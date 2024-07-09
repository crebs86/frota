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
            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->unsignedBigInteger('driver');
            $table->foreign('driver')
                ->references('id')
                ->on('drivers');

            $table->unsignedBigInteger('car')->nullable();
            $table->foreign('car')
                ->references('id')
                ->on('cars');

            $table->unsignedBigInteger('from');
            $table->foreign('from')
                ->references('id')
                ->on('branches');

            $table->unsignedBigInteger('to');
            $table->foreign('to')
                ->references('id')
                ->on('branches');

            $table->int('vacancy')->nullable();

            $table->int('order');

            $table->string('obs')->nullable();

            $table->date('date');

            $table->time('time');

            $table->timestamps();
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
