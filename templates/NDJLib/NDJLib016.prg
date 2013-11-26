#INCLUDE "NDJ.CH"
/*/
	Funcao: 	FindMsObject
	Autor:		Marinaldo de Jesus
	Data:		17/04/2011
	Uso:		Retornar Array com os Objetos conforme cMsClassName
    Sintaxe:    StaticCall( NDJLIB016 , FindMsObject , cMsClassName , oWnd )
/*/
Static Function FindMsObject( cMsClassName , oWnd )

	Local aMsObject	:= {}

	TRYEXCEPTION
	
		DEFAULT oWnd := GetWndDefault()
		
		IF !( ValType( oWnd ) == "O" )
			BREAK
		EndIF
		
		IF !( ValType( cMsClassName ) == "C" )
			BREAK
		EndIF

		cMsClassName	:= Upper( cMsClassName )
		aMsObject		:= FindObject( @oWnd , @cMsClassName )
		AddObj( @oWnd , @cMsClassName , @aMsObject )

	ENDEXCEPTION

Return( aMsObject )

/*/
	Funcao: 	FindObject
	Autor:		Marinaldo de Jesus
	Data:		17/04/2011
	Uso:		Retornar Array com os Objetos conforme cMsClassName
/*/
Static Function FindObject( oWnd , cMsClassName , aMsObject )
	
	Local aChild
	Local aControls

	Local nChild
	Local nChilds
	Local nControl
	Local nControls
	
	Local oChild

	DEFAULT aMsObject := {}
	
	BEGIN SEQUENCE

		aControls	:= oWnd:aControls

		IF ( aControls == NIL )
			AddObj( @oWnd , @cMsClassName , @aMsObject )
			oChild := oWnd:oWnd
			IF !( oChild == NIL )
				AddObj( @oChild , @cMsClassName , @aMsObject )
				FindObject( @oChild , @cMsClassName , @aMsObject )	
			EndIF	
			BREAK
		EndIF

		nControls	:= Len( aControls )
		For nControl := 1 To nControls
			oChild := aControls[ nControl ]
			IF ( oChild == NIL )
				Loop
			EndIF
			AddObj( @oChild , @cMsClassName , @aMsObject )
			TRYEXCEPTION
				aChild	:= oChild:aControls 
				IF !( aChild == NIL )
					nChilds := Len( aChild )
					For nChild := 1 To nChilds
						oChild := aChild[ nChild ]
						IF !( oChild == NIL )
							IF ( oChild == NIL )
								Loop
							EndIF
							AddObj( @oChild , @cMsClassName , @aMsObject )
							FindObject( @oChild , @cMsClassName , @aMsObject )	
						EndIF	
					Next nChild
				EndIF		
			ENDEXCEPTION
		Next nControl

		oChild := oWnd:oWnd
		IF !( oChild == NIL )
			AddObj( @oChild , @cMsClassName , @aMsObject )
			FindObject( @oChild , @cMsClassName , @aMsObject )	
		EndIF	

	END SEQUENCE

Return( aMsObject )

/*/
	Funcao: 	AddObj
	Autor:		Marinaldo de Jesus
	Data:		17/04/2011
	Uso:		Adicionar o Objeto 
/*/
Static Function AddObj( oObj , cMsClassName , aMsObject )

	Local cClassName	:= Upper( oObj:ClassName() )
	
	Local lAddObj		:= .F.

	IF ( cClassName == cMsClassName )
		IF ( lAddObj := ( aScan( aMsObject , { |oFind| ( oFind == oObj ) } ) == 0 ) )
			aAdd( aMsObject , oObj )
		EndIF
	EndIF

Return( lAddObj )

/*/
	Funcao: 	GetOctlFocus
	Autor:		Marinaldo de Jesus
	Data:		26/06/2011
	Uso:		Retorna o Objeto Ativo
/*/
Static Function GetOctlFocus( oWnd )

	Local oCtlFocus

	TRYEXCEPTION
	
		DEFAULT oWnd := GetWndDefault()
		
		IF !( ValType( oWnd ) == "O" )
			BREAK
		EndIF

		oCtlFocus	:= oWnd:oCtlFocus

	ENDEXCEPTION

Return( oCtlFocus )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		FindMsObject()
		FindObject()
		GetOctlFocus()
		lRecursa	:= __Dummy( .F. )
		SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )