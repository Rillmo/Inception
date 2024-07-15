#!/bin/sh

# MySQL 데이터 디렉토리가 비어 있으면 초기화
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "Database initialized."
fi

# MySQL 서버 시작
exec mysqld --user=mysql --datadir=/var/lib/mysql --console
