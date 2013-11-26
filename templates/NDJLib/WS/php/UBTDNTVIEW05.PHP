<html>
	<head>
		<title>UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	   = "http://naldo-pc:8088/ws02/UBTDNTVIEW.apw?WSDL";
			$client    = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$alias     = "SA1";
			$deleted   = false;
			$recno     = false;
			$param     = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
			$result    = $client->GETTRMAX($param);
			$tRMax     = $result->GETTRMAXRESULT;
			$fields    = $client->getTFieldsName($param);
			$array     = $fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING;
 			$fNames	   = array("A1_FILIAL","A1_COD","A1_LOJA","A1_NOME","A1_NREDUZ","A1_CGC");
			$arrRemove = array_merge(array_diff($array,$fNames));
			$fields->GETTFIELDSNAMERESULT->UFLDNAME->STRING = array_merge(array_diff($array,$arrRemove));
			$fields    = $fields->GETTFIELDSNAMERESULT;
			$where     = "A1_COD BETWEEN '000001' AND '001000' ORDER BY A1_FILIAL,A1_COD,A1_LOJA";
			$param     = array("ALIAS"=>$alias,"RINIT"=>1,"REND"=>$tRMax,"WHERE"=>$where,"FIELDSNAME"=>$fields,"RDELETED"=>$deleted,"RRECNO"->$recno);
			$result    = $client->GETTBYWHEREANDFIELDSNAME($param);
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
			if (is_array($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT)){
				foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
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
					foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT as $item) {
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
			if (is_array($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT)){
				foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
						echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
				}
			} else {
				foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLESTRUCT as $item) {
						echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
				}
			}	
			echo 		"</tr>";
			echo 	"</thead>";	  
			echo "<tbody>";
			if (is_array($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLEDATA->FIELDVIEW)){
				foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLEDATA->FIELDVIEW as $itens) {
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
				if (is_array($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING)){
					foreach ($result->GETTBYWHEREANDFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING as $item) {
						echo "<td><pre>".print_r($item,true)."</pre></td>";
					}
				} else {
					$item = $result->GETTBYWHEREANDFIELDSNAMERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING;
					echo "<td><pre>".print_r($item,true)."</pre></td>";
				}	
				echo "<tr>";
			}
			echo "</tbody>";			
			echo "</table>";
			echo "</table>";
			echo "<br/>";
			die();
		?>
	</body>
</html>