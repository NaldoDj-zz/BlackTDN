<html>
	<head>
		<title>BlackTDN :: UBTDNTBLVIEW.php</title>
	</head>
	<body>
		<?php
			$wsdl	 = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";
			$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
			$alias   = "SA1";
			$deleted = false;
			$recno   = false;
			$param   = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
			$result  = $client->GETTRMAX($param);
			$tRMax   = $result->GETTRMAXRESULT;
			$where   = "A1_COD BETWEEN '000001' AND '000100' ORDER BY A1_FILIAL,A1_COD,A1_LOJA";
			$param   = array("ALIAS"=>$alias,"RINIT"=>1,"REND"=>$tRMax,"WHERE"=>$where,"RDELETED"=>$deleted,"RRECNO"=>$recno);
			$result  = $client->GETTBYWHERE($param);
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
				foreach ($result->GETTBYWHERERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
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
			echo "<tbody>";
			echo "</table>";
			echo "<br />";
			echo "<table border='1' align='left'>";
			echo 	"<thead>";
			echo 		"<tr align='left'>";
				foreach ($result->GETTBYWHERERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
						echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
				}
			echo 		"</tr>";
			echo 	"</thead>";	  
			echo "<tbody>";
			if (is_array($result->GETTBYWHERERESULT->TABLEDATA->FIELDVIEW)){
				foreach ($result->GETTBYWHERERESULT->TABLEDATA->FIELDVIEW as $itens) {
					echo "<tr align='left'>";
					foreach ($itens->FLDTAG->STRING as $item) {
						echo "<td><pre>".print_r($item,true)."</pre></td>";
					}
					echo "</tr>";
				}
			} else{
				echo "<tr align='left'>";
					foreach ($result->GETTBYWHERERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING as $item) {
						echo "<td><pre>".print_r($item,true)."</pre></td>";
					}
				echo "<tr>";
			}
			echo "</tbody>";			
			echo "</table>";
			die();
		?>
	</body>
</html>