#INCLUDE "NDJ.CH"
/*/
    Funcao: MT160LEG
    Autor:    Marinaldo de Jesus
    Data:    27/10/2010
    Uso:    Executada MATA160. 
            Sera utilizado adicionar novas opcoes a Legenda do Browse.
/*/
User Function MT160LEG()

    Local aCores    := {}

    IF ( Type( "aLegenda" ) == "A" )
        aAdd( aLegenda , { "CRDIMG16"  , OemToAnsi( "Aguardando Aprovação"             ) } )
        aAdd( aLegenda , { "BR_CANCEL" , OemToAnsi( "Rejeitada Pelo Solicitante"    ) } )
    EndIF    

    aAdd( aCores , { "SC8->C8_XSTATCO$'01'" , "CRDIMG16" } )
    aAdd( aCores , { "SC8->C8_XSTATCO$'xX'" , "BR_CANCEL" } )
    aEval( ParamIxb[1] , { |aElem| aAdd( aCores , aElem ) } )

    IF IsInCallStack( "U_MATA160" )
        cCadastro    := OemToAnsi( "Aprovação de Cotação" )
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
