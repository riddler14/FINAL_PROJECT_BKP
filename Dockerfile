FROM php:8.1-fpm

# Update package lists
RUN apt-get update

# Install dependencies
RUN apt-get install -y libpq-dev postgresql-client curl ca-certificates

# Install PHP extensions with detailed logging
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql gd --log-level=debug

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
