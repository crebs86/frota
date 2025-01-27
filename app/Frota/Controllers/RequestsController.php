<?php

namespace App\Frota\Controllers;

use App\Frota\Core\Requests;
use App\Frota\Models\Request as RequestModel;
use App\Frota\Requests\RequestRequest;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RequestsController extends Controller
{
    use ACL, Helpers, Requests;

    public function index(?Request $request)
    {
        return $this->runIndex($request);
    }

    /*     public function getRoutes()
    {
        if ($this->can('Solicitacao Criar', 'Solicitacao Ver', 'Solicitacao Apagar', 'Solicitacao Editar', 'Liberador')) {
            return Inertia::render('Frota/Requests/Index', [
                'drivers' => Driver::with('user')->select('id')->get(),
                'branches' => Branch::select('id', 'name')->get(),
                'timetables' => Arr::pluck(Timetable::all(['time']), 'time'),
                'routes' => []
            ]);
        }
        return Inertia::render('Admin/403');
    } */

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
        if ($this->can('Solicitacao Apagar', 'Solicitacao Criar', 'Solicitacao Editar', 'Solicitacao Ver', 'Liberador')) {
            return response()->json($this->runFilterRoutes($request));
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqc(403-1)'], 403);
    }

    public function update(RequestRequest $request, RequestModel $model)
    {
        if ($this->can('Solicitacao Editar') && $model->user === auth()->id() || $this->can('Agenda Editar', 'Liberador')) {
            return $this->runUpdate($request, $model);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqc(403-2)'], 403);
    }
}
