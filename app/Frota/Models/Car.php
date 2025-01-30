<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Car extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['marca', 'modelo', 'placa', 'garagem_id', 'patrimonio', 'tombo'];

    public function garage()
    {
        return $this->belongsTo(Garage::class, 'garagem_id', 'id')->select('id')->with('branch');
    }
}
