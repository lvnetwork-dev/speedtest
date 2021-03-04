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

}

instala1604(){
   
}

instala1804(){

}

verVersao(){
    if [ "$versaoZbx" = "1" ]; then
        instalaZbx40
    elif [ "$versaoZbx" = "2" ]; then
        instalaZbx50
    else
        echo "OPCAO INVALIDA"
    fi
}

instalaFront(){
    echo "FrontEnd"
}

selVersao
verVersao