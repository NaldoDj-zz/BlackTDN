#include "shell.ch"
#include "fileio.ch"
#include "dbStruct.ch"
#include "RWMAKE.CH"
#include "PRCONST.CH"
#include "PROTHEUS.CH"
#include "GPEWRITER.CH" 

/*
	Programa	: GpeWriter
	Autor		: R.H
	Data		: 05/07/2000
	Descrição	: Impressao de Documentos tipo OpenOffice Writer
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
User Function GpeWriter()

Local bPrint		:= { |lEnd| Pergunte(cPerg,.F.),fWord_Imp(lEnd,oDlg) }
Local cCampo  		:= ""
Local oDlg			:= NIL
Local oFont			:= TFont():New("Arial",NIL,14,NIL,.T.)  

Private cCadastro	:= "Integração OppenOffice Writer"
Private cPerg		:= Padr( "GPEWRITER" , Len( SX1->X1_GRUPO ) )
Private aInfo		:= {}
Private aDepenIR	:= {}
Private aDepenSF	:= {}
Private aPerSRF 	:= {}
Private nDepen		:= 0

ChkProFile(.F.)

ValidPerg(@cPerg)

fInfo( @aInfo , xFilial("SRA") )

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001) FROM 096,042 TO 323,505 PIXEL 
	@008,010 TO 084,222																			OF oDlg PIXEL 
	@018,020 SAY OemToAnsi(STR0002)																OF oDlg PIXEL FONT oFont
	@030,020 SAY OemToAnsi(STR0003)																OF oDlg PIXEL FONT oFont
	@095,005 BUTTON OemToAnsi(STR0004) SIZE 55,12	ACTION fVarW_Imp() 							OF oDlg PIXEL FONT oFont
	@095,062 BUTTON OemToAnsi(STR0242) SIZE 55,12	ACTION GPE2Writer(.T.,@aInfo)	 			OF oDlg PIXEL FONT oFont
	@095,119 BUTTON OemToAnsi(STR0005) SIZE 55,12	ACTION Processa(bPrint,cCadastro,NIL,.T.)	OF oDlg PIXEL FONT oFont
	@095,178 BMPBUTTON TYPE 5						ACTION Pergunte(cPerg,.T.)
	@095,205 BMPBUTTON TYPE 2  			   			ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED

Return( NIL )

/*
	Programa	: GpeWriter
	Funcao		: fWord_Imp()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Impressao de Documentos tipo OpenOffice Writer
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function fWord_Imp(lEnd,oDlg)

	Local aLog			:= Array(0)
    Local aSaveExt		:= {".odt",".ott",".dot",".doc",".pdf",".htm",".html",".rtf" }

	Local cMsg			:= ""
	Local cCRLF			:= CRLF
	Local cError
	Local cExclui		:= ""
	Local cFilAnt   	:= Space(Len(xFilial("SRA")))
	Local aCampos		:= {}
	Local nX			:= 0
	Local nSvOrdem		:= 0
	Local nSvRecno		:= 0
	Local cAcessaSRA	:= &( " { || " + ChkRH( "GPEWRITER" , "SRA" , "2" ) + " } " )

#IFDEF TOP
	Local cStr
	Local nStr
	Local nStrT
	Local cIndexKey
	Local aStrSRA
#ENDIF
	
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
	Local cAdmiDe		:= Dtos(dAdmiDe)
	Local dAdmiAte		:= MV_PAR16
	Local cAdmiAte		:= Dtos(dAdmiAte)
	Local cSituacao		:= MV_PAR17
	Local cCategoria	:= MV_PAR18
	Local nCopias		:= Max( MV_PAR23 , 1 )
	Local nOrdem		:= MV_PAR24
	Local cArqWord		:= AllTrim( MV_PAR25 )
	Local lDepende		:= ( MV_PAR26 == 1 )
	Local nDepende  	:= MV_PAR27
	Local lImpress      := ( MV_PAR28 == 1 )
    Local cSaveExt		:= Lower( AllTrim( MV_PAR29 ) )
    Local lPreview		:= ( MV_PAR30 == 2 )

	Local cAux			:= ""
	Local cPath 		:= GETTEMPPATH()
	Local cArqSaida     := ""
	Local nAt			:= 0

	Local lServer
	Local lPrinter
	Local cSession
	Local cPrinter
	Local cOrientation

	Local lRet			:= .F.
	Local lError		:= .F.

	BEGIN SEQUENCE

		//?-Checa o SO do Remote (1=Windows, 2=Linux)
		If GetRemoteType() == 2
			lError	:= .T.
			cError := OemToAnsi(STR0167)
			ApMsgAlert( cError , OemToAnsi(STR0168))	//?-"Integração Word funciona somente com Windows !!!")###"Atenção !"
			aAdd( aLog , cError )
			BREAK	
		EndIf
		
		IF ( lImpress )
	
			lPrinter	:= PrinterSetup()
			IF !( lPrinter )
				lError	:= .T.
				cError	:= "Impressão Cancelada. Para imprimir confirme a Configuração da Impressora"
				ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
				aAdd( aLog , cError )
				BREAK
			EndIF
	
			cSession	:= GetPrinterSession()
			lServer		:= ( GetProfString(cSession,"LOCAL","SERVER",.T. ) == "SERVER" )
	
			While ( lServer )
				ApMsgAlert( "Impressão disponível apenas no Client. Reconfigure a Impressora" , "A T E N Ç Ã O !!!" )
				lPrinter := PrinterSetup()
				IF !( lPrinter )
					lError	:= .T.
					cError	:= "Impressão Cancelada. Para imprimir confirme a Configuração da Impressora"
					ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
					aAdd( aLog , cError )
					BREAK
				EndIF	
				lServer 	:= ( GetProfString(cSession,"LOCAL","SERVER",.T. ) == "SERVER" )
			End While
	
			lPrinter		:= IsPrinterOk()
			IF !( lPrinter )
				lError	:= .T.
				cError	:= "Problemas na Configuração da Impressora"
				ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
				aAdd( aLog , cError )
				BREAK
			EndIF
	
			cPrinter		:= GetProfString(cSession,"DEFAULT","",.T.)
			IF Empty(cPrinter)
				lError	:= .T.
				cError	:= "Problemas na Configuração da Impressora"
				ApMsgAlert( cError, "A T E N Ç Ã O !!!" )
				aAdd( aLog , cError )
				BREAK
			EndIF
		    cOrientation	:= Upper( AllTrim( GetProfString(cSession,"ORIENTATION","",.T. ) ) )

		Else

			cPrinter		:= ""
			cOrientation	:= ""

			IF (;
					Empty( cSaveExt );
					.or.;
					!( "." $ cSaveExt );
					.or.;
					( aScan( aSaveExt , cSaveExt ) == 0 );
				)	
				lError	:= .T.
				cError	:= "Extensão Inválida. Os Tipos de Extensões válidos são:" + cCRLF
				aAdd( aLog , cError )
				aEval( aSaveExt , { |e| cError += ( e + cCRLF ) , aAdd( aLog , e ) } )
				ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
				BREAK
			EndIF	

		EndIF
	
		nDepen := If (!lDepende,4,nDepende)

		If substr(cArqWord,2,1) <> ":"
			cAux 	:= cArqWord
			nAT		:= 1
			for nx := 1 to len(cArqWord)
				cAux := substr(cAux,If(nx==1,nAt,nAt+1),len(cAux))
				nAt := at("\",cAux)
				If nAt == 0
					Exit
				Endif
			next nx
			CpyS2T(cArqWord,cPath,.T.)
			cArqWord	:= cPath+cAux
		Endif

		SRB->( nSBOrdem := IndexOrd() , nSBRecno := Recno() )
		SRB->( dbGotop() )

		SRA->( nSvOrdem := IndexOrd() , nSvRecno := Recno() )
		SRA->( dbGotop() )

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
		
		cFilialAnt := Space(Len(xFilial("SRA")))

#IFNDEF TOP		
		While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
#ELSE
		While SRA->( !Eof() )
#ENDIF

			IncProc()
			IF ( lEnd )
				aAdd( aLog , "Cancelado pelo Usuário" )
				BREAK
			EndIF

			#IFNDEF TOP

				IF SRA->( Eval ( &(cExclui) ) )
			       SRA->( dbSkip() )
			       Loop
			    EndIF
			    
			#ENDIF

			IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		      SRA->( dbSkip() )
		      Loop
			EndIF 
			
			If lDepende
				If nDepende == 1 //Salario Familia //
					If SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))         
				    	fDepSF()
					Else
						SRA->(dbSkip())
						Loop
					Endif		
				ElseIf nDepende == 2 //Imposto de Renda	//
		   	   If SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))
			    		fDepIR()
			    	Else
						SRA->(dbSkip())
						Loop
					Endif	
				ElseIf nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
		   			If SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))         
			       		fDepIR()
			       	Else
						SRA->(dbSkip())
						Loop
					Endif
					If SRB->(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT,.F.))         
			    		fDepSF()
			    	Else                                                                         
						SRA->(dbSkip())
						Loop
					Endif	
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
			If cPaisLoc == "COL"
			   fPesqSRF()                  //Busca Periodo Aquisitivo para Colombia
			Endif   
			IF SRA->RA_FILIAL # cFilialAnt
				IF !fInfo(@aInfo,SRA->RA_FILIAL)
					lError	:= .T.
					aAdd( aLog , "Não foi possível Carregar informações da Empresa" )
					BREAK
				EndIF			
				cFilialAnt := SRA->RA_FILIAL
			EndIF	

			cArqSaida := SRA->RA_FILIAL
			cArqSaida += "_"
			cArqSaida += SRA->RA_MAT
			cArqSaida += "_"
			cArqSaida += StrTran(AllTrim(SRA->RA_NOME)," ","_")
			cArqSaida += cSaveExt

			cError := ""
			IF !( GPE2Writer(.F.,@aInfo,@cArqWord,@lImpress,@cArqSaida,@nCopias,@cPrinter,@cOrientation,@cError,@cCRLF,@lPreview) )
				lError	:= .T.
				aAdd( aLog , "Ocorreram Problemas na Impressão dos dados do funcionário:" )
				aAdd( aLog , "Filial    : " + SRA->RA_FILIAL  )
				aAdd( aLog , "Matricula : " + SRA->RA_MAT     )
				aAdd( aLog , "Nome      : " + SRA->RA_NOME    )
				IF Empty( cError )
					cError	:= "UNDEFINED"
				EndIF
				aAdd( aLog , "Erro      : " + cError )
				aAdd( aLog , "" )
			Else
				IF ( lImpress )
					aAdd( aLog , "Impressão OK:" )
				Else
					aAdd( aLog , "Arquivo Salvo com Sucesso:" )
				EndIF
				aAdd( aLog , "Filial    : " + SRA->RA_FILIAL  )
				aAdd( aLog , "Matricula : " + SRA->RA_MAT     )
				aAdd( aLog , "Nome      : " + SRA->RA_NOME    )
				IF .not.( lImpress )
					aAdd( aLog , "Arquivo   : " + cArqSaida )
				EndIF
				aAdd( aLog , "" )
			EndIF

			SRA->( dbSkip() )
			
			//Iniciliaza array 
		    aSize( aDepenIR , 0 )
		    aSize( aDepenSF , 0 )
		    aSize( aPerSRF  , 0 )
		
		End While
	
		lRet	:= .T.
	
	End Sequence

	If Len(cAux) > 0
		fErase(carqword)
	Endif

#IFDEF TOP		
	SRA->( dbCloseArea() )
#ENDIF

	dbSelectArea('SRA')
	SRA->( dbSetOrder( nSvOrdem ) )
	SRA->( dbGoTo( nSvRecno ) )

	IF !Empty( aLog )
		fMakeLog( { aLog } , { "Log de OcorrÊncias na Integração com o OpenOffice Writer" } , cPerg , .T. , NIL , cCadastro , NIL , NIL , NIL , .F. )
		aSize( aLog , 0 )
	EndIF
	
	IF .NOT.( lError )
		IF ( lImpress )
			cMsg	:= "Impressão Finalizada. Deseja Imprimir novos Documentos?"
		Else
			cMsg	:= "Salvamento Finalizado. Deseja Salvar novos Documentos?"
		EndIF
		IF .NOT.( MsgYesNo( cMsg ) )
			oDlg:End()
		EndIF
	EndIF

Return( lRet )

/*
	Programa	: GpeWriter
	Funcao		: fOpen_Word()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Selecionar o Arquivo Modelo
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function fOpen_Word()

Local __bDummy		:= { || fOpen_Word() , __bDummy }

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= STR0006	//"*.DOT,*.DOC,*.ODT,*.OTT|*.DOT|*.DOC|*.ODT|*.OTT"
Local cNewPathArq	:= AllTrim( cGetFile (cTipo,STR0007,3,CurDrive()+"\gpe_writer",.F.,GETF_LOCALHARD,.T.,.T.) )

IF !Empty( cNewPathArq )
	IF Len( cNewPathArq ) > 75
    	ApMsgAlert( STR0187 , STR0168 ) //"O endereco completo do local onde está o arquivo do Word excedeu o limite de 75 caracteres!"
    	Return			
	Else
		//"[DOT][DOC][ODT][OTT]"
		IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) $ Upper( AllTrim( STR0008 ) )
			ApMsgAlert( cNewPathArq , STR0009 )
	    Else
	    	ApMsgAlert( STR0011 , STR0168 )
	    	Return
	    EndIF
	EndIf
Else
    ApMsgAlert( STR0007 , STR0012 )
    Return( .F. )
EndIF

dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "25" , .T. ) ) )
	IF SX1->( RecLock("SX1",.F.,.T.) )
		SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
		MV_PAR25 := cNewPathArq
		MsUnLock()
	EndIF
EndIF	

dbSelectArea( cSvAlias )

Return(.T.)

/*
	Programa	: GpeWriter
	Funcao		: fVarW_Imp()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Impressao das Variaveis disponiveis para uso
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function fVarW_Imp()

Local cString	:= 'SRA'                                	     
Local aOrd		:= {STR0142,STR0143}
Local cDesc1	:= STR0144
Local cDesc2	:= STR0145                     
Local cDesc3	:= STR0146                                
Local Tamanho	:= "P"

Private nomeprog	:= 'GPEWRITER'
Private AT_PRG		:= nomeProg
Private aReturn		:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
Private wCabec0		:= 1
Private wCabec1		:= STR0149
Private wCabec2		:= ""
Private wCabec3		:= ""
Private nTamanho	:= "P"
Private lEnd		:= .F.
Private Titulo		:= cDesc1
Private Li			:= 0
Private ContFl		:= 1
Private cBtxt		:= ""
Private aLinha		:= {}
Private nLastKey	:= 0

nDepen := 0

WnRel := "WRITER_VAR" 
WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)

IF nLastKey == 27
	Return( NIL )
EndIF

SetDefault(aReturn,cString)

IF nLastKey == 27
	Return( NIL )
EndIF

RptStatus( { |lEnd| fImpVar() } , Titulo )

Return( NIL )

/*
	Programa	: GpeWriter
	Funcao		: fImpVar()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Impressao das Variaveis disponiveis para uso
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function fImpVar()

Local aCampos	:= {}

Local bSort

Local cDetalhe	:= ""

Local nX
Local nXs
Local nOrdem	:= aReturn[8]

aCampos := fCpos_Word()

IF nOrdem == 1
	bSort := { |x,y| x[1] < y[1] }
Else
	bSort := { |x,y| x[4] < y[4] }
EndIF
aSort( aCampos , NIL , NIL , bSort )

nXs := Len( aCampos )
SetRegua( nXs )

For nX := 1 To nXs

        IncRegua()  

        IF lEnd
           @ Prow()+1,0 PSAY cCancel
           Exit
        EndIF            

		 /*
			Mascara do Relatorio
					  10        20        30        40        50        60        70        80
			12345678901234567890123456789012345678901234567890123456789012345678901234567890
			Variaveis                      Descricao
			XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/

			cDetalhe := IF( Len( AllTrim( aCampos[nX,1] ) ) < 30 , AllTrim( aCampos[nX,1] ) + ( Space( 30 - Len( AllTrim ( aCampos[nX,1] ) ) ) ) , aCampos[nX,1] )
			cDetalhe := cDetalhe + AllTrim( aCampos[nX,4] )
      	
        Impr( cDetalhe )
        
Next nX

IF aReturn[5] == 1
   Set Printer To
   dbCommit()
   OurSpool(WnRel)
EndIF

//--APAGA OS INDICES TEMPORARIOS--//
If nOrdem == 5
	IF File( cArqNtx + OrdBagExt() )
		fErase( cArqNtx + OrdBagExt() )
	EndIF	
	IF File( cArqNtx + IndexExt() )
		fErase( cArqNtx + IndexExt() )
	EndIF	
Endif                      

MS_FLUSH()

Return( NIL )

/*
	Programa	: GpeWriter
	Funcao		: fDepIR()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Carrega Dependentes de Imp. de Renda
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function fDepIR()
Local Nx,nVezes
	aSize( aDepenIR , 0 )
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If  (SRB->RB_TIPIR == '1') .Or.;
         	(SRB->RB_TIPIR == '2' .And. Year(dDataBase)-Year(SRB->RB_DTNASC) <= 21) .Or. ;
            (SRB->RB_TIPIR == '3' .And. Year(dDataBase)-Year(SRB->RB_DTNASC) <= 24)
			//	Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_NOME,30),SRB->RB_DTNASC,If(SRB->RB_GRAUPAR=='C','Conjuge   ',If(SRB->RB_GRAUPAR=='F','Filho     ','Outros    '))   })
        EndIf
        SRB->(dbSkip())
	EndDo 
	If  Len(aDepenIR) < 10
      	nVezes := (10 - Len(aDepenIR))
		For Nx := 1 to nVezes
			 aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		Next Nx
	EndIf
Return(aDepenIR)

/*
	Programa	: GpeWriter
	Funcao		: fDepSF()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Carrega Dependentes de Salario Familia
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function  fDepSF()
Local Nx,nVezes
	aSize( aDepenSF , 0 )
   While SRB->( !Eof() .and. RB_FILIAL+RB_MAT == SRA->( RA_FILIAL+RA_MAT ) )
		If SRB->( (RB_TIPSF == '1') .Or. (RB_TIPSF == '2' .And. ; 
			Year(dDAtABase) - Year(RB_DTNASC) <= 14))
			//Nome do Depend., Dta Nascimento,Grau Parent.,Local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      	SRB->(aAdd(aDepenSF,{left(RB_NOME,30),RB_DTNASC,If(RB_GRAUPAR=='C','Conjuge   ',If(RB_GRAUPAR=='F','Filho     ','Outros    ')),;
      						RB_LOCNASC,RB_CARTORI,RB_NREGCAR,RB_NUMLIVR,RB_NUMFOLH,RB_DTENTRA,RB_DTBAIXA}))
		EndIf
		SRB->(dbSkip())
	Enddo
   If  Len(aDepenSF) < 10
		nVezes := (10 - Len(aDepenSF))
		For Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		Next Nx
	EndIf

Return(aDepenSF)

/*
	Programa	: GpeWriter
	Funcao		: fPesqSRF()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Carrega Periodo Aquisitivo SRF
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function  fPesqSRF()
Local cAliasSRF := "SRF"
	/* Rotina de Busca Periodo Aquisitivo SRF */

	aSize( aPerSRF , 0 )
	
	dbSelectArea(cAliasSRF)
	
	(cAliasSRF)->( dbSetOrder(RETORDER(cAliasSRF,"RF_FILIAL+RF_MAT+DTOS(RF_DATABAS") ) )
	
	IF (cAliasSRF)->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT) )
   
		While (cAliasSRF)->( !Eof() .And. RF_MAT == SRA->RA_MAT )
				       
				
				IF (cAliasSRF)->RF_STATUS == "1"                       //1= Ativo
					
					//Verifica se o Periodo Aberto não esta Expirado (3 Anos)
					nAnoExp := DDATABASE - (cAliasSRF)->RF_DATAFIM
					
					IF (nAnoExp < 1080 )          
			
			           //Data Inicial Periodo de Ferias, Data Final Periodo de Ferias
      		           (cAliasSRF)->( aAdd(aPerSRF,{RF_DATABAS,RF_DATAFIM } ) )
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
	Programa	: GpeWriter
	Funcao		: fTarProf()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Carrega Informacoes dos lancamentos de tarefas p/ professor
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		:		
-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
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
If SRO->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
	While SRO->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT ) == ( RO_FILIAL + RO_MAT ) .And. nCont < nQtTar )
		If MesAno(SRO->RO_DATA) == MesAno(dDtRef) .And. Eval(bTar) // Fitlra data de referencia e tarefas fixas
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
		SRO->( dbSkip() )
	EndDo
EndIf

For nI := 1 To nQtTar
	aEval( aCpos[nI], { |x| aAdd( aRet[nI], x[2] ) } )
Next

RestArea( aArea )

Return( aRet )

/*
	Programa	: GpeWriter
	Funcao		: fCpos_Word()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Retorna Array com as Variaveis Disponiveis para Impressao
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: aExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)		
				  aExp[x,2] - Conteudo do Campo                (Tam Max. 49)
                  aExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture
				  aExp[x,4] - Descricao da Variaval

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
STATIC Function fCpos_Word()

Local aExp			:= {}
Local aRet			:= {}
Local cTexto_01		:= AllTrim( MV_PAR19 )
Local cTexto_02		:= AllTrim( MV_PAR20 )
Local cTexto_03		:= AllTrim( MV_PAR21 )
Local cTexto_04		:= AllTrim( MV_PAR22 ) 
Local cApoderado	:= ""
Local cRamoAtiv		:= ""   

If cPaisLoc == "ARG"
	If fPHist82(xFilial(),"99","01")
		cApoderado := SubStr(SRX->RX_TXT,1,30)
	EndIf
	If fPHist82(xFilial(),"99","02")
		cRamoAtiv := SubStr(SRX->RX_TXT,1,50) 
	EndIf	           
EndIf	

aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  	, "SRA->RA_FILIAL"			,STR0013	} ) 
aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT												, "SRA->RA_MAT"				,STR0014	} ) 
aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC												, "SRA->RA_CC"				,STR0015	} ) 
aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 				, "@!"						,STR0016	} ) 
aAdd( aExp, {'GPE_NOME'					,	SRA->RA_NOME											, "SRA->RA_NOME"			,STR0017	} ) 
aAdd( aExp, {'GPE_NOMECMP'  			,   If(SRA->(FieldPos("RA_NOMECMP")) # 0  ,SRA->RA_NOMECMP,space(40)), "@!"           ,STR0017 	} )
aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC												, "SRA->RA_CIC"				,STR0018	} ) 
aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS												, "SRA->RA_PIS"				,STR0019	} ) 
aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG												, "SRA->RA_RG"				,STR0020	} ) 
aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG											, "@!"						,STR0152	} ) 
aAdd( aExp, {'GPE_RG_ORG_UF'   			,	SRA->RA_RGUF											, "@!"						,STR0241	} ) 
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
aAdd( aExp, {'GPE_PAI_NOME'	   			,	SRA->RA_PAI												, "SRA->RA_PAI"				,STR0036	} ) 
aAdd( aExp, {'GPE_MAE_NOME'	   			,	SRA->RA_MAE												, "SRA->RA_MAE"				,STR0037	} ) 
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
aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG											, "SRA->RA_ANOCHEG"			,STR0045	} )
aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 	, "SRA->RA_DEPIR"			,STR0046	} )	
aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF											, "SRA->RA_DEPSF"			,STR0047 	} )
aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC											, "SRA->RA_NASC"			,STR0048	} )
aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA											, "SRA->RA_ADMISSA"			,STR0049	} )
aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0050	} )
aAdd( aExp, {'GPE_MES_ADMISSAO'			,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0051 	} )
aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )					, "@!"						,STR0052	} )
aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO											, "SRA->RA_OPCAO"			,STR0053	} )
aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA											, "SRA->RA_DEMISSA"			,STR0054	} ) 
aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP											, "SRA->RA_VCTOEXP"			,STR0055	} )
aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0056	} )
aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0057	} )
aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 					, "@!"						,STR0058	} )
aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)				, "@!"						,STR0059	} )
aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI											, "SRA->RA_EXAMEDI"			,STR0060	} )
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
aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV											, "SRA->RA_SEGUROV"			,STR0087	} )
aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT											, "SRA->RA_PERCADT"			,STR0089	} )
aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC											, "SRA->RA_CATFUNC"			,STR0090	} )
aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")			, "@!"						,STR0091	} )
aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(IF(RA_CATFUNC$"H","P/Hora",IF(RA_CATFUNC$"J","P/Aula","P/Mes"))) 			, "@!"						,STR0092	} )
aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 			, "SRA->RA_TIPOPGT"			,STR0093	} )
aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")			, "@!"						,STR0094	} )
aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO											, "SRA->RA_SALARIO"			,STR0095	} )
aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM											, "SRA->RA_ANTEAUM"			,STR0096	} )
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
aAdd( aExp, {'GPE_DIA_DDATABASE'		,	StrZero( Day( dDataBase ) , 2 )            				, "@!"						,STR0127	} )
aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 								, "@!"						,STR0128	} )
aAdd( aExp, {'GPE_ANO_DDATABASE'		,	StrZero( Year( dDataBase ) , 4 )            			, "@!"						,STR0129	} )
aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	aInfo[03]                              					, "@!"						,STR0130	} )
aAdd( aExp, {'GPE_END_EMPRESA'			,	aInfo[04]                              					, "@!"						,STR0131	} )
aAdd( aExp, {'GPE_CID_EMPRESA'			,	aInfo[05]                              					, "@!"						,STR0132	} )
aAdd( aExp, {'GPE_CEP_EMPRESA'         	,   aInfo[07]                                              	, "!@R #####-###"          	,STR0034 	} )
aAdd( aExp, {'GPE_EST_EMPRESA'         	,   aInfo[06]												, "@!"						,STR0032 	} )
aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	aInfo[08]             									, "@R ##.###.###/####-##"	,STR0134	} )
aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	aInfo[09]                              					, "@!" 						,STR0135	} )
aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	aInfo[10]                              					, "@!" 						,STR0136	} )
aAdd( aExp, {'GPE_FAX_EMPRESA'         	,   If(aInfo[11]#nil ,aInfo[11], "        ")              	, "@!"                     	,STR0136 	} )
aAdd( aExp, {'GPE_BAI_EMPRESA'			,	aInfo[13]                              					, "@!" 						,STR0137	} )
aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")			, "@!" 						,STR0138	} )
aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0139	} )
aAdd( aExp, {'GPE_MES_DEMISSAO'			,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0140 	} )
aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )					, "@!" 						,STR0141 	} )

//Periodo Aquisitivo de Ferias
IF cPaisLoc == "COL"
   aAdd( aExp, {'GPE_DIA_INIFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,1] ) , 2 ),space(02))   , "@!"		,STR0188 	} )
   aAdd( aExp, {'GPE_MES_INIFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,1] ),space(12)) , "@!"    ,STR0189 	} )
   aAdd( aExp, {'GPE_ANO_INIFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,1] ) , 4 ),space(04))  , "@!"		,STR0190 	} )
   
   aAdd( aExp, {'GPE_DIA_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,2] ) , 2 ),space(02))   , "@!"		,STR0191 	} )
   aAdd( aExp, {'GPE_MES_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,2] ),space(12)) , "@!"    ,STR0192 	} )
   aAdd( aExp, {'GPE_ANO_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,2] ) , 4 ),space(04))  , "@!"		,STR0193 	} )
ENDIF   

//SALARIO FAMILIA//
aAdd( aExp, {'GPE_CFILHO01'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL01'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO02'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL02'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO03'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL03'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO04'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL04'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO05'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL05'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO06'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL06'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO07'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL07'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO08'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL08'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO09'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL09'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO10'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[10,1],space(30))		, "@!"                    	,STR0150 	} )
aAdd( aExp, {'GPE_DESC_ESTEMP'         	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      		, "@!"                     	,STR0134 	} ) 
aAdd( aExp, {'GPE_cGrau01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_LOCAL01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,6],space(10))	 	, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,7],space(10))	 	, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,8],space(10))	 	, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,9],space(10))	 	, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,10],space(10))  	, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,4],space(10))	 	, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,06],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,5],space(10))		, "@!"						,STR0156 	} )
aAdd( aExp, {'GPE_NREGISTRO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,7],space(10))	    , "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,10],space(10))		, "@!"						,STR0161 	} ) 
//IMPOSTO DE RENDA//
aAdd( aExp, {'GPE_CDEPE01'             	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,1],space(30))		, "@!"						,STR0154   	} )
aAdd( aExp, {'GPE_CGRDP01'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR01'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,2],space(08)) 		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,1],space(30))		, "@!" 						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR02'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[2,2],space(08))		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR03'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[3,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR04'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[4,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR05'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[5,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR06'				,   if(nDepen==2 .or. nDepen==3,aDepenIR[6,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,3],space(10))		, "@!"						,STR0153	} ) 
aAdd( aExp, {'GPE_DTFLIR07'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[7,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR08'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[8,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR09'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[9,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_CGRDP10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR10'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[10,2],space(08))		, ""                        ,STR0163 	} )

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
	aAdd( aExp, {'GPE_DEPTO'	,	SRA->RA_DEPTO	,	"SRA->RA_DEPTO"		,STR0181 	} )	//Codigo do Departamento
EndIf

If SRA->(FieldPos("RA_POSTO"  )) # 0
	aAdd( aExp, {'GPE_POSTO'	,	SRA->RA_POSTO  ,	"SRA->RA_POSTO"		,STR0182 	} )	//Codigo do Posto
EndIf

If cPaisLoc == "MEX"
	aAdd( aExp, {'GPE_PRINOME'	,	SRA->RA_PRINOME	,	"SRA->RA_PRINOME"	,STR0169	} ) 	//Primeiro Nome 
	aAdd( aExp, {'GPE_SECNOME'	,	SRA->RA_SECNOME	,	"SRA->RA_SECNOME"	,STR0170	} ) 	//Segundo Nome
	aAdd( aExp, {'GPE_PRISOBR'	,	SRA->RA_PRISOBR	,	"SRA->RA_PRISOBR"	,STR0171	} ) 	//Primeiro Sobrenome
	aAdd( aExp, {'GPE_SECSOBR'	,	SRA->RA_SECSOBR	,	"SRA->RA_SECSOBR"	,STR0172	} ) 	//Segundo Sobrenome
	aAdd( aExp, {'GPE_KEYLOC'	,	SRA->RA_KEYLOC	,	"SRA->RA_KEYLOC"	,STR0174	} ) 	//Codigo Local de Pagamento
	aAdd( aExp, {'GPE_TSIMSS'	,	SRA->RA_TSIMSS	,	"SRA->RA_TSIMSS"	,STR0175	} ) 	//Tipo de Salario IMSS
	aAdd( aExp, {'GPE_TEIMSS'	,	SRA->RA_TEIMSS	,	"SRA->RA_TEIMSS"	,STR0176	} ) 	//Tipo de Empregado IMSS
	aAdd( aExp, {'GPE_TJRNDA'	,	SRA->RA_TJRNDA	,	"SRA->RA_TJRNDA"	,STR0177	} ) 	//Tipo de Jornada IMSS
	aAdd( aExp, {'GPE_FECREI'	,	SRA->RA_FECREI	,	"SRA->RA_FECREI"	,STR0178	} ) 	//Data de Readmissao
	aAdd( aExp, {'GPE_DTBIMSS'	,	SRA->RA_DTBIMSS	,	"SRA->RA_DTBIMSS"	,STR0179	} ) 	//Data de Baixa IMSS
	aAdd( aExp, {'GPE_CODRPAT'	,	SRA->RA_CODRPAT	,	"SRA->RA_CODRPAT"	,STR0180	} ) 	//Codigo do Registro Patronal
	aAdd( aExp, {'GPE_CURP'		,	SRA->RA_CURP	,	"SRA->RA_CURP"		,STR0183	} ) 	//CURP
	aAdd( aExp, {'GPE_TIPINF'	,	SRA->RA_TIPINF	,	"SRA->RA_TIPINF"	,STR0184	} ) 	//Tipo de Infonavit
	aAdd( aExp, {'GPE_VALINF'	,	SRA->RA_VALINF	,	"SRA->RA_VALINF"	,STR0185	} ) 	//Valor do Infonavit
	aAdd( aExp, {'GPE_NUMINF'	,	SRA->RA_NUMINF	,	"SRA->RA_NUMINF"	,STR0186	} ) 	//Nro. de Credito Infonavit
EndIf                    

If cPaisLoc == "ANG"
	aAdd( aExp, {'GPE_BIDENT'	     ,	SRA->RA_BIDENT                                	, "SRA->RA_BIDENT"	,STR0195	} ) //Nr. Bilhete Identidade
	aAdd( aExp, {'GPE_BIEMISS'	     ,	SRA->RA_BIEMISS                             	, "SRA->RA_BIEMISS"	,STR0196	} )	//Data de Emissão do Bilhete Identidade
    aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"	,STR0194	} ) //Descrição do Estado Civil
    aAdd( aExp, {'GPE_ESTADO'		 ,  Alltrim(fDescRCC("S001",SRA->RA_ESTADO,1,2,3,30))  , "SRA->RA_ESTADO"	,STR0032	} ) // Descrição do Distrito
EndIf

If SRA->RA_CATFUNC $ "I*J"
	
	aRet := fTarProf()
	
	//Inclusao de variaveis contendo as tarefas fixas e aditamentos fixos dos professores
	aAdd( aExp, {'GPE_DESC_TAR_01'      	,   aRet[1,1], "@!"				, STR0197 	} ) // "Descrição da primeira tarefa"
	aAdd( aExp, {'GPE_AULS_TAR_01'         	,   aRet[1,2], "SRO->RO_QTDSEM"	, STR0198 	} ) // "Aulas por semana da primeira tarefa"
	aAdd( aExp, {'GPE_QTD_TAR_01'         	,   aRet[1,3], "SRO->RO_QUANT"	, STR0199 	} ) // "Quantidade da primeira tarefa"
	aAdd( aExp, {'GPE_VUNI_TAR_01'         	,   aRet[1,4], "SRO->RO_VALOR"	, STR0199 	} ) // "Valor unitário da primeira tarefa"
	aAdd( aExp, {'GPE_VTOT_TAR_01'         	,   aRet[1,5], "SRO->RO_VALTOT"	, STR0199	} ) // "Valor total da primeira tarefa"
	
	aAdd( aExp, {'GPE_DESC_TAR_02'         	,   aRet[2,1], "@!"          	, STR0197 	} ) // "Descrição da segunda tarefa"
	aAdd( aExp, {'GPE_AULS_TAR_02'         	,   aRet[2,2], "SRO->RO_QTDSEM"	, STR0198 	} ) // "Aulas por semana da segunda tarefa"
	aAdd( aExp, {'GPE_QTD_TAR_02'         	,   aRet[2,3], "SRO->RO_QUANT"	, STR0199 	} ) // "Quantidade da segunda tarefa"
	aAdd( aExp, {'GPE_VUNI_TAR_02'         	,   aRet[2,4], "SRO->RO_VALOR"	, STR0199 	} ) // "Valor unitário da segunda tarefa"
	aAdd( aExp, {'GPE_VTOT_TAR_02'         	,   aRet[2,5], "SRO->RO_VALTOT"	, STR0199 	} ) // "Valor total da segunda tarefa"
EndIf

Return( aExp )


/*
	Programa	: GpeWriter
	Funcao		: ChkProfile()
	Autor		: R.H.
	Data		: 05/07/2000
	Descrição	: Avalia o conteudo ja existente no profile e o altera se necessario
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function ChkProfile( lCheck )
	Local cAlias	:= "ProfAlias"
	BEGIN SEQUENCE
		IF !( lCheck )
			BREAK
		ENDIF
		OpenProfile()
		IF .NOT.( (cAlias)->( DbSeek( SM0->M0_CODIGO + Padl( CUSERNAME, 13 ) + cPerg ) ) )
			BREAK
		EndIF
		cCampo	:= SubStr( AllTrim( (cAlias)->P_DEFS ), 487, 75 )
		cCampo	:= Upper( cCampo )
		IF ( ".DOT" $ cCampo .or. ".ODT" $ cCampo .or. ".DOC" $ cCampo .or. ".OTT" $ cCampo )
			BREAK
		EndIF
		IF (cAlias)->( RecLock( cAlias, .F. ) )
			(cAlias)->P_DEFS := ""
			(cAlias)->( MsUnLock() )
		EndIF	
	END SEQUENCE
Return( NIL )

/*
	Programa	: GpeWriter
	Funcao		: GPE2Writer
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Permitir a Impressão de Documentos Funcionais do totvs/protheus no OpenOffice Writer
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function GPE2Writer(lExport,aInfo,cArqWord,lImpress,cArqSaida,nCopias,cPrinter,cOrientation,cError,cCRLF,lPreview)

	Local aFields

	Local cCmd
	Local cDir				:= CurDrive()+"\gpe_writer\"
	Local cField
	Local cFError			:= (cDir+"gpe_writer_error.log")
	Local cDirSave			:= (cDir+"save\")
	Local cPicture
	Local caFields3
	Local cfSemaphore		:= (cDir+"oOOWriter.lck" )
	Local cFWParameters		:= (cDir+"gpe_wparameters.csv")

	Local lOK				:= .F.

	Local n
	Local nWait				:= IF((lImpress:=(ValType(lImpress)=="L".and.lImpress)),1,1)
	Local nFile				:= -1
	Local nField
	Local nFields
	Local nAttempts
	Local nSleep			:= IF( lImpress , .5 , .5 )

	DEFAULT lExport 		:= .T.
	DEFAULT cCRLF			:= CRLF
	DEFAULT lPreview		:= .F.

	BEGIN SEQUENCE

		nAttempts	:= 0
		While !( lIsDir( cDir ) )
			IF ( ++nAttempts > 10 )
				cError	:= "Diretório " + cDir + " Não Encontrado"
				ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
				BREAK
			EndIF
			Sleep(100)
			MakeDir( cDir )
		End While

		IF !( lImpress )
			nAttempts	:= 0
			While !( lIsDir( cDirSave ) )
				IF ( ++nAttempts > 10 )
					cError	:= "Diretório " + cDirSave + " para salvamento dos arquivos Não Encontrado"
					ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
					BREAK
				EndIF
				Sleep(100)
				MakeDir( cDirSave )
			End While
	    	IF .NOT.(lExport)
		    	cArqSaida	:= ( cDirSave + cArqSaida )
		    EndIF
      EndIF
		
		nFile 		:= fCreate(cFWParameters)
		nAttempts	:= 0
		While ( nFile == -1 )
			IF ( ++nAttempts > 10 )
				EXIT
			EndIF
			Sleep(100)
			nFile := fCreate(cFWParameters)
		End While

		IF ( nFile == -1 )
			cError	:= "Impossível Exportar arquivo com Dados para Impressão"
			ApMsgAlert( cError , "A T E N Ç Ã O !!!" )
			BREAK
		EndIF

		aFields	:= fCpos_Word()
		nFields := Len( aFields )
		For n := 1 To 2
			For nField := 1 To nFields
				IF ( n == 1 )
					fWrite(nFile,AllTrim(aFields[nField][1]))
				Else
					IF (SubStr(AllTrim(aFields[nField][3]),4,2)=="->")
						caFields3	:= AllTrim(aFields[nField][3])
						cPicture	:= X3Picture(SubStr(caFields3,AT(">",caFields3)+1))
					Else
						cPicture	:= aFields[ nField ][3]
					EndIF	
					cField			:= Transform(aFields[ nField ][2],cPicture)
					fWrite(nFile,cField)
				EndIF
				IF ( nField < nFields )
					fWrite( nFile , "|" )
				ElseIF ( nField == nFields )
					fWrite( nFile , cCRLF )
				EndIF
			Next nField
		Next n

		fClose( nFile )
		nFile	:= fOpen( cFWParameters , FO_READ )

		IF ( lExport )
			ApMsgAlert( cFWParameters+" Exportado com Sucesso" , "Aviso" )
			lOK	:= .T.
			BREAK
		EndIF

		nAttempts := 0
		While File( cfSemaphore )
			IF ( ++nAttempts >= 100 )
				BREAK
			EndIF
			Sleep( 100 )
			fErase( cfSemaphore )
		End While

		IF !( lImpress )
			cPrinter 		:= "file:///"
			cPrinter 		+= StrTran( cArqSaida , "\" , "/" )
			cOrientation	:= "P"
		EndIF

		cCmd	:= CurDrive()+"\gpe_writer\gpe_writer.exe"
		cCmd	+= " "
		cCmd	+= '"'+cArqWord+'"'
		cCmd	+= " "
		cCmd	+= cValToChar( lImpress )
		cCmd	+= " "
		cCmd	+= cValToChar( nCopias )
		cCmd	+= " "
		cCmd	+= cValToChar( nWait )
		cCmd	+= " "
		cCmd	+= cValToChar( nSleep )
		cCmd	+= " "
		cCmd	+= '"'+cPrinter+'"'
		cCmd	+= " "
		cCmd	+= cOrientation
		cCmd	+= " "
		cCmd	+= '"'+cArqSaida+'"'
		cCmd	+= " "
		cCmd	+= cValToChar( lPreview )

		WaitRun( cCmd , SW_HIDE )

		lOK		:= .not.( File( cFError ) .or. File( cfSemaphore ) )

		IF .not.( lOK )
			IF File( cFError )
				cError	:= MemoRead( cFError )
				fErase( cFError )
			Else
				cError	:= "Operação não completada. Erro Indefinido: " + cfSemaphore
				fErase( cfSemaphore )
			EndIF	
		EndIF

		fClose( nFile )
		nFile 	:= -1
		IF File( cFWParameters )
			fErase( cFWParameters )
		EndIF

	END SEQUENCE

	IF !( nFile == -1 )
		fClose( nFile )
	EndIF

	IF !( lExport )
		IF File( cFWParameters )
			fErase( cFWParameters )
		EndIF	
	EndIF

Return( lOK )

/*
	Programa	: GpeWriter
	Funcao		: ValidPerg
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Verifica as Perguntas a serem utilizadas no Programa
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function ValidPerg(cPerg)

	Local aPerg		:= Array(0)
	Local aGrpSXG


	Local cOrdem	:= Replicate("0", Len( SX1->X1_ORDEM ) )
	Local cGRPSXG	:= ""

	Local cX1Tipo
	Local cPicSXG

	Local nTamSXG	:= 0
	Local nDecSXG	:= 0

	cPerg			:= Padr( cPerg , Len( SX1->X1_GRUPO ) )

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_FILIAL"),X3Decimal("RA_FILIAL"),X3Picture("RA_FILIAL"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_FILIAL","X3_TIPO")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Filial De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Sucursal ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Branch ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH1")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR01")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","XM0")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFILDE.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_FILIAL"),X3Decimal("RA_FILIAL"),X3Picture("RA_FILIAL"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_FILIAL","X3_TIPO")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Filial Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Sucursal ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Branch ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH2")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR02")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","XM0")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFILAT.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= "004"
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_CC"),X3Decimal("RA_CC"),X3Picture("RA_CC"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_CC","X3_TIPO")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Centro de Custo De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Centro de Costo ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Cost Center ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH3")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR03")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","CTT")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCCDE.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= "004"
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_CC"),X3Decimal("RA_CC"),X3Picture("RA_CC"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_CC","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Centro de Custo Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Centro de Costo ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Cost Center ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH4")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR04")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZZZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","CTT")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCCAT.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_MAT"),X3Decimal("RA_MAT"),X3Picture("RA_MAT"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_MAT","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Matricula De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Matricula ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Registration ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH5")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR05")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRA")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHMATD.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_MAT"),X3Decimal("RA_MAT"),X3Picture("RA_MAT"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_MAT","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Matricula Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Matricula ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Registration ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH6")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR06")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRA")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHMATA.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)
	
	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_NOME"),X3Decimal("RA_NOME"),X3Picture("RA_NOME"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_NOME","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nome De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Nombre ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Name ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH7")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR07")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHNOMED.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_NOME"),X3Decimal("RA_NOME"),X3Picture("RA_NOME"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_NOME","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nome Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Nombre ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Name ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH8")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR08")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHNOMEA.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_TNOTRAB"),X3Decimal("RA_TNOTRAB"),X3Picture("RA_TNOTRAB"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_TNOTRAB","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Turno De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Turno ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Shift ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CH9")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR09")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SR6")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHTURDE.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_TNOTRAB"),X3Decimal("RA_TNOTRAB"),X3Picture("RA_TNOTRAB"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_TNOTRAB","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Turno Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Turno ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Shift ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHa")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR10")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SR6")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHTURAT.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)
	

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_CODFUNC"),X3Decimal("RA_CODFUNC"),X3Picture("RA_CODFUNC"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_CODFUNC","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Funcao De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Funcion ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Position ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHb")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR11")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRJ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFUNCD.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_CODFUNC"),X3Decimal("RA_CODFUNC"),X3Picture("RA_CODFUNC"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_CODFUNC","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Funcao Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Funcion ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Position ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHc")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR12")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZZZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","SRJ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHFUNCA.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_SINDICA"),X3Decimal("RA_SINDICA"),X3Picture("RA_SINDICA"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_SINDICA","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Sindicato De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Sindicato ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Union ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHd")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR13")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","RCE")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSINDID.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_SINDICA"),X3Decimal("RA_SINDICA"),X3Picture("RA_SINDICA"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_SINDICA","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Sindicato Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Sindicato ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Union ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHe")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR14")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ZZ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","RCE")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSINDIA.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_ADMISSA"),X3Decimal("RA_ADMISSA"),X3Picture("RA_ADMISSA"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_ADMISSA","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Admissao De ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿De Admision ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"From Adimission ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHf")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR15")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","15/12/1970")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,X3Tamanho("RA_ADMISSA"),X3Decimal("RA_ADMISSA"),X3Picture("RA_ADMISSA"))
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= GetSx3Cache("RA_ADMISSA","X3_TIPO")	
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Admissao Ate ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿A Admision ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"To Admission ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHg")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR16")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","15/12/2999")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,5,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Situacoes  a Impr. ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Situaciones a Impr ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Status to Print ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHh")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","fSituacao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR17")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01"," ADFT")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHSITUA.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,15,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Categorias a Impr. ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Categorias a Impr. ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Categories to Print ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHi")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","fCategoria")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR18")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","ACDEGHMPST")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP",".RHCATEG.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)
	
	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,40,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 01 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Texto Libre 01 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Free Text 01 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHj")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR19")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","< Texto Livre 01 >")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,40,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 02 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Texto Libre 02 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Free Text 02 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHk")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR20")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","< Texto Livre 02 >")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,40,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 03 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Texto Libre 03 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Free Text 03 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHl")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR21")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","< Texto Livre 03 >")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,40,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Texto Livre 04 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Texto Libre 04 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Free Text 04 ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHm")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR22")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","< Texto Livre 04 >")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,3,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Nro. Copias ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Numero Copias ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"CopyNumber ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHn")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","naovazio")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR23")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","1")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,1,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Ordem de Impressao ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Orden de Impresion ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Printing Order ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR24")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Matricula")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Matricula")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Registration")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Centro de Custo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Centro de Costo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Cost Center")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF03","Nome")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA3","Nombre")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG3","Name")  
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF04","Turno")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA4","Turno")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG4","Shift")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF05","Admissao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA5","Admision")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG5","Admission")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,75,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Arquivo do Writer?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Archivo del Writer?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Writer File ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHp")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","fOpen_Word()")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR25")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","1")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,1,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Verific.Dependente ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Verific.Dependiente ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Check Dependant ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHQ")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR26")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Sim")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Si")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Yes")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Nao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","No")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","No")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,1,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]	
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Tipo de Dependente ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Tipo de Dependiente ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Dependent Type ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHR")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",3)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR27")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Dep.Sal.Familia")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Dep.Sal.Familia")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Fam.Allow.Dep.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Dep.Imp.Renda")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Dep.Imp.Renta")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Income Dep.")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Ambos")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Ambos")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Both")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,1,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]	
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Impressao ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Impresion ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Printing ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHS")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR28")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Impressora")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Impresora")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Printer")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Arquivo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Arquivo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Arquivo")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,5,0,"") 
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]
	cX1Tipo		:= "C"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Extensao do arquivo ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Extensión de archivo ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"File Extension ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHT")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","G")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR29")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	cOrdem		:= __Soma1( cOrdem )
	cGRPSXG		:= ""
	aGRPSXG		:= SXGSize(cGRPSXG,1,0,"")
	nTamSXG		:= aGRPSXG[1]
	nDecSXG		:= aGRPSXG[2]
	cPicSXG		:= aGRPSXG[3]	
	cX1Tipo		:= "N"
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERGUNT","Preview ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERSPA" ,"¿Preview ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PERENG" ,"Preview ?")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VARIAVL","MV_CHU")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TIPO",cX1Tipo)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_TAMANHO",nTamSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DECIMAL",nDecSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PRESEL",1)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GSC","C")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VALID","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_VAR01","MV_PAR30")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_CNT01","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF01","Nao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA1","Nao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG1","Nao")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEF02","Sim")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFSPA2","Sim")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_DEFENG2","Sim")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_F3","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PYME","S")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_GRPSXG",cGRPSXG)
	AddPerg(@aPerg,cPerg,cOrdem,"X1_HELP","")
	AddPerg(@aPerg,cPerg,cOrdem,"X1_PICTURE",cPicSXG)

	PutSX1(@cPerg,@aPerg)

Return(Pergunte(cPerg,.F.))

/*
	Programa	: GpeWriter
	Funcao		: PutSX1
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Adiciona e/ou Remove Perguntas utilizadas no Programa
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Procedure PutSX1(cPerg,aPerg)

	Local cKeySeek

	Local lFound
	Local lAddNew

	Local nBL
	Local nEL		:= Len( aPerg )

	Local nAT
	Local nField
	Local nFields
	Local nAtField

	Local __nGrupo	:= 1
	Local __nOrdem	:= 2
	Local __nField	:= 3

	Local uCNT

	SX1->( dbSetOrder( 1 ) ) //X1_GRUPO+X1_ORDEM

	cPerg			:= Padr( cPerg , Len( SX1->X1_GRUPO ) )

	SX1->( dbGoTop() )
	SX1->( dbSeek( cPerg , .F. ) )

	While SX1->( !Eof() .and. X1_GRUPO == cPerg )
		nAT 		:= SX1->( aScan( aPerg , { |x| (  ( x[__nGrupo] == X1_GRUPO ) .and. ( x[__nOrdem] == X1_ORDEM ) ) } ) )
		lFound	:= ( nAT > 0 )
		IF !( lFound )
			IF SX1->( RecLock( "SX1" , .F. ) )	
				SX1->( dbDelete() )
				SX1->( MsUnLock() )
			EndIF
		EndIF
		SX1->( dbSkip() )
	End While

	For nBL := 1 To nEL
		cKeySeek	:= aPerg[nBL][__nGrupo]
		cKeySeek	+= aPerg[nBL][__nOrdem]
		lFound	:= SX1->( dbSeek( cKeySeek , .T. ) )
		lAddNew	:= !( lFound )
		IF SX1->( RecLock( "SX1" , lAddNew ) )
			nFields := Len( aPerg[nBL][__nField] )
			For nField := 1 To nFields
				nAtField := aPerg[nBL][__nField][nField][4]
				lChange	:= ( aPerg[nBL][__nField][nField][3] .and. ( nAtField > 0 ) )
				IF ( lChange )
					uCNT	:= aPerg[nBL][__nField][nField][2]
					SX1->( FieldPut( nAtField , uCNT ) )
				EndIF
			Next nField
			SX1->( MsUnLock() )
		EndIF
	Next nBL

Return

/*
	Programa	: GpeWriter
	Funcao		: AddPerg
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Adiciona Informacoes do compo
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Procedure AddPerg(aPerg,cGrupo,cOrdem,cField,uCNT)

	Local bEval

	Local nAT
	Local nATField

	Local __nGrupo	:= 1
	Local __nOrdem	:= 2
	Local __nField	:= 3

	Static aX1Fields
	Static __cX1Fields

	IF !( Type("cEmpAnt") == "C" )
		Private cEmpAnt := ""
	EndIF

	IF ( ( aX1Fields == NIL ) .or. !( __cX1Fields == cEmpAnt ) )
		__cX1Fields := cEmpAnt
		aX1Fields	:= {;
									{ "X1_GRUPO" 	, NIL , .T. , 0 },;
									{ "X1_ORDEM" 	, NIL , .T. , 0 },;
									{ "X1_PERGUNT"	, NIL , .T. , 0 },;
									{ "X1_PERSPA" 	, NIL , .T. , 0 },;
									{ "X1_PERENG" 	, NIL , .T. , 0 },;
									{ "X1_VARIAVL"	, NIL , .T. , 0 },;
									{ "X1_TIPO" 	, NIL , .T. , 0 },;
									{ "X1_TAMANHO" 	, NIL , .T. , 0 },;
									{ "X1_DECIMAL" 	, NIL , .T. , 0 },;
									{ "X1_PRESEL" 	, NIL , .F. , 0 },;
									{ "X1_GSC" 		, NIL , .T. , 0 },;
									{ "X1_VALID" 	, NIL , .T. , 0 },;
									{ "X1_VAR01" 	, NIL , .T. , 0 },;
									{ "X1_DEF01" 	, NIL , .T. , 0 },;
									{ "X1_DEFSPA1" 	, NIL , .T. , 0 },;
									{ "X1_DEFENG1" 	, NIL , .T. , 0 },;
									{ "X1_CNT01" 	, NIL , .F. , 0 },;
									{ "X1_VAR02" 	, NIL , .T. , 0 },;
									{ "X1_DEF02" 	, NIL , .T. , 0 },;
									{ "X1_DEFSPA2" 	, NIL , .T. , 0 },;
									{ "X1_DEFENG2" 	, NIL , .T. , 0 },;
									{ "X1_CNT02" 	, NIL , .F. , 0 },;
									{ "X1_VAR03" 	, NIL , .T. , 0 },;
									{ "X1_DEF03" 	, NIL , .T. , 0 },;
									{ "X1_DEFSPA3" 	, NIL , .T. , 0 },;
									{ "X1_DEFENG3" 	, NIL , .T. , 0 },;
									{ "X1_CNT03" 	, NIL , .F. , 0 },;
									{ "X1_VAR04" 	, NIL , .T. , 0 },;
									{ "X1_DEF04" 	, NIL , .T. , 0 },;
									{ "X1_DEFSPA4" 	, NIL , .T. , 0 },;
									{ "X1_DEFENG4" 	, NIL , .T. , 0 },;
									{ "X1_CNT04" 	, NIL , .F. , 0 },;
									{ "X1_VAR05" 	, NIL , .T. , 0 },;
									{ "X1_DEF05" 	, NIL , .T. , 0 },;
									{ "X1_DEFSPA5" 	, NIL , .T. , 0 },;
									{ "X1_DEFENG5" 	, NIL , .T. , 0 },;
									{ "X1_CNT05" 	, NIL , .F. , 0 },;
									{ "X1_F3" 		, NIL , .T. , 0 },;
									{ "X1_PYME" 	, NIL , .T. , 0 },;
									{ "X1_GRPSXG" 	, NIL , .T. , 0 },;
									{ "X1_HELP" 	, NIL , .T. , 0 },;
									{ "X1_PICTURE" 	, NIL , .T. , 0 },;
									{ "X1_IDFIL" 	, NIL , .T. , 0 };
							}

			bEval := { |x,y|;
									nATField 		:= FieldPos(aX1Fields[y][1]),;
									aX1Fields[y][2]	:= GetValType(ValType(FieldGet(nATField))),;
									aX1Fields[y][4]	:= nATField,;
			         }
 		
			SX1->(aEval(aX1Fields,bEval))

		EndIF

		nAT := aScan( aPerg , { |x| ( ( x[1] == cGrupo ) .and. ( x[2] == cOrdem ) ) } ) 

		IF ( nAT == 0 )
			aAdd( aPerg , { cGrupo , cOrdem , aClone( aX1Fields ) } )
			nAT := Len( aPerg )
		EndIF

		cField		:= Upper( AllTrim( cField ) )
		nATField	:= aScan( aPerg[nAT][3] , { |e| ( e[1] == cField ) } )

		IF ( nATField > 0 )

			aPerg[nAT][__nField][nATField][2]	:= uCNT

			nATField	:= aScan( aPerg[nAT][3] , { |e| ( e[1] == "X1_GRUPO" ) } )
			IF ( nATField > 0 )
				aPerg[nAT][__nField][nATField][2]	:= cGrupo
			EndIF

			nATField	:= aScan( aPerg[nAT][3] , { |e| ( e[1] == "X1_ORDEM" ) } )
			IF ( nATField > 0 )
				aPerg[nAT][__nField][nATField][2]	:= cOrdem
			EndIF	

		EndIF

Return

/*
	Programa	: GpeWriter
	Funcao		: SXGSize
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Obtem Informações do Grupo em SXG (Size e Picture)
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function SXGSize( cGRPSXG , nSize , nDec , cPicture )

	Local cSXGPict

	Local nSXGDec
	Local nSXGSize

	DEFAULT nSize		:= 0
	DEFAULT nDec		:= 0
	DEFAULT cPicture	:= ""

	IF !Empty( cGRPSXG )

		SXG->( dbSetOrder( 1 ) ) //XG_GRUPO
		
		lFound			:= SXG->( MsSeek( cGRPSXG , .F. ) )
		
		IF ( lFound )
			nSXGSize	:= SXG->XG_SIZE
			cSXGPict	:= SXG->XG_PICTURE	
		Else
			cSXGPict	:= cPicture
			nSXGSize	:= nSize
		EndIF
		
		nSXGDec			:= nDec

	Else

		nSXGSize		:= nSize
		nSXGDec			:= nDec
		cSXGPict		:= cPicture

	EndIF

Return( { nSXGSize , nSXGDec , cSXGPict } )

/*
	Programa	: GpeWriter
	Funcao		: X3Tamanho()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Obtem o Tamanho do campo 
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function X3Tamanho(cField)
	Local nTamanho		:= GetSx3Cache(@cField,"X3_TAMANHO")
	DEFAULT nTamanho	:= 0
Return(nTamanho)

/*
	Programa	: GpeWriter
	Funcao		: X3Decimal()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Obtem a Decimal do campo 
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function X3Decimal(cField)
	Local nDecimal		:= GetSx3Cache(@cField,"X3_DECIMAL")
	DEFAULT nDecimal	:= 0
Return(nDecimal)

/*
	Programa	: GpeWriter
	Funcao		: X3Picture
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Obtem a Picture do Campo
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function X3Picture(cField)
	Local cPicture		:= GetSx3Cache(@cField,"X3_PICTURE")
	DEFAULT cPicture	:= ""
	cPicture			:= AllTrim(cPicture)
Return(cPicture)

/*
	Programa	: GpeWriter
	Funcao		: CurDrive()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 02/07/2012
	Descrição	: Retorna o Driver Drive para gravacao dos arquivos
	Sintaxe		: Chamada padrao para programas em "RdMake".
	Uso			: Generico
	Obs.		: 

-------------------------------------------------------------------------
			ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL.             
-------------------------------------------------------------------------
Programador		|Data      |Motivo Alteracao
-------------------------------------------------------------------------
                |DD/MM/YYYY|
-------------------------------------------------------------------------*/
Static Function CurDrive()
	Local cDriver
	Local cTempPath	:= GetTempPath(.T.)
	SplitPath(cTempPath,@cDriver)	
Return(cDriver)