FROM composer as composer-cli

FROM php:8.3-fpm-alpine

RUN set -xe

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache pcre-dev yaml-dev libzip-dev curl-dev postgresql-dev linux-headers $PHPIZE_DEPS \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install yaml && docker-php-ext-enable yaml \
    && docker-php-ext-configure bcmath --enable-bcmath && docker-php-ext-install bcmath \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install opcache curl zip pdo pdo_pgsql pdo_mysql zip ctype \
    && pecl install timezonedb && docker-php-ext-enable timezonedb \
    && pecl install -o -f apcu && docker-php-ext-enable apcu \
    && pecl install xdebug && docker-php-ext-enable xdebug

COPY --from=composer-cli /usr/bin/composer /usr/bin/composer

COPY ./docker/local/php.ini /usr/local/etc/php/conf.d/base.ini

WORKDIR /var/www/html

FROM php:8.2-cli-alpine AS supervisor

RUN set -xe

ENV COMPOSER_ALLOW_SUPERUSER=1

ENV YAML_VERSION 2.0.4

RUN echo "http://dl-cdn.alpinelinux.org/alpine/latests-stable/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
    && apk add --update --no-cache \
    make \
    gcc \
    g++ \
    autoconf \
    nano \
    bash \
    git \
    coreutils \
    libcurl \
    curl-dev \
    libpng \
    libpng-dev \
    pcre \
    pcre-dev \
    libzip \
    libzip-dev \
    openssl \
    openssl-dev \
    oniguruma-dev \
    openssh-client \
    rabbitmq-c \
    rabbitmq-c-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    jpeg-dev \
    freetype \
    freetype-dev \
    icu-dev \
    icu-libs \
    php82-dev \
    libpq \
    yaml \
    yaml-dev \
    postgresql-dev \
    linux-headers \
    supervisor \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install yaml \
    && docker-php-ext-enable yaml \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-install bcmath opcache intl curl gd pcntl shmop zip pdo pdo_pgsql mbstring zip sockets \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
    && pecl install timezonedb \
    && docker-php-ext-enable timezonedb \
    && pecl install -o -f apcu \
    && docker-php-ext-enable apcu \
    && mkdir /etc/supervisor.d \
    && apk del libpng-dev \
               pcre-dev \
               libzip-dev \
               openssl-dev \
               rabbitmq-c-dev \
               libjpeg-turbo-dev \
               jpeg-dev \
               freetype-dev \
               icu-dev \
               make \
               gcc \
               g++ \
               autoconf \
               php82-dev \
    && rm -rf /var/cache/apk/* \
    && rm -rf /usr/src \
    && rm -rf /tmp/*

COPY --from=composer-cli /usr/bin/composer /usr/bin/composer

COPY ./docker/local/php.ini /usr/local/etc/php/conf.d/base.ini
COPY ./docker/local/supervisord.conf /etc/supervisord.conf
COPY ./docker/local/consumers.ini /etc/supervisor.d/

WORKDIR /var/www/html

CMD /usr/bin/supervisord -n
