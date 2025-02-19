<?php

use App\Models\Branch;
use App\Models\Setting;
use App\Frota\Models\Car;
use App\Frota\Models\Driver;
use App\Frota\Models\Garage;
use App\Frota\Models\Timetable;
use Illuminate\Support\Facades\Crypt;

/**
 * setGetKey($request->user_id)
 */
if (!function_exists('setGetKey')) {
    /**
     * @param string $key
     * @param string|null $sufix
     *
     * @return string
     */
    function setGetKey($key, $sufix = null)
    {
        return Crypt::encryptString(($sufix ? $sufix . '::' : '') . ($key . '::' . auth()->id()));;
    }
}

/**
 * User::find(getKeyValue($request->id))
 */
if (!function_exists('getKeyValue')) {
    /**
     * @param string $key
     * @param string|null $sufix
     *
     * @return mixed
     */
    function getKeyValue($key, $sufix = null)
    {
        $exp = explode('::', Crypt::decryptString($key));
        if (intval($exp[2]) === auth()->id()) {
            return $sufix && $sufix === $exp[0] ? $exp[1] : null;
        } else {
            return null;
        }
    }
}

if (!function_exists('garages')) {

    function garages()
    {
        return cache()->remember('garages', 60 * 60 * 24, function () {
            return Garage::select('id', 'deleted_at')->with('branch')->withTrashed()->get()->toArray();
        });
    }
}

if (!function_exists('activeGarages')) {

    function activeGarages()
    {
        return cache()->remember('activeGarages', 60 * 60 * 24, function () {
            return Garage::with('branch')->select('id')->get();
        });
    }
}

if (!function_exists('activeBranches')) {

    function activeBranches()
    {
        return cache()->remember('activeBranches', 60 * 60 * 24, function () {
            return Branch::select('id', 'name')->get();
        });
    }
}

if (!function_exists('cars')) {

    function cars()
    {
        return cache()->remember('cars', 60 * 60 * 24, function () {
            return Car::select('id', 'placa', 'marca', 'modelo', 'patrimonio', 'tombo', 'garagem_id', 'deleted_at')->with('garage')->withTrashed()->get();
        });
    }
}
if (!function_exists('activeCars')) {

    function activeCars()
    {
        return cache()->remember('activeCars', 60 * 60 * 24, function () {
            return Car::select('id', 'placa', 'marca', 'modelo')->get();
        });
    }
}

if (!function_exists('drivers')) {

    function drivers()
    {
        return cache()->remember('drivers', 60 * 60 * 24, function () {
            return Driver::with('user', 'garage', 'car')->select('id', 'garagem_id', 'carro_favorito', 'proprio', 'matricula', 'cnh', 'deleted_at')->withTrashed()->get();
        });
    }
}

if (!function_exists('userDriver')) {

    function userDriver()
    {
        return cache()->remember('userDriver', 60 * 60 * 24, function () {
            return Driver::with('user', 'garage', 'car')->where('id', '<>', 2)->select('id', 'garagem_id', 'carro_favorito', 'proprio', 'matricula', 'cnh', 'deleted_at')->get();
        });
    }
}

if (!function_exists('timetable')) {

    function timetable()
    {
        return cache()->remember('timetable', 60 * 60 * 30, function () {
            return Timetable::all(['time']);
        });
    }
}

if (!function_exists('definedFavoriteCar')) {

    function definedFavoriteCar($lifetime = 60 * 60)
    {
        return cache()->remember('definedFavoriteCar_' . auth()->id(), $lifetime, function () {
            return true;
        });
    }
}

if (!function_exists('resetCache')) {

    function resetCache($name)
    {
        cache()->forget($name);
    }
}

if (!function_exists('stylesSettings')) {
    /**
     * @return Setting
     */
    function stylesSettings()
    {
        return json_decode(cache()->remember('stylesSettings', 60 * 60 * 2, function () {
            return Setting::where('name', 'styles')->first();
        })->settings);
    }
}

if (!function_exists('getSettingMustVerifyEmail')) {
    /**
     * @return Setting
     */
    function getSettingMustVerifyEmail()
    {
        return json_decode(cache()->remember('settings', 60 * 60 * 2, function () {
            return Setting::where('name', 'general')->first();
        })->settings)->mustVerifyEmail[1];
    }
}

if (!function_exists('verifyPermissionLevel')) {
    /**
     * @return Setting
     */
    function verifyPermissionLevel(array $role, array $admin_role)
    {
        if (count(array_intersect($role, $admin_role)) > 0) {
            //return 'if';
            return auth()->user()->hasRole(config('crebs86.admin_roles_edit'));
        } else {
            //return 'else';
            return true;
        }
    }
}

if (!function_exists('verifyUserLevel')) {
    /**
     * @return Setting
     */
    function verifyUserLevel(bool $role, array $admin_role)
    {
        if ($role) {
            return auth()->user()->hasRole($admin_role);
        } else {
            return true;
        }
    }
}
