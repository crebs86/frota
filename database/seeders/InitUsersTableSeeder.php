<?php

namespace Database\Seeders;

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
        ));
    }
}
