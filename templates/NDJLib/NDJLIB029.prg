#include "ndj.ch"

/*/
	Fun‡„o		: ArrayCompare
	Autor		: Marinaldo de Jesus
	Data		: 04/08/2004³
	Descri‡„o	: Efetua a Comparacao de Arrays
	Retorno		: lCompare <=> False se Houver Diferca, True se Nao Houver
*/
Static Function ArrayCompare( aArray1 , aArray2 , nPosDif )

	Local cType1		:= ValType( aArray1 )
	Local cType2		:= ValType( aArray2 )
	
	Local lCompare
	Local nArray
	Local nArray1Size
	Local nArray2Size
	Local nHalfToBeg
	Local nHalfToEnd
	
	Begin Sequence
	
		IF !( lCompare := ( cType1 == cType2 ) )
			Break
		EndIF
	
		IF ( cType1 == "O" )
			lCompare := Compare( aArray1 , aArray2 , @nPosDif )
			Break
		EndIF
	
		IF !( lCompare := ( cType1 == "A" ) )
			Break
		EndIF
				
		IF !( lCompare := ( ( nArray1Size := Len( aArray1 ) ) == ( nArray2Size := Len( aArray2 ) ) ) )
			nPosDif := ( Min( nArray1Size , nArray2Size ) + 1 )
			Break
		EndIF
				
		nHalfToBeg := ( IF( ( ( nArray1Size % 2 ) > 0 ) , ( ( nArray1Size + 1 ) ) , nArray1Size ) / 2 )
		nHalfToEnd := Min( nArray1Size , ( nHalfToBeg + 1 ) )
		For nArray := 1 To nArray1Size
			IF ( nArray <= nHalfToBeg )
				IF !( lCompare := Compare( aArray1[ nArray ] , aArray2[ nArray ] ) )
					nPosDif := nArray
					Break
				EndIF
			Else
				Break
			EndIF
			IF ( nHalfToBeg > nArray )
				IF !( lCompare := Compare( aArray1[ nHalfToBeg ] , aArray2[ nHalfToBeg ] ) )
					nPosDif := nHalfToBeg
					Break
				EndIF
				--nHalfToBeg
			EndIF
			IF ( nHalfToEnd < nArray1Size )
				IF !( lCompare := Compare( aArray1[ nHalfToEnd ] , aArray2[ nHalfToEnd ] ) )
					nPosDif := nHalfToEnd
					Break
				EndIF
				++nHalfToEnd
			EndIF
			IF ( nArray1Size >= nHalfToEnd )
				IF !( lCompare := Compare( aArray1[ nArray1Size ] , aArray2[ nArray1Size ] ) )
					nPosDif := nArray1Size
					Break
				EndIF
				--nArray1Size
			EndIF
		Next nArray
	
	End Sequence

Return( lCompare )

/*/
	Fun‡„o		: Compare
	Autor		: Marinaldo de Jesus
	Data		: 08/10/2002
	Descri‡„o	: Compara o Conteudo de 2 Variaveis
	Retorno		: lCompare <=> False se Houver Diferenca, True se Nao Houver
*/
Static Function Compare( uCompare1 , uCompare2 , nPosDif )

	Local cType1	:= ValType( uCompare1 )
	Local cType2	:= ValType( uCompare2 )

	Local lCompare

	IF ( lCompare := ( cType1 == cType2 ) )
		IF ( cType1 == "A" )
			lCompare := ArrayCompare( uCompare1 , uCompare2 , @nPosDif )
		ElseIF ( cType1 == "O" )
			lCompare := ArrayCompare( ClassDataArr( uCompare1 ) , ClassDataArr( uCompare2 ) , @nPosDif )
		ElseIF ( cType1 == "B" )
			lCompare := ( GetCBSource( uCompare1 ) == GetCBSource( uCompare2 ) )
		Else
			lCompare := ( uCompare1 == uCompare2 )
		EndIF
	EndIF
	
Return( lCompare )

/*
	Fun‡„o		: SaveArray
	Autor		: Marinaldo de Jesus
	Data		: 18/02/2005
	Descri‡„o	: Salva Array em Disco	
*/
Static Function SaveArray( uArray , cFileName , nErr )

Local cValTypeuArray	:= ValType( uArray )
Local lSaveArray		:= .F.

Local aArray
Local nfHandle

Begin Sequence

	IF !( cValTypeuArray $ "A/O" )
		Break
	EndIF

	IF ( cValTypeuArray == "O" )
		aArray := ClassDataArr( uArray )
	Else
	    aArray := uArray
	EndIF

	lSaveArray := FileCreate( cFileName , @nfHandle , @nErr )
	IF !( lSaveArray )
		Break
	EndIF

	SaveArr( nfHandle , aArray )
	fClose( nfHandle )

End Sequence	

Return( lSaveArray )

/*/
	Fun‡„o    : SaveArr
	Autor	  :	Marinaldo de Jesus
	Data	  :	18/02/2005
	Descri‡„o : Salva Array em Disco
	Uso       : SaveArray
*/
Static Function SaveArr( nfHandle , aArray )

	Local cElemType
	
	Local uCntSave
	
	Local nLoop
	Local nLoops
		
	nLoops		:= Len( aArray )
	uCntSave	:= ( "A" + StrZero( nLoops , 10 ) )
	fWrite( nfHandle , uCntSave )
	For nLoop := 1 To nLoops
		cElemType := ValType( aArray[ nLoop ] )
		IF ( cElemType $ "A/O" )
			IF ( cElemType == "A" )
				SaveArr( nfHandle , aArray[ nLoop ] )
			Else
				SaveArr( nfHandle , ClassDataArr( aArray[ nLoop ] ) )
			EndIF
		Else
			IF ( cElemType == "B" )
				uCntSave	:= GetCBSource( aArray[ nLoop ] )
			ElseIF ( cElemType == "C" )
				uCntSave	:= aArray[ nLoop ]
			ElseIF ( cElemType == "D" )
				uCntSave	:= Dtos( aArray[ nLoop ] )
			ElseIF ( cElemType == "L" )
				uCntSave	:= IF( aArray[ nLoop ] , ".T." , ".F." )
			ElseIF ( cElemType == "N" )
				uCntSave	:= Transform( aArray[ nLoop ] , RetPictVal( aArray[ nLoop ] ) )
			EndIF
			uCntSave := ( cElemType + StrZero( Len( uCntSave ) , 5 ) + uCntSave )
			fWrite( nfHandle , uCntSave )
		EndIF
	Next nLoop

Return( NIL )

/*
	Fun‡„o		: RestArray
	Autor		: Marinaldo de Jesus
	Data		: 18/02/2005
	Descri‡„o	: Restaura Array do Disco
	Retorno   	: aArray
*/
Static Function RestArray( cFileName , nErr )

	Local aRestArray := {}
	
	Local nfHandle
	
	Begin Sequence
	
		IF !( File( cFileName ) )
			Break
		EndIF
		
		nfHandle := fOpen( cFileName )
	
		IF ( nfHandle <= 0 )
			nErr := fError()
			Break
		EndIF
	
		fReadStr( nfHandle , 1 )
		aRestArray := RestArr( nfHandle )
		fClose( nfHandle )
	
	End Sequence

Return( aRestArray )

/*
	Fun‡„o		: RestArr
	Autor		: Marinaldo de Jesus
	Data	    : 18/02/2005
	Descri‡„o	: Restaura Array do Disco
	Uso         : RestArray
*/
Static Function RestArr( nfHandle )

	Local aArray
	Local cElemType
	Local cElemSize
	
	Local nLoop
	Local nLoops
	
	Local uCnt
	
	nLoop	:= 0
	nLoops	:= Val( fReadStr( nfHandle , 10 ) )
	aArray	:= Array( nLoops )
	
	While ( ( ++nLoop ) <= nLoops )
	
		cElemType	:= fReadStr( nfHandle , 1 )
		IF ( cElemType $ "A/O" )
			aArray[ nLoop ] := RestArr( nfHandle )
		Else
			cElemSize	:= fReadStr( nfHandle , 5 )
			uCnt		:= fReadStr( nfHandle , Val( cElemSize ) )
			IF ( cElemType $ "B/L" )
				aArray[ nLoop ] := &( uCnt )
			ElseIF ( cElemType == "C" )
				aArray[ nLoop ] := uCnt
			ElseIF ( cElemType == "D" )
				aArray[ nLoop ] := Stod( AllTrim( uCnt ) )
			ElseIF ( cElemType == "N" )
				aArray[ nLoop ] := Val( AllTrim( uCnt ) )
			EndIF
		EndIF
	
	End While
	
Return( aArray )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
		lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa := __Dummy( .F. )
    	RESTARRAY()
    	SAVEARRAY()
    	SYMBOL_UNUSED( __cCRLF )    	
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )