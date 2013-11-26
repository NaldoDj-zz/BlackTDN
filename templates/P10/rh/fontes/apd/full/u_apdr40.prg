#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  ³APDR40    ³Autor³Marinaldo de Jesus		           ³Data  ³21/11/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricoes³Relatório de Avaliação por Faixa vs Área/Departamento				 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SINAF																 ³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUAO INICIAL                    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Programador ³Data      ³Nro. Ocorr.³Motivo da Alteracao                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³            ³          ³           ³                    						 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function APDR40()
	
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Mascara do Relatório (220 Colunas)                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	  	EMPRESA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX
	    AVALIAÇÃO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		---------------------------------------------------------------------------------------------------------------------------------
        |    |                                 |                |   Insuficiente  |     Regular     |  Satisfatorio   |    Excelente    |
	  	|QTDE| ÁREA                            |      TIPO      |-----------------|-----------------------------------------------------|
		|    |                                 |                | 999.99 a 999.99 | 999.99 a 999.99 | 999.99 a 999.99 | 999.99 a 999.99 |
		|-------------------------------------------------------------------------------------------------------------------------------|
		|-------------------------------------------------------------------------------------------------------------------------------|
        |    |                                 |                |       999       |        999      |        999      |        999      |
	  	|9999|                                 | AUTO AVALIAÇÃO |-----------------|-----------------|-----------------|-----------------|
		|    |                                 |                |       999%      |        999%     |        999%     |        999%     |
		|    |                                 |----------------|-----------------|-----------------|-----------------|-----------------|
        |    |                                 |                |       999       |        999      |        999      |        999      |
	  	|9999| XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  |    AVALIAÇÃO   |-----------------|-----------------|-----------------|-----------------|
		|    |                                 |                |       999%      |        999%     |        999%     |        999%     |
		|    |                                 |----------------|-----------------|-----------------|-----------------|-----------------|
        |    |                                 |                |       999       |        999      |        999      |        999      |
	  	|9999|                                 |     CONSENSO   |-----------------|-----------------|-----------------|-----------------|
		|    |                                 |                |       999%      |        999%     |        999%     |        999%     |
		--------------------------------------------------------------------------------------------------------------------------------|
		---------------------------------------------------------------------------------------------------------------------------------
	/*/

	Local aArea		:= GetArea()
	Local aOrd		:= {}
	Local aImpress	:= aClone( __aImpress )
	
	Local cDesc1	:= OemToAnsi( "Relatório de Avaliação por Faixa vs Área/Departamento" )
	Local cDesc2	:= OemToAnsi( "Ser  impresso de acordo com os parametros solicitados pelo" )
	Local cDesc3	:= OemToAnsi( "usu rio." )
	Local cAlias	:= "RD0"	//Alias do arquivo Principal ( Base )
	Local cPerg		:= Padr( "U_APDR40" , Len( SX1->X1_GRUPO ) )
	
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
	Private cAPDREsc
	Private cAPDREmp
	
	BEGIN SEQUENCE

		Pergunte( cPerg , .F. )

		APDR40AvaVld(.F.)
		APDR40EscVld(.F.)
		APDR40EmpVld(.F.)
    
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
							.F.			,;	//14 -> lCrystal: 		Se relatorio esta integrado ao Crystal Report
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

		IF !( APDR40AvaVld() )
			Break
		EndIF
		
		IF !( APDR40EscVld() )
			Break
		EndIF
		
		IF !( APDR40EmpVld() )
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
³Funo    ³U_InAPDR40    ³Autor ³Marinaldo de Jesus   ³ Data ³21/11/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Executar Funcoes Dentro de APDR010                           ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³U_InAPDR40( cExecIn , aFormParam )						 	 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³uRet                                                 	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observao³                                                      	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico 													 ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function InAPDR40( cExecIn , aFormParam )
         
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
³Funo    ³PrintRel    ³ Autor ³Marinaldo de Jesus   ³ Data ³21/11/2009³
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

	Local aInterval		:= {}
	
	Local cAlsQry		:= GetNextAlias()
	
	Local cDet			:= ""
	Local cDetCab0		:= "---------------------------------------------------------"
    Local cDetCab1		:= "|    |                                 |                |"
	Local cDetCab2		:= "|QTDE| ÁREA                            |      TIPO      |"
	Local cDetCab3		:= "|    |                                 |                |"
	Local cDetCab4		:= "---------------------------------------------------------"

	Local cCodAva		:= MV_PAR01
	Local cCodEsc   	:= MV_PAR02
	Local cCodEmp   	:= MV_PAR03
	Local cCodFil		:= ""
	
	Local cSvEmpAnt		:= cEmpAnt
	Local cSvFilAnt		:= cFilAnt

	Local cInterval		:= ""
	Local cRBLValor     := ""

	Local nQbCount		:= 0
	Local nDetCab2		:= 0
	Local nRBLMaxD		:= 0
	Local nRBLValor		:= 0
	Local nInterval		:= 0

	Local nCntTp1Fx1	:= 0
	Local nCntTp1Fx2	:= 0
	Local nCntTp1Fx3	:= 0
	Local nCntTp1Fx4	:= 0

	Local nCntTp2Fx1	:= 0
	Local nCntTp2Fx2	:= 0
	Local nCntTp2Fx3	:= 0
	Local nCntTp2Fx4	:= 0

	Local nCntTp3Fx1	:= 0
	Local nCntTp3Fx2	:= 0
	Local nCntTp3Fx3	:= 0
	Local nCntTp3Fx4	:= 0

	Local nDepTp1Cnt	:= 0
	Local nDepTp2Cnt	:= 0
	Local nDepTp3Cnt	:= 0
	
	Local nEmpTp1Cnt	:= 0
	Local nEmpTp2Cnt	:= 0
	Local nEmpTp3Cnt	:= 0

	Local nTotTp1Fx1	:= 0
	Local nTotTp1Fx2	:= 0
	Local nTotTp1Fx3	:= 0
	Local nTotTp1Fx4	:= 0

	Local nTotTp2Fx1	:= 0
	Local nTotTp2Fx2	:= 0
	Local nTotTp2Fx3	:= 0
	Local nTotTp2Fx4	:= 0

	Local nTotTp3Fx1	:= 0
	Local nTotTp3Fx2	:= 0
	Local nTotTp3Fx3	:= 0
	Local nTotTp3Fx4	:= 0
	
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

		wCabec1 	+= SM0->( M0_NOMECOM + "/" + M0_FILIAL + "/" + M0_NOME )
		
		wCabec2 	+= GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_DESC" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )  

		BEGINSQL ALIAS cAlsQry

			SELECT 
				RBL.RBL_DESCRI,
				RBL.RBL_VALOR,
				( 
					SELECT 
						COUNT(*)
					FROM
						%table:RBL% RBL
					WHERE 
						RBL.D_E_L_E_T_ = ' ' AND
						RBL.RBL_FILIAL = %exp:xFilial("RBL",cCodFil)% AND
						RBL.RBL_ESCALA = %exp:cCodEsc%
				) RBL_ITENS
			FROM
				%table:RBL% RBL
			WHERE 
				RBL.D_E_L_E_T_ = ' ' AND
				RBL.RBL_FILIAL = %exp:xFilial("RBL",cCodFil)% AND
				RBL.RBL_ESCALA = %exp:cCodEsc%
			ORDER BY
				RBL.RBL_FILIAL,RBL.RBL_ESCALA,RBL.RBL_ITEM
		
		ENDSQL

		IF (cAlsQry)->( Eof() .or. Bof() )
			UserException( "Não existe(m) item(ns) para a Escala Selecionada" )
		EndIF

		While (cAlsQry)->( !Eof() )
		    
			nRBLMaxD := Max( nRBLMaxD , Len( AllTrim( (cAlsQry)->RBL_DESCRI ) ) )
			
			(cAlsQry)->( dbSkip() )
		
		End While   
		
		nRBLMaxD	:= Max( nRBLMaxD , 15 ) //"999.99 a 999.99"
		
		nRBLMaxD	+= 2
		
		nDetCab2	:= Len( cDetCab2 )

		SetRegua( 0 )
		                            
		(cAlsQry)->( dbGoTop() )
		
		While (cAlsQry)->( !Eof() )
	    	
	    	IncRegua()
	    	
	    	nRBLValor	:= (cAlsQry)->RBL_VALOR

	    	aAdd( aInterval , { nInterval , nRBLValor } )
	    	
	    	cInterval := TransForm( nInterval , "@E 999.99" )
	    	cRBLValor := TransForm( nRBLValor , "@E 999.99" )

            nInterval	:= ( nRBLValor + 0.01 )
	    	
			cDetCab1	+=  " "
			cDetCab1	+=  PadC( AllTrim( (cAlsQry)->RBL_DESCRI ),nRBLMaxD )
			cDetCab1	+=  " "

			cDetCab1	+=	"|"
			
			cDetCab2	+=	Replicate( "-",nRBLMaxD + 2 )

			cDetCab2	+=	"|"

			cDetCab3    +=  " "
			cDetCab3    +=  PadC( cInterval + " a " + cRBLValor,nRBLMaxD )
			cDetCab3    +=  " "

			cDetCab3	+=	"|"
		
			(cAlsQry)->( dbSkip() )
		
		End While

		cDetCab0    += Replicate( "-" , ( Len( cDetCab2 ) - nDetCab2 ) )
		cDetCab4	+= Replicate( "-" , ( Len( cDetCab2 ) - nDetCab2 ) )

		(cAlsQry)->( dbCloseArea() )

		IF Empty( aInterval )
			UserException( "Não existe(m) item(ns) para a Escala Selecionada" )
		EndIF	

		IF ( Len( aInterval ) <> 4 )
			UserException( "Número de Intervalos inválido para a Escala Selecionada." + CRLF + CRLF + "A Escala deve possuir 4 Intervalos." )
		EndIF	

		BEGINSQL ALIAS cAlsQry

			SELECT 
				SQB.QB_DEPTO,
				SQB.QB_DESCRIC,
				ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP1CNT
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '1' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
                  ),0.00) TP1CNT,
				ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP1CNT
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '2' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
                  ),0.00) TP2CNT,
				ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) TP1CNT
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '3' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
                  ),0.00) TP3CNT,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP1FX1
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '1' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[1,1]% AND %exp:aInterval[1,2]%
                  ),0.00) CNTTP1FX1,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP1FX2
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '1' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[2,1]% AND %exp:aInterval[2,2]%
                  ),0.00) CNTTP1FX2,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP1FX3
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '1' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[3,1]% AND %exp:aInterval[3,2]%
                  ),0.00) CNTTP1FX3,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP1FX4
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '1' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[4,1]% AND %exp:aInterval[4,2]%
                  ),0.00) CNTTP1FX4,
                                    ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP2FX1
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '2' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[1,1]% AND %exp:aInterval[1,2]%
                  ),0.00) CNTTP2FX1,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP2FX2
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '2' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[2,1]% AND %exp:aInterval[2,2]%
                  ),0.00) CNTTP2FX2,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP2FX3
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '2' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[3,1]% AND %exp:aInterval[3,2]%
                  ),0.00) CNTTP2FX3,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP2FX4
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '2' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[4,1]% AND %exp:aInterval[4,2]%
                  ),0.00) CNTTP2FX4,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP3FX1
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '3' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[1,1]% AND %exp:aInterval[1,2]%
                  ),0.00) CNTTP3FX1,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP3FX2
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '3' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[2,1]% AND %exp:aInterval[2,2]%
                  ),0.00) CNTTP3FX2,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP3FX3
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '3' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[3,1]% AND %exp:aInterval[3,2]%
                  ),0.00) CNTTP3FX3,
                  ISNULL((
					SELECT
						 ISNULL(COUNT(DISTINCT RDD_CODADO),0.00) CNTTP3FX4
					FROM
						%table:RDD% RDD, 
						%table:RDZ% RDZ,
						%table:RD6% RD6,
						%table:SRA% SRA
					WHERE 
						RDD.%NotDel% AND
						RDZ.%NotDel% AND
						RD6.%NotDel% AND
						SRA.%NotDel% AND
						RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
						RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
						( RDZ.RDZ_FILENT >= %exp:cCodFil% AND RDZ.RDZ_FILENT <= 'ZZ' ) AND
						RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
						RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
						( SRA.RA_FILIAL >= %exp:cCodFil% AND SRA.RA_FILIAL <= 'ZZ' ) AND
						RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
						RD6.RD6_CODIGO = %exp:cCodAva% AND
						RDD.RDD_CODAVA = RD6.RD6_CODIGO	AND
						RDD.RDD_TIPOAV = '3' AND
						SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
						SRA.RA_DEPTO = SQB.QB_DEPTO
					GROUP BY
						RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
						HAVING AVG(RDD.RDD_RESOBT) BETWEEN %exp:aInterval[4,1]% AND %exp:aInterval[4,2]%
                  ),0.00) CNTTP3FX4
			FROM
				%table:SQB% SQB
			WHERE 
				SQB.D_E_L_E_T_ = ' ' AND
				SQB.QB_FILIAL = %exp:xFilial("SQB",cCodFil)%
			ORDER BY
				SQB.QB_FILIAL,SQB.QB_DEPTO
		ENDSQL

		IF (cAlsQry)->( Eof() .or. Bof() )
			UserException( "Não existe(m) Área(s)/Departamento(s) Cadastrado(s)" )
		EndIF

		Impr( OemToAnsi( cDetCab0 ) )
		Impr( OemToAnsi( cDetCab1 ) )
		Impr( OemToAnsi( cDetCab2 ) )
		Impr( OemToAnsi( cDetCab3 ) )
		Impr( OemToAnsi( cDetCab4 ) ) 

		SetRegua( 0 )

		While (cAlsQry)->( !Eof() )

			nDepTp1Cnt	:= (cAlsQry)->TP1CNT
			nDepTp2Cnt	:= (cAlsQry)->TP2CNT
			nDepTp3Cnt	:= (cAlsQry)->TP3CNT

			nEmpTp1Cnt	+= nDepTp1Cnt
			nEmpTp2Cnt	+= nDepTp2Cnt
			nEmpTp3Cnt	+= nDepTp3Cnt
	
			TRYEXCEPTION
			
				IF ( ( nDepTp1Cnt + nDepTp2Cnt + nDepTp3Cnt ) <= 0 )
					UserException("")
				EndIF

				IF ( ++nQbCount > 3 )
					nQbCount := 1
					Impr( "" , "P" )
					Impr( OemToAnsi( cDetCab0 ) )
					Impr( OemToAnsi( cDetCab1 ) )
					Impr( OemToAnsi( cDetCab2 ) )
					Impr( OemToAnsi( cDetCab3 ) )
					Impr( OemToAnsi( cDetCab4 ) ) 
				EndIF

				nCntTp1Fx1	:= (cAlsQry)->CNTTP1FX1
				nCntTp1Fx2	:= (cAlsQry)->CNTTP1FX2
				nCntTp1Fx3	:= (cAlsQry)->CNTTP1FX3
				nCntTp1Fx4	:= (cAlsQry)->CNTTP1FX4

				nTotTp1Fx1	+= nCntTp1Fx1
				nTotTp1Fx2	+= nCntTp1Fx2
				nTotTp1Fx3	+= nCntTp1Fx3
				nTotTp1Fx4	+= nCntTp1Fx4

				nCntTp2Fx1	:= (cAlsQry)->CNTTP2FX1
				nCntTp2Fx2	:= (cAlsQry)->CNTTP2FX2
				nCntTp2Fx3	:= (cAlsQry)->CNTTP2FX3
				nCntTp2Fx4	:= (cAlsQry)->CNTTP2FX4

				nTotTp2Fx1	+= nCntTp2Fx1
				nTotTp2Fx2	+= nCntTp2Fx2
				nTotTp2Fx3	+= nCntTp2Fx3
				nTotTp2Fx4	+= nCntTp2Fx4

				nCntTp3Fx1	:= (cAlsQry)->CNTTP3FX1
				nCntTp3Fx2	:= (cAlsQry)->CNTTP3FX2
				nCntTp3Fx3	:= (cAlsQry)->CNTTP3FX3
				nCntTp3Fx4	:= (cAlsQry)->CNTTP3FX4
	
				nTotTp3Fx1	+= nCntTp3Fx1
				nTotTp3Fx2	+= nCntTp3Fx2
				nTotTp3Fx3	+= nCntTp3Fx3
				nTotTp3Fx4	+= nCntTp3Fx4

				cDet := "|--------------------------------------------------------___________________________------------------__________________________|"
		        cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
		        Impr(OemToAnsi(cDet))
		        
		        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
			  	
			  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nCntTp1Fx1,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nCntTp1Fx2,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nCntTp1Fx3,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nCntTp1Fx4,"999"),nRBLMaxD)+" ")
			  	Impr(OemToAnsi(cDet))
			  	
			  	cDet := "|QTDE|                                 | AUTO AVALIAÇÃO |_______---_______|_______---_______|_______---_______|_______---_______|"
				cDet := StrTran(cDet,"QTDE",Transform(nDepTp1Cnt,"9999"))
				cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
				Impr(OemToAnsi(cDet))
				
				cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
			  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nCntTp1Fx1/nDepTp1Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nCntTp1Fx2/nDepTp1Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nCntTp1Fx3/nDepTp1Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nCntTp1Fx4/nDepTp1Cnt)*100),"999")+"%",nRBLMaxD))
				Impr(OemToAnsi(cDet))
				
				cDet := "|    |                                 |----------------|_______---_______|_______---_______|_______---_______|_______---_______|"
		        cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
		        Impr(OemToAnsi(cDet))
		        
		        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
			  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nCntTp2Fx1,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nCntTp2Fx2,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nCntTp2Fx3,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nCntTp2Fx4,"999"),nRBLMaxD)+" ")
			  	Impr(OemToAnsi(cDet))
			  	
			  	cDet := "|QTDE| __DESCRICAO__DO__DEPARTAMENTO__  |    AVALIAÇÃO   |_______---_______|_______---_______|_______---_______|_______---_______|"
				cDet := StrTran(cDet,"QTDE",Transform(nDepTp2Cnt,"9999"))
				cDet := StrTran(cDet,"__DESCRICAO__DO__DEPARTAMENTO__",(cAlsQry)->QB_DESCRIC)
				cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
				Impr(OemToAnsi(cDet))
				
				cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
			  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nCntTp2Fx1/nDepTp2Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nCntTp2Fx2/nDepTp2Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nCntTp2Fx3/nDepTp2Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nCntTp2Fx4/nDepTp2Cnt)*100),"999")+"%",nRBLMaxD))
				Impr(OemToAnsi(cDet))
				
				cDet := "|    |                                 |----------------|_______---_______|_______---_______|_______---_______|_______---_______|"
		        cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
		        Impr(OemToAnsi(cDet))
		        
		        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
			  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nCntTp3Fx1,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nCntTp3Fx2,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nCntTp3Fx3,"999"),nRBLMaxD)+" ")
			  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nCntTp3Fx4,"999"),nRBLMaxD)+" ")
			  	Impr(OemToAnsi(cDet))
			  	
			  	cDet := "|QTDE|                                 |     CONSENSO   |_______---_______|_______---_______|_______---_______|_______---_______|"
				cDet := StrTran(cDet,"QTDE",Transform(nDepTp3Cnt,"9999"))
				cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
				Impr(OemToAnsi(cDet))
				
				cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
			  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nCntTp3Fx1/nDepTp3Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nCntTp3Fx2/nDepTp3Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nCntTp3Fx3/nDepTp3Cnt)*100),"999")+"%",nRBLMaxD))
			  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nCntTp3Fx4/nDepTp3Cnt)*100),"999")+"%",nRBLMaxD))
				Impr(OemToAnsi(cDet))
				
				cDet := "|--------------------------------------------------------___________________________------------------__________________________|"
				cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
				Impr(OemToAnsi(cDet))
				
				cDet := " --------------------------------------------------------___________________________------------------__________________________"
				cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
				Impr(OemToAnsi(cDet))
			
			CATCHEXCEPTION USING oException
			
				IF !Empty( oException:Description )
					UserException( oException:Description  )
				EndIF
			
			ENDEXCEPTION
	
			(cAlsQry)->( dbSkip() )

		End While

		IF ( ( nEmpTp1Cnt + nEmpTp2Cnt + nEmpTp3Cnt ) > 0 )

			IF ( ++nQbCount > 3 )
				Impr( "" , "P" )
				Impr( OemToAnsi( cDetCab0 ) )
				Impr( OemToAnsi( cDetCab1 ) )
				Impr( OemToAnsi( cDetCab2 ) )
				Impr( OemToAnsi( cDetCab3 ) )
				Impr( OemToAnsi( cDetCab4 ) )  
			EndIF

			cDet := "|--------------------------------------------------------___________________________------------------__________________________|"
	        cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
	        Impr(OemToAnsi(cDet))
	        
	        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
		  	
		  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nTotTp1Fx1,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nTotTp1Fx2,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nTotTp1Fx3,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nTotTp1Fx4,"999"),nRBLMaxD)+" ")
		  	Impr(OemToAnsi(cDet))
		  	
		  	cDet := "|QTDE|                                 | AUTO AVALIAÇÃO |_______---_______|_______---_______|_______---_______|_______---_______|"
			cDet := StrTran(cDet,"QTDE",Transform(nEmpTp1Cnt,"9999"))
			cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
			Impr(OemToAnsi(cDet))
			
			cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
		  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nTotTp1Fx1/nEmpTp1Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nTotTp1Fx2/nEmpTp1Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nTotTp1Fx3/nEmpTp1Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nTotTp1Fx4/nEmpTp1Cnt)*100),"999")+"%",nRBLMaxD))
			Impr(OemToAnsi(cDet))
			
			cDet := "|    |                                 |----------------|_______---_______|_______---_______|_______---_______|_______---_______|"
	        cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
	        Impr(OemToAnsi(cDet))
	        
	        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
		  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nTotTp2Fx1,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nTotTp2Fx2,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nTotTp2Fx3,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nTotTp2Fx4,"999"),nRBLMaxD)+" ")
		  	Impr(OemToAnsi(cDet))
		  	
		  	cDet := "|QTDE| __DESCRICAO__DO__DEPARTAMENTO__  |    AVALIAÇÃO   |_______---_______|_______---_______|_______---_______|_______---_______|"
			cDet := StrTran(cDet,"QTDE",Transform(nEmpTp2Cnt,"9999"))
			cDet := StrTran(cDet,"__DESCRICAO__DO__DEPARTAMENTO__",Padr("EMPRESA",Len("__DESCRICAO__DO__DEPARTAMENTO__")))
			cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
			Impr(OemToAnsi(cDet))
			
			cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
		  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nTotTp2Fx1/nEmpTp2Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nTotTp2Fx2/nEmpTp2Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nTotTp2Fx3/nEmpTp2Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nTotTp2Fx4/nEmpTp2Cnt)*100),"999")+"%",nRBLMaxD))
			Impr(OemToAnsi(cDet))
			
			cDet := "|    |                                 |----------------|_______---_______|_______---_______|_______---_______|_______---_______|"
	        cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
	        Impr(OemToAnsi(cDet))
	        
	        cDet := "|    |                                 |                |_______QT1_______|_______QT2_______|_______QT3_______|_______QT4_______|"
		  	cDet := StrTran(cDet,"_______QT1_______"," "+PadC(Transform(nTotTp3Fx1,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT2_______"," "+PadC(Transform(nTotTp3Fx2,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT3_______"," "+PadC(Transform(nTotTp3Fx3,"999"),nRBLMaxD)+" ")
		  	cDet := StrTran(cDet,"_______QT4_______"," "+PadC(Transform(nTotTp3Fx4,"999"),nRBLMaxD)+" ")
		  	Impr(OemToAnsi(cDet))
		  	
		  	cDet := "|QTDE|                                 |     CONSENSO   |_______---_______|_______---_______|_______---_______|_______---_______|"
			cDet := StrTran(cDet,"QTDE",Transform(nEmpTp3Cnt,"9999"))
			cDet := StrTran(cDet,"_______---_______",Replicate("-",nRBLMaxD+2))
			Impr(OemToAnsi(cDet))
			
			cDet := "|    |                                 |                |_______PE1%______|_______PE2%______|_______PE3%______|_______PE4%______|"
		  	cDet := StrTran(cDet,"_______PE1%______","  "+PadC(Transform(((nTotTp3Fx1/nEmpTp3Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE2%______","  "+PadC(Transform(((nTotTp3Fx2/nEmpTp3Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE3%______","  "+PadC(Transform(((nTotTp3Fx3/nEmpTp3Cnt)*100),"999")+"%",nRBLMaxD))
		  	cDet := StrTran(cDet,"_______PE4%______","  "+PadC(Transform(((nTotTp3Fx4/nEmpTp3Cnt)*100),"999")+"%",nRBLMaxD))
			Impr(OemToAnsi(cDet))
			
			cDet := "|--------------------------------------------------------___________________________------------------__________________________|"
			cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
			Impr(OemToAnsi(cDet))
			
			cDet := " --------------------------------------------------------___________________________------------------__________________________"
			cDet := StrTran(cDet,"___________________________------------------__________________________",Replicate("-",(((nRBLMaxD+2)*4)+3)))
			Impr(OemToAnsi(cDet))
        
		EndIF
	    
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
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³APDR40AvaVld³ Autor ³Marinaldo de Jesus   ³ Data ³21/11/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Valida o Codigo da Avaliação								³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR40AvaVld( lValid )
	
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
³Funo    ³APDR40EscVld³ Autor ³Marinaldo de Jesus   ³ Data ³21/11/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Valida o Codigo da Escala									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR40EscVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDREsc := MV_PAR02

	TRYEXCEPTION
		DEFAULT lValid := .T.
		IF ( lValid )
			RBK->( dbSetOrder( RetOrder( "RBK" , "RBK_FILIAL+RBK_ESCALA" ) ) )
			IF RBK->( !dbSeek( xFilial( "RBK" ) + cAPDREsc ) )
				UserException( "Código da Escala Informada Não Existente na Tabela RBK" )
			EndIF
		EndIF	
	CATCHEXCEPTION USING oException
		lRet := .F.
		MsgAlert( oException:Description , "Alerta!" )
	ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funo    ³APDR40EmpVld³ Autor ³Marinaldo de Jesus   ³ Data ³21/11/2009³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descrio ³Valida o Codigo da Empresa									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<vide parametros formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³SIGAAPD														³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function APDR40EmpVld( lValid )

	Local lRet := .T.
	Local oException

	cAPDREmp := MV_PAR03

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