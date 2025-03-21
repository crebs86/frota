<?php

use Illuminate\Support\Facades\Route;
use App\Regulacao\Controllers\ContratosController;
use App\Regulacao\Controllers\HomeController;


Route::prefix('/regulacao')->middleware(
    getSettingMustVerifyEmail() ? ['auth', 'verified'] : ['auth']
)->name('regulacao.')->group(function () {
    Route::get('/', [HomeController::class, 'index'])->name('home');
    Route::get('/contratos', [ContratosController::class, 'index'])->name('contratos.index');
    Route::get('/contratos/ver/{contract}', [ContratosController::class, 'show'])->name('contratos.show');
    Route::get('/contratos/novo', [ContratosController::class, 'create'])->name('contratos.create');
    Route::post('/contratos/novo', [ContratosController::class, 'store'])->name('contratos.store');
    Route::get('/contratos/{contract}/editar', [ContratosController::class, 'edit'])->name('contratos.edit');
    Route::put('/contratos/{contract}/atualizar', [ContratosController::class, 'update'])->name('contratos.update');
    Route::get('/contratos/{contract}/atualizar', [ContratosController::class, 'edit'])->name('contratos.update');
});
