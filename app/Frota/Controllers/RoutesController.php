<?php

namespace App\Frota\Controllers;

use Carbon\Carbon;
use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Models\Task;
use App\Frota\Models\Route;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\CarsLog;
use App\Frota\Models\Timetable;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
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
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time')
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
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time'),
            'driverRoutes' => $driverRoutes
        ]);
    }

    public function myRoutes(Request $request): Response
    {
        $request->merge(['driver' => auth()->id()]);
        $request->date ?? $request->merge(['date' => date('Y-m-d')]);

        return Inertia::render('Frota/Routes/MyRoutes', [
            'myRoutesByDate' => $this->getTaskByDriver($request),
            'driver' => Driver::where('id', auth()->id())->select('id', 'carro_favorito')->with('user')->with('car')->first(),
            'cars' => Car::all(['id', 'modelo', 'placa'])
        ]);
    }

    public function myRoutesByDate(Request $request): array
    {
        $request->merge(['driver' => auth()->id()]);
        return $this->getTaskByDriver($request);
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
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Tarefa Ver') && $this->validateDate($request->date)) {
            $task = $this->getTaskByDriver($request);

            $request->validate([
                'branch' => 'required|integer|exists:branches,id',
                'time' => 'required',
                'date' => 'required|date',
                'driver' => 'required|integer|exists:drivers,id'
            ], [
                'branch.*' => 'Informe uma unidade para a rota.',
                'time.required' => 'Selecione um horário para a rota.',
                'date.*' => 'A data não foi informada.',
                'driver.*' => 'Selecione um motorista para fazer a rota.'
            ]);

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

    private function routePersist($task, Request $request): JsonResponse
    {
        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'date' => $task['date'],
            'time' => $request->time
        ]);

        if ($route) {
            return response()->json([
                'message' => 'A rota foi adicionada.'
            ]);
        } else {
            return response()->json('Erro ao criar rota', 503);
        }
    }

    public function routeUpdate(Request $request, Route $route): JsonResponse
    {
        if ($this->can('Tarefa Editar')) {
            if ($route->update([
                'time' => $request->time,
                'to' => $request->branch['id']
            ])) {
                return response()->json('A rota foi atualizada.');
            } else {
                return response()->json('Ocorreu um erro ao processar solicitação.', 503);
            }
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso.'], 403);
    }

    public function startRoute(Request $request): JsonResponse
    {
        $route = Route::where('id', $request->id)->select('id', 'date', 'started_at', 'task')->with('taskData')->first();
        $routeArray = $route->toArray();
        if ($routeArray['task_data']['driver']['id'] === auth()->id() && Carbon::parse($routeArray['date'])->diffInDays(now()) === 0) {
            $route->started_at = $request->started_at ? date('Y-m-d') . ' ' . $request->started_at : now();
            $route->obs_start = $request->obs;

            if ($route->save()) {
                $this->saveCarLog($request->id, Car::where('placa', $request->car)->select('id')->first(), $request->km, 'start'); //salva informações do início da rota

                $request->merge(['driver' => auth()->id()]);
                $request->merge(['date' => date('Y-m-d')]);

                $myRoutesByDate = $this->getTaskByDriver($request);
                return response()->json($myRoutesByDate);
            }
        } else {
            return response()->json('Você não possui permissão para editar esta rota.', 403);
        }
    }

    public function saveCarLog($routeId, Car $car, int $km, string $type): void
    {
        $carDrive = DB::table('routes')
            ->where('routes.id', $routeId)
            ->join('tasks', 'routes.task', '=', 'tasks.id')
            ->join('drivers', 'drivers.id', '=', 'tasks.driver')
            ->select('routes.task', 'tasks.id as taskId', 'tasks.driver', 'drivers.carro_favorito')
            ->first();

        //dd($carDrive->carro_favorito);

        $cl = CarsLog::where('route', $routeId)->where('type', $type)->get();
        if ($cl->count() === 0) {
            CarsLog::create([
                'route' => $routeId,
                'car' => $car->id,
                'km' => $km,
                'type' => $type
            ]);
        }

        if ($carDrive->carro_favorito != $car->id) {
            $this->setNewFavoriteCar($carDrive->driver, $car->id);
        }
    }

    public function finishRoute(Request $request): JsonResponse
    {
        $route = Route::where('id', $request->id)->select('id', 'date', 'ended_at', 'task')->with('taskData')->first();
        $routeArray = $route->toArray();
        if ($routeArray['task_data']['driver']['id'] === auth()->id() && Carbon::parse($routeArray['date'])->diffInDays(now()) === 0) {
            $route->ended_at = $request->ended_at ? date('Y-m-d') . ' ' . $request->ended_at : now();
            $route->obs_end = $request->obs;

            if ($route->save()) {
                $this->saveCarLog($request->id, Car::where('placa', $request->car)->select('id')->first(), $request->km, 'end'); //salva informações da finalização da rota

                $request->merge(['driver' => auth()->id()]);
                $request->merge(['date' => date('Y-m-d')]);

                $myRoutesByDate = $this->getTaskByDriver($request);
                return response()->json($myRoutesByDate);
            }
        } else {
            return response()->json('Você não possui permissão para editar esta rota.', 403);
        }
    }

    public function eraseRoute(Request $request): JsonResponse
    {
        $route = Route::where('id', $request->id)->select('id', 'date', 'ended_at', 'started_at', 'task')->with('taskData')->first();
        $routeArray = $route->toArray();
        if ($routeArray['task_data']['driver']['id'] === auth()->id() && Carbon::parse($routeArray['date'])->diffInDays(now()) === 0) {
            $route->started_at = null;
            $route->ended_at = null;
            $route->obs_start = null;
            $route->obs_end = null;

            if ($route->save()) {
                CarsLog::where('route', $request->id)->delete(); //limpar dados do log

                $request->merge(['driver' => auth()->id()]);
                $request->merge(['date' => date('Y-m-d')]);

                $myRoutesByDate = $this->getTaskByDriver($request);
                return response()->json($myRoutesByDate);
            }
        } else {
            return response()->json('Você não possui permissão para editar esta rota.', 403);
        }
    }

    public function setSingleRoute(Request $request)
    {
        if (Driver::find(auth()->id())) {
            $request->merge(['date' => date('Y-m-d'), 'driver' => auth()->id()]);

            $task = $this->getTaskByDriver($request);

            $request->validate([
                'branch' => 'required|integer|exists:branches,id',
                'car' => 'required|exists:cars,placa',
                'km' => 'required|integer|max:999999'
            ], [
                'branch.*' => 'Informe uma unidade para a rota.',
                'car.*' => 'Informe um carro para a rota.',
                'km.required' => 'Informe a quilometragem atual do carro.',
                'km.max' => 'Quilometragem deve ter no máximo 6 caracteres.'
            ]);

            if (count($task) === 0) {
                $createTask = Task::create([
                    'driver' => $request->driver,
                    'date' => $request->date
                ])->toArray();
                $route = $this->persistSingleRoute($createTask, $request);
            } else {
                $route = $this->persistSingleRoute($task[0], $request);
            }

            if ($route) {
                $request->merge(['id' => $route->id]);
                return $this->startRoute($request);
            }
            return response()->json('Não foi possível validar inicio da rota. Atualize a página para verificar sua criação e início manual.', 404);
        }
        return response()->json('Você não possui permissão para editar esta rota.', 403);
    }

    private function persistSingleRoute($task, Request $request): Route
    {
        return Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'date' => $task['date'],
            'time' => date('H:i:s')
        ]);
    }

    private function setNewFavoriteCar($driver, $car)
    {
        Driver::find($driver)->update([
            'carro_favorito' => $car
        ]);
    }

    private function validateDate($date)
    {
        $date1 = Carbon::createFromFormat('Y-m-d H:i:s', $date . ' 00:00:00');
        $date2 = Carbon::createFromFormat('Y-m-d H:i:s', now()->format('Y-m-d') . ' 00:00:00');
        return $date1->gte($date2);
    }
}
