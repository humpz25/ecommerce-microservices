<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\OrderSummaryMail;

class EmailController extends Controller
{
    public function sendOrderSummary(Request $request)
    {
        $data = $request->validate([
            'user_email' => 'required|email',
            'order' => 'required|array',
        ]);

        Mail::to($data['user_email'])->send(new OrderSummaryMail($data['order']));

        return response()->json(['message' => 'Email sent successfully']);
    }
}
