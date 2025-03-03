<?php

namespace App\Frota\Controllers;

use App\Traits\ACL;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use Illuminate\Support\Arr;
use App\Frota\Models\Driver;
use App\Http\Controllers\Controller;
use App\Frota\Requests\DriverRequest;
use Illuminate\Http\RedirectResponse;
use Intervention\Image\ImageManager;

class DriversController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Index', [
                'drivers' => drivers()->where('user', '<>', null)->where('id', '<>', 2)
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Motorista Criar')) {
            return Inertia::render('Frota/Drivers/Create', [
                'users' => User::select('id', 'name')
                    ->whereKeyNot(
                        Arr::pluck(
                            Driver::withTrashed()->get(['id'])
                                ->toArray(),
                            'id'
                        )
                    )
                    ->get(),
                'garages' => activeGarages(),
                'cars' => Car::select('id', 'placa', 'modelo')->get(),
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param DriverRequest $driverRequest
     * @param Driver $driver
     *
     * @return Response|RedirectResponse
     */
    public function store(DriverRequest $driverRequest, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Criar', 'Combustivel Administrar')) {
            if ($d = $driver->create($driverRequest->validated())) {

                $user = User::find($driverRequest->id);
                $user->assignRole('Motorista');
                resetCache('drivers');
                resetCache('userDriver');

                return redirect(route('frota.drivers.index'))->with('success', 'Motorista adicionado!' . $d);
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar motorista.');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar')) {
            return $this->showUserPage();
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar')) {
            return $this->showUserPage($this->can('Motorista Editar'));
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param bool $canEdit
     * @return Response
     */
    public function showUserPage(bool $canEdit = false): Response
    {
        if (request('driver') != 2 && $this->can('Motorista Ver', 'Motorista Editar', 'Motorista Apagar', 'Motorista Criar')) {
            $driver = drivers()->where('id', request('driver'))->first();
            if ($driver?->user) {
                return Inertia::render('Frota/Drivers/Show', [
                    'driver' => $driver,
                    'garages' => activeGarages(),
                    'cars' => cars()->select('id', 'placa', 'modelo'),
                    '_checker' => setGetKey(request('driver'), 'edit_driver'),
                    'canEdit' => $canEdit,
                    'avatar' => Storage::exists('avatar/' . $driver->id . '.webp')
                        ? 'data:image/webp;base64,' . base64_encode(Storage::get('avatar/' . $driver->id . '.webp'))
                        : null,
                ]);
            }
            if($driver?->id) {
                return Inertia::render('Admin/403', [
                    'message' => 'Usuário base do motorista está inativo. <a href ="' . route('admin.acl.users.show', $driver->id) . '" style="text-decoration:underline;">Ver</a>'
                ]);
            }
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param DriverRequest $request
     * @param Driver $driver
     *
     * @return Response|RedirectResponse
     */
    public function update(DriverRequest $request, Driver $driver): Response|RedirectResponse
    {
        if ($this->can('Motorista Editar')) {
            if ((int)getKeyValue($request->_checker, 'edit_driver') === (int)$request->driver->id) {
                if ($this->can('Motorista Editar')) {
                    $request->merge(['deleted_at' => $request->deleted_at ? now() : null]);
                    if ($driver->update($request->all())) {
                        resetCache('drivers');
                        resetCache('userDriver');
                        if ($request->deleted_at) {
                            User::find($driver->id)->removeRole('Motorista');
                        } else {
                            $u = User::find($driver->id);
                            if (!$u->hasRole('Motorista')) {
                                $u->assignRole('Motorista');
                            }
                        }
                        return redirect()->back()->with(['driver' => drivers()->where('id', request('driver'))]);
                    }
                    return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados do motorista.');
                }
            }
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Atualiza ou insere imagem na pasta privada 'avatar'.
     * @param Request $request
     * @return RedirectResponse
     */
    public function updateAvatar(Request $request): RedirectResponse
    {
        $avatar = $request->avatar;
        $data = file_get_contents($avatar);
        $manager = new ImageManager(\Intervention\Image\Drivers\Gd\Driver::class);
        $imageOrigen = $manager->read($data);
        if (Storage::disk('local')->put('avatar/' . auth()->id() . '.webp', $imageOrigen->toWebp())) {
            return redirect()->back()->with('success', 'Imagem atualizada com sucesso.');
        }
        return redirect()->back()->with('error', 'Ocorreu um erro ao atualizar a imagem.');
    }
}
