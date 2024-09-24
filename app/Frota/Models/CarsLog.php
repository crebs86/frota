<?php

namespace App\Frota\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CarsLog extends Model
{
    use HasFactory;

    protected $fillable = ['route', 'car', 'km', 'type'];

    protected $table = 'cars_log';

    public $timestamps = false;
}
