<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Carts extends Model
{
    use HasFactory;

    protected $fillable = [
        'users_id',
        'products_id',
        'amount'
    ];

    public function users(){
        return $this->belongsTo(User::class);
    }

    public function categories(){
        return $this->belongsTo(Products::class);
    }
}
