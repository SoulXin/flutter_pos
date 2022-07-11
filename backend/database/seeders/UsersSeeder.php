<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;

class UsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        User::firstOrCreate(
            ['username' => 'admin'],
        	['password' => bcrypt('admin')],
        );

        User::firstOrCreate(
            ['username' => 'admin2'],
        	['password' => bcrypt('admin2')],
        );
    }
}
