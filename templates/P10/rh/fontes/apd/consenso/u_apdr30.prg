#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
зддддддддддбддддддддддбдддддбддддддддддддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁAPDR30    ЁAutorЁMarinaldo de Jesus		           ЁData  Ё21/11/2009Ё
цддддддддддеддддддддддадддддаддддддддддддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescricoesЁRelatСrio de AvaliaГЦo por Grupo de Cargo							 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSINAF																 Ё
цддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL                    Ё
цддддддддддддбддддддддддбдддддддддддбдддддддддддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                         Ё
цддддддддддддеддддддддддедддддддддддедддддддддддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                    						 Ё
юддддддддддддаддддддддддадддддддддддадддддддддддддддддддддддддддддддддддддддддддды/*/
User Function APDR30()
	
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Mascara do RelatСrio (220 Colunas)                           Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	    		10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	  	EMPRESA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX                                                                  NOTA MEDIA DA AVALIAгцO INDIVIDUAL DOS COLABORADORES DA EMPRESA: 999.99
	    аREA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                    NOTA MEDIA DA AVALIAгцO INDIVIDUAL DOS COLABORADORES DA аREA: 999.99
	    AVALIAгцO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                      NOTA DA AVALIAгцO DE DESEMPENHO DA аREA: 999.99
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        CсDIGO GRUPO DO CARGO                 MиDIA ESPERADA                           NOTA                                            (%)                          (%)
	 	                                                         MиDIA DOS COLABORADORES DA аREA ALOCADOS NO CARGO)     (MиDIA DA MESMA CATEGORIA)     (SOBRE A MEDIA ESPERADA)
	  	99     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    999.99      	                    999.99  								       999.99                        999.99
	/*/        

	Local aArea		:= GetArea()
	Local aOrd		:= {}
	Local aImpress	:= aClone( __aImpress )
	
	Local cDesc1	:= OemToAnsi( "RelatСrio de AvaliaГЦo por Grupo de Cargo" )
	Local cDesc2	:= OemToAnsi( "Ser═ impresso de acordo com os parБmetros solicitados pelo" )
	Local cDesc3	:= OemToAnsi( "usu═rio." )
	Local cAlias	:= "RD0"	//Alias do arquivo Principal ( Base )
	Local cPerg		:= Padr( "U_APDR30" , Len( SX1->X1_GRUPO ) )
	
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
	Private nTamanho := "G"
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

		APDR30AvaVld(.F.)
		APDR30DepVld(.F.)
		APDR30EmpVld(.F.)
		APDR30FilVld(.F.)
		APDR30IniVld(.F.)
		APDR30FimVld(.F.)
    
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

		IF !( APDR30AvaVld() )
			Break
		EndIF
		
		IF !( APDR30DepVld() )
			Break
		EndIF
		
		IF !( APDR30EmpVld() )
			Break
		EndIF
		
		IF !( APDR30FilVld() )
			Break
		EndIF

		IF !( APDR30IniVld() )
			Break
		EndIF

		IF !( APDR30FimVld() )
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
ЁFun┤└o    ЁU_InAPDR30    ЁAutor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar Funcoes Dentro de APDR010                           Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InAPDR30( cExecIn , aFormParam )						 	 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                 	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                      	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 													 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function InAPDR30( cExecIn , aFormParam )
         
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
ЁFun┤┘o    ЁPrintRel    Ё Autor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
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
	Local cDetCab0		:= OemToAnsi("CсDIGO GRUPO DO CARGO                 MиDIA ESPERADA                           NOTA                                            (%)                          (%)")
	Local cDetCab1		:= OemToAnsi("                                                         MиDIA DOS COLABORADORES DA аREA ALOCADOS NO CARGO)     (MиDIA DA MESMA CATEGORIA)     (SOBRE A MEDIA ESPERADA)")
	
	Local cCodAva		:= MV_PAR01
	Local cCodDep   	:= MV_PAR02
	Local cCodEmp   	:= MV_PAR03
	Local cCodFil   	:= MV_PAR04
	
	Local cSvEmpAnt		:= cEmpAnt
	Local cSvFilAnt		:= cFilAnt

	Local nEmpCon		:= 0

	Local nDepCon		:= 0

	Local nSQ3Media		:= 0
	Local nRd6Media		:= 0

	Local nTp3AvgDep	:= 0
	Local nTp3AvgEmp	:= 0

	Local oException    
	
	TRYEXCEPTION

		SM0->( dbSetOrder( 1 ) )
		IF SM0->( !dbSeek( cCodEmp + cCodFil ) )
			UserExeption( "Empresa ou Filial nЦo Cadastrada no SIGAMAT.EMP!" )
		EndIF

		IF ( cCodEmp <> cEmpAnt )
			GetEmpr( cCodEmp + cCodFil ) 
		EndIF

		BEGINSQL ALIAS cAlsQry
			SELECT
				RDD.RDD_CODAVA,
				RDD.RDD_TIPOAV,
				ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
			FROM
				%table:RDD% RDD,
				%table:RDZ% RDZ,
				%table:RD6% RD6
			WHERE
				RDD.%NotDel% AND
				RDZ.%NotDel% AND
				RD6.%NotDel% AND
				RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
				RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
				RDZ.RDZ_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
				RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
				RD6.RD6_CODIGO = %exp:cCodAva% AND
				RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
				RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
				RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
				RDD.RDD_TIPOAV = '3'
			GROUP BY
				RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV                          
		ENDSQL
	
		SetRegua( 0 )
	
		While ( cAlsQry )->( !Eof() )
			IncRegua()
			nEmpCon	+= ( cAlsQry )->RDD_RESOBT
			( cAlsQry )->( dbSkip() )
		End While

		( cAlsQry )->( dbCloseArea() )

		BEGINSQL ALIAS cAlsQry
			SELECT
				RDD.RDD_CODAVA,
				RDD.RDD_TIPOAV,
				CTT.CTT_DEPTO,
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
				RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
				RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
				SRA.RA_FILIAL  = %exp:xFilial("SRA",cCodFil)% AND
				CTT.CTT_FILIAL  = %exp:xFilial("CTT",cCodFil)% AND
				RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
				RD6.RD6_CODIGO = %exp:cCodAva% AND
				RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
				RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
				RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
				RDD.RDD_TIPOAV = '3' AND
				SRA.RA_FILIAL+SRA.RA_MAT = RDZ.RDZ_CODENT AND
				SRA.RA_CC = CTT.CTT_CUSTO AND
				CTT.CTT_DEPTO = %exp:cCodDep%
			GROUP BY
				RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV,CTT.CTT_DEPTO
		ENDSQL
		
		SetRegua( 0 )
	
		While ( cAlsQry )->( !Eof() )
			IncRegua()
			nDepCon	+= ( cAlsQry )->RDD_RESOBT
			( cAlsQry )->( dbSkip() )
		End While
	
		( cAlsQry )->( dbCloseArea() )

		wCabec1 	+= SM0->( Padr( AllTrim(M0_NOMECOM) + "/" + AllTrim(M0_FILIAL) + "/" + AllTrim(M0_NOME)  , Len(M0_NOMECOM)+Len(M0_FILIAL)+Len(M0_NOME) ) )
		wCabec1 	+= PadL("NOTA MEDIA DA AVALIAгцO INDIVIDUAL DOS COLABORADORES DA EMPRESA: " + TransForm( nEmpCon , "@E 999.99" ),220-Len(wCabec1))
		wCabec1		:= OemToAnsi( wCabec1 )
	
		wCabec2 	+= GetCache( "SQB" , cCodDep , xFilial("SQB",cCodFil) , "QB_DESCRIC" , RetOrder( "SQB" , "QB_FILIAL+QB_DEPTO" ) , .F. )
		wCabec2 	+= PadL("NOTA MEDIA DA AVALIAгцO INDIVIDUAL DOS COLABORADORES DA аREA: " + TransForm( nDepCon , "@E 999.99" ),220-Len(wCabec2))
		wCabec2		:= OemToAnsi( wCabec2 )
	
		nRd6Media	:= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_NMEDIA" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )
		
		wCabec3 	+= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_DESC" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )  
		wCabec3 	+= PadL("NOTA DA AVALIAгцO DE DESEMPENHO DA аREA: " + TransForm( nRd6Media  , "@E 999.99" ),220-Len(wCabec3)) 
		wCabec3		:= OemToAnsi( wCabec3 )

		BEGINSQL ALIAS cAlsQry
			SELECT 
				SQ3.Q3_CARGO,
				SQ3.Q3_DESCSUM,
				SQ3.Q3_NMEDIA,
				ISNULL((
						SELECT
							ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
						FROM
							%table:RDD% RDD,
							%table:RDZ% RDZ,
							%table:RD6% RD6,
							%table:SRA% SRA,
							%table:SRJ% SRJ,
							%table:CTT% CTT
						WHERE
							RDD.%NotDel% AND
							RDZ.%NotDel% AND
							RD6.%NotDel% AND
							SRA.%NotDel% AND
							SRJ.%NotDel% AND
							CTT.%NotDel% AND
							RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
							RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
							RDZ.RDZ_FILENT = %exp:cCodFil% AND
							RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%AND
							RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
							SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
							SRJ.RJ_FILIAL = %exp:xFilial("SRJ",cCodFil)% AND
							CTT.CTT_FILIAL = %exp:xFilial("CTT",cCodFil)% AND
							RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
							RD6.RD6_CODIGO = %exp:cCodAva% AND
							RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
							RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
							RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
							RDD.RDD_TIPOAV = '3' AND
							SRA.RA_FILIAL+SRA.RA_MAT = RDZ.RDZ_CODENT AND
							SRA.RA_CODFUNC = SRJ.RJ_FUNCAO AND
							SRA.RA_CC = CTT.CTT_CUSTO AND
							CTT.CTT_DEPTO = %exp:cCodDep% AND
							SRJ.RJ_CARGO = SQ3.Q3_CARGO
						GROUP BY
							RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
					),0.00) TP3AVGDEP,
				ISNULL((
						SELECT
							ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
						FROM
							%table:RDD% RDD,
							%table:RDZ% RDZ,
							%table:RD6% RD6,
							%table:SRA% SRA,
							%table:SRJ% SRJ
						WHERE
							RDD.%NotDel% AND
							RDZ.%NotDel% AND
							RD6.%NotDel% AND
							SRA.%NotDel% AND
							SRJ.%NotDel% AND
							RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
							RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
							RDZ.RDZ_FILENT = %exp:cCodFil% AND
							RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%AND
							RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
							SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
							SRJ.RJ_FILIAL = %exp:xFilial("SRJ",cCodFil)% AND
							RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
							RD6.RD6_CODIGO = %exp:cCodAva% AND
							RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
							RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
							RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
							RDD.RDD_TIPOAV = '3' AND
							SRA.RA_FILIAL+SRA.RA_MAT = RDZ.RDZ_CODENT AND
							SRJ.RJ_FUNCAO = SRA.RA_CODFUNC AND
							SRJ.RJ_CARGO = SQ3.Q3_CARGO
						GROUP BY
							RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
					),0.00) TP3AVGEMP
			FROM
				%table:SQ3% SQ3
			WHERE
				SQ3.%NotDel% AND
				SQ3.Q3_FILIAL = %exp:xFilial("SQ3",cCodFil)% AND
				(
					0 < ( 
							SELECT
								SUM(RDD.RDD_RESOBT) RDD_RESOBT
							FROM
								%table:RDD% RDD,
								%table:RDZ% RDZ,
								%table:RD6% RD6,
								%table:SRA% SRA,
								%table:SRJ% SRJ,
								%table:CTT% CTT
							WHERE
								RDD.%NotDel% AND
								RDZ.%NotDel% AND
								RD6.%NotDel% AND
								SRA.%NotDel% AND
								SRJ.%NotDel% AND
								CTT.%NotDel% AND
								RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
								RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
								RDZ.RDZ_FILENT = %exp:cCodFil% AND
								RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%AND
								RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
								SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
								SRJ.RJ_FILIAL = %exp:xFilial("SRJ",cCodFil)% AND
								CTT.CTT_FILIAL = %exp:xFilial("CTT",cCodFil)% AND
								RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
								RD6.RD6_CODIGO = %exp:cCodAva% AND
								RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
								RDD.RDD_DTIAVA >= %exp:Dtos(dAPDRIni)% AND
								RDD.RDD_DTFAVA <= %exp:Dtos(dAPDRFim)% AND
								RDD.RDD_TIPOAV IN ( '3' ) AND
								SRA.RA_FILIAL+SRA.RA_MAT = RDZ.RDZ_CODENT AND
								SRA.RA_CODFUNC = SRJ.RJ_FUNCAO AND
								SRA.RA_CC = CTT.CTT_CUSTO AND
								CTT.CTT_DEPTO = %exp:cCodDep% AND
								SRJ.RJ_CARGO = SQ3.Q3_CARGO
							GROUP BY
								RDD.RDD_FILIAL,RDD.RDD_CODAVA
						)
				)
			ORDER BY
				SQ3.Q3_FILIAL,SQ3.Q3_CARGO

		ENDSQL
		
		Impr( cDetCab0 )
		Impr( cDetCab1 )
		Impr( "" )
		
		SetRegua( 0 )

		While (cAlsQry)->( !Eof() )
	
			IncRegua()
			
			IF ( lEnd )
				Impr( OemToAnsi( cCancel ) )
				Exit
			EndIF

			nSQ3Media	:= (cAlsQry)->Q3_NMEDIA

			nTp3AvgDep	:= (cAlsQry)->TP3AVGDEP
			nTp3AvgEmp	:= (cAlsQry)->TP3AVGEMP

			cDet := "CARGO D_E_S_C_R_I_C_A_O_D_O_C_A_R_G_    MEDESP                              _NOTA_                                         MEDCAT                        SMEDES"
			cDet := StrTran(cDet,"CARGO",(cAlsQry)->Q3_CARGO)
			cDet := StrTran(cDet,"D_E_S_C_R_I_C_A_O_D_O_C_A_R_G_",(cAlsQry)->Q3_DESCSUM)
			cDet := StrTran(cDet,"MEDESP",TransForm( nSQ3Media  , "@E 999.99" ))
			cDet := StrTran(cDet,"_NOTA_",TransForm( nTp3AvgDep , "@E 999.99" ))
			cDet := StrTran(cDet,"MEDCAT",TransForm( nTp3AvgEmp , "@E 999.99" ))
			cDet := StrTran(cDet,"SMEDES",TransForm( ((nTp3AvgDep/nSQ3Media)*100 ) , "@E 999.99" ))

			IF ( Li == 57 )
				++LI
				Impr( cDetCab0 )
				Impr( cDetCab1 )
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
ЁFun┤┘o    ЁAPDR30AvaVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da AvaliaГЦo								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30AvaVld( lValid )
	
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
ЁFun┤┘o    ЁAPDR30DepVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo do Departamento								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30DepVld( lValid )

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
ЁFun┤┘o    ЁAPDR30EmpVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da Empresa									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30EmpVld( lValid )

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
ЁFun┤┘o    ЁAPDR30FilVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё21/11/2009Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Codigo da Filial									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30FilVld( lValid )

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
ЁFun┤┘o    ЁAPDR30IniVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё18/01/2010Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Inicio da Avaliacao								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30IniVld( lValid )

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
ЁFun┤┘o    ЁAPDR30FimVldЁ Autor ЁMarinaldo de Jesus   Ё Data Ё18/01/2010Ё
цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁValida o Fimcio da Avaliacao								Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁSIGAAPD														Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function APDR30FimVld( lValid )

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