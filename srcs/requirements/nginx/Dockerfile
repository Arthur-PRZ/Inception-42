FROM debian:12-slim

RUN apt update -y && apt install nginx -y
RUN mkdir -p /etc/nginx/ssl && apt install openssl -y 
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Perpignan/O=42/OU=42/CN=artperez.42.fr/UID=artperez"
RUN mkdir -p /var/run/nginx

COPY conf/default.conf /etc/nginx/conf.d/default.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]
