FROM php:8.0-fpm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    postgresql-client \
    curl \
    ca-certificates \
    build-essential \
    git \
    zlib1g-dev \
    unzip \
    libzip-dev && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install pdo pdo_mysql pdo_pgsql gd

# Clean up cached files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /var/www/html

# Copy the application code into the container
COPY . /var/www/html

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/html

# Install Composer dependencies with verbose logging
RUN composer install --no-dev --optimize-autoloader --verbose --prefer-dist

# Run Laravel commands to cache configuration and routes
RUN php artisan config:cache
RUN php artisan route:cache

# Expose the port that the application will run on
EXPOSE 10000

# Define the command to start the application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]
