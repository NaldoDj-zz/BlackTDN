#include "totvs.ch"
/*
    Programa:uSRV.prw
    Funcao:RVCodTrg()
    Autor:Marinaldo de Jesus (marinaldo.jesus@totvspartners.com.br)
    Data:21/10/2015
    Finalidade:Retornar um Codigo Valido para o Cadastro de Verbas de Acordo com o Tipo    
    Uso:Gatilho do Campo RV_TIPOCOD
*/
function u_RVCodTrg() as character
    local aArea         as array
    local aAreaSRV      as array
    local cRVCod        as character
    local cRVTipoCod    as character
    local cAlias        as character
    local nRVCod        as numeric
    local nSRVOrder     as numeric
    aArea:=GetArea()
    aAreaSRV:=SRV->(GetArea())
    cAlias:=GetNextAlias()
    cRVTipoCod:=GetMemVar("RV_TIPOCOD")
    BEGINSQL ALIAS cAlias
        SELECT MAX(SRV.RV_COD) AS RV_COD
          FROM %table:SRV% AS SRV
         WHERE SRV.%notDel%
           AND SRV.RV_FILIAL=%xFilial:SRV%
           AND SRV.RV_TIPOCOD=%exp:cRVTipoCod%           
    ENDSQL 
    cRVCod:=(cAlias)->RV_COD
    (cAlias)->(dbCloseArea())
    dbSelectArea("SRV")
    if (Empty(cRVCod))
        nRVCod:=GetSX3Cache("RV_COD","X3_TAMANHO")
        DO CASE  
        CASE (cRVTipoCod=="1")
            cRVCod:="0"
        CASE (cRVTipoCod=="2")
            cRVCod:="6"
        CASE (cRVTipoCod=="3")
            cRVCod:="B"
        CASE (cRVTipoCod=="4")
            cRVCod:="C"
        OTHERWISE
            cRVCod:="0"
        END CASE 
        cRVCod+=Replicate("0",nRVCod-1)
    endif
    cRVCod:=__Soma1(cRVCod)
    if ((cRVTipoCod=="1").and.(cRVCod>="600"))
        DEFAULT nRVCod:=GetSX3Cache("RV_COD","X3_TAMANHO")
        cRVCod:=("1"+Replicate("0",nRVCod-1))        
    endif
    nSRVOrder:=RetOrder("SRV","RV_FILIAL+RV_COD")
    while ((.not.(ExistChav("SRV",cRVCod,nSRVOrder,.F.))).or.(.not.(FreeForUse("SRV",cRVCod))))
        cRVCod:=__Soma1(cRVCod)
    end while
    RestArea(aAreaSRV)
    RestArea(aArea)
return(cRVCod) 

/*
    Programa:uSRV.prw
    Funcao:RVCodEmpty()
    Autor:Marinaldo de Jesus (marinaldo.jesus@totvspartners.com.br)
    Data:21/10/2015
    Finalidade:Verifica se o Campo RV_COD esta vazio    
    Uso:Gatilho do Campo RV_TIPOCOD
*/
function u_RVCodEmpty() as logical
    local cRVCod   as character
    local lIsEmpty as logical
    if (.not.(Type("INCLUI")=="L"))
        private INCLUI as logical
        INCLUI:=.F.
    endif
    if (IsMemVar("RV_COD"))
        if (INCLUI)
            cRVCod:=Space(GetSX3Cache("RV_COD","X3_TAMANHO"))
        else
            cRVCod:=GetMemVar("RV_COD")
        endif
    else
        cRVCod:=SRV->RV_COD
    endif
    lIsEmpty:=Empty(cRVCod)
return(lIsEmpty) 
