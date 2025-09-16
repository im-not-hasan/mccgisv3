<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class ReCaptcha
{
    public static function verify(string $token, ?string $ip = null): array
    {
        $secret = config('services.recaptcha.secret');
        $min    = (float) (config('services.recaptcha.min_score') ?? 0.5);

        $resp = Http::asForm()->post('https://www.google.com/recaptcha/api/siteverify', [
            'secret'   => $secret,
            'response' => $token,
            'remoteip' => $ip,
        ])->json();

        $ok    = ($resp['success'] ?? false) === true;
        $score = (float) ($resp['score'] ?? 0);

        return [
            'ok'      => $ok && $score >= $min,
            'score'   => $score,
            'action'  => $resp['action'] ?? null,
            'raw'     => $resp,
        ];
    }
}
