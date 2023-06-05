<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use App\Http\Controllers\Controller;
use App\Frota\Requests\DriverRequest;
use Illuminate\Http\RedirectResponse;

class DriversController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Index', [
                'drivers' => Driver::with('user', 'garage', 'car')->select('id', 'garagem_id', 'carro_favorito', 'proprio', 'matricula', 'cnh', 'deleted_at')->withTrashed()->get()->toArray()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Create', [
                'users' => User::select('id', 'name')->get(),
                'garages' => Garage::with('branch')->select('id')->get(),
                'cars' => Car::select('id', 'placa', 'modelo')->get(),
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param DriverRequest $driverRequest
     * @param Driver $driver
     * 
     * @return Response
     */
    public function store(DriverRequest $driverRequest, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Criar')) {

            if ($d = $driver->create($driverRequest->validated())) {
                return redirect(route('drivers.index'))->with('success', 'Motorista adicionado!' . $d);
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar motorista');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Show', [
                'driver' => Driver::where('id', request('driver'))->with('user', 'garage', 'car')->get(),
                'garages' => Garage::with('branch')->select('id')->get(),
                'canEdit' => false
            ]);
        }
    }
}
