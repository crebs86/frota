<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FrotaInitRolesTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {

        DB::table('roles')->insert(array(
            0 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 8,
                'name' => 'Motorista',
                'updated_at' => now(),
            ),
            1 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 9,
                'name' => 'Motorista Administrar',
                'updated_at' => now(),
            ),
            2  =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 10,
                'name' => 'Carro Administrar',
                'updated_at' => now(),
            ),
            3  =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 11,
                'name' => 'Agenda Administrar',
                'updated_at' => now(),
            ),
            4 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 12,
                'name' => 'Tarefa Administrar',
                'updated_at' => now(),
            ),
            5 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 13,
                'name' => 'Ocorrencia Administrar',
                'updated_at' => now(),
            ),
            6 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 14,
                'name' => 'Garagem Administrar',
                'updated_at' => now(),
            ),
            7 =>
            array(
                'created_at' => now(),
                'guard_name' => 'web',
                'id' => 15,
                'name' => 'Combustivel Administrar',
                'updated_at' => now(),
            ),
        ));
    }
}
