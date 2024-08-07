<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('drivers', function (Blueprint $table) {
            // $table->id();

            // $table->unsignedBigInteger('driver');
            // $table->foreign('driver')
            //     ->references('id')
            // ->on('users');

            $table->unsignedBigInteger('id')->unique();
            $table->foreign('id')
                ->references('id')
                ->on('users');

            $table->unsignedBigInteger('garagem_id')->nullable();
            $table->foreign('garagem_id')
                ->references('id')
                ->on('garages');

            $table->unsignedBigInteger('carro_favorito')->nullable();
            $table->foreign('carro_favorito')
                ->references('id')
                ->on('cars');

            $table->boolean('proprio')->default(false);
            $table->string('matricula', 55)->nullable();
            $table->boolean('cnh')->nullable();

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('drivers');
    }
};
