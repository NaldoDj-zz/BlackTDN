#INCLUDE "NDJ.CH"
/*/
	Funcao: U_MATRKBUT
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Implementacao do Ponto de Entrada MATRKBUT no Programa TRKXFUN, funcao MaTrkShow.
			Sera utilizado para adicionar novo botao que permitira ao usuario efetuar "Auditoria" 
			nos Processos de compras informando quem foi o usuario que Incluiu e/ou Alterou determinado
			Item durante o Processo.
/*/
User Function MATRKBUT()

	Local aButtons 		:= {}
	
	Local bController	:= { || Controller() }
	
 	Local lController	:= ( IsInCallStack( "MaTrkShow" ) )

	BEGIN SEQUENCE

		IF !( lController )
			BREAK
		EndIF

		aAdd( aButtons , { OemToAnsi( "Auditoria" ) , bController  } )

	END SEQUENCE

Return( aButtons )

/*/
	Funcao: Controller
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Usada na U_MATRKBUT efetuar o processo de "Auditoria"
/*/
Static Function Controller()

	Local aArea			:= GetArea()
	Local aTrackerAlias	:= GetAliasTracker()
	Local aTrackerAreas	:= {}

	Local cTreeAlias

	Local lController	:= .T.
	
	Local nLoop
	Local nLoops
	Local nTreeRecno
	
	Local oException

	nLoops := Len( aTrackerAlias )
	For nLoop := 1 To nLoops
		TRYEXCEPTION 
			IF ( Select( aTrackerAlias[ nLoop ] ) > 0 )
				aAdd( aTrackerAreas , ( aTrackerAlias[ nLoop ] )->( GetArea() ) )
			EndIF	
		CATCHEXCEPTION USING oException
		ENDEXCEPTION	
	Next nLoop

	BEGIN SEQUENCE

		MSAguarde( { || lController	:= IsTreeMounted( @cTreeAlias ) } , "Aguarde..." , "Localizando Tabela System Tracker" , .F. )
		IF !( lController )
			MsgInfo( OemToAnsi( "'System Tracker' ainda não carregada." + CRLF + CRLF + "Utilize o Botão Rastrear Para obter a Tabela 'System Tracker' antes de efetuar a Auditoria." ) , OemToAnsi( "Atenção" )  )
			BREAK
		EndIF

		nTreeRecno	:= ( cTreeAlias )->( Recno() )

		ShowController( @cTreeAlias )

		( cTreeAlias )->( MsGoto( @nTreeRecno ) )

	END SEQUENCE

	nLoops := Len( aTrackerAreas )
	For nLoop := 1 To nLoops
		RestArea( aTrackerAreas[ nLoop ] )
	Next nLoop

	RestArea( aArea )

Return( lController )

/*/
	Funcao: IsTreeMounted
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Usada na U_MATRKBUT para verificar se o Tree do Processo de Pedido ja foi montado
/*/
Static Function IsTreeMounted( cTreeAlias )
	Local aTreeFields	:= { "T_IDLIST" , "T_IDTREE" , "T_IDCODE" , "T_ISTREE" , "T_PROMPT" , "T_CARGO" , "T_BMP001" , "T_BMP002" , "T_CLIENT"  } 
Return( StaticCall( NDJLIB001 , GetAlias4Fields , @cTreeAlias , @aTreeFields ) )

/*/
	Funcao: Decrypt
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Usada na U_MATRKBUT para Obter as informacoes dos campos _USERLGI e _USERLGA
/*/
Static Function ULGDecrypt( cUserLG )
Return( StaticCall( NDJLIB014 , ULGDecrypt , @cUserLG ) )

/*/
	Funcao: ShowController
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Mostrar o Tree do Tracker com informacoes dos Usuarios que Incluiram e/ou Alteraram o Item
/*/
Static Function ShowController( cTreeAlias )

	Local aArea		:= GetArea()
	Local aSize		:= MsAdvSize( .F. )
	Local aPosObj	:= {}
	Local aObjects	:= {}
	Local adbStruct	:= (cTreeAlias)->( dbStruct() )

	Local bCloseDlg	:= { || oTree:End() , oTree := NIL , oDlg:End() }

	Local nFields	:= Len( adbStruct )
	Local nLenTxt   := Len( (cTreeAlias)->T_PROMPT )
	Local nLenCargo	:= Len( (cTreeAlias)->T_CARGO )	
	
	Local oDlg
	Local oTree
	Local oMenuTree

	BEGIN SEQUENCE

		aSize		:= MsAdvSize( .T. )
		aObjects	:= {}
		aAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo		:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj		:= MsObjSize( aInfo, aObjects, .T., .T. )
	
		DEFINE MSDIALOG oDlg FROM aSize[7],0 TO aSize[6],aSize[5] TITLE "System Tracker Controller" OF oMainWnd PIXEL STYLE DS_MODALFRAME
			
			oTree 			:= dbTree():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],oDlg,NIL,NIL,.T.)
			
			oTree:BuildTrb( @nLenTxt , @nLenCargo )

			oTree:lShowHint := .F.

			MENU oMenuTree POPUP
				MENUITEM "Visualizar"	ACTION MSAguarde( { || MaPrepView( @oTree ) } , "Aguarde..." , "Obtendo Informações" , .F. )
				MENUITEM "Abandonar"	ACTION Eval( bCloseDlg )
			ENDMENU
			
			oTree:bRClicked := { |oObject,nx,ny| oMenuTree:Activate( nX, nY - 145, oObject ) }

			MSAguarde( { || MergeTree( @cTreeAlias , @oTree , @nFields ) } , "Aguarde..."  , "Efetuando Auditoria" , .F. )
			
			oDlg:lEscClose := .F.
	
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnChoiceBar( oDlg , bCloseDlg , bCloseDlg )

	END SEQUENCE	

	RestArea( aArea )

Return( .T. )

/*/
	Funcao: MergeTree
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Montar os Itens do Tree de Auditoria
/*/
Static Function MergeTree( cTreeAlias , oTree , nFields )

	Local aRecnos		:= {}

	Local cAlias
	Local cResName
	Local cT_CargoNew	:= Replicate( "0" , Len( ( cTreeAlias )->( T_CARGO ) ) )
	
	Local nLoop
	Local nLoops
	Local nField
	Local nRecno

	Local uCntPut

	( cTreeAlias )->( dbGoTop() )
	While ( cTreeAlias )->( !Eof() )
		IF ( oTree:cArqTree )->( RecLock( oTree:cArqTree , .T. ) ) 
			For nField := 1 To nFields
				uCntPut := ( cTreeAlias )->( FieldGet( nField ) )
				( oTree:cArqTree )->( FieldPut( nField , uCntPut ) )
			Next nField
			( oTree:cArqTree )->( T_CLIENT := "N" )
			( oTree:cArqTree )->( MsUnLock() )
			++oTree:nCodeAtu
			++oTree:nTotal
			aAdd( aRecnos , ( oTree:cArqTree )->( Recno() ) )
		EndIF
		( cTreeAlias )->( dbSkip() )
	End While

	nLoops := Len( aRecnos )
	For nLoop := 1 To nLoops
		nRecno		:= aRecnos[ nLoop ]
		( oTree:cArqTree )->( dbGoto( nRecno ) )
		cAlias		:= ( oTree:cArqTree )->( SubStr( T_CARGO  , 1 , 3 ) )
		cResName	:= MaEntImage( cAlias , 1 )
		( oTree:cArqTree )->( oTree:ChangeBmp( cResName , cResName , NIL , NIL , T_CARGO ) )
		AddUserLg( @oTree:cArqTree , @nRecno , @oTree , @cT_CargoNew )
	Next nLoop

	IF ( nLoops > 0 )
		( oTree:cArqTree )->( dbGoto( aRecnos[ 1 ] ) )
		( oTree:cArqTree )->( oTree:TreeSeek( T_CARGO ) )
	EndIF	

	oTree:Refresh()

Return( .T. )

/*/
	Funcao: MyMaPrepView
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Baseada na MaPrepView posiciona no registro
/*/
Static Function MyMaPrepView( oTree , cAlias , cChave )

	Local cT_Cargo	:= ( oTree:cArqTree )->( T_CARGO  )
	Local cT_cAlias	:= SubStr( cT_Cargo , 1 , 3 )

	Local lRet      := .T.
	Local nTamChave := 0

	DEFAULT cAlias	:= cT_cAlias
	DEFAULT cChave	:= cT_Cargo

	Do Case
		Case ( ( cAlias == "AB2" ) .or. ( cAlias == "AB1" ) )
			AB1->( dbSetOrder( 1 ) )
			lRet := AB1->( dbSeek( xFilial( "AB1" ) + SubStr( cChave, 5, 8 ) ) )
		Case ( cAlias == "AB4" )
			AB3->( dbSetOrder( 1 ) )
			lRet := AB3->( dbSeek( xFilial( "AB3" ) + SubStr( cChave, 5, 6 ) ) )
		Case ( cAlias == "AB7" )
			AB6->( dbSetOrder( 1 ) )
			lRet := AB6->( dbSeek( xFilial( "AB6" ) + SubStr( cChave, 5, 6 ) ) )
		Case ( cAlias == "AB9" )
			AB9->( dbSetOrder( 1 ) )
			lRet := AB9->( dbSeek( xFilial( "AB9" ) + Substr( cChave, 5, 16 ) ) )
		Case ( cAlias == "ABK" )
			ABK->( dbSetOrder( 1 ) )
			lRet := ABK->( dbSeek( xFilial( "ABK" ) + Substr( cChave, 5, 12 ) ) )
		Case ( cAlias == "ABL" )
			ABL->( dbSetOrder( 1 ) )
			lRet := ABL->( dbSeek( xFilial( "ABL" ) + Substr( cChave, 5, 10 ) ) )
		Case ( cAlias == "ABI" )
			ABH->( dbSetOrder( 1 ) )
			lRet := ABH->( dbSeek( xFilial( "ABH" ) + Substr( cChave, 5, 6 ) ) )
		Case ( cAlias == "SC2"  )
			SC2->( dbSetOrder( 1 ) )
			lRet := SC2->( dbSeek( xFilial( "SC2" ) + Substr( cChave, 5, Len(SD3->D3_OP) ) ) )
		Case ( ( cAlias == "SC6" ) .or. ( cAlias == "SC5" ) )
			SC5->( dbSetOrder( 1 ) )
			lRet := SC5->( dbSeek( xFilial( "SC5" ) + Substr( cChave, 5, 6 ) ) )
		Case ( ( cAlias == "CN9" ) .or. ( cAlias == "N9H" ) )
			CN9->( dbSetOrder( 1 ) )
			lRet := CN9->( dbSeek( xFilial( "CN9" ) + Substr( cChave, 5, Len( CN9_REVISA + CN9_NUMERO ) ) ) )
			IF ( Select( "N9H" ) == 0 )
				cAlias	:= "CN9"
			EndIF
		Case ( ( cAlias == "CNA" ) .or. ( cAlias == "CNB" ) )
			nTamChave := Len( CNA->( CNA_CONTRA+ CNA_REVISA + CNA_NUMERO ) )
			CNA->( dbSetOrder( 1 ) )
			lRet := CNA->( dbSeek( xFilial( "CNA" ) + Substr( cChave, 5,  24 ) ) )
		Case ( ( cAlias == "CND" ) .or. ( cAlias == "CNE" ) )
			nTamChave := Len( CND->( CND_CONTRA + CND_REVISA + CND_NUMERO + CND_NUMMED ) )
			CND->( dbSetOrder( 1 ) )
			lRet := CND->( dbSeek( xFilial( "CND" ) + Substr( cChave, 5, 30 ) ) )
		Case ( ( cAlias == "ADA" ) .or. ( cAlias == "ADB" ) )
			ADA->( dbSetOrder( 1 ) )
			lRet := ADA->( dbSeek( xFilial( "ADA" ) + Substr( cChave, 5, 6 ) ) )
		Case ( cAlias == "ABF" )
			ABF->( dbSetOrder( 1 ) )
			lRet := ABF->( dbSeek( xFilial( "ABF" ) + Substr( cChave, 5, 10 ) ) )
		Case ( cAlias == "ABB" )
			AB6->( dbSetOrder( 1 ) )
			lRet := AB6->( dbSeek( xFilial( "AB6" ) + SubStr( cChave, 5, 6 ) ) )
		Case ( ( cAlias == "SD2" ) .or. ( cAlias == "SF2" ) )
			SD2->( dbSetOrder( 3 ) )
			nTamChave := Len( SD2->( D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) )
			lRet := SD2->( dbSeek( xFilial( "SD2" ) + SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SD3" )
			SD3->(dbGoto(Val(Substr(cChave,5+Len(SD3->D3_NUMSEQ),10))))
			lRet := (SD3)->( !Eof() )
		Case ( cAlias == "SC9" )
			nTamChave := Len( SC9->( C9_PEDIDO + C9_ITEM + C9_SEQUEN ) )
			SC9->( dbSetOrder( 1 ) )
			lRet := SC9->( dbSeek( xFilial( "SC9" ) + SubStr( cChave, 5, nTamChave ) ) )
		Case ( ( cAlias == "SCK" ) .or. ( cAlias == "SCJ" ) )
			SCJ->( dbSetOrder( 1 ) )
			lRet := SCJ->( dbSeek( xFilial( "SCJ" ) + SubStr( cChave, 5, 6 ) ) )
		Case ( cAlias == "AD1" )
			AD1->( dbSetOrder( 1 ) )
			lRet := AD1->( dbSeek( xFilial( "AD1" ) + SubStr( cChave, 5, 6 ) ) )
		Case ( ( cAlias == "AAN" ) .or. ( cAlias == "AAO" ) .or. ( cAlias == "AAP" ) )
			AAM->( dbSetOrder( 1 ) )
			nTamChave := Len( AAM->AAM_CONTRT )
			lRet := AAM->( dbSeek( xFilial( "AAM" ) + SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SC0" )
			SC0->( dbSetOrder( 1 ) )
			nTamChave := Len( SC0->C0_NUM )
			lRet := SC0->( dbSeek( xFilial( "SC0" ) + SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SE1" )
			SE1->( dbSetOrder( 2 ) )
			nTamChave := Len( SE1->( E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO ) )
			lRet := SE1->( dbSeek( xFilial( "SE1" ) + SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SE2" )
			SE2->( dbSetOrder( 6 ) )
			nTamChave := Len( SE2->( E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA ) )
			lRet := SE2->( dbSeek( SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SCN" )
			nTamChave :=  Len( SCN->( CN_REMITO + CN_ITEM) )
			SCN->( dbSetOrder(1 ) )  // Pesquisa por remito
			lRet := SCN->( dbSeek( xFilial( "SCN" ) + SubStr( cChave, 5 + Len(SCN->( CN_PEDIDO + CN_ITEMPED + CN_CLIENTE + CN_LOJA) ),nTamChave) )  )
		Case ( ( cAlias == "SUA" ) .or. ( cAlias == "SUB" ) )
			nTamChave :=  Len( SUA->UA_NUM)
			SUA->( dbSetOrder(1 ) )  // Pesquisa por Atendimento - Televendas
			lRet := SUA->( dbSeek( xFilial( "SUA" ) + SubStr( cChave, 5,nTamChave) )  )
		Case ( cAlias == "SC1" )
			SC1->( dbSetOrder( 1 ) )
			lRet := SC1->( dbSeek( Substr( cChave, 5, 8 ) ) )
		Case ( cAlias == "SC3" )
			SC3->( dbSetOrder( 1 ) )
			lRet := SC3->( dbSeek( Substr( cChave, 5, 8 ) ) )
		Case ( cAlias == "SC7" )
			SC7->( dbSetOrder( 14 ) )
			lRet := SC7->( dbSeek( Substr( cChave, 5, 8 ) ) )
		Case ( cAlias == "SCR" )
			SCR->( dbSetOrder( 2 ) )    
			cChave := Substr(cChave,5,4) + Pad(Substr(cChave,9,6),Len(SCR->CR_NUM))+Substr(cChave,15,6)
			lRet := SCR->( dbSeek(cChave) )
		Case ( cAlias == "SC8" )
			SC8->( dbSetOrder( 1 ) )
			nTamChave := Len( SC8->C8_FILIAL ) + Len( SC8->C8_NUM )  
	 		lRet := SC8->( dbSeek(  Substr( cChave, 5, nTamChave ) ) )
		Case ( ( cAlias == "SD1" ) .or. ( cAlias == "SF1" ) )
			SD1->( dbSetOrder( 1 ) )
			nTamChave := Len( SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA ) )
			lRet := SD1->( dbSeek( SubStr( cChave, 5, nTamChave ) ) )
		Case ( cAlias == "SA1" )
			nTamChave :=  SA1->( Len(A1_COD)+Len(A1_LOJA) )
			SA1->( dbSetOrder( 1 ) )
			lRet := SA1->( dbSeek( xFilial( "SA1" ) + SubStr( cChave, 5,nTamChave) )  )
		Case ( cAlias == "SUS" )
			nTamChave :=  SUS->( Len(US_COD)+Len(US_LOJA) )
			SUS->( dbSetOrder( 1 ) )
			lRet := SUS->( dbSeek( xFilial( "SUS" ) + SubStr( cChave, 5,nTamChave) )  )
		Case ( cAlias == "ACH" )
			nTamChave := ACH->( Len(ACH_CODIGO)+Len(ACH_LOJA) )
			ACH->( dbSetOrder( 1 ) )
			lRet := ACH->( dbSeek( xFilial( "ACH" ) + SubStr( cChave, 5,nTamChave) )  )
		Case ( cAlias == "DAI" )
			nTamChave := DAK->( Len(DAK_COD)+Len(DAK_SEQCAR) )
			DAK->( dbSetOrder( 1 ) )
			lRet := DAK->( dbSeek( xFilial( "DAK" ) + Substr( cChave, 5, nTamChave ) ) )
		Otherwise
			lRet := .F.
	EndCase

Return( lRet )

/*/
	Funcao: AddUserLg
	Autor:	Marinaldo de Jesus
	Data:	25/10/2010
	Uso:	Adicionar o Usuario que Incluiu ou Alterou determinado Item
/*/
Static Function AddUserLg( cTreeAlias , nRecno , oTree , cT_CargoNew )

	Local aUserLGI
	Local aUserLGA

	Local cAlias
	Local cUserLG
	Local cKeySeek
	Local cT_Cargo
	Local cT_Prompt
	Local cPrefixCpo

	Local nKeyLen
	Local nUserLgI
	Local nUserLgA
	Local nXIncHrs
	Local nXAltHrs

	BEGIN SEQUENCE

		( cTreeAlias )->( MsGoto( nRecno  ) )

		cT_Cargo	:= ( cTreeAlias )->( T_CARGO  )
		cAlias		:= SubStr( cT_Cargo , 1 , 3 )

		IF !( MyMaPrepView( @oTree , @cAlias , @cT_Cargo ) )
			BREAK
		EndIF

		nKeyLen 	:= ( cAlias )->( Len( &( IndexKey() ) ) )
		cKeySeek	:= SubStr( cT_Cargo , 5 , nKeyLen )

		IF !( ( cAlias )->( dbSeek( cKeySeek , .F. ) ) )
			IF !( MyMaPrepView( @oTree , @cAlias , @cT_Cargo ) )
				BREAK
			EndIF
		EndIF

		cPrefixCpo	:= ( PrefixoCpo( cAlias  ) + "_" )

		nUserLgI	:= ( cAlias )->( FieldPos( cPrefixCpo+"USERLGI" ) )
		IF ( nUserLgI > 0 )
			cUserLG	:= ( cAlias )->( FieldGet( nUserLgI ) )
			IF !Empty( cUserLG )
				aUserLGI	:= ULGDecrypt( cUserLG )
				( cTreeAlias )->( oTree:TreeSeek( T_CARGO ) )
				cT_Prompt 	:= OemToAnsi( "Incluido Por: " ) + AllTrim( aUserLGI[1] ) + " em: " + DtoC( aUserLGI[2] , "DDMMYYYY" )
				nXIncHrs	:= ( cAlias )->( FieldPos( cPrefixCpo+"XINCHRS" ) )
				IF ( nXIncHrs > 0 )
					cT_Prompt 	+= " " 
					cT_Prompt 	+= ( cAlias )->( FieldGet( nXIncHrs ) )
				EndIF
				cT_CargoNew	:= __Soma1( cT_CargoNew )
				( cTreeAlias )->( oTree:AddItem( cT_Prompt , cT_CargoNew , "ADICIONAR_001" , "ADICIONAR_001" , NIL , NIL , 2 ) )
			EndIF	
		EndIF

		( cTreeAlias )->( MsGoto( nRecno  ) )
	
		nUserLgA	:= ( cAlias )->( FieldPos( cPrefixCpo+"USERLGA" ) )
		IF ( nUserLgA > 0 )
			cUserLG := ( cAlias )->( FieldGet( nUserLgA ) )
			IF !Empty( cUserLG )
				aUserLGA := ULGDecrypt( cUserLG )
				( cTreeAlias )->( oTree:TreeSeek( T_CARGO ) )
				cT_Prompt	:= OemToAnsi( "Alterado Por: " ) + AllTrim( aUserLGA[1] ) + " em: " + DtoC( aUserLGA[2] , "DDMMYYYY" )
				nXAltHrs := ( cAlias )->( FieldPos( cPrefixCpo+"XALTHRS" ) )
				IF ( nXAltHrs > 0 )
					cT_Prompt 	+= " " 
					cT_Prompt 	+= ( cAlias )->( FieldGet( nXAltHrs ) )
				EndIF
				cT_CargoNew	:= __Soma1( cT_CargoNew )
				( cTreeAlias )->( oTree:AddItem( cT_Prompt , cT_CargoNew , "ALT_CAD" , "ALT_CAD" , NIL , NIL , 2 ) )
			EndIF
		EndIF 

	END SEQUENCE

Return( NIL )

/*/
	Funcao: GetAliasTracker
	Autor:	Marinaldo de Jesus
	Data:	01/11/2010
	Uso:	Retornar os Alias participantes do Tracker
/*/
Static Function GetAliasTracker()

	Local aAlias := {}

	aAdd( aAlias , "AB2" )
	aAdd( aAlias , "AB1" )
	aAdd( aAlias , "AB4" )
	aAdd( aAlias , "AB3" )
	aAdd( aAlias , "AB7" )
	aAdd( aAlias , "AB6" )
	aAdd( aAlias , "AB9" )
	aAdd( aAlias , "AB9" )
	aAdd( aAlias , "ABK" )
	aAdd( aAlias , "ABL" )
	aAdd( aAlias , "ABI" )
	aAdd( aAlias , "ABH" )
	aAdd( aAlias , "SC2" )
	aAdd( aAlias , "SC6" )
	aAdd( aAlias , "SC5" )
	aAdd( aAlias , "SC5" )
	aAdd( aAlias , "CN9" )
	aAdd( aAlias , "N9H" )
	aAdd( aAlias , "CNA" )
	aAdd( aAlias , "CNB" )
	aAdd( aAlias , "CND" )
	aAdd( aAlias , "CNE" )
	aAdd( aAlias , "CND" )
	aAdd( aAlias , "ADA" )
	aAdd( aAlias , "ADB" )
	aAdd( aAlias , "ABF" )
	aAdd( aAlias , "ABB" )
	aAdd( aAlias , "SD2" )
	aAdd( aAlias , "SF2" )
	aAdd( aAlias , "SD3" )
	aAdd( aAlias , "SC9" )
	aAdd( aAlias , "SCK" )
	aAdd( aAlias , "SCJ" )
	aAdd( aAlias , "AD1" )
	aAdd( aAlias , "AAN" )
	aAdd( aAlias , "AAO" )
	aAdd( aAlias , "AAP" )
	aAdd( aAlias , "SC0" )
	aAdd( aAlias , "SE1" )
	aAdd( aAlias , "SE2" )
	aAdd( aAlias , "SCN" )
	aAdd( aAlias , "SUA" )
	aAdd( aAlias , "SUB" )
	aAdd( aAlias , "SC1" )
	aAdd( aAlias , "SC3" )
	aAdd( aAlias , "SC7" )
	aAdd( aAlias , "SCR" )
	aAdd( aAlias , "SC8" )
	aAdd( aAlias , "SD1" )
	aAdd( aAlias , "SF1" )
	aAdd( aAlias , "SA1" )
	aAdd( aAlias , "SUS" )
	aAdd( aAlias , "ACH" )
	aAdd( aAlias , "DAI" )

Return( aAlias )

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