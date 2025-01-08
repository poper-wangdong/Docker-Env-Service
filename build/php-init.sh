#!/bin/sh

# xdebug 开启配置
echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# 全局安装 phpcs 相关包
export PHP_CS_FIXER_IGNORE_ENV=1
composer global require --dev friendsofphp/php-cs-fixer:2.19 "squizlabs/php_codesniffer=*"