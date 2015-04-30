#INCLUDE "NDJ.CH"

#DEFINE _SIZE_CPF_		 9
#DEFINE _SIZE_CGC_		12

Static __aCPF__	:= Array(0)
Static __aCGC__ := Array(0)

/*/
	Funcao:		NextCPF
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Obtem o Proximo CPF Valido
	Sintaxe:	<Vide Parametros Formais>
	
	cStart  : Numero do CPF ( Exemplo: "10656875917"
	nStart  : Numerico de 9 ( Exemplo: 106568759 )
	nFinish : Numerico de 9 ( Exemplo: ++nStart ou --nStart )
	nPlus   : Numerico      ( Exemplo: 1, 2 , 10, ... n	)
	nStep   : Numerico      ( Exemplo: 1, 2 , 10, ... n	)

/*/
Static Function NextCPF( cStart , nStart , nFinish , nPlus , nStep  ) 

	Local cNextCPF
	Local nCPF
	
	DEFAULT cStart	:= "00000000000"
	DEFAULT nStart	:= Val( SubStr( cStart , 1 , 9 ) )
	DEFAULT nFinish	:= ( nStart + 1 )
	
	BEGIN SEQUENCE
	
		IF Empty( __aCPF__ )
			__aCPF__ := BuildCPF( @nStart , @nFinish , @nPlus , @nStep )
		EndIF
	
		nCPF := aScan( __aCPF__ , { |cCPF| ( cCPF == cStart ) } )
		IF ( ( ++nCPF ) > Len( __aCPF__ ) )
			aSize( __aCPF__ , 0 )
			nFinish		+= nCPF
			cNextCPF 	:= NextCPF( @cStart , @nStart , @nFinish , @nPlus , @nStep  ) 
			BREAK
		EndIF
		
		cNextCPF := __aCPF__[ nCPF ]
	
	END SEQUENCE
	
	cStart	:= cNextCPF

Return( cNextCPF )

/*/
	Funcao:		ClearCPF
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Limpa a Pilha de CPF
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function ClearCPF()
Return( aSize( __aCPF__ , 0 ) )

/*/
	Funcao:		BuildCPF
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna Array com Numeros de CPF's Validos
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function BuildCPF( nStart , nFinish , nPlus , nStep )

	Local aCPFs		:= Array(0)
	Local cStart	:= "000000000"
	
	Local cCPF
	Local cPlus
	Local nSize
	Local nCPF
	
	DEFAULT nStart	:= 1
	DEFAULT nFinish	:= 1
	DEFAULT nPlus	:= 1
	DEFAULT nStep	:= 1
	
	IF ( nStep < 0 )
		IF ( nFinish > nStart )
			nCPF 	:= nStart
			nStart	:= nFinish
			nFinish := nCPF
			nCPF	:= NIL
		EndIF
		IF ( nPlus > 0 )
			nPlus	*= -( 1 ) 
		EndIF
	Else
		IF ( nFinish < nStart )
			nCPF 	:= nStart
			nStart	:= nFinish
			nFinish := nCPF
			nCPF	:= NIL
		EndIF
		IF ( nPlus < 0 )
			nPlus	:= Abs( @nPlus )
		EndIF
	EndIF
	
	nStart	-= nPlus
	nCPF	:= nStart
	For nStart := nStart To nFinish Step nStep
		nCPF	+= nPlus
	    cPlus   := Transform( @nCPF , StaticCall( NDJLIB001 , RetPictVal , @nCPF ) )
		nSize	:= Len( @cPlus )
		IF ( nSize <= _SIZE_CPF_ )
			IF ( nSize == _SIZE_CPF_ )
				cCPF	:= cPlus
			Else
				cCPF	:= SubStr( @cStart , 1 , ( _SIZE_CPF_ - nSize ) )
				cCPF	+= cPlus
			EndIF
			cCPF		+= DvCPF1( @cCPF )
			cCPF		+= DvCPF2( @cCPF )
			IF CPFChkDv( @cCPF , .F. )
				aAdd( @aCPFs , @cCPF )
			EndIF
		EndIF	
	Next nStart
	
Return( aCPFs )
	
	/*/
		Funcao:		CPFChkDv
		Autor:		Marinaldo de Jesus 
		Data:		21/03/2005
		Descricao:	Verifica se os Digitos Verificadores do CPF estao OK
		Sintaxe:	<Vide Parametros Formais>
	/*/
Static Function CPFChkDv( cCPF , lShowHelp )
	
	Local cDvCPFPar
	Local cDvCPFFun
	
	Local lDvCpfOk
	
	BEGIN SEQUENCE
	
		lDvCpfOk := ( Len( @cCPF ) == 11 )
		IF !( lDvCpfOk )
			BREAK
		EndIF
	
		lDvCpfOk := !Empty( StrTran( @cCPF , SubStr( @cCPF , 1 , 1 ) , "" ) )
		IF !( lDvCpfOk )
			BREAK
		EndIF
	
		cDvCPFPar	:= SubStr( @cCPF , ( -2 ) )
		cDvCPFFun	:= DvCPF( @cCPF )
	
		lDvCpfOk	:= ( cDvCPFPar == cDvCPFFun )
	
	END SEQUENCE
	
	DEFAULT lShowHelp := .T.
	IF (;
			!( lDvCpfOk );
			.and.;
			( lShowHelp );
		)	
		Help( " " , 1 , "CPFINVALID" )
	EndIF

Return( lDvCpfOk )

/*/
	Funcao:		DvCPF
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna os Digitos Verificadores do CPF
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCPF( cCPF )

	Local cDvCPF1	:= DvCPF1( @cCPF )
	Local cDvCPF2	:= DvCPF2( @cCPF )
	Local cDvCPF	:= ( cDvCPF1 + cDvCPF2 )
	
Return( cDvCPF )

/*/
	Funcao:		DvCPF1
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o 1o. Digito Verificador do CPF
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCPF1( cCPF )

	Local aMultiply
	Local aDvMod
	
	Local cNumber
	
	Local nAccumulator
	Local nIntDiv11
	Local nIntMult11
	Local nDvCPF1
	
	IF !Empty( cCPF )
		aMultiply		:= { 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 }
		cNumber			:= SubStr( @cCPF , 1 , _SIZE_CPF_ )
		aDvMod			:= Multiply( @cNumber , @aMultiply , "><" )
		nAccumulator	:= DvModAcm( @aDvMod )
		nIntDiv11		:= Int( ( nAccumulator / 11 ) )
		nIntMult11		:= ( nIntDiv11 * 11 )
		nDvCPF1			:= ( nAccumulator - nIntMult11 )
		IF (;
				( nDvCPF1 == 0 );
				.or.;
				( nDvCPF1 == 1 );
			)
			nDvCPF1 := 0
		Else
			nDvCPF1	:= ( 11 - nDvCPF1 )
		EndIF
		cDvCPF1		:= AllTrim( Str( @nDvCPF1 ) )
	Else
		cDvCPF1		:= ""
	EndIF

Return( cDvCPF1 )

/*/
	Funcao:		DvCPF2
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o 2o. Digito Verificador do CPF
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCPF2( cCPF )

	Local aMultiply
	Local aDvMod
	
	Local cNumber
	
	Local nAccumulator
	Local nIntDiv11
	Local nIntMult11
	Local nDvCPF2
	
	IF !Empty( cCPF )
		aMultiply		:= { 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 }
		cNumber			:= SubStr( @cCPF , 1 , ( _SIZE_CPF_ + 1 ) )
		aDvMod			:= Multiply( @cNumber , @aMultiply , "><" )
		nAccumulator	:= DvModAcm( @aDvMod )
		nIntDiv11		:= Int( ( nAccumulator / 11 ) )
		nIntMult11		:= ( nIntDiv11 * 11 )
		nDvCPF2			:= ( nAccumulator - nIntMult11 )
		IF (;
				( nDvCPF2 == 0 );
				.or.;
				( nDvCPF2 == 1 );
			)
			nDvCPF2 := 0
		Else
			nDvCPF2	:= ( 11 - nDvCPF2 )
		EndIF
		cDvCPF2		:= AllTrim( Str( @nDvCPF2 ) )
	Else
		cDvCPF2		:= ""
	EndIF

Return( cDvCPF2 )

/*/
	Funcao:		NextCGC
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Obtem o Proximo CGC Valido
	Sintaxe:	<Vide Parametros Formais>

	cStart  : Numero do CGC  ( Exemplo: "40454647000299"
	nStart  : Numerico de 12 ( Exemplo: 404546470002 )
	nFinish : Numerico de 12 ( Exemplo: ++nStart ou --nStart )
	nPlus   : Numerico       ( Exemplo: 1, 2 , 10, ... n	)
	nStep   : Numerico       ( Exemplo: 1, 2 , 10, ... n	)
/*/
Static Function NextCGC( cStart , nStart , nFinish , nPlus , nStep  ) 

	Local cNextCGC
	
	Local nCGC
	
	DEFAULT cStart	:= "00000000000000"
	DEFAULT nStart	:= Val( SubStr( cStart , 1 , 12 ) )
	DEFAULT nFinish	:= ( nStart + 1 )
	
	BEGIN SEQUENCE
	
		IF Empty( __aCGC__ )
			__aCGC__ := BuildCGC( @nStart , @nFinish , @nPlus , @nStep )
		EndIF
		
		nCGC := aScan( __aCGC__ , { |cCGC| ( cCGC == cStart ) } )
		IF ( ( ++nCGC ) > Len( __aCGC__ ) )
			aSize( __aCGC__ , 0 )
			nFinish		+= nCGC
			cNextCGC 	:= NextCGC( @cStart , @nStart , @nFinish , @nPlus , @nStep  ) 
			BREAK
		EndIF
		
		cNextCGC := __aCGC__[ nCGC ]
	
	END SEQUENCE
	
	cStart	:= cNextCGC

Return( cNextCGC )

/*/
	Funcao:		ClearCGC
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Limpa a Pilha de CGC
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function ClearCGC()
Return( aSize( __aCGC__ , 0 ) )

/*/
	Funcao:		BuildCGC
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna Array com Numeros de CGC's Validos
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function BuildCGC( nStart , nFinish , nPlus , nStep )

	Local aCGCs		:= Array(0)
	Local cStart	:= "000000000000"
	                    
	Local cCGC
	Local cPlus
	Local nSize
	Local nCGC
	
	DEFAULT nStart	:= 1
	DEFAULT nFinish	:= 1
	DEFAULT nPlus	:= 1
	DEFAULT nStep	:= 1
	
	IF ( nStep < 0 )
		IF ( nFinish > nStart )
			nCGC 	:= nStart
			nStart	:= nFinish
			nFinish := nCGC
			nCGC	:= NIL
		EndIF
		IF ( nPlus > 0 )
			nPlus	*= -( 1 ) 
		EndIF
	Else
		IF ( nFinish < nStart )
			nCGC 	:= nStart
			nStart	:= nFinish
			nFinish := nCGC
			nCGC	:= NIL
		EndIF
		IF ( nPlus < 0 )
			nPlus	:= Abs( @nPlus )
		EndIF
	EndIF
	
	nStart	-= nPlus
	nCGC	:= nStart
	For nStart := nStart To nFinish Step nStep
		nCGC	+= nPlus
	    cPlus   := Transform( @nCGC , StaticCall( NDJLIB001 , RetPictVal , @nCGC ) )
		nSize	:= Len( @cPlus )
		IF ( nSize <= _SIZE_CGC_ )
			IF ( nSize == _SIZE_CGC_ )
				cCGC	:= cPlus
			Else
				cCGC	:= SubStr( @cStart , 1 , ( _SIZE_CGC_ - nSize ) )
				cCGC	+= cPlus
			EndIF
			cCGC		+= DvCGC1( @cCGC )
			cCGC		+= DvCGC2( @cCGC )
			IF CGCChkDv( @cCGC , .F. )
				aAdd( @aCGCs , @cCGC )
			EndIF
		EndIF
	Next nStart

Return( aCGCs )

/*/
	Funcao:		CGCChkDv
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Verifica se os Digitos Verificadores do CGC estao OK
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function CGCChkDv( cCGC , lShowHelp )

	Local cDvCGCPar
	Local cDvCGCFun
	
	Local lDvCGCOk
	
	BEGIN SEQUENCE
	
		lDvCGCOk := ( Len( cCGC ) == 14 )
		IF !( lDvCGCOk )
			BREAK
		EndIF
	
		lDvCGCOk := !Empty( StrTran( @cCGC , SubStr( @cCGC , 1 , 1 ) , "" ) )
		IF !( lDvCGCOk )
			BREAK
		EndIF
	
		cDvCGCPar	:= SubStr( @cCGC , ( -2 ) )
		cDvCGCFun	:= DvCGC( @cCGC )
	
		lDvCGCOk	:= ( cDvCGCPar == cDvCGCFun )
	
	END SEQUENCE
	
	DEFAULT lShowHelp := .T.
	IF (;
			!( lDvCGCOk );
			.and.;
			( lShowHelp );
		)	
		Help( " " , 1 , "CGC" )
	EndIF

Return( lDvCGCOk )

/*/
	Funcao:		DvCGC
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna os Digitos Verificadores do CGC
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCGC( cCGC )

	Local cDvCGC1	:= DvCGC1( @cCGC )
	Local cDvCGC2	:= DvCGC2( @cCGC )
	Local cDvCGC	:= ( cDvCGC1 + cDvCGC2 )
	
Return( cDvCGC )

/*/
	Funcao:		DvCGC1
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o 1o. Digito Verificador do CGC
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCGC1( cCGC )

	Local aMultiply
	Local aDvMod
	
	Local cNumber
	
	Local nAccumulator
	Local nIntDiv11
	Local nIntMult11
	Local nDvCGC1
	
	IF !Empty( cCGC )
		aMultiply		:= { 5 , 4 , 3 , 2 , 9 , 8 , 7 , 6 , 5 , 4 , 3 , 2 }
		cNumber			:= SubStr( @cCGC , 1 , _SIZE_CGC_ )
		aDvMod			:= Multiply( @cNumber , @aMultiply , ">>" )
		nAccumulator	:= DvModAcm( @aDvMod )
		nIntDiv11		:= Int( ( nAccumulator / 11 ) )
		nIntMult11		:= ( nIntDiv11 * 11 )
		nDvCGC1			:= ( nAccumulator - nIntMult11 )
		IF (;
				( nDvCGC1 == 0 );
				.or.;
				( nDvCGC1 == 1 );
			)
			nDvCGC1 := 0
		Else
			nDvCGC1	:= ( 11 - nDvCGC1 )
		EndIF
		cDvCGC1		:= AllTrim( Str( @nDvCGC1 ) )
	Else
		cDvCGC1		:= ""
	EndIF
	
Return( cDvCGC1 )

/*/
	Funcao:		DvCGC2
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o 2o. Digito Verificador do CGC
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvCGC2( cCGC )

	Local aMultiply
	Local aDvMod
	
	Local cNumber
	
	Local nAccumulator
	Local nIntDiv11
	Local nIntMult11
	Local nDvCGC2
	
	IF !Empty( cCGC )
		aMultiply		:= { 6 , 5 , 4 , 3 , 2 , 9 , 8 , 7 , 6 , 5 , 4 , 3 , 2 }
		cNumber			:= SubStr( @cCGC , 1 , ( _SIZE_CGC_ + 1 ) )
		aDvMod			:= Multiply( @cNumber , @aMultiply , ">>" )
		nAccumulator	:= DvModAcm( @aDvMod )
		nIntDiv11		:= Int( ( nAccumulator / 11 ) )
		nIntMult11		:= ( nIntDiv11 * 11 )
		nDvCGC2			:= ( nAccumulator - nIntMult11 )
		IF (;
				( nDvCGC2 == 0 );
				.or.;
				( nDvCGC2 == 1 );
			)
			nDvCGC2 := 0
		Else
			nDvCGC2	:= ( 11 - nDvCGC2 )
		EndIF
		cDvCGC2		:= AllTrim( Str( @nDvCGC2 ) )
	Else
		cDvCGC2		:= ""
	EndIF

Return( cDvCGC2 )

/*/
	Funcao:		Multiply
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna Array de elementos produto da multiplicacao de cada Byte 
				Numerico da String cNumber pelo respectivo multiplicador e   con
				forme a Direcao.
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function Multiply( cNumber , aMultiply , cDirection )

	Local aAccumulator
	
	Local lMultRight4Left
	
	Local nLoop
	Local nLoops
	Local nStep
	Local nNumber
	Local nMultiplo
	Local nMultiplos
	
	BEGIN SEQUENCE
	
		DEFAULT cNumber := ""
		nLoops := Len( AllTrim( cNumber ) )
		IF ( nLoops == 0 )
			BREAK
		EndIF
	
		DEFAULT aMultiply 	:= { 0 , 1 }
		DEFAULT cDirection 	:= "<<"
	
		nMultiplos 		:= Len( aMultiply )
		lMultRight4Left := ( cDirection $ "<<_><" )
		IF ( lMultRight4Left )
			nMultiplo	:= nMultiplos
		Else	//>>_<>
			nMultiplo	:= 1
		EndIF
	
		IF ( cDirection $ "<<_<>" )
			nLoop		:= nLoops
			nLoops		:= 1
			nStep		:= -1
		Else	//>>_><
			nLoop		:= 1
			nStep		:= 1
		EndIF
	
		aAccumulator := Array(0)
		For nLoop := nLoop To nLoops Step nStep
			nNumber 		:= Val( SubStr( cNumber , nLoop , 1 ) )
			nNumber 		*= aMultiply[ nMultiplo ]
			aAdd( aAccumulator , nNumber )
			IF ( lMultRight4Left )
				IF ( ( --nMultiplo ) <= 0 )
					nMultiplo := nMultiplos
				EndIF
			Else
				IF ( ( ++nMultiplo ) > nMultiplos )
					nMultiplo := 1
				EndIF
			EndIF
		Next nLoop
	
	END SEQUENCE
	
	IF Empty( aAccumulator )
		aAccumulator := { 0 }
	EndIF

Return( aAccumulator )

/*/
	Funcao:		nByteSum
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna a soma de Cada Byte de um Numero
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function nByteSum( uNumber )

	Local cTypeNumber := ValType( uNumber )
	
	Local cNumber
	
	Local nByteSum := 0
	
	BEGIN SEQUENCE
	
		IF ( cTypeNumber == "N" )
	        cNumber     := StrTran( Transform( uNumber , StaticCall( NDJLIB001 , RetPictVal , uNumber ) ) , "." , "" )
		ElseIF ( cTypeNumber == "D" )
			cNumber 	:= Dtos( uNumber )
		ElseIF ( cTypeNumber == "C" )
			cNumber 	:= uNumber
		ElseIF ( cTypeNumber == "L" )
			cNumber 	:= IF( uNumber , "1" , "0" )
		Else
			BREAK
		EndIF
	
		aEval( Multiply( @cNumber , { 1 } , ">>" ) , { |nNumber| nByteSum += nNumber } )
	
	END SEQUENCE

Return( nByteSum )

/*/
	Funcao:		DvMod
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador conforme nMod
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvMod( nMod , cNumber , aMultiply , cDirection , bGetDvMod , bAcumulator )

	Local aDvMod
	
	Local cDvMod
	
	Local nAccumulator
	
	Local nRemaining
	
	aDvMod				:= Multiply( @cNumber , @aMultiply , @cDirection )
	
	DEFAULT bAcumulator	:= { | aDvMod | DvModAcm( @aDvMod ) }
	
	nAccumulator		:= Eval( @bAcumulator , @aDvMod )
	
	DEFAULT bGetDvMod	:= { | nMod , nAccumulator | GetDvMod( @nMod , @nAccumulator ) }
	
	DEFAULT nMod		:= 11
	cDvMod				:= Eval( @bGetDvMod, @nMod , @nAccumulator )

Return( cDvMod )

/*/
	Funcao:		DvModAcm
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador conforme nMod
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvModAcm( aDvMod )

	Local nDvModAcm := 0
	
	Local nLoop
	Local nLoops
	
	nLoops := Len( aDvMod )
	For nLoop := 1 To nLoops
		nDvModAcm += aDvMod[ nLoop ]
	Next nLoop
	
Return( nDvModAcm )

/*/
	Funcao:		GetDvMod
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador conforme nMod
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function GetDvMod( nMod , nAccumulator )

	Local cDvMod
	
	Local nDvMod
	Local nRemaining
	
	nRemaining	:= ( nAccumulator % nMod )
	nDvMod		:= nRemaining
	IF (;
			( nDvMod <= 1 );
			.or.;
			( nDvMod >= 10 );
		)
		nDvMod := 1
	EndIF
	cDvMod := AllTrim( Str( @nDvMod ) ) 
	
Return( cDvMod )

/*/
	Funcao:		DvModMsR
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Obtido pela  Subtracao do Modulo pelo resto da Divisao do Modulo DVSMDM
	Sintaxe:	<Vide Parametros Formais>
/*/

Static Function DvModMsR( nMod , cNumber , aMultiply , cDirection , bGetDvMod , bAcumulator )

	DEFAULT bGetDvMod := { | nMod , nAccumulator | _DvModMsR( @nMod , @nAccumulator ) }

Return( DvMod( @nMod , @cNumber , @aMultiply , @cDirection , @bGetDvMod , @bAcumulator ) )

/*/
	Funcao:		_DvModMsR
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Obtido pela  Subtracao do Modulo pelo resto da Divisao do Modulo
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function _DvModMsR( nMod , nAccumulator )

	Local cDvMod
	
	Local nDvMod
	Local nRemaining
	
	nRemaining	:= ( nAccumulator % nMod )
	nDvMod		:= ( nMod - nRemaining )
	IF (;
			( nDvMod <= 1 );
			.or.;
			( nDvMod >= 10 );
		)
		nDvMod := 1
	EndIF
	
	cDvMod := AllTrim( Str( @nDvMod ) )

Return( cDvMod )

/*/
	Funcao:		DvM10b12
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 10 Base 1 a 2
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvM10b12( cNumber , cDirection )

	Local aMultiply		:= { 2 , 1 }
	Local bGetDvMod	:= { | nMod , nAccumulator | _DvM10b12( @nMod , @nAccumulator ) }
	
	DEFAULT cDirection := "<>"
	
Return( DvMod( 10 , @cNumber , @aMultiply , @cDirection , @bGetDvMod ) )

/*/
	Funcao:		_DvM10b12
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 10 Base 1 a 2
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function _DvM10b12( nMod , nAccumulator )

	Local cDvMod
	
	Local nDvMod
	Local nRemaining
	
	nRemaining	:= ( nAccumulator % nMod )
	nDvMod		:= nRemaining
	IF ( nDvMod >= 10 )
		nDvMod := 0
	EndIF	
	
	cDvMod := AllTrim( Str( @nDvMod ) )

Return( cDvMod )

/*/
	Funcao:		Dv10b12M
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 10 Base 1 a 2 Considerando o Maior Multipo de 10 para a apuracao do Digito
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function Dv10b12M( cNumber , cDirection )

	Local aMultiply		:= { 2 , 1 }
	Local bAcumulator	:= { | aDvMod | Dv10b12MAcm( @aDvMod ) }
	Local bGetDvMod		:= { | nMod , nAccumulator | _Dv10b12M( @nMod , @nAccumulator ) }
	
	DEFAULT cDirection := "<>"
	
Return( DvMod( 10 , @cNumber , @aMultiply , @cDirection , @bGetDvMod , @bAcumulator ) )

/*/
	Funcao:		Dv10b12MAcm
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Acumular os Valores para apuracao do Digito verificador na funcao Dv10b12M()
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function Dv10b12MAcm( aDvMod )

	Local nDv10b12MAcm	:= 0

	Local nLoop
	Local nLoops
	
	nLoops := Len( aDvMod )
	For nLoop := 1 To nLoops
		nDv10b12MAcm += nByteSum( @aDvMod[ nLoop ] )
	Next nLoop
	
Return( nDv10b12MAcm )

/*/
	Funcao:		_Dv10b12M
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 10 Base 1 a 2 Considerado o Maior Multipo de 10 para a apuracao do Digito
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function _Dv10b12M( nMod , nAccumulator )

	Local cDvMod
	Local nDvMod
	
	IF ( nAccumulator <= nMod )
		nDvMod := nMod
	Else	
		nDvMod	:= Int( ( nAccumulator / nMod ) )
		nDvMod	*= nMod
		While ( nDvMod < nAccumulator )
			nDvMod += 10
		End While
		nDvMod -= nAccumulator
	EndIF
	
	cDvMod := AllTrim( Str( @nDvMod ) )

Return( cDvMod )

/*/
	Funcao:		DvM11
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 11
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvM11( cNumber , aMultiply , cDirection )

	Local bGetDvMod := { | nMod , nAccumulator | DvM11P41( @nMod , @nAccumulator ) }

Return( DvMod( 11 , @cNumber , @aMultiply , @cDirection , @bGetDvMod ) )

/*/
	Funcao:		DvM11P41
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 11 Base 0 a 7
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvM11P41( nMod , nAccumulator )
	
	Local cDvMod
	
	Local nDvMod
	Local nRemaining
	
	nRemaining	:= ( nAccumulator % nMod )
	
	IF ( nRemaining == 1 )
		cDvMod 	:= "P"
	ElseIF( nRemaining == 0 )
		cDvMod 	:= "0"
	Else
		nDvMod	:= ( nMod - nRemaining )
		IF (;
				( nDvMod <= 1 );
				.or.;
				( nDvMod >= 10 );
			)
			nDvMod := 0
		EndIF	
		cDvMod := AllTrim( Str( @nDvMod ) )
	EndIF
	
Return( cDvMod )

/*/
	Funcao:		DvM11b27
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 11 Base 2 a 7
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvM11b27( cNumber , cDirection )

	Local aMultiply	:= { 7 , 6 , 5 , 4 , 3 , 2 }
	
	DEFAULT cDirection := "<<"
	
Return( DvM11( @cNumber , @aMultiply , @cDirection ) )

/*/
	Funcao:		DvM11b29
	Autor:		Marinaldo de Jesus 
	Data:		21/03/2005
	Descricao:	Retorna o Digito Verificador Modulo 11 Base 2 a 9
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function DvM11b29( cNumber , cDirection )

	Local aMultiply := { 9 , 8 , 7 , 6 , 5 , 4 , 3 , 2 }
	
	DEFAULT cDirection := "<<"
	
Return( DvModMsR( 11 , @cNumber , @aMultiply , @cDirection ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
		lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa := __Dummy( .F. )
   		CLEARCGC()
    	CLEARCPF()
    	DV10B12M()
    	DVM10B12()
    	DVM11B27()
    	DVM11B29()
    	SYMBOL_UNUSED( __cCRLF )    	
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )