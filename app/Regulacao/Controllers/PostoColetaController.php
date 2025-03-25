<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Http\Controllers\Controller;
use App\Regulacao\Models\PostoColeta;
use App\Regulacao\Requests\PostoColetaRequest;
use Illuminate\Http\RedirectResponse;


class PostoColetaController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Regulacao/Financeiro/PostoColeta', [
                'postos' => postos()
            ]);
        }
        return Inertia::render('Admin/403');
    }
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Regulacao Criar')) {
            return Inertia::render('Regulacao/Financeiro/PostoColetaCriar', [
                'branches' => Branch::select('id', 'name', 'email', 'address', 'phones', 'notes')
                    ->whereKeyNot(1)
                    ->whereKeyNot(Arr::pluck(PostoColeta::withTrashed()->get(['id'])
                        ->toArray(), 'id'))
                    ->get()->each(function ($branch) {
                        $branch->hash = cripto($branch->id, 'branche');
                    })
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
    public function store(PostoColetaRequest $request): Response|RedirectResponse
    {
        if ($this->can('Regulacao Criar')) {
            if (PostoColeta::create(['id' => $request->id])) {
                resetCache('postos');
                return redirect()->back();
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar Posto de Coleta');
        }
        return Inertia::render('Admin/403');
    }

    /**
    public function show(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar')) {
            return $this->showGaragePage();
        }
        return Inertia::render('Admin/403');
    }


    public function edit(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar')) {
            return $this->showGaragePage($this->can('Regulacao Editar'));
        }
        return Inertia::render('Admin/403');
    }


    public function showGaragePage($canEdit = false): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Frota/Garages/Show', [
                'garage' => Garage::where('id', request('garage'))->select('id', 'deleted_at')->with('branch')->withTrashed()->get()->toArray(),
                '_checker' => setGetKey(request('garage'), 'edit_destroy_garage'),
                'canEdit' => $canEdit
            ]);
        }
        return Inertia::render('Admin/403');
    }


    public function update(GarageRequest $request, Garage $garage): Response|RedirectResponse
    {
        if (
            (int)getKeyValue($request->_checker, 'edit_destroy_garage')
            === $request->garage->id
        ) {
            if ($this->can('Regulacao Editar', 'Regulacao Apagar')) {
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


    public function destroy(GarageRequest $request, Garage $garage): Response|RedirectResponse
    {
        if (
            (int)getKeyValue($request->_checker, 'edit_destroy_garage') === $request->garage->id
        ) {
            if ($this->can('Regulacao Editar', 'Regulacao Apagar')) {
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
    }/** */
}
