<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use App\Regulacao\Models\Contrato;
use App\Regulacao\Models\CotaFinanceira;
use App\Regulacao\Models\PostoColeta;
use Carbon\Carbon;
use DateTime;

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

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function buscarCota(Request $request): JsonResponse
    {
        if (!($request->contrato || $request->posto_coleta))
            return response()->json('Selecione um Posto de Coleta ou um Contrato', 422);

        if (!$this->can('Regulacao Editar', 'Regulacao Apagar'))
            return response()->json('Sem permissão para acessar recurso', 403);

        $request->merge(
            [
                'posto_coleta' => $request->posto_coleta ? cripto($request->posto_coleta, 'posto-coleta', 2) : null,
                'contrato' => $request->contrato ? cripto($request->contrato, 'contrato', 2) : null
            ]
        );

        return response()->json([
            'cotas_financeiras' => $this->getCota($request)
        ]);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function salvarCota(Request $request): JsonResponse
    {
        if (!$this->can('Regulacao Editar', 'Regulacao Apagar'))
            return response()->json('Sem permissão para acessar recurso', 403);
        $request->merge($this->dataToMerge($request));
        $request->validate([
            'posto_coleta' => 'required|exists:postos_coleta,id',
            'contrato' => 'required|exists:contratos,id',
            'valor' => 'decimal:2',
            'inicio' => 'date',
            'fim' => 'date',
        ]);

        $cotasFinanceiras = CotaFinanceira::where([
            'contrato' => $request->contrato,
            'posto_coleta' => $request->posto_coleta,
        ])->whereBetween('inicio', [
            'inicio' => $request->inicio,
            'fim' => $request->fim
        ])->get();

        if ($cotasFinanceiras->count() === 0) {
            CotaFinanceira::create(array_merge(['user' => auth()->id()], $request->only('contrato', 'posto_coleta', 'valor', 'inicio', 'fim')));

            return response()->json([
                'cotas_financeiras' => $this->getCota($request)
            ]);
        }
        return response()->json(['cotas_financeiras' => $cotasFinanceiras]);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function atualizarCota(Request $request): JsonResponse
    {
        if (!$this->can('Regulacao Editar', 'Regulacao Apagar'))
            return response()->json('Sem permissão para acessar recurso', 403);

        $request->merge($this->dataToMerge($request));

        $request->validate([
            'inicio' => 'nullable|date|after_or_equal:' . now()->format('Y-m-d'),
            'fim' => 'nullable|date|after_or_equal:' . now()->format('Y-m-d')
        ]);

        $cota = CotaFinanceira::find($request->id);

        if (!$cota)
            return response()->json('Erro ao processar solicitação.', 409);

        if (!$cota->alteracoes) {
            $cota->alteracoes = json_encode([['user' => auth()->user()->name, 'valor' => $cota->valor, 'data' => Carbon::parse($cota->created_at)->format('Y-m-d H:i:s'), 'inicio' => $cota->inicio, 'fim' => $cota->fim]]);
        } else {
            $a = json_decode($cota->alteracoes, true);
            $a[] = ['user' => auth()->user()->name, 'valor' => $request->valor, 'data' => now()->format('Y-m-d H:i:s'), 'inicio' => $request->inicio ?? $cota->inicio, 'fim' => $request->fim ?? $cota->fim];
            $cota->alteracoes = json_encode($a);
        }

        $cota->valor = $request->valor;
        $cota->inicio = $request->inicio ?? $cota->inicio;
        $cota->fim = $request->fim ?? $cota->fim;
        if ($cota->save())
            return response()->json([
                'cotas_financeiras' => $this->getCota($request)
            ]);

        return response()->json('Erro ao salvar solicitação.', 409);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function copiarCota(Request $request): JsonResponse
    {
        if (!$this->can('Regulacao Editar', 'Regulacao Apagar'))
            return response()->json('Sem permissão para acessar recurso', 403);

        $request->merge($this->dataToMerge($request));

        $request->validate([
            'inicio' => 'date|after_or_equal:' . now()->format('Y-m-d'),
            'fim' => 'date|after_or_equal:' . now()->format('Y-m-d')
        ]);

        $cota = CotaFinanceira::find($request->id);

        if (!$cota)
            return response()->json('Erro ao processar solicitação.', 409);

        $novaCota = CotaFinanceira::create([
            'posto_coleta' => $cota->posto_coleta,
            'contrato' => $cota->contrato,
            'valor' => $cota->valor,
            'inicio' => $request->inicio,
            'fim' => $request->fim,
            'user' => auth()->id(),
        ]);

        if ($novaCota)
            return response()->json([
                'cotas_financeiras' => $this->getCota($request)
            ]);

        return response()->json('Erro ao salvar solicitação.', 409);
    }

    /**
     * @param $request
     * @return array
     */
    private function dataToMerge($request): array
    {
        return
            [
                'posto_coleta' => $request->posto_coleta ? cripto($request->posto_coleta, 'posto-coleta', 2) : null,
                'contrato' => $request->contrato ? cripto($request->contrato, 'contrato', 2) : null,
                'valor' => str_replace(['.', ','], ['', '.'], $request->valor),
                'id' => $request->hash ? cripto($request->hash, 'cota-financeira', 2) : null,
                'inicio' => $request->inicio ? Carbon::parse($request->inicio)->format('Y-m-d') : null,
                'fim' => $request->fim ? Carbon::parse($request->fim)->format('Y-m-d') : null,
            ];
    }

    /**
     * @param $request
     * @return Collection
     */
    private function getCota($request): Collection
    {
        return CotaFinanceira::where(function ($query) use ($request) {
            return $request->contrato ? $query->where('cotas_financeiras.contrato', $request->contrato) : $query;
        })
            ->where(function ($query) use ($request) {
                return $request->posto_coleta ? $query->where('cotas_financeiras.posto_coleta', $request->posto_coleta) : $query;
            })
            ->join('branches', 'cotas_financeiras.posto_coleta', 'branches.id')
            ->join('contratos', 'cotas_financeiras.contrato', 'contratos.id')
            ->select('cotas_financeiras.id', 'name', 'valor', 'inicio', 'fim', 'alteracoes', 'contratos.contrato as n_contrato', 'ano')
            ->get()
            ->each(function ($cota) {
                $cota->hash = cripto($cota->id, 'cota-financeira');
            });
    }
}
