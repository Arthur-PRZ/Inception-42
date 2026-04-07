#!/bin/bash

sleep 10

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Creation du fichier wp-config.php avec wp.cli..."

	wp config create \
		--path=/var/www/html \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--allow-root
fi

if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
	wp core install \
		--path=/var/www/html \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root

	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}" \
		--path=/var/www/html \
		--allow-root

	echo "configuration terminée !"
else
	echo "wp-config.php existe déjà, configuration ignorée"
fi 

chown -R www-data:www-data /var/www/html

php-fpm8.2 -F
