<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use Illuminate\Support\Arr;
use App\Frota\Models\Garage;
use App\Http\Controllers\Controller;
use App\Frota\Requests\GarageRequest;
use Illuminate\Http\RedirectResponse;
use App\Http\Requests\Admin\BranchRequest;

class GaragesController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar', 'Garagem Criar')) {
            return Inertia::render('Frota/Garages/Index', [
                'garage' => garages()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Garagem Criar')) {
            return Inertia::render('Frota/Garages/Create', [
                'branches' => Branch::select('id', 'name', 'email', 'address', 'phones', 'notes')
                    ->whereKeyNot(Arr::pluck(Garage::withTrashed()->get(['id'])
                        ->toArray(), 'id'))
                    ->get()
            ]);
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

            if ($garage->create($garageRequest->validated())) {
                resetCache('activeGarages');
                resetCache('garages');
                return redirect()->back();
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
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar')) {
            return $this->showGaragePage();
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar')) {
            return $this->showGaragePage($this->can('Garagem Editar'));
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param bool $canEdit
     * @return Response
     */
    public function showGaragePage($canEdit = false): Response
    {
        if ($this->can('Garagem Ver', 'Garagem Editar', 'Garagem Apagar', 'Garagem Criar')) {
            return Inertia::render('Frota/Garages/Show', [
                'garage' => Garage::where('id', request('garage'))->select('id', 'deleted_at')->with('branch')->withTrashed()->get()->toArray(),
                '_checker' => setGetKey(request('garage'), 'edit_destroy_garage'),
                'canEdit' => $canEdit
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param GarageRequest $request
     * @param Garage $garage
     *
     * @return Response|RedirectResponse
     */
    public function update(GarageRequest $request, Garage $garage): Response|RedirectResponse
    {
        if (
            (int)getKeyValue($request->_checker, 'edit_destroy_garage')
            === $request->garage->id
        ) {
            if ($this->can('Garagem Editar', 'Garagem Apagar')) {
                if ($garage->restore()) {
                    resetCache('activeGarages');
                    resetCache('garages');
                    return redirect(route('frota.garages.index'));
                }
                return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados da garagem.');
            }
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param GarageRequest $request
     * @param Garage $garage
     *
     * @return Response|RedirectResponse
     */
    public function destroy(GarageRequest $request, Garage $garage): Response|RedirectResponse
    {
        if (
            (int)getKeyValue($request->_checker, 'edit_destroy_garage') === $request->garage->id
        ) {
            if ($this->can('Garagem Editar', 'Garagem Apagar')) {
                if ($garage->delete()) {
                    resetCache('activeGarages');
                    resetCache('garages');
                    return redirect(route('frota.garages.index'));
                }
                return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados da garagem.');
            }
        }
        return Inertia::render('Admin/403');
    }

    public function simpleBranch(BranchRequest $request, Branch $branch)
    {
        $b = $branch->create($request->validated());
        if ($b) {
            return response()->json('Nova Unidade criada.');
        }
    }
}
