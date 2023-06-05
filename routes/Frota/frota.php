<?php

use Illuminate\Support\Facades\Route;
use App\Frota\Controllers\CarsController;
use App\Frota\Controllers\HomeController;
use App\Frota\Controllers\TasksController;
use App\Frota\Controllers\DriversController;
use App\Frota\Controllers\GaragesController;
use App\Frota\Controllers\ReportsController;
use App\Frota\Controllers\IncidentsController;

Route::prefix('/')->middleware(
    getSettingMustVerifyEmail() ? ['auth', 'verified'] : ['auth']
)->group(function () {
    Route::get('/', [HomeController::class, 'index'])->name('home');

    Route::resource('/tarefas', TasksController::class, ['names' => 'tasks'])->parameter('tarefas', 'task')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/carros', CarsController::class, ['names' => 'cars'])->parameter('carros', 'car')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/motoristas', DriversController::class, ['names' => 'drivers'])->parameter('motoristas', 'driver')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/garagens', GaragesController::class, ['names' => 'garages'])->parameter('motoristas', 'garage')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/ocorrencias', IncidentsController::class, ['names' => 'incidents'])->parameter('ocorrencias', 'incident')->withTrashed(['show', 'edit', 'update', 'restore']);

    Route::resource('/relatorios', ReportsController::class, ['names' => 'reports'])->parameter('relatorios', 'report')->withTrashed(['show', 'edit', 'update', 'restore']);
});
