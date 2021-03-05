# Entre com o Usuário OoklaServer
su - ooklaserver

# Baixe o renovador automático
wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/certificado-ssl/renovaSSL.sh

# Saia do Usuário
exit

# Transforme o arquivo em um executável
chmod +x /etc/ooklaserver/renovaSSL.sh

# Inclua o Script na Cron
echo '00 00   1 * *   root    /etc/ooklaserver/renovaSSL.sh' >> /etc/crontab

# Reinicie a Cron
systemctl restart cron

# Veja a inclusão no arquivo
cat /etc/crontab

# Execute o Script
bash /etc/ooklaserver/renovaSSL.sh