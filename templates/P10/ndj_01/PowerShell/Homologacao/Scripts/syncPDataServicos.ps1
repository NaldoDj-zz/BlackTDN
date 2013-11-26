function syncPDataServices
{
	param(
			[string]$totvsTarget	= "C:\Protheus10_TST\Protheus_Data\system_services\",
			[string]$totvsSource	= "C:\Protheus10_TST\Protheus_Data\system\",
			[string]$DisplayName 	= "PROTHEUS 10 TESTE SERVICOS"
		)	
   
	if( !$totvsTarget.endsWith("\")) { $totvsTarget+="\" }
	if( !$totvsSource.endsWith("\")) { $totvsSource+="\" }

	$log		= join-path $totvsTarget "TotvsChanges.log"

	if ( Test-Path $log )
	{
		$TotvsChangesLog = get-item $log
		if ( $TotvsChangesLog.Length -ge 61440 )
		{
			$TotvsChangesLog.Delete()
		}
	}

	add-content -force $log -value "`n`n[$(get-date)]Totvs sync path has started"

	$Name =  ( get-service -name $DisplayName | % { $_.Name } )
	while ( -not ( (((Get-Service -Name $DisplayName ).Status).tostring()).contains("Stopped") ) )
	{
		invoke-expression -command 'taskkill -f -fi "SERVICES eq $Name" /t'		
		start-sleep -seconds 1
	}

	$files = Get-ChildItem $totvsTarget -recurse
	foreach ( $file in $files )
	{
		$bExtension = $file.Extension.Contains('ind')
		$bExtension = ( $bExtension -or $file.Extension.Contains('cdx') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('lck') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('idx') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('bmi') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('log') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('tmp') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('itmp') )
		$bExtension = ( $bExtension -or $file.Extension.Contains('#') )
		if ( $bExtension ){ remove-item -recurse -force $file.fullName }
	}	
  
	$TotvsGet = Get-ChildItem -path $totvsSource -recurse -exclude *.bmi,*.cdx,*idx,*.ind,*.int,*.##r,*.#db,*.#nu,*.#lp,*.#ls,*.#le,*.log,*lck,*.tmp,*.itmp,*.zip,c0*.*,c1*.*,c2*.*,c3*.*,c4*.*,c5*.*,c6*.*,c7*.*,c8*.*,c9*.*,sc0*.*,sc1*.*,sc2*.*,sc3*.*,sc4*.*,sc5*.*,sc6*.*,sc7*.*,sc8*.*,sc9*.*,*.htm*,*.xml*,*.js*,*.jpg,*.jpeg,*.bmp,*.bitmap,*.gif | Where { -not $_.FullName.Contains( "bkp" ) -and -not $_.FullName.Contains( "export" ) -and -not $_.FullName.Contains( "pswbackup" ) -and -not $_.FullName.Contains( "update" ) -and -not $_.FullName.Contains( "workflow" ) }
   
	foreach( $file in $TotvsGet )
	{ 
		$fileName		= $file.FullName.ToLower()
		$localFile		= $fileName.Replace($totvsSource.ToLower(),$totvsTarget.ToLower())
		$msgNew			= "new file found: $fileName , downloading..."
		$msgUpdate		= "file : $fileName  is changed, updating..."
		$msgNoChange	= "nothing changed for: $fileName"
         	
		if( Test-Path $localFile )
		{
			if($file.lastWriteTime -gt (get-item $localFile).lastWriteTime)
			{
				copy-item $file.FullName $localFile -force
				write-host $msgUpdate -fore yellow
				add-content -force $log -value $msgUpdate
			}
			else
			{
				add-content $log -force -value $msgNoChange
				write-host $msgNoChange
			}
		}
		else
		{
			write-host $msgNew -fore green
			add-content -force $log -value $msgNew
			copy-item $file.FullName $localFile -force
		}
	}
	
	Start-Service -Name $DisplayName
	
	Start-Sleep -Seconds 120
	
	while ( -not ( (((Get-Service -Name $DisplayName ).Status).tostring()).contains("Stopped") ) )
	{
		invoke-expression -command 'taskkill -f -fi "SERVICES eq $Name" /t'		
		start-sleep -seconds 1
	}
	
	Start-Service -Name $DisplayName
	
}
syncPDataServices