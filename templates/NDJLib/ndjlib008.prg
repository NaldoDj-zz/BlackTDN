#include "ndj.ch" 

#DEFINE MAX_NDJ_PACK_PARAMETERS 99
/*/
    Funcao:RpcPackTabs
    Autor:Marinaldo de Jesus
    Data:03/02/2011
    Uso:Chamada Via RPC para limpeza de tabelas (pack)
    Sintaxe:1-RpcPackTabs({cEmp,cFil})//Chamada Direta
            2-RpcPackTabs(cEmp,cFil)//Chamada Via Agendamento
/*/
User Function RpcPackTabs(aParameters)

    Local aTabs

    Local cEmp
    Local cFil
    Local cTab
    Local cTabs

    Local nTab
    Local nTabs
    Local nLoop
    Local nLoops
    Local nStrZero
    
    Local oException

    TRYEXCEPTION

        IF !Empty(aParameters)
            IF (Len(aParameters)>1)
                cEmp:=aParameters[1]
            EndIF
            IF (Len(aParameters)>2)
                cFil:=aParameters[2]
            EndIF
        EndIF
    
        DEFAULT cEmp:="01"
        DEFAULT cFil:="01"
        
        PREPARE ENVIRONMENT EMPRESA (cEmp) FILIAL (cFil)

            nLoops:=MAX_NDJ_PACK_PARAMETERS
            nStrZero:=Len(StaticCall(NDJLIB001,RetPictVal,nLoops))

            For nLoop:=0 To nLoops
                cTabs:=Upper(AllTrim(GetNewPar("NDJ_PACK"+StrZero(nLoop,nStrZero),"")))
                aTabs:=StrTokArr(cTabs,";")
                nTabs:=Len(aTabs)
                For nTab:=1 To nTabs
                    cTab:=aTabs[ nTab ]
                    IF !Empty(cTab)
                        StaticCall(NDJLIB001,dbPack,cTab)
                    EndIF    
                Next nTab
            Next nLoop

        RESET ENVIRONMENT

    CATCHEXCEPTION USING oException

        IF (ValType(oException)=="O")
            ConOut(CaptureError())
        EndIF

    ENDEXCEPTION

Return(NIL)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
