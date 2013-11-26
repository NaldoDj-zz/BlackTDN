#INCLUDE "NDJ.CH"
/*/
	Funcao:		AVALCOPC
	Data:		23/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de entrada executado na AnАlise da CotaГЦo de Compras
				serА utilizado para levar as informaГУes da tabela de CotaГЦo de Compras(SC8) para a tabela de Pedido de Compras (SC7)	
/*/
User Function AVALCOT()

	Local aArea		:= GetArea()
	Local aFromTo	:= {}

	Local c4aVisao
	Local cFornece
	Local cC7Descri
	Local cCTDFilial

	Local lAprova	:= ( IsInCallStack( "U_MATA160" ) )

	Local nOpc		:= ParamIXB[1] 
	Local nCTDOrder

	BEGIN SEQUENCE

		IF !( lAprova )
			BREAK
		EndIF

		IF !( nOpc == 4 )
			BREAK
		EndIF

		//Tratamento para a 4a Visao
        cFornece    := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_FORNECE" , .T. )
		IF !Empty( cFornece )
			c4aVisao	:= ( "200" + cFornece )
			cCTDFilial	:= xFilial( "CTD" )
			nCTDOrder	:= RetOrder( "CTD" , "CTD_FILIAL+CTD_ITEM" )
			CTD->( dbSetOrder( nCTDOrder ) )
			//Grava a 4a Visao
			IF CTD->( dbSeek( cCTDFilial + c4aVisao  , .F. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_XVISCTB" , c4aVisao , .T. )
			EndIF
		EndIF	

		PutToFrom( @aFromTo , "C7_XEQUIPA" , "C8_XEQUIPA" )
		PutToFrom( @aFromTo , "C7_XCLIORG" , "C8_XCLIORG" )
		PutToFrom( @aFromTo , "C7_XCONTAT" , "C8_XCONTAT" )
		PutToFrom( @aFromTo , "C7_XENDER"  , "C8_XENDER"  )
		PutToFrom( @aFromTo , "C7_XCODSBM" , "C8_XCODSBM" )
		PutToFrom( @aFromTo , "C7_XSBM"    , "C8_XSBM"    )
		PutToFrom( @aFromTo , "C7_XLOJAIN" , "C8_XLOJAIN" )
		PutToFrom( @aFromTo , "C7_XRESPON" , "C8_XRESPON" )
		PutToFrom( @aFromTo , "C7_XCLIINS" , "C8_XCLIINS" )
		PutToFrom( @aFromTo , "C7_XGARA"   , "C8_XGARA"   )
		PutToFrom( @aFromTo , "C7_XMODALI" , "C8_XMODALI" )
		PutToFrom( @aFromTo , "C7_XNUMPRO" , "C8_XNUMPRO" )
		PutToFrom( @aFromTo , "C7_XPROP1"  , "C8_XPROP1"  )
		PutToFrom( @aFromTo , "C7_XMODELO" , "C8_XMODELO" )
		PutToFrom( @aFromTo , "C7_XMARCA"  , "C8_XMARCA"  )
		PutToFrom( @aFromTo , "C7_XPROJET" , "C8_XPROJET" )
		PutToFrom( @aFromTo , "C7_XCODOR"  , "C8_XCODOR"  )
		PutToFrom( @aFromTo , "C7_XSZ2COD" , "C8_XSZ2COD" )
		PutToFrom( @aFromTo , "C7_CC"      , "C8_CC"      )
		PutToFrom( @aFromTo , "C7_CLVL"    , "C8_CLVL"    )
		PutToFrom( @aFromTo , "C7_ITEMCTA" , "C8_ITEMCTA" )
		PutToFrom( @aFromTo , "C7_XTAREFA" , "C8_XTAREFA" )
		PutToFrom( @aFromTo , "C7_CODORCA" , "C8_CODORCA" )
		PutToFrom( @aFromTo , "C7_USERSC"  , "C8_USERSC"  )
		PutToFrom( @aFromTo , "C7_XDESFOR" , "C8_XDESFOR" )
		PutToFrom( @aFromTo , "C7_XREVIS"  , "C8_XREVIS"  )
		PutToFrom( @aFromTo , "C7_XCODGE"  , "C8_XCODGE"  )
		PutToFrom( @aFromTo , "C7_XVISCTB" , "C8_XVISCTB" )
		PutToFrom( @aFromTo , "C7_XREFCNT" , "C8_XREFCNT" )
		PutToFrom( @aFromTo , "C7_XDTPPAG" , "C8_XDTPPAG" )
		PutToFrom( @aFromTo , "C7_UM"      , "C8_UM"      )
		
        StaticCall( NDJLIB001 , NDJFromTo , "SC8" , "SC7" , @aFromTo )

		cC7Descri	:= PosAlias( "SB1" , SC7->C7_PRODUTO , NIL , "B1_DESC" , RetOrder( "SB1" , "B1_FILIAL+B1_COD" ) , .F. )
        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_DESCRI" , cC7Descri , .T. )

        StaticCall( NDJLIB001 , PutIncHrs , "SC7" )

        SC7->( aAdd( __aNDJSC7Reg , Recno() ) )

	END SEQUENCE

	RestArea( aArea )

Return( NIL )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁPutToFrom        ЁAutorЁMarinaldo de JesusЁ Data Ё23/11/2010Ё
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁCarrega o Array para o De Para							    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico												    Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function PutToFrom( aFromTo, cTo , cFrom )
	aAdd( aFromTo, { cFrom , cTo } )
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