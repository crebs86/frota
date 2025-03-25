<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CotaFinanceira extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'cotas_financeiras';
    protected $fillable = ['posto_coleta', 'contrato', 'user', 'valor', 'alteracoes', 'inicio', 'fim'];
}
