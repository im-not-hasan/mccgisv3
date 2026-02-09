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
            $regularStudents = DB::table('student')
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('regular', 1)
                ->select(
                    'student.*',
                    DB::raw('0 as is_irregular')
                )
                ->orderBy('gender', 'desc')
                ->orderBy('lname')
                ->get();

            $irregularStudents = DB::table('irregstudentsubject as iss')
                ->join('student as s', 'iss.student_id', '=', 's.id')
                ->join('subject as sub', 'iss.subject_id', '=', 'sub.id')
                ->where('sub.code', $subject_id)
                ->where('iss.year', $year)
                ->where('iss.section', $section)
                ->where('iss.ay_id', $ay_id)
                ->select(
                    's.*',
                    DB::raw('1 as is_irregular')
                )
                ->get();

            $students = $regularStudents
                ->merge($irregularStudents)
                ->unique('id')
                ->sortBy([
                    ['gender', 'desc'],
                    ['lname', 'asc'],
                ])
                ->values();

            // Log::info("Students fetched", [
            //     'count' => $students->count(),
            // ]);
            $active_curriculum = DB::table('curriculums')->where('display',1)->first();
            $subject = DB::table('subject')->where('code', $subject_id)->where('curriculum',$active_curriculum->curriculum)->first();
            $subjectid = $subject->id;
            $hasComponents = DB::table('grade_components')
                ->where('subject_id', $subjectid)
                ->where('teacher_id', $teacher_id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ay_id)
                ->exists();


            // Fetch grade components filtered by subject, teacher, course, year, section, ay
            Log::info("Searching for Components where", [
                'subject_id' => $subjectid,
                'teacher_id' => $teacher_id,
                'course' => $course,
                'year' => $year,
                'section' => $section,
                'ay_id' => $ay_id,
                'term' => "midterm",
            ]);
            
            // ✅ Check if this class has already been submitted
            $isSubmitted = DB::table('grades')
                ->where('subject_id', $subjectid)
                ->where('teacher_id', $teacher_id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ay_id)
                ->where('submitted', 1)
                ->exists();

            $gradeComponentsRaw = DB::table('grade_components')
                ->where('subject_id', $subjectid)
                ->where('teacher_id', $teacher_id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ay_id)
                ->where('term', "midterm")
                ->get();

                
            // Log::info('Grade Components Raw Data:', ['data' => $gradeComponentsRaw->toArray()]);
            // Structure gradeComponents by type and index
            $gradeComponents = [];
            foreach ($gradeComponentsRaw as $comp) {
                $gradeComponents[$comp->component_type][$comp->component_index] = $comp->hps;
            }

            // Determine quiz and attendance count, defaulting if none found
            if (!isset($gradeComponents['quiz'])) {
                Log::info('No quiz components found — defaulting quizCount to 5', [
                    'subject_id' => $subjectid,
                    'teacher_id' => $teacher_id,
                    'course' => $course,
                    'year' => $year,
                    'section' => $section,
                    'ay_id' => $ay_id,
                ]);
            }

            if (!isset($gradeComponents['attendance'])) {
                Log::info('No attendance components found — defaulting attendanceCount to 10', [
                    'subject_id' => $subjectid,
                    'teacher_id' => $teacher_id,
                    'course' => $course,
                    'year' => $year,
                    'section' => $section,
                    'ay_id' => $ay_id,
                ]);
            }

            $quizCount = isset($gradeComponents['quiz'])
                ? count($gradeComponents['quiz'])
                : 5;

            $attendanceCount = isset($gradeComponents['attendance'])
                ? count($gradeComponents['attendance'])
                : 10;

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
                ->where('gc.term', "midterm")
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

            // Log::info('Processed Grades Data:', ['gradesData' => $gradesData]);

            // Log::info('Processed Grades Data JSON:', ['gradesData' => json_encode($gradesData)]);

            return response()->json([
                'students' => $students,
                'gradeComponents' => $gradeComponents,
                'gradesData' => $gradesData,
                'quizCount' => $quizCount,
                'attendanceCount' => $attendanceCount,
                'term' => "midterm",
                'submitted' => $isSubmitted ? 1 : 0, // ✅ return as integer
                'hasComponents' => $hasComponents,
            ]);
        } catch (\Exception $e) {
            Log::error("Error in getGrades(): " . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch grades or students.'], 500);
        }
    }

    public function getFinalGrades(Request $request, $subject_id, $course, $year, $section)
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
            $regularStudents = DB::table('student')
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('regular', 1)
                ->orderBy('gender', 'desc')
                ->orderBy('lname')
                ->get();

            $irregularStudents = DB::table('irregstudentsubject as iss')
                ->join('student as s', 'iss.student_id', '=', 's.id')
                ->join('subject as sub', 'iss.subject_id', '=', 'sub.id')
                ->where('sub.code', $subject_id)
                ->where('iss.year', $year)
                ->where('iss.section', $section)
                ->where('iss.ay_id', $ay_id)
                ->select('s.*')
                ->get();
                
            $students = $regularStudents
                ->merge($irregularStudents)
                ->unique('id')
                ->sortBy([
                    ['gender', 'desc'],
                    ['lname', 'asc'],
                ])
                ->values();

            // Log::info("Students fetched", [
            //     'count' => $students->count(),
            // ]);
            $active_curriculum = DB::table('curriculums')->where('display',1)->first();
            $subject = DB::table('subject')->where('code', $subject_id)->where('curriculum',$active_curriculum->curriculum)->first();
            $subjectid = $subject->id;
            // Fetch grade components filtered by subject, teacher, course, year, section, ay
            Log::info("Searching for Components where", [
                'subject_id' => $subjectid,
                'teacher_id' => $teacher_id,
                'course' => $course,
                'year' => $year,
                'section' => $section,
                'ay_id' => $ay_id,
                'term' => "final",
            ]);
            
            $gradeComponentsRaw = DB::table('grade_components')
                ->where('subject_id', $subjectid)
                ->where('teacher_id', $teacher_id)
                ->where('course', $course)
                ->where('year', $year)
                ->where('section', $section)
                ->where('ay_id', $ay_id)
                ->where('term', "final")
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
                ->where('gc.term', "final")
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

            // Log::info('Processed Grades Data:', ['gradesData' => $gradesData]);

            // Log::info('Processed Grades Data JSON:', ['gradesData' => json_encode($gradesData)]);

            return response()->json([
                'students' => $students,
                'gradeComponents' => $gradeComponents,
                'gradesData' => $gradesData,
                'quizCount' => $quizCount,
                'attendanceCount' => $attendanceCount,
                'term' => "final",
            ]);
        } catch (\Exception $e) {
            Log::error("Error in getGrades(): " . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch grades or students.'], 500);
        }
    }



















    public function saveGrades(Request $request)
    {
        $teacherUsername = $request->input('teacher_username');
        $subjectCode = $request->input('subject_code'); 
        $course = $request->input('course');
        $year = (int) $request->input('year');
        $section = $request->input('section');
        $ayId = (int) $request->input('ay_id');
        $term = $request->input('term', 'midterm');

        $gradeComponents = $request->input('gradeComponents', []);
        $gradesData = $request->input('gradesData', []);
        $gradesSummary = $request->input('gradesSummary', []);
        $curriculum = DB::table('curriculums')
            ->where('display',1)
            ->first();

        // Find teacher
        $teacher = DB::table('teacher')->where('teachid', $teacherUsername)->first();
        if (!$teacher) {
            return response()->json(['error' => 'Teacher not found'], 404);
        }

        // Find subject
        $subject = DB::table('subject')->where('code', $subjectCode)->where('curriculum',$curriculum->curriculum)->first();
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
                ->where('term', $term)
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
                    'term' => $term,
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
            ->where('term', $term)
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
                    'ay_id' => $ayId,
                    'submitted' => 0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        return response()->json(['message' => 'Midterm grades saved successfully']);
    }



    public function saveFinalGrades(Request $request)
    {
        $teacherUsername = $request->input('teacher_username');
        $subjectCode = $request->input('subject_code'); 
        $course = $request->input('course');
        $year = (int) $request->input('year');
        $section = $request->input('section');
        $ayId = (int) $request->input('ay_id');
        $term = $request->input('term', 'final');

        $gradeComponents = $request->input('gradeComponents', []);
        $gradesData = $request->input('gradesData', []);
        $gradesSummary = $request->input('gradesSummary', []);
        $curriculum = DB::table('curriculums')
            ->where('display',1)
            ->first();

        // Find teacher
        $teacher = DB::table('teacher')->where('teachid', $teacherUsername)->first();
        if (!$teacher) {
            return response()->json(['error' => 'Teacher not found'], 404);
        }

        // Find subject
        $subject = DB::table('subject')->where('code', $subjectCode)->where('curriculum',$curriculum->curriculum)->first();
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
                ->where('term', $term)
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
                    'term' => $term,
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
            ->where('term', $term)
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
                    'final' => $final,
                    'overall' => $overall,
                    'ay_id' => $ayId,
                    'submitted' => 0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }

        return response()->json(['message' => 'Final grades saved successfully']);
    }



// Autosave (BATCH)
public function autosave(Request $request)
{
    // 🔐 Validate teacher once
    $teacher = DB::table('teacher')
        ->where('teachid', $request->teacher_username)
        ->first();

    if (!$teacher) {
        return response()->json(['error' => 'Unauthorized'], 401);
    }

    // 📦 Expect batched changes
    $changes = $request->input('changes', []);

    if (!is_array($changes) || empty($changes)) {
        return response()->json(['skipped' => true]);
    }

    // 📚 Resolve curriculum + subject once
    $curriculum = DB::table('curriculums')->where('display', 1)->first();
    if (!$curriculum) {
        return response()->json(['error' => 'Curriculum not found'], 404);
    }

    $subject = DB::table('subject')
        ->where('code', $request->subject_code)
        ->where('curriculum', $curriculum->curriculum)
        ->first();

    if (!$subject) {
        return response()->json(['error' => 'Subject not found'], 404);
    }

    DB::beginTransaction();

    try {
        foreach ($changes as $change) {

            // 👨‍🎓 Student
            $student = DB::table('student')
                ->where('studid', $change['student_id'])
                ->first();

            if (!$student) {
                continue; // skip invalid student
            }

            // 🧩 Grade component
            $component = DB::table('grade_components')
                ->where('subject_id', $subject->id)
                ->where('teacher_id', $teacher->id)
                ->where('course', $request->course)
                ->where('year', $request->year)
                ->where('section', $request->section)
                ->where('ay_id', $request->ay_id)
                ->where('component_type', $change['component_type'])
                ->where('component_index', $change['component_index'])
                ->where('term', $change['term'])
                ->first();

            if (!$component) {
                continue; // skip missing component
            }

            // 💾 Upsert grade
            DB::table('grades_data')->updateOrInsert(
                [
                    'grade_component_id' => $component->id,
                    'student_id' => $student->id,
                ],
                [
                    'score' => $change['score'],
                    'updated_at' => now(),
                ]
            );
        }

        DB::commit();

        return response()->json([
            'saved' => true,
            'count' => count($changes),
        ]);

    } catch (\Throwable $e) {
        DB::rollBack();

        \Log::error('Autosave failed', [
            'error' => $e->getMessage(),
        ]);

        return response()->json([
            'error' => 'Autosave failed',
        ], 500);
    }
}










    

    // POST: Submit grades (final)
    public function submitGrades(Request $request)
    {
        $teacherUsername = $request->input('teacher_username');
        $subjectCode = $request->input('subject_code');
        $course = $request->input('course');
        $year = $request->input('year');
        $section = $request->input('section');
        $ayId = $request->input('ay_id');

        $teacher = DB::table('teacher')->where('teachid', $teacherUsername)->first();
        $subject = DB::table('subject')
            ->where('code', $subjectCode)
            ->whereIn('curriculum', DB::table('curriculums')->where('display', 1)->pluck('curriculum'))
            ->first();

        if (!$teacher || !$subject) {
            return response()->json(['error' => 'Teacher or subject not found'], 404);
        }

        DB::table('grades')
            ->where('teacher_id', $teacher->id)
            ->where('subject_id', $subject->id)
            ->where('course', $course)
            ->where('year', $year)
            ->where('section', $section)
            ->where('ay_id', $ayId)
            ->update(['submitted' => 1, 'updated_at' => now()]);

        return response()->json(['message' => 'Grades successfully submitted!']);
    }

}
