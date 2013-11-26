#INCLUDE "NDJ.CH"
Static __aUseCode		:= {}
Static __nUseCode		:= 0

Static __aFreeLocks		:= {}
Static __nFreeLocks		:= 0

Static __aSetFreeLock   := {}
Static __nSetFreeLock	:= 0

Static __aAliasLock		:= {}
Static __nAliasLock		:= 0

/*/
	Funcao:		UseCode()
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Lock by Name
    Sintaxe:    StaticCall( NDJLIB003 , UseCode , cCodeIUse )
/*/
Static Function UseCode( cCodeIUse )

	Local cUserID

	Local lUsed		:= .F.
	
	Local nUsed
	
	Local oException

	TRYEXCEPTION

		cCodeIUse	:= AllTrim( cCodeIUse )
		
		nUsed		:= aScan( __aUseCode , { |cCode| ( cCode == cCodeIUse ) } )
		
		IF ( lUsed := ( nUsed > 0 ) )
			BREAK
		EndIF

		lUsed		:=  LockByName( cCodeIUse )
		IF !( lUsed )
			BREAK
		EndIF

		aAdd( __aUseCode , cCodeIUse )
		++__nUseCode

		cUserID	:= StaticCall( NDJLIB001 , RetCodUsr )

		StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , cCodeIUse )
		StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , "Usuário: " + cUserID )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , "Nome: " + StaticCall( NDJLIB014 , UsrRetName , cUserID  ) )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , "Nome Completo: " + StaticCall( NDJLIB014 , UsrFullName , cUserID  ) )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , "Computador: " + GetComputerName() )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , "Client IP: " + GetClientIp() )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , "Thread Id: " + AllTrim( Str(ThreadId(),0) ) )
	    StaticCall( NDJLIB013 , PutSemaphore , cCodeIUse , __cCRLF )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			lUsed		:= .F.
		EndIF	

	ENDEXCEPTION

Return ( lUsed )

/*/
	Funcao:		ReleaseCode()
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	UnLock by Name
    Sintaxe:    StaticCall( NDJLIB003 , ReleaseCode , cCodeRelease )
/*/
Static Function ReleaseCode( cCodeRelease )

	Local cFSemaphore
	
	Local lRelease		:= .F.
	
	Local nUsed
	
	Local oException

	TRYEXCEPTION

		cCodeRelease    := AllTrim( cCodeRelease )
		nUsed 			:= aScan( __aUseCode , { |cCode| ( cCode == cCodeRelease ) } )

		IF ( lRelease := .NOT.( nUsed > 0 ) )
			BREAK
		EndIF

		lRelease	:= UnlockByName( cCodeRelease )
		IF !( lRelease )
			BREAK
		EndIF

		aDel( __aUseCode , nUsed )
		aSize( __aUseCode , ( --__nUseCode ) )

		cFSemaphore	:= GetPathSemaforo()
		cFSemaphore	+= StaticCall( APLIB050 , PrepareKey ,  cCodeRelease )
		cFSemaphore	+= ".lck"
		cFSemaphore	:= Lower( cFSemaphore )
		IF File( cFSemaphore )
			fErase( cFSemaphore )
		EndIF

		StaticCall( NDJLIB013 , RmvSemaphore , cCodeRelease )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			lRelease	:= .F.
		EndIF	

	ENDEXCEPTION

Return( lRelease )

/*/
	Funcao:		FreeAllCodes()
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	UnLock All by Name
    Sintaxe:    StaticCall( NDJLIB003 , FreeAllCodes )
/*/
Static Function FreeAllCodes()

	Local aCode		:= aClone( __aUseCode )
	Local cCode

	Local lReleased := .T.

	Local nCode
	Local nCodes	:= __nUseCode

	For nCode := 1 To nCodes
		cCode	    := aCode[ nCode ]
		lReleased	:= ReleaseCode( cCode )
		IF !( lReleased )
			Exit
		EndIF
	Next nCode

Return( lReleased )

/*/
	Funcao:		UnLockAll()
	Autor:		Marinaldo de Jesus
	Data:		09/08/2011
	Descricao:	Commit e UnLockAll
    Sintaxe:    StaticCall( NDJLIB003 , UnLockAll )
/*/
Static Function UnLockAll()

	Local cAlias := Alias()

	IF (;
			!Empty( cAlias );
			.and.;
			( Select( cAlias ) > 0 );
		)
		( cAlias )->( MsUnLock() )
		( cAlias )->( MsUnLockAll() )
		IF !( InTransact() )
			( cAlias )->( dbUnLockAll() )
		EndIF	
		FreeAllCodes()
	EndIF	

Return( NIL )

/*/
	Funcao:		IFreeLocks
	Autor:		Marinaldo de Jesus
	Data:		09/08/2011
	Descricao:	Libera o Lock
    Sintaxe:    StaticCall( NDJLIB003 , IFreeLocks , cAlias , lForce )
/*/
Static Function IFreeLocks( cAlias , lForce )

	Local lFreeLocks	:= .F.
	
	Local nAT

	DEFAULT cAlias		:= Alias()
	DEFAULT lForce		:= .F.

	cAlias				:= Upper( AllTrim( cAlias ) )
	nAT					:= aScan( __aFreeLocks , { |aAliasFree| ( aAliasFree[ 1 ] == cAlias ) } )

	IF ( nAT == 0 )
		IF !( lForce )
			aAdd( __aFreeLocks , { cAlias , .F. } )
			++__nFreeLocks
		Else
			lFreeLocks	:= .T.
		EndIF	
	Else
		IF ( lForce )
			lFreeLocks	:= .T.
		Else
			lFreeLocks	:= __aFreeLocks[ nAT ][ 2 ]
		EndIF	
		IF !( lFreeLocks )
			__aFreeLocks[ nAT ][ 2 ]	:= .T.
		Else
			aDel( __aFreeLocks , nAT )
			aSize( __aFreeLocks , ( --__nFreeLocks ) )
		EndIF
	EndIF

Return( lFreeLocks )

/*/
	Funcao: 	_FreeLocks
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Uso:		Liberar Multiplos Locks
    Sintaxe:    StaticCall( NDJLIB003 , _FreeLocks , aFreeLocks )
/*/
Static Function _FreeLocks( aFreeLocks )

	Local nLoop
	Local nLoops

	Local oException

	TRYEXCEPTION

		nLoops := Len( aFreeLocks )
		For nLoop := 1 To nLoops
			FreeLocks( aFreeLocks[ nLoop , 1 ] , aFreeLocks[ nLoop , 2 ] , .T. , aFreeLocks[ nLoop , 3 ] )
		Next nLoop
		
	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION	

Return( NIL )

/*/
	Funcao: 	SetFreeLock
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Uso:		Armazena Locks Para Liberacao Futura
    Sintaxe:    StaticCall( NDJLIB003 , SetFreeLock , cAlias , aRecnos , aKeys )
/*/
Static Function SetFreeLock( cAlias , aRecnos , aKeys )

	DEFAULT cAlias	:= Alias()

	cAlias			:= Upper( AllTrim( cAlias ) )

	IF !Empty( cAlias )
		aAdd( __aSetFreeLock , { cAlias , aRecnos , aKeys } )
		++__nSetFreeLock
	EndIF	

Return( __aSetFreeLock )

/*/
	Funcao: 	GetFreeLock
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Uso:		Obtem os Locks a serem Liberados
    Sintaxe:    StaticCall( NDJLIB003 , GetFreeLock , cAlias )
/*/
Static Function GetFreeLock( cAlias )

	Local aFreeLock	:= {}

	Local nAT		:= 0

	DEFAULT cAlias	:= Alias()

	cAlias			:= Upper( AllTrim( cAlias ) )

	While ( ( nAT := aScan( __aSetFreeLock , { |aFreeLck| ( aFreeLck[ 1 ] == cAlias ) } , ++nAT ) ) > 0 )
		aAdd( aFreeLock , __aSetFreeLock[ nAT ] )
		aDel( __aSetFreeLock , nAT )
		aSize( __aSetFreeLock , ( --__nSetFreeLock ) )
	End While	

Return( aFreeLock )

/*/
	Funcao: 	LockSoft
	Autor:		Marinaldo de Jesus
	Data:		11/08/2011
	Uso:		Adiciona Alias para AliasUnLock
    Sintaxe:    StaticCall( NDJLIB003 , LockSoft , cAlias , @aAliasLock )
/*/
Static Function LockSoft( cAlias , aAliasLock )

	Local aLock	:= {}
	Local lLock	:= .F.

	Local nBL
	Local nEL

	DEFAULT cAlias	:= Alias()

	cAlias	:= Upper( AllTrim( cAlias ) )

	IF !Empty( cAlias )	

		lLock	:= ( cAlias )->( SoftLock( @cAlias ) )

		IF ( lLock )
			aLock 				:= AliasLock( @cAlias )
			nEL					:= __nAliasLock
			DEFAULT aAliasLock	:= {}
			For nBL := 1 To nBL
				IF ( aScan( aAliasLock , { |cAlias| cAlias  == aLock[ nBL ] } ) == 0 )
					aAdd( aAliasLock , aLock[ nBL ] )
				EndIF
			Next nEL
		EndIF

	EndIF	

Return( lLock )

/*/
	Funcao: 	AliasLock
	Autor:		Marinaldo de Jesus
	Data:		11/08/2011
	Uso:		Adiciona Alias para AliasUnLock
    Sintaxe:    StaticCall( NDJLIB003 , AliasLock , cAlias )
/*/
Static Function AliasLock( cAlias )

	DEFAULT cAlias	:= Alias()

	cAlias	:= Upper( AllTrim( cAlias ) )

	IF !Empty( cAlias )
		IF ( aScan( __aAliasLock , { |cAliasLck| cAliasLck == cAlias } ) == 0 )
			aAdd( __aAliasLock , cAlias )
			++__nAliasLock
		EndIF
	EndIF	

Return( __aAliasLock )

/*/
	Funcao: 	AliasUnLock
	Autor:		Marinaldo de Jesus
	Data:		11/08/2011
	Uso:		Libera Todos os Locks Obtidos pela AliasLock 
    Sintaxe:    StaticCall( NDJLIB003 , AliasUnLock , aAliasLock )
/*/
Static Function AliasUnLock( aAliasLock )

	Local aFreeLocks
	
	Local cAlias

	Local nBL
	Local nEL
	Local nAT

	DEFAULT aAliasLock	:= aClone( __aAliasLock )

	nEL	:= Len( aAliasLock )
	For nBL := 1 To nEL
		cAlias	:= Upper( AllTrim( aAliasLock[ nBL ] ) )
		IFreeLocks( cAlias , .T. )
		aFreeLocks	:= GetFreeLock( cAlias )
		_FreeLocks( @aFreeLocks )
		While ( ( nAT := aScan( __aAliasLock , { |cAliasLck| cAliasLck == cAlias } , ++nAT ) ) > 0 )
			( cAlias )->( UnLockAll() )
			aDel( __aAliasLock , nAT )
			aSize( __aAliasLock , ( --__nAliasLock ) )
		End While
	Next nBL

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	USECODE()
		SETFREELOCK()
		ALIASUNLOCK()
		LOCKSOFT()
    	lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )