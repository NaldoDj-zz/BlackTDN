#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  ³APDR50    ³Autor³Marinaldo de Jesus		           ³Data  ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricoes³Relatório de Avaliação Variação de Notas por Área					 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SINAF																 ³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL                    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Programador ³Data      ³Nro. Ocorr.³Motivo da Alteracao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ³          ³           ³                    						 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function APDR50()
	
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Mascara do Relatório (220 Colunas)                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	  	EMPRESA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	    AVALIAÇÃO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	    1       10        20        30        40
		-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                         AUTO AVALIAÇÃO                 |                   AVALIAÇÃO                    |                    CONSENSO                    |      
        ÁREA                             QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO | QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO | QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO |
	  	__DESCRICAO__DO__DEPARTAMENTO__   QTD1      MINTP1       MAXTP1        DESTP1    | QTD2      MINTP2       MAXTP2        DESTP2    | QTD3      MINTP3       MAXTP3        DESTP3    |    
	/*/

	Local aArea		:= GetArea()
	Local aOrd		:= {}
	Local aImpress	:= aClone( __aImpress )
	
	Local cDesc1	:= OemToAnsi( "Relatório de Avaliação Variação de Notas por Área" )
	Local cDesc2	:= OemToAnsi( "Ser  impresso de acordo com os parâmetros solicitados pelo" )
	Local cDesc3	:= OemToAnsi( "usu rio." )
	Local cAlias	:= "RD0"	//Alias do arquivo Principal ( Base )
	Local cPerg		:= Padr( "U_APDR50" , Len( SX1->X1_GRUPO ) )
	
	Local wnRel
	Local cMsgAlert
	
	Private aReturn  := {;
							"Zebrado"		,;	//01 -> "Zebrado" -> Descricao do Tipo de Formulario que aparecera na Pasta Opcionais
							NIL				,;  //02 -> Reservado...
							"Administrao"	,;	//03 -> "Administrao" -> Descricao do Destinatario que aparecera na Pasta Opcionais
							2				,;  //04 -> Orientacao do Relatório 1=Retrato;2=Paisagem
							NIL				,;  //05 -> Local da Impressao
							NIL				,;	//06 -> Nome com que o arquivo sera salvo
							NIL				,;	//07 -> Filtro DEFAULT do Relatório que sera utilizado na Pasta Filtro
							1		 		;	//08 -> Ordem DEFAULT do Relatório que srea utilizado na Pasta Ordem
						}
	
	Private NomeProg := FunName()
	Private Titulo   := cDesc1
	Private nTamanho := "G"
	Private wCabec0  := 2
	Private wCabec1  := "EMPRESA:"
	Private wCabec2  := "AVALIAÇÃO:"
	
	Private ContFl   := 1
	Private Li       := 0
	Private nLastKey := 0

	Private cAPDRAva
	Private cAPDREmp
	
	BEGIN SEQUENCE

		Pergunte( cPerg , .F. )

		APDR50AvaVld(.F.)
		APDR50EmpVld(.F.)
    
		__aImpress[1] := 1

		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Envia controle para a funcao SETPRINT                        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		wnRel := NomeProg
		wnRel := SetPrint(;
							""			,;	//01 -> cAlias:			Alias da Tabela
							wnRel		,;	//02 -> cNome: 			Nome do Relatório
							cPerg		,;	//03 -> cPerg: 			Grupo de Perguntas
							@Titulo 	,;	//04 -> cDesc: 			Descricao do Relatório
							cDesc1		,;	//05 -> cCnt1: 			1a. Descricao que aparecera no Rodape da Pasta Impressao
							cDesc2		,;	//06 -> cCnt2: 			2a. Descricao que aparecera no Rodape da Pasta Impressao	
							cDesc3		,;	//07 -> cCnt3: 			3a. Descricao que aparecera no Rodape da Pasta Impressao
							.F.			,;	//08 -> lDic:  			Se Disponibilizara Pasta para Selecao dos Campos
							aOrd		,;	//09 -> aOrd:  			Array com a Descricao das Ordens para Selecao	
							.T.			,;	//10 -> lCompres: 		Se habilitara compressao do Relatório
							nTamanho    ,;	//11 -> cSize: 			Tamanho do Relatório "P=80Colunas";"M=132Colunas";"G=220Colunas"
							NIL			,;	//12 -> aFilter: 		Array com expressao de Filtro
							.F.			,;	//13 -> lFiltro: 		Se habilitara a Pasta Filtro
							.F.			,;	//14 -> lCrystal: 		Se Relatório esta integrado ao Crystal Report
							NIL			,;	//15 -> cNameDrv: 		Nome do Drive que sera utilizado para a impressao
							NIL			,;	//16 -> lNoAsc: 		Se mostrara a Caixa de Dialogo para a SetPrint
							NIL			,;	//17 -> lServer: 		Se a impressao sera no servidor
							NIL			 ;	//18 -> cPortToPrint:	Porta para a Impressao
						)
	
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Se pressionou a Tecla "ESC" abandona                         ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		IF ( nLastKey == 27 )
			Break
		EndIF
	
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Chamada a SetDefault para carga das Informacoes do  Seleciona³
		³ das na SetPrint()											   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		SetDefault(;
						@aReturn	,;	//01 -> aRet:		Array com a Estrutura do aReturn	
						cAlias		,;	//02 -> cAlias:		Alias do Arquivo
						NIL			,;	//03 -> lPortr:		Se Retrato 
						NIL			,;	//04 -> lNoAsk:		Se tera Display
						@nTamanho	,;	//05 -> cSize:		Tamanho do Relatório
						2			 ;	//06 -> nOrienta:	Orientacao do Relatório ( 1-Retrato; 2-Paisagem )
					)
	
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Se pressionou a Tecla "ESC" abandona                         ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		IF ( nLastKey == 27 )
		   Break
		EndIF
		
		Pergunte( cPerg , .F. )

		IF !( APDR50AvaVld() )
			Break
		EndIF
		
		IF !( APDR50EmpVld() )
			Break
		EndIF
		
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Chamda a execussao da Impressao							   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		RptStatus( { |lEnd| PrintRel( @lEnd , @wnRel , @cPerg ) } , Titulo )
		
	END SEQUENCE
	
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Restaura os Ponteiros de Entrada							   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	__aImpress := aClone( aImpress )
	RestArea( aArea )

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³U_InAPDR50    ³Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Executar Funcoes Dentro de APDR010                           ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³U_InAPDR50( cExecIn , aFormParam )						 	 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³uRet                                                 	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observao³                                                      	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico 													 ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function InAPDR50( cExecIn , aFormParam )
         
Local uRet

DEFAULT cExecIn		:= ""
DEFAULT aFormParam	:= {}

IF !Empty( cExecIn )
	cExecIn	:= BldcExecInFun( cExecIn , aFormParam )
	uRet	:= &( cExecIn )
EndIF

Return( uRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³PrintRel    ³ Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Imprime Detalhes do Relatório								³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function PrintRel( lEnd , wnRel , cPerg )

	Local cAlsQry		:= GetNextAlias()
	Local cAlsQryDet	:= GetNextAlias()
	Local cAlsView		:= APDR50GetView()
	Local cAlsExpr		:= ""
	Local cQueryView	:= ""
	
	Local cDet			:= ""
	Local cDetCab0		:= OemToAnsi("                                                 AUTO AVALIAÇÃO                 |                   AVALIAÇÃO                    |                    CONSENSO                    |")
	Local cDetCab1		:= OemToAnsi("ÁREA                             QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO | QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO | QTDE   MENOR NOTA   MAIOR NOTA   DESVIO PADRÃO |")
	
	Local cCodAva		:= MV_PAR01
	Local cCodEmp		:= MV_PAR02
	Local cCodFil   	:= ""
	
	Local cSvEmpAnt		:= cEmpAnt
	Local cSvFilAnt		:= cFilAnt

	Local nMinTp1		:= 0
	Local nMinTp2		:= 0
	Local nMinTp3		:= 0

	Local nMaxTp1		:= 0
	Local nMaxTp2		:= 0
	Local nMaxTp3		:= 0
	
	Local nDesTp1		:= 0
	Local nDesTp2		:= 0
	Local nDesTp3		:= 0

	Local nEmpCntDep	:= 0
	
	Local nEmpMinTp1	:= 0
	Local nEmpMinTp2	:= 0
	Local nEmpMinTp3	:= 0

	Local nEmpMaxTp1	:= 0
	Local nEmpMaxTp2	:= 0
	Local nEmpMaxTp3	:= 0
	
	Local nEmpDesTp1	:= 0
	Local nEmpDesTp2	:= 0
	Local nEmpDesTp3	:= 0

	Local nDepTp1Cnt	:= 0
	Local nDepTp2Cnt	:= 0
	Local nDepTp3Cnt	:= 0

	Local nEmpTp1Cnt	:= 0
	Local nEmpTp2Cnt	:= 0
	Local nEmpTp3Cnt	:= 0

	Local oException    

	TRYEXCEPTION

		SM0->( dbSetOrder( 1 ) )
		SM0->( dbSeek( cCodEmp , .T. ) )
		IF SM0->( Eof() .or. Bof() )
			UserExeption( "Empresa não Cadastrada no SIGAMAT.EMP!" )
		EndIF

		cCodFil   		:= SM0->M0_CODFIL

		IF ( cCodEmp <> cEmpAnt )
			GetEmpr( cCodEmp + cCodFil ) 
		EndIF
		
		While !( MayIUseCode( cAlsView ) )
			cAlsView := APDR50GetView()
		End While

		wCabec1 	+= SM0->( M0_NOMECOM )
		wCabec1		:= OemToAnsi( wCabec1 )
	
		wCabec2 	+= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_DESC" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )  
		wCabec2		:= OemToAnsi( wCabec2 )

		cQueryView := "CREATE VIEW " + cAlsView + " AS " + CRLF
		cQueryView += "				SELECT" + CRLF
		cQueryView += "					RDD.RDD_FILIAL, " + CRLF
		cQueryView += "					RDD.RDD_CODAVA, " + CRLF
		cQueryView += "					RDD.RDD_TIPOAV, " + CRLF
		cQueryView += "					SRA.RA_DEPTO, " + CRLF							
		cQueryView += "					ISNULL(AVG(RDD_RESOBT),0.00) RDD_RESOBT" + CRLF
		cQueryView += "				FROM " + CRLF
		cQueryView += "					"+RetSqlName("RDD") + " RDD," + CRLF
		cQueryView += "					"+RetSqlName("RDZ") + " RDZ," + CRLF
		cQueryView += "					"+RetSqlName("RD6") + " RD6," + CRLF
		cQueryView += "					"+RetSqlName("SRA") + " SRA"  + CRLF
		cQueryView += "				WHERE " + CRLF
		cQueryView += "					RDD.D_E_L_E_T_ = ' ' AND" + CRLF
		cQueryView += "					RDZ.D_E_L_E_T_ = ' ' AND" + CRLF
		cQueryView += "					RD6.D_E_L_E_T_ = ' ' AND" + CRLF
		cQueryView += "					SRA.D_E_L_E_T_ = ' ' AND" + CRLF
		cQueryView += "					RDZ.RDZ_FILIAL = '" + xFilial("RDZ",cCodFil) + "' AND" + CRLF
		cQueryView += "					RDZ.RDZ_EMPENT = '" + cCodEmp  + "' AND" + CRLF
		cQueryView += "					( RDZ.RDZ_FILENT >= '" + cCodFil + "' AND RDZ.RDZ_FILENT <= 'ZZ' ) AND" + CRLF
		cQueryView += "					RDD.RDD_FILIAL = '" + xFilial("RDD",cCodFil)  + "' AND" + CRLF
		cQueryView += "					RD6.RD6_FILIAL = '" + xFilial("RD6",cCodFil)  + "' AND" + CRLF
		cQueryView += "					( SRA.RA_FILIAL >= '" + cCodFil  + "' AND SRA.RA_FILIAL <= 'ZZ' ) AND" + CRLF
		cQueryView += "					RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND" + CRLF
		cQueryView += "					RD6.RD6_CODIGO = '" + cCodAva  + "' AND" + CRLF
		cQueryView += "					RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND" + CRLF
		cQueryView += "					RDD.RDD_TIPOAV IN ('1','2','3') AND" + CRLF
		cQueryView += "					SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT" + CRLF
		cQueryView += "				GROUP BY" + CRLF
		cQueryView += "					RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV,SRA.RA_DEPTO,SRA.RA_MAT" + CRLF

		cQueryView := StrTran( cQueryView , CRLF , "" )
		
		TcSqlExec( cQueryView )
		
		SetRegua( 0 )
		
		BEGINSQL ALIAS cAlsQry
		
			SELECT
				QB_DEPTO,
				QB_DESCRIC,
				ISNULL(( 
		 			SELECT 
		 				 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP1CNT 
		 			FROM 
		 				%table:RDD% RDD, 
		 				%table:RDZ% RDZ, 
		 				%table:RD6% RD6, 
		 				%table:SRA% SRA 
		 			WHERE 
		 				RDD.D_E_L_E_T_ = ' ' AND 
		 				RDZ.D_E_L_E_T_ = ' ' AND 
		 				RD6.D_E_L_E_T_ = ' ' AND 
		 				SRA.D_E_L_E_T_ = ' ' AND 
		 				RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND 
		 				RDZ.RDZ_EMPENT =  %exp:cCodEmp%  AND 
		 				( RDZ.RDZ_FILENT >=  %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND 
		 				RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%  AND 
		 				RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)%  AND 
		 				( SRA.RA_FILIAL >=  %exp:cCodFil%  AND SRA.RA_FILIAL <= 'ZZ' ) AND 
		 				RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND 
		 				RD6.RD6_CODIGO =  %exp:cCodAva%  AND 
		 				RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND 
		 				RDD.RDD_TIPOAV = '1' AND 
		 				SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND 
		 				SRA.RA_DEPTO = SQB.QB_DEPTO
                   ),0.00) TP1CNT, 
		 		ISNULL(( 
		 			SELECT 
		 				 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP2CNT 
		 			FROM 
		 				%table:RDD% RDD, 
		 				%table:RDZ% RDZ, 
		 				%table:RD6% RD6, 
		 				%table:SRA% SRA 
		 			WHERE 
		 				RDD.D_E_L_E_T_ = ' ' AND 
		 				RDZ.D_E_L_E_T_ = ' ' AND 
		 				RD6.D_E_L_E_T_ = ' ' AND 
		 				SRA.D_E_L_E_T_ = ' ' AND 
		 				RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND 
		 				RDZ.RDZ_EMPENT =  %exp:cCodEmp%  AND 
		 				( RDZ.RDZ_FILENT >=  %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND 
		 				RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%  AND 
		 				RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)%  AND 
		 				( SRA.RA_FILIAL >=  %exp:cCodFil%  AND SRA.RA_FILIAL <= 'ZZ' ) AND 
		 				RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND 
		 				RD6.RD6_CODIGO =  %exp:cCodAva%  AND 
		 				RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND 
		 				RDD.RDD_TIPOAV = '2' AND 
		 				SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND 
		 				SRA.RA_DEPTO = SQB.QB_DEPTO 
                   ),0.00) TP2CNT, 
		 		ISNULL(( 
		 			SELECT 
		 				 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP3CNT 
		 			FROM 
		 				%table:RDD% RDD, 
		 				%table:RDZ% RDZ, 
		 				%table:RD6% RD6, 
		 				%table:SRA% SRA 
		 			WHERE 
		 				RDD.D_E_L_E_T_ = ' ' AND 
		 				RDZ.D_E_L_E_T_ = ' ' AND 
		 				RD6.D_E_L_E_T_ = ' ' AND 
		 				SRA.D_E_L_E_T_ = ' ' AND 
		 				RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND 
		 				RDZ.RDZ_EMPENT =  %exp:cCodEmp%  AND 
		 				( RDZ.RDZ_FILENT >=  %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND 
		 				RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%  AND 
		 				RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)%  AND 
		 				( SRA.RA_FILIAL >=  %exp:cCodFil%  AND SRA.RA_FILIAL <= 'ZZ' ) AND 
		 				RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND 
		 				RD6.RD6_CODIGO =  %exp:cCodAva%  AND 
		 				RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND 
		 				RDD.RDD_TIPOAV = '3' AND 
		 				SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND 
		 				SRA.RA_DEPTO = SQB.QB_DEPTO 
                   ),0.00) TP3CNT
			FROM 
		 		%table:SQB% SQB  
			ORDER BY 
				SQB.QB_FILIAL,
				SQB.QB_DEPTO
		ENDSQL

		Impr( cDetCab0 )
		Impr( cDetCab1 )
		Impr( "" )
		
		While (cAlsQry)->( !Eof() )

			TRYEXCEPTION

				nDepTp1Cnt	:= (cAlsQry)->TP1CNT
				nDepTp2Cnt	:= (cAlsQry)->TP2CNT
				nDepTp3Cnt	:= (cAlsQry)->TP3CNT
                
            	IF ( ( nDepTp1Cnt + nDepTp2Cnt + nDepTp3Cnt ) == 0 )
            		UserException( "" )
            	EndIF

				nEmpTp1Cnt	+= nDepTp1Cnt
				nEmpTp2Cnt	+= nDepTp2Cnt
				nEmpTp3Cnt	+= nDepTp3Cnt

				cAlsExpr 	:= '%'+cAlsView+'%'
				
				BEGINSQL ALIAS cAlsQryDet

					SELECT 
						ISNULL((
							SELECT 
								MIN(RDD_RESOBT) MINAVGTP1 
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '1' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
							),0.00) MINAVGTP1,
						ISNULL((
							SELECT 
								MIN(RDD_RESOBT) MINAVGTP2 
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '2' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) MINAVGTP2,
						ISNULL((
							SELECT 
								MIN(RDD_RESOBT) MINAVGTP3
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '3' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) MINAVGTP3,
												ISNULL((
							SELECT 
								MAX(RDD_RESOBT) MAXAVGTP1 
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '1' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
							),0.00) MAXAVGTP1,
						ISNULL((
							SELECT 
								MAX(RDD_RESOBT) MAXAVGTP2 
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '2' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) MAXAVGTP2,
						ISNULL((
							SELECT 
								MAX(RDD_RESOBT) MAXAVGTP3
							FROM 
								%exp:cAlsExpr% 
							WHERE 
								RDD_TIPOAV = '3' AND
								RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) MAXAVGTP3,
						ISNULL((
						SELECT 
							STDEV(RDD_RESOBT) STDEVTP1 
						FROM 
							%exp:cAlsExpr% 
						WHERE 
							RDD_TIPOAV = '1' AND
							RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) STDEVTP1,
						ISNULL((
						SELECT 
							STDEV(RDD_RESOBT) STDEVTP2 
						FROM 
							%exp:cAlsExpr% 
						WHERE 
							RDD_TIPOAV = '2' AND
							RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
						),0.00) STDEVTP2,
						ISNULL((
						SELECT 
							STDEV(RDD_RESOBT) STDEVTP3 
						FROM 
							%exp:cAlsExpr% 
						WHERE 
							RDD_TIPOAV = '3' AND
							RA_DEPTO =%exp:(cAlsQry)->QB_DEPTO%
						),0.00) STDEVTP3
					FROM
						%exp:cAlsExpr% 
					WHERE
						RA_DEPTO = %exp:(cAlsQry)->QB_DEPTO%
					GROUP BY
						RDD_FILIAL,RDD_CODAVA
				ENDSQL

				++nEmpCntDep
	
				nMinTp1		:= (cAlsQryDet)->MINAVGTP1
				nMinTp2		:= (cAlsQryDet)->MINAVGTP2
				nMinTp3		:= (cAlsQryDet)->MINAVGTP3

 				nEmpMinTp1	:= Min(nMinTp1,Max(nEmpMinTp1,nMinTp1))
				nEmpMinTp2	:= Min(nMinTp2,Max(nEmpMinTp2,nMinTp2))
				nEmpMinTp3	:= Min(nMinTp3,Max(nEmpMinTp3,nMinTp3))

				nMaxTp1		:= (cAlsQryDet)->MAXAVGTP1
				nMaxTp2		:= (cAlsQryDet)->MAXAVGTP2
				nMaxTp3		:= (cAlsQryDet)->MAXAVGTP3

 				nEmpMaxTp1	:= Max(nMaxTp1,nEmpMaxTp1)
				nEmpMaxTp2	:= Max(nMaxTp2,nEmpMaxTp2)
				nEmpMaxTp3	:= Max(nMaxTp3,nEmpMaxTp3)
	
				nDesTp1		:= (cAlsQryDet)->STDEVTP1
				nDesTp2		:= (cAlsQryDet)->STDEVTP2
				nDesTp3		:= (cAlsQryDet)->STDEVTP3

				(cAlsQryDet)->( dbCloseArea() )
	
				cDet := "__DESCRICAO__DO__DEPARTAMENTO__   QTD1      MINTP1       MAXTP1        DESTP1    | QTD2      MINTP2       MAXTP2        DESTP2    | QTD3      MINTP3       MAXTP3        DESTP3    |"
				
				cDet := StrTran(cDet,"__DESCRICAO__DO__DEPARTAMENTO__",(cAlsQry)->QB_DESCRIC)
				
				cDet := StrTran(cDet,"QTD1",Transform(nDepTp1Cnt,"9999"))
				cDet := StrTran(cDet,"QTD2",Transform(nDepTp2Cnt,"9999"))
				cDet := StrTran(cDet,"QTD3",Transform(nDepTp3Cnt,"9999"))
				
				cDet := StrTran(cDet,"MINTP1",Transform(nMinTp1,"@E 999.99")) 
				cDet := StrTran(cDet,"MINTP2",Transform(nMinTp2,"@E 999.99"))
				cDet := StrTran(cDet,"MINTP3",Transform(nMinTp3,"@E 999.99"))
	
				cDet := StrTran(cDet,"MAXTP1",Transform(nMaxTp1,"@E 999.99")) 
				cDet := StrTran(cDet,"MAXTP2",Transform(nMaxTp2,"@E 999.99"))
				cDet := StrTran(cDet,"MAXTP3",Transform(nMaxTp3,"@E 999.99"))
	
				cDet := StrTran(cDet,"DESTP1",Transform(nDesTp1,"@E 999.99"))
				cDet := StrTran(cDet,"DESTP2",Transform(nDesTp2,"@E 999.99")) 
				cDet := StrTran(cDet,"DESTP3",Transform(nDesTp3,"@E 999.99"))  
	
				IF ( Li == 57 )
					++LI
					Impr( cDetCab0 )
					Impr( cDetCab1 )
					Impr( "" )
				EndIF 
	
				Impr( OemToAnsi( cDet ) ) 
				
			CATCHEXCEPTION USING oException
			    
				IF !Empty( oException:Description )
					UserException( oException:Description )
				EndIF
							
			ENDEXCEPTION
			
			(cAlsQry)->( dbSkip() )
		
		End While

		IF ( ( nEmpTp1Cnt + nEmpTp2Cnt + nEmpTp3Cnt ) > 0 )

			IF ( Li == 57 )
				++LI
				Impr( cDetCab0 )
				Impr( cDetCab1 )
				Impr( "" )
			Else
				cDet := "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
				Impr( cDet ) 	
			EndIF 

			nEmpDesTp1 := __NoRound( DesvPad( {nEmpMinTp1,nEmpMaxTp1} ) , 2 )
			nEmpDesTp2 := __NoRound( DesvPad( {nEmpMinTp2,nEmpMaxTp2} ) , 2 )
			nEmpDesTp3 := __NoRound( DesvPad( {nEmpMinTp3,nEmpMaxTp3} ) , 2 )

			cDet := "__DESCRICAO__DO__DEPARTAMENTO__   QTD1      MINTP1       MAXTP1        DESTP1    | QTD2      MINTP2       MAXTP2        DESTP2    | QTD3      MINTP3       MAXTP3        DESTP3    |"
		
			cDet := StrTran(cDet,"__DESCRICAO__DO__DEPARTAMENTO__",Padr("EMPRESA",Len("__DESCRICAO__DO__DEPARTAMENTO__")))
				
			cDet := StrTran(cDet,"QTD1",Transform(nEmpTp1Cnt,"9999"))
			cDet := StrTran(cDet,"QTD2",Transform(nEmpTp2Cnt,"9999"))
			cDet := StrTran(cDet,"QTD3",Transform(nEmpTp3Cnt,"9999"))
				
			cDet := StrTran(cDet,"MINTP1",Transform(nEmpMinTp1,"@E 999.99")) 
			cDet := StrTran(cDet,"MINTP2",Transform(nEmpMinTp2,"@E 999.99"))
			cDet := StrTran(cDet,"MINTP3",Transform(nEmpMinTp3,"@E 999.99"))
	
			cDet := StrTran(cDet,"MAXTP1",Transform(nEmpMaxTp1,"@E 999.99")) 
			cDet := StrTran(cDet,"MAXTP2",Transform(nEmpMaxTp2,"@E 999.99"))
			cDet := StrTran(cDet,"MAXTP3",Transform(nEmpMaxTp3,"@E 999.99"))
	
			cDet := StrTran(cDet,"DESTP1",Transform(nEmpDesTp1,"@E 999.99"))
			cDet := StrTran(cDet,"DESTP2",Transform(nEmpDesTp2,"@E 999.99")) 
			cDet := StrTran(cDet,"DESTP3",Transform(nEmpDesTp3,"@E 999.99"))  

			Impr( OemToAnsi( cDet ) ) 

		EndIF

		
		(cAlsQry)->( dbCloseArea() )
	
		TcSqlExec( "DROP VIEW " + cAlsView )

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
	
	Leave1Code( cAlsView )

	IF !( cSvEmpAnt == cEmpAnt )
		GetEmpr( cSvEmpAnt+cSvFilAnt )		
	EndIF
	
Return( NIL  )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³APDR50AvaVld³ Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Valida o Codigo da Avaliação								³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR50AvaVld( lValid )
	
	Local lRet := .T.
	Local oException
	
	cAPDRAva := MV_PAR01
	
	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			RD6->( dbSetOrder( RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) ) )
			IF RD6->( !dbSeek( xFilial( "RD6" ) + cAPDRAva ) )
				UserException( "Código de Avaliação Informado Não Existente na Tabela RD6" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³APDR50EmpVld³ Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Valida o Codigo da Empresa									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR50EmpVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDREmp := MV_PAR02

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			SM0->( dbSetOrder( 1 ) )
			SM0->( dbSeek( cAPDREmp , .T. ) )
			IF !( SM0->M0_CODIGO == cAPDREmp )
				UserException( "Código da Empresa Informado Inválido" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³APDR50GetView³Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Obtem um nome de View Valida								³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR50GetView()
Return( "apdr50_view_"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(Randomize(0,999),3)  )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³DesvPadPA	 ³Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Calcula o Desvio Padrão de um Array de Valores				³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function DesvPadPA( aValores )
Return( DesvPad( aValores , .T. ) )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³DesvPad		 ³Autor ³Marinaldo de Jesus   ³ Data ³10/12/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Calcula o Desvio Padrão de um Array de Valores				³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function DesvPad( aValores , lPolarizado )

	Local nSoma		:= 0
	Local nMedia	:= 0

	Local nLoop
	Local nLoops

	nLoops := Len( aValores )
	For nLoop := 1 To nLoops
		cType := ValType( aValores[nLoop] )
		IF ( cType == "L" )
			aValores[nLoop] := IF( aValores[nLoop] , 1 , 0 )
		ElseIF ( cType == "D" )
			aValores[nLoop] := Val( Dtos( aValores[nLoop] ) )
		ElseIF ( cType == "C" )
			aValores[nLoop] := Val( aValores[nLoop] )
		ElseIF ( cType <> "N" )
			aValores[nLoop] := 0
		EndIF
		nSoma += aValores[nLoop]
	Next nLoop

	nMedia := ( nSoma / nLoops )
	nSoma  := 0    

	For nLoop := 1 To nLoops
		aValores[nLoop] := Abs( aValores[nLoop] - nMedia ) 
		aValores[nLoop] *= aValores[nLoop]
		nSoma += aValores[nLoop]
	Next nLoop

	DEFAULT lPolarizado := .F.
	nMedia := ( nSoma / ( nLoops - IF( lPolarizado , 0 , 1 ) ) )

	nDesvPad := Sqrt( nMedia )

Return( nDesvPad  )