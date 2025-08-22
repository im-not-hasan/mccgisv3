<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class IrregStudentSubjectController extends Controller
{
    public function store(Request $request)
    {
        Log::info('Received irreg student subject POST request', [
            'payload' => $request->all()
        ]);

        try {
            $validated = $request->validate([
                'studid' => 'required|string|exists:student,studid',
                'subjects' => 'required|array',
                'subjects.*.id' => 'required|integer|exists:subject,id',
            ]);

            Log::info('Validation successful', [
                'validated' => $validated
            ]);

            // Get student.id from student.studid
            $studentId = DB::table('student')
                ->where('studid', $validated['studid'])
                ->value('id');

            if (!$studentId) {
                Log::error('Student ID not found for given studid', [
                    'studid' => $validated['studid']
                ]);
                return response()->json(['error' => 'Student ID not found'], 422);
            }

            foreach ($validated['subjects'] as $subject) {
                DB::table('irregstudentsubject')->insert([
                    'student_id' => $studentId, // Save as student.id (int)
                    'subject_id' => $subject['id'],
                ]);
            }

            Log::info("Irregular student subjects added successfully", [
                'student_id' => $studentId
            ]);

            return response()->json(['message' => 'Irregular student subjects saved successfully.']);
        } catch (\Exception $e) {
            Log::error('Error saving irregular student subjects', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json(['error' => 'Failed to save irregular student subjects'], 500);
        }
    }
    public function update(Request $request, $studid)
    {
        Log::info('Received irreg student subject UPDATE request', [
            'studid' => $studid,
            'payload' => $request->all()
        ]);

        try {
            $validated = $request->validate([
                'subjects' => 'required|array',
                'subjects.*.id' => 'required|integer|exists:subject,id',
            ]);

            // Get student.id from student.studid
            $studentId = DB::table('student')
                ->where('studid', $studid)
                ->value('id');

            if (!$studentId) {
                Log::error('Student ID not found for given studid', [
                    'studid' => $studid
                ]);
                return response()->json(['error' => 'Student ID not found'], 422);
            }

            // Delete existing subjects for the student
            DB::table('irregstudentsubject')
                ->where('student_id', $studentId)
                ->delete();

            // Insert the new subjects
            foreach ($validated['subjects'] as $subject) {
                DB::table('irregstudentsubject')->insert([
                    'student_id' => $studentId,
                    'subject_id' => $subject['id'],
                ]);
            }

            Log::info("Irregular student subjects updated successfully", [
                'student_id' => $studentId
            ]);

            return response()->json(['message' => 'Irregular student subjects updated successfully.']);
        } catch (\Exception $e) {
            Log::error('Error updating irregular student subjects', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json(['error' => 'Failed to update irregular student subjects'], 500);
        }
    }
    public function getStudentSubjects($studid)
    {
        try {
            $studentId = DB::table('student')
                ->where('studid', $studid)
                ->value('id');

            if (!$studentId) {
                return response()->json(['error' => 'Student not found'], 404);
            }

            $subjects = DB::table('irregstudentsubject')
                ->join('subject', 'irregstudentsubject.subject_id', '=', 'subject.id')
                ->where('irregstudentsubject.student_id', $studentId)
                ->select('subject.id', 'subject.title')
                ->get();

            return response()->json($subjects);
        } catch (\Exception $e) {
            Log::error('Error fetching student subjects', [
                'error' => $e->getMessage()
            ]);
            return response()->json(['error' => 'Failed to fetch subjects'], 500);
        }
    }

}