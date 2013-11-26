<html>
	<head>
		<title>UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	 = "http://naldo-pc:8088/ws02/UBTDNTVIEW.apw?WSDL";	
			$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$alias   = "SX2";
			$deleted = false;
			$recno	 = false;
			$param   = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
			$result  = $client->GETTRMAX($param);
			$tRMax   = $result->GETTRMAXRESULT;
			echo "<pre>".print_r($result,true)."</pre>";
			$step    = $tRMax%10;
			echo "<table>";
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
			die();
		?>
	</body>
</html>