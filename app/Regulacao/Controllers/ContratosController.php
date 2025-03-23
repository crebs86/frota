<?php

namespace App\Regulacao\Controllers;

use App\Regulacao\Core\ContratoCore;
use App\Traits\ACL;
use Illuminate\Foundation\Application;
use Illuminate\Routing\Redirector;
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
    use ACL, Helpers, ContratoCore;

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
                'contrato' => DB::table('contratos')
                        ->select('contratos.id', 'contrato', 'ano', 'ativo', 'contratada_cnpj', 'contratada_nome', 'vigencia_inicio', 'vigencia_fim', 'valor_global', 'aditivos', 'contratante', 'descricao', 'users.name', 'contratos.created_at', 'contratos.updated_at')
                        ->join('users', 'user', '=', 'users.id')
                        ->where('contratos.id', cripto($request->contract, 'ver', 2))
                        ->get()->each(function ($item) {
                            $item->id = cripto($item->id, 'editar');
                            return;
                        })[0] ?? null
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

    /**
     * @param ContratosRequest $request
     * @return RedirectResponse|Response
     */
    public function store(ContratosRequest $request): Response|RedirectResponse
    {
        if ($this->can('Contratos Criar')) {
            $request->merge(['user' => auth()->id(), 'contratada_cnpj' => str_replace(['.', '/', '-'], '', $request->contratada_cnpj)]);
            $contrato = Contrato::create($request->except('valor', 'hash'));
            return redirect(route('regulacao.contratos.edit', cripto($contrato->id, 'editar')));
        }
        return Inertia::render('Admin/403');
    }

    public function edit(Request $request): Response
    {
        if ($this->can('Contratos Editar', 'Contratos Apagar')) {
            $contrato = collect(Contrato::find(cripto($request->contract, 'editar', 2)))->except('id')->all();
            return Inertia::render('Regulacao/Contratos/Create', [
                'editar' => true,
                'contrato' => $contrato,
                'hash' => cripto(cripto($request->contract, 'editar', 2), 'editar')
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function update(ContratosRequest $request): Response
    {
        if ($this->can('Contratos Editar', 'Contratos Apagar')) {
            $request->merge(['contratada_cnpj' => str_replace(['.', '/', '-'], '', $request->contratada_cnpj)]);
            $contrato = $this->getContrato(cripto($request->contract, 'editar', 2));
            $contrato->update(array_merge($request->except('valor', 'hash'), ['user' => auth()->id()]));
            return Inertia::render('Regulacao/Contratos/Create', [
                'editar' => true,
                'contrato' => $contrato,
                'hash' => cripto($contrato->id, 'editar')
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function aditivoInserir(Request $request): Response|RedirectResponse
    {
        if ($this->can('Contratos Editar')) {
            $contrato = $this->getContrato(cripto($request->contract, 'editar', 2));
            return $this->inserirAditivo($contrato, $request);
        }
        return Inertia::render('Admin/403');
    }

    public function aditivoAtualizar(Request $request): Response|RedirectResponse
    {
        if ($this->can('Contratos Editar')) {
            return $this->atualizarAditivo($request);
        }
        return Inertia::render('Admin/403');
    }
}
