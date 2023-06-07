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
                return redirect(route('cars.index'))->with('success', 'Carro adicionado!');
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
        if ($this->can('Carros Ver', 'Carros Editar', 'Carros Apagar', 'Carros Criar')) {
            return Inertia::render('Frota/Cars/Show', [
                'car' => Car::where('id', request('car'))->select('id', 'marca', 'modelo', 'placa', 'patrimonio', 'tombo', 'garagem_id', 'deleted_at')->with('garage')->withTrashed()->get()->toArray()
            ]);
        }
    }
}
