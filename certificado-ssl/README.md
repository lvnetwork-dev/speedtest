## Renovar Certificado :gear:
* :star_struck: Repositório para renovar o certificado SSL.
 
## Procedimentos:
* Entre com o Usuário OoklaServer:
>    $ su - ooklaserver

* Baixe o renovador automático:
>    $ wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/certificado-ssl/renovaSSL.sh

* Saia do Usuário:
>    $ exit

* Transforme o arquivo em um executável:
>    $ chmod +x /etc/ooklaserver/renovaSSL.sh

* Inclua o Script na Cron:
>    $ echo '00 00   1 * *   root    /etc/ooklaserver/renovaSSL.sh' >> /etc/crontab

* Reinicie a Cron:
>    $ systemctl restart cron

* Veja a inclusão no arquivo:
>    $ cat /etc/crontab

* Execute o Script:
>    $ ./etc/ooklaserver/renovaSSL.sh


## Desenvolvedor :heart_eyes_cat:
[![Github Badge](https://img.shields.io/badge/-Github-000?style=flat-square&logo=Github&logoColor=white&link=https://github.com/nilsonpessim)](https://github.com/nilsonpessim)
[![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://br.linkedin.com/in/nilsonpessim)](https://br.linkedin.com/in/nilsonpessim)
[![Whatsapp Badge](https://img.shields.io/badge/-Whatsapp-4CA143?style=flat-square&labelColor=4CA143&logo=whatsapp&logoColor=white&link=https://api.whatsapp.com/send?phone=5537999351046)](https://api.whatsapp.com/send?phone=5537999351046)