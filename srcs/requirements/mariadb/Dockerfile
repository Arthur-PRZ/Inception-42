FROM debian:12-slim

RUN apt update -y && apt upgrade -y && apt-get install mariadb-server -y

RUN mkdir -p /var/run/mysql /var/lib/mysql && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY init-mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-mariadb.sh


CMD ["/usr/local/bin/init-mariadb.sh"]
