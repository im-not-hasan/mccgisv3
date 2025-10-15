<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SecureHeadersMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        // ✅ Universal secure headers (good for both local + production)
        $headers = [
            // Prevent clickjacking
            'X-Frame-Options' => 'SAMEORIGIN',

            // Disable MIME sniffing
            'X-Content-Type-Options' => 'nosniff',

            // Basic XSS protection
            'X-XSS-Protection' => '1; mode=block',

            // HSTS (enforces HTTPS for one year)
            'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains; preload',

            // Limit referrer info
            'Referrer-Policy' => 'strict-origin-when-cross-origin',

            // Hide PHP version header
            'X-Powered-By' => 'MCCGISv3',

            // 🔒 Content Security Policy
            // Allows your app to run in local Vite dev mode + Hostinger prod without issues
            'Content-Security-Policy' => "
                default-src 'self' data: blob:;
                img-src 'self' data: blob:;
                font-src 'self' https://fonts.bunny.net;
                style-src 'self' 'unsafe-inline' https://fonts.bunny.net;
                script-src 'self' 'unsafe-inline' 'unsafe-eval'
                    https://www.google.com/recaptcha/
                    https://www.gstatic.com/
                    http://localhost:5173
                    http://127.0.0.1:5173
                    http://[::1]:5173;
                connect-src 'self'
                    ws://localhost:5173
                    ws://127.0.0.1:5173
                    ws://[::1]:5173
                    https://www.google.com/recaptcha/
                    https://www.gstatic.com/;
                frame-src 'self' https://www.google.com/recaptcha/ https://www.gstatic.com/;
                object-src 'none';
            ",
        ];

        foreach ($headers as $key => $value) {
            // Compress multiline CSP into one clean header line
            $response->headers->set($key, preg_replace('/\s+/', ' ', trim($value)));
        }

        return $response;
    }
}
