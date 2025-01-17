<?php

namespace Database\Seeders;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        if (file_exists(app_path() . '/instalar/instalacao.php')) {
            include(app_path() . '/instalar/instalacao.php');
            $this->call(InitSettingsTableSeeder::class);
            $modo === 'dev' ? $this->call(BranchesSeed::class) : null;
            $modo === 'dev' ? $this->call(ClientsSeed::class) : null;
            $this->call(InitUsersTableSeeder::class);
            $modo === 'dev' ? $this->call(UsersSeeder::class) : null;
            $this->call(InitPermissionsTableSeeder::class);
            $this->call(InitRolesTableSeeder::class);
            $this->call(InitRoleHasPermissionsTableSeeder::class);
            $this->call(InitModelHasRolesTableSeeder::class);
        }

        $this->call(FrotaDatabaseSeeder::class);
    }
}
