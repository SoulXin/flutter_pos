<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class CartsFactory extends Factory
{
    protected $model = \App\Models\Carts::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'users_id' => 1,
            'products_id' => $this->faker->unique(true)->numberBetween(1, 10),
            'amount' => $this->faker->unique(true)->numberBetween(1, 3)
        ];
    }
}
