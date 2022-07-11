<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ProductsFactory extends Factory
{
    protected $model = \App\Models\Products::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'user_id' => $this->faker->unique(true)->numberBetween(1, 2),
            'categories_id' => $this->faker->unique(true)->numberBetween(1, 5),
            'name' => 'Product '. $this->faker->userName,
            'price' => $this->faker->unique(true)->numberBetween(1000, 5000)
        ];
    }
}
