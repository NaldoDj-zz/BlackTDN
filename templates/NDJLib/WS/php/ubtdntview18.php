<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	   = "http://BlackTDN:8088/wsDev02/UBTDNTVIEW.apw?WSDL";
			try {
				$client    = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
				$alias     = "SX3";
				$deleted   = true;
				$recno	   = true;
				$param     = array("ALIAS"=>$alias,"RDELETED"=>$deleted,"RRECNO"=>$recno);
				$tStruct = $client->GETTSTRUCT($param);
				$param     = array("ALIAS"=>$alias);
				$fields    = $client->GETTFIELDSNAME($param);
				$array     = $fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING;
				$fNames    = array();
				for ($f = 0; $f < sizeof($array); ++$f) {
					if ($tStruct->GETTSTRUCTRESULT->UFIELDSTRUCT[$f]->FLDMANDATORY){
						array_push($fNames,$array[$f]);
					}	
				}
				$arrRemove = array_merge(array_diff($array,$fNames));
				$fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING = array_merge(array_diff($array,$arrRemove));
				$fields    = $fields->GETTFIELDSNAMERESULT;
				$param     = array("ALIAS"=>$alias,"FIELDSNAME"=>$fields,"RDELETED"=>$deleted,"RRECNO"=>$recno);
				$tStruct = $client->GETTSTRUCTBYFIELDSNAME($param);
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
				if (is_array($tStruct->GETTSTRUCTBYFIELDSNAMERESULT->UFIELDSTRUCT)){	
					foreach ($tStruct->GETTSTRUCTBYFIELDSNAMERESULT->UFIELDSTRUCT as $item) {
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
						foreach ($tStruct->GETTSTRUCTBYFIELDSNAMERESULT as $item) {
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
				if (is_array($tStruct->GETTSTRUCTBYFIELDSNAMERESULT->UFIELDSTRUCT)){
					foreach ($tStruct->GETTSTRUCTBYFIELDSNAMERESULT->UFIELDSTRUCT as $item) {
							echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
					}
				} else {
					foreach ($tStruct->GETTSTRUCTBYFIELDSNAMERESULT as $item) {
						echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
					}
				}	
				echo 		"</tr>";
				echo 	"</thead>";	  
				echo "<tbody>";
				$param   = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
				$result  = $client->GETTRMAX($param);
				$tRMax   = $result->GETTRMAXRESULT;
				$where   = "X3_ARQUIVO=='SRA'";
				$param   = array("ALIAS"=>$alias,"WHERE"=>$where,"RINIT"=>1,"REND"=>$tRMax,"RDELETED"=>$deleted);
				$recnos	 = $client->GETTRECNOSBYWHERE($param);
				if (is_array($recnos->GETTRECNOSBYWHERERESULT->URECNOS->STRING)){
					$recnos = array("URECNOS"=>$recnos->GETTRECNOSBYWHERERESULT->URECNOS->STRING);
					$param   = array("ALIAS"=>$alias,"TABLERECNOS"=>$recnos,"FIELDSNAME"=>$fields,"RDELETED"=>$deleted,"RRECNO"=>$recno);
					try {
						$result  = $client->GETTDATABYRECNOSANDFIELDSNAME($param);
						if (is_array($result->GETTDATABYRECNOSANDFIELDSNAMERESULT->FIELDVIEW)){
							foreach ($result->GETTDATABYRECNOSANDFIELDSNAMERESULT->FIELDVIEW as $itens) {
								echo "<tr align='left'>";
								if (is_array($itens->FLDTAG->STRING)){
									foreach ($itens->FLDTAG->STRING as $item) {
										echo "<td><pre>".print_r($item,true)."</pre></td>";
									}
								} else {
									foreach ($itens->FLDTAG as $item) {
										echo "<td><pre>".print_r($item,true)."</pre></td>";
									}
								}	
								echo "</tr>";
							}
						} else{
							echo "<tr align='left'>";
								if (is_array($result->GETTDATABYRECNOSANDFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING)){
									foreach ($result->GETTDATABYRECNOSANDFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING as $item) {
										echo "<td><pre>".print_r($item,true)."</pre></td>";
									}
								} else{
									$item = $result->GETTDATABYRECNOSANDFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING;
									echo "<td><pre>".print_r($item,true)."</pre></td>";
								}	
							echo "<tr>";
						}
					} catch (exception $e){
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
					echo "</tbody>";			
					echo "</table>";
				}
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