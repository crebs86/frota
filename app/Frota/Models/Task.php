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
            ->where('date', request('date'))
            ->where(function ($query) {
                if (request()->route()->getName() === "frota.tasks.filter-routes"
                    || request()->route()->getName() === "frota.my-routes"
                    || request()->route()->getName() === "frota.tasks.filter"
                    || request()->route()->getName() === 'frota.routes.driver.edit'
                    || request()->route()->getName() === 'frota.request.store') {
                    return $query
                        ->where('type', 0)
                        ->orWhere(['type' => 1])
                        ->where(['status' => 1]);
                } elseif (request()->route()->getName() === "frota.requests.evaluate") {
                    return $query->where('type', '<>', 0);
                }
                return $query;
            })
            ->select('id', 'task', 'to', 'time', 'passengers', 'started_at', 'ended_at', 'duration', 'status', 'type', 'obs', 'date')
            ->orderBy('time')->with('branch', 'carsLog');
    }

    public function driver()
    {
        return $this->hasOne(Driver::class, 'id', 'driver')->select('id')->with('user');
    }
}
