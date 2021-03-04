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

confSpeedTest(){
	echo "Criando Usuario"
	echo ""
	addgroup ooklaserver && useradd -d /etc/ooklaserver -m -g ooklaserver -s /bin/bash ooklaserver &&
	echo "OK"
	echo ""	

	delay 2

	echo "Acessando Usuário - Baixando Pacote"
	echo ""
	su - ooklaserver &&
	https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/resources/ooklaserver.sh &&
	exit &&
	echo "OK"
	echo ""

	delay 2

	echo "Instalando SpeedTest"
	echo ""
	chmod +x ooklaserver.sh && ./ooklaserver.sh install &&
	echo "OK"
	echo ""

	delay 2
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

confOoklaServer(){
	echo "teste"
}

confCertificado(){
	echo "teste"
}

instala1804(){
	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https &&
	echo "OK"
	echo ""

	confSpeedTest
	confRcLocal
}

instala1604(){
	echo "Instalando Apache e PHP"
	echo ""
	apt -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https &&
	echo "OK"
	echo ""
	
	confSpeedTest
	confRcLocal
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

instalacaoAvancada() {
    echo "[LV SPEEDTEST] Selecione o Tipo de Instacao:"
    echo ""
    echo "[1] Simples | [2] Avancada"
    echo ""
}

instalacaoSimples(){

}

setup() {
    echo "[LV SPEEDTEST] Selecione o Tipo de Instacao:"
    echo ""
    echo "[1] Simples | [2] Avancada"
    echo ""

    read tipoInstalacao

    if [ "$tipoInstalacao" = "1" ]; then
        instalacaoSimples
    elif [ "$tipoInstalacao" = "2" ]; then
        instalacaoAvancada
    else
        echo "OPCAO INVALIDA"
    fi
}

setup