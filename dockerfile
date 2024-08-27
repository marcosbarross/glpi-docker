FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    unzip \
    wget \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install xml \
    && docker-php-ext-install json \
    && docker-php-ext-install zip

RUN a2enmod rewrite

RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz && \
    tar -xvzf glpi-10.0.9.tgz -C /var/www/html/ && \
    mv /var/www/html/glpi /var/www/html/public && \
    chown -R www-data:www-data /var/www/html/public && \
    chmod -R 755 /var/www/html/public

RUN echo "<VirtualHost *:80> \n\
    DocumentRoot /var/www/html/public \n\
    <Directory /var/www/html/public> \n\
        Options Indexes FollowSymLinks \n\
        AllowOverride All \n\
        Require all granted \n\
    </Directory> \n\
    ErrorLog /var/log/apache2/error.log \n\
    CustomLog /var/log/apache2/access.log combined \n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

CMD ["apache2-foreground"]
