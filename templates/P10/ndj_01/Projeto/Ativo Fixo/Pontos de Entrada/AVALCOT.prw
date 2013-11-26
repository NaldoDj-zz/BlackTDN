#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AVALCOT  º Autor ³ Jose Carlos Noronhaº Data ³  15/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada executado na Análise da Cotação de Comprasº±±
±±             que será utilizado para levar as informações da tabela de  º±±
±±             Cotação de Compras(SC8) para a tabela de Pedido de Compras º±±
±±             (SC7).                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function AVALCOT()

	Local aArea		:= GetArea()
	Local aFromTo	:= {}
	
	Local c4aVisao
	Local cFornece
	Local cCTDFilial

	Local nOpc		:= ParamIXB[1] 
	Local nCTDOrder

	BEGIN SEQUENCE
	
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

        StaticCall( NDJLIB001 , NDJFromTo , "SC8" , "SC7" , @aFromTo )
        StaticCall( NDJLIB001 , PutIncHrs , "SC7" )

		AddRegSC7()

	END SEQUENCE

	RestArea( aArea )

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³PutToFrom        ³Autor³Marinaldo de Jesus³ Data ³23/11/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Carrega o Array para o De Para							    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function PutToFrom( aFromTo, cTo , cFrom )
	aAdd( aFromTo, { cFrom , cTo } )
Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³AddRegSC7		 ³Autor³Marinaldo de Jesus³ Data ³29/12/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Armazenar os Recnos da SC7 para Futura Distribuicao			³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function AddRegSC7()

	Local oException

	TRYEXCEPTION

        StaticCall( NDJLIB004 , SetPublic , "__aNDJSC7Reg" , NIL , "A" , 0 )

        SC7->( aAdd( __aNDJSC7Reg , Recno() ) )

	CATCHEXCEPTION USING oException 
	
		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			cMsgHelp += CRLF
			cMsgHelp += oException:ErrorStack
			ConOut( cMsgHelp )
		EndIF	

	ENDEXCEPTION

Return( NIL )
