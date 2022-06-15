<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Categories extends Model
{
    use HasFactory;

    protected $fillable = [
        'users_id',
        'name',
    ];
    
    public function users(){
        return $this->belongsTo(User::class);
    }

    public function products(){
        return $this->hasMany(Products::class);
    }
}
