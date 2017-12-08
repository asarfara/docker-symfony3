FROM php:7.1-fpm

COPY symfony /opt/projects/docker-test

RUN cd /opt/projects/docker-test \
  && rm -rf var/cache/* \
  && rm -rf var/logs/* \
  && chmod -R a+rw var

RUN apt-get update && \
    apt-get -y install libzip-dev git zip && \
    docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Permission fix
RUN chmod -R 755 /opt

EXPOSE 9000

CMD ["php-fpm"]
