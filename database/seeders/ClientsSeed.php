<?php

namespace Database\Seeders;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ClientsSeed extends Seeder
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
            $c = rand(0, 201);
            $address = $faker->address;

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

            DB::table('clients')->insert([
                'name' => $name,
                'email' => $nameSlug . '@' . Str::after($email, '@'),
                'cep' => Str::replace('-', '', Str::limit($address, 9, null)),
                'address' => $address,
                'cpf' => str_replace('-', '', str_replace('.', '', $faker->unique()->cpf)),
                'phones' => $faker->phoneNumber(),
                'notes' => $faker->text(rand(25, 200)),
                'branch_id' => $a % 4 !== 0 ? rand(1, 50) : null,
                'deleted_at' => $c % 3 === 0 && $c % 2 === 0 ? now() : null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
