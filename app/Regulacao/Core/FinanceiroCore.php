<?php

namespace App\Regulacao\Core;

use App\Regulacao\Models\ExamesFinanceiro;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

trait FinanceiroCore
{
    public function examesContratoSalvar(Request $request)
    {
        $examesContratoValor = [];
        $contrato = cripto($request->contract, 'contrato', 2);
        foreach ($request->all() as $id => $valor) {
            if (!$valor)
                $valor = rand(0, 100) . ',' . rand(0, 9) . rand(0, 9);
            //return response()->json('Preencha o valor para todos os exames', 409);

            $valor = str_replace(['.', ','], ['', '.'], $valor);

            if (!preg_match('/^\d{1,6}(\.\d{1,2})?$/', $valor))
                return response()->json('Há valores incorretos informados.', 409);

            $examesContratoValor[] = [
                'valor' => $valor,
                'contrato' => $contrato,
                'CodExameLaboratorial' => cripto($id, 'contrato-exame', 2),
                'user' => auth()->id(),
                'created_at' => null,
                'updated_at' => null
            ];
        }
        //dd($examesContratoValor);
        if (DB::table('exames_financeiro')->insert($examesContratoValor)) {
            return response()->json('Valor atualizado com sucesso!');
        }
        return response()->json('Não foi possível inserir os exames no contrato.', 409);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function exameValorAtualizar(Request $request): JsonResponse
    {
        $request->merge(['valor' => str_replace(['.', ','], ['', '.'], $request->valor)]);
        $request->validate([
            'valor' => 'required|decimal:2|max:999999.99',
            'hash' => 'required|string',
        ]);
        $exame = ExamesFinanceiro::find(cripto($request->hash, 'valor-editar', 2));
        if ($exame->update(['valor' => $request->valor])) {
            return response()->json('Valor atualizado com sucesso!');
        }
        return response()->json('Não foi possível atualizar o valor do exame.', 409);
    }
}
