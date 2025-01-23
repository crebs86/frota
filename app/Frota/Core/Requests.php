<?php

namespace App\Frota\Core;

use Inertia\Inertia;
use App\Models\Branch;
use App\Traits\Helpers;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use Illuminate\Http\JsonResponse;
use App\Frota\Models\Request as RequestModel;

trait Requests
{
    use Routes, Helpers;

    public function runIndex($request)
    {
        $props = [
            'drivers' => Driver::with('user')->select('id')->get(),
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Arr::pluck(Timetable::all(['time']), 'time')
        ];

        $date = $request->date ?? now()->format('Y-m-d');

        if ($this->can('Liberador') && !$this->hasRole('Super Admin')) {
            return Inertia::render('Frota/Requests/Admin', array_merge_recursive(
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
                        ->with('branch', 'driver')
                        ->get()->toArray()
                ],
                $props
            ));
        }

        if ($this->can('Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar')) {
            return Inertia::render('Frota/Requests/Index', $props);
        }
        return Inertia::render('Admin/403');
    }

    public function runGetRoutes(Request $request) {}

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
}
