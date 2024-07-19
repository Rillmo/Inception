FROM debian:bookworm

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server mariadb-client

RUN mkdir -p /var/lib/mysql /var/run/mysqld
RUN	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN chmod +x /var/run/mysqld

EXPOSE 3306

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
