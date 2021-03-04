#!/bin/bash

versaoUbuntu() {
    echo "[LV SPEEDTEST] Selecione a Versao:"
    echo ""
    echo "[1] Ubuntu 18.04 | [2] Ubuntu 16.04"
    echo ""
}

atualizaUbuntu() {
	echo "Atualizando o Linux"
	echo ""
	apt-get update && apt-get -y upgrade
}

sshConecte(){
	echo "teste"

}

instala1804(){
	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https &&
	echo "OK"
	echo ""

	delay 2s
	
	echo "Criando Usuario"
	echo ""
	addgroup ooklaserver && useradd -d /etc/ooklaserver -m -g ooklaserver -s /bin/bash ooklaserver
	echo "OK"
	echo ""

	delay 2s

	echo "Acessando Usuário - Baixando Pacote"
	echo ""
	su - ooklaserver &&
	https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/resources/ooklaserver.sh &&
	exit &&

	echo "Instalando SpeedTest"
	echo ""
	chmod +x ooklaserver.sh && ./ooklaserver.sh install &&
	echo ""
}

instala1604(){
	apt -y install apache2 libapache2-mod-php7.0 php7.0 unzip apt-transport-https  
}

instalaCert(){
	echo "teste"
   
}

versaoUbuntu(){
    if [ "$versaoZbx" = "1" ]; then
        instala1804
    elif [ "$versaoZbx" = "2" ]; then
        instala1604
    else
        echo "OPCAO INVALIDA"
    fi
}

versaoUbuntu