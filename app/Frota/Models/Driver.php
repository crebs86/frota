<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Permission\Traits\HasRoles;

class Driver extends Model
{
    use HasFactory, HasRoles, SoftDeletes;

    protected $fillable = ['id', 'garagem', 'carro_favorito', 'proprio', 'matricula', 'cnh'];
}
