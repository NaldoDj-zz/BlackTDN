#INCLUDE "NDJ.CH"
/*/
	Funcao:		MTA140MNU
	Autor:		Marinaldo de Jesus
	Data:		29/12/2010
	Descricao:	Implementacao do Ponto de Entrada MTA140MNU executado na funcao MENUDEF
				do programa MATA140 Adicao de nova opcao no menu aRotina
/*/
User Function MTA140MNU()

	Local aMenuPopUp		:= {}
	
	Local laRotina			:= ( Type( "aRotina" ) == "A" )
    Local lNDJAtesto        := .F.
	Local lMATA140A			:= .F.
	Local lMATA140V			:= .F.
	
	Local nOpcDisable		:= 99

	Local oException
                                        '
	Local nIndex			:= 0

	TRYEXCEPTION

		StaticCall( NDJLIB004 , SetPublic , "cNDJSF1FMbr" , 0 , "C" , 0 , .F. )
        
		IF !( laRotina )
			BREAK
		EndIF

		//Adiciona Filtro Customizado
		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Filtrar Legenda" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA140MNU , SF1FiltLeg )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Limpar Filtro" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MTA140MNU , MbrRstFilter )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
        aRotina[ nIndex ][1]    := "Filtro &NDJ"
		aRotina[ nIndex ][2]	:= aMenuPopUp
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 1

		//Adiciona Opcao para Atesto de Pre-Nota
        lNDJAtesto            := StaticCall( NDJLIB001 , GetMemVar , "NDJ_ATESTO" )
        DEFAULT lNDJAtesto    := .F.
        IF ( lNDJAtesto )
			lMata140A		:= IsInCallStack( "U_MATA140A" )
			IF !( lMata140A )
				lMata140V	:= IsInCallStack( "U_MATA140V" )
				nOpcDisable	:= 3
				nIndex 		:= aScan( aRotina , { |aElem| ( aElem[4] == 2 ) } )
				IF ( nIndex > 0 )
					aRotina[nIndex][2]	:= "A103NFiscal"
				EndIF
			Else
				nOpcDisable	:= 3
			EndIF
			nIndex := ( nOpcDisable - 1 )
			//Desabilita as Demais Rotinas 
			While ( ( nIndex := aScan( aRotina , { |aElem| ( aElem[4] >= nOpcDisable ) } , ++nIndex ) ) > 0 )
				IF ( Upper( "A140Impri" ) $ Upper( aRotina[nIndex][2] ) )
					Loop
				EndIF
	        	aRotina[nIndex][2]	:= "Help( '' , 1 , 'U_MATA140A' , NIL , OemToAnsi( 'Opção não disponível na Rotina de Atesto/Recusa de Pré-Nota' ) , 1 , 0 )"
	        End While
			IF ( lMATA140A )
                aAdd( aRotina , { "Atestar"        , "StaticCall(U_MTA140MNU,NDJAtesto,'SF1',SF1->(Recno()),4)"    , 0 , 4 , 0 , NIL } )
                aAdd( aRotina , { "Recusar"        , "StaticCall(U_MTA140MNU,NDJRecusa,'SF1',SF1->(Recno()),4)"    , 0 , 4 , 0 , NIL } )
			ElseIF ( lMATA140V )
                aAdd( aRotina , { "Consultar"    , "StaticCall(U_MTA140MNU,NDJConsulta,'SF1',SF1->(Recno()),2)"    , 0 , 2 , 0 , NIL } )
			EndIF
			BREAK
		EndIF

		//Adiciona Opcao para Pre-Nota 'Avulsa'
        IF ( GetNewPar( "NDJ_PRENFA" , .T. ) )
            aAdd( aRotina , { "Avulsa"    ,"StaticCall(U_MTA140MNU,NDJPreNFA,'SF1',SF1->(Recno()),3)"    , 0 , 3 , 0 , NIL } )
			BREAK
		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
	Funcao:		SF1FiltLeg
	Autor:		Marinaldo de Jesus
	Data:		06/11/2011
	Descricao:	Filtra o Browse de acordo com a Opcao da Legenda da mBrowse
/*/
Static Function SF1FiltLeg()

	Local aGetSF1
	Local aColors
	Local aLegend

	Local cSvExprFilTop

	aGetSF1			:= StaticCall( MT103COR , GetF1Status , "SF1" , NIL , .T. )
	aColors			:= aGetSF1[1]
	aLegend			:= aGetSF1[2]

    cSvExprFilTop    := StaticCall( NDJLIB001 , BrwFiltLeg , "SF1" , @aColors , @aLegend , "Documento de Entrada" , "Legenda" , "Duplo Clique para ativar o Filtro" , "cNDJSF1FMbr" )

Return( cSvExprFilTop )

/*/
	Funcao:		MbrRstFilter
	Autor:		Marinaldo de Jesus
	Data:		06/11/2011
	Descricao:	Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( NDJLIB001 , MbrRstFilter , "SF1" , "cNDJSF1FMbr" ) )

/*/
	Funcao:	RpcAtesto
	Autor:	Marinaldo de Jesus
	Data:	11/01/2011
    Uso:    Chamada Via RPC da Verificacao do "Status" do Atesto
	Sintaxe: 1 - RpcAtesto( { cEmp , cFil } )	 //Chamada Direta
			 2 - RpcAtesto( cEmp , cFil )		 //Chamada Via Agendamento
/*/
User Function RpcAtesto( aParameters )

	Local cEmp
	Local cFil
	
	Local oException

	TRYEXCEPTION

        IF !Empty( aParameters )
            IF ( Len( aParameters ) > 1 )
                cEmp    := aParameters[1]
			EndIF
            IF ( Len( aParameters ) > 2 )
                cFil    := aParameters[2]
			EndIF
		EndIF
	
		DEFAULT cEmp	:= "01"
		DEFAULT cFil	:= "01"
		
		PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil )

            NDJSolAtesto()

		RESET ENVIRONMENT

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
    Funcao:		NDJPreNFA
	Autor:		Marinaldo de Jesus
	Data:		29/12/2010
    Descricao:	Tratamento Diferenciado quando executado a partir de NDJPreNFA
/*/
Static Function NDJPreNFA( cAlias , nReg , nOpc )
	Local uRet
	nReg := 0
	PutFileInEof( "SF1" )
	PutFileInEof( "SD1" )
	INCLUI := .T.
	ALTERA := .F.
	EXCLUI := .F.
	//Nao Permito a liberacao dos Locks da SZ4 e SZ5 na Inclusao de Destinos
    StaticCall( NDJLIB003 , IFreeLocks , "SZ4" )
    StaticCall( NDJLIB003 , IFreeLocks , "SZ5" )
	//Executo a Rotina Padrao de Entrada de Pre-Nota
	uRet := A140NFiscal( @cAlias , @nReg , @nOpc )
	MbrChgLoop( .F. )
Return( uRet )

/*/
    Funcao:		NDJAtesto
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Processo de Aprovacao de Atesto
/*/
Static Function NDJAtesto( cAlias , nReg , nOpc )
	Local cTipo := "A"
Return( NDJMntAtesto( @cAlias , @nReg , @nOpc , @cTipo , .T. ) )

/*/
    Funcao:		NDJRecusa()
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Processo de Recusa de Atesto
/*/
Static Function NDJRecusa( cAlias , nReg , nOpc  )
	Local cTipo	:= "A"
Return( NDJMntAtesto( @cAlias , @nReg , @nOpc , @cTipo , .T. ) )

/*/
    Funcao:		NDJConsulta()
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Consulta de Atesto
/*/
Static Function NDJConsulta( cAlias , nReg , nOpc )

	Local aArea			:= GetArea()
	
	Local cCRLF			:= CRLF
    Local cTipo         := StaticCall( NDJLIB001 , GetMemVar , "NDJ_ATTIPO" )
	Local cQuery		:= ""
	Local cEmptyTes		:= Space( GetSx3Cache( "D1_TES" , "X3_TAMANHO" ) )
	Local cNextAlias	:= GetNextAlias()
	
	Local lClassificada	:= .F.

	Local uRet

	BEGIN SEQUENCE

		cQuery := "SELECT " + cCRLF
		cQuery += "		COUNT(1) AS ISCLASSIF " + cCRLF
		cQuery += "FROM " + cCRLF
		cQuery += "		" + RetSqlName( "SF1" ) + " SF1 " + cCRLF
		cQuery += "WHERE " + cCRLF
		cQuery += "		SF1.D_E_L_E_T_ <> '*'" + cCRLF
		cQuery += "AND " + cCRLF		
		cQuery += "			SF1.F1_FILIAL = '" + xFilial("SF1") + "'" + cCRLF
		cQuery += "AND " + cCRLF
		cQuery += "			SF1.F1_DOC = '" + SF1->F1_DOC + "'" + cCRLF
		cQuery += "AND " + cCRLF
		cQuery += "			SF1.F1_SERIE = '" + SF1->F1_SERIE + "'" + cCRLF
		cQuery += "AND " + cCRLF
		cQuery += "			SF1.F1_FORNECE = '" + SF1->F1_FORNECE + "'" + cCRLF
		cQuery += "AND " + cCRLF
		cQuery += "			SF1.F1_LOJA = '" + SF1->F1_LOJA + "'" + cCRLF
		cQuery += "AND " + cCRLF
		cQuery += "		EXISTS " + cCRLF
		cQuery += " 	( "
		cQuery += "				SELECT " + cCRLF
		cQuery += "					1 " + cCRLF
		cQuery += "				FROM " + cCRLF
		cQuery += "					" + RetSqlName( "SD1" ) + " SD1  " + cCRLF
		cQuery += "				WHERE " + cCRLF
		cQuery += "					SD1.D_E_L_E_T_ <> '*'" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_FILIAL = '" + xFilial("SD1") + "'" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_DOC = SF1.F1_DOC" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_SERIE = SF1.F1_SERIE" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_FORNECE = SF1.F1_FORNECE" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_LOJA = SF1.F1_LOJA" + cCRLF
		cQuery += "				AND " + cCRLF
		cQuery += "					SD1.D1_TES <> '" + cEmptyTes + "'" + cCRLF
		cQuery += "			) " + cCRLF

        cQuery    := StaticCall( NDJLIB001 , ClearQuery , cQuery )

		TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

		lClassificada := ( cNextAlias )->( ISCLASSIF > 0 )
    
		( cNextAlias )->( dbCloseArea() )

		dbSelectArea( "SF1" )

		IF ( lClassificada )
			uRet := A103NFiscal( @cAlias , @nReg , @nOpc )
			BREAK
		EndIF
	
        uRet := NDJMntAtesto( @cAlias , @nReg , @nOpc , @cTipo , .F. )
	
	END SEQUENCE

	RestArea( aArea )

Return( uRet )


/*/
    Funcao:		NDJMntAtesto()
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Rotina de Manutencao do Processo de Atesto
/*/
Static Function NDJMntAtesto( cAlias , nReg , nOpc , cTipo , lEval )

	Local aArea			:= GetArea()
	Local aHeader		:= SD1->( dbStruct() )
	Local aAreaSF1		:= SF1->( GetArea() )
	Local aAreaSD1		:= SD1->( GetArea() )
	Local aBagName		:= {}

	Local cMsgYesNo
	Local cTitYesNo
	Local cAliasTmp
	Local cTempFile

	Local oException
	
	Local nOpcA
	
	Local uRet

	TRYEXCEPTION

		SF1->( MsGoto( nReg ) )

		IF !( BuildSD1Tmp( @cAliasTmp , @cTempFile , @aBagName , @aHeader , @cTipo ) )
			UserException( "Não foi possível carregar os ìtens da Nota Fiscal" )
		EndIF

		nOpc	:= 2
		
        StaticCall( NDJLIB001 , SetMemVar , "nOpcaNDJAt" , 0 , .T. , .T. )

		uRet	:= A140NFiscal( @cAlias , @nReg , @nOpc )

        nOpcA    := StaticCall( NDJLIB001 , GetMemVar , "nOpcaNDJAt" )
		
		DEFAULT lEval	:= .T.
		IF (;
				( lEval );
				.and.;
				( nOpcA == 1 );
			)	
            IF IsInCallStack( "NDJRecusa" )
				cTipo := "R"
            ElseIF IsInCallStack( "NDJAtesto" )
				cTipo := "S"
			EndIF
			DO CASE
				CASE ( cTipo == "S" )
					cMsgYesNo := "Deseja Atestar Essa Nota Fiscal? "
					cTitYesNo := "Atesto de Nota Fiscal"
				CASE ( cTipo == "R" )
					cMsgYesNo := "Deseja Recusar Essa Nota Fiscal? "
					cTitYesNo := "Recusa de Nota Fiscal"
			END CASE
			IF MsgYesNo( @cMsgYesNo , @cTitYesNo )
				ExecAtesto( @cTipo , @nReg )
			EndIF
		EndIF

        StaticCall( NDJLIB007 , CloseTmpFile , @cAliasTmp , @cTempFile , @aBagName )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
			IF ( "FINALIZADA" $ oException:Description )
				Final( oException:Description )
			EndIF
		EndIF	

	ENDEXCEPTION

	IF ( Select( "SD1" ) > 0 )
		SD1->( dbCloseArea() )
	EndIF

	ChkFile( "SD1" )

	RestArea( aAreaSD1 )
	RestArea( aAreaSF1 )
	RestArea( aArea )

Return( uRet )

/*/
	Funcao:		ExecAtesto
	Autor:		Marinaldo de Jesus
	Data:		02/02/2011
	Descricao:	Efetiva o Processo de Atesto/Recuso
	Sintaxe:	ExecAtesto( cTipo , nReg )
/*/
Static Function ExecAtesto( cTipo , nReg )

	Local cDlgMsg
    Local cCodUser        := StaticCall( NDJLIB014 , RetCodUsr )
	Local cObsAtesto
	
	Local lObsAtesto
	
	Local nAttempts	:= 0 
	
	BEGIN SEQUENCE

		lObsAtesto	:= (;
							( cTipo == "R" );
							.or.;
							(;
                                GetNewPar( "NDJ_ADMPNF" , .F. );  //Se estiver no Grupo de Administradores, Atesta qualquer Pre-Nota de acordo como parametro NDJ_ADMPNF ou NDJ_GRPPNF
								.and.;
								(;
									PswUsrGrp( cCodUser , "000000" );
									.or.; 
                                    PswUsrGrp( cCodUser , GetNewPar( "NDJ_GRPPNF" , "@@@@@@" ) );
								);
							);
						)			
		
		IF ( lObsAtesto )
		    IF ( cTipo == "R" )
		    	cDlgMsg := "Justificativa da Recusa"
		    ElseIF ( cTipo == "S" )
			    cDlgMsg := "Justificativa do Atesto"
		    EndIF
			nAttempts := 0
			While (;
						Empty( cObsAtesto );
						.or.;
						( Len( cObsAtesto ) < 10 );
					)
                cObsAtesto := StaticCall( NDJLIB001 , DlgMemoEdit , NIL , cDlgMsg , NIL , NIL , NIL , cObsAtesto )
				IF ( ( ++nAttempts ) > 5 )
					cObsAtesto += " Aprovador não incluiu uma justiticativa plausível!" + CRLF + CRLF + "Processo não será efetivado"
					lObsAtesto := .F.
					Exit
				EndIF
			End While
			IF !( lObsAtesto )
				MsgInfo( cObsAtesto , "Atenção!!!" )
				BREAK
			EndIF
		EndIF	

        NDJEvalAtesto( @cTipo , @nReg , @cObsAtesto )

	END SEQUENCE		

Return( NIL )

/*/
    Funcao:		NDJSolAtesto
	Autor:		Marinaldo de Jesus
	Data:		30/01/2011
	Descricao:	Dispara as Solicitacoes de Atesto
    Sintaxe:    StaticCall( U_MTA140MNU , NDJSolAtesto , nReg , lModify , lDeleta , aLstSF1SD1 )
/*/
Static Function NDJSolAtesto( nReg , lModify , lDeleta , aLstSF1SD1 )

	Local aHeader		:= SD1->( dbStruct() )
	Local aBagName		:= {}

	Local cAliasTmp
	Local cTempFile

	Local cTipo			:= "A"
	Local cCodUser		:= ""
	Local cNextAlias	:= GetNextAlias()

	Local lInRpc		:= IsInCallStack( "RpcAtesto" )

	BEGIN SEQUENCE

		IF ( lDeleta )     
			
			BEGINSQL ALIAS cNextAlias
				SELECT DISTINCT
					SD1.D1_XCODGE
				FROM
					%table:SD1% SD1,
					%table:SF1% SF1
				WHERE
					SD1.D1_FILIAL = %exp:xFilial("SD1")%
				AND	
					SF1.F1_FILIAL = %exp:xFilial("SF1")%
				AND	
					SF1.F1_DOC = %exp:SF1->F1_DOC%
				AND
					SF1.F1_SERIE = %exp:SF1->F1_SERIE%
				AND
					SF1.F1_FORNECE = %exp:SF1->F1_FORNECE%
				AND
					SF1.F1_LOJA = %exp:SF1->F1_LOJA%
				AND			
					SF1.F1_TIPO = %exp:SF1->F1_TIPO%
				AND
					SD1.D1_DOC = SF1.F1_DOC
				AND
					SD1.D1_SERIE = SF1.F1_SERIE
				AND
					SD1.D1_FORNECE = SF1.F1_FORNECE
				AND
					SD1.D1_LOJA = SF1.F1_LOJA
				AND			
					SD1.D1_TIPO = SF1.F1_TIPO
			ENDSQL
		
		Else
	
			BEGINSQL ALIAS cNextAlias
				SELECT DISTINCT
					SD1.D1_XCODGE
				FROM
					%table:SD1% SD1,
					%table:SF1% SF1
				WHERE
					SD1.%NotDel%
				AND	
					SF1.%NotDel%
				AND	
					SD1.D1_FILIAL = %exp:xFilial("SD1")%
				AND	
					SF1.F1_FILIAL = %exp:xFilial("SF1")%
				AND	
					SF1.F1_DOC = %exp:SF1->F1_DOC%
				AND
					SF1.F1_SERIE = %exp:SF1->F1_SERIE%
				AND
					SF1.F1_FORNECE = %exp:SF1->F1_FORNECE%
				AND
					SF1.F1_LOJA = %exp:SF1->F1_LOJA%
				AND			
					SF1.F1_TIPO = %exp:SF1->F1_TIPO%
				AND
					SD1.D1_DOC = SF1.F1_DOC
				AND
					SD1.D1_SERIE = SF1.F1_SERIE
				AND
					SD1.D1_FORNECE = SF1.F1_FORNECE
				AND
					SD1.D1_LOJA = SF1.F1_LOJA
				AND			
					SD1.D1_TIPO = SF1.F1_TIPO
			ENDSQL 

		EndIF			

		cCodUser := ( cNextAlias )->( D1_XCODGE )

		( cNextAlias )->( dbCloseArea() )

		IF !( lInRpc )
			IF !( BuildSD1Tmp( @cAliasTmp , @cTempFile , @aBagName , @aHeader , @cTipo , @cCodUser , NIL , @lDeleta , @aLstSF1SD1 ) )
				UserException( "Não foi possível carregar os ìtens da Nota Fiscal" )
			EndIF
			DEFAULT lModify := .F.
            NDJEvalAtesto( @cTipo , @nReg , NIL , @lModify , @lDeleta , NIL , @aLstSF1SD1 )
            StaticCall( NDJLIB007 , CloseTmpFile , @cAliasTmp , @cTempFile , @aBagName )
			BREAK
		EndIF

		cNextAlias := GetNextAlias()

		BEGINSQL ALIAS cNextAlias
			SELECT
				SF1.R_E_C_N_O_ 
			FROM
				%table:SF1% SF1
			WHERE
				SF1.%NotDel%
			AND	
				SF1.F1_FILIAL = %exp:xFilial("SF1")%
			AND
				SF1.F1_XATESTO = %exp:cTipo%
		ENDSQL

		While ( cNextAlias )->( !Eof() )
			nReg	:= ( cNextAlias )->( R_E_C_N_O_ )
			SF1->( dbGoto( nReg ) )
			IF !( BuildSD1Tmp( @cAliasTmp , @cTempFile , @aBagName , @aHeader , @cTipo , @cCodUser , NIL , @lDeleta , @aLstSF1SD1 ) )
				UserException( "Não foi possível carregar os ìtens da Nota Fiscal" )
			EndIF
            NDJEvalAtesto( @cTipo , @nReg )
            StaticCall( NDJLIB007 , CloseTmpFile , @cAliasTmp , @cTempFile , @aBagName )
			( cNextAlias )->( dbSkip() )
		End While	

		( cNextAlias )->( dbCloseArea() )
		
		dbSelectArea( "SF1" )
		
	END SEQUENCE	

Return( NIL )

/*/
    Funcao:		NDJEvalAtesto()
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Efetiva o Atesto/Recusa e Dispara os e-mails
/*/
Static Function NDJEvalAtesto( cTipo , nReg , cObsAtesto , lModify , lDeleta , nSD1Recno , aLstSF1SD1 )

	Local aArea			:= GetArea()
	Local aAreaSF1		:= SF1->( GetArea() )
	Local aPrjRecnos	:= {}
	Local aSD1Recnos	:= {}

	Local cCRLF			:= CRLF
	Local cTime			:= Time()
	Local cDate			:= ""
	Local cD1XObs		:= ""
    Local cCodUsr        := StaticCall( NDJLIB014 , RetCodUsr )
	Local cProjeto		:= ""
	Local cSD1Filial	:= xFilial( "SD1" )
	Local cSD1KeySeek	:= ""
	Local cNewSD1Alias	:= GetNextAlias()

	Local dDate			:= MsDate()

	Local lSendMail		:= .F.
	Local lSD1Goto		:= !Empty( nSD1Recno )
	Local lObsAtesto	:= !Empty( cObsAtesto )
	Local lSetDeleted

	Local nRecno
	Local nRecnos
	Local nProjeto		:= 0
	Local nSD1Order		:= RetOrder( "SD1" , "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM" )

	SF1->( MsGoto( nReg ) )

	ChkFile( "SD1" , .F. , cNewSD1Alias )
	( cNewSD1Alias )->( dbSetOrder( nSD1Order ) )
	
	cDate				:= Dtoc( dDate , "DD/MM/YYYY" )

	IF ( cTipo == "S" )

		IF ( lSD1Goto )
			SD1->( MsGoto( nSD1Recno ) )
		EndIF
		
		While SD1->( !Eof() )

			cSD1KeySeek := SD1->D1_FILIAL
			cSD1KeySeek += SD1->D1_DOC
			cSD1KeySeek += SD1->D1_SERIE
			cSD1KeySeek += SD1->D1_FORNECE
			cSD1KeySeek += SD1->D1_LOJA
			cSD1KeySeek += SD1->D1_COD
			cSD1KeySeek += SD1->D1_ITEM

			IF ( cNewSD1Alias )->( dbSeek( cSD1KeySeek , .F. ) )
				IF ( cNewSD1Alias )->( RecLock( cNewSD1Alias , .F. ) )
					( cNewSD1Alias )->D1_XATESTO		:= cTipo //S=Atestado
					( cNewSD1Alias )->D1_XCUSERA		:= cCodUsr
					( cNewSD1Alias )->D1_XDTATES		:= dDate
					( cNewSD1Alias )->D1_XHRATES		:= cTime
					cD1XObs								:= ( cNewSD1Alias )->D1_XOBS
					IF ( lObsAtesto )
						IF !Empty( cD1XObs )
							( cNewSD1Alias )->D1_XOBS	:= ( cD1XObs + cCRLF + cObsAtesto )
							cD1XObs						:= ""
						Else
							( cNewSD1Alias )->D1_XOBS	:= cObsAtesto
						EndIF
					Else
						cObsAtesto						:= "Atestado por: " 
						cObsAtesto						+= cCodUsr
						cObsAtesto						+= " : "
						cObsAtesto						+= UsrFullName( cCodUsr )
						cObsAtesto						+= cCRLF
						cObsAtesto						+= "as " + cTime + " de: " + cDate
						IF !Empty( cD1XObs )
							cObsAtesto					:= ( cD1XObs + cCRLF + cObsAtesto )
							cD1XObs						:= ""
						EndIF
						( cNewSD1Alias )->D1_XOBS		:= cObsAtesto
						cObsAtesto						:= ""
					EndIF
					( cNewSD1Alias )->( MsUnLock() )
				EndIF
			EndIF

			IF ( lSD1Goto )
				Exit
			EndIF

			SD1->( dbSkip() )

		End While

        IF ( NDJFullAtesto( @nReg , @cTipo ) )

			cSD1KeySeek := cSD1Filial
			cSD1KeySeek += SF1->F1_DOC
			cSD1KeySeek += SF1->F1_SERIE
			cSD1KeySeek += SF1->F1_FORNECE
			cSD1KeySeek += SF1->F1_LOJA

			IF ( cNewSD1Alias )->( dbSeek( cSD1KeySeek , .F. ) )
				While ( cNewSD1Alias )->(;
											!Eof();
											.and.;
											( cSD1KeySeek == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
										)
					cProjeto := SD1->D1_XPROJET
					nProjeto := aScan( aPrjRecnos , { |x| ( x[1] == cProjeto ) } )
					IF ( nProjeto == 0 )
						aAdd( aPrjRecnos , { cProjeto , Array( 0 ) , 0 } )
						nProjeto := Len( aPrjRecnos )
					EndIF
					( cNewSD1Alias )->( aAdd( aPrjRecnos[ nProjeto ][ 2 ] , Recno() ) )
					aPrjRecnos[ nProjeto ][ 3 ] += ( cNewSD1Alias )->D1_TOTAL
					( cNewSD1Alias )->( dbSkip() )
				End While
			EndIF

			IF SF1->( RecLock( "SF1" , .F. ) )
				SF1->F1_XATESTO := cTipo
				SF1->( MsUnLock() )
				MSAguarde( { || SD1SendMail( @nReg , @cNewSD1Alias , @aPrjRecnos , @cTipo , @cObsAtesto ) } , "Enviando e-mail de Atesto aos Destinatários" , "Aguarde..." , .F. )
			EndIF

		EndIF

	ElseIF ( cTipo == "R" )

		cSD1KeySeek := cSD1Filial
		cSD1KeySeek += SF1->F1_DOC
		cSD1KeySeek += SF1->F1_SERIE
		cSD1KeySeek += SF1->F1_FORNECE
		cSD1KeySeek += SF1->F1_LOJA

		IF ( cNewSD1Alias )->( dbSeek( cSD1KeySeek , .F. ) )
			While ( cNewSD1Alias )->(;
										!Eof();
										.and.;
										( cSD1KeySeek == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
									)
				IF ( cNewSD1Alias )->( RecLock( cNewSD1Alias , .F. ) )
					( cNewSD1Alias )->D1_XATESTO		:= cTipo //R=Recusa de Atesto
					( cNewSD1Alias )->D1_XCUSERA		:= cCodUsr
					( cNewSD1Alias )->D1_XDTATES		:= dDate
					( cNewSD1Alias )->D1_XHRATES		:= cTime
					cD1XObs								:= ( cNewSD1Alias )->D1_XOBS
					IF ( lObsAtesto )
						IF !Empty( cD1XObs )
							( cNewSD1Alias )->D1_XOBS	:= ( cD1XObs + cCRLF + cObsAtesto )
						Else
							( cNewSD1Alias )->D1_XOBS	:= cObsAtesto
						EndIF
					EndIF
					( cNewSD1Alias )->( MsUnLock() )
					cProjeto := SD1->D1_XPROJET
					nProjeto := aScan( aPrjRecnos , { |x| ( x[1] == cProjeto ) } )
					IF ( nProjeto == 0 )
						aAdd( aPrjRecnos , { cProjeto , Array( 0 ) , 0 } )
						nProjeto := Len( aPrjRecnos )
					EndIF
					( cNewSD1Alias )->( aAdd( aPrjRecnos[ nProjeto ][ 2 ] , Recno() ) )
					aPrjRecnos[ nProjeto ][ 3 ] += ( cNewSD1Alias )->D1_TOTAL
				EndIF
				( cNewSD1Alias )->( dbSkip() )
			End While
		EndIF

		IF SF1->( RecLock( "SF1" , .F. ) )
			SF1->F1_XATESTO := cTipo
			SF1->( MsUnLock() )
			MSAguarde( { || SD1SendMail( @nReg , @cNewSD1Alias , @aPrjRecnos , @cTipo , @cObsAtesto ) } , "Enviando e-mail de Recusa aos Destinatários" , "Aguarde..." , .F. )
		EndIF

	ElseIF ( cTipo == "A" )

		DEFAULT lDeleta	:= .F.

		IF ( lDeleta )
			lSetDeleted	:= Set( _SET_DELETED , .F. )
		EndIF

		IF !Empty( aLstSF1SD1 )
			SF1->( MsGoto( aLstSF1SD1[ 1 ][ 3 ] ) )
			aEval( aLstSF1SD1[1][2] , { |e| aAdd( aSD1Recnos , e[3] ) } )
		EndIF

		IF Empty( aSD1Recnos )

			nRecno	:= SF1->( Recno() )

			cSD1KeySeek := cSD1Filial
			cSD1KeySeek += SF1->F1_DOC
			cSD1KeySeek += SF1->F1_SERIE
			cSD1KeySeek += SF1->F1_FORNECE
			cSD1KeySeek += SF1->F1_LOJA

			While SF1->( !Eof() .and. ( cSD1KeySeek == F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA ) )
				nRecno	:= SF1->( Recno() )
				SF1->( dbSkip() )
			End While

			SF1->( MsGoto( nRecno ) )

			IF ( cNewSD1Alias )->( dbSeek( cSD1KeySeek , .F. ) )

				While ( cNewSD1Alias )->(;
											!Eof();
											.and.;
											( cSD1KeySeek == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
										)
					IF ( ( cNewSD1Alias )->D1_XATESTO == cTipo )
						IF (;
						   		( cNewSD1Alias )->( D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
						   		==;
						   		SF1->( F1_FILIAL+DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA );
							)
							( cNewSD1Alias )->( aAdd( aSD1Recnos , Recno() ) )
						EndIF
					EndIF
					( cNewSD1Alias )->( dbSkip() )
				End While

			EndIF

		EndIF

		nRecnos := Len( aSD1Recnos )
		For nRecno := 1 To nRecnos
			( cNewSD1Alias )->( dbGoTo( aSD1Recnos[ nRecno ]  ) )
			cProjeto := ( cNewSD1Alias )->D1_XPROJET
			nProjeto := aScan( aPrjRecnos , { |x| ( x[1] == cProjeto ) } )
			IF ( nProjeto == 0 )
				aAdd( aPrjRecnos , { cProjeto , Array( 0 ) , 0 } )
				nProjeto := Len( aPrjRecnos )
			EndIF
			( cNewSD1Alias )->( aAdd( aPrjRecnos[ nProjeto ][ 2 ] , Recno() ) )
			aPrjRecnos[ nProjeto ][ 3 ] += ( cNewSD1Alias )->D1_TOTAL
		Next nRecno
		lSendMail := ( ( nProjeto > 0  ) .and. ( aPrjRecnos[ nProjeto ][ 3 ] > 0 ) )

		IF (;
				(;
					( SF1->F1_XATESTO == cTipo );
					.or.;
					( lDeleta );
				);
				.and.;
				( lSendMail );
			)	
			IF IsInCallStack( "RpcAtesto" )
				SD1SendMail( @nReg , @cNewSD1Alias , @aPrjRecnos , @cTipo , @cObsAtesto )
			Else
				IF ( lModify )
					cObsAtesto := "PRE-NOTA MODIFICADA"
				ElseIF ( lDeleta )
					cObsAtesto := "PRE-NOTA EXCLUIDA"
				EndIF
				MSAguarde( { || SD1SendMail( @nReg , @cNewSD1Alias , @aPrjRecnos , @cTipo , @cObsAtesto , @lModify , @lDeleta ) } , "Enviando e-mail de Solicitação de Atesto" , "Aguarde..." , .F. )
			EndIF
		EndIF

		IF ( lDeleta )
			Set( _SET_DELETED , lSetDeleted )
		EndIF

	EndIF

	( cNewSD1Alias )->( dbCloseArea() )

	RestArea( aAreaSF1 )
	RestArea( aArea )

Return( NIL )

/*/
    Funcao:		NDJFullAtesto()
	Autor:		Marinaldo de Jesus
	Data:		14/04/2011
	Descricao:	Verifica se Todos os Atestos Foram Feitos
    Sintaxe:    StaticCall( U_MTA140MNU , NDJFullAtesto , nReg , cTipo )
/*/
Static Function NDJFullAtesto( nReg , cTipo )

	Local cNextAlias	:= GetNextAlias()

	Local lFullAtesto	:= .F.

	Local nAtestos		:= 0
	Local nAtestadas	:= 0
	
	BEGIN SEQUENCE

		DEFAULT nReg := 0
		SF1->( MsGoto( nReg ) )
		IF SF1->( Eof() .or. Bof() )
			BREAK
		EndIF

		BEGINSQL ALIAS cNextAlias
			SELECT
				COUNT( "D1_XATESTO" ) ATESTOS
			FROM
				%table:SD1% SD1,
				%table:SF1% SF1
			WHERE
				SD1.%NotDel%
			AND	
				SF1.%NotDel%
			AND	
				SD1.D1_FILIAL = %exp:xFilial("SD1")%
			AND	
				SF1.F1_FILIAL = %exp:xFilial("SF1")%
			AND
				SF1.F1_DOC = %exp:SF1->F1_DOC%
			AND
				SF1.F1_SERIE = %exp:SF1->F1_SERIE%
			AND
				SF1.F1_FORNECE = %exp:SF1->F1_FORNECE%
			AND
				SF1.F1_LOJA = %exp:SF1->F1_LOJA%
			AND			
				SF1.F1_TIPO = %exp:SF1->F1_TIPO%
			AND
				SD1.D1_DOC = SF1.F1_DOC
			AND
				SD1.D1_SERIE = SF1.F1_SERIE
			AND
				SD1.D1_FORNECE = SF1.F1_FORNECE
			AND
				SD1.D1_LOJA = SF1.F1_LOJA
			AND			
				SD1.D1_TIPO = SF1.F1_TIPO
		ENDSQL
	
		nAtestos		:= ( cNextAlias )->( ATESTOS )
	
		( cNextAlias )->( dbCloseArea() )

		DEFAULT cTipo	:= "S"
	
		BEGINSQL ALIAS cNextAlias
			SELECT
				COUNT( "D1_XATESTO" ) ATESTADAS
			FROM
				%table:SD1% SD1,
				%table:SF1% SF1
			WHERE
				SD1.%NotDel%
			AND	
				SF1.%NotDel%
			AND	
				SD1.D1_FILIAL = %exp:xFilial("SD1")%
			AND	
				SF1.F1_FILIAL = %exp:xFilial("SF1")%
			AND
				SF1.F1_DOC = %exp:SF1->F1_DOC%
			AND
				SF1.F1_SERIE = %exp:SF1->F1_SERIE%
			AND
				SF1.F1_FORNECE = %exp:SF1->F1_FORNECE%
			AND
				SF1.F1_LOJA = %exp:SF1->F1_LOJA%
			AND			
				SF1.F1_TIPO = %exp:SF1->F1_TIPO%
			AND
				SD1.D1_DOC = SF1.F1_DOC
			AND
				SD1.D1_SERIE = SF1.F1_SERIE
			AND
				SD1.D1_FORNECE = SF1.F1_FORNECE
			AND
				SD1.D1_LOJA = SF1.F1_LOJA
			AND			
				SD1.D1_TIPO = SF1.F1_TIPO
			AND			
				SD1.D1_XATESTO = %exp:cTipo%
		ENDSQL
	
		nAtestadas		:= ( cNextAlias )->( ATESTADAS )
	
		( cNextAlias )->( dbCloseArea() )
		dbSelectArea( "SF1" )
	
		lFullAtesto :=	(;
							( nAtestadas > 0 );
							.and.;
							( nAtestadas == nAtestos );
						 )

	END SEQUENCE						 

Return( lFullAtesto )


/*/
	Funcao:		BuildSD1Tmp()
	Autor:		Marinaldo de Jesus
	Data:		29/01/2011
	Descricao:	Monta o Arquivo Temporario com os Dados da Aprovacao
				Obs.:	Essa tecnica so funciona pq existe campo Memo na SD1 variavel lExistMemo em A140NFiscal
						Se ela estiver Setada como .T. (Existe campo Memo, e sistema padrao nao executa query e
						sim Pesquisa usado dbSeek )
						
/*/
Static Function BuildSD1Tmp( cAliasTmp , cTempFile , aBagName , aHeader , cTipo , cCodUser , aSD1Recnos , lDeleta , aLstSF1SD1 )
	
	Local cQuery		:= ""
	Local cWhere		:= ""
	Local cOrderBy		:= ""
	Local cSD1Where		:= ""
	Local cMemoValue	:= ""
	Local cSD1KeySeek	:= ""
	Local cSD1AliasRec	:= GetNextAlias()
	Local cNewSD1Alias	:= GetNextAlias()
	Local cSD1IndexKey	:= ""
	
	Local lAddProjet	:= .T.
	Local lBuildSD1Tmp	:= .F.

	Local nField
	Local nFields
	Local nRecno
	Local nRecnos
	Local nSD1Recno
	Local nSD1IndexOrd

	BEGIN SEQUENCE

		IF ( Select( "SD1") > 0 )
			SD1->( dbCloseArea() )
		EndIF
	
        DEFAULT cCodUser        := StaticCall( NDJLIB014 , RetCodUsr )
		DEFAULT lDeleta			:= .F.

		IF !( lDeleta )
	
            //Se estiver no Grupo de Administradores, Atesta qualquer Pre-Nota de acordo como parametro NDJ_ADMPNF ou NDJ_GRPPNF
			IF (;
                    GetNewPar( "NDJ_ADMPNF" , .F. );
					.and.;
					(;
						PswUsrGrp( cCodUser , "000000" );
						.or.;
                        PswUsrGrp( cCodUser , GetNewPar( "NDJ_GRPPNF" , "@@@@@@" ) );
					);
				)	
				//Desfaz a Condicao, uma vez que neste caso ira Atestar a Nota sem Considerar a Regra de Atesto
				cSD1Where	:= ""
			Else
				//Obtem a Condicao para o Filtro das Informacoes de Atesto
				cSD1Where	:= StaticCall( U_MT140FIL , FilterAtesto , @cCodUser , @cTipo , @lAddProjet )
			EndIF
	
			cQuery := "SELECT" + CRLF
            cQuery +=        "SD1NDJ.R_E_C_N_O_ "  + CRLF
			cQuery += "FROM " + CRLF
            cQuery +=         RetSqlName( "SD1" ) + " SD1NDJ " + CRLF
		
			cWhere := "WHERE " + CRLF
            cWhere +=        "SD1NDJ.D_E_L_E_T_<>'*'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=        "SD1NDJ.D1_FILIAL='"    + xFilial( "SD1" ) + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=        "SD1NDJ.D1_XATESTO='"    + cTipo + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=        "SD1NDJ.D1_DOC='"     + SF1->F1_DOC  + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=    "SD1NDJ.D1_SERIE='"    + SF1->F1_SERIE + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=      "SD1NDJ.D1_FORNECE='" + SF1->F1_FORNECE + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=    "SD1NDJ.D1_LOJA='"     + SF1->F1_LOJA + "'" + CRLF
			cWhere += " AND " + CRLF
            cWhere +=    "SD1NDJ.D1_TIPO='"     + SF1->F1_TIPO + "'" + CRLF
		
			IF !Empty( cSD1Where )
				cWhere += " AND " + CRLF
				cWhere += "(" + CRLF
                cWhere +=     "SD1NDJ.D1_FILIAL+SD1NDJ.D1_DOC+SD1NDJ.D1_SERIE+SD1NDJ.D1_FORNECE+SD1NDJ.D1_LOJA+SD1NDJ.D1_TIPO+SD1NDJ.D1_XPROJET" + CRLF
				cWhere +=	cSD1Where + CRLF
				cWhere += ")"
			EndIF
		
			cQuery += cWhere
			
			cOrderBy :=	"ORDER BY " + CRLF
            cOrderBy +=        "SD1NDJ.D1_FILIAL," + CRLF
            cOrderBy +=        "SD1NDJ.D1_XATESTO," + CRLF
            cOrderBy +=        "SD1NDJ.D1_DOC," + CRLF
            cOrderBy +=        "SD1NDJ.D1_SERIE," + CRLF
            cOrderBy +=        "SD1NDJ.D1_FORNECE," + CRLF
            cOrderBy +=        "SD1NDJ.D1_LOJA," + CRLF
            cOrderBy +=        "SD1NDJ.D1_TIPO" + CRLF
	
			cQuery	+= cOrderBy
	
			TCQUERY ( cQuery ) ALIAS ( cSD1AliasRec ) NEW
	
			DEFAULT aSD1Recnos	:= {}
	
			While ( ( cSD1AliasRec )->( !Eof() ) )
				( cSD1AliasRec)->( aAdd( aSD1Recnos , R_E_C_N_O_ ) )
				( cSD1AliasRec)->( dbSkip() )
			End While
	
			IF ( Select( cSD1AliasRec ) > 0 )
				( cSD1AliasRec )->( dbCloseArea() )
			EndIF

		Else

			aSD1Recnos	:= {}
			IF !Empty( aLstSF1SD1 )
				aEval( aLstSF1SD1[ 1 ][ 2 ] , { |aElem| aAdd( aSD1Recnos , aElem[3]  ) } )
			EndIF	

		EndIF
	
		nRecnos := Len( aSD1Recnos )
		IF ( nRecnos == 0 )
			ChkFile( "SD1" )
			BREAK
		EndIF

		IF ( lDeleta )

			IF ( Select( "SD1" ) > 0 )
				SD1->( dbCloseArea() )
			EndIF

			ChkFile( "SD1" )

		Else
		
			cQuery := "SELECT" + CRLF
			cQuery +=		" * "  + CRLF
			cQuery += "FROM " + CRLF
            cQuery +=         RetSqlName( "SD1" ) + " SD1NDJ " + CRLF
			cQuery += cWhere
			cQuery += cOrderBy
			
			TCQUERY ( cQuery ) ALIAS ( "SD1" ) NEW
		
			nField := 0
			While ( ( nField := aScan( aHeader , { |aField| ( aField[ DBS_TYPE ] $ ( "D/L/N" ) ) } , ++nField ) ) > 0 )
			  	TcSetField(;
								"SD1",;
								aHeader[ nField , DBS_NAME ],;
								aHeader[ nField , DBS_TYPE ],;
								aHeader[ nField , DBS_LEN  ],;
								aHeader[ nField , DBS_DEC  ];
							)
	  		End While

		EndIF

        DEFAULT aBagName	:= {}
        lBuildSD1Tmp    	:= StaticCall( NDJLIB007 , MakeTmpFile , "SD1" , @cAliasTmp , @cTempFile , NIL , NIL , NIL , @aBagName , @aHeader , IF( lDeleta , @aSD1Recnos , NIL ) )
	
		IF !( lBuildSD1Tmp )
			IF ( Select( cAliasTmp ) > 0 )
				( cAliasTmp )->( dbCloseArea() )
			EndIF
			dbSelectArea( "SD1" )
			BREAK
		EndIF
	
		IF ( Select( "SD1") > 0 )
			SD1->( dbCloseArea() )
		EndIF
		
		dbChangeAlias( cAliasTmp , "SD1" )
		cAliasTmp := "SD1"
	
		ChkFile( "SD1" , .F. , cNewSD1Alias )
		nSD1IndexOrd	:= ( cNewSD1Alias )->( IndexOrd() )
		cSD1IndexKey	:= 	( cNewSD1Alias )->( IndexKey() )
		
		( cAliasTmp )->( dbSetOrder( nSD1IndexOrd ) )
	
		For nRecno := 1 To nRecnos
			nSD1Recno := aSD1Recnos[ nRecno ]
			( cNewSD1Alias )->( dbGoTo( nSD1Recno ) )
			nField := 0
			While ( ( nField := aScan( aHeader , { |aField| ( aField[ DBS_TYPE ] == "M" ) } , ++nField ) ) > 0 )
				cSD1KeySeek := ( cNewSD1Alias )->( &( cSD1IndexKey ) )
				IF ( cAliasTmp )->( dbSeek( cSD1KeySeek , .F. ) )
					IF ( cAliasTmp )->( RecLock( cAliasTmp , .F. ) )
                    	cMemoValue := ( cNewSD1Alias )->( FieldGet( nField ) )
                    	( cAliasTmp )->( FieldPut( nField , cMemoValue ) )
                    	cMemoValue := ""
                    	( cAliasTmp )->( MsUnLock() )
					EndIF
				EndIF
			End While
		Next nRecno
	
		( cNewSD1Alias )->( dbCloseArea() )
	
		dbSelectArea( cAliasTmp )
	
	END SEQUENCE

Return( lBuildSD1Tmp )

/*/
	Funcao: SD1SendMail()
	Autor:	Marinaldo de Jesus
	Data:	29/01/2011
	Uso:	Envia e-mail de Atesto ou Recusa
/*/
Static Function SD1SendMail( nReg , cNewSD1Alias , aPrjRecnos , cTipo , cObsAtesto , lModify , lDeleta )

	Local aTo			:= {}
	Local aRecnos

	Local cBody
	Local cSubject		:= ""
	Local cProjeto		:= ""
	Local cMailPrg		:= ""
	Local cAF8Filial	:= xFilial( "AF8" )
	Local cSA2Filial	:= xFilial( "SA2" )
	Local cSB1Filial	:= xFilial( "SB1" )
	Local cSZJFilial	:= xFilial( "SZJ" )
	Local cSZKFilial	:= xFilial( "SZK" )

	Local nTotal
	Local nProjeto
	Local nProjetos		:= Len( aPrjRecnos )
	Local nAF8Order		:= RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET+AF8_DESCRI" )
	Local nSA2Order		:= RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" )
	Local nSB1Order		:= RetOrder( "SB1" , "B1_FILIAL+B1_COD" )
	Local nSZJOrder		:= RetOrder( "SZJ" , "ZJ_FILIAL+ZJ_XCODPRO" )
	Local nSZKOrder		:= RetOrder( "SZK" , "ZK_FILIAL+ZK_XCODPRO+ZK_CGESTOR" )
	Local nAFXOrder		:= RetOrder( "AFX" , "AFX_FILIAL+AFX_PROJET+AFX_REVISA+AFX_EDT+AFX_USER+AFX_FASE" )

	SF1->( MsGoto( nReg ) )

	AF8->( dbSetOrder( nAF8Order ) )

	SZJ->( dbSetOrder( nSZJOrder ) )
	SZK->( dbSetOrder( nSZKOrder ) )
	
	AFX->( dbSetOrder( nAFXOrder ) )

	For nProjeto := 1 To nProjetos

		aSize( aTo , 0 )

		cProjeto	:= aPrjRecnos[ nProjeto ][ 1 ]
		aRecnos		:= aPrjRecnos[ nProjeto ][ 2 ]
		nTotal		:= aPrjRecnos[ nProjeto ][ 3 ]
		
		IF AF8->( dbSeek( cAF8Filial + cProjeto , .F. ) )
		
			IF SZJ->( dbSeek( cSZJFilial + AF8->AF8_XCPROG , .F. ) )

				IF SZK->( dbSeek( cSZKFilial + AF8->AF8_XCPROG , .F. ) )

					While SZK->( !Eof() .and. ZK_FILIAL == cSZKFilial .and. ZK_XCODPRO == AF8->AF8_XCPROG )
						IF ( SZK->ZK_XAMAIL == "1" )
                            cMailPrg := StaticCall( NDJLIB014 , UsrRetMail ,  SZK->ZK_CGESTOR )
							AddMailDest( @aTo , @cMailPrg )
						EndIF
						SZK->( dbSkip() )
					End While
					
				EndIF
			
			EndIF
		
		EndIF

		cBody		:= OemToAnsi( BuildHtml( @nReg , @cNewSD1Alias , @aRecnos , @nTotal , @cTipo ,  @cObsAtesto , @cProjeto , @cAF8Filial , @nAF8Order , @cSA2Filial , @nSA2Order , @cSB1Filial , @nSB1Order , @aTo , @lModify , @lDeleta , .T. ) )
		IF !Empty( cBody )
			IF ( cTipo == "S" )
				cSubject    := "ATESTO APROVADO"
			ELSEIF ( cTipo == "R" )
				cSubject    := "ATESTO RECUSADO"
			ELSEIF ( cTipo == "A" )
				DEFAULT lModify	:= .F.
				DEFAULT lDeleta := .F.
				IF ( lDeleta )
					cSubject    := "ATESTO CANCELADO"
				ElseIF ( lModify )
					cSubject    := "SOLICITACAO DE RE-ATESTO"
				Else
					cSubject    := "SOLICITACAO DE ATESTO"
				EndIF
			EndIF
			cSubject += " "
			cSubject += "PROJETO"
			cSubject += " "
			cSubject += cProjeto
			cSubject += " "
			cSubject += AllTrim( Posicione( "AF8" , nAF8Order , cAF8Filial + cProjeto , "AF8_DESCRI" ) )
			cSubject += " "
			cSubject += "FORNECEDOR"
			cSubject += " "
			cSubject += SF1->F1_FORNECE
			cSubject += " "
			cSubject += "LOJA"
			cSubject += " "
			cSubject += SF1->F1_LOJA
			cSubject += " "
			cSubject += AllTrim( Posicione( "SA2" , nSA2Order , cSA2Filial + SF1->( F1_FORNECE + F1_LOJA ) , "A2_NOME" ) )
            IF !( StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo , NIL , NIL , NIL , .F. ) )
				UserException( "Problema no Envio de e-mail de Atesto/Recusa. " + CRLF + "Entre em Contato com o Administrador do Sistema." + CRLF + CRLF + "Opção será FINALIZADA"  )
			EndIF
		EndIF
	
	Next nProjeto

Return( NIL )

/*/
	Funcao: BuildHtml
	Autor:	Marinaldo de Jesus
	Data:	29/01/2011
	Uso:	Monta o HTML de Atesto
/*/
Static Function BuildHtml( nReg , cNewSD1Alias , aRecnos , nTotal , cTipo , cObsAtesto , cProjeto , cAF8Filial , nAF8Order , cSA2Filial , nSA2Order , cSB1Filial , nSB1Order , aTo , lModify , lDeleta , lRmvCRLF )

	Local cID			:= ""
	Local cCRLF			:= CRLF
    Local cToken        := NDJ_TOKEN_MAILD
	Local cHtml 		:= ""
	Local cRecno		:= ""
	Local cMailSC		:= ""
	Local cIndexKey		:= ""
	Local cTableKey		:= ""
	Local cEnvServer	:= ""
	Local cD1XProp1		:= ""
	Local cD1XObsNFE	:= ""
	Local cAFXFilial	:= xFilial( "AFX" )
	Local cMailGestor	:= ""
	Local cMailUsrAFX	:= ""

	Local lWebAtesto	:= .F.
	Local lEnvTeste		:= .F.
	Local lEnvProducao	:= .F.

	Local nRecno    
	Local nRecnos		:= Len( aRecnos )
	Local nColSpan		:= 0

	BEGIN SEQUENCE

		DEFAULT lModify	:= .F.
		DEFAULt lDeleta	:= .F.

		SF1->( MsGoto( nReg ) )

		IF ( cTipo == "S" )
            AddMailDest( @aTo , GetNewPar("NDJ_EFIN","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ESYSAD","ndjadvpl@gmail.com") )
		ElseIF ( cTipo == "R" )
            AddMailDest( @aTo , GetNewPar("NDJ_EFIN","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ESYSAD","ndjadvpl@gmail.com") )
		ElseIF ( cTipo == "A" )
            AddMailDest( @aTo , GetNewPar("NDJ_EFIN","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
            AddMailDest( @aTo , GetNewPar("NDJ_ESYSAD","ndjadvpl@gmail.com") )
		EndIF

		cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + cCRLF
		cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' + cCRLF 
		cHtml += '	<head>' + cCRLF 
		cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' + cCRLF 
		IF ( cTipo == "S" )
            cHtml += '        <title>NDJ - ATESTO DE NOTA FISCAL</title>' + cCRLF 
		ElseIF ( cTipo == "R" )
            cHtml += '        <title>NDJ - RECUSA DE NOTA FISCAL</title>' + cCRLF 
		ElseIF ( cTipo == "A" )
			IF ( lModify )
                cHtml += '        <title>NDJ - SOLICITAÇÃO DE RE-ATESTO DE NOTA FISCAL</title>' + cCRLF 
			ElseIF ( lDeleta )
                cHtml += '        <title>NDJ - SOLICITAÇÃO DE ATESTO CANCELADA</title>' + cCRLF 
			Else
                cHtml += '        <title>NDJ - SOLICITAÇÃO DE ATESTO DE NOTA FISCAL</title>' + cCRLF 
			EndIF
		EndIF	
		cHtml += '	</head>' + cCRLF 
		cHtml += '	<body bgproperties="0" bottommargin="0" leftmargin="0" marginheight="0" marginwidth="0" >' + cCRLF 
		cHtml += '		<table cellpadding="0" cellspacing="0"  width"100%" border="0" >' + cCRLF 
		cHtml += '			<tr bgcolor="#EEEEEE">' + cCRLF 
		cHtml += '				<td>' + cCRLF 
        cHtml += '                    <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0">' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr bgcolor="#BEBEBE">' + cCRLF 
		cHtml += '				<td height="20">' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr>' + cCRLF 
		cHtml += '				<td>' + cCRLF 
		cHtml += '					<br />' + cCRLF 
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<b>' + cCRLF 
		IF ( cTipo == "S" )
			cHtml += '							ATESTO DE NOTA FISCAL'
		ElseIF ( cTipo == "R" )	
			cHtml += '							RECUSA DE NOTA FISCAL'
		ElseIF ( cTipo == "A" )	
			IF ( lModify )
				cHtml += '						SOLICITAÇÃO DE RE-ATESTO'
			ElseIF ( lDeleta )
				cHtml += '						CANCELAMENTO DE ATESTO'
			Else
				cHtml += '						SOLICITAÇÃO DE ATESTO'
			EndIF
		EndIF
		cHtml += '						</b>' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 

		IF (;
				!( lDeleta );
				.and.;
				( cTipo == "A" );
			)	

			cIndexKey   := SF1->( IndexKey() )
			cTableKey	:= SF1->( &( cIndexKey ) )

			cRecno		:= AllTrim( Str( nReg 	) )

            cID         := StaticCall( NDJLIB013 , GetKeyID , "SF1" , cIndexKey , cTableKey )
			cID			+= cToken
			cID			+= "SF1"
			cID			+= cToken
			cID			+= cIndexKey
			cID			+= cToken
			cID			+= cTableKey
			cID			+= cToken
			cID			+= cRecno
			
			cID			:= Encode64( cID )

			cEnvServer	:= Lower( GetEnvServer() )

            lEnvTeste        := ( ( "teste" $ cEnvServer ) .or. ( "NDJ" $ cEnvServer ) .or. ( "desenv" $ cEnvServer ) )
			lEnvProducao	:= ( "producao" $ cEnvServer )

			lWebAtesto		:= ( lEnvTeste .or. lEnvProducao )

		EndIF

		cHtml += '			<tr>' + cCRLF  
		cHtml += '				<td>' + cCRLF 
		cHtml += '					<p>' + cCRLF 
		cHtml += '						<font face="arial" size="2">' + cCRLF  
		IF ( cTipo $ "SA" )
			cHtml += '							Prezado Solicitante,'
		ElseIF ( cTipo == "R" )	
			cHtml += '							Ao Departamento Financeiro,'
		EndIF
		cHtml += '						</font>' + cCRLF 
		cHtml += '						<font face="arial" size="2">' + cCRLF 
		cHtml += '							<br />' + cCRLF
		cHtml += '							<br />' + cCRLF
		IF ( cTipo == "S" )
			cHtml += ' Foi Aprovado o Atesto da PRE-NOTA em referencia, portanto a mesma ja pode ser classificada'  
		ElseIF ( cTipo == "R" )	
			cHtml += ' A PRE-NOTA em referencia foi recusada, portanto as informações da mesma deverão ser revistas'  
		ElseIF ( cTipo == "A" )
			IF ( lModify )
				cHtml += ' A PRE-NOTA em referencia foi modificada e necessita do seu RE-ATESTO'  
			ElseIF ( lDeleta )
				cHtml += ' A PRE-NOTA em referencia foi EXCLUIDA do Sistema e em função disso a Solicitação de ATESTO foi CANCELADA'  
			Else
				cHtml += ' A PRE-NOTA em referencia foi incluida no sistema e necessita do seu ATESTO'  
			EndIF
		EndIF
		cHtml += '						</font>' + cCRLF
		cHtml += '						<br />' + cCRLF
		cHtml += '					</p>' + cCRLF 
		cHtml += '				</td>' + cCRLF
		cHtml += '			</tr>' + cCRLF
		cHtml += '			<tr>' + cCRLF
		cHtml += '				<td align="right" valign="top">' + cCRLF 
		cHtml += '					<br />' + cCRLF  
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<table width="100%" border="0" cellspacing="2" cellpadding="0">' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Número da Pré-Nota:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += SF1->F1_DOC
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Série:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += SF1->F1_SERIE
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Fornecedor:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += SF1->F1_FORNECE
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Loja:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += SF1->F1_LOJA
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Nome do Fornecedor:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += AllTrim( Posicione( "SA2" , nSA2Order , cSA2Filial + SF1->( F1_FORNECE + F1_LOJA ) , "A2_NOME" ) )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Fantasia:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += AllTrim( Posicione( "SA2" , nSA2Order , cSA2Filial + SF1->( F1_FORNECE + F1_LOJA ) , "A2_NREDUZ" ) )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Tipo:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += SF1->F1_TIPO
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF 
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Data de Emissão:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>'
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<font size="2" face="arial">' + cCRLF 
		cHtml += Dtoc( SF1->F1_EMISSAO , "DDMMYYYY" )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF 
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Projeto:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>'
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<font size="2" face="arial">' + cCRLF 
		cHtml += cProjeto + " - " + AllTrim( Posicione( "AF8" , nAF8Order , cAF8Filial + cProjeto , "AF8_DESCRI" ) )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF 
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Valor Total dos Itens de Atesto:'
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>'
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<font size="2" face="arial">' + cCRLF 
		cHtml += Transform( nTotal , "@R 999,999,999,999.99" )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '						</table>' + cCRLF
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td>' + cCRLF
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr>' + cCRLF
		cHtml += '				<td colspan="2">' + cCRLF
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<table width="100%" border="1" cellspacing="1" cellpadding="2">' + cCRLF
		cHtml += '							<tr  bgcolor="#cccccc">' + cCRLF
		cHtml += '								<td width="60">' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Item'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Cód. do Produto'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Desc. do Produto'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Un.'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Quant.'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Preço Unitário'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Valor Total'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Cod. da SC'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Item da SC'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Cod. do PC'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Item do PC'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Seq. do PC'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Projeto'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Revisão'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Tarefa'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Centro de Custo'  
		++nColSpan
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		IF ( cTipo == "S" )
			cHtml += '								<td>' + cCRLF 
			cHtml += '									<b>' + cCRLF 
			cHtml += '										<font face="arial" size="2">' + cCRLF  
			cHtml += '											Cod.Usr.Atesto'  
			cHtml += '										</font>' + cCRLF  
			cHtml += '									</b>' + cCRLF 
			cHtml += '								</td>' + cCRLF  
			cHtml += '								<td>' + cCRLF 
			cHtml += '									<b>' + cCRLF 
			cHtml += '										<font face="arial" size="2">' + cCRLF  
			cHtml += '										   Atestado Por'  
			cHtml += '										</font>' + cCRLF  
			cHtml += '									</b>' + cCRLF 
			cHtml += '								</td>' + cCRLF  
		EndIF
		cHtml += '							</tr>' + cCRLF
		For nRecno := 1 To nRecnos
			
			(cNewSD1Alias)->( dbGoto( aRecnos[ nRecno ] ) )

			IF ( AllTrim( (cNewSD1Alias)->D1_XCODSBM ) $ "PJ/SJ" )
                AddMailDest( @aTo , GetNewPar("NDJ_EGCT","ndjadvpl@gmail.com") )
			EndIF

            cMailSC        := StaticCall( NDJLIB014 , UsrRetMail , (cNewSD1Alias)->D1_XUSER  ) 
            cMailGestor    := StaticCall( NDJLIB014 , UsrRetMail , (cNewSD1Alias)->D1_XCODGE )

			IF ( cTipo == "S" )
				AddMailDest( @aTo , @cMailSC )
				AddMailDest( @aTo , @cMailGestor )
			ElseIF ( cTipo == "R" )
				AddMailDest( @aTo , @cMailSC )
				AddMailDest( @aTo , @cMailGestor )
			ElseIF ( cTipo == "A" )
				AddMailDest( @aTo , @cMailSC )
				AddMailDest( @aTo , @cMailGestor )
			EndIF

			IF AFX->( dbSeek( cAFXFilial + cProjeto , .F. ) )
				While AFX->( !Eof() .and. AFX_FILIAL == cAFXFilial .and. AFX_PROJET == cProjeto )
					IF ( AFX->AFX_XAMAIL == "2" )
                        cMailUsrAFX := StaticCall( NDJLIB014 , UsrRetMail , AFX->AFX_USER )
						AddMailDest( @aTo , @cMailUsrAFX )
					ElseIF (;
								( AFX->AFX_XAMAIL == "1" );
								.and.;
								(;
									( AFX->AFX_USER == (cNewSD1Alias)->D1_XUSER );
									.or.;
									( AFX->AFX_USER == (cNewSD1Alias)->D1_XCODGE );
								);
							)	
                        cMailUsrAFX := StaticCall( NDJLIB014 , UsrRetMail , AFX->AFX_USER )
						AddMailDest( @aTo , @cMailUsrAFX )
					EndIF
					AFX->( dbSkip() )
				End While
			EndIF

			cHtml += '						<tr>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += (cNewSD1Alias)->D1_ITEM   
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_COD    
			cHtml += '								</font>' + cCRLF  	
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += AllTrim( Posicione( "SB1" , nSB1Order , cSB1Filial + (cNewSD1Alias)->D1_COD , "B1_DESC" ) )
			cHtml += '								</font>' + cCRLF  	
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += (cNewSD1Alias)->D1_UM
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += Transform( (cNewSD1Alias)->D1_QUANT , GetSx3Cache( "D1_QUANT" , "X3_PICTURE" ) )
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += Transform( (cNewSD1Alias)->D1_VUNIT  , GetSx3Cache( "D1_VUNIT" , "X3_PICTURE" ) )
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += Transform( (cNewSD1Alias)->D1_TOTAL    , GetSx3Cache( "D1_TOTAL  " , "X3_PICTURE" ) )
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '			  				<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_XNUMSC
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_XITEMSC
			cHtml += '							</font>' + cCRLF  
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_PEDIDO
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_ITEMPC
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_XSEQUEN
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += cProjeto
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_XREVIS
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_XTAREFA
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += (cNewSD1Alias)->D1_CC
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			IF ( cTipo == "S" )
				cHtml += '							<td>' + cCRLF 
				cHtml += '								<font face="arial" size="2">' + cCRLF  
				cHtml += (cNewSD1Alias)->D1_XCUSERA
				cHtml += '								</font>' + cCRLF  
				cHtml += '							</td>' + cCRLF 
				cHtml += '							<td>' + cCRLF 
				cHtml += '								<font face="arial" size="2">' + cCRLF  
				cHtml += UsrFullName( (cNewSD1Alias)->D1_XCUSERA )
				cHtml += '								</font>' + cCRLF  
				cHtml += '							</td>' + cCRLF 
				EndIF
			cHtml += '						</tr>' + cCRLF
			cD1XProp1	:= (cNewSD1Alias)->D1_XPROP1
			IF !Empty( cD1XProp1 )
				cHtml += '			<tr>' + cCRLF
				cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
				cHtml += '					<b>' + cCRLF 
				cHtml += '						<font face="arial" size="2">' + cCRLF  
				cHtml += '							Proposta do Fornecedor'  
				cHtml += '						</font>' + cCRLF  
				cHtml += '					</b>' + cCRLF 
				cHtml += '				</td>' + cCRLF  
				cHtml += '			</tr>' + cCRLF
				cHtml += '			<tr>' + cCRLF
				cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
				cHtml += '					<font face="arial" size="2" color="#CC0000">' + cCRLF
				cHtml += cD1XProp1 + cCRLF
				cHtml += '					</font>' + cCRLF 
				cHtml += '				 </td>' + cCRLF 
				cHtml += '			</tr>' + cCRLF
				cD1XProp1	:= ""
			EndIF
			cD1XObsNFE	:= (cNewSD1Alias)->D1_XOBSNFE
			IF !Empty( cD1XObsNFE )
				cHtml += '			<tr>' + cCRLF
				cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
				cHtml += '					<b>' + cCRLF 
				cHtml += '						<font face="arial" size="2">' + cCRLF  
				cHtml += '							Observações do Item da Nota Fiscal'  
				cHtml += '						</font>' + cCRLF  
				cHtml += '					</b>' + cCRLF 
				cHtml += '				</td>' + cCRLF  
				cHtml += '			</tr>' + cCRLF
				cHtml += '			<tr>' + cCRLF
				cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
				cHtml += '					<font face="arial" size="2" color="#CC0000">' + cCRLF
				cHtml += cD1XObsNFE + cCRLF
				cHtml += '					</font>' + cCRLF 
				cHtml += '				 </td>' + cCRLF 
				cHtml += '			</tr>' + cCRLF
				cD1XObsNFE	:= ""
			EndIF
		Next nRecno
		cHtml += '						</table>' + cCRLF
		cHtml += '						<hr/>' + cCRLF
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td">' + cCRLF
		cHtml += '			</tr>' + cCRLF
		IF !Empty( cObsAtesto )
			cHtml += '			<tr>' + cCRLF
			cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
			cHtml += '					<b>' + cCRLF 
			cHtml += '						<font face="arial" size="2">' + cCRLF  
			cHtml += '							Observações'  
			cHtml += '						</font>' + cCRLF  
			cHtml += '					</b>' + cCRLF 
			cHtml += '				</td>' + cCRLF  
			cHtml += '			</tr>' + cCRLF  
			cHtml += '			<tr>' + cCRLF
			cHtml += '				<td  colspan="' + AllTrim( Str( nColSpan , 0 ) ) + '">' + cCRLF 
			cHtml += '					<font face="arial" size="2" color="#CC0000">' + cCRLF
			cHtml += cObsAtesto + cCRLF
			cHtml += '					</font>' + cCRLF 
			cHtml += '				 </td>' + cCRLF 
			cHtml += '			</tr>' + cCRLF
		EndIF

		IF ( lWebAtesto )

			IF ( lEnvTeste )
                AddMailDest( @aTo , StaticCall( NDJLIB014 , UsrRetMail , "000001" ) )
			EndIF        
	
			cHtml += '			<tr>' + cCRLF 
			cHtml += '				<td>' + cCRLF 
			cHtml += '					<br />' + cCRLF 
			cHtml += '					<font face="arial" size="2">' + cCRLF 
			cHtml += '						<b>' + cCRLF 
			
			IF ( lEnvTeste )
                cHtml += '<a href="http://homologacao-portal.NDJ.br/web/atesto?userId='+cID+'&Recno='+cRecno+'">Para atestar a nota fiscal via web basta clicar aqui.</a>(HOMOLOGAÇÃO)'
			ElseIF ( lEnvProducao )	
                cHtml += '<a href="http://portal.NDJ.br/web/atesto?userId='+cID+'&Recno='+cRecno+'">Para atestar a nota fiscal via web basta clicar aqui.</a>'
			EndIF

			cHtml += '						</b>' + cCRLF 
			cHtml += '						<br />' + cCRLF 
			cHtml += '						<br />' + cCRLF 
			cHtml += '					</font>' + cCRLF 
			cHtml += '				</td>' + cCRLF 
			cHtml += '			</tr>' + cCRLF 

		EndIF

		cHtml += '			<tr bgcolor="#BEBEBE">'
		cHtml += '				<td>' + cCRLF 
		cHtml += '					.'  
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF
		cHtml += '		</table>' + cCRLF
		cHtml += '	</body>' + cCRLF
		cHtml += '</html>' + cCRLF
		
		DEFAULT lRmvCRLF := .F.
		IF ( lRmvCRLF )
			cHtml := StrTran( cHtml , cCRLF , "" )
		EndIF

	END SEQUENCE		

Return( cHtml )

/*/
	Funcao: AddMailDest
	Autor:	Marinaldo de Jesus
	Data:	17/02/2011
	Uso:	Adiciona Destinatarios de Email
/*/
Static Function AddMailDest( aDest , cMailDest )
Return( StaticCall( NDJLIB002 , AddMailDest , @aDest , @cMailDest ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJATESTO()
        NDJRECUSA()
        NDJPRENFA()
        NDJCONSULTA()
        SF1FiltLeg()
        MbrRstFilter()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )