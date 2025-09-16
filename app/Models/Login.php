<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class Login extends Authenticatable
{
    protected $table = 'login';
    protected $primaryKey = 'id';
    public $timestamps = false;

    // Use the actual column names in your table (lowercase vs. uppercase matters!)
    protected $fillable = ['username', 'password', 'fullname', 'level'];

    protected $hidden = ['password'];

    // If your `login` table does NOT have remember_token, disable it:
    protected $rememberTokenName = null;

    // (Optional) If you ever use guards that expect an email field, you can ignore;
    // You’re logging users in manually (Auth::login($user)), so this is enough.
}
