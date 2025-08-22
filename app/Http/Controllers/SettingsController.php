<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;


class SettingsController extends Controller
{
    public function getAY()
    {
        $ay = DB::table('ay')->select('id', 'academicyear', 'semester', 'display')->get();
        \Log::info('Fetched academic years:', ['data' => $ay]);
        return response()->json($ay);
    }

    public function toggleDisplay(Request $request)
    {
        $request->validate([
            'id' => 'required|integer',
            'display' => 'required|boolean',
        ]);

        DB::table('ay')->where('id', $request->id)->update(['display' => $request->display]);

        return response()->json(['message' => 'Academic Year Display Updated']);
    }

    public function deleteAcademicYear($id)
    {
        DB::table('ay')->where('id', $id)->delete();
        return response()->json(['success' => true]);
    }

    public function storeAcademicYear(Request $request)
    {
        $request->validate([
            'academicyear' => 'required|string',
            'semester' => 'required|integer|in:1,2,3',
        ]);

        DB::table('ay')->insert([
            'academicyear' => $request->academicyear,
            'semester' => $request->semester,
            'display' => 0,
        ]);

        return response()->json(['success' => true]);
    }


    
    public function updatePassword(Request $request)
    {
        $request->validate([
            'oldPassword' => 'required|string|min:6',
            'newPassword' => 'required|string|min:6',
        ]);

        $username = session('username');

        // Fetch user from login table
        $user = DB::table('login')->where('username', $username)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found.'], 404);
        }

        // Check old password (assuming bcrypt hashed)
        if (!password_verify($request->oldPassword, $user->password)) {
            return response()->json(['message' => 'Old Password is incorrect.'], 403);
        }

        // Hash new password
        $newPasswordHash = password_hash($request->newPassword, PASSWORD_DEFAULT);

        DB::table('login')
            ->where('username', $username)
            ->update(['password' => $newPasswordHash]);

        return response()->json(['message' => 'Password Updated Successfully.']);
    }


}
