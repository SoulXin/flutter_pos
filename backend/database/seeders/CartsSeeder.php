<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Carts;

class CartsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Carts::factory()->count(5)->create(); 
    }
}
