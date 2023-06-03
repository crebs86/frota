<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use App\Models\User;
use Inertia\Inertia;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Http\Controllers\Controller;

class DriversController extends Controller
{
    use ACL, Helpers;

    public function index()
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Index', [
                'driver' => Driver::get()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function create()
    {
        if ($this->can('Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Create', [
                'users' => User::select('id', 'name')->get(),
                'garages' => Branch::select('id', 'name')->get(),
                'cars' => Car::select('id', 'placa', 'modelo')->get(),
            ]);
        }
        return Inertia::render('Admin/403');
    }
}
