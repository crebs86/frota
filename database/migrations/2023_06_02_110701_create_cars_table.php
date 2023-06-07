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
        Schema::create('cars', function (Blueprint $table) {
            $table->id();
            $table->string('marca', 25);
            $table->string('modelo', 55);
            $table->string('placa', 7)->unique();
            $table->boolean('patrimonio', false);
            $table->string('tombo', 55)->nullable();
            
            $table->unsignedBigInteger('garagem_id')->nullable();
            $table->foreign('garagem_id')
                ->references('id')
                ->on('garages');
                
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cars');
    }
};
