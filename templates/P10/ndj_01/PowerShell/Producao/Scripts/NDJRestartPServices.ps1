param( [string]$sOperation = "restart" )

[Boolean]$bRestart = $sOperation.ToLower().Contains("restart")

[array]$aServices = "ctreeServer",
					"PROTHEUS 10 PRODUCAO MASTER",
					"PROTHEUS 10 PRODUCAO SLAVE01",
					"PROTHEUS 10 PRODUCAO SLAVE02",
					"PROTHEUS 10 PRODUCAO SLAVE03",
					"PROTHEUS 10 PRODUCAO SLAVE04",
					"PROTHEUS 10 PRODUCAO SLAVE05",
					"PROTHEUS 10 PRODUCAO SLAVE06",
					"PROTHEUS 10 PRODUCAO SLAVE07",
					"PROTHEUS 10 PRODUCAO SLAVE08",
					"PROTHEUS 10 PRODUCAO SLAVE09",
					"PROTHEUS 10 PRODUCAO SLAVE10",
					"PROTHEUS 10 PRODUCAO SLAVE11",
					"PROTHEUS 10 PRODUCAO SLAVE12",
					"PROTHEUS 10 PRODUCAO SLAVE13",
					"PROTHEUS 10 PRODUCAO SLAVE14",
					"PROTHEUS 10 PRODUCAO SLAVE15",
					"PROTHEUS 10 PRODUCAO SLAVE16",
					"PROTHEUS 10 PRODUCAO SLAVE17",
					"PROTHEUS 10 PRODUCAO SLAVE18",
					"PROTHEUS 10 PRODUCAO SLAVE19",
					"PROTHEUS 10 PRODUCAO SLAVE20",
					"PROTHEUS 10 SERVICOS"

foreach ( $DisplayName in $aServices )
{
	$Name =  ( get-service -name $DisplayName | % { $_.Name } )
	while ( -not ( (((Get-Service -Name $DisplayName).Status).tostring()).contains("Stopped") ) )
	{
		invoke-expression -command 'taskkill -f -fi "SERVICES eq $Name" /t'		
		start-sleep -seconds 1
	}
	if ( $bRestart )
	{
		while ( -not ( (((Get-Service -Name $DisplayName).Status).tostring()).contains("Running") ) )
		{
			Start-Service -Name $DisplayName
			start-sleep -seconds 1	
		}
	}	
}