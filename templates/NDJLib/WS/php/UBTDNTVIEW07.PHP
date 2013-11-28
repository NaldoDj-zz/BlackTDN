<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	 = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";	
			try {
				$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
				$alias   = "SX2";
				$deleted = false;
				$param   = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
				$result  = $client->GETTRMAX($param);
				$tRMax   = $result->GETTRMAXRESULT;
				echo "<pre>".print_r($result,true)."</pre>";
				$step    = 40;
				echo "<table border='1' align='left'>";
				echo 	"<thead>";
				echo 		"<tr align='left'>";
				echo 			"<th>CODE</th>";
				echo 			"<th>DESCRIPTION</th>";
				echo 		"</tr>";
				echo 	"</thead>";	  
				echo 	"<tbody>";
				for ($i = 1; $i <= $tRMax; $i+=$step) {
					$e	= min($i+$step,$tRMax);
					$param   = array("ALIAS"=>$alias,"RINIT"=>$i,"REND"=>$e);
					$result  = $client->GETTALIAS($param);
					if (is_array($result->GETTALIASRESULT->TALIASES->UANYCODEDESC)){
						foreach ($result->GETTALIASRESULT->TALIASES->UANYCODEDESC as $item) {
							echo "<tr>";
							echo "<td><pre>".print_r($item->CODE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->DESCRIPTION,true)."</pre></td>";
							echo "</tr>";
						}
					} else{
							$item = $result->GETTALIASRESULT->TALIASES->UANYCODEDESC;
							echo "<tr align='left'>";
								echo "<td><pre>".print_r($item->CODE,true)."</pre></td>";
								echo "<td><pre>".print_r($item->DESCRIPTION,true)."</pre></td>";
							echo "<tr>";
					}	
				}
				echo 	"<tbody>";
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
			die();
		?>
	</body>
</html>