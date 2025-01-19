<?php

namespace App\Frota\Core;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Frota\Models\Request as RequestModel;

trait Requests
{
    use Routes;

    public function runGetRoutes(Request $request)
    {

    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function runStore(Request $request): JsonResponse
    {
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
            'date' => $request->date
        ])->get()->toArray();
        $a = [];
        $i = 0;
        foreach ($data as $key => $item) {
            if ($key === 'routes') {
                foreach ($item as $route) {
                    $a[$i]['driver'] = $data['driver'];
                    $a[$i]['date'] = $data['date'];
                    $a[$i]['branch'] = $route['branch']['name'];
                    $a[$i]['b'] = $route['branch']['id'];
                    $a[$i]['time'] = $route['time'];
                    $a[$i]['task'] = $route['task'];
                    $a[$i]['started_at'] = $route['started_at'];
                    $a[$i]['ended_at'] = $route['ended_at'];
                    $i++;
                }
            }
        }
        return collect(array_merge_recursive($a, $rm))->sortBy(function ($item) {
            return $item['time'];
        })->toArray();
    }
}
