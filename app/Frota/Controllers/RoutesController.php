<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Task;
use App\Frota\Models\Driver;
use App\Frota\Models\Route;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;

class RoutesController extends Controller
{
    use ACL, Helpers;

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
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function edit(Request $request): Response|RedirectResponse
    {
        if (!$request->driver || !$request->date) {
            return redirect()->to(route('frota.routes.create'));
        }

        $driverRoutes = Task::select('id', 'driver', 'date')
            ->where('date', $request->date)
            ->where('driver', $request->driver)
            ->with('driver')
            ->with('routes')
            ->get()->toArray();

        if (count($driverRoutes) < 1) {
            return redirect()->to(route('frota.routes.create'));
        }

        return Inertia::render('Frota/Routes/Edit', [
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Timetable::all(['id', 'time']),
            'driverRoutes' => $driverRoutes
        ]);
    }

    public function myRoutes(): Response
    {
        return Inertia::render('Frota/Routes/MyRoutes');
    }

    public function filterRoutes(Request $request): array|JsonResponse
    {
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver')) {
            return $this->getTaskByDriver($request);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso.'], 403);
    }

    public function filter(Request $request): JsonResponse
    {
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver')) {
            $res = [];
            if ($request->branch) {
                $res = Route::where('to', $request->branch)
                    ->where('date', $request->date)
                    ->select('id', 'task', 'to', 'started_at', 'ended_at', 'time')
                    ->with('taskData')
                    ->get()
                    ->toArray();
            } elseif ($request->driver) {
                $res = $this->getTaskByDriver($request);
            }

            if (count($res) < 1) {
                return response()->json(['error' => 'Nenhuma rota foi encontrada com os dados informados.'], 404);
            } else {
                return response()->json(['data' => $res]);
            }
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso.'], 403);
    }

    private function getTaskByDriver(Request $request): array
    {
        return Task::select('id', 'driver', 'date')
            ->where('date', $request->date)
            ->where('driver', $request->driver)
            ->with('routes')
            ->get()->toArray();
    }

    public function routeStore(Request $request): JsonResponse
    {
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver')) {
            $task = $this->getTaskByDriver($request);
            if (count($task) === 0) {
                $createTask = Task::create([
                    'driver' => $request->driver,
                    'date' => $request->date
                ])->toArray();
                return $this->routePersist($createTask, $request);
            } else {
                return $this->routePersist($task[0], $request);
            }
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso.'], 403);
    }

    public function routePersist($task, Request $request, $order = null): JsonResponse
    {
        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'order' => $order,
            'date' => $task['date'],
            'time' => $request->time
        ]);

        if ($route) {
            return response()->json([
                'message' => 'Rota criada.'
            ]);
        } else {
            return response()->json('Erro ao criar rota', 500);
        }
    }

    public function routeUpdate(Request $request)
    {
        
    }
}
