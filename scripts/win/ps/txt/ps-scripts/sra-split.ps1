#file:sra-split.ps1
#Author:Marinaldo de Jesus
#date:2016-01-06
#Use:1) Ordenar o arquivo de saída do sistema Senior
#    2) Dividir o arquivo gerando os dados por Filial
#    3) Separar em Canais Válidos
Function sra-split {
    [CmdletBinding(
                    SupportsShouldProcess=$True,
                    ConfirmImpact="Low"
                  )
    ]
    Param(
            [Parameter(Mandatory=$True,Position=1)]
            [string]$filePath="sra.txt"
    )

    Clear-Host

    $txtFile=$filePath
    $fName=[System.IO.Path]::GetFileNameWithoutExtension($txtFile)
    $txtSort=$txtFile.Replace($fName,"$($fName)-sort")

    #Obtém o Conteúdo do Arquivo
    #Ordena as Informações
    #Salva o Novo Arquivo
    $MC=Measure-Command {
        $sortFile=Get-Content $txtFile `
            | Show-Progress -Activity "Sorting..."`
            | Sort-Object -property @{Expression={$_.SubString(0,17)};Ascending=$true}`
            | Show-Progress -Activity "Saving..."`
            | Out-File -FilePath $txtSort -Encoding ascii -Force
    }

    for($i=1
        $i -le 20
        $i++){
       Write-Host ""
    }

    $MC

    $MC=Measure-Command {

        #Define o Path para a Gravação dos Arquivos
        $pathOutFile=".\split\sra\"

        #Obtém o Conteúdo do Arquivo Ordenado
        $sortFile=Get-Content $txtSort

        #Força a Criação do Diretório Split a partir de .\
        New-Item -path $pathOutFile -type directory -Force

        #Remove qualquer item existente em .\split
        Remove-Item -Path "$pathOutFile\*" -Force -Recurse

        #Define a HashTable com os Canais
        $Canais=@{
                    SRA_0="SRA_0";
                    SRA_1="SRA_1";
                    SRA_2="SRA_2";
                    SRA_3="SRA_3";
                    SRA_4="SRA_4";
                    SRA_5="SRA_5"
        }

        #Define o Array com as Filiais
        $Filiais=@("0101","0102","0103","0104","0105","9801")

        #Define bgColor
        $bgColor="Black"

        #Define fgColor
        $fgColor="DarkRed"

        #Define variável para controle de alteração da cor
        $bChgColor=$True

        #Define separador
        $cSep="--------------------------------------------------------------------------"

        $FilePath=""

        Write-Host $cSep -foregroundcolor Cyan -backgroundcolor $bgColor

        [int]$nPercentF=0
        [int]$nProgressF=0

        #Lê o conteúdo do arquivo e gera um novo arquivo por Filial
        foreach ($Filial in $Filiais) {

            $key=""
            $lKey=""

            $nProgressF++
            $nPercentF=[int](($nProgressF/$Filiais.Count)*100)

            Write-Progress -id 0 `
                           -Activity "Processando Filial[$Filial]/[$($Filiais)]" `
                           -PercentComplete "$nPercentF" `
                           -Status ("Working["+($nPercentF)+"]%")

            [int]$nPercentC=0
            [int]$nProgressC=0

            #Processa para cada CANAL
            foreach ($Canal in $Canais.Values | Sort-Object )
            {
                Write-Host $Filial,$Canal
                Write-Host $cSep -foregroundcolor Cyan -backgroundcolor $bgColor

                #Incrementa o Progresso
                $nProgressC++
                $nPercentC=[int](($nProgressC/$Canais.Count)*100)
                Write-Progress -id 1 `
                               -Activity "Processando Canal[$Canal]" `
                               -PercentComplete "$nPercentC" `
                               -Status ("Working["+($nPercentC)+"]%")

                #Gera o arquivo por Filial e Canal
                $sortFile | ? {$_.Substring(0,4).Contains($Filial) -and $_.Substring(12,5).Contains($Canal) } | ? {
                        #Obtém a chave para pesquisa
                        $key=$_.Substring(0,17)
                        #Verifica se é igual a última chave utilizada
                        if ($key -eq $lKey){
                            #Define o arquivo para dados duplicados
                            $FilePath="$($pathOutFile)dupl-sra-$($Filial)-$($Canal).txt"
                        } else {
                            #Define o arquivo para dados OK
                            $FilePath="$($pathOutFile)sra-$($Filial)-$($Canal).txt"
                        }
                        #Grava os Dados no novo arquivo
                        Out-File -inputobject $_ -FilePath $FilePath -Encoding ascii -Append
                        #Salva a última chave utilizada
                        $lKey=$key
                }

                #Obtem o conteúdo para o CANAL
                $FilePath="$($pathOutFile)sra-$($Filial)-$($Canais[$Canal]).txt"
                if (Test-Path $FilePath ){
                    $Content=(Get-Content $FilePath | Where-Object {$_.Substring(12,5).Contains($Canais[$Canal])})
                    if ($Content){
                        [System.Collections.ArrayList]$tmp=@($Content)
                        Set-Variable -Name "t_$Canal" -Value $tmp
                        #Remove o Arquivo de Trabalho
                        Remove-Item $FilePath -Force
                    }    
                }    

            }

            [int]$nPercentD=0
            [int]$nProgressD=0

            $bWriteHost=$False

            #Processa a partir do CANAL SRA_0
            ($t_sra_0) | Foreach-Object {$index=0 }{
                Try
                {

                    $nProgressD++
                    $nPercentD=[int](($nProgressD/($t_sra_0).Count)*100)
                    Write-Progress -id 2 `
                                   -Activity "Processando Filial[$Filial]" `
                                   -PercentComplete "$nPercentD" `
                                   -Status ("Working["+($nPercentD)+"]%")

                    $key=$t_sra_0.Item($index).Substring(4,8)

                    if ($sra_1=$t_sra_1 | Where-Object {$_.Substring(4,8).Contains($key)})
                    {
                        if ($sra_2=$t_sra_2 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {
                            if ($sra_3=$t_sra_3 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {
                                if ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                                {
                                    if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                                    {

                                        if ($bWriteHost){
                                            Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        }

                                        $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-3-4-5.txt"

                                        Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                        $t_sra_1.Remove($sra_1)
                                        $t_sra_2.Remove($sra_2)
                                        $t_sra_3.Remove($sra_3)
                                        $t_sra_4.Remove($sra_4)
                                        $t_sra_5.Remove($sra_5)

                                    }
                                    else {

                                        if ($bWriteHost){
                                            Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                            Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        }
                                        
                                        $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-3-4.txt"

                                        Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                        Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append

                                        $t_sra_1.Remove($sra_1)
                                        $t_sra_2.Remove($sra_2)
                                        $t_sra_3.Remove($sra_3)
                                        $t_sra_4.Remove($sra_4)

                                    }
                                }
                                elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                                {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }
                                        
                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-3-5.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_1.Remove($sra_1)
                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_3.Remove($sra_3)
                                    $t_sra_5.Remove($sra_5)

                                }
                                else {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }
                                    
                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-3.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_1.Remove($sra_1)
                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_3.Remove($sra_3)

                                }
                            }
                            elseif ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {
                                if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                                {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }
                                    
                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-4-5.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_1.Remove($sra_1)
                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_4.Remove($sra_4)
                                    $t_sra_5.Remove($sra_5)

                                }
                            }
                            elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                    
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2-5.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_1.Remove($sra_1)
                                $t_sra_2.Remove($sra_2)
                                $t_sra_5.Remove($sra_5)

                            }
                            else {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                                                    
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1-2.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_1.Remove($sra_1)
                                $t_sra_2.Remove($sra_2)

                            }
                        }
                        else {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_1 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }
                                
                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-1.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_1 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_1.Remove($sra_1)

                        }
                    }
                    elseif ($sra_2=$t_sra_2 | Where-Object {$_.Substring(4,8).Contains($key)})
                    {
                        if ($sra_3=$t_sra_3 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {
                            if ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {
                                if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                                {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }
                                    
                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-3-4-5.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_3.Remove($sra_3)
                                    $t_sra_4.Remove($sra_4)
                                    $t_sra_5.Remove($sra_5)

                                }
                                else {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }

                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-3-4.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_3.Remove($sra_3)
                                    $t_sra_4.Remove($sra_4)

                                }
                            }
                            elseif ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {
                                if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                                {

                                    if ($bWriteHost){
                                        Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                        Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    }
                                    
                                    $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-4-5.txt"

                                    Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                    Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                    $t_sra_2.Remove($sra_2)
                                    $t_sra_4.Remove($sra_4)
                                    $t_sra_5.Remove($sra_5)

                                }
                            }
                            elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-5.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_2.Remove($sra_2)
                                $t_sra_5.Remove($sra_5)

                            }
                            else {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-3.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_2.Remove($sra_2)
                                $t_sra_3.Remove($sra_3)

                            }
                        }
                        elseif ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {
                            if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                    
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-4-5.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_2.Remove($sra_2)
                                $t_sra_4.Remove($sra_4)
                                $t_sra_5.Remove($sra_5)

                            }
                        }
                        elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }
                                
                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2-5.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_2.Remove($sra_2)
                            $t_sra_5.Remove($sra_5)

                        }
                        else {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_2 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }
                            
                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-2.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_2 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_2.Remove($sra_2)

                       }
                    }
                    elseif ($sra_3=$t_sra_3 | Where-Object {$_.Substring(4,8).Contains($key)})
                    {
                        if ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {
                            if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                            {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                    
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-3-4-5.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_3.Remove($sra_3)
                                $t_sra_4.Remove($sra_4)
                                $t_sra_5.Remove($sra_5)

                            }
                            else {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-3-4.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_3.Remove($sra_3)
                                $t_sra_4.Remove($sra_4)

                            }
                        }
                        elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {

                                if ($bWriteHost){
                                    Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                    Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                }
                                    
                                $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-3-5.txt"

                                Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append
                                Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                                $t_sra_3.Remove($sra_3)
                                $t_sra_5.Remove($sra_5)

                        }
                        else {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_3 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }
                            
                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-3.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_3 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_3.Remove($sra_3)

                        }
                    }
                    elseif ($sra_4=$t_sra_4 | Where-Object {$_.Substring(4,8).Contains($key)})
                    {
                        if ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                        {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }
                            
                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-4-5.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_4.Remove($sra_4)
                            $t_sra_5.Remove($sra_5)

                        }
                        else {

                            if ($bWriteHost){
                                Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                                Write-Host $sra_4 -foregroundcolor $fgColor -backgroundcolor $bgColor
                            }

                            $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-4.txt"

                            Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                            Out-File -inputobject $sra_4 -FilePath $FilePath -Encoding ascii -Append

                            $t_sra_4.Remove($sra_4)

                        }
                    }
                    elseif ($sra_5=$t_sra_5 | Where-Object {$_.Substring(4,8).Contains($key)})
                    {

                        if ($bWriteHost){
                            Write-Host $_     -foregroundcolor $fgColor -backgroundcolor $bgColor
                            Write-Host $sra_5 -foregroundcolor $fgColor -backgroundcolor $bgColor
                        }
                        
                        $FilePath="$($pathOutFile)sra-$($Filial)-Channels-0-5.txt"

                        Out-File -inputobject $_     -FilePath $FilePath -Encoding ascii -Append
                        Out-File -inputobject $sra_5 -FilePath $FilePath -Encoding ascii -Append

                        $t_sra_5.Remove($sra_5)

                    }

                }
                Catch
                {
                    Write-Host $_.Exception.Message -foregroundcolor red -backgroundcolor Cyan
                }
                Finally
                {
                    #...
                }

                $index++

                if ($bChgColor) {
                    $fgColor="White"
                }
                else {
                    $fgColor="DarkRed"
                }

                $bChgColor= -not($bChgColor)

                if ($bWriteHost){
                    Write-Host $cSep -foregroundcolor Cyan -backgroundcolor $bgColor
                }    

            }

        }
    }

    Clear-Host

    for($i=1
        $i -le 20
        $i++){
       Write-Host ""
    }

    $MC
}
Function Show-Progress{
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [PSObject[]]$InputObject,
        [string]$Activity = "Processing items"
    )

    Begin {$PipeArray = @()}

    Process {$PipeArray+=$InputObject}

    End {
        [int]$TotItems = ($PipeArray).Count
        [int]$Count = 0

        $PipeArray|foreach {
            $_
            $Count++
            [int]$percentComplete = [int](($Count/$TotItems* 100))
            Write-Progress -Activity "$Activity" -PercentComplete "$percentComplete" -Status ("Working - " + $percentComplete + "%")
            }
        }
}    
sra-split "sra.txt"
