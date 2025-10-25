<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ClassesController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = DB::table('class')->select('id', 'name', 'course', 'year', 'section');

            if ($request->has('courses')) {
                $courses = explode(',', $request->query('courses'));
                $query->whereIn('course', $courses);
            }

            $classes = $query->orderBy('year')->orderBy('name')->get();

            return response()->json(['classes' => $classes]);
        } catch (\Exception $e) {
            Log::error("Error fetching class data", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to fetch class data'], 500);
        }
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'course' => 'required|string|max:50',
            'year' => 'required|integer|between:1,4',
            'section' => 'required|string|max:10',
        ]);

        try {
            DB::table('class')->insert($validated);
            Log::info("Class created", $validated);
            return response()->json(['message' => 'Class created successfully']);
        } catch (\Exception $e) {
            Log::error("Class creation failed", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to create class'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'course' => 'required|string|max:50',
            'year' => 'required|integer|between:1,4',
            'section' => 'required|string|max:10',
        ]);

        try {
            DB::table('class')->where('id', $id)->update($validated);
            Log::info("Class updated", ['id' => $id]);
            return response()->json(['message' => 'Class updated successfully']);
        } catch (\Exception $e) {
            Log::error("Failed to update class", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Update failed'], 500);
        }
    }

    public function destroy($id)
    {
        try {
            DB::table('class')->where('id', $id)->delete();
            Log::info("Class deleted", ['id' => $id]);
            return response()->json(['message' => 'Deleted']);
        } catch (\Exception $e) {
            Log::error("Delete failed", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Delete failed'], 500);
        }
    }
    public function getStats()
    {
        try {
            $classes = DB::table('class')
                ->select('id', 'course', 'year', 'section')
                ->get();

            $classStats = $classes->map(function ($cls) {
                $studentCount = DB::table('student')
                    ->where('course', $cls->course)
                    ->where('year', $cls->year)
                    ->where('section', $cls->section)
                    ->count();

                return [
                    'id' => $cls->id,
                    'course' => $cls->course,
                    'year' => $cls->year,
                    'section' => $cls->section,
                    'studentCount' => $studentCount,
                    'color' => match ($cls->course) {
                        'BSIT' => '#3b82f6',
                        'BSBA' => '#f59e0b',
                        'BSHM' => '#8b5cf6',
                        'BSED' => '#ec4899',
                        'BEED' => '#10b981',
                        default => '#6b7280'
                    }
                ];
            });
            return response()->json([
                'classes' => $classStats,
                'totalClasses' => $classes->count(),
                'totalStudents' => $classStats->sum('studentCount')
            ]);
        } catch (\Exception $e) {
            Log::error("Failed to fetch class stats", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Error'], 500);
        }
    }

    public function getClassStudents($classId)
    {
        try {
            $class = DB::table('class')->where('id', $classId)->first();
            if (!$class) {
                return response()->json(['message' => 'Class not found'], 404);
            }

            $students = DB::table('student')
                ->select('id', 'studid', 'lname', 'fname', 'mname', 'gender')
                ->where('course', $class->course)
                ->where('year', $class->year)
                ->where('section', $class->section)
                ->orderBy('gender') 
                ->orderBy('lname')  
                ->get();

            return response()->json(['students' => $students]);
        } catch (\Exception $e) {
            Log::error('Error fetching class students', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to fetch students'], 500);
        }
    }

    
    // POST /api/classes/{classId}/students
    public function addStudentToClass(Request $request, $classId)
    {
        $request->validate([
            'student_id' => 'required|integer|exists:student,id',
        ]);

        try {
            $class = DB::table('class')->where('id', $classId)->first();
            $student = DB::table('student')->where('id', $request->student_id)->first();

            if (!$class || !$student) {
                return response()->json(['message' => 'Class or student not found'], 404);
            }

            // Update student year/section/course to match the class
            DB::table('student')
                ->where('id', $student->id)
                ->update([
                    'year' => $class->year,
                    'section' => $class->section,
                    'course' => $class->course,
                ]);

            return response()->json(['message' => 'Student added to class']);
        } catch (\Exception $e) {
            Log::error('Failed to add student to class', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Add failed'], 500);
        }
    }

    // DELETE /api/classes/{classId}/students/{studentId}
    public function removeStudentFromClass($classId, $studentId)
    {
        try {
            // Clear student from class (optional: update only section and year to null)
            DB::table('student')
                ->where('id', $studentId)
                ->update([
                    'section' => null,
                    'year' => null,
                ]);

            return response()->json(['message' => 'Student removed from class']);
        } catch (\Exception $e) {
            Log::error('Failed to remove student from class', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Remove failed'], 500);
        }
    }

    



    ///Teacher's Student View
    public function getStudentsByClass(Request $request)
    {
        $course = $request->query('course');
        $year = $request->query('year');
        $section = $request->query('section');

        $students = DB::table('student')
            ->where('course', $course)
            ->where('year', $year)
            ->where('section', $section)
            ->orderBy('gender')
            ->orderBy('lname')
            ->get();

        //Log::info('Fetching students with:', ['course' => $course, 'year' => $year, 'section' => $section, 'students' => $students]);
        return response()->json(['student' => $students]);
    }


    //Registrar's Subject View
    public function getClassSubjects($classId){
        try {
            // Find class
            $class = DB::table('class')->where('id', $classId)->first();
            if (!$class) {
                return response()->json(['message' => 'Class not found'], 404);
            }

            // Get active AY and Curriculum
            $ay = DB::table('ay')->where('display', 1)->first();
            $curriculum = DB::table('curriculums')->where('display', 1)->first();
            if (!$ay || !$curriculum) {
                return response()->json(['message' => 'Missing active AY or Curriculum'], 404);
            }

            // Fetch subjects and join assignments, teacher, and grades
            $subjects = DB::table('subject')
                ->leftJoin('assignments', function ($join) use ($class, $ay) {
                    $join->on('subject.id', '=', 'assignments.subject_id')
                        ->where('assignments.course', $class->course)
                        ->where('assignments.year', $class->year)
                        ->where('assignments.section', $class->section)
                        ->where('assignments.ay_id', $ay->id);
                })
                ->leftJoin('teacher', 'assignments.teacher_id', '=', 'teacher.id')
                ->leftJoin('grades', function ($join) use ($class, $ay) {
                    $join->on('grades.subject_id', '=', 'subject.id')
                        ->where('grades.course', $class->course)
                        ->where('grades.year', $class->year)
                        ->where('grades.section', $class->section)
                        ->where('grades.ay_id', $ay->id);
                })
                ->select(
                    'subject.id',
                    'subject.code',
                    'subject.title',
                    'assignments.teacher_id',
                    'assignments.ay_id',
                    DB::raw("COALESCE(CONCAT(teacher.fname, ' ', teacher.lname), 'Unassigned') as instructor"),
                    DB::raw("MAX(grades.submitted) as submitted")
                )
                ->where('subject.course', $class->course)
                ->where('subject.year', $class->year)
                ->where('subject.semester', $ay->semester)
                ->where('subject.curriculum', $curriculum->curriculum)
                ->groupBy('subject.id', 'subject.code', 'subject.title', 'assignments.teacher_id', 'assignments.ay_id', 'teacher.fname', 'teacher.lname')
                ->get();

            return response()->json(['subjects' => $subjects]);
        } catch (\Exception $e) {
            Log::error('Error fetching class subjects', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to fetch subjects'], 500);
        }
    }




}
