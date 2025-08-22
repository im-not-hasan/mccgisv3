<?php

namespace App\Http\Controllers;

use App\Models\Login; // Import the Login model
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;

class CustomLoginController extends Controller
{
    public function login(Request $request)
    {
        // Log the input and stored password for debugging
        \Log::info('Login attempt - Username: ' . $request->Username);
        \Log::info('Input password: ' . $request->Password);
        

        $request->validate([
            'Username' => 'required|string',
            'Password' => 'required|string',
        ]);

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
