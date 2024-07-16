<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Route extends Model
{
    use HasFactory;

    protected $fillable = ['task', 'date', 'user', 'to', 'vacancy', 'order', 'time', 'started_at', 'endend_at'];

    public $timestamps = false;
}
