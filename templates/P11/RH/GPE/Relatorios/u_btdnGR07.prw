#INCLUDE "PROTHEUS.CH"

#IFNDEF F_NAME
	#DEFINE F_NAME		1
#ENDIF
#IFNDEF F_SIZE
	#DEFINE F_SIZE		2
#ENDIF
#IFNDEF F_DATE
	#DEFINE F_DATE		3
#ENDIF
#IFNDEF F_TIME
	#DEFINE F_TIME		4
#ENDIF
#IFNDEF F_ATTR
	#DEFINE F_ATTR		5
#ENDIF
  
#DEFINE AMB_SERVER 1
#DEFINE AMB_CLIENT 2

#DEFINE	 PRT_SERVER 1
#DEFINE	 PRT_CLIENT 2

#DEFINE PRN_ID			1
#DEFINE PRN_NAME		2
#DEFINE PRN_FNAME		3
#DEFINE PRN_CONTINUE	4
#DEFINE PRN_MAIL		5
#DEFINE PRN_SENTMAIL	6
#DEFINE PRN_LOCKBYNAME	7

#DEFINE ELEM_PRN		7

#DEFINE N_SLEEP		  500

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: u_btdnGR07()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Gerar informacoes da Folha em PDF por funcionario
*/                          
User Function btdnGR07()

	MsAguarde({||__ChkAlias()},"Preparando Ambiente.","Aguarde...")
		GPER040()
	MsAguarde({||__ChkAlias()},"Restaurando Ambiente.","Aguarde...")

Return(__FechaRel())

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: __ChkAlias()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Resetar Alias em Memoria
*/                          
Static Function __ChkAlias()

	Local aAlias	:= Array(0)
	Local cAlias
	
	Local nAlias
	Local nAliases

	cAlias := "SR0"
	While ( cAlias <= "SRZ" )
		aAdd(aAlias,cAlias)
		cAlias := __Soma1(cAlias)
	End While

	aAdd(aAlias,"RHH")
	aAdd(aAlias,"CTT")
	aAdd(aAlias,"SI3")
	
	nAliases := Len( aAlias )
	For nAlias := 1 To nAliases
		cAlias := aAlias[nAlias]
		IF ( Select(cAlias) > 0 )
			(cAlias)->( dbCloseArea() )
			ChkFile(cAlias)
		EndIF
	Next nAlias

Return( NIL )

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: U_GPER040X()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Processa a Geracao e envio dos arquivos
*/ 
User Function GPER040X()
	
	Local bProcessa

	Local lRet			:= .T.
	Local lServer
	
	Local cTitulo
	Local cLInternet

	Local lGPER040
	Local lu_btdnGR0
	Local lbtdnGR07
	Local lGPCHKPER
	
	Local lProcessa	
	
	BEGIN SEQUENCE

		lGPER040 := IsInCallStack("GPER040")
		IF .NOT.( lGPER040 )
			APMsgAlert( OemToAnsi("Chamada Inválida") , OemToAnsi( "ATENÇÃO" ) )
			BREAK
		EndIF

		lu_btdnGR07 := IsInCallStack("u_btdnGR07")
		IF .NOT.( lu_btdnGR07 )
			APMsgAlert( OemToAnsi("Chamada Inválida") , OemToAnsi( "ATENÇÃO" ) )
			BREAK
		EndIF

		lGPCHKPER	:= IsInCallStack("u_btdnGR07")
		IF .NOT.( lGPCHKPER )
			APMsgAlert( OemToAnsi("Chamada Inválida") , OemToAnsi( "ATENÇÃO" ) )
			BREAK
		EndIF
	
		lbtdnGR07 := IsInCallStack("btdnGR07")

		IF ( Type("__cINTERNET" ) == "U" )
			_SetNamedPrvt( "__cINTERNET" , NIL  , "u_btdnGR07" )
		EndIF
		cLInternet	:= __cINTERNET

		IF .NOT.( Type( "aPVGper040" ) == "A" )
			PVGper040((__cINTERNET=="AUTOMATICO"))
		EndIF	

		IF .NOT.( Type( "aPVGper040" ) == "A" )
			APMsgAlert( OemToAnsi( "Ocorreram Problemas durante a Configuração de Impressão. Contate o Administrador do Sistema" ) , OemToAnsi( "ATENÇÃO" ) )
			lRet := .F.
			BREAK
		EndIF
		
		IF .NOT.( nOR(1,2,3) == nOr(__nOrdem,6) ) //1:RA_FILIAL+RA_CC+RA_MAT;2:RA_FILIAL+RA_MAT;3:RA_FILIAL+RA_NOME
			APMsgAlert( OemToAnsi( "Ordem de Impressão Inválida. Selecione por: C.Custo Cadastro; Matrícula ; ou Nome" ) , OemToAnsi( "ATENÇÃO" ) )
			lRet := .F.
			BREAK
		EndIF

		IF .NOT.( __aReturn[5] == 2 ) //Via SPOOL
			APMsgAlert( OemToAnsi( "Tipo de Impressão não Permitida. Selecione Tipo Impressão: Via Spool" ) , OemToAnsi( "ATENÇÃO" ) )
			lRet := .F.
			BREAK
		EndIF

    	IF .NOT.( "PDFCREATOR" $ Upper(__cPrtSelected) ) //Verifica a Impressora Selecionada
			APMsgAlert( OemToAnsi( "Impressora INVÁLIDA. Em Opções selecione: PDFCreator" ) , OemToAnsi( "ATENÇÃO" ) )
			lRet := .F.
			BREAK
    	EndIF
    	
    	lServer := ( __nAmbiente == AMB_SERVER )
   		IF ( lServer ) //Verifica se a impressao sera no server
			APMsgAlert( OemToAnsi( "Impressão no servidor não permitida. Selecione a impressão no Cliente" ) , OemToAnsi( "ATENÇÃO" ) )
			lRet := .F.
			BREAK
    	EndIF
   
		IF .NOT.( lbtdnGR07 )
	    
			cTitulo		:= Capital(Titulo)
			bProcessa	:= { |lEnd| btdnGR07(@lEnd,@lProcessa,@cTitulo) }
			lProcessa	:= IsInCallStack("PROCESSA")
			
			__FechaRel()
	
			IF .NOT.( lProcessa )
				lProcessa := .T.
				Processa(bProcessa,cTitulo)
			Else
				Eval(bProcessa,.F.)
			EndIF	
			
			__cINTERNET	:= cLInternet
		
			lRet := .F.
			
			BREAK
					
		EndIF

		lRet		:= .T.

	END SEQUENCE	

Return( lRet ) //Saida em GPER040

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: btdnGR07()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Processa a Geracao e envio dos arquivos
*/ 
Static Function btdnGR07(lEnd,lProcessa,cTitulo)
	
	Local aArea			:= GetArea()
	Local aPDFFile		:= Array(1)
	Local aPDFFiles		:= Array(0)
	
	Local cLInternet	:= __cINTERNET
	
	Local cAlias
	Local cEmail
	
	Local cSRVPath
	Local cCLIPath
	
	Local cPDFFile
	Local cPDFPath
	
	Local cAnoMesRef	:= (SubStr(__cMesAnoRef,-4)+SubStr(__cMesAnoRef,1,2))
	
	Local lServer		:= ( __nAmbiente == AMB_SERVER )
	Local nPrtIn		:= IF(lServer,PRT_SERVER,PRT_CLIENT)
	
	Local lMailOK		:= .T.
	Local lContinue		:= .F.
	Local lSendMail		:= .F.
	Local lRptStatus	:= .NOT.( IsInCallStack("RptStatus") )
	
	Local nID
	Local nIDs
	
	Local nPDF
	Local nPDFs

	Local nPVar
	Local nPVars
	
	Local cVar
	Local cTipo
	Local xValue
	
	Local cSpace30		:= Space(30)
	
	Local cMesArqRef
	
	Local aOrdBag
	
	Local cArqMov
	Local cAliasMov
	Local cMesArqRef

	Local dChkDtRef
	
	Local lArqMov

	Local bGR040Imp 	:= {|lEnd|GR040Imp(@lEnd,__wnRel,__cString,__cMesAnoRef,__nTpContr,.F.)}

	Local bException	:= { |e| oException := e , BREAK(e) }
	Local bErrorBlock

	Local oException
	
	bErrorBlock	:= ErrorBlock( bException )
	BEGIN SEQUENCE

		DEFAULT lEnd	:= .F.
		IF .NOT.( Type("lAbortPrint") == "L" )
			Private lAbortPrint	:= .F.
		EndIF
		
		cSRVPath		:= "\PDFSpool\"
		MakeDir(cSRVPath)
		
		IF ( lServer )
			cPDFPath	:= cSRVPath
		Else	
			SplitPath(GetTempPath(),@cCLIPath)
			IF (SubStr(cCLIPath,-1)=="\")
				cCLIPath += SubStr(cSRVPath,2)
			Else
				cCLIPath += cSRVPath
			EndIF
			MakeDir(cCLIPath)
			cPDFPath	:= cCLIPath
		EndIF
		
		IF ( __nRelat == 4 )
			cMesArqRef := "13"+SubStr(__cMesAnoRef,-4)
		Else
			cMesArqRef := __cMesAnoRef
		EndIF
	
		IF .NOT.( __nRelat == 5 )
			aOrdBag		:= Array(0)
			cArqMov		:= ""
			cAliasMov	:= ""
			dChkDtRef   := CtoD("01/"+SubStr(__cMesAnoRef,1,2)+"/"+SubStr(__cMesAnoRef,-4),"DDMMYY")
			lArqMov		:= OpenSrc(@cMesArqRef,@cAliasMov,@aOrdBag,@cArqMov,@dChkDtRef,.F.)
			IF .NOT.( lArqMov )
				UserException("No Table/View Data")
			EndIF
			IF Empty( cArqMov )
				IF ( __nRelat == 4 )
					cArqMov	:= RetSQLName("SRI")
				Else
					cArqMov := RetSQLName("SRC")
				EndIF
			Else
				fFimArqMov(@cAliasMov,@aOrdBag,@cArqMov)	
			EndIF
		Else
			cArqMov := RetSQLName("RHH")
		EndIF
	
		MsAguarde( {|| cAlias := QueryView(@cArqMov,@cAnoMesRef,@__Semana) } , "Obtendo Dados no SGBD" , "Aguarde..." )
		
		IF ( Empty( cAlias ) .or. ( Select( cAlias ) == 0 ) )
			UserException("No Table/View Data")
		EndIF

		IF ( __nTamanho == "P" )
			cTipo := "080"
		ElseIF ( __nTamanho == "G" )
			cTipo := "220"
		Else
			cTipo := "132"
		EndIF

		cTipo	+= IF(__aReturn[4]==1,"P","L")

		lServer	:= ( __nAmbiente == AMB_SERVER )

	    IF ( lProcessa )
	    	ProcRegua(0)
	    EndIF	
   
	    While (cAlias)->( .NOT.( Eof() ) )
		
			__cFilDe   	:= (cAlias)->RA_FILIAL
			__cFilAte  	:= __cFilDe
			__cCcDe    	:= (cAlias)->RA_CC
			__cCcAte   	:= __cCcDe
			__cMatDe   	:= (cAlias)->RA_MAT
			__cMatAte  	:= __cMatDe
			__cNomDe   	:= AllTrim((cAlias)->RA_NOME)
			__cNomAte  	:= __cNomDe
			__nTpContr 	:= (cAlias)->( Val( RA_TPCONTR ) )
			
			cEmail		:= AllTrim( (cAlias)->RA_EMAIL )
	
			IF ( lProcessa )
				IncProc("["+__cFilDe+"]["+__cMatDe+"]["+Lower(__cNomDe)+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF
			EndIF	
	 
			__cIdPrnRel := __Soma1( __cIdPrnRel )
	
			__cPDFFile  := cEmpAnt
			__cPDFFile  += "-"
			__cPDFFile  += __cFilDe
			__cPDFFile  += "-"
			__cPDFFile  += AllTrim(__cCcDe)
			__cPDFFile  += "-"
			__cPDFFile  += __cMatDe
			__cPDFFile  += "-"
			__cPDFFile  += StrTran(__cNomDe," ","-")
			__cPDFFile  += "-"
			__cPDFFile  += "ccheque"
			__cPDFFile  += "-"			
			__cPDFFile  += cAnoMesRef
			__cPDFFile  += "-"
			__cPDFFile  += __cIdPrnRel
			
			__cPDFFile	:= Lower(__cPDFFile)
	
			lLockByName	:= LockByName( __cPDFFile , .T. )
			
			aAdd( __aIdPrnRel , Array(ELEM_PRN) )
			
			nID := Len( __aIdPrnRel )
			
			__aIdPrnRel[nID][PRN_ID]   			:= __cIdPrnRel
			__aIdPrnRel[nID][PRN_NAME]			:= __cPDFFile
			__aIdPrnRel[nID][PRN_FNAME]			:= 0
			__aIdPrnRel[nID][PRN_CONTINUE]		:= .F.
			__aIdPrnRel[nID][PRN_MAIL]			:= cEmail
			__aIdPrnRel[nID][PRN_SENTMAIL]		:= .F.
			__aIdPrnRel[nID][PRN_LOCKBYNAME]	:= lLockByName
	
			IF ( lLockByName )
					
				__lGP040DET	:= .F. 
				__lGPROXIMO := .F.
					
				__mv_par04 := __cFilDe
				__mv_par05 := __cFilAte
				__mv_par06 := __cCcDe
				__mv_par07 := __cCcAte
				__mv_par08 := __cMatDe
				__mv_par09 := __cMatAte
				__mv_par10 := __cNomDe
				__mv_par11 := __cNomAte
				__mv_par12 := __cSit
				__mv_par13 := __cCat
				
				nPVars := Len( aPVGper040 )
				For nPVar := 1 To nPVars
					cVar	:= "__"+aPVGper040[nPVar][1]
					xValue	:= aPVGper040[nPVar][1]
					&xValue	:= &cVar
				Next nPVar
   
   				PrinterDisk(.F.)
				PrinterWin(.T.)
				PreparePrint(.T.,__cPrtSelected,.F.,__cPDFFile,.F.,1)
				InitPrint(@nPrtIn,@cSpace30,@cTipo,.F.,@__cPDFFile)

				IF ( lRptStatus )
					RptStatus(bGR040Imp,cTitulo)
				Else
					Eval(bGR040Imp)
				EndIF
		
				__FechaRel()
		
				lContinue						:= ( __lGP040DET .or. __lGPROXIMO )
				__aIdPrnRel[nID][PRN_CONTINUE]	:= lContinue
				
				IF .NOT.( lContinue )
					cPDFFile	:= ( cPDFPath+__cPDFFile+".pdf" )
					IF File( cPDFFile )
						fErase( cPDFFile )
					EndIF
				EndIF
					
			EndIF
			
			(cAlias)->( dbSkip() )
	
		End While
		
		(cAlias)->( dbCloseArea() ) 
		
		Sleep( N_SLEEP )

		IF .NOT.( __lIsBlind )
			lSendMail := MsgYesNo( OemToAnsi( "Geração Finalizada. Deseja enviar os arquivos por e-mail?" ) , OemToAnsi( "ATENÇÃO" ) )
			IF .NOT.( lSendMail )
				BREAK
			EndIF
		EndIF
		
		Sleep( N_SLEEP )

		aDir(cPDFPath+"*.pdf",@aPDFFiles)
		aPDFFiles	:= Directory(cPDFPath+"*.pdf")
		nPDFs		:= Len( aPDFFiles )

		nIDs		:= Len( __aIdPrnRel )

		IF ( lProcessa )
	    	ProcRegua(nPDFs)
	    EndIF

		For nPDF := 1 To nPDFs
			cPDFFile				:= Lower( aPDFFiles[nPDF][F_NAME] )
			IF ( lProcessa )
				IncProc("Verificando Arquivo : ["+cPDFFile+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF				
			EndIF	
			aPDFFiles[nPDF][F_NAME]	:= ( cPDFPath + cPDFFile )
		Next nPDF

		IF ( lProcessa )
	    	ProcRegua(nIDs)
	    EndIF

		For nID := 1 TO nIDs
			__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
			IF ( lProcessa )
				IncProc("Verificando Arquivo : ["+__cPDFFile+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF				
			EndIF	
			For nPDF := 1 To nPDFs
				cPDFFile	:= aPDFFiles[nPDF][F_NAME]
				IF ( __cPDFFile $ cPDFFile )
					__aIdPrnRel[nID][PRN_FNAME]			:= nPDF
					IF ( __aIdPrnRel[nID][PRN_CONTINUE] )
						__aIdPrnRel[nID][PRN_CONTINUE]	:= ( aPDFFiles[__aIdPrnRel[nID][PRN_FNAME]][F_SIZE] > 0 )
					EndIF
					EXIT
				EndIF
			Next nPDF
		Next nID	
		
		IF ( lProcessa )
	    	ProcRegua(0)
	    EndIF
		
		For nID := 1 TO nIDs
			__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
			IF ( lProcessa )
				IncProc("Processando : ["+__cPDFFile+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF
			EndIF	
			IF ( __aIdPrnRel[nID][PRN_FNAME] == 0 )
				Loop
			EndIF
			IF .NOT.( __aIdPrnRel[nID][PRN_CONTINUE] )
				Loop
			EndIF
			cEmail	 := __aIdPrnRel[nID][PRN_MAIL]
			IF Empty( cEmail )
				Loop
			EndIF
			IncProc("Enviando : ["+cEmail+"]")
			cPDFFile 	:= aPDFFiles[__aIdPrnRel[nID][PRN_FNAME]][F_NAME]
			IF File( cPDFFile )
				IF .NOT.( lServer )
					lMailOK			:= __CopyFile(cPDFFile,StrTran(cPDFFile,cPDFPath,cSRVPath))
					IF ( lMailOK )
						cPDFFile	:= StrTran(cPDFFile,cPDFPath,cSRVPath)
					EndIF
				EndIF
				lMailOK		:= File( cPDFFile )
				IF ( lMailOK )
					aPDFFile[1]	:= cPDFFile
					/*
						Parametros (SX6) Utilizados pela Rotina de envio de e-mail
						
						MV_SUBJLE
						MV_RELFROM	//E-mail utilizado no campo FROM no envio de relatorios por e-mail
						MV_RELSERV	//Nome do Servidor de Envio de E-mail utilizado nos relatorios
						MV_RELAUTH	//Servidor de EMAIL necessita de Autenticacao? (.T.)
						MV_RELACNT	//Conta a ser utilizada no envio de E-Mail para os relatorios
						MV_RELPSW	//Senha para autenticacäo no servidor de e-mail
						MV_RELTIME	//Timeout no Envio de EMAIL.
						MV_MAILADT	//Conta oculta de auditoria utilizada no envio de e-mail para os relatorios
					*/
					__cINTERNET := "AUTOMATICO"
						lMailOK	:= SetMail(@cEmail,@Titulo,@Titulo,@aPDFFile,.F.,.F.,.F.,.F.,"")
					__cINTERNET := cLInternet
					Sleep( N_SLEEP )
				EndIF
				__aIdPrnRel[nID][PRN_SENTMAIL] := lMailOK
				IF File( cPDFFile )
					fErase( cPDFFile )
				EndIF
			EndIF
		Next nID

		IF ( lProcessa )
	    	ProcRegua(nIDs)
	    EndIF
		
		For nID := 1 TO nIDs
			__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
			IF ( lProcessa )
				IncProc("Excluindo Arquivo : ["+__cPDFFile+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF
			EndIF	
			IF ( __aIdPrnRel[nID][PRN_FNAME] == 0 )
				Loop
			EndIF
			IF .NOT.( __aIdPrnRel[nID][PRN_LOCKBYNAME] )
				Loop	
			EndIF
			__cPDFFile	:= __aIdPrnRel[nID][PRN_NAME]
			cPDFFil		:= aPDFFiles[__aIdPrnRel[nID][PRN_FNAME]][F_NAME]
			IF File( cPDFFile )
				fErase( cPDFFile )
			EndIF	
			UnLockByName( __cPDFFile , .T. )
		Next nID

		IF ( lProcessa )
	    	ProcRegua(nIDs)
	    EndIF
		
		For nID := 1 TO nIDs
			IF ( lProcessa )
				IncProc("Liberando Registros : ["+__cPDFFile+"]")
				IF ( ( lEnd ) .or. ( lAbortPrint ) )
					BREAK
				EndIF
			EndIF	
			IF ( __aIdPrnRel[nID][PRN_LOCKBYNAME] )
				__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
				UnLockByName( __cPDFFile , .T. )
			EndIF
		Next nID

		IF .NOT.( lServer )
	   
			IF ( lProcessa )
	    		ProcRegua(nPDFs)
	    	EndIF
			
			For nPDF := 1 To nPDFs
				cPDFFile := aPDFFiles[nPDF][F_NAME]
				IF ( lProcessa )
					IncProc("Excluindo Arquivo : ["+StrTran(__cPDFFile," ","")+"]")
					IF ( ( lEnd ) .or. ( lAbortPrint ) )
						BREAK
					EndIF
				EndIF	
				IF File( cPDFFile )
					fErase( cPDFFile )
				EndIF	
			Next nPDF
		
		EndIF
	
	RECOVER
	
		__FechaRel()
		IF ( Select( cAlias ) > 0 )
			(cAlias)->( dbCloseArea() )
		EndIF
		
  		IF ( Type("__aIdPrnRel") == "A" )
  			nIDs := Len( __aIdPrnRel )
			IF ( lProcessa )
		    	ProcRegua(nIDs)
		    EndIF
  			For nID := 1 TO nIDs
				__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
				IF ( lProcessa )
					IncProc("Liberando Registros : ["+__cPDFFile+"]")
					IF ( ( lEnd ) .or. ( lAbortPrint ) )
						BREAK
					EndIF
				EndIF
				IF ( __aIdPrnRel[nID][PRN_LOCKBYNAME] )
					__cPDFFile := __aIdPrnRel[nID][PRN_NAME]
					UnLockByName( __cPDFFile , .T. )
				EndIF
			Next nID
		EndIF	
		
	END SEQUENCE
	ErrorBlock( bErrorBlock )
	
	RestArea( aArea )

Return( NIL )

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: QueryView()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Retorna View para o Processo
*/ 
Static Function QueryView(cArqMov,cAnoMesRef,cSemana)

	Local aSitFolh		:= Array(0)
	Local aCatFunc		:= Array(0)
	    
	Local cSitFolh		:= ""
	Local cCatFunc		:= ""
	Local cQExists		:= ""
	
	Local cAlias		:= GetNextAlias()

	Local nBL
	Local nEL

	nEL := Len(__cSit)
	For nBL := 1 To nEL
		aAdd(aSitFolh,SubStr(__cSit,nBL,1))
	Next nBL
	
	nEL := Len(aSitFolh)
	For nBL := 1 To nEL 
		cSitFolh += "'"+aSitFolh[nBL]+"'"
		IF ( nBL < nEL ) 
			cSitFolh += ","
		EndIF	
	Next nBL
	IF Empty( cSitFolh )
		cSitFolh := "' '"
	EndIF
	cSitFolh := "%("+cSitFolh+")%"	

	nEL := Len(__cCat)
	For nBL := 1 To nEL
		aAdd(aCatFunc,SubStr(__cCat,nBL,1))
	Next nBL
		
	nEL := Len(aCatFunc)
	For nBL := 1 To nEL 
		cCatFunc += "'"+aCatFunc[nBL]+"'"
		IF ( nBL < nEL ) 
			cCatFunc += ","
		EndIF
	Next nBL
	IF Empty( cCatFunc )
		cCatFunc := "' '"
	EndIF
	cCatFunc := "%("+cCatFunc+")%"
	
	DO CASE
		CASE ( "RC"  $ cArqMov )
			cQExists := "AND EXISTS "
			cQExists += "("
			cQExists += " SELECT DISTINCT 1"
			cQExists += "  FROM "+cArqMov+" TMOV"
			cQExists += " WHERE TMOV.D_E_L_E_T_=' '"
			cQExists += "   AND TMOV.RC_FILIAL=SRA.RA_FILIAL"
			cQExists += "   AND TMOV.RC_MAT=SRA.RA_MAT"
			cQExists += "   AND TMOV.RC_SEMANA='"+cSemana+"'"
			cQExists += ")"
		CASE ( "RI"  $ cArqMov )
			cQExists := "AND EXISTS "
			cQExists += "("
			cQExists += " SELECT DISTINCT 1"
			cQExists += "  FROM "+cArqMov+" TMOV"
			cQExists += " WHERE TMOV.D_E_L_E_T_=' '"
			cQExists += "   AND TMOV.RI_FILIAL=SRA.RA_FILIAL"
			cQExists += "   AND TMOV.RI_MAT=SRA.RA_MA"
			cQExists += ")"
		CASE ( "RHH" $ cArqMov )
			cQExists := "AND EXISTS "
			cQExists += "("
			cQExists += " SELECT DISTINCT 1"
			cQExists += "  FROM "+cArqMov+" TMOV"
			cQExists += " WHERE TMOV.D_E_L_E_T_=' '"
			cQExists += "   AND TMOV.RHH_FILIAL=SRA.RA_FILIAL"
			cQExists += "   AND TMOV.RHH_MAT=SRA.RA_MAT"
			cQExists += "   AND TMOV.RHH_MESANO='"+cAnoMesRef+"'"
			cQExists += ")"
	END CASE
	
	cQExists := "%"+cQExists+"%"
	
    BEGINSQL ALIAS cAlias
	    %noParser%
	    SELECT
			 SRA.RA_FILIAL
			,SRA.RA_MAT
			,SRA.RA_NOME
			,SRA.RA_CC
			,SRA.RA_SITFOLH
			,SRA.RA_CATFUNC
			,SRA.RA_TPCONTR
			,SRA.RA_EMAIL
		FROM 
			%table:SRA% SRA 
		WHERE SRA.%notDel%
		  %exp:cQExists%
		  AND SRA.RA_FILIAL BETWEEN %exp:__cFilDe% AND %exp:__cFilAte%
		  AND SRA.RA_MAT BETWEEN %exp:__cMatDe% AND %exp:__cMatAte%
		  AND SRA.RA_NOME BETWEEN %exp:__cNomDe% AND %exp:__cNomAte%
		  AND SRA.RA_CC	BETWEEN %exp:__cCCDe% AND %exp:__cCCAte%
		  AND SRA.RA_SITFOLH IN %exp:cSitFolh%
		  AND SRA.RA_CATFUNC IN %exp:cCatFunc%
	ENDSQL

Return(cAlias)

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: PVGper040()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: GetSet de Variaveis
*/ 
Static Function PVGper040(lIsBlind)

	Local nPVar
	Local nPVars

	Local cVar
	Local xValue
	
	Local aStackParameters

	BEGIN SEQUENCE

		_SetNamedPrvt("__cString",ReadStackParameters("GPER040",Upper("cString"),NIL,NIL,@aStackParameters),"u_btdnGR07")
		_SetNamedPrvt("__cMesAnoRef",ReadStackParameters("GPER040",Upper("cMesAnoRef"),NIL,NIL,@aStackParameters),"u_btdnGR07")
		_SetNamedPrvt("__nTpContr",ReadStackParameters("GPER040",Upper("nTpContr"),NIL,NIL,@aStackParameters),"u_btdnGR07")

		aSize( aStackParameters , 0 )
		aStackParameters := NIL

		_SetNamedPrvt( "aPVGper040"     , Array(0)  , "u_btdnGR07" )
		
		_SetNamedPrvt( "__cIdPrnRel"    , "0000"  	, "u_btdnGR07" )
		_SetNamedPrvt( "__aIdPrnRel"    , Array(0)	, "u_btdnGR07" )
		_SetNamedPrvt( "__cPrtSelected" , GetPrtSelected() , "u_btdnGR07" )
	
		// Pega o ambiente para impressao do usuario (SERVER ou CLIENT)
		_SetNamedPrvt( "__nAmbiente" , SetPrintEnv() , "u_btdnGR07" )
		        		
		_SetNamedPrvt( "__lGP040DET" , .F. , "u_btdnGR07" )
		_SetNamedPrvt( "__lGPROXIMO" , .F. , "u_btdnGR07" )
		
		_SetNamedPrvt( "__cPDFFile" , "" , "u_btdnGR07" )
		_SetNamedPrvt( "__lIsBlind" , lIsBlind , "u_btdnGR07" )
		
		aAdd( aPVGper040 , { "aReturn"  , {"",1,"",2,2,1,"",1} } )
		aAdd( aPVGper040 , { "wnRel"    , "GPER040" } )
		aAdd( aPVGper040 , { "Titulo"   , "GPER040" } )
		aAdd( aPVGper040 , { "cPerg"    , "GPR040" } ) 
		
		aAdd( aPVGper040 , { "nOrdem"   , 1 } )
		aAdd( aPVGper040 , { "dDataRef" , IF( ( Type("dDataBase")=="D") , dDataBase , MsDate() ) } )
		aAdd( aPVGper040 , { "dDtaComp" , IF( ( Type("dDataBase")=="D") , dDataBase , MsDate() ) } )
		aAdd( aPVGper040 , { "nRelat"   , 2 } )
		aAdd( aPVGper040 , { "Semana"   , Space(GetSx3Cache("RC_SEMANA","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cFilDe"   , Space(GetSx3Cache("RA_FILIAL","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cFilAte"  , Replicate("Z",GetSx3Cache("RA_FILIAL","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cCcDe"    , Space(GetSx3Cache("RA_CC","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cCcAte"   , Replicate("Z",GetSx3Cache("RA_CC","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cMatDe"   , Space(GetSx3Cache("RA_MAT","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cMatAte"  , Replicate("Z",GetSx3Cache("RA_MAT","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cNomDe"   , Space(GetSx3Cache("RA_NOME","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cNomAte"  , Space(GetSx3Cache("RA_NOME","X3_TAMANHO")) } )
		aAdd( aPVGper040 , { "cSit"     , "A" } )
		aAdd( aPVGper040 , { "cCat"     , "M" } )
		aAdd( aPVGper040 , { "lSalta"   , .F. } )
		aAdd( aPVGper040 , { "cSinAna"  , "A" } )
		aAdd( aPVGper040 , { "lImpFil"  , .F. } )
		aAdd( aPVGper040 , { "lImpEmp"  , .F. } )
		aAdd( aPVGper040 , { "lImpNiv"  , .F. } )
		aAdd( aPVGper040 , { "lUnicNV"  , .F. } )
		aAdd( aPVGper040 , { "lImpTot"  , .F. } )
		aAdd( aPVGper040 , { "cTipCC"   , 1 } )
		aAdd( aPVGper040 , { "cRefOco"  , 1 } )
		aAdd( aPVGper040 , { "nTpContr" , 1 } )
		aAdd( aPVGper040 , { "nTamanho" , "M" } )

		aAdd( aPVGper040 , { "mv_par01"   , dDataRef } )
		aAdd( aPVGper040 , { "mv_par02"   , nRelat   } )
		aAdd( aPVGper040 , { "mv_par03"   , Semana   } )
		aAdd( aPVGper040 , { "mv_par04"   , cFilDe   } )
		aAdd( aPVGper040 , { "mv_par05"   , cFilAte  } )
		aAdd( aPVGper040 , { "mv_par06"   , cCcDe    } )
		aAdd( aPVGper040 , { "mv_par07"   , cCcAte   } )
		aAdd( aPVGper040 , { "mv_par08"   , cMatDe   } )
		aAdd( aPVGper040 , { "mv_par09"   , cMatAte  } )
		aAdd( aPVGper040 , { "mv_par10"   , cNomDe   } )
		aAdd( aPVGper040 , { "mv_par11"   , cNomAte  } )
		aAdd( aPVGper040 , { "mv_par12"   , cSit     } )
		aAdd( aPVGper040 , { "mv_par13"   , cCat     } )
		aAdd( aPVGper040 , { "mv_par14"   , lSalta   } )
		aAdd( aPVGper040 , { "mv_par15"   , cSinAna  } )
		aAdd( aPVGper040 , { "mv_par16"   , 2        } )
		aAdd( aPVGper040 , { "mv_par17"   , 2        } )
		aAdd( aPVGper040 , { "mv_par18"   , 2        } )
		aAdd( aPVGper040 , { "mv_par19"   , 2        } )
		aAdd( aPVGper040 , { "mv_par20"   , 2        } )
		aAdd( aPVGper040 , { "mv_par21"   , cTipCC   } )
		aAdd( aPVGper040 , { "mv_par22"   , cRefOco  } )
		aAdd( aPVGper040 , { "mv_par23"   , nTpContr } )
		
		nPVars := Len( aPVGper040 )
		For nPVar := 1 To nPVars
			cVar	:= aPVGper040[nPVar][1]
			IF ( Type( cVar ) == "U" )
				xValue	:= aPVGper040[nPVar][2]
				_SetNamedPrvt( cVar  , xValue , "u_btdnGR07" )
			Else
				cVar	:= aPVGper040[nPVar][1]
				xValue	:= &cVar
				aPVGper040[nPVar][2] := xValue
			EndIF
			_SetNamedPrvt( "__"+cVar , xValue , "u_btdnGR07" )
		Next nPVar
		
		IF ( cSinAna == "S" )
			__cSinAna := ( cSinAna := "A" )
			__mv_par15 := ( mv_par15 := cSinAna )
		EndIF
		IF ( lImpFil )
			__lImpFil := ( lImpFil := .F. )
			__mv_par16 := ( mv_par16 := 2 )
		EndIF
		IF ( lImpEmp )
			__lImpEmp := ( lImpEmp := .F. )
			__mv_par17 := ( mv_par17 := 2 )	
		EndIF
		IF ( lImpNiv )
			__lImpNiv := ( lImpNiv := .F. )
			__mv_par18 := ( mv_par18 := 2 )
		EndIF
		IF ( lUnicNV )
			__lUnicNV  := ( lUnicNV := .F. )
			__mv_par20 := ( mv_par20 := 2 )
		EndIF
		IF ( lImpTot )
			__lImpTot := ( lImpTot := .F. )
			__mv_par20 := ( mv_par20 := 2 )
		EndIF
		
		IF Empty( __cMesAnoRef )
			__cMesAnoRef := Month2Str(dDataRef)+Year2Str(dDataRef)
		EndIF	
		
		__wnRel := ( wnRel := "btdnGR07" )
		
	END SEQUENCE

Return( NIL )

/*
	Programa	: u_btdnGR07.PRW
	Funcao		: __FechaRel()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Libera o Spool de Impressao
*/ 
Static Function __FechaRel()
	Local cFn	:= "FechaRel"
	Local lFn	:= FindFunction(cFn)
	IF ( lFn )
		&cFn.(,)
	EndIF	
	MS_Flush()
Return( Sleep( N_SLEEP ) )

#DEFINE STACK_INDEX_PARAMETER     1
#DEFINE STACK_INDEX_SCOPE         2
#DEFINE STACK_INDEX_TYPE          3
#DEFINE STACK_INDEX_VALUE         4

#DEFINE STACK_INDEX_ELEMENTS      4 

/*/
	Funcao  : ReadStackParameters
	Autor   : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data    : 19/01/2011
	Uso     : Retornar informacoes de Variaveis da Pilha de Chamadas
    Sintaxe : ReadStackParameters( cStack , cParameter , cScope , cModule , aStackParameters )
/*/
Static Function ReadStackParameters( cStack , cParameter , cScope , cModule , aStackParameters )

	Local bAscan

	Local lScope
	Local lModule

	Local nStack
	Local nParameter
	
	Local uValue

	BEGIN SEQUENCE

		DEFAULT aStackParameters := GetStackParameters()
		
		IF Empty( aStackParameters )
			BREAK
		EndIF
		
		lModule		:= !Empty( cModule )

		IF ( lModule )
			bAscan	:= { |x| ( x[ 1 ] == cStack ) .and. ( cModule $ x[ 2 ] ) }
		Else
			bAscan	:= { |x| ( x[ 1 ] == cStack ) }
		EndIF	
		
		nStack	:= aScan( aStackParameters , bAscan )
		IF ( nStack == 0 )
			BREAK
		EndIF

		lScope		:= !Empty( cScope )

		IF ( lScope )
			bAscan	:= 	{ |x| ( x[ STACK_INDEX_PARAMETER ] == cParameter ) .and. ( x[ STACK_INDEX_SCOPE ] == cScope ) }
		Else
			bAscan	:= 	{ |x| ( x[ STACK_INDEX_PARAMETER ] == cParameter ) }
		EndIF

		nParameter	:= aScan( aStackParameters[ nStack ][ 3 ] , bAscan )
		IF ( nParameter == 0 )
			BREAK
		EndIF

		uValue	:= aStackParameters[ nStack ][ 3 ][ nParameter ][ STACK_INDEX_VALUE ]

	END SEQUENCE

Return( uValue )

/*/
	Funcao  : GetStackParameters
	Autor   : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data    : 19/01/2011
	Uso     : Obtem Array com a Pilha de Chamadas que sera usado pela ReadStackParameters
    Sintaxe : GetStackParameters()
/*/
Static Function GetStackParameters()

	Local aStackEnv
	Local aStackParameters	:= {}
	
	Local cStack
	Local cModule
	Local cStackEnv
	
	Local lIscBlock
	
	Local nStack
	Local nIndexEnv
	Local nStackEnv

	Local bException	:= { |e| oException := e , BREAK(e) }
	Local bErrorBlock

	Local oException
	
	bErrorBlock	:= ErrorBlock( bException )
	BEGIN SEQUENCE

		UserException( "IGetStackParameters" )

	RECOVER

	    cStackEnv	:= oException:ErrorEnv
	    IF !(;
	    		( Chr( 10 ) $ cStackEnv );
	    		.and.;
	    		( Chr( 13 ) $ cStackEnv );
	    	)	
		    cStackEnv	:= StrTran( cStackEnv , "  " , CRLF )
		    cStackEnv	:= StrTran( cStackEnv , "STACK " , CRLF + "STACK " )
	    EndIF
	    aStackEnv	:= StrTokArr( cStackEnv , CRLF )

	    cStackEnv	:= NIL

	    nIndexEnv	:= 0
	    nStackEnv	:= Len( aStackEnv )

	    While ( ( ++nIndexEnv ) <= nStackEnv )

	    	IF ( "Public" $ aStackEnv[ nIndexEnv ] )

	    		IF ( "Publicas" $ aStackEnv[ nIndexEnv ] )
	    			Loop
	    		EndIF

	    		nStack := aScan( aStackParameters , { |x| ( x[1] == "PUBLIC" ) } ) 
	    	
	    		IF ( nStack == 0 )
	    			aAdd( aStackParameters , { "PUBLIC" , "" , Array(0) } )
	    			nStack := Len( aStackParameters )
	    		EndIF

	    		cStackEnv	:= aStackEnv[ nIndexEnv ] 
	    		AddStackParameters( @aStackParameters , @nStack ,  @cStackEnv  )

            ElseIF ( "STACK" == SubStr( aStackEnv[ nIndexEnv ] , 1 , 5 ) )
            	
            	cStackEnv	:= AllTrim( StrTran( aStackEnv[ nIndexEnv ] , "STACK" , "" ) )
            	lIscBlock 	:= ( ( "{" $ cStackEnv ) .and. ( "}" $ cStackEnv ) .and. ( "|"  $ cStackEnv ) )
            	IF ( lIscBlock )
            		cStack	:= SubStr( cStackEnv , AT( "{" , cStackEnv ) , RAT( "}" , cStackEnv ) )
            	Else
            		cStack	:= SubStr( cStackEnv , 1 , AT( "(" , cStackEnv ) - 1 )
            	EndIF	
            	cModule		:= StrTran( cStackEnv , cStack , "" )

	    		nStack 		:= aScan( aStackParameters , { |x| ( x[1] == cStack ) } ) 

	    		IF ( nStack == 0 )
	    			aAdd( aStackParameters , { cStack , cModule , Array(0) } )
	    			nStack := Len( aStackParameters )
	    		EndIF

            	While (;
            				( ( ++nIndexEnv ) <= nStackEnv );
            				.and.;
            				!( "STACK" == SubStr( aStackEnv[ nIndexEnv ] , 1 , 5 ) );
            				.and.;
            				!( "FILES" == Upper( SubStr( aStackEnv[ nIndexEnv ] , 1 , 5 ) ) );
            			) 

	    			cStackEnv	:= aStackEnv[ nIndexEnv ] 
	    			AddStackParameters( @aStackParameters , @nStack ,  @cStackEnv  )

            	End While

            	--nIndexEnv

			ElseIF ( "FILES" == Upper( SubStr( aStackEnv[ nIndexEnv ] , 1 , 5 ) ) )
			
				Exit

            EndIF
	    		
	    End While

	END SEQUENCE
	ErrorBlock( bErrorBlock )

Return( aStackParameters )

/*/
	Funcao  : AddStackParameters
	Autor   : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data    : 19/01/2011
	Uso     : Carregar os Valores da Pilha de Chamadas
	Sintaxe : AddStackParameters( aStackParameters , nStack ,  cStackEnv  )
/*/
Static Function AddStackParameters( aStackParameters , nStack ,  cStackEnv  )

	Local aScope
	Local aTokens		:= StrTokArr( cStackEnv , ":" )
	Local aDateFormat
	
	Local cType
	Local cScope
	Local cParameter
	Local cDateFormat	:= Set( 4 )

	Local dDate

    Local nToken
    Local nTokens		:= Len( aTokens )
    Local nParameter
    Local nDateFormat

	Local uValue

	Local bException	:= { |e| oException := e , BREAK(e) }
	Local bErrorBlock

	IF ( nTokens >= 1 )
		aScope	:= StrTokArr( aTokens[ 1 ] , " " )
		IF ( Len( aScope ) >= 1 )
			cScope	:= Upper( AllTrim( aScope[ 1 ] ) )
		Else
			cScope	:= "UNDEFINED"
		EndIF
	Else
		cScope	:= "UNDEFINED"
	EndIF	

	IF ( nTokens >= 2 )
		cStackEnv	:= aTokens[ 2 ]
   		cParameter	:= AllTrim( SubStr( cStackEnv , 1 , AT( "(" , cStackEnv ) - 1 ) )
   		cType		:= SubStr( cStackEnv , AT( "(" , cStackEnv ) + 1 , 1 )
   	Else
   		cParameter	:= "NULL"
   		cType		:= "U"
   	EndIF	

	IF ( nTokens >= 3 )
		uValue		:= aTokens[ 3 ]
		IF ( nTokens > 3 )
			nToken := 3
			While ( ( ++nToken ) <= nTokens )
				uValue += aTokens[ nToken ]
			End While
		EndIF
	Else
		uValue		:= NIL
	EndIF	

	bErrorBlock	:= ErrorBlock( bException )
	BEGIN SEQUENCE

		IF ( cScope $ "PUBLIC/PRIVATE" )

			uValue := &( cParameter )

		Else

			Do Case
				Case ( cType == "C"  )
					//...
				Case ( cType == "N"  )
					uValue := Val( uValue )
				Case ( cType == "D"  )
					dDate := CtoD( uValue )
	                IF Empty( dDate )
						aDateFormat	:= { "yyyy/mm/dd" , "yyyy-mm-dd" , "mm/dd/yyyy" , "mm-dd-yyyy" , "dd/mm/yyyy" , "dd-mm-yyyy" }
						For nDateFormat := 1 To Len( aDateFormat )
							Set( 4 , aDateFormat[ nDateFormat ] )
							dDate := CtoD( uValue )
							IF !Empty( dDate )
								Exit
							EndIF
						Next nDateFormat
					EndIF	
					uValue	:= dDate
				Case ( cType == "L"  )
					uValue := &( uValue )
				Case ( cType == "B"  )
					uValue := &( uValue )
				Case ( cType == "A"  )
					uValue := {}
				Case ( cType $ "U/O" )
					uValue := NIL
			OtherWise
				uValue := NIL	
			End Case 

		EndIF
			
	RECOVER

		Do Case
			Case ( cType == "C"  )
				uValue := ""
			Case ( cType == "N"  )
				uValue := 0
			Case ( cType == "D"  )
				dDate := CtoD( "" )
			Case ( cType == "L"  )
				uValue := .F.
			Case ( cType == "B"  )
				uValue := { || .F. }
			Case ( cType == "A"  )
				uValue := {}
			Case ( cType $ "U/O" )
				uValue := NIL
		OtherWise
			uValue := NIL	
		End Case 	

	END SEQUENCE
	ErrorBlock( bErrorBlock )

	aAdd( aStackParameters[ nStack ][3] , Array( STACK_INDEX_ELEMENTS ) )

	nParameter := Len( aStackParameters[ nStack ][3] )

	aStackParameters[ nStack ][3][ nParameter ][ STACK_INDEX_PARAMETER  ]	:= cParameter
	aStackParameters[ nStack ][3][ nParameter ][ STACK_INDEX_SCOPE		]	:= cScope
	aStackParameters[ nStack ][3][ nParameter ][ STACK_INDEX_TYPE		]	:= cType
	aStackParameters[ nStack ][3][ nParameter ][ STACK_INDEX_VALUE		]	:= uValue

	Set( 4 , cDateFormat )

Return( NIL )