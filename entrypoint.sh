#!/bin/sh

# Run database migrations
php artisan migrate --force

php artisan db:seed --force

# Start PHP-FPM
php artisan serve --host=0.0.0.0 --port=10000
