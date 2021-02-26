#!/bin/bash

################################
##                            ##
##  Name: Renova SSL          ##
##  Author: Nilson Pessim     ##
##  Date: 16/01/2021 Rev 1.1  ##
##                            ##
################################

echo "###### Iniciando renovacao Automatica ######"
sleep 5
echo ""

echo "[LV-ALERT] Parando o Apache..."
sleep 2
apachectl stop &&
echo "[OK]"
echo ""
sleep 2

echo "[LV-ALERT] Renovando o Certificado..."
sleep 2
certbot -q renew &&
chown ooklaserver. /etc/letsencrypt/ -R &&
echo "[OK]"
echo ""
sleep 2

echo "[LV-ALERT] Reiniciando OoklaServer..."
sleep 2
cd /etc/ooklaserver &&
echo ""
echo "[LV-ALERT] Parando Servidor..."
./ooklaserver.sh stop &&
echo ""
echo "[LV-ALERT] Iniciando Servidor..."
su ooklaserver -c '/etc/ooklaserver/ooklaserver.sh start' &&
systemctl start apache2 &&
sleep 2
echo ""

echo "[LV-ALERT] O certificado foi renovado!"
echo ""
echo ""