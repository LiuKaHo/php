#!/bin/bash

rsyslogd
/etc/init.d/cron start
/etc/init.d/cron reload
touch /var/spool/cron/crontabs/root
echo  "* * * * * /usr/local/bin/php /opt/code/${PROJECT_NAME}/artisan schedule:run" >> /var/spool/cron/crontabs/root
docker-php-entrypoint php-fpm