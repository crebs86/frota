<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FrotaInitBranchesTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {

        DB::table('branches')->insert(array(
            0 =>
            array(
                'name' => 'Não Cadastrado',
                'notes' => 'Unidade pra locais não cadastrados.',
                'address' => 'Não Cadastrado',
                'created_at	' => now(),
                'updated_at' => now(),
            )
        ));
    }
}
