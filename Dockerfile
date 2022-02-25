# Install PHP composer
FROM php:latest as picocms
RUN apt-get update && apt-get install -y git unzip
RUN mkdir -p /opt/picocms
WORKDIR /opt
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    php composer.phar --ignore-platform-reqs create-project picocms/pico-composer /opt/picocms && \
    php composer.phar --ignore-platform-reqs require picoauth/picoauth-theme -d /opt/picocms

FROM alpine:latest
LABEL maintainer="bas.van.wetten@gmail.com"

RUN apk add --no-cache --update \
    bash \
    nginx \
    php7 php7-fpm php7-iconv php7-openssl php7-phar php7-json php7-dom php7-mbstring php7-session \
    gettext && \
    # No need for the default configs
    rm -f /etc/php/php-fpm.d/www.conf && \
    # Remove nginx user because we will create a user with correct permissions dynamically
    deluser nginx && \
    mkdir -p /var/log/nginx && \
    mkdir -p /tmp/nginx/body && \
    # Small fixes to php & nginx
    ln -s /etc/php7 /etc/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /usr/lib/php7 /usr/lib/php && \
    rm -rf /var/log/php7 && \
    mkdir -p /var/log/php/ && \
    # No need for the default configs
    rm -f /etc/php/php-fpm.d/www.conf && \
    # Remove default localhost folder
    rm -rf /var/www/localhost && \
    # Remove cache and tmp files
    rm -rf /var/cache/apk/* && \
    # Create Folders
    mkdir -p /var/www/nginx

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

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

VOLUME /var/www/picocms

WORKDIR ${WEB_ROOT}
EXPOSE ${PORT}
ENTRYPOINT ["/init"]