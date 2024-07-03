<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FrotaInitDriversPermissionsSeeder extends Seeder
{

    public function run()
    {

        //DB::table('role_has_permissions')->delete();

        DB::table('role_has_permissions')->insert(array(
            24 =>
            array(
                'permission_id' => 39,
                'role_id' => 8,
            ),
            25 =>
            array(
                'permission_id' => 40,
                'role_id' => 8,
            ),
            26 =>
            array(
                'permission_id' => 41,
                'role_id' => 8,
            ),
            27 =>
            array(
                'permission_id' => 42,
                'role_id' => 8,
            ),
            28 =>
            array(
                'permission_id' => 35,
                'role_id' => 8,
            ),
            29 =>
            array(
                'permission_id' => 38,
                'role_id' => 8,
            ),
            30 =>
            array(
                'permission_id' => 36,
                'role_id' => 8,
            ),
            31 =>
            array(
                'permission_id' => 37,
                'role_id' => 8,
            ),
            32 =>
            array(
                'permission_id' => 21,
                'role_id' => 8,
            ),

        ));
    }
}
