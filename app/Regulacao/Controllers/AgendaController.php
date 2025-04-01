<?php

namespace App\Regulacao\Controllers;

use Carbon\Carbon;
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

    private $validate = [
        'posto_coleta' => 'required|exists:postos_coleta,id',
        'vigencia_inicio' => 'required|date_format:Y-m-d',
        'vigencia_fim' => 'required|date_format:Y-m-d',
        'hora_inicio' => 'required|date_format:H:i:s',
        'hora_fim' => 'required|date_format:H:i:s',
        'vagas' => 'required|integer|max:255',
        'intervalo' => 'required|integer|max:60',
    ];

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
        if ($this->can('Regulacao Ver', 'Regulacao Editar', 'Regulacao Apagar', 'Regulacao Criar')) {
            return response()->json(
                Agenda::where('posto_coleta', cripto($request->hash, 'agenda', 2))
                    ->withTrashed()
                    ->get()->each(function ($item) {
                        $item->hash = cripto($item->id, 'agenda');
                    })
            );
        }
        return response()->json('Você não possui permissão para acessar este recurso.', 403);
    }

    public function store(Request $request)
    {
        if ($this->can('Regulacao Criar')) {
            $request->merge($this->mergeData($request));

            $request->validate($this->validate);

            if (Agenda::insert($request->except('hash'))) {
                return $this->buscarAgendas($request);
            }
        }
        return response()->json('Você não possui permissão para acessar este recurso.', 403);
    }

    public function update(Request $request)
    {
        if ($this->can('Regulacao Editar', 'Regulacao Apagar')) {
            $request->merge($this->mergeData($request));

            $request->validate($this->validate);

            $agenda = Agenda::find(cripto($request->agenda, 'agenda', 2));

            if (!$agenda)
                return response()->json('Erro ao processar solicitação.', 409);
            if (!$agenda->alteracoes) {
                $agenda->alteracoes = json_encode([
                    [
                        'user' => auth()->user()->name,
                        'vagas' => $agenda->vagas,
                        'intervalo' => $agenda->intervalo,
                        'data' => Carbon::parse($agenda->created_at)->format('Y-m-d H:i:s'),
                        'vigencia_inicio' => $agenda->vigencia_inicio,
                        'vigencia_fim' => $agenda->vigencia_fim,
                        'hora_inicio' => $agenda->hora_inicio,
                        'hora_fim' => $agenda->hora_fim
                    ]
                ]);
            } else {
                $a = json_decode($agenda->alteracoes, true);
                $a[] = [
                    'user' => auth()->user()->name,
                    'vagas' => $request->vagas,
                    'intervalo' => $request->intervalo,
                    'data' => now()->format('Y-m-d H:i:s'),
                    'vigencia_inicio' => $request->vigencia_inicio ?? $agenda->vigencia_inicio,
                    'vigencia_fim' => $request->vigencia_fim ?? $agenda->vigencia_fim,
                    'hora_inicio' => $request->hora_inicio ?? $agenda->hora_inicio,
                    'hora_fim' => $request->hora_fim ?? $agenda->hora_fim
                ];
                $agenda->alteracoes = json_encode($a);
            }

            if ($agenda->update($request->except('hash', 'agenda'))) {
                return $this->buscarAgendas($request);
            }
        }
        return response()->json('Você não possui permissão para acessar este recurso.', 403);
    }

    public function mergeData(Request $request)
    {
        return [
            'posto_coleta' => cripto($request->hash, 'agenda', 2),
            'vigencia_inicio' => $request->vigencia_inicio ? Carbon::parse($request->vigencia_inicio)->format('Y-m-d') : null,
            'vigencia_fim' => $request->vigencia_fim ? Carbon::parse($request->vigencia_fim)->format('Y-m-d') : null,
            'hora_inicio' => $request->hora_inicio ? Carbon::parse($request->hora_inicio)->format('H:i:s') : null,
            'hora_fim' => $request->hora_fim ? Carbon::parse($request->hora_fim)->format('H:i:s') : null,
            'user' => auth()->id()
        ];
    }

    public function desativarAgenda(Request $request)
    {
        if ($this->can('Regulacao Apagar')) {
            if (Agenda::find(cripto($request->agenda, 'agenda', 2))->delete()) {
                return $this->buscarAgendas($request);
            }
        }

        return response()->json('Você não possui permissão para acessar este recurso.', 403);
    }
}
