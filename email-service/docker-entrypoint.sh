#!/bin/sh
set -e

# Run only the service-specific migrations
php artisan migrate --force

# Start the server
php artisan serve --host=0.0.0.0 --port=8000
