<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\FromArray;

class StudentsTemplateExport implements FromArray, WithHeadings
{
    public function headings(): array
    {
        // All required fields (except ay/semester which are derived)
        return [
            'studid',
            'fname',
            'lname',
            'mname',
            'email',
            'course',
            'year',
            'section',
            'gender',
            'regular', // 1 = regular, 0 = irregular
        ];
    }

    public function array(): array
    {
        // Empty template (you can add a sample row if you want)
        return [
            
        ];
    }
}
