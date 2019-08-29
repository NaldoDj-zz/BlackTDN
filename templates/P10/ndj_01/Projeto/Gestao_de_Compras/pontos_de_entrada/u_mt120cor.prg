#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT120COR
    Autor:        Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada MT120COR executado na funcao MATA120
                do programa MATA120 Tratamento de cores na mBrowse
/*/
User Function MT120COR()

    Local aCores        := ParamIxb[1]
    Local aCoresAdd        := {}

    Local cC7XCTNCNB    := Space( GetSx3Cache( "C7_XCTNCNB" , "X3_TAMANHO" ) )

    IF !( ValType( aCores ) == "A" )
        aCores := {}
    EndIF

    aAdd( aCoresAdd , { "( ( C7_XCNTSOL == .T. ) .and. ( C7_XCNTADT == .F. ) .and. ( C7_XCTNCNB == '" + cC7XCTNCNB + "' ) )"    , "NDJSOLICITACNT_16"    } )        //"Solicitação de Contrato"
    aAdd( aCoresAdd , { "( ( C7_XCNTSOL == .T. ) .and. ( C7_XCNTADT == .T. ) .and. ( C7_XCTNCNB == '" + cC7XCTNCNB + "' ) )"    , "NDJADITIVOCNT_16"    } )        //"Solicitação de Aditivo"
    aAdd( aCoresAdd , { "( ( C7_CONAPRO == 'B' ) .and. ( C7_XCTNCNB <> '" + cC7XCTNCNB + "' ) .and. ( C7_QUJE>=C7_QUANT ) )"    , "BPMSDOCA_16"            } )        //"Bloqueado por Contrato"
    aAdd( aCoresAdd , { "( ( C7_BLOCKZ0 == .T. ) .and. ( C7_CONAPRO == 'B' ) )"                                                    , "CADEADO_16"            } )        //"Bloqueado por Orçamento"

    aEval( aCores , { |aElem| aAdd( aCoresAdd , aElem ) } )

    aCores    := aCoresAdd

    IF IsInCallStack( "GetC7Status" )
        __aColors_ := aCores
        UserException( "IGetC7Status" )
    EndIF

Return( aCores )

/*/
    Funcao:        GetC7Status
    Autor:        Marinaldo de Jesus
    Descricao:    Retornar o Status da SC7 conforme Array de Cores da mBrowse
    Sintaxe:    StaticCall( U_MT110COR , GetC7Status , cAlias , cResName , lArrColors )
/*/
Static Function GetC7Status( cAlias , cResName , lArrColors )

    Local bGetColors    := { || Mata120() }
    Local bGetLegend    := { || A120Legenda() }

    DEFAULT cAlias         := "SC7"

Return( StaticCall( NDJLIB001 , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , @cResName , @lArrColors ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        GetC7Status()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
