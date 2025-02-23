<?php

namespace App\Frota\Core;

use Carbon\Carbon;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Frota\Models\Car;
use App\Frota\Models\Task;
use App\Frota\Models\Route;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\CarsLog;
use App\Frota\Models\Timetable;
use App\Frota\Models\RealBranch;
use App\Traits\Helpers;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\RedirectResponse;

trait Routes
{
    use Helpers;

    /**
     * @param Request $request
     * @return Response|RedirectResponse
     */
    public function runEdit(Request $request): Response|RedirectResponse
    {
        if (!$request->driver || !$request->date) {
            return redirect()->to(route('frota.routes.create'));
        }

        $driverRoutes = Task::select('id', 'driver', 'date')
            ->where('date', $request->date)
            ->where('driver', $request->driver)
            ->with('driver')
            ->with('routes')
            ->first();

        if (!$driverRoutes) {
            return redirect()->to(route('frota.routes.create'));
        }

        return Inertia::render('Frota/Routes/Edit', [
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time'),
            'driverRoutes' => $this->runSetRealBranch($driverRoutes->toArray()),
            '_checker' => setGetKey($driverRoutes->id, 'route_edit')
        ]);
    }

    public function runAllRoutes()
    {
        $allRoutes = [];
        $task = DB::table('tasks as t')
            ->select('r.id as route', 't.id as task', 't.date', 't.driver', 'r.time', 'r.started_at', 'r.ended_at', 'u.name', 'b.name as branch', 'r.to', 'r.duration', 'r.status')
            ->where([
                'r.type' => 0,
                't.date' => now()->format('Y-m-d')
            ])
            ->orWhere(function ($q) {
                $q->where([
                    'r.type' => 1,
                    'r.status' => 1,
                    't.date' => now()->format('Y-m-d')
                ]);
            })
            ->join('routes as r', 't.id', 'r.task')
            ->join('drivers as d', 't.driver', 'd.id')
            ->join('users as u', 'u.id', 'd.id')
            ->join('branches as b', 'b.id', 'r.to')
            ->orderBy('r.time')
            ->get();

        if ($task->count() > 0) {
            $allRoutes = $this->runSetAllRoutesRealBranch($task->toArray());
        }
        return Inertia::render('Frota/Routes/AllRoutes', [
            'allRoutes' => $allRoutes
        ]);
    }

    /**
     * @param Request $request
     * @return Response
     */
    public function runMyRoutes(Request $request): Response
    {
        $request->merge(['driver' => auth()->id()]);
            $request->date ?? $request->merge(['date' => date('Y-m-d')]);

        $cars = activeCars();
        $cars->each(function ($car) {
            return $car->token = setGetKey($car->id, 'car_token');
        });

        if (!$driver = Driver::where('id', auth()->id())->select('id', 'carro_favorito')->with('user')->with('car')->first()) {
            return Inertia::render('Admin/403');
        }

        if ($driver?->car?->id) {
            $driver->car->token = setGetKey($driver->car->id, 'car_token');
        }

        return Inertia::render('Frota/Routes/MyRoutes', [
            'myRoutesByDate' => $this->runGetTaskByDriver($request),
            'driver' => $driver,
            'cars' => $cars,
            'lifetime' => cache()->forever('lifetime_' . auth()->id(), now()->addSeconds(60 * 60 * 2)->format('YmdHis'))
        ]);
    }

    /**
     * @param Request $request
     * @return array|JsonResponse
     */
    public function runFilterRoutes(Request $request): array|JsonResponse
    {
        $a = $this->runGetTaskByDriver($request)[0] ?? [];
        return [$a, $a ? setGetKey($a['id'], 'route_edit') : null];
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runFilter(Request $request): JsonResponse
    {
        $res = [];
        if ($request->branch) {
            $res = Route::select('id', 'task', 'to', 'started_at', 'ended_at', 'time')
                ->where('to', $request->branch)
                ->where('date', $request->date)
                ->where('type', 0)
                ->orWhere(function ($q) use ($request) {
                    return $q->where(['status' => 1])
                        ->where('date', $request->date)
                        ->where(['type' => 1])
                        ->where('to', $request->branch);
                })
                ->with('taskData')
                ->get();
        } elseif ($request->driver) {
            $res = $this->runGetTaskByDriver($request);
        }

        if (count($res) < 1) {
            return response()->json(['error' => 'Nenhuma rota foi encontrada com os dados informados.'], 404);
        } else {
            return response()->json(['data' => $res, '_checker' => !$request->branch ? setGetKey($res[0]['id'], 'editar_add_rota') : null]);
        }
    }

    /**
     * @param Request $request
     * @return array
     */
    private function runGetTaskByDriver(Request $request): array
    {
        $task = Task::select('id', 'driver', 'date')
            ->where(function ($q) use ($request) {
                if (!$request->driver) {
                    return $q->where('driver', '=', 2);
                }
                return $q->where([
                    'date' => $request->date,
                    'driver' => $request->driver
                ]);
            })
            ->with('routes')
            ->first();

        if ($task) {
            return [$this->runSetRealBranch($task?->toArray())];
        }
        return [];
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runRouteStore(Request $request): JsonResponse
    {
        $driverRequired = request()->route()->getName() === 'frota.request.store' ? 'nullable' : 'required';
        $request->validate([
            'branch' => 'required|integer|exists:branches,id',
            'time' => 'required|date_format:H:i:s',
            'duration' => 'required|date_format:H:i',
            'date' => 'required|date_format:Y-m-d',
            'driver' => $driverRequired . '|integer|exists:drivers,id',
            'local' => 'required_if:branch,==,1|string|nullable|max:255',
            'passengers' => 'required|array',
            'duration' => 'required|date_format:H:i',
        ], [
            'branch.*' => 'Informe uma unidade para a rota.',
            'time.required' => 'Selecione um horário para a rota.',
            'time.date_format' => 'Selecione um horário na lista.',
            'duration.required' => 'Informe uma duração.',
            'duration.date_format' => 'Duração inválida.',
            'date.*' => 'A data não foi informada.',
            'driver.*' => 'Selecione um motorista para fazer a rota.',
            'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.',
            'passengers.required' => 'Informe pelo menos um passageiro com contato.'
        ]);

        if (!$this->validateDate($request->date, $request->time)) {
            return response()->json(['error' => 'Você não pode agendar um horário passado. rrs(403-1)'], 403);
        }
        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar', 'Solicitacao Criar')) {

            $task = $this->runGetTaskByDriver($request);

            if (count($task) === 0) {
                $createTask = Task::create([
                    'driver' => $request->driver ?? 2,
                    'date' => $request->date
                ])->toArray();
                return $this->runRoutePersist($createTask, $request);
            } else {

                if (request()->route()->getName() === 'frota.request.store' || (int)getKeyValue($request->_checker, 'route_edit') === (int)$task[0]['id']) {
                    return $this->runRoutePersist($task[0], $request);
                }
                return response()->json(['error' => 'Erro na utilização da aplicação. rrs(403-2)'], 403);
            }
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. rrs(403-3)'], 403);
    }

    /**
     * @param $task
     * @param Request $request
     * @return JsonResponse
     */
    private function runRoutePersist($task, Request $request): JsonResponse
    {
        $response = '';
        if ($task) {
            $unique = Route::where([
                'time' => $request->time,
                'task' => $task['id'],
            ])->select('type')->get();

            if ($request->driver && $unique->count() > 0) {
                $unique->each(function ($item) use (&$response) {
                    if ($item->type === 0) {
                        $response = [['message' => 'Já existe uma agenda neste horário para este motorista.', 'errors' => ["time" => ['Já existe uma agenda neste horário para este motorista.']]], 409];
                    } else {
                        $response = [['message' => 'Existe uma solicitação pendente neste horário para este motorista.', 'errors' => ["time" => ['Existe uma solicitação pendente neste horário para este motorista.']]], 409];
                    }
                });

                if ($response[1] === 409 && !$request->ignore) {
                    return response()->json($response[0], $response[1]);
                }
            }
        }

        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'date' => $task['date'] && $task['driver'] != 2 ? $task['date'] : $request->date,
            'time' => $request->time,
            'type' => $request->type ?? 0,
            'obs' => $request->obs,
            'duration' => $request->duration,
            'passengers' => json_encode($request->passengers),
        ]);

        if ($route) {
            if ($route->to === 1) {
                RealBranch::create([
                    'route' => $route->id,
                    'name' => $request->local
                ]);
            }
            return response()->json([
                'message' => 'A rota foi adicionada.'
            ]);
        } else {
            return response()->json('Erro ao criar rota', 503);
        }
    }

    /**
     * @param Request $request
     * @param Route $route
     * @return JsonResponse
     */
    public function runRouteUpdate(Request $request, Route $route): JsonResponse
    {
        if (!$this->validateDate($request->date, $request->time)) {
            return response()->json(['error' => 'Não é possível atualizar uma rota passada. rru(403-1)'], 403);
        }
        if ($route->started_at) {
            return response()->json(['error' => 'Rota já iniciada, não é possível a sua edição. rru(403-2)'], 403);
        }

        $request->merge(['to' => $request->branch['id']]);

        $unique = DB::table('tasks as t')
            ->select('r.type', 'r.status', 't.id', 'r.task')
            ->where([
                'driver' => $request->driver,
                't.date' => $request->date,
                'r.time' => $request->time
            ])->where('r.id', '<>', $request->id)
            ->join('routes as r', 't.id', '=', 'r.task')
            ->get();

        $response = '';

        //todo remover linhas duplicadas
        if ($unique->count() > 0) {
            $unique->each(function ($item) use (&$response) {
                if ($item->type === 0 || $item->status === 1 && $item->type === 1) {
                    $response = [['message' => 'Já existe uma agenda neste horário para este motorista.', 'errors' => ["time" => ['Já existe uma agenda neste horário para este motorista.']]], 409];
                } elseif ($item->type === 1 && $item->status === 0) {
                    $response = [['message' => 'Existe uma solicitação pendente neste horário para este motorista.', 'errors' => ["time" => ['Existe uma solicitação pendente neste horário para este motorista.']]], 409];
                }
            });
            if ($response[1] === 409 && !$request->ignore) {
                return response()->json($response[0], $response[1]);
            }
        }

        $request->validate(
            [
                'to' => 'required|integer|exists:branches,id',
                'time' => 'required|date_format:H:i:s',
                'driver' => 'required|exists:drivers,id',
                'date' => 'required|date_format:Y-m-d',
                'passengers' => 'required|array',
                'duration' => 'required|date_format:H:i',
                'local' => 'required_if:to,==,1|string|nullable|max:255',
            ],
            [
                'to.*' => 'Informe uma unidade para a rota.',
                'time.required' => 'Selecione um horário para a rota.',
                'time.date_format' => 'Formato da hora inválido.',
                'date.date_format' => 'Formato da data inválido.',
                'duration.required' => 'Selecione um período de permanência.',
                'duration.date_format' => 'Duração inválida.',
                'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.'
            ]
        );
        $t = Task::select('driver', 'date')->find($route->task);
        if ($t && $t?->driver === $request->driver && $t?->date === $request->date) {
            if ($route->update([
                'time' => $request->time,
                'to' => $request->branch['id'],
                'duration' => $request->duration,
                'passengers' => json_encode($request->passengers),
                'obs' => $request->obs
            ])) {
                $this->setRealBranch($request, $route);
                return response()->json('A rota foi atualizada.');
            }
        } else {
            if ($task = $this->checkReturnTask($request)) {
                $route->update([
                    'time' => $request->time,
                    'date' => $request->date,
                    'task' => $task->id,
                    'to' => $request->branch['id'],
                    'duration' => $request->duration,
                    'passengers' => json_encode($request->passengers),
                    'obs' => $request->obs
                ]);
                $this->setRealBranch($request, $route);
                return response()->json('A rota foi atualizada.');
            }
            return response()->json(['error' => 'Erro ao atualizar a rota. rru(503-1)'], 503);
        }
        return response()->json(['error' => 'Erro ao atualizar a rota. rru(503-2)'], 503);
    }

    /**
     * @param $request
     * @return Task
     */
    private function checkReturnTask($request): Task
    {
        return Task::where([
            'driver' => $request->driver,
            'date' => $request->date,
        ])->first() ?? Task::create([
            'driver' => $request->driver,
            'date' => $request->date,
        ]);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runStartRoute(Request $request): JsonResponse
    {
        $request->validate([
            'km' => 'required|max:9999999|integer',
            'car' => 'required',
            'obs' => 'nullable|max:255',
            'started_at' => 'nullable|date_format:H:i'
        ], [
            'started_at.date_format' => 'Erro no formato da hora informado.',
            'car.required' => 'Selecione um carro para fazer a rota.'
        ]);

        $route = Route::where(
            [
                'id' => $request->id,
                'started_at' => null
            ]
        )->select('id', 'date', 'started_at', 'task', 'time')->with('taskData')->first();

        if (!$route) {
            return response()->json('Esta rota não existe.', 404);
        }

        $routeArray = $route?->toArray();
        if (count($routeArray) > 0) {
            if ($routeArray['task_data']['driver']['id'] === auth()->id() && explode(' ', now()->format('Y-m-d H:i:s'))[0] === $routeArray['date']) {
                $route->started_at = $request->started_at ? date('Y-m-d') . ' ' . $request->started_at : now();
                $route->obs_start = $request->obs;

                if ($route->save()) {
                    $this->runSaveCarLog($request->id, Car::where('placa', $request->car)->select('id')->first(), $request->km, 'start'); //salva informações do início da rota

                    $request->merge(['driver' => auth()->id()]);
                    $request->merge(['date' => date('Y-m-d')]);

                    $myRoutesByDate = $this->runGetTaskByDriver($request);
                    return response()->json($myRoutesByDate);
                } else {
                    return response()->json('Erro ao salvar rota.', 403);
                }
            } else {
                return response()->json('Você não possui permissão para editar esta rota(1)', 403);
            }
        } else {
            return response()->json('Esta rota já foi iniciada.', 403);
        }
    }

    /**
     * @param $routeId
     * @param Car $car
     * @param int $km
     * @param string $type
     * @return void
     */
    public function runSaveCarLog($routeId, Car $car, int $km, string $type): void
    {
        $carDrive = DB::table('routes')
            ->where('routes.id', $routeId)
            ->join('tasks', 'routes.task', '=', 'tasks.id')
            ->join('drivers', 'drivers.id', '=', 'tasks.driver')
            ->select('routes.task', 'tasks.id as taskId', 'tasks.driver', 'drivers.carro_favorito')
            ->first();

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
            $this->runSetNewFavoriteCar($carDrive->driver, $car->id);
        }
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runFinishRoute(Request $request): JsonResponse
    {
        $request->validate([
            'km' => 'required|max:9999999|integer',
            'car' => 'required',
            'obs' => 'nullable|max:255',
            'started_at' => 'nullable|date_format:H:i'
        ], [
            'started_at.date_format' => 'Erro no formato da hora informado.',
            'car.required' => 'Selecione um carro para fazer a rota.'
        ]);
        $route = Route::where(
            [
                'id' => $request->id,
                'ended_at' => null
            ]
        )->select('id', 'date', 'started_at', 'task')->with('taskData')->first();

        if (!$route) {
            return response()->json('Esta rota não existe.', 404);
        }

        $routeArray = $route?->toArray();
        if (count($routeArray) > 0) {
            if ($routeArray['task_data']['driver']['id'] === auth()->id() && explode(' ', now()->format('Y-m-d H:i:s'))[0] === $routeArray['date']) {
                $route->ended_at = $request->ended_at ? date('Y-m-d') . ' ' . $request->ended_at : now();
                $route->obs_end = $request->obs;

                if ($route->save()) {
                    $this->runSaveCarLog($request->id, Car::where('placa', $request->car)->select('id')->first(), $request->km, 'end'); //salva informações da finalização da rota

                    $request->merge(['driver' => auth()->id()]);
                    $request->merge(['date' => date('Y-m-d')]);

                    $myRoutesByDate = $this->runGetTaskByDriver($request);
                    return response()->json($myRoutesByDate);
                }
            } else {
                return response()->json('Você não possui permissão para editar esta rota(2).', 403);
            }
        }
        return response()->json('Esta rota já foi finalizada.', 403);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runEraseRoute(Request $request): JsonResponse
    {
        $route = Route::where('id', $request->id)->select('id', 'date', 'ended_at', 'started_at', 'task')->with('taskData')->first();
        $routeArray = $route->toArray();
        if ($routeArray['task_data']['driver']['id'] === auth()->id() && explode(' ', now()->format('Y-m-d H:i:s'))[0] === $routeArray['date']) {
            $route->started_at = null;
            $route->ended_at = null;
            $route->obs_start = null;
            $route->obs_end = null;

            if ($route->save()) {
                CarsLog::where('route', $request->id)->delete(); //limpar dados do log

                $request->merge(['driver' => auth()->id()]);
                $request->merge(['date' => date('Y-m-d')]);

                $myRoutesByDate = $this->runGetTaskByDriver($request);
                return response()->json($myRoutesByDate);
            }
        }
        return response()->json('Você não possui permissão para editar esta rota(3).', 403);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runSetSingleRoute(Request $request): JsonResponse
    {
        $request->merge(['date' => date('Y-m-d'), 'driver' => auth()->id()]);

        $task = $this->runGetTaskByDriver($request);

        $request->validate([
            'branch' => 'required|integer|exists:branches,id',
            'car' => 'required|exists:cars,placa',
            'km' => 'required|integer|max:999999',
            'local' => 'required_if:branch,==,1|string|nullable|max:255',
            'obs' => 'nullable|max:255'
        ], [
            'branch.*' => 'Informe uma unidade para a rota.',
            'car.*' => 'Informe um carro para a rota.',
            'km.required' => 'Informe a quilometragem atual do carro.',
            'km.max' => 'Quilometragem deve ter no máximo 6 caracteres.',
            'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.'
        ]);
        if (count($task) === 0) {
            $createTask = Task::create([
                'driver' => $request->driver,
                'date' => $request->date
            ])->toArray();
            $route = $this->runPersistSingleRoute($createTask, $request);
        } else {
            $route = $this->runPersistSingleRoute($task[0], $request);
        }

        if ($route) {
            $request->merge(['id' => $route->id]);
            return $this->runStartRoute($request);
        }
        return response()->json('Não foi possível validar inicio da rota. Atualize a página para verificar sua criação e início manual.', 404);
    }

    /**
     * @param $task
     * @param Request $request
     * @return Route|JsonResponse
     */
    private function runPersistSingleRoute($task, Request $request): Route|JsonResponse
    {
        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'duration' => '00:00',
            'passengers' => $request->passengers ? json_encode($request->passengers) : '{}',
            'date' => $task['date'],
            'time' => date('H:i:s')
        ]);

        if ($route) {
            if ($route->to === 1) {
                RealBranch::create([
                    'route' => $route->id,
                    'name' => $request->local
                ]);
            }
            return $route;
        } else {
            return response()->json('Erro ao criar rota.', 503);
        }
    }

    /**
     * @param $driver
     * @param $car
     * @return void
     */
    private function runSetNewFavoriteCar($driver, $car)
    {
        Driver::find($driver)->update([
            'carro_favorito' => $car
        ]);
    }
}
