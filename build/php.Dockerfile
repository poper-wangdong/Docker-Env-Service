# 一些环境变量
ARG COMPOSER_VERSION="latest"
ARG PHP_VERSION=fpm-alpine

# 导入 Composer 特定版本
FROM composer:${COMPOSER_VERSION} AS composer

# 基于 PHP 构建
FROM php:${PHP_VERSION}

# 复制安装包
COPY ./php-init.sh /php-init.sh

# 安装 php 扩展
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
ARG PHP_EXTENSIONS="zip"

# 安装 Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_HOME="/usr/local/composer" \
    PATH="/usr/local/composer/vendor/bin:${PATH}" \
    PHP_CS_FIXER_IGNORE_ENV=1

# 执行安装过程
ARG ALPINE_REPOSITORIES
ARG TZ="UTC"
RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
    sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories; \
    fi && \
    apk update \
    && apk --no-cache add tzdata \
    && ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && export MC="-j$(nproc)" \
    && install-php-extensions ${PHP_EXTENSIONS} \
    && sh /php-init.sh

WORKDIR /var/www/html