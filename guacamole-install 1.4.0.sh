#!/bin/bash
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
clear

if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "20.04" ]
	then
		echo
		echo -e "O usuário é Root, continuando com o script..."
		echo -e "Distribuição é >= ($UBUNTU), continuando com o script..."
		echo
		sleep 5
	else
		echo
		echo -e "Usuário não é Root ($USUARIO) ou Distribuição não é 20.04.x"
		echo -e "Execute o script com o comando: sudo -i"
		echo
		exit 1
fi

echo
echo
echo "INSTALACAO DO APACHE GUACAMOLE - VERSAO 1.4.0"
echo
echo
echo "Instalando Java JDK - Default JDK..."
echo
apt install default-jdk -y
echo
echo
echo "Java JDK instalado!"
sleep 3
echo
echo
echo "Configurando a variavel de ambiente JAVA_HOME para todos usuarios..."
echo
echo 'export JAVA_HOME=/usr/lib/jvm/default-java/' >> /etc/bash.bashrc
source /etc/bash.bashrc
echo
echo
echo "Variavel de ambiente JAVA_HOME configurada!"
sleep 3
echo
echo
echo "Instalando o Servidor de aplicacao Tomcat..."
echo
apt install tomcat9* -y
cp -v /etc/tomcat9/tomcat-users.xml /etc/tomcat9/tomcat-users.xml.bkp
cp -v conf/tomcat-users.xml /etc/tomcat9/tomcat-users.xml
systemctl restart tomcat9
echo
echo
echo "Servidor de aplicacao Apache Tomcat instalado!"
sleep 3
echo
echo
echo "Instalando dependencias..."
echo
apt install build-essential gcc libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin uuid-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libtelnet-dev libvncserver-dev libwebsockets-dev libpulse-dev libssl-dev libvorbis-dev libossp-uuid-dev -y
echo
echo
echo "Dependencias instaladas!"
sleep 3
echo
echo
echo "Baixando arquivos de configuracao..."
echo
#git clone https://github.com/daniloatx/apache-guacamole.git
cd guacamole/
tar -xvzf guacamole-server-1.4.0.tar.gz
cd guacamole-server-1.4.0
echo
echo "Configurando o Apache Guacamole Server..."
echo
./configure --with-init-dir=/etc/init.d
echo
make
sleep 1
echo
echo
make install
ldconfig
echo
echo
sleep 2
echo "Habilitando servico Guacd..."
systemctl enable guacd
systemctl start guacd
echo "Servico habilitado e iniciado!"
sleep 3
echo
echo
cd ..
echo "Criando estrutura de diretorios..."
echo
mkdir -pv /etc/guacamole/{extensions,lib}
echo
echo
echo "Configurando o Apache Guacamole Client..."
cp -v guacamole-1.4.0.war /etc/guacamole/guacamole.war
ln -sv /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
ln -sv /etc/guacamole /usr/share/tomcat9.guacamole
cp -v conf/guacamole.properties /etc/guacamole/guacamole.properties
cp -v conf/guacd.conf /etc/guacamole/
cp -v /etc/default/tomcat9 /etc/default/tomcat9.old
cp -v conf/tomcat9 /etc/default/tomcat9
cp -v mysql/guacamole-auth-jdbc-mysql-1.4.0.jar /etc/guacamole/extensions/
cp -v mysql/mysql-connector-java-8.0.27.jar /etc/guacamole/lib/
echo
echo "Reiniciando o Tomcat..."
systemctl restart tomcat9
echo
echo "Tomcat reiniciado!"
sleep 3
echo
echo
echo "INSTALACAO DO APACHE GUACAMOLE CONCLUIDA!"
echo

