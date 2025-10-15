<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class SanitizeInputMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next)
    {
        // Only sanitize non-file input data
        $input = $request->except(['password', 'password_confirmation', 'file', 'files']);

        foreach ($input as $key => $value) {
            if (is_string($value)) {
                // Trim leading/trailing whitespace
                $clean = trim($value);

                // Strip HTML and script tags
                $clean = strip_tags($clean);

                // Replace multiple spaces with a single one
                $clean = preg_replace('/\s+/', ' ', $clean);

                // If field becomes empty or only spaces, set to null
                if ($clean === '' || $clean === null) {
                    $clean = null;
                }

                $input[$key] = $clean;
            }
        }

        // Replace the sanitized input in the request
        $request->merge($input);

        return $next($request);
    }
}
