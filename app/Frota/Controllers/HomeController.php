<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use App\Traits\Helpers;
use App\Http\Controllers\Controller;
use Inertia\Inertia;

class HomeController extends Controller
{
    use ACL, Helpers;

    public function index()
    {
        return Inertia::render('Frota/Home');
    }
}
