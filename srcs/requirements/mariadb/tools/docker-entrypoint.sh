#!/bin/sh

set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	# 외부 ip 허용
	echo "external ip setting"
	sed -i "s|^bind-address\s*=.*|bind-address = 0.0.0.0|" /etc/mysql/mariadb.conf.d/50-server.cnf
	echo "complete"
	
	# Check if data directory is empty
	echo "data dir init"
	echo "Initializing MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	echo "complete"

	# mariadb 서버 임시 시작
	echo "starting temp mariadb server"
	mariadbd -u root &
	MARIADB_PID=$!
	echo "complete"

	sleep 3

	# wordpress용 user & db 생성
	echo "wordpress user & db setting"
	mariadb -u root <<-EOSQL
		CREATE DATABASE IF NOT EXISTS wordpress_db;
		CREATE USER 'junkim2'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
		GRANT ALL ON wordpress_db.* TO 'junkim2'@'%';
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
	EOSQL
	echo "complete"
	sleep 3
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
fi

# mariadb 서버 시작
echo "starting mariadb server"
exec mariadbd -u root
echo "complete"
