<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use App\Frota\Models\ScheduleTemplate;
use App\Frota\Models\Timetable;
use App\Frota\Requests\ScheduleTemplateRequest;
use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Inertia\Inertia;
use Inertia\Response;

class SchedulesController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        return Inertia::render('Frota/Schedules/Index', []);
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        return Inertia::render('Frota/Schedules/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function storeScheduleTemplate(ScheduleTemplateRequest $scheduleTemplateRequest)
    {
        if ($this->can('Agenda Modelo Criar', 'Agenda Modelo Editar')) {
            $scheduleTemplate = ScheduleTemplate::where('driver', $scheduleTemplateRequest->driver)->get()->first();
            if ($scheduleTemplate) {
                $scheduleTemplate->update($scheduleTemplateRequest->validated());
            } else {
                ScheduleTemplate::create($scheduleTemplateRequest->validated());
            }
        }
    }
}
