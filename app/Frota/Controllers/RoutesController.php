<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use App\Traits\Helpers;
use App\Frota\Models\Task;
use App\Frota\Models\Driver;
use App\Frota\Models\Route;
use Illuminate\Http\Request;
use App\Frota\Models\Timetable;
use App\Http\Controllers\Controller;

class RoutesController extends Controller
{
    use ACL, Helpers;

    public function index(): Response
    {
        return Inertia::render('Frota/Routes/Index', [
            'branches' => Branch::all(['id', 'name']),
            'drivers' => Driver::select('id')->with('user')->get()->toArray()
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Frota/Routes/Create', [
            'drivers' => Driver::with('user')->select('id')->get(),
            'branches' => Branch::select('id', 'name')->get(),
            'timetables' => Timetable::all(['id', 'time'])
        ]);
    }

    public function myRoutes(): Response
    {
        return Inertia::render('Frota/Routes/MyRoutes');
    }

    public function filterRoutes(Request $request): array
    {
        return $this->getTaskByDriver($request);
    }

    public function filter(Request $request)
    {
        $res = [];
        if ($request->branch) {
            $res = Task::select('id', 'driver', 'date')
                ->where('date', $request->date)->get()->toArray();
        } elseif ($request->driver) {
            $res = $this->getTaskByDriver($request);
        }
        if (count($res) < 1) {
            $request->session()->flash('error', 'Nenhuma rota foi encontrada com os dados informados.');
            return redirect()->back();
        }
    }

    private function getTaskByDriver(Request $request): array
    {
        return Task::select('id', 'driver', 'date')
            ->where('date', $request->date)
            ->where('driver', $request->driver)
            ->with('routes')
            ->get()->toArray();
    }

    public function routeStore(Request $request)
    {
        $task = $this->getTaskByDriver($request);
        if (count($task) === 0) {
            $createTask = Task::create([
                'driver' => $request->driver,
                'date' => $request->date
            ])->toArray();
            return $this->routePersist($createTask, $request);
        } else {
            dd('else');
        }
    }

    public function routePersist($task, Request $request)
    {
        $route = Route::create([
            'task' => $task['id'],
            'user' => auth()->id(),
            'to' => $request->branch,
            'order' => 1,
            'date' => $task['date'],
            'time' => $request->time
        ]);

        if ($route) {
            return response()->json([
                'message' => 'Rota criada.'
            ]);
        }
    }
}
