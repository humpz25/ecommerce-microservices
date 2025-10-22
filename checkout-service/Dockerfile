FROM php:8.2-fpm-alpine

RUN apk add --no-cache oniguruma-dev libzip-dev zip unzip bash icu-dev
RUN docker-php-ext-install pdo pdo_mysql mbstring intl

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .

RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
