<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Permission\Traits\HasRoles;

class Fuel extends Model
{
    use HasFactory, HasRoles, SoftDeletes;

    protected $fillable = ['car', 'driver', 'km', 'quantidade', 'valor', 'local', 'observacao', 'arquivo', 'hora'];

    public function carModel(): BelongsTo
    {
        return $this->belongsTo(Car::class, 'car')->select('id', 'modelo', 'placa');
    }
}
