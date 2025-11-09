<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureLoggedIn
{
    public function handle(Request $request, Closure $next, $requiredLevel = null)
    {
        $username = session('username');

        if (!$username) {
            // If request expects JSON (API / Axios), return 401
            if ($request->expectsJson()) {
                return response()->json(['message' => 'Unauthenticated.'], 401);
            }
            // Otherwise redirect to login
            return redirect('/');
        }

        // optional: check user level
        if ($requiredLevel) {
            $level = session('level') ?? null;
            // allow multiple accepted levels separated by pipe: admin|registrar
            $allowed = explode('|', $requiredLevel);
            if (!in_array($level, $allowed)) {
                abort(403, 'Forbidden');
            }
        }

        return $next($request);
    }
}
