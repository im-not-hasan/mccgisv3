<?php

namespace App\Http\Controllers;

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

        $logs = DB::table('login_logs')
            ->orderByDesc('created_at')
            ->limit(100)
            ->get();

        return response()->json($logs);
    }

    public function geolocate(Request $request)
{
    $ip = $request->query('ip');
    if (!$ip) {
        return response()->json(['error' => 'Missing IP'], 400);
    }

    try {
        // ✅ Use ip-api.com instead — works without HTTPS or API key
        $url = "http://ip-api.com/json/{$ip}?fields=status,message,country,regionName,city,lat,lon,isp,query";
        $geo = @json_decode(file_get_contents($url), true);

        if (!$geo || $geo['status'] !== 'success') {
            return response()->json(['error' => 'Failed to fetch geolocation', 'response' => $geo], 500);
        }

        return response()->json([
            'ip' => $geo['query'],
            'country' => $geo['country'] ?? null,
            'region' => $geo['regionName'] ?? null,
            'city' => $geo['city'] ?? null,
            'latitude' => $geo['lat'] ?? null,
            'longitude' => $geo['lon'] ?? null,
            'org' => $geo['isp'] ?? null,
        ]);
    } catch (\Exception $e) {
        return response()->json(['error' => 'Lookup failed', 'message' => $e->getMessage()], 500);
    }
}


}
