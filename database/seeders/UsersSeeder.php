<?php

namespace Database\Seeders;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create('pt_BR');
        for ($i = 1; $i <= 0; $i++) {
            $a = rand(0, 200);
            $b = rand(0, 4);
            $c = rand(0, 201);

            $branches = [];
            foreach (range(1, rand(1, 4)) as $v) {
                $branches = array_merge([range(1, 25)[rand(0, 24)]], $branches);
            }

            $email = $faker->email;
            $name = $faker->name;
            $nameSlug = Str::slug(

                Str::replace([
                    ' jr.',
                    'dr.',
                    'dra.',
                    'sr.',
                    'sra.',
                    'srta.',
                    ' de ',
                    ' da ',
                    ' das ',
                    ' do ',
                    ' dos ',
                    ' neto',
                    ' sobrinho',
                ], ' ', Str::lower($name)),

                '.'
            );

            DB::table('users')->insert([
                'name' => $name,
                'email' => $nameSlug . '@' . Str::after($email, '@'),
                'cpf' => str_replace('-', '', str_replace('.', '', $faker->unique()->cpf)),
                'notes' => $faker->text(rand(25, 200)),
                //'branch_id' => $a % 4 !== 0 ? json_encode($branches) : null,
                'password' => '$2y$10$s2Hogvn1G3ZC/3SGG9we/exaibaCHDjZPIfNODSpjDVZLdv99sMBy', //12345678
                'email_verified_at' => $b % 2 === 0 || $b % 3 === 0 ? now() : null,
                'deleted_at' => $c % 3 === 0 && $c % 2 === 0 ? now() : null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
