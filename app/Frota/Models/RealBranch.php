<?php

namespace App\Frota\Models;


use App\Models\Branch;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RealBranch extends Model
{
    use HasFactory;

    protected $fillable = ['route', 'name'];

    public $timestamps = false;

    protected $primaryKey = 'route';
}
