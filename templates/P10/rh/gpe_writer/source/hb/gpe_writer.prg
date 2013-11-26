#include "common.ch"
#include "fileio.ch"

#ifndef __XHARBOUR__
   #xcommand TRY  => BEGIN SEQUENCE WITH {|oErr| break( oErr )}
   #xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#endif                                   

/*
	Programa	: GPE_Writer
	Função		: Main
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Permitir a Impressão de Documentos Funcionais do totvs/protheus no OpenOffice Writer
*/
procedure main( cTemplate , lPrint , nCopyNumber , nWait , nSleep , cPrinter , cOrientation , cFileSaveAs , lPreview )

	Local e
    Local cType
	Local cErrorMessage

	Local cCurrentFolder := GetCurrentFolder()

	TRY

		if ( pCount() == 0 )
			break
		endif

		if .NOT.( subStr(cCurrentFolder,-1) == hb_ps() )
			cCurrentFolder += hb_ps()
		endif
	
		DEFAULT cTemplate		TO cCurrentFolder+"gpe_writer.odt"
		DEFAULT lPrint			TO .T.
		DEFAULT cFileSaveAs		TO ""
		DEFAULT nCopyNumber		TO 1
		DEFAULT nWait			TO 0
		DEFAULT nSleep			TO 0
		DEFAULT cPrinter        TO ""
		DEFAULT cOrientation	TO ""
		DEFAULT lPreview		TO .F.

		IF ( valType(lPrint) == "C" )
			lPrint		:= allTrim( lPrint )
			lPrint		:= IF( ( lPrint $ ".T." ) , .T. , .F. )
		EndIF

		IF ( valType(nCopyNumber) == "C" )
			nCopyNumber	:= Val(nCopyNumber)
		EndIF

		IF .not.( lPrint )
			if empty( cFileSaveAs )
				break( "Arquivo de Destino não informado. Operação de Salvamento não será efetuada" )
			endif
			nCopyNumber	:= 1
		EndIF

		IF ( valType(nWait) == "C" )
			nWait	:= Val(nWait)
		EndIF
	
		IF ( valType(nSleep) == "C" )
			nSleep	:= Val(nSleep)
		EndIF

		IF (;
				( subStr(cTemplate,1) == '"' );
				.and.;
				( subStr(cTemplate,-1) == '"' );
			)	
			cTemplate	:= subStr( cTemplate , 2 , len( cTemplate ) -1 )
		EndIF

		IF (;
				( subStr(cPrinter,1) == '"' );
				.and.;
				( subStr(cPrinter,-1) == '"' );
			)	
			cPrinter	:= subStr( cPrinter , 2 , len( cPrinter ) -1 )
		EndIF

		IF (;
				( subStr(cOrientation,1) == '"' );
				.and.;
				( subStr(cOrientation,-1) == '"' );
			)	
			cOrientation	:= subStr( cOrientation , 2 , len( cOrientation ) -1 )
		EndIF

		IF (;
				( subStr(cFileSaveAs,1) == '"' );
				.and.;
				( subStr(cFileSaveAs,-1) == '"' );
			)	
			cFileSaveAs	:= subStr( cFileSaveAs , 2 , len( cFileSaveAs ) -1 )
		EndIF

		IF ( valType(lPreview) == "C" )
			lPreview		:= allTrim( lPreview )
			lPreview		:= IF( ( lPreview $ ".T." ) , .T. , .F. )
		EndIF

		oOOWriter( @cCurrentFolder , @cTemplate , @lPrint , @nCopyNumber , @nWait , @nSleep , @cPrinter , @cOrientation , @cFileSaveAs , @lPreview )

	CATCH e

		cType	:= valType(e)

		switch ( cType )
		case ( "C" )
			cErrorMessage	:= e
			exit
		case ( "O" )
			cErrorMessage	:= "Operation: "
			cErrorMessage	+= e:operation
			cErrorMessage	+= "-"
			cErrorMessage	+= "Description: "
			cErrorMessage	+= e:Description
			exit
		end switch

		if .not.( empty( cErrorMessage ) )
			hb_MemoWrit( cCurrentFolder + "gpe_writer_error.log" , cErrorMessage ) 
		endif

	END TRY

return

/*
	Programa	: GPE_Writer
	Função		: oOOWriter
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Permitir a Impressão de Documentos Funcionais do totvs/protheus no OpenOffice Writer
*/
procedure oOOWriter( cCurrentFolder , cTemplate , lPrint , nCopyNumber , nWait , nSleep , cPrinter , cOrientation , cFileSaveAs , lPreview )

	Local aData
	Local aFields

	Local aOO_LoadF
	Local aOO_SaveAs
	Local aOO_Printer
	Local aOO_GetPrinter

	Local cFile 
	Local cData
	Local cType
	Local cfSemaphore
	Local cTokenField
	Local cErrorMessage
	Local cSearchString
	Local cReplaceString 

	Local cSplitFExt
	Local cSplitPath
	Local cSplitFName

	Local nData
	Local nField
	Local nFields
	Local nFHandle
	Local nIdleSleep

	Local o
	Local e
	
	Local oOO_Doc
	Local oOO_Desktop
	Local oOO_Property
	Local oOO_ServiceManager
	Local oOO_ReplaceDescriptor

	TRY

		cFile					:= strTran( cTemplate , "\" , hb_ps() )
		cFile					:= strTran( cFile , "/" , hb_ps() )
		if .not.( file(cFile) )
			break("Arquivo " + cFile + " não encontrado")
		endif
		
		cData					:= cCurrentFolder+"gpe_wparameters.csv"
		if .not.( file(cData) )
			break("Arquivo " + cData + " não encontrado")
		endif

		cfSemaphore				:= cCurrentFolder+"oOOWriter.lck"
		nFHandle 				:= fCreate( cfSemaphore )

		nIdleSleep := 0
		while ( nFHandle == -1 )
			if ( ++nIdleSleep > 50 )
				break("impossível iniciar serviço de impressão. " + cfSemaphore )
			endif
			hb_idleSleep(nSleep)
			nFHandle := fCreate( cfSemaphore )
			hb_GCall(.T.)
		end while

		aData										:= FileToArr( cData )
		nData										:= len( aData )

		if ( nData < 2 )
			break
		endif

		aFields										:= Array(2)
		aFields[1]									:= StrTokArray( aData[1] , "|" )
		aFields[2]									:= StrTokArray( aData[2] , "|" )

		if .NOT.( len( aFields[1] ) == len( aFields[2] ) )
			break("Estrutuda de Dados Inválida")
		endif

		oOO_ServiceManager							:= win_oleCreateObject("com.sun.star.ServiceManager")

		nIdleSleep := 0
		while ( ++nIdleSleep <= nWait )
			hb_idleSleep(nSleep)
			hb_GCall(.T.)
		end while

		oOO_Desktop									:= oOO_ServiceManager:createInstance("com.sun.star.frame.Desktop")

		if ( oOO_Desktop == NIL )
			break("OpenOffice Writer não dispinível")
		endif

		nIdleSleep := 0
		while ( ++nIdleSleep <= nWait )
			hb_idleSleep(nSleep)
			hb_GCall(.T.)
		end while

		cFile										:= "file:///"+cFile

		aOO_LoadF	:= Array(0)
		
		oOO_Property	:= oOOSProperty(oOO_ServiceManager,"ReadOnly",.T.)
		aAdd( aOO_LoadF , oOO_Property )

		oOO_Property	:= oOOSProperty(oOO_ServiceManager,"Hidden",.not.(lPreview))
		aAdd( aOO_LoadF , oOO_Property )

		oOO_Doc										:= oOO_Desktop:loadComponentFromURL(cFile,"_blank",0,aOO_LoadF)

		aOO_GetPrinter								:= oOO_Doc:getPrinter()
		IF empty( aOO_GetPrinter )
			break("Impressora não disponível")
		EndIF

		oOO_ReplaceDescriptor							:= oOO_Doc:createReplaceDescriptor()
		oOO_ReplaceDescriptor:SearchWords				:= .T.
		oOO_ReplaceDescriptor:SearchBackwards			:= .T.
		oOO_ReplaceDescriptor:SearchCaseSensitive		:= .T.
		oOO_ReplaceDescriptor:SearchSimilarity			:= .F.

		cTokenField	:= "!"

		nFields					:= len( aFields[1] )
		for nField := 1 to nFields
			cSearchString	:= cTokenField
			cSearchString	+= aFields[1][nField]
			cSearchString	+= cTokenField
			oOO_ReplaceDescriptor:setSearchString(cSearchString)
			cReplaceString	:= aFields[2][nField]
			oOO_ReplaceDescriptor:setReplaceString(cReplaceString)
			oOO_Doc:replaceAll(oOO_ReplaceDescriptor)
		next nField

		oOO_ReplaceDescriptor	:= NIL

		oOO_Doc:refresh()

		if ( lPrint )

			for each o in aOO_GetPrinter
				switch o:Name
				case ( "Name" )
					if .not.( empty( cPrinter ) )
						o:Value	:= cPrinter
					endif	
					exit
				case ( "PaperOrientation" )
					if .not.( empty(cOrientation) )
						o:Value	:= IF( ( cOrientation $ "[PORTRAIT][P]" ) , 0 , IF( ( cOrientation $ "[LANDSCAPE][L]" ) , 1 , 0 ) ) 
					endif	
					exit
				end switch
			Next each

			oOO_Doc:setPrinter( aOO_GetPrinter )
	
			aOO_Printer				:= Array(0)
	
			oOO_Property			:= oOOSProperty(oOO_ServiceManager,"Wait",.T.)
			aAdd( aOO_Printer , oOO_Property )

			oOO_Property			:= oOOSProperty(oOO_ServiceManager,"CopyCount",nCopyNumber)
			aAdd( aOO_Printer , oOO_Property )

			oOO_Property			:= oOOSProperty(oOO_ServiceManager,"Collate",.T.)
			aAdd( aOO_Printer , oOO_Property )

			oOO_Doc:Print( aOO_Printer )

			nIdleSleep := 0
			while ( ++nIdleSleep <= nWait )
				hb_idleSleep(nSleep)
				hb_GCall(.T.)
			end while
		
		else
		
			hb_FNameSplit( cFileSaveAs , @cSplitPath , @cSplitFName , @cSplitFExt )
			if .not.( empty( cSplitFExt ) )
				cSplitFExt	:= lower( cSplitFExt )
			else
				cSplitFExt	:= ".odf"
			endif
			if ( empty( cSplitPath ) )
				cFileSaveAs := cCurrentFolder+cSplitFName+cSplitFExt
			endif
			
			cFileSaveAs		:= strTran( cFileSaveAs , "\" , "/" )

			aOO_SaveAs		:= Array(0)
			oOO_Property	:= NIL

			switch ( cSplitFExt )
			case ( ".odt" )
			case ( ".ott" )
				exit
			case ( ".dot" )
			case ( ".doc" )
				oOO_Property	:= oOOSProperty(oOO_ServiceManager,"FilterName","MS Word 97")
				exit
			case ( ".pdf" )
				oOO_Property	:= oOOSProperty(oOO_ServiceManager,"FilterName","writer_pdf_Export")
				exit
			case ( ".htm" )
			case ( ".html" )
				oOO_Property	:= oOOSProperty(oOO_ServiceManager,"FilterName","HTML (StarWriter)")
				exit
			case ( ".rtf" )
				oOO_Property	:= oOOSProperty(oOO_ServiceManager,"FilterName","Rich Text Format")
				exit
			end switch

			if .not.( oOO_Property == NIL )
				aAdd( aOO_SaveAs , oOO_Property )
			endif	
			
			oOO_Doc:storeToURL("file:///"+cFileSaveAs,aOO_SaveAs) 

		endif

		oOO_Doc:Close(.T.)
		oOO_Desktop:Terminate()

		oOO_Doc					:= NIL
		oOO_Desktop				:= NIL

		fClose( nFHandle )
		fErase( cfSemaphore )

	CATCH e

		cType	:= valType(e)

		switch ( cType )
		case ( "C" )
			cErrorMessage	:= e
			exit
		case ( "O" )
			cErrorMessage	:= "Operation: "
			cErrorMessage	+= e:operation
			cErrorMessage	+= "-"
			cErrorMessage	+= "Description: "
			cErrorMessage	+= e:Description
			exit
		end switch

		if .not.( empty( cErrorMessage ) )
			hb_MemoWrit( cCurrentFolder + "gpe_writer_error.log" , cErrorMessage ) 
		endif	

		IF ( valType( nFHandle ) == "N" )
			fClose( nFHandle )
		EndIF	

		IF ( valType( cfSemaphore ) == "C" )
			fErase( cfSemaphore )
		EndIF	

	end TRY

	hb_GCall(.T.)

return                                                                

/*
	Programa	: GPE_Writer
	Função		: FileToArr
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Carregar os dados de arquivo texto em array considerando, como quebra de linha CRLF
*/
Static Function FileToArr( cFile , nLines )

	Local aLines		:= Array(0)

	Local cCRLF			:= hb_OsNewLine()

	Local nfHandle		:= fOpen( cFile , FO_READ )
	Local nFileSize		:= fSeek( nfHandle , 0 , FS_END )
	Local nBufferSize   := 1024
                    	
	nLines				:= ReadFile( @aLines , @nfHandle , @nBufferSize , @nFileSize , @cCRLF )

	fClose( nfHandle )

return( aLines )

/*
	Programa	: GPE_Writer
	Função		: ReadFile
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Carregar os dados de arquivo texto em array considerando, como quebra de linha, CRLF
*/
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

	hb_GCall(.T.)
	
return( nLines )

/*
	Programa	: GPE_Writer
	Função		: StrTokArray
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Transforma String em Array conforme Token
*/
Static Function StrTokArray( cString , cToken , bEvalToken )

	Local aStrTokArr		:= {}
	
	Local cStr
	
	Local nATToken
	Local nRealSize
	
	DEFAULT cToken		TO "+"
	DEFAULT bEvalToken	TO { || .T. }

	if ( at( cToken , cString ) > 0 )
		nRealSize	:= len( cToken )
		while ( ( nATToken := at( cToken , cString ) ) > 0 )
			if ( nATToken > 1 )
				cStr := allTrim( subStr( cString , 1 , ( nATToken - 1 ) ) )
				cString := subStr( cString , ( nATToken + nRealSize ) )
			Else
				cStr := ""
				cString := subStr( cString , ( nATToken + nRealSize ) )
			endif
			if eval( bEvalToken , @cStr )
				aAdd( aStrTokArr , cStr )
			endif
		end while
		if ( len( cString ) > 0 )
			cStr := cString
			if eval( bEvalToken , @cStr )
				aAdd( aStrTokArr , cStr ) 
			endif
		endif
	Else
		cStr := cString
		if eval( bEvalToken , @cStr )
			aAdd( aStrTokArr , cStr )
		endif
	endif

return( aStrTokArr )

/*
	Programa	: GPE_Writer
	Função		: oOOSProperty
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Struct Property 
*/
Static Function oOOSProperty(oSrvManager,cName,uValue)
	Local oOOSProperty  := oSrvManager:Bridge_GetStruct("com.sun.star.beans.PropertyValue")
	oOOSProperty:Name	:= cName
	oOOSProperty:Value	:= uValue
return( oOOSProperty )

/*
	Programa	: GPE_Writer
	Função		: GetCurrentFolder
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 02/07/2012
	Uso			: Retornar o Diretorio Corrente
*/
Static Function GetCurrentFolder()
Return( hb_CurDrive() + hb_osDriveSeparator() + hb_ps() + CurDir() )