#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT150OK
    Data:        16/08/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada executado no progama MT150OK.
                Implementação do Ponto de Entrada MT150OK que srá utilizado para validar a Linha Digitada da GetDados
/*/
User Function MT150OK()

    Local lTudoOk    := .T.

    Local nSvn        := n
    
    Local nItem
    Local nItens

    BEGIN SEQUENCE

        nItens    := Len( aCols )
        For nItem := 1 To nItens
            n := nItem
            IF !( GdDeleted() )
                lTudoOK := U_MT150LOK()
                IF !( lTudoOK )
                    BREAK
                EndIF
            EndIF
        Next nItem

    END SEQUENCE

    IF ( lTudoOK )
        n    := nSvn
    EndIF    

Return( lTudoOk )

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
