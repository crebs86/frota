<?php

namespace App\Frota\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Permission\Traits\HasRoles;

class Driver extends Model
{
    use HasFactory, HasRoles, SoftDeletes;

    protected $fillable = ['id', 'garagem_id', 'carro_favorito', 'proprio', 'matricula', 'cnh'];

    /**
     * @return BelongsTo
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id')->select('id', 'name');
    }


    /**
     * @return BelongsTo
     */
    public function garage(): BelongsTo
    {
        return $this->belongsTo(Garage::class, 'garagem_id', 'id')->select('id', 'deleted_at')->with('branch');
    }

    /**
     * @return BelongsTo
     */
    public function car(): BelongsTo
    {
        return $this->belongsTo(Car::class, 'carro_favorito', 'id')->select('id', 'modelo', 'placa');
    }
}
