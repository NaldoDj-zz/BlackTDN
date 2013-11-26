#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "DBSTRUCT.CH"
/*/
	CLASS:		fTdb
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Alternativa aas funcoes tipo FT_F* devido as limitacoes apontadas em (http://tdn.totvs.com.br/kbm#9734)
	Sintaxe:	ftdb():New() : Objeto do Tipo fT
/*/
CLASS fTdb FROM fT

	DATA cDbFile
	DATA cDbAlias
	DATA cRDDName

	METHOD New()		CONSTRUCTOR
	METHOD ClassName()

	METHOD ft_fUse( cFile )
	METHOD ft_fOpen( cFile )
	METHOD ft_fClose()
	
	METHOD ft_fAlias()
	
	METHOD ft_fExists( cFile )
	
	METHOD ft_fRecno()
	METHOD ft_fSkip( nSkipper )
	METHOD ft_fGoTo( nGoTo )
	METHOD ft_fGoTop()
	METHOD ft_fGoBottom()
	METHOD ft_fLastRec()
	METHOD ft_fRecCount()

	METHOD ft_fEof()
	METHOD ft_fBof()

	METHOD ft_fReadLn()
	METHOD ft_fReadLine()
	
	METHOD ft_fError( cError )

	METHOD ft_fSetCRLF( cCRLF )
	METHOD ft_fSetRddName( cRddName )
	METHOD ft_fSetBufferSize( nBufferSize )

END CLASS

User Function ftdb()
Return( NIL )

/*/
	METHOD:		New
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	CONSTRUCTOR
	Sintaxe:	ftdb():New() : Object do Tipo fT				
/*/
METHOD New() CLASS fTdb

	_Super:New()

	Self:cDbFile	:= ""
	Self:cDbAlias	:= ""

	Self:cClassName	:= "FTDB"

	Self:ft_fSetRddName()

Return( Self )

/*/
	METHOD:		ClassName
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retornar o Nome da Classe
	Sintaxe:	ftdb():ClassName() : Retorna o Nome da Classe
/*/
METHOD ClassName() CLASS fTdb
Return( Self:cClassName )

/*/
	METHOD:		ft_fUse
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Abrir o Arquivo Passado como Parametro
	Sintaxe:	ftdb():ft_fUse( cFile ) : nfHandle ( nfHandle > 0 True, False)
/*/
METHOD ft_fUse( cFile ) CLASS fTdb

	TRYEXCEPTION

		IF !( Self:ft_fExists( cFile ) )
			BREAK
		EndIF

		Self:ft_fOpen( cFile )
	
	CATCHEXCEPTION

		Self:ft_fClose()

	ENDEXCEPTION

Return( Self:nfHandle )

/*/
	METHOD:		ft_fOpen
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Abrir o Arquivo Passado como Parametro
	Sintaxe:	ftdb():ft_fOpen( cFile ) : nfHandle ( nfHandle > 0 True, False)
/*/
METHOD ft_fOpen( cFile ) CLASS fTdb

	Local adbStruct := { { "LINE" , "M" , 80 , 0 } }
	
	Local lNewArea	:= .T.
	Local lShared	:= .T.
	Local lReadOnly	:= .F.
	Local lHelp		:= .F.
	Local lQuit		:= .F.

	TRYEXCEPTION

		IF !( Self:ft_fExists( cFile ) )
			BREAK
		EndIF

		Self:cFile		:= cFile
		Self:nfHandle	:= fOpen( Self:cFile , FO_READ )
		
		IF ( Self:nfHandle <= 0 )
			BREAK
		EndIF
		
		Self:cDbFile		:= CriaTrab( NIL , .F. )
		While MsFile( Self:cDbFile , NIL , Self:cRddName )
			Self:cDbFile	:= CriaTrab( NIL , .F. )
		End While
		
		Self:cDbFile		+= IF( ( Self:cRddName == "TOPCONN" ) , "" , GetDbExtension() )

		IF !( MsCreate( Self:cDbFile , adbStruct , Self:cRddName ) )
			BREAK
		EndIF

		Self:cDbAlias	:= GetNextAlias()
		
		IF !( MsOpEndbf( @lNewArea , Self:cRddName , Self:cDbFile , Self:cDbAlias , @lShared , @lReadOnly , @lHelp , @lQuit ) )
			BREAK
		EndIF

		Self:nFileSize	:= fSeek( Self:nfHandle , 0 , FS_END )

		fSeek( Self:nfHandle , 0 , FS_SET )

		Self:nFileSize	:= ReadFile( Self:cDbAlias , @Self:nfHandle , @Self:nBufferSize , @Self:nFileSize , @Self:cCRLF )

		Self:ft_fGoTop()

	CATCHEXCEPTION
	
		Self:ft_fClose()
	
	ENDEXCEPTION

Return( Self:nfHandle )

/*/
	Funcao:		ReadFile
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Percorre o Arquivo a ser lido e alimento o Array aLines
	Sintaxe:	ReadFile( cAlias , nfHandle , nBufferSize , nFileSize , cCRLF ) : nLines Read
/*/
Static Function ReadFile( cAlias , nfHandle , nBufferSize , nFileSize , cCRLF )
    
	Local cLine
	Local cBuffer

	Local nLines		:= 0
	Local nAtPlus		:= ( len( cCRLF ) -1 )
	Local nBytesRead	:= 0

	fSeek( nfHandle , 0 )

	cBuffer				:= ""
	while ( nBytesRead <= nFileSize )
		cBuffer 	+= fReadStr( @nfHandle , @nBufferSize )
		nBytesRead	+= nBufferSize
		while ( cCRLF $ cBuffer )
			++nLines
			cLine 	:= subStr( cBuffer , 1 , ( at( cCRLF , cBuffer ) + nAtPlus ) )
			cBuffer	:= subStr( cBuffer , len( cLine ) + 1 )
			cLine	:= strTran( cLine , cCRLF , "" )
			( cAlias )->( dbAppend( .T. ) )
			( cAlias )->( FieldPut( 1 , cLine  ) )
			cLine		:= ""
		end while
	end while

	if .not.( empty( cBuffer ) )
		++nLines
		( cAlias )->( dbAppend( .T. ) )
		( cAlias )->( FieldPut( 1 , cBuffer ) )
		cBuffer	:= ""
	endif

Return( nLines )

/*/
	METHOD:		ft_fClose
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Fechar o Arquivo aberto pela ft_fOpen ou ft_fUse
	Sintaxe:	ftdb():ft_fClose() : NIL
/*/
METHOD ft_fClose() CLASS fTdb

	Local cMemoFile
	
	_Super:ft_fClose()

	IF ( Select( Self:cDbAlias ) > 0 )
		( Self:cDbAlias )->( dbCloseArea() )
	EndIF

	IF MsFile( Self:cDbFile , NIL , Self:cRddName )
		MsErase( Self:cDbFile , NIL , Self:cRddName )
	EndIF
	
	cMemoFile := ( FileNoExt( Self:cDbFile ) + ".fpt" )
	
	IF File( cMemoFile )
		fErase( cMemoFile )
	EndIF

	Self:cDbFile	:= ""
	Self:cDbAlias	:= ""

Return( NIL )

/*/
	METHOD:		ft_fAlias
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retornar o Nome do Arquivo Atualmente Aberto
	Sintaxe:	ftdb():ft_fAlias() : cFile
/*/
METHOD ft_fAlias() CLASS fTdb
Return( Self:cDbAlias )

/*/
	METHOD:		ft_fExists
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se o Arquivo Existe
	Sintaxe:	ftdb():ft_fExists( cFile ) : lExists
/*/
METHOD ft_fExists( cFile ) CLASS fTdb
Return( _Super:ft_fExists( cFile ) )

/*/
	METHOD:		ft_fRecno
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Recno Atual
	Sintaxe:	ftdb():ft_fRecno() : nRecno
/*/
METHOD ft_fRecno() CLASS fTdb
	Self:nRecno := ( Self:cDbAlias )->( Recno() )
Return( Self:nRecno )

/*/
	METHOD:		ft_fSkip
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta n Posicoes 
	Sintaxe:	ftdb():ft_fSkip( nSkipper ) : nRecno
/*/
METHOD ft_fSkip( nSkipper ) CLASS fTdb
	DEFAULT nSkipper	:= 1
	( Self:cDbAlias )->( dbSkip( nSkipper ) )
	Self:nRecno	:= Self:ft_fRecno()
Return( Self:nRecno )

/*/
	METHOD:		ft_fGoTo
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Registro informando em nGoto
	Sintaxe:	ftdb():ft_fGoTo( nGoTo ) : nRecno
/*/
METHOD ft_fGoTo( nGoTo ) CLASS fTdb
	( Self:cDbAlias )->( dbGoto( nGoTo ) )
	Self:nRecno	:= Self:ft_fRecno()
Return( Self:nRecno )

/*/
	METHOD:		ft_fGoTop
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Inicio do Arquivo
	Sintaxe:	ftdb():ft_fGoTo( nGoTo ) : nRecno
/*/
METHOD ft_fGoTop() CLASS fTdb
	( Self:cDbAlias )->( dbGoTop() )
	Self:nRecno	:= Self:ft_fRecno()
Return( Self:nRecno )

/*/
	METHOD:		ft_fGoBottom
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Final do Arquivo
	Sintaxe:	ftdb():ft_fGoBottom() : nRecno
/*/
METHOD ft_fGoBottom() CLASS fTdb
	( Self:cDbAlias )->( dbGoBottom() )
	Self:nRecno	:= Self:ft_fRecno()
Return( Self:nRecno )

/*/
	METHOD:		ft_fLastRec
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Numero de Registro do Arquivo
	Sintaxe:	ftdb():ft_fLastRec() : nRecCount
/*/
METHOD ft_fLastRec() CLASS fTdb
Return( ( Self:cDbAlias )->( LastRec() ) )

/*/
	METHOD:		ft_fRecCount
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Numero de Registro do Arquivo
	Sintaxe:	ftdb():ft_fRecCount() : nRecCount
/*/
METHOD ft_fRecCount() CLASS fTdb
Return( ( Self:cDbAlias )->( RecCount() ) )

/*/
	METHOD:		ft_fEof
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se Atingiu o Final do Arquivo
	Sintaxe:	ftdb():ft_fEof() : lEof
/*/
METHOD ft_fEof() CLASS fTdb
Return( ( Self:cDbAlias )->( Eof() ) )

/*/
	METHOD:		ft_fBof
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se Atingiu o Inicio do Arquivo
	Sintaxe:	ftdb():ft_fBof() : lBof
/*/
METHOD ft_fBof() CLASS fTdb
Return( ( Self:cDbAlias )->( Bof() ) )

/*/
	METHOD:		ft_fReadLine
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Le a Linha do Registro Atualmente Posicionado
	Sintaxe:	ftdb():ft_fReadLine() : cLine
/*/
METHOD ft_fReadLine() CLASS fTdb

	TRYEXCEPTION

		Self:nLastRecno	:= Self:nRecno
		Self:cLine		:= ( Self:cDbAlias )->( FieldGet( 1 ) )

	CATCHEXCEPTION

		Self:cLine	:= ""

	ENDEXCEPTION

Return( Self:cLine )

/*/
	METHOD:		ft_fReadLn
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Le a Linha do Registro Atualmente Posicionado
	Sintaxe:	ftdb():ft_fReadLn() : cLine
/*/
METHOD ft_fReadLn() CLASS fTdb
Return( Self:ft_fReadLine() )

/*/
	METHOD:		ft_fError
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Ultimo erro ocorrido
	Sintaxe:	ftdb():ft_fError( @cError ) : nDosError
/*/
METHOD ft_fError( cError ) CLASS fTdb
	cError	:= CaptureError()
Return( fError() )

/*/
	METHOD:		ft_fSetBufferSize
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Redefine nBufferSize
	Sintaxe:	ftdb():ft_fSetBufferSize( nBufferSize ) : nLastBufferSize
/*/
METHOD ft_fSetBufferSize( nBufferSize ) CLASS fTdb
Return( _Super:ft_fSetBufferSize( @nBufferSize ) )

/*/
	METHOD:		ft_fSetCRLF
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Redefine cCRLF
	Sintaxe:	ftdb():ft_fSetCRLF( cCRLF ) : nLastCRLF
/*/
METHOD ft_fSetCRLF( cCRLF ) CLASS fTdb
Return( _Super:ft_fSetCRLF( @cCRLF ) )

/*/
	METHOD:		ft_fSetRddName
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]`
	Data:		01/05/2011
	Descricao:	Redefine cRddName
	Sintaxe:	ftdb():ft_fSetRddName( cRddName ) : cLastRddName
/*/
METHOD ft_fSetRddName( cRddName ) CLASS fTdb
	Local cLastRddName	:= Self:cRddName
	DEFAULT cRddName	:= "DBFCDXADS"
	Self:cRddName		:= Upper( cRddName )
Return( cLastRddName )