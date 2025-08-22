<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;
use App\Imports\InstructorLoadsImport;
use PhpOffice\PhpSpreadsheet\IOFactory;

class InstructorLoadImportController extends Controller
{
    public function import(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:xlsx,xls,csv'
        ]);

        $uploaded = $request->file('file');
        $path = $uploaded->getRealPath();

        // 1) Detect sheet count using PhpSpreadsheet (fast & reliable)
        $reader = IOFactory::createReaderForFile($path);
        $reader->setReadDataOnly(true);
        $spreadsheet = $reader->load($path);
        $sheetCount = $spreadsheet->getSheetCount();
        $spreadsheet->disconnectWorksheets();
        unset($spreadsheet);

        // 2) Pass sheet count to the importer
        $importer = new InstructorLoadsImport($sheetCount);

        // 3) Do the import (Laravel-Excel)
        Excel::import($importer, $uploaded);

        return response()->json([
            'message'  => 'Import completed',
            'inserted' => $importer->inserted,
            'updated'  => $importer->updated,
            'skipped'  => $importer->skipped,
            'errors'   => $importer->errors,
        ]);
    }
}