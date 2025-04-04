<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Agenda extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['vigencia_inicio', 'vigencia_fim', 'hora_inicio', 'hora_fim', 'intervalo', 'vagas', 'user', 'alteracoes'];
}
