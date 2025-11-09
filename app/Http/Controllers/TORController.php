<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class TORController extends Controller
{
    public function requestTOR(Request $request)
    {
        $request->validate([
            'password' => 'required|string',
        ]);

        $studentUsername = session('username');
        if (!$studentUsername) {
            return response()->json(['error' => 'not_logged_in'], 401);
        }

        // Find student in login table
        $student = DB::table('login')->where('username', $studentUsername)->first();
        if (!$student) {
            return response()->json(['error' => 'student_not_found'], 404);
        }

        // Verify password
        if (!Hash::check($request->password, $student->password)) {
            return response()->json(['error' => 'wrong_password'], 401);
        }

        // Check cooldown (14 days after last completed TOR)
        $cooldownDays = 14;
        $recentCompleted = DB::table('tor_requests')
            ->where('student_id', $student->username)
            ->where('status', 'completed')
            ->where('completed_at', '>=', now()->subDays($cooldownDays))
            ->first();

        if ($recentCompleted) {
            return response()->json([
                'error'   => 'cooldown',
                'message' => "You can only request a new TOR {$cooldownDays} days after your last completed request."
            ], 429);
        }

        // Check if they already have a pending/processing request
        $existing = DB::table('tor_requests')
            ->where('student_id', $student->username)
            ->whereIn('status', ['pending', 'processing'])
            ->first();

        if ($existing) {
            return response()->json([
                'error'   => 'duplicate',
                'message' => 'You already have a TOR request that is still pending or processing.'
            ], 409);
        }

        // Insert new TOR request (✅ only valid columns from your schema)
        DB::table('tor_requests')->insert([
            'student_id'   => $student->username,
            'status'       => 'pending',
            'requested_at' => now(),
            'processed_at' => null,
            'completed_at' => null,
            'remarks'      => null,
        ]);

        return response()->json(['success' => true, 'message' => 'TOR request submitted successfully.']);
    }

    public function allRequests()
    {
        $requests = DB::table('tor_requests as r')
            ->join('student as s', 's.studid', '=', 'r.student_id')
            ->select(
                'r.id',
                'r.student_id',
                's.lname',
                's.fname',
                's.mname',
                'r.status',
                'r.requested_at',
                's.gender'
            )
            ->orderBy('r.requested_at', 'desc')
            ->get();

        \Log::info('[allRequests] Returning TOR requests', [
            'count' => $requests->count(),
            'sample' => $requests->first()
        ]);
        return response()->json($requests);
    }

    public function updateStatus(Request $request, $id)
    {
        $status = $request->input('status');

        // Validate allowed statuses
        if (!in_array($status, ['pending', 'processing', 'completed'])) {
            return response()->json(['error' => 'Invalid status'], 400);
        }

        DB::table('tor_requests')
            ->where('id', $id)
            ->update([
                'status' => $status,
                'processed_at' => $status === 'processing' ? now() : null,
                'completed_at' => $status === 'completed' ? now() : null,
            ]);

        // \Log::info("TOR Request #$id updated to $status");

        return response()->json(['success' => true, 'status' => $status]);
    }

    public function getStudentInfo($id)
    {
        try {
            $info = DB::table('tor_student_info')
                ->where('tor_request_id', $id)
                ->first();

            \Log::info('[TORController@getStudentInfo] Fetching student info', [
                'tor_request_id' => $id,
                'found' => $info ? true : false,
            ]);

            return response()->json($info ?: []);
        } catch (\Exception $e) {
            \Log::error('[TORController@getStudentInfo] Error', [
                'message' => $e->getMessage(),
            ]);
            return response()->json(['error' => 'Server error'], 500);
        }
    }

    public function saveStudentInfo(Request $request)
    {
        try {
            // 🔍 Log the raw incoming request
            // \Log::info('[TORController@saveStudentInfo] Incoming request', [
            //     'payload' => $request->all()
            // ]);

            $validated = $request->validate([
                'tor_request_id'      => 'required|integer|exists:tor_requests,id',
                'surname'             => 'required|string|max:50',
                'firstname'           => 'required|string|max:50',
                'middlename'          => 'nullable|string|max:50',
                'course'              => 'nullable|string|max:20',
                'dob_month'           => 'nullable|string|max:20',
                'dob_day'             => 'nullable|string|max:5',
                'dob_year'            => 'nullable|string|max:10',
                'place_of_birth'      => 'nullable|string|max:150',
                'civil_status'        => 'nullable|string|max:20',
                'citizenship'         => 'nullable|string|max:50',
                'religion'            => 'nullable|string|max:50',
                'sex'                 => 'nullable|string|max:10',
                'intermediate_sy'     => 'nullable|string|max:20',
                'intermediate_school' => 'nullable|string|max:150',
                'highschool_sy'       => 'nullable|string|max:20',
                'highschool_school'   => 'nullable|string|max:150',
                'guardian_name'       => 'nullable|string|max:100',
                'student_number'      => 'nullable|string|max:30',
                'date_enrolled'       => 'nullable|string|max:50',
                'home_address'        => 'nullable|string|max:255',
                'picture'             => 'nullable|string',
            ]);
            
            if (!empty($validated['student_number'])) {
                $student = DB::table('student')
                    ->select('course')
                    ->where('studid', $validated['student_number'])
                    ->first();

                if ($student) {
                    $validated['course'] = $student->course;
                }
            }

            // \Log::info('[TORController@saveStudentInfo] Validated data', [
            //     'validated' => $validated
            // ]);

            if (!empty($validated['picture'])) {
                // ✅ Keep as base64 string, no decode
                // Ensure it has no prefix like "data:image/jpeg;base64,"
                $validated['picture'] = preg_replace('/^data:image\/\w+;base64,/', '', $validated['picture']);
            }


            $existing = DB::table('tor_student_info')
                ->where('tor_request_id', $validated['tor_request_id'])
                ->first();

            if ($existing) {
                DB::table('tor_student_info')
                    ->where('tor_request_id', $validated['tor_request_id'])
                    ->update($validated);

                \Log::info('[TORController@saveStudentInfo] Updated existing record', [
                    'id' => $existing->id
                ]);
            } else {
                DB::table('tor_student_info')->insert($validated);
                \Log::info('[TORController@saveStudentInfo] Inserted new record');
            }

            return response()->json([
                'success' => true,
                'message' => 'Student info saved successfully.'
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            \Log::error('[TORController@saveStudentInfo] Validation failed', [
                'errors' => $e->errors()
            ]);
            throw $e; // still return 422 with errors to frontend
        } catch (\Exception $e) {
            \Log::error('[TORController@saveStudentInfo] Exception', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Unexpected server error: ' . $e->getMessage()
            ], 500);
        }
    }

    public function print($request_id)
    {
        try {
            // Get tor_request + student basic link
            $torReq = DB::table('tor_requests')->where('id', $request_id)->first();
            if (!$torReq) {
                abort(404, 'TOR request not found');
            }

            // Student record (by studid)
            $studentRow = DB::table('student')
                ->where('studid', $torReq->student_id)
                ->first();

            $student_pk = $studentRow?->id;

            // Student info (manual form) — fallback to student table if empty
            $info = DB::table('tor_student_info')
                ->where('tor_request_id', $request_id)
                ->first();

            $studentInfo = (object) [
                'student_number'      => $info->student_number      ?? ($studentRow->studid ?? ''),
                'surname'             => $info->surname             ?? ($studentRow->lname ?? ''),
                'firstname'           => $info->firstname           ?? ($studentRow->fname ?? ''),
                'middlename'          => $info->middlename          ?? ($studentRow->mname ?? ''),
                'course'              => $info->course              ?? ($studentRow->course ?? ''),
                'dob_month'           => $info->dob_month           ?? '',
                'dob_day'             => $info->dob_day             ?? '',
                'dob_year'            => $info->dob_year            ?? '',
                'place_of_birth'      => $info->place_of_birth      ?? '',
                'civil_status'        => $info->civil_status        ?? '',
                'citizenship'         => $info->citizenship         ?? '',
                'religion'            => $info->religion            ?? '',
                'sex'                 => $info->sex                 ?? ($studentRow->gender ?? ''),
                'intermediate_sy'     => $info->intermediate_sy     ?? '',
                'intermediate_school' => $info->intermediate_school ?? '',
                'highschool_sy'       => $info->highschool_sy       ?? '',
                'highschool_school'   => $info->highschool_school   ?? '',
                'guardian_name'       => $info->guardian_name       ?? '',
                'home_address'        => $info->home_address        ?? '',
                'date_enrolled'       => $info->date_enrolled       ?? '',
                'picture'             => $info->picture             ?? null,
            ];

            // Fetch grades with subject + AY
            $gradeRows = [];
            if ($student_pk) {
                $gradeRows = DB::table('grades as g')
                    ->join('subject as s', 'g.subject_id', '=', 's.id')
                    ->join('ay as a', 'g.ay_id', '=', 'a.id')
                    ->where('g.student_id', $student_pk)
                    ->select(
                        'g.overall as rating',
                        's.code',
                        's.title',
                        DB::raw('COALESCE(s.totalunit, "0") as units'),
                        'a.academicyear',
                        DB::raw('COALESCE(a.semester, "") as ay_semester')
                    )
                    ->orderBy('a.academicyear')
                    ->orderBy('a.semester')
                    ->orderBy('s.code')
                    ->get();
            }

            // Group into AY + Semester buckets
            $grouped = [];
            foreach ($gradeRows as $row) {
                $semLabel = $this->semesterDisplay($row->ay_semester);
                $key = $semLabel . ', ' . $row->academicyear;

                if (!isset($grouped[$key])) {
                    $grouped[$key] = [];
                }

                $remarks = '';
                if ($row->rating !== null) {
                    $remarks = $row->rating > 3.0 ? 'Failed' : 'Passed';
                }

                $grouped[$key][] = (object) [
                    'code'    => $row->code,
                    'title'   => $row->title,
                    'rating'  => $row->rating,
                    'reexam'  => '', // always blank
                    'units'   => $row->units,
                    'remarks' => $remarks,
                ];
            }

            $college = (object)[
                'country'  => 'Republic of the Philippines',
                'province' => 'Province of Cebu',
                'municipal'=> 'Municipality of Madridejos',
                'name'     => 'Madridejos Community College',
                'office'   => 'OFFICE OF THE REGISTRAR',
                'address'  => 'Bunakan, Madridejos, Cebu',
                'email'    => 'madrccollege@municipality.com',
            ];

            $footer = (object)[
                'prepared_by'     => 'RENO R. SEVILLAO',
                'registrar'       => 'ROBERTO CARATAO',
                'registrar_title' => 'College Registrar',
            ];

            return inertia('TORPrintTemplate', [
                'studentInfo' => $studentInfo,
                'grouped'     => $grouped,
                'torReq'      => $torReq,
                'college'     => $college,
                'footer'      => $footer,
                'pageNo'      => 1,
            ]);
        } catch (\Exception $e) {
            \Log::error('[TORController@print] Exception', [
                'message' => $e->getMessage(),
                'trace'   => $e->getTraceAsString(),
            ]);
            abort(500, 'Server error while preparing TOR.');
        }
    }


    /** Semester mapping helper */
    private function semesterDisplay($sem)
    {
        // Accepts int strings ("1","2") or text ("First","Second","Summer")
        $s = strtolower(trim((string)$sem));
        if ($s === '1' || str_starts_with($s, '1') || str_contains($s, 'first'))  return 'First Semester';
        if ($s === '2' || str_starts_with($s, '2') || str_contains($s, 'second')) return 'Second Semester';
        if (str_contains($s, 'summer')) return 'Summer';
        return ucfirst($sem) . ','; // fallback, keep comma so it matches sample
    }

    /** Simple pass/fail (Passed if numeric <= 3.0) when remarks empty */
    private function passFailFromNumeric($rating)
    {
        if ($rating === null || $rating === '') return '';
        $n = floatval($rating);
        if ($n <= 0) return '';
        return $n <= 3.0 ? 'Passed' : 'Failed';
    }



}
