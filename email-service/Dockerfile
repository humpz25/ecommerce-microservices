FROM php:8.2-fpm-alpine
RUN apk add --no-cache oniguruma-dev libzip-dev zip unzip bash icu-dev
RUN docker-php-ext-install pdo pdo_mysql mbstring intl
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction
CMD php artisan serve --host=0.0.0.0 --port=8000
