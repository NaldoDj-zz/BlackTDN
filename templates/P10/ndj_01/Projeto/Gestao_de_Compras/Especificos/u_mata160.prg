#INCLUDE "NDJ.CH"
/*/
    Programa:    U_MATA160
    Autor:          Marinaldo de Jesus
    Data:        14/12/2010
    Uso:        Chamar o programa MATA160 (Analise de Cotacao) com filtro por Solicitante e Possibilitar tratamento especifico
                Essa sera a Rotina Para a Aprovacao da Cotacao a Partir da Rotina de (Analise de Cotacao)
/*/
User Function MATA160()

    Local uRet

    BEGIN SEQUENCE

        IF IsInCallStack( "MATA160" )
            BREAK
        EndIF

        uRet        := MATA160()

    END SEQUENCE

Return( uRet )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
