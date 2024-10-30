FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    ...

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd

COPY . /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:cache
RUN php artisan route:cache

EXPOSE 9000

CMD ["php-fpm"]
