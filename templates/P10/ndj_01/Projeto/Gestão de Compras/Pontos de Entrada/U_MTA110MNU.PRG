#INCLUDE "NDJ.CH"

/*/
	Funcao:		MTA110MNU
	Autor:		Marinaldo de Jesus
	Data:		07/01/2011
	Descricao:	Ponto de Entrada MTA110MNU, executado na MATA110, na MenuDef, sera utilizado alterar as Opcoes do aRotina
/*/
User Function MTA110MNU()

	Local aNewRot
	Local aMenuPopUp
	Local aFunctions

	Local cFunction

	Local nBL
	Local nEL

	Local nBPop
	Local nEPop

	Local nPrg
	Local nPrgs
	Local nIndex

	TRYEXCEPTION
	
		IF !( Type( "aRotina" ) == "A" )
			BREAK
		EndIF

        StaticCall( NDJLIB004 , SetPublic , "cNDJSC1FMbr" , 0 , "C" , 0 , .F. )

        IF ( IsInCallStack( "NDJShwSC" ) )

			aNewRot		:= {}
			aFunctions	:= { "PesqBrw" , "A110Visual" , "A110Legenda" }

			nPrgs 		:= Len( aFunctions )
			For nPrg := 1 To nPrgs
				cFunction	:= aFunctions[ nPrg ]
				nIndex		:= aScan( aRotina , { |aElem| Upper( cFunction ) $ Upper( aElem[2] ) } )
				IF ( nIndex > 0 )
					aAdd( aNewRot , aClone( aRotina[ nIndex ] ) )
				EndIF	
			Next nPrg

			aRotina := aNewRot

			BREAK

		EndIF
        
		IF !( IsInCallStack( "__A220TOSC" ) )
		
			nEL := Len( aRotina )
			For nBL := 1 To nEL
				IF ( aRotina[ nBL ][ 2 ] == "A" )
					nEPop := Len( aRotina[ nBL ][ 2 ] )
					For nBPop := 1 To nEPop
						cExecute := "StaticCall( U_MTA110MNU , MATA110 , Alias() , (Alias())->(Recno()) , " + Str( aRotina[ nBL ][ 2 ][ nEPop ][ 4 ] ) + ",'" + aRotina[ nBL ][ 2 ][ nEPop ][ 2 ] + "' )"
						aRotina[ nBL ][ 2 ][ nEPop ][ 2 ] := cExecute
					Next nBPop
				Else
					cExecute := "StaticCall( U_MTA110MNU , MATA110 , Alias() , (Alias())->(Recno()) , " + Str( aRotina[ nBL ][ 4 ] ) + ",'" + aRotina[ nBL ][ 2 ] + "' )"
					aRotina[ nBL ][ 2 ]	:= cExecute
				EndIF
			Next nBL

		EndIF
	
		aMenuPopUp	:= {}

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Filtrar Anexos" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA110MNU , SC1FromAC9 )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3
  
		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Filtrar Legenda" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA110MNU , SC1FiltLeg )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Limpar Filtro" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA110MNU , MbrRstFilter )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
        aRotina[ nIndex ][1]    := "Filtro &NDJ"
		aRotina[ nIndex ][2]	:= aMenuPopUp
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 1

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
		aRotina[ nIndex ][1]	:= "Hist. Suspensão"
		aRotina[ nIndex ][2]	:= "StaticCall( U_MTA110MNU , SC1HistSusp )"
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 2

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION		

Return( NIL )

/*/
	Funcao:		MATA110
	Autor:		Marinaldo de Jesus
	Data:		20/03/2011
	Descricao:	Chamada as Rotinas do menu
	Sintaxe:	StaticCall( U_MTA110MNU , MATA110 , cAlias , nReg , nOpc , cExecute )
/*/
Static Function MATA110( cAlias , nReg , nOpc , cExecute )

	Local uRet

	aRotSetOpc( cAlias , @nReg , nOpc )

	IF ( "(" $ cExecute )
		uRet	:= &cExecute
	Else
		uRet	:= &cExecute.( @cAlias , @nReg , @nOpc )
	EndIF

	//Forca o Commit dos Destinos da SC1
    StaticCall( U_NDJA001 , SZ2SZ3Commit )

	//Libera os Locks Pendentes
    StaticCall( NDJLIB003 , AliasUnLock )

Return( uRet )

/*/
	Funcao:		SC1FromAC9
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Filtra o Browse com as SCs que possuem anexo
/*/
Static Function SC1FromAC9()
    cNDJSC1FMbr := StaticCall( U_MATA110C , AC9SC1SetFilter )
Return( cNDJSC1FMbr )

/*/
	Funcao:		SC1FiltLeg
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Filtra o Browse de acordo com a Opcao da Legenda da mBrowse
/*/
Static Function SC1FiltLeg()

	Local aGetSc1
	Local aColors
	Local aLegend

	Local cSvExprFilTop

	aGetSc1			:= StaticCall( U_MT110COR , GetC1Status , "SC1" , NIL , .T. )
	aColors			:= aGetSc1[1]
	aLegend			:= aGetSc1[2]

    cSvExprFilTop    := StaticCall( NDJLIB001 , BrwFiltLeg , "SC1" , @aColors , @aLegend , "Solicitação de Compras" , "Legenda" , "Duplo Clique para ativar o Filtro" , "cNDJSC1FMbr" )

Return( cSvExprFilTop )

/*/
	Funcao:		SC1HistSusp
	Autor:		Marinaldo de Jesus
	Data:		04/05/2011
	Descricao:	Apresenta o Historico de Suspensao da SC
/*/
Static Function SC1HistSusp()

	Local aFixe				:= {}
	Local aArea				:= GetArea()
	Local aSC1Area			:= SC1->( GetArea() )
	
	Local cExprFilTop

	Local nFixe				:= 0
	Local nIndex			:= 0
	Local nSZ6Order			:= RetOrder( "SZ6" , "Z6_FILIAL+Z6_NUMSC" )

	Private aRotina			:= {}
	
	Private aGets
	Private aTela
	
	Private cCadastro		:= "Histórico de Suspensão de Solicitação de Compras"

	aAdd( aRotina , Array( 4 ) )
	nIndex 	:= Len( aRotina )
	aRotina[ nIndex ][1]	:= "Pesquisar"
	aRotina[ nIndex ][2]	:= "PesqBrw"
	aRotina[ nIndex ][3]	:= 0
	aRotina[ nIndex ][4]	:= 1

	aAdd( aRotina , Array( 4 ) )
	nIndex 	:= Len( aRotina )
	aRotina[ nIndex ][1]	:= "Visualizar"
	aRotina[ nIndex ][2]	:= "AxVisual"
	aRotina[ nIndex ][3]	:= 0
	aRotina[ nIndex ][4]	:= 2

	SZ6->( dbSetOrder( nSZ6Order ) )

    cExprFilTop 	:= "Z6_NUMSC='" + SC1->C1_NUM + "' AND Z6_SUSPNSC='T'"
    cNDJSC1FMbr        := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

	SetMBTopFilter( "SC1" , ""  )
	SetMBTopFilter( "SZ6" , cExprFilTop , .F. )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_NUMSC" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_NUMSC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_NUMSC" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_NUMSC" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_NUMSC" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_NUMSC" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ITEMSC" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_ITEMSC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ITEMSC" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ITEMSC" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ITEMSC" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ITEMSC" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_USER" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_USER"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_USER" , "X3_TIPO" 	  )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_USER" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_USER" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_USER" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DUSER" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_DUSER"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DUSER" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DUSER" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DUSER" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DUSER" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DATA" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_DATA"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DATA" , "X3_TIPO" 	  )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DATA" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DATA" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DATA" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_HORA" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_HORA"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_HORA" , "X3_TIPO" 	  )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_HORA" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_HORA" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_HORA" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_OBS" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_OBS"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_OBS" , "X3_TIPO" 	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_OBS" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_OBS" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_OBS" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_SUSPNSC" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_SUSPNSC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_SUSPNSC" , "X3_TIPO" 	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_SUSPNSC" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_SUSPNSC" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_SUSPNSC" , "X3_PICTURE" )

    mBrowse( 6 , 1 , 22 , 75 , "SZ6" , @aFixe , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , @cExprFilTop )

	CursorWait()

	MbrRstFilter()	

	IF ( Type( "bFiltraBrw" ) == "B" )
		IF ( "SC1" $ GetCbSource( bFiltraBrw ) )
			Eval( bFiltraBrw )
		EndIF
	EndIF

	RestArea( aSC1Area )
	RestArea( aArea )

	CursorArrow()

Return( NIL )

/*/
	Funcao:		MbrRstFilter
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( NDJLIB001 , MbrRstFilter , "SC1" , "cNDJSC1FMbr" ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	SC1FromAC9()
    	SC1FiltLeg()
    	MbrRstFilter()
    	SC1HistSusp()
    	MATA110()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )