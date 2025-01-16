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
use Illuminate\Validation\Rule;
use App\Frota\Models\RealBranch;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\RedirectResponse;

trait Routes
{
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

    /**
     * @param Request $request
     * @return Response
     */
    public function runMyRoutes(Request $request): Response
    {
        $request->merge(['driver' => auth()->id()]);
        $request->date ?? $request->merge(['date' => date('Y-m-d')]);

        $cars = Car::all(['id', 'modelo', 'placa']);
        $cars->each(function ($car) {
            return $car->token = setGetKey($car->id, 'car_token');
        });

        $driver = Driver::where('id', auth()->id())->select('id', 'carro_favorito')->with('user')->with('car')->first();
        if ($driver->car?->id) {
            $driver->car->token = setGetKey($driver->car->id, 'car_token');
        }
        return Inertia::render('Frota/Routes/MyRoutes', [
            'myRoutesByDate' => $this->runGetTaskByDriver($request),
            'driver' => $driver,
            'cars' => $cars
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
            $res = Route::where('to', $request->branch)
                ->where('date', $request->date)
                ->select('id', 'task', 'to', 'started_at', 'ended_at', 'time')
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
            ->where('date', $request->date)
            ->where('driver', $request->driver)
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
        $request->validate([
            'branch' => 'required|integer|exists:branches,id',
            'time' => 'required',
            'date' => 'required|date',
            'driver' => 'required|integer|exists:drivers,id',
            'local' => 'required_if:branch,==,1|string|nullable|max:255'
        ], [
            'branch.*' => 'Informe uma unidade para a rota.',
            'time.required' => 'Selecione um horário para a rota.',
            'date.*' => 'A data não foi informada.',
            'driver.*' => 'Selecione um motorista para fazer a rota.',
            'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.'
        ]);

        if ($this->can('Tarefa Apagar', 'Tarefa Criar', 'Tarefa Editar') && $this->validateDate($request->date)) {

            $task = $this->runGetTaskByDriver($request);

            if (count($task) === 0) {
                $createTask = Task::create([
                    'driver' => $request->driver,
                    'date' => $request->date
                ])->toArray();
                return $this->runRoutePersist($createTask, $request);
            } else {
                /**
                 * Verificar payload em edição de rota
                 */

                if ((int) getKeyValue($request->_checker, 'route_edit') === (int) $task[0]['id']) {
                    return $this->runRoutePersist($task[0], $request);
                }
                return response()->json(['error' => 'Erro na utilização da aplicação.'], 403);
            }
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso.'], 403);
    }

    /**
     * @param $task
     * @param Request $request
     * @return JsonResponse
     */
    private function runRoutePersist($task, Request $request): JsonResponse
    {
        $request->validate(
            [
                'time' => [
                    Rule::unique('routes')->where(function ($q) use ($request, $task) {
                        return $q->where([
                            'time' => $request->time,
                            'task' => $task['id']
                        ]);
                    })
                ]
            ],
            [
                'time.unique' => 'Já existe uma agenda neste horário para este motorista.'
            ]
        );
        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'date' => $task['date'],
            'time' => $request->time
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
        $request->merge(['to' => $request->branch['id']]);

        $request->validate([
            'to' => 'required|integer|exists:branches,id',
            'time' => [
                'required',
                Rule::unique('routes')->where(function ($q) use ($request, $route) {
                    return $q->where([
                        'time' => $request->time,
                        'task' => $route->task
                    ])->where('id', '<>', $route->id);
                })
            ],
            'local' => 'required_if:to,==,1|string|nullable|max:255'
        ], [
            'to.*' => 'Informe uma unidade para a rota.',
            'time.required' => 'Selecione um horário para a rota.',
            'time.unique' => 'Já existe uma agenda neste horário para este motorista.',
            'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.'
        ]);

        if ($route->update([
            'time' => $request->time,
            'to' => $request->branch['id']
        ])) {

            if ($request->currentBranch['id'] === 1 && $request->branch['id'] === 1) {
                RealBranch::find($route->id)->update([
                    'name' => $request->local
                ]);
            } elseif ($request->currentBranch['id'] === 1 && $request->branch['id'] !== 1) {
                RealBranch::find($route->id)?->delete();
            } elseif ($request->currentBranch['id'] !== 1 && $request->branch['id'] === 1) {
                RealBranch::create([
                    'route' => $route->id,
                    'name' => $request->local
                ]);
            }

            return response()->json('A rota foi atualizada.');
        }
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
        } else {
            return response()->json('Esta rota já foi finalizada.', 403);
        }
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
        } else {
            return response()->json('Você não possui permissão para editar esta rota(3).', 403);
        }
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
        $route =  Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
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

    /**
     * @param $date
     * @return bool
     */
    private function runValidateDate($date)
    {
        $date1 = Carbon::createFromFormat('Y-m-d H:i:s', $date . ' 00:00:00');
        $date2 = Carbon::createFromFormat('Y-m-d H:i:s', now()->format('Y-m-d') . ' 00:00:00');
        return $date1->gte($date2);
    }

    /**
     * @param array $task
     * @return array
     */
    private function runSetRealBranch(array $task)
    {
        $t = [];

        /**
         * Renomeia o nome da branch para local não cadastrado
         */
        foreach ($task as $key => $value) {
            if ($key === 'routes') {
                foreach ($value as $k => $v) {
                    $t[$key][$k] = $v;
                    if ($v['to'] === 1) {
                        $t[$key][$k]['branch']['name'] = $this->runGetRealBranch($v['id']);
                    }
                }
            } else {
                $t[$key] = $value;
            }
        }
        return $t;
    }

    /**
     * @param int $loose
     * @return string
     */
    private function runGetRealBranch(int $loose): string
    {
        return RealBranch::select('name')->find($loose)?->name ?? 'Erro...';
    }
}
