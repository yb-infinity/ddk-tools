# syntax=docker/dockerfile:1.4
ARG ALPINE_VER=3.21.3
FROM alpine:${ALPINE_VER}

ARG BUILD_VER
ARG BUILD_DATE
ARG PHP_VER=84
ARG COMPOSER_VER=2.8.6
ARG NORMALIZE_VER=2.45.0
ARG PARALLEL_VER=1.4.0

LABEL org.opencontainers.image.authors="DrakeMazzy <i.am@mazzy.rv.ua>" \
    org.opencontainers.image.title="DrupalDevKit - tools" \
    org.opencontainers.image.description="Docker image with PHP 8, Composer, PHP-Parallel-Lint and composer-normalize" \
    org.opencontainers.image.url="https://github.com/yb-infinity/ddk-tools" \
    org.opencontainers.image.licenses="GPL-2.0-or-later" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.version="${BUILD_VER}"

ENV COMPOSER_ALLOW_SUPERUSER=1
USER root
RUN set -e && apk --update add --no-cache tini wget \
    php${PHP_VER} \
    php${PHP_VER}-phar \
    php${PHP_VER}-mbstring \
    php${PHP_VER}-openssl \
    # fix for arm64
    && rm -f /usr/bin/php /usr/bin/php-config /usr/bin/phpize && \
    if [ ! -e /usr/bin/php ]; then ln -s /usr/bin/php${PHP_VER} /usr/bin/php; fi && \
    if [ ! -e /usr/bin/php-config ]; then ln -s /usr/bin/php${PHP_VER}-config /usr/bin/php-config; fi && \
    if [ ! -e /usr/bin/phpize ]; then ln -s /usr/bin/php${PHP_VER}-ize /usr/bin/phpize; fi && \
    # install composer
    wget -q https://getcomposer.org/download/${COMPOSER_VER}/composer.phar -O /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    # install normalize
    wget -q https://github.com/ergebnis/composer-normalize/releases/download/${NORMALIZE_VER}/composer-normalize.phar -O /usr/local/bin/composer-normalize && \
    chmod +x /usr/local/bin/composer-normalize && \
    # install php-parallel-lint
    wget -q https://github.com/php-parallel-lint/PHP-Parallel-Lint/releases/download/v${PARALLEL_VER}/parallel-lint.phar -O /usr/local/bin/parallel-lint && \
    chmod +x /usr/local/bin/parallel-lint && \
    # configure
    echo -e "\nmemory_limit = -1" >> /etc/php${PHP_VER}/php.ini && \
    # cleanup
    apk del wget && \
    rm -rf /etc/apk /lib/apk /usr/share/apk /var/cache/apk/* && \
    composer clear-cache && \
    find /root/.composer -type d -name ".git" -o -name ".github" -o -name "tests" | xargs rm -rf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
VOLUME /tmp

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
