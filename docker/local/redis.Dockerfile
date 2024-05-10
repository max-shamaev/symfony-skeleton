FROM redis:7-alpine as redis

USER root
RUN apk add gettext
RUN ulimit -n 10032

RUN apk add --no-cache bash su-exec
RUN apk add --update tini

RUN mkdir -p /usr/local/etc/redis
COPY ./docker/local/redis/redis.conf /usr/local/etc/redis/redis.conf
COPY ./docker/local/redis/docker-entrypoint.sh /usr/local/bin/

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
