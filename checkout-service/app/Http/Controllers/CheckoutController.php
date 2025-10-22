<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class CheckoutController extends Controller
{
    public function store(Request $request)
    {
        $data = $request->validate([
            'user_email' => 'required|email',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|integer',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        $total = 0;
        $orderItems = [];

        foreach ($data['items'] as $item) {
            $productResponse = Http::get(env('CATALOG_URL') . "/products/{$item['product_id']}");

            if ($productResponse->failed()) {
                return response()->json(['error' => 'Product not found'], 404);
            }

            $product = $productResponse->json();
            $subtotal = $product['price'] * $item['quantity'];
            $total += $subtotal;

            $orderItems[] = [
                'product_id' => $product['id'],
                'product_name' => $product['name'],
                'price' => $product['price'],
                'quantity' => $item['quantity'],
            ];
        }

        $order = Order::create([
            'user_email' => $data['user_email'],
            'total_amount' => $total,
        ]);

        foreach ($orderItems as $item) {
            $order->items()->create($item);
        }

        // Prepare order array for email
        $orderArray = [
            'id' => $order->id,
            'user_email' => $order->user_email,
            'total_amount' => $order->total_amount,
            'items' => $order->items->map(function($item) {
                return [
                    'product_id' => $item->product_id,
                    'product_name' => $item->product_name,
                    'price' => $item->price,
                    'quantity' => $item->quantity,
                ];
            })->toArray(),
        ];

        // Send order summary to email service
        Http::post(env('EMAIL_URL') . '/send-order-summary', [
            'user_email' => $data['user_email'],
            'order' => $orderArray,
        ]);

        return response()->json([
            'message' => 'Order placed successfully!',
            'order' => $orderArray,
        ]);
    }
}
