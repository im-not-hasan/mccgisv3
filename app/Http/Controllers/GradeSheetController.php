<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class GradeSheetController extends Controller
{
    public function print(Request $request)
    {
        // Log::info('GradeSheetController@print called with:', [
        //     'subject_id' => $request->subject_id,
        //     'course'     => $request->course,
        //     'year'       => $request->year,
        //     'section'    => $request->section,
        //     'ay_id'      => $request->ay_id,
        //     'teacher_id' => $request->teacher_id,
        // ]);
        $subject_id = $request->subject_id;
        $course = $request->course;
        $year = $request->year;
        $section = $request->section;
        $ay_id = $request->ay_id;
        $teacher_id = $request->teacher_id;

        $teacher = DB::table('teacher')
            ->select('fname','mname','lname')
            ->where('id',$teacher_id)
            ->first();

        $teacher_name = null;
        if ($teacher) {
            $mInitial = $teacher->mname 
                ? ' ' . strtoupper(substr($teacher->mname, 0, 1)) . '.' 
                : '';
            $teacher_name = trim("{$teacher->fname} {$mInitial} {$teacher->lname}");
        }
        
        // Log::info('Teacher Name', [
        //     'teacher_name' => $teacher_name,
        // ]);

        // Fetch students with grades

        $ay = DB::table('ay')
            ->select('academicyear')
            ->where('id',$ay_id)
            ->first();
        
        if (!$ay) {
            $ay = (object)[ 'academicyear' => '' ];
        }

        $students = DB::table('grades')
            ->join('student', 'grades.student_id', '=', 'student.id')
            ->where('grades.subject_id', $subject_id)
            ->where('grades.course', $course)
            ->where('grades.year', $year)
            ->where('grades.section', $section)
            ->where('grades.ay_id', $ay_id)
            ->where('grades.teacher_id', $teacher_id)
            ->select(
                'grades.*',
                'student.gender',
                // include whichever student columns you still want:
                // formatted display name: LNAME, FNAME M.
                    DB::raw("
                        TRIM(
                        CONCAT(
                            COALESCE(student.lname, ''), 
                            CASE WHEN COALESCE(student.lname,'') <> '' THEN ', ' ELSE '' END,
                            COALESCE(student.fname, ''),
                            CASE 
                            WHEN COALESCE(student.mname,'') <> '' 
                            THEN CONCAT(' ', LEFT(student.mname,1), '.')
                            ELSE ''
                            END
                        )
                        ) as name
                    ")
                )
            // Sort by Gender, LName and FName
            ->orderByRaw("CASE WHEN student.gender = 'Male' THEN 0 ELSE 1 END")
            ->orderBy('student.lname')
            ->orderBy('student.fname')
                
            ->get();
        
        
        // --- Absences calculation ---
        $attendanceAbsences = DB::table('grades_data as gd')
            ->join('grade_components as gc', 'gd.grade_component_id', '=', 'gc.id')
            ->where('gc.subject_id', $subject_id)
            ->where('gc.teacher_id', $teacher_id)
            ->where('gc.course', $course)
            ->where('gc.year', $year)
            ->where('gc.section', $section)
            ->where('gc.ay_id', $ay_id)
            ->where('gc.component_type', 'attendance')
            ->select(
                'gd.student_id',
                'gc.term',
                DB::raw("SUM(CASE WHEN gd.score = 0 THEN 1 ELSE 0 END) AS absences")
            )
            ->groupBy('gd.student_id', 'gc.term')
            ->get();

        // Map of student_id → absences by term
        $absencesMap = [];
        foreach ($attendanceAbsences as $row) {
            $sid = $row->student_id;
            if (!isset($absencesMap[$sid])) {
                $absencesMap[$sid] = ['midterm' => 0, 'final' => 0];
            }
            $absencesMap[$sid][$row->term] = (int)$row->absences;
        }

        // Attach absences to each student
        $students = $students->map(function ($row) use ($absencesMap) {
            $sid = $row->student_id ?? null;
            $row->midterm_absences = $sid && isset($absencesMap[$sid]) 
                ? $absencesMap[$sid]['midterm'] 
                : 0;
            $row->final_absences   = $sid && isset($absencesMap[$sid]) 
                ? $absencesMap[$sid]['final'] 
                : 0;
            return $row;
        });


        // Adding Space after Males
        $grouped = collect();

        $maleStudents   = $students->where('gender', 'Male')->values();
        $femaleStudents = $students->where('gender', 'Female')->values();

        $grouped = $grouped->merge($maleStudents);

        // add a blank spacer row
        $grouped->push((object)[
            'name'   => '',
            'gender' => 'Spacer',
        ]);

        $grouped = $grouped->merge($femaleStudents);

        // Log::info('Students fetched for GradeSheet', [
        //     'count' => $students->count(),
        //     'students' => $students,
        // ]);

        // Fetch subject info too
        $subject = DB::table('subject')->where('id', $subject_id)->first();

        // Log::info('Subject fetched for GradeSheet', [
        //     'subject' => $subject,
        // ]);


        //Fetch units (lecunit + labunit)
        $subject = DB::table('subject')
            ->select('id','code','title','lecunit','labunit','semester') // adjust field names if different
            ->where('id', $subject_id)
            ->first();

        // Attach computed units once
        if ($subject) {
            $lec = (int)($subject->lecunit ?? 0);
            $lab = (int)($subject->labunit ?? 0);
            $subject->units = $lec + $lab; // e.g., 3
        }

        if ($subject->semester == 1) {
            $subject->semester_display = "1st";
        } elseif ($subject->semester == 2) {
            $subject->semester_display = "2nd";
        } elseif (strtolower($subject->semester) === "summer") {
            $subject->semester_display = "Summer";
        } else {
            $subject->semester_display = $subject->semester; // fallback
        }

        return inertia('GradeSheetTemplate', [
            'students'   => $grouped,
            'subject'    => $subject,
            'course'     => $course,
            'year'       => $year,
            'section'    => $section,
            'ay_id'      => $ay_id,
            'teacher_id' => $teacher_id,
            'teacher_name' => $teacher_name,
            'ay' => $ay->academicyear,

        ]);
    }


    
}
