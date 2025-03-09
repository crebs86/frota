<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Maintenance;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;


class MaintenanceController extends Controller
{
    use ACL, Helpers;

    public function show(Request $request): Response
    {
        if ($this->can('Manutencao Ver', 'Manutencao Editar', 'Manutencao Criar', 'Manutencao Apagar')) {
            return Inertia::render('Frota/Maintenance/Show',
                [
                    'maintenance' =>
                        Maintenance::where('car', $request->car)
                            ->orderBy('date', 'desc')
                            ->orderBy('time', 'desc')
                            ->paginate(10)
                ]
            );
        }
        return Inertia::render('Admin/403');
    }
}
