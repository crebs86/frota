<?php

namespace App\Http\Controllers\Admin;

use App\Traits\ACL;
use Illuminate\Http\RedirectResponse;
use Inertia\Inertia;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Inertia\Response;

class MiscController extends Controller
{
    use Helpers, ACL;

    /**
     * @return RedirectResponse
     */
    public function home(): RedirectResponse
    {
        if (auth()->check()) {
            if ($this->hasRole('Motorista')) {
                return redirect()->route('frota.my-routes');
            } elseif ($this->hasPermission('Liberador')) {
                return redirect()->route('frota.requests.evaluates');
            }
            return redirect()->route('frota.home');
        }
        return redirect()->route('login');
    }

    /**
     * @return Response
     */
    public function dashboard(): Response
    {
        return Inertia::render('Dashboard');
    }

    /**
     * @return Response
     */
    public function redirect(): Response
    {
        return Inertia::render('Admin/419', [
            'url' => url()->previous()
        ]);
    }
}
