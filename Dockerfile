FROM php:8.1-fpm

# Install necessary packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libpq-dev \
    postgresql-client \
    curl \
    ca-certificates && \
    docker-php-ext-install pdo pdo_mysql pdo_pgsql gd

# Clean up cached files to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Manually add the PostgreSQL repository
RUN curl -o /etc/apt/trusted.gpg.d/postgresql.gpg https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && apt-get install -y postgresql-client-16

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
