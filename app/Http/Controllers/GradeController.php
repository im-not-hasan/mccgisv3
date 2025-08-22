<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use App\Models\Grade;
use App\Models\Student;

class GradeController extends Controller
{

    public function getGrades(Request $request, $subject_id, $course, $year, $section)
    {   
        $teacherUsername = $request->query('teacher_username');
        $teacher = DB::table('teacher')->where('teachid', $teacherUsername)->first();
        $teacher_id = $teacher->id;
        $ay_id = $request->query('ay_id');
        // Log::info("getGrades() called", [
        //     'subject_id' => $subject_id,
        //     'course' => $course,
        //     'year' => $year,
        //     'section' => $section,
        //     'ay' => $ay_id,
        //     'teacher_id' => $teacher_id,
        // ]);

        try {
            // Fetch students in the class
            $students = DB::table('student')
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->orderBy('gender')
                ->orderBy('lname')
                ->get();

            Log::info("Students fetched", [
                'count' => $students->count(),
            ]);
            $subject = DB::table('subject')->where('code', $subject_id)->first();
            $subjectid = $subject->id;
            // Fetch grade components filtered by subject, teacher, course, year, section, ay
            Log::info("Searching for Components where", [
                'subject_id' => $subjectid,
                'teacher_id' => $teacher_id,
                'course' => $course,
                'year' => $year,
                'section' => $section,
                'ay_id' => $ay_id,
            ]);
            $gradeComponentsRaw = DB::table('grade_components')
                ->where('subject_id', $subjectid)
                ->where('teacher_id', $teacher_id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ay_id)
                ->get();
                
            // Log::info('Grade Components Raw Data:', ['data' => $gradeComponentsRaw->toArray()]);
            // Structure gradeComponents by type and index
            $gradeComponents = [];
            foreach ($gradeComponentsRaw as $comp) {
                $gradeComponents[$comp->component_type][$comp->component_index] = $comp->hps;
            }

            // Determine quiz and attendance count, defaulting if none found
            $quizCount = isset($gradeComponents['quiz']) ? count($gradeComponents['quiz']) : 5;
            $attendanceCount = isset($gradeComponents['attendance']) ? count($gradeComponents['attendance']) : 10;
            $examCount = isset($gradeComponents['exam']) ? count($gradeComponents['exam']) : 0;
            Log::info("Grade Components counts", [
                'quizCount' => $quizCount,
                'attendanceCount' => $attendanceCount,
                'gradeComponents' => $gradeComponents,
            ]);
            
            // Fetch all grades summary for subject/course/year/section (for midterm, final, etc)
            $gradesRaw = DB::table('grades_data as gd')
                ->join('grade_components as gc', 'gd.grade_component_id', '=', 'gc.id')
                ->where('gc.subject_id', $subjectid)
                ->where('gc.teacher_id', $teacher_id)
                ->where('gc.course', $course)
                ->where('gc.year', $year)
                ->where('gc.section', $section)
                ->where('gc.ay_id', $ay_id)
                ->select('gd.*', 'gc.component_type', 'gc.component_index', 'gd.student_id')
                ->get();
            
            
            // Log::info('Grades Raw Data with Join:', ['gradesRaw' => $gradesRaw->toArray()]);

            // Build a map from DB 'id' to 'studid' for students
            $studentIdMap = [];
            foreach ($students as $s) {
                // assuming your 'student' table's primary key is 'id'
                $studentIdMap[$s->id] = $s->studid;
            }

            // Initialize $gradesData keyed by studid
            $gradesData = [];

            // 1️⃣ First pass: populate grades from $gradesRaw
            foreach ($gradesRaw as $grade) {
                // Convert DB student_id → studid
                if (!isset($studentIdMap[$grade->student_id])) {
                    Log::warning("Grade found for unknown student_id: {$grade->student_id}");
                    continue; // skip grades with no matching student
                }

                $studId = $studentIdMap[$grade->student_id];

                if (!isset($gradesData[$studId])) {
                    $gradesData[$studId] = [
                        'quizzes' => [],
                        'attendance' => [],
                        'performance' => null,
                        'exams' => [],
                    ];
                }

                switch ($grade->component_type) {
                    case 'quiz':
                        $index = $grade->component_index - 1;
                        $gradesData[$studId]['quizzes'][$index] = $grade->score;
                        break;

                    case 'attendance':
                        $index = $grade->component_index - 1;
                        $gradesData[$studId]['attendance'][$index] = $grade->score;
                        break;

                    case 'performance':
                        $gradesData[$studId]['performance'] = $grade->score;
                        break;

                    case 'exam':
                        $index = $grade->component_index - 1;
                        $gradesData[$studId]['exams'][$index] = $grade->score;
                        break;
                }
            }

            // 2️⃣ Second pass: ensure all students have complete arrays
            foreach ($students as $student) {
                $studId = $student->studid;

                if (!isset($gradesData[$studId])) {
                    $gradesData[$studId] = [
                        'quizzes' => [],
                        'attendance' => [],
                        'performance' => null,
                        'exams' => [],
                    ];
                }

                // Fill missing quizzes
                for ($i = 0; $i < $quizCount; $i++) {
                    if (!isset($gradesData[$studId]['quizzes'][$i])) {
                        $gradesData[$studId]['quizzes'][$i] = '';
                    }
                }

                // Fill missing attendance
                for ($i = 0; $i < $attendanceCount; $i++) {
                    if (!isset($gradesData[$studId]['attendance'][$i])) {
                        $gradesData[$studId]['attendance'][$i] = '';
                    }
                }

                // Fill missing exams
                for ($i = 0; $i < $examCount; $i++) {
                    if (!isset($gradesData[$studId]['exams'][$i])) {
                        $gradesData[$studId]['exams'][$i] = '';
                    }
                }

                // Default performance
                if ($gradesData[$studId]['performance'] === null) {
                    $gradesData[$studId]['performance'] = '';
                }
            }

            Log::info('Processed Grades Data:', ['gradesData' => $gradesData]);

            Log::info('Processed Grades Data JSON:', ['gradesData' => json_encode($gradesData)]);

            return response()->json([
                'students' => $students,
                'gradeComponents' => $gradeComponents,
                'gradesData' => $gradesData,
                'quizCount' => $quizCount,
                'attendanceCount' => $attendanceCount,
            ]);
        } catch (\Exception $e) {
            Log::error("Error in getGrades(): " . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch grades or students.'], 500);
        }
    }

















    // POST: Save grades (not final)
    public function saveGrades(Request $request)
    {
        $teacherUsername = $request->input('teacher_username');
        $subjectCode = $request->input('subject_code'); // Make sure this matches your DB schema type
        $course = $request->input('course');
        $year = (int) $request->input('year');
        $section = $request->input('section');
        $ayId = (int) $request->input('ay_id');

        $gradeComponents = $request->input('gradeComponents', []);
        $gradesData = $request->input('gradesData', []);
        $gradesSummary = $request->input('gradesSummary', []);

        // Find teacher
        $teacher = DB::table('teacher')->where('teachid', $teacherUsername)->first();
        if (!$teacher) {
            return response()->json(['error' => 'Teacher not found'], 404);
        }

        // Find subject
        $subject = DB::table('subject')->where('code', $subjectCode)->first();
        if (!$subject) {
            return response()->json(['error' => 'Subject not found'], 404);
        }

        // 1. Save or update grade_components
        foreach ($gradeComponents as $comp) {
            $componentType = $comp['component_type'];
            $componentIndex = $comp['component_index'];
            $hps = $comp['hps'];

            $existing = DB::table('grade_components')
                ->where('subject_id', $subject->id)
                ->where('teacher_id', $teacher->id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ayId)
                ->where('component_type', $componentType)
                ->where('component_index', $componentIndex)
                ->first();

            if ($existing) {
                DB::table('grade_components')->where('id', $existing->id)->update([
                    'hps' => $hps,
                    'updated_at' => now(),
                ]);
            } else {
                DB::table('grade_components')->insert([
                    'subject_id' => $subject->id,
                    'teacher_id' => $teacher->id,
                    'course' => $course,
                    'year' => $year,
                    'section' => $section,
                    'ay_id' => $ayId,
                    'component_type' => $componentType,
                    'component_index' => $componentIndex,
                    'hps' => $hps,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        // 2. Save or update grades_data
        foreach ($gradesData as $data) {
            $studentId = $data['student_id'];
            $componentType = $data['component_type'];
            $componentIndex = $data['component_index'];
            $score = $data['score'];
            $student = DB::table('student')->where('studid', $studentId)->first();
            if (!$student) {
                return response()->json(['error' => 'Student not found'], 404);
            }

            // Get grade_component_id based on subject, teacher, course, year, section, ay, type & index
            $gradeComponent = DB::table('grade_components')
                ->where('subject_id', $subject->id)
                ->where('teacher_id', $teacher->id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ayId)
                ->where('component_type', $componentType)
                ->where('component_index', $componentIndex)
                ->first();

            if (!$gradeComponent) {
                continue; // skip if no matching component
            }

            $existingData = DB::table('grades_data')
                ->where('grade_component_id', $gradeComponent->id)
                ->where('student_id', $student->id)
                ->first();

            if ($existingData) {
                DB::table('grades_data')->where('id', $existingData->id)->update([
                    'score' => $score,
                    'updated_at' => now(),
                ]);
            } else {
                DB::table('grades_data')->insert([
                    'grade_component_id' => $gradeComponent->id,
                    'student_id' => $student->id,
                    'score' => $score,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        // 3. Save or update summary grades in grades table
        foreach ($gradesSummary as $summary) {
            $studentId = $summary['student_id'];
            $midterm = $summary['midterm'];
            $final = $summary['final'];
            $overall = $summary['overall'];
            $student = DB::table('student')->where('studid', $studentId)->first();
            if (!$student) {
                return response()->json(['error' => 'Student not found'], 404);
            }

            $existingGrade = DB::table('grades')
                ->where('student_id', $student->id)
                ->where('subject_id', $subject->id)
                ->where('teacher_id', $teacher->id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ayId)
                ->first();

            if ($existingGrade) {
                DB::table('grades')->where('id', $existingGrade->id)->update([
                    'midterm' => $midterm,
                    'final' => $final,
                    'overall' => $overall,
                    'updated_at' => now(),
                ]);
            } else {
                DB::table('grades')->insert([
                    'student_id' => $student->id,
                    'subject_id' => $subject->id,
                    'teacher_id' => $teacher->id,
                    'course' => $course,
                    'year' => $year,
                    'section' => $section,
                    'midterm' => $midterm,
                    'final' => $final,
                    'overall' => $overall,
                    'ay_id' => $ayId,
                    'submitted' => 0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        return response()->json(['message' => 'Grades saved successfully']);
    }















    

    // POST: Submit grades (final)
    public function submitGrades(Request $request)
    {
        foreach ($request->grades as $gradeData) {
            Grade::updateOrCreate(
                [
                    'student_id' => $gradeData['student_id'],
                    'subject_id' => $request->subject_id,
                ],
                [
                    'teacher_id' => $request->teacher_id,
                    'course'     => $request->course,
                    'year'       => $request->year,
                    'section'    => $request->section,
                    'ay_id'      => $request->ay_id,
                    'prelim'     => $gradeData['prelim'],
                    'midterm'    => $gradeData['midterm'],
                    'final'      => $gradeData['final'],
                    'overall'    => $gradeData['overall'],
                    'submitted'  => true,
                ]
            );
        }

        return response()->json(['message' => 'Grades submitted successfully']);
    }
}
