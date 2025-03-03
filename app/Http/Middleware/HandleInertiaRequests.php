<?php

namespace App\Http\Middleware;

use Illuminate\Support\Facades\Storage;
use Inertia\Middleware;
use Tighten\Ziggy\Ziggy;
use Illuminate\Http\Request;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determines the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @see https://inertiajs.com/shared-data
     *
     * @return array<string, mixed>
     */
    public function share(Request $request)
    {
        return array_merge(parent::share($request), [
            'auth' => [
                'user' => $this->isInstalled() ? $request->user() : null,
                'roles' => function () use ($request) {
                    if ($request->user()) {
                        return $request->user()->roles->sortBy('name')->pluck('name');
                    }
                },
                'permissions' => function () use ($request) {
                    if ($request->user()) {
                        return $request->user()->getPermissionsViaRoles()->sortBy('name')->pluck('name')->unique()->values()->all();
                    }
                },
                'avatar' => $this->getAvatar($request)
            ],
            'ziggy' => function () use ($request) {
                return array_merge((new Ziggy)->toArray(), [
                    'location' => $request->url(),
                ]);
            },
            'flash' => function () use ($request) {
                return [
                    'success' => $request->session()->get('success'),
                    'error' => $request->session()->get('error'),
                    'info' => $request->session()->get('info'),
                    'warning' => $request->session()->get('warning'),
                ];
            },
            'app' => function () {
                return [
                    'version' => config('crebs86.version'),
                    'year' => config('crebs86.year_date'),
                    'released' => config('crebs86.release_date'),
                    'app_version' => 'x.x.x',
                    'settingsStyles' => stylesSettings()
                ];
            },
        ]);
    }

    private function isInstalled()
    {
        if (!file_exists(app_path('/instalar'))) {
            return true;
        }
        return false;
    }

    /**
     * Retorna base64 de imagem
     * @param $request
     * @return string|null
     */
    private function getAvatar($request): ?string
    {
        if ($request->user() && Storage::exists('avatar/' . auth()->id() . '.webp')) {
            $avatar = Storage::get('avatar/' . auth()->id() . '.webp');
            return 'data:image/webp;base64,' . base64_encode($avatar);
        };
        return null;
    }
}
