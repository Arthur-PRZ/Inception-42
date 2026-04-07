#!/bin/bash
#service mysql start;

mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld

mysql_install_db --user=mysql --datadir=/var/lib/mysql

mysqld --user=mysql &
sleep 5

mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root shutdown
sleep 2

mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld

exec mysqld --user=mysql
