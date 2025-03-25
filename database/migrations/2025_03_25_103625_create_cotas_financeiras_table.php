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
        Schema::create('cotas_financeiras', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('posto_coleta');
            $table->foreign('posto_coleta')
                ->references('id')
                ->on('postos_coleta');

            $table->unsignedBigInteger('contrato');
            $table->foreign('contrato')
                ->references('id')
                ->on('contratos');

            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->decimal('valor');
            $table->text('alteracoes')->nullable();

            $table->timestamp('inicio');
            $table->timestamp('fim');

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cotas_financeiras');
    }
};
