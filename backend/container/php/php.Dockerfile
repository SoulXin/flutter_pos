FROM php:8.0.20-fpm-buster

RUN apt-get update && \
    apt-get install -y zip apt-utils re2c g++ zlib1g zlib1g-dbg zlib1g-dev zlibc

RUN apt-get install -y cron make nano

RUN apt-get install -y --no-install-recommends libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev libzip-dev  \
    # gd
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    # gmp
    && apt-get install -y --no-install-recommends libgmp-dev \
    && docker-php-ext-install gmp
    # pdo_mysql
RUN docker-php-ext-install pdo_mysql \
    # opcache
    && docker-php-ext-enable opcache \
    # zip
    && docker-php-ext-install zip \
    # bcmath
    && docker-php-ext-install bcmath \
    # mysql
    && docker-php-ext-install mysqli \
    # exif
    && docker-php-ext-install exif
    # imagick
#RUN apt-get install -y libmagickwand-dev --no-install-recommends

#RUN pecl install imagick && docker-php-ext-enable imagick
    # xdebug
#RUN pecl install xdebug-2.8.1
#RUN docker-php-ext-enable xdebug

RUN pecl install redis
RUN docker-php-ext-enable redis

#RUN pecl install swoole
#RUN docker-php-ext-enable swoole

    # clean up
RUN apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear/

RUN curl --silent --show-error https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

COPY php/custom.ini /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY html/index.php /var/www/html

# Copy cronjob file to the cron.d directory
COPY php/cronjob /etc/cron.d/cronjob

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cronjob

# Apply cron job
RUN crontab /etc/cron.d/cronjob

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD php-fpm && service cron start && crontab /etc/cron.d/cronjob && tail -f /var/log/cron.log
