<html>
    <head>
        <title>BlackTDN :: UBTDNTBLVIEW.php</title>
    </head>
    <body>
        <?php
		   $wsdl = "http://BlackTDN:8088/ws02/UBTDNTVIEW.apw?WSDL";    
           try { // exceptions -> http://php.net/manual/en/language.exceptions.php
				// SoapClient and WSDL_CACHE_NONE -> http://php.net/manual/en/soapclient.soapclient.php
				$client  = new SoapClient($wsdl,array("cache_wsdl"=>WSDL_CACHE_NONE));
				$alias   = "SRA";
				$deleted = false;
				$recno   = false;
				$param   = array("ALIAS"=>$alias,"RDELETED"=>$deleted);
				try { // try -> http://php.net/manual/en/language.exceptions.php
					$result  = $client->GETTRMAX($param);
					$tRMax   = intVal($result->GETTRMAXRESULT/10);
				} catch (SoapFault $fault) { //SoapFault -> http://php.net/manual/en/function.is-soap-fault.php
					$tRMax = 0;
				}	
				//Control Structures (if) -> http://www.php.net/manual/en/control-structures.if.php
			    if ($tRMax>0){
					$step    = $tRMax%10;					
					//array -> http://php.net/manual/en/ref.array.php
					$results = array(); 
					//control Structures (for) -> http://php.net/manual/en/control-structures.for.php
					for ($i = 1; $i <= $tRMax; $i+=$step) {  
						$e      = min($i+$step,$tRMax);
						$param   = array("ALIAS"=>$alias,"RINIT"=>$i,"REND"=>$e,"RDELETED"=>$deleted,"RRECNO"=>$recno);
						$result  = $client->GETTABLE($param);
						// exceptions -> http://php.net/manual/en/language.exceptions.php
						if (!is_soap_fault($result)){ //is_soap_fault -> http://php.net/manual/en/function.is-soap-fault.php
							array_push ($results,$result); //array_push -> http://php.net/manual/en/ref.array.php
						}
					}	
					//sizeof -> http://www.php.net/manual/en/function.sizeof.php
					if (sizeof($results)>0 ){
						$result = $results[0];
					} else {
						//throw - > http://php.net/manual/en/language.exceptions.php
						throw new Exception('No Results');
					}		
					echo "<table border='1' align='left'>";
					echo     "<thead>";
					echo         "<tr align='left'>";
					echo             "<th>FLDNAME</th>";
					echo             "<th>FLDTYPE</th>";
					echo             "<th>FLDSIZE</th>";
					echo             "<th>FLDDEC</th>";
					echo             "<th>FLDTITLE</th>";
					echo             "<th>FLDDESCRIPTION</th>";
					echo             "<th>FLDMANDATORY</th>";
					echo         "</tr>";
					echo     "</thead>";      
					echo "<tbody>";
					// is_array -> //array -> http://php.net/manual/en/ref.array.php
					if (is_array($result->GETTABLERESULT->TABLESTRUCT->UFIELDSTRUCT)){
						//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
						foreach ($result->GETTABLERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) { 
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
						//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
						foreach ($result->GETTABLERESULT->TABLESTRUCT as $item) {
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
					echo     "<thead>";
					echo         "<tr align='left'>";
					//Control Structures (if) -> http://www.php.net/manual/en/control-structures.if.php
					// is_array -> //array -> http://php.net/manual/en/ref.array.php
					if (is_array($result->GETTABLERESULT->TABLESTRUCT->UFIELDSTRUCT)){
						//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
						foreach ($result->GETTABLERESULT->TABLESTRUCT->UFIELDSTRUCT as $item) {
								echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
						}
					} else {
						//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
						foreach ($result->GETTABLERESULT->TABLESTRUCT as $item) {
								echo "<th><pre>".print_r($item->FLDNAME,true)."</pre></th>";
						}
					}                    
					echo         "</tr>";
					echo     "</thead>";      
					echo "<tbody>";
					//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
					foreach ($results as $result){
						// is_array -> //array -> http://php.net/manual/en/ref.array.php
						if (is_array($result->GETTABLERESULT->TABLEDATA->FIELDVIEW)){
							//Control Structures (foreach) -> http://www.php.net/manual/en/control-structures.foreach.php
							foreach ($result->GETTABLERESULT->TABLEDATA->FIELDVIEW as $itens) {
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
								if (is_array($result->GETTABLERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING)){
									foreach ($result->GETTABLERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING as $item) {
										echo "<td><pre>".print_r($item,true)."</pre></td>";
									}
								} else {
									$item = $result->GETTABLERESULT->TABLEDATA->FIELDVIEW->FLDTAG->STRING;
									echo "<td><pre>".print_r($item,true)."</pre></td>";
								}
							echo "<tr>";
						}
					}    
					echo "</tbody>";            
					echo "</table>";
				}
			} catch (SoapFault $fault) { //SoapFault -> http://php.net/manual/en/function.is-soap-fault.php
				trigger_error("SOAP Fault: (faultcode: {$fault->faultcode}, faultstring: {$fault->faultstring})", E_USER_ERROR);
			} catch (Exception $e) { //Exception -> http://php.net/manual/en/language.exceptions.php
				echo "Caught Exception ('{$e->getMessage()}')\n{$e}\n";
			}	
            die();
        ?>
    </body>
</html>