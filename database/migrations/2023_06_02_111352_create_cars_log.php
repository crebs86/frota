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
        Schema::create('cars_log', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('route');
            $table->foreign('route')
                ->references('id')
                ->on('routes');

            $table->unsignedBigInteger('car');
            $table->foreign('car')
                ->references('id')
                ->on('cars');

            $table->string('type');

            $table->unique(['route', 'type']);

            $table->integer('km');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cars_log');
    }
};
