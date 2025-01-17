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

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function loadLastFill(Request $request): JsonResponse
    {
        if ($this->can('Combustivel Ver', 'Combustivel Editar', 'Combustivel Criar', 'Combustivel Apagar')) {
            return response()->json(
                Fuel::where('car', getKeyValue($request->token, 'car_token'))
                    ->select('km', 'quantidade', 'valor', 'local', 'hora', 'created_at', 'car')
                    //->with('carModel')
                    ->limit(3)
                    ->orderBy('hora', 'desc')
                    ->get());
        } else {
            return response()->json('Você não possui permissão para acessar este recurso. Fill(403-1)', 403);
        }
    }

    /**
     * @param FuelRequest $request
     * @return JsonResponse
     */
    public function insertFill(FuelRequest $request): JsonResponse
    {
        if ($this->can('Combustivel Criar')) {
            return $this->runInsertFill($request);
        } else {
            return response()->json('Você não possui permissão para acessar este recurso. Fill(403-2)', 403);
        }
    }
}
