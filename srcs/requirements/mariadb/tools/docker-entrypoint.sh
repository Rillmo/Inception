#!/bin/sh

set -e

# 외부 ip 허용
echo "external ip setting"
sed -i "s|.*bind-address\s*=.*|#bind-address=127.0.0.1|g" /etc/mysql/mariadb.conf.d/50-server.cnf
echo "complete"

# Check if data directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# mariadb 서버 임시 시작
echo "starting mariadb"
mariadbd -u root &
MARIADB_PID=$!
echo "complete"

sleep 3

# root 비밀번호 설정
echo "root password setting"
mariadb -u root <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOSQL
echo "complete"

# wordpress용 user & db 생성
echo "wordpress user & db setting"
mariadb -u root -p$MYSQL_ROOT_PASSWORD <<-EOSQL
	CREATE DATABASE IF NOT EXISTS wordpress_db;
	CREATE USER 'junkim2'@'%' IDENTIFIED BY "$MYSQL_USER_PASSWORD";
	GRANT ALL ON wordpress_db.* TO 'junkim2'@'%';
	FLUSH PRIVILEGES;
EOSQL
echo "complete"

sleep 3

# mariadb 서버 시작
echo "restarting mariadb"
kill "$MARIADB_PID"
wait "$MARIADB_PID"
exec mariadbd -u root
echo "complete"
