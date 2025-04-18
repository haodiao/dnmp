ARG PHP_VERSION
FROM $PHP_VERSION

ARG TZ
ARG PHP_EXTENSIONS
ARG CONTAINER_PACKAGE_URL

RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

COPY ./extensions /tmp/extensions

#ADD ./extensions/install-php-extensions  /usr/local/bin/
RUN curl -L -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && chmod uga+x /usr/local/bin/install-php-extensions

RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

# Fix: https://github.com/docker-library/php/issues/240
RUN apk add git gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

WORKDIR /tmp/extensions
RUN chmod +x install.sh \
    && sh install.sh \
    && rm -rf /tmp/extensions

# Install cacert.pem
RUN curl -L -o /usr/local/etc/php/cacert.pem https://curl.se/ca/cacert.pem

# Install composer and change it's cache home
RUN curl -L -o /usr/bin/composer https://getcomposer.org/download/latest-stable/composer.phar \
    && chmod +x /usr/bin/composer
ENV COMPOSER_HOME=/tmp/composer

# php image's www-data user uid & gid are 82, change them to 1000 (primary user)
RUN apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN mkdir /www && chown -R www-data:www-data /www

#WORKDIR /var/www
WORKDIR /www