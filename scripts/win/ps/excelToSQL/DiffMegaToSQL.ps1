function toSQL {
    
    param(
            [Parameter(Mandatory=$true)]$RowData,
            [Parameter(Mandatory=$true)][ref]$RowCount,
            [Parameter(Mandatory=$true)][ref]$LogArray
    )

    [String]$SRDTable="SRD200"

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
    $RD_PD="'116'"
    $RD_VALOR=$RowData.PD_116
    $RD_INSS="'S'"
    $RD_IR="'S'"
    $RD_FGTS="'S'"
    
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

    [String]$Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    $RD_INSS="'N'"
    $RD_FGTS="'N'"

    #INSS...............................................................................................................
    $RD_PD="'410'"
    $RD_VALOR=$RowData.INSSDiff

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    $RD_IR="'N'"

    #Base INSS..........................................................................................................
    $RD_PD="'701'"
    $RD_VALOR=$RowData.PD_116

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    #Base FGTS..........................................................................................................
    $RD_PD="'706'"
    $RD_VALOR=$RowData.PD_116

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    #FGTS..............................................................................................................
    $RD_PD="'710'"
    $RD_VALOR=$RowData.FGTS

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    #Salario Educacao...................................................................................................
    $RD_PD="'794'"
    $RD_VALOR=$RowData.SalarioEducacao

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

    #Salario Liquido....................................................................................................
    $RD_PD="'799'"
    $RD_VALOR=$RowData.Liquido

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    $RowCount.Value++
    $logArray.Value+="$($RowCount.Value) :: $($Line)"
    Write-Output $Line

}

function DiffMegaToSQL {

    [System.Array]$stores=Import-Excel -Path ".\DiffMega.xlsx"
    if ([System.IO.File]::Exists(".\DiffMegaToSQL.sql")){
        Remove-Item ".\DiffMegaToSQL.sql" -Force -ErrorAction SilentlyContinue
    }
    

    if (Get-Module -ListAvailable -Name ImportExcel) {
      Write-Host "Module ImportExcel exists"
    } else {
      Write-Host "Module ImportExcel does not exist. Installing..."
      Install-Module -Name ImportExcel -Force -Confirm:$False
    }

    [int]$Row=0
    [int]$RowCount=0
    [System.Array]$logArray=@()
    [System.Array]$stores=Import-Excel -Path ".\DiffMega.xlsx"
    (
        $stores | % { $_ |  % {
                toSQL $_ ([ref]$RowCount) ([ref]$logArray)
                $Row++
                Write-Progress -Activity "DiffMegaToSQL" -status "Processando $Row" -percentComplete (($Row/$stores.Length)*100) -ID 1
            }
        }

     ) | out-file ".\DiffMegaToSQL.sql"

    cls

    if ($logArray.Count -gt 0){
        $logArray | % { write-host $_ }
    }
     
}     

cls
DiffMegaToSQL