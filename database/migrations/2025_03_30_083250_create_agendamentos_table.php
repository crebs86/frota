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
        Schema::create('agendamentos', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('agenda');
            $table->foreign('agenda')
                ->references('id')
                ->on('agendas');

            $table->unsignedInteger('CodRequisicao');
            $table->unsignedInteger('CodExameLaboratorial');
            $table->decimal('valor');

            $table->softDeletes();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('agendamentos');
    }
};
