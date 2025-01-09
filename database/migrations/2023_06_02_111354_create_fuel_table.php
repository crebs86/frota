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
        Schema::create('fuel', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('car')->unique();
            $table->foreign('car')
                ->references('id')
                ->on('cars');

            $table->unsignedBigInteger('driver')->unique();
            $table->foreign('driver')
                ->references('id')
                ->on('users');

            $table->string('km');
            $table->string('quantidade');
            $table->string('valor')->nullable();
            $table->string('local')->nullable();
            $table->text('observacao')->nullable();
            $table->text('arquivo')->nullable();
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('fuel');
    }
};
