#!/bin/bash

setup() {
    echo "[LV SPEEDTEST] Selecione a Versao:"
    echo ""
    echo "[1] Ubuntu 18.04 | [2] Ubuntu 16.04"
    echo ""

    read verUbuntu

    if [ "$verUbuntu" = "1" ]; then
        instala1804
    elif [ "$verUbuntu" = "2" ]; then
        instala1604
    else
        echo "Opcao Invalida..."
        exit
    fi
}

atualizaUbuntu() {
	echo "Atualizando o Ubuntu"
	echo ""
	apt-get update && apt-get -y upgrade &&
	echo ""
	echo "Ubuntu Atualizado!"

	echo "Informe o Dominio do Provedor:"
	echo ""
	read dominioProvedor &&
	echo ""
	echo ""

	echo "Informe o Subdominio do Provedor:"
	echo ""
	read subDomProvedor &&
	echo ""
	echo ""

	echo "Informe o Email do Provedor:"
	echo ""
	read emailProvedor &&
	echo ""
	echo ""
}

confRcLocal(){
	touch /etc/rc.local &&

	delay 2
	
	echo "#!/bin/sh" >> /etc/rc.local
	echo "su ooklaserver -c './etc/ooklaserver/OoklaServer --daemon'" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local

	delay 2

	chmod +x /etc/rc.local
}

confCertificado(){
	apt -y install letsencrypt python-certbot-apache &&
	apache2ctl stop &&
	letsencrypt --authenticator standalone --installer apache -n --agree-tos --email $emailProvedor -d $subDomProvedor &&

	echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/$subDomProvedor/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/$subDomProvedor/privkey.pem'    >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/$subDomProvedor/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties.default
	echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/$subDomProvedor/privkey.pem' >> /etc/ooklaserver/OoklaServer.properties.default

	delay 2

	chown ooklaserver. /etc/letsencrypt/ -R &&

	cd /etc/ooklaserver &&
	./ooklaserver.sh stop &&
	su ooklaserver -c  '/etc/ooklaserver/ooklaserver.sh start' &&

	su ooklaserver -c  'wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/certificado-ssl/renovaSSL.sh' &&

	chmod +x /etc/ooklaserver/renovaSSL.sh &&

	echo '00 00 1 * * root /etc/ooklaserver/renovaSSL.sh' >> /etc/crontab && 

	systemctl restart cron &&

	reboot
}

confSpeedTest(){
	echo "Criando Usuario"
	echo ""
	addgroup ooklaserver && 
	useradd -d /etc/ooklaserver -m -g ooklaserver -s /bin/bash ooklaserver &&
	echo ""

	delay 2

	echo "Acessando Usuário - Baixando Pacote" &&
	echo ""

	su ooklaserver -c  'wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/resources/ooklaserver.sh' &&
	su ooklaserver -c  'chmod +x ooklaserver.sh' &&
	su ooklaserver -c  './ooklaserver.sh install' &&
	
	echo "OK"

	delay 2

	echo "Configurando os Arquivos..."

	echo 'openSSL.server.privateKeyFile OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *.$dominioProvedor' >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.privateKeyFile OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *.$dominioProvedor' >> /etc/ooklaserver/OoklaServer.properties.default

	sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf &&
	sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf &&

	delay 5

	wget https://github.com/lvnetwork-dev/speedtest/raw/main/resources/fallback.zip &&

	unzip fallback.zip /var/www/html/ &&

	touch /var/www/html/crossdomain.xml

	delay 2

	echo '<?xml version="1.0"?>' >> /var/www/html/crossdomain.xml
	echo "<cross-domain-policy>" >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.speedtest.net" />' >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.ookla.com" />' >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.$dominioProvedor" />' >> /var/www/html/crossdomain.xml
	echo "</cross-domain-policy>" >> /var/www/html/crossdomain.xml

	confRcLocal

	confCertificado
}

instala1804(){
	atualizaUbuntu

	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https &&
	echo "Apache Instalado!"
	echo ""

	confSpeedTest	
}

instala1604(){
	atualizaUbuntu

	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.0 php7.0 unzip apt-transport-https &&
	echo "Apache Instalado!"
	echo ""
	
	confSpeedTest
}

setup