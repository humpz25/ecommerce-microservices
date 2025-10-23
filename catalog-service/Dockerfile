FROM php:8.2-fpm-alpine

# -------------------------
# Install system dependencies
# -------------------------
RUN apk add --no-cache \
    bash \
    git \
    zip \
    unzip \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    autoconf \
    g++ \
    make \
    zlib-dev

# -------------------------
# Install PHP extensions
# -------------------------
RUN docker-php-ext-install pdo pdo_mysql mbstring intl zip

# -------------------------
# Install Composer globally
# -------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# -------------------------
# Set working directory
# -------------------------
WORKDIR /var/www

# -------------------------
# Copy project files
# -------------------------
COPY . .

# -------------------------
# Install PHP dependencies
# -------------------------
RUN composer install --no-dev --optimize-autoloader --no-interaction

# -------------------------
# Entrypoint
# -------------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
