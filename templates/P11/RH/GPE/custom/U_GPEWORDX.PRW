#INCLUDE "MSOLE.CH"
#INCLUDE "SHELL.CH"	
#INCLUDE "RWMAKE.CH" 
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "U_GPEWORDX.CH"

#DEFINE MVPAR25_MAXSIZE 75

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

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: U_GpeWordX()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Integracao com Ms Word
*/                          
User Function GpeWordX(cTitle,lSPlash)

	Local cCampo  		:= ""
	Local oDlg			:= NIL  
	Local cMsgDic		:= ""	//Mensagem para validacao de dicionario de dados
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aGDCoord		:= {}
	
	Private cCadastro := IF(Empty(cTitle),OemToAnsi(STR0001),cTitle)

	fChkUpd( @cMsgDic )
	If !Empty(cMsgDic)
		MsgAlert( cMsgDic ) 
		Return(.F.)
	EndIf
	
	Private	cPerg	:= PadR("U_GPEWORDX",Len(SX1->X1_GRUPO))
	Private aInfo	:= {}
	Private aDepenIR:= {}
	Private aDepenSF:= {}
	Private aPerSRF := {}
	Private nDepen	:= 0
	Private lDepSf	:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
	
	//tratando os espacos do novo tamanho do X1_GRUPO
	cPerg	:= PadR(cPerg,Len(SX1->X1_GRUPO))
	
	Private cNumSeq	:= cEmpAnt+Dtos(dDataBase)+"0000000000"
	
	Pergunte(cPerg,.F.)
	     
	OpenProfile()
	IF ( Select("ProfAlias") > 0 )
		IF ( ProfAlias->( dbSeek(SM0->M0_CODIGO+PadL(CUSERNAME,1)+cPerg) ) )
			cCampo := Upper(SubStr(AllTrim(ProfAlias->P_DEFS),487,MVPAR25_MAXSIZE))
			IF .NOT.( ".DOT" $ cCampo ) .OR. .NOT.( ".DOTX" $ cCampo )
				IF ProfAlias->( RecLock("ProfAlias",.F.))
					ProfAlias->P_DEFS := ""
					ProfAlias->( MsUnLock() )
				EndIF	
			EndIf
		EndIf
	EndIF	
	
	DEFAULT lSPlash := .T.
	IF lSPlash
		aAdvSize		:= MsAdvSize()
		aAdvSize[5]		:=	(aAdvSize[5]/100) * 60	//horizontal
		aAdvSize[6]		:=  (aAdvSize[6]/100) * 40	//Vertical
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
		aGdCoord		:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*20), (((aObjSize[1,4])/100)*59) }	//1,3 Vertical /1,4 Horizontal
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL			
			@ aGdCoord[1],aGdCoord[2] TO aGdCoord[3],aGdCoord[4] PIXEL
			@ aGdCoord[1]+10,aGdCoord[2]+10 SAY OemToAnsi(STR0002) + " " + OemToAnsi(STR0003) PIXEL						 												
		
			@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)-95 BMPBUTTON TYPE 5 ACTION Eval( { || Pergunte(cPerg,.T.) } )	
				
			@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)-60 BUTTON OemToAnsi(STR0004) SIZE 55,11 ACTION Eval( { || (ndepen:= 0,fVarW_Imp() ) }  )      
			@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)+5 BUTTON OemToAnsi(STR0005) SIZE 55,11 ACTION Eval( { ||  Processa({|lEnd| fWord_Imp(@lEnd) , "Processando" } ) } )
			     
			@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)+70 BMPBUTTON TYPE 2 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
	Else
		Pergunte(cPerg,.F.)
		IF IsInCallStack("u_btdnGR08")
			btdnGR08W()	//Tratamento para Folha de Ponto
		EndIF
		IF Pergunte(cPerg,.T.)
			Processa({|lEnd| fWord_Imp(@lEnd) , "Processando" } )
		EndIF
	EndIF
		
Return( .T. )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fWord_Imp
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Integracao com Ms Word
*/                          
Static Function fWord_Imp()

	Local aPDFFile

	Local cDrive
	Local cArquivo
	Local cExtensao
	Local cDiretorio
	Local cArqNome
	Local cWordArq

	Local lRAXMAILFP	:= SRA->( FieldPos("RA_XMAILFP") > 0 )
	Local fhWord		:= NIL
	Local cExclui		:= ""
	Local aFields		:= {}
	Local nX			:= 0
	Local nSvOrdem		:= 0
	Local nSvRecno		:= 0
	Local cAcessaSRA	:= &( " { || " + ChkRH( "GPEWORD" , "SRA" , "2" ) + " } " )
	
	Local cFilDe		:= MV_PAR01
	Local cFilAte		:= MV_PAR02
	Local cCcDe			:= MV_PAR03
	Local cCcAte		:= MV_PAR04
	Local cMatDe		:= MV_PAR05
	Local cMatAte		:= MV_PAR06
	Local cNomeDe		:= MV_PAR07
	Local cNomeAte		:= MV_PAR08
	Local cTnoDe		:= MV_PAR09
	Local cTnoAte		:= MV_PAR10
	Local cFunDe		:= MV_PAR11
	Local cFunAte		:= MV_PAR12
	Local cSindDe		:= MV_PAR13
	Local cSindAte		:= MV_PAR14
	Local dAdmiDe		:= MV_PAR15
	Local cAdmiDe		:= DtoS(dAdmiDe)
	Local dAdmiAte		:= MV_PAR16
	Local cAdmiAte		:= DtoS(dAdmiAte)
	Local cSituacao		:= MV_PAR17
	Local cCategoria	:= MV_PAR18
	Local nCopias		:= Max(MV_PAR23,1)
	Local nOrdem		:= MV_PAR24
	Local cArqWord		:= Lower(AllTrim(MV_PAR25))
	Local cAux			:= ""
	Local cPath 		:= Lower( GetTempPath() )
	Local nAt			:= 0
	Local lDepende		:= (MV_PAR26==1)
	Local nDepende  	:= MV_PAR27
	Local lImpress      := (MV_PAR28==1)
	Local cArqSaida     := Lower(AllTrim(MV_PAR29))
	Local nSRBRecno		:= 0
	Local lContinue
	Local cEmail
	Local aSMail		:= Array(0)
	Local afAtt			:= Array(1)
	Local nID
	Local nIDs
	Local cLInternet	:= __cINTERNET
	Local cMsg
	Local aMsg
	Local cMailTit
	Local cMailBody
	Local cFolhaPonto

	Local cPDF
	Local lPDF			:= MsgYesNo("Enviar os Arquivos como PDF?",OemToAnsi("ATENÇÃO"))
	Local lServer		:= .F.
	Local lBTDNPS1		:= .F.
	Local lCpyS2T		:= .F.
	Local cSrvSaida
	
	Local cWaitRunCmd
	Local nWaitRunRet
	
	Local nField
	Local nFields
	
	Local cPicture
	Local caFields3
	
	Local cSvFilAnt		:= cFilAnt
	Local cFilialAnt	:= "__@@cFilialAnt@@__"

	//?-Checa o SO do Remote (1=Windows, 2=Linux)
	If ( GetRemoteType() == 2 )
		MsgAlert(OemToAnsi(STR0167), OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
		Return(.F.)	
	EndIf

	SplitPath(GetTempPath(),@cDrive)
	cDrive := Lower(cDrive)
	
	nDepen := IF ( !lDepende, 4,nDepende )
	
	IF .NOT.(File(cArqWord))
		ApMsgAlert(OemToAnsi("Arquivo Modelo: "+cArqWord+" Não encontrado."),OemToAnsi("ATENÇÃO"))
		Return(.F.)
	EndIF
	
	IF .NOT.( Type("MV_PAR31")=="N" )
		MV_PAR31	:= 2
	EndIF
	
	Private lFPonto	:= ( MV_PAR31 == 1 )
	
	IF ( lFPonto )
		cFolhaPonto := cEmpAnt+Lower(AllTrim(GetNewPar("FOLHAPONTO","FolhaDePonto.dotx")))		
		IF .NOT.(cFolhaPonto$Lower(AllTrim(cArqWord)))
			ApMsgAlert(OemToAnsi("O Arquivo Modelo para geração da Folha de Ponto é Inválido. Selecione modelo de nome: "+cFolhaPonto),OemToAnsi("ATENÇÃO"))
			Return(.F.)
		EndIF
	EndIF
	
	IF .NOT.( Type("MV_PAR32")=="N" )
		MV_PAR32	:= 2
	EndIF
	
	Private lSMail	:= ( MV_PAR32 == 1 )
	
	IF ( ( lSMail ) .and. Empty(cArqSaida) )
		While ( lContinue := MsgYesNo(OemToAnsi("Para o envio dos e-mail a informação do diretório é obrigatória. Deseja Continuar?"),OemToAnsi("ATENÇÃO")) )
			IF fDirG_Word()
				cArqSaida := Lower(AllTrim(MV_PAR29))
				IF .NOT.( Empty(cArqSaida) )
					EXIT
				EndIF
			EndIF
		End While
		IF .NOT.( lContinue )
			Return( .F. )
		EndIF
	EndIF
	
	cArquivo	:= cArqWord
	SplitPath(@cArquivo,NIL,NIL,@cWordArq)
	
	IF ( lDepende )
		SRB->(dbSetOrder(RetOrder("SRB","RB_FILIAL+RB_MAT")))
	EndIF	

	IF .NOT.( ":" $ cArqWord )
		cAux 		:= cArqWord
		cArqWord	:= ""
		SplitPath(@cAux,NIL,NIL,@cArqWord,@cExtensao)
		cArqWord	:= Lower(cPath+cArqWord+cExtensao)		
		IF File( cArqWord )
			fErase( cArqWord )
		EndIF
		IF ( .NOT.( CpyS2T( cAux , cPath ,.T. ) ) .OR. .NOT.( File( cArqWord ) ) )
			ApMsgAlert(OemToAnsi("Arquivo Modelo: "+cArqWord+" Não encontrado."),OemToAnsi("ATENÇÃO"))
			Return(.F.)
		EndIF
		lCpyS2T		:= .T.
	EndIF

	cExclui := cExclui + "{ || "
	cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
	cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or." 
	cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or." 
	cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or." 
	cExclui := cExclui + "(RA_TNOTRAB < cTnoDe     .or. RA_TNOTRAB > cTnoAte    ).or." 
	cExclui := cExclui + "(RA_CODFUNC < cFunDe     .or. RA_CODFUNC > cFunAte    ).or." 
	cExclui := cExclui + "(RA_SINDICA < cSindDe    .or. RA_SINDICA > cSindAte   ).or." 
	cExclui := cExclui + "(RA_ADMISSA < dAdmiDe    .or. RA_ADMISSA > dAdmiAte   ).or." 
	cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$cCategoria)"
	cExclui := cExclui + " } "

	dbSelectArea("SRB")
	nSBOrdem := SRB->(IndexOrd())
	nSBRecno := SRB->(Recno())
	SRB->(dbGotop())
	
	dbSelectArea("SRA")
	nSvOrdem := SRA->(IndexOrd())
	nSvRecno := SRA->(Recno())
	SRA->(dbGotop())
	
	#IFNDEF TOP
		
		cExclui := cExclui + "{ || "
		cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
		cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or." 
		cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or." 
		cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or." 
		cExclui := cExclui + "(RA_TNOTRAB < cTnoDe     .or. RA_TNOTRAB > cTnoAte    ).or." 
		cExclui := cExclui + "(RA_CODFUNC < cFunDe     .or. RA_CODFUNC > cFunAte    ).or." 
		cExclui := cExclui + "(RA_SINDICA < cSindDe    .or. RA_SINDICA > cSindAte   ).or." 
		cExclui := cExclui + "(RA_ADMISSA < dAdmiDe    .or. RA_ADMISSA > dAdmiAte   ).or." 
		cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$cCategoria)"
		cExclui := cExclui + " } "
		
		IF nOrdem == 1	   							//Matricula
			SRA->( dbSetOrder(nOrdem) )
			SRA->( dbSeek( cFilDe + cMatDe , .T. ) )
			cInicio := '{ || RA_FILIAL + RA_MAT }'
			cFim    := cFilAte + cMatAte
		ElseIF nOrdem == 2							//Centro de Custo
			SRA->( dbSetOrder(nOrdem) )
			SRA->( dbSeek( cFilDe + cCcDe + cMatDe , .T. ) )
			cInicio  := '{ || RA_FILIAL + RA_CC + RA_MAT }'
			cFim     := cFilAte + cCcAte + cMatAte
		ElseIF nOrdem == 3							//Nome 
			SRA->( dbSetOrder(nOrdem) )
			SRA->( dbSeek( cFilDe + cNomeDe + cMatDe , .T. ) )
			cInicio := '{ || RA_FILIAL + RA_NOME + RA_MAT }'
			cFim    := cFilAte + cNomeAte + cMatAte
		ElseIF nOrdem == 4							//Turno 
			SRA->( dbSetOrder(nOrdem) )
			SRA->( dbSeek( cFilDe + cTnoDe ,.T. ) )
			cInicio  := '{ || RA_FILIAL + RA_TNOTRAB } '
			cFim     := cFilAte + cCcAte + cNomeAte
		ElseIF nOrdem == 5							//Admissao 
			cIndCond:= "RA_FILIAL + DTOS (RA_ADMISSA)"
			cArqNtx  := CriaTrab(Nil,.F.)
			SRA->( IndRegua("SRA",cArqNtx,cIndCond,,,STR0162))		//"Selecionando Registros..."
			SRA->( dbSeek( cFilDe + DTOS(dAdmiDe) ,.T. ) )
			cInicio  :='{ || RA_FILIAL + DTOS(RA_ADMISSA)}' 
			cFim     := cFilAte + DTOS(dAdmiAte)
		EndIF

    #ELSE

    	aStrSRA	:= SRA->( dbStruct() )
        SRA->( dbCloseArea() )

		cStr  		:= cSituacao 
		nStr  		:= 0
		nStrT 		:= Len( cStr )
		cSituacao   := ""
		While ( ++nStr <= nStrT )
			cSituacao += "'"+SubStr(cStr,nStr,1)+"'"
			IF .NOT.( nStr == nStrT )
				cSituacao += ","	
			ENDIF
		End While
		cSituacao	:= "%("+cSituacao+")%"

		cStr  		:= cCategoria
		nStr  		:= 0
		nStrT 		:= Len( cStr )
		cCategoria	:= ""
		While ( ++nStr <= nStrT )
			cCategoria += "'"+SubStr(cStr,nStr,1)+"'"
			IF .NOT.( nStr == nStrT )
				cCategoria += ","	
			ENDIF
		End While
		cCategoria	:= "%("+cCategoria+")%"

		IF nOrdem == 1	   							//Matricula
			cIndexKey := "%SRA.RA_FILIAL,SRA.RA_MAT%"
		ElseIF nOrdem == 2							//Centro de Custo
			cIndexKey := "%SRA.RA_FILIAL,SRA.RA_CC,SRA.RA_MAT%"
		ElseIF nOrdem == 3							//Nome 
			cIndexKey := "%SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_MAT%"
		ElseIF nOrdem == 4							//Turno 
			cIndexKey := "%SRA.RA_FILIAL,SRA.RA_TNOTRAB%"
		ElseIF nOrdem == 5							//Admissao 
			cIndexKey := "%SRA.RA_FILIAL,SRA.RA_ADMISSA%"
		EndIF

        BEGINSQL ALIAS "SRA"
        	
        	SELECT
        		SRA.*
        	FROM
        		%table:SRA% SRA
        	WHERE SRA.%notDel%
        	  AND SRA.RA_FILIAL = SRA.RA_FILIAL
        	  AND SRA.RA_FILIAL  BETWEEN %exp:cFilDe%  AND %exp:cFilAte%
        	  AND SRA.RA_CC      BETWEEN %exp:cCCDe%   AND %exp:cCCAte%
        	  AND SRA.RA_MAT     BETWEEN %exp:cMatDe%  AND %exp:cMatAte%
        	  AND SRA.RA_NOME    BETWEEN %exp:cNomeDe% AND %exp:cNomeAte%
        	  AND SRA.RA_TNOTRAB BETWEEN %exp:cTnoDe%  AND %exp:cTnoAte%
        	  AND SRA.RA_CODFUNC BETWEEN %exp:cFunDe%  AND %exp:cFunAte%
        	  AND SRA.RA_SINDICA BETWEEN %exp:cSindDe% AND %exp:cSindAte%
        	  AND SRA.RA_ADMISSA BETWEEN %exp:cAdmiDe% AND %exp:cAdmiAte%
        	  AND SRA.RA_SITFOLH IN %exp:cSituacao%
        	  AND SRA.RA_CATFUNC IN %exp:cCategoria%
        	ORDER BY
        	  %exp:cIndexKey%
        
        ENDSQL

        aEval(aStrSRA,{|f|IF(f[DBS_TYPE]$"DLN",TCSetField("SRA",f[DBS_NAME],f[DBS_TYPE],f[DBS_LEN],f[DBS_DEC]),NIL)})
        aSize( aStrSRA , 0 )
        aStrSRA := NIL

	#ENDIF

	ProcRegua(0)

	fhWord	:= OLE_CreateLink()
	OLE_NewFile(fhWord,cArqWord)
	
	cArqSaida	:= Lower( cArqSaida )

#IFNDEF TOP		
	While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
#ELSE
	While SRA->( !Eof() )
#ENDIF	
		
		IncProc("Processando...")
		
		#IFNDEF TOP

			IF SRA->( Eval ( &(cExclui) ) )
		       SRA->( dbSkip() )
		       Loop
		    EndIF
			    
		#ENDIF		    
		
		IF ( ( lFPonto ) .and. ( lRAXMAILFP ) )
	    	IF ( SRA->RA_XMAILFP == "N" )
	    		SRA->( dbSkip() )
	    		Loop
	    	EndIF
	 	EndIF
	
		IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
			SRA->(dbSkip())
			Loop
		EndIF 
	
		If lDepende
			If nDepende == 1 //Salario Familia //
				If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
			    	fDepSF( )
				Else
					SRA->(dbSkip())
					Loop
				Endif		
			ElseIf nDepende == 2 //Imposto de Renda	//
	   			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
		    		fDepIR( )
		    	Else
					SRA->(dbSkip())
					Loop
				Endif	
			ElseIf nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
	   			SRB->(dbSeek(SRA->(RA_FILIAL+RA_MAT),.F.))
	   			nSRBRecno	:= SRB->( Recno() )
	       		fDepIR()
				SRB->( MsGoTo( nSRBRecno ) )
				SRB->(MsSeek(SRA->(RA_FILIAL+RA_MAT),.F.))
				fDepSF()
			Endif
			If (nDepende == 1)
				If  empty(aDepenSF[1,1])
					SRA->(dbSkip())
					Loop
				Endif	
			ElseIf	(nDepende == 2)
				If  empty(aDepenIR[1,1])
					SRA->(dbSkip())
					Loop
				Endif	          
			ElseIf	(nDepende == 3)
				If  empty(aDepenIR[1,1])  .and. empty(aDepenSF[1,1])
					SRA->(dbSkip())
					Loop
				EndIf
			Endif	                                                          
		Endif			
	   
		If ( cPaisLoc == "COL" )
		   fPesqSRF()                  //Busca Periodo Aquisitivo para Colombia
		Endif   
	
		IF SRA->RA_FILIAL # cFilialAnt
			cFilAnt	:= SRA->RA_FILIAL
			SM0->( dbSetOrder( 1 ) )
			SM0->( dbSeek( cEmpAnt+cFilAnt , .F. ) )
			IF !fInfo(@aInfo,SRA->RA_FILIAL)
				Exit
			EndIF			
			cFilialAnt := SRA->RA_FILIAL
		EndIF	
	    
		SRA->(IncProc("["+RA_FILIAL+"]["+RA_MAT+"]["+AllTrim(RA_NOME)+"]"))
		
		aFields := SRA->(fCpos_Word())
		nFields := Len( aFields )
		For nField := 1 To nFields
			IF (SubStr(AllTrim(aFields[nField][3]),4,2)=="->")
				caFields3	:= AllTrim(aFields[nField][3])
				cPicture	:= X3Picture(SubStr(caFields3,AT(">",caFields3)+1))
			Else
				cPicture	:= aFields[nField][3]
			EndIF	
			cField	:= Transform(aFields[nField][2],cPicture)
			OLE_SetDocumentVar(fhWord,aFields[nField][1],cField)
		Next nField
	        	
		OLE_UpDateFields(fhWord)
	
		IF ( lImpress )
			For nX := 1 To nCopias
				OLE_SetProperty(fhWord,"208",.F.)
				OLE_PrintFile(fhWord)
			Next nX
		EndIF

		IF ( .NOT.( lImpress ) .or. ( lSMail ) )
			cArquivo	:= cArqSaida
			cArquivo	+= cEmpAnt
			cArquivo	+= "-"
			cArquivo	+= AllTrim(SRA->RA_FILIAL)
			cArquivo	+= "-"
			cArquivo	+= AllTrim(SRA->RA_CC)
			cArquivo	+= "-"
			cArquivo	+= AllTrim(SRA->RA_TNOTRAB)
			cArquivo	+= "-"
			cArquivo	+= AllTrim(SRA->RA_MAT)
			cArquivo	+= "-"
			cArquivo	+= StrTran(AllTrim(SRA->RA_NOME)," ","-")
			cArquivo	+= "-"
			cArquivo	+= cWordArq
			cArquivo	+= ".doc"
			cArquivo	:= Lower(cArquivo)
			OLE_SaveAsFile(@fhWord,@cArquivo)
			IF ( lSMail )
				cEmail	:= Lower( AllTrim( SRA->RA_EMAIL ) )
				IF .NOT.( Empty( cEmail ) )
					aAdd( aSMail , Array(4) )
					nID := Len( aSMail )
					aSMail[nID][1] := cEmail
					aSMail[nID][2] := cArquivo
					aSMail[nID][3] := .F.
				EndIF	
			EndIF
		EndIF
		
	    SRA->(dbSkip())
	
	    aSize( aDepenIR , 0 )
	    aSize( aDepenSF , 0 )
		aSize( aPerSRF  , 0 )
	
	Enddo	
	
	OLE_CloseFile( fhWord )
	OLE_CloseLink( fhWord )
	
	If ( lCpyS2T )
		IF ( cPath $ cArqWord )
			fErase(cArqWord)
		EndIF	
	Endif

	nIDs := Len(aSMail)
	
	IF ( ( nIDs > 0 ) .and. ( lPDF ) )
		lBTDNPS1	:= GetNewPar( "DOC2PDFEXE" , .F. )
		IF ( lBTDNPS1)  
			lBTDNPS1	:= File(cArqSaida+"BTDNdoc2pdf.exe")
			IF ( lBTDNPS1 )
				MakeDir(cArqSaida+"chksum\")
				IF File(cArqSaida+"chksum\"+"BTDNdoc2pdf.exe")
					fErase(cArqSaida+"chksum\"+"BTDNdoc2pdf.exe")
				EndIF
				IF ( Resource2File("BTDNdoc2pdf.exe",cArqSaida+"chksum\"+"BTDNdoc2pdf.exe") )
					IF .NOT.( MD5File (cArqSaida+"BTDNdoc2pdf.exe",1,0)==MD5File(cArqSaida+"chksum\"+"BTDNdoc2pdf.exe",1,0))
						fErase(cArqSaida+"BTDNdoc2pdf.exe")
						lBTDNPS1 := Resource2File("BTDNdoc2pdf.exe",cArqSaida+"BTDNdoc2pdf.exe")
					EndIF
					fErase(cArqSaida+"chksum\"+"BTDNdoc2pdf.exe")
				EndIF
			EndIF
			IF .NOT.( lBTDNPS1 )
				lBTDNPS1 := Resource2File("BTDNdoc2pdf.exe",cArqSaida+"BTDNdoc2pdf.exe")			
				IF .NOT.( lBTDNPS1 )
					lPDF := doc2pdf(@cArqSaida)
				EndIF	                                                                     	
			Else
				lPDF := lBTDNPS1
			EndIF	
		Else
			lPDF := doc2pdf(@cArqSaida)	
		EndIF
		IF ( lPDF )
			IF ( lBTDNPS1 )
				cWaitRunCmd    := cArqSaida+"BTDNdoc2pdf.exe"
			Else
				cWaitRunCmd    := "PowerShell -WindowStyle MAXIMIZED -File " + cArqSaida+"doc2pdf.ps1"
			EndIF
			MsAguarde( { || nWaitRunRet := WaitRun(cWaitRunCmd,SW_SHOWNORMAL) , Sleep(5000) } , IF(lBTDNPS1,"BTDN","")+"DOC2PDF : Convertendo arquivos" , "Aguarde..." ) 
		EndIF
	EndIF
	
	BEGIN SEQUENCE
	
		IF .NOT.( lSMail )
			BREAK
		ENDIF

		IF .NOT.( nIDs > 0 )
			BREAK
		ENDIF
		
		IF ( nIDs > 1 )
			cMsg := "Arquivos gerados. Deseja encaminhá-los por e-mail?"
		Else
			cMsg := "Arquivo gerado. Deseja encaminhá-lo por e-mail?"
		EndIF	
		
		IF .NOT.( MsgYesNo(OemToAnsi(cMsg),OemToAnsi("ATENÇÃO")) )
			BREAK
		ENDIF
		
		aMsg := DlgMemoEdit()
		IF .NOT.( aMsg[1] )
			BREAK
		EndIF
		
		cMailTit 	:= aMsg[2]
		cMailBody	:= aMsg[3]			
		MakeDir("\tmp\")
		MakeDir("\tmp\mail\")
		ProcRegua(nIDs)
		For nID := 1 TO nIDs
			cEmail	    := aSMail[nID][1]
			IncProc("Enviando : ["+cEmail+"]")
			cArquivo	:= aSMail[nID][2]
			cSrvSaida	:= cArqSaida
			IF ( lPDF )
				cPDF := StrTran(cArquivo,".doc",".pdf")
				IF File(cPDF)
					fErase(cArquivo)
					cArquivo 		:= cPDF
					aSMail[nID][2]	:= cPDF
				ElseIF ( lBTDNPS1 )
					cPDF 		:= StrTran(cPDF,cArqSaida,"")
					aPDFFile	:= Directory("\pdfspool\*"+cPDF)
					IF .NOT.( Empty(aPDFFile) )
						cPDF := Lower( "\pdfspool\"+aPDFFile[1][F_NAME] )
						IF File(cPDF)
							fErase(cArquivo)
							IF ( "microsoft word - " $ cArquivo )
								cPDF := StrTran(cArquivo,"microsoft word - ","")
								IF File( cPDF )
									fErase( cPDF )
								EndIF
								IF ( ( fRename(cArquivo,cPDF) == -1 ) .or. .NOT.( fError() == 0 ) )
									cPDF		:= cArquivo
								EndIF
							EndIF
							cArquivo 		:= cPDF
							aSMail[nID][2]	:= cPDF
                      		lServer			:= .T.
                      	EndIF
					Else
						aPDFFile := Directory(cDrive+"\pdfspool\*"+cPDF)
						IF .NOT.( Empty(aPDFFile) )
							cPDF := Lower(cDrive+"\pdfspool\"+aPDFFile[1][F_NAME])
							IF File(cPDF)
								fErase(cArquivo)
								cArquivo 		:= Lower(cPDF)
								IF ( "microsoft word - " $ cArquivo )
									cPDF := StrTran(cArquivo,"microsoft word - ","")
									IF File( cPDF )
										fErase( cPDF )
									EndIF
									IF ( ( fRename(cArquivo,cPDF) == -1 ) .or. .NOT.( fError() == 0 ) )
										cPDF 		:= cArquivo
									EndIF
								EndIF
								cArquivo 		:= cPDF
								cSrvSaida		:= (cDrive+"\pdfspool\")
								aSMail[nID][2]	:= cPDF
                    	  		lServer			:= .F.
        					EndIF
						EndIF
					EndIF
				EndIF
			EndIF
			IF File( cArquivo )
				IF lServer .or. __CopyFile(cArquivo,StrTran(cArquivo,cSrvSaida,"\tmp\mail\"))
					IF .NOT.( lServer )
						cArquivo := StrTran(cArquivo,cSrvSaida,"\tmp\mail\")
					EndIF
					IF File( cArquivo )
						afAtt[1]			:= cArquivo
						__cINTERNET 		:= "AUTOMATICO"
							/*
								Parametros (SX6) Utilizados pela Rotina de envio de e-mail
					
								MV_SUBJLE   //Se Justifica o Texto
								MV_RELFROM	//E-mail utilizado no campo FROM no envio de relatorios por e-mail
								MV_RELSERV	//Nome do Servidor de Envio de E-mail utilizado nos relatorios
								MV_RELAUTH	//Servidor de EMAIL necessita de Autenticacao? (.T.)
								MV_RELACNT	//Conta a ser utilizada no envio de E-Mail para os relatorios
								MV_RELPSW	//Senha para autenticacäo no servidor de e-mail
								MV_RELTIME	//Timeout no Envio de EMAIL.
								MV_MAILADT	//Conta oculta de auditoria utilizada no envio de e-mail para os relatorios
							*/
							aSMail[nID][3]	:= SetMail(@cEmail,@cMailTit,@cMailBody,@afAtt,.F.,.F.,.F.,.F.,"")
							fErase( cArquivo )
						__cINTERNET 		:= cLInternet
					EndIF	
				EndIF
			EndIF
		Next nID

		ProcRegua(0)

		For nID := 1 TO nIDs
			IncProc("Verificando arquivos temporários...")		
			IF ( aSMail[nID][3] )
				cArquivo	:= aSMail[nID][2]
				IncProc("Excluindo : ["+cArquivo+"]")
				IF File( cArquivo )
					fErase( cArquivo )
				EndIF
			EndIF
		Next nID

	END SEQUENCE
	
	cFilAnt := cSvFilAnt
	SM0->( dbSetOrder( 1 ) )
	SM0->( dbSeek( cEmpAnt+cFilAnt , .F. ) )
		 
#IFDEF TOP		
	SRA->( dbCloseArea() )
#ENDIF

	dbSelectArea("SRA")
	SRA->(dbSetOrder( nSvOrdem ))
	SRA->(dbGoTo( nSvRecno ))

Return( .T. )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fOpen_Word()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Selecionar o Modelo de Documento a ser Impresso
*/                          
Static Function fOpen_Word(lGet,cFile)

	Local cSvAlias		:= Alias()
	Local lAchou		:= .F.
	Local cTipo			:= STR0006														
	Local cNewPathArq	:= AllTrim(IF(IF(lGet==NIL,.F.,lGet),cGetFile(cTipo,STR0007 ),cFile))									
	
	IF .NOT.( Empty( cNewPathArq ) )
		IF ( Len( cNewPathArq ) > MVPAR25_MAXSIZE )
	    	MsgAlert( STR0187 ) //"O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
	    	Return(.F.)			
		Else
			IF Lower( SubStr( AllTrim( cNewPathArq ), - 3 ) ) == Lower( AllTrim( STR0008 ) ) 
				Aviso( STR0009 , cNewPathArq , { STR0010 } )								
		    ElseIf Lower( SubStr( AllTrim( cNewPathArq ), - 4 ) ) == Lower( AllTrim( STR0294 ) )	
				Aviso( STR0009 , cNewPathArq , { STR0010 } )								
		    Else
		    	MsgAlert( STR0011 )															
		    	Return(.F.)
		    EndIf
		EndIf
	Else
	    Aviso(STR0012 ,STR0007,{ STR0010 } )//Aviso(STR0012 ,{ STR0010 } )													
	    Return(.F.)
	EndIF
	dbSelectArea("SX1")
	IF lAchou := ( SX1->( dbSeek( cPerg + "25" , .T. ) ) )
		IF RecLock("SX1",.F.,.T.)	
			IF Empty(cNewPathArq)
				SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
			Else
				SX1->X1_CNT01 := cNewPathArq
			EndIF
			MV_PAR25 := cNewPathArq
			SX1->(MsUnLock())
		EndIF
	EndIF	
	dbSelectArea( cSvAlias )
Return(.T.)

/*
	Programa	: U_btdnGR08.PRW
	Funcao		: fDirG_Word
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Seleciona Diretorio Local para Gravacao dos arquivos
*/  
Static Function fDirG_Word(lGetF)
	
	Local cDrive
	Local cfDirGWord

	Local lRet			:= .T.
	Local lFound		:= .F.
	Local lLock			:= .F.

	BEGIN SEQUENCE    

		IF ( MV_PAR28 == 1 ) //Impressora
			BREAK
		EndIF
		
		SplitPath(GetTempPath(),@cDrive)
			
		IF .NOT.( SubStr(cDrive,-1)=="\")
			cDrive += "\"	
		EndIF
		
		cDrive += "gpedocs\" 
		
		MakeDir( cDrive )
		
		IF ( lGetF )
			cfDirGWord := cGetFile ("Selecione o Diretorio|*.*",OemToAnsi("Selecione o Diretório para Gravação"),1,@cDrive,.F.,(GETF_LOCALHARD+GETF_RETDIRECTORY),.T.,.T.)
		Else
			cfDirGWord := cDrive
		EndIF       

		IF Empty( cfDirGWord )
		    ApMsgAlert(OemToAnsi("Informe um Diretório para Gravação"),OemToAnsi("ATENÇÃO"))
		    lRet := .F.
		    BREAK
		EndIF
		
		MakeDir( cfDirGWord )
		
		IF ( Type("cPerg") == "U" )
			cPerg	:= PadR("U_GPEWORDX",Len(SX1->X1_GRUPO))
		EndIF
		
		cPerg		:= PadR( cPerg , Len(SX1->X1_GRUPO) )
		
		lFound		:= ( SX1->( dbSeek( cPerg + "29" , .T. ) ) )
		MV_PAR29	:= cfDirGWord
		
		IF .NOT.( lFound )
			BREAK
		EndIF
		
		lLock	:= SX1->( RecLock( "SX1" , .F. , .T. ) )
		
		IF .NOT.( lLock )
			BREAK
		EndIF
		
		SX1->X1_CNT01 := cfDirGWord
		
		SX1->( MsUnLock() )

	END SEQUENCE

Return( lRet )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fVarW_Imp()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Imprime as Variaveis
*/      
Static Function fVarW_Imp()

	Local cString	:= 'SRA'                                	     
	Local aOrd		:= {STR0142,STR0143}
	Local cDesc1	:= STR0144
	Local cDesc2	:= STR0145                     
	Local cDesc3	:= STR0146                                
	Local Tamanho	:= "G"

	Private nomeprog	:= 'GPEWORD'
	Private AT_PRG		:= nomeProg
	Private aReturn		:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
	Private wCabec0		:= 1
	Private wCabec1		:= STR0149
	Private wCabec2		:= ""
	Private wCabec3		:= ""
	Private nTamanho	:= "G"
	Private lEnd		:= .F.
	Private Titulo		:= cDesc1
	Private Li			:= 0
	Private ContFl		:= 1
	Private cBtxt		:= ""
	Private aLinha		:= {}
	Private nLastKey	:= 0
	
	WnRel := "WORD_VAR" 
	WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)
	
	IF nLastKey == 27
		Return(.F.)
	EndIF
	
	SetDefault(aReturn,cString)
	
	IF nLastKey == 27
		Return(.F.)
	EndIF
	
	RptStatus( { |lEnd| fImpVar() } , Titulo )

Return( .T. )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fImpVar()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Imprime as Variaveis
*/      
Static Function fImpVar()

	Local nOrdem	:= aReturn[8]
	Local aFields	:= {}
	Local nX		:= 0
	Local cDetalhe	:= ""
	Local cDescr	:= ""
	
	IF !fInfo(@aInfo,xFilial("SRA"))
		Return(.F.)
	EndIF			
	
	aFields := fCpos_Word()
	
	IF nOrdem = 1
		aSort( aFields , , , { |x,y| x[1] < y[1] } )
	Else
		aSort( aFields , , , { |x,y| x[4] < y[4] } )
	EndIF
	
	SetRegua( Len( aFields ) )
	
	For nX := 1 To Len( aFields )
	
		IncRegua()  
		
		IF lEnd
			@ Prow()+1,0 PSAY cCancel
			Exit
		EndIF            
	
		cDescr := AllTrim( aFields[nX,4] )
		Impr( Padr(aFields[nX,1],31) + cDescr )
		
	Next nX
	
	IF aReturn[5] == 1
	   Set Printer To
	   dbCommit()
	   OurSpool(WnRel)
	EndIF
	
	If nOrdem == 5
		fErase( cArqNtx + OrdBagExt() )
	Endif                      
	
	MS_FLUSH()

Return( .T. )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fDepIR()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Dependentes para IR
*/      
Static Function fDepIR()
	
	Local Nx,nVezes
	Local aArea		:= GetArea()
	Local aSRBArea	:= SRB->( GetArea() )

	aSize( aDepenIR , 0 )
	
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If  (SRB->RB_TipIr == '1') .Or.;
         	(SRB->RB_TipIr == '2' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 21) .Or. ;
            (SRB->RB_TipIr == '3' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 24)
			//	Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    '))   })
        EndIf
        SRB->(dbSkip())
	EndDo 
	If  Len(aDepenIR) < 10
      	nVezes := (10 - Len(aDepenIR))
		For Nx := 1 to nVezes
			 aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		Next Nx
	EndIf
	IF Empty(aDepenIR[1][1])
		aDepenIR[1][1] := PADC( "------- SEM DEPENDENTES -------" , 50 )
	EndIF	
	RestArea( aSRBArea )
	RestArea( aArea )
Return(aDepenIR)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fDepSF()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Dependentes para Salario Familia
*/      
Static Function fDepSF()
	Local aArea		:= GetArea()
	Local aSRBArea	:= SRB->( GetArea() )
	Local Nx,nVezes
	aSize( aDepenSF , 0 )
   	Do While SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If (SRB->RB_TipSf == '1') .Or. (SRB->RB_TipSf == '2' .And. ;
			Year(dDAtABase) - Year(SRB->RB_DtNasc) <= 14)
			//Nome do Depend., Dta Nascimento,Grau Parent.,Local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      		aAdd(aDepenSF,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    ')),;
      						SRB->RB_LOCNASC,SRB->RB_CARTORI,SRB->RB_NREGCAR,SRB->RB_NUMLIVR,SRB->RB_NUMFOLH,SRB->RB_DTENTRA,SRB->RB_DTBAIXA})
		EndIf
		SRB->(dbSkip())
	Enddo
   	If  Len(aDepenSF) < 10
      	nVezes := (10 - Len(aDepenSF))
		For Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		Next Nx
	EndIf
	IF Empty(aDepenSF[1][1])
		aDepenSF[1][1] := PADC( "------- SEM DEPENDENTES -------" , 50 )
	EndIF	
	RestArea( aSRBArea )
	RestArea( aArea )
Return(aDepenSF)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fPesqSRF()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Informações de Férias
*/      
Static Function fPesqSRF()
	Local cAliasSRF := "SRF"
	/* Rotina de Busca Periodo Aquisitivo SRF */
	aSize( aPerSRF , 0 )
	dbSelectArea(cAliasSRF)
	(cAliasSRF)->(dbSetOrder(RETORDER(cAliasSRF,"RF_FILIAL+RF_MAT+DTOS(RF_DATABAS")))
	IF (cAliasSRF)->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
   		While (cAliasSRF)->(!Eof() .And. RF_MAT == SRA->RA_MAT)
			IF (cAliasSRF)->RF_STATUS == "1"                       //1= Ativo
				//Verifica se o Periodo Aberto não esta Expirado (3 Anos)
				nAnoExp := DDATABASE - (cAliasSRF)->RF_DATAFIM
				IF (nAnoExp < 1080 )          
		           //Data Inicial Periodo de Ferias, Data Final Periodo de Ferias
   		           (cAliasSRF)->(aAdd(aPerSRF,{RF_DATABAS,RF_DATAFIM } ))
				Else
				   ( cAliasSRF )->( dbSkip(1) )
				   Loop
				ENDIF
				EXIT
			ENDIF
		   ( cAliasSRF )->( dbSkip(1) )
		EndDO
	ENDIF	
Return(aPerSRF)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fTarProf()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Informações de Tarefeiro/Professor
*/      
Static Function fTarProf(dDtRef)

	Local nI		:= 0
	Local nP		:= 0
	Local nCont		:= 0
	Local nQtTar	:= 2				// Quantidade de tarefas
	Local aArea		:= GetArea()
	Local aCpos		:= Array(nQtTar,0)
	Local aRet		:= Array(nQtTar,0)
	Local bTar		:= { || .T. }
	
	DEFAULT dDtRef := SRA->RA_ADMISSA
	
	For nI := 1 To nQtTar
		aAdd( aCpos[nI], { "RO_DESTAR",	} )
		aAdd( aCpos[nI], { "RO_QTDSEM",	} )
		aAdd( aCpos[nI], { "RO_QUANT",	} )
		aAdd( aCpos[nI], { "RO_VALOR",	} )
		aAdd( aCpos[nI], { "RO_VALTOT",	} )
	Next
	
	// Professores mensalistas so considerar tarefas fixas
	If SRA->RA_CATFUNC == "I"
		bTar := { || SRO->RO_TIPO == "1" }
	EndIf
	
	dbSelectArea("SRO")
	If SRO->(dbSeek( SRA->( RA_FILIAL + RA_MAT ) ))
		While SRO->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT ) == ( RO_FILIAL + RO_MAT ) .And. nCont < nQtTar )
			If SRO->( MesAno(RO_DATA) == MesAno(dDtRef) .And. Eval(bTar) ) // Fitlra data de referencia e tarefas fixas
				If SRO->( RO_TPALT == "001" .And. RO_QUANT > 0 ) // Considera apenas salario Inicial e despreza se for h.e./falta
					nCont++
					For nP := 1 To Len( aCpos[1] )
						If aCpos[nCont][nP][1] == "RO_DESTAR"
							aCpos[nCont][nP][2] := fDescTarefa(SRO->RO_CODTAR)
						Else
							aCpos[nCont][nP][2] := SRO->( &( aCpos[nCont][nP][1] ) )
						EndIf
					Next
				EndIf
			EndIf
			SRO->(dbSkip())
		EndDo
	EndIf
	
	For nI := 1 To nQtTar
		aEval( aCpos[nI], { |x| aAdd( aRet[nI], x[2] ) } )
	Next
	
	RestArea( aArea )
	
Return( aRet )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fCpos_Word()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Retorna Array com as Variaveis Disponiveis para Impressao
					aExp[x][1] - Variavel Para utilizacao no Word (Tam Max. 30)
					aExp[x][2] - Conteudo do Campo                (Tam Max. 49)
					aExp[x][3] - Campo para Pesquisa da Picture no X3 ou Picture
					aExp[x][4] - Descricao da Variavel
	
*/      
Static Function fCpos_Word()

	Local aExp			:= {}
	Local aRet			:= {}
	Local cTexto_01		:= AllTrim( MV_PAR19 )
	Local cTexto_02		:= AllTrim( MV_PAR20 )
	Local cTexto_03		:= AllTrim( MV_PAR21 )
	Local cTexto_04		:= AllTrim( MV_PAR22 ) 
	Local cApoderado	:= ""
	Local cRamoAtiv		:= ""   
	Local cEstCiv		:= "" //Estado Civil para DCN/DMN - PIS
	Local cTipCertd		:= "" //Tipo de Certidao Civil para DCN/DMN - PIS
	Local cGrauInstr	:= "" //Grau de Instrucao conforme DCN/DMN - PIS
	Local cTipNIS		:= ""
	
	Local cDESMTSS		:=""
	Local cDESCCSS		:=""
	Local cDESINS		:=""
	Local cDESCAN		:=""
	Local cDESCIC		:=""
	Local cDESJOR		:=""
	Local cDESFON		:=""
	
	Local cCodMunLP		:= ""
	Local cCodReqFun	:= ""
	
	Local cDescDepto
	
	Local cSRJFilial	:= xFilial("SRJ",SRA->RA_FILIAL)
	Local cCC2Filial	:= xFilial("CC2",SRA->RA_FILIAL)
	Local cSR6Filial	:= xFilial("SR6",SRA->RA_FILIAL)
	Local cSRAFilial	:= xFilial("SRA",SRA->RA_FILIAL)
	Local cSQBFilial	:= xFilial("SQB",SRA->RA_FILIAL)

	Local cRCOFilial	:= IF(cPaisLoc$"COS",xFilial("RCO",SRA->RA_FILIAL),"")
	Local cRGCFilial	:= IF(cPaisLoc$"COS|MEX",xFilial("RGC",SRA->RA_FILIAL),"")
	Local cVAMFilial	:= IF(cPaisLoc$"MEX",xFilial("VAM",SRA->RA_FILIAL),"")

	Local lDepen1or3	:= ( (nDepen==1) .or. (nDepen==3) )
	Local lDepen2or3	:= ( (nDepen==2) .or. (nDepen==3) )
	
	Local nAt
	Local lEndDepto		:= ( ( Type( "__lEndDepto" ) == "L" ) .and. __lEndDepto )

	Local nSQBOrder		:= RetOrder("SQB","QB_FILIAL+QB_DEPTO")

	Local cNroEndEmp
	Local cComEndEmp
	Local cEndEmp
	Local cMunEmp
	Local cCepEmp
	Local cUFEmp
	Local cBaiEmp

	Local cRAXALOCAC	:= ""
	Local aX3cBox
	
	If cPaisLoc == "BRA"
		cTipNIS := MV_PAR30  //Pergunte exclusivo do Brasil // Tipo PIS - DCN/DMN
	EndIf
	
	If cPaisLoc == "ARG"
		If fPHist82(cSRAFilial,"99","01")
			cApoderado := SubStr(SRX->RX_TXT,1,30)
		EndIf
		If fPHist82(cSRAFilial,"99","02")
			cRamoAtiv := SubStr(SRX->RX_TXT,1,50) 
		EndIf	           
	EndIf	
	
	aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  	, "SRA->RA_FILIAL"			,STR0013	} ) 
	aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT												, "SRA->RA_MAT"				,STR0014	} ) 
	aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC												, "SRA->RA_CC"				,STR0015	} ) 
	aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 				, "@!"						,STR0016	} ) 
	aAdd( aExp, {'GPE_NOME'		   			,	SRA->RA_NOME											, "SRA->RA_NOME"			,STR0017	} ) 
	aAdd( aExp, {'GPE_NOMECMP'           	,   If(SRA->(FieldPos("RA_NOMECMP")) # 0  ,SRA->RA_NOMECMP,space(40)), "@!"           ,STR0017 	} )
	aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC												, "SRA->RA_CIC"				,STR0018	} ) 
	aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS												, "SRA->RA_PIS"				,STR0019	} ) 
	aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG												, "SRA->RA_RG"				,STR0020	} ) 
	aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG											, "@!"						,STR0152	} ) 
	aAdd( aExp, {'GPE_RG_ORGUF'	   			,	SRA->RA_RGUF											, "@!"						,STR0241	} ) 
	aAdd( aExp, {'GPE_CTPS'					,	SRA->RA_NUMCP							 				, "SRA->RA_NUMCP"			,STR0021	} ) 
	aAdd( aExp, {'GPE_SERIE_CTPS'			,	SRA->RA_SERCP							 				, "SRA->RA_SERCP"			,STR0022	} ) 
	aAdd( aExp, {'GPE_UF_CTPS'				,	SRA->RA_UFCP							 				, "SRA->RA_UFCP"			,STR0023	} ) 
	aAdd( aExp, {'GPE_CNH'   	  			,	SRA->RA_HABILIT							 				, "SRA->RA_HABILIT"			,STR0024	} ) 
	aAdd( aExp, {'GPE_RESERVISTA'			,	SRA->RA_RESERVI							 				, "SRA->RA_RESERVI"			,STR0025	} ) 
	aAdd( aExp, {'GPE_TIT_ELEITOR' 			,	SRA->RA_TITULOE							 				, "SRA->RA_TITULOE"			,STR0026	} ) 
	aAdd( aExp, {'GPE_ZONA_SECAO'  			,	SRA->RA_ZONASEC							 				, "SRA->RA_ZONASEC"			,STR0027	} ) 
	aAdd( aExp, {'GPE_ENDERECO'				,	SRA->RA_ENDEREC							 				, "SRA->RA_ENDEREC"			,STR0028	} ) 
	aAdd( aExp, {'GPE_COMP_ENDER'			,	SRA->RA_COMPLEM							 				, "SRA->RA_COMPLEM"			,STR0029	} )	
	
	If cPaisLoc == "PER"
		aAdd( aExp, {'GPE_BAIRRO'				,	RetContUbigeo("SRA->RA_CEP", "RA_BAIRRO") 				, "@!"						,STR0030	} ) 
		aAdd( aExp, {'GPE_MUNICIPIO'			,	RetContUbigeo("SRA->RA_CEP", "RA_MUNICIP") 				, "@!"						,STR0031	} )
		aAdd( aExp, {'GPE_DESC_ESTADO'			,	RetContUbigeo("SRA->RA_CEP", "RA_DEPARTA")				, "@!"						,STR0033	} )	
	Else
		aAdd( aExp, {'GPE_BAIRRO'				,	SRA->RA_BAIRRO							 				, "SRA->RA_BAIRRO"			,STR0030	} ) 
		aAdd( aExp, {'GPE_MUNICIPIO'			,	SRA->RA_MUNICIP							 				, "SRA->RA_MUNICIP"			,STR0031	} )	
	Endif
	
	If !(cPaisLoc $ "ANG*PER")
		aAdd( aExp, {'GPE_ESTADO'				,	SRA->RA_ESTADO											, "SRA->RA_ESTADO"			,STR0032	} )	
	ENDIF
	
	If cPaisLoc <> "PER"
		aAdd( aExp, {'GPE_DESC_ESTADO'			,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")			, "@!"						,STR0033	} ) 
	Endif
	aAdd( aExp, {'GPE_CEP'		   			,	SRA->RA_CEP												, "SRA->RA_CEP"				,STR0034	} ) 
	aAdd( aExp, {'GPE_TELEFONE'	   			,	SRA->RA_TELEFON											, "SRA->RA_TELEFON"			,STR0035	} ) 
	aAdd( aExp, {'GPE_NOME_PAI'	   			,	SRA->RA_PAI												, "SRA->RA_PAI"				,STR0036	} ) 
	aAdd( aExp, {'GPE_NOME_MAE'	   			,	SRA->RA_MAE												, "SRA->RA_MAE"				,STR0037	} ) 
	aAdd( aExp, {'GPE_COD_SEXO'	   			,	SRA->RA_SEXO											, "SRA->RA_SEXO"			,STR0038	} ) 
	aAdd( aExp, {'GPE_DESC_SEXO'   			,	SRA->(IF(RA_SEXO ="M","Masculino","Feminino"))			, "@!"						,STR0039	} ) 
	If cPaisLoc <> "ARG"
		aAdd( aExp, {'GPE_EST_CIVIL'  			,	SRA->RA_ESTCIVI										, "SRA->RA_ESTCIVI"			,STR0040	} ) 
	Else	
		aAdd( aExp, {'GPE_EST_CIVIL'  			,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")		, "SRA->RA_ESTCIVI"			,STR0040	} ) 
	EndIf	
	aAdd( aExp, {'GPE_COD_NATURALIDADE'		,	If(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    	, "SRA->RA_NATURAL"			,STR0041	} ) 
	aAdd( aExp, {'GPE_DESC_NATURALIDADE'	,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")			, "@!"						,STR0042	} ) 
	aAdd( aExp, {'GPE_COD_NACIONALIDADE'	,	SRA->RA_NACIONA											, "SRA->RA_NACIONA"			,STR0043	} ) 
	aAdd( aExp, {'GPE_DESC_NACIONALIDADE'	,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")			, "@!"						,STR0044	} ) 
	If cPaisLoc <> "EQU"
		aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG											, "SRA->RA_ANOCHEG"			,STR0045	} )
	EndIf
	aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 	, "SRA->RA_DEPIR"			,STR0046	} )	
	If lDepSf
		aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF											, "SRA->RA_DEPSF"			,STR0047 	} )
	EndIf
	aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC											, "SRA->RA_NASC"			,STR0048	} )
	aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA											, "SRA->RA_ADMISSA"			,STR0049	} )
	aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	Day2Str( SRA->RA_ADMISSA )					, "@!"						,STR0050	} )
	aAdd( aExp, {'GPE_MES_ADMISSAO'			,	Month2Str( SRA->RA_ADMISSA )					, "@!"						,STR0051 	} )
	aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	Year2Str( SRA->RA_ADMISSA )					, "@!"						,STR0052	} )
	aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO											, "SRA->RA_OPCAO"			,STR0053	} )
	aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA											, "SRA->RA_DEMISSA"			,STR0054	} ) 
	If cPaisLoc <> "EQU"
		aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP											, "SRA->RA_VCTOEXP"			,STR0055	} )
		aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	Day2Str( SRA->RA_VCTOEXP )					, "@!"						,STR0056	} )
		aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	Month2Str( SRA->RA_VCTOEXP )					, "@!"						,STR0057	} )
		aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	Year2Str( SRA->RA_VCTOEXP ) 					, "@!"						,STR0058	} )
		IF .NOT.( Empty( SRA->RA_VCTOEXP ) )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	LTrim(Str(SRA->(RA_VCTOEXP-RA_ADMISSA)+1)), "@!",STR0059	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA_EXTENSO',DiasExtenso(SRA->(RA_VCTOEXP-RA_ADMISSA)+1), "@!",STR0059 + " Extenso"	} )
		Else
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		   ,LTrim(Str(0)) , "@!",STR0059	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA_EXTENSO',DiasExtenso(0), "@!",STR0059 + " Extenso"	} )
		EndIF
		aAdd( aExp, {'GPE_DATA_EXPERIENCIA2'	,	SRA->RA_VCTEXP2											, "SRA->RA_VCTEXP2"			,STR0245	} )
		aAdd( aExp, {'GPE_DIA_EXPERIENCIA2' 	,	Day2Str( SRA->RA_VCTEXP2 )					, "@!"						,STR0246	} )
		aAdd( aExp, {'GPE_MES_EXPERIENCIA2'		,	Month2Str( SRA->RA_VCTEXP2 )					, "@!"						,STR0247	} )
		aAdd( aExp, {'GPE_ANO_EXPERIENCIA2'		,	Year2Str( SRA->RA_VCTEXP2 ) 					, "@!"						,STR0248	} )
		IF .NOT.( Empty( SRA->RA_VCTEXP2 ) )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2'		,LTrim(Str(SRA->(RA_VCTEXP2-RA_VCTOEXP)))			, "@!"						,STR0249	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2_EXTENSO',DiasExtenso(SRA->(RA_VCTEXP2-RA_VCTOEXP))			, "@!"						,STR0249 + " Extenso"	} )
		Else
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2'		,LTrim(Str(0)) , "@!",STR0249	} )
			aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2_EXTENSO',DiasExtenso(0), "@!",STR0249 + " Extenso"	} )
		EndIF
		aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI											, "SRA->RA_EXAMEDI"			,STR0060	} )
	EndIf
	
	
	aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'		, 	SRA->RA_BCDEPSA											, "SRA->RA_BCDEPSA"			,STR0061	} )
	aAdd( aExp, {'GPE_DESC_BCO_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")					, "@!"						,STR0062	} )
	aAdd( aExp, {'GPE_DESC_AGE_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")				, "@!"						,STR0063	} )
	aAdd( aExp, {'GPE_CTA_DEP_SAL'			,	SRA->RA_CTDEPSA											, "SRA->RA_CTDEPSA"			,STR0064	} )
	aAdd( aExp, {'GPE_BCO_AG_FGTS'			,	SRA->RA_BCDPFGT											, "SRA->RA_BCDPFGT"			,STR0065	} )
	aAdd( aExp, {'GPE_DESC_BCO_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")					, "@!"						,STR0066	} )
	aAdd( aExp, {'GPE_DESC_AGE_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")				, "@!"						,STR0067	} )
	aAdd( aExp, {'GPE_CTA_Dep_FGTS'			,	SRA->RA_CTDPFGT											, "SRA->RA_CTDPFGT"			,STR0068	} )
	aAdd( aExp, {'GPE_SIT_FOLHA'	  		,	SRA->RA_SITFOLH											, "SRA->RA_SITFOLH"			,STR0069	} )
	aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  		,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")			, "@!"						,STR0070	} )
	aAdd( aExp, {'GPE_HRS_MENSAIS'			,	SRA->RA_HRSMES											, "SRA->RA_HRSMES"			,STR0071	} )
	aAdd( aExp, {'GPE_HRS_SEMANAIS'			,	SRA->RA_HRSEMAN											, "SRA->RA_HRSEMAN"			,STR0072	} )
	aAdd( aExp, {'GPE_CHAPA'		  		,	SRA->RA_CHAPA											, "SRA->RA_CHAPA"			,STR0073	} )
	aAdd( aExp, {'GPE_TURNO_TRAB'	 		,	SRA->RA_TNOTRAB											, "SRA->RA_TNOTRAB"			,STR0074	} )
	aAdd( aExp, {'GPE_DESC_TURNO'	  		,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC')					, "@!"						,STR0075	} )
	aAdd( aExp, {'GPE_COD_FUNCAO'	 		,	SRA->RA_CODFUNC											, "SRA->RA_CODFUNC"			,STR0076 	} )
	aAdd( aExp, {'GPE_DESC_FUNCAO'			,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC')					, "@!"						,STR0077	} )
	aAdd( aExp, {'GPE_CBO'			   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)		, "@!"				        ,STR0078	} )
	aAdd( aExp, {'GPE_CONT_SINDIC'			,	SRA->RA_PGCTSIN											, "SRA->RA_PGCTSIN"			,STR0079	} )
	aAdd( aExp, {'GPE_COD_SINDICATO'		,	SRA->RA_SINDICA											, "SRA->RA_SINDICA"			,STR0080	} )
	aAdd( aExp, {'GPE_DESC_SINDICATPO'		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) ), "@!"						,STR0081	} )
	aAdd( aExp, {'GPE_COD_ASS_MEDICA'		,	SRA->RA_ASMEDIC											, "SRA->RA_ASMEDIC"			,STR0082	} )
	aAdd( aExp, {'GPE_DEP_ASS_MEDICA'		,	SRA->RA_DPASSME											, "SRA->RA_DPASSME"			,STR0083	} )
	aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'		,	SRA->RA_ADTPOSE											, "SRA->RA_ADTPOSE"			,STR0084	} )
	aAdd( aExp, {'GPE_COD_CESTA_BASICA'		,	SRA->RA_CESTAB											, "SRA->RA_CESTAB"			,STR0085	} )
	aAdd( aExp, {'GPE_COD_VALE_REF' 		,	SRA->RA_VALEREF											, "SRA->RA_VALEREF"			,STR0086	} )
	If cPaisLoc $ ("ANG/ARG/BOL/BRA/CHI/COL/EQU/MEX/PER/PTG/URU/")
		aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV											, "SRA->RA_SEGUROV"			,STR0087	} )
	EndIf
	aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT											, "SRA->RA_PERCADT"			,STR0089	} )
	aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC											, "SRA->RA_CATFUNC"			,STR0090	} )
	aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")			, "@!"						,STR0091	} )
	aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(IF(RA_CATFUNC$"H","P/Hora",IF(RA_CATFUNC$"J","P/Aula","P/Mes"))) 			, "@!"						,STR0092	} )
	aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 			, "SRA->RA_TIPOPGT"			,STR0093	} )
	aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")			, "@!"						,STR0094	} )
	aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO											, "SRA->RA_SALARIO"			,STR0095	} )
	If cPaisLoc <> "EQU"
		aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM											, "SRA->RA_ANTEAUM"			,STR0096	} )
	EndIf
	aAdd( aExp, {'GPE_HRS_PERICULO'  		,	SRA->RA_PERICUL											, "SRA->RA_PERICUL"			,STR0099	} )
	aAdd( aExp, {'GPE_HRS_INS_MINIMA'		,	SRA->RA_INSMIN											, "SRA->RA_INSMIN"			,STR0100	} )
	aAdd( aExp, {'GPE_HRS_INS_MEDIA'		,	SRA->RA_INSMED											, "@!"						,STR0101	} )
	aAdd( aExp, {'GPE_HRS_INS_MAXIMA'		,	SRA->RA_INSMAX											, "SRA->RA_INSMAX"			,STR0102	} )
	aAdd( aExp, {'GPE_TIPO_ADMISSAO'		,	SRA->RA_TIPOADM											, "SRA->RA_TIPOADM"			,STR0103	} )
	aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'		,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")			, "@!"						,STR0104	} )
	aAdd( aExp, {'GPE_COD_AFA_FGTS'			,	SRA->RA_AFASFGT											, "SRA->RA_AFASFGT"			,STR0105	} )
	aAdd( aExp, {'GPE_DESC_AFA_FGTS'		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")			, "@!"						,STR0106	} )
	If cPaisLoc <> "PER"
		aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI											, "SRA->RA_VIEMRAI"			,STR0107	} )
		aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+SRA->RA_VIEMRAI,"X5_DESCRI")				, "@!"						,STR0108	} )
	Endif
	aAdd( aExp, {'GPE_COD_INST_RAIS'		,	SRA->RA_GRINRAI											, "SRA->RA_GRINRAI"			,STR0109	} )
	aAdd( aExp, {'GPE_DESC_GRAU_INST'		,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")			, "@!"						,STR0110	} )
	aAdd( aExp, {'GPE_COD_RESC_RAIS'		,	SRA->RA_RESCRAI											, "SRA->RA_RESCRAI"			,STR0111	} )
	aAdd( aExp, {'GPE_CRACHA'		  		,	SRA->RA_CRACHA											, "SRA->RA_CRACHA"			,STR0112	} )
	aAdd( aExp, {'GPE_REGRA_APONTA'			,	SRA->RA_REGRA											, "SRA->RA_REGRA"			,STR0113	} )
	aAdd( aExp, {'GPE_NO_REGISTRO'	 		,	SRA->RA_REGISTR											, "SRA->RA_REGISTR"			,STR0115	} )
	aAdd( aExp, {'GPE_NO_FICHA'	    		,	SRA->RA_FICHA											, "SRA->RA_FICHA"			,STR0116	} )
	aAdd( aExp, {'GPE_TP_CONT_TRAB'			,	SRA->RA_TPCONTR											, "SRA->RA_TPCONTR"			,STR0117	} )
	aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'	,	SRA->(IF(RA_TPCONTR="1","Indeterminado","Determinado")) , "@!"						,STR0118	} )
	aAdd( aExp, {'GPE_APELIDO'		   		,	SRA->RA_APELIDO											, "SRA->RA_APELIDO"			,STR0119	} )
	aAdd( aExp, {'GPE_E-MAIL'		 		,	SRA->RA_EMAIL											, "SRA->RA_EMAIL"			,STR0120	} )
	aAdd( aExp, {'GPE_TEXTO_01'				,	cTexto_01								   				, "@!"						,STR0121	} ) 
	aAdd( aExp, {'GPE_TEXTO_02'				,	cTexto_02												, "@!"						,STR0122	} )
	aAdd( aExp, {'GPE_TEXTO_03'				,	cTexto_03												, "@!"						,STR0123	} )
	aAdd( aExp, {'GPE_TEXTO_04'				,	cTexto_04												, "@!"						,STR0124	} )
	aAdd( aExp, {'GPE_EXTENSO_SAL'			,	Extenso( SRA->RA_SALARIO , .F. , 1 )					, "@!"						,STR0125 	} )
	aAdd( aExp, {'GPE_DDATABASE'			,	dDataBase                    	        				, "" 						,STR0126	} )
	aAdd( aExp, {'GPE_DIA_DDATABASE'		,	Day2Str( dDataBase )            				, "@!"						,STR0127	} )
	aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 								, "@!"						,STR0128	} )
	aAdd( aExp, {'GPE_ANO_DDATABASE'		,	Year2Str( dDataBase )            			, "@!"						,STR0129	} )
	aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	AllTrim(aInfo[03])                     					, "@!"						,STR0130	} )
	aAdd( aExp, {'GPE_END_EMPRESA'			,	AllTrim(aInfo[04])                     					, "@!"						,STR0131	} )
	aAdd( aExp, {'GPE_CID_EMPRESA'			,	AllTrim(aInfo[05])										, "@!"						,STR0132	} )
	aAdd( aExp, {'GPE_CEP_EMPRESA'         	,   AllTrim(aInfo[07])										, "!@R #####-###"          	,STR0034 	} )
	aAdd( aExp, {'GPE_EST_EMPRESA'         	,   AllTrim(aInfo[06])										, "@!"						,STR0032 	} )
	aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	AllTrim(aInfo[08])										, "@R ##.###.###/####-##"	,STR0134	} )
	aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	AllTrim(aInfo[09])										, "@!" 						,STR0135	} )
	aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	AllTrim(aInfo[10])                     					, "@!" 						,STR0136	} )
	aAdd( aExp, {'GPE_FAX_EMPRESA'         	,   If(aInfo[11]#nil ,AllTrim(aInfo[11]), "        ")      	, "@!"                     	,STR0136 	} )
	aAdd( aExp, {'GPE_BAI_EMPRESA'			,	AllTrim(aInfo[13])										, "@!" 						,STR0137	} )
	aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")			, "@!" 						,STR0138	} )
	aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	Day2Str( SRA->RA_DEMISSA )					, "@!" 						,STR0139	} )
	aAdd( aExp, {'GPE_MES_DEMISSAO'			,	Month2Str( SRA->RA_DEMISSA )					, "@!" 						,STR0140 	} )
	aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	Year2Str( SRA->RA_DEMISSA )					, "@!" 						,STR0141 	} )
	If cPaisLoc == "BRA"
		aAdd( aExp, {'GPE_RG_EMISSAO'			,	SRA->RA_DTRGEXP											, "SRA->RA_DTRGEXP"       	,STR0242	} )
		aAdd( aExp, {'GPE_CTPS_EMISSAO'			,	SRA->RA_DTCPEXP											, "SRA->RA_DTCPEXP"       	,STR0243	} )
	EndIf
	aAdd( aExp, {'GPE_FUNC_COR'				,	If( SRA->RA_RACACOR == "1" , "Indígena" , ( If( SRA->RA_RACACOR == "2" , "Branca" , ( If( SRA->RA_RACACOR == "4" , "Negra" , ( If( SRA->RA_RACACOR == "6" , "Amarela" , ( If( SRA->RA_RACACOR == "8" , "Parda" , "Não informado" ) ) ) ) ) ) ) ) ) 											, "@!"       	,STR0244	} )
	//Periodo Aquisitivo de Ferias
	
	IF cPaisLoc == "COL"
	   aAdd( aExp, {'GPE_DIA_INIFERIAS'           ,   if(Len(aPerSRF) > 0,Day2Str( aPerSRF[1,1] ),space(02))   , "@!"		,STR0188 	} )
	   aAdd( aExp, {'GPE_MES_INIFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,1] ),space(12)) , "@!"    ,STR0189 	} )
	   aAdd( aExp, {'GPE_ANO_INIFERIAS'           ,   if(Len(aPerSRF) > 0,Year2Str( aPerSRF[1,1]) ,space(04))  , "@!"		,STR0190 	} )
	   
	   aAdd( aExp, {'GPE_DIA_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,Day2Str( aPerSRF[1,2] ),space(02))   , "@!"		,STR0191 	} )
	   aAdd( aExp, {'GPE_MES_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,2] ),space(12)) , "@!"    ,STR0192 	} )
	   aAdd( aExp, {'GPE_ANO_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,Year2Str( aPerSRF[1,2] ),space(04))  , "@!"		,STR0193 	} )
	ENDIF   
	
	//SALARIO FAMILIA//
	aAdd( aExp, {'GPE_CFILHO01'            	,   if(lDepen1or3,aDepenSF[1,1],space(30))		, "@!"						,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL01'              	,   if(lDepen1or3,aDepenSF[1,2],space(08))		, ""						,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO02'            	,   if(lDepen1or3,aDepenSF[2,1],space(30))		, "@!"						,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL02'              	,   if(lDepen1or3,aDepenSF[2,2],space(08))		, ""						,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO03'            	,   if(lDepen1or3,aDepenSF[3,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL03'              	,   if(lDepen1or3,aDepenSF[3,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO04'            	,   if(lDepen1or3,aDepenSF[4,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL04'              	,   if(lDepen1or3,aDepenSF[4,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO05'            	,   if(lDepen1or3,aDepenSF[5,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL05'              	,   if(lDepen1or3,aDepenSF[5,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO06'            	,   if(lDepen1or3,aDepenSF[6,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL06'              	,   if(lDepen1or3,aDepenSF[6,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO07'            	,   if(lDepen1or3,aDepenSF[7,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL07'              	,   if(lDepen1or3,aDepenSF[7,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO08'            	,   if(lDepen1or3,aDepenSF[8,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL08'              	,   if(lDepen1or3,aDepenSF[8,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO09'            	,   if(lDepen1or3,aDepenSF[9,1],space(30))		, "@!"                      ,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL09'              	,   if(lDepen1or3,aDepenSF[9,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_CFILHO10'            	,   if(lDepen1or3,aDepenSF[10,1],space(30))		, "@!"                    	,STR0150 	} )
	aAdd( aExp, {'GPE_DTFL10'              	,   if(lDepen1or3,aDepenSF[10,2],space(08))		, ""                        ,STR0151 	} )
	aAdd( aExp, {'GPE_DESC_ESTEMP'         	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      		, "@!"                     	,STR0134 	} ) 
	aAdd( aExp, {'GPE_cGrau01'				,	if(lDepen1or3,aDepenSF[1,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau02'				,	if(lDepen1or3,aDepenSF[2,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau03'				,	if(lDepen1or3,aDepenSF[3,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau04'				,	if(lDepen1or3,aDepenSF[4,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau05'				,	if(lDepen1or3,aDepenSF[5,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau06'				,	if(lDepen1or3,aDepenSF[6,3],space(10))		, "@!"						,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau07'				,	if(lDepen1or3,aDepenSF[7,3],space(10))		, "@!"						,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau08'				,	if(lDepen1or3,aDepenSF[8,3],space(10))		, "@!"						,STR0153 	} )
	aAdd( aExp, {'GPE_cGrau09'				,	if(lDepen1or3,aDepenSF[9,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_cGrau10'				,	if(lDepen1or3,aDepenSF[10,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_LOCAL01'				,	if(lDepen1or3,aDepenSF[1,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO01'			,	if(lDepen1or3,aDepenSF[1,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO01'			,	if(lDepen1or3,aDepenSF[1,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO01'				,	if(lDepen1or3,aDepenSF[1,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA01'				,	if(lDepen1or3,aDepenSF[1,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(lDepen1or3,aDepenSF[1,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(lDepen1or3,aDepenSF[1,10],space(10))		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL02'				,	if(lDepen1or3,aDepenSF[2,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO02'			,	if(lDepen1or3,aDepenSF[2,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO02'			,	if(lDepen1or3,aDepenSF[2,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO02'				,	if(lDepen1or3,aDepenSF[2,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA02'				,	if(lDepen1or3,aDepenSF[2,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(lDepen1or3,aDepenSF[2,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(lDepen1or3,aDepenSF[2,10],space(10))		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL03'				,	if(lDepen1or3,aDepenSF[3,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO03'			,	if(lDepen1or3,aDepenSF[3,5],space(10))	 	, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO03'			,	if(lDepen1or3,aDepenSF[3,6],space(10))	 	, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO03'				,	if(lDepen1or3,aDepenSF[3,7],space(10))	 	, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA03'				,	if(lDepen1or3,aDepenSF[3,8],space(10))	 	, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(lDepen1or3,aDepenSF[3,9],space(10))	 	, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(lDepen1or3,aDepenSF[3,10],space(10))  	, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL04'				,	if(lDepen1or3,aDepenSF[4,4],space(10))	 	, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO04'			,	if(lDepen1or3,aDepenSF[4,5],space(10))	 	, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO04'			,	if(lDepen1or3,aDepenSF[4,06],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO04'				,	if(lDepen1or3,aDepenSF[4,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA04'				,	if(lDepen1or3,aDepenSF[4,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(lDepen1or3,aDepenSF[4,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(lDepen1or3,aDepenSF[4,10],space(10)) 		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL05'				,	if(lDepen1or3,aDepenSF[5,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO05'			,	if(lDepen1or3,aDepenSF[5,5],space(10))		, "@!"						,STR0156 	} )
	aAdd( aExp, {'GPE_NREGISTRO05'			,	if(lDepen1or3,aDepenSF[5,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO05'				,	if(lDepen1or3,aDepenSF[5,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA05'				,	if(lDepen1or3,aDepenSF[5,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(lDepen1or3,aDepenSF[5,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(lDepen1or3,aDepenSF[5,10],space(10))		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL06'				,	if(lDepen1or3,aDepenSF[6,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO06'			,	if(lDepen1or3,aDepenSF[6,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO06'			,	if(lDepen1or3,aDepenSF[6,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO06'				,	if(lDepen1or3,aDepenSF[6,7],space(10))	    , "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA06'				,	if(lDepen1or3,aDepenSF[6,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(lDepen1or3,aDepenSF[6,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(lDepen1or3,aDepenSF[6,10],space(10))		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL07'				,	if(lDepen1or3,aDepenSF[7,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO07'			,	if(lDepen1or3,aDepenSF[7,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO07'			,	if(lDepen1or3,aDepenSF[7,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO07'				,	if(lDepen1or3,aDepenSF[7,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA07'				,	if(lDepen1or3,aDepenSF[7,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(lDepen1or3,aDepenSF[7,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(lDepen1or3,aDepenSF[7,10],space(10)) 		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL08'				,	if(lDepen1or3,aDepenSF[8,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO08'			,	if(lDepen1or3,aDepenSF[8,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO08'			,	if(lDepen1or3,aDepenSF[8,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO08'				,	if(lDepen1or3,aDepenSF[8,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA08'				,	if(lDepen1or3,aDepenSF[8,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(lDepen1or3,aDepenSF[8,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(lDepen1or3,aDepenSF[8,10],space(10)) 		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL09'				,	if(lDepen1or3,aDepenSF[9,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO09'			,	if(lDepen1or3,aDepenSF[9,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO09'			,	if(lDepen1or3,aDepenSF[9,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO09'				,	if(lDepen1or3,aDepenSF[9,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA09'				,	if(lDepen1or3,aDepenSF[9,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(lDepen1or3,aDepenSF[9,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(lDepen1or3,aDepenSF[9,10],space(10))		, "@!"						,STR0161 	} ) 
	aAdd( aExp, {'GPE_LOCAL10'				,	if(lDepen1or3,aDepenSF[10,4],space(10))		, "@!"						,STR0164 	} ) 
	aAdd( aExp, {'GPE_CARTORIO10'			,	if(lDepen1or3,aDepenSF[10,5],space(10))		, "@!"						,STR0156 	} ) 
	aAdd( aExp, {'GPE_NREGISTRO10'			,	if(lDepen1or3,aDepenSF[10,6],space(10))		, "@!"						,STR0165 	} ) 
	aAdd( aExp, {'GPE_NLIVRO10'				,	if(lDepen1or3,aDepenSF[10,7],space(10))		, "@!"						,STR0158 	} ) 
	aAdd( aExp, {'GPE_NFOLHA10'				,	if(lDepen1or3,aDepenSF[10,8],space(10))		, "@!"						,STR0159 	} ) 
	aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(lDepen1or3,aDepenSF[10,9],space(10))		, "@!"						,STR0160 	} ) 
	aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(lDepen1or3,aDepenSF[10,10],space(10))		, "@!"						,STR0161 	} ) 
	//IMPOSTO DE RENDA//
	aAdd( aExp, {'GPE_CDEPE01'             	,   if(lDepen2or3,aDepenIR[1,1],space(30))		, "@!"						,STR0154   	} )
	aAdd( aExp, {'GPE_cGrDp01'				,	if(lDepen2or3,aDepenIR[1,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR01'            	,   if(lDepen2or3,aDepenIR[1,2],space(08)) 		, ""						,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE02'				,	if(lDepen2or3,aDepenIR[2,1],space(30))		, "@!" 						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp02'				,	if(lDepen2or3,aDepenIR[2,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR02'            	,   if(lDepen2or3,aDepenIR[2,2],space(08))		, ""						,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE03'				,	if(lDepen2or3,aDepenIR[3,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp03'				,	if(lDepen2or3,aDepenIR[3,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR03'            	,   if(lDepen2or3,aDepenIR[3,2],space(08)) 		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE04'				,	if(lDepen2or3,aDepenIR[4,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp04'				,	if(lDepen2or3,aDepenIR[4,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR04'            	,   if(lDepen2or3,aDepenIR[4,2],space(08)) 		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE05'				,	if(lDepen2or3,aDepenIR[5,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp05'				,	if(lDepen2or3,aDepenIR[5,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR05'            	,   if(lDepen2or3,aDepenIR[5,2],space(08))		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE06'				,	if(lDepen2or3,aDepenIR[6,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp06'				,	if(lDepen2or3,aDepenIR[6,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR06'				,   if(lDepen2or3,aDepenIR[6,2],space(08)) 		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE07'				,	if(lDepen2or3,aDepenIR[7,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp07'				,	if(lDepen2or3,aDepenIR[7,3],space(10))		, "@!"						,STR0153	} ) 
	aAdd( aExp, {'GPE_DTFLIR07'            	,   if(lDepen2or3,aDepenIR[7,2],space(08))		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE08'				,	if(lDepen2or3,aDepenIR[8,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp08'				,	if(lDepen2or3,aDepenIR[8,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR08'            	,   if(lDepen2or3,aDepenIR[8,2],space(08)) 		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE09'				,	if(lDepen2or3,aDepenIR[9,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp09'				,	if(lDepen2or3,aDepenIR[9,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR09'            	,   if(lDepen2or3,aDepenIR[9,2],space(08)) 		, ""                        ,STR0163 	} )
	aAdd( aExp, {'GPE_CDEPE10'				,	if(lDepen2or3,aDepenIR[10,1],space(30))		, "@!"						,STR0154 	} )
	aAdd( aExp, {'GPE_cGrDp10'				,	if(lDepen2or3,aDepenIR[10,3],space(10))		, "@!"						,STR0153 	} ) 
	aAdd( aExp, {'GPE_DTFLIR10'            	,   if(lDepen2or3,aDepenIR[10,2],space(08))		, ""                        ,STR0163 	} )
	
	If cPaisLoc == "ARG"
		aAdd( aExp, {'GPE_MES_ADEXT'		    ,	MesExtenso( Month( SRA->RA_ADMISSA ) )					    , "@!"						,STR0155	} )
		aAdd( aExp, {'GPE_APODERADO'		    ,	cApoderado												    , "@!"						,STR0156	} )
		aAdd( aExp, {'GPE_ATIVIDADE'		    ,	cRamoAtiv												    , "@!"						,STR0157	} )
	EndIf	
	
	aAdd( aExp, {'GPE_MUNICNASC'           	,   if(SRA->(FieldPos("RA_MUNNASC")) # 0  ,SRA->RA_MUNNASC,space(20)), "@!"                    ,STR0166 	} )
	If SRA->(FieldPos("RA_PROCES" )) # 0
		aAdd( aExp, {'GPE_PROCES'	,	SRA->RA_PROCES	,	"SRA->RA_PROCES"	,STR0173 	} )	//Codigo do Processo
	EndIf
	
	If SRA->(FieldPos("RA_DEPTO"  )) # 0                                                                         
		aAdd( aExp, {'GPE_DEPTO'		,	SRA->RA_DEPTO	,	"SRA->RA_DEPTO"		,STR0181 	} )	//Codigo do Departamento
		cDescDepto	:= Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_DESCRIC")
		aAdd( aExp, {'GPE_DESC_DEPTO',cDescDepto,"SQB->QB_DESCRIC","Descricao do Departamento"} )	//Descricao do Departamento
	EndIf
	
	If SRA->(FieldPos("RA_POSTO"  )) # 0
		aAdd( aExp, {'GPE_POSTO'	,	SRA->RA_POSTO  ,	"SRA->RA_POSTO"		,STR0182 	} )	//Codigo do Posto
	EndIf
	
	If cPaisLoc == "MEX"
	
		cCodMunLP  := POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_MUNIC")
		cCodReqFun := POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_DESCREQ")
		
		aAdd( aExp, {'GPE_PRINOME'	, SRA->RA_PRINOME	,												"SRA->RA_PRINOME"	,STR0169	} ) 	//Primeiro Nome 
		aAdd( aExp, {'GPE_SECNOME'	, SRA->RA_SECNOME	,												"SRA->RA_SECNOME"	,STR0170	} ) 	//Segundo Nome
		aAdd( aExp, {'GPE_PRISOBR'	, SRA->RA_PRISOBR	,												"SRA->RA_PRISOBR"	,STR0171	} ) 	//Primeiro Sobrenome
		aAdd( aExp, {'GPE_SECSOBR'	, SRA->RA_SECSOBR	,												"SRA->RA_SECSOBR"	,STR0172	} ) 	//Segundo Sobrenome
		aAdd( aExp, {'GPE_KEYLOC'	, SRA->RA_KEYLOC	,												"SRA->RA_KEYLOC"	,STR0174	} ) 	//Codigo Local de Pagamento
		aAdd( aExp, {'GPE_TSIMSS'	, SRA->RA_TSIMSS	,												"SRA->RA_TSIMSS"	,STR0175	} ) 	//Tipo de Salario IMSS
		aAdd( aExp, {'GPE_TEIMSS'	, SRA->RA_TEIMSS	,												"SRA->RA_TEIMSS"	,STR0176	} ) 	//Tipo de Empregado IMSS
		aAdd( aExp, {'GPE_TJRNDA'	, SRA->RA_TJRNDA	,												"SRA->RA_TJRNDA"	,STR0177	} ) 	//Tipo de Jornada IMSS
		aAdd( aExp, {'GPE_FECREI'	, SRA->RA_FECREI	,												"SRA->RA_FECREI"	,STR0178	} ) 	//Data de Readmissao
		aAdd( aExp, {'GPE_DTBIMSS'	, SRA->RA_DTBIMSS	,						  						"SRA->RA_DTBIMSS"	,STR0179	} ) 	//Data de Baixa IMSS
		aAdd( aExp, {'GPE_CODRPAT'	, SRA->RA_CODRPAT	,						  						"SRA->RA_CODRPAT"	,STR0180	} ) 	//Codigo do Registro Patronal
		aAdd( aExp, {'GPE_CURP'		, SRA->RA_CURP	,						  							"SRA->RA_CURP"		,STR0183	} ) 	//CURP
		aAdd( aExp, {'GPE_TIPINF'	, SRA->RA_TIPINF	,  						  						"SRA->RA_TIPINF"	,STR0184	} ) 	//Tipo de Infonavit
		aAdd( aExp, {'GPE_VALINF'	, SRA->RA_VALINF	,						   						"SRA->RA_VALINF"	,STR0185	} ) 	//Valor do Infonavit
		aAdd( aExp, {'GPE_NUMINF'	, SRA->RA_NUMINF	,						   						"SRA->RA_NUMINF"	,STR0186	} ) 	//Nro. de Credito Infonavit
		aAdd( aExp, {'GPE_IDADE'	, cValToChar(Year(DDATABASE)-Year(SRA->RA_NASC))	,				"!@"				,STR0335	} ) 	//Idade
		aAdd( aExp, {'GPE_REQFUNC'	, MSMM(cCodReqFun,80),												"!@"				,STR0334	} )		//Requisitos da Funcao
		aAdd( aExp, {'GPE_DESCMUNIC', POSICIONE("VAM",1,cVAMFilial+SRA->RA_MUNICIP,"VAM_DESCID"),	"!@"				,STR0031	} ) 	//Descricao do Municipio
	
		//Campos da Localidade de Pagamento
		aAdd( aExp, {'GPE_DESCLP',		POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_DESLOC"),	"RGC->RGC_DESLOC"	,STR0216	} )		//Descricao do Local de Pagamento
		aAdd( aExp, {'GPE_ENDERECOLP',	POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_ENDER"),	"RGC->RGC_ENDER"	,STR0328	} )		//Endereco da Localidade de Pagamento
		aAdd( aExp, {'GPE_BAIRROLP',	POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_BAIRRO"),	"RGC->RGC_BAIRRO"	,STR0329	} )		//Bairro da Localidade de Pagamento
		aAdd( aExp, {'GPE_CIDADELP',	POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_CIDADE"),	"RGC->RGC_CIDADE"	,STR0330	} )		//Cidade da Localidade de Pagamento
		aAdd( aExp, {'GPE_ESTADOLP',	POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_ESTADO"),	"RGC->RGC_ESTADO"	,STR0331	} )		//Estado da Localidade de Pagamento
		aAdd( aExp, {'GPE_CEPLP',		POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_CODPOS"),	"RGC->RGC_CODPOS"	,STR0333	} )		//CEP da Localidade de Pagamento
		aAdd( aExp, {'GPE_DESCMUNICLP',	POSICIONE("VAM",1,cVAMFilial+cCodMunLP,"VAM_DESCID"), 	"!@"					,STR0332	} )		//Municipio da Localidade de Pagamento
	
	EndIf    
	
	If getRpoRelease() >= "R7" .OR. cPaisLoc $ "COS/DOM"
		aAdd( aExp, {'GPE_DISTEMP'	,	POSICIONE("CC2",1,cCC2Filial+SRA->RA_ESTADO+SRA->RA_MUNICIP,"CC2_MUN")			,	"CC2->CC2_MUN"		,STR0220	} )//"Descripción del distrito"
	EndIf   
	
	If cPaisLoc == "COS" 
	
		cDESMTSS:=getQuery(	" SELECT SubStrING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S006' AND SubStrING(RCC_CONTEU,1,4)= '"+POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODMTSS")+"'")
		cDESCCSS:=getQuery(	" SELECT SubStrING(RCC_CONTEU,5,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S007' AND SubStrING(RCC_CONTEU,1,4)= '"+POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODCCSS")+"'")
		cDESINS:=getQuery ( " SELECT SubStrING(RCC_CONTEU,6,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S008' AND SubStrING(RCC_CONTEU,1,5)= '"+POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODINS")+"'")
		cDESCAN:=getQuery ( " SELECT SubStrING(RCC_CONTEU,6,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S013' AND SubStrING(RCC_CONTEU,1,5)= '"+SRA->RA_MUNICIP+"'")
		cDESCIC:=getQuery ( " SELECT SubStrING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S014' AND SubStrING(RCC_CONTEU,1,4)= '"+SRA->RA_TPCIC+"'")
		cDESJOR:=getQuery ( " SELECT SubStrING(RCC_CONTEU,5,100) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S021' AND SubStrING(RCC_CONTEU,1,2)= '"+SRA->RA_TJRNDA+"'")
		cDESFON:=getQuery ( " SELECT SubStrING(RCC_CONTEU,5,40)  CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S004' AND SubStrING(RCC_CONTEU,1,4)= '"+SRA->RA_FONSOL+"'")
	
		aAdd( aExp, {'GPE_CODRPAT'	,	SRA->RA_CODRPAT														,	"SRA->RA_CODRPAT"	,STR0180	} )//Codigo do Registro Patronal
		aAdd( aExp, {'GPE_NRPAT'	,	POSICIONE("RCO",1,cRCOFilial+SRA->RA_CODRPAT,"RCO_NREPAT")		,	"RCO->RCO_NREPAT"	,STR0207	} )//Codigo do Registro Patronal
		aAdd( aExp, {'GPE_POLRT'	,	POSICIONE("RCO",1,cRCOFilial+SRA->RA_CODRPAT,"RCO_POLRT")		,	"RCO->RCO_POLRT"	,STR0208	} )//"Número de Póliza para MTSS"
		aAdd( aExp, {'GPE_SUCCSS'	,	POSICIONE("RCO",1,cRCOFilial+SRA->RA_CODRPAT,"RCO_SUCCSS")		,	"RCO->RCO_SUCCSS"	,STR0209	} )//"Número de Sucursal del CCSS"
		aAdd( aExp, {'GPE_CODMTSS'	,	POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODMTSS")		,	"SRJ->RJ_CODMTSS"	,STR0210	} )//"Código Ocupación MTSS"
		aAdd( aExp, {'GPE_CODCCSS'	,	POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODCCSS")		,	"SRJ->RJ_CODCCSS"	,STR0211	} )//"Código Ocupación CCSS"
		aAdd( aExp, {'GPE_CODCINS'	,	POSICIONE("SRJ",1,cSRJFilial+SRA->RA_CODFUNC,"RJ_CODINS")		,	"SRJ->RJ_CODINS"	,STR0212	} )//"Código Ocupación INS"
		aAdd( aExp, {'GPE_DESMTSS'	,	cDESMTSS															,	"!@             "	,STR0213	} )//"Descripción de código Ocupación MTSS"
		aAdd( aExp, {'GPE_DESCCSS'	,	cDESCCSS															,	"!@            "	,STR0214	} )//"Descripción de código Ocupación CCSS"
		aAdd( aExp, {'GPE_DESINS'	,	cDESINS																,	"!@            "	,STR0215	} )//"Descripción de código Ocupación INS" 	
		aAdd( aExp, {'GPE_KEYLOC'	,	SRA->RA_KEYLOC														,	"SRA->RA_KEYLOC"	,STR0174	} )//Codigo Local de Pagamento
		aAdd( aExp, {'GPE_DESLOC'	,	POSICIONE("RGC",1,cRGCFilial+SRA->RA_KEYLOC,"RGC_DESLOC")		,	"RGC->RGC_DESLOC"	,STR0216	} )//"Descripción Localidad de Pago"
		aAdd( aExp, {'GPE_TNOTRAB'	,	SRA->RA_TNOTRAB														,	"SRA->RA_TNOTRAB"	,STR0217	} )//"Turno Trabajado"
		aAdd( aExp, {'GPE_HRDIA'	,	POSICIONE("SR6",1,cSR6Filial+SRA->RA_TNOTRAB,"R6_HRDIA")		,	"SR6->R6_HRDIA"		,STR0218	} )//"Horas por Día"
		aAdd( aExp, {'GPE_BAIRROEMP',	SRA->RA_BAIRRO														,	"SRA->RA_BAIRRO"	,STR0219	} )//"Distrito donde vive el trabajador"
		aAdd( aExp, {'GPE_PRINOME'	,	SRA->RA_PRINOME														,	"SRA->RA_PRINOME"	,STR0169	} )//Primeiro Nome 
		aAdd( aExp, {'GPE_SECNOME'	,	SRA->RA_SECNOME														,	"SRA->RA_SECNOME"	,STR0170	} )//Segundo Nome
		aAdd( aExp, {'GPE_PRISOBR'	,	SRA->RA_PRISOBR														,	"SRA->RA_PRISOBR"	,STR0171	} )//Primeiro Sobrenome
		aAdd( aExp, {'GPE_SECSOBR'	,	SRA->RA_SECSOBR														,	"SRA->RA_SECSOBR"	,STR0172	} )//Segundo Sobrenome
		aAdd( aExp, {'GPE_CANTEMP'	,	SRA->RA_MUNICIP														,	"SRA->RA_MUNICIP"	,STR0221	} )//"Cantón donde vive el Trabajador"
		aAdd( aExp, {'GPE_DESCCANEMP'	,cDESCAN															,	"!@             "	,STR0222	} )//"Descripción del cantón donde vive el Trabjador"
		aAdd( aExp, {'GPE_PROVEMP'	,	SRA->RA_ESTADO														,	"SRA->RA_ESTADO"	,STR0223	} )//"Provincia donde vive el Trabjador"
		aAdd( aExp, {'GPE_TIPOFIN'	,	SRA->RA_TIPOFIN														,	"SRA->RA_TIPOFIN"	,STR0225	} )//"Tipo de Baja de Acuerdo a la Empresa"
		aAdd( aExp, {'GPE_IDENEMP'	,	cDESCIC																,	"SRA->RA_CIC"	,	STR0226		} )//"Tipo número de identificación"
		aAdd( aExp, {'GPE_SEGSOC'	,	SRA->RA_RG															,	"SRA->RA_RG"	,	STR0227		} )//"Número de Seguridad Social"
		aAdd( aExp, {'GPE_DESTIPJOR',	cDESJOR																,	"!@            "	,STR0228	} )//"Descripción Jornada"
		aAdd( aExp, {'GPE_FECAUM'	,	SRA->RA_FECAUM														,	"SRA->RA_FECAUM"	,STR0229	} )//"Fecha de Modificación de Salario"
		aAdd( aExp, {'GPE_DOMICIL'	,	SRA->RA_DOMICIL														,	"SRA->RA_DOMICIL"	,STR0230	} )//"Extranjero viviendo en el Pais(1=Si; 2=No"
		aAdd( aExp, {'GPE_MOEDAPG'	,	SRA->RA_MOEDAPG														,	"SRA->RA_MOEDAPG"	,STR0231	} )//Tipo de Moneda para el salario en contrato (1=Local, 2=Dólares)
		aAdd( aExp, {'GPE_FONSOL'	,	SRA->RA_FONSOL 														,	"SRA->RA_FONSOL"	,STR0232	} )//"Asociación Solidarista"
		
		aAdd( aExp, {'GPE_DESFONSOL',	cDESFON																,	"!@            "	,STR0233	} )//"Descripción Asociación Solidarista"
		aAdd( aExp, {'GPE_TPCCSS'	,	SRA->RA_TPCCSS														,	"SRA->RA_TPCCSS"	,STR0234	} )//"Clase Seguro"
		aAdd( aExp, {'GPE_NSEGURO'	,	SRA->RA_NSEGURO														,	"SRA->RA_NSEGURO"	,STR0235	} )//"Número Asegurado"	
		aAdd( aExp, {'GPE_GROSSUP'	,	SRA->RA_GROSSUP														,	"SRA->RA_GROSSUP"	,STR0236	} )//"Tipo de Gross Up de Salario"
		aAdd( aExp, {'GPE_ANTEAUM'	,	SRA->RA_ANTEAUM														,	"SRA->RA_ANTEAUM"	,STR0237	} )//"Salario Anterior"	
	
	EndIf
	
	If cPaisLoc == "ANG"
		aAdd( aExp, {'GPE_BIDENT'	     ,	SRA->RA_BIDENT                                	, "SRA->RA_BIDENT"	,STR0195	} ) //Nr. Bilhete Identidade
		aAdd( aExp, {'GPE_BIEMISS'	     ,	SRA->RA_BIEMISS                             	, "SRA->RA_BIEMISS"	,STR0196	} )	//Data de Emissão do Bilhete Identidade
	    aAdd( aExp, {'GPE_ESTADO'		 ,  Alltrim(fDescRCC("S001",SRA->RA_ESTADO,1,2,3,30))  , "SRA->RA_ESTADO"	,STR0032	} ) // Descrição do Distrito
	EndIf
	
	aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"	,STR0194	} ) //Descrição do Estado Civil
	    
	If SRA->RA_CATFUNC $ "I*J"
		
		aRet := fTarProf()
		
		//Inclusao de variaveis contendo as tarefas fixas e aditamentos fixos dos professores
		aAdd( aExp, {'GPE_DESC_TAR_01'      	,   aRet[1,1], "@!"				, STR0197 	} ) // "Descrição da primeira tarefa"
		aAdd( aExp, {'GPE_AULS_TAR_01'         	,   aRet[1,2], "SRO->RO_QTDSEM"	, STR0198 	} ) // "Aulas por semana da primeira tarefa"
		aAdd( aExp, {'GPE_QTD_TAR_01'         	,   aRet[1,3], "SRO->RO_QUANT"	, STR0199 	} ) // "Quantidade da primeira tarefa"
		aAdd( aExp, {'GPE_VUNI_TAR_01'         	,   aRet[1,4], "SRO->RO_VALOR"	, STR0200 	} ) // "Valor unitário da primeira tarefa"
		aAdd( aExp, {'GPE_VTOT_TAR_01'         	,   aRet[1,5], "SRO->RO_VALTOT"	, STR0201	} ) // "Valor total da primeira tarefa"
		
		aAdd( aExp, {'GPE_DESC_TAR_02'         	,   aRet[2,1], "@!"          	, STR0202 	} ) // "Descrição da segunda tarefa"
		aAdd( aExp, {'GPE_AULS_TAR_02'         	,   aRet[2,2], "SRO->RO_QTDSEM"	, STR0203 	} ) // "Aulas por semana da segunda tarefa"
		aAdd( aExp, {'GPE_QTD_TAR_02'         	,   aRet[2,3], "SRO->RO_QUANT"	, STR0204 	} ) // "Quantidade da segunda tarefa"
		aAdd( aExp, {'GPE_VUNI_TAR_02'         	,   aRet[2,4], "SRO->RO_VALOR"	, STR0205 	} ) // "Valor unitário da segunda tarefa"
		aAdd( aExp, {'GPE_VTOT_TAR_02'         	,   aRet[2,5], "SRO->RO_VALTOT"	, STR0206 	} ) // "Valor total da segunda tarefa"
	EndIf
	
	If cPaisLoc == "BRA"    
		//Variaveis criadas para utilizacao no DCN/DMN Documento de Cadastro/Manutencao do NIS - PIS   
	
		cEstCiv :=SRA->RA_ESTCIVI  					//Adequacao do estado civil conforme o leiaute do DCN/DMN - PIS
		Do Case
			Case cEstCiv$"C|M"
				cEstCiv :="CASADO(A)
			Case cEstCiv$"D"
				cEstCiv :="DIVORCIADO(A)
			Case cEstCiv$"Q"
				cEstCiv :="SEPARADO(A)
			Case cEstCiv$"S"
				cEstCiv :="SOLTEIRO(A)
			Case cEstCiv$"V"
				cEstCiv :="VIUVO(A)
		EndCase	
		
	    cTipCertd := SRA->(IF(FieldPos("RA_TIPCERT")>0,RA_TIPCERT,"")) //Adequacao da descricao do certificado civil conforme o leiaute do DCN/DMN - PIS
	    Do Case
	    	Case cTipCertd == "1"
	    		cTipCertd :=OemToAnsi(STR0317)
	    	Case cTipCertd == "2"
	    		cTipCertd :=OemToAnsi(STR0318)
	    	Case cTipCertd == "3"
	    		cTipCertd :=OemToAnsi(STR0317)
	    	Case cTipCertd == "4"
	    		cTipCertd :=OemToAnsi(STR0320)
	    EndCase
	    		
		
		cGrauInstr :=SRA->RA_GRINRAI
		Do Case										//Adequacao da descricao do grau de instrucao conforme o leiaute do DCN/DMN - PIS
			Case cGrauInstr == "10"  
				cGrauInstr := OemToAnsi(STR0295)
			Case cGrauInstr == "20"  
				cGrauInstr := OemToAnsi(STR0296)
			Case cGrauInstr == "25"  
				cGrauInstr := OemToAnsi(STR0297)
			Case cGrauInstr == "30"  
				cGrauInstr := OemToAnsi(STR0298)
			Case cGrauInstr == "35"  
				cGrauInstr := OemToAnsi(STR0299)
			Case cGrauInstr == "40"  
				cGrauInstr := OemToAnsi(STR0300)
			Case cGrauInstr == "45"  
				cGrauInstr := OemToAnsi(STR0301)
			Case cGrauInstr == "50"  
				cGrauInstr := OemToAnsi(STR0302)
			Case cGrauInstr == "55"  
				cGrauInstr := OemToAnsi(STR0303)
			Case cGrauInstr == "65"  
				cGrauInstr := OemToAnsi(STR0304)
			Case cGrauInstr == "75"  
				cGrauInstr := OemToAnsi(STR0305)
			Case cGrauInstr == "85"  
				cGrauInstr := OemToAnsi(STR0306)
			Case cGrauInstr == "95"  
				cGrauInstr := OemToAnsi(STR0307)																											
		EndCase                                     
	
		IF SRA->(FieldPos("RA_BRNASEX")>0)
			aAdd( aExp, {'GPE_NACION_BRASILEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","x",""))))						 	 		,"SRA->RA_BRNASEX"	, STR0250   } ) // "Marca 'x' se Nacionalidade Brasileira"
			aAdd( aExp, {'GPE_NACION_ESTRANGEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","","x"))))))			,"SRA->RA_BRNASEX"	, STR0251   } ) // "Marca 'x' se Nacionalidade Extrangeira"
			aAdd( aExp, {'GPE_NACION_BRA_NATURA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","x",""))))))			,"SRA->RA_BRNASEX"	, STR0252   } ) // "Marca 'x' se Nacionalidade Brasileira Naturalizada"
			aAdd( aExp, {'GPE_NACION_BRA_NASC_EXTE'	,SRA->(IF(RA_BRNASEX$"1","x",""))			 													,"SRA->RA_BRNASEX"	, STR0253   } ) // "Marca 'x' se Nacionalidade Brasileiro Nascido no Exterior"
		EndIF
		aAdd( aExp, {'GPE_EST_CIVIL_DCN'  		,cEstCiv																						,"SRA->RA_ESTCIVI"	, STR0254	} ) // "Estado civil de acordo com o NIS/PIS"
		aAdd( aExp, {'GPE_NOME_PAI_DCN'	   		,SRA->(IF(Empty (SRA->RA_PAI),"IGNORADO",SRA->RA_PAI))											,"SRA->RA_PAI"		, STR0255	} ) // "Nome do Pai, informa IGNORADO caso esteja em branco"
		aAdd( aExp, {'GPE_NOME_MAE_DCN'	   		,SRA->(IF(Empty (SRA->RA_MAE),"IGNORADA",SRA->RA_MAE))											,"SRA->RA_MAE"		, STR0256	} ) // "Nome da Mae, informa IGNORADO caso esteja em branco"
		IF SRA->(FieldPos("RA_COMPLRG")>0)
			aAdd( aExp, {'GPE_COMPLEM_RG'			,SRA->RA_COMPLRG																				,"SRA->RA_COMPLRG"	, STR0257   } ) // "Complemento do RG"
		EndIF
		
		IF SRA->(FieldPos("RA_TIPCERT")>0)
			aAdd( aExp, {'GPE_TIP_CERTID'			,cTipCertd																						,"SRA->RA_TIPCERT"	, STR0258   } ) // "Tipo de Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_EMICERT")>0)
			aAdd( aExp, {'GPE_EMIS_CERTID'			,SRA->RA_EMICERT																				,"SRA->RA_EMICERT"	, STR0259   } ) // "Data de Emissao da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_MATCERT")>0)
			aAdd( aExp, {'GPE_MAT_CERTID'			,SRA->RA_MATCERT																				,"SRA->RA_MATCERT"	, STR0260   } ) // "Termo/Matricula da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_LIVCERT")>0)
			aAdd( aExp, {'GPE_LIVRO_CERT'			,SRA->RA_LIVCERT																				,"SRA->RA_LIVCERT"	, STR0261   } ) // "Livro da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_FOLCERT")>0)
			aAdd( aExp, {'GPE_FOLHA_CERT'			,SRA->RA_FOLCERT																				,"SRA->RA_FOLCERT"	, STR0262   } ) // "Folha da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_CARCERT")>0)
			aAdd( aExp, {'GPE_CART_CERTID'			,SRA->RA_CARCERT																				,"SRA->RA_CARCERT"	, STR0263   } ) // "Cartorio da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_UFCERT")>0)
			aAdd( aExp, {'GPE_UF_CERTIDAO'			,SRA->RA_UFCERT			 																		,"SRA->RA_UFCERT"	, STR0264   } ) // "UF da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_UFCERT")>0 .and. FieldPos("RA_CDMUCER")>0)
			aAdd( aExp, {'GPE_MUN_CERTIDAO'			,fDesc("CC2",SRA->RA_UFCERT+SRA->RA_CDMUCER,"CC2_MUN")											,"SRA->RA_MUNCERT"	, STR0265   } ) // "Municipio da Certidao Civil"
		EndIF
		IF SRA->(FieldPos("RA_NUMEPAS")>0)
			aAdd( aExp, {'GPE_NUM_PASSAPOR'			,SRA->RA_NUMEPAS																				,"SRA->RA_NUMEPAS"	, STR0266   } ) // "Numero do Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_EMISPAS")>0)
			aAdd( aExp, {'GPE_EMIS_PASSAPOR'		,SRA->RA_EMISPAS																				,"SRA->RA_EMISPAS"	, STR0267   } ) // "Orgao Emissor do Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_UFPAS")>0)
			aAdd( aExp, {'GPE_UF_PASSAPORTE'		,SRA->RA_UFPAS  																				,"SRA->RA_UFPAS"	, STR0268   } ) // "UF do Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_DEMIPAS")>0)
			aAdd( aExp, {'GPE_DT_EMIS_PAS'			,SRA->RA_DEMIPAS																				,"SRA->RA_DEMIPAS"	, STR0269   } ) // "Data Emissao Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_DVALPAS")>0)
			aAdd( aExp, {'GPE_DT_VALID_PAS'			,SRA->RA_DVALPAS																				,"SRA->RA_DVALPAS"	, STR0270   } ) // "Data Validade Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_CODPAIS")>0)
			aAdd( aExp, {'GPE_PAIS_PASSAPOR'		,fDesc("CCH",SRA->RA_CODPAIS,"CCH_PAIS")														,"SRA->RA_PAISPAS"	, STR0271   } ) // "Pais de Emissao Passaporte"
		EndIF
		IF SRA->(FieldPos("RA_NUMNATU")>0)
			aAdd( aExp, {'GPE_NUM_NATURALIZ'		,SRA->RA_NUMNATU																				,"SRA->RA_NUMNATU"	, STR0272   } ) // "Numero de Naturalizacao"
		EndIF
		IF SRA->(FieldPos("RA_DATNATU")>0)
			aAdd( aExp, {'GPE_DATA_NATURALIZ'		,SRA->RA_DATNATU																				,"SRA->RA_DATNATU"	, STR0273   } ) // "Data de Naturalizacao"
		EndIF
		IF SRA->(FieldPos("RA_NUMRIC")>0)
			aAdd( aExp, {'GPE_NUMERO_RIC'			,SRA->RA_NUMRIC 																				,"SRA->RA_NUMRIC" 	, STR0274   } ) // "Numero do RIC"
		EndIF
		IF SRA->(FieldPos("RA_EMISRIC")>0)
			aAdd( aExp, {'GPE_EMISSAO_RIC'			,SRA->RA_EMISRIC																				,"SRA->RA_EMISRIC"	, STR0275   } ) // "Orgao Emissor do RIC"
		EndIF
		IF SRA->(FieldPos("RA_UFRIC")>0)
			aAdd( aExp, {'GPE_UF_RIC'				,SRA->RA_UFRIC  																				,"SRA->RA_UFRIC"  	, STR0276   } ) // "UF do RIC"
		EndIF
		IF SRA->(FieldPos("RA_UFRIC")>0 .and. FieldPos("RA_CDMURIC")>0)
			aAdd( aExp, {'GPE_MUNICIPIO_RIC'		,fDesc("CC2",SRA->RA_UFRIC+SRA->RA_CDMURIC,"CC2_MUN")											,"SRA->RA_MUNIRIC"	, STR0277   } ) // "Municipio do RIC"
		EndIF
		IF SRA->(FieldPos("RA_DEXPRIC")>0)
			aAdd( aExp, {'GPE_DATA_EXP_RIC'			,SRA->RA_DEXPRIC																				,"SRA->RA_DEXPRIC"	, STR0278   } ) // "Data de Expedicao do RIC"
		EndIF
		IF SRA->(FieldPos("RA_TIPENDE")>0)
			aAdd( aExp, {'GPE_TIPO_ENDERECO_COM'	,SRA->(IF(RA_TIPENDE$"1","x" ,""))																,"SRA->RA_TIPENDE"	, STR0279   } ) // "Marca 'x' se Endereco for Comercial"
			aAdd( aExp, {'GPE_TIPO_ENDERECO_RES'	,SRA->(IF(RA_TIPENDE$"2","x" ,""))																,"SRA->RA_TIPENDE"	, STR0280   } ) // "Marca 'x' se Endereco for Residencial"	
		EndIF
		IF SRA->(FieldPos("RA_NUMENDE")>0)
			aAdd( aExp, {'GPE_NUM_ENDERECO'			,SRA->RA_NUMENDE																				,"SRA->RA_NUMENDE"	, STR0281   } ) // "Numero do Endereco"
		EndIF
		IF SRA->(FieldPos("RA_CPOSTAL")>0)
			aAdd( aExp, {'GPE_CAIXA_POSTAL'			,SRA->RA_CPOSTAL																				,"SRA->RA_CPOSTAL"	, STR0282  	} ) // "Caixa Postal"
	 	EndIF
	 	IF SRA->(FieldPos("RA_CEPCXPO")>0)
	 		aAdd( aExp, {'GPE_CEP_CAIXA_POSTAL'		,SRA->RA_CEPCXPO																				,"SRA->RA_CEPCXPO"	, STR0283	} ) // "CEP da Caixa Postal" 
	 	EndIF
	 	IF SRA->(FieldPos("RA_DDDFONE")>0)
	 		aAdd( aExp, {'GPE_DDD_TELEFONE'			,SRA->RA_DDDFONE																				,"SRA->RA_DDDFONE"	, STR0284   } ) // "DDD do Telefone"
		EndIF
		IF SRA->(FieldPos("RA_DDDCELU")>0)
			aAdd( aExp, {'GPE_DDD_CELULAR'			,SRA->RA_DDDCELU																				,"SRA->RA_DDDCELU"	, STR0285   } ) // "DDD do Celular"
		EndIF
		IF SRA->(FieldPos("RA_NUMCELU")>0)
			aAdd( aExp, {'GPE_NUM_CELULAR'			,SRA->RA_NUMCELU																				,"SRA->RA_NUMCELU"	, STR0286   } ) // "Numero do Celular"
	   	EndIF
	   	aAdd( aExp, {'GPE_EMPRESA_TIPO_CNPJ'	,IF(aInfo[15]==2,"x","")																		,"@!"				, STR0287	} ) // "Marca 'x' se Empresa por CNPJ"
	   	aAdd( aExp, {'GPE_EMPRESA_TIPO_CEI'		,IF(aInfo[15]==1,"x","")																		,"@!"				, STR0288	} ) // "Marca 'x' se Empresa por CEI"
		IF SRA->(FieldPos("RA_DATCHEG")>0)
			aAdd( aExp, {'GPE_DATA_CHEGADA'			,SRA->RA_DATCHEG																				,"SRA->RA_DATCHEG"	, STR0289   } ) // "Data de Expedicao do RIC"   	
		EndIF
		IF SRA->(FieldPos("RA_SECAO")>0)
			aAdd( aExp, {'GPE_SECAO'				,SRA->RA_SECAO												  									,"SRA->RA_SECAO"	, STR0290  	} ) // "Secao Eleitoral"
		EndIF
		aAdd( aExp, {'GPE_INST_DCN'				,cGrauInstr																						,"@!"				, STR0291	} ) // "Grau de Instrucao conforme NIS/PIS"
		IF SRA->(FieldPos("RA_BRNASEX")>0 .and. FieldPos("RA_CPAISOR")>0)
			aAdd( aExp, {'GPE_PAIS_ORIGEM_PIS'		,SRA->(IF(RA_NACIONA<>"10" .OR. RA_BRNASEX=="1",fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS"),""))	,"SRA->RA_PAISORI"	, STR0292   } ) // "Pais de Origem para o DCN/DMN"    
			aAdd( aExp, {'GPE_COD_UF_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_NATURAL,""))	    					,"SRA->RA_NATURAL"	, STR0308   } ) // "Estado de Nascimento NIS/PIS"     
		EndIF
		IF SRA->(FieldPos("RA_MUNNASC")) > 0
			aAdd( aExp, {'GPE_MUNICIPIO_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_MUNNASC,""))							,"SRA->RA_MUNNASC"	, STR0309	} ) // "Municipio de Nascimento NIS/PIS"	
		EndIF
		aAdd( aExp, {'GPE_TIPO_MANUT_NIS_ALTER'	,IF(cTipNIS=="1","x","")																		,"@!"				, STR0310	} )	// "Marca 'x' para tipo de DMN - Alteracao"	
		aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CADAS'	,IF(cTipNIS=="2","x","")																		,"@!"				, STR0311	} )	// "Marca 'x' para tipo de DMN - Cadastro Retroativo"	
		aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CANCE'	,IF(cTipNIS=="3","x","")																		,"@!"				, STR0312	} )	// "Marca 'x' para tipo de DMN - Cancelamento"	
		aAdd( aExp, {'GPE_TIPO_MANUT_NIS_REATI'	,IF(cTipNIS=="4","x","")																		,"@!"				, STR0313	} )	// "Marca 'x' para tipo de DMN - Reativacao"
		aAdd( aExp, {'GPE_TIPO_MANUT_NIS_RETRO'	,IF(cTipNIS=="5","x","")																		,"@!"				, STR0314	} )	// "Marca 'x' para tipo de DMN - Retroacao Cadastral"	
		aAdd( aExp, {'GPE_COD_SEXO_MASCULINO'	,SRA->(IF(RA_SEXO=="M","x",""))																, "SRA->RA_SEXO"	, STR0315	} )	// "Marca 'x' se sexo for Masculino" 
		aAdd( aExp, {'GPE_COD_SEXO_FEMININO'	,SRA->(IF(RA_SEXO=="F","x",""))																, "SRA->RA_SEXO"	, STR0316	} )	// "Marca 'x' se sexo for Feminino" 
	
	EndIf
	
	IF SRA->( FieldPos("RA_XALOCAC" ) > 0 )
		cRAXALOCAC	:= AllTrim( Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_DESCRIC") )
		IF Empty( cRAXALOCAC )
			aX3cBox	:= RetSx3Box(AllTrim(GetSx3Cache("RA_XALOCAC","X3_CBOX")),1,1,1)
			nAt		:= aScan(aX3cBox,{|e|e[2]==SRA->RA_XALOCAC})
			IF ( nAt > 0 )
				cRAXALOCAC	:= AllTrim(aX3cBox[nAt][3])
			EndIF	
		EndIF
		aAdd( aExp, {'GPE_BASE_ALOCADO'	,cRAXALOCAC, "SRA->RA_XALOCAC"	, GetSx3Cache("RA_XALOCAC","X3_TITULO")	} )	
	Else
		aAdd( aExp, {'GPE_BASE_ALOCADO'	,cRAXALOCAC, "SRA->RA_XALOCAC"	, GetSx3Cache("RA_XALOCAC","X3_TITULO")	} )	
	EndIF

	IF ( lEndDepto )

		IF SQB->( FieldPos( "QB_XLOGRAD" ) > 0 )
			
			IF SQB->( FieldPos( "QB_XLOGNRO" ) > 0 )
				cNroEndEmp	:= AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGNRO"))
			EndIF    
	
			IF SQB->( FieldPos( "QB_XLOGCOM" ) > 0 )
				cComEndEmp	:= AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGCOM"))
			EndIF    
		
			cEndEmp := AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGRAD"))

			IF .NOT.( Empty( cEndEmp ) )
				
				nAt 	:= aScan(aExp,{|e|e[1]=='GPE_END_EMPRESA'})
				IF .NOT.( Empty(cNroEndEmp) )
					cEndEmp += ", " + cNroEndEmp
				EndIF
				IF .NOT.( Empty( cComEndEmp ) )
					cEndEmp += " - " + cComEndEmp
				EndIF             
				IF ( nAt > 0 )
					aExp[nAt][2] := cEndEmp
				Else
					aAdd( aExp, {'GPE_END_EMPRESA',cEndEmp, "@!",STR0131} )
				EndIF

				IF SQB->( FieldPos( "QB_XLOGMUN" ) > 0 )
					cMunEmp := AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGMUN"))
					IF .NOT.( Empty( cMunEmp ) )
						nAt 	:= aScan(aExp,{|e|e[1]=='GPE_CID_EMPRESA'})
						IF ( nAt > 0 )
							aExp[nAt][2] := cMunEmp
						Else
							aAdd( aExp, {'GPE_CID_EMPRESA',cMunEmp, "@!",STR0132} )
						EndIF
					EndIF
				EndIF
				
				IF SQB->( FieldPos( "QB_XLOGCEP" ) > 0 )
					cCepEmp := AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGCEP"))
					IF .NOT.( Empty( cCepEmp ) )
						nAt 	:= aScan(aExp,{|e|e[1]=='GPE_CEP_EMPRESA'})
						IF ( nAt > 0 )
							aExp[nAt][2] := cCepEmp
						Else
							aAdd( aExp, {'GPE_END_EMPRESA',cCepEmp, "@!",STR0034} )
						EndIF
					EndIF
				EndIF
	
				IF SQB->( FieldPos( "QB_XLOGUF" ) > 0 )
					cUFEmp := AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGUF"))
					IF .NOT.( Empty( cUFEmp ) )
						nAt 	:= aScan(aExp,{|e|e[1]=='GPE_EST_EMPRESA'})
						IF ( nAt > 0 )
							aExp[nAt][2] := cUFEmp
						Else
							aAdd( aExp, {'GPE_EST_EMPRESA',cUFEmp, "@!",STR0032} )
						EndIF
					EndIF
				EndIF
		
				IF SQB->( FieldPos( "QB_XLOGBAI" ) > 0 )
					cBaiEmp := AllTrim(Posicione("SQB",nSQBOrder,cSQBFilial+SRA->RA_DEPTO,"QB_XLOGBAI"))
					IF .NOT.( Empty( cUFEmp ) )
						nAt 	:= aScan(aExp,{|e|e[1]=='GPE_BAI_EMPRESA'})
						IF ( nAt > 0 )
							aExp[nAt][2] := cUFEmp
						Else
							aAdd( aExp, {'GPE_BAI_EMPRESA',cBaiEmp, "@!",STR0137} )
						EndIF
					EndIF
				EndIF
				
			EndIF
		
		EndIF    
	
	EndIF
		
	aAdd( aExp, {'GPE_NUM_SEQ',cNumSeq:=__Soma1(cNumSeq),"@!","Numero Sequencial"} )	//"Numero Sequencial"
	aExpPon( @aExp )
	
Return( aExp )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: GetQuery()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Retorna Informacoes da Definicao de Tabelas
	
*/      
Static Function GetQuery(cQuery)

	Local cDes:=""
	Local cAliasTmp:=CriaTrab(Nil,.F.)
	
	IF (Select(cAliasTmp) > 0)
		(cAliasTmp)->(dbCloseArea())
	EndIF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.) 
	(cAliasTmp)->(dbgotop())
	IF(cAliasTmp)->(!EOF())
		cDes:=(cAliasTmp)->CONTEU
	EndIf
	(cAliasTmp)->( dbCloseArea()) 

Return( cdes )

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fOpTipPis()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Opcoes dos Tipos de NIS para o cadastro de PIS
*/      
Static Function fOpTipPis()

	Local cTitulo	:= "" 
	Local MvParDef	:= ""
	Local MvPar
	Local lRet	    := .T.
	
	Private aInc	:={}
	
	IF ( Alltrim(ReadVar()) == "MV_PAR30" )
	
		MvPar		:=	&(Alltrim(ReadVar()))	 		    // Carrega Nome da Variavel do Get em Questao
		mvRet		:=	Alltrim(ReadVar())			 	    // Iguala Nome da Variavel ao Nome variavel de Retorno
		aInc		:=	{STR0322,STR0323,STR0324,STR0325,STR0326,STR0327}// "Nenhum";"Alteracao";"Cadastro Retroativo";"Cancelamento";
															//"Reativacao";"Retroacao Cadastral"
		MvParDef	:=	"012345"
		cTitulo		:=	STR0321							  	//"Informe o Tipo de Alteracao do NIS-PIS"
	
		f_Opcoes(@MvPar,cTitulo,aInc,MvParDef,12,49,.T.)  	// Chama funcao f_Opcoes
	
		&MvRet := mvpar										// Devolve Resultado
	
	EndIF
	
	IF ( .F. )
		fOpTipPis()
	EndIF	
	
Return(.T.)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: fChkUpd()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Checa se atualizacoes foram processadas no ambiente
*/      
Static Function fChkUpd( cMsg )

	Local cFun
	
	DEFAULT cMsg := ""
	
	//Retorna as informacoes sobre a atualizacao que precisa ser executada pelo RHUPDMOD
	If cPaisLoc == "BRA"
		cFun := "fRhUpdMsg"
		If !CpoUsado( "RA_BRNASEX" )
			IF FindFunction(cFun)
				cMsg := &cFun.( 206 )
			EndIF	
		EndIf
	EndIf
	
Return(cMsg)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: DiasExtenso()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Retorna o Exstenso do Dia
*/
Static Function DiasExtenso(nDias)
	Local cExtenso := Upper( Extenso(nDias) )
	cExtenso := StrTran(cExtenso,"REAIS","")
	cExtenso := StrTran(cExtenso,"REAL","")
Return(cExtenso)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: aExpPon
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Carrega aExp com informações do Ponto Eletronico
*/
Static Function aExpPon(aExp)

	DEFAULT aExp := Array(0)

	aPDiaSemana(@aExp)

Return(.T.)
	
/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: aPDiaSemana
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Carrega aExp com informações do Ponto Eletronico
*/
Static Function aPDiaSemana(aExp)

	Local dTmp
	
	Local cDia
	Local cSeq		:= "00"
	Local cWVarD	:= "PON_DIA_"
	Local cWVarE	:= "PON_DIA_S"

	Local cMonth	:= Month2Str(dDataBase)
	Local cYear     := Year2Str(dDataBase)
	Local cMY		:= ("/"+cMonth+"/"+cYear)

	Local cDiaSem

	Local lSabDom	:= ((Type("__lSatSunOnly")=="L").and.__lSatSunOnly)
	Local nDow

	DEFAULT aExp 	:= Array(0) 
	
	While ( cSeq <= "31" )
		cSeq 	:= __Soma1(cSeq)
		cDia	:= cSeq
		While (SubStr(cDia,1,1)=="0")
			cDia := SubStr(cDia,2)
		End While
		dTmp	:= CtoD(cSeq+cMY)
		IF .NOT.( Empty(dTmp))		
			cDiaSem	:= DiaSemana(dTmp)
			IF ( lSabDom )
				nDow := Dow(dTmp)
				IF .NOT.((nDow==1).or.(nDow==7))
					cDiaSem := ""	
				EndIF
			EndIF
			aAdd( aExp, {cWVarD+cSeq,cDia,"@!","Dia "+PadL(cDia,2)} )
			aAdd( aExp, {cWVarE+cSeq,cDiaSem,"@!","Dia Semana "+PadL(cDia,2)} )		
		Else
			aAdd( aExp, {cWVarD+cSeq,"","@!","Dia  "+PadL(cDia,2)} )
			aAdd( aExp, {cWVarE+cSeq,"","@!","Dia Semana "+PadL(cDia,2)} )	
		EndIF
	End While

Return(.T.)
		
/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: DlgMemoEdit()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Obtem Titulo e Corpo da Mensagem de e-mail
*/                          
Static Function DlgMemoEdit(;
									bAction		,;	//01 -> Acao a ser executada se tudo Ok
									cTitle		,;	//02 -> Array com Botoes para Opcao de Edicao dos Campos Memo
									lModify		,;	//03 -> Se podera modificar o Conteudo do campo Memo
									aButtons	,;	//04 -> Array com Botoes para Opcao de Edicao dos Campos Memo
									oMemoEdit	,;	//05 -> Objeto MemoEdit
									cMemoEdit	,;	//06 -> Conteudo do Campo Memo
									oFont		,;	//07 -> Objeto Font
									aAdvSize    ,;	//08 -> Coordenadas do Dialogo
									oGetEdit	,;  //09 -> oGet
									cGetEdit	 ;	//08 -> cGet	
								)
	
	Local aSvKeys
	Local aInfoAdvSize
	Local aObjSize
	Local aObjCoords
	
	Local bSet15			:= {||GetKeys(),IF(Eval( bAllValid ),(lConfOk:=MsgYesNo(OemToAnsi("Confirma o Texto para envio do e-mail?"),OemToAnsi("ATENÇÃO")),IF(lConfOk,oDlg:End(),NIL)),NIL)}
	Local bSet24			:= {||GetKeys(),( lConfOk := .F. , oDlg:End() ) }
	
	Local bGetValid			:= {||(.NOT.(Empty(cGetEdit)).AND..NOT.(OemToAnsi("<DIGITE AQUI O TÍTULO DO E-MAIL>")$Upper(AllTrim(cGetEdit))))}
	Local bMemValid 		:= {||(.NOT.(Empty(cMemoEdit)).AND..NOT.(OemToAnsi("<DIGITE AQUI A MENSAGEM DO E-MAIL>")$Upper(AllTrim(cMemoEdit))))}
	Local bAllValid 		:= {||Eval(bGetValid).and.Eval(bMemValid)}
	
	Local cTitCompl
	Local cSvGetEdit
	Local cSvMemoEdit
	
	Local lConfOk			:= .F.
	
	Local nColDesMem
	
	Local oDlg
	
	Begin Sequence
	
		DEFAULT lModify		:= .T.
	
		cSvGetEdit			:= cGetEdit
		cSvMemoEdit			:= cMemoEdit
	
		DEFAULT aAdvSize	:= MsAdvSize( .T. , .T. )
		aInfoAdvSize		:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aObjCoords			:= { { 0 , 0 , .T. , .T. } }
		aObjSize			:= MsObjSize( aInfoAdvSize , aObjCoords )
	
		aSvKeys := GetKeys()
	
		IF .NOT.( ValType( oFont ) == "O" )
			DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
		EndIF	
		IF .NOT.( Type( "cCadastro" ) == "C" )
			Private cCadastro := ""
		EndIF
	
		DEFAULT cTitle  := ""
		IF .NOT.Empty( cCadastro )
			cTitCompl	:=	cCadastro
			IF .NOT.Empty( cTitle )
				cTitCompl	+=	" - "
				cTitCompl	+= cTitle
			EndIF
		Else
			cTitCompl	:= cTitle
		EndIF		
		
		DEFAULT cGetEdit 	:= PadR(OemToAnsi("<DIGITE AQUI O TÍTULO DO E-MAIL>"),100)
		DEFAULT cMemoEdit	:= OemToAnsi( "<DIGITE AQUI A MENSAGEM DO E-MAIL>" )
		
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( cTitCompl ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL
	
			aObjSize[1][1]+= 5
			@ aObjSize[1][1],aObjSize[1][2] MSGET oGetEdit  VAR cGetEdit OF oDlg SIZE (aObjSize[1][4]-aObjSize[1][2]),20 FONT oFont PIXEL WHEN ( .T. ) VALID Eval(bGetValid)
			aObjSize[1][1] += 25
			@ aObjSize[1][1],aObjSize[1][2] GET   oMemoEdit VAR cMemoEdit MEMO   OF oDlg SIZE (aObjSize[1][4]-aObjSize[1][2]),((aObjSize[1][3]-aObjSize[1][1])) FONT oFont PIXEL WHEN ( .T. ) DESIGN UPDATE VALID Eval(bMemValid)
	
			oMemoEdit:lReadOnly := .NOT.( lModify )
			oMemoEdit:EnableVScroll(.T.)
			oMemoEdit:EnableHScroll(.T.)
	
			oDlg:lEscClose		:= .F. //Nao permite sair ao se pressionar a tecla ESC.
			
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( @oDlg , @bSet15 , @bSet24 , NIL , @aButtons ) CENTERED VALID Eval( bAllValid )
		RestKeys( aSvKeys , .T. )
	
		IF ( lModify )
			IF ( lConfOk )		//<CTRL-O>
				DEFAULT bAction	:= { || .T. }
				Eval( bAction )
			ElseIF .NOT.( lConfOk )	//<CTRL-X>
				IF .NOT.( cSvMemoEdit == cMemoEdit ) .or. .NOT.( cSvGetEdit == cGetEdit )
					IF .NOT.( MsgNoYes( OemToAnsi( "Abandonar as Alterações?" ) , cTitCompl ) )
						lConfOk := DlgMemoEdit(;
								   				@bAction	,;	//01 -> Acao a ser executada se tudo Ok
								   				@cTitle		,;	//02 -> Array com Botoes para Opcao de Edicao dos Campos Memo
												@lModify	,;	//03 -> Se podera modificar o Conteudo do campo Memo
												@aButtons	,;	//04 -> Array com Botoes para Opcao de Edicao dos Campos Memo
												@oMemoEdit	,;	//05 -> Objeto MemoEdit
												@cMemoEdit	,;	//06 -> Conteudo do Campo Memo
												@oFont		,;	//07 -> Objeto Font
												@aAdvSize   ,;	//08 -> Coordenadas do Dialogo
												@oGetEdit	,;  //09 -> oGet
												@cGetEdit	 ;	//08 -> cGet
									)[1]
					EndIF
				EndIF
			EndIF
		EndIF
	
	End Sequence
	
Return( { lConfOk , cGetEdit , cMemoEdit } )

 /*
	Programa	: U_GPEWORDX.PRW
	Funcao		: btdnGR08W()
	Autor		: [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Tratamento para Impressao da Folha de Ponto
*/                          
Static Function btdnGR08W()

	Local cPath	:= Lower(AllTrim(GetNewPar("GPEDOTPATH","\GPEWDOT\")))
	Local cFile := cPath+cEmpAnt+Lower(AllTrim(GetNewPar("FOLHAPONTO","FolhaDePonto.dotx")))
	
	SX1->( dbSetOrder(1)) //X1_GRUPO+X1_ORDEM
	
	IF ( Type("cPerg") == "U" )
		cPerg	:= PadR("U_GPEWORDX",Len(SX1->X1_GRUPO))
	Else
		cPerg	:= PadR(cPerg,Len(SX1->X1_GRUPO))
	EndIF
	
	IF SX1->( dbSeek( cPerg+"26" , .F.  ) )
		MV_PAR26 := 2
		IF SX1->( RecLock( "SX1" , .F. ) )
			SX1->X1_PRESEL := MV_PAR26
		EndIF	
	EndIF

	IF SX1->( dbSeek( cPerg+"28" , .F.  ) )
		MV_PAR28 := 2
		IF SX1->( RecLock( "SX1" , .F. ) )
			SX1->X1_PRESEL := MV_PAR28
		EndIF	
	EndIF
	
	IF SX1->( dbSeek( cPerg+"31" , .F.  ) )
		MV_PAR31 := 1
		IF SX1->( RecLock( "SX1" , .F. ) )
			SX1->X1_PRESEL := MV_PAR31
		EndIF	
	EndIF

	IF SX1->( dbSeek( cPerg+"32" , .F.  ) )
		MV_PAR32 := 1
		IF SX1->( RecLock( "SX1" , .F. ) )
			SX1->X1_PRESEL := MV_PAR32
		EndIF	
	EndIF

	fOpen_Word(.F.,cFile)
	fDirG_Word(.F.)

Return(.T.)

/*
	Programa	: U_GPEWORDX.PRW
	Funcao		: doc2pdf()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 25/06/2013
	Descricao	: Script em PS para converter DOC em PDF
	
	* autorize a execução dos scripts digitando: Set-ExecutionPolicy unrestricted no Console
	* do PowerShell como:
	* 
	* ***************************************************************************************
	* 
	* PS C:\> Set-ExecutionPolicy unrestricted
	* 
	* Alteração da Diretiva de Execução
	* A diretiva de execução ajuda a proteger contra scripts não confiáveis. A
	* alteração da diretiva de execução pode implicar em exposição aos riscos de
	* segurança descritos no tópico da ajuda about_Execution_Policies. Deseja alterar
	*  a diretiva de execução?
	* [S] Sim  [N] Não  [U] Suspender  [?] Ajuda (o padrão é "S"): S
	
*/                          
Static Function doc2pdf(cPSPath)

	Local cNPS
	Local cLPS
	
	Local cDrive
	Local cPsFile

	Local cCRLF	:= CRLF
	
	SplitPath(GetTempPath(),@cDrive)
	
	IF .NOT.( SubStr( cDrive , -1 ) == "\" )
		cDrive += "\"	
	EndIF
	
	IF Empty( cPsPath )
		cPsPath := ( cDrive + "doc2pdf\" )
	EndIF

	IF .NOT.( SubStr(cPsPath,-1) =="\" )
		cPsPath += "\"
	EndIF
	
	MakeDir(cPsPath)
			
	cNPS :='##############################################doc2pdf.ps1##############################################'+cCRLF
	cNPS +='# doc2pdf.ps1                                                                                         #'+cCRLF
	cNPS +='# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br                                         #'+cCRLF
	cNPS +='# Data       : 26/06/2013                                                                             #'+cCRLF
	cNPS +='#######################################################################################################'+cCRLF
	cNPS +='function doc2pdf()'+cCRLF
	cNPS +='{'+cCRLF
	cNPS +='    param('+cCRLF
	cNPS +='			[string]$source = $(Throw "You have to specify a source path."),'+cCRLF
	cNPS +='			[string]$log    = $(join-path . "doc2pdf.log"),'+cCRLF
	cNPS +='			$word           = $(new-object -ComObject "word.application")'+cCRLF
	cNPS +='	)'+cCRLF
	cNPS +='    $extensionSize = 3'+cCRLF
	cNPS +='    if ($source.EndsWith("docx")){'+cCRLF
	cNPS +='      $extensionSize = 4'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    $msg          = "`n`n[$(get-date)]doc2pdf has started. File: $source"'+cCRLF
	cNPS +='    add-content -force $log -value $msg'+cCRLF
	cNPS +='    $destiny      = $source.Substring(0,$source.Length-$extensionSize)+"pdf"'+cCRLF
	cNPS +='    $saveaspath   = $destiny'+cCRLF
	cNPS +='    $formatPDF    = 17'+cCRLF
	cNPS +='    $process      = Get-Process winword -ErrorAction SilentlyContinue'+cCRLF
	cNPS +='    $word.Visible = $false'+cCRLF
	cNPS +='    try{'+cCRLF
	cNPS +='        $word.DisplayAlerts      = "wdAlertsNone"'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    catch [system.exception]{'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    finally{'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    try{'+cCRLF
	cNPS +='        $word.AutomationSecurity = "msoAutomationSecurityForceDisable"'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    catch [system.exception]{'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    finally{'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='	try{'+cCRLF
	cNPS +='        $doc = $word.documents.open($source)'+cCRLF
	cNPS +='        try{'+cCRLF
	cNPS +='         #Office 7'+cCRLF
	cNPS +='         $msg = "converting: $source using MSOffice Word 7. Wait..."'+cCRLF
	cNPS +='         add-content -force $log -value $msg'+cCRLF
	cNPS +='         write-host -fore yellow $msg'+cCRLF
	cNPS +='         $doc.SaveAs($saveaspath,$formatPDF)'+cCRLF
	cNPS +='        }'+cCRLF
	cNPS +='        catch [system.exception]{'+cCRLF
	cNPS +='            try{'+cCRLF
	cNPS +='                #Office 10'+cCRLF
	cNPS +='                $msg = "converting: $source using MSOffice Word 10. Wait..."'+cCRLF
	cNPS +='                add-content -force $log -value $msg'+cCRLF
	cNPS +='                write-host -fore yellow $msg'+cCRLF
	cNPS +='                $doc.SaveAs([ref]$saveaspath,[ref]$formatPDF)'+cCRLF
	cNPS +='            }'+cCRLF
	cNPS +='            catch [system.exception]{'+cCRLF
	cNPS +='                $msg = "Caught a system exception. File: $source UNCONVERTED using MSOffice Word 7 or 10"'+cCRLF
	cNPS +='                add-content -force $log -value $msg'+cCRLF
	cNPS +='                write-host -fore red $msg'+cCRLF
	cNPS +='            }'+cCRLF
	cNPS +='            finally{'+cCRLF
	cNPS +='                $msg = "Converted using MSOffice Word 10. file: $source"'+cCRLF
	cNPS +='                add-content -force $log -value $msg'+cCRLF
	cNPS +='                write-host -fore green $msg'+cCRLF
	cNPS +='            }'+cCRLF
	cNPS +='        }'+cCRLF
	cNPS +='        finally{'+cCRLF
	cNPS +='                $msg = "Converted using MSOffice Word 7. file: $source"'+cCRLF
	cNPS +='                add-content -force $log -value $msg'+cCRLF
	cNPS +='                write-host -fore green $msg'+cCRLF
	cNPS +='        }'+cCRLF
	cNPS +='        $doc.Close()'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    catch [system.exception]{'+cCRLF
	cNPS +='        $msg = "Caught a system exception. File: $source UNCONVERTED"'+cCRLF
	cNPS +='        add-content -force $log -value $msg'+cCRLF
	cNPS +='        write-host -fore red $msg'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='    finally{'+cCRLF
	cNPS +='        $msg = "End of script. File: $source"'+cCRLF
	cNPS +='        add-content -force $log -value $msg'+cCRLF
	cNPS +='        write-host -fore blue $msg'+cCRLF
	cNPS +='    }'+cCRLF
	cNPS +='}'+cCRLF
	cNPS +='##############################################doc2pdf.ps1##############################################'+cCRLF
	cNPS +='# doc2pdf.ps1                                                                                         #'+cCRLF
	cNPS +='# Autor      : Marinaldo de Jesus (http://www.blacktdn.com.br                                         #'+cCRLF
	cNPS +='# Data       : 26/06/2013                                                                             #'+cCRLF
	cNPS +='#######################################################################################################'+cCRLF
	cNPS +='$log = join-path '+cPsPath+' "doc2pdf.log"'+cCRLF
	cNPS +='if ( test-path $log ){'+cCRLF
	cNPS +='	$tempLog = get-item $log'+cCRLF
	cNPS +='	if ( $tempLog.Length -ge 61440 ){'+cCRLF
	cNPS +='		$tempLog.Delete()'+cCRLF
	cNPS +='	}'+cCRLF
	cNPS +='}'+cCRLF
	cNPS +='$word = new-object -ComObject "word.application"'+cCRLF
	cNPS +='ls '+cPsPath+'*.doc* -Recurse | %{ doc2pdf $_.fullname $log $word}'+cCRLF
	cNPS +='ps | %{ if( $_.Name.toLower().Contains("winword")){ ps $_.Name | KILL } }'+cCRLF
	    
	cPsFile := ( cPsPath + "doc2pdf.ps1" )
	
	IF File(cPsFile)
		cLPS := MemoRead(cPsFile)	
	EndIF
	
	IF .NOT.( cLPS == cNPS )
		IF File(cPsFile)
			fErase(cPsFile)
		EndIF
		MemoWrite(cPsFile,cNPS)
	EndIF

Return( File(cPsFile) )