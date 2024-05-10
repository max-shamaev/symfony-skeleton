FROM composer as composer-cli

FROM php:8.3-fpm-alpine

ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

RUN set -xe

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache pcre-dev yaml-dev libzip-dev curl-dev linux-headers $PHPIZE_DEPS \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install yaml && docker-php-ext-enable yaml \
    && docker-php-ext-configure bcmath --enable-bcmath && docker-php-ext-install bcmath \
    && docker-php-ext-install opcache curl zip pdo pdo_mysql zip ctype \
    && pecl install timezonedb && docker-php-ext-enable timezonedb \
    && pecl install -o -f apcu && docker-php-ext-enable apcu \
    && pecl install xdebug && docker-php-ext-enable xdebug

RUN addgroup -g ${GID} --system user
RUN adduser -G user --system -D -s /bin/sh -u ${UID} user
RUN sed -i "s/user = www-data/user = user/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = user/g" /usr/local/etc/php-fpm.d/www.conf

COPY --from=composer-cli /usr/bin/composer /usr/bin/composer

COPY ./docker/local/php.ini /usr/local/etc/php/conf.d/base.ini
COPY ./docker/local/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY ./docker/local/docker.conf /usr/local/etc/php-fpm.d/docker-additional.conf

WORKDIR /var/www/html
