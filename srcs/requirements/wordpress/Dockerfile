FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get -y install \
	mariadb-client \
	php8.2 \
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

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xvf latest.tar.gz && \
	mkdir -p /var/www/html && \
	mv /wordpress/* /var/www/html/ && \
	chown -R www-data:www-data /var/www/html && \ 
	rm -r /wordpress latest.tar.gz

EXPOSE 9000

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--", "/usr/local/bin/docker-entrypoint.sh"]
