<?php

namespace Database\Seeders;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class FrotaDatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {

        $this->call(FrotaInitTimetablesTableSeeder::class);
        $this->call(FrotaInitPermissionsTableSeeder::class);
        $this->call(FrotaInitRolesTableSeeder::class);
        $this->call(FrotaInitRoleHasPermissionsTableSeeder::class);
        $this->call(FrotaInitDriversPermissionsSeeder::class);
    }
}
