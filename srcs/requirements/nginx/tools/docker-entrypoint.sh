#!/bin/sh

sleep 10

if [ -f /etc/nginx/sites-available/default-docker ]; then
	# nginx.conf 설정
	echo "nginx.conf file setting"
	echo "daemon off;" >> /etc/nginx/nginx.conf
	echo "complete"

	# nginx default 파일 설정
	echo "nginx default file setting"
	mv /etc/nginx/sites-available/default-docker /etc/nginx/sites-available/default
	echo "complete"
fi

echo "starting nginx"
exec nginx
echo "complete"
