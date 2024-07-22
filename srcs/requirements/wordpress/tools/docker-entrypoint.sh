#!/bin/sh

set -e
sleep 10

# PHP 버전 가져오기
echo "php version check"
PHP_VERSION=$(ls /etc/php/ | grep -E '^[0-9]+\.[0-9]+$')
echo "complete"

# wp-config 환경변수 설정
echo "wp-config env setting"
CONFIG_FILE="/etc/php/$PHP_VERSION/fpm/pool.d/www.conf"
sed -i 's|^;clear_env = no|clear_env = no|' "$CONFIG_FILE"
echo "complete"

# php 외부 연결 오픈
echo "php external connection open"
if [ -f "$CONFIG_FILE" ]; then
    # 'listen' 설정 변경
    sed -i 's|^listen = /run/php/php'"$PHP_VERSION"'-fpm.sock.*|listen = 0.0.0.0:9000|' "$CONFIG_FILE"
    echo "Updated $CONFIG_FILE"
else
    echo "Config file not found for PHP version $PHP_VERSION"
fi
echo "complete"

if [ ! -f /var/www/html/wp-config.php ]; then
    # wordpress 설치
    echo "installing wordpress"
    wget https://wordpress.org/latest.tar.gz && \
    tar -xvf latest.tar.gz && \
    mv /wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html && \
    rm -r /wordpress latest.tar.gz
    echo "complete"

    # wordpress 설정파일 이름 변경
    echo "wp-config setting"
    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    echo "complete"

    # wordpress DB 설정
    echo "wordpress db setting"
    sed -i "s/database_name_here/$WORDPRESS_DB/g" /var/www/html/wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USERNAME/g" /var/www/html/wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" /var/www/html/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/g" /var/www/html/wp-config.php
    echo "complete"

    # wp-cli 세팅
    echo "setting with wp-cli"
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url=https://localhost \
        --title=inception \
        --admin_user=nimda \
        --admin_password=1234 \
        --admin_email=nimda@gmail.com
    wp user create \
        $WORDPRESS_USER $WORDPRESS_USER_EMAIL \
        --user_pass=$WORDPRESS_USER_PASSWORD \
        --role=author \
        --allow-root \
        --path=/var/www/html
    echo "complete"

fi


# php-fpm 시작
echo "starting php-fpm $PHP_VERSION"
exec /usr/sbin/php-fpm$PHP_VERSION -F -R
echo "complete"
