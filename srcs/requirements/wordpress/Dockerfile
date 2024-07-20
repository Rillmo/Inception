FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get -y install \
	mariadb-client \
	php \
	php-fpm \
	php-cli \
	wget \
	curl \
	php-mysql \
	php-mbstring \
	php-xml \
	sendmail \
	vim \
	tini

EXPOSE 9000

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--", "/usr/local/bin/docker-entrypoint.sh"]
