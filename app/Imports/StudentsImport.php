<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
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
            // Hard fail: there must be an active AY
            $this->errors[] = "No active Academic Year found (ay.display = 1). Set one before importing.";
            // Skip processing entirely
            $this->skipped = count($rows);
            return;
        }

        // Try to infer semester text if table stores 1/2; adjust to your schema
        // If your ay table already has strings, just assign directly.
        $semesterVal = property_exists($active, 'semester') ? (string)$active->semester : '';
        // map 1/2 to labels if needed; otherwise pass through
        if ($semesterVal === '1') $semesterVal = '1ST';
        if ($semesterVal === '2') $semesterVal = '2ND';

        $ayText = property_exists($active, 'academicyear') ? (string)$active->academicyear : ((string)($active->ay ?? ''));

        foreach ($rows as $index => $row) {
            // Normalize incoming columns (no ay/semester in file)
            $data = [
                'studid'  => trim((string)($row['studid']  ?? '')),
                'fname'   => trim((string)($row['fname']   ?? '')),
                'lname'   => trim((string)($row['lname']   ?? '')),
                'mname'   => trim((string)($row['mname']   ?? '')),
                'email'   => trim((string)($row['email']   ?? '')),
                'course'  => trim((string)($row['course']  ?? '')),
                'year'    => trim((string)($row['year']    ?? '')),
                'section' => trim((string)($row['section'] ?? '')),
                'gender'  => trim((string)($row['gender']  ?? '')),
                'regular' => isset($row['regular']) && $row['regular'] !== '' ? (int)$row['regular'] : null,
            ];

            // Required: ALL of the above (since ay/semester are derived now)
            $required = array_keys($data);
            foreach ($required as $field) {
                if ($data[$field] === '' || $data[$field] === null) {
                    $this->skipped++;
                    $this->errors[] = "Row ".($index + 2)." missing required field: $field";
                    continue 2; // skip this row
                }
            }

            // Optional: normalize/validate a bit
            if (!in_array($data['regular'], [0,1], true)) {
                $this->skipped++;
                $this->errors[] = "Row ".($index + 2)." invalid 'regular' value (must be 0 or 1).";
                continue;
            }

            // If you want to restrict gender:
            // $allowedGender = ['M','F','Male','Female'];
            // if ($data['gender'] !== '' && !in_array($data['gender'], $allowedGender, true)) { ... }

            // Compose payload including derived fields
            $payload = $data + [
                'semester' => $semesterVal,
                'ay'       => $ayText,
            ];

            try {
                $exists = DB::table('student')->where('studid', $payload['studid'])->first();

                if ($exists) {
                    DB::table('student')->where('studid', $payload['studid'])->update($payload);
                    $this->updated++;
                } else {
                    DB::table('student')->insert($payload);
                    $this->inserted++;
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
