<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
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
}
