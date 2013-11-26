#INCLUDE "NDJ.CH"    
#INCLUDE "U_NDJA004.CH"
/*/
    Function:	NDJA004
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ
    Sintaxe:    StaticCall(U_NDJA004,NDJA004,cAlias,nReg,nOpc,lExecAuto)
/*/
Static Function NDJA004( cAlias , nReg , nOpc , lExecAuto )
                                                            
	Local aArea 		:= GetArea()
	Local aAreaCN9		:= CN9->( GetArea() )
	Local aAreaSZ8		:= SZ8->( GetArea() )
	Local aSaveGet		:= SaveoGet()

	Local cExprFilTop

	Local lExistOpc		:= ( ValType( nOpc ) == "N" )
	
	Local uRet

	SaveInter()

	BEGIN SEQUENCE

		cAlias	:= "SZ8"

		Private aRotina		:= {;
									{ STR0001 , "PesqBrw"													, 0 , 01 } ,; //"Pesquisar"
                                    { STR0002 , "StaticCall(U_NDJA004,NDJA004Mnt,'SZ8',SZ8->(Recno()),2)"	, 0 , 02 } ,; //"Visualizar"
                                    { STR0003 , "StaticCall(U_NDJA004,NDJA004Mnt,'SZ8',SZ8->(Recno()),3)"	, 0 , 03 } ,; //"Incluir"
                                    { STR0004 , "StaticCall(U_NDJA004,NDJA004Mnt,'SZ8',SZ8->(Recno()),4)"	, 0 , 04 } ,; //"Alterar"
                                    { STR0005 , "StaticCall(U_NDJA004,NDJA004Mnt,'SZ8',SZ8->(Recno()),5)"	, 0 , 05 }  ; //"Excluir"
								}

        Private cCadastro    := OemToAnsi( STR0006 )    //"Cadastro de Tabela Designa絥s vs Contratos NDJ"
	
		IF ( lExistOpc )

			DEFAULT nReg	:= ( cAlias )->( Recno() )
			IF !Empty( nReg )
				( cAlias )->( MsGoto( nReg ) )
			EndIF
	
			DEFAULT lExecAuto := .F.
			IF ( lExecAuto )
	
				nPos := aScan( aRotina , { |x| x[4] == nOpc } )
				IF ( nPos == 0 )
					BREAK
				EndIF
				bBlock	:= &( "{ |a,b,c,d| " + aRotina[ nPos , 2 ] + "(a,b,c,d) }" )
				uRet	:= Eval( @bBlock , @cAlias , @nReg , @nPos )
			
			Else
	
                uRet    := NDJA004Mnt( @cAlias , @nReg , @nOpc , .T. )
			
			EndIF	
		
		Else

			cExprFilTop	:= "Z8_CONTRA = '" + Z8ContraInit() + "'"

			mBrowse( 6 , 1 , 22 , 75 , cAlias , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , @cExprFilTop )
	
		EndIF
		
	END SEQUENCE

	CursorWait()

	RestArea( aAreaSZ8 )
	RestArea( aAreaCN9 )
	RestArea( aArea )

	RestartoGet( aSaveGet )

	RestInter()

	CursorArrow()

Return( uRet )

/*/
    Function:	NDJA004Vis
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ (Visualizar)
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Vis,cAlias,nReg)
/*/
Static Function NDJA004Vis( cAlias , nReg )
	Local nOpc := 2
Return( NDJA004( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA004Inc
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ (Incluir)
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Inc,cAlias,nReg)
/*/
Static Function NDJA004Inc( cAlias , nReg )
	Local nOpc := 3
	IF ( nReg > 0 )
		nOpc := 4
	EndIF
Return( NDJA004( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA004Alt
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Alt,cAlias,nReg)
/*/
Static Function NDJA004Alt( cAlias , nReg )
	Local nOpc := 4
Return( NDJA004( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA004Del
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Del,cAlias,nReg)
/*/
Static Function NDJA004Del( cAlias , nReg )
	Local nOpc := 5
Return( NDJA004( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA004Mnt
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
    Descricao:	Cadastro de Tabela Designacoes vs Contratos NDJ (Manutencao)
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Mnt,cAlias,nReg,lDlgPadSiga)
/*/
Static Function NDJA004Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

	Local aArea			:= GetArea(Alias())
	Local aAreaSZ8		:= SZ8->( GetArea() )
	Local aSvKeys		:= GetKeys()
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aSZ8Header	:= {}
	Local aSZ8Cols		:= {}
	Local aSvSZ8Cols	:= {}
	Local aSZ8Fields	:= {}
	Local aSZ8Altera	:= {}
	Local aSZ8NaoAlt	:= {}
	Local aSZ8VirtEn	:= {}
	Local aSZ8NotFields	:= {}
	Local aSZ8Recnos	:= {}
	Local aSZ8Keys		:= {}
	Local aSZ8VisuEn	:= {}
	Local aButtons		:= {}
	Local aFreeLocks	:= {}
	Local aLog			:= {}
	Local aLogTitle		:= {}
	Local aLogGer		:= {}
	Local aLogGerTitle	:= {}
	
	Local bSet15		:= { || NIL }
	Local bSet24		:= { || NIL }
	Local bDialogInit	:= { || NIL }
	Local bGetSZ8		:= { || NIL } 

	Local cZ8Item		:= ""
	Local cZ8Codigo		:= ""
	Local cSZ8KeySeek	:= ""

	Local cTitLog		:= ""
	Local cMsgYesNo		:= ""
	
	Local lLocks		:= .F.
	Local lExecLock		:= ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
	Local lExcGeraLog	:= .F.
	
	Local nOpcAlt		:= 0
	Local nSZ8Usado		:= 0
	Local nLoop			:= 0
	Local nLoops		:= 0

	Local oDlg			:= NIL
	Local oEnSZ8		:= NIL
    Local oPanel
	

	Private aGets
	Private aTela

	Private nGetSX8Len	:= GetSX8Len()

	CursorWait()
	
	BEGIN SEQUENCE

		aRotSetOpc( cAlias , @nReg , nOpc )
	
		aSZ8NotFields	:= { "Z8_FILIAL" }
		bGetSZ8			:= { |lLock,lExclu|	IF( lExecLock , ( lLock := .T. , lExclu	:= .T. ) , aSZ8Keys := NIL ),;
											aSZ8Cols := SZ8->(;
																GdBuildCols(	@aSZ8Header		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																				@nSZ8Usado		,;	//02 -> Numero de Campos em Uso
																				@aSZ8VirtEn		,;	//03 -> [@]Array com os Campos Virtuais
																				@aSZ8VisuEn		,;	//04 -> [@]Array com os Campos Visuais
																				"SZ8"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																				aSZ8NotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																				@aSZ8Recnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																				"SZ8"		   	,;	//08 -> Alias do Arquivo Pai
																				NIL				,;	//09 -> Chave para o Posicionamento no Alias Filho
																				NIL				,;	//10 -> Bloco para condicao de Loop While
																				NIL				,;	//11 -> Bloco para Skip no Loop While
																				NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
																				NIL				,;	//13 -> Se Sera considerado o Inicializador Padrao
																				NIL				,;	//14 -> Opcional, Carregar Todos os Campos
																				NIL				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
																				NIL				,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
																				NIL				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
																				NIL				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
																				NIL				,;	//19 -> Carregar Coluna Fantasma
																				NIL				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
																				NIL				,;	//21 -> Verifica se Deve Checar se o campo eh usado
																				NIL				,;	//22 -> Verifica se Deve Checar o nivel do usuario
																				NIL				,;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
																				@aSZ8Keys		,;	//24 -> [@]Array que contera as chaves conforme recnos
																				@lLock			,;	//25 -> [@]Se devera efetuar o Lock dos Registros
																				@lExclu			 ;	//26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																		    );
															  ),;
											IF( lExecLock , ( lLock .and. lExclu ) , .T. );
		  					} 
		IF !( lLocks := WhileNoLock( "SZ8" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZ8 ) )
			BREAK
		EndIF

		aSvSZ8Cols		:= aClone( aSZ8Cols )

		For nLoop := 1 To nSZ8Usado
			aAdd( aSZ8Fields , aSZ8Header[ nLoop , 02 ] )
            StaticCall( NDJLIB001 , SetMemVar , aSZ8Header[ nLoop , 02 ] , aSZ8Cols[ 01 , nLoop ] , .T. )
		Next nLoop
		
		IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
	
			nLoops := Len( aSZ8VisuEn )
			For nLoop := 1 To nLoops
				aAdd( aSZ8NaoAlt , aSZ8VisuEn[ nLoop ] )
			Next nLoop
			IF ( nOpc == 4 )
				aAdd( aSZ8NaoAlt , "Z8_CONTRA"	)
				aAdd( aSZ8NaoAlt , "Z8_CODPLAN"	)
				aAdd( aSZ8NaoAlt , "Z8_ITEPLAN"	)
				aAdd( aSZ8NaoAlt , "Z8_CODIGO"	)
				aAdd( aSZ8NaoAlt , "Z8_ITEM"	)
			EndIF
			nLoops := Len( aSZ8Fields )
			For nLoop := 1 To nLoops
				IF ( aScan( aSZ8NaoAlt , { |cNaoA| cNaoA == aSZ8Fields[ nLoop ] } ) == 0 )
					aAdd( aSZ8Altera , aSZ8Fields[ nLoop ] )
				EndIF
			Next nLoop
		
		EndIF

		IF ( nOpc == 5 ) 
            cZ8Codigo    := StaticCall( NDJLIB001 , GetMemVar ,  "Z8_CODIGO" )
            cZ8Item        := StaticCall( NDJLIB001 , GetMemVar ,  "Z8_ITEM" )
			cSZ8KeySeek	:= ( cZ8Codigo + cZ8Item )
			IF !( ApdChkDel( cAlias , nReg , nOpc , cSZ8KeySeek , .F. , @aLog , @aLogTitle ) )
				aAdd( aLogGer , aClone( aLog ) )
				aAdd( aLogGerTitle , aLogTitle[1] )
			EndIF
			IF ( lExcGeraLog := !Empty( aLogGer ) )
				CursorArrow()
				//"Deseja gerar Log?"
				IF ( lExcGeraLog := MsgNoYes( STR0013 , cCadastro + " - " + OemToAnsi( cTitLog ) ) )
					CursorWait()
					//"Log de Inconsistencia na Exclusao de Designacoes"
					fMakeLog( aLogGer , aLogGerTitle , NIL , NIL , FunName() , STR0014 )
					CursorArrow()
				Else
					//"A chave a ser excluida est� sendo utilizada."
					//"Ate que as referencias a ela sejam eliminadas a mesma nao pode ser excluida."
					MsgInfo( OemToAnsi( STR0015 + CRLF + STR0016 ) , cCadastro + " - " + OemToAnsi( cTitLog ) )
				EndIF
				BREAK
			EndIF
			CursorWait()
		EndIF
	
		DEFAULT lDlgPadSiga	:= .F.
		aAdvSize		:= MsAdvSize( NIL , lDlgPadSiga )
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

		bSet15		:= { || IF(; 
									(;
										( nOpc == 3 );	//Inclusao
										.or.;
										( nOpc == 4 );	//Alteracao
									);					
									.and.;
                                    NDJA004TEncOk( nOpc , oEnSZ8 ),;                        //Valida Todos os Campos da Enchoice
									(;
										nOpcAlt 	:= 1 ,;
										RestKeys( aSvKeys , .T. ),;
										oDlg:End();
								 	),;
								 	IF(; 
								 		(;
								 			( nOpc == 3 );	//Inclusao
								 			.or.;
								 			( nOpc == 4 );  //Alteracao
								 		) ,;				
								 			(;
								 				nOpcAlt := 0 ,;
								 				.F.;
								 			 ),;	
										(;
											nOpcAlt := IF( nOpc == 2 , 0 , 1 ) ,;		//Visualizacao ou Exclusao
											RestKeys( aSvKeys , .T. ),;
											oDlg:End();
								 		);
								 	  );
							   );
						 }
		bSet24		:= { || ( nOpcAlt := 0 , RestKeys( aSvKeys , .T. ) , oDlg:End() ) }
	
		bDialogInit := { || EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ) }
	
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( STR0006 ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL

			@ 000,000 MSPANEL oPanel OF oDlg
			oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

			oEnSZ8	:= MsmGet():New(	cAlias		,;
										nReg		,;
										nOpc		,;
										NIL			,;
										NIL			,;
										NIL			,;
										aSZ8Fields	,;
										aObjSize[1]	,;
										aSZ8Altera	,;
										NIL			,;
										NIL			,;
										NIL			,;
										oPanel		,;
										NIL			,;
										.F.			,;
										NIL			,;
										.F.			 ;
									)

		ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
	
		CursorWait()
	
		IF( nOpcAlt == 1 )
	 		IF ( nOpc != 2 )
				MsAguarde(;
							{ ||;
                                    NDJA004Grava(;
													nOpc		,;	//Opcao de Acordo com aRotina
								 					nReg		,;	//Numero do Registro do Arquivo Pai ( SZ8 )
								 					aSZ8Header	,;	//Campos do Arquivo Pai ( SZ8 )
								 					aSZ8VirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZ8 )
								 					aSZ8Cols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZ8 )
								 					aSvSZ8Cols	 ;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZ8 )
								 				 );
							};
						  )
			EndIF
		Else
			While ( GetSX8Len() > nGetSX8Len )
				RollBackSX8()
			End While
		EndIF
	
	END SEQUENCE
	
	aAdd( aFreeLocks , { "SZ8" , aSZ8Recnos , aSZ8Keys } )
    StaticCall( NDJLIB003 , _FreeLocks , @aFreeLocks )

	RestArea( aArea )
	
	RestKeys( aSvKeys , .T. )
	
	CursorArrow()

Return( nOpcAlt )

/*/
    Function:	NDJA004TEncOk
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Tudo Ok para a Enchoice
    Sintaxe:    StaticCall(U_NDJA004,NDJA004TEncOk,nOpc,oEnSZ8)
/*/
Static Function NDJA004TEncOk( nOpc , oEnSZ8 )

	Local aArea		:= GetArea()
	Local aSZ8Area	:= SZ8->( GetArea() ) 

	Local lTudoOk	:= .T.

	BEGIN SEQUENCE
	                
		IF !( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
			BREAK
		EndIF

		lTudoOk := EnchoTudOk( oEnSZ8 )

	END SEQUENCE		

	RestArea ( aSZ8Area )
	RestArea ( aArea )

Return( lTudoOk )

/*/
    Function:	NDJA004Grava
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Gravar as informacoes da SZ8
    Sintaxe:    StaticCall(U_NDJA004,NDJA004Grava)
/*/
Static Function NDJA004Grava(    nOpc        ,;    //Opcao de Acordo com aRotina
							 	nReg		,;	//Numero do Registro do Arquivo Pai ( SZ8 )
							 	aSZ8Header	,;	//Campos do Arquivo Pai ( SZ8 )
							 	aSZ8VirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZ8 )
							 	aSZ8Cols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZ8 )
							 	aSvSZ8Cols	 ;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZ8 )
							  )

	Local aMestre		:= GdPutIStrMestre( 01 )
	Local aItens		:= {}

	Local cOpcao		:= IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )
	Local cZ8Codigo
	Local cCNBKeySeek

	Local lAllModif		:= .F.
	Local lSZ8Modif		:= .F.

	Local nLoop
	Local nLoops
	Local nCNBOrder
	
	CursorWait()
	
		IF ( cOpcao == "DELETE" )
			lSZ8Modif := .T.
		EndIF

		IF !( lSZ8Modif )
			nLoops := Len( aSZ8Header )
			For nLoop := 1 To nLoops
                aSZ8Cols[ 01 , nLoop ] := StaticCall( NDJLIB001 , GetMemVar ,  aSZ8Header[ nLoop , 02 ] )
			Next nLoop
			lSZ8Modif := !( ArrayCompare( aSZ8Cols , aSvSZ8Cols ) )
		EndIF
	
	 	lAllModif := (  lSZ8Modif )
	
		IF ( lAllModif )
	
			aMestre[ 01 , 01 ]	:= "SZ8"
			aMestre[ 01 , 02 ]	:= nReg
			aMestre[ 01 , 03 ]	:= lSZ8Modif
			aMestre[ 01 , 04 ]	:= aClone( aSZ8Header )
			aMestre[ 01 , 05 ]	:= aClone( aSZ8VirtEn )
			aMestre[ 01 , 06 ]	:= {}
			aMestre[ 01 , 07 ]	:= aItens
		
			GdPutInfoData( aMestre , cOpcao , .F. , .F. )

			nCNBOrder		:= RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_NUMERO+CNB_ITEM" )

			SZ8->( MsGoto( nReg ) )
			cCNBKeySeek := xFilial( "CNB" , SZ8->Z8_FILIAL )
			cCNBKeySeek += SZ8->Z8_CONTRA
			cCNBKeySeek += SZ8->Z8_CODPLAN
			cCNBKeySeek += SZ8->Z8_ITEPLAN
			IF CNB->( dbSeek( cCNBKeySeek , .F. ) )
				IF ( cOpcao == "DELETE" )
                	cZ8Codigo	:= GetSx3Cache( "Z8_CODIGO" , "X3_TAMANHO" )
				Else
                    cZ8Codigo    := StaticCall( NDJLIB001 , __FieldGet , "S8" , "Z8_CODIGO" , .F. )
				EndIF
                StaticCall( NDJLIB001 , __FieldPut , "CNB" , "CNB_XCIRQT" , cZ8Codigo , .T. )
			EndIF

			While ( GetSX8Len() > nGetSX8Len )
				ConfirmSX8()
			End While

		EndIF

	CursorArrow()

Return( NIL )

/*/
	Function:	Z8CodigoVld
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Funcao para Validar o Conteudo do Campo Z8_CODIGO
    Sintaxe:    StaticCall(U_NDJA004,Z8CodigoVld)
/*/
Static Function Z8CodigoVld( cZ8Contra , cZ8CodPlan , cZ8ItePan )

    Local cZ8Codigo        := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODIGO" )

	Local nFieldPos
	
	Local lSZ8CodigoOk	:= .T.
	
	BEGIN SEQUENCE

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CONTRA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CONTRA" ) );
			)
			DEFAULT cZ8Contra := GdFieldGet( "Z8_CONTRA" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CONTRA" ) )
            DEFAULT cZ8Contra := StaticCall( NDJLIB001 , GetMemVar , "Z8_CONTRA" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CONTRA" ) ) > 0 )
			DEFAULT cZ8Contra := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODPLAN" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODPLAN" ) );
			)
			DEFAULT cZ8CodPlan := GdFieldGet( "Z8_CODPLAN" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODPLAN" ) )
            DEFAULT cZ8CodPlan := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODPLAN" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODPLAN" ) ) > 0 )
			DEFAULT cZ8CodPlan := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_ITEPLAN" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_ITEPLAN" ) );
			)
			DEFAULT cZ8ItePan := GdFieldGet( "Z8_ITEPLAN" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_ITEPLAN" ) )
            DEFAULT cZ8ItePan := StaticCall( NDJLIB001 , GetMemVar , "Z8_ITEPLAN" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_ITEPLAN" ) ) > 0 )
			DEFAULT cZ8ItePan := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF !( lSZ8CodigoOk := Z8GetCodigo( @cZ8Contra , @cZ8CodPlan , @cZ8ItePan , @cZ8Codigo , .F. , .F. ) )
	    	Help( "" , 1 , "Z8_CODIGO" , NIL , OemToAnsi( "C�digo Invᬩdo" ) , 1 , 0 )			
	    	BREAK
	    EndIF
	
        StaticCall( NDJLIB001 , SetMemVar , "Z8_CODIGO" , cZ8Codigo )
	
	END SEQUENCE
	
Return( lSZ8CodigoOk )

/*/
	Function:	Z8GetCodigo
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Funcao para Obter o Proximo Codigo para a Tabela SZ8
    Sintaxe:    StaticCall(U_NDJA004,Z8GetCodigo)
/*/
Static Function Z8GetCodigo( cZ8Contra , cZ8CodPlan , cZ8ItePan , cZ8Codigo )

	Local bUseCode		:= { || cUseCode	:= ( cEmpAnt + cFilAnt + "SZ8" + cZ8Codigo ) }
	Local bGetNumExc	:= { || cZ8Codigo := __Soma1( cZ8Codigo ) }

	Local cWhere		:= ""
	Local cUseCode		:= ""
	Local cSZ8Filial	:= xFilial( "SZ8" )

	Local lZ8GetCodigo	:= .T.

	Local nFieldPos

	IF Empty( cZ8Codigo )

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CONTRA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CONTRA" ) );
			)
			DEFAULT cZ8Contra := GdFieldGet( "Z8_CONTRA" )
      ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CONTRA" ) )
            DEFAULT cZ8Contra := StaticCall( NDJLIB001 , GetMemVar , "Z8_CONTRA" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CONTRA" ) ) > 0 )
			DEFAULT cZ8Contra := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODPLAN" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODPLAN" ) );
			)
			DEFAULT cZ8CodPlan := GdFieldGet( "Z8_CODPLAN" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODPLAN" ) )
            DEFAULT cZ8CodPlan := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODPLAN" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODPLAN" ) ) > 0 )
			DEFAULT cZ8CodPlan := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_ITEPLAN" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_ITEPLAN" ) );
			)
			DEFAULT cZ8ItePan := GdFieldGet( "Z8_ITEPLAN" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_ITEPLAN" ) )
            DEFAULT cZ8ItePan := StaticCall( NDJLIB001 , GetMemVar , "Z8_ITEPLAN" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_ITEPLAN" ) ) > 0 )
			DEFAULT cZ8ItePan := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		cWhere		:= "SZ8.Z8_FILIAL='" + cSZ8Filial +"'"
		cWhere		+= " AND "
		cWhere		+= "SZ8.Z8_CONTRA='" + cZ8Contra +"'"
		cWhere		+= " AND "
		cWhere		+= "SZ8.Z8_CODPLAN='" + cZ8CodPlan +"'"
		cWhere		+= " AND "
		cWhere		+= "SZ8.Z8_ITEPLAN='" + cZ8ItePan +"'"

        cZ8Codigo    := StaticCall( NDJLIB001 , QryMaxCod , "SZ8" , "Z8_CODIGO" , cWhere , .T. )

		IF Empty( cZ8Codigo )
			cWhere		:= "SZ8.Z8_FILIAL='" + cSZ8Filial +"'"
            cZ8Codigo    := StaticCall( NDJLIB001 , QryMaxCod , "SZ8" , "Z8_CODIGO" , cWhere , .T. )
			IF Empty( cZ8Codigo )
				cZ8Codigo	:= Replicate( "0" , GetSx3Cache( "Z8_CODIGO" , "X3_TAMANHO" ) )
			EndIF
			cZ8Codigo	:= Eval( bGetNumExc )
			While (;
                        !( StaticCall( NDJLIB003 , UseCode , Eval( bUseCode ) ) );
						.or.;
                        ( cZ8Codigo == StaticCall( NDJLIB001 , QryMaxCod , "SZ8" , "Z8_CODIGO" , cWhere , .T. ) );
				  )
                StaticCall( NDJLIB003 , ReleaseCode , Eval( bUseCode ) )
				cZ8Codigo	:= Eval( bGetNumExc )
			End While
		EndIF

        lZ8GetCodigo := StaticCall( NDJLIB003 , UseCode , Eval( bUseCode ) )

	EndIF

    SetMaxCode( NDJ_MAX_CODE )
    StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )

Return( lZ8GetCodigo )

/*/
	Function:	Z8CodigoInit
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Inicializador Padrao do Campo Z8_CODIGO
    Sintaxe:    StaticCall(U_NDJA004,Z8CodigoInit)
/*/
Static Function Z8CodigoInit( cZ8Contra , cZ8CodPlan , cZ8ItePan )

	Local cZ8Codigo
	
	Local nFieldPos

	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "Z8_CONTRA" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CONTRA" ) );
		)
		DEFAULT cZ8Contra := GdFieldGet( "Z8_CONTRA" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CONTRA" ) )
        DEFAULT cZ8Contra := StaticCall( NDJLIB001 , GetMemVar , "Z8_CONTRA" )
	ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CONTRA" ) ) > 0 )
		DEFAULT cZ8Contra := SZ8->( FieldGet( nFieldPos ) )
	EndIF

	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODPLAN" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODPLAN" ) );
		)
		DEFAULT cZ8CodPlan := GdFieldGet( "Z8_CODPLAN" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODPLAN" ) )
        DEFAULT cZ8CodPlan := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODPLAN" )
	ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODPLAN" ) ) > 0 )
		DEFAULT cZ8CodPlan := SZ8->( FieldGet( nFieldPos ) )
	EndIF

	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "Z8_ITEPLAN" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_ITEPLAN" ) );
		)
		DEFAULT cZ8ItePan := GdFieldGet( "Z8_ITEPLAN" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_ITEPLAN" ) )
        DEFAULT cZ8ItePan := StaticCall( NDJLIB001 , GetMemVar , "Z8_ITEPLAN" )
	ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_ITEPLAN" ) ) > 0 )
		DEFAULT cZ8ItePan := SZ8->( FieldGet( nFieldPos ) )
	EndIF

	Z8GetCodigo( @cZ8Contra , @cZ8CodPlan , @cZ8ItePan , @cZ8Codigo , .F. , .F. )

Return( cZ8Codigo )

/*/
	Function:	Z8ItemVld
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Funcao para Validar o Conteudo do Campo Z8_ITEM
    Sintaxe:    StaticCall(U_NDJA004,Z8ItemVld)
/*/
Static Function Z8ItemVld( cZ8Codigo )

	Local cZ8Item
	
	Local lSZ8ItemOk	:= .T.
	
	Local nFieldPos
	
	BEGIN SEQUENCE

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODIGO" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODIGO" ) );
			)
			DEFAULT cZ8Codigo := GdFieldGet( "Z8_CODIGO" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODIGO" ) )
            DEFAULT cZ8Codigo := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODIGO" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODIGO" ) ) > 0 )
			DEFAULT cZ8Codigo := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_ITEM" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_ITEM" ) );
			)
			cZ8Item := GdFieldGet( "Z8_ITEM" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_ITEM" ) )
            cZ8Item := StaticCall( NDJLIB001 , GetMemVar , "Z8_ITEM" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_ITEM" ) ) > 0 )
			cZ8Item := SZ8->( FieldGet( nFieldPos ) )
		EndIF
		
		IF !( lSZ8ItemOk := Z8GetItem( @cZ8Codigo , @cZ8Item , .F. , .F. ) )
			Help( "" , 1 , "Z8_ITEM" , NIL , OemToAnsi( "Item Invᬩdo" ) , 1 , 0 )
	    	BREAK
	    EndIF

        StaticCall( NDJLIB001 , SetMemVar , "Z8_ITEM" , cZ8Item )

	END SEQUENCE

Return( lSZ8ItemOk )

/*/
	Function:	Z8GetItem
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Funcao para Obter o Proximo Item para a Tabela SZ8
    Sintaxe:    StaticCall(U_NDJA004,Z8GetItem)
/*/
Static Function Z8GetItem( cZ8Codigo , cZ8Item , lExistChav , lShowHelp )
	Local bGetNumExc	:= { || cZ8Item := __Soma1( cZ8Item ) }
	Local cSZ8Filial	:= xFilial( "SZ8" )
	Local cWhere		:= ""
	Local nFieldPos
	IF Empty( cZ8Item )
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODIGO" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODIGO" ) );
			)
			DEFAULT cZ8Codigo := GdFieldGet( "Z8_CODIGO" )
          ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODIGO" ) )
            DEFAULT cZ8Codigo := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODIGO" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODIGO" ) ) > 0 )
			DEFAULT cZ8Codigo := SZ8->( FieldGet( nFieldPos ) )
		EndIF
		cWhere  := "SZ8.Z8_FILIAL='" + cSZ8Filial +"'"
		cWhere  += " AND "
		cWhere  += "SZ8.Z8_CODIGO='" + cZ8Codigo  +"'"
        cZ8Item := StaticCall( NDJLIB001 , QryMaxCod , "SZ8" , "Z8_ITEM" , cWhere , .T. )
		IF Empty( cZ8Item )
			cZ8Item := Replicate( "0" , GetSx3Cache( "Z8_ITEM" , "X3_TAMANHO" ) )
		EndIF
		cZ8Item := Eval( bGetNumExc )
	EndIF
    SetMaxCode( NDJ_MAX_CODE )
    StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
Return(;
			GetNrExclOk(	@cZ8Item 						,;
							"SZ8"							,;
							"Z8_ITEM"						,;
							"Z8_FILIAL+Z8_CODIGO+Z8_ITEM"	,;
							bGetNumExc						,;
							lExistChav						,;
							lShowHelp	 					,;
							cZ8Codigo						;
						);
		)

/*/
	Function:	Z8ItemInit
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Inicializador Padrao do Campo Z8_ITEM
    Sintaxe:    StaticCall(U_NDJA004,Z8ItemInit)
/*/
Static Function Z8ItemInit( cZ8Codigo )
	Local cZ8Item
	Local nFieldPos
	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODIGO" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODIGO" ) );
		)
		DEFAULT cZ8Codigo := GdFieldGet( "Z8_CODIGO" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODIGO" ) )
        DEFAULT cZ8Codigo := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODIGO" )
	ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODIGO" ) ) > 0 )
		DEFAULT cZ8Codigo := SZ8->( FieldGet( nFieldPos ) )
	EndIF
	Z8GetItem( @cZ8Codigo , @cZ8Item , .F. , .F. )
Return( cZ8Item )

/*/
	Function:	Z8ContraInit
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Inicializador Padrao do Campo Z8_CONTRA
    Sintaxe:    StaticCall(U_NDJA004,Z8ContraInit)
/*/
Static Function Z8ContraInit()

	Local cZ8Contra 
	Local nFieldPos

	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CN9_NUMERO" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CN9_NUMERO" ) );
		)
		cZ8Contra  := GdFieldGet( "CN9_NUMERO" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CN9_NUMERO" ) )
        cZ8Contra  := StaticCall( NDJLIB001 , GetMemVar , "CN9_NUMERO" )
	ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_NUMERO" ) ) > 0 )
		cZ8Contra  := CN9->( FieldGet( nFieldPos ) )
	Else
		cZ8Contra  := Space( GetSx3Cache( "CN9_NUMERO" , "X3_TAMANHO" ) )
	EndIF

Return( cZ8Contra  )

/*/
	Function:	Z8ContraVld
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Valid do Campo Z8_CONTRA
    Sintaxe:    StaticCall(U_NDJA004,Z8ContraVld)
/*/
Static Function Z8ContraVld( cZ8Contra , lShowHelp , cMsgHelp )

	Local lSZ8ContraOK	:= .T.
	
	Local nCN9Order		:= RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )
	
	Local nFieldPos
	
	BEGIN SEQUENCE

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CONTRA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CONTRA" ) );
			)
			DEFAULT cZ8Contra := GdFieldGet( "Z8_CONTRA" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CONTRA" ) )
            DEFAULT cZ8Contra := StaticCall( NDJLIB001 , GetMemVar , "Z8_CONTRA" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CONTRA" ) ) > 0 )
			DEFAULT cZ8Contra := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF !( lSZ8ContraOK := !Empty( cZ8Contra ) )
			cMsgHelp := STR0021	//"O Campo:"
			cMsgHelp += " "
			cMsgHelp += GetCache( "SX3" , "Z8_CONTRA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( Z8_CONTRA )"
			cMsgHelp += " "
			cMsgHelp += STR0022	//"deve ser preenchido."
			BREAK
		EndIF
	
		IF !( lSZ8ContraOK := ExistCpo("CN9",cZ8Contra,nCN9Order) )
			BREAK
		EndIF

	END SEQUENCE	

	DEFAULT lShowHelp	:= .T.	
	IF !Empty( cMsgHelp )
		IF ( lShowHelp )
			Help( "" , 1 , "Z8_CONTRA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )			
		EndIF
	EndIF

Return( lSZ8ContraOK )

/*/
	Function:	Z8CodPlanInit
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Inicializador Padrao do Campo Z8_CODPLAN
    Sintaxe:    StaticCall(U_NDJA004,Z8CodPlanInit)
/*/
Static Function Z8CodPlanInit()
	Local cSZ8CodPlan 
	cSZ8CodPlan  := Space( GetSx3Cache( "Z8_CODPLAN" , "X3_TAMANHO" ) )
Return( cSZ8CodPlan  )

/*/
	Function:	Z8CodPlanVld
	Autor:		Marinaldo de Jesus
	Data:		20/11/2010
	Descricao:	Valid do Campo Z8_CODPLAN
    Sintaxe:    StaticCall(U_NDJA004,Z8CodPlanVld)
/*/
Static Function Z8CodPlanVld( cZ8CodPlan , lShowHelp , cMsgHelp )

	Local cZ8Contra
	
	Local lSZ8CodPlanOK	:= .T.
	
	Local nCNBOrder		:= RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_NUMERO" )
	
	Local nFieldPos

	DEFAULT	lShowHelp 	:= .T.
	
	BEGIN SEQUENCE

		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CN9_NUMERO" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CN9_NUMERO" ) );
			)
			cZ8Contra  := GdFieldGet( "CN9_NUMERO" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CN9_NUMERO" ) )
            cZ8Contra  := StaticCall( NDJLIB001 , GetMemVar , "CN9_NUMERO" )
		ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_NUMERO" ) ) > 0 )
			cZ8Contra  := CN9->( FieldGet( nFieldPos ) )
		Else
			cZ8Contra  := Space( GetSx3Cache( "CN9_NUMERO" , "X3_TAMANHO" ) )
		EndIF
	
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "Z8_CODPLAN" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "Z8_CODPLAN" ) );
			)
			DEFAULT cZ8CodPlan := GdFieldGet( "Z8_CODPLAN" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "Z8_CODPLAN" ) )
            DEFAULT cZ8CodPlan := StaticCall( NDJLIB001 , GetMemVar , "Z8_CODPLAN" )
		ElseIF ( SZ8->( nFieldPos := FieldPos( "Z8_CODPLAN" ) ) > 0 )
			DEFAULT cZ8CodPlan := SZ8->( FieldGet( nFieldPos ) )
		EndIF

		IF !( lSZ8CodPlanOK := !Empty( cZ8CodPlan ) )
			cMsgHelp := STR0021	//"O Campo:"
			cMsgHelp += " "
			cMsgHelp += GetCache( "SX3" , "Z8_CODPLAN" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( Z8_CODPLAN )"
			cMsgHelp += " "
			cMsgHelp += STR0022	//"deve ser preenchido."
			BREAK
		EndIF
	
		IF !( lSZ8CodPlanOK := ExistCpo( "CNB" , cZ8Contra+cZ8CodPlan , nCNBOrder ) )
			BREAK
		EndIF

		IF !( lSZ8CodPlanOK := Z8CodigoVld( @cZ8Contra , @cZ8CodPlan ) )
			IF ( lShowHelp )
				Help( "" , 1 , "Z8_CODIGO" , NIL , OemToAnsi( "C�digo Invᬩdo" ) , 1 , 0 )
			EndIF
			BREAK
		EndIF

		IF !( lSZ8CodPlanOK := Z8ItemVld() )
			IF ( lShowHelp )
				Help( "" , 1 , "Z8_ITEMVLD" , NIL , OemToAnsi( "Item Invᬩdo" ) , 1 , 0 )
			EndIF
			BREAK
		EndIF

	END SEQUENCE	

	IF !Empty( cMsgHelp )
		IF ( lShowHelp )
			Help( "" , 1 , "Z8_CODPLAN" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
		EndIF
	EndIF

Return( lSZ8CodPlanOK )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJA004()
        NDJA004Vis()
        NDJA004Inc()
        NDJA004Alt()
        NDJA004Del()
        NDJA004Mnt()
        NDJA004TEncOk()
        NDJA004Grava()
		Z8CodigoInit()
		Z8CodigoVld()
		Z8ContraVld()
		Z8CodPlanInit()
		Z8CodPlanVld()
		Z8ItemInit()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )