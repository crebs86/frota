<?php

use App\Regulacao\Controllers\ExamesController;
use App\Regulacao\Controllers\FinanceiroController;
use Illuminate\Support\Facades\Route;
use App\Regulacao\Controllers\ContratosController;
use App\Regulacao\Controllers\HomeController;

Route::prefix('/regulacao')->middleware(
    getSettingMustVerifyEmail() ? ['auth', 'verified'] : ['auth']
)->name('regulacao.')->group(function () {
    Route::get('/', [HomeController::class, 'index'])->name('home');
    Route::prefix('/contratos')->name('contratos.')->group(function () {
        Route::get('/', [ContratosController::class, 'index'])->name('index');
        Route::get('/ver/{contract}', [ContratosController::class, 'show'])->name('show');
        Route::get('/novo', [ContratosController::class, 'create'])->name('create');
        Route::post('/novo', [ContratosController::class, 'store'])->name('store');
        Route::get('/{contract}/editar', [ContratosController::class, 'edit'])->name('edit');
        Route::put('/{contract}/atualizar', [ContratosController::class, 'update'])->name('update');
        Route::get('/{contract}/atualizar', [ContratosController::class, 'edit'])->name('update');

        Route::post('/aditivo/{contract}', [ContratosController::class, 'aditivoInserir'])->name('aditivo.insert');
        Route::put('/aditivo/{contract}/atualizarAditivo', [ContratosController::class, 'aditivoAtualizar'])->name('aditivo.update');
        Route::delete('/aditivo/{contract}/removerAditivo', [ContratosController::class, 'aditivoRemover'])->name('aditivo.remover');
    });

    Route::prefix('/financeiro')->name('financeiro.')->group(function () {
        Route::get('/', [FinanceiroController::class, 'index'])->name('index');
        Route::prefix('/exames')->name('exames.')->group(function () {
            Route::get('/', [ExamesController::class, 'index'])->name('index');
            Route::match(['get', 'post'],'/exames-por-contrato', [ExamesController::class, 'buscarExamesContrato'])->name('exames-por-contrato');
            Route::post('/exames-por-contrato/{contract}/salvar', [ExamesController::class, 'salvarExamesContrato'])->name('salvar-exames-por-contrato');
        });
    });
});
