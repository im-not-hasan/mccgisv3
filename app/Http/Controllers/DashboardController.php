<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Log;

class DashboardController extends Controller
{
    public function getCounts()
        {
            $level = Session::get('level');
            $username = Session::get('username');
            $counts = [];

            // 🟡 1. Get active semesters
            $activeSemesters = DB::table('ay')
                ->where('display', 1)
                ->pluck('semester')
                ->map(function ($s) {
                    return $s == 3 ? 'Summer' : (string) $s;
                })
                ->toArray();
            
            $curriculum = DB::table('curriculums')
                ->where('display',1)
                ->first();

            // 🟢 2. Basic Counts
            if ($level === 'admin' || $level === 'registrar') {
                $counts['students'] = DB::table('student')->count();
                $counts['teachers'] = DB::table('teacher')->count();
                $counts['class'] = DB::table('class')->count();
                $counts['subjects'] = DB::table('subject')
                    ->where('curriculum', $curriculum->curriculum)
                    ->whereIn('semester', $activeSemesters)
                    ->count();
            } elseif ($level === 'teacher') {
                // Get teacher's internal numeric ID from teachid (username)
                $teacherRecord = DB::table('teacher')->where('teachid', $username)->first();
                if ($teacherRecord) {
                    $teacherId = $teacherRecord->id;

                    // Subject count (distinct subject_ids assigned to this teacher)
                    $counts['subjects'] = DB::table('assignments')
                        ->where('teacher_id', $teacherId)
                        ->distinct('subject_id')
                        ->count('subject_id');

                    // Class count (distinct combinations of course + year + section)
                    $counts['class'] = DB::table('assignments')
                        ->where('teacher_id', $teacherId)
                        ->select('course', 'year', 'section')
                        ->distinct()
                        ->count();
                } else {
                    // If no matching teacher found, set counts to 0
                    $counts['subjects'] = 0;
                    $counts['class'] = 0;
                }
            }


                // If needed: students count for teacher (optional)
                // $counts['students'] = DB::table('student')->count();
            

            // 📝 3. Grading Compliance (TODO: Implement grading completeness logic here)
            // $grading = ['complete' => 0, 'incomplete' => 0];

            // 📊 4. Students per Course (for chart)
            $studentsPerCourse = DB::table('student')
                ->select('course', DB::raw('COUNT(*) as students'))
                ->groupBy('course')
                ->get()
                ->map(function ($row) {
                    return [
                        'course' => $row->course ?? 'N/A',
                        'students' => $row->students ?? 0,
                    ];
                });

            return response()->json([
                'counts' => $counts,
                'activeSemesters' => $activeSemesters,
                // 'grading' => $grading, // placeholder for future
                'studentsPerCourse' => $studentsPerCourse,
            ]);
        }


        public function studentDashboard(Request $request)
        {
            $studid = session('username');

            // Query directly using DB facade
            $student = DB::table('student')->where('studid', $studid)->first();

            if (!$student) {
                return response()->json(['error' => 'Student not found.'], 404);
            }

            $activeSemesters = DB::table('ay')->where('display', 1)->pluck('semester')->toArray();

            // Log::info('[studentDashboard] Returning student dashboard data', [
            //     'studid' => $studid,
            //     'student' => $student,
            //     'activeSemesters' => $activeSemesters,
            // ]);

            return response()->json([
                'student' => [
                    'fullname' => $student->fname . ' ' . $student->lname,
                    'id' => $student->studid,
                    'course' => $student->course,
                    'year' => $student->year,
                    'section' => $student->section
                ],
                'activeSemesters' => $activeSemesters,
            ]);
        }

        public function registrarDashboard(Request $request)
        {
            $TOR_requests = DB::table('tor_requests')->count();
            $activeSemesters = DB::table('ay')->where('display', 1)->pluck('semester')->toArray();
            $pendingRequests = DB::table('tor_requests')->where('status','pending')->count();

            return response()->json([
                'TOR_requests' => $TOR_requests,
                'activeSemesters' => $activeSemesters,
                'pendingRequests' => $pendingRequests,
            ]);
        }



}
