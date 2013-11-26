#INCLUDE "NDJ.CH"
/*/
	Funcao: PM410ROT
	Autor:	Marinaldo de Jesus
	Data:	07/01/2010
	Uso:	Executada a partir da MenuDefm em PMSA410.
			Sera utilizado para adicionar nova(s) opcao(oes) ao Menu aRotina do Programa PMSA410.PRW.
/*/
User Function PM410ROT()

	Local aRotina
	Local aNewRot
	
	Local cFunction
	
	Local nIndex

	Local oException

	TRYEXCEPTION

        StaticCall( NDJLIB004 , SetPublic , "cNDJAF8FMbr" , "" )

		aRotina	:= IF( Type( "aRotina" ) == "A" , aRotina , {} )
		aNewRot	:= {}

		nIndex := aScan( aRotina , { |aElem| Upper( "PMS410Dlg" ) $ Upper( aElem[2] ) .and. aElem[4] == 4 } )
		IF ( nIndex > 0 )
			aAdd( aNewRot , aClone( aRotina[ nIndex ] ) )
		Else
			aAdd( aNewRot , Array( 4 ) )
			nIndex 		:= Len( aNewRot )
			cFunction	:= "PMS410Dlg"
		EndIF	

		aNewRot[nIndex][1]	:= "Executar Projeto"
		aNewRot[nIndex][2]	:= IF( ( aNewRot[nIndex][2] == NIL ) , cFunction	, aNewRot[nIndex][2] )
		aNewRot[nIndex][3]	:= IF( ( aNewRot[nIndex][3] == NIL ) , 0 			, aNewRot[nIndex][3] )
		aNewRot[nIndex][4]	:= IF( ( aNewRot[nIndex][4] == NIL ) , 4 			, aNewRot[nIndex][4] )

		nIndex := aScan( aRotina , { |aElem| Upper( "PMS410Dlg" ) $ Upper( aElem[2] ) .and. aElem[4] == 2 } )
		IF ( nIndex > 0 )
			aAdd( aNewRot , aClone( aRotina[ nIndex ] ) )
		Else
			aAdd( aNewRot , Array( 4 ) )
			nIndex 		:= Len( aNewRot )
		EndIF	

        cFunction    := "StaticCall(U_PM410ROT,NDJShwSC,'AF8',AF8->(Recno()),2)"

		aNewRot[nIndex][1]	:= "SC do Projeto"
		aNewRot[nIndex][2]	:= cFunction
		aNewRot[nIndex][3]	:= IF( ( aNewRot[nIndex][3] == NIL ) , 0 			, aNewRot[nIndex][3] )
		aNewRot[nIndex][4]	:= IF( ( aNewRot[nIndex][4] == NIL ) , 2 			, aNewRot[nIndex][4] )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( aNewRot )

/*/
    Funcao: NDJShwSC
	Autor:	Marinaldo de Jesus
	Data:	07/01/2010
	Uso:	Disponibilizar as SC de acordo com o Projeto.
/*/
Static Function NDJShwSC( cAlias , nReg , nOpc ) 

	Local aArea			:= GetArea()
	Local aAF8Area		:= AF8->( GetArea() )
	Local aModuloReSet	:= SetModulo( "SIGACOM" , "COM" )
	
	Local uRet

	Local oException

	TRYEXCEPTION

        cNDJAF8FMbr    := StaticCall( NDJLIB001 , GetSetMbFilter , "" )

		SetMBTopFilter( "AF8" , ""  )

		uRet		:= __Execute( "MATA110()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA110" , AllTrim(Str(nModulo)) , "" , 1 , .T. )
		
		MbrRstFilter()

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

	ReSetModulo( aModuloReSet )

	RestArea( aAF8Area )
	RestArea( aArea )

Return( uRet )

/*/
	Funcao:		MbrRstFilter
	Autor:		Marinaldo de Jesus
	Data:		20/03/2011
	Descricao:	Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( NDJLIB001 , MbrRstFilter , "AF8" , "cNDJAF8FMbr" ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJShwSC()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )