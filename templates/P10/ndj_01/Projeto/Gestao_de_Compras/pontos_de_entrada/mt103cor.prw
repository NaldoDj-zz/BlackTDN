#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103COR º Autor ³ Jose Carlos Noronhaº Data ³  05/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para tratar as cores do browse com a      ¹±±
±±             inclusao do ATESTO.                                        ¹±±
±±                                                                        ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT103COR()

    Local aCores    := ParamIxb[1]
    Local aColors    := {}

    IF ( SF1->( FieldPos( "F1_XATESTO" ) ) > 0 )
        aAdd( aColors , { "F1_XATESTO=='A'" , "CADEADO_16" } )        //"Aguardando Atesto"
        aAdd( aColors , { "F1_XATESTO=='R'" , "BR_CANCEL" } )        //"Recusa de Atesto"
        aEval( aCores , { |aElem,nIndex| aAdd( aColors , aCores[ nIndex ] ) } )
    EndIF

    IF IsInCallStack( "GetF1Status" )
        __aColors_ := aColors
        UserException( "IGetF1Status" )
    EndIF

Return( aColors )  

/*/
    Funcao:        GetF1Status
    Autor:        Marinaldo de Jesus
    Descricao:    Retornar o Status da SF1 conforme Array de Cores da mBrowse
    Sintaxe:    StaticCall( U_MT110COR , GetF1Status , cAlias , cResName , lArrColors )
/*/
Static Function GetF1Status( cAlias , cResName , lArrColors )

    Local bGetColors    := { || MATA103() }            
    Local bGetLegend    := { || A103Legenda() }

    DEFAULT cAlias         := "SF1"

Return( StaticCall( NDJLIB001 , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , @cResName , @lArrColors ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
        GetF1Status()
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
