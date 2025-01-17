<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Core\Routes;
use App\Frota\Models\Route;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use Illuminate\Http\JsonResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;

class RoutesController extends Controller
{
    use ACL, Helpers, Routes;

    public function index(): Response
    {
        return Inertia::render('Frota/Routes/Index', [
            'branches' => Branch::all(['id', 'name']),
            'drivers' => Driver::select('id')->with('user')->get()->toArray()
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Frota/Routes/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time')
        ]);
    }

    public function edit(Request $request): Response|RedirectResponse
    {
        return $this->runEdit($request);
    }

    public function allRoutes(): Response
    {
        if ($this->can('Tarefa Ver')) {
            return $this->runAllRoutes();
        } else {
            return Inertia::render('Admin/403');
        }
    }

    public function myRoutes(Request $request): Response
    {
        return $this->runMyRoutes($request);
    }

    public function myRoutesByDate(Request $request): array
    {
        $request->merge(['driver' => auth()->id()]);
        return $this->getTaskByDriver($request);
    }

    public function filterRoutes(Request $request): array|JsonResponse
    {
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver')) {
            return $this->runFilterRoutes($request);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. fr(403-1)'], 403);
    }

    public function filter(Request $request): JsonResponse
    {
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver')) {
            return $this->runFilter($request);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. f(403-1)'], 403);
    }

    private function getTaskByDriver(Request $request): array
    {
        return $this->runGetTaskByDriver($request);
    }

    public function routeStore(Request $request): JsonResponse
    {
        return $this->runRouteStore($request);
    }

    private function routePersist($task, Request $request): JsonResponse
    {
        return $this->runRoutePersist($task, $request);
    }

    public function routeUpdate(Request $request, Route $route): JsonResponse
    {
        if ((int) getKeyValue($request->_checker, 'route_edit') !== (int) $route->task) {
            return response()->json(['error' => 'Erro na utilização da aplicação. ru(403-1)'], 403);
        }

        if ($this->can('Tarefa Editar')) {
            return $this->runRouteUpdate($request, $route);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. ru(403-2)'], 403);
    }

    public function startRoute(Request $request): JsonResponse
    {
        return $this->runStartRoute($request);
    }

    public function saveCarLog($routeId, Car $car, int $km, string $type): void
    {
        $this->runSaveCarLog($routeId, $car, $km, $type);
    }

    public function finishRoute(Request $request): JsonResponse
    {
        return $this->runFinishRoute($request);
    }

    public function eraseRoute(Request $request): JsonResponse
    {
        return $this->runEraseRoute($request);
    }

    public function setSingleRoute(Request $request)
    {
        if (Driver::find(auth()->id())) {
            return $this->runSetSingleRoute($request);
        }
        return response()->json('Você não possui permissão para editar esta rota. ssr(403-1).', 403);
    }

    private function persistSingleRoute($task, Request $request): Route
    {
        return $this->runPersistSingleRoute($task, $request);
    }

    private function setNewFavoriteCar($driver, $car)
    {
        $this->runSetNewFavoriteCar($driver, $car);
    }

    private function validateDate($date)
    {
        return $this->runValidateDate($date);
    }

    private function setRealBranch(array $task)
    {
        return $this->runSetRealBranch($task);
    }

    private function getRealBranch(int $loose): string
    {
        return $this->runGetRealBranch($loose);
    }
}
