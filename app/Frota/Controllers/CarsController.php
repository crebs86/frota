<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Models\Garage;
use App\Frota\Requests\CarRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;


class CarsController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Carros Ver', 'Carros Editar', 'Carros Apagar', 'Carros Criar')) {
            return Inertia::render('Frota/Cars/Index', [
                'cars' => Car::select('id', 'marca', 'modelo', 'placa', 'patrimonio', 'tombo', 'garagem_id', 'deleted_at')->with('garage')->withTrashed()->get()->toArray()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Carros Criar')) {
            return Inertia::render('Frota/Cars/Create', [
                'garages' => Garage::with('branch')->select('id')->get(),
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param CarRequest $carRequest
     * @param Car $car
     * 
     * @return Response
     */
    public function store(CarRequest $carRequest, Car $car): Response|RedirectResponse
    {
        if ($this->can('Carros Criar')) {

            if ($d = $car->create($carRequest->validated())) {
                return redirect(route('frota.cars.index'))->with('success', 'Carro adicionado!');
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar garagem');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Carros Ver', 'Carros Editar', 'Carros Apagar')) {
            return $this->showCarPage();
        }
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Carro Ver', 'Carro Editar', 'Carro Apagar')) {
            return $this->showCarPage($this->can('Carro Editar'));
        }
    }

    /**
     * @return Response
     */
    public function showCarPage($canEdit = false): Response
    {
        if ($this->can('Carro Ver', 'Carro Editar', 'Carro Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Cars/Show', [
                'garages' => Garage::with('branch')->select('id')->get(),
                'car' => Car::select('id', 'placa', 'marca', 'modelo', 'patrimonio', 'tombo', 'garagem_id', 'deleted_at')->where('id', request('car'))->with('garage')->get(),
                '_checker' => setGetKey(request('car'), 'edit_car'),
                'canEdit' => $canEdit
            ]);
        }
    }

    /**
     * @param CarRequest $request
     * @param Car $car
     * 
     * @return Response
     */
    public function update(CarRequest $request, Car $car): Response|RedirectResponse
    {
        if (
            (int) getKeyValue($request->_checker, 'edit_car') === request('car')->id
        ) {
            if ($this->can('Carros Editar', 'Carros Apagar')) {
                if ($car->update($request->validated())) {
                    return redirect()->back()->with(['car' => Car::where('id', request('car'))
                        ->select('id', 'marca', 'modelo', 'placa', 'patrimonio', 'tombo', 'garagem_id', 'deleted_at')
                        ->with('garage')->withTrashed()->get()->toArray(), 'aaa' => $car]);
                }
                return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados do veículo.');
            }
        }
        return Inertia::render('Admin/403');
    }
}
