<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;

class StudentsController extends Controller
{
    public function getStudentStats()
    {
        // Get student counts by course
        $byCourse = DB::table('student')
            ->select('course', DB::raw('count(*) as count'))
            ->groupBy('course')
            ->pluck('count', 'course');

        // Get student counts by gender
        $genderCounts = DB::table('student')
            ->select('gender', DB::raw('count(*) as count'))
            ->groupBy('gender')
            ->pluck('count', 'gender');
        
        $byGender = [
            'male' => $genderCounts['Male'] ?? 0,
            'female' => $genderCounts['Female'] ?? 0,
        ];

        // Get total, male, female counts
        $total = DB::table('student')->count();
        $male = DB::table('student')->where('gender', 'Male')->count();
        $female = DB::table('student')->where('gender', 'Female')->count();

        return response()->json([
            'byCourse' => $byCourse,
            'byGender' => $byGender,
            'totals' => [
                'total' => $total,
                'male' => $male,
                'female' => $female,
            ],
        ]);
    }

    public function getAllStudents()
    {
        $students = DB::table('student')
            ->get();

        return response()->json($students);
    }

    public function getStudentsByCourse($course)
    {
        $students = DB::table('student')
            ->where('course', $course)
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



    public function destroy($id)
    {
        $student = DB::table('student')->where('id', $id)->first();
        \Log::info("Deleting student", ['studid' => $student->studid]);
        DB::table('irregstudentsubject')->where('student_id', $id)->delete();
        DB::table('student')->where('id', $id)->delete();
        DB::table('login')->where('username', $student->studid)->delete();
        return response()->json(['message' => 'Deleted']);
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

}
