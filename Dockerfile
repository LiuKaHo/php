FROM php:7.2-fpm

MAINTAINER liukaho

RUN apt-get update && apt-get install -y \
    apt-utils \
    git \
    openssl \
    libssl1.0-dev \
    libssh-dev \
    pkg-config \
    libmemcached-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    cron \
    rsyslog


#install php extensions
RUN pecl install swoole && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini


RUN docker-php-ext-install -j$(nproc)  iconv mysqli zip mbstring pdo_mysql


# install php gd extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd



#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
     && php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
     && php composer-setup.php --install-dir=/usr/local/bin --filename=composer\
     && php -r "unlink('composer-setup.php');"


#install phpunit
RUN php -r "copy('http://phar.phpunit.cn/phpunit.phar', 'phpunit');" \
    && chmod +x phpunit \
    && mv phpunit /usr/local/bin/phpunit \
    && phpunit --version


#install supervisor
RUN apt-get install -y supervisor && echo_supervisord_conf

#php config files
ADD php.ini /usr/local/etc/php/php.ini
ADD php-fpm.conf /usr/local/etc/php-fpm.ini



WORKDIR /opt

RUN touch /var/log/cron.log

COPY ./entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/entrypoint.sh \
    && ln -s /usr/local/bin/entrypoint.sh /

RUN usermod -u 1000 www-data
USER www-data

ENTRYPOINT ["entrypoint.sh"]


EXPOSE 9000

