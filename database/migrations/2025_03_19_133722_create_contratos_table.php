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
        Schema::create('contratos', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->integer('contrato');
            $table->integer('ano');
            $table->string('contratada_nome');
            $table->string('contratada_cnpj', 14);
            $table->date('vigencia_inicio');
            $table->date('vigencia_fim');
            $table->decimal('valor_global', 11, 2);
            $table->text('aditivos');
            $table->string('descricao', 550);
            $table->boolean('ativo');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('contratos');
    }
};
