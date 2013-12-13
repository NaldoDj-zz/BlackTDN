#include "ndj.ch"
Static Function NDJIPCControl(cEmp,cFil,cFunction,nThreads,bIPCPSlice,nIPCPSlice,oProcess,cIDThread,uIPCPar02,uIPCPar03,uIPCPar04,uIPCPar05,;
                                                           		                          uIPCPar06,uIPCPar07,uIPCPar08,uIPCPar09,uIPCPar10,;
													                                      uIPCPar11,uIPCPar12,uIPCPar13,uIPCPar14,uIPCPar15,;
													                                      uIPCPar16,uIPCPar17,uIPCPar18,uIPCPar19,uIPCPar20)	
	
	Local aIDThreads		:= Array(0)

	Local cMsg1
	Local cMsg2
	Local cGlbError
	Local cGlbValue
	Local cEnvServer		:= GetEnvServer()
	Local cSemaphore		:= NDJSemaphore()
	Local cGlbErrorMsg
	Local cGlbErrorSTK
	Local cFileControl		:= NDJ_CIPCFILECONTROL
    
	Local lRet				:= .F.
	Local lError			:= .F.
	Local loProcess			:= (ValType(oProcess)=="O")
	Local lGlbValue			:= .F.
	Local lGlbError			:= .F.
	Local lbIPCPSlice		:= ((ValType(bIPCPSlice)=="B").and.((ValType(nIPCPSlice)=="N").and.((nIPCPSlice>=2).and.(nIPCPSlice<=20))))
	
	Local nThread
	Local nAllThreadsOK		:= 0
	
	BEGIN SEQUENCE
	
		IF .NOT.(NDJFControl(cFileControl))
			BREAK
		ENDIF
		
		DEFAULT nThreads	:= 1
	
		IF ( loProcess )
			oProcess:SetRegua1( nThreads )
		EndIF

		For nThread := 1 To nThreads
			cIDThread := cSemaphore
			cIDThread += NDJIDThread(nThread)
			IF ( loProcess )
				oProcess:IncRegua1( "Iniciando Thread["+cIDThread+"]" )
				IF ( oProcess:lEnd )
					BREAK
				EndIF
			EndIF	
			StartJob("U_NDJWaitEx",cEnvServer,.F.,@cSemaphore,@cFunction,@cEmp,@cFil)
			IF ( NDJ_NIPCGLBLOCK == 1 )
				While .NOT.( GlbLock() )
					NDJKillApp(cFileControl)
					IF ( KillApp() )
						IF ( loProcess )
							oProcess:lEnd := .T.
						EndIF
						BREAK
					EndIF
					Sleep(NDJ_NIPCSLEEP)
				End While
			EndIF
			PutGlbValue(cIDThread,".F.")
			PutGlbValue("NDJIPCTTS"+cIDThread,"0")
			PutGlbValue("NDJIPCERROR"+cIDThread,".F.")
			PutGlbValue("NDJIPCERRORMSG"+cIDThread,"")
			PutGlbValue("NDJIPCERRORSTK"+cIDThread,"")
			IF ( NDJ_NIPCGLBLOCK == 1 )
				GlbUnLock()
			EndIF	
			aAdd(aIDThreads,{cIDThread,.F.})
		Next nThread
		
		IF ( loProcess )
			oProcess:SetRegua1( nThreads )
		EndIF

		For nThread := 1 To nThreads
			NDJKillApp(cFileControl)
			IF ( KillApp() )
				IF ( loProcess )
					oProcess:lEnd := .T.
				EndIF
				BREAK
			EndIF
			cIDThread	:= aIDThreads[nThread][1]
			IF ( loProcess )
				oProcess:IncRegua1( "Preparando Thread["+cIDThread+"]" )
				IF ( oProcess:lEnd )
					BREAK
				EndIF
			EndIF	
			IF ( lbIPCPSlice )
				DO CASE
				CASE ( nIPCPSlice == 2 )
					uIPCPar02 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
				CASE ( nIPCPSlice == 3 )
					uIPCPar03 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
				CASE ( nIPCPSlice == 4 )
					uIPCPar04 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
				CASE ( nIPCPSlice == 5 )
					uIPCPar05 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
                CASE ( nIPCPSlice == 6 )
                	uIPCPar06 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 7 )
               		uIPCPar07 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 8 )
               		uIPCPar08 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 9 )
               		uIPCPar09 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 10 )
               		uIPCPar10 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 11 )
               		uIPCPar11 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 12 )
               		uIPCPar12 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 13 )
               		uIPCPar13 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 14 )
               		uIPCPar14 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 15 )
               		uIPCPar15 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 16 )
               		uIPCPar16 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 17 )
               		uIPCPar17 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 18 )
               		uIPCPar18 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 19 )
               		uIPCPar19 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	CASE ( nIPCPSlice == 20 )
               		uIPCPar20 := Eval(bIPCPSlice,cIDThread,nThread,nThreads)
               	ENDCASE
			EndIF
			While .NOT.(IPCGo(@cSemaphore,@cIDThread,@uIPCPar02,@uIPCPar03,@uIPCPar04,@uIPCPar05,;
                                          @uIPCPar06,@uIPCPar07,@uIPCPar08,@uIPCPar09,@uIPCPar10,;
										  @uIPCPar11,@uIPCPar12,@uIPCPar13,@uIPCPar14,@uIPCPar15,;
										  @uIPCPar16,@uIPCPar17,@uIPCPar18,@uIPCPar19,@uIPCPar20))
				Sleep(NDJ_NIPCSLEEP)
				NDJKillApp(cFileControl)
				IF ( KillApp() )
					IF ( loProcess )
						oProcess:lEnd := .T.
					EndIF
					BREAK
				EndIF
				IF ( loProcess )
					IF ( oProcess:lEnd )
						BREAK
					EndIF
				ENDIF	
			End While
			Sleep(NDJ_NIPCSLEEP)
		Next nThread	
		
		Sleep(NDJ_NIPCSLEEP)

		While .NOT.( KillApp() )
			nAllThreadsOK := 0
			IF ( loProcess )
				oProcess:SetRegua1( nThreads )
				IF ( oProcess:lEnd )
					BREAK
				EndIF
			EndIF
			For nThread := 1 To nThreads
				NDJKillApp(cFileControl)
				IF ( KillApp() )
					IF ( loProcess )
						oProcess:lEnd := .T.
					EndIF
					BREAK
				EndIF
				cIDThread	:= aIDThreads[nThread][1]
				IF ( loProcess )
					oProcess:IncRegua1( "Aguardando a Finalização da Thread["+cIDThread+"]" )
					IF ( oProcess:lEnd )
						BREAK
					EndIF
				EndIF	
				IF ( NDJ_NIPCGLBLOCK == 1 )
					While .NOT.( GlbLock() )
						NDJKillApp(cFileControl)
						IF ( KillApp() )
							BREAK
						EndIF
						Sleep(NDJ_NIPCSLEEP)
					End While
				EndIF
				cGlbValue := GetGlbValue(cIDThread)
				cGlbError := GetGlbValue("NDJIPCERROR"+cIDThread)
				IF ( NDJ_NIPCGLBLOCK == 1 )
					GlbUnLock()
				EndIF
				lGlbError := &cGlbError		
				IF .NOT.( aIDThreads[nThread][2] )
					IF .NOT.( lGlbError )
						lGlbValue := &cGlbValue
						aIDThreads[nThread][2] := lGlbValue
					Else
						lError					:= .T.
						aIDThreads[nThread][2]	:= .T.
					EndIF
				Else
					++nAllThreadsOK
				EndIF
				IF ( aIDThreads[nThread][2] )
					NDJIPCMsgOut("[IDTHREAD]["+aIDThreads[nThread][1]+"]["+cGlbValue+"][ERROR]["+cGlbError+"][OK]")
				Else
					NDJIPCMsgOut("[IDTHREAD]["+aIDThreads[nThread][1]+"]["+cGlbValue+"][ERROR]["+cGlbError+"][NOT OK]")
				EndIF
			Next nThread
			IF ( nAllThreadsOK == nThreads )
				IPCGo(cSemaphore,"NDJ_FORCE_EXIT")
				EXIT
			EndIF
			Sleep(NDJ_NIPCSLEEP)
		End While

		IF ( loProcess )
			oProcess:SetRegua1( nThreads )
		EndIF
		
		For nThread := 1 To nThreads
			cIDThread	:= aIDThreads[nThread][1]
			IF ( NDJ_NIPCGLBLOCK == 1 )
				While .NOT.( GlbLock() )
					NDJKillApp(cFileControl)
					IF ( KillApp() )
						IF ( loProcess )
							oProcess:lEnd := .T.
						EndIF
						BREAK
					EndIF
					Sleep(NDJ_NIPCSLEEP)
				End While
			EndIF
			IF ( loProcess )
				oProcess:IncRegua1( "Finalizando a Thread["+cIDThread+"]" )
				IF ( oProcess:lEnd )
					BREAK
				EndIF
			EndIF	
			cGlbError    := GetGlbValue("NDJIPCERROR"+cIDThread)
			cGlbErrorMsg := GetGlbValue("NDJIPCERRORMSG"+cIDThread)
			cGlbErrorSTK := GetGlbValue("NDJIPCERRORSTK"+cIDThread)
			IF ( NDJ_NIPCGLBLOCK == 1 )
				GlbUnLock()
			EndIF
			lGlbError := &cGlbError
			IF ( lGlbError )
				cMsg1 := NDJIPCMsgOut("[IDTHREAD]["+aIDThreads[nThread][1]+"][ERROR]["+cGlbError+"][ERRORMSG]["+cGlbErrorMsg+"]")
				cMsg2 := NDJIPCMsgOut("[IDTHREAD]["+aIDThreads[nThread][1]+"][ERROR]["+cGlbError+"][ERRORSTK]["+cGlbErrorSTK+"]")					
				IF ( loProcess )
					oProcess:SaveLog( cMsg1 )
					oProcess:SaveLog( cMsg2 )
				EndIF
			Else
				cMsg1	:= NDJIPCMsgOut("[IDTHREAD]["+aIDThreads[nThread][1]+"]["+cGlbValue+"][ERROR]["+cGlbError+"][OK]")
				IF ( loProcess )
					oProcess:SaveLog( cMsg1 )
				EndIF
			EndIF
			IF ( NDJ_NIPCGLBLOCK == 1 )
				While .NOT.( GlbLock() )
					NDJKillApp(cFileControl)
					IF ( KillApp() )
						BREAK
					EndIF
					Sleep(NDJ_NIPCSLEEP)
				End While
			EndIF
			ClearGlbValue(cIDThread)
			ClearGlbValue("NDJIPCTTS"+cIDThread)
			ClearGlbValue("NDJIPCERROR"+cIDThread)
			ClearGlbValue("NDJIPCERRORMSG"+cIDThread)
			ClearGlbValue("NDJIPCERRORSTK"+cIDThread)
			IF ( NDJ_NIPCGLBLOCK == 1 )
				GlbUnLock()
			EndIF
		Next nThread
		
		lRet	:= .NOT.( lError )

	END SEQUENCE
	
	IPCGo(cSemaphore,"NDJ_FORCE_EXIT")
		
Return( lRet )

Function U_NDJWaitEx(cSemaphore,cFunction,cEmp,cFil)

	Local bError
	
	Local cFileControl	:= NDJ_CIPCFILECONTROL

	Local cIDThread,uIPCPar02,uIPCPar03,uIPCPar04,uIPCPar05,uIPCPar06,uIPCPar07,uIPCPar08,uIPCPar09,uIPCPar10,;
		  uIPCPar11,uIPCPar12,uIPCPar13,uIPCPar14,uIPCPar15,uIPCPar16,uIPCPar17,uIPCPar18,uIPCPar19,uIPCPar20    

    Local nTimeOut
		  
	Local xRet
		  
	bError	:= ErrorBlock({|e|NDJIPCError(e,IF((ValType(cIDThread)=="C"),cIDThread,NIL))})
	BEGIN SEQUENCE

		RpcSetType(3)
		RpcSetEnv(cEmp,cFil)

		InitPublic()
		SetsDefault()
		
		nTimeOut := GetNewPar("NDJIPCTOUT",3600000) //DEFAULT 3600000 Milisegundos (1 hora)

		While .NOT.( KillApp() )
			IF IPCWaitEx(cSemaphore,nTimeOut,@cIDThread,;
											 @uIPCPar02,;
											 @uIPCPar03,;
											 @uIPCPar04,;
											 @uIPCPar05,;
											 @uIPCPar06,;
											 @uIPCPar07,;
											 @uIPCPar08,;
											 @uIPCPar09,;
											 @uIPCPar10,;
											 @uIPCPar11,;
											 @uIPCPar12,;
											 @uIPCPar13,;
											 @uIPCPar14,;
											 @uIPCPar15,;
											 @uIPCPar16,;
											 @uIPCPar17,;
											 @uIPCPar18,;
											 @uIPCPar19,;
											 @uIPCPar20;
						)
				IF ( ( ValType(cIDThread) == "C" ) .and. ( cIDThread == "NDJ_FORCE_EXIT" ) )
					EXIT
				EndIF
				NDJInternal(NDJIPCMsgOut("Begin Execute->"+cFunction+"->IDTHREAD->"+cIDThread))
				xRet := &cFunction.(cIDThread,;
									uIPCPar02,;
									uIPCPar03,;
									uIPCPar04,;
									uIPCPar05,;
									uIPCPar06,;
									uIPCPar07,;
									uIPCPar08,;
									uIPCPar09,;
									uIPCPar10,;
									uIPCPar11,;
									uIPCPar12,;
									uIPCPar13,;
									uIPCPar14,;
									uIPCPar15,;
									uIPCPar16,;
									uIPCPar17,;
									uIPCPar18,;
									uIPCPar19,;
									uIPCPar20;
									)
				NDJInternal(NDJIPCMsgOut("End Execute->"+cFunction+"->IDTHREAD->"+cIDThread+"->Result->["+cValToChar(xRet)+"]"))
			Else                        
				NDJInternal(NDJIPCMsgOut("NDJ_FORCE_EXIT!!!"))
				EXIT
			EndIf
			NDJKillApp(cFileControl)
		End While
		
	END SEQUENCE
	ErrorBlock(bError)

	RpcClearEnv()

Return( NIL )

Static Function NDJSemaphore(cType,lInc,nSize)
	
	Local aFiles		:= Array(0)
	
	Local cExt
	Local cFile
	Local cNDJSMPR
	Local cNDJSMPF
	Local cProcName		:= ProcName()
	Local cFileControl
	Local cPathControl  := NDJ_CIPCPATHCONTROL
	
	Local nATT			:= 0
	Local nType
	Local nFile
	Local nFiles
	Local nFileControl

	Local lFileControl
	
	Static __aNDJTSMT
	
	DEFAULT cType := "IPC"
	DEFAULT nSize := 7
	
	IF .NOT.( ValType(__aNDJTSMT)=="A" )
		__aNDJTSMT := Array(0)
	EndIF
	
	nType := aScan(__aNDJTSMT,{|e|e[1]==cType})
	IF ( nType == 0 )
		aAdd(__aNDJTSMT,{cType,nSize})
		nType	:= Len(__aNDJTSMT)
	EndIF
	nSize		:= __aNDJTSMT[nType][2]
	
	cExt		:= ("."+Lower(cType+cProcName))

	While .NOT.(LockByName(cExt))
		IF ( ++nATT > 10 )
			UserException("Impossivel Obter Semaforo em "+cProcName)
		ENDIF
		Sleep(NDJ_NIPCSLEEP)
	End While

	cNDJSMPR	:= Replicate("0",nSize)
	
	nFiles		:= aDir(cPathControl+"*"+cExt,@aFiles)
	
	For nFile := 1 To nFiles
		cFile		 := Lower(aFiles[nFile])
		cFileControl := (cPathControl+cFile)
		IF ( File(cFileControl) )
			cNDJSMPF := StrTran(cFile,cExt,"")
			cNDJSMPR := IF((cNDJSMPR>cNDJSMPF),cNDJSMPR,cNDJSMPF)
			fErase(cFileControl)
		EndIF
	Next nFile
	
	DEFAULT lInc := .T.
	IF ( lInc )
		cNDJSMPR := __Soma1(cNDJSMPR)
	EndIF	
	
	cFileControl := (cPathControl+cNDJSMPR+cExt)
	lFileControl := NDJFControl(@cFileControl,@nFileControl,.F.)

	IF .NOT.(lFileControl)
		UnLockByName(cExt)
		UserException("Impossivel Obter Semaforo para "+__aNDJTSMT[nType][1])
	EndIF
    
	fClose(nFileControl)

	UnLockByName(cExt)

Return(cNDJSMPR)

Static Function NDJIDThread(nID,nSize)
	DEFAULT nID   := 1
	DEFAULT nSize := 3
Return(StrZero(nID,nSize))

Static Function NDJKillApp(cFileControl)
	
	Local cSPDrive
	Local cSPPath
	Local cSPFile
	Local cSPExt
	
	Local cPathControl  := NDJ_CIPCPATHCONTROL
	
	Local lKillApp
	
	DEFAULT cFileControl := NDJ_CIPCFILECONTROL
	
	SplitPath(cFileControl,@cSPDrive,@cSPPath,@cSPFile,@cSPExt)
	
	cFileControl := cPathControl
	cFileControl += cSPFile
	cFileControl += cSPExt

	lKillApp := IF(.NOT.(File(cFileControl)),KillApp(.T.),.F.)

	IF ( lKillApp )
		NDJIPCMsgOut("NDJKillApp")
	EndIF	

Return(lKillApp)

Static Function NDJIPCError(e,cIDThread)    
	IF (ValType(cIDThread)=="C")
		NDJDisTTS(cIDThread)
		MsUnLockAll()
		PutGlbValue(cIDThread,".T.")
		PutGlbValue("NDJIPCERROR"+cIDThread,".T.")
		PutGlbValue("NDJIPCERRORMSG"+cIDThread,"Error->Description->"+e:Description)
		PutGlbValue("NDJIPCERRORSTK"+cIDThread,"Error->Stack->"+e:ErrorStack)
		NDJIPCMsgOut("ERROR->IDThread["+cIDThread+"]")
	ENDIF
	NDJIPCMsgOut("Error->Description->"+e:Description)      
	NDJIPCMsgOut("Error->Stack->"+e:ErrorStack)
	BREAK
Return( NIL )

Static Function NDJFControl(cFileControl,nFileControl,lfClose)

	Local cSPDrive
	Local cSPPath
	Local cSPFile
	Local cSPExt

	Local cPathControl  := NDJ_CIPCPATHCONTROL

	Local lFile         := .F.
	Local nATT          := 0

	IF .NOT.(lIsDir(cPathControl))
		MakeDir(cPathControl)
	EndIF

	SplitPath(cFileControl,@cSPDrive,@cSPPath,@cSPFile,@cSPExt)

	cFileControl := cPathControl
	cFileControl += cSPFile
	cFileControl += cSPExt

	IF .NOT.(File(cFileControl))
		While .NOT.(LockByName(cFileControl))
			IF ( ++nATT > 10 )
				EXIT
			ENDIF
			Sleep(500)
			IF File(cFileControl)
				EXIT
			EndIF
		End While
		IF .NOT.(File(cFileControl))
			nFileControl := fCreate(cFileControl)
			DEFAULT lfClose := .F.
			IF ( lfClose )
				fClose(nFileControl)
				nFileControl := -1
			ENDIF	
		EndIF
		UnlockByName(cFileControl)
	EndIF

	lFile := File(cFileControl)

	IF .NOT.(lFile)
		NDJIPCMsgOut("Impossivel Criar : "+cFileControl)
	EndIF

Return(lFile)

Static Function NDJPathControl()
Return(NDJ_CIPCPATHCONTROL)

Static Function NDJChkTTS()
	Static __lNDJIPCTTS
	IF ( __lNDJIPCTTS == NIL )
		__lNDJIPCTTS := IF((Select("SX6")>0),GetNewPar("NDJIPCTTS",.T.),.T.)
	EndIF
Return(__lNDJIPCTTS)

Static Function NDJBegTTS(cIDThread)
	Local cTTS := "NDJIPCTTS"
	Local lTTS := .F.
	Local nTTS := NDJ_TRANNULL
	DEFAULT cIDThread := ""
	cTTS += cIDThread
	lTTS := NDJChkTTS()
	IF ( lTTS )
		lTTS := (GetGlbValue(cTTS)$"12345")
		IF .NOT.(lTTS)
			nTTS := NDJ_TRANBEGIN
			PutGlbValue(cTTS,AllTrim(Str(nTTS)))
	    	dbCommitAll()
		    TCCommit(nTTS,cTTS) //Begin Transaction
		Else
			nTTS := Val(GetGlbValue(cTTS))
		EndIF
	EndIF
Return(nTTS)

Static Function NDJEndTTS(cIDThread)
	Local cTTS := "NDJIPCTTS"
	Local lTTS := .F.
	Local nTTS := NDJ_TRANNULL
	DEFAULT cIDThread := ""
	cTTS += cIDThread
	lTTS := ( NDJChkTTS() .and. (GetGlbValue(cTTS)$"12345") )
	IF ( lTTS )
		nTTS := Val(GetGlbValue(cTTS))
		lTTS := (nTTS==NDJ_TRANBEGIN)
		IF (lTTS)
		    nTTS := NDJ_TRANCOMMIT
		    PutGlbValue(cTTS,AllTrim(Str(nTTS)))
		    dbCommitAll()
		    TCCommit(nTTS,cTTS) //Commit Transaction
		    nTTS := NDJ_TRANEND
		    PutGlbValue(cTTS,AllTrim(Str(nTTS)))
		    TCCommit(nTTS,cTTS) //End Transaction
		    nTTS := NDJ_TRANNULL
		    PutGlbValue(cTTS,AllTrim(Str(nTTS)))
		Else
			nTTS := Val(GetGlbValue(cTTS))
		EndIF
	EndIF
Return(nTTS)

Static Function NDJDisTTS(cIDThread)
	Local cTTS := "NDJIPCTTS"
	Local lTTS := .F.
	Local nTTS := NDJ_TRANNULL
	DEFAULT cIDThread := ""
	cTTS += cIDThread
	lTTS := ( NDJChkTTS() .and. (GetGlbValue(cTTS)$"12345") )
	IF (lTTS)
	    nTTS := Val(GetGlbValue(cTTS))
	    lTTS := ((nTTS>=1).and.(nTTS<=5))
	    IF ( lTTS )
	    	IF (nTTS<=2)
	    		nTTS := NDJ_TRANROLLBACK
	    		PutGlbValue(cTTS,AllTrim(Str(nTTS)))
	    		TCCommit(nTTS,cTTS) //RollBack Transaction
	    	EndIF
	    	IF .NOT.(nTTS==5)
	    		nTTS := NDJ_TRANEND
	    		PutGlbValue(cTTS,AllTrim(Str(nTTS)))
	    		TCCommit(nTTS,cTTS) //End Transaction
	    		nTTS := NDJ_TRANNULL
	    		PutGlbValue(cTTS,AllTrim(Str(nTTS)))
	    	EndIF
		Else
			nTTS := Val(GetGlbValue(cTTS))
		EndIF
	EndIF
Return(nTTS)

Static Function NDJIPCMsgOut(xOutPut,nOutPut) 

	Local cOutPut	:= ""                        

	DEFAULT nOutPut := NDJ_MSGCONOUT
	DEFAULT xOutPut	:= ""      
	
	IF (ValType(xOutPut)=="A")
		aEval(xOutPut,{|x|cOutPut+=xOutPut[x]+__cCRLF}) 
	Else
		cOutPut := xOutPut
	EndIF
	
	cOutPut := ("NDJ_IPC->"+ProcName(1)+"->"+DToS(MsDate())+"->"+Time()+"->"+cOutPut)     
	                
	IF (nOutPut==NDJ_MSGCONOUT)
		ConOut(cOutPut)
	ElseIF (nOutPut==TAF_MSGINTERNAL)
		NDJInternal(cOutPut)
	ElseIF (nOutPut==NDJ_MSGALERT)
		ApMsgAlert(cOutPut)
	EndIF
	
Return(cOutPut)

Static Function NDJInternal(cOutInternal)
	PTInternal(1,cOutInternal)
	#IFDEF TOP
		TCInternal(1,cOutInternal)
	#ENDIF
Return(cOutInternal)