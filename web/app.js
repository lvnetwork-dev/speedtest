$(document).ready(function() {
    
	$('#btnGeraScript').click(function(){

		var wizard          = $("#scriptGerado").steps();
		var versaoOS        = $('#versaoOS').val();
		var emailProvedor   = $('#emailProvedor').val();
		var dominioProvedor = $('#dominioProvedor').val();
		var subDominio      = $('#subDominio').val();

		geraScript(wizard, versaoOS, emailProvedor, dominioProvedor, subDominio);

		$('#formulario').css("display", "none");
	
	});

	$('#btnReloadPage').click(function(){

		location.reload();
	
	});
	
});

function geraScript(wizard, versaoOS, emailProvedor, dominioProvedor, subDominio){

	insPHP(wizard, versaoOS); 
	addUsuario(wizard); 
	insOokla(wizard); 
	addRcLocal(wizard); 
	addFallBack(wizard);
	addCrossDomain(wizard, dominioProvedor); 
	addCertificado(wizard, emailProvedor, subDominio);
	confArquivos(wizard, dominioProvedor, subDominio);

}

function insPHP(wizard, versaoOS){

	if (versaoOS == '1804') {
		wizard.steps("add", {
			title: "", 
			content: '<h5>Atualizar os repositórios e pacotes do sistema:</h5> <code> apt-get update && apt-get -y upgrade </code> <hr> <h5>Instalar PHP e Apache para Ubuntu 18.04 - Bionic Beaver:</h5> <code> apt-get -y install apache2 libapache2-mod-php7.2 php7.2 unzip apt-transport-https </code>'
		});
	} else {
		wizard.steps("add", {
			title: "", 
			content: '<h5>Atualizar os repositórios e pacotes do sistema:</h5> <code> apt-get update && apt-get -y upgrade </code> <hr> <h5>Instalar PHP e Apache para Ubuntu 16.04 - Xenial Xerus:</h5> <code> apt-get -y install apache2 libapache2-mod-php7.0 php7.0 unzip apt-transport-https </code>'
		});
	}

}

function addUsuario(wizard){
	wizard.steps("add", {
		title: "", 
		content: '<h5>Iremos utilizar um usuário sem poderes de root para executar os serviços da Ookla:</h5> <code> addgroup ooklaserver <br>  useradd -d /etc/ooklaserver -m -g ooklaserver -s /bin/bash ooklaserver <br> su - ooklaserver </code>'
	});
}

function insOokla(wizard){
	wizard.steps("add", {
		title: "", 
		content: '<h5>Baixe e execute o instalador dentro do usuário OoklaServer:</h5> <code> wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/resources/ooklaserver.sh <br> chmod 777 ooklaserver.sh <br> ./ooklaserver.sh install </code>'
	});
}

function addRcLocal(wizard){
	wizard.steps("add", {
		title: "", 
		content: "<h5>Iniciar serviço automaticamente:</h5> <code> nano /etc/rc.local </code> <br> <br> <div class='alert alert-primary'> #!/bin/sh <br> su ooklaserver -c './etc/ooklaserver/OoklaServer --daemon'<br>exit 0 </div> <br> <code> chmod +x /etc/rc.local </code>"
	});
}

function addFallBack(wizard){
	wizard.steps("add", {
		title: "", 
		content: '<h5>Instalar Fallback:</h5> <code> cd /var/www/html/ <br> wget https://github.com/lvnetwork-dev/speedtest/raw/main/resources/fallback.zip <br> unzip fallback.zip && rm fallback.zip </code>' 
	});
}

function addCrossDomain(wizard, dominioProvedor){
	var obj = new Object();
	wizard.steps("add", {
		title: "", 
		content: '<h5>Configure o CrossDomain:</h5> <code> nano /var/www/html/crossdomain.xml </code> <br> <br> <div class="alert alert-primary"> &lt;allow-access-from domain=&quot;*.'+dominioProvedor+'&quot;/&gt; <div>'
	});
}

function addCertificado(wizard, emailProvedor, subDominio){
	conteudo = '<h5>Configurar Certificado:</h5> <code> apt install letsencrypt python-certbot-apache <br> apache2ctl stop <br> letsencrypt --authenticator standalone --installer apache -n --agree-tos --email '+emailProvedor+' -d '+subDominio+'</code>';
	conteudo += '<hr><h5> Script renovação automática: </h5> <code> su - ooklaserver <br> wget https://raw.githubusercontent.com/lvnetwork-dev/speedtest/main/certificado-ssl/renovaSSL.sh </code> <br>';
	conteudo += "<code> chmod +x /etc/ooklaserver/renovaSSL.sh <br> exit <br> echo '00 00 1 * * root /etc/ooklaserver/renovaSSL.sh' >> /etc/crontab <br> systemctl restart cron </code>";
	
	wizard.steps("add", {
		title: "", 
		content: conteudo
	});
}

function confArquivos(wizard, dominioProvedor, subDominio){
	conteudo = '<h5>Configurar Arquivos:</h5>';

	conteudo += "<code> echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/"+subDominio+"/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties</code> <br>"; 
	conteudo += "<code> echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/"+subDominio+"/privkey.pem'    >> /etc/ooklaserver/OoklaServer.properties</code> <br>";
	conteudo += "<code> echo 'OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *."+dominioProvedor+"'    >> /etc/ooklaserver/OoklaServer.properties</code> <br>";

	conteudo += "<code> echo 'openSSL.server.certificateFile = /etc/letsencrypt/live/"+subDominio+"/fullchain.pem' >> /etc/ooklaserver/OoklaServer.properties.default</code> <br>";
	conteudo += "<code> echo 'openSSL.server.privateKeyFile = /etc/letsencrypt/live/"+subDominio+"/privkey.pem' >> /etc/ooklaserver/OoklaServer.properties.default</code> <br>";
	conteudo += "<code> echo 'OoklaServer.allowedDomains = *.ookla.com, *.speedtest.net, *."+dominioProvedor+"'    >> /etc/ooklaserver/OoklaServer.properties.default</code> <br> <br>";

	conteudo += "<code> chown ooklaserver. /etc/letsencrypt/ -R <br> reboot</code>"; 

	wizard.steps("add", {
		title: "", 
		content: conteudo
	});
}