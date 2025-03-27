<?php

namespace App\Regulacao\Core;

use App\Regulacao\Models\Contrato;
use Illuminate\Http\RedirectResponse;
use Inertia\Inertia;
use Inertia\Response;

trait ContratoCore
{

    /**
     * @param $contrato
     * @param $request
     * @return RedirectResponse
     */
    public function inserirAditivo($contrato, $request): RedirectResponse
    {
        if ($contrato->aditivos === null) {
            $contrato->valor_global = $request->valor + $contrato->valor_global;
            $contrato->aditivos = json_encode([
                [
                    'valor' => str_replace(['.', ','], ['', '.'], $request->valor) / 100,
                    'descricao' => $request->descricao,
                    'indice' => cripto(1, 'aditivo')
                ]
            ]);
            if ($contrato->save()) {
                return redirect()->back();
            }
        } else {
            $contrato->valor_global = $request->valor + $contrato->valor_global;
            $aditivos = json_decode($contrato->aditivos, true);
            $aditivos[] = [
                'valor' => str_replace(['.', ','], ['', '.'], $request->valor) / 100,
                'descricao' => $request->descricao,
                'indice' => cripto(count($aditivos) + 1, 'aditivo')
            ];
            $contrato->aditivos = json_encode($aditivos);
            if ($contrato->save()) {
                return redirect()->back();
            }
        }
        return redirect()->to(route('redirect.409'))->with('error', 'Não foi possível inserir o aditivo de contrato.');
    }

    protected $a = 0;
    /**
     * @param $request
     * @return RedirectResponse
     */
    public function atualizarAditivo($request): RedirectResponse
    {
        $contrato = $this->getContrato(cripto($request->contract, 'editar', 2));
        $aditivos = json_decode($contrato->aditivos);

        $contrato->aditivos = json_encode(collect($aditivos)->each(function ($item) use ($request) {
            if ($request->indice === $item->indice) {
                $this->a = $item->valor;
                $item->valor = str_replace(['.', ','], ['', '.'], $request->valor) / 100;
                $item->descricao = $request->descricao;
            }
            return;
        }));

        $contrato->user = auth()->id();
        $contrato->valor_global = $this->atualizarValorGlobal($contrato->valor_global, $request->valor);

        if ($contrato->save()) {
            return redirect()->back();
        }
        return redirect()->to(route('redirect.409'))->with('error', 'Não foi possível inserir o aditivo de contrato.');
    }

    /**
     * @param $request
     * @return RedirectResponse
     */
    public function removerAditivo($request): RedirectResponse
    {
        $contrato = $this->getContrato(cripto($request->contract, 'editar', 2));
        $aditivos = json_decode($contrato->aditivos);

        $contrato->aditivos = json_encode(collect($aditivos)->reject(function ($item) use ($request) {
            $this->a = $item->valor;
            return $request->indice === $item->indice;
        })->values());

        $contrato->user = auth()->id();
        $contrato->valor_global = $this->subtrairAditivo($contrato->valor_global);

        if ($contrato->save()) {
            return redirect()->back();
        }
        return redirect()->to(route('redirect.409'))->with('error', 'Não foi possível remover o aditivo do contrato.');
    }


    private function atualizarValorGlobal($valor_atual, $novo_valor)
    {
        $atual = $this->subtrairAditivo($valor_atual);
        return $atual + $novo_valor;
    }

    private function subtrairAditivo($valor_atual)
    {
        return $valor_atual - $this->a;
    }

    /**
     * @param $id
     * @return Contrato
     */
    public function getContrato($id): Contrato
    {
        return Contrato::find($id);
    }
}
