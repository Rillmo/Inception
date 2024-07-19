#!/bin/sh

set -e
sleep 10

# PHP 버전 가져오기
echo "php version check"
PHP_VERSION=$(ls /etc/php/ | grep -E '^[0-9]+\.[0-9]+$')
echo "complete"

if [ -f /var/www/html/wp-config-sample.php ]; then
    # wordpress 설정파일 이름 변경
    echo "wp-config setting"
    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    echo "complete"

    # wordpress DB 설정
    echo "wordpress db setting"
    sed -i "s/database_name_here/'$WORDPRESS_DB'/g" /var/www/html/wp-config.php
    sed -i "s/username_here/'$WORDPRESS_DB_USERNAME'/g" /var/www/html/wp-config.php
    sed -i "s/password_here/'$WORDPRESS_DB_PASSWORD'/g" /var/www/html/wp-config.php
    sed -i "s/localhost/'$WORDPRESS_DB_HOST'/g" /var/www/html/wp-config.php
    echo "complete"


    # php 외부 연결 오픈
    echo "php external connection open"
    CONFIG_FILE="/etc/php/$PHP_VERSION/fpm/pool.d/www.conf"
    if [ -f "$CONFIG_FILE" ]; then
        # 'listen' 설정 변경
        sed -i 's|^listen = /run/php/php'"$PHP_VERSION"'-fpm.sock.*|listen = 0.0.0.0:9000|' "$CONFIG_FILE"
        echo "Updated $CONFIG_FILE"
    else
        echo "Config file not found for PHP version $PHP_VERSION"
    fi
    echo "complete"
fi

# php-fpm 시작
echo "starting php-fpm$PHP_VERSION"
exec /usr/sbin/php-fpm$PHP_VERSION -F -R
echo "complete"
