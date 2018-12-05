#!/bin/bash

service supervisor start
supervisorctl reload
supervisorctl update
docker-php-entrypoint php-fpm