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

    function definedFavoriteCar()
    {
        if (cache()->has('defineFavoriteCar_' . auth()->id())) {
            return cache()->get('defineFavoriteCar_' . auth()->id());
        }
        return null;
    }
}

if (!function_exists('defineFavoriteCar')) {

    function defineFavoriteCar(int|float $lifetime = 60 * 60): void
    {
        cache()->forever('defineFavoriteCar_' . auth()->id(), now()->addSeconds($lifetime)->format('YmdHis'));
    }
}

if (!function_exists('resetCache')) {

    function resetCache($name): void
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

if (!function_exists('cripto')) {
    /**
     * param $type 1 = encode; 2 = decode
     */
    function cripto(string $string, string $chave, $type = 1)
    {
        $original = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcedfghijklmnopqrstuvwxyz0123456789/+';
        $variants = [
            'A' => 'ALNknuzXUM1bxYGrBwQtC90HdDZ7se+P5h8Tv2VIJmKpyEiaSOc6Wg43Fqfo/lRj',
            'Z' => 'ZD3SyCIjn2WMgAcsHXa8JK9B1VfbOk+6PuzYLEq5xQ7RUwNihtdFm/Tpo40leGvr',
            'C' => 'C8iAgo/rLB0fwjc35SJOhI1Q6XtxqkzURHpWnYD+4VPGMes2lb7FZNvuyTm9dKaE',
            'Y' => 'YajZTDq0Kygivdxe5hSIzRX3AMGJ/Nc62PWOLot9kVCUuElwF+HQm4r7fbpB1sn8',
            'e' => 'eUqsZnbO9PAu4+Ll32MhzFrpG5TSQD/cgEJNa7WkYBxHw68fItX10yimCvodVjKR',
            'W' => 'WBY4Ay5JQzU1DjqbH7eclEKG0iOFgRwo39MvZudk6LICp8Xs2xSahfrNmT+n/PtV',
            'G' => 'G8rSXytaOfLK0QJnP9i5MNuxYAcq+63m47hoVBgWHjs/CpEFZvklUzewb1I2dTRD',
            'k' => 'kwayfBq12pIuXKgjPGDteOvFNo5/CJ6AniTVLZUr3YQ7dxmsScMEzH80b+hlWR49',
            'B' => 'BUX3EGrnpwFZqjcbDJk20tylCLaVi58N4+Y6HRof9PS/Qed7uzxIKAs1MhgWOvTm',
            'M' => 'MFopuSZmOBzhY97cGibWJy+fU8D4lCXT1KkwAdtxP3VQ02HRIsgnq6eLNaEr5vj/',
            'n' => 'nlIDStsHE/yqWziJ2Q+1dmC73N8K0YPoj6hkfMxpXFVO9bgAZr4cvGBTuRa5eLUw',
            'h' => 'hwvdYyPL6aWIDQiU2kqJBt5n+ZuCNso9KX/0H8czOpxlEgjrTASb731VMG4fFeRm',
            'j' => 'jfgukW/GeVRh91Lvy+ErlptIPDd6nSKiHXZq4w3xYOUATs8bacFm7z5MCQBJ02oN',
            'b' => 'bDm8Q3daC2ps71YekqUncl5ZSu/GHvW6zLfEiPwyV4OoThjKJxNMt+0rIRABgF9X',
            'u' => 'uko09RywpPr+DCQEMSHhidcOUbGlxemWZt26KBAfngJXL8sI5zqYF7Nj31V/v4aT',
        ];

        if ($type === 1) {
            $b64 = base64_encode($original[rand(1, 63)] . $string . '_' . auth()->id() . '_' . $chave);
            return encode($b64, $original, $variants[array_rand($variants)]);
        } elseif ($type = 2) {
            return decode(str_replace('|', '/', $string), $variants[$string[0]], $original, $chave);
        }
        abort(403);
    }

    function encode($string, $original, $alternativo)
    {
        $codigo = $alternativo[0];
        for ($i = 0; $i < strlen($string); $i++) {
            $caractere = $string[$i];
            if ($caractere != '=') {
                $posicao = strpos($alternativo, $caractere);
                if ($posicao !== false) {
                    $codigo .= $original[$posicao];
                } else {
                    $posicao = strpos(strtolower($alternativo), strtolower($caractere));
                    if ($posicao !== false) {
                        if (ctype_upper($caractere)) {
                            $codigo .= strtoupper($original[$posicao]);
                        } else {
                            $codigo .= $original[$posicao];
                        }
                    } else {
                        $codigo .= $caractere;
                    }
                }
            } else {
                $codigo .= $caractere;
            }
        }
        return str_replace('/', '|', $codigo);
    }

    function decode($string, $alternativo, $original, $chave)
    {
        $codigo = '';
        for ($i = 1; $i < strlen($string); $i++) {
            $caractere = $string[$i];
            if ($caractere != '=') {
                $posicao = strpos($original, $caractere);
                if ($posicao !== false) {
                    $codigo .= $alternativo[$posicao];
                } else {
                    $posicao = strpos(strtolower($original), strtolower($caractere));
                    if ($posicao !== false) {
                        if (ctype_upper($caractere)) {
                            $codigo .= strtoupper($alternativo[$posicao]);
                        } else {
                            $codigo .= $alternativo[$posicao];
                        }
                    } else {
                        $codigo .= $caractere;
                    }
                }
            } else {
                $codigo .= $caractere;
            }
        }
        $hash = explode('_', substr(base64_decode($codigo), 1));
        if ($hash[1] != auth()->id() || $chave != $hash[2]) {
            abort(403);
        }
        return $hash[0];
    }
}
