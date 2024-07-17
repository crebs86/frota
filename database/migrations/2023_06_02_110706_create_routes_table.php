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
        Schema::create('routes', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('task');
            $table->foreign('task')
                ->references('id')
                ->on('tasks');

            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->unsignedBigInteger('to');
            $table->foreign('to')
                ->references('id')
                ->on('branches');

            $table->integer('vacancy')->nullable();
            //$table->integer('order');
            $table->date('date');
            $table->time('time');
            $table->timestamp('started_at')->nullable();
            $table->timestamp('ended_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('routes');
    }
};
