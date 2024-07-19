FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get -y install \
	nginx \
	openssl \
	vim

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/server_pkey.pem \
	-out /etc/ssl/certs/server.crt

EXPOSE 443

COPY /conf/default_docker /etc/nginx/sites-enabled/

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]