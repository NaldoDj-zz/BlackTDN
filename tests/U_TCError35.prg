#IFDEF __NALDO_PC
	#DEFINE TC_DBMS		"MSSQL/RNP"
	#DEFINE TC_PORT		7890
	#DEFINE TC_SERVER  "127.0.0.1"
#ELSE
	#DEFINE TC_DBMS		"POSTGRES/TSS"
	#DEFINE TC_PORT		7890
	#DEFINE TC_SERVER  "192.168.1.5"
#ENDIF

#DEFINE TC_MAXCONNECTION 10000

/*
	Programa	:	TCError35()
	Autor		:	Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		:	15/06/2011
	Uso			:	Testar Limite de Conexoes ao DBMS
*/
User Function TCError35()  

	Local aTCConnection		:= Array(0)

	Local bError			:= { |e| oError := e , BREAK(e) }
	Local bErrorBlock		:= ErrorBlock( bError )
	
	Local cDescription

	Local nTCConnection 	:= 0
	Local nMaxConnection	:= 0

	Local oError

	BEGIN SEQUENCE

		While ( ++nMaxConnection <= TC_MAXCONNECTION )
			IF ( KillApp() )
				UserException( "[PROCNAME]["+ProcName()+"][MESSAGE RECEIVED][KILAPP]")
			EndIF
			nTCConnection	:= TCLink( TC_DBMS , TC_SERVER , TC_PORT )
			IF ( nTCConnection == -34 ) //TCF_TooManyUsers
				ConOut( "" )
				ConOut( "===============================================================" )
				ConOut( "" , "[TCLINK][TCF_TooManyUsers]["+LTrim(Str(nTCConnection))+"][RECONNECTING...]" , "" )
				ConOut( "===============================================================" )
				ConOut( "" )
				nTCConnection	:= TCLink( "@!!@" + TC_DBMS , TC_SERVER , TC_PORT )
			EndIF
			IF ( nTCConnection == -35 ) //TCF_NoDBConnection
				UserException( "-35 TCF_NoDBConnection" )
			EndIF
			IF ( nTCConnection >= 0 )
				aAdd( aTCConnection , nTCConnection )
				ConOut( "" )
				ConOut( "===============================================================" )
				ConOut( "" , "[TCLINK]["+LTrim(Str(nTCConnection))+"]" , "" )
				ConOut( "===============================================================" )
				ConOut( "" )
			EndIF
		End While

		nTCConnection	:= Len( aTCConnection )

		ConOut( "" )
		ConOut( "===============================================================" )
		ConOut( " [TC_MAXCONNECTION]["+LTrim(Str(TC_MAXCONNECTION))+"]" )
		ConOut( " [TENTATIVAS DE CONEXAO]["+LTrim(Str(nMaxConnection))+"]" )
		ConOut( " [CONEXOES ATIVAS]["+LTrim(Str(nTCConnection))+"]" )
		ConOut( "===============================================================" )
		ConOut( "" )

		aEval( aTCConnection , { |nTCLink| TCUnLink( nTCLink ) } )
		aSize( aTCConnection , 0 )

	RECOVER

		IF ( ValType( oError ) == "O" )

			cDescription 	:= oError:Description
			nTCConnection	:= Len( aTCConnection )

			ConOut( "" )
			ConOut( "===============================================================" )
			IF ( "-35" $ cDescription )
				ConOut( " [ATENCAO][Excedeu o Numero de Conexoes ao DBMS]" )
			EndIF
			ConOut( " [TCWARNING]["+cDescription+"]" )
			ConOut( " [TC_MAXCONNECTION]["+LTrim(Str(TC_MAXCONNECTION))+"]" )
			ConOut( " [TENTATIVAS DE CONEXAO]["+LTrim(Str(nMaxConnection))+"]" )
			ConOut( " [CONEXOES ATIVAS]["+LTrim(Str(nTCConnection))+"]" )
			ConOut( "===============================================================" )
			ConOut( "" )

		EndIF

		aEval( aTCConnection , { |nTCLink| TCUnLink( nTCLink ) } )
		aSize( aTCConnection , 0 )

	END SEQUENCE
    ErrorBlock( bErrorBlock )

Return( NIL )