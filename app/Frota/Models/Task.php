<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    use HasFactory;

    protected $fillable = ['driver', 'car', 'obs', 'date'];

    public $timestamps = false;

    public function routes()
    {
        return $this->hasMany(Route::class, 'task', 'id')->select('id', 'task', 'to', 'time', 'started_at', 'ended_at')->orderBy('time')->with('branch', 'carsLog');
    }

    public function driver()
    {
        return $this->hasOne(Driver::class, 'id', 'driver')->select('id')->with('user');
    }
}
