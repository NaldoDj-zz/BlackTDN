#INCLUDE "NDJ.CH"
/*/
    Funcao: MT140APV
    Autor:    Marinaldo de Jesus
    Data:    30/01/2011
    Uso:    Executado a partir da Ma140Grava em MATA140.
            Implementação do Ponto de Entrada MT140APV, originalmente utilizado para Retornar o Grupo de Aprovadores, será utilizado, também, para
            salvar as informações da SF1 e SD1 antes da Gravação para comparação posterior;
/*/
User Function MT140APV()

    Local aArea            := GetArea()
    Local aAreaSF1        := SF1->( GetArea() )
    Local aAreaSD1        := SD1->( GetArea() )
    
    Local cGrupo         := ParamIxb[1]
    
    Local oException

    TRYEXCEPTION

        SF1SD1Arr()

    CATCHEXCEPTION USING oException

    ENDEXCEPTION

    RestArea( aAreaSD1 )
    RestArea( aAreaSF1 )
    RestArea( aArea )

Return( cGrupo )


/*/
    Funcao:     SF1SD1Arr
    Autor:        Marinaldo de Jesus
    Data:        30/01/2011
    Uso:        Salvar informacoes da SF1 e SD1 para comparacao apos a gravacao
    Sintaxe:    StaticCall( U_MT140APV , SF1SD1Arr , lSetPublic , lRetLastVal , lClearPublic )
/*/
Static Function SF1SD1Arr( lSetPublic , lRetLastVal , lClearPublic )

    Local aArray        := {}

    Local cSD1Filial
    Local cSD1KeySeek
    
    Local nRecno
    Local nSD1Order

    BEGIN SEQUENCE

        DEFAULT lRetLastVal := .F.
        IF ( lRetLastVal )
            IF ( Type( "__aSF1SD1LVal" ) == "A" ) 
                aArray := __aSF1SD1LVal
            EndIF
            BREAK
        EndIF

        DEFAULT lClearPublic := .F.
        IF ( lClearPublic )
            StaticCall( NDJLIB004 , SetPublic , "__aSF1SD1LVal" , NIL , "A" , 0 , .T. )
            BREAK
        EndIF

        cSD1Filial    := xFilial( "SD1" )
        nSD1Order     := RetOrder( "SD1" , "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM" )
    
        SF1->( aAdd( aArray , { StaticCall( NDJLIB001 , RegToArray , "SF1" , ( nRecno := Recno() ) ) , Array( 0 ) , nRecno } ) )
    
        cSD1KeySeek := cSD1Filial
        cSD1KeySeek += SF1->F1_DOC
        cSD1KeySeek += SF1->F1_SERIE
        cSD1KeySeek += SF1->F1_FORNECE
        cSD1KeySeek += SF1->F1_LOJA

        SD1->( dbSetOrder( nSD1Order ) )
        IF SD1->( dbSeek( cSD1KeySeek , .F. ) )
            While SD1->(;
                            !Eof();
                            .and.;
                            ( cSD1KeySeek == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
                        )
                SD1->( aAdd( aArray[1][2] , { StaticCall( NDJLIB001 , RegToArray , "SD1" , ( nRecno := Recno() ) ) , Array( 0 ) , nRecno } ) )
                SD1->( dbSkip() )
            End While
        EndIF
    
        DEFAULT lSetPublic := .T.
        IF ( lSetPublic )
            StaticCall( NDJLIB004 , SetPublic , "__aSF1SD1LVal" , @aArray , "A" , Len( aArray ) , .T. )
        EndIF    
    
    END SEQUENCE

Return( aArray )

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
