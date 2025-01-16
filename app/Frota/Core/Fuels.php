<?php

namespace App\Frota\Core;

use App\Frota\Models\Fuel;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

trait Fuels
{
    public function runInsertFill(Request $request): JsonResponse
    {
        dd($request->all());
        $fuel = Fuel::create([
            'car' => $request->car,
            'driver' => auth()->id(),
            'km' => $request->km,
            'quantidade' => $request->quantidade,
            'valor' => $request->valor,
            'local' => $request->local,
            'observacao' => $request->observacao,
            'arquivo' => $request->arquivo,
            'hora' => $request->data . ' ' . $request->hora,
        ]);
        return response()->json();
    }
}
