<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Route;
use App\Frota\Models\Timetable;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use App\Models\Branch;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Arr;
use Inertia\Inertia;

class HomeController extends Controller
{
    use ACL, Helpers;

    public function index()
    {
        if ($this->can('Motorista Editar', 'Motorista Ver', 'Motorista Criar', 'Motorista Apagar', 'Carro Editar', 'Carro Ver', 'Carro Criar', 'Carro Apagar', 'Ocorrencia Editar', 'Ocorrencia Ver', 'Ocorrencia Criar', 'Ocorrencia Apagar', 'Solicitacao Editar', 'Solicitacao Ver', 'Solicitacao Criar', 'Solicitacao Apagar', 'Tarefa Editar', 'Tarefa Ver', 'Tarefa Criar', 'Tarefa Apagar', 'Liberador')) {
            $routes = Route::where([
                'date' => now()->format('Y-m-d'),
                'type' => 0
            ])
                ->orWhere(function ($q) {
                    return $q->where([
                        'type' => 1,
                        'status' => 1,
                        'date' => now()->format('Y-m-d')
                    ]);
                })
                ->select('started_at', 'ended_at')
                ->get();
            return Inertia::render('Frota/Home', [
                'drivers_count' => Driver::where('id', '<>', 2)->count(),
                'cars_count' => Car::count(),
                'routes_count' => $routes->count(),
                'exec_routes' => $routes->where('started_at', '<>', null)->where('ended_at', '<>', null)->count()
            ]);
        } else {
            return Inertia::render('Admin/403');
        }
    }

    public function loadData(): JsonResponse
    {
        return response()->json([
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::select('time')->get()->toArray(), 'time')
        ]);
    }

    public function loadBranches(): JsonResponse
    {
        return response()->json(Branch::select('id', 'name')->get());
    }

    public function loadDrivers()
    {
        return response()->json(Driver::select('id')->where('id', '<>', 2)->with('user')->get());
    }
}
