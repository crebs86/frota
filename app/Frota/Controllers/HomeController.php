<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Timetable;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use App\Models\Branch;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Arr;
use Inertia\Inertia;

class HomeController extends Controller
{
    use ACL, Helpers;

    public function index()
    {
        $drivers = Driver::count();
        $cars = Car::count();
        return Inertia::render('Frota/Home', [
            'drivers_count' => $drivers,
            'cars_count' => $cars
        ]);
    }

    public function loadData(): JsonResponse
    {
        return response()->json([
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::select('time')->get()->toArray(), 'time')
        ]);
    }

    public function loadBranches(): JsonResponse
    {
        return response()->json(Branch::select('id', 'name')->get());
    }
}
