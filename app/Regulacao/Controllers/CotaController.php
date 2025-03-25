<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use App\Regulacao\Models\Contrato;
use App\Regulacao\Models\CotaFinanceira;
use App\Regulacao\Models\PostoColeta;


class CotaController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Regulacao/Financeiro/Cotas', [
                'postos_coleta' => PostoColeta::join('branches', 'postos_coleta.id', 'branches.id')->select('postos_coleta.id', 'branches.name')
                    ->get()
                    ->each(function ($posto) {
                        $posto->hash = cripto($posto->id, 'posto-coleta');
                    }),
                'contratos' => Contrato::select('id', 'contrato', 'ano', 'contratada_nome', 'versao', 'vigencia_fim', 'valor_global')
                    ->get()
                    ->each(function ($contrato) {
                        $contrato->hash = cripto($contrato->id, 'contrato');
                    })
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function buscarCota(Request $request)
    {
        if (!$request->contrato || !$request->posto_coleta)
            return response()->json('Selecione um Posto de Coleta e um Contrato', 422);

        return response()->json([
            'cotas_financeiras' => CotaFinanceira::where([
                'posto_coleta' => cripto($request->posto_coleta, 'posto-coleta', 2),
                'contrato' => cripto($request->contrato, 'contrato', 2)
            ])->get()
        ]);
    }

    public function salvarCota(Request $request)
    {
        $request->merge(
            [
                'posto_coleta' => cripto($request->posto_coleta, 'posto-coleta', 2),
                'contrato' => cripto($request->contrato, 'contrato', 2),
                'valor' => str_replace(['.', ','], ['', '.'], $request->cota['valor']),
                'inicio' => $request->cota['inicio'],
                'fim' => $request->cota['fim']
            ]
        );
        $request->validate([
            'posto_coleta' => 'required|exists:postos_coleta,id',
            'contrato' => 'required|exists:contratos,id',
            'valor' => 'decimal:2',
            'inicio' => 'date',
            'fim' => 'date',
        ]);

        $cotaFinanceira = CotaFinanceira::where([
            'contrato' => $request->contrato,
            'posto_coleta' => $request->posto_coleta,
        ])->whereBetween('inicio', [
            'inicio' => $request->inicio,
            'fim' => $request->fim
        ])->get();

        if ($cotaFinanceira->count() === 0) {
            $cota = CotaFinanceira::create(array_merge(['user' => auth()->id()], $request->only('contrato', 'posto_coleta', 'valor', 'inicio', 'fim')));
            return response()->json(['cota' => $cota]);
        }
        return response()->json(['cota' => $cotaFinanceira]);
    }
}
