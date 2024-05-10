FROM nginx:alpine

RUN apk update
RUN apk add --no-cache openssl openssh rsync curl
RUN rm -rf /etc/nginx/conf.d
COPY ./docker/local/nginx /etc/nginx

WORKDIR /var/www/html

RUN chown nginx:nginx /var/www/html

STOPSIGNAL SIGQUIT
