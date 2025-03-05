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
        Schema::create('attaches', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('maintenance_id');
            $table->foreign('maintenance_id')
                ->references('id')
                ->on('maintenance');

            /**
             * 1 invoice
             * 2 photo
             * 3 service_order
             * 4 report
             */
            $table->integer('type');
            /**
             * 202501012359_123456_abcd
             */
            $table->string('filename', 24);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attaches');
    }
};
