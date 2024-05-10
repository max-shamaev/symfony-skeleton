#!/bin/sh
set -e

#ip link add dummy0 type dummy > /dev/null
#if [[ $? -eq 0 ]]; then
#    PRIVILEGED=true
#    # clean the dummy0 link
#    ip link delete dummy0 > /dev/null
#else
#    PRIVILEGED=false
#fi
#
#if $PRIVILEGED; then
#  echo 65535 > /proc/sys/net/core/somaxconn
#  sysctl vm.overcommit_memory=1
#fi

echo Base user:   `whoami`
echo Base groups: `groups`

#envsubst < /usr/local/etc/redis/redis.conf.template > /usr/local/etc/redis/redis.conf

# example: PREPARE_SCRIPT="/opt/app/bin/console cache:warmup --no-debug"
if [ ! -z "${PREPARE_SCRIPT:-}" ]; then
  $PREPARE_SCRIPT
fi


# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	find . \! -user redis -exec chown redis '{}' +
	exec su-exec redis "$0" "$@"
fi

exec "$@"
