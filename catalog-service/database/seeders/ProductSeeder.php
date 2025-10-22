<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Product::insert([
            ['name' => 'iPhone 16', 'description' => 'Latest Apple iPhone', 'price' => 1299.99, 'stock' => 15],
            ['name' => 'MacBook Air M3', 'description' => 'Lightweight and powerful laptop', 'price' => 1599.99, 'stock' => 10],
            ['name' => 'AirPods Pro 2', 'description' => 'Noise-cancelling wireless earbuds', 'price' => 249.99, 'stock' => 25],
        ]);
    }
}
