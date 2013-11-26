#OBS: É muito importante que a entrada SourcePath dos arquivos de configuração do protheus 10 tenham o último caracter como sendo "\", indicando que é um diretório. Pois se não estiver dessa forma podem ser apresentadas mensagens de erro na execução do Script.

#Diretório de origem do RPO compilado para Homologação
$comphlg = "C:\Protheus10_TST\apo\CompHLG"

#Declara variáveis a utilizar no tratamento do totvsappserver.copyini
$find       	= ""
#Diretório de binários do Protheus 10
$pathbin    	= "C:\Protheus10_TST\bin"
#Arquivo INI que será trabalhado para alteração do RPO
$copyIniFile	= "totvsappserver.copyini"
#Diretorio dos RPOs de destino, ou seja, o que se quer atualizar. Destino.
$rpospath		= "C:\Protheus10_TST\apo\RPOsHomolog\"
#String de busca do sourcepath do arquivo INI
$rposmatch  	= get-childitem -path $rposPath
#Arquivo RPO que será copiado
$rpoName		= "tttp101.rpo"
	 
#Chama o script que copia o totvsappserver.ini para totvsappserver.copyini
Invoke-Expression -Command "$pathbin\Scripts\SaveCopyIni.ps1"
	 
#strings que vão ser utilizadas para verificar qual RPO o INI está apontando
$find00      = "sourcepath=C:\\Protheus10_TST\\apo\\RPOsHomolog\\rpo00\\"
$find01      = "sourcepath=C:\\Protheus10_TST\\apo\\RPOsHomolog\\rpo01\\"
$find02      = "sourcepath=C:\\Protheus10_TST\\apo\\RPOsHomolog\\rpo02\\"
$find03      = "sourcepath=C:\\Protheus10_TST\\apo\\RPOsHomolog\\rpo03\\"
$find04      = "sourcepath=C:\\Protheus10_TST\\apo\\RPOsHomolog\\rpo04\\"
$match	     = get-childitem -path $pathbin -include $copyIniFile -recurse | select-string $find00 -list

#Cadeia de SE que checa se a string procurada está contida no INI e armazena na variável $find que será utilizada para alterar o sourcepath do arquivo totvsappserver.copyini
if ( $match -match $find00 )
{
	$find		= $find00
	$TargetFilePathRpoSync = "C:\Protheus10_TST\apo\RPOsHomolog\rpo01\"
}
else
{
	$match	     = get-childitem -path $pathbin -include $copyIniFile -recurse | select-string $find01 -list
	if ( $match -match $find01 )
	{
		$find		= $find01
		$TargetFilePathRpoSync = "C:\Protheus10_TST\apo\RPOsHomolog\rpo02\"
	}
	else
	{	
		$match	    = get-childitem -path $pathbin -include $copyIniFile -recurse | select-string $find02 -list
		if ( $match -match $find02 )
		{
			$find		= $find02
			$TargetFilePathRpoSync = "C:\Protheus10_TST\apo\RPOsHomolog\rpo03\"
		}
		else
		{
			$match	    = get-childitem -path $pathbin -include $copyIniFile -recurse | select-string $find03 -list
			if ( $match -match $find03 )
			{
				$find		= $find03
				$TargetFilePathRpoSync = "C:\Protheus10_TST\apo\RPOsHomolog\rpo04\"
			}
			else
			{
				$find       = $find04
				$TargetFilePathRpoSync = "C:\Protheus10_TST\apo\RPOsHomolog\rpo00\"
			}
		}	
	}	
}
#Uma que não exista o caracter "\" no final do caminho de destino do RPO, inclui esse caracter
if( !$TargetFilePathRpoSync.endsWith("\")) 
{
	$TargetFilePathRpoSync+="\" 
}
#Adiciona a string SourcePath no início do caminho de destino do RPO
$replace = "SourcePath="
$replace += $TargetFilePathRpoSync
$TargetFilePathRpoSync += $rpoName
#Compõe o caminho do RPO source, que será utilizado para atualizar o diretório destino 
$SourceFilePathRpoSync = $comphlg
if( !$SourceFilePathRpoSync.endsWith("\")) 
{ 
	$SourceFilePathRpoSync+="\" 
}
$SourceFilePathRpoSync += $rpoName

#Testa se o RPO de destino não existe ou tem data de modificação inferior ao de origem. Nesse caso então remove o RPO de destino, copia o RPO de origem no destino e altera o caminho no totvsappserver.copyini
if(!(Test-Path $TargetFilePathRpoSync) -or ((get-item $SourceFilePathRpoSync).lastWriteTime -gt (get-item $TargetFilePathRpoSync).lastWriteTime))
{
	if(Test-Path $TargetFilePathRpoSync)
	{
		Remove-Item -Force $TargetFilePathRpoSync
	}
	#Esse é o comando que copia efetivamente o RPO de origem para o caminho de destino
	copy-item $SourceFilePathRpoSync $TargetFilePathRpoSync -force
	#Essa é a linha de comando que, utilizando as variáveis trabalhadas anteriormente, substitui efetivamente o sourcepath nos arquivos totvsappserver.copyini
	get-childitem -path $pathbin -include $copyIniFile -recurse | % { (get-content $_) |% { $_ -replace $find,$replace } | set-content $_ -force }
}

#Chama o script que copia o totvsappserver.copyini para totvsappserver.ini
Invoke-Expression -Command "$pathbin\Scripts\RestoreCopyIni.ps1"
