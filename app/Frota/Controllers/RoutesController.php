<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Task;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use App\Http\Controllers\Controller;

class RoutesController extends Controller
{
    use ACL, Helpers;

    public function index(): Response
    {
        return Inertia::render('Frota/Routes/Index', [
            'branches' => Branch::all(['id', 'name']),
            'drivers' => Driver::select('id')->with('user')->get()->toArray()
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Frota/Routes/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function myRoutes(): Response
    {
        return Inertia::render('Frota/Routes/MyRoutes');
    }

    public function filter(Request $request)
    {
        $res = [];
        if ($request->branch) {
            $res = Task::select('id', 'driver', 'date')
                ->where('date', $request->date)->get()->toArray();
        } elseif ($request->driver) {
            $res = Task::select('id', 'driver', 'date')
                ->where('date', $request->date)
                ->where('driver', $request->driver)
                ->with('routes')
                ->get()->toArray();
        }
        dd($request->all(), $res);
    }
}
