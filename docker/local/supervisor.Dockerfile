FROM composer as composer-cli

FROM php:8.3-cli-alpine

RUN set -xe

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache pcre-dev yaml-dev libzip-dev curl-dev linux-headers supervisor $PHPIZE_DEPS \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install bcmath opcache curl zip pdo pdo_mysql zip ctype pcntl \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install yaml && docker-php-ext-enable yaml \
    && pecl install timezonedb && docker-php-ext-enable timezonedb \
    && pecl install -o -f apcu && docker-php-ext-enable apcu

COPY --from=composer-cli /usr/bin/composer /usr/bin/composer

COPY ./docker/local/php.ini /usr/local/etc/php/conf.d/base.ini
COPY ./docker/local/supervisord.conf /etc/supervisord.conf
COPY ./docker/local/consumers.ini /etc/supervisor.d/

WORKDIR /var/www/html

CMD /usr/bin/supervisord -n
