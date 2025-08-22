<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\StudentsTemplateExport;
use App\Imports\StudentsImport;

class StudentImportExportController extends Controller
{
    // Download a blank template with headers only
    public function exportTemplate(Request $request)
    {
        $filename = 'students_template.xlsx';
        return Excel::download(new StudentsTemplateExport, $filename);
    }

    // Upload a filled template and insert/update students
    public function import(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:xlsx,csv,txt'
        ]);

        try {
            $importer = new StudentsImport();
            Excel::import($importer, $request->file('file'));

            return response()->json([
                'message' => 'Import completed',
                'inserted' => $importer->inserted,
                'updated' => $importer->updated,
                'skipped' => $importer->skipped,
                'errors'   => $importer->errors, // array of row-level issues
            ]);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Import failed',
                'error' => $e->getMessage(),
            ], 422);
        }
    }
}
