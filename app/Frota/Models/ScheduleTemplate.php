<?php

namespace App\Frota\Models;

use App\Models\User;
use App\Frota\Models\Driver;
use Spatie\Permission\Traits\HasRoles;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ScheduleTemplate extends Model
{
    use HasFactory, HasRoles, SoftDeletes;

    protected $primaryKey = 'driver';

    public $incrementing = false;

    protected $fillable = ['driver', 'timesMorningStart', 'timesMorningEnd', 'timesAfternoonStart', 'timesAfternoonEnd', 'timesNightStart', 'timesNightEnd', 'timesSpecialStart', 'timesSpecialEnd'];

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'driver')->select('id', 'garagem_id')->with('user', 'garage');
    }
}
