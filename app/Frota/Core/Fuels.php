<?php

namespace App\Frota\Core;

use App\Frota\Models\Fuel;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Inertia\Inertia;

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
            'valor' => str_replace(',', '.', str_replace('.', '', $request->valor)),
            'local' => $request->local,
            'observacao' => $request->observacao,
            'arquivo' => $request->arquivo,
            'hora' => $hora
        ]);
        if ($fuel) {
            return response()->json($fuel);
        } else {
            return response()->json('Erro ao inserir o registro. Fuels (500-1)', 500);
        }
    }

    public function runLoadHistoryFill(Request $request)
    {
        return Inertia::render('Frota/Cars/FillHistory', [
            'history' =>
            Fuel::where('car', $request->car)
                ->where(function ($q) use ($request) {
                    if ($request->de && $request->para) {
                        return $q->whereBetween('hora', [$request->de . ' 00:00:00', $request->para . ' 23:59:59']);
                    } elseif ($request->de && !$request->para) {
                        return $q->whereBetween('hora', [$request->de . ' 00:00:00', now()->format('Y-m-d') . ' 23:59:59']);
                    } elseif (!$request->de && $request->para) {
                        return $q->whereBetween('hora', ['1970-01-01' . ' 00:00:00', $request->para . ' 23:59:59']);
                    }
                    return $q;
                })
                ->with('carModel', 'driver')
                ->orderBy('hora', 'desc')
                ->paginate(10),
            'de' => $request->de,
            'para' => $request->para,
            'car' => cars()->where('id', $request->car)->first()
        ]);
    }
}
