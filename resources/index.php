<?php

	#####################################
	# SPEEDTEST CUSTOM - AUTHOR: NILSON #
	#####################################

	$provTag  = 'lvnetwork'; // Informe o nome do provedor configurado no painel Custom.
	$provCor  = '#FFFFFF';   // Informe a cor de fundo para página - Valor em Hexadecimal.
	
	$provURL  = 'https://'.$provTag.'.speedtestcustom.com'; // Não altere essa linha!
	
?>

<!-- Corpo da Página HTML -->

<!DOCTYPE html>
<html>
	<head>
		<title><?php echo strtoupper($provTag);?></title>
	</head>

	<body style="background-color: <?php echo $provCor;?>;" >

		<iframe width="100%" height="650px" frameborder="0" src="<?php echo $provURL;?>"></iframe>

	</body>
</html>

<!-- Corpo da Página HTML -->