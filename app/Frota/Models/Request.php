<?php

namespace App\Frota\Models;


use App\Models\Branch;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Request extends Model
{
    use HasFactory;

    protected $fillable = ['user', 'to', 'local', 'vacancy', 'date', 'time', 'passengers', 'status'];

    public $timestamps = false;

    public function branch(): HasOne
    {
        return $this->hasOne(Branch::class, 'id', 'to')->select('id', 'name');
    }

    public function user(): HasOne
    {
        return $this->hasOne(User::class, 'id', 'user')->select('id', 'name');
    }

}
