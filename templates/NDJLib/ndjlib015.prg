#INCLUDE "NDJ.CH"
/*/
	Funcao:		PackSX
	Autor:		Marinaldo de Jesus
	Data:		08/11/2005
	Descricao:	Tenta efetuar a Limpeza dos Registros Deletados do SX
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function PackSX( cAlias , cFileSX , nAttempts , nSleep , cRddName )

	Local lLocked		:= .F.
	Local lUnLocked		:= .F.
	Local lSxPackOk		:= .T.
	
	IF ( Select( cAlias ) > 0 )
		DEFAULT cRddName := ( cAlias )->( RddName() )
	EndIF
	
	IF ( lLocked := LockSX( @cAlias , @cFileSX , @nAttempts , @nSleep , @cRddName ) )
        ( cAlias )->( StaticCall( NDJLIB001 , dbPack , cAlias , .F. , .F. , .F. , .F. , @cRddName , @cFileSX ) )
	EndIF
	
	lUnLocked := UnLockSX( @cAlias , @cFileSX , @nAttempts , @nSleep , @cRddName )
	lSxPackOk := ( lLocked .and. lUnLocked )

Return( lSxPackOk )

/*/
	Funcao:		LockSX
	Autor:		Marinaldo de Jesus
	Data:		08/11/2005
	Descricao:	Tenta efetuar a Lock no SX
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function LockSX( cAlias , cFileSX , nAttempts , nSleep , cRddName )

	Local bLockFile		:= { || dbUseArea( .T. , cRddName , cFileSX , cAlias , .F. , .F. ) , ( lLocked := ( Select( cAlias) > 0 ) ) }
	
	Local lLocked		:= .F.
	
	Local nAttempt		:= 0
	
	IF ( Select( cAlias ) > 0 )
		DEFAULT cRddName := ( cAlias )->( RddName() )
		( cAlias )->( dbCloseArea() )
	EndIF	
	
	DEFAULT nAttempts	:= 10
	DEFAULT nSleep		:= 3
	
	While !( Eval( bLockFile ) )
		IF ( ( ++nAttempt ) > nAttempts )
			Exit
		EndIF
		Sleep( nSleep )
	End While

Return( lLocked )

/*/
	Funcao:		UnLockSX
	Autor:		Marinaldo de Jesus
	Data:		08/11/2005
	Descricao:	Tenta Liberar Lock no SX
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function UnLockSX( cAlias , cFileSX , nAttempts , nSleep , cRddName )

	Local bUnLockFile	:= { || dbUseArea( .T. , cRddName , cFileSX , cAlias , .T. , .F. ) , ( lUnLocked := ( Select( cAlias) > 0 ) ) }
	
	Local lUnLocked		:= .F.
	
	Local nAttempt		:= 0
	
	IF ( Select( cAlias ) > 0 )
		DEFAULT cRddName := ( cAlias )->( RddName() )
		( cAlias )->( dbCloseArea() )
	EndIF	
	
	DEFAULT nAttempts	:= 3
	DEFAULT nSleep		:= 5
	
	While !( Eval( bUnLockFile ) )
		IF ( ( ++nAttempt ) > nAttempts )
			Exit
		EndIF
		Sleep( nSleep )
	End While

Return( lUnLocked )

/*/
	Funcao:		PackSXP
	Autor:		Marinaldo de Jesus
	Data:		08/11/2005
	Descricao:	Tenta efetuar a Limpeza dos Registros Deletados do SXP
	Sintaxe:	<Vide Parametros Formais>
/*/
Static Function PackSXP( cFileSXP , nAttempts , nSleep , cRddName )
	DEFAULT cRddName := __LocalDriver
Return( PackSX( "SXP" , @cFileSXP , @nAttempts , @nSleep , cRddName ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	CAPTUREERROR()
    	PACKSXP()
    	PUTTRYEXCEPTIONVARS()
    	lRecursa	:= __Dummy( .F. )
    	SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )