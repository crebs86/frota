<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use Illuminate\Support\Arr;
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
                'users' => User::select('id', 'name')
                    ->whereKeyNot(Arr::pluck(Driver::all('id')
                        ->toArray(), 'id'))
                    ->get(),
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

                $user = User::find($driverRequest->id);
                $user->assignRole('Motorista');

                return redirect(route('frota.drivers.index'))->with('success', 'Motorista adicionado!' . $d);
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar motorista.');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar')) {
            return $this->showUserPage();
        }
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar')) {
            return $this->showUserPage($this->can('Motorista Editar'));
        }
    }

    /**
     * @return Response
     */
    public function showUserPage($canEdit = false): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Show', [
                'driver' => Driver::where('id', request('driver'))->with('user', 'garage', 'car')->get(),
                'garages' => Garage::with('branch')->select('id')->get(),
                'cars' => Car::select('id', 'placa', 'modelo')->get(),
                '_checker' => setGetKey(request('driver'), 'edit_driver'),
                'canEdit' => $canEdit
            ]);
        }
    }

    /**
     * @param DriverRequest $request
     * @param Driver $driver
     * 
     * @return Response
     */
    public function update(DriverRequest $request, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Editar')) {
            if ((int) getKeyValue($request->_checker, 'edit_driver') === (int) $request->driver->id) {
                if ($this->can('Motorista Editar')) {
                    if ($driver->update($request->validated())) {
                        return redirect()->back()->with(['driver' => Driver::where('id', request('driver'))->with('user', 'garage', 'car')->get()]);
                    }
                    return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados do motorista.');
                }
            }
        }
        return Inertia::render('Admin/403');
    }
}
