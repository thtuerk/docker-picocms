FROM webdevops/php:alpine-php7 as install
LABEL maintainer="bas.van.wetten@gmail.com"

# Install PHP composer
RUN mkdir -p /opt/phpcomposer
WORKDIR /opt/phpcomposer
RUN     php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
        php composer-setup.php && \
        php -r "unlink('composer-setup.php');"
# Install PicoCMs
RUN     php composer.phar create-project picocms/pico-composer /app

FROM scratch
WORKDIR /app
COPY --from=install /app .

VOLUME /app