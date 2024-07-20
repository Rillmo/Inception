FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get -y install \
	nginx \
	openssl \
	vim \
	tini

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/server_pkey.pem \
	-out /etc/ssl/certs/server.crt \
	-subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42Seoul/CN=junkim2"

EXPOSE 443

COPY /conf/default-docker /etc/nginx/sites-available/

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--" , "docker-entrypoint.sh"]