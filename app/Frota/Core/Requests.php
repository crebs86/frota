<?php

namespace App\Frota\Core;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Frota\Models\Request as RequestModel;
use App\Traits\Helpers;

trait Requests
{
    use Routes, Helpers;

    public function runGetRoutes(Request $request) {}

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runStore(Request $request): JsonResponse
    {
        if (!$this->validateDate($request->date, $request->time)) {
            return response()->json(['error' => 'Você não pode solicitar um horário passado. rs(403-1)'], 403);
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
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqs(403-1)'], 403);
    }

    /**
     * @param $data
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
