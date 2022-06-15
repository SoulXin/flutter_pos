<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    use HasFactory;

    protected $fillable = [
        'users_id',
        'categories_id',
        'name',
        'price'
    ];

    public function users(){
        return $this->belongsTo(User::class);
    }

    public function categories(){
        return $this->belongsTo(Categories::class);
    }
}
