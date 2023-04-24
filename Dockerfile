FROM php:latest as picocms
RUN apt-get update && apt-get install -y git unzip
RUN mkdir -p /opt/picocms
WORKDIR /opt

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    php composer.phar config --global --no-plugins allow-plugins.picocms/composer-installer true && \
    php composer.phar --ignore-platform-reqs create-project picocms/pico-composer /opt/picocms

FROM alpine:latest
LABEL maintainer="thomas@tuerk-brechen.de"

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz /tmp/

RUN apk add --no-cache --update \
    bash \
    nginx \
    php81 php81-fpm php81-iconv php81-openssl php81-phar php81-json php81-dom php81-mbstring php81-session \
    gettext && \
    # No need for the default configs
    rm -f /etc/php/php-fpm.d/www.conf && \
    # Remove nginx user because we will create a user with correct permissions dynamically
    deluser nginx && \
    mkdir -p /var/log/nginx && \
    mkdir -p /tmp/nginx/body && \
    # Small fixes to php & nginx
    ln -s /etc/php81 /etc/php && \
    ln -s /usr/sbin/php-fpm81 /usr/bin/php-fpm && \
    ln -s /usr/lib/php81 /usr/lib/php && \
    # rm -rf /var/log/php81 && \
    mkdir -p /var/log/php/ && \
    # No need for the default configs
    rm -f /etc/php/php-fpm.d/www.conf && \
    # Remove default localhost folder
    rm -rf /var/www/localhost && \
    # Remove cache and tmp files
    rm -rf /var/cache/apk/* && \
    # Create Folders
    mkdir -p /var/www/nginx && \
    # unpack s6
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz

COPY --from=picocms /opt/picocms /opt/picocms
COPY /files /

ENV NGINX_PID_FILE="/var/run/nginx/nginx.pid" \
    PORT="80" \
    WEB_ROOT="/var/www/picocms/" \
    WEB_USER="picocms" \
    WEB_GROUP="web" \
    NGINX_MAX_BODY_SIZE="64M" \
    NGINX_FASTCGI_TIMEOUT="30" \
    PHP_MEMORY_LIMIT="256M"

VOLUME /var/www/picocms

WORKDIR ${WEB_ROOT}
EXPOSE ${PORT}
ENTRYPOINT ["/init"]