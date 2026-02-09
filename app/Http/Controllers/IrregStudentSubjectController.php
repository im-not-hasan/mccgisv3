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
                'subjects.*.year' => 'required',
                'subjects.*.section' => 'required|string',
            ]);

            // Get student.id
            $studentId = DB::table('student')
                ->where('studid', $validated['studid'])
                ->value('id');

            if (!$studentId) {
                return response()->json(['error' => 'Student ID not found'], 422);
            }

            // Get current AY
            $currentAyId = DB::table('ay')
                ->where('display', 1)
                ->value('id');

            if (!$currentAyId) {
                return response()->json(['error' => 'No active academic year'], 422);
            }

            foreach ($validated['subjects'] as $subject) {
                DB::table('irregstudentsubject')->insert([
                    'student_id' => $studentId,
                    'subject_id' => $subject['id'],
                    'year'       => $subject['year'],
                    'section'    => $subject['section'],
                    'ay_id'      => $currentAyId,
                ]);
            }

            Log::info('Irregular student subjects added successfully', [
                'student_id' => $studentId,
                'ay_id' => $currentAyId
            ]);

            return response()->json(['message' => 'Irregular student subjects saved successfully.']);

        } catch (\Exception $e) {
            Log::error('Error saving irregular student subjects', [
                'error' => $e->getMessage(),
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
                'subjects.*.year' => 'required',
                'subjects.*.section' => 'required|string',
            ]);

            $studentId = DB::table('student')
                ->where('studid', $studid)
                ->value('id');

            if (!$studentId) {
                return response()->json(['error' => 'Student ID not found'], 422);
            }

            $currentAyId = DB::table('ay')
                ->where('display', 1)
                ->value('id');

            if (!$currentAyId) {
                return response()->json(['error' => 'No active academic year'], 422);
            }

            // Delete only CURRENT AY records
            DB::table('irregstudentsubject')
                ->where('student_id', $studentId)
                ->where('ay_id', $currentAyId)
                ->delete();

            foreach ($validated['subjects'] as $subject) {
                DB::table('irregstudentsubject')->insert([
                    'student_id' => $studentId,
                    'subject_id' => $subject['id'],
                    'year'       => $subject['year'],
                    'section'    => $subject['section'],
                    'ay_id'      => $currentAyId,
                ]);
            }

            Log::info('Irregular student subjects updated successfully', [
                'student_id' => $studentId,
                'ay_id' => $currentAyId
            ]);

            return response()->json(['message' => 'Irregular student subjects updated successfully.']);

        } catch (\Exception $e) {
            Log::error('Error updating irregular student subjects', [
                'error' => $e->getMessage(),
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

            $currentAyId = DB::table('ay')
                ->where('display', 1)
                ->value('id');

            $subjects = DB::table('irregstudentsubject')
                ->join('subject', 'irregstudentsubject.subject_id', '=', 'subject.id')
                ->where('irregstudentsubject.student_id', $studentId)
                ->where('irregstudentsubject.ay_id', $currentAyId)
                ->select(
                    'subject.id',
                    'subject.title',
                    'irregstudentsubject.year',
                    'irregstudentsubject.section'
                )
                ->get();

            return response()->json($subjects);

        } catch (\Exception $e) {
            Log::error('Error fetching student subjects', [
                'error' => $e->getMessage()
            ]);

            return response()->json(['error' => 'Failed to fetch subjects'], 500);
        }
    }

    public function destroy($studid)
    {
        $ay_id = DB::table('ay')
            ->where('display', 1)
            ->value('id');

        try {
            $studentId = DB::table('student')
                ->where('studid', $studid)
                ->value('id');

            if (!$studentId) {
                return response()->json(['error' => 'Student not found'], 404);
            }

            DB::table('irregstudentsubject')
                ->where('student_id', $studentId)
                ->where('ay_id', $ay_id)
                ->delete();

            return response()->json([
                'message' => 'Irregular subject assignments removed'
            ]);
        } catch (\Exception $e) {
            Log::error('Error deleting irregular subjects', [
                'error' => $e->getMessage()
            ]);

            return response()->json(['error' => 'Failed to remove irregular subjects'], 500);
        }
    }


}