<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
	<?php
		$wsdl	 = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";	
		try {
				$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
				echo "<table>";
				echo 	"<thead>";
				echo 		"<tr align='left'>";
				echo 			"<th>__getFunctions</th>";
				echo 		"</tr>";
				echo 	"</thead>";
				echo 	"<tbody>";
				echo 		"<tr>";
				echo 			"<td>";
				echo 				"<pre>".print_r($client->__getFunctions(),true)."</pre>";
				echo 			"</td>";
				echo 		"</tr>";
				echo 	"</tbody>";
				echo "</table>";
				echo "<table>";
				echo 	"<thead>";
				echo 		"<tr align='left'>";
				echo 			"<th>__getTypes()</th>";
				echo 		"</tr>";
				echo 	"</thead>";
				echo 	"<tbody>";
				echo 		"<tr>";
				echo 			"<td>";
				echo 				"<pre>".print_r($client->__getTypes(),true)."</pre>";
				echo 			"</td>";
				echo 		"</tr>";
				echo 	"</tbody>";
				echo "</table>";				
			} catch (SoapFault $fault) {
						echo "<table>";
						echo 	"<thead>";
						echo 		"<tr>";
						echo 			"<th>SOAP Fault</th>";
						echo 		"</tr>";
						echo 	"</thead>";
						echo 	"<tbody>";
						echo 		"<tr>";
						echo 			"<td>";
						echo 				"<pre>";
						echo 				"".print_r(trigger_error("SOAP Fault: (faultcode: {$fault->faultcode}, faultstring: {$fault->faultstring})", E_USER_ERROR),true)."";
						echo 				"</pre>";
						echo 			"</td>";
						echo 		"</tr>";
						echo 	"</tbody>";
						echo "</table>";
			} catch (exception $e) {
						echo "<table>";
						echo 	"<thead>";
						echo 		"<tr>";
						echo 			"<th>Caught Exception</th>";
						echo 		"</tr>";
						echo 	"</thead>";
						echo 	"<tbody>";
						echo 		"<tr>";
						echo 			"<td>";
						echo 				"<pre>";
						echo 					"Caught Exception ('{$e->getMessage()}')\n{$e}\n";
						echo 				"</pre>";
						echo 			"</td>";
						echo 		"</tr>";
						echo 	"</tbody>";
						echo "</table>";
			}				
	?>
	</body>
</html>