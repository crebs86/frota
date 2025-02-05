<?php

namespace Database\Seeders;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class InitUsersTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        $email = 'frota@frota.app';
        $senha = bcrypt('baseapps');
        $cpf = '00000000000';

        if (file_exists(app_path() . '/instalar/instalacao.php')) {
            include(app_path() . '/instalar/instalacao.php');
            $email = $emailAdministrador !== '' ? $emailAdministrador : $email;
            $senha = $senhaAdministrador !== '' ? bcrypt($senhaAdministrador) : $senha;
            $cpf = $cpfAdministrador !== '' ? $cpfAdministrador :  $cpf;
        }

        DB::table('drivers')->delete();
        DB::table('users')->delete();

        DB::table('users')->insert(array(
            0 =>
            array(
                'branch_id' => NULL,
                'cpf' => $cpf,
                'created_at' => now(),
                'deleted_at' => NULL,
                'email' => $email,
                'email_verified_at' => now(),
                'id' => 1,
                'name' => 'Super Admin',
                'notes' => 'Default User',
                'password' => $senha,
                'remember_token' => NULL,
                'updated_at' => now(),
            ),
            1 =>
            array(
                'branch_id' => NULL,
                'cpf' => '00000000001',
                'created_at' => now(),
                'deleted_at' => NULL,
                'email' => Str::random(5),
                'email_verified_at' => now(),
                'id' => 2,
                'name' => '-',
                'notes' => 'Default Driver',
                'password' => bcrypt(Str::random(12)),
                'remember_token' => NULL,
                'updated_at' => now(),
            ),
        ));

        DB::table('drivers')->insert(
            array(
                0 =>
                array(
                    'id' => 2,
                    'garagem_id' => NULL,
                    'proprio' => 0,
                    'created_at' => now(),
                    'updated_at' => now(),
                    'deleted_at' => now(),
                ),
            )
        );
    }
}
