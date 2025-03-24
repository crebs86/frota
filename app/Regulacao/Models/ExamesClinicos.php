<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ExamesClinicos extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'exames_clinicos';
}
