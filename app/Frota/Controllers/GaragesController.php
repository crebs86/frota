<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Garage;
use App\Http\Controllers\Controller;
use App\Frota\Requests\GarageRequest;
use Illuminate\Http\RedirectResponse;

class GaragesController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar', 'Garagem Criar')) {
            return Inertia::render('Frota/Garagem/Index', [
                'garage' => Garage::with('branch')->withTrashed()->get()->toArray()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Gaaragem Criar')) {
            return Inertia::render('Frota/Garagem/Create', []);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param GarageRequest $garageRequest
     * @param Garage $garage
     * 
     * @return Response
     */
    public function store(GarageRequest $garageRequest, Garage $garage): Response|RedirectResponse
    {
        if ($this->can('Garagem Criar')) {

            if ($d = $garage->create($garageRequest->validated())) {
                return redirect(route('garages.index'))->with('success', 'Garagem adicionada!' . $d);
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
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar', 'Garagem Criar')) {
            return Inertia::render('Frota/Garagem/Show', []);
        }
    }
}
