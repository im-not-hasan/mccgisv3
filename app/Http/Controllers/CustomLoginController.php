<?php

namespace App\Http\Controllers;

use App\Models\Login;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Cache;

class CustomLoginController extends Controller
{
    // ------------------------------------------------------------------------
    // 🔹 LOGIN
    // ------------------------------------------------------------------------
    public function login(Request $request)
    {
        $request->validate([
            'Username'        => 'required|string',
            'Password'        => 'required|string',
            'recaptcha_token' => 'required|string',
        ]);

        // 🔹 Verify reCAPTCHA
        $response = Http::asForm()->post('https://www.google.com/recaptcha/api/siteverify', [
            'secret'   => env('RECAPTCHA_SECRET_KEY'),
            'response' => $request->recaptcha_token,
            'remoteip' => $request->ip(),
        ]);
        $result = $response->json();
        if (empty($result['success']) || ($result['score'] ?? 0) < 0.5) {
            return response()->json(['error' => 'recaptcha_failed'], 422);
        }

        // 🔹 Find user
        $user = Login::where('Username', $request->Username)->first();
        if (!$user) {
            return response()->json(['error' => 'not_found'], 404);
        }

        // 🔹 Check for existing lockout
        $lockoutTime = Session::get('lockout_time');
        if ($lockoutTime && now()->lessThan($lockoutTime)) {
            return response()->json([
                'error' => 'locked',
                'lockout_expires_at' => $lockoutTime->toISOString(),
            ], 429);
        }

        // 🔹 Check password
        $info = password_get_info($user->password);
        $isHashed = $info['algoName'] !== 'unknown';
        if ($isHashed) {
            if (!Hash::check($request->Password, $user->password)) {
                $attempts = Session::get('login_attempts', 3) - 1;
                Session::put('login_attempts', $attempts);
                if ($attempts <= 0) {
                    $lockoutUntil = now()->addSeconds(60);
                    Session::put('lockout_time', $lockoutUntil);
                    return response()->json([
                        'error' => 'locked',
                        'lockout_expires_at' => $lockoutUntil->toISOString(),
                    ], 429);
                }
                return response()->json(['error' => 'wrong_password', 'attempts' => $attempts], 401);
            }
        } else {
            if ($request->Password !== $user->password) {
                $attempts = Session::get('login_attempts', 3) - 1;
                Session::put('login_attempts', $attempts);
                if ($attempts <= 0) {
                    $lockoutUntil = now()->addSeconds(60);
                    Session::put('lockout_time', $lockoutUntil);
                    return response()->json([
                        'error' => 'locked',
                        'lockout_expires_at' => $lockoutUntil->toISOString(),
                    ], 429);
                }
                return response()->json(['error' => 'wrong_password', 'attempts' => $attempts], 401);
            }
            // Upgrade legacy plain password to hash
            $user->password = Hash::make($request->Password);
            $user->save();
        }

        // 🔹 Reset attempts if user passed
        Session::forget('lockout_time');
        Session::put('login_attempts', 3);

        // 🔹 Create session
        Session::put('fullname', $user->fullname);
        Session::put('level', $user->level);
        Session::put('user_id', $user->id ?? null);
        Session::put('username', $user->username);

        // 🔹 Fetch email (based on user level)
        $email = null;
        $level = strtolower($user->level);
        if ($level === 'student') {
            $email = DB::table('student')->where('studid', $user->username)->value('email');
        } elseif (in_array($level, ['teacher', 'registrar', 'admin'])) {
            $email = DB::table('teacher')->where('teachid', $user->username)->value('email');
        }

        if (!$email) {
            return response()->json(['error' => 'no_email'], 404);
        }

        // 🔹 Generate OTP
        $otp = rand(100000, 999999);
        Cache::put('otp_' . $user->username, $otp, now()->addMinutes(5));

        try {
            Mail::raw("Your MCCGIS login verification code is: $otp", function ($message) use ($email) {
                $message->to($email)->subject('MCCGIS Login Verification Code');
            });
        } catch (\Exception $e) {
            return response()->json(['error' => 'mail_failed', 'message' => 'Failed to send OTP email.']);
        }

        return response()->json([
            'require_otp' => true,
            'message' => 'OTP sent to registered email.',
            'level' => $level,
            'username' => $user->username,
        ]);
    }



    // ------------------------------------------------------------------------
    // 🔹 Step 1: Check user level and fetch email (Forgot Password)
    // ------------------------------------------------------------------------
    public function checkUserEmail(Request $req)
    {
        $username = $req->username;
        $login = DB::table('login')->where('username', $username)->first();
        if (!$login) return response()->json(['email' => null]);

        $level = strtolower($login->level);
        $email = null;

        if ($level === 'student') {
            $email = DB::table('student')->where('studid', $username)->value('email');
        } elseif (in_array($level, ['teacher', 'registrar'])) {
            $email = DB::table('teacher')->where('teachid', $username)->value('email');
        }

        if (!$email) return response()->json(['email' => null]);

        // Masked email for frontend
        $parts = explode('@', $email);
        $masked = substr($parts[0], 0, 1)
            . str_repeat('*', max(1, strlen($parts[0]) - 2))
            . substr($parts[0], -1) . '@' . $parts[1];

        return response()->json([
            'email' => $email,
            'partial' => $masked,
            'level' => $level,
        ]);
    }

    // ------------------------------------------------------------------------
    // 🔹 Step 2: Send OTP for Forgot Password
    // ------------------------------------------------------------------------
    public function forgotPassword(Request $req)
    {
        $req->validate([
            'email' => 'required|email',
            'username' => 'required|string',
            'level' => 'required|string',
        ]);

        // 🔹 Fetch the real email
        $realEmail = null;
        $level = strtolower($req->level);

        if ($level === 'student') {
            $realEmail = DB::table('student')->where('studid', $req->username)->value('email');
        } elseif (in_array($level, ['teacher', 'registrar'])) {
            $realEmail = DB::table('teacher')->where('teachid', $req->username)->value('email');
        }

        if (!$realEmail) {
            return response()->json(['success' => false, 'message' => 'No email found for this account.']);
        }
        if (strtolower(trim($realEmail)) !== strtolower(trim($req->email))) {
            return response()->json(['success' => false, 'message' => 'The entered email does not match our records.']);
        }

        // 🔹 Generate and cache OTP
        $otp = rand(100000, 999999);
        Cache::put('otp_' . $req->username, $otp, now()->addMinutes(5));

        try {
            Mail::raw("Your MCCGIS verification code is: $otp", function ($message) use ($req) {
                $message->to($req->email)->subject('MCCGIS Password Reset Code');
            });
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'Email sending failed.']);
        }

        return response()->json(['success' => true, 'message' => 'OTP sent successfully.']);
    }

    // ------------------------------------------------------------------------
    // 🔹 Step 3: Verify OTP (Forgot Password → Reset)
    // ------------------------------------------------------------------------
    public function verifyOtp(Request $req)
    {
        $req->validate([
            'otp' => 'required|string',
            'username' => 'required|string',
            'context' => 'nullable|string', // 'login' or 'forgot'
        ]);

        $cachedOtp = Cache::get('otp_' . $req->username);

        if ($cachedOtp && $cachedOtp == $req->otp) {
            Cache::forget('otp_' . $req->username);

            // 🧭 Determine which flow we are in
            $context = $req->context ?? 'login';

            if ($context === 'forgot') {
                // 🔹 Forgot password flow → send reset token
                $token = Str::random(40);
                Cache::put('reset_token_' . $req->username, $token, now()->addMinutes(5));

                return response()->json([
                    'success' => true,
                    'context' => 'forgot',
                    'reset_token' => $token,
                    'message' => 'OTP verified. You may now reset your password.'
                ]);
            }

            // 🔹 Default: login flow → redirect dashboard
            return response()->json([
                'success' => true,
                'context' => 'login',
                'redirect' => route('dashboard'),
                'message' => 'OTP verified. Logging in...'
            ]);
        }

        return response()->json(['success' => false, 'message' => 'Invalid or expired OTP.']);
    }


    // ------------------------------------------------------------------------
    // 🔹 Step 4: Reset Password
    // ------------------------------------------------------------------------
    public function resetPassword(Request $req)
    {
        $req->validate([
            'username' => 'required|string',
            'token' => 'required|string',
            'new_password' => [
                'required',
                'string',
                'min:8',
                'regex:/[A-Z]/',     // must contain uppercase
                'regex:/[a-z]/',     // must contain lowercase
                'regex:/[0-9]/',     // must contain number
                'regex:/[@$!%*#?&]/', // must contain special character(s)
                'confirmed',
            ],
        ], [
            'new_password.regex' => 'Password must include uppercase, lowercase, number, and special character.',
        ]);

        $cachedToken = Cache::get('reset_token_' . $req->username);
        if (!$cachedToken || $cachedToken !== $req->token) {
            return response()->json(['success' => false, 'message' => 'Invalid or expired reset token.']);
        }

        $user = Login::where('username', $req->username)->first();
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found.']);
        }

        $user->password = Hash::make($req->new_password);
        $user->save();

        Cache::forget('reset_token_' . $req->username);

        return response()->json(['success' => true, 'message' => 'Password successfully reset.']);
    }
}
