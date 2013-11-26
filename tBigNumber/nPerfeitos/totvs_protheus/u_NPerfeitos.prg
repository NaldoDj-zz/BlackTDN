#IFDEF PROTHEUS

	#include "set.ch"
	#include "dbstruct.ch"	
	#include "fileio.ch"
	#include "protheus.ch"
	#include "paramtypex.ch"
	#include "tryexception.ch"

	#DEFINE NP_GRID				"100"				//Informe um Numero Par
	#DEFINE NP_THREAD			5					//Numero de Threads Concorrentes
	#DEFINE NP_MAXZERO			25					//0000000000000000000000000  | How big do you want?
	#DEFINE NP_MAXNUMP			( NP_MAXZERO + 1 )	//10000000000000000000000000 | MASK: 10.000.000.000.000.000.000.000.000
	#DEFINE NP_PATHLCK			"\np_semaforo\"
	#DEFINE NP_FILELCK			NP_PATHLCK+"execute_np_number.nplck"
	#DEFINE NP_LOCKBYFNAME		NP_PATHLCK+"waitrun_np_number.nplck"
	#DEFINE NP_GRIDBMAXWAIT		10
	
	#DEFINE NP_PRVT_IPALIAS		"__cAliasIP" 
	#DEFINE NP_PRVT_NPALIAS		"__cAliasNP"
	#DEFINE NP_PRVT_NPDBS		"__aDBs"
	#DEFINE NP_PRVT_NPLPENV		"__lPrepEnv"
	
	#IFNDEF FO_EXCLUSIVE
		#DEFINE FO_EXCLUSIVE	16
	#ENDIF
	
	#IFNDEF _SET_DELETED
		#DEFINE _SET_DELETED	11
	#ENDIF
	
	Static __aLockNPFile		AS ARRAY
	Static __nPMaxNumP			AS NUMBER		VALUE NP_MAXNUMP

	#IFDEF NP_TOPCONN
		Static __cNPRDD 		AS CHARACTER	VALUE "TOPCONN"
		Static __lTopConn		AS LOGICAL		VALUE .T.
		Static __lCtreeCDX		AS LOGICAL		VALUE .F.
		Static __ldbfCDXAds		AS LOGICAL		VALUE .F.
		#DEFINE NP_SLEEP_MIN	 250
		#DEFINE NP_SLEEP_MED	 500
		#DEFINE NP_SLEEP_MAX	1500
	#ELSE
		#DEFINE NP_SLEEP_MIN	 150
		#DEFINE NP_SLEEP_MED	 300
		#DEFINE NP_SLEEP_MAX	 500
		#IFDEF NP_CTREE
			Static __cNPRDD		AS CHARACTER VALUE "CTREECDX"
			Static __lTopConn	AS LOGICAL		VALUE .F.
			Static __lCtreeCDX	AS LOGICAL		VALUE .T.
			Static __ldbfCDXAds	AS LOGICAL		VALUE .F.
		#ELSE		
			Static __cNPRDD		AS CHARACTER VALUE "DBFCDXADS"
			Static __lTopConn	AS LOGICAL		VALUE .F.
			Static __lCtreeCDX	AS LOGICAL		VALUE .F.
			Static __ldbfCDXAds	AS LOGICAL		VALUE .T.
		#ENDIF	
	#ENDIF
	
	/*
		Funcao	: U_NPerfeitos()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Verificar os Numeros Perfeitos em um Determinado Intervalo ( Usando Grid )

		Formula para Obter um Numero Perfeito
		<x> Representa a Ordem do Numero Perfeito
		
		2^(<x>-1)*(2^<x>-1) 
		
		para <x> = 2:   2^1(2^2 - 1) = 6
		para <x> = 3:   2^2(2^3 - 1) = 28
		para <x> = 5:   2^4(2^5 - 1) = 496
		para <x> = 7:   2^6(2^7 - 1) = 8128

	*/
	User Function NPerfeitos()
	
		Local cRDDDefault	AS CHARACTER	VALUE RddSetDefault( @__cNPRDD )
		
		Local lIsBlind		AS LOGICAL		VALUE IsBlind()
		Local bExec			AS BLOCK		VALUE { || NPerfeitos( @lIsBlind , @oProcess ) }
		
		Local oProcess		AS OBJECT
	
		PTInternal( 1 , "[NP][U_NPerfeitos][Start]" )
	
		IF ( lIsBlind )
			Eval( bExec )
		Else
			ASSIGN oProcess	:= MsNewProcess():New( bExec , OemToAnsi( "Números Perfeitos :: http://www.blacktdn.com.br" ) , "Calculando..." , .T. )
			oProcess:Activate()
			IF .NOT.( oProcess:lEnd )
				oProcess:oDlg:End()
			EndIF
			oProcess	:= NIL
		EndIF
	    
		aEval( __aLockNPFile , { |e| UnLockNPFile( e[1] ) } )
	
		PTInternal( 1 , "[NP][U_NPerfeitos][End]" )

		RddSetDefault( @cRDDDefault )
	
	Return( .T. )
	
	/*
		Funcao	: NPerfeitos()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Verificar os Numeros Perfeitos em um Determinado Intervalo ( Usando Grid )
	*/
	Static Function NPerfeitos( lIsBlind , oProcess )
	
		Local aDBs			AS ARRAY
		Local aGPPEnv		AS ARRAY
		Local aGPCall		AS ARRAY
	
		Local cNI			AS CHARACTER	
		Local cNF			AS CHARACTER	
		Local cNP			AS CHARACTER	VALUE NP_GRID
		Local cNG			AS CHARACTER	
		Local cMG			AS CHARACTER	
		Local cNS			AS CHARACTER	
	
		Local lGridC		AS LOGICAL
		Local lGPCall		AS LOGICAL
		Local lProcessa		AS LOGICAL
		Local lBatchExec	AS LOGICAL
		Local lSetCentury	AS LOGICAL 		VALUE __SetCentury("on")
	
		Local nBL			AS NUMERIC
		Local nSL			AS NUMERIC
		Local nEL			AS NUMERIC		VALUE __nPMaxNumP
	
		Local nWait			AS NUMERIC
		Local nSeconds		AS NUMERIC
	
		Local oNI			AS OBJECT CLASS "TBIGNUMBER"
		Local oNG			AS OBJECT CLASS "TBIGNUMBER"
		Local oNF			AS OBJECT CLASS "TBIGNUMBER"
		Local oMG			AS OBJECT CLASS "TBIGNUMBER"
		Local oNP			AS OBJECT CLASS "TBIGNUMBER"
		Local oN2			AS OBJECT CLASS "TBIGNUMBER"
		Local oNS			AS OBJECT CLASS "TBIGNUMBER"
	
		Local oGClient		AS OBJECT

		PARAMTYPE 1 VAR lIsBlind AS LOGIC OPTIONAL DEFAULT IsBlind()
		PARAMTYPE 2 VAR oProcess AS OBJECT 
        
		ASSIGN lProcessa := .NOT.( lIsBlind )

		TRYEXCEPTION

			While .NOT.( lIsDir( NP_PATHLCK ) )
				ASSIGN nWait := 0
				MakeDir( NP_PATHLCK )
				IF ( ++nWait > NP_GRIDBMAXWAIT )
					UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeitos][Impossível Criar Diretório: " + NP_PATHLCK + "]" )  )
				EndIF
			End While

			Set( 4 , "dd/mm/yyyy" )
	
			ConOut( "" , "" , OemToAnsi( "[NP_MSG][NPerfeitos][Números Perfeitos: Início do Processamento...]" ) )

			IF .NOT.( OpenDBs( @aDBs , .T. ) )
				ASSIGN nWait := 0
				While ( ++nWait < NP_GRIDBMAXWAIT )
					IKillApp(.T.)
					Sleep(NP_SLEEP_MIN)
				End While
				IF .NOT.( OpenDBs( @aDBs , .F. ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs]" + CRLF + "(Tente Novamente...)" ) )
				EndIF
			EndIF

			IF .NOT.( File( NP_FILELCK ) )
				IF .NOT.( LockNPFile( @NP_FILELCK , FO_COMPAT ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeitos][Impossível Criar arquivo: " + NP_FILELCK + "]" ) )
				EndIF
			EndIF	
	
			ConOut( "" , "" , OemToAnsi( "[NP_MSG][NPerfeitos][Números Perfeitos: Início do Cálculo]" ) )
			ConOut( OemToAnsi( "[NP_MSG][NPerfeitos](Para encerrar o Processamento, exclua o arquivo "  + NP_FILELCK + ")" ) )
	
			ASSIGN oNI	:= tBigNumber():New()
			ASSIGN oNG	:= tBigNumber():New()
			ASSIGN oNF	:= tBigNumber():New()
			ASSIGN oMG	:= tBigNumber():New()
			ASSIGN oNP	:= tBigNumber():New(cNP)
			ASSIGN oN2	:= tBigNumber():New("2")
			ASSIGN oNS	:= tBigNumber():New()
	
			ASSIGN cNI 	:= GetStartNumber(.F.)
			ASSIGN nSL	:= Len( cNI )
	
			IF ( lProcessa )
				oProcess:SetRegua1( nEL )
				ASSIGN nWait := 0
				While ( ( ++nWait ) <= nSL )
					oProcess:IncRegua1()
				End While
				oProcess:SetRegua2( 0 )
			EndIF

			oNI:SetValue( cNI )
	
			For nBL := nSL To nEL
	
				IKillApp(.T.)

				IF ( lProcessa )
					oProcess:IncRegua1()
					IF ( oProcess:lEnd )
						UnLockNPFile( @NP_FILELCK )
						IKillApp(.T.)
					EndIF
				EndIF

				ASSIGN cMG		:= ( "1" + Replicate( "0" , nBL ) )
				oMG:SetValue( cMG )
				
				While ( oNI:lte( oMG ) )
	
					IKillApp(.T.)
	
					IF ( lProcessa )
						oProcess:IncRegua2()
						IF ( oProcess:lEnd )
							UnLockNPFile( @NP_FILELCK )
							IKillApp(.T.)
						EndIF
					EndIF
	
					ASSIGN cNG		:= "1"
					aSize( aGPCall , 0 )
					
					oNG:SetValue( cNG )
					While ( oNG:lte( @oNP ) )
	
						IKillApp(.T.)
	
						IF ( lProcessa )
							oProcess:IncRegua2()
							IF ( oProcess:lEnd )
								UnLockNPFile( @NP_FILELCK )
								IKillApp(.T.)
							EndIF
						EndIF
	
						oNG:SetValue( oNG:Add( "1" ) )
						oNF:SetValue( oNI:Add( oNP ) )
						
						IF ( oNF:gt( oMG ) )
							oNF:SetValue( oMG )
							oNG:SetValue( oNP )
						EndIF
					
						aAdd( aGPCall , { oNI:Int() , oNF:Int() , lGridC } )
		
						oNI:SetValue( oNF:Add( oN2 ) ) //Teoricamente Apenas os Numeros Pares Sao Perfeitos
						
						IF ( oNI:gt( oMG ) )
							cNI := oNI:Int()
							Exit
						EndIF
	
					End While
	
					IKillApp(.T.)
	
					ASSIGN lGPCall	:= .NOT.( Empty( aGPCall ) )
	
					IF ( lProcessa )
						IF( lGPCall )
							oProcess:IncRegua2( "[Interval]["+aGPCall[1][1]+"|"+aGPCall[Len(aGPCall)][2]+"]" )
							IF ( oProcess:lEnd )
								UnLockNPFile( @NP_FILELCK )
								IKillApp(.T.)
							EndIF
						EndIF
					EndIF	

					IF ( lGPCall )
						#IFNDEF __DEBUGNP
							ASSIGN oGClient			:= GridClient():New()
							ASSIGN oGClient:lBlind	:= .T.	//Nao Executa a Processa
							ASSIGN lGridC			:= oGClient:ConnectCoord()
							IF .NOT.( lGridC )
	                            ASSIGN lGridC		:= StartGJob( @oGClient , .T. )
							EndIF
							IF ( lGridC )
								ASSIGN aGPPEnv		:= { aGPCall[ 1 ][ 1 ] , aGPCall[ Len( aGPCall ) ][ 2 ] }
								aEval( aGPCall , { |e,y| aGPCall[y][3] := lGridC } )
								ASSIGN lBatchExec	:= oGClient:BatchExec( "U_GMathPEnv" , @aGPPEnv , "U_GMathCall" , @aGPCall , "U_GMathEnd" )
								IF .NOT.( lBatchExec )
									ASSIGN lGridC	:= .F.
									aEval( aGPCall , { |e,y| aGPCall[y][3] := lGridC , U_GMathCall( @e ) } )
								EndIF
								StartGJob( @oGClient , .F. )
								oGClient	:= FreeObj( oGClient )
							Else
								aEval( aGPCall , { |e| U_GMathCall( @e ) } )
							EndIF
						#ELSE
							aEval( aGPCall , { |e| U_GMathCall( @e ) } )
						#ENDIF
					EndIF
	
				End While

				ASSIGN cNS 	:= GetStartNumber(.T.)
				IF .NOT.( cNS == "6" )
					oNS:SetValue( cNS )
					IF oNS:lt( oNI )
						oNI:SetValue( oNS )
						ASSIGN cNI := oNI:Int()
						ASSIGN nSL	:= Len( cNI )
					EndIF	
				EndIF

			Next nBL

			IF ( __ldbfCDXAds )
				( __cAliasNP )->( dbSetOrder( OrdNumber( "NP_NUMBER2" ) ) )
			EndIF	
			
			( __cAliasNP )->( dbGoTop() )
	
			ConOut( "" , "" , OemToAnsi( "[NP_MSG][NPerfeitos][Numeros Perfeitos Encontrados]" ) , "" )
			
		 	While ( __cAliasNP )->( .NOT.( Eof() ) )
			 	ConOut( "[NP_MSG][NPerfeitos][" + ( __cAliasNP )->NP_NUMBER + "]" )
			 	( __cAliasNP )->( dbSkip() )
			End While
	
			ConOut( "" , "" )
	
			CloseDBs( @aDBs )
	
		CATCHEXCEPTION
			
			IF ( Select( __cAliasNP ) > 0 )
	
				IF ( __ldbfCDXAds )
					( __cAliasNP )->( dbSetOrder( OrdNumber( "NP_NUMBER2" ) ) )
				EndIF	
				
				( __cAliasNP )->( dbGoTop() )
				
			 	ConOut( "" , "" , OemToAnsi( "[NP_MSG][NPerfeitos][Numeros Perfeitos Encontrados]" ) , "" )
			 	
			 	While ( __cAliasNP )->( .NOT.( Eof() ) )
				 	ConOut( "[NP_MSG][" + ( __cAliasNP )->NP_NUMBER + "]" )
				 	( __cAliasNP )->( dbSkip() )
				End While
				
				ConOut( "" , "" )
			
			EndIF
	
			CloseDBs( @aDBs )
	
			ConOut( "" , "" , CaptureError( .T. ) )
	
		ENDEXCEPTION

		aEval( __aLockNPFile , { |e| UnLockNPFile( e[1] ) } )
	
		ConOut( "" , "" , OemToAnsi( "[NP_MSG][NPerfeitos][Números Perfeitos: Final do Processamento...]" ) , "" , "" )
	
		IF .NOT.( lSetCentury )
			__SetCentury("off")
		EndIF
	
	Return( .T. )
	
	/*
		Funcao	: GMathPEnv()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Preparacao do Ambiente para Execucao via Grid
	*/
	User Function GMathPEnv( aGPPEnv )
	
		Local aDBs		AS ARRAY
	
		Local cNI		AS CHARACTER
		Local cNF		AS CHARACTER

		Local cInterval	AS CHARACTER
	
		Local lPrepEnv	AS LOGICAL

		PARAMTYPE 1 VAR aGPPEnv AS ARRAY

		ASSIGN cNI			:= aGPPEnv[1]
		ASSIGN cNF			:= aGPPEnv[2]
		
		ASSIGN cInterval	:= (cNI+"|"+cNF)

		PTInternal( 1 , "[NP][U_GMathPEnv][Interval: "+cInterval+"][Start][BEGIN PREPENV]" )
	
		TRYEXCEPTION
	
			_SetOwnerPrvt( NP_PRVT_IPALIAS	 , GetNextAlias() )
			_SetOwnerPrvt( NP_PRVT_NPALIAS   , GetNextAlias() )
			_SetOwnerPrvt( NP_PRVT_NPDBS	 , {} )
			_SetOwnerPrvt( NP_PRVT_NPLPENV   , .F. )
	
			ASSIGN	lPrepEnv := OpenDBs( @aDBs , .F. )
			
			IF .NOT.( lPrepEnv )
				UserException( OemToAnsi( "[U_GMathPEnv][Problema na Preparação do Ambiente. Impossível Abrir aruivos de Trabalho]" ) )	
			EndIF
	
			ASSIGN &( NP_PRVT_NPLPENV ) := .T.
	
			PTInternal( 1 , "[NP][U_GMathPEnv][Interval: "+cInterval+"][Start][BEGIN PREPENV][True]" )
	
		CATCHEXCEPTION
	
			PTInternal( 1 , "[NP][U_GMathPEnv][Interval: "+cInterval+"][Start][BEGIN PREPENV][False]" )
	
			ConOut( "" , "" , "[NP_ERROR]" + CaptureError( .T. ) )	
			
			KillApp(.T.)
	
		ENDEXCEPTION
	
	Return( lPrepEnv )
	
	/*
		Funcao	: GMathCall()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Chamar a Funcao para o Calculo dos Numeros Perfeitos a Partir do Grid
	*/
	User Function GMathCall( aGPCall )
	
		Local cNI		AS CHARACTER
		Local cNF		AS CHARACTER
		Local lGridC    AS LOGICAL
	
		Local cInterval	AS CHARACTER

		Local lRet		AS LOGICAL

		PARAMTYPE 1 VAR aGPCall AS ARRAY

		ASSIGN cNI			:= aGPCall[1]
		ASSIGN cNF			:= aGPCall[2]
		ASSIGN lGridC		:= aGPCall[3]
		
		ASSIGN cInterval	:= (cNI+"|"+cNF)
	
		PTInternal( 1 , "[NP][U_GMathCall][Interval: "+cInterval+"][Start]" )
		Sleep(NP_SLEEP_MIN)
	
		ASSIGN lRet			:= MathIPNum( @cNI , @cNF , @lGridC )
	
		PTInternal( 1 , "[NP][U_GMathCall][Interval: "+cInterval+"][Finish]" )
		Sleep(NP_SLEEP_MIN)

	Return( lRet )
	
	/*
		Funcao	: MathIPNum()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Verificar os Numeros Perfeitos em um Determinado Intervalo ( MultiThread )
	*/
	Static Function MathIPNum( cN , cM , lGridC )
	
		Local aThread		AS ARRAY
		Local aNumbers		AS ARRAY

		Local cIP			AS CHARACTER
		Local cPort			AS CHARACTER
		Local cThread		AS CHARACTER
		Local cEnvServer	AS CHARACTER

		Local cNPFile		AS CHARACTER
		Local cIntExec		AS CHARACTER
		Local cInterval		AS CHARACTER
	
		Local lTTS			AS LOGICAL
		Local lExit			AS LOGICAL
		Local lFound		AS LOGICAL
		Local lError		AS LOGICAL
		Local lThreadOk		AS LOGICAL		VALUE .T.
		Local lPerfect		AS LOGICAL

		Local nID			AS NUMBER
		Local nExit			AS NUMBER
		Local nFinal		AS NUMBER
		Local nNumber		AS NUMBER
		Local nNumbers		AS NUMBER
		Local nStrZero		AS NUMBER

		Local oN			AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
		Local oM			AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()
		Local o2			AS OBJECT CLASS "TBIGNUMBER" VALUE tBigNumber():New()

		PARAMTYPE 1 VAR cN		AS CHARACTER
		PARAMTYPE 2 VAR cM  	AS CHARACTER
		PARAMTYPE 3 VAR lGridC	AS LOGICAL

		oN:SetValue( cN )
		oM:SetValue( cM )
		o2:SetValue( "2" )

		ASSIGN cIP			:= StrTran( IF( lGridC , GetPvProfString( "GRIDAGENT" , "AGENTIP" , "" , GetSrvIniName() ) , GetServerIP() ) , "." , "" )
		ASSIGN cPort		:= GetPvProfString( "TCP" , "PORT" , "" , GetSrvIniName() )
		ASSIGN cThread		:= AllTrim( Str( ThreadID() ) )
		ASSIGN cEnvServer	:= GetEnvServer()
		ASSIGN cInterval	:= (cN+"|"+cM)
		
		TRYEXCEPTION

			IF Empty( cIP )
				ASSIGN cIP := "This"
			EndIF
	
			PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Start]")
	
			While ( oN:lte( @oM ) )
				IKillApp(.F.)
				aAdd( aNumbers , oN:Int() )
				oN:SetValue( oN:Add( o2 ) ) //Teoricamente Apenas os Numeros Pares Sao Perfeitos
				IF ( oN:gt( @oM ) )
					EXIT
				EndIF
			End While

			ASSIGN nNumber	:= 0
			ASSIGN nNumbers	:= Len( aNumbers )
			
			ASSIGN nFinal	:= MIN( nNumbers , NP_THREAD )     
			ASSIGN nStrZero	:= Len(AllTrim(Str(nFinal)))

			For nID := 1 To nFinal
				IKillApp(.F.)
				aAdd( aThread , Array( 6 ) )
				ASSIGN aThread[nID][1]	:= .F.
				ASSIGN aThread[nID][2]	:= ""
				ASSIGN aThread[nID][3]	:= ""
				ASSIGN aThread[nID][4]	:= ""
				ASSIGN aThread[nID][5]	:= ""
				ASSIGN aThread[nID][6]	:= ""
			Next nID
	
			While .NOT.( KillApp() )
	
				IKillApp(.F.)
	                
				IF ( nNumber >= nNumbers )
					Exit
				EndIF
	
				For nID := 1 To nFinal
	
					IKillApp(.F.)
	
					IF ( ++nNumber > nNumbers )
						Loop
					EndIF
	
					ASSIGN aThread[nID][1]	:= .F.
					ASSIGN aThread[nID][2]	:= aNumbers[ nNumber ]
		        	ASSIGN aThread[nID][3]	:= ( "NP_"+aThread[nID][2]+"_ID_"+StrZero(nID,nStrZero)+"_"+cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)
		        	ASSIGN aThread[nID][4]	:= ( NP_PATHLCK+"error_"+aThread[nID][3]+".nplck" )
		        	ASSIGN aThread[nID][5]	:= ( NP_PATHLCK+"final_"+aThread[nID][3]+".nplck" )
		        	ASSIGN aThread[nID][6]	:= ( NP_PATHLCK+"NPerfeito_execute_"+aThread[nID][2]+".nplck" )
	
					ASSIGN lTTS		:= .F.
					ASSIGN lFound	:= ( __cAliasNP )->( dbSeek( PadR( aThread[nID][2] , Len( NP_NUMBER ) ) , .F. ) )
					ASSIGN lPerfect	:= lFound
					IF .NOT.( lFound )
						ASSIGN lFound	:= ( __cAliasIP )->( dbSeek( PadR( aThread[nID][2] , Len( IP_NUMBER ) ) , .F. ) )
						IF ( lFound )
							ASSIGN lTTS	:= ( __cAliasIP )->IP_TTS
							IF ( lTTS )
								ASSIGN lPerfect	:= ( __cAliasIP )->IP_PERFECT
							EndIF
						EndIF
					EndIF

					IF ( ( lTTS ) .or. ( lPerfect ) )
						ASSIGN aThread[nID][1]	:= .T.
						ASSIGN cNPFile			:= aThread[nID][5]
						IF File( cNPFile )
							Sleep(NP_SLEEP_MED)
						EndIF
						UnLockNPFile( @cNPFile )
						Loop
					EndIF

				Next nID

				ASSIGN cIntExec := ( aThread[1][2]+"|"+aThread[nFinal][2] )

				PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Start]")
				Sleep(NP_SLEEP_MIN)

				For nID := 1 To nFinal
					IKillApp(.F.)
	        		IF .NOT.( aThread[nID][1] )
		        		StartJob("U__NPGJOB",cEnvServer,.F.,aThread[nID][3],aThread[nID][2],aThread[nID][4],aThread[nID][5],aThread[nID][6])
		        		Sleep(NP_SLEEP_MAX)
		        	EndIF
				Next nID
                
				PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Sleep]")
				Sleep(NP_SLEEP_MAX*2)
				
				PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Wait]")
				Sleep(NP_SLEEP_MIN)

				While .NOT.( KillApp() )
	
					IKillApp(.F.)
	
					ASSIGN nExit	:= 0

					For nID := 1 To nFinal
		
						IKillApp(.F.)

						IF ( aThread[nID][1] )
							++nExit
							ASSIGN cNPFile	:= aThread[nID][5]
							IF File( cNPFile )
								Sleep(NP_SLEEP_MED)
							EndIF	
							UnLockNPFile( @cNPFile )
							Loop
						EndIF
		
						ASSIGN cNPFile	:= aThread[nID][4]
						
						ASSIGN lError	:= File( cNPFile )
						IF ( lError )
							ConOut( "" , "" , "[NP_ERROR][MathIPNum][" + aThread[nID][3] + "][Error][Restart]" )
							Sleep(NP_SLEEP_MED)
							UnLockNPFile( @cNPFile )
							StartJob("U__NPGJOB",cEnvServer,.F.,aThread[nID][3],aThread[nID][2],aThread[nID][4],aThread[nID][5],aThread[nID][6])
							Sleep(NP_SLEEP_MAX)
							Loop
						EndIF
						
						ASSIGN cNPFile	:= aThread[nID][5]
						ASSIGN lTTS		:= File( cNPFile )
						IF .NOT.( lTTS )
							ASSIGN lFound := ( __cAliasIP )->( dbSeek( PadR( aThread[nID][2] , Len( IP_NUMBER ) ) , .F. ) )
							IF ( lFound )
								ASSIGN lTTS	:= ( __cAliasIP )->IP_TTS
							EndIF
						EndIF

						IF ( lTTS )
							ASSIGN lTTS				:= .F.
							ASSIGN aThread[nID][1]	:= .T.
							IF .NOT.( File( cNPFile ) )
								Sleep(NP_SLEEP_MED)
							EndIF
							UnLockNPFile( @cNPFile )
							ASSIGN cNPFile	:= aThread[nID][6]
							IF ( File( cNPFile ) )
								Sleep(NP_SLEEP_MED)
							EndIF
							UnLockNPFile( cNPFile )
							Loop
						EndIF

						ASSIGN cNPFile	:= aThread[nID][6]
						IF .NOT.( File( cNPFile ) )
							ASSIGN lFound := ( __cAliasIP )->( dbSeek( PadR( aThread[nID][2] , Len( IP_NUMBER ) ) , .F. ) )
							IF .NOT.( lFound )
								ConOut( "" , "" , "[NP_WARNING][MathIPNum][" + aThread[nID][3] + "][Not Found][Restart]" )
								StartJob("U__NPGJOB",cEnvServer,.F.,aThread[nID][3],aThread[nID][2],aThread[nID][4],aThread[nID][5],aThread[nID][6])	
								Sleep(NP_SLEEP_MAX)
							EndIF
						EndIF

					Next nID

					ASSIGN lExit	:= ( nExit >= nFinal )
					IF ( lExit )
						Exit
					EndIF
					
					PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Sleep]")
					Sleep(NP_SLEEP_MAX)
				
					PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][Wait]")
					Sleep(NP_SLEEP_MED)

				End While

				PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+cIntExec+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][End]")
				Sleep(NP_SLEEP_MIN)

			End While
            
			PTInternal( 1 , "[NP][MathIPNum][Interval: "+cInterval+"]["+(cEnvServer+"_IP_"+cIP+"_Port_"+cPort+"_Thread_"+cThread)+"][End]")
			Sleep(NP_SLEEP_MIN)

		CATCHEXCEPTION 

			ASSIGN lThreadOk	:= .F.
			IKillApp(.F.)

		ENDEXCEPTION		

	Return( lThreadOk )
	
	/*
		Funcao	: GMathEnd()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Funcao a Ser Executada na Finalizacao/Retorno do Grid
	*/
	User Function GMathEnd()
		Local aDbs 		AS ARRAY 	VALUE &( NP_PRVT_NPDBS )
		Local lPrepEnv	AS LOGICAL	VALUE &( NP_PRVT_NPLPENV )
		PTInternal( 1 , "[NP][U_GMathEnd][Start]" )
		IF ( ( ValType( lPrepEnv ) == "L" ) .and. lPrepEnv )
			PTInternal( 1 , "[NP][U_GMathEnd][Exec]" )
			CloseDBs( @aDBs )
		EndIF	
		PTInternal( 1 , "[NP][U_GMathEnd][Finish]" )
	Return( .T. )
	
	/*
		Funcao	: IKillApp
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Verifica se Deve Forcar a Finalizacao da Thread
	*/
	Static Function IKillApp( lKillApp )

		PARAMTYPE 1 VAR lKillApp AS LOGICAL OPTIONAL DEFAULT .T.

		IF .NOT.( File( NP_FILELCK ) )
			ConOut( "" , "" , OemToAnsi( "[NP_WARNING][IKillApp][Finalização Forçada. Arquivo " + NP_FILELCK + " não encontrado]" ) )
			IF ( lKillApp )
				KillApp(lKillApp)
			Else
				UserException( OemToAnsi( "[NP_EXCEPTION][IKillApp][Finalização Forçada. Arquivo " + NP_FILELCK + " não encontrado]" ) )
			EndIF	
		EndIF

	Return( .T. )
	
	/*
		Funcao	: U__NPGJOB()
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Job para verificar se Determinado Numero eh Perfeito
		Sintaxe	: StartJob( "U__NPGJOB" , cEnvServer , .F. , cID , cN , cErrorFile , cFinalFile , cNPFile )
	*/
	User Function _NPGJOB( cID , cN , cErrorFile , cFinalFile , cNPFile )
	
		Local aDBs			AS ARRAY

		Local lNPGJOB		AS LOGICAL
		Local lPerfect		AS LOGICAL

		PARAMTYPE 1 VAR cID			AS CHARACTER
		PARAMTYPE 2 VAR cN			AS CHARACTER
		PARAMTYPE 3 VAR cErrorFile	AS CHARACTER
		PARAMTYPE 4 VAR cFinalFile	AS CHARACTER
		PARAMTYPE 5 VAR cNPFile		AS CHARACTER

		PTInternal( 1 , "[NP][U__NPGJOB][" + cID + "]" )
	
		BEGIN SEQUENCE
	
			IF .NOT.( OpenDBs( @aDBs , .F. ) )
				LockNPFile( @cErrorFile , FO_COMPAT )
				PTInternal( 1 , "[NP][U__NPGJOB]["+cID+"]["+"Error"+"]" )
				Sleep(NP_SLEEP_MIN)
				BREAK
			EndIF

			ASSIGN lPerfect	:= NPerfeito(@cN,@cErrorFile,@cFinalFile,@cNPFile)
	
			PTInternal( 1 , "[NP][U__NPGJOB]["+cID+"][Final]["+IF(lPerfect,"True","False")+"]" )
			Sleep(NP_SLEEP_MIN)

			ASSIGN lNPGJOB		:= .T.
	
		END SEQUENCE
	
	Return( lNPGJOB )
	
	/*
		Funcao	: NPerfeito
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Verificar se um numero eh um "Numero Perfeito"
		fonte	: http://pt.wikipedia.org/wiki/N%C3%BAmero_perfeito
	*/
	Static Function NPerfeito( cN , cErrorFile , cFinalFile , cNPFile )

		Local lError	AS LOGICAL
		Local lLock		AS LOGICAL
		Local lFound	AS LOGICAL
		Local lPerfect	AS LOGICAL
		Local lLockFile	AS LOGICAL
	
		Local o0		AS OBJECT CLASS "TBIGNUMBER"
		Local o1		AS OBJECT CLASS "TBIGNUMBER"
		Local oN		AS OBJECT CLASS "TBIGNUMBER"
		Local oSm		AS OBJECT CLASS "TBIGNUMBER"
		Local oP1		AS OBJECT CLASS "TBIGNUMBER"

		PARAMTYPE 1 VAR cN			AS CHARACTER
		PARAMTYPE 2 VAR cErrorFile	AS CHARACTER
		PARAMTYPE 3 VAR cFinalFile	AS CHARACTER
		PARAMTYPE 4 VAR cNPFile		AS CHARACTER
		
		ASSIGN lLockFile := LockNPFile( @cNPFile )

		BEGIN SEQUENCE

			IF .NOT.( lLockFile )
				ASSIGN lError := .NOT.( File( cNPFile ) )
				BREAK
			EndIF
	
			ASSIGN lFound	:= ( __cAliasNP )->( dbSeek( PadR( cN , Len( NP_NUMBER ) ) , .F. ) )
			IF ( lFound )
				BREAK
			EndIF	
	
			ASSIGN lFound	:= ( __cAliasIP )->( dbSeek( PadR( cN , Len( IP_NUMBER ) ) , .F. ) )

			IF ( lFound )
				IF ( ( __cAliasIP )->IP_TTS )
					ASSIGN lPerfect	:= ( __cAliasIP )->IP_PERFECT
					IF ( lPerfect )
						ASSIGN lFound	:= ( __cAliasNP )->( dbSeek( PadR( cN , Len( NP_NUMBER ) ) , .F. ) )
						IF .NOT.( lFound )
							TRYEXCEPTION
								( __cAliasNP )->( dbAppend( .T. ) )
								lLock := .NOT.( ( __cAliasNP )->( Eof() .or. NetErr() ) )
								IF .NOT.( lLock )
									UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeito][Update error: File is in EOF or a network error has occurred]" ) )
								EndIF
								( __cAliasNP )->NP_NUMBER := cN
								( __cAliasNP )->( dbUnLock() )
							CATCHEXCEPTION
								ASSIGN lError := .T.
							ENDEXCEPTION
						EndIF
					EndIF
					BREAK
				EndIF	
				ASSIGN lLock	:= ( __cAliasIP )->( rLock() )
			EndIF
	
			IF .NOT.( lFound )
				ASSIGN lFound := ( __cAliasIP )->( dbSeek( PadR( cN , Len( IP_NUMBER ) ) , .F. ) )
			EndIF

			IF .NOT.( lFound )
				TRYEXCEPTION
					( __cAliasIP )->( dbAppend( .T. ) )
					lLock := .NOT.( ( __cAliasIP )->( Eof() .or. NetErr() ) )
					IF .NOT.( lLock )
						UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeito][Update error: File is in EOF or a network error has occurred]" ) )
					EndIF
					( __cAliasIP )->IP_NUMBER := cN
					( __cAliasIP )->( dbUnLock() )
					lLock := ( __cAliasIP )->( rLock() )
				CATCHEXCEPTION 
					ASSIGN lError	:= .T.
					ASSIGN lLock	:= .F.
				ENDEXCEPTION
			EndIF	

			ASSIGN lError	:= ( lError .or. .NOT.( lLock ) )
			IF ( lError )
				BREAK
			EndIF

			ASSIGN oN	:= tBigNumber():New( cN )
	    
			ASSIGN o0  	:= tBigNumber():New( "0" )
			ASSIGN o1	:= tBigNumber():New( "1" )
			ASSIGN oSm	:= tBigNumber():New( o0 )
			ASSIGN oP1	:= tBigNumber():New( o1 )
			
			While ( oP1:lt( @oN ) )
				IKillApp(.F.)
				IF ( oN:Mod( oP1 ):eq(o0) )
				     oSm:SetValue( oSm:Add( oP1 ) )
				EndIF
				oP1:SetValue( oP1:Add( o1 ) )
			End While

			ASSIGN lPerfect	:= oN:eq( oSm )
	
			IF ( lPerfect )
				ASSIGN lFound	:= ( __cAliasNP )->( dbSeek( PadR( cN , Len( NP_NUMBER ) ) , .F. ) )
				IF .NOT.( lFound )
					TRYEXCEPTION
						( __cAliasNP )->( dbAppend( .T. ) )
						lLock := .NOT.( ( __cAliasNP )->( Eof() .or. NetErr() ) )
						IF .NOT.( lLock )
							UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeito][Update error: File is in EOF or a network error has occurred]" ) )
						EndIF
						( __cAliasNP )->NP_NUMBER := cN 
						( __cAliasNP )->( dbUnLock() )
					CATCHEXCEPTION 
						ASSIGN lError	:= .T.
					ENDEXCEPTION
				EndIF
			EndIF
			TRYEXCEPTION
				lLock := .NOT.( ( __cAliasIP )->( Eof() .or. NetErr() ) )
				IF .NOT.( lLock )
					UserException( OemToAnsi( "[NP_EXCEPTION][NPerfeito][Update error: File is in EOF or a network error has occurred]" ) )
				EndIF
				( __cAliasIP )->IP_PERFECT	:= lPerfect
				( __cAliasIP )->IP_TTS		:= .T.
				( __cAliasIP )->( dbUnLock() )
			CATCHEXCEPTION 
				ASSIGN lError	:= .T.
			ENDEXCEPTION

		End Sequence

		IF ( lError )
			LockNPFile( @cErrorFile , FO_COMPAT )
		Else
			LockNPFile( @cFinalFile , FO_COMPAT )
		EndIF

		UnLockNPFile( @cNPFile )

	Return( lPerfect )
	
	/*
		Funcao	: LockNPFile
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 03/07/2011
		Uso		: Trava Processo Aguardando Liberacao
	*/
	Static Function LockNPFile( cNPFile , nMode )
	
		Local cFLock	AS CHARACTER
		
		Local lLock		AS LOGICAL

		Local nWait
		Local nWaitErr
		Local nfhNPFile
		Local nLockNPFile

		PARAMTYPE 1 VAR cNPFile	AS CHARACTER
		PARAMTYPE 2 VAR nMode 	AS NUMBER OPTIONAL DEFAULT FO_EXCLUSIVE
		
		ASSIGN cFLock	:= Lower( cNPFile )
	
		BEGIN SEQUENCE
	
			ASSIGN nWait := 0
			While .NOT.( File( cFLock ) )
				ASSIGN nfhNPFile := fCreate( cFLock )
				IF ( File( cFLock ) )
					fClose( nfhNPFile )
					IF ( nMode == 0 )
						ASSIGN lLock := .T.
						BREAK
					EndIF
					ASSIGN nfhNPFile	:= fOpen( cFLock , nMode )
					ASSIGN lLock 		:= ( fError() == 0 )
					ASSIGN nWaitErr		:= 0
					While .NOT.( lLock )
						ASSIGN nfhNPFile := fOpen( cFLock , nMode )
						IF ( ASSIGN lLock := ( fError() == 0 ) )
							Exit
						EndIF
						IF ( ( ++nWaitErr ) > NP_GRIDBMAXWAIT )
							BREAK
						EndIF
						Sleep(NP_SLEEP_MIN)
					End While
				EndIF
				IF File( cFLock )
					ASSIGN nLockNPFile := aScan( __aLockNPFile , { |aLock| ( aLock[ 2 ] == -1 ) } )
					IF ( nLockNPFile > 0 )
						IF .NOT.( cFLock == __aLockNPFile[ nLockNPFile ][ 1 ] )
							IF File( __aLockNPFile[ nLockNPFile ][ 1 ] )
								fErase( __aLockNPFile[ nLockNPFile ][ 1 ] )
							EndIF
							ASSIGN __aLockNPFile[ nLockNPFile ][ 1 ]	:= cFLock
						EndIF	
						ASSIGN __aLockNPFile[ nLockNPFile ][ 2 ]		:= nfhNPFile
					Else
						aAdd( __aLockNPFile , { cFLock , nfhNPFile } )
					EndIF	
					Exit
				EndIF
				Sleep(NP_SLEEP_MIN)
				IF ( ( ++nWait ) > NP_GRIDBMAXWAIT )
					Exit
				EndIF
			End While	
	
		END SEQUENCE
	
	Return( lLock )
	
	/*
		Funcao	: UnLockNPFile
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 03/07/2011
		Uso		: Destrava Processo Liberando a Acao
	*/
	Static Function UnLockNPFile( cNPFile )
	
		Local cFUNLock		AS CHARACTER
		
		Local lUnLock		AS LOGICAL
		
		Local nWait
		Local nfhNPFile
		Local nLockNPFile	AS NUMBER

		PARAMTYPE 1 VAR cNPFile	AS CHARACTER

		ASSIGN cFUNLock		:= Lower( cNPFile )
		ASSIGN nLockNPFile	:= aScan( __aLockNPFile , { |aLock| ( aLock[ 1 ] == cFUNLock ) } )
	
		BEGIN SEQUENCE
	
			IF ( nLockNPFile > 0 )
				ASSIGN nfhNPFile							:= __aLockNPFile[ nLockNPFile ][ 2 ]
				ASSIGN __aLockNPFile[ nLockNPFile ][ 2 ]	:= -1
				IF ( nfhNPFile > 0 )
					fClose( nfhNPFile )
				EndIF	
			EndIF	
	
			ASSIGN nWait := 0
			While File( cFUNLock )
				fErase( cFUNLock )
				IF ( ASSIGN lUnLock := .NOT.( File( cFUNLock ) ) )
					BREAK
				EndIF
				Sleep(NP_SLEEP_MIN)
				IF ( ( ++nWait ) > NP_GRIDBMAXWAIT )
					Exit
				EndIF
			End While
		
			ASSIGN lUnLock	:= .NOT.( File( cFUNLock ) )
	
		END SEQUENCE
	
	Return( lUnLock )
	
	/*
		Funcao	: OpenDBs
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 14/06/2011
		Uso		: Tenta abir as tabelas que serao utilizadas
	*/
	Static Function OpenDBs( aDBs , lNotShared )
	
		Local aDBNP			AS ARRAY
		Local aDBIP			AS ARRAY
		
		Local aFiles		AS ARRAY
		
		Local aModStru		AS ARRAY
		Local aOrdBagIP		AS ARRAY
		Local aOrdBagNP		AS ARRAY
	
		Local cDBIP			AS CHARACTER	VALUE "IP_NUMBER"+IF(__lTopConn,"",IF(__ldbfCDXAds,GetDBExtension(),IF(__lCtreeCDX,GetDBExtension(),"")))
		Local cIDIP			AS CHARACTER	VALUE "IP_NUMBER"+IF(__lTopConn,"",IF(__ldbfCDXAds,RetIndExt(),IF(__lCtreeCDX,RetIndExt(),"")))
	
		Local cDBNP			AS CHARACTER	VALUE "NP_NUMBER"+IF(__lTopConn,"",IF(__ldbfCDXAds,GetDBExtension(),IF(__lCtreeCDX,GetDBExtension(),"")))
		Local cIDNP			AS CHARACTER	VALUE "NP_NUMBER"+IF(__lTopConn,"",IF(__ldbfCDXAds,RetIndExt(),IF(__lCtreeCDX,RetIndExt(),"")))
	
		Local cEmpty		AS CHARACTER
		Local cDBTmp		AS CHARACTER
		Local cAliasTmp		AS CHARACTER
	
		Local lOpened		AS LOGICAL
	
		Local lPack			AS LOGICAL
		Local lModStru		AS LOGICAL
		Local lPMaxNumP     AS LOGICAL
		Local lSetDeleted	AS LOGICAL
	    
		Local nFile			AS NUMBER
		Local nFiles		AS NUMBER
		Local nTcLink		AS NUMBER
			
		Static nContinue	AS NUMBER
	
		PARAMTYPE 1 VAR aDBs		AS ARRAY
		PARAMTYPE 2 VAR lNotShared	AS LOGICAL OPTIONAL DEFAULT .F.
	
		TRYEXCEPTION
	
			RddSetDefault( @__cNPRDD )

			IF .NOT.( Type("__cRDD") == "C" )
				Private __cRDD AS CHARACTER VALUE __cNPRDD
			EndIF

			IF ( __lTopConn )
				ASSIGN nTcLink	:= AdvConnection()
				IF Empty( nTCLink )
					Connect(NIL,.T.,NIL,NIL,4,)
					ASSIGN nTcLink	:= AdvConnection()
					IF .NOT.( Empty( nTcLink ) )
						IF ( nTcLink == -1 )
							UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível conectar ao DBMS]" ) )
						EndIF
					EndIF
				EndIF
				ASSIGN cDBIP	:= RetFileName(cDBIP)
				ASSIGN cIDIP	:= RetFileName(cIDIP)
				ASSIGN cDBNP	:= RetFileName(cDBNP)
				ASSIGN cIDNP	:= RetFileName(cIDNP)
			EndIF
	
			IF .NOT.( Type( NP_PRVT_IPALIAS ) == "C" )
				_SetOwnerPrvt( NP_PRVT_IPALIAS , GetNextAlias() )
			EndIF	
	
			IF .NOT.( Type( NP_PRVT_NPALIAS ) == "C" )
				_SetOwnerPrvt( NP_PRVT_NPALIAS , GetNextAlias() )
			EndIF	
	
			IF .NOT.( Type( NP_PRVT_NPDBS ) == "A" )
				_SetOwnerPrvt( NP_PRVT_NPDBS , {} )
			EndIF
	
			ASSIGN lNotShared	:= ( lNotShared .or. .NOT.( MsFile( cDBIP , NIL , __cNPRDD ) ) .or. .NOT.( MsFile( cIDIP , NIL , __cNPRDD ) ) )
	
			IF ( lNotShared )
	
				IF .NOT.( UnLockNPFile( @NP_LOCKBYFNAME ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível Obter Exclusividade para Criação das Tabelas para o Inicio do Processamento]" ) )
				EndIF
	
				IF .NOT.( LockNPFile( @NP_LOCKBYFNAME ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível Obter Exclusividade para Criação das Tabelas para o Inicio do Processamento]" ) )
				EndIF	

			EndIF
	
			Sleep(NP_SLEEP_MIN)

			ASSIGN aDBIP	:= { { "IP_NUMBER" , "C" , __nPMaxNumP , 0 } , { "IP_PERFECT" , "L" , 1 , 0 } , { "IP_TTS" , "L" , 1 , 0 } }

			IF .NOT.( MsFile( cDBIP , NIL , __cNPRDD ) )
				IF .NOT.( MsCreate( cDBIP ,  @aDBIP , @__cNPRDD ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs]Impossível Criar: " + cDBIP + "]" ) )
				EndIF
			EndIF
			
			IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
			EndIF

			ASSIGN lPMaxNumP	:= ( Len( ( __cAliasIP )->IP_NUMBER ) < __nPMaxNumP )

			IF ( Len( ( __cAliasIP )->IP_NUMBER ) > __nPMaxNumP )
				ASSIGN lPMaxNumP			:= .T.
				ASSIGN __nPMaxNumP			:= Max( __nPMaxNumP , Len( ( __cAliasIP )->IP_NUMBER ) )
				ASSIGN aDBIP[1][DBS_LEN]	:= __nPMaxNumP
			EndIF

			ASSIGN aModStru	:= ( __cAliasIP )->( dbStruct() )
			ASSIGN lModStru	:= .NOT.( Compare( aDBIP , aModStru ) )

			aAdd(;
					aOrdBagIP , {;
 										 "IP_NUMBER"		,; // 01 - Chave do Indice 
 										 { || IP_NUMBER }	,; // 02 - Nome Fisico do Arquivo de Indice
 										 "IP_NUMBER1"		,; // 03 - Nome Fisico do Arquivo de Indice
 										 "1"				,; // 04 - Ordem do Indice
 										 "IP_NUMBER1"		 ; // 05 - Apelido do Indice
 					 		  			};
 			)

			IF ( __ldbfCDXAds )
				
				aAdd(;
						aOrdBagIP , {;
	 										 "PADL(RTRIM(IP_NUMBER),"+AllTrim(STR(__nPMaxNumP))+")"			,; // 01 - Chave do Indice 
	 										 &("{||PADL(RTRIM(IP_NUMBER),"+AllTrim(STR(__nPMaxNumP))+")}")	,; // 02 - Chave do Indice 
	 										 "IP_NUMBER2"													,; // 03 - Nome Fisico do Arquivo de Indice
	 										 "2"															,; // 04 - Ordem do Indice
	 										 "IP_NUMBER2"	 										 		 ; // 05 - Apelido do Indice
	 					 		  			};
	 			)
			
			EndIF

			IF ( lModStru )
				IF ( lPMaxNumP )
					ASSIGN cDBTmp := CriaTrab(NIL,.F.)+IF(__lTopConn,"",IF(__ldbfCDXAds,GetDBExtension(),IF(__lCtreeCDX,GetDBExtension(),"")))
					( __cAliasIP )->( dbCloseArea() )
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .T. , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
					EndIF
					IF .NOT.( ( __cAliasIP )->( MsCopyFile(cDBIP,cDBTmp,__cNPRDD) ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível renomear tabela " +  cDBIP + " para Recriacao]" ) )
					EndIF
				EndIF
				( __cAliasIP )->( tbDropIndex(__cAliasIP,cIDIP,aOrdBagIP) )
				( __cAliasIP )->( dbCloseArea() )
				IF .NOT.( MsErase( cDBIP , NIL , __cNPRDD ) )
					IF File( cDBIP )
						IF .NOT.( fErase( cDBIP ) == 0 )
							UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível dropar tabela " +  cDBIP + " para Recriacao]" ) )
						EndIF
					EndIF	
				EndIF	
				IF .NOT.( MsCreate( cDBIP ,  @aDBIP , @__cNPRDD ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs]Impossível Criar: " + cDBIP + "]" ) )
				EndIF
				IF ( lPMaxNumP )
					ASSIGN cAliasTmp	:= GetNextAlias()
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBTmp , @cAliasTmp , .T. , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBTmp + "]" ) )
					EndIF
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
					EndIF
					( __cAliasIP )->( MsAppEnd( cDBIP , cDBTmp ) )
					( cAliasTmp )->( dbCloseArea() )
					MsErase( cAliasTmp , NIL , __cNPRDD )
				EndIF
				( __cAliasIP )->( dbCloseArea() )
				IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
				EndIF
			EndIF

			IF ( lNotShared )
				( __cAliasIP )->( tbDropIndex(__cAliasIP,cIDIP,aOrdBagIP) )
				( __cAliasIP )->( dbCloseArea() )
				IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
				EndIF
			EndIF

			IF .NOT.( (__cAliasIP)->( tbCreateIndex( @__cAliasIP , @cIDIP , @aOrdBagIP ) ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível Indexar: " + cIDIP + "]" ) )
			EndIF
			( __cAliasIP )->( dbCloseArea() )
			IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBIP , @__cAliasIP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBIP + "]" ) )
			EndIF
			(__cAliasIP)->( tbCreateIndex( @__cAliasIP , @cIDIP , @aOrdBagIP ) )

			ASSIGN aDBNP	:= { { "NP_NUMBER" , "C" , __nPMaxNumP , 0 } }

			IF .NOT.( MsFile( cDBNP , NIL , __cNPRDD ) )
				IF .NOT.( MsCreate( cDBNP ,  @aDBNP , @__cNPRDD ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs]Impossível Criar: " + cDBNP + "]" ) )
				EndIF
			EndIF
			
			IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
			EndIF

			ASSIGN lPMaxNumP	:= ( Len( ( __cAliasNP )->NP_NUMBER ) < __nPMaxNumP )

			IF ( Len( ( __cAliasNP )->NP_NUMBER ) > __nPMaxNumP )
				ASSIGN lPMaxNumP			:= .T.
				ASSIGN __nPMaxNumP			:= Max( __nPMaxNumP , Len( ( __cAliasNP )->NP_NUMBER ) )
				ASSIGN aDBNP[1][DBS_LEN]	:= __nPMaxNumP
			EndIF

			ASSIGN aModStru	:= ( __cAliasNP )->( dbStruct() )
			ASSIGN lModStru	:= .NOT.( Compare( aDBNP , aModStru ) )

			aAdd(;
					aOrdBagNP , {;
 										 "NP_NUMBER"		,; // 01 - Chave do Indice 
 										 { || NP_NUMBER }	,; // 02 - Nome Fisico do Arquivo de Indice
 										 "NP_NUMBER1"		,; // 03 - Nome Fisico do Arquivo de Indice
 										 "1"				,; // 04 - Ordem do Indice
 										 "NP_NUMBER1"		 ; // 05 - Apelido do Indice
 					 		  			};
 			)
			
			IF ( __ldbfCDXAds )
			
				aAdd(;
						aOrdBagNP , {;
	 										 "PADL(RTRIM(NP_NUMBER),"+AllTrim(STR(__nPMaxNumP))+")"			,; // 01 - Chave do Indice 
	 										 &("{||PADL(RTRIM(NP_NUMBER),"+AllTrim(STR(__nPMaxNumP))+")}")	,; // 02 - Chave do Indice 
	 										 "NP_NUMBER2"													,; // 03 - Nome Fisico do Arquivo de Indice
	 										 "2"															,; // 04 - Ordem do Indice
	 										 "NP_NUMBER2"	 										 		 ; // 05 - Apelido do Indice
	 					 		  			};
	 			)
			
			ENDIF            

			IF ( lModStru )
				IF ( lPMaxNumP )
					ASSIGN cDBTmp := CriaTrab(NIL,.F.)+IF(__lTopConn,"",IF(__ldbfCDXAds,GetDBExtension(),IF(__lCtreeCDX,GetDBExtension(),"")))
					( __cAliasNP )->( dbCloseArea() )
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .T. , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
					EndIF
					IF .NOT.( ( __cAliasNP )->( MsCopyFile(cDBNP,cDBTmp,__cNPRDD) ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível renomear tabela " +  cDBNP + " para Recriacao]" ) )
					EndIF
				EndIF
				( __cAliasNP )->( tbDropIndex(__cAliasNP,cIDNP,aOrdBagNP) )
				( __cAliasNP )->( dbCloseArea() )
				IF .NOT.( MsErase( cDBNP , NIL , __cNPRDD ) )
					IF File( cDBNP )
						IF .NOT.( fErase( cDBNP ) == 0 )
							UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível dropar tabela " +  cDBNP + " para Recriacao]" ) )
						EndIF
					EndIF	
				EndIF
				IF .NOT.( MsCreate( cDBNP ,  @aDBNP , @__cNPRDD ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs]Impossível Criar: " + cDBNP + "]" ) )
				EndIF
				IF ( lPMaxNumP )
					ASSIGN cAliasTmp	:= GetNextAlias()
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBTmp , @cAliasTmp , .T. , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBTmp + "]" ) )
					EndIF
					IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
						UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
					EndIF
					( __cAliasNP )->( MsAppEnd( cDBNP , cDBTmp ) )
					( cAliasTmp )->( dbCloseArea() )
					MsErase( cAliasTmp , NIL , __cNPRDD )
				EndIF
				( __cAliasNP)->( dbCloseArea() )
				IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
				EndIF
			EndIF

			IF ( lNotShared )
				( __cAliasNP )->( tbDropIndex(__cAliasNP,cIDNP,aOrdBagNP) )
				( __cAliasNP )->( dbClearIndex() )
				( __cAliasNP )->( dbCloseArea() )
				IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
					UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
				EndIF
			EndIF

			IF .NOT.( (__cAliasNP)->( tbCreateIndex( @__cAliasNP , @cIDNP , @aOrdBagNP ) ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível Indexar: " + cIDNP + "]" ) )
			EndIF
			( __cAliasNP )->( dbCloseArea() )
			IF .NOT.( MsOpenDbf( .T. , @__cNPRDD , @cDBNP , @__cAliasNP , .NOT.( lNotShared ) , .F. , .T. , .F. ) )
				UserException( OemToAnsi( "[NP_EXCEPTION][OpenDBs][Impossível abrir: " + cDBNP + "]" ) )
			EndIF
			(__cAliasNP)->( tbCreateIndex( @__cAliasNP , @cIDNP , @aOrdBagNP ) )

			IF ( lNotShared )
				
				ASSIGN lSetDeleted	:= Set( _SET_DELETED , .F. )
				
				ASSIGN cEmpty		:= Space( __nPMaxNumP )
				
				( __cAliasIP )->( dbGotop() )
				ASSIGN lPack		:= ( __cAliasIP )->( ( IP_NUMBER == cEmpty ) .or. dbSeek( cEmpty , .F. ) )
				While ( __cAliasIP )->( .NOT.( Eof() ) .and. ( IP_NUMBER == cEmpty ) )
					( __cAliasIP )->( dbDelete() )
					( __cAliasIP )->( dbSkip() )
				End While
				IF ( lPack )
					( __cAliasIP )->( __dbPack() )
				EndIF	
				( __cAliasIP )->( dbCloseArea() )
				
				( __cAliasNP )->( dbGotop() )
				ASSIGN lPack		:= ( __cAliasNP )->( ( NP_NUMBER == cEmpty ) .or. dbSeek( cEmpty , .F. ) )
				While ( __cAliasNP )->( .NOT.( Eof() ) .and. ( NP_NUMBER == cEmpty ) )
					( __cAliasNP )->( dbDelete() )
					( __cAliasNP )->( dbSkip() )
				End While
				IF ( lPack )
					( __cAliasNP )->( __dbPack() )
				EndIF	
				( __cAliasNP )->( dbCloseArea() )
	
				Set( _SET_DELETED , lSetDeleted )
	
				ASSIGN lOpened := OpenDBs( @aDBs , .F. )
	
				UnLockNPFile( @NP_LOCKBYFNAME )

				ASSIGN aFiles := Array( aDir( NP_PATHLCK + "*.nplck" ) )
				ASSIGN nFiles := aDir( NP_PATHLCK + "*.nplck" , @aFiles )
				For nFile := 1 To nFiles
					ASSIGN cFile := Lower(NP_PATHLCK+aFiles[nFile])
					IF .NOT.(NP_FILELCK$cFile)
						LockNPFile(cFile)
						UnLockNPFile(cFile)
					EndIF	
				Next nFile	

			Else
	
				ASSIGN aDBs		:= &( NP_PRVT_NPDBS )
				
				aSize( aDBs , 0 )
	
				aAdd( aDBs , __cAliasIP )
				aAdd( aDBs , __cAliasNP )
	
				ASSIGN lOpened	:= .T.
			
			EndIF
	
		CATCHEXCEPTION 
	
			IF ( lNotShared )
	
				UnLockNPFile( @NP_LOCKBYFNAME )
	
				++nContinue
	
				IF ( nContinue < 3 )
				
					Sleep(NP_SLEEP_MIN)
	
					ASSIGN lOpened 	:= OpenDBs( @aDBs , @lNotShared )
	
					IF .NOT.( lOpened )
	
						Sleep(NP_SLEEP_MAX)
	
					EndIF
	
				Else
				
					ConOut( "" , "" , "[NP_ERROR][OpenDBs]" + CaptureError( .T. ) )
				
				EndIF
	
			Else
	
				ConOut( "" , "" , "[NP_ERROR][OpenDBs]" + CaptureError( .T. ) )
			
			EndIF
	
		ENDEXCEPTION
	
	Return( lOpened )
	
	/*
		Funcao	: CloseDBs
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 09/07/2011
		Uso		: Fecha as Areas de Trabalho em Uso
	*/
	Static Function CloseDBs( aDBs )
		PARAMTYPE 1 VAR aDBs AS ARRAY
		aEval( aDBs , { |cAlias| IF( Select( cAlias ) > 0 , ( cAlias )->( dbCloseArea() ) , NIL ) } )
		aSize( aDBs , 0 )
	Return( .T. )
	
	/*
		Funcao	: GetStartNumber
		Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data	: 13/07/2011
		Uso		: Obtem o Numero Inicial
	*/
	Static Function GetStartNumber(lBegin)
	
		Local cN		AS CHARACTER
		Local cM		AS CHARACTER

		Local lFound	AS LOGICAL
	    
	    PARAMTYPE 1 VAR lBegin AS LOGICAL DEFAULT .T.

		IF ( lBegin )
		
			BEGIN SEQUENCE
				IF ( __cAliasNP )->( .NOT.( RecCount() == 0 ) )
					( __cAliasNP )->( dbGoTop() )
					IF ( __ldbfCDXAds )
						( __cAliasIP )->( dbSetOrder( OrdNumber( "IP_NUMBER2" ) ) )
						While ( __cAliasNP )->( .NOT.( Eof() ) )
							ASSIGN cN		:= ( __cAliasNP )->NP_NUMBER
							ASSIGN cN		:= PadL( RTrim( AllTrim( cN ) ) , __nPMaxNumP )
							ASSIGN lFound	:= ( __cAliasIP )->( dbSeek( cN , .F. ) )
							IF .NOT.( lFound )
								BREAK
							EndIF
							( __cAliasNP )->( dbSkip() )
						End While	
					Else	
						IF ( __lCtreeCDX )
							( __cAliasIP )->( dbSetOrder( 1 ) )
						Else
							( __cAliasIP )->( dbSetOrder( OrdNumber( "IP_NUMBER1" ) ) )
						EndIF	
						While ( __cAliasNP )->( .NOT.( Eof() ) )
							ASSIGN cN		:= ( __cAliasNP )->NP_NUMBER
							ASSIGN lFound	:= ( __cAliasIP )->( dbSeek( cN , .F. ) )
							IF .NOT.( lFound )
								BREAK
							EndIF
							While ( __cAliasIP )->( .NOT.( Eof() ) )
								lFound := ( cN == ( __cAliasIP )->( IP_NUMBER ) )
								IF ( lFound )
									EXIT
								EndIF
								( __cAliasIP )->( dbSkip() )
							End While
							IF .NOT.( lFound )
								BREAK
							EndIF
							( __cAliasNP )->( dbSkip() )
						End While
					EndIF
					( __cAliasIP )->( dbSetFilter( { ||IP_TTS==.F. } , "IP_TTS==.F." ) )
					( __cAliasIP )->( dbGotop() )
					ASSIGN cN	:= ( __cAliasIP )->IP_NUMBER
					IF ( __ldbfCDXAds )
						BREAK
					EndIF
					ASSIGN cN	:= PadL( RTrim( AllTrim( cN ) ) , __nPMaxNumP )
					While ( __cAliasIP )->( .NOT.( Eof() ) )
						ASSIGN cM := ( __cAliasIP )->IP_NUMBER
						ASSIGN cM := PadL( RTrim( AllTrim( cM ) ) , __nPMaxNumP )
						IF ( cN > cM )
							cN := cM
						EndIF
						( __cAliasIP )->( dbSkip() )
					End While
			    EndIF
			END SEQUENCE
	
			( __cAliasIP )->( dbClearFilter() )
			IF ( __lCtreeCDX )
				( __cAliasIP )->( dbSetOrder( 1 ) )
			Else
				( __cAliasIP )->( dbSetOrder( OrdNumber( "IP_NUMBER1" ) ) )
			EndIF	

			( __cAliasNP )->( dbClearFilter() )
			IF ( __lCtreeCDX )
				( __cAliasNP )->( dbSetOrder( 1 ) )
			Else
				( __cAliasNP )->( dbSetOrder( OrdNumber( "NP_NUMBER1" ) ) )
			EndIF	
			
			ASSIGN cN := AllTrim( cN ) 
		
		EndIF	
		
		IF Empty( cN )
			ASSIGN cN	:= "6"	//Inicio com o Primeiro Numero do Grupo dos Perfeitos
		EndIF
	
	Return( cN )

	#IFNDEF __DEBUGNP
		/*
			Funcao	: StartGJob
			Autor	: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
			Data	: 21/02/2013
			Uso		: Forcar a Subida dos Grids Server e Agent
		*/
		Static Function StartGJob( oGClient , lServer )

		    Local cIni			AS CHARACTER	VALUE GetSrvIniName()
		    Local cSEnv			AS CHARACTER	VALUE GetPvProfString( "GridServer" , "ENVIRONMENT" , GetEnvServer() , cIni )
		    Local cAEnv			AS CHARACTER	VALUE GetPvProfString( "GridAgent"  , "ENVIRONMENT" , cSEnv          , cIni )

		    Local lGridC		AS LOGICAL
                                
		    Local nWait         AS NUMBER
		    Local nInstances	AS NUMBER

			PARAMTYPE 1 VAR oGClient	AS OBJECT  DEFAULT GridClient():New()
			PARAMTYPE 2 VAR lServer		AS LOGICAL DEFAULT .F.

		    IF ( lServer )
			    StartJob( "GridServer" , cSEnv , .F. )
				ASSIGN nWait := 0
				While ( ( ++nWait ) <= NP_GRIDBMAXWAIT )
					Sleep(NP_SLEEP_MIN)
				End While
		    EndIF
	
		    ASSIGN nInstances := Val( GetPvProfString( "GridAgent" , "Instances" , GetEnvServer() , GetSrvIniName() ) )
		    While ( nInstances > 0 )
		    	--nInstances
		    	StartJob( "GridAgent" , cAEnv , .F. )
				ASSIGN nWait := 0
				While ( ( ++nWait ) <= NP_GRIDBMAXWAIT )
					Sleep(NP_SLEEP_MIN)
				End While
		    End While    

			IF .NOT.( ValType( oGClient ) == "O" )
				ASSIGN oGClient			:= GridClient():New()
				ASSIGN oGClient:lBlind	:= .T.	//Nao Executa a Processa
			EndIF

			ASSIGN lGridC	:= oGClient:ConnectCoord()

			IF .NOT.( lGridC )
				ConOut( "" , "" )
				ConOut( "" , "" , "[NP_WARNING][NPerfeitos]" + oGClient:GetError() )
			EndIF	

		Return( lGridC )

	#ENDIF

	/*
		Funcao		: tbCreateIndex
		Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data		: 21/02/2013
		Descricao	: Cria os Indices
	*/
	Static Function tbCreateIndex( cAlias , cPathFile , aOrdBag )
	
		Local lIndexOK	AS LOGICAL

		Local cBagName	AS CHARACTER
		Local cRddName	AS CHARACTER

		Local nBag		AS NUMBER
		Local nBags		AS NUMBER

		PARAMTYPE 1 VAR cAlias 		AS CHARACTER
		PARAMTYPE 2 VAR cPathFile	AS CHARACTER
		PARAMTYPE 3 VAR aOrdBag 	AS ARRAY

		ASSIGN cBagName	:= ( RetFileName(FileNoExt(cPathFile))+IF(__lTopConn,"",IF(__ldbfCDXAds,RetIndExt(),IF(__lCtreeCDX,RetIndExt(),""))) )
		ASSIGN cRddName	:= ( cAlias )->( RddName() )

		ASSIGN nBags := Len( aOrdBag )
		
		For nBag := 1 To nBags
			IF .NOT.( ( cAlias )->( MsFile( cPathFile , aOrdBag[nBag][3] , cRddName ) ) )
		 		IF ( __lTopConn )
		 			( cAlias )->( dbCreateIndex(aOrdBag[nBag][3],aOrdBag[nBag][1],aOrdBag[nBag][2],IF(.F.,.T.,NIL)) )
		 		Else
					( cAlias )->( OrdCreate(cBagName,aOrdBag[nBag][3],aOrdBag[nBag][1],aOrdBag[nBag][2],IF(.F.,.T.,NIL)))
		 		EndIF
		 	EndIF
		Next nBag
		
		( cAlias )->( dbClearIndex() )
		
		For nBag := 1 To Len( aOrdBag )
			IF ( __lTopConn )
				( cAlias )->( dbSetIndex(aOrdBag[nBag][3] ) )
				( cAlias )->( OrdListAdd(aOrdBag[nBag][3],aOrdBag[nBag][3] ) )
			Else
				( cAlias )->( OrdListAdd(cBagName,aOrdBag[nBag][3] ) )
			EndIF
			( cAlias )->( dbSetNickName( aOrdBag[nBag][3],aOrdBag[nBag][5] ) )
		Next nBag

		For nBag := 1 To nBags
			ASSIGN lIndexOK := ( cAlias )->( MsFile( cPathFile , aOrdBag[nBag][3] , cRddName ) )
			IF .NOT.( lIndexOK )
				BREAK
			EndIF
		Next nBag

		IF ( lIndexOK )
			( cAlias )->( dbSetorder( 1 ) )
		EndIF	
	
	Return( lIndexOK )
	
	/*
		Funcao		: tbDropIndex
		Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data		: 21/02/2013
		Descricao	: Apaga os Indices
	*/
	Static Function tbDropIndex( cAlias , cTable , aOrdBag )

		Local cBagName	AS CHARACTER
		Local cRddName	AS CHARACTER

		Local nBag		AS NUMBER
		Local nBags		AS NUMBER
		
		Local lDropOK	AS LOGICAL VALUE .T.

		PARAMTYPE 1 VAR cAlias 	AS CHARACTER
		PARAMTYPE 2 VAR cTable	AS CHARACTER
		PARAMTYPE 3 VAR aOrdBag	AS ARRAY

		ASSIGN cBagName	:= ( RetFileName(FileNoExt(cTable))+IF(__lTopConn,"",IF(__ldbfCDXAds,RetIndExt(),IF(__lCtreeCDX,RetIndExt(),""))) )
		ASSIGN cRddName := ( cAlias )->( RddName() )

		IF ( __lTopConn )
			( cAlias )->( dbClearIndex() )
			ASSIGN lDropOK := ( cAlias )->( TCDropIndex( cTable , aOrdBag ) )
		Else
			ASSIGN nBags := Len( aOrdBag )
			For nBag := 1 To nBags
				IF ( cAlias )->( MsFile(cBagName,aOrdBag[nBag][3],cRddName) ) 
					MsErase( cBagName , aOrdBag[nBag][3] , cRddName )
			 	EndIF
			Next nBag
	 		MsErase( cBagName , cBagName , cRddName )
	 		IF File( cBagName )
	 			fErase( cBagName )
	 		EndIF
			ASSIGN lDropOK	:= .NOT.( File( cBagName ) )
			( cAlias )->( dbClearIndex() )
		EndIF	

	Return( lDropOK )

	/*
		Funcao		: TCDropIndex
		Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
		Data		: 21/02/2013
		Descricao	: Drop dos Indices
	*/
	Static Function TCDropIndex( cTable , aOrdBag )
	
		Local cQuery		AS CHARACTER
		Local cTcGetDb		AS CHARACTER
		Local cTcSrvType	AS CHARACTER	VALUE Upper( AllTrim( TcSrvType() ) )
		
		Local lDropped		AS LOGICAL		VALUE .T.
		Local lAS400		AS LOGICAL		VALUE ( cTcSrvType == "AS/400" )

		Local nBag			AS NUMBER
		Local nBags			AS NUMBER

		PARAMTYPE 1 VAR cTable 	AS CHARACTER
		PARAMTYPE 3 VAR aOrdBag	AS ARRAY
		
		ASSIGN nBags 	:= Len( aOrdBag )
		ASSIGN cTcGetDb	:= Upper( AllTrim( TcGetDb() ) )

		For nBag := 1 To nBags
			IF TcCanOpen( cTable , aOrdBag[nBag][3] )
				IF .NOT.( lAS400 )
					IF .NOT.( cTcGetDb $ "ORACLE/INFORMIX" )
						ASSIGN cQuery := ( "Drop Index "+ cTable + "." + aOrdBag[nBag][3] )
					Else
						ASSIGN cQuery := ( "Drop Index " + aOrdBag[nBag][3] )
					EndIF
		       		ASSIGN lDropped := ( TcSqlExec( cQuery ) == 0 )
		    	Else
		    		ASSIGN lDropped := MsErase( cTable , aOrdBag[nBag][3] , "TOPCONN" )
		    	EndIF
		    EndIF
		Next nBag

		TcRefresh( cTable )

	Return( lDropped )

#ENDIF