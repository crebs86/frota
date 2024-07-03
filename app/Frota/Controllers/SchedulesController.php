<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use App\Frota\Models\Timetable;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Inertia\Inertia;


class SchedulesController extends Controller
{
    use ACL, Helpers;

    public function index()
    {
        return Inertia::render('Frota/Schedules/Index', []);
    }

    public function create()
    {
        return Inertia::render('Frota/Schedules/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }
}
