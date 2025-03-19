<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\MiscController;

if (is_file(app_path() . '/instalar/route.php')) {//carrega rota de instalação, se está estiver presente
    require(app_path() . '/instalar/route.php');
}else{

Route::get('/', [MiscController::class, 'home'])->name('home');

Route::get('/painel', [MiscController::class, 'dashboard'])->middleware(
    getSettingMustVerifyEmail() ? ['auth', 'verified'] : ['auth']
)->name('dashboard');

Route::any('pagina-expirada/', [MiscController::class, 'redirect'])->name('redirect');

require __DIR__ . '/admin.php';
require __DIR__ . '/auth.php';
require __DIR__ . '/Frota/frota.php';
require __DIR__ . '/Regulacao/contrato.php';
}
