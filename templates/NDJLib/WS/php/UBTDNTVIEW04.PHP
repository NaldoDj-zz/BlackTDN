<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	   = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";
			$client    = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$alias     = "SRA";
			$param     = array("ALIAS"=>$alias);
			$fields    = $client->getTFieldsName($param);
			$array     = $fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING;
 			$fNames	   = array("RA_FILIAL","RA_MAT","RA_NOME","RA_CIC","RA_ADMISSA");	
			$arrRemove = array_merge(array_diff($array,$fNames));
			$fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING = array_merge(array_diff($array,$arrRemove));
			$fields    = $fields->GETTFIELDSNAMERESULT;
			$deleted   = false;
			$recno	   = false;
			$param     = array("ALIAS"=>$alias,"FIELDSNAME"=>$fields,"RDELETED"=>$deleted);
			$tStruct = $client->GETTSTRUCTBYFIELDSNAME($param);
      		echo "<table>";
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
        	$step    = $tRMax%10;
			if ($tRMax>0){
				for ($i = 1; $i <= $tRMax; $i+=$step) {
					$e		 = min($i+$step,$tRMax);
					$param   = array("ALIAS"=>$alias,"RINIT"=>$i,"REND"=>$e,"FIELDSNAME"=>$fields,"RDELETED"=>$deleted,"RRECNO"=>$recno);
					$result  = $client->GETTDATABYFIELDSNAME($param);
					if (is_array($result->GETTDATABYFIELDSNAMERESULT->FIELDVIEW)){
						foreach ($result->GETTDATABYFIELDSNAMERESULT->FIELDVIEW as $itens) {
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
							if (is_array($result->GETTDATABYFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING)){
								foreach ($result->GETTDATABYFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING as $item) {
									echo "<td><pre>".print_r($item,true)."</pre></td>";
								}
							} else{
								$item = $result->GETTDATABYFIELDSNAMERESULT->FIELDVIEW->FLDTAG->STRING;
								echo "<td><pre>".print_r($item,true)."</pre></td>";
							}	
						echo "<tr>";
					}
				}	
				echo "</tbody>";			
				echo "</table>";
			}	
			die();
		?>
	</body>
</html>