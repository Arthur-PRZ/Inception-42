FROM debian:12-slim

RUN apt-get update -y && apt-get upgrade -y && apt-get -y install wget

RUN apt-get install -y php8.2 \
	php8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	tar

RUN mkdir -p /var/www/html && wget https://wordpress.org/wordpress-6.7.tar.gz -P /var/www && \ 
	tar -xvf /var/www/wordpress-6.7.tar.gz && mv wordpress/* /var/www/html && rm /var/www/wordpress-6.7.tar.gz

RUN chown -R www-data:www-data /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY conf/auto_config.sh /usr/local/bin/auto_config.sh

RUN chmod +x /usr/local/bin/auto_config.sh

CMD ["/usr/local/bin/auto_config.sh"]


