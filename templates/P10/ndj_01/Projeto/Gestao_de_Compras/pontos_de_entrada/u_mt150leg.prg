#INCLUDE "NDJ.CH"
/*/
    Funcao: MT150LEG
    Autor:    Marinaldo de Jesus
    Data:    27/10/2010
    Uso:    Executada MATA150. 
            Sera utilizado adicionar novas opcoes a Legenda do Browse.
/*/
User Function MT150LEG()

    Local aCores    := {}
    Local nOpc        := ParamIxb[1]

    IF ( nOpc == 2 )
        aAdd( aCores , { "CRDIMG16"  , OemToAnsi( "Aguardando Aprovação"        ) } )
        aAdd( aCores , { "BR_CANCEL" , OemToAnsi( "Rejeitada Pelo Solicitante"    ) } )
    ElseIF ( nOpc == 1 )
        aAdd( aCores , { "SC8->C8_XSTATCO$'01'" , "CRDIMG16"  } )
        aAdd( aCores , { "SC8->C8_XSTATCO$'xX'" , "BR_CANCEL" } )
    EndIF

Return( aCores )

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
