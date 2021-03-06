FROM php:7.2-fpm

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libz-dev \
        less \
        git \
        mysql-client \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libzip-dev \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        sockets \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug-2.7.0beta1 \
    && pecl install memcached \
    && docker-php-ext-enable xdebug memcached \
    && apt-get remove -y build-essential libz-dev libmemcached-dev \
    && apt-get autoremove -y \
    && apt-get clean

RUN curl https://getcomposer.org/download/$(curl -LSs https://api.github.com/repos/composer/composer/releases/latest | grep 'tag_name' | sed -e 's/.*: "//;s/".*//')/composer.phar > composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer
   
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["php-fpm"]
