<?php

namespace App\Regulacao\Controllers;

use App\Regulacao\Cache;
use App\Regulacao\Core\FinanceiroCore;
use App\Regulacao\Models\ExamesFinanceiro;
use App\Traits\ACL;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use Illuminate\Http\Request;
use App\Regulacao\Models\Contrato;
use App\Http\Controllers\Controller;
use App\Regulacao\Requests\ContratosRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;

class ExamesController extends Controller
{
    use ACL, Helpers, FinanceiroCore, Cache;

    /**
     * @param Request $request
     * @return Response
     */
    public function index(Request $request): Response
    {
        if ($this->can('Financeiro Ver', 'Financeiro Editar', 'Financeiro Apagar', 'Financeiro Criar')) {
            if ($request->contract)
                return $this->buscarExamesContrato($request);

            return Inertia::render(
                'Regulacao/Financeiro/Exames',
                [
                    'contratos' => $this->getContratos()
                ]
            );
        }
        return Inertia::render('Admin/403');
    }

    public function buscarExamesContrato(Request $request)
    {
        if (!$request->contract)
            return redirect()->to(route('regulacao.financeiro.exames.index'));

        if ($this->can('Financeiro Ver', 'Financeiro Editar', 'Financeiro Apagar', 'Financeiro Criar') && $request->contract) {
            $exames_financeiros = ExamesFinanceiro::where('contrato', cripto($request->contract, 'contrato', 2))
                ->select('exames_financeiro.id', 'valor', 'ec.Descricao as exame', 'ec.CodigoExterno as codigo')
                ->join('exames_clinicos as ec', 'ec.id', '=', 'exames_financeiro.CodExameLaboratorial')
                ->get()->each(function ($exame) {
                    $exame->hash = cripto($exame->id, 'valor-editar');
                    $exame->id = rand(1, 555);
                });

            $exames_clinicos = null;
            if ($exames_financeiros->count() === 0) {
                $exames_clinicos = DB::table('exames_clinicos')
                    ->select('id', 'CodSetorExameLaboratorial', 'CodigoExterno', 'Descricao', 'ExameParaProntoAtendimento', 'ExameAutorizacaoPrevia', 'InformarDataInicioSintoma', 'Ativo', 'ExameParaLACEN', 'Sexo')
                    ->get()
                    ->each(function ($item) {
                        $item->id = cripto($item->id, 'contrato-exame');
                    });
            }

            return Inertia::render('Regulacao/Financeiro/Exames', [
                'contratos' => $this->getContratos(),
                'exames_financeiro' => $exames_financeiros,
                'exames_clinicos' => $exames_clinicos,
                'dados' => $request->dados ?? []
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function salvarExamesContrato(Request $request)
    {
        return $this->examesContratoSalvar($request);
    }

    private function getContratos()
    {
        return DB::table('contratos')
            ->select('id', 'contrato', 'ano', 'contratada_nome', 'vigencia_inicio')
            ->orderBy('ano', 'desc')
            ->get()
            ->each(function ($contrato) {
                $contrato->hash = cripto($contrato->id, 'contrato');
                $contrato->id = Str::random(2);
            });
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function atualizarValorExame(Request $request): JsonResponse
    {
        return $this->exameValorAtualizar($request);
    }
}
