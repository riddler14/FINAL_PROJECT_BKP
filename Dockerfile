FROM php:8.1-fpm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    curl \
    ca-certificates \
    build-essential \
    git

# Install PDO and other extensions manually
RUN docker-php-source extract && \
    cd /usr/src/php/ext/pdo && \
    ./configure && make && make install && \
    cd /usr/src/php/ext/pdo_mysql && \
    ./configure && make && make install && \
    cd /usr/src/php/ext/pdo_pgsql && \
    ./configure && make && make install && \
    cd /usr/src/php/ext/gd && \
    ./configure && make && make install && \
    docker-php-source delete

# Clean up cached files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/www/html

# Copy the application code into the container
COPY . /var/www/html

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Run Laravel commands to cache configuration and routes
RUN php artisan config:cache
RUN php artisan route:cache

# Expose the port that the application will run on
EXPOSE 9000

# Define the command to start the application
CMD ["php-fpm"]
