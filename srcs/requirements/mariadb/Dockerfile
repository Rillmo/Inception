FROM alpine:3.19

RUN apk update && apk upgrade
RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /var/lib/mysql /run/mysqld
RUN	chown -R mysql:mysql /var/lib/mysql /run/mysqld
RUN chmod +x /var/run/mysqld

EXPOSE 3306

COPY /tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]