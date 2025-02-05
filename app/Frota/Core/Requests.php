<?php

namespace App\Frota\Core;

use App\Frota\Models\Justification;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Route;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use App\Frota\Models\Request as RequestModel;
use App\Frota\Models\Task;

trait Requests
{
    use Routes, Helpers;

    /**
     * @param $request
     * @return Response
     */
    public function runIndex($request): Response
    {
        $props = [
            'drivers' => Driver::with('user')->where('id', '<>', 2)->select('id')->get(),
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time'),
            'liberator' => $this->can('Liberador') && !$this->hasRole('Super Admin')
        ];

        $date = $request->date ?? now()->format('Y-m-d');

        if ($this->can('Liberador') && !$this->hasRole('Super Admin')) {
            return Inertia::render('Frota/Requests/Index', array_merge_recursive(
                [
                    'requests' => RequestModel::where(
                        function ($q) use ($date, $request) {
                            if ($request->type === 'Data Criação') {
                                return $q->whereBetween('created_at', [$date . ' 00:00:00', $date . ' 23:59:59']);
                            } else {
                                return $q->where('date', request('date') ?? now()->format('Y-m-d'));
                            }
                        }
                    )->where(function ($q) use ($request) {
                        if ($request->driver) {
                            return $q->where('driver', $request->driver);
                        }
                        return $q;
                    })
                        ->where(function ($q) use ($request) {
                            if ($request->branch) {
                                return $q->where('to', $request->branch);
                            }
                            return $q;
                        })
                        ->select('id', 'driver', 'to', 'local', 'date', 'time', 'duration', 'obs', 'passengers', 'status', 'created_at')
                        ->with('branch', 'driver')
                        ->get()->each(function ($item) {
                            $item->_checker = setGetKey($item->id, 'request_evaluate');
                        })->toArray()
                ],
                $props
            ));
        }

        if ($this->can('Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar')) {
            return Inertia::render('Frota/Requests/Index', $props);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runStore(Request $request): JsonResponse
    {
        if (!$this->validateDate($request->date, $request->time)) {
            return response()->json(['error' => 'Você não pode solicitar um horário passado. reqs(403-1)'], 403);
        }
        if ($this->can('Solicitacao Criar')) {
            $request->merge(['user' => auth()->id()]);
            $request->merge(['to' => $request->branch]);
            $request->merge(['local' => $request->branch !== 1 ? null : $request->local]);
            $request->merge(['passengers' => json_encode($request->passengers)]);
            if (RequestModel::create($request->all())) {
                return response()->json([
                    'message' => 'A solicitação foi registrada. Aguarde a avaliação do responsável.'
                ]);
            }
            return response()->json('Erro ao criar rota. reqs(500-1)', 500);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqs(403-2)'], 403);
    }

    /**
     * @param $data
     * @param Request $request
     * @return array
     */
    public function runMakeResponse($data, Request $request): array
    {
        $rm = RequestModel::where([
            'driver' => $request->driver,
            'date' => $request->date,
        ])
            ->where('status', '<>', 1)
            ->with('branch', 'user', 'driver')
            ->get()
            ->each(function ($item) {
                $item->_checker = setGetKey($item->id, 'route_edit');
                if ($item->to !== 1) {
                    $item->local = $item->branch->name;
                }
                return $item;
            })->toArray();
        $a = [];
        $i = 0;
        foreach ($data as $key => $item) {
            if ($key === 'routes') {
                foreach ($item as $route) {
                    $a[$i]['id'] = $route['id'];
                    $a[$i]['task'] = $route['task'];
                    $a[$i]['driver'] = $data['driver'];
                    $a[$i]['date'] = $data['date'];
                    $a[$i]['branch'] = $route['branch']['name'];
                    $a[$i]['b'] = $route['branch']['id'];
                    $a[$i]['time'] = $route['time'];
                    $a[$i]['_checker'] = setGetKey($route['task'], 'route_edit');
                    $a[$i]['passengers'] = $route['passengers'];
                    $a[$i]['duration'] = $route['duration'];
                    $a[$i]['started_at'] = $route['started_at'];
                    $a[$i]['ended_at'] = $route['ended_at'];
                    $i++;
                }
            }
        }
        return collect(array_merge_recursive($a, $rm))->sortBy('time')->values()->all();
    }

    /**
     * @param Request $request
     * @param $model
     * @return JsonResponse
     */
    public function runUpdate(Request $request, $model)
    {
        if (!$this->validateDate($request->date, $request->time)) {
            return response()->json(['error' => 'Você não pode solicitar um horário passado. requ(403-1)'], 403);
        }
        if ((int)getKeyValue($request->_checker, 'route_edit') === $request->id) {
            $request->merge(['to', $request->branch]);
            $request->merge(['passengers', json_encode($request->passengers)]);
            if ($model->update($request->all())) {
                return response()->json('A rota foi atualizada.');
            }
        }
        return response()->json(['error' => 'Erro na utilização da aplicação. rup(403-1)'], 403);
    }

    public function runGetRequestsToEvaluate(Request $request)
    {
        return response()->json($this->runGetRequests($request));
    }

    /**
     * @param Request $request
     * @return array
     */
    private function runGetRequests(Request $request): array
    {
        $date = $request->date ?? now();
        $driver = $request->driver ?? null;

        $task = DB::table('tasks as t')
            ->select('r.id as route', 't.id as task', 't.date', 't.driver', 'r.date as dt', 'r.time', 'u.name', 'b.name as branch', 'r.to', 'r.duration', 'r.passengers', 'r.type', 'r.status')
            ->where(function ($q) use ($request, $date) {
                if ($request->date) {
                    return $q->where('r.date', $date);
                } else {
                    return $q->whereBetween('r.date', [$date->format('Y-m-d'), $date->addMonths(1)]);
                }
            })
            ->where('r.type', '<>', 0)
            ->where(function ($q) use ($driver, $request) {
                if ($driver && !$request->date) {
                    return $q->where('driver', $driver);
                } elseif (!$driver) {
                    return $q->where('driver', '<>', null);
                }
                return $q->where('driver', $driver);
            })
            ->join('routes as r', 't.id', 'r.task')
            ->join('drivers as d', 't.driver', 'd.id')
            ->join('users as u', 'u.id', 'd.id')
            ->join('branches as b', 'b.id', 'r.to')
            ->orderBy('r.date')
            ->orderBy('r.time')
            ->limit($request->date ? 999999 : 100)
            ->get()->each(function ($item) {
                $item->_checker = setGetKey($item->route, 'request_evaluate');
            });

        if ($task->count() > 0) {
            return $this->runSetAllRoutesRealBranch($task->toArray());
        }

        return [];
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runAllow(Request $request): JsonResponse
    {
        if ((int)getKeyValue($request->_checker, 'request_evaluate') === (int)$request->route) {

            $route = Route::select('status', 'id', 'task', 'date', 'time')->with('taskData')->find($request->route);
            $status = $route->status;

            if ($request->type) {
                if (!$request->justification) {
                    return response()->json('Informe uma justificativa.', 422);
                }
                $route->update(['status' => 2]);
                if ($status === 1) {
                    $this->storeJustification((int)$route->id, $request->justification);
                }
                return response()->json('A solicitação foi marcada como negada.', 200);
            }

            if (!$this->validateDate($route->date, $route->time)) {
                return response()->json('Não é possíovel autorizar uma solicitação passada.', 403);
            }

            if ($route->status === 1 && !$request->type) {
                return response()->json('Esta rota já foi aprovada. rev(404-1)', 404);
            }

            if (!$request->type && (!$route->taskData?->driver && !$request->driver)) {
                return response()->json('Informe um motorista.', 422);
            }

            $update = $request->driver ? ['status' => $request->type ? 2 : 1, 'driver' => $request->driver] : ['status' => $request->type ? 2 : 1];
            if ($request->driver) {
                if (
                    $task = DB::table('tasks as t')
                    ->where('t.driver', '<>', 2)
                    ->where('driver', $request->driver)
                    ->where('r.id', '<>', $route->id)
                    ->where(['r.date' => $route->date, 'r.time' => $route->time])
                    ->select('type', 'status')
                    ->join('routes as r', 't.id', '=', 'r.task')
                    ->first()
                ) {
                    if (!($task && $task->status != 2) || $request->ignore) {
                        $update = ['status' => $request->type ? 2 : 1, 'task' => $this->getTask($request, $route)?->id];
                    } else {
                        return response()->json('Já existe uma agenda ou solicitação para este horário para este motorista.(1)', 409);
                    }
                }
            } elseif (!$request->ignore) {
                if (
                    DB::table('tasks as t')
                    ->where('t.driver', '<>', 2)
                    ->where('driver', $route->taskData->driver)
                    ->where('r.id', '<>', $route->id)
                    ->where(['r.date' => $route->date, 'r.time' => $route->time])
                    ->select('type', 'status')
                    ->join('routes as r', 't.id', '=', 'r.task')
                    ->get()->count() > 0
                ) {
                    return response()->json('Já existe uma agenda ou solicitação para este horário para este motorista.(2)', 409, ['_direct_allow' => true]);
                }
            } else {
                $update = ['status' => $request->type ? 2 : 1];
            }

            if ($route->update($update)) {
                if ($status === 2 && !$request->type) {
                    $this->removeJustification((int)$route->id);
                }
                return response()->json($request->type ? 'A rota foi autorizada.' : 'A solicitação foi marcada como negada.', 200);
            }
        }
        return response()->json('Erro na utilização da aplicação. rev(403-1)', 403);
    }

    private function getTask($request, $route)
    {
        if ($request->driver === 2) {
            return Task::where('driver', 2)->first();
        } else {
            if ($task = Task::where(['driver' => $request->driver, 'date' => $route->date])->first()) {
                return $task;
            } else {
                return Task::create(['driver' => $request->driver, 'date' => $route->date]);
            }
        }
    }

    /**
     * @param int $route
     * @param string $justification
     * @return void
     */
    private function storeJustification(int $route, string $justification = ''): void
    {
        if ($this->checkConflictJustification($route)) {
            Justification::insert([
                'user' => auth()->id(),
                'route' => $route,
                'justification' => $justification ?? 'Negado',
            ]);
        }
    }

    /**
     * @param int $route
     * @return bool
     */
    private function checkConflictJustification(int $route): bool
    {
        return Justification::find($route)?->count() < 1;
    }

    /**
     * @param int $route
     * @return void
     */
    private function removeJustification(int $route): void
    {
        Justification::find($route)?->delete();
    }
}
