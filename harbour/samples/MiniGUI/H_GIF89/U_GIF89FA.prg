#include "protheus.ch"

#DEFINE ANIMATE_DELAY	5
#DEFINE ANIMATE_COUNT	3
#DEFINE ANIMATE_SLEEP	100

/*
	Funcao: 	U_GIF89ExFA
	Autor:		Marinaldo de Jesus
	Data:		22/03/2012
	Descricao:	Exemplo de Uso de Arquivo GIF no Protheus
*/
User Function GIF89ExFA()

	Local cGIFPath
	LOCAL cPathChr  := IF( ( GetRemoteType() == 2 ) , "/" , "\" ) //-1 = sem remote/ 0 = delphi/ 1 = QT windows/ 2 = QT Linux
	Local nOpcGet	:= nOR( GETF_LOCALFLOPPY , GETF_LOCALHARD , GETF_NETWORKDRIVE , GETF_SHAREAWARE , GETF_RETDIRECTORY )

	Local aGIFFiles	:= Array(0)

	Private oMainWnd

	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE ( ProcName() + " Demo" )
		cGIFPath		:= cGetFile( ".GIF |*.GIF " , OemToAnsi( "Selecione o Diretório" ) , NIL , GetTempPath() , .F. , nOpcGet , .T. , .T. )
		IF !( SubStr( cGIFPath , -1 ) == cPathChr )
			cGIFPath += cPathChr
		EndIF
		aDir(cGIFPath+"*.GIF",@aGIFFiles)
	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( aEval( aGIFFiles , { |cGIFFile| GIF89ExFA(cGIFPath+cGIFFile) } ) , oMainWnd:End() )

Return( Final( "Final " + ProcName() + " Demo" ) )

/*
	Funcao: 	GIF89ExFA()
	Autor:		Marinaldo de Jesus
	Data:		22/03/2012
	Descricao:	Exemplo de Uso de Arquivo GIF no Protheus
*/
Static Function GIF89ExFA(cGIFFile)

	Local aPictInfo 	:= {}
	Local aPictures		:= {}
	Local aImageInfo 	:= {}	
	
	Local cExt
	Local cDir
	Local cFile
	Local cDriver

	Local nCount		:= 0
	Local nInterval
	Local nTotalFrames
	Local nCurrentFrame	:= 1

	Local oGIF
	Local oPanel
	Local oTimer

	SplitPath( cGIFFile , @cDriver , @cDir , @cFile , @cExt )
	
	IF Empty( cDriver )
		cFile	:= ( GetTempPath() + cFile + cExt )
		IF !( __CopyFile( cGIFFile , cFile ) )
			Final("Unable to copy " + cGIFFile)
		EndIF
	EndIF

	IF !( StaticCall( H_GIF89 , LoadGIF , @cGIFFile , @aPictInfo, @aPictures, @aImageInfo ) )
		Final("Unable to Load " + cGIFFile)
	EndIF

	nInterval			:= StaticCall( H_GIF89 , GetFrameDelay , aImageInfo[nCurrentFrame] )
	nTotalFrames		:= Len( aPictures )

	DEFINE MSDIALOG oDlg TITLE "GIF89ExFA Demo" FROM 0,0 TO aPictInfo[3],aPictInfo[2] OF GetWndDefault() PIXEL STYLE WS_POPUP

		@00,00 MSPANEL oPanel OF oDlg SIZE aPictInfo[3],aPictInfo[2]
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT

		@ 0,0 BITMAP oGIF FILE cGIFFile OF oPanel SIZE aPictInfo[3],aPictInfo[2] NOBORDER WHEN .F. PIXEL
		
		oGIF:lAutoSize	:= .T.
		oGIF:lStretch 	:= .T.
		oGIF:Align 		:= CONTROL_ALIGN_NONE

		DEFINE TIMER oTimer OF oPanel:oWND INTERVAL nInterval ACTION PlayGif(@oDlg,@oGIF,@aPictures,@nCurrentFrame,@nTotalFrames,@aImageInfo,@nInterval,@oTimer,@nCount)

	ACTIVATE DIALOG oDlg CENTERED ON INIT oTimer:Activate() VALID ( oTimer:Deactivate() , .T. )

	OnClose( @aPictures , @aPictInfo , @aImageInfo , @cFile )

Return( .T. )

/*
	Funcao: 	PlayGif
	Autor:		Marinaldo de Jesus
	Data:		22/03/2012
	Descricao:	Exemplo de Uso de Arquivo GIF no Protheus
*/
Static Function PlayGif(oDlg,oGIF,aPictures,nCurrentFrame,nTotalFrames,aImageInfo,nInterval,oTimer,nCount)

	Local cBMPFile  := oGIF:cBMPFile

	Local lNoExit	:= .T.

	While lNoExit

		IF ( nCurrentFrame > nTotalFrames )
			nCurrentFrame 		:= 1
			lNoExit				:= .F.
		Else
			oGIF:cBMPFile		:= aPictures[nCurrentFrame]
			nInterval			:= StaticCall( H_GIF89 , GetFrameDelay , aImageInfo[nCurrentFrame] , ANIMATE_DELAY )
			++nCurrentFrame
			oTimer:nInterval	:= nInterval
		ENDIF

		Sleep( ANIMATE_SLEEP )

	End While

	Sleep( nInterval / ANIMATE_SLEEP )

	oGIF:cBMPFile	:= cBMPFile

	IF ( ++nCount >= ANIMATE_COUNT )
		oTimer:Deactivate()
		oTimer:End()
		oDlg:End()
	EndIF

Return( .T. )

/*
	Funcao: 	OnClose
	Autor:		Marinaldo de Jesus
	Data:		22/03/2012
	Descricao:	Exemplo de Uso de Arquivo GIF no Protheus
*/
Static Function OnClose( aPictures , aPictInfo , aImageInfo , cFile )
	aEval( aPictures, {|f| FErase( f ) } )
	aSize( aPictures , 0 )
	aSize( aPictInfo , 0 )
	aSize( aImageInfo , 0 )
	IF !( cFile == NIL )
		fErase( cFile )
	EndIF
Return( .T. )