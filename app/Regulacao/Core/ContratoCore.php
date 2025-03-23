<?php

namespace App\Regulacao\Core;

use App\Regulacao\Models\Contrato;
use Illuminate\Http\RedirectResponse;
use Inertia\Inertia;
use Inertia\Response;
use function Laravel\Prompts\error;

trait ContratoCore
{

    public function inserirAditivo($contrato, $request)
    {
        if ($contrato->aditivos === null) {
            $contrato->aditivos = json_encode([
                ['valor' => str_replace(['.', ','], ['', '.'], $request->valor) / 100,
                    'descricao' => $request->descricao,
                    'indice' => cripto(1, 'aditivo')]
            ]);
            if ($contrato->save()) {
                return redirect()->back();
            }
        } else {
            $aditivos = json_decode($contrato->aditivos, true);
            $aditivos[] = [
                'valor' => str_replace(['.', ','], ['', '.'], $request->valor) / 100,
                'descricao' => $request->descricao,
                'indice' => cripto(count($aditivos) + 1, 'aditivo')];
            $contrato->aditivos = json_encode($aditivos);
            if ($contrato->save()) {
                return redirect()->back();
            }
        }
        return redirect()->to(route('redirect.409'))->with('error', 'Não foi possível inserir o aditivo de contrato.');
    }

    public function atualizarAditivo($request)
    {
        $contrato = $this->getContrato(cripto($request->contract, 'editar', 2));
        $aditivos = json_decode($contrato->aditivos);
        $contrato->aditivos = json_encode(collect($aditivos)->each(function ($item) use ($request) {
            if ($request->indice === $item->indice) {
                $item->valor = str_replace(['.', ','], ['', '.'], $request->valor) / 100;
                $item->descricao = $request->descricao;
            }
        }));
        $contrato->user = auth()->id();
        if ($contrato->save()) {
            return redirect()->back();
        }
        return redirect()->to(route('redirect.409'))->with('error', 'Não foi possível inserir o aditivo de contrato.');
    }

    public function getContrato($id)
    {
        return Contrato::find($id);
    }
}
