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
        $ay = DB::table('ay')->select('id', 'academicyear', 'semester', 'display')->where('archived', 0)->get();
        \Log::info('Fetched academic years:', ['data' => $ay]);
        return response()->json($ay);
    }

    public function getArchivedAY()
    {
        $ay = DB::table('ay')
            ->select('id', 'academicyear', 'semester', 'display')
            ->where('archived', 1)
            ->get();

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
        DB::table('ay')
            ->where('id', $id)
            ->update(['archived' => 1, 'display' => 0]);

        return response()->json(['success' => true, 'archived' => true]);
    }

    public function restoreAcademicYear($id)
    {
        DB::table('ay')
            ->where('id', $id)
            ->update(['archived' => 0]);

        return response()->json(['success' => true]);
    }

    public function forceDeleteAcademicYear($id)
    {
        DB::table('ay')
            ->where('id', $id)
            ->delete();

        return response()->json(['success' => true, 'deleted' => true]);
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

    public function getCurriculums()
    {
        $rows = DB::table('curriculums')
            ->select('id', 'curriculum', 'display')
            ->where('archived', 0)
            ->orderBy('curriculum', 'asc')
            ->get();

        \Log::info('[Settings] Fetched curriculums', ['count' => $rows->count()]);
        return response()->json($rows);
    }

    public function storeCurriculum(Request $request)
    {
        $request->validate([
            'curriculum' => 'required|integer|unique:curriculums,curriculum',
            'display'    => 'nullable|boolean',
        ]);

        $display = (int) ($request->display ?? 0);

        DB::table('curriculums')->insert([
            'curriculum' => $request->curriculum,
            'display'    => $display,
        ]);

        // Optional: ensure ONLY ONE active curriculum at a time
        if ($display === 1) {
            DB::table('curriculums')
                ->where('curriculum', '!=', $request->curriculum)
                ->update(['display' => 0]);
        }

        // \Log::info('[Settings] Curriculum created', ['curriculum' => $request->curriculum, 'display' => $display]);
        return response()->json(['success' => true]);
    }

    public function toggleCurriculumDisplay(Request $request)
    {
        $request->validate([
            'id'      => 'required|integer|exists:curriculums,id',
            'display' => 'required|boolean',
        ]);

        $id      = (int) $request->id;
        $display = (int) $request->display;

        // Update the requested row
        DB::table('curriculums')->where('id', $id)->update(['display' => $display]);

        // Enforce single-active rule
        if ($display === 1) {
            DB::table('curriculums')->where('id', '!=', $id)->update(['display' => 0]);
        }

        $rows = DB::table('curriculums')
            ->select('id', 'curriculum', 'display')
            ->orderBy('curriculum', 'asc')
            ->get();

        // \Log::info('[Settings] Curriculum display toggled', ['id' => $id, 'display' => $display, 'count' => $rows->count()]);

        return response()->json([
            'message'     => 'Curriculum display updated',
            'curriculums' => $rows,
        ], 200);
    }


    public function deleteCurriculum($id)
    {
        DB::table('curriculums')
            ->where('id', $id)
            ->update([
                'archived' => 1,
                'display'  => 0, 
            ]);

        // \Log::info('[Settings] Curriculum moved to trash', ['id' => (int) $id]);
        return response()->json(['success' => true, 'archived' => true]);
    }

    public function getArchivedCurriculums()
    {
        $rows = DB::table('curriculums')
            ->select('id', 'curriculum', 'display')
            ->where('archived', 1)
            ->orderBy('curriculum', 'asc')
            ->get();

        return response()->json($rows);
    }

    public function restoreCurriculum($id)
    {
        DB::table('curriculums')
            ->where('id', $id)
            ->update(['archived' => 0]);

        return response()->json(['success' => true]);
    }

    public function forceDeleteCurriculum($id)
    {
        DB::table('curriculums')
            ->where('id', $id)
            ->delete();

        return response()->json(['success' => true, 'deleted' => true]);
    }


}
