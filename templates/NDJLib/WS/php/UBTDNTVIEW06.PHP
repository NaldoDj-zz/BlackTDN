<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	   = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";	
			$client    = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$alias     = "SRA";
			$deleted   = false;
			$recno	   = false;	
			$param     = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
			$result    = $client->GETTRMAX($param);
			$tRMax     = $result->GETTRMAXRESULT;
        	$step      = $tRMax%10;
			if ($tRMax>0){
			    $results = array();
				$fNames  = array("RA_FILIAL","RA_MAT","RA_NOME","RA_CIC","RA_ADMISSA");
				$fldName = array("UFLDNAME"=>$fNames);
				for ($i = 1; $i <= $tRMax; $i+=$step) {
					$e	= min($i+$step,$tRMax);
					$param   = array("ALIAS"=>$alias,"RINIT"=>$i,"REND"=>$e,"FIELDSNAME"=>$fldName,"RDELETED"=>$deleted,"RRECNO"=>$recno);
					$result  = $client->GETTABLEBYFIELDSNAME($param);
					array_push ($results,$result);
				}
				$result = $results[0];
				echo "<table border='1' align='left'>";
				echo 	"<thead>";
				echo 		"<tr align='left'>";
				echo 			"<th>FLDNAME</th>";
				echo 			"<th>FLDTYPE</th>";
				echo 			"<th>FLDSIZE</th>";
				echo 			"<th>FLDDEC</th>";
				echo 			"<th>FLDTITLE</th>";
				echo 			"<th>FLDDESCRIPTION</th>";
				echo 			"<th>FLDMANDATORY</th>";
				echo 		"</tr>";
				echo 	"</thead>";	  
				echo "<tbody>";
				if (is_array($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT)){				
					foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
						 echo "<tr>";
							echo "<td><pre>".print_r($item->FLDNAME,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDTYPE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDSIZE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDDEC,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDTITLE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDDESCRIPTION,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDMANDATORY,true)."</pre></td>";
						echo "</tr>";
					}
				} else {
					 echo "<tr>";
					foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT as $item) {
							echo "<td><pre>".print_r($item->FLDNAME,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDTYPE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDSIZE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDDEC,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDTITLE,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDDESCRIPTION,true)."</pre></td>";
							echo "<td><pre>".print_r($item->FLDMANDATORY,true)."</pre></td>";
					}	
					echo "</tr>";
				}	
				echo "<tbody>";
				echo "</table>";
				echo "<br />";
				echo "<table border='1' align='left'>";
				echo 	"<thead>";
				echo 		"<tr align='left'>";
				if (is_array($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT)){
					foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
							echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
					}
				}else{
					foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLESTRUCT as $item) {
							echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
					}
				}			
				echo 		"</tr>";
				echo 	"</thead>";	  
				echo "<tbody>";
				foreach ($results as $result){
					if (is_array($result->GETTABLEBYFIELDSNAMERESULT->TABLEDATA->FIELDVIEW)){
						foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLEDATA->FIELDVIEW as $itens) {
							echo "<tr align='left'>";
							if (is_array($itens->FLDTAG->STRING)){
								foreach ($itens->FLDTAG->STRING as $item) {
									echo "<td><pre>".print_r($item,true)."</pre></td>";
								}
							}else{
								foreach ($itens->FLDTAG as $item) {
									echo "<td><pre>".print_r($item,true)."</pre></td>";
								}	
							}	
							echo "</tr>";
						}
					} else{
						echo "<tr align='left'>";
						if (is_array($result->GETTABLEBYFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING)){
							foreach ($result->GETTABLEBYFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING as $item) {
								echo "<td><pre>".print_r($item,true)."</pre></td>";
							}
						} else {
							$item = $result->GETTABLEBYFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING;
							echo "<td><pre>".print_r($item,true)."</pre></td>";
						}	
						echo "</tr>";
					}
				}	
				echo "</tbody>";			
				echo "</table>";
			}	
			die();
		?>
	</body>
</html>