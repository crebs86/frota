<?php

namespace App\Frota\Controllers;

use App\Frota\Core\Requests;
use App\Frota\Models\Driver;
use App\Frota\Models\Timetable;
use App\Frota\Models\Request as RequestModel;
use App\Frota\Requests\RequestRequest;
use App\Models\Branch;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Inertia\Inertia;


class RequestsController extends Controller
{
    use ACL, Helpers, Requests;

    public function index()
    {
        if ($this->can('Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar')) {
            return Inertia::render('Frota/Requests/Index', [
                'drivers' => Driver::with('user')->select('id')->get(),
                'branches' => Branch::select('id', 'name')->get(),
                'timetables' => Arr::pluck(Timetable::all(['time']), 'time')
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function getRoutes()
    {
        if ($this->can('Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar')) {
            return Inertia::render('Frota/Requests/Index', [
                'drivers' => Driver::with('user')->select('id')->get(),
                'branches' => Branch::select('id', 'name')->get(),
                'timetables' => Arr::pluck(Timetable::all(['time']), 'time'),
                'routes' => []
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function store(RequestRequest $request)
    {
        if ($this->can('Solicitacao Criar')) {
            return $this->runStore($request);
        }
    }

    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function getRoutesAndRequests(Request $request): JsonResponse
    {
        if ($this->can('Solicitacao Apagar', 'Solicitacao Criar', 'Solicitacao Editar', 'Solicitacao Ver')) {
            $fr = $this->runMakeResponse($this->runFilterRoutes($request)[0], $request);

            return response()->json($fr);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. fr(403-1)'], 403);
    }

    public function update(RequestRequest $request, RequestModel $model)
    {
        if ($this->can('Solicitacao Editar') && $model->user === auth()->id() || $this->can('Agenda Editar')) {
            return $this->runUpdate($request, $model);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. up(403-1)'], 403);
    }
}
