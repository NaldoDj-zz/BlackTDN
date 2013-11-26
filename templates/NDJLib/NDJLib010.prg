#INCLUDE "NDJ.CH"
#INCLUDE "NDJLib010.ch"
/*/
	Funcao:		Execute
	Autor:		Marinaldo de Jesus 
	Data:		28/03/2011
	Descricao:	Executar Funcoes com Abertura Especifica
	Sintaxe:	Execute( cTitle , bExec , cModName , lGetSenha , cMenuLoad , lMenu , lSchedule , cInternal )
/*/
Static Function Execute( cTitle , bExec , cModName , lGetSenha , cMenuLoad , lMenu , lSchedule , cInternal )

	Local bWindowInit

	Local lMainWnd

	Begin Sequence

		DEFAULT cTitle		:= ""
		DEFAULT bExec		:= { || .T. }
		DEFAULT cModName 	:= "SIGAESP"
		DEFAULT lGetSenha	:= .T.
		DEFAULT cMenuLoad	:= ""
		DEFAULT lMenu		:= .F.
		DEFAULT lSchedule	:= .F.
		DEFAULT cInternal	:= ProcName()

		__SetCentury( "on" )

		lMainWnd	:= ( Type( "oMainWnd" ) == "O" )
		lSchedule	:= IF( lMainWnd  , .F. , lSchedule )
		lGetSenha	:= IF( lSchedule , .F. , lGetSenha )

		IF (;
				!( lMainWnd );
				.and.;
				!( lSchedule );
			)	

			Private oMainWnd
			Private oMsgItem0
			Private oMsgItem1
			Private oMsgItem2
			Private oMsgItem3
			Private oMsgItem4
		
			MsApp():New( cModName )
			oApp:CreateEnv()

			IF ( "11" $ GetVersao() )
				oApp:Activate()
				bWindowInit	:= { ||;
										IF( lGetSenha , ( StaticCall( FWAPP , APPGETLOGIN ) , IF( lMenu , oApp:LoadMenu( cMenuLoad ) , .T. ) ) , .T. ) ,;
										IF( ExistBlock("SIGA"+cModulo) , ExecBlock("SIGA"+cModulo,.F.,.F.) , .T. ),;
										PutInternal( cInternal ),;
										Eval( bExec );
							    }
			Else
				bWindowInit	:= { ||;
										IF( lGetSenha , ( GetSenha( NIL , aConfig() ) , IF( lMenu , oApp:LoadMenu( cMenuLoad ) , .T. ) ) , .T. ) ,;
										IF( ExistBlock("SIGA"+cModulo) , ExecBlock("SIGA"+cModulo,.F.,.F.) , .T. ),;
										PutInternal( cInternal ),;
										Eval( bExec );
							    }
	        EndIF
	        
			DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( cTitle )

				oMainWnd:oMsgBar	:= TMsgBar():New( oMainWnd , Space(2)+OemToAnsi(GetVersao()),.F.,.F.,.F.,.F., RGB(116,116,116),,,.F.,"fw_rodape_logo")
				oApp:oMainWnd 		:= oMainWnd
				IF ( Type( "oApp:lShortCut" ) == "L" )
					oApp:lShortCut	:= .F.
				EndIF	
				oApp:lFlat			:= .F.
				IF ( Type( "oApp:lMenu" ) == "L" )
					oApp:lMenu		:= lMenu
				Else
					lMenu			:= .F.
				EndIF	
				
				DEFINE MSGITEM oMsgItem0 OF oMainWnd:oMsgBar PROMPT "" SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem1 OF oMainWnd:oMsgBar PROMPT oApp:dDataBase SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem2 OF oMainWnd:oMsgBar PROMPT ""	SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem3 OF oMainWnd:oMsgBar PROMPT ""	SIZE 100 ACTION GetSDIInfo()
				DEFINE MSGITEM oMsgItem4 OF oMainWnd:oMsgBar PROMPT STR0001 SIZE 100 ACTION GetSDIInfo() //"Ambiente"

		 	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

		 	Break

		EndIF

		IF (;
				!( lMainWnd );
				.or.;
				!( lSchedule );
			)	
			Break
		EndIF

		PutInternal( cInternal )
		Eval( bExec )

	End Sequence

Return( NIL )

/*/
	Funcao:		PutInternal
	Autor:		Marinaldo de Jesus 
	Data:		16/10/2009
	Descricao:	Carregar PtInternal e TCInternal
	Sintaxe:	PutInternal( cInternal )
/*/
Static Function PutInternal( cInternal )

	#IFDEF TOP
		Local cTCInternal
	#ENDIF	
	Local cPTInternal

	Local lInternal	:= .T.

	TRYEXCEPTION

		IF !( Type( "cEmpAnt" ) == "C" )
			Private cEmpAnt := "99"
		EndIF
		
		IF !( Type( "cFilAnt" ) == "C" )
			Private cFilAnt	:= "01"
		EndIF
		
		IF !( Type( "cUserName" ) == "C" )
			Private cUserName := "Admin"
		EndIF
		
		IF !( Type( "cModulo" ) == "C" )
			Private cModulo := "ESP"
		EndIF
		
		#IFDEF TOP
			TCInternal( 8 , cUserName )
			cTCInternal := cInternal
			cTCInternal += " :: "
			cTCInternal += ConType()
			TCInternal( 1 , cTCInternal )
		#ENDIF
		
		cPTInternal := "Emp :" 		+ cEmpAnt + "/" + cFilAnt
		cPTInternal += " "
		cPTInternal += "Logged :"	+ cUserName
		cPTInternal += " "
		cPTInternal += "SIGA" 		+ cModulo
		cPTInternal += " "
		cPTInternal += "Obj :"		+ cInternal
		
		PTInternal( 1 , cPTInternal )

	CATCHEXCEPTION

		lInternal	:= .F.

	ENDEXCEPTION

Return( lInternal )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	Execute()
    	lRecursa	:= __Dummy( .F. )
		SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )