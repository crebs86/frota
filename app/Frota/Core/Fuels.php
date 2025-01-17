<?php

namespace App\Frota\Core;

use App\Frota\Models\Fuel;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

trait Fuels
{
    public function runInsertFill(Request $request): JsonResponse
    {
        if ($request->data && $request->hora) {
            $hora = $request->data . ' ' . $request->hora;
        } else {
            $hora = now();
        }
        $fuel = Fuel::create([
            'car' => $request->car,
            'driver' => auth()->id(),
            'km' => $request->km,
            'quantidade' => $request->quantidade,
            'valor' => $request->valor,
            'local' => $request->local,
            'observacao' => $request->observacao,
            'arquivo' => $request->arquivo,
            'hora' => $hora,
        ]);
        if ($fuel) {
            return response()->json($fuel);
        } else {
            return response()->json('Erro ao inserir o registro. Fuels (500-1)', 500);
        }
    }
}
