<?php

namespace App\Frota\Controllers;

use App\Frota\Core\Fuels;
use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Fuel;
use App\Frota\Models\Timetable;
use App\Frota\Requests\FuelRequest;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FuelController extends Controller
{
    use ACL, Helpers, Fuels;

    public function loadLastFill(Request $request): JsonResponse
    {
        if ($this->can('Combustivel Ver', 'Combustivel Editar', 'Combustivel Criar', 'Combustivel Apagar')) {
            return response()->json(Fuel::where('car', getKeyValue($request->token, 'car_token'))
                ->limit(5)
                ->orderBy('hora')
                ->get());
        } else {
            return response()->json('Você não possui permissão para acessar este recurso. Fill(403-1)', 403);
        }
    }

    public function insertFill(FuelRequest $request)
    {
        if ($this->can('Combustivel Criar')) {
            return response()->json($this->runInsertFill($request));
        } else {
            return response()->json('Você não possui permissão para acessar este recurso. Fill(403-2)', 403);
        }
    }
}
