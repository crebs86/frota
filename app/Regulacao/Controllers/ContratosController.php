<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Regulacao\Models\Contrato;
use App\Http\Controllers\Controller;
use App\Regulacao\Requests\ContratosRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

class ContratosController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Contratos Ver', 'Contratos Editar', 'Contratos Apagar', 'Contratos Criar')) {
            return Inertia::render(
                'Regulacao/Contratos/Index',
                [
                    'contratos' => DB::table('contratos')->select('id', 'contrato', 'ano', 'ativo', 'contratada_nome', 'vigencia_fim')->get()->each(function ($item) {
                        $item->view = cripto($item->id, 'ver');
                        $item->id = cripto($item->id, 'editar');
                        return;
                    })
                ]
            );
        }
        return Inertia::render('Admin/403');
    }

    public function show(Request $request)
    {
        if ($this->can('Contratos Ver')) {
            return Inertia::render('Regulacao/Contratos/Show', [
                'contrato' => DB::table('contratos')->select('id', 'contrato', 'ano', 'ativo', 'contratada_nome', 'vigencia_fim')->where('id', cripto($request->contract, 'ver', 2))->get()->each(function ($item) {
                    $item->id = cripto($item->id, 'editar');
                    return;
                })
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function create(): Response
    {
        if ($this->can('Contratos Criar')) {
            return Inertia::render('Regulacao/Contratos/Create', [
                'editar' => false
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function store(ContratosRequest $request)
    {
        if ($this->can('Contratos Criar')) {
            $request->merge(['user' => auth()->id()]);
            $contrato = Contrato::create($request->except('valor'));
            return redirect(route('regulacao.contratos.edit', cripto($contrato->id, 'editar')));
        }
        return Inertia::render('Admin/403');
    }

    public function edit(Request $request): Response
    {
        if ($this->can('Contratos Editar', 'Contratos Apagar')) {
            $contrato = Contrato::find(cripto($request->contract, 'editar', 2));
            return Inertia::render('Regulacao/Contratos/Create', [
                'editar' => true,
                'contrato' => $contrato,
                'hash' => cripto($contrato->id, 'editar')
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function update(ContratosRequest $request): Response
    {
        if ($this->can('Contratos Editar', 'Contratos Apagar')) {
            $contrato = Contrato::find(cripto($request->contract, 'editar', 2));
            $contrato->update($request->except('valor', 'hash'));
            return Inertia::render('Regulacao/Contratos/Create', [
                'editar' => true,
                'contrato' => $contrato,
                'hash' => cripto($contrato->id, 'editar')
            ]);
        }
        return Inertia::render('Admin/403');
    }
}
