FROM php:8.2-apache
COPY . /var/www/html/
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli \
    && rm -rf /var/lib/apt/lists/*
    
EXPOSE 80