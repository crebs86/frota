<?php

namespace App\Regulacao\Core;

use Illuminate\Support\Facades\DB;

trait FinanceiroCore
{
    public function examesContratoSalvar($request)
    {
        $examesContratoValor = [];
        $contrato = cripto($request->contract, 'contrato', 2);
        foreach ($request->all() as $id => $valor) {
            if (!$valor)
                $valor = rand(0, 100) . ',' . rand(0, 9) . rand(0, 9);
            //return response()->json('Preencha o valor para todos os exames', 409);

            $examesContratoValor[] = [
                'valor' => str_replace(['.', ','], ['', '.'], $valor),
                'contrato' => $contrato,
                'CodExameLaboratorial' => cripto($id, 'contrato-exame', 2),
                'user' => auth()->id(),
                'created_at' => now(),
                'updated_at' => now()
            ];
        }
        dd(DB::table('exames_financeiro')->insert($examesContratoValor));
        dd($examesContratoValor);
    }
}
