#Declara o diretório de binários do protheus 10
$PathBin    	= "C:\Protheus10_PROD\bin\"
#Nome do arquivo de configuração do protheus 10 original
$NameIniFile	= "totvsappserver.ini"
#Nome do arquivo de configuração do protheus 10 que manipulamos 
$CopyIniFile    = "totvsappserver.copyini"
#Comando para listar todos os arquivos totvsappserver.copyini
$CopyIniFiles  	= get-childitem -path $PathBin -include $CopyIniFile -recurse
#A cada totvsappserver.copyini encontrado, copia seu conteúdo para o totvsappserver.ini original o sobrescrevendo
foreach( $iniFile in $CopyIniFiles )
{
	$NewName = $iniFile.Name
	$NewName = $NewName.Replace($CopyIniFile,$NameIniFile)
	$IniDirectory = $iniFile.DirectoryName
	if ( !$IniDirectory.endsWith("\") )
		{
			$IniDirectory+="\"
		}
	$NewPathFileIni = ( $IniDirectory + $NewName )
	copy-item $iniFile.FullName $NewPathFileIni -force
}