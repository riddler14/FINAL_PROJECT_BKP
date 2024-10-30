FROM php:8.2-fpm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    curl \
    ca-certificates \
    build-essential \
    git

# Install PHP extensions using PECL
RUN pecl install pdo pdo_mysql pdo_pgsql gd

# Enable the installed extensions
RUN docker-php-ext-enable pdo pdo_mysql pdo_pgsql gd

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
