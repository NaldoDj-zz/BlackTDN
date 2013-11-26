write-host "Início do script." 
[array]$asFind =	"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo00\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo01\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo02\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo03\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo04\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo05\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo06\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo07\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo08\\",
					"Sourcepath=C:\\Protheus10_PROD\\apo\\RPOsProd\\rpo09\\"

[array]$aReplace =	"C:\Protheus10_PROD\apo\RPOsProd\rpo01\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo02\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo03\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo04\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo05\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo06\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo07\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo08\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo09\",
					"C:\Protheus10_PROD\apo\RPOsProd\rpo00\"

[int]$nIndex			= -1
[string]$find			= ""
[string]$pathbin		= "C:\Protheus10_PROD\bin"
[string]$copyIniFile	= "totvsappserver.copyini"
[boolean]$bFound		= $false

foreach ( $sFind in $asFind )
{
	$nIndex++
	$match = get-childitem -path $pathbin -include $copyIniFile -recurse | select-string $sFind -list
	if ( $match -match $sFind )
	{
		$find	= $sFind
		$bFound = $true
		$TargetFilePathRpoSync = $aReplace[$nIndex]
		break
	}	
}

IF ( $bFound )
{
	[string]$unidade	= "x:"
	[string]$compprod	= "\\200.143.193.75\compprod"
	[string]$netuser	= "administrador"
	[string]$netpass	= "7s@kbHcJ"
	$net				= new-object -ComObject WScript.Network

	if ( Get-PSDrive -PSProvider filesystem| Select-String -SimpleMatch $unidade.Replace(":","") )
	{
		write-host "Removendo unidade mapaeada $unidade" 
		$net.removenetworkdrive($unidade)
	}

	$net.MapNetworkDrive($unidade, $compprod, $false, $netuser, $netpass)

	Invoke-Expression -Command "$pathbin\Scripts\SaveCopyIni.ps1"
	
	if( !$TargetFilePathRpoSync.endsWith("\")) 
	{ 
		$TargetFilePathRpoSync+="\" 
	}

	[string]$rpoName	= "tttp101.rpo"
	
	$replace = "SourcePath="
	$replace += $TargetFilePathRpoSync
	
	$TargetFilePathRpoSync += $rpoName
	$SourceFilePathRpoSync = $compprod
	
	if( !$SourceFilePathRpoSync.endsWith("\")) 
	{ 
		$SourceFilePathRpoSync+="\" 
	}
	
	$SourceFilePathRpoSync += $rpoName

	if(!(Test-Path $TargetFilePathRpoSync) -or ((get-item $SourceFilePathRpoSync).lastWriteTime -gt (get-item $TargetFilePathRpoSync).lastWriteTime))
	{
		
		if(Test-Path $TargetFilePathRpoSync)
		{
			Remove-Item -Force $TargetFilePathRpoSync
		}
		
		copy-item $SourceFilePathRpoSync $TargetFilePathRpoSync -force
		get-childitem -path $pathbin -include $copyIniFile -recurse | % { (get-content $_) |% { $_ -replace $find,$replace } | set-content $_ -force }
	
	}

	Invoke-Expression -Command "$pathbin\Scripts\RestoreCopyIni.ps1"

	if ( Get-PSDrive -PSProvider filesystem| Select-String -SimpleMatch $unidade.Replace(":","") )
	{
		write-host "Removendo unidade mapaeada" 
		$net.removenetworkdrive($unidade)
	}
	
}
write-host "Fim do Script."