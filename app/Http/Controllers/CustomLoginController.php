<?php

namespace App\Http\Controllers;

use App\Models\Login; // Import the Login model
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Http;

class CustomLoginController extends Controller
{
    public function login(Request $request)
    {
        // Log the input and stored password for debugging
        \Log::info('Login attempt - Username: ' . $request->Username);
        \Log::info('Input password: ' . $request->Password);
        \Log::info('Recaptcha Token: ' . $request->recaptcha_token);

        $request->validate([
            'Username'        => 'required|string',
            'Password'        => 'required|string',
            'recaptcha_token' => 'required|string',
        ]);
        \Log::info('🔑 Site Key (from .env): ' . env('RECAPTCHA_SITE_KEY'));
         \Log::info('🔑 Secret Key (from .env): ' . env('RECAPTCHA_SECRET_KEY'));

        // 🔑 Verify reCAPTCHA
        $response = Http::asForm()->post('https://www.google.com/recaptcha/api/siteverify', [
            'secret'   => env('RECAPTCHA_SECRET_KEY'),
            'response' => $request->recaptcha_token,
            'remoteip' => $request->ip(),
        ]);

        $result = $response->json();

        \Log::info('🟢 reCAPTCHA verification result:', $result);
        
        if (empty($result['success']) || $result['score'] < 0.5) {
            return response()->json([
                'error'   => 'recaptcha_failed',
                'message' => 'reCAPTCHA verification failed',
                'debug'   => $result, // <-- remove this in production
            ], 422);
        }

        // Use Eloquent to find the user by Username
        $user = Login::where('Username', $request->Username)->first(); // Fetch the user using the Login model
        $info = password_get_info($user->password);
        $isHashed = $info['algoName'] !== 'unknown';

        // Check if user exists
        if (!$user) {
            return response()->json(['error' => 'not_found'], 404); // User not found
        }
        if ($isHashed) {
        // Check password (assuming it's hashed in the database)
            if (!Hash::check($request->Password, $user->password)) {
                $attempts = Session::get('login_attempts', 3); // Get current login attempts
                $attempts--;
                Session::put('login_attempts', $attempts); // Store updated attempts

                if ($attempts <= 0) {
                    Session::put('lockout_time', now()->addSeconds(60)); // Lockout after 3 failed attempts
                    return response()->json(['error' => 'locked'], 429); // Return lockout status
                }

                return response()->json([
                    'error' => 'wrong_password',
                    'attempts' => $attempts, // Return remaining attempts
                ], 401);
            }
         }
        else{
            if ($request->Password !== $user->password) {
                $attempts = Session::get('login_attempts', 3); // Get current login attempts
                $attempts--;
                Session::put('login_attempts', $attempts); // Store updated attempts

                if ($attempts <= 0) {
                    Session::put('lockout_time', now()->addSeconds(60)); // Lockout after 3 failed attempts
                    return response()->json(['error' => 'locked'], 429); // Return lockout status
                }

                return response()->json([
                    'error' => 'wrong_password',
                    'attempts' => $attempts, // Return remaining attempts
                ], 401);
            }
            $user->password = Hash::make($request->Password);
            $user->save();
        }
        // Reset attempts and create session on successful login
        Session::put('login_attempts', 3); // Reset the attempts to 3
        Session::put('fullname', $user->fullname); // Store full name
        Session::put('level', $user->level); // Store user level
        Session::put('user_id', $user->id ?? null); // Optionally store the user ID
        Session::put('username', $user->username);

        // Debugging: Log session data
        \Log::info('User logged in:', [
            'level' => $user->level,
            'username' => $user->username,
            'fullname' => $user->fullname,
        ]);

        // Return redirect URL based on user level
        return response()->json([
        'redirect' => route('dashboard'), // route('dashboard') works too
        'fullname' => $user->fullname,
        'username' => $user->username,
        'level' => $user->level,
    ]);

    }
}
