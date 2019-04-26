#!/bin/bash

supervisord -c /etc/supervisor/supervisord.conf
supervisorctl reload
supervisorctl update
docker-php-entrypoint php-fpm