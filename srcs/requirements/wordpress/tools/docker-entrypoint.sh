#!/bin/sh

# wordpress 설정파일 이름 변경
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# wordpress DB 설정
sed -i "s/database_name_here/'$WORDPRESS_DB'/g" /var/www/html/wp-config.php
sed -i "s/username_here/'$WORDPRESS_DB_USERNAME'/g" /var/www/html/wp-config.php
sed -i "s/password_here/'$WORDPRESS_DB_PASSWORD'/g" /var/www/html/wp-config.php
sed -i "s/localhost/'$WORDPRESS_DB_HOST'/g" /var/www/html/wp-config.php

# PHP 버전 가져오기
PHP_VERSION=$(ls /etc/php/ | grep -E '^[0-9]+\.[0-9]+$')

# php 외부 연결 오픈
CONFIG_FILE="/etc/php/$PHP_VERSION/fpm/pool.d/www.conf"
if [ -f "$CONFIG_FILE" ]; then
    # 'listen' 설정 변경
    sed -i 's|^listen = /run/php/php'"$PHP_VERSION"'-fpm.sock.*|listen = 0.0.0.0:9000|' "$CONFIG_FILE"
    echo "Updated $CONFIG_FILE"
else
    echo "Config file not found for PHP version $PHP_VERSION"
fi

exec service php$PHP_VERSION-fpm start
