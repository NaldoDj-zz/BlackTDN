#INCLUDE "NDJ.CH"
/*/
	Programa:	MT100AGR
	Autor:		Marinaldo de Jesus
	Data:		24/02/2011
	Descricao:	Ponto de Entrada Executado nos programas MATA103 e MATA100
	Uso:		Sera utilizado Para:
				1 ) Aglutinacao dos Seguintes Impostos: PIS, COFINS e CSLL;
				2 ) Gravar informacoes do D1 no E2 para o Processo de Contabilização
/*/
User Function MT100AGR()
	
	Local aArea := GetArea()

	Local oException
    
	TRYEXCEPTION
	
        NDJAglImp()                                    //Verifica a Aglutinacao de Impostos
        NDJSC1ToSE2()                                //Grava Informacoes do D1 no E2 para o processo de Contabilizacao
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )    //Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJA002 , SZ4SZ5Commit )        //Forca o Commit das Alteracoes de Destinos

	CATCHEXCEPTION USING oException
	
		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION	

	RestArea( aArea )

Return( NIL )  

/*/
    Programa:    NDJAglImp
	Autor:		Marinaldo de Jesus
	Data:		24/02/2011
    Uso:        Algutinar os Impostos conforme Regra da NDJ
/*/
Static Function NDJAglImp()

	Local aRecnos		:= {}
	Local aSEDArea		:= SED->( GetArea() )
	Local aSE2Area		:= SE2->( GetArea() )
	Local aStackPrm
	Local aSE2Fields	:= {}

	Local cIN
	Local cCRLF
	Local cQuery
	Local cWhere

	Local cCSLL
	Local cPisNat
	Local cCofins
    Local cNDJAlgImp

	Local cE2Num
	Local cE2Filial
	Local cE2Parcela
	Local cE2Prefixo
	Local cSE2KeySeek
	Local cSE2CodeIUse

	Local cEDFilial

	Local cNextAlias
	Local cMsgNAlgTx

	Local dE2Emissao

	Local lCSLL
	Local lPisNat
	Local lCofins
	Local lAglutina		:= .F.
	Local lDeleta

	Local nQtdTx
	Local nVlrTx
	Local nRecno
	Local nField
	Local nRecnos
	Local nFields
	Local nSEDOrder
	Local nSE2Order
	
	Local nE2Saldo
	Local nE2Valor
	Local nE2Naturez
	Local nE2Parcela

	Local oExceptions
	
	Local uCntPut

	TRYEXCEPTION

		lDeleta	:= IsInCallStack( "A100Deleta" )
		IF !( lDeleta )
			IF IsInCallStack( "A103NFiscal" )
                lDeleta    := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "A103NFiscal" ) , Upper( "l103Exclui" ) , NIL , NIL , @aStackPrm )
				IF !( ValType( lDeleta ) == "L" )
					lDeleta := .F.
				EndIF
			EndIF
		EndIF

		IF ( lDeleta )
			BREAK
		EndIF

		nE2Saldo	:= SE2->( FieldPos( "E2_SALDO" 	  ) )
		nE2Valor	:= SE2->( FieldPos( "E2_VALOR" 	  ) )
		nE2Naturez	:= SE2->( FieldPos( "E2_NATUREZ" ) )
		nE2Parcela	:= SE2->( FieldPos( "E2_PARCELA" ) )

		IF ( nE2Saldo == 0 )
			BREAK
		EndIF

		IF ( nE2Valor == 0 )
			BREAK
		EndIF

		IF ( nE2Naturez == 0 )
			BREAK
		EndIF

		IF ( nE2Parcela == 0 )
			BREAK
		EndIF

		cMsgNAlgTx 		:= ""
        cNDJAlgImp        := AllTrim( GetNewPar( "NDJ_AGLIMP" , "" ) )

        lAglutina        := !Empty( cNDJAlgImp )
		IF !( lAglutina )
			BREAK
		EndIF

		nSEDOrder		:= RetOrder( "SED" , "ED_FILIAL+ED_CODIGO" )
		SED->( dbSetOrder( nSEDOrder ) )
		cEDFilial		:= xFilial( "SED" )

		//A natureza deve estar Cadastrada para que seja considerada na Aglutinacao de Impostos
        lAglutina         := SED->( dbSeek( cEDFilial + cNDJAlgImp  ) )
		IF !( lAglutina )
			BREAK
		EndIF

		cIN				:= ""
		cCRLF			:= CRLF

		cCSLL			:= AllTrim( SuperGetMv( "MV_CSLL" , NIL , "" ) )
		lCSLL			:= !Empty( cCSLL )
		IF ( lCSLL )
			//A natureza deve estar Cadastrada para que seja considerada na Aglutinacao de Impostos
			lAglutina		 := SED->( dbSeek( cEDFilial + cCSLL ) )
			IF !( lAglutina )
				BREAK
			EndIF
			IF !Empty( cIN )
				cIN += ","
			EndIF
			cIN	+= "'" + cCSLL  + "'"
			cIN	+= cCRLF
		EndIF    

		cPisNat			:= AllTrim( SuperGetMv( "MV_PISNAT"	 , NIL , "" ) )
		lPisNat			:= !Empty( cPisNat )
		IF ( lPisNat )
			//A natureza deve estar Cadastrada para que seja considerada na Aglutinacao de Impostos
			lAglutina		 := SED->( dbSeek( cEDFilial + cPisNat ) )
			IF !( lAglutina )
				BREAK
			EndIF
			IF !Empty( cIN )
				cIN += ","
			EndIF
			cIN	+=  "'" + cPisNat + "'" 
			cIN	+= cCRLF
		EndIF	

		cCofins			:= AllTrim( SuperGetMv( "MV_COFINS"	 , NIL , "" ) )
		lCofins			:= !Empty( cCofins )
		IF ( lCofins )
			//A natureza deve estar Cadastrada para que seja considerada na Aglutinacao de Impostos
			lAglutina		 := SED->( dbSeek( cEDFilial + cCofins ) )
			IF !( lAglutina )
				BREAK
			EndIF
			IF !Empty( cIN )
				cIN += ","
			EndIF
			cIN	+= "'" + cCofins + "'"
			cIN	+= cCRLF
	    EndIF

		IF !Empty( cIN )
			cIN := "IN" + cCRLF + "(" + cIN + ")" + cCRLF
		EndIF	

		//Obtem os Dados do Cabecalho da Nota
		cE2Filial	:= xFilial( "SE2" )
		cE2Num		:= SF1->F1_DOC
		cE2Prefixo	:= SF1->F1_PREFIXO
		cE2Fornece	:= SF1->F1_FORNECE
		dE2Emissao	:= SF1->F1_EMISSAO

		//Prepara a Clausula Where que sera utilizada em Todas as Consultas SQL
		cWhere		:= "WHERE"
		cWhere		+= cCRLF
		cWhere		+= "	SE2.D_E_L_E_T_ <> '*'" 
		cWhere		+= cCRLF
		cWhere		+= "AND"
		cWhere		+= cCRLF
		cWhere		+= "	SE2.E2_FILIAL = '" + cE2Filial + "'" 
		cWhere		+= cCRLF
		cWhere		+= "AND"
		cWhere		+= cCRLF
		cWhere		+= "	SE2.E2_PREFIXO = '" + cE2Prefixo + "'"
		cWhere		+= cCRLF
		cWhere		+= "AND"
		cWhere		+= cCRLF
		cWhere		+= "	SE2.E2_NUM = '" + cE2Num + "'" 
		cWhere		+= cCRLF
		cWhere		+= "AND"    
		cWhere		+= cCRLF
		cWhere		+= "	SE2.E2_EMISSAO = '" + dTos( dE2Emissao ) + "'" 
		cWhere		+= cCRLF
		cWhere		+= "AND"
		cWhere		+= cCRLF
		cWhere		+= "	SE2.E2_TIPO = 'TX'"
		cWhere		+= cCRLF
		
		IF !Empty( cIN )
			cWhere	+= "AND"
			cWhere	+= cCRLF
			cWhere	+= "	SE2.E2_NATUREZ
			cWhere	+= cCRLF
			cWhere	+= cIN
			cWhere	+= cCRLF
		EndIF	

		//Verifica se Existem Impostos a serem algutinados
		cQuery		:= "SELECT"
		cQuery		+= cCRLF
		cQuery		+= "	COUNT(1) E2_COUNTTX"
		cQuery		+= cCRLF
		cQuery		+= "FROM" 
		cQuery		+= cCRLF
		cQuery		+= "	" + RetSqlName( "SE2" ) + " SE2 "
		cQuery		+= cCRLF
		cQuery		+= cWhere
        
		cNextAlias	:= GetNextAlias()
		
        cQuery        := StaticCall( NDJLIB001 , ClearQuery , cQuery )
		
		TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW
		
		nQtdTx 		:= ( cNextAlias )->( E2_COUNTTX )
		( cNextAlias )->( dbCloseArea() )

		//Se existir apenas um Imposto nao precisa Aglutinar
		IF ( nQtdTx <= 1 )
			BREAK
		EndIF

		lAglutina	:= MsgYesNo( "Deseja Aglutinar os Impostos? " , "Aglutinação de Impostos" )	
		IF !( lAglutina )
			BREAK
		EndIF

		//Obtem os Recnos dos Registros a Serem Deletados
		cQuery		:= "SELECT"
		cQuery		+= cCRLF
		cQuery		+= "	R_E_C_N_O_"
		cQuery		+= cCRLF
		cQuery		+= "FROM" 
		cQuery		+= cCRLF
		cQuery		+= "	" + RetSqlName( "SE2" ) + " SE2 "
		cQuery		+= cCRLF
		cQuery		+= cWhere

        cQuery        := StaticCall( NDJLIB001 , ClearQuery , cQuery )
		
		TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

		While ( cNextAlias )->( !Eof() )
			nRecno := ( cNextAlias )->( R_E_C_N_O_ )
			aAdd( aRecnos , nRecno )
			( cNextAlias )->( dbSkip() )
		End While

		( cNextAlias )->( dbCloseArea() )

		lAglutina := !Empty( aRecnos )
		IF !( lAglutina )
			cMsgNAlgTx := "Os Impostos não foram Aglutinados."
			cMsgNAlgTx += cCRLF
			cMsgNAlgTx += "Os Registros a Serem Aglutinados Não Existem Mais no SGBD"
			BREAK
		EndIF

		//Armazena as Informacoes de pelo menos um Registro de Impostos
        aSE2Fields    := StaticCall( NDJLIB001 , RegToArray , "SE2" , nRecno )

		//Totaliza os Impostos
		cQuery		:= "SELECT"
		cQuery		+= cCRLF
		cQuery		+= "	SUM(E2_VALOR) E2_VALORTX"
		cQuery		+= cCRLF
		cQuery		+= "FROM" 
		cQuery		+= cCRLF
		cQuery		+= "	" + RetSqlName( "SE2" ) + " SE2 "
		cQuery		+= cCRLF
		cQuery		+= cWhere
		cQuery		+= "GROUP BY" 
		cQuery		+= cCRLF
		cQuery		+= "	SE2.E2_FILIAL," 
		cQuery		+= cCRLF
		cQuery		+= "	SE2.E2_NUM" 
		cQuery		+= cCRLF

        cQuery        := StaticCall( NDJLIB001 , ClearQuery , cQuery )

		TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

		nVlrTx		:= ( cNextAlias )->( E2_VALORTX )

		( cNextAlias )->( dbCloseArea() )

		lAglutina	:= !Empty( nVlrTx )
		IF !( lAglutina )
			cMsgNAlgTx := "Os Impostos não foram Aglutinados."
			cMsgNAlgTx += cCRLF
			cMsgNAlgTx += "Valor Total (ZERO)"
			BREAK
		EndIF

		//Obtem a Proxima Parcela a ser Gravada na Aglutinacao dos Impostos
        cE2Parcela    := StaticCall( NDJLIB001 , QryMaxCod , "SE2" , "E2_PARCELA" , StaticCall( NDJLIB001 , ClearQuery , cWhere ) , .F. , .T. )
		cE2Parcela	:= __Soma1( cE2Parcela )

		nSE2Order	:= RetOrder( "SE2" , "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA" )
		SE2->( dbSetOrder( nSE2Order ) )

		cSE2KeySeek		:= cE2Filial
		cSE2KeySeek		+= cE2Prefixo
		cSE2KeySeek		+= cE2Num

		cSE2CodeIUse	:= ( cSE2KeySeek + cE2Parcela )

		While (;
					SE2->( dbSeek( cSE2CodeIUse ) , .F. );
					.or.;
                    !( StaticCall( NDJLIB003 , UseCode , cEmpAnt + cSE2CodeIUse ) ); //Obtem o Semaforo
				)	
			cE2Parcela		:= __Soma1( cE2Parcela )
			cSE2CodeIUse	:= ( cSE2KeySeek + cE2Parcela )
		End While

		//Deleta os Registros que foram base para Aglutinacao
		nRecnos	:= Len( aRecnos )
		For nRecno := 1 To nRecnos
			SE2->( dbGoto( aRecnos[ nRecno ] ) )
			IF SE2->( !RecLock( "SE2" , .F. ) )
				cMsgNAlgTx += "Problema para Excluir o Titulo de Imposto " 
				cMsgNAlgTx += cCRLF
				cMsgNAlgTx += "Natureza: "
				cMsgNAlgTx += SE2->E2_NATUREZ
				cMsgNAlgTx += cCRLF
				cMsgNAlgTx += "Registro: "
				cMsgNAlgTx += Str( aRecnos[ nRecno ] )
				cMsgNAlgTx += cCRLF
				Loop
			EndIF
			SE2->( dbDelete() )
			SE2->( MsUnLock() )
		Next nRecno

		lAglutina := SE2->( RecLock( "SE2" , .T. ) )
		IF !( lAglutina )
			cMsgNAlgTx := "Os Impostos não foram Aglutinados."
			cMsgNAlgTx += cCRLF
			cMsgNAlgTx += "Problemas na Adicção de um Novo Registro na Tabela SE2"
			//Se nao Conseguiu obter o Lock, Restaura os Registros Deletados
			For nRecno := 1 To nRecnos
				SE2->( dbGoto( aRecnos[ nRecno ] ) )
				IF SE2->( RecLock( "SE2" , .F. ) )
					SE2->( dbRecall() )
					SE2->( MsUnLock() )
				EndIF
			Next nRecno
			BREAK
		EndIF

		//Grava o Novo Registro com os Impostos Aglutinados
		nFields := Len( aSE2Fields )
		For nField := 1 To nFields
			IF (;
					( nField == nE2Valor );
					.or.;
					( nField == nE2Saldo );
				)
				uCntPut := nVlrTx
			ElseIF ( nField == nE2Naturez )
                uCntPut := cNDJAlgImp
			ElseIF  ( nField == nE2Parcela )
				uCntPut := cE2Parcela
			Else
				uCntPut := aSE2Fields[ nField ]
			EndIF
			SE2->( FieldPut( nField , uCntPut ) )
		Next nField

		SE2->( MsUnLock() )
		
		//Libera o Semaforo
        StaticCall( NDJLIB003 , ReleaseCode , cSE2CodeIUse )

		MsgInfo( "Os Impostos Foram Aglutinados" + cCRLF + "Total: " + Transform( nVlrTx , "@R 999,999,999.99" ) , "Aglutinação de Impostos" )
		IF  !Empty( cMsgNAlgTx )
			MsgInfo( cMsgNAlgTx , "Aglutinação de Impostos" )
		EndIF	

	CATCHEXCEPTION USING oException

		IF !( lAglutina )
			IF !Empty( cMsgNAlgTx )
				MsgInfo( cMsgNAlgTx , "Problema na Aglutinação de Impostos" )
			EndIF
		EndIF
	
		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION	

	RestArea( aSEDArea )
	RestArea( aSE2Area )

Return( lAglutina )	

/*/
    Programa:    NDJSC1ToSE2
	Autor:		Marinaldo de Jesus
	Data:		18/03/2011
	Uso:		Carregar Informacoes na SE2 de acordo com campos da SD1
/*/
Static Function NDJSC1ToSE2()

	Local aStackPrm

	Local cCRLF
	Local cQuery

	Local cF1Doc
	Local cF1Loja
	Local cF1Filial
	Local cE2Parcela
	Local cF1Prefixo
	Local cF1Fornece

	Local cD1Filial
	Local cE2Filial

	Local cSE2Table
	Local cSF1Table
	Local cSD1Table

	Local dF1Emissao

	Local lDeleta

	Local oExceptions

	TRYEXCEPTION

		lDeleta	:= IsInCallStack( "A100Deleta" )
		IF !( lDeleta )
			IF IsInCallStack( "A103NFiscal" )
                lDeleta    := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "A103NFiscal" ) , Upper( "l103Exclui" ) , NIL , NIL , @aStackPrm )
				IF !( ValType( lDeleta ) == "L" )
					lDeleta := .F.
				EndIF
			EndIF
		EndIF

		IF ( lDeleta )
			BREAK
		EndIF

		cF1Filial	:= SF1->F1_FILIAL
		cD1Filial	:= xFilial( "SD1" , cF1Filial )
		cE2Filial	:= xFilial( "SE2" , cF1Filial )

		cF1Doc		:= SF1->F1_DOC
		cF1Prefixo	:= SF1->F1_PREFIXO
		cF1Fornece	:= SF1->F1_FORNECE
		cF1Loja		:= SF1->F1_LOJA
		dF1Emissao	:= SF1->F1_EMISSAO

		cSF1Table	:= RetSqlName( "SF1" )
		cSD1Table	:= RetSqlName( "SD1" )
		cSE2Table	:= RetSqlName( "SE2" )

		cCRLF		:= CRLF

		cQuery		:= "UPDATE" + cCRLF
		cQuery 		+= "		" + cSE2Table + cCRLF
		cQuery		+= "SET" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_CONTAD = SD1.D1_CONTA," + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_CCD = SD1.D1_CC," + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_ITEMD = D1_ITEMCTA," + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_CLVLDB = SD1.D1_CLVL," + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_XVISCTB = SD1.D1_XVISCTB" + cCRLF
		cQuery		+= "FROM" + cCRLF
		cQuery		+= "		" + cSF1Table +  " SF1," + cCRLF
		cQuery		+= "		" + cSD1Table +  " SD1" + cCRLF
		cQuery		+= "WHERE" + cCRLF
		cQuery		+= "		SF1.D_E_L_E_T_<> '*'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_FILIAL = '" + cF1Filial + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_DOC = '" + cF1Doc + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_PREFIXO = '" + cF1Prefixo + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_FORNECE = '" + cF1Fornece + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_LOJA = '" + cF1Loja + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SF1.F1_EMISSAO = '" + Dtos( dF1Emissao ) + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D_E_L_E_T_<> '*'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_FILIAL = '" + cD1Filial + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".D_E_L_E_T_<> '*'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_FILIAL = '" + cE2Filial + "'" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_DOC = SF1.F1_DOC" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_SERIE = SF1.F1_SERIE" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_FORNECE = SF1.F1_FORNECE" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_LOJA = SF1.F1_LOJA" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		SD1.D1_EMISSAO = SF1.F1_EMISSAO" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_NUM = SF1.F1_DOC" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_PREFIXO = SF1.F1_PREFIXO" + cCRLF
		cQuery		+= "AND" + cCRLF
		cQuery		+= "		" + cSE2Table +  ".E2_EMISSAO = SF1.F1_EMISSAO" + cCRLF

        cQuery        := StaticCall( NDJLIB001 , ClearQuery , cQuery )

		IF ( TcSqlExec( cQuery ) <> 0 )
			UserException( TCSqlError() )
		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

Return( NIL )	

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )