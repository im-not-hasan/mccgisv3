<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LoginLogController extends Controller
{
    public function index(Request $request)
    {
        $level = session('level') ?? session('user_level');
        if ($level !== 'admin') {
            abort(403);
        }

        // Get recent 100 logs (or paginate if you prefer)
        $logs = DB::table('login_logs')
            ->orderByDesc('created_at')
            ->limit(100)
            ->get();

        return response()->json($logs);

    }
}
