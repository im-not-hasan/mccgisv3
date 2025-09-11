<?php

return [
    App\Providers\AppServiceProvider::class,
    app()->environment('local') ? Laravel\Pail\PailServiceProvider::class : null,
];
