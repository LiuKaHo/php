#!/bin/bash

rsyslogd
/etc/init.d/cron start
touch /var/spool/cron/crontabs/root
echo  "* * * * * /usr/local/bin/php /opt/code/${PROJECT_NAME}/artisan schedule:run" >> /var/spool/cron/crontabs/root
/etc/init.d/cron reload
service supervisor starts
supervisorctl reload
docker-php-entrypoint php-fpm