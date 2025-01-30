<?php

namespace App\Frota\Models;

use App\Models\Branch;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Garage extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['id'];

    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class, 'id')->select('id', 'name');
    }
}
