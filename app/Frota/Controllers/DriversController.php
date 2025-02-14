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
            $drivers = Driver::with('user', 'garage', 'car')->select('id', 'garagem_id', 'carro_favorito', 'proprio', 'matricula', 'cnh', 'deleted_at')->withTrashed()->get();
            return Inertia::render('Frota/Drivers/Index', [
                'drivers' => $drivers->where('user', '<>', null)->where('id', '<>', 2)->toArray()
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
                    ->whereKeyNot(
                        Arr::pluck(
                            Driver::withTrashed()->get(['id'])
                                ->toArray(), 'id'))
                    ->get(),
                'garages' => activeGarages(),
                'cars' => Car::select('id', 'placa', 'modelo')->get(),
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param DriverRequest $driverRequest
     * @param Driver $driver
     *
     * @return Response|RedirectResponse
     */
    public function store(DriverRequest $driverRequest, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Criar', 'Combustivel Administrar')) {
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
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar')) {
            return $this->showUserPage($this->can('Motorista Editar'));
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param bool $canEdit
     * @return Response
     */
    public function showUserPage(bool $canEdit = false): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            $driver = Driver::where('id', request('driver'))->with('user', 'garage', 'car')->withTrashed()->first();
            if ($driver?->user) {
                return Inertia::render('Frota/Drivers/Show', [
                    'driver' => $driver,
                    'garages' => activeGarages(),
                    'cars' => Car::select('id', 'placa', 'modelo')->get(),
                    '_checker' => setGetKey(request('driver'), 'edit_driver'),
                    'canEdit' => $canEdit
                ]);
            }
            return Inertia::render('Admin/403', [
                'message' => 'Usuário base do motorista está inativo. <a href ="' . route('admin.acl.users.show', $driver->id) . '" style="text-decoration:underline;">Ver</a>'
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param DriverRequest $request
     * @param Driver $driver
     *
     * @return Response|RedirectResponse
     */
    public function update(DriverRequest $request, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Editar')) {
            if ((int)getKeyValue($request->_checker, 'edit_driver') === (int)$request->driver->id) {
                if ($this->can('Motorista Editar')) {
                    $request->merge(['deleted_at' => $request->deleted_at ? now() : null]);
                    if ($driver->update($request->all())) {
                        if ($request->deleted_at) {
                            User::find($driver->id)->removeRole('Motorista');
                        } else {
                            $u = User::find($driver->id);
                            if (!$u->hasRole('Motorista')) {
                                $u->assignRole('Motorista');
                            }
                        }
                        return redirect()->back()->with(['driver' => Driver::where('id', request('driver'))->with('user', 'garage', 'car')->withTrashed()->get()]);
                    }
                    return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados do motorista.');
                }
            }
        }
        return Inertia::render('Admin/403');
    }
}
