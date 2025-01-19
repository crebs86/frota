<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('requests', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('driver')->nullable();
            $table->foreign('driver')
                ->references('id')
                ->on('drivers');

            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->unsignedBigInteger('mediator')->nullable();
            $table->foreign('mediator')
                ->references('id')
                ->on('users');

            $table->unsignedBigInteger('to');
            $table->foreign('to')
                ->references('id')
                ->on('branches');

            $table->string('local', 255)->nullable();

            $table->integer('vacancy')->nullable();
            $table->date('date');
            $table->time('time');
            $table->string('passengers', 510)->nullable();
            $table->integer('status')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('requests');
    }
};
