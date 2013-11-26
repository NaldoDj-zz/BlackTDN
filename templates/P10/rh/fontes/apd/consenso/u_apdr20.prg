#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
зддддддддддбддддддддддбдддддбддддддддддддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁAPDR20    ЁAutorЁMarinaldo de Jesus		           ЁData  Ё20/11/2009Ё
цддддддддддеддддддддддадддддаддддддддддддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescricoesЁRelatСrio de Avaliacao por CompetЙncia								 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSINAF																 Ё
цддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL                    Ё
цддддддддддддбддддддддддбдддддддддддбдддддддддддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                         Ё
цддддддддддддеддддддддддедддддддддддедддддддддддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                    						 Ё
юддддддддддддаддддддддддадддддддддддадддддддддддддддддддддддддддддддддддддддддддды/*/
User Function APDR20()
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Mascara do RelatСrio (220 Colunas)                           Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	    		10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	  	EMPRESA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX     					     AVLIAгцO INDIVIDUAL
	    аREA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                        
	    AVALIAгцO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     
		------------------------------------------------------------------------------------------------------------------------------------	
	  	ITEM   COMPETйNCIA                                                  QTD. RESPOSTA(S)  MиDIA аREA  MиDIA EMPRESA  (%)(аREA x EMPRESA) 
	  	999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX      999.99         999.99       999.99              999       
	/*/

	Local aArea		:= GetArea()
	Local aOrd		:= {}
	Local aImpress	:= aClone( __aImpress )
	
	Local cDesc1	:= OemToAnsi("RelatСrio de AvaliaГЦo por CompetЙncia")
	Local cDesc2	:= OemToAnsi("Ser═ impresso de acordo com os parametros solicitados pelo")
	Local cDesc3	:= OemToAnsi("usu═rio.")
	Local cAlias	:= "RD0"	//Alias do arquivo Principal ( Base )
	Local cPerg		:= Padr( "U_APDR20" , Len( SX1->X1_GRUPO ) )
	
	Local wnRel
	Local cMsgAlert
	
	Private aReturn  := {;
							"Zebrado"		,;	//01 -> "Zebrado" -> Descricao do Tipo de Formulario que aparecera na Pasta Opcionais
							NIL				,;  //02 -> Reservado...
							"Administra┤└o"	,;	//03 -> "Administra┤└o" -> Descricao do Destinatario que aparecera na Pasta Opcionais
							2				,;  //04 -> Orientacao do RelatСrio 1=Retrato;2=Paisagem
							NIL				,;  //05 -> Local da Impressao
							NIL				,;	//06 -> Nome com que o arquivo sera salvo
							NIL				,;	//07 -> Filtro DEFAULT do RelatСrio que sera utilizado na Pasta Filtro
							1		 		;	//08 -> Ordem DEFAULT do RelatСrio que srea utilizado na Pasta Ordem
						}
	
	Private NomeProg := FunName()
	Private Titulo   := cDesc1
	Private nTamanho := "M"
	Private wCabec0  := 3
	Private wCabec1  := "EMPRESA:"
	Private wCabec2  := "аREA:"
	Private wCabec3  := "AVALIAгцO:"
	
	Private ContFl   := 1
	Private Li       := 0
	Private nLastKey := 0

	Private cAPDRAva
	Private cAPDRDep
	Private cAPDREmp
	Private cAPDRFil
	Private dAPDRIni
	Private dAPDRFim
	
	BEGIN SEQUENCE

		Pergunte( cPerg , .F. )

		APDR20AvaVld(.F.)
		APDR20DepVld(.F.)
		APDR20EmpVld(.F.)
		APDR20FilVld(.F.)
		APDR20IniVld(.F.)
		APDR20FimVld(.F.)
    
		__aImpress[1] := 1

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Envia controle para a funcao SETPRINT                        Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		wnRel := NomeProg
		wnRel := SetPrint(;
							""			,;	//01 -> cAlias:			Alias da Tabela
							wnRel		,;	//02 -> cNome: 			Nome do RelatСrio
							cPerg		,;	//03 -> cPerg: 			Grupo de Perguntas
							@Titulo 	,;	//04 -> cDesc: 			Descricao do RelatСrio
							cDesc1		,;	//05 -> cCnt1: 			1a. Descricao que aparecera no Rodape da Pasta Impressao
							cDesc2		,;	//06 -> cCnt2: 			2a. Descricao que aparecera no Rodape da Pasta Impressao	
							cDesc3		,;	//07 -> cCnt3: 			3a. Descricao que aparecera no Rodape da Pasta Impressao
							.F.			,;	//08 -> lDic:  			Se Disponibilizara Pasta para Selecao dos Campos
							aOrd		,;	//09 -> aOrd:  			Array com a Descricao das Ordens para Selecao	
							.T.			,;	//10 -> lCompres: 		Se habilitara compressao do RelatСrio
							nTamanho    ,;	//11 -> cSize: 			Tamanho do RelatСrio "P=80Colunas";"M=132Colunas";"G=220Colunas"
							NIL			,;	//12 -> aFilter: 		Array com expressao de Filtro
							.F.			,;	//13 -> lFiltro: 		Se habilitara a Pasta Filtro
							.F.			,;	//14 -> lCrystal: 		Se RelatСrio esta integrado ao Crystal Report
							NIL			,;	//15 -> cNameDrv: 		Nome do Drive que sera utilizado para a impressao
							NIL			,;	//16 -> lNoAsc: 		Se mostrara a Caixa de Dialogo para a SetPrint
							NIL			,;	//17 -> lServer: 		Se a impressao sera no servidor
							NIL			 ;	//18 -> cPortToPrint:	Porta para a Impressao
						)
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Se pressionou a Tecla "ESC" abandona                         Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( nLastKey == 27 )
			Break
		EndIF
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Chamada a SetDefault para carga das Informacoes do  SelecionaЁ
		Ё das na SetPrint()											   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		SetDefault(;
						@aReturn	,;	//01 -> aRet:		Array com a Estrutura do aReturn	
						cAlias		,;	//02 -> cAlias:		Alias do Arquivo
						NIL			,;	//03 -> lPortr:		Se Retrato 
						NIL			,;	//04 -> lNoAsk:		Se tera Display
						@nTamanho	,;	//05 -> cSize:		Tamanho do RelatСrio
						2			 ;	//06 -> nOrienta:	Orientacao do RelatСrio ( 1-Retrato; 2-Paisagem )
					)
	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Se pressionou a Tecla "ESC" abandona                         Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF ( nLastKey == 27 )
		   Break
		EndIF
		
		Pergunte( cPerg , .F. )

		IF !( APDR20AvaVld() )
			Break
		EndIF
		
		IF !( APDR20DepVld() )
			Break
		EndIF
		
		IF !( APDR20EmpVld() )
			Break
		EndIF
		
		IF !( APDR20FilVld() )
			Break
		EndIF

		IF !( APDR20IniVld() )
			Break
		EndIF

		IF !( APDR20FimVld() )
			Break
		EndIF
		
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Chamada a Rotina de Impressao							   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		RptStatus( { |lEnd| PrintRel( @lEnd , @wnRel , @cPerg ) } , Titulo )
		
	END SEQUENCE
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Restaura os Ponteiros de Entrada							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	__aImpress := aClone( aImpress )
	RestArea( aArea )

Return( NIL )

/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁU_InAPDR20    ЁAutor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar Funcoes Dentro de APDR010                           Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InAPDR20( cExecIn , aFormParam )						 	 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                 	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                      	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 													 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function InAPDR20( cExecIn , aFormParam )
         
Local uRet

DEFAULT cExecIn		:= ""
DEFAULT aFormParam	:= {}

IF !Empty( cExecIn )
	cExecIn	:= BldcExecInFun( cExecIn , aFormParam )
	uRet	:= &( cExecIn )
EndIF

Return( uRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁPrintRel    Ё Autor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁImprime Detalhes do RelatСrio								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function PrintRel( lEnd , wnRel , cPerg )

	Local cAlsQry		:= GetNextAlias()
	
	Local cDet			:= ""
	Local cDetCab0		:= OemToAnsi("ITEM   COMPETйNCIA                                                  QTD. RESPOSTA(S)  MиDIA аREA  MиDIA EMPRESA  (%)(аREA x EMPRESA) ")
	
	Local cCodAva		:= MV_PAR01
	Local cCodDep   	:= MV_PAR02
	Local cCodEmp   	:= MV_PAR03
	Local cCodFil   	:= MV_PAR04
	
	Local cSvEmpAnt		:= cEmpAnt
	Local cSvFilAnt		:= cFilAnt
	
	Local cCodComp		:= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_CODCOM" , RetOrder( "RD6", "RD6_FILIAL+RD6_CODIGO" ) , .F. )

	Local nTp3Cnt 		:= 0
	Local nTp3AvgDep	:= 0
	Local nTp3AvgEmp	:= 0
	Local nTp3DepEmp	:= 0

	Local oException    
	
	TRYEXCEPTION
		
		SM0->( dbSetOrder( 1 ) )
		IF SM0->( !dbSeek( cCodEmp + cCodFil ) )
			UserExeption( "Empresa ou Filial nЦo Cadastrada no SIGAMAT.EMP!" )
		EndIF

		IF ( cCodEmp <> cEmpAnt )
			GetEmpr( cCodEmp + cCodFil ) 
		EndIF

		wCabec1 	+= SM0->( Padr( AllTrim(M0_NOMECOM) + "/" + AllTrim(M0_FILIAL) + "/" + AllTrim(M0_NOME)  , Len(M0_NOMECOM)+Len(M0_FILIAL)+Len(M0_NOME) ) )
		wCabec1 	+= Padl("AVALIAгцO INDIVIDUAL",132-Len(wCabec1))
		wCabec1 	:= OemToAnsi(wCabec1)

		wCabec2 	+= GetCache( "SQB" , cCodDep , xFilial("SQB",cCodFil) , "QB_DESCRIC" , RetOrder( "SQB" , "QB_FILIAL+QB_DEPTO" ) , .F. )
		wCabec2 	:= OemToAnsi(wCabec2)

		wCabec3 	+= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_DESC" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )  
		wCabec3 	:= OemToAnsi(wCabec3)
		
		BEGINSQL ALIAS cAlsQry

			SELECT 
				RD2.RD2_ITEM,
				RD2_DESC,
					ISNULL((
						SELECT
							 COUNT(*)
						FROM
							%table:RDD% RDD,
							%table:RDZ% RDZ,
							%table:RD6% RD6,
							%table:SRA% SRA,
							%table:CTT% CTT
						WHERE 
							RDD.%NotDel% AND
							RDZ.%NotDel% AND
							RD6.%NotDel% AND
							SRA.%NotDel% AND 
							CTT.%NotDel% AND
							RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
							RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
							RDZ.RDZ_FILENT = %exp:cCodFil% AND
							RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
							RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
							SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
							CTT.CTT_FILIAL = %exp:xFilial("CTT",cCodFil)% AND
							RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
							RD6.RD6_CODIGO = %exp:cCodAva% AND
							RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
							RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
							RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
							RDD.RDD_TIPOAV = '3' AND
							RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
							RDD.RDD_ITECOM = RD2.RD2_ITEM AND
							SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
							SRA.RA_CC = CTT.CTT_CUSTO AND
							CTT.CTT_DEPTO = %exp:cCodDep%
					  ),0.00) TP3CNT,
				ISNULL((
						SELECT
							ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
						FROM
							%table:RDD% RDD,
							%table:RDZ% RDZ,
							%table:RD6% RD6,
							%table:SRA% SRA,
							%table:CTT% CTT
						WHERE
							RDD.%NotDel% AND
							RDZ.%NotDel% AND
							RD6.%NotDel% AND
							SRA.%NotDel% AND
							CTT.%NotDel% AND
							RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
							RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
							RDZ.RDZ_FILENT = %exp:cCodFil% AND
							RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
							RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
							SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
							CTT.CTT_FILIAL = %exp:xFilial("CTT",cCodFil)% AND
							RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
							RD6.RD6_CODIGO = %exp:cCodAva% AND
							RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
							RDD.RDD_TIPOAV = '3' AND
							RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
							RDD.RDD_ITECOM = RD2.RD2_ITEM AND
							RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
							RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
							SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
							SRA.RA_CC = CTT.CTT_CUSTO AND
							CTT.CTT_DEPTO = %exp:cCodDep%
						GROUP BY
							RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
					),0.00) TP3AVGDEP,
				ISNULL((
						SELECT
							ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
						FROM
							%table:RDD% RDD,
							%table:RDZ% RDZ,
							%table:RD6% RD6
						WHERE
							RDD.%NotDel% AND
							RDZ.%NotDel% AND
							RD6.%NotDel% AND
							RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
							RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
							RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
							RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
							RD6.RD6_CODIGO = %exp:cCodAva% AND
							RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
							RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
							RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
							RDD.RDD_TIPOAV = '3' AND
							RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
							RDD.RDD_ITECOM = RD2.RD2_ITEM
						GROUP BY
							RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
					),0.00) TP3AVGEMP
			FROM
				%table:RDM% RDM,
				%table:RD2% RD2
			WHERE
				RDM.%NotDel% AND
				RD2.%NotDel% AND
				RDM.RDM_FILIAL = %exp:xFilial("RDM",cCodFil)% AND
				RD2.RD2_FILIAL = %exp:xFilial("RD2",cCodFil)% AND
				RDM.RDM_CODIGO = %exp:cCodComp% AND
				RD2.RD2_CODIGO = RDM.RDM_CODIGO
			ORDER BY
				RD2.RD2_FILIAL,RD2.RD2_CODIGO,RD2.RD2_ITEM

		ENDSQL
		
		Impr( cDetCab0 )
		Impr( "" )
		
		SetRegua( 0 )
	
		While (cAlsQry)->( !Eof() )
	
			IncRegua()
			
			IF ( lEnd )
				Impr( OemToAnsi( cCancel ) )
				Exit
			EndIF

			nTp3Cnt 	:= (cAlsQry)->TP3CNT
			nTp3AvgDep	:= (cAlsQry)->TP3AVGDEP
			nTp3AvgEmp	:= (cAlsQry)->TP3AVGEMP
			nTp3DepEmp	:= NoRound( ( ( nTp3AvgDep/nTp3AvgEmp) * 100 ) , 2 )

			cDet := "_ITEM_ _D_E_S_C_R_I_C_A_O__D_A__C_O_M_P_E_T_E_N_C_I_A______________      QTDRES         MEDARE       MEDESP              PAE       "

			cDet := StrTran( cDet , "_ITEM_" , (cAlsQry)->RD2_ITEM )
			cDet := StrTran( cDet , "_D_E_S_C_R_I_C_A_O__D_A__C_O_M_P_E_T_E_N_C_I_A______________" , (cAlsQry)->RD2_DESC )
			cDet := StrTran( cDet , "QTDRES" , TransForm( nTp3Cnt , "@E 999.99" ) )
	        cDet := StrTran( cDet , "MEDARE" , TransForm( nTp3AvgDep , "@E 999.99" ) )
	        cDet := StrTran( cDet , "MEDESP" , TransForm( nTp3AvgEmp , "@E 999.99" ) )
	        cDet := StrTran( cDet , "PAE"    , TransForm( nTp3DepEmp , "@E 999.99" ) )
	
			IF ( Li == 57 )
				++LI
				Impr( cDetCab0 )
				Impr( "" )
			EndIF 
	
			Impr( OemToAnsi( cDet ) )
			
			(cAlsQry)->( dbSkip() )
			
		End While
		
		(cAlsQry)->( dbCloseArea() )
	
		SET DEVICE TO SCREEN
		IF ( aReturn[5] == 1 )
			SET PRINTER TO
			dbCommit()
			OurSpool( wnRel )
		EndIF
		
		Ms_Flush()
	
	CATCHEXCEPTION USING oException
	
		MsgAlert( oException:Description , "Alerta!" )

	ENDEXCEPTION

	IF !( cSvEmpAnt == cEmpAnt )
		GetEmpr( cSvEmpAnt+cSvFilAnt )		
	EndIF
	
Return( NIL  )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20AvaVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da AvaliaГЦo								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20AvaVld( lValid )
	
	Local lRet := .T.
	Local oException
	
	cAPDRAva := MV_PAR01
	
	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			RD6->( dbSetOrder( RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) ) )
			IF RD6->( !dbSeek( xFilial( "RD6" ) + cAPDRAva ) )
				UserException( "CСdigo de AvaliaГЦo Informado NЦo Existente na Tabela RD6" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20DepVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo do Departamento								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20DepVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDRDep := MV_PAR02

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			SQB->( dbSetOrder( RetOrder( "SQB" , "QB_FILIAL+QB_DEPTO" ) ) )
			IF SQB->( !dbSeek( xFilial( "SQB" ) + cAPDRDep ) )
				UserException( "CСdigo do Departamento Informado NЦo Existente na Tabela SQB" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20EmpVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da Empresa									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20EmpVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDREmp := MV_PAR03

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			SM0->( dbSetOrder( 1 ) )
			SM0->( dbSeek( cAPDREmp , .T. ) )
			IF !( SM0->M0_CODIGO == cAPDREmp )
				UserException( "CСdigo da Empresa Informado InvАlido" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20FilVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё20/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da Filial									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20FilVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDREmp := MV_PAR03
	cAPDRFil := MV_PAR04

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			SM0->( dbSetOrder( 1 ) )
			IF SM0->( !dbSeek( cAPDREmp + cAPDRFil ) )
				UserException( "Filial InvАlida" )
			EndIF
		ENDIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description  , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20IniVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё18/01/2010Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Inicio da Avaliacao								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20IniVld( lValid )

	Local cKeySeek
	
	Local lRet 		:= .T.
	
	Local nRDPOrder	:= RetOrder( "RDP" , "RDP_FILIAL+RDP_CODAVA+DTOS(RDP_DATINI)" )
	
	Local oException

	dAPDRIni := MV_PAR05

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			RDP->( dbSetOrder( nRDPOrder ) )
			cKeySeek := xFilial("RDP",xFilial("RD6",cFilAnt))+cAPDRAva+Dtos(dAPDRIni)
			IF RDP->( !dbSeek( cKeySeek ) )
				UserException( "Data Inicio da AvaliaГЦo InvАlida" )
			EndIF
		ENDIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description  , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁAPDR20FimVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё18/01/2010Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Fimcio da Avaliacao								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR20FimVld( lValid )

	Local cKeySeek
	
	Local lRet 		:= .T.
	
	Local nRDPOrder	:= RetOrder( "RDP" , "RDP_FILIAL+RDP_CODAVA+DTOS(RDP_DATFim)" )
	
	Local oException

	dAPDRFim := MV_PAR06

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			RDP->( dbSetOrder( nRDPOrder ) )
			cKeySeek := xFilial("RDP",xFilial("RD6",cFilAnt))+cAPDRAva+Dtos(dAPDRIni)
			IF RDP->( !dbSeek( cKeySeek ) )
				UserException( "Data Final da AvaliaГЦo InvАlida" )
			EndIF
			IF !( dAPDRFim == RDP->RDP_DATFIM )
				UserException( "Data Final da AvaliaГЦo InvАlida" )
			EndIF
		ENDIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description  , "Alerta!" )
	ENDEXCEPTION

Return( lRet )