<?php

namespace App\Frota\Controllers;

use App\Frota\Models\Driver;
use App\Traits\ACL;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;
use App\Traits\Helpers;
use App\Frota\Models\Car;
use App\Frota\Requests\CarRequest;
use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;


class CarsController extends Controller
{
    use ACL, Helpers;

    /**
     * @return Response
     */
    public function index(): Response
    {
        if ($this->can('Carro Ver', 'Carro Editar', 'Carro Apagar', 'Carro Criar')) {
            return Inertia::render('Frota/Cars/Index', [
                'cars' => cars()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function create(): Response
    {
        if ($this->can('Carro Criar')) {
            return Inertia::render('Frota/Cars/Create', [
                'garages' => activeGarages(),
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param CarRequest $carRequest
     * @param Car $car
     *
     * @return Response|RedirectResponse
     */
    public function store(CarRequest $carRequest, Car $car): Response|RedirectResponse
    {
        if ($this->can('Carro Criar')) {

            if ($car->create($carRequest->validated())) {
                resetCache('cars');
                resetCache('activeCars');
                return redirect(route('frota.cars.index'))->with('success', 'Carro adicionado!');
            }
            return redirect()->back()->with('error', 'Ocorreu um erro ao adicionar garagem');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function show(): Response
    {
        if ($this->can('Carro Ver', 'Carro Editar', 'Carro Apagar')) {
            return $this->showCarPage();
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @return Response
     */
    public function edit(): Response
    {
        if ($this->can('Carro Ver', 'Carro Editar', 'Carro Apagar')) {
            return $this->showCarPage($this->can('Carro Editar'));
        }
        return Inertia::render('Admin/403');
    }

    /**
     * @param bool $canEdit
     * @return Response
     */
    public function showCarPage($canEdit = false): Response
    {
        return Inertia::render('Frota/Cars/Show', [
            'garages' => activeGarages(),
            'car' => [cars()->where('id', request('car'))->first()],
            '_checker' => setGetKey(request('car'), 'edit_car'),
            'canEdit' => $canEdit
        ]);
    }

    /**
     * @param CarRequest $request
     * @param Car $car
     *
     * @return Response|RedirectResponse
     */
    public function update(CarRequest $request, Car $car): Response|RedirectResponse
    {
        if (
            (int)getKeyValue($request->_checker, 'edit_car') === request('car')->id
        ) {
            if ($this->can('Carro Editar', 'Carro Apagar')) {
                $request->merge(['deleted_at' => !$request->active ? now() : null]);
                if ($car->update($request->all())) {
                    resetCache('cars');
                    resetCache('activeCars');
                    return redirect()->back()->with(['car' => cars()->where('id', request('car'))]);
                }
                return redirect()->back()->with('error', 'Ocorreu um erro ao salvar os dados do carro.');
            }
        }
        return Inertia::render('Admin/403');
    }

    public function driverFavoriteCar(Request $request): JsonResponse
    {
        cache()->forget('defineFavoriteCar_' . auth()->id());
        if (!isset($request->currentCar['id']) || (int)$request->currentCar['id'] === (int)getKeyValue($request->currentCar['token'], 'car_token')) {
            $driver = Driver::find(auth()->id());
            if ($driver->carro_favorito != $request->car['id']) {
                $driver->update([
                    'carro_favorito' => $request->car['id']
                ]);
                defineFavoriteCar();
                return response()->json('Carro favorito atualizado.');
            }
            defineFavoriteCar();
            return response()->json('Carro favorito confirmado.');
        }
        return response()->json('Ocorreu um erro ao salvar os dados do carro. dfv(500-1)', 500);
    }

}
