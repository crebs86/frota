<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FrotaInitPermissionsTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {


        DB::table('permissions')->insert(array(
            0 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 23,
                    'name' => 'Motorista Criar',
                    'updated_at' => now(),
                ),
            1 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 24,
                    'name' => 'Motorista Ver',
                    'updated_at' => now(),
                ),
            2 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 25,
                    'name' => 'Motorista Apagar',
                    'updated_at' => now(),
                ),
            3 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 26,
                    'name' => 'Motorista Editar',
                    'updated_at' => now(),
                ),
            4 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 27,
                    'name' => 'Carro Criar',
                    'updated_at' => now(),
                ),
            5 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 28,
                    'name' => 'Carro Ver',
                    'updated_at' => now(),
                ),
            6 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 29,
                    'name' => 'Carro Apagar',
                    'updated_at' => now(),
                ),
            7 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 30,
                    'name' => 'Carro Editar',
                    'updated_at' => now(),
                ),
            8 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 31,
                    'name' => 'Agenda Criar',
                    'updated_at' => now(),
                ),
            9 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 32,
                    'name' => 'Agenda Ver',
                    'updated_at' => now(),
                ),
            10 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 33,
                    'name' => 'Agenda Apagar',
                    'updated_at' => now(),
                ),
            11 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 34,
                    'name' => 'Agenda Editar',
                    'updated_at' => now(),
                ),
            12 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 35,
                    'name' => 'Tarefa Criar',
                    'updated_at' => now(),
                ),
            13 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 36,
                    'name' => 'Tarefa Ver',
                    'updated_at' => now(),
                ),
            14 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 37,
                    'name' => 'Tarefa Apagar',
                    'updated_at' => now(),
                ),
            15 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 38,
                    'name' => 'Tarefa Editar',
                    'updated_at' => now(),
                ),
            16 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 39,
                    'name' => 'Ocorrencia Criar',
                    'updated_at' => now(),
                ),
            17 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 40,
                    'name' => 'Ocorrencia Ver',
                    'updated_at' => now(),
                ),
            18 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 41,
                    'name' => 'Ocorrencia Apagar',
                    'updated_at' => now(),
                ),
            19 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 42,
                    'name' => 'Ocorrencia Editar',
                    'updated_at' => now(),
                ),
            20 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 43,
                    'name' => 'Garagem Criar',
                    'updated_at' => now(),
                ),
            21 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 44,
                    'name' => 'Garagem Ver',
                    'updated_at' => now(),
                ),
            22 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 45,
                    'name' => 'Garagem Apagar',
                    'updated_at' => now(),
                ),
            23 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 46,
                    'name' => 'Garagem Editar',
                    'updated_at' => now(),
                ),
            24 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 47,
                    'name' => 'Combustivel Criar',
                    'updated_at' => now(),
                ),
            25 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 48,
                    'name' => 'Combustivel Ver',
                    'updated_at' => now(),
                ),
            26 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 49,
                    'name' => 'Combustivel Apagar',
                    'updated_at' => now(),
                ),
            27 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 50,
                    'name' => 'Combustivel Editar',
                    'updated_at' => now(),
                ),
            28 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 51,
                    'name' => 'Solicitacao Criar',
                    'updated_at' => now(),
                ), 29 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 52,
                    'name' => 'Solicitacao Ver',
                    'updated_at' => now(),
                ),
            30 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 53,
                    'name' => 'Solicitacao Apagar',
                    'updated_at' => now(),
                ),
            31 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 54,
                    'name' => 'Solicitacao Editar',
                    'updated_at' => now(),
                ),
            32 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 55,
                    'name' => 'Liberador',
                    'updated_at' => now(),
                ),
            33 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 56,
                    'name' => 'Manutencao Criar',
                    'updated_at' => now(),
                ),
            34 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 57,
                    'name' => 'Manutencao Ver',
                    'updated_at' => now(),
                ),
            35 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 58,
                    'name' => 'Manutencao Editar',
                    'updated_at' => now(),
                ),
            36 =>
                array(
                    'created_at' => now(),
                    'guard_name' => 'web',
                    'id' => 59,
                    'name' => 'Manutencao Apagar',
                    'updated_at' => now(),
                ),
        ));
    }
}
