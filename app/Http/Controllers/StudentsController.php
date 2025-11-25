<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;
use Barryvdh\DomPDF\Facade\Pdf;

class StudentsController extends Controller
{
    public function getStudentStats()
    {
        // Get student counts by course (TOTAL per course)
        $byCourse = DB::table('student')
            ->select('course', DB::raw('COUNT(*) as total'))
            ->where('archived',0)
            ->groupBy('course')
            ->pluck('total', 'course');

        // Get REGULAR student counts by course
        $byCourseRegular = DB::table('student')
            ->where('regular', 1)
            ->where('archived',0)
            ->select('course', DB::raw('COUNT(*) as count'))
            ->groupBy('course')
            ->pluck('count', 'course');

        // Irregular per course 
        $byCourseIrregular = DB::table('student')
            ->where('regular', 0)
            ->where('archived',0)
            ->select('course', DB::raw('COUNT(*) as count'))
            ->groupBy('course')
            ->pluck('count', 'course');

        // Get student counts by gender
        $genderCounts = DB::table('student')
            ->where('archived',0)
            ->select('gender', DB::raw('count(*) as count'))
            ->groupBy('gender')
            ->pluck('count', 'gender');
        
        $byGender = [
            'male'   => $genderCounts['Male']   ?? 0,
            'female' => $genderCounts['Female'] ?? 0,
        ];

        // Get total, male, female, regular, irregular
        $total     = DB::table('student')->where('archived',0)->count();
        $male      = DB::table('student')->where('archived',0)->where('gender', 'Male')->count();
        $female    = DB::table('student')->where('archived',0)->where('gender', 'Female')->count();
        $regular   = DB::table('student')->where('archived',0)->where('regular', 1)->count();
        $irregular = DB::table('student')->where('archived',0)->where('regular', 0)->count();

        return response()->json([
            'byCourse'          => $byCourse,
            'byCourseRegular'   => $byCourseRegular,
            'byCourseIrregular' => $byCourseIrregular, 
            'byGender'          => $byGender,
            'totals' => [
                'total'     => $total,
                'male'      => $male,
                'female'    => $female,
                'regular'   => $regular,
                'irregular' => $irregular,
            ],
        ]);
    }


    public function getAllStudents()
    {
        $students = DB::table('student')
            ->where('archived', 0)
            ->get();

        return response()->json($students);
    }

    public function getStudentsByCourse($course)
    {
        $students = DB::table('student')
            ->where('course', $course)
            ->where('archived', 0)
            ->get();

        return response()->json($students);
    }

    public function getArchivedStudents()
    {
        $students = DB::table('student')
            ->where('archived', 1)
            ->get();

        return response()->json($students);
    }


    public function store(Request $request)
    {
        $validated = $request->validate([
            'studid'    => 'required|string|max:50|unique:student,studid',
            'fname'     => 'required|string|max:100',
            'lname'     => 'required|string|max:100',
            'mname'     => 'nullable|string|max:50',
            'email'     => 'nullable|email|max:255',
            'course'    => 'required|string|max:10',
            'year'      => 'required|integer|max:50',
            'section'   => 'required|string|max:50',
            'semester'  => 'required|string|max:50',
            'ay'        => 'required|string|max:100',
            'gender'    => 'required|string|max:10',
            'regular'   => 'required|integer',
        ]);

        DB::beginTransaction();

        try {
            // Insert student record
            DB::table('student')->insert($validated);

            // Insert login record for this student with hashed password
            DB::table('login')->insert([
                'username' => $validated['studid'],
                'password' => Hash::make($validated['studid']), // hashed password
                'fullname' => trim($validated['fname'] . ' ' . ($validated['mname'] ?? '') . ' ' . $validated['lname']),
                'level'    => 'student',
            ]);

            DB::commit();

            Log::info("Student and login added successfully", ['studid' => $validated['studid']]);
            return response()->json(['message' => 'Student added successfully'], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Error adding student and login", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to add student'], 500);
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'studid'    => 'required|string|max:50|unique:student,studid,' . $id,
            'fname'     => 'required|string|max:100',
            'lname'     => 'required|string|max:100',
            'mname'     => 'nullable|string|max:50',
            'email'     => 'nullable|email|max:255',
            'course'    => 'required|string|max:10',
            'year'      => 'required|integer|max:50',
            'section'   => 'required|string|max:50',
            'semester'  => 'required|string|max:50',
            'ay'        => 'required|string|max:100',
            'gender'    => 'required|string|max:10',
            'regular'   => 'nullable|integer',
        ]);

        DB::beginTransaction();

        try {
            // Update student table
            DB::table('student')->where('id', $id)->update($validated);

            // Get the old studid for login table update (if studid changed)
            $student = DB::table('student')->where('id', $id)->first();

            if ($student) {
                // Update login table with new studid and fullname
                DB::table('login')->where('username', $student->studid)->update([
                    'username' => $validated['studid'],
                    'fullname' => trim($validated['fname'] . ' ' . ($validated['mname'] ?? '') . ' ' . $validated['lname']),
                ]);
            }

            DB::commit();

            Log::info("Student and login updated successfully", ['id' => $id, 'studid' => $validated['studid']]);
            return response()->json(['message' => 'Student updated successfully']);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Failed to update student", ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Failed to update student'], 500);
        }
    }

    public function deleteStudent($id)
    {
        $student = DB::table('student')->where('id', $id)->first();

        DB::table('student')
            ->where('id', $id)
            ->update([
                'archived' => 1
            ]);

        DB::table('login')
            ->where('username', $student->studid)
            ->update(['disabled' => 1]);

        return response()->json(['success' => true, 'archived' => true]);
    }


    public function destroy($id)
    {
        $student = DB::table('student')->where('id', $id)->first();
        \Log::info("Deleting student", ['studid' => $student->studid]);
        DB::table('irregstudentsubject')->where('student_id', $id)->delete();
        DB::table('student')->where('id', $id)->delete();
        DB::table('login')->where('username', $student->studid)->delete();
        return response()->json(['message' => 'Deleted']);
    }

    public function restoreStudent($id)
    {
        $student = DB::table('student')->where('id', $id)->first();

        DB::table('student')
            ->where('id', $id)
            ->update([
                'archived' => 0
            ]);

        DB::table('login')
            ->where('username', $student->studid)
            ->update(['disabled' => 0]);

        return response()->json(['success' => true]);
    }

    public function forceDeleteStudent($id)
{
    $student = DB::table('student')->where('id', $id)->first();

    // delete related records
    \Log::info("Deleting student", ['studid' => $student->studid]);
    DB::table('irregstudentsubject')->where('student_id', $id)->delete();
    DB::table('login')->where('username', $student->studid)->delete();

    // delete student permanently
    DB::table('student')->where('id', $id)->delete();

    return response()->json(['success' => true, 'deleted' => true]);
}






    // Students - View Subjects


    public function studentSubjects(Request $request)
    {
        $username = session('username');
        //Log::info('Fetching studentSubjects for username:', [$username]);

        // Get student details
        $student = DB::table('student')->where('studid', $username)->first();
        //Log::debug('Student details fetched:', [$student]);

        if (!$student) {
            Log::warning('No student found for studid:', [$username]);
            return response()->json(['subjects' => []]);
        }

        $course = $student->course;
        $year = $student->year;
        $section = $student->section;
        $regular = $student->regular;
        $studentId = $student->id;

        // Log::info('Student basic info:', [
        //     'course' => $course,
        //     'year' => $year,
        //     'section' => $section,
        //     'regular' => $regular,
        //     'studentId' => $studentId
        // ]);

        // Get active semester & curriculum
        $activeSemester = DB::table('ay')->where('display', 1)->value('semester');
        // Log::info('Active semester fetched:', [$activeSemester]);
        $ay_id = DB::table('ay')->where('display', 1)->value('id');
        $curriculum = DB::table('curriculums')
            ->where('display',1)
            ->first();
        $subjects = [];

        if ($regular == 1) {
            Log::info('Processing as REGULAR student');

            // Fetch subjects for their course, year, and active semester
            $subjectList = DB::table('subject')
                ->where('course', $course)
                ->where('year', $year)
                ->where('semester', $activeSemester)
                ->where('curriculum',$curriculum->curriculum)
                ->get();

            // Log::debug('Subjects fetched for regular student:', [$subjectList]);

            foreach ($subjectList as $subj) {
                // Get teacher_id from assignments
                $teacherId = DB::table('assignments')
                    ->where('subject_id', $subj->id)
                    ->where('course', $course)
                    ->where('year', $year)
                    ->where('section', $section)
                    ->value('teacher_id');

                // Log::debug("Teacher ID for subject {$subj->code}:", [$teacherId]);

                // Get teacher details
                if ($teacherId) {
                    $teacher = DB::table('teacher')->where('id', $teacherId)->first();
                    // Log::debug("Teacher details for teacher_id {$teacherId}:", [$teacher]);
                    $instructorName = $teacher ? "{$teacher->fname} {$teacher->lname}" : "N/A";
                } else {
                    $instructorName = "N/A";
                }
                
                // Get grade for subject
                $midterm = DB::table('grades')
                    ->where('student_id', $studentId)
                    ->where('subject_id', $subj->id)
                    ->where('teacher_id', $teacherId)
                    ->where('ay_id', $ay_id)
                    ->value('midterm');

                $final = DB::table('grades')
                    ->where('student_id', $studentId)
                    ->where('subject_id', $subj->id)
                    ->where('teacher_id', $teacherId)
                    ->where('ay_id', $ay_id)
                    ->value('final');

                $overall = DB::table('grades')
                    ->where('student_id', $studentId)
                    ->where('subject_id', $subj->id)
                    ->where('teacher_id', $teacherId)
                    ->where('ay_id', $ay_id)
                    ->value('overall');

                if($overall<=0.00 || !$overall){
                    if($final<=0.00 || !$final){
                        $grade= $midterm;
                    }
                    else{
                        $grade =$final;
                    }
                }
                else{
                    $grade=$overall;
                }

                $subjects[] = [
                    'code' => $subj->code,
                    'title' => $subj->title,
                    'instructor' => $instructorName,
                    'grade' => $grade,
                ];
            }

        } else {
            //Log::info('Processing as IRREGULAR student');

            // Fetch their custom subjects
            $irregSubjects = DB::table('irregstudentsubject')
                ->where('student_id', $studentId)
                ->get();

            //Log::debug('Irregular student subjects fetched:', [$irregSubjects]);

            foreach ($irregSubjects as $irreg) {
                // Get subject details
                $subj = DB::table('subject')->where('id', $irreg->subject_id)->first();
                //Log::debug("Subject details for irreg subject_id {$irreg->subject_id}:", [$subj]);

                if ($subj) {
                    // Get teacher_id from assignments
                    $teacherId = DB::table('assignments')
                        ->where('subject_id', $subj->id)
                        ->where('course', $course)
                        ->where('year', $year)
                        ->where('section', $section)
                        ->value('teacher_id');

                    //Log::debug("Teacher ID for subject {$subj->code}:", [$teacherId]);

                    // Get teacher details
                    if ($teacherId) {
                        $teacher = DB::table('teacher')->where('id', $teacherId)->first();
                        Log::debug("Teacher details for teacher_id {$teacherId}:", [$teacher]);
                        $instructorName = $teacher ? "{$teacher->fname} {$teacher->lname}" : "N/A";
                    } else {
                        $instructorName = "N/A";
                    }

                    $subjects[] = [
                        'code' => $subj->code,
                        'title' => $subj->title,
                        'instructor' => $instructorName,
                    ];
                }
            }
        }

        Log::info('Final subjects array to return:', [$subjects]);

        return response()->json(['subjects' => $subjects]);
    }



    public function getSections()
    {
        $sections = DB::table('class')->select('section')->distinct()->pluck('section');
        return response()->json($sections);
    }


    public function getAcademicYears()
    {
        $ays = DB::table('ay')->select('academicyear')->distinct()->pluck('academicyear');
        return response()->json($ays);
    }

    public function checkStudid($studid)
    {
        $exists = DB::table('student')->where('studid', $studid)->exists();
        return response()->json(['exists' => $exists]);
    }

    public function viewGradesData(Request $request)
    {
        $username = session('username');
        $student = DB::table('student')->where('studid', $username)->first();

        if (!$student) {
            return response()->json(['student' => null, 'grouped' => []]);
        }

        // active curriculum (can be 0)
        $activeCurriculum = DB::table('curriculums')->where('display', 1)->first();
        $curriculumCode = $activeCurriculum?->curriculum; // could be 0

        $subjectsQuery = DB::table('subject')
            ->where('course', $student->course);

        // IMPORTANT: apply even if curriculum = 0
        if (!is_null($curriculumCode)) {
            $subjectsQuery->where('curriculum', $curriculumCode);
        }

        $subjects = $subjectsQuery
            ->orderBy('year')
            ->orderBy('semester')
            ->orderBy('code')
            ->get();

        // student grades
        $grades = DB::table('grades')
            ->where('student_id', $student->id)
            ->pluck('overall', 'subject_id');

        // map + normalize semester
        $mapped = $subjects->map(function ($s) use ($grades) {
            // normalize semester to 1 / 2 / 3
            $rawSem = strtolower((string) $s->semester);
            if ($rawSem === 'summer' || $rawSem === 'midyear' || $rawSem === '3') {
                $sem = 3;
            } else {
                $sem = (int) $s->semester; // 1 or 2
            }

            return [
                'id'          => $s->id,
                'code'        => $s->code,
                'title'       => $s->title,
                'year'        => (int) $s->year,
                'semester'    => $sem,
                'total_units' => $s->totalunit ?? 0,
                'grade'       => $grades[$s->id] ?? null,
            ];
        });

        // labels
        $years = [
            1 => 'First Year',
            2 => 'Second Year',
            3 => 'Third Year',
            4 => 'Fourth Year',
        ];
        $semesters = [
            1 => 'First Semester',
            2 => 'Second Semester',
            3 => 'Summer',
        ];

        $grouped = [];
        foreach ($years as $y => $yLabel) {
            $grouped[$yLabel] = [];
            foreach ($semesters as $semNum => $semLabel) {
                $list = $mapped
                    ->where('year', $y)
                    ->where('semester', $semNum)
                    ->values();
                if ($list->isNotEmpty()) {
                    $grouped[$yLabel][$semLabel] = $list;
                }
            }
        }

        return response()->json([
            'student'    => [
                'fullname' => "{$student->fname} {$student->lname}",
                'course'   => $student->course,
                'year'     => $student->year,
                'section'  => $student->section,
            ],
            'curriculum' => $curriculumCode,
            'grouped'    => $grouped,
        ]);
    }    

    public function downloadGradeSlip(Request $request)
    {
        // 1) get logged-in student
        $username = session('username');
        $student = DB::table('student')->where('studid', $username)->first();
        if (!$student) {
            abort(404, 'Student not found.');
        }

        // 2) get active curriculum (can be 0)
        $activeCurriculum = DB::table('curriculums')->where('display', 1)->first();
        $curriculumCode = $activeCurriculum?->curriculum; // could be 0

        // 3) base subject query for this student's course + curriculum
        $subjectsQuery = DB::table('subject')
            ->where('course', $student->course);

        // important: apply even if curriculum = 0
        if (!is_null($curriculumCode)) {
            $subjectsQuery->where('curriculum', $curriculumCode);
        }

        // we’ll select all relevant columns; adjust names if yours differ
        $subjects = $subjectsQuery
            ->select(
                'id',
                'code',
                'title',
                'year',
                'semester',
                'lecunit',
                'labunit',
                'totalunit',
                'pre'
            )
            ->orderBy('year')
            ->orderBy('semester')
            ->orderBy('code')
            ->get();

        // 4) get student grades and index by subject_id
        $grades = DB::table('grades')
            ->where('student_id', $student->id)
            ->pluck('overall', 'subject_id');

        // 5) normalize + attach grade
        $normalized = $subjects->map(function ($s) use ($grades) {
            // normalize semester: db can have "1", "2", "summer"
            $rawSem = strtolower((string) $s->semester);
            if ($rawSem === 'summer' || $rawSem === 'midyear' || $rawSem === '3') {
                $sem = 3;
            } else {
                $sem = (int) $s->semester;
            }

            return (object) [
                'id'          => $s->id,
                'code'        => $s->code,
                'title'       => $s->title,
                'year'        => (int) $s->year,
                'semester'    => $sem,
                'lecunit'     => $s->lecunit ?? 0,
                'labunit'     => $s->labunit ?? 0,
                'totalunit'   => $s->totalunit ?? 0,
                'pre'=> $s->prerequisite ?? 'None',
                'grade'       => $grades[$s->id] ?? null,
            ];
        });

        // 6) build grouped array EXACTLY like the school sheet
        $yearLabels = [
            1 => 'First Year',
            2 => 'Second Year',
            3 => 'Third Year',
            4 => 'Fourth Year',
        ];
        $semLabels = [
            1 => 'First Semester',
            2 => 'Second Semester',
            3 => 'Summer',
        ];

        $grouped = [];
        foreach ($yearLabels as $yearNum => $yearLabel) {
            $grouped[$yearLabel] = [];
            foreach ($semLabels as $semNum => $semLabel) {
                // filter subjects that match this year + sem
                $list = $normalized
                    ->where('year', $yearNum)
                    ->where('semester', $semNum)
                    ->values();

                if ($list->isNotEmpty()) {
                    $grouped[$yearLabel][$semLabel] = $list;
                }
            }
        }

        // 7) render PDF with the official-looking blade
        $pdf = Pdf::loadView('pdf.gradeslip', [
            'student'    => $student,
            'grouped'    => $grouped,
            'printedAt'  => now()->format('F d, Y'),
        ])->setPaper('legal', 'portrait');

        return $pdf->download('gradeslip-'.$student->studid.'.pdf');
    }

}
