#!/bin/bash
clear
echo ""
echo "Instalando o MySQL Server..."
echo
apt install mysql-server -y
sleep 2
echo ""
echo "MySQL Server instalado!"
sleep 2
echo
echo
echo "Configurando senha de root do MySQL. Siga o passo a passo informado a seguir..."
mysql_secure_installation

sleep 2
echo ""
echo "MySQL Server instalado!"
echo
echo


CREATE DATABASE guacamole_db;
CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY 'Guac@2022$1';
GRANT SELECT, INSERT,U PDATE, DELETE ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;



ls schema/

cat schema/*.sql | mysql -u root -p guacamole_db




guacamole.properties
mysql-hostname: localhost
mysql-database: guacamole_db
mysql-username: guacamole_user
mysql-password: Guac@2022$1