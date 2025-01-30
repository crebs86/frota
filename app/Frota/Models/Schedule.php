<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Schedule extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['driver', 'morning_start', 'morning_end', 'afternoon_start', 'afternoon_end', 'night_start', 'night_end', 'special_start', 'special_end'];

    public $primaryKey = 'driver';

    public function driverName()
    {
        return $this->hasOne(Driver::class, 'id', 'driver')->select('id')->with('user');
    }
}
