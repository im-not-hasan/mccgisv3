<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;

class InstructorsController extends Controller
{
    public function getInstructorStats()
    {
        // Count by department (BSIT, BSBA, BSHM, EDUC)
        $byDepartment = DB::table('teacher')
            ->select('department', DB::raw('COUNT(*) as count'))
            ->where('archived',0)
            ->groupBy('department')
            ->pluck('count', 'department');

        // Count by gender
        $genderCounts = DB::table('teacher')
            ->select('sex', DB::raw('COUNT(*) as count'))
            ->where('archived',0)
            ->groupBy('sex')
            ->pluck('count', 'sex');

        // Clean up gender keys to lowercase for Vue consistency
        $byGender = [
            'male' => $genderCounts['Male'] ?? 0,
            'female' => $genderCounts['Female'] ?? 0,
        ];

        // Total instructors
        $total = array_sum($byGender);

        return response()->json([
            'byDepartment' => $byDepartment,
            'byGender' => $byGender,
            'totals' => [
                'total' => $total,
                'male' => $byGender['male'],
                'female' => $byGender['female'],
            ],
        ]);
    }
    public function getInstructorsByDepartment($department)
    {
        $instructors = DB::table('teacher')
            ->where('department', $department)
            ->where('archived',0)
            ->get();

        return response()->json($instructors);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'teachid'    => 'required|string|max:12',
            'fname'      => 'required|string|max:100',
            'mname'      => 'nullable|string|max:50',
            'lname'      => 'required|string|max:100',
            'sex'        => 'required|string|max:50',
            'age'        => 'required|integer|min:18|max:100',
            'email'      => 'required|email|max:50',
            'phone'      => 'required|string|max:11',
            'department' => 'required|string|max:30',
        ]);

        DB::beginTransaction();

        try {
            // Insert instructor record
            DB::table('teacher')->insert($validated);

            // Insert login record for this instructor with hashed password (default password = teachid)
            DB::table('login')->insert([
                'username' => $validated['teachid'],
                'password' => Hash::make($validated['teachid']),
                'fullname' => $validated['fname'] . ' '  . $validated['lname'],
                'level'    => 'teacher',
            ]);

            DB::commit();

            Log::info("Instructor and login added successfully", ['teachid' => $validated['teachid']]);
            return response()->json(['message' => 'Instructor added successfully'], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Error adding instructor and login", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to add instructor'], 500);
        }
    }


        public function update(Request $request, $id)
        {
            $validated = $request->validate([
                'teachid'    => 'required|string|max:12',
                'fname'      => 'required|string|max:100',
                'mname'      => 'nullable|string|max:50',
                'lname'      => 'required|string|max:100',
                'sex'        => 'required|string|max:50',
                'age'        => 'required|integer|min:18|max:100',
                'email'      => 'required|email|max:50',
                'phone'      => 'required|digits_between:7,11',
                'department' => 'required|string|max:30',
            ]);

            try {
                DB::table('teacher')->where('id', $id)->update($validated);

                \Log::info("Instructor updated", ['id' => $id]);
                return response()->json(['message' => 'Instructor updated successfully']);
            } catch (\Exception $e) {
                \Log::error("Failed to update instructor", ['error' => $e->getMessage()]);
                return response()->json(['message' => 'Failed to update instructor'], 500);
            }
        }

        public function destroy($id) // Not Being Used iirc
        {
            \Log::info("Deleting instructor", ['id' => $id]);

            try {
                DB::table('teacher')->where('id', $id)->delete();
                return response()->json(['message' => 'Instructor deleted successfully']);
            } catch (\Exception $e) {
                \Log::error("Failed to delete instructor", ['error' => $e->getMessage()]);
                return response()->json(['message' => 'Failed to delete instructor'], 500);
            }
        }
        
        // Assignment of Subjects-Related Proccesses below

        public function assignSubject(Request $request, $id)
        {
            $validated = $request->validate([
                'subject_id' => 'required|integer|exists:subject,id',
                'course'     => 'required|string|max:10',
                'year'       => 'required|integer',
                'section'    => 'required|string|max:10',
            ]);

            try {
                // Get the active academic year
                $activeAY = DB::table('ay')->where('display', 1)->first();

                if (!$activeAY) {
                    return response()->json(['message' => 'No active academic year found.'], 422);
                }

                $ay_id = $activeAY->id;

                // Check if this subject is already assigned for this class in the active AY
                $existing = DB::table('assignments')
                    ->where('subject_id', $validated['subject_id'])
                    ->where('course', $validated['course'])
                    ->where('year', $validated['year'])
                    ->where('section', $validated['section'])
                    ->where('ay_id', $ay_id)
                    ->first();

                if ($existing) {
                    \Log::warning("Duplicate assignment attempted", [
                        'teacher_id' => $id,
                        'subject_id' => $validated['subject_id'],
                        'course'     => $validated['course'],
                        'year'       => $validated['year'],
                        'section'    => $validated['section'],
                        'ay_id'      => $ay_id,
                    ]);
                    return response()->json(['message' => 'This subject is already assigned to this class for the current Academic Year.'], 422);
                }

                // Insert new assignment with ay_id
                DB::table('assignments')->insert([
                    'teacher_id' => $id,
                    'subject_id' => $validated['subject_id'],
                    'course'     => $validated['course'],
                    'year'       => $validated['year'],
                    'section'    => $validated['section'],
                    'ay_id'      => $ay_id,
                ]);

                \Log::info("Subject assigned to instructor", [
                    'teacher_id' => $id,
                    'subject_id' => $validated['subject_id'],
                    'ay_id'      => $ay_id
                ]);

                return response()->json(['message' => 'Subject assigned successfully'], 201);

            } catch (\Exception $e) {
                \Log::error("Failed to assign subject", ['error' => $e->getMessage()]);
                return response()->json(['message' => 'Failed to assign subject'], 500);
            }
        }



        public function getAssignments($teacher_id)
        {
            $ay = DB::table('ay')
            ->where('display',1)
            ->first();
            $assignments = DB::table('assignments')
                ->join('subject', 'assignments.subject_id', '=', 'subject.id')
                ->select(
                    'assignments.id',
                    'subject.code as subject_code',
                    'subject.title as subject_name',
                    'assignments.course',
                    'assignments.year',
                    'assignments.section'
                )
                ->where('assignments.teacher_id', $teacher_id)
                ->where('assignments.ay_id', $ay->id)
                ->get();

            return response()->json($assignments);
        }
        
        public function storeAssignment(Request $request)
        {
            $validated = $request->validate([
                'teacher_id' => 'required|integer|exists:teacher,id',
                'subject_id' => 'required|integer|exists:subject,id',
                'course'     => 'required|string|max:10',
                'year'       => 'required|integer|min:1|max:4',
                'section'    => 'required|string|max:10',
            ]);

            DB::table('assignments')->insert($validated);

            return response()->json(['message' => 'Assignment created successfully']);
        }
        
        public function deleteAssignment($instructorId, $assignmentId)
        {
            DB::table('assignments')->where('id', $assignmentId)->delete();

            return response()->json(['message' => 'Assignment deleted successfully']);
        }
                

        // View Subjects and Classes Handled

       public function teacherClasses(Request $request)
        {
            $ay = DB::table('ay')
            ->where('display',1)
            ->first();
            $username = session('username');
            Log::info('Fetching teacherClasses for username:', [$username]);

            $teacherId = DB::table('teacher')
                ->where('teachid', $username)
                ->value('id');

            Log::info('Resolved teacherId:', [$teacherId]);

            if (!$teacherId) {
                Log::warning('No teacher found for teachid:', [$username]);
                return response()->json(['classes' => []]);
            }

            // Get all class groupings
            $classes = DB::table('assignments')
                ->select('course', 'year', 'section')
                ->where('teacher_id', $teacherId)
                ->where('ay_id', $ay->id)
                ->groupBy('course', 'year', 'section')
                ->get();

            Log::info('Fetched classes count:', [count($classes)]);

            // For each class, fetch subjects assigned to teacher for that class (both code and title)
            foreach ($classes as $cls) {
                $subjects = DB::table('assignments')
                    ->join('subject', 'assignments.subject_id', '=', 'subject.id')
                    ->where('assignments.teacher_id', $teacherId)
                    ->where('assignments.course', $cls->course)
                    ->where('assignments.year', $cls->year)
                    ->where('assignments.section', $cls->section)
                    ->where('ay_id', $ay->id)
                    ->select('subject.code', 'subject.title')
                    ->get();

                Log::debug("Subjects (code & title) for class {$cls->course} {$cls->year}-{$cls->section}:", [$subjects]);

                $cls->subjects = $subjects;
            }

            return response()->json(['classes' => $classes]);
        }
        
        public function checkTeachid($teachid)
        {
            $exists = DB::table('teacher')->where('teachid', $teachid)->exists();
            return response()->json(['exists' => $exists]);
        }


        // List archived instructors (for Trash.vue)
        public function getArchivedInstructors()
        {
            \Log::info('[Instructors] getArchivedInstructors() CALLED');

            $instructors = DB::table('teacher')
                ->where('archived', 1)
                ->get();

            \Log::info('[Instructors] Archived instructors fetched', [
                'count'  => $instructors->count(),
                'sample' => $instructors->take(3),
            ]);

            return response()->json($instructors);
        }

        // Move instructor to trash (soft delete)
        public function deleteInstructor($id)
        {
            $teacher = DB::table('teacher')->where('id', $id)->first();

            if (!$teacher) {
                return response()->json(['success' => false, 'message' => 'Instructor not found'], 404);
            }

            // archive teacher
            DB::table('teacher')
                ->where('id', $id)
                ->update([
                    'archived' => 1,
                ]);

            // disable login if exists
            DB::table('login')
                ->where('username', $teacher->teachid)
                ->update(['disabled' => 1]);

            \Log::info('[Instructors] Moved to trash', ['teachid' => $teacher->teachid]);

            return response()->json(['success' => true, 'archived' => true]);
        }

        // Restore from trash
        public function restoreInstructor($id)
        {
            $teacher = DB::table('teacher')->where('id', $id)->first();

            if (!$teacher) {
                return response()->json(['success' => false, 'message' => 'Instructor not found'], 404);
            }

            DB::table('teacher')
                ->where('id', $id)
                ->update([
                    'archived' => 0,
                ]);

            DB::table('login')
                ->where('username', $teacher->teachid)
                ->update(['disabled' => 0]);

            \Log::info('[Instructors] Restored from trash', ['teachid' => $teacher->teachid]);

            return response()->json(['success' => true]);
        }

        // Force delete (permanent)
        public function forceDeleteInstructor($id)
        {
            $teacher = DB::table('teacher')->where('id', $id)->first();

            if (!$teacher) {
                return response()->json(['success' => false, 'message' => 'Instructor not found'], 404);
            }

            \Log::info('[Instructors] Permanently deleting instructor', ['teachid' => $teacher->teachid]);

            // delete related stuff here if you have any (loads, assignments, etc.)
            DB::table('assignments')->where('teacher_id', $id)->delete();

            // delete login
            DB::table('login')->where('username', $teacher->teachid)->delete();

            // delete teacher row
            DB::table('teacher')->where('id', $id)->delete();

            return response()->json(['success' => true, 'deleted' => true]);
        }

        
}
