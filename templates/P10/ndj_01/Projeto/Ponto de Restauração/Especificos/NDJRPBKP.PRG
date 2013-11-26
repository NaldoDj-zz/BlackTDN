#INCLUDE "NDJ.CH"
#ifdef SPANISH
		#DEFINE STR0001 "Criando Ponto de Restauração..."
		#DEFINE STR0002 "Aguarde..."
		#DEFINE STR0003 "Restaurando..."
		#DEFINE STR0004 "Atenção"
		#DEFINE STR0005 "Ororreram Problemas no Processo de Restauração"
		#DEFINE STR0006 "Ocorreram Problemas no Processo de Criação do Ponto de Restauração"
#else
	#ifdef ENGLISH
		#DEFINE STR0001 "Criando Ponto de Restauração..."
		#DEFINE STR0002 "Aguarde..."
		#DEFINE STR0003 "Restaurando..."
		#DEFINE STR0004 "Atenção"
		#DEFINE STR0005 "Ororreram Problemas no Processo de Restauração"
		#DEFINE STR0006 "Ocorreram Problemas no Processo de Criação do Ponto de Restauração"
		
	#else
		#DEFINE STR0001 "Criando Ponto de Restauração..."
		#DEFINE STR0002 "Aguarde..."
		#DEFINE STR0003 "Restaurando..."
		#DEFINE STR0004 "Atenção"
		#DEFINE STR0005 "Ororreram Problemas no Processo de Restauração"
		#DEFINE STR0006 "Ocorreram Problemas no Processo de Criação do Ponto de Restauração"
	#endif
#endif

#DEFINE NDJ_RP_INI	"\ndj_cfg\ndj_rp.ini"

/*/
	Funcao:		TRPSave
	Autor:		Marinaldo de Jesus
	Data:		23/09/2011
	Descricao:	Criando Ponto de Restauracao
	Sintaxe:	StaticCall( NDJRPBKP , TRPSave , cEmp , cFil , cRPType )
/*/
Static Function TRPSave( cEmp , cFil , cRPType )

	Local bEval			:= { || MsgRun( STR0001 , STR0002 , bMsgRun ) }
	Local bMsgRun		:= { ||;
									lRpSave := StaticCall( NDJLIB021 , RPSave , GetNewPar( "NDJ_RPINI" , NDJ_RP_INI ) , @cTSX5Key , @cMsgError ) ,;
									IF( lRpSave , StaticCall( NDJLIB021 , PutRPSX5 , cRPType , cTSX5Key ) , MsgInfo( cMsgError , STR0004 ) );
						   }
	Local cTSX5Key		:= ""
	Local cModName		:= IF( Type( "cModulo" ) == "C" , "SIGA"+cModulo , "SIGAESP" )
	Local cMsgError		:= OemToAnsi( STR0006 )	//"Ocorreram Problemas no Processo de Criação do Ponto de Restauração"
	Local lRpSave 		:= .F.

	Private cDtIni
	Private cDtFim
	Private cTSPath

	DEFAULT cRPType		:= "RP"

	IF !( Type( "cEmpAnt" ) == "C" )
		DEFAULT cEmp	:= "01"
		Private cEmpAnt := cEmp
	Else
		DEFAULT cEmp	:= cEmpAnt
	EndIF
	IF !( Type( "cFilAnt" ) == "C" )
		DEFAULT cFil	:= "01"
		Private cFilAnt := cFil
	Else
		DEFAULT cFil	:= cFilAnt
	EndIF

	//"Criando Ponto de Restauração..."
Return( StaticCall( NDJLIB001 , EvalPrg , bEval , @cEmp , @cFil , @cModName ) )

/*/
	Funcao:		TRPRestore
	Autor:		Marinaldo de Jesus
	Data:		23/09/2011
	Descricao:	Restaurando Ponto de Restauracao
	Sintaxe:	StaticCall( NDJRPBKP , TRPRestore , cEmp , cFil , cRPType )
/*/
Static Function TRPRestore( cEmp , cFil , cRPType )

	Local bEval			:= { || MsgRun( STR0003 , STR0002 , bMsgRun ) }
	Local bMsgRun		:= { ||;
									cTSX5Key := StaticCall( NDJLIB021 , GetRPSX5 , cRPType ),	;
									IF( !Empty( cTSX5Key ) , IF( !StaticCall( NDJLIB021 , RPRestore , @cTSX5Key , @cMsgError ) , MsgInfo( cMsgError , STR0004 ) , .T. ) , .T. );
							}
	Local cTSX5Key		:= ""
	Local cModName		:= IF( Type( "cModulo" ) == "C" , "SIGA"+cModulo , "SIGAESP" )
	Local cMsgError		:= OemToAnsi( STR0005 ) //"Ororreram Problemas no Processo de Restauração"

	DEFAULT cRPType		:= "RP"

	IF !( Type( "cEmpAnt" ) == "C" )
		DEFAULT cEmp	:= "01"
		Private cEmpAnt := cEmp
	Else
		DEFAULT cEmp	:= cEmpAnt
	EndIF
	IF !( Type( "cFilAnt" ) == "C" )
		DEFAULT cFil	:= "01"
		Private cFilAnt := cFil
	Else
		DEFAULT cFil	:= cFilAnt
	EndIF

	//"Restaurando..."
Return( StaticCall( NDJLIB001 , EvalPrg , @bEval , @cEmp , @cFil , @cModName ) )

Static Function __Dummy( lRecursa )
	TRYEXCEPTION
		lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
	   	lRecursa		:= __Dummy( .F. )
	   	SYMBOL_UNUSED( __cCRLF )
		TRPRESTORE()
    	TRPSAVE()
	CATCHEXCEPTION
	ENDEXCEPTION
Return( lRecursa )