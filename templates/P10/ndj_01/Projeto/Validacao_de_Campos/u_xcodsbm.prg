#INCLUDE "NDJ.CH"
/*/
    Funcao:        C1XCodSbmVld
    Autor:        Marinaldo de Jesus
    Data:        10/11/2010
    Descricao:    Validar o campo C1_XCODSBM
    Sintaxe:    StaticCall(U_XCODSBM,C1XCodSbmVld)
/*/
Static Function C1XCodSbmVld( cC1CodSbm , lShowHelp , cMsgHelp , lChgProduto )
Return( StaticCall( U_SC1FLDVLD , C1XCodSbmVld , @cC1CodSbm , @lShowHelp , @cMsgHelp , @lChgProduto ) )

/*/
    Funcao:     C1ProdutoVld
    Autor:        Marinaldo de Jesus
    Data:        23/11/2010
    Descricao:    Manter o Centro de Custo Baseado no CodSBM
/*/
Static Function C1ProdutoVld( cC1Produto , lShowHelp , cMsgHelp )
Return( StaticCall( U_SC1FLDVLD , C1ProdutoVld , @cC1Produto , @lShowHelp , @cMsgHelp ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        C1XCodSbmVld()
        C1ProdutoVld()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
