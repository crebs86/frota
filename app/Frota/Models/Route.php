<?php

namespace App\Frota\Models;


use App\Models\Branch;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Route extends Model
{
    use HasFactory;

    protected $fillable = ['task', 'date', 'user', 'to', 'vacancy', 'obs_start', 'obs_end', 'time', 'started_at', 'endend_at'];

    public $timestamps = false;

    public function branch()
    {
        return $this->hasOne(Branch::class, 'id', 'to')->select('id', 'name');
    }

    public function taskData()
    {
        return $this->hasOne(Task::class, 'id', 'task')->select('id', 'date','driver')->with('driver');
    }
}
