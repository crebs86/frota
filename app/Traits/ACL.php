<?php

namespace App\Traits;

trait ACL
{
    function can()
    {
        foreach (func_get_args() as $v) {
            if (auth()->user()?->can($v)) {
                return true;
            }
        }
        return false;
    }

    function isSuperAdmin()
    {
        return $this->hasRole('Super Admin');
    }

    function hasRole($roles)
    {
        return auth()->user()?->hasRole($roles);
    }

    function hasPermission($permissions)
    {
        return auth()->user()?->hasPermissionTo($permissions);
    }
}
