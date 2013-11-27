<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
	<?php
		$wsdl	 = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";	
		$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
		echo "<pre>".print_r($client->__getFunctions(),true)."</pre>";
		echo "<pre>".print_r($client->__getTypes(),true)."</pre>";
	?>
	</body>
</html>