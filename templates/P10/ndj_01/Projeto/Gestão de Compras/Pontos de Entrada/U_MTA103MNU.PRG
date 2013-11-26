#INCLUDE "NDJ.CH"
/*/
	Funcao:		MTA103MNU
	Autor:		Marinaldo de Jesus
	Data:		06/11/2011
	Descricao:	Implementacao do Ponto de Entrada MTA103MNU executado na funcao MENUDEF
				do programa MATA103 Adicao de nova opcao no menu aRotina
/*/
User Function MTA103MNU()

	Local aMenuPopUp		:= {}
	
	Local laRotina			:= ( Type( "aRotina" ) == "A" )

	Local oException

	Local nIndex			:= 0

	TRYEXCEPTION

		StaticCall( NDJLIB004 , SetPublic , "cNDJSF1FMbr" , 0 , "C" , 0 , .F. )
        
		IF !( laRotina )
			BREAK
		EndIF

		//Adiciona Filtro Customizado
		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Filtrar Legenda" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA140MNU , SF1FiltLeg )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Limpar Filtro" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA140MNU , MbrRstFilter )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
        aRotina[ nIndex ][1]    := "Filtro &NDJ"
		aRotina[ nIndex ][2]	:= aMenuPopUp
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 1

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa := __Dummy( .F. )
		__cCRLF		:= NIL	
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )