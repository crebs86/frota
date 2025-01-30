<?php

namespace App\Frota\Controllers;

use App\Frota\Core\Requests;
use App\Frota\Models\Route;
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

    public function update(RequestRequest $request, Route $route)
    {
        if ($this->can('Solicitacao Editar') && $route->user === auth()->id() || $this->can('Agenda Editar', 'Liberador')) {
            return $this->runUpdate($request, $route);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqc(403-2)'], 403);
    }

    public function getRequestsToEvaluate(Request $request)
    {
        if ($this->can('Liberador')) {
            return $this->runGetRequestsToEvaluate($request);
        }
        return response()->json(['error' => 'Você não tem permissão para usar este recurso. reqe(403-1)'], 403);
    }

    public function allow(Request $request): JsonResponse
    {
        return $this->runAllow($request);
    }
}
