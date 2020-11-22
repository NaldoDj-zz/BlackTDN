function toSQL {
    
    param(
            [Parameter(Mandatory=$true)]$RowData,
            [Parameter(Mandatory=$true)][ref]$RowCount,
            [Parameter(Mandatory=$true)][ref]$SRDItems,
            [Parameter(Mandatory=$true)][String]$SRDTable
    )

    #store RD_FIELDS
    [String]$RD_FIELDS="RD_FILIAL,RD_MAT,RD_PD,RD_TIPO1,RD_VALOR,RD_DATARQ,RD_TIPO2,RD_STATUS,RD_INSS,RD_IR,RD_FGTS,RD_PROCES,RD_PERIODO,RD_SEMANA,RD_ROTEIR,RD_CONVOC,RD_QTDSEM,RD_HORINFO,RD_HORAS,RD_VALINFO,RD_VNAOAPL,RD_DATPGT,RD_CC,RD_SEQ,RD_EMPRESA,RD_MES,RD_DTREF,RD_POSTO,RD_NUMID,RD_DEPTO,RD_NODIA,RD_DIACTB,RD_PLNUCO,RD_CODB1T,RD_ITEM,RD_CLVL,RD_EMPCONS,RD_IDCMPL,RD_CRITER,RD_SEQUE,RD_LOTPLS,RD_CODRDA,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,RD_VALORBA"

    #store Fields
    [String]$RD_FILIAL="'"+$RowData.Filial+"'"
    [String]$RD_MAT="'"+$RowData.Matricula+"'"
    [String]$RD_TIPO1="'V'"
    [String]$tmp=$RowData.Competencia
    [String]$RD_DATARQ=$tmp.SubString(3,4)
    [String]$RD_DATARQ+=$tmp.SubString(0,2)
    [String]$RD_DATARQ="'"+$RD_DATARQ+"'"
    [String]$RD_TIPO2="'I'"
    [String]$RD_STATUS="'A'"
    [String]$RD_PROCES="'00001'"
    [String]$RD_PERIODO=$RD_DATARQ
    [String]$RD_SEMANA="'02'"
    [String]$RD_ROTEIR="'FOL'"
    [String]$RD_CONVOC="''"
    [float]$RD_QTDSEM=0
    [float]$RD_HORINFO=0
    [float]$RD_HORAS=0
    [float]$RD_VALINFO=0
    [float]$RD_VNAOAPL=0
    [String]$RD_DATPGT="' '"
    [String]$RD_CC="' '"
    [String]$RD_SEQ="' '"
    [String]$RD_EMPRESA="' '"
    [String]$RD_MES="' '"
    [String]$RD_DTREF="' '"
    [String]$RD_POSTO="' '"
    [String]$RD_NUMID="' '"
    [String]$RD_DEPTO="' '"
    [String]$RD_NODIA="' '"
    [String]$RD_DIACTB="' '"
    [String]$RD_PLNUCO="' '"
    [String]$RD_CODB1T="' '"
    [String]$RD_ITEM="' '"
    [String]$RD_CLVL="' '"
    [String]$RD_EMPCONS="' '"
    [String]$RD_IDCMPL="' '"
    [String]$RD_CRITER="' '"
    [String]$RD_SEQUE="' '"
    [String]$RD_LOTPLS="' '"
    [String]$RD_CODRDA="' '"
    [String]$D_E_L_E_T_="' '"
    [String]$R_E_C_N_O_="(SELECT (isNull(MAX(R_E_C_N_O_),0)+1) R_E_C_N_O_ FROM $($SRDTable))"
    [float]$R_E_C_D_E_L_=0
    [float]$RD_VALORBA=0

    #Diferenca Salarial.................................................................................................
    [String]$RD_PD="'116'"
    [float]$RD_VALOR=$RowData.PD_116
    [String]$RD_INSS="'S'"
    [String]$RD_IR="'S'"
    [String]$RD_FGTS="'S'"
    
    #store RD_VALUES
    [String]$RD_VALUES=$RD_FILIAL
    $RD_VALUES+=","
    $RD_VALUES+=$RD_MAT
    $RD_VALUES+=","
    $RD_VALUES+="`$RD_PD"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_TIPO1
    $RD_VALUES+=","
    $RD_VALUES+="`$RD_VALOR"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_DATARQ
    $RD_VALUES+=","
    $RD_VALUES+=$RD_TIPO2
    $RD_VALUES+=","
    $RD_VALUES+=$RD_STATUS
    $RD_VALUES+=","
    $RD_VALUES+="`$RD_INSS"
    $RD_VALUES+=","
    $RD_VALUES+="`$RD_IR"
    $RD_VALUES+=","
    $RD_VALUES+="`$RD_FGTS"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_PROCES
    $RD_VALUES+=","
    $RD_VALUES+=$RD_PERIODO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_SEMANA
    $RD_VALUES+=","
    $RD_VALUES+=$RD_ROTEIR
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CONVOC
    $RD_VALUES+=","
    $RD_VALUES+=$RD_QTDSEM
    $RD_VALUES+=","
    $RD_VALUES+=$RD_HORINFO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_HORAS
    $RD_VALUES+=","
    $RD_VALUES+=$RD_VALINFO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_VNAOAPL
    $RD_VALUES+=","
    $RD_VALUES+=$RD_DATPGT
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CC
    $RD_VALUES+=","
    $RD_VALUES+=$RD_SEQ
    $RD_VALUES+=","
    $RD_VALUES+=$RD_EMPRESA
    $RD_VALUES+=","
    $RD_VALUES+=$RD_MES
    $RD_VALUES+=","
    $RD_VALUES+=$RD_DTREF
    $RD_VALUES+=","
    $RD_VALUES+=$RD_POSTO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_NUMID
    $RD_VALUES+=","
    $RD_VALUES+=$RD_DEPTO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_NODIA
    $RD_VALUES+=","
    $RD_VALUES+=$RD_DIACTB
    $RD_VALUES+=","
    $RD_VALUES+=$RD_PLNUCO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CODB1T
    $RD_VALUES+=","
    $RD_VALUES+=$RD_ITEM
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CLVL
    $RD_VALUES+=","
    $RD_VALUES+=$RD_EMPCONS
    $RD_VALUES+=","
    $RD_VALUES+=$RD_IDCMPL
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CRITER
    $RD_VALUES+=","
    $RD_VALUES+=$RD_SEQUE
    $RD_VALUES+=","
    $RD_VALUES+=$RD_LOTPLS
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CODRDA
    $RD_VALUES+=","
    $RD_VALUES+=$D_E_L_E_T_
    $RD_VALUES+=","
    $RD_VALUES+=$R_E_C_N_O_
    $RD_VALUES+=","
    $RD_VALUES+=$R_E_C_D_E_L_
    $RD_VALUES+=","
    $RD_VALUES+=$RD_VALORBA

    [String]$Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    $RD_INSS="'N'"
    $RD_FGTS="'N'"

    #INSS...............................................................................................................
    $RD_PD="'410'"
    $RD_VALOR=$RowData.INSSDiff

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    $RD_IR="'N'"

    #Base INSS..........................................................................................................
    $RD_PD="'701'"
    $RD_VALOR=$RowData.PD_116

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    #Base FGTS..........................................................................................................
    $RD_PD="'706'"
    $RD_VALOR=$RowData.PD_116

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $SRDItems.Value+=$Line
    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    #FGTS..............................................................................................................
    $RD_PD="'710'"
    $RD_VALOR=$RowData.FGTS

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    #Salario Educacao...................................................................................................
    $RD_PD="'794'"
    $RD_VALOR=$RowData.SalarioEducacao

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

    #Salario Liquido....................................................................................................
    $RD_PD="'799'"
    $RD_VALOR=$RowData.Liquido

    $Line="IF NOT EXISTS (SELECT 1 FROM $($SRDTable) SRD WHERE SRD.RD_FILIAL=$($RD_FILIAL) AND SRD.RD_MAT=$($RD_MAT) AND SRD.RD_PD=$($RD_PD) AND SRD.RD_SEMANA=$($RD_SEMANA) AND SRD.RD_PROCES=$($RD_PROCES) AND SRD.RD_PERIODO=$($RD_PERIODO) AND SRD.RD_SEQ=$($RD_SEQ) AND SRD.RD_ROTEIR=$($RD_ROTEIR))"
    $Line+="BEGIN INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES))) END" 
    $SRDItems.Value+=$Line

    $RowCount.Value++
    #Write-Host $RowCount.Value"::"$Line
    Write-Output $Line

}

function DiffMegaInsertInToSQL {

    cls

    if ([System.IO.File]::Exists(".\DiffMegaInsertInToSQL.sql")){
        Remove-Item ".\DiffMegaInsertInToSQL.sql" -Force -ErrorAction SilentlyContinue
    }    

    if (Get-Module -ListAvailable -Name ImportExcel) {
      Write-Host "Module ImportExcel exists"
    } else {
      Write-Host "Module ImportExcel does not exist. Installing..."
      Install-Module -Name ImportExcel -Force -Confirm:$False
    }

    #https://virtuallysober.com/2017/07/10/working-with-sql-databases-using-powershell/
    if (Get-Module -ListAvailable -Name SqlServer) {
      Write-Host "Module SqlServer exists"
    } else {
      Write-Host "Module SqlServer does not exist. Installing..."
      Install-Module -Name SqlServer -Force -Confirm:$False -AllowClobber
    }

    cls

    #https://devblogs.microsoft.com/scripting/how-to-reuse-windows-powershell-functions-in-scripts/
    #include ".\ini.ps1"
    .".\ini.ps1"
    [System.Object]$ini=Get-IniFile ".\DiffMegaInsertInToSQL.ini"
    Remove-Item function:\Get-IniFile*

    [String]$SQLInstance=$ini.CONNECTION.SQLInstance
    [String]$SQLDatabase=$ini.CONNECTION.SQLDatabase
    [String]$SQLUsername=$ini.CONNECTION.SQLUsername
    [String]$SQLPassword=$ini.CONNECTION.SQLPassword
    [String]$SQLTable=$ini.CONNECTION.SQLTable

    [int]$Row=0
    [int]$RowCount=0
    [System.Collections.ArrayList]$SRDItems=@()

    [System.Array]$stores=Import-Excel -Path ".\DiffMega.xlsx"

    (
        $stores | % { $_ |  % {
                toSQL $_ ([ref]$RowCount) ([ref]$SRDItems) $SQLTable
                $Row++
                Write-Progress -Activity "DiffMegaInsertInToSQL" -status "Processando $Row" -percentComplete (($Row/$stores.Length)*100)

            }
        }

     ) |  out-file ".\DiffMegaInsertInToSQL.sql"
 
    $Row=0
    ForEach ($SRDItem in $SRDItems)
    {
        $Row++
        Write-Progress -Activity "DiffMegaInsertInToSQL" -status "Inserindo $Row" -percentComplete (($Row/$SRDItems.Count)*100)
        # Creating the INSERT query using the variables defined
        [string]$SQLQuery4="USE $SQLDatabase BEGIN TRY $SRDItem END TRY BEGIN CATCH SELECT ERROR_NUMBER() AS ERRORNUMBER ,ERROR_MESSAGE() AS ERRORMESSAGE END CATCH"
        #write-host -ForegroundColor "blue" $SQLQuery4
        # Running the INSERT query
        [string]$SQLQuery4Output=Invoke-Sqlcmd -query $SQLQuery4 -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword -OutputSqlErrors $true
    }
 
 }
 
 DiffMegaInsertInToSQL