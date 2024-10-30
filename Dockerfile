FROM php:8.1-fpm

RUN apt-get install -y curl ca-certificates
RUN curl -o /etc/apt/trusted.gpg.d/postgresql.gpg https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y postgresql-client-16 libpq-dev


RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd

COPY . /var/www/html
WORKDIR /var/www/html

RUN composer install --no-dev --optimize-autoloader

RUN php artisan config:cache
RUN php artisan route:cache

EXPOSE 9000

CMD ["php-fpm"]
