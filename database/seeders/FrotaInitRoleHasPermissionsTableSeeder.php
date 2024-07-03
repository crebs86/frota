<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FrotaInitRoleHasPermissionsTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {


        DB::table('role_has_permissions')->insert(array(
            0 =>
            array(
                'permission_id' => 23,
                'role_id' => 9,
            ),
            1 =>
            array(
                'permission_id' => 24,
                'role_id' => 9,
            ),
            2 =>
            array(
                'permission_id' => 25,
                'role_id' => 9,
            ),
            3 =>
            array(
                'permission_id' => 26,
                'role_id' => 9,
            ),
            4 =>
            array(
                'permission_id' => 27,
                'role_id' => 10,
            ),
            5 =>
            array(
                'permission_id' => 28,
                'role_id' => 10,
            ),
            6 =>
            array(
                'permission_id' => 29,
                'role_id' => 10,
            ),
            7 =>
            array(
                'permission_id' => 30,
                'role_id' => 10,
            ),
            8 =>
            array(
                'permission_id' => 31,
                'role_id' => 11,
            ),
            9 =>
            array(
                'permission_id' => 32,
                'role_id' => 11,
            ),
            10 =>
            array(
                'permission_id' => 33,
                'role_id' => 11,
            ),
            11 =>
            array(
                'permission_id' => 34,
                'role_id' => 11,
            ),
            12 =>
            array(
                'permission_id' => 35,
                'role_id' => 12,
            ),
            13 =>
            array(
                'permission_id' => 36,
                'role_id' => 12,
            ),
            14 =>
            array(
                'permission_id' => 37,
                'role_id' => 12,
            ),
            15 =>
            array(
                'permission_id' => 38,
                'role_id' => 12,
            ),
            16 =>
            array(
                'permission_id' => 39,
                'role_id' => 13,
            ),
            17 =>
            array(
                'permission_id' => 40,
                'role_id' => 13,
            ),
            18 =>
            array(
                'permission_id' => 41,
                'role_id' => 13,
            ),
            19 =>
            array(
                'permission_id' => 42,
                'role_id' => 13,
            ),
            20 =>
            array(
                'permission_id' => 43,
                'role_id' => 14,
            ),
            21 =>
            array(
                'permission_id' => 44,
                'role_id' => 14,
            ),
            22 =>
            array(
                'permission_id' => 45,
                'role_id' => 14,
            ),
            23 =>
            array(
                'permission_id' => 46,
                'role_id' => 14,
            ),
        ));
    }
}
