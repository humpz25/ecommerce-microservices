<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Order Summary</title>
</head>
<body>
    <h2>Thank you for your order!</h2>
    <p>We’ve received your order and will process it soon.</p>

    <h3>Order Details:</h3>
    <ul>
        @foreach ($order['items'] as $item)
            <li>
                {{ $item['product_name'] }} (x{{ $item['quantity'] }}) - ${{ $item['price'] }}
            </li>
        @endforeach
    </ul>

    <p><strong>Total: ${{ $order['total_amount'] }}</strong></p>
</body>
</html>
