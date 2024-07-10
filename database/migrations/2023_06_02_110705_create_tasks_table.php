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
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('driver');
            $table->foreign('driver')
                ->references('id')
                ->on('drivers');

            $table->unsignedBigInteger('car')->nullable();
            $table->foreign('car')
                ->references('id')
                ->on('cars');

            $table->string('obs')->nullable();
            $table->date('date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
