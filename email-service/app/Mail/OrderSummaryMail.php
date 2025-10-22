<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class OrderSummaryMail extends Mailable
{
    use Queueable, SerializesModels;

    public $order;

    public function __construct($order)
    {
        $this->order = $order;
    }

    public function build()
    {
        return $this->subject('Your Order Summary')
                    ->view('emails.order-summary');
    }
}
