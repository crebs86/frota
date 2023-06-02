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
        Schema::create('schedules', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('driver');
            $table->foreign('driver')
                ->references('id')
                ->on('drivers');

            $table->unsignedBigInteger('car');
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

            $table->text('creators');

            $table->string('obs')->nullable();

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('schedules');
    }
};
