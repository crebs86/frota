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
        Schema::create('maintenance', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('car');
            $table->foreign('car')
                ->references('id')
                ->on('cars');

            $table->integer('km_arrival')->nullable();
            $table->integer('km_departure')->nullable();
            $table->timestamp('date_arrival')->nullable();
            $table->timestamp('date_departure')->nullable();

            /**
             * 1 Preventiva
             * 2 Corretiva
             */
            $table->integer('type');

            $table->date('date');
            $table->string('place')->nullable();
            $table->string('mechanic')->nullable();
            $table->string('replaces')->nullable();
            $table->float('cost')->nullable();

            $table->text('obs')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('maintenance');
    }
};
