{{-- resources/views/pdf/gradeslip_official.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Grade Slip</title>
    <style>
        @page { margin: 40px 40px; }
        body {
            font-family: DejaVu Sans, sans-serif;
            font-size: 11px;
            color: #000;
        }
        .header {
            text-align: center;
            margin-bottom: 10px;
        }
        .course-title {
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            margin-top: 4px;
        }
        .subhead {
            text-align: center;
            font-size: 10px;
            margin-top: 4px;
            line-height: 1.3;
        }
        .year-title {
            font-weight: bold;
            text-transform: uppercase;
            text-align: center;
            margin-top: 5px;
            margin-bottom: 4px;
            font-size: 12px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 12px;
        }
        th, td {
            border: 1px solid #000;
            padding: 3px 5px;
            font-size: 10px;
        }
        th {
            background: #f3f3f3;
            font-weight: bold;
        }
        .semester-row {
            background: #e9e9e9;
            font-weight: bold;
            text-align: left;
        }
        .totals-row td {
            font-weight: bold;
            text-align: right;
        }
        .footer {
            margin-top: 25px;
            font-size: 9px;
            text-align: right;
        }
        .logo {
            width: 100%;
            max-height: 70px;
            object-fit: contain;
            margin-bottom: 6px;
        }
    </style>
</head>
<body>
    {{-- top header image --}}
    <div class="header" style="margin-top:-30px;">
        {{-- make sure /public/header.png exists --}}
        <img src="{{ public_path('header.png') }}" alt="Header" class="logo">
        @php
            // map course code to long program name
            $program = match (strtoupper($student->course ?? '')) {
                'BSIT' => 'BACHELOR OF SCIENCE IN INFORMATION TECHNOLOGY',
                'BSBA' => 'BACHELOR OF SCIENCE IN BUSINESS ADMINISTRATION',
                'BSHM' => 'BACHELOR OF SCIENCE IN HOSPITALITY MANAGEMENT',
                'BSED' => 'BACHELOR OF SECONDARY EDUCATION',
                'BEED' => 'BACHELOR OF ELEMENTARY EDUCATION',
                default => 'BACHELOR PROGRAM',
            };
        @endphp
        <div class="course-title">
            {{ $program }}
        </div>
        <div class="subhead">
            Effective Academic Year 2024–2025 <br>
            Revised Curriculum || Date of Revision: April 2024 <br>
            {{ $student->lname }}, {{ $student->fname }} {{ $student->mname }}
        </div>
    </div>

    @foreach($grouped as $year => $semesters)
        <div class="year-title">{{ strtoupper($year) }}</div>

        @foreach($semesters as $semester => $subjects)
            <table>
                <thead>
                    <tr>
                        <td colspan="7" class="semester-row">
                            {{ strtoupper($semester) }}
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 90px;">Subject Code</th>
                        <th>Descriptive Title</th>
                        <th style="width: 45px; text-align:center;">Lec Unit</th>
                        <th style="width: 45px; text-align:center;">Lab Unit</th>
                        <th style="width: 55px; text-align:center;">Total Units</th>
                        <th style="width: 85px; text-align:center;">Pre-requisites</th>
                        <th style="width: 45px; text-align:center;">Grade</th>
                    </tr>
                </thead>
                <tbody>
                    @php $totalUnits = 0; @endphp
                    @foreach($subjects as $s)
                        @php $totalUnits += $s->totalunit ?? 0; @endphp
                        <tr>
                            <td>{{ $s->code }}</td>
                            <td>{{ $s->title }}</td>
                            <td style="text-align:center;">{{ $s->lecunit ?? 0 }}</td>
                            <td style="text-align:center;">{{ $s->labunit ?? 0 }}</td>
                            <td style="text-align:center;">{{ $s->totalunit ?? 0 }}</td>
                            <td style="text-align:center;">{{ $s->prerequisite ?? 'None' }}</td>
                            <td style="text-align:center;">
                                @if(isset($s->grade) && is_numeric($s->grade))
                                    {{ number_format(round($s->grade, 1), 1) }}
                                @endif
                            </td>
                        </tr>
                    @endforeach
                    <tr class="totals-row">
                        <td colspan="4" style="text-align:right;">TOTAL</td>
                        <td>{{ $totalUnits }}</td>
                        <td colspan="2"></td>
                    </tr>
                </tbody>
            </table>
        @endforeach
    @endforeach

    <div class="footer">
        Printed: {{ $printedAt }}
    </div>
</body>
</html>
