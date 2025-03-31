<?php

namespace App\Regulacao\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use Illuminate\Http\Request;
use App\Regulacao\Models\Agenda;
use Illuminate\Http\JsonResponse;
use App\Http\Controllers\Controller;
use App\Regulacao\Models\PostoColeta;
use Illuminate\Http\RedirectResponse;


class AgendaController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Regulacao/Agenda/Index');
        }
        return Inertia::render('Admin/403');
    }

    public function create()
    {
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return Inertia::render('Regulacao/Agenda/Create', [
                'postos_coleta' => PostoColeta::join('branches', 'postos_coleta.id', 'branches.id')
                    ->select('name', 'postos_coleta.id')
                    ->get()
                    ->each(function ($item) {
                        $item->hash = cripto($item->id, 'agenda');
                    })
            ]);
        }
        return Inertia::render('Admin/403');
    }

    public function buscarAgendas(Request $request): JsonResponse
    {
        return response()->json(Agenda::where('posto_coleta', cripto($request->hash, 'agenda', 2))->get());
    }
}
