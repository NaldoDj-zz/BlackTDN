function toSQL($RowData) {

    $SRDTable="SRD200"

    #store RD_FIELDS
    $RD_FIELDS="RD_FILIAL,RD_MAT,RD_PD,RD_TIPO1,RD_VALOR,RD_DATARQ,RD_TIPO2,RD_STATUS,RD_INSS,RD_IR,RD_FGTS,RD_PROCES,RD_PERIODO,RD_SEMANA,RD_ROTEIR,RD_CONVOC,RD_QTDSEM,RD_HORINFO,RD_HORAS,RD_VALINFO,RD_VNAOAPL,RD_DATPGT,RD_CC,RD_SEQ,RD_EMPRESA,RD_MES,RD_DTREF,RD_POSTO,RD_NUMID,RD_DEPTO,RD_NODIA,RD_DIACTB,RD_PLNUCO,RD_CODB1T,RD_ITEM,RD_CLVL,RD_EMPCONS,RD_IDCMPL,RD_CRITER,RD_SEQUE,RD_LOTPLS,RD_CODRDA,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,RD_VALORBA"

    #store Fields
    $RD_FILIAL="'"+$RowData.Filial+"'"
    $RD_MAT="'"+$RowData.Matricula+"'"
    $RD_TIPO1="'V'"
    [STRING]$tmp=$RowData.Competencia
    $RD_DATARQ=$tmp.SubString(3,4)
    $RD_DATARQ+=$tmp.SubString(0,2)
    $RD_DATARQ="'"+$RD_DATARQ+"'"
    $RD_TIPO2="'I'"
    $RD_STATUS="'A'"
    $RD_PROCES="'00001'"
    $RD_PERIODO=$RD_DATARQ
    $RD_SEMANA="'02'"
    $RD_ROTEIR="'FOL'"
    $RD_CONVOC="''"
    $RD_QTDSEM=0
    $RD_HORINFO=0
    $RD_HORAS=0
    $RD_VALINFO=0
    $RD_VNAOAPL=0
    $RD_DATPGT="' '"
    $RD_CC="' '"
    $RD_SEQ="' '"
    $RD_EMPRESA="' '"
    $RD_MES="' '"
    $RD_DTREF="' '"
    $RD_POSTO="' '"
    $RD_NUMID="' '"
    $RD_DEPTO="' '"
    $RD_NODIA="' '"
    $RD_DIACTB="' '"
    $RD_PLNUCO="' '"
    $RD_CODB1T="' '"
    $RD_ITEM="' '"
    $RD_CLVL="' '"
    $RD_EMPCONS="' '"
    $RD_IDCMPL="' '"
    $RD_CRITER="' '"
    $RD_SEQUE="' '"
    $RD_LOTPLS="' '"
    $RD_CODRDA="' '"
    $D_E_L_E_T_="' '"
    $R_E_C_N_O_="(SELECT (isNull(MAX(R_E_C_N_O_),0)+1) R_E_C_N_O_ FROM $($SRDTable))"
    $R_E_C_D_E_L_=0
    $RD_VALORBA=0

    $RD_PD="'116'"
    $RD_VALOR=$RowData.PD_116
    $RD_INSS="'S'"
    $RD_IR="'S'"
    $RD_FGTS="'S'"
    
    #store RD_VALUES
    $RD_VALUES=$RD_FILIAL
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
    $RD_VALUES+=$RD_PROCES="'00001'"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_PERIODO=$RD_DATARQ
    $RD_VALUES+=","
    $RD_VALUES+=$RD_SEMANA="'02'"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_ROTEIR="'FOL'"
    $RD_VALUES+=","
    $RD_VALUES+=$RD_CONVOC
    $RD_VALUES+=","
    $RD_VALUES+=$RD_QTDSEM
    $RD_VALUES+=","
    $RD_VALUES+=$RD_HORINFO
    $RD_VALUES+=","
    $RD_VALUES+=$RD_HORAS=0
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

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

    $RD_PD="'799'"
    $RD_VALOR=$RowData.Liquido
    $RD_INSS="'N'"
    $RD_IR="'N'"
    $RD_FGTS="'N'"

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

    $RD_PD="'794'"
    $RD_VALOR=$RowData.SalarioEducacao
    $RD_INSS="'N'"
    $RD_IR="'N'"
    $RD_FGTS="'N'"

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

    $RD_PD="'710'"
    $RD_VALOR=$RowData.FGTS
    $RD_INSS="'N'"
    $RD_IR="'N'"
    $RD_FGTS="'N'"

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

    $RD_PD="'410'"
    $RD_VALOR=$RowData.INSSDiff
    $RD_INSS="'N'"
    $RD_IR="'S'"
    $RD_FGTS="'N'"

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

    $RD_PD="'701'"
    $RD_VALOR=$RowData.PD_116
    $RD_INSS="'N'"
    $RD_IR="'N'"
    $RD_FGTS="'N'"

    $Line="INSERT INTO $($SRDTable) ($($RD_FIELDS)) VALUES ($($ExecutionContext.InvokeCommand.ExpandString($RD_VALUES)))"

    Write-Host $Line
    Write-Output $Line

}


$stores = Import-Excel -Path .\DiffMega.xlsx
Remove-Item .\DiffMega.sql -Force -ErrorAction SilentlyContinue

if (Get-Module -ListAvailable -Name ImportExcel) {
  Write-Host "Module exists"
} else {
  Write-Host "Module does not exist. Installing..."
  Install-Module -Name ImportExcel -Force -Confirm:$False
}

(
    $stores | % { $_ |  % {
            toSQL($_)
        }
    }

 ) |  out-file DiffMega.sql