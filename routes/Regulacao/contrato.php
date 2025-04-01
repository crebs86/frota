<?php

use Illuminate\Support\Facades\Route;
use App\Regulacao\Controllers\CotaController;
use App\Regulacao\Controllers\HomeController;
use App\Regulacao\Controllers\AgendaController;
use App\Regulacao\Controllers\ExamesController;
use App\Regulacao\Controllers\ContratosController;
use App\Regulacao\Controllers\FinanceiroController;
use App\Regulacao\Controllers\PostoColetaController;

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
            Route::get('/contrato/{contract?}', [ExamesController::class, 'index'])->name('index');
            Route::match(['get', 'post'], '/exames-por-contrato', [ExamesController::class, 'buscarExamesContrato'])->name('exames-por-contrato');
            Route::post('/exames-por-contrato/{contract}/salvar', [ExamesController::class, 'salvarExamesContrato'])->name('salvar-exames-por-contrato');
            Route::put('/exame-valor/{exame}/atualizar', [ExamesController::class, 'atualizarValorExame'])->name('atualizar-valor-exame');
        });
        Route::prefix('/posto-coleta')->name('posto-coleta.')->group(function () {
            Route::get('/', [PostoColetaController::class, 'index'])->name('index');
            Route::get('/novo', [PostoColetaController::class, 'create'])->name('create');
            Route::post('/novo', [PostoColetaController::class, 'store'])->name('store');
        });
        Route::prefix('/cota')->name('cota.')->group(function () {
            Route::get('/', [CotaController::class, 'index'])->name('index');
            Route::post('/buscar-cota', [CotaController::class, 'buscarCota'])->name('buscar-cota');
            Route::post('/salvar-cota-unidade', [CotaController::class, 'salvarCota'])->name('salvar-cota');
            Route::post('/atualizar-cota-unidade', [CotaController::class, 'atualizarCota'])->name('atualizar-cota');
            Route::post('/copiar-cota-unidade', [CotaController::class, 'copiarCota'])->name('copiar-cota');
        });
    });


    Route::prefix('/agenda')->name('agenda.')->group(function () {
        Route::get('/', [AgendaController::class, 'index'])->name('index');
        Route::get('/criar-agenda', [AgendaController::class, 'create'])->name('create');
        Route::post('/criar-agenda', [AgendaController::class, 'store'])->name('store');
        Route::put('/atualizar-agenda', [AgendaController::class, 'update'])->name('update');
        Route::post('/buscar-agendas', [AgendaController::class, 'buscarAgendas'])->name('buscar-agendas');
        Route::post('/desativar-agendas', [AgendaController::class, 'desativarAgenda'])->name('delete');
    });
});
