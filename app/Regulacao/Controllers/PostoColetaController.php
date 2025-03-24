<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;


class PostoColetaController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Regulacao/Financeiro/PostoColeta', []);
        }
        return Inertia::render('Admin/403');
    }
}
