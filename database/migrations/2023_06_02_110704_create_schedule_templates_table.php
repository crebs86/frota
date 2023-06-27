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
        Schema::create('schedule_templates', function (Blueprint $table) {

            $table->unsignedBigInteger('driver')->primary();
            $table->foreign('driver')
                ->references('id')
                ->on('drivers');

            $table->unsignedBigInteger('timesMorningStart')->nullable();
            $table->foreign('timesMorningStart')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesMorningEnd')->nullable();
            $table->foreign('timesMorningEnd')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesAfternoonStart')->nullable();
            $table->foreign('timesAfternoonStart')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesAfternoonEnd')->nullable();
            $table->foreign('timesAfternoonEnd')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesNightStart')->nullable();
            $table->foreign('timesNightStart')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesNightEnd')->nullable();
            $table->foreign('timesNightEnd')
                ->references('id')
                ->on('timetables');


            $table->unsignedBigInteger('timesSpecialStart')->nullable();
            $table->foreign('timesSpecialStart')
                ->references('id')
                ->on('timetables');

            $table->unsignedBigInteger('timesSpecialEnd')->nullable();
            $table->foreign('timesSpecialEnd')
                ->references('id')
                ->on('timetables');

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('schedule_templates');
    }
};
