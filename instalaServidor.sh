#!/bin/bash

versaoUbuntu() {
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
	echo "Atualizando o Linux"
	echo ""
	apt-get update && apt-get -y upgrade
}

sshConecte(){
	echo "teste"
}

confRcLocal(){
	touch /etc/rc.local
	echo "#!/bin/sh" >> /etc/rc.local
	echo "su ooklaserver -c './etc/ooklaserver/OoklaServer --daemon'" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local

	chmod +x /etc/rc.local

	delay 2

	sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
	sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf
}

confCertificado(){
	apt -y install letsencrypt python-certbot-apache &&
	apache2ctl stop &&
	letsencrypt --authenticator standalone --installer apache -n --agree-tos --email $emailProvedor -d $subDomProvedor &&

	echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/$subDomProvedor/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/$subDomProvedor/privkey.pem'    >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/$subDomProvedor/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties.default
	echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/$subDomProvedor/privkey.pem' >> /etc/ooklaserver/OoklaServer.properties.default

	chown ooklaserver. /etc/letsencrypt/ -R &&

	cd /etc/ooklaserver &&
	./ooklaserver.sh stop &&
	su ooklaserver -c  '/etc/ooklaserver/ooklaserver.sh start' &&

	su ooklaserver -c  'wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/certificado-ssl/renovaSSL.sh' &&

	chmod +x /etc/ooklaserver/renovaSSL.sh &&

	echo '00 00 1 * * root /etc/ooklaserver/renovaSSL.sh' >> /etc/crontab && 

	systemctl restart cron

	reboot

}

confSpeedTest(){
	echo "Criando Usuario"
	echo ""
	addgroup ooklaserver && useradd -d /etc/ooklaserver -m -g ooklaserver -s /bin/bash ooklaserver &&
	echo "OK"
	echo ""	

	delay 2

	echo "Acessando Usuário - Baixando Pacote"
	echo ""

	su ooklaserver -c  'wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/resources/ooklaserver.sh --no-check-certificate' &&
	su ooklaserver -c  'chmod +x ooklaserver.sh' &&
	su ooklaserver -c  './ooklaserver.sh install' &&
	
	echo "OK"
	echo ""

	delay 2

	echo "Instalando SpeedTest"
	echo ""
	chmod +x ooklaserver.sh && ./ooklaserver.sh install &&
	echo "OK"
	echo ""

	delay 2

	echo "Informe o Dominio do Provedor:"
	read dominioProvedor
	echo ""

	echo "Informe o Subdominio do Provedor:"
	read subDomProvedor
	echo ""

	echo "Informe o Email do Provedor:"
	read emailProvedor
	echo ""

	echo "Configurando Arquivos..."

	echo 'openSSL.server.privateKeyFile OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *.$dominioProvedor' >> /etc/ooklaserver/OoklaServer.properties
	echo 'openSSL.server.privateKeyFile OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *.$dominioProvedor' >> /etc/ooklaserver/OoklaServer.properties.default

	sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf &&
	sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf &&

	wget https://github.com/lvnetwork-dev/speedtest/blob/main/resources/fallback.zip?raw=true &&

	unzip fallback.zip /var/www/html/ &&

	touch /var/www/html/crossdomain.xml

	echo '<?xml version="1.0"?>' >> /var/www/html/crossdomain.xml
	echo "<cross-domain-policy>" >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.speedtest.net" />' >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.ookla.com" />' >> /var/www/html/crossdomain.xml
	echo '<allow-access-from domain="*.$dominioProvedor" />' >> /var/www/html/crossdomain.xml
	echo "</cross-domain-policy>" >> /var/www/html/crossdomain.xml

	confCertificado
}

instala1804(){
	atualizaUbuntu

	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https &&
	echo "OK"
	echo ""

	confSpeedTest
	confRcLocal
}

instala1604(){
	atualizaUbuntu

	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.0 php7.0 unzip apt-transport-https &&
	echo "OK"
	echo ""
	
	confSpeedTest
	confRcLocal
}

versaoUbuntu