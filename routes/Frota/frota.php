<?php

use App\Frota\Controllers\RequestsController;
use Illuminate\Support\Facades\Route;
use App\Frota\Controllers\CarsController;
use App\Frota\Controllers\HomeController;
use App\Frota\Controllers\RoutesController;
use App\Frota\Controllers\DriversController;
use App\Frota\Controllers\FuelController;
use App\Frota\Controllers\GaragesController;
use App\Frota\Controllers\ReportsController;
use App\Frota\Controllers\IncidentsController;
use App\Frota\Controllers\SchedulesController;

Route::prefix('/frota')->middleware(
    getSettingMustVerifyEmail() ? ['auth', 'verified'] : ['auth']
)->name('frota.')->group(function () {
    Route::get('/', [HomeController::class, 'index'])->name('home');
    Route::get('/loadData', [HomeController::class, 'loadData'])->name('load-data');
    Route::get('/carregarUnidades', [HomeController::class, 'loadBranches'])->name('load-branches');

    Route::resource('/rotas', RoutesController::class, ['names' => 'routes'])->parameter('rotas', 'route')->withTrashed(['show', 'edit', 'update', 'restore']);
    Route::get('/tarefas', [RoutesController::class, 'allRoutes'])->name('all-routes');
    Route::get('/tarefas/minhas', [RoutesController::class, 'myRoutes'])->name('my-routes');
    Route::post('/tarefas/minhas/iniciarRota/{id}', [RoutesController::class, 'startRoute'])->name('tasks.start-route');
    Route::post('/tarefas/minhas/finalizarRota/{id}', [RoutesController::class, 'finishRoute'])->name('tasks.finish-route');
    Route::post('/tarefas/minhas/limparRota/{id}', [RoutesController::class, 'eraseRoute'])->name('tasks.erase-route');
    Route::post('/tarefas/minhas/inserirRotaAvulsa', [RoutesController::class, 'setSingleRoute'])->name('tasks.set-sigle-route');
    Route::post('/tarefas/minhas/filtrar', [RoutesController::class, 'myRoutesByDate'])->name('my-routes-bydate');
    Route::post('/tarefas/filtrar', [RoutesController::class, 'filter'])->name('tasks.filter');
    Route::post('/tarefas', [RoutesController::class, 'filterRoutes'])->name('tasks.filter-routes');
    Route::post('/tarefas/criarRota', [RoutesController::class, 'routeStore'])->name('tasks.route.store');
    Route::get('rotas/{date}/{driver}/editar', [RoutesController::class, 'edit'])->name('routes.driver.edit');
    Route::put('rotas/{route}/atualizar', [RoutesController::class, 'routeUpdate'])->name('routes.route.update');

    Route::resource('/agendas', SchedulesController::class, ['names' => 'schedules'])->parameter('agendas', 'schedule')->withTrashed(['show', 'edit', 'update', 'restore']);
    Route::post('/agendas/motorista/{driver}', [SchedulesController::class, 'verifyDriverSchedule'])->name('schedules.driver');

    Route::resource('/carros', CarsController::class, ['names' => 'cars'])->parameter('carros', 'car')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/motoristas', DriversController::class, ['names' => 'drivers'])->parameter('motoristas', 'driver')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/garagens', GaragesController::class, ['names' => 'garages'])->parameter('garagens', 'garage')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/ocorrencias', IncidentsController::class, ['names' => 'incidents'])->parameter('ocorrencias', 'incident')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/relatorios', ReportsController::class, ['names' => 'reports'])->parameter('relatorios', 'report')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::get('/combustivel/carregarAbastecimentos/{car}/de/{de}/para/{para?}', [FuelController::class, 'loadHistoryFill'])->name('load-history-fill');
    Route::post('/combustivel/carregarAbastecimentos', [FuelController::class, 'loadLastFill'])->name('load-last-fill');
    Route::post('/combustivel/informarAbastecimento', [FuelController::class, 'insertFill'])->name('insert-fill');

    Route::match(['get', 'post'], '/solicitacoes', [RequestsController::class, 'index'])->name('requests.index');
    Route::post('/solicitacoes/criar', [RequestsController::class, 'store'])->name('requests.store');
    Route::put('/solicitacoes/{model}/update', [RequestsController::class, 'update'])->name('requests.update');
    Route::post('/solicitacoes/rotasESolicitacoes', [RequestsController::class, 'getRoutesAndRequests'])->name('requests.get-routes-and-requests');
});
