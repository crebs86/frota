<?php

namespace App\Regulacao\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PostoColeta extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'postos_coleta';
    protected $fillable = ['id'];
}
