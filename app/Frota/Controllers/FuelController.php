<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Fuel;
use App\Frota\Models\Timetable;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class FuelController extends Controller
{
    use ACL, Helpers;

    public function loadLastFill(): JsonResponse
    {
        if ($this->can('Combustivel Ver', 'Combustivel Editar', 'Combustivel Criar', 'Combustivel Apagar')) {
            return response()->json(Fuel::all());
        } else {
            return response()->json('Você não possui permissão para acessar este recurso', 403);
        }
    }
}
