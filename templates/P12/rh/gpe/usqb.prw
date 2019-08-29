#include "totvs.ch"
static __cQBDescric   as character
static __cQBTableName as character
static __cQBKeyEmpFil as character
static __cQBKeyVAlias as character
/*
    Programa:uSQB.prw
    Funcao:U_QBXDESSUPTrg()
    Autor:Marinaldo de Jesus (marinaldo.jesus@totvspartners.com.br)
    Data:21/10/2015
    Finalidade:Retornar Descricao do Departamento a partir de Alias Virtual    
    Uso:Inicializador Padrao do campo customizado QB_XDESSUP ou Gatilho do campo QB_DEPSUP -> QB_XDESSUP
*/
function u_QBXDESSUPTrg(lMemVar as logical) as character
    local cQBDEPSUP     as character
    local cEmpFilKey    as character
    local cSQBFilial    as character
    local cQBxDescSup   as character
    local cSQBKeySeek   as character
    local lSQBChange    as logical
    local nSQBOrder     as numeric
    DEFAULT __cQBTableName:=RetSQLName("SQB")
    DEFAULT __cQBKeyEmpFil:="@__cQBKeyEmpFil@"
    DEFAULT __cQBKeyVAlias:=GetNextAlias()
    cEmpFilKey:=(cEmpAnt+cFilAnt)
    if .not.(__cQBKeyEmpFil==cEmpFilKey)
        __cQBKeyEmpFil:=cEmpFilKey
        if ((Select(__cQBKeyVAlias)==0).or.(.not.(__cQBTableName==RetSQLName("SQB"))))
            lSQBChange:=.T.
        endif
    endif
    DEFAULT lSQBChange:=.F.
    if (lSQBChange)
        if .not.(Empty(__cQBKeyVAlias))
            if (Select(__cQBKeyVAlias)>0)
                (__cQBKeyVAlias)->(dbCloseArea())
            endif
        endif
        ChkFile("SQB",.F.,__cQBKeyVAlias)
    endif
    if (Select(__cQBKeyVAlias)>0)
        DEFAULT lMemVar:=IsInCallStack("RUNTRIGGER")
        cQBDEPSUP:=if(lMemVar,GetMemVar("QB_DEPSUP"),SQB->QB_DEPSUP)
        cSQBFilial:=xFilial("SQB",if(lMemVar,NIL,SQB->QB_FILIAL))
        cSQBKeySeek:=cSQBFilial
        cSQBKeySeek+=cQBDEPSUP
        nSQBOrder:=RetOrder("SQB","QB_FILIAL+QB_DEPTO")
        cQBxDescSup:=Posicione(__cQBKeyVAlias,nSQBOrder,cSQBKeySeek,"QB_DESCRIC")
    else
        DEFAULT __cQBDescric:=Space(GetSx3Cache("QB_DESCRIC","X3_TAMANHO"))
        cQBxDescSup:=__cQBDescric
    endif
return(cQBxDescSup)
