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
    vim \
    wget 



#install php extensions
RUN pecl install swoole && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini


RUN docker-php-ext-install -j$(nproc)  iconv mysqli zip mbstring pdo_mysql bcmath


# install php gd extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd




#install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \ 
          && php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
          && php composer-setup.php --install-dir=/usr/local/bin --filename=composer\
          && php -r "unlink('composer-setup.php');"


#install phpunit
RUN php -r "copy('https://phar.phpunit.de/phpunit-7.phar', 'phpunit');" \
    && chmod +x phpunit \
    && mv phpunit /usr/local/bin/phpunit \
    && phpunit --version



#php config files
ADD php.ini /usr/local/etc/php/php.ini
ADD php-fpm.conf /usr/local/etc/php-fpm.ini



WORKDIR /opt


ADD cacert.pem /usr/local/etc/php/cacert.pem


EXPOSE 9000

