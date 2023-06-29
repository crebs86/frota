<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Driver;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use App\Http\Controllers\Controller;
use App\Frota\Models\ScheduleTemplate;
use App\Frota\Requests\ScheduleTemplateRequest;

class SchedulesController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Agenda Modelo Criar', 'Agenda Modelo Editar', 'Agenda Modelo Ver', 'Agenda Modelo Apagar')) {
            return Inertia::render('Frota/Schedules/Index', [
                'drivers' => ScheduleTemplate::with('driver')->get(['driver'])->toArray()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Agenda Modelo Criar', 'Agenda Modelo Editar')) {
            return Inertia::render('Frota/Schedules/Create', [
                'drivers' => Driver::with('user')->select('id')->get(),
                'timetables' => Timetable::all(['id', 'time']),
                'isEditMethod' => false
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param ScheduleTemplateRequest $scheduleTemplateRequest
     * 
     * @return void
     */
    public function storeScheduleTemplate(ScheduleTemplateRequest $scheduleTemplateRequest): void
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

    /**
     * @param Request $request
     * 
     * @return ScheduleTemplate|null
     */
    public function getDriverTimeTable(Request $request): ScheduleTemplate|null
    {
        return ScheduleTemplate::where('driver', $request->driver)->get()->first();
    }

    /**
     * @param Request $request
     * 
     * @return Response
     */
    public function edit(Request $request): Response
    {
        if ($this->can('Agenda Modelo Criar', 'Agenda Modelo Editar')) {
            return Inertia::render('Frota/Schedules/Create', [
                'drivers' => Driver::with('user')->where('id', $request->schedule)->select('id')->get(),
                'timetables' => Timetable::all(['id', 'time']),
                'isEditMethod' => true
                //'_checker' => setGetKey($request->schedule, 'edit_schedule_template'),
            ]);
        }
        return Inertia::render('Admin/403');
    }
}
