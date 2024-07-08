<?php

namespace Database\Seeders;

use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class BranchesSeed extends Seeder
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

            DB::table('branches')->insert([
                'name' => $name,
                'email' => 'un_' . $nameSlug . '@' . Str::after($email, '@'),
                'cnpj' => $faker->unique()->cnpj(false),
                'phones' => $faker->phoneNumber(),
                'notes' => $faker->text(rand(25, 200)),
                'cep' => Str::replace('-', '', Str::limit($address, 9, null)),
                'address' => $address,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
