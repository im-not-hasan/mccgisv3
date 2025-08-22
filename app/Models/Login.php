<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Login extends Model
{
    protected $table = 'login'; // The name of the table

    // Optional: You can specify which fields can be mass-assigned if needed
    protected $fillable = ['Username', 'Password', 'Fullname', 'Level'];

    // Optionally, you can set other properties (like hidden fields, etc)
}
