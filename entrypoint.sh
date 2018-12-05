#!/bin/bash

service supervisor start
supervisorctl reload
docker-php-entrypoint php-fpm