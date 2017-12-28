FROM php:7.1-fpm

COPY symfony /opt/projects/docker-test

RUN apt-get update && \
    apt-get -y install libzip-dev git zip && \
    docker-php-ext-install zip sockets pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install -d /opt/projects/docker-test/

# Permission fix
RUN chmod -R 755 /opt

RUN cd /opt/projects/docker-test \
  && rm -rf var/cache/* \
  && rm -rf var/logs/* \
  && chmod -R a+rw var

EXPOSE 9000

CMD ["php-fpm"]
