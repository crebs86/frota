<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Regulacao\Models\Contrato;
use App\Http\Controllers\Controller;
use App\Regulacao\Requests\ContratosRequest;
use Illuminate\Http\RedirectResponse;


class ContratosController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Contratos Ver', 'Contratos Editar', 'Contratos Apagar', 'Contratos Criar')) {
            return Inertia::render('Regulacao/Contratos/Index', ['contratos' => Contrato::all()]);
        }
        return Inertia::render('Admin/403');
    }

    public function create(): Response
    {
        if ($this->can('Contratos Criar')) {
            return Inertia::render('Regulacao/Contratos/Create');
        }
        return Inertia::render('Admin/403');
    }

    public function store(ContratosRequest $request): Response
    {
        if ($this->can('Contratos Criar')) {
            return Inertia::render('Regulacao/Contratos/Create');
        }
        return Inertia::render('Admin/403');
    }
}
