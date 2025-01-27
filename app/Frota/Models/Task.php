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
        return $this->hasMany(Route::class, 'task', 'id')
            ->where(function ($query) {
                if (request()->route()->getName() === "frota.tasks.filter-routes" || request()->route()->getName() === "frota.tasks.filter") {
                    return $query->where('type', 0);
                } elseif (false) {
                    return $query->where('type', '<>', 0);
                }
                return $query;
            })
            ->select('id', 'task', 'to', 'time', 'passengers', 'started_at', 'ended_at', 'duration', 'status', 'type')
            ->orderBy('time')->with('branch');
    }

    public function driver()
    {
        return $this->hasOne(Driver::class, 'id', 'driver')->select('id')->with('user');
    }
}
