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
        Schema::create('justifications', function (Blueprint $table) {

            $table->unsignedBigInteger('route')->unique();
            $table->foreign('route')
                ->references('id')
                ->on('routes');

            $table->unsignedBigInteger('user');
            $table->foreign('user')
                ->references('id')
                ->on('users');

            $table->string('justification', 255);

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('justifications');
    }
};
