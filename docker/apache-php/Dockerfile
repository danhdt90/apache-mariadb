ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-apache

# Set timezone
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libicu-dev \
    libmagickwand-dev \
    nano \
    htop \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mysqli \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
        soap \
        opcache

# Install ImageMagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# XDebug installation temporarily removed
# RUN pecl install xdebug \
#     && docker-php-ext-enable xdebug

# Enable Apache modules
RUN a2enmod rewrite ssl headers expires deflate

# Copy Apache configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Copy PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
# XDebug config temporarily removed
# COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create directory for logs
RUN mkdir -p /var/log/apache2 /var/log/php

# Set permissions
RUN chown -R www-data:www-data /var/www/html /var/log/apache2 /var/log/php \
    && chmod -R 755 /var/www/html

# Create a startup script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]