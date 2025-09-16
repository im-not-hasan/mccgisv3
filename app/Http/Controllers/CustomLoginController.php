<?php

namespace App\Http\Controllers;

use App\Models\Login;
use App\Services\ReCaptcha;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;

class CustomLoginController extends Controller
{
    public function login(Request $request)
    {
        // Basic validation
        $request->validate([
            'Username'        => 'required|string',
            'Password'        => 'required|string',
            'recaptcha_token' => 'required|string',
        ]);

        // 1) reCAPTCHA v3 verification
        $check = ReCaptcha::verify($request->recaptcha_token, $request->ip());
        if (!$check['ok']) {
            \Log::warning('reCAPTCHA failed', ['score' => $check['score'], 'raw' => $check['raw'] ?? null]);
            return response()->json([
                'error'   => 'recaptcha_failed',
                'message' => 'reCAPTCHA verification failed.',
            ], 422);
        }

        // 2) Lockout check
        $lockout = Session::get('lockout_time');
        if ($lockout && now()->lt($lockout)) {
            return response()->json(['error' => 'locked'], 429);
        }

        // 3) Find user
        $user = Login::where('username', $request->Username)->first();
        if (!$user) {
            return response()->json(['error' => 'not_found'], 404);
        }

        // 4) Handle legacy/plain password -> upgrade to hash
        $info     = password_get_info($user->password);
        $isHashed = $info['algoName'] !== 'unknown';

        if ($isHashed) {
            if (!Hash::check($request->Password, $user->password)) {
                $attempts = Session::get('login_attempts', 3) - 1;
                Session::put('login_attempts', $attempts);
                if ($attempts <= 0) {
                    Session::put('lockout_time', now()->addSeconds(60));
                    return response()->json(['error' => 'locked'], 429);
                }
                return response()->json(['error' => 'wrong_password', 'attempts' => $attempts], 401);
            }
        } else {
            if ($request->Password !== $user->password) {
                $attempts = Session::get('login_attempts', 3) - 1;
                Session::put('login_attempts', $attempts);
                if ($attempts <= 0) {
                    Session::put('lockout_time', now()->addSeconds(60));
                    return response()->json(['error' => 'locked'], 429);
                }
                return response()->json(['error' => 'wrong_password', 'attempts' => $attempts], 401);
            }
            // upgrade to hashed
            $user->password = Hash::make($request->Password);
            $user->save();
        }

        // 5) Success: reset attempts
        Session::put('login_attempts', 3);

        // 6) Authenticate with Laravel guard so @auth works
        Auth::login($user); // now Auth::check() is true, @auth works, route model policies, etc.
        $request->session()->regenerate();
        // 7) (Optional) keep your session keys if other code depends on them
        Session::put('fullname', $user->fullname);
        Session::put('level', $user->level);
        Session::put('user_id', $user->id ?? null);
        Session::put('username', $user->username);

        return response()->json([
            'redirect' => route('dashboard'),
            'fullname' => $user->fullname,
            'username' => $user->username,
            'level'    => $user->level,
        ]);
    }
}
