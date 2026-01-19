FROM alpine:3.12 AS builder
ENV DEBIAN_FRONTEND=noninteractive

ARG PHPIPAM_VERSION=1.7
WORKDIR /opt

RUN apk update && apk add git

RUN git clone --branch "${PHPIPAM_VERSION}" --depth 1 https://github.com/phpipam/phpipam.git html/

RUN cp /opt/html/config.docker.php /opt/html/config.php

RUN sed -i \
  "/allow_untested_php_versions\s*=/d" \
  /opt/html/config.php \
 && echo "\$allow_untested_php_versions = true;" \
 >> /opt/html/config.php

FROM php:8.4-apache

ENV DEBIAN_FRONTEND=noninteractive
EXPOSE 80

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
     mariadb-client-compat \
    unzip \
    iputils-ping \
    gettext \
    libgmp-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
 && rm -rf /var/lib/apt/lists/*


 RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    sockets \
    gmp \
    gettext \
    gd \ 
    mysqli \
    pdo \
    pdo_mysql 


RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
 && printf "ErrorLog /dev/stderr\nCustomLog /dev/stdout combined\n" \
    > /etc/apache2/conf-enabled/docker-logs.conf

RUN rm -rf /var/www/html/*

COPY --from=builder --chown=www-data:www-data /opt/html/ /var/www/html/


HEALTHCHECK --interval=30s --timeout=5s \
CMD curl -f http://localhost/ || exit 1

CMD ["-D", "FOREGROUND"]