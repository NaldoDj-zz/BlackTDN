#INCLUDE "NDJ.CH"
/*/
	Funcao: MA160BAR
	Autor:	Marinaldo de Jesus
	Data:	10/12/2010
	Uso:	Executada a partir da Ma160Bar em MATA160. Originalmente usada para adicionar novos botoes na EnchoiceBar.
			Sera utilizado trazer a Cotacao Previamente Selecionada
/*/
User Function MA160BAR()

	Local cAliasPLN
	
	Local lLock
	Local lIsLocked
	Local lUMata160		:= IsInCallStack( "U_MATA160"  )

	BEGIN SEQUENCE

		TRYEXCEPTION
			FindTwBrw()
		ENDEXCEPTION

		IF !( lUMata160 )
			BREAK
		EndIF

		IF !( IsPLNMounted( @cAliasPLN ) )
			BREAK
		EndIF

		( cAliasPLN )->( dbGotop() )
		IF ( cAliasPLN )->( Eof() .or. Bof() )
			BREAK
		EndIF
		
		lIsLocked := ( cAliasPLN )->( IsLocked() )
		IF ( lIsLocked )
			lLock	:= lIsLocked
		Else
			lLock	:= ( cAliasPLN )->( RecLock( cAliasPLN , .F. ) )
		EndIF

		/*/
			Paramixb[1] : nReg
			Paramixb[2] : aPlanilha
			Paramixb[3] : aAuditoria
			Paramixb[4] : aCotacao
			Paramixb[5] : aListBox
			Paramixb[6] : aCabec
			Paramixb[7] : aRefImpos
			Paramixb[8] : lTes
			Paramixb[9] : aCpoSC8
		/*/

		IF ( lLock )
			( cAliasPLN )->PLN_OK			:= "XX"	
			IF !( lIsLocked )
				( cAliasPLN )->( MsUnLock() )
			EndIF
			ParamIxb[2][1][1][PLAN_MARK]	:= "XX"
			ParamIxb[6][7]:oBrowse:Refresh()
		EndIF

	END SEQUENCE

Return( NIL )

/*/
	Funcao: IsPnlMounted
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Obtem o Alias para a Tabela de Analise de Cotacao
/*/
Static Function IsPLNMounted( cAliasPLN )

	Local aPLNFields	:= {					; 
								"PLN_OK",		;
								"PLN_FORNECE",	;
								"PLN_LOJA",		;
								"PLN_NREDUZ",	;
								"PLN_NUMPRO",	;
								"PLN_TOTAL",	;
								"PLN_DATPRF",	;
								"PLN_DATPRZ",	;
								"PLN_DESVIO",	;
								"PLN_NOTA",		;
								"PLN_OBS",		;
								"PLN_FLAG",		;
								"PLN_ITEM",		;
								"PLN_PRECO",	;
								"PLN_COND",		;
								"PLN_DESCRI",	;
								"PLN_PRAZO",	;
								"PLN_VISTO",	;
								"PLN_ITEMGRD"	;
							 } 

Return( StaticCall( NDJLIB001 , GetAlias4Fields , @cAliasPLN , @aPLNFields ) )    

/*/
	Funcao: FindTwBrw
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Altera a acao do Duplo Clique do ListBox de Fornecedores
/*/
Static Function FindTwBrw()

    Local aObj                := StaticCall( NDJLIB016 , FindMsObject , "TFOLDER" )

    Local bldblclick        := { || StaticCall( NDJLIB001 , DlgMemoEdit , NIL , NIL , .F. , NIL , NIL , oTWBrowse:aArray[ oTWBrowse:nRowPos , oTWBrowse:nColPos ] ) }

	Local nObj				:= aScan( aObj , { |oObj| aScan( oObj:aPrompts , { |cPromp| "fornecedor" $ Lower( cPromp ) } ) > 0 } )
	Local nPrompt			:= aScan( aObj[nObj]:aPrompts , { |cPrompt| "fornecedor" $ Lower( cPrompt ) } ) 
	Local nTWBrowse			:= aScan( aObj[nObj]:aDialogs[nPrompt]:oWnd:aControls , { |oObj| "TWBROWSE" $ oObj:ClassName() } )

	Local oTWBrowse			:= aObj[nObj]:aDialogs[nPrompt]:oWnd:aControls[nTWBrowse]

    bldblclick                := { || StaticCall( NDJLIB001 , DlgMemoEdit , NIL , NIL , .F. , NIL , NIL , oTWBrowse:aArray[ oTWBrowse:nRowPos , oTWBrowse:nColPos ] ) }

	oTWBrowse:bldblclick	:= bldblclick
	oTWBrowse:cToolTip		:= OemToAnsi( "Duplo clique para visualizar os Detalhes do Campo" )

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )