<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\StreamedResponse;

class BackupController extends Controller
{
    public function download(Request $request)
    {
        // ✅ Verify user is admin
        $level = session('level') ?? session('user_level') ?? null;
        if (!$level && Auth::check()) {
            $level = Auth::user()->level ?? Auth::user()->role ?? null;
        }

        if ($level !== 'admin') {
            return redirect('/')->with('error', 'Unauthorized');
        }

        // ✅ Prepare filename
        $filename = 'mccgis_backup_' . now()->format('Y_m_d_His') . '.sql';

        // ✅ Stream database export directly to response
        return new StreamedResponse(function () {
            $pdo = DB::connection()->getPdo();
            $dbName = DB::getDatabaseName();

            echo "-- ==============================================\n";
            echo "-- MCCGISv3 Database Backup\n";
            echo "-- Database: {$dbName}\n";
            echo "-- Generated at: " . now() . "\n";
            echo "-- ==============================================\n\n";

            // 🔹 Fetch all tables
            $tables = $pdo->query('SHOW TABLES')->fetchAll(\PDO::FETCH_COLUMN);

            foreach ($tables as $table) {
                echo "-- --------------------------------------------------\n";
                echo "-- Table structure for `$table`\n";
                echo "-- --------------------------------------------------\n";

                // Drop + create table
                $createStmt = $pdo->query("SHOW CREATE TABLE `$table`")->fetch(\PDO::FETCH_ASSOC);
                echo "DROP TABLE IF EXISTS `$table`;\n";
                echo $createStmt['Create Table'] . ";\n\n";

                // Insert data rows
                $rows = $pdo->query("SELECT * FROM `$table`");
                foreach ($rows as $row) {
                    $values = array_map(function ($v) use ($pdo) {
                        return $v === null ? 'NULL' : $pdo->quote($v);
                    }, $row);

                    $columns = array_map(fn($col) => "`$col`", array_keys($row));

                    echo "INSERT INTO `$table` (" . implode(',', $columns) . ") VALUES (" . implode(',', $values) . ");\n";
                }

                echo "\n\n";
            }

            echo "-- ✅ Backup completed successfully.\n";
        }, 200, [
            'Content-Type' => 'application/sql',
            'Content-Disposition' => 'attachment; filename="' . $filename . '"',
        ]);
    }
}
