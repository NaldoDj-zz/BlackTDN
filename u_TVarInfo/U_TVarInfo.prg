#INCLUDE "SHELL.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE STACK_NAME		 		1
#DEFINE STACK_PARAMETER	 		2

#DEFINE STACK_ELEMENTS			2

#DEFINE CLS_NAME				1

Static __cClassName		:= "[TVarInfo][cClassName]"

Static __nClsIntSleep	:= 0
Static __nClsAddSleep	:= 0
Static __nClsNIntSleep	:= 0
Static __nClsVAddSleep	:= 0

/*/
	Class:		TVarInfo [ Baseada na Ideia Original de Julio Wittwer ]
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Reproduz as Caracteristicas da Funcao VarInfo resolvendo a Limitacao do Tamanho da String
	Sintaxe:	TVarInfo():New( uVarInfo , cVarName , nClsIntSleep , @nClsAddSleep )
/*/
Class TVarInfo From LongClassName

	DATA aTVarInfo
	
	DATA cClassName

	DATA nAT
	DATA nSize

	DATA cCRLF
	DATA cSRVFile
	DATA cLocalFile
	DATA cLocalPath

	DATA lBof
	DATA lEof
	
	DATA cDateFormat
	DATA lSetCentury

	DATA nfHandle

	Method New( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep )
	Method Init( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep )
	Method Reset( uVarInfo , cVarName , lEraseSrv , lEraseLocal )

	Method Echo( lHtml , lTableFormat )
	Method Show( nSWShow )

	Method Save( lHtml , lTableFormat )

	Method GoTo( n )
	Method GoTop()
	Method GoBottom()
	Method GoNext()

	Method Close( lEraseSrv , lEraseLocal )

End Class

/*/
	Funcao:		U_TVarInfoNew
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Reproduz as Caracteristicas da Funcao VarInfo resolvendo a Limitacao do Tamanho da String
	Sintaxe:	U_TVarInfoNew( uVarInfo , cVarName )
/*/
User Function TVarInfoNew( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep )
Return( TVarInfo():New( @uVarInfo , @cVarName , @nClsIntSleep , @nClsAddSleep ) )

/*/
	Method:		New
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Constructor
	Sintaxe:	TVarInfo():New( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep )
/*/
Method New( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep ) Class TVarInfo

	Self:Init( @uVarInfo , @cVarName , @nClsIntSleep , @nClsAddSleep )

Return( Self )

/*/
	Method:		Init
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Inicializa
/*/
Method Init( uVarInfo , cVarName , nClsIntSleep , nClsAddSleep ) Class TVarInfo

	Local aStackA		:= Array(0)
	Local aStackO		:= Array(0)
	
	Local cVarType
	
	Local nStackA		:= 0
	Local nStackO		:= 0

	IF ( cVarName == NIL )
		cVarType 		:= ValType( uVarInfo )
		DO CASE
		CASE ( cVarType == "A" )
			cVarName 	:= "[VAR_ARRAY]"
		CASE ( cVarType == "C" )
			cVarName 	:= "[VAR_STRING]"
		CASE ( cVarType == "D" )
			cVarName 	:= "[VAR_DATE]"
		CASE ( cVarType == "O" )
			cVarName 	:= "[VAR_OBJECT]"
		CASE ( cVarType == "L" )
			cVarName 	:= "[VAR_BOOLEAN]"
		CASE ( cVarType == "N" )
			cVarName 	:= "[VAR_NUMERIC]"
		CASE ( cVarType == "U" )
			cVarName 	:= "[VAR_NOTSET]"
		OTHERWISE
			cVarName 	:= "[VAR_"+cVarType+"]"
		ENDCASE			
	EndIF

	Self:cClassName			:= "TVARINFO"
	Self:aTVarInfo			:= Array(0)
	Self:cSRVFile			:= ""
	Self:cLocalFile			:= ""
	Self:cLocalPath			:= ""
	Self:nfHandle			:= -1
	Self:lSetCentury		:= __SetCentury("ON")
	Self:cDateFormat		:= Set( 4 , "dd/mm/yyyy" )

	DEFAULT Self:cCRLF		:= CRLF

	/*
		[TVARINFO]
		ClsIntSleep=5;Valor Inicial na Ocorrencia da Exception. Incremente em 5
		ClsAddSleep=1;Valor Inicial na Ocorrencia da Exception. Incremente em 1
	*/
	DEFAULT nClsIntSleep	:= Val(GetPvProfString("TVARINFO","ClsIntSleep","0",GetSrvIniName()))
	DEFAULT nClsAddSleep	:= Val(GetPvProfString("TVARINFO","ClsAddSleep","0",GetSrvIniName()))

	__nClsIntSleep			:= nClsIntSleep
	__nClsAddSleep			:= nClsAddSleep
	__nClsNIntSleep			:= Int( __nClsIntSleep / 2 )
	__nClsVAddSleep			:= 0

	TVarInfo( @Self:aTVarInfo , @aStackA , @nStackA , @aStackO , @nStackO , @cVarName , @uVarInfo )
	nStackA := 0
	aSize( aStackA , nStackA )
	nStackO := 0
	aSize( aStackO , nStackO )

	Self:nSize			:= Len( Self:aTVarInfo )

	IF ( Self:nSize > 0 )
		Self:nAT		:= 1
		Self:lBof		:= .F.
		Self:lEof		:= .F.
	Else
		Self:nAT		:= 0
		Self:lBof		:= .T.
		Self:lEof		:= .T.
	EndIF	

Return( NIL )

/*/
	Method:		ReSet
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	ReSet
/*/
Method ReSet( uVarInfo , cVarName , lEraseSrv , lEraseLocal ) Class TVarInfo
	Self:Close( @lEraseSrv , @lEraseLocal )
	Self:Init( @uVarInfo , @cVarName )	
Return( NIL )

/*/
	Method:		GoTo
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Posiciona no Registro n
/*/
Method GoTo( n ) Class TVarInfo
	DEFAULT n := 0
Return( Self:nAT := n )

/*/
	Method:		GoTop
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	GoTop
/*/
Method GoTop() Class TVarInfo
Return( Self:nAT := Min( 1 , Self:nSize ) )

/*/
	Method:		GoBottom
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	GoBottom
/*/
Method GoBottom() Class TVarInfo
Return( Self:nAT := Self:nSize )

/*/
	Method:		GoNext
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Tenta Obter o Proximo Registro
/*/
Method GoNext() Class TVarInfo

	Local lGoNext	:= .F.

	IF ( Self:nSize > 0 )

		++Self:nAT

		Self:lBof	:= ( Self:nAT <= 0 )
		Self:lEof	:= ( Self:nAT > Self:nSize )

		lGoNext		:= !( Self:lBof .or. Self:lEof )

		IF !( lGoNext )
			Self:nAT	:= 1
			Self:lBof	:= .F.
			Self:lEof	:= .F.
		EndIF

	Else

		Self:nAT	:= 0
		Self:lBof	:= .T.
		Self:lEof	:= .T.

	EndIF

Return( lGoNext )

/*/
	Method:		Echo
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Retorna a Linha Atual
/*/
Method Echo( lHtml , lTableFormat ) Class TVarInfo

	Local cEcho				:= ""
	
	DEFAULT lHtml			:= .F.
	DEFAULT lTableFormat    := .F.

	IF ( Self:nAT > 0 .and. Self:nAT <= Self:nSize )
		IF ( lHtml )
			IF ( Self:nAT == 1 )
				cEcho		+= "<html>" + Self:cCRLF
				cEcho		+= "	<head>" + Self:cCRLF
				cEcho		+= "	</head>" + Self:cCRLF
				cEcho		+= "	<body>" + Self:cCRLF
				IF ( lTableFormat )
					cEcho	+= "		<table border='0'>" + Self:cCRLF
					cEcho	+= "			<thead>" + Self:cCRLF
					cEcho	+= "				<tr>" + Self:cCRLF
					cEcho	+= "					<th>" + Self:cCRLF
					cEcho	+= "					</th>" + Self:cCRLF
					cEcho	+= "				</tr>" + Self:cCRLF
					cEcho	+= "			</thead>" + Self:cCRLF
					cEcho	+= "			<tfoot>" + Self:cCRLF
					cEcho	+= "			</tfoot>" + Self:cCRLF
					cEcho	+= "			<tbody>" + Self:cCRLF
				Else
					cEcho	+= "		<pre>" + Self:cCRLF
				EndIF
			EndIF
			IF ( lTableFormat )
				cEcho		+= "				<tr>" + Self:cCRLF
    			cEcho		+= "					<td>" + Self:cCRLF
				cEcho		+= "						<pre>" + Self:cCRLF
			EndIF
			cEcho			+= Self:aTVarInfo[ Self:nAT ] + Self:cCRLF
			IF ( lTableFormat )
				cEcho		+= "						</pre>" + Self:cCRLF
				cEcho		+= "					</td>" + Self:cCRLF
				cEcho		+= "				</tr>" + Self:cCRLF
			EndIF
			IF ( Self:nAT == Self:nSize )
				IF ( lTableFormat )
					cEcho	+= "			</tbody>" + Self:cCRLF
					cEcho	+= "		</table>" + Self:cCRLF
				Else
					cEcho	+= "		</pre>" + Self:cCRLF
				EndIF	
				cEcho		+= "	</body>" + Self:cCRLF
				cEcho		+= "</html>" + Self:cCRLF
			EndIF
		Else
			cEcho			+= Self:aTVarInfo[ Self:nAT ]
			cEcho			+= Self:cCRLF
		EndIF
	EndIF

Return( cEcho )

/*/
	Method:		Show
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Apresenta o Conteudo obtido pela VarInfo
/*/
Method Show( nSWShow ) Class TVarInfo

	Local lShow	:= .F.

	IF (;
			( Self:nfHandle > 0 );
			.and.;
			File( Self:cSRVFile );
		)	

		Self:cLocalPath	:= GetTempPath()
	
		IF !( SubStr( Self:cLocalPath , -1 ) == "\" )
			Self:cLocalPath += "\"
		EndIF
	
		Self:cLocalFile	:= ( Self:cLocalPath + Self:cSRVFile )

		lShow	:= __CopyFile( Self:cSRVFile , Self:cLocalFile )
		IF ( lShow )              
			DEFAULT nSWShow := SW_SHOWMAXIMIZED
			ShellExecute( "Open", Self:cLocalFile , "" , Self:cLocalPath , nSWShow )
		EndIF

	EndIF
	
Return( lShow )

/*/
	Method:		Save
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Salva o Conteudo Obtivo pela VarInfo
/*/
Method Save( lHtml , lTableFormat ) Class TVarInfo

	Local cExt
	Local cEcho
	
	Local lSave			:= .F.

	DEFAULT lHtml		:= .F.
	IF ( lHtml )
		cExt 			:= ".html"
	Else
		cExt 			:= ".txt"
	EndIF

	Self:cSRVFile		:= ( Lower( CriaTrab( NIL , .F. ) ) + cExt )
	While File( Self:cSRVFile )
		Self:cSRVFile	:= ( Lower( CriaTrab( NIL , .F. ) ) + cExt )
	End While

	Self:nfHandle		:= fCreate( Self:cSRVFile , FC_NORMAL )
	IF ( ( fError() == 0 ) .and. File( Self:cSRVFile ) )
		fClose( Self:nfHandle )
		Self:nfHandle	:= fOpen( Self:cSRVFile , FO_READWRITE )
		IF ( fError() == 0 )
			cEcho	:= Self:Echo( @lHtml , @lTableFormat )
			fWrite( Self:nfHandle , cEcho )
			While ( Self:GoNext() )
				cEcho	:= Self:Echo( @lHtml , @lTableFormat )
				fWrite( Self:nfHandle , cEcho )
			End While
			fClose( Self:nfHandle )
			Self:nfHandle	:= fOpen( Self:cSRVFile , FO_SHARED )
			lSave			:= ( fError() == 0 )
		EndIF
	EndIF	

Return( lSave )

/*/
	Method:		Close
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Fecha e exclui os arquivos utilizados
/*/
Method Close(lEraseSrv,lEraseLocal) Class TVarInfo

	DEFAULT lEraseSrv	:= .T.
	DEFAULT lEraseLocal	:= .T.

	IF ( Self:nfHandle > 0 )
		fClose( Self:nfHandle )
		Self:nfHandle	:= -1
	EndIF

	IF !Empty( Self:cSRVFile )
		IF ( lEraseSrv )
			fErase( Self:cSRVFile )
		EndIF	
		Self:cSRVFile	:= ""
	EndIF

	IF !Empty( Self:cLocalFile )
		IF ( lEraseLocal )
			fErase( Self:cLocalFile )		
		EndIF	
		Self:cLocalFile	:= ""
	EndIF

	Self:cLocalPath	:= ""

	aSize( Self:aTVarInfo , 0 )
	Self:nAT	:= 0

	Self:lBof	:= .T.
	Self:lEof	:= .T.

	Self:cCRLF	:= NIL

	Set( 4 , Self:cDateFormat )

	IF !( Self:lSetCentury )
		__SetCentury("OFF")
	EndIF

Return( NIL )

/*/
	Funcao:		TVarInfo
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Obtem o Conteudo de uma variavel passada por parametro
/*/
Static Function TVarInfo( aTVarInfo , aStackA , nStackA , aStackO , nStackO , cVarName , uVarInfo , nNivel , cClassName )

	Local cTab			:= ""
	Local cNStr			:= ""
	Local cLine 		:= ""
	Local cVar			:= ""
	Local cVarType		:= ValType( uVarInfo )

	Local lStack

	Local nBL
	Local nEL
	Local nVar

	Local nLen			:= 0
	Local nStack 		:= 0
	
	Local uVar

	DEFAULT nNivel		:= 0

	BEGIN SEQUENCE

		IF ( cVarType == "O" )
	
			++nNivel
	
			cClassName	:= GetClassName( uVarInfo )

			nStack		:= aScanX( aStackO , { |aStk,nAT| aStackO[ nAT ][ STACK_PARAMETER ] == uVarInfo } )
			lStack		:= ( nStack > 0 ) 

			IF ( lStack )

				cTab	:= Space( nNivel * 5 )
				
				cLine	+= cTab
				cLine	+= cVarName
				cLine	+= " -> OBJECT ("
				cLine	+= cClassName
				cLine	+= ") "
				cLine	+= "[CLONE OF "
				cLine	+= aStackO[ nStack ][ STACK_NAME ]
				cLine	+= "]"  

				aAdd( aTVarInfo , cLine )

				BREAK

			EndIF

			/*
				Exception code: C0000005 ACCESS_VIOLATION
				Access Violation tInterFunctionCall on TVARINFO(U_TVARINFO.PRG)
				BEGIN Isto "minimiza" a ocorrencia da Exception
			*/	
				__nClsVAddSleep		+= __nClsAddSleep
				IF ( __cClassName == cClassName )
					Sleep( __nClsIntSleep + __nClsVAddSleep ) 
				Else
					__cClassName	:= cClassName
					Sleep( __nClsNIntSleep )
				EndIF
			/*
				END Isto "minimiza" a ocorrencia da Exception
				Exception code: C0000005 ACCESS_VIOLATION
				Access Violation tInterFunctionCall on TVARINFO(U_TVARINFO.PRG)
			*/	

			aAdd( aStackO , Array( STACK_ELEMENTS ) )

			nStack									:= ++nStackO
			aStackO[ nStack ][ STACK_NAME		]	:= cVarName
			aStackO[ nStack ][ STACK_PARAMETER	]	:= uVarInfo

			cTab	:= Space( nNivel * 5 )

			cLine	+= cTab
			cLine	+= cVarName
			cLine	+= " -> OBJECT ("
			cLine	+= cClassName
			cLine	+= ") "

			aAdd( aTVarInfo , cLine )

			TVarInfo( @aTVarInfo , @aStackA , @nStackA , @aStackO , @nStackO , cVarName , ClassDataArray( uVarInfo ) , nNivel , @cClassName )

		ElseIF ( cVarType == "A" )
	
			cTab	:= Space( nNivel * 5 )
			nEL		:= Len( uVarInfo )
			cNStr	:= Transform( nEL , RetPictVal( nEL ) )

			nStack	:= aScanX( aStackA , { |aStk,nAT| aStackA[ nAT ][ STACK_PARAMETER ] == uVarInfo } )
			lStack	:= ( nStack > 0 ) 
	
			IF ( lStack )
	
				cLine	+= cTab
				cLine	+= cVarName
				cLine	+= " -> ARRAY ("
				cLine	+= cNStr
				cLine	+= ") "
				cLine	+= "[CLONE OF "
				cLine	+= aStackA[ nStack ][ STACK_NAME ]
				cLine	+= "]"
	
			Else
	
				aAdd( aStackA , Array( STACK_ELEMENTS ) )

				nStack									:= ++nStackA
				aStackA[ nStack ][ STACK_NAME		]	:= cVarName
				aStackA[ nStack ][ STACK_PARAMETER	]	:= uVarInfo

				cLine	+= cTab
				cLine	+= cVarName
				cLine	+= " -> ARRAY ("
				cLine	+= cNStr
				cLine	+= ") [...]"
			
			EndIF	
	
			aAdd( aTVarInfo , cLine )
	
			++nNivel

			For nBL := 1 To nEL
				cNStr	:= Transform( nBL , RetPictVal( nBL ) )
				uVar	:= uVarInfo[ nBL ]
				TVarInfo( @aTVarInfo , @aStackA , @nStackA , @aStackO , @nStackO , cVarName+"["+cNStr+"]" , @uVar , nNivel , @cClassName )
				uVar	:= NIL
			Next nBL

		Else
	
			cVar 	:= AllToChar( uVarInfo , cVarType )
			
			cTab 	:= Space( nNivel * 5 )
			
			nVar	:= Len( cVar )
			
			cLine	+= cTab
			cLine	+= cVarName
			cLine	+= " -> "
			cLine	+= cVarType
			cLine	+= " ("
			cLine	+= Transform( nVar , RetPictVal( nVar ) )
			cLine	+= ") "
			cLine	+= "["
			cLine	+= cVar
			cLine	+= "]"
	
			aAdd( aTVarInfo , cLine )
	
		EndIF  

	END SEQUENCE		

Return( NIL )

/*/
	Funcao:		AllToChar
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	AllToChar
/*/
Static Function AllToChar( uVarInfo , cVarType , cPicture )

	Local cVar

	DO CASE
	CASE ( cVarType == "N" )
		IF Empty( cPicture )
			cPicture	:= RetPictVal( uVarInfo , .T. )
		EndIF	
		cVar			:= Transform( uVarInfo , AllTrim( cPicture ) )
	CASE ( cVarType == "C" )
		DEFAULT cPicture	:= ""
		IF !Empty( cPicture )
			cVar		:= Transform( uVarInfo , AllTrim( cPicture ) )
		Else
			cVar		:= uVarInfo
		EndIF
	CASE ( cVarType == "L" )
		cVar := IF( uVarInfo , ".T." , ".F." )
	CASE ( cVarType == "D" )
		cVar			:= DToC( uVarInfo )
	CASE ( cVarType == "B" )
		cVar			:= GetCbSource( uVarInfo )
	CASE ( cVarType == "O" )		
		cVar 			:= "[OJBECT][...]"
	OTHERWISE
		cVar 			:= ""
	ENDCASE

Return( cVar )

/*/
	Funcao:		RetPictVal
	Autor:		Marinaldo de Jesus [ http://www.blacktdn.com.br ] 
	Data:		28/09/2011
	Descricao:	Retorna a Picture para Campo Numerico Conforme Valor
	Sitantxe:	RetPictVal( nVal , lDecZero , nInt , nDec , lPictSepMil )
/*/
Static Function RetPictVal( nVal , lDecZero , nInt , nDec , lPictSepMil )

	Local cPict
	Local cPictSepMil
	
	Local uInt
	Local uDec
	
	IF ( ValType( nVal ) == "N" )
		uInt	:= Int( nVal )
		uDec	:= ( nVal - uInt )
		DEFAULT lDecZero := .F.
		IF (;
				( uDec == 0 );
				.and.;
				!( lDecZero );
			)
			uDec := NIL
		EndIF
		IF ( uDec <> NIL )
			uDec	:= AllTrim( Str( uDec ) )
			uDec	:= SubStr( uDec , At( "." , uDec ) + 1 )
			uDec	:= Len( uDec )
		EndIF
		uInt	:= Len( AllTrim( Str( uInt ) ) )
		nInt	:= uInt
		cPict	:= Replicate( "9" , uInt )
		DEFAULT lPictSepMil := .F.
		IF ( lPictSepMil )
			IF ( nInt > 3 )
				cPictSepMil := cPict
				cPict		:= ""
				For uInt := nInt To 1 Step - 3
					cPict := ( "," + SubStr( cPictSepMil , -3 , uInt ) + cPict )
				Next uInt
			EndIF
		EndIF
		IF ( uDec <> NIL )
			cPict	+= "."
			cPict	+= Replicate( "9" , uDec )
			nDec	:= uDec
		EndIF
	EndIF

Return( cPict )