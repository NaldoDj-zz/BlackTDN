#INCLUDE "NDJ.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103COR � Autor � Jose Carlos Noronha� Data �  05/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para tratar as cores do browse com a      ���
��             inclusao do ATESTO.                                        ���
��                                                                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
