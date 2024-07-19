FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get -y install \
	mariadb-client \
	php7.3 \
	php-fpm \
	php-cli \
	wget \
	curl \
	php-mysql \
	php-mbstring \
	php-xml \
	sendmail \
	vim

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xvf latest.tar.gz && \
	mv /wordpress/* /var/www/html/ && \
	chown -R www-data:www-data /var/www/html && \ 
	rm -r /wordpress latest.tar.gz

EXPOSE 9000

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]