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
        $this->call(InitSettingsTableSeeder::class);
        $this->call(BranchesSeed::class);
        $this->call(ClientsSeed::class);
        $this->call(InitUsersTableSeeder::class);
        $this->call(UsersSeeder::class);
        $this->call(InitPermissionsTableSeeder::class);
        $this->call(InitRolesTableSeeder::class);
        $this->call(InitRoleHasPermissionsTableSeeder::class);
        $this->call(InitModelHasRolesTableSeeder::class);

        $this->call(FrotaDatabaseSeeder::class);
    }
}
