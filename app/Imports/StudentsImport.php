<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
// use Illuminate\Support\Facades\Hash;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class StudentsImport implements ToCollection, WithHeadingRow
{
    public int $inserted = 0;
    public int $updated  = 0;
    public int $skipped  = 0;
    public array $errors = [];

    public function collection(Collection $rows)
    {
        // Get active AY/semester once
        $active = DB::table('ay')->where('display', 1)->first();

        if (!$active) {
            $this->errors[] = "No active Academic Year found (ay.display = 1). Set one before importing.";
            $this->skipped = count($rows);
            return;
        }

        // Normalize semester text
        $semesterVal = (string)($active->semester ?? '');
        if ($semesterVal === '1') $semesterVal = 'First Semester';
        if ($semesterVal === '2') $semesterVal = 'Second Semester';

        $ayText = (string)($active->academicyear ?? ($active->ay ?? ''));

        foreach ($rows as $index => $row) {

            $data = [
                'studid'  => trim((string)($row['studid']  ?? '')),
                'fname'   => trim((string)($row['fname']   ?? '')),
                'lname'   => trim((string)($row['lname']   ?? '')),
                'mname'   => ($row['mname'] ?? '') === '' ? ' ' : trim((string)$row['mname']),
                'email'   => trim((string)($row['email']   ?? '')),
                'course'  => trim((string)($row['course']  ?? '')),
                'year'    => trim((string)($row['year']    ?? '')),
                'section' => trim((string)($row['section'] ?? '')),
                'gender'  => trim((string)($row['gender']  ?? '')),
                'regular' => isset($row['regular']) && $row['regular'] !== '' ? (int)$row['regular'] : null,
            ];

            // Validate required fields
            $requiredFields = ['studid', 'fname', 'lname', 'email', 'course', 'year', 'section', 'gender', 'regular'];
            
            foreach ($requiredFields as $field) {
            if ($data[$field] === '' || $data[$field] === null) {
                $this->skipped++;
                $this->errors[] = "Row ".($index + 2)." missing required field: $field";
                continue 2;
            }
        }

            // Validate regular flag
            if (!in_array($data['regular'], [0, 1], true)) {
                $this->skipped++;
                $this->errors[] = "Row ".($index + 2)." invalid 'regular' value (must be 0 or 1)";
                continue;
            }

            // Merge semester + ay fields
            $payload = $data + [
                'semester' => $semesterVal,
                'ay'       => $ayText,
            ];

            try {
                /** ------------------------------
                 *   STUDENT TABLE INSERT/UPDATE
                 *  ------------------------------ */
                $exists = DB::table('student')->where('studid', $payload['studid'])->first();

                if ($exists) {
                    DB::table('student')->where('studid', $payload['studid'])->update($payload);
                    $this->updated++;
                } else {
                    DB::table('student')->insert($payload);
                    $this->inserted++;
                }

                /** ------------------------------
                 *   LOGIN TABLE SYNC
                 *  ------------------------------ */
                $fullname = trim($payload['fname'] . ' ' . $payload['lname']);

                $login = DB::table('login')->where('username', $payload['studid'])->first();

                if ($login) {
                    // Update metadata only; do NOT reset password
                    DB::table('login')
                        ->where('id', $login->id)
                        ->update([
                            'fullname' => $fullname,
                            'level'    => 'student'
                        ]);
                } else {
                    // Insert new login credentials with bcrypt password
                    DB::table('login')->insert([
                        'username'   => $payload['studid'],
                        'password'   => $payload['studid'], // plain text- login logic will hash later
                        'fullname'   => $fullname,
                        'level'      => 'student',
                        'disabled'   => 0,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }

            } catch (\Throwable $e) {
                $this->skipped++;
                $this->errors[] = "Row ".($index + 2)." error: ".$e->getMessage();
            }
        }
    }

    public function headingRow(): int
    {
        return 1;
    }
}
