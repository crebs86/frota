<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Contrato extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['user', 'contrato', 'ano', 'contratada_nome', 'contratada_cnpj', 'vigencia_inicio', 'vigencia_fim', 'valor_global', 'aditivos', 'descricao', 'ativo'];
}
