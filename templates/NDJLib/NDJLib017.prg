#include "fileio.ch"
#include "tbiconn.ch"
#include "protheus.ch"
#include "tryexception.ch"
/*/
	CLASS:		ufT
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Alternativa aas funcoes tipo FT_F* devido as limitacoes apontadas em (http://tdn.totvs.com.br/kbm#9734)
	Sintaxe:	uft():New() : Objeto do Tipo fT
/*/
CLASS ufT FROM LongClassName

	DATA aLines
	
	DATA cCRLF
	DATA cFile
	DATA cLine

	DATA cClassName

	DATA nRecno
	DATA nfHandle
	DATA nFileSize
	DATA nLastRecno
	DATA nBufferSize

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
	METHOD ft_fSetBufferSize( nBufferSize )

END CLASS

User Function uft()
Return(uft():New())

/*/
	METHOD:		New
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	CONSTRUCTOR
	Sintaxe:	uft():New() : Object do Tipo fT				
/*/
METHOD New() CLASS ufT

	Self:aLines			:= Array(0)	

	Self:cFile			:= ""
	Self:cLine			:= ""

	Self:cClassName		:= "UFT"

	Self:nRecno			:= 0
	Self:nLastRecno		:= 0
	Self:nfHandle		:= -1
	Self:nFileSize		:= 0

	Self:ft_fSetCRLF()
	Self:ft_fSetBufferSize()

Return( Self )

/*/
	METHOD:		ClassName
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retornar o Nome da Classe
	Sintaxe:	uft():ClassName() : Retorna o Nome da Classe
/*/
METHOD ClassName() CLASS ufT
Return( Self:cClassName )

/*/
	METHOD:		ft_fUse
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Abrir o Arquivo Passado como Parametro
	Sintaxe:	uft():ft_fUse( cFile ) : nfHandle ( nfHandle > 0 True, False)
/*/
METHOD ft_fUse( cFile ) CLASS ufT

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
	Sintaxe:	uft():ft_fOpen( cFile ) : nfHandle ( nfHandle > 0 True, False)
/*/
METHOD ft_fOpen( cFile ) CLASS ufT

	TRYEXCEPTION

		IF !( Self:ft_fExists( cFile ) )
			BREAK
		EndIF

		Self:cFile		:= cFile
		Self:nfHandle	:= fOpen( Self:cFile , FO_READ )
		
		IF ( Self:nfHandle <= 0 )
			BREAK
		EndIF
		
		Self:nFileSize	:= fSeek( Self:nfHandle , 0 , FS_END )

		fSeek( Self:nfHandle , 0 , FS_SET )

		Self:nFileSize	:= ReadFile( @Self:aLines , @Self:nfHandle , @Self:nBufferSize , @Self:nFileSize , @Self:cCRLF )

		Self:ft_fGoTop()

	CATCHEXCEPTION
	
		Self:nfHandle := -1
	
	ENDEXCEPTION

Return( Self:nfHandle )

/*/
	Funcao:		ReadFile
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Percorre o Arquivo a ser lido e alimento o Array aLines
	Sintaxe:	ReadFile( aLines , nfHandle , nBufferSize , nFileSize , cCRLF ) : nLines Read
/*/
Static Function ReadFile( aLines , nfHandle , nBufferSize , nFileSize , cCRLF )
    
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
			aAdd( aLines , cLine )
		end while
	end while

	if .not.( empty( cBuffer ) )
		++nLines
		aAdd( aLines , cBuffer )
	endif

Return( nLines )

/*/
	METHOD:		ft_fClose
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Fechar o Arquivo aberto pela ft_fOpen ou ft_fUse
	Sintaxe:	uft():ft_fClose() : NIL
/*/
METHOD ft_fClose() CLASS ufT

	IF ( Self:nfHandle > 0 )
		fClose( Self:nfHandle )
	EndIF

	aSize( Self:aLines , 0 )

	Self:cFile			:= ""
	Self:cLine			:= ""

	Self:nRecno			:= 0
	Self:nfHandle		:= -1
	Self:nFileSize		:= 0
	Self:nLastRecno		:= 0

Return( NIL )

/*/
	METHOD:		ft_fAlias
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retornar o Nome do Arquivo Atualmente Aberto
	Sintaxe:	uft():ft_fAlias() : cFile
/*/
METHOD ft_fAlias() CLASS ufT
Return( Self:cFile )

/*/
	METHOD:		ft_fExists
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se o Arquivo Existe
	Sintaxe:	uft():ft_fExists( cFile ) : lExists
/*/
METHOD ft_fExists( cFile ) CLASS ufT

	Local lExists	:= .F.

	TRYEXCEPTION

		IF Empty( cFile )
			BREAK
		EndIF

		lExists := File( cFile )

	CATCHEXCEPTION
	
		lExists := .F.

	ENDEXCEPTION

Return( lExists )

/*/
	METHOD:		ft_fRecno
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Recno Atual
	Sintaxe:	uft():ft_fRecno() : nRecno
/*/
METHOD ft_fRecno() CLASS ufT
Return( Self:nRecno )

/*/
	METHOD:		ft_fSkip
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta n Posicoes 
	Sintaxe:	uft():ft_fSkip( nSkipper ) : nRecno
/*/
METHOD ft_fSkip( nSkipper ) CLASS ufT

	DEFAULT nSkipper	:= 1

	Self:nRecno	+= nSkipper

Return( Self:nRecno )

/*/
	METHOD:		ft_fGoTo
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Registro informando em nGoto
	Sintaxe:	uft():ft_fGoTo( nGoTo ) : nRecno
/*/
METHOD ft_fGoTo( nGoTo ) CLASS ufT

	Self:nRecno	:= nGoTo

Return( Self:nRecno )

/*/
	METHOD:		ft_fGoTop
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Inicio do Arquivo
	Sintaxe:	uft():ft_fGoTo( nGoTo ) : nRecno
/*/
METHOD ft_fGoTop() CLASS ufT
Return( Self:ft_fGoTo( 1 ) )

/*/
	METHOD:		ft_fGoBottom
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Salta para o Final do Arquivo
	Sintaxe:	uft():ft_fGoBottom() : nRecno
/*/
METHOD ft_fGoBottom() CLASS ufT
Return( Self:ft_fGoTo( Self:nFileSize ) )

/*/
	METHOD:		ft_fLastRec
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Numero de Registro do Arquivo
	Sintaxe:	uft():ft_fLastRec() : nRecCount
/*/
METHOD ft_fLastRec() CLASS ufT
Return( Self:nFileSize )

/*/
	METHOD:		ft_fRecCount
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Numero de Registro do Arquivo
	Sintaxe:	uft():ft_fRecCount() : nRecCount
/*/
METHOD ft_fRecCount() CLASS ufT
Return( Self:nFileSize )

/*/
	METHOD:		ft_fEof
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se Atingiu o Final do Arquivo
	Sintaxe:	uft():ft_fEof() : lEof
/*/
METHOD ft_fEof() CLASS ufT
Return( Self:nRecno > Self:nFileSize )

/*/
	METHOD:		ft_fBof
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Verifica se Atingiu o Inicio do Arquivo
	Sintaxe:	uft():ft_fBof() : lBof
/*/
METHOD ft_fBof() CLASS ufT
Return( Self:nRecno < 1 )

/*/
	METHOD:		ft_fReadLine
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Le a Linha do Registro Atualmente Posicionado
	Sintaxe:	uft():ft_fReadLine() : cLine
/*/
METHOD ft_fReadLine() CLASS ufT

	TRYEXCEPTION

		Self:nLastRecno	:= Self:nRecno
		Self:cLine		:= Self:aLines[ Self:nRecno ]

	CATCHEXCEPTION

		Self:cLine	:= ""

	ENDEXCEPTION

Return( Self:cLine )

/*/
	METHOD:		ft_fReadLn
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Le a Linha do Registro Atualmente Posicionado
	Sintaxe:	uft():ft_fReadLn() : cLine
/*/
METHOD ft_fReadLn() CLASS ufT
Return( Self:ft_fReadLine() )

/*/
	METHOD:		ft_fError
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Retorna o Ultimo erro ocorrido
	Sintaxe:	uft():ft_fError( @cError ) : nDosError
/*/
METHOD ft_fError( cError ) CLASS ufT
	cError	:= CaptureError()
Return( fError() )

/*/
	METHOD:		ft_fSetBufferSize
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Redefine nBufferSize
	Sintaxe:	uft():ft_fSetBufferSize( nBufferSize ) : nLastBufferSize
/*/
METHOD ft_fSetBufferSize( nBufferSize ) CLASS ufT

	Local nLastBufferSize	:= Self:nBufferSize

	DEFAULT nBufferSize	:= 1024
	
	Self:nBufferSize	:= nBufferSize
	Self:nBufferSize	:= Max( Self:nBufferSize , 1 )

Return( nLastBufferSize )

/*/
	METHOD:		ft_fSetCRLF
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		01/05/2011
	Descricao:	Redefine cCRLF
	Sintaxe:	uft():ft_fSetCRLF( cCRLF ) : nLastCRLF
/*/
METHOD ft_fSetCRLF( cCRLF ) CLASS ufT

	Local cLastCRLF	:= Self:cCRLF
	
	DEFAULT cCRLF	:= CRLF
	
	Self:cCRLF		:= cCRLF

Return( cLastCRLF )