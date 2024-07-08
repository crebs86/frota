<?php

namespace App\Frota\Controllers;

use stdClass;
use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use Illuminate\Http\Request;
use App\Frota\Models\Schedule;
use App\Frota\Models\Timetable;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use App\Frota\Requests\ScheduleRequest;

class SchedulesController extends Controller
{
    use ACL, Helpers;

    public function index(Schedule $schedule): Response
    {
        return Inertia::render('Frota/Schedules/Index', [
            'schedule' => $schedule->select('driver')->with('driverName')->get()
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Frota/Schedules/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function store(ScheduleRequest $request, Schedule $schedule)
    {
        $req = new stdClass();
        $req->driver = $request->driver_id;
        $req->morning_start = $request->timeMorningStart['time'] ?? null;
        $req->morning_end = $request->timeMorningEnd['time'] ?? null;
        $req->afternoon_start = $request->timeAfternoonStart['time'] ?? null;
        $req->afternoon_end = $request->timeAfternoonEnd['time'] ?? null;
        $req->night_start = $request->timeNightStart['time'] ?? null;
        $req->night_end = $request->timeNightEnd['time'] ?? null;
        $req->special_start = $request->timeSpecialStart['time'] ?? null;
        $req->special_end = $request->timeSpecialEnd['time'] ?? null;

        $schedule->create(get_object_vars($req));

        return redirect(route('frota.schedules.index'));
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Agenda Ver', 'Agenda Editar', 'Agenda Apagar')) {
            return $this->showSchedulePage();
        }
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Agenda Ver', 'Agenda Editar', 'Agenda Apagar')) {
            return $this->showSchedulePage($this->can('Agenda Editar'));
        }
    }

    /**
     * @return Response
     */
    public function showSchedulePage($canEdit = false): Response
    {
        if ($this->can('Agenda Ver', 'Agenda Editar', 'Agenda Apagar', 'Agenda Criar')) {
            return Inertia::render('Frota/Schedules/Show', [
                'schedule' => Schedule::where('driver', request('schedule'))->select('driver', 'morning_start', 'morning_end', 'afternoon_start', 'afternoon_end', 'night_start', 'night_end', 'special_start', 'special_end', 'deleted_at')->with('driverName')->withTrashed()->get()->toArray(),
                '_checker' => setGetKey(request('schedule'), 'edit_destroy_schedule'),
                'timetables' => Timetable::all(['id', 'time']),
                'canEdit' => $canEdit
            ]);
        }
    }

    /**
     * @param ScheduleRequest $request
     * @param Schedule $schedule
     * 
     * @return Response
     */
    public function update(ScheduleRequest $request, Schedule $schedule): Response|RedirectResponse
    {
        if (
            (int) getKeyValue($request->_checker, 'edit_destroy_schedule')
            === $request->driver_id
        ) {
            if ($this->can('Agenda Editar', 'Agenda Apagar')) {

                $req = new stdClass();
                $req->morning_start = $request->timeMorningStart['time'] ?? null;
                $req->morning_end = $request->timeMorningEnd['time'] ?? null;
                $req->afternoon_start = $request->timeAfternoonStart['time'] ?? null;
                $req->afternoon_end = $request->timeAfternoonEnd['time'] ?? null;
                $req->night_start = $request->timeNightStart['time'] ?? null;
                $req->night_end = $request->timeNightEnd['time'] ?? null;
                $req->special_start = $request->timeSpecialStart['time'] ?? null;
                $req->special_end = $request->timeSpecialEnd['time'] ?? null;

                $res = $schedule->update(get_object_vars($req));

                if ($res) {
                    return redirect()->back();
                } else {
                    return redirect()->back()->with('error', 'Ocorreu um erro ao salvar agenda.');
                }
            }
        }
        return Inertia::render('Admin/403');
    }

    public function verifyDriverSchedule(Request $request)
    {
        $schedule = Schedule::select('driver')->where('driver', $request->driver)->get();
        return response()->json($schedule);
    }

    /**
     * @param ScheduleRequest $request
     * @param Schedule $schedule
     * 
     * @return Response
     */
    public function destroy(ScheduleRequest $request, Schedule $schedule): Response|RedirectResponse
    {
        if (
            (int) getKeyValue($request->_checker, 'edit_destroy_schedule') === $request->garage->id
        ) {
            if ($this->can('Agenda Editar', 'Agenda Apagar')) {
                if ($schedule->delete()) {
                    return redirect(route('frota.schedules.index'));
                }
                return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados da agenda.');
            }
        }
        return Inertia::render('Admin/403');
    }
}
