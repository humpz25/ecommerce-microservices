FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache bash icu-dev oniguruma-dev libzip-dev zip unzip libxml2-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring intl xml

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
