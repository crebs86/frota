<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Driver;
use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use App\Models\Branch;

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

    public function myRoutes(): Response
    {
        return Inertia::render('Frota/Routes/MyRoutes');
    }
}
