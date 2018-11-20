#!/bin/bash

rsyslogd
cron -f &
docker-php-entrypoint php-fpm
