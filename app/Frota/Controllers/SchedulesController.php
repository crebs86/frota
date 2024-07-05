<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use App\Frota\Models\Schedule;
use App\Frota\Models\Timetable;
use App\Frota\Requests\ScheduleRequest;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Inertia\Inertia;
use stdClass;

class SchedulesController extends Controller
{
    use ACL, Helpers;

    public function index(Schedule $schedule)
    {
        return Inertia::render('Frota/Schedules/Index', [
            'schedule' => $schedule->select('driver')->with('driverName')->get()
        ]);
    }

    public function create()
    {
        return Inertia::render('Frota/Schedules/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function store(ScheduleRequest $request, Schedule $schedule)
    {
        $req = new stdClass();
        $req->driver = $request->driver_id;
        $req->morning_start = $request->timeMorningStart['time'] ?? null;
        $req->morning_end = $request->timeMorningEnd['time'] ?? null;
        $req->afternoon_start = $request->timeAfternoonStart['time'] ?? null;
        $req->afternoon_end = $request->timeAfternoonEnd['time'] ?? null;
        $req->night_start = $request->timeNightStart['time'] ?? null;
        $req->night_end = $request->timeNightEnd['time'] ?? null;
        $req->special_start = $request->timeSpecialStart['time'] ?? null;
        $req->special_end = $request->timeSpecialEnd['time'] ?? null;

        $schedule->create(get_object_vars($req));

        return redirect(route('frota.schedules.index'));
    }
}
