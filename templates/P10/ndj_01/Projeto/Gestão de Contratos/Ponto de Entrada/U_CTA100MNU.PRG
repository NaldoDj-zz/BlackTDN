#INCLUDE "NDJ.CH"
/*/
	Funcao:		CTA100MNU
	Autor:		Marinaldo de Jesus
	Data:		05/11/2011
	Descricao:	Ponto de Entrada CTA100MNU, executado em MenuDef na CTA100, sera utilizado para Alterar a Opcao de Pesquisa quanto existir filtro.
/*/
User Function CTA100MNU()

	Local aMnuPopUP	:= {}
	
	Local nIndex
	
	Local lUCN100FIL
    
	TRYEXCEPTION

		IF !( Type( "aRotina" ) == "A" )
			BREAK
		EndIF

		nIndex	:= aScan( aRotina , { |aElem| ( aElem[4] == 4 ) } )
		IF ( nIndex > 0	)
			aAdd( aRotina , aClone( aRotina[ nIndex ] ) )
			nIndex := Len( aRotina )
			IF ( nIndex	> 0 )
				aRotina[nIndex][1]	:= "Gerar Aditivo"
                aRotina[nIndex][2]	:= "StaticCall(U_CTA100MNU,NDJAditivos,'CN9',CN9->(Recno()),4)"
				aRotina[nIndex][3]	:= 0
				aRotina[nIndex][4]	:= 4
			EndIF
		EndIF

		nIndex	:= aScan( aRotina , { |aElem| ( aElem[4] == 4 ) } )
		IF ( nIndex > 0 )
			aAdd( aMnuPopUP , aClone( aRotina[ nIndex ] ) )
			nIndex := Len( aMnuPopUP )
			IF ( nIndex > 0 )
				aMnuPopUP[nIndex][1]	:= "Pesquisar"
                aMnuPopUP[nIndex][2]	:= "StaticCall(U_CTA100MNU,NDJCirquitos,1)"
				aMnuPopUP[nIndex][3]	:= 0
				aMnuPopUP[nIndex][4]	:= 4
			EndIF
		EndIF

		nIndex	:= aScan( aRotina , { |aElem| ( aElem[4] == 4 ) } )
		IF ( nIndex > 0 )
			aAdd( aMnuPopUP , aClone( aRotina[ nIndex ] ) )
			nIndex := Len( aMnuPopUP )
			IF ( nIndex > 0 )
				aMnuPopUP[nIndex][1]	:= "Manutenção"
                aMnuPopUP[nIndex][2]	:= "StaticCall(U_CTA100MNU,NDJCirquitos)"
				aMnuPopUP[nIndex][3]	:= 0
				aMnuPopUP[nIndex][4]	:= 4
			EndIF
		EndIF

		nIndex	:= aScan( aRotina , { |aElem| ( aElem[4] == 4 ) } )
		IF ( nIndex	> 0 )
			aAdd( aRotina , aClone( aRotina[ nIndex ] ) )
			nIndex := Len( aRotina )
			IF ( nIndex	> 0 )
				aRotina[nIndex][1]	:= "Circuito"
				aRotina[nIndex][2]	:= aMnuPopUP
				aRotina[nIndex][3]	:= 0
				aRotina[nIndex][4]	:= 4
			EndIF
		EndIF

		lUCN100FIL := ( FindFunction( "U_CN100FIL" ) .and. !Empty( U_CN100FIL() ) )

		IF ( lUCN100FIL )

			nIndex					:= aScan( aRotina , { |aElem| Upper( "AxPesqui" ) $ Upper( aElem[2] ) } )
			IF .NOT.( nIndex > 0 )
				BREAK
			EndIF
	
			aRotina[nIndex][2]		:= "PesqBrw"
		
		EndIF	
	
	CATCHEXCEPTION USING oExeption

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
    Funcao:     NDJAditivos 
	Autor:		Marinaldo de Jesus
	Data:		19/04/2011
	Descricao:	Chamada a Rotina de Inclusao e/ou Visualizacao de Contratos para Manutencao do Aditivo
/*/
Static Function NDJAditivos( cAlias , nReg , nOpc )

    Local cCN9Situac := StaticCall( NDJLIB001 , __FieldGet , "CN9" , "CN9_SITUAC" , .T. )
	
	Local uRet

    StaticCall( NDJLIB001 , __FieldPut , "CN9" , "CN9_SITUAC" , "02" , .T. )        //Em Elaboracao

    uRet := StaticCall( U_MT120BRW , NDJContratos , @nOpc , .T. )

    StaticCall( NDJLIB001 , __FieldPut , "CN9" , "CN9_SITUAC" , cCN9Situac , .T. )    //Restaura o Status Anterior

Return( uRet )

/*/
    Funcao:     NDJCirquitos
	Autor:		Marinaldo de Jesus
	Data:		27/04/2011
	Descricao:	Chamada a Rotina de Inclusao e/ou Visualizacao de Cirtuitos
/*/
Static Function NDJCirquitos( nOpc )

	Local aArea			:= GetArea()
	Local aSZ8Area		:= SZ8->( GetArea() )
	Local aCN9Area		:= CN9->( GetArea() )
	Local aSaveGet		:= SaveoGet()

	Local cCirquito		:= "0"
	Local cSZ8KeySeek
	Local cCN9KeySeek
	Local cSvExprFilTop
	
	Local nSZ8Order		:= RetOrder( "SZ8" , "Z8_FILIAL+Z8_CONTRA+Z8_CODPLAN+Z8_ITEPLAN+Z8_CODIGO+Z8_ITEM" )
	Local nCN9Order		:= RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO" )
	Local nCN9Recno

	Local uRet

	DEFAULT nOpc		:= 4

	BEGIN SEQUENCE

		IF ( nOpc == 1 )	//Pesquisar

			IF !( ChkVazio( "SZ8" ) )
				BREAK
			EndIF
		
			SZ8->( dbSetOrder( nSZ8Order ) )

			IF SZ8->( ( AxPesqui() == 1 ) )
				CN9->( dbSetOrder( nCN9Order ) )
				cCN9KeySeek := xFilial( "CN9" )
                cCN9KeySeek += StaticCall( NDJLIB001 , __FieldGet , "SZ8" , "Z8_CONTRA" )
				IF CN9->( dbSeek( cCN9KeySeek , .F. ) )
					nCN9Recno := CN9->( Recno() )
				EndIF	
			EndIF
			IF !Empty( nCN9Recno )
				CN9->( MsGoto( nCN9Recno ) )
			EndIF
			BREAK
		
		EndIF

		SaveInter()
	
        cSvExprFilTop        := StaticCall( NDJLIB001 , GetSetMbFilter , "" )
	
		SetMBTopFilter( "CN9" , ""  )
		SetMBTopFilter( "SZ8" , ""  )
		
        uRet := StaticCall( U_NDJA004 , NDJA004 )
	
		cSZ8KeySeek := xFilial( "SZ8" )
        cSZ8KeySeek += StaticCall( NDJLIB001 , __FieldGet , "CN9" , "CN9_NUMERO" )

		SZ8->( dbSetOrder( nSZ8Order ) )
		IF SZ8->( dbSeek( cSZ8KeySeek , .F.  ) )
			cCirquito	:= "1"
		EndIF
	
        StaticCall( NDJLIB001 , __FieldPut , "CN9" , "CN9_XCIRQT" , cCirquito , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CN9" , "CN9_XCIRQT" , cCirquito , .F. )
	
        StaticCall( NDJLIB001 , GetSetMbFilter , cSvExprFilTop )
	
		SetMBTopFilter( "SZ8" , "" )
	
		SetMBTopFilter( "CN9" , cSvExprFilTop )
	
		RestartoGet( aSaveGet )
	
		RestInter()

		RestArea( aSZ8Area )
		RestArea( aCN9Area )
		RestArea( aArea )

	END SEQUENCE

Return( uRet )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJAditivos()
        NDJCirquitos()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )