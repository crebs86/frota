<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Requisicao extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'requisicoes';
}
