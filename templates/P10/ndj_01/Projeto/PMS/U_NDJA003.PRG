#INCLUDE "NDJ.CH"
#INCLUDE "U_NDJA003.CH"
/*/
    Function:	NDJA003
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:  Cadastro de Programas NDJ
    Sintaxe:    NDJA003     - Chamada a partir do menu
                U_NDJA003( cAlias , nReg , nOpc , <lExecAuto> ) - Chamada em outros pontos do sistema
/*/
User Function NDJA003( cAlias , nReg , nOpc , lExecAuto )

	Local aArea 	:= GetArea()
	Local aAreaSZJ	:= SZJ->( GetArea() )
	Local aAreaSZK	:= SZK->( GetArea() )
	Local aSaveGet	:= SaveoGet()
	
	Local lExistOpc	:= ( ValType( nOpc ) == "N" )

	BEGIN SEQUENCE

		cAlias	:= "SZJ"
	
		Private aRotina		:= {;
									{ STR0001 , "PesqBrw"		, 0 , 01 } ,; //"Pesquisar"
                                    { STR0002 , "U_NDJA003Mnt"	, 0 , 02 } ,; //"Visualizar"
                                    { STR0003 , "U_NDJA003Mnt"	, 0 , 03 } ,; //"Incluir"
                                    { STR0004 , "U_NDJA003Mnt"	, 0 , 04 } ,; //"Alterar"
                                    { STR0005 , "U_NDJA003Mnt"	, 0 , 05 }  ; //"Excluir"
								}

        Private cCadastro    := OemToAnsi( STR0006 )    //"Cadastro de Programas NDJ"
	
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
				bBlock := &( "{ |a,b,c,d| " + aRotina[ nPos , 2 ] + "(a,b,c,d) }" )
				Eval( @bBlock , @cAlias , @nReg , @nPos )
			
			Else
	
                U_NDJA003Mnt( @cAlias , @nReg , @nOpc , .T. )
			
			EndIF	
		
		Else
	
			mBrowse( 6 , 1 , 22 , 75 , cAlias )
	
		EndIF
		
	END SEQUENCE
	
	CursorWait()

	RestArea( aAreaSZK )
	RestArea( aAreaSZJ )
	RestArea( aArea )
	
	CursorArrow()

	RestartoGet( aSaveGet )

Return( NIL )

/*/
    Function:	InNDJA003Exec
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Executar Funcoes Dentro de NDJA003
    Sintaxe:    StaticCall(U_NDJA003,InNDJA003Exec,cExecIn,aFormParam )
/*/
Static Function InNDJA003Exec( cExecIn , aFormParam )
         
	Local uRet

	TRYEXCEPTION
	
		DEFAULT cExecIn		:= ""
		DEFAULT aFormParam	:= {}
		
		IF !Empty( cExecIn )
			cExecIn	:= BldcExecInFun( cExecIn , aFormParam )
			uRet	:= &( cExecIn )
		EndIF

	CATCHEXCEPTION 

		uRet	:= NIL

	ENDEXCEPTION

Return( uRet )

/*/
    Function:	NDJA003Vis
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Cadastro de Programas NDJ (Visualizar)
    Sintaxe:    StaticCall(U_NDJA003,NDJA003Vis,cAlias,nReg)
/*/
Static Function NDJA003Vis( cAlias , nReg )
	Local nOpc := 2
Return( U_NDJA003( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA003Inc
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Cadastro de Programas NDJ (Incluir)
    Sintaxe:    StaticCall(U_NDJA003,NDJA003Inc,cAlias,nReg)
/*/
Static Function NDJA003Inc( cAlias , nReg )
	Local nOpc := 3
	IF ( nReg > 0 )
		nOpc := 4
	EndIF
Return( U_NDJA003( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA003Alt
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Cadastro de Programas NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA003,NDJA003Alt,cAlias,nReg)
/*/
Static Function NDJA003Alt( cAlias , nReg )
	Local nOpc := 4
Return( U_NDJA003( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA003Del
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Cadastro de Programas NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA003,NDJA003Del,cAlias,nReg)
/*/
Static Function NDJA003Del( cAlias , nReg )
	Local nOpc := 5
Return( U_NDJA003( @cAlias , @nReg , @nOpc ) )

/*/
    Function:	NDJA003Mnt
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
    Descricao:	Cadastro de Programas NDJ (Manutencao)
    Sintaxe:    U_NDJA003Mnt( cAlias , nReg , lDlgPadSiga )
/*/
User Function NDJA003Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

	Local aArea			:= GetArea(Alias())
	Local aAreaSZJ		:= SZJ->( GetArea() )
	Local aSvKeys		:= GetKeys()
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {}
	Local aSZJHeader	:= {}
	Local aSZJCols		:= {}
	Local aSvSZJCols	:= {}
	Local aSZJFields	:= {}
	Local aSZJAltera	:= {}
	Local aSZJNaoAlt	:= {}
	Local aSZJVirtEn	:= {}
	Local aSZJNotFields	:= {}
	Local aSZJRecnos	:= {}
	Local aSZJKeys		:= {}
	Local aSZJVisuEn	:= {}
	Local aSZKGdAltera  := {}
	Local aSZKGdNaoAlt	:= {}
	Local aSZKRecnos	:= {}
	Local aSZKKeys		:= {}
	Local aSZKNotFields	:= {}
	Local aSZKVirtGd	:= {}
	Local aSZKVisuGd	:= {}
	Local aSZKHeader	:= {}
	Local aSZKCols		:= {}
	Local aSvSZKCols	:= {}
	Local aSZKQuery		:= {}
	Local aButtons		:= {}
	Local aFreeLocks	:= {}
	Local aLog			:= {}
	Local aLogTitle		:= {}
	Local aLogGer		:= {}
	Local aLogGerTitle	:= {}
	
	Local bSZKGdDelOk	:= { |lDelOk| CursorWait() , lDelOk := SZKGdDelOk( "SZK" , NIL , nOpc , cZJXCodPro , nSZKOrder ) , CursorArrow() , lDelOk }
	Local bSet15		:= { || NIL }
	Local bSet24		:= { || NIL }
	Local bGdSZKSeek	:= { || NIL }
	Local bDialogInit	:= { || NIL }
	Local bGetSZJ		:= { || NIL } 
	Local bGetSZK		:= { || NIL }
	Local bSZKSort		:= { || NIL }
	Local bSZKLinOk		:= { |oBrowse| oGdSZKLinOk( oBrowse ) }
	Local bSZKTudOk		:= { |oBrowse| oGdSZKTudOk( oBrowse ) }
	
	Local cNumSC		:= ""
	Local cItemSC		:= ""
	Local cFilSZJ		:= ""
	Local cZJXCodPro		:= ""
	Local cZJKeySeek	:= ""
	Local cMsgYesNo		:= ""
	Local cTitLog		:= ""
	
	Local lLocks		:= .F.
	Local lExecLock		:= ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
	Local lExcGeraLog	:= .F.
	
	Local nOpcAlt		:= 0
	Local nSZJUsado		:= 0
	Local nSZKUsado		:= 0
	Local nLoop			:= 0
	Local nLoops		:= 0
	Local nOpcNewGd		:= 0
	Local nSZKMaxLocks	:= 50
	Local nSZKGhostCol	:= 0
	Local nSZKOrder		:= RetOrder( "SZK" , "ZK_FILIAL+ZK_XCODPRO+ZK_CGESTOR" )
	Local nSZJOrder		:= RetOrder( "SZJ" , "ZJ_FILIAL+ZJ_XCODPRO" )
	
	Local oDlg			:= NIL
	Local oEnSZJ		:= NIL	
	Local oGdSZK		:= NIL

	Local oPanel

	Private aGets
	Private aTela

	Private nGetSX8Len	:= GetSX8Len()
	
	CursorWait()
	
	BEGIN SEQUENCE

		aRotSetOpc( cAlias , @nReg , nOpc )
	
		aSZJNotFields	:= { "ZJ_FILIAL" }
		bGetSZJ			:= { |lLock,lExclu|	IF( lExecLock , ( lLock := .T. , lExclu	:= .T. ) , aSZJKeys := NIL ),;
											aSZJCols := SZJ->(;
																GdBuildCols(	@aSZJHeader		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																				@nSZJUsado		,;	//02 -> Numero de Campos em Uso
																				@aSZJVirtEn		,;	//03 -> [@]Array com os Campos Virtuais
																				@aSZJVisuEn		,;	//04 -> [@]Array com os Campos Visuais
																				"SZJ"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																				aSZJNotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																				@aSZJRecnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																				"SZJ"		   	,;	//08 -> Alias do Arquivo Pai
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
																				@aSZJKeys		,;	//24 -> [@]Array que contera as chaves conforme recnos
																				@lLock			,;	//25 -> [@]Se devera efetuar o Lock dos Registros
																				@lExclu			 ;	//26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																		    );
															  ),;
											IF( lExecLock , ( lLock .and. lExclu ) , .T. );
		  					} 

		IF !( lLocks := WhileNoLock( "SZJ" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZJ ) )
			BREAK
		EndIF
		cFilSZJ			:= SZJ->ZJ_FILIAL
		cZJXCodPro		:= SZJ->ZJ_XCODPRO
		cZJKeySeek		:= ( cFilSZJ + cZJXCodPro )

		SZJ->( dbSetOrder( nSZJOrder ) )
		IF SZJ->( !dbSeek( cZJKeySeek , .F. ) )
			nOpc		:= 3
			aRotSetOpc( cAlias , @nReg , @nOpc )
			aSvSZJCols	:= {}
		Else
			aSvSZJCols	:= aClone( aSZJCols )
		EndIF

		SZJ->( RestArea( aAreaSZJ ) )

		lExecLock	:= ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
		lExcGeraLog	:= .F.
		nOpcNewGd	:= IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE	)

		For nLoop := 1 To nSZJUsado
			aAdd( aSZJFields , aSZJHeader[ nLoop , 02 ] )
            StaticCall( NDJLIB001 , SetMemVar , aSZJHeader[ nLoop , 02 ] , aSZJCols[ 01 , nLoop ] , .T. )
		Next nLoop
		
		IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
	
			nLoops := Len( aSZJVisuEn )
			For nLoop := 1 To nLoops
				aAdd( aSZJNaoAlt , aSZJVisuEn[ nLoop ] )
			Next nLoop
			IF ( nOpc == 4 )
				aAdd( aSZJNaoAlt , "ZJ_XCODPRO" )
			EndIF
			nLoops := Len( aSZJFields )
			For nLoop := 1 To nLoops
				IF ( aScan( aSZJNaoAlt , { |cNaoA| cNaoA == aSZJFields[ nLoop ] } ) == 0 )
					aAdd( aSZJAltera , aSZJFields[ nLoop ] )
				EndIF
			Next nLoop
		
		EndIF

		aAdd( aSZKNotFields , "ZK_FILIAL"  )
		aAdd( aSZKNotFields , "ZK_XCODPRO"  )
		#IFDEF TOP
			aSZKQuery		:= Array( 05 )
			aSZKQuery[01]	:= "	D_E_L_E_T_<>'*' "
			aSZKQuery[02]	:= " AND "
			aSZKQuery[03]	:= "	ZK_FILIAL='"+cFilSZJ+"'"
			aSZKQuery[04]	:= " AND "
			aSZKQuery[05]	:= "	ZK_XCODPRO='"+cZJXCodPro+"'"
		#ENDIF

		IF ( nOpc == 3  ) //Inclusao
			PutFileInEof( "SZK" )
		EndIF

		bGetSZK	:= { |lLock,lExclu|	IF( lExecLock , ( lLock := .T. , lExclu := .T. ) , aSZKKeys := NIL ),;
						 				aSZKCols := SZK->(;
														GdBuildCols(	@aSZKHeader		,;	//01 -> Array com os Campos do Cabecalho da GetDados
																		@nSZKUsado		,;	//02 -> Numero de Campos em Uso
																		@aSZKVirtGd		,;	//03 -> [@]Array com os Campos Virtuais
																		@aSZKVisuGd		,;	//04 -> [@]Array com os Campos Visuais
																		"SZK"			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
																		aSZKNotFields	,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
																		@aSZKRecnos		,;	//07 -> [@]Array unidimensional contendo os Recnos
																		"SZJ"		   	,;	//08 -> Alias do Arquivo Pai
																		cZJKeySeek		,;	//09 -> Chave para o Posicionamento no Alias Filho
																		NIL				,;	//10 -> Bloco para condicao de Loop While
																		NIL				,;	//11 -> Bloco para Skip no Loop While
																		NIL				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
																		NIL				,;	//13 -> Se Sera considerado o Inicializador Padrao
																		NIL				,;	//14 -> Opcional, Carregar Todos os Campos
																		NIL				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
																		aSZKQuery		,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
																		.F.				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
																		.F.				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
																		Altera			,;	//19 -> Carregar Coluna Fantasma
																		NIL				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
																		NIL				,;	//21 -> Verifica se Deve Checar se o campo eh usado
																		NIL				,;	//22 -> Verifica se Deve Checar o nivel do usuario
																		NIL				,;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
																		@aSZKKeys		,;	//24 -> [@]Array que contera as chaves conforme recnos
																		@lLock			,;	//25 -> [@]Se devera efetuar o Lock dos Registros
																		@lExclu			,;	//26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
																		nSZKMaxLocks	,;	//27 -> Numero maximo de Locks a ser efetuado
																		Altera			 ;	//28 -> Utiliza Numeracao na GhostCol
																    );
														  ),;
										IF( lExecLock , ( lLock .and. lExclu ) , .T. );
		  		    }

		IF !( lLocks := WhileNoLock( "SZK" , NIL , NIL , 1 , 1 , .T. , nSZKMaxLocks , 5 , bGetSZK ) )
			BREAK
		EndIF
		CursorWait()

		IF ( ( nSZKGhostCol := GdFieldPos( "GHOSTCOL" , aSZKHeader ) ) > 0 )
			bSZKSort := { |x,y| ( x[ nSZKGhostCol ] < y[ nSZKGhostCol ] ) }
		EndIF
	
		aSvSZKCols	:= aClone( aSZKCols )

		For nLoop := 1	To nSZKUsado
            StaticCall( NDJLIB001 , SetMemVar , aSZKHeader[ nLoop , 02 ] , GetValType( aSZKHeader[ nLoop , 08 ] , aSZKHeader[ nLoop , 04 ] ) , .T. )
			IF (;
					( aScan( aSZKVirtGd		, aSZKHeader[ nLoop , 02 ] ) == 0 ) .and.	;
			   		( aScan( aSZKVisuGd		, aSZKHeader[ nLoop , 02 ] ) == 0 ) .and.	;
			   		( aScan( aSZKNotFields	, aSZKHeader[ nLoop , 02 ] ) == 0 ) .and.	;
			   		( aScan( aSZKGdNaoAlt	, aSZKHeader[ nLoop , 02 ] ) == 0 )		;
			  	)
				aAdd( aSZKGdAltera , aSZKHeader[ nLoop , 02 ] )
			EndIF			   
		Next nLoop

		IF ( nOpc == 5 ) 
			IF !( ApdChkDel( cAlias , nReg , nOpc , cZJXCodPro , .F. , @aLog , @aLogTitle , { "SZK" } ) )
				aAdd( aLogGer , aClone( aLog ) )
				aAdd( aLogGerTitle , aLogTitle[1] )
			EndIF
			IF ( lExcGeraLog := !Empty( aLogGer ) )
				CursorArrow()
				//"Deseja gerar Log?"
				IF ( lExcGeraLog := MsgNoYes( STR0013 , cCadastro + " - " + OemToAnsi( cTitLog ) ) )
					CursorWait()
					//"Log de Inconsistencia na Exclusao de Tipos de Avaliacao"
					fMakeLog( aLogGer , aLogGerTitle , NIL , NIL , FunName() , STR0014 )
					CursorArrow()
				Else
					//"A chave a ser excluida est� sendo utilizada."
					//"At� que as refer�ncias a ela sejam eliminadas a mesma n�o pode ser excluida."
					MsgInfo( OemToAnsi( STR0015 + CRLF + STR0016 ) , cCadastro + " - " + OemToAnsi( cTitLog ) )
				EndIF
				BREAK
			EndIF
			CursorWait()
		EndIF
	
		DEFAULT lDlgPadSiga	:= .F.
		aAdvSize		:= MsAdvSize( NIL , lDlgPadSiga )
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aAdd( aObjCoords , { 000 , 025 , .T. , .F. } )
		aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

		bGdSZKSeek := { ||	GdSZKSeek( oGdSZK )				,;
							SetKey( VK_F4 , bGdSZKSeek )	 ;
				   }
		aAdd(;
				aButtons	,;
								{;
									"PMSPESQ",;
		   							bGdSZKSeek,;
		       	   					OemToAnsi( STR0001 + "...<F4>"  ),;	//"Pesquisar"
		       	   					OemToAnsi( STR0001 );				//"Pesquisar"
		           				};
		     )

		bSet15		:= { || IF(; 
									(;
										( nOpc == 3 );	//Inclusao
										.or.;
										( nOpc == 4 );	//Alteracao
									);					
									.and.;
                                    NDJA003TEncOk( nOpc , oEnSZJ );                            //Valida Todos os Campos da Enchoice
									.and.;
									oGdSZK:TudoOk(),;										//Valida as Informacoes da GetDados
									(;
										nOpcAlt 	:= 1 ,;
										aSZKCols	:= oGdSZK:aCols,;						//Redireciona o Ponteiro do aSZKCols
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
	
		bDialogInit := { ||;
								EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
								SetKey( VK_F4 , bGdSZKSeek  ),;
						}
	
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( STR0006 ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL

			@ 000,000 MSPANEL oPanel OF oDlg
			oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

			oEnSZJ	:= MsmGet():New(	cAlias		,;
										nReg		,;
										nOpc		,;
										NIL			,;
										NIL			,;
										NIL			,;
										aSZJFields	,;
										aObjSize[1]	,;
										aSZJAltera	,;
										NIL			,;
										NIL			,;
										NIL			,;
										oPanel		,;
										NIL			,;
										.F.			,;
										NIL			,;
										.F.			 ;
									)

			oGdSZK	:= MsNewGetDados():New(	aObjSize[2,1]	,;
											aObjSize[2,2]	,;
											aObjSize[2,3]	,;
											aObjSize[2,4]	,;
											nOpcNewGd		,;
											bSZKLinOk		,;
											bSZKTudOk		,;
											""				,;
											aSZKGdAltera	,;
											0				,;
											999999			,; 
											NIL				,;
											NIL				,;
											bSZKGdDelOk		,;
											oPanel			,;
											aSZKHeader		,;
											aSZKCols		;
										 )

			AlignObject( oPanel , { oEnSZJ:oBox , oGdSZK:oBrowse } , 1 , NIL , { 60 } ); 

		ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
	
		CursorWait()
	
		IF( nOpcAlt == 1 )
	 		IF ( nOpc != 2 )
				MsAguarde(;
							{ ||;
									aSort( aSZKCols , NIL , NIL , bSZKSort ),;	//Sorteia as Informacoes do SZK para Comparacao Antes da Gravacao
                                    NDJA003Grava(;
													nOpc		,;	//Opcao de Acordo com aRotina
								 					nReg		,;	//Numero do Registro do Arquivo Pai ( SZJ )
								 					aSZJHeader	,;	//Campos do Arquivo Pai ( SZJ )
								 					aSZJVirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZJ )
								 					aSZJCols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZJ )
								 					aSvSZJCols	,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZJ )
								 					aSZKHeader	,;	//Campos do Arquivo Filho ( SZK )
								 					aSZKCols	,;	//Itens Atual do Arquivo Filho ( SZK )
								 					aSvSZKCols	,;	//Itens Anterior do Arquivo Filho ( SZK )
								 					aSZKVirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZK )
								 					aSZKRecnos	 ;	//Recnos do Arquivo Filho ( SZK )
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
	
	aAdd( aFreeLocks , { "SZJ" , aSZJRecnos , aSZJKeys } )
	aAdd( aFreeLocks , { "SZK" , aSZKRecnos , aSZKKeys } )
    StaticCall( NDJLIB003 , _FreeLocks , @aFreeLocks )

	RestArea( aArea )
	
	RestKeys( aSvKeys , .T. )
	
	CursorArrow()

Return( nOpcAlt )

/*/
	Function:	GdSZKSeek
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Efetuar Pesquisa na GetDados
    Sintaxe:    StaticCall(U_NDJA003,GdSZKSeek,oGdSZK)
/*/
Static Function GdSZKSeek( oGdSZK )

	Local aSvKeys		:= GetKeys()
	Local cProcName3	:= Upper( AllTrim( ProcName( 3 ) ) )
	Local cProcName5	:= Upper( AllTrim( ProcName( 5 ) ) )
	
	BEGIN SEQUENCE
	
        IF !( "NDJA003MNT" $ ( cProcName3 + cProcName5  ) )
			BREAK
		EndIF
		
		GdSeek( oGdSZK , OemToAnsi( STR0001 ) )	//"Pesquisar"
	
	END SEQUENCE	
	
	RestKeys( aSvKeys , .T. )

Return( NIL )

/*/
    Function:	NDJA003TEncOk
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Tudo Ok para a Enchoice
    Sintaxe:    StaticCall(U_NDJA003,NDJA003TEncOk,nOpc,oEnSZJ)
/*/
Static Function NDJA003TEncOk( nOpc , oEnSZJ )

	Local lTudoOk := .T.
	                
	IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
		lTudoOk := EnchoTudOk( oEnSZJ )
	EndIF
	
Return( lTudoOk )

/*/
	Function:	oGdSZKLinOk
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Linha OK da GetDados
    Sintaxe:    StaticCall(U_NDJA003,oGdSZKLinOk,oBrowse)
/*/
Static Function oGdSZKLinOk( oBrowse )

	Local lLinOk  		:= .T.

	Local aCposKey
	
	CursorWait()
	
		BEGIN SEQUENCE

			IF !( GdDeleted() )

				aCposKey := GdObrigat( aHeader )
				IF !( lLinOk := GdNoEmpty( aCposKey ) )
			    	BREAK
				EndIF

				aCposKey := GetArrUniqe( "SZK" )
				IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
					BREAK
				EndIF

				aCposKey := { "ZK_CGESTOR" }
				IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
					BREAK
				EndIF

			EndIF

		END SEQUENCE
		
		IF !( lLinOk )
			oBrowse:SetFocus()
		EndIF
	
		PutFileInEof( "SZK" )
	
	CursorArrow()
	
Return( lLinOk )

/*/
	Function:	oGdSZKTudOk
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Tudo Ok da GetDados
    Sintaxe:    StaticCall(U_NDJA003,oGdSZKTudOk,oBrowse)
/*/
Static Function oGdSZKTudOk( oBrowse )


	Local lTudoOk 	:= .T.

	Local nLoop
	Local nLoops

	CursorWait()
	
		BEGIN SEQUENCE

			Private n

			nLoops := Len( aCols )
			For nLoop := 1 To nLoops
				n := nLoop
				IF !( lTudoOk := oGdSZKLinOk( oBrowse ) )
					oBrowse:Refresh()
					BREAK
				EndIF
			Next nLoop 

			IF !( lTudoOk )
				oBrowse:Refresh()
				BREAK
			EndIF

		END SEQUENCE

	CursorArrow()

Return( lTudoOk  )

/*/
	Function:	SZKGdDelOk
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Validar a Delecao na GetDados
    Sintaxe:    StaticCall(U_NDJA003,SZKGdDelOk,cAlias,nRecno,nOpc,cXCODPRO,nSZKOrder)
/*/
Static Function SZKGdDelOk( cAlias , nRecno , nOpc , cXCODPRO , nSZKOrder )
         
	Local lDelOk 		:= .T.
	Local lStatusDel	:= .F.
	
	Static lFirstDelOk
	Static lLstDelOk
	
	DEFAULT lFirstDelOk	:= .T.
	DEFAULT lLstDelOk	:= .T.
	
	BEGIN SEQUENCE
	
		//Quando for Visualizacao ou Exclusao Abandona
		IF (;
				( nOpc == 2 ) .or. ;	//Visualizacao
				( nOpc == 5 );			//Exclusao
			)
			BREAK
		EndIF
	
		//Apenas se for a primeira vez
		IF !( lFirstDelOk )
			lFirstDelOk	:= .T.
			lDelOk 		:= lLstDelOk
			lLstDelOk	:= .T.
			BREAK
		EndIF
	
		lStatusDel	:= !( GdDeleted() ) //Inverte o Estado

		IF ( lStatusDel )	//Deletar
			IF !( nOpc == 3  )	//Quando nao for Inclusao
				IF !( lDelOk := .T. )
					CursorArrow()
					//"A chave a ser excluida est� sendo utilizada."
					//"At� que as refer�ncias a ela sejam eliminadas a mesma n�o pode ser excluida."
					MsgInfo( OemToAnsi( STR0008 + CRLF + STR0009 ) , cCadastro )
					lLstDelOk := lDelOk
	    			//Ja Passou pela funcao
					lFirstDelOk := .F.
	    			BREAK
	    		EndIF
	    	EndIF	
		Else				//Restaurar
	   		lLstDelOk := lDelOk
			//Ja Passou pela funcao
			lFirstDelOk := .F.
	   		BREAK
		EndIF
	
		//Ja Passou pela funcao
		lFirstDelOk := .F.
	
	END SEQUENCE
	
Return( lDelOk )

/*/
    Function:	NDJA003Grava
	Autor:		Marinaldo de Jesus
	Data:		28/01/2011
	Descricao:	Gravar as informacoes da SZK e SZJ
    Sintaxe:    StaticCall(U_NDJA003,NDJA003Grava)
/*/
Static Function NDJA003Grava(    nOpc        ,;    //Opcao de Acordo com aRotina
							 	nReg		,;	//Numero do Registro do Arquivo Pai ( SZJ )
							 	aSZJHeader	,;	//Campos do Arquivo Pai ( SZJ )
							 	aSZJVirtEn	,;	//Campos Virtuais do Arquivo Pai ( SZJ )
							 	aSZJCols	,;	//Conteudo Atual dos Campos do Arquivo Pai ( SZJ )
							 	aSvSZJCols	,;	//Conteudo Anterior dos Campos do Arquivo Pai ( SZJ )
							 	aSZKHeader	,;	//Campos do Arquivo Filho ( SZK )
							 	aSZKCols	,;	//Itens Atual do Arquivo Filho ( SZK )
							 	aSvSZKCols	,;	//Itens Anterior do Arquivo Filho ( SZK )
							 	aSZKVirtGd	,;	//Campos Virtuais do Arquivo Filho ( SZK )
							 	aSZKRecnos	 ;	//Recnos do Arquivo Filho ( SZK )
							  )

	Local aMestre		:= GdPutIStrMestre( 01 )
	Local aItens		:= {}

	Local cOpcao		:= IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )

	Local lAllModif		:= .F.
	Local lSZJModif		:= .F.
	Local lSZKModif		:= .F.
	Local lSZKDelet		:= .F.
	
	Local aSZKColDel
	Local aSZKRecDel
	Local nLoop
	Local nLoops
	Local nItens
	
	CursorWait()
	
		IF ( cOpcao <> "DELETE" )
			IF ( lSZKModif := !ArrayCompare( aSZKCols , aSvSZKCols ) )
				GdSuperDel( @aSZKHeader , @aSZKCols , NIL , .T. , GdGetBlock( "SZK" , @aSZKHeader , .F. ) ) 
				lSZKDelet := GdSplitDel( @aSZKHeader , @aSZKCols , @aSZKRecnos , @aSZKColDel , @aSZKRecDel  )
				IF ( lSZKDelet )
					SZK->( DelRecnos( "SZK" , @aSZKRecDel ) )
					lSZKDelet	:= .F.
				EndIF
				SZK->( DelRecnos( "SZK" , @aSZKRecnos ) )
			EndIF
		Else
			lSZKModif := .T.
			lSZJModif := .T.
		EndIF
	
		IF ( lSZKModif )

			aAdd( aItens , GdPutIStrItens() )
			nItens := Len( aItens )
			aItens[ nItens , 01 ] := "SZK"
			aItens[ nItens , 02 ] := {;
										{ "FILIAL" , xFilial( "SZK" , xFilial( "SZJ" ) ) },;
                                        { "XCODPRO" , StaticCall( NDJLIB001 , GetMemVar , "ZJ_XCODPRO" ) };
								 	 }
			aItens[ nItens , 03 ] := aClone( aSZKHeader )
			aItens[ nItens , 04 ] := aClone( aSZKCols   )
			aItens[ nItens , 05 ] := aClone( aSZKVirtGd )
			aItens[ nItens , 06 ] := aClone( aSZKRecnos )
	
		EndIF		
	
		IF !( lSZJModif )
			nLoops := Len( aSZJHeader )
			For nLoop := 1 To nLoops
                aSZJCols[ 01 , nLoop ] := StaticCall( NDJLIB001 , GetMemVar , aSZJHeader[ nLoop , 02 ] )
			Next nLoop
			lSZJModif := !( ArrayCompare( aSZJCols , aSvSZJCols ) )
		EndIF

	 	lAllModif := ( ( lSZKModif ) .or. ( lSZJModif ) )
	
		IF ( lAllModif )
	
			aMestre[ 01 , 01 ]	:= "SZJ"
			aMestre[ 01 , 02 ]	:= nReg
			aMestre[ 01 , 03 ]	:= lSZJModif
			aMestre[ 01 , 04 ]	:= aClone( aSZJHeader )
			aMestre[ 01 , 05 ]	:= aClone( aSZJVirtEn )
			aMestre[ 01 , 06 ]	:= {}
			aMestre[ 01 , 07 ]	:= aClone( aItens )
		
			GdPutInfoData( aMestre , cOpcao , .F. , .F. )
	
			While ( GetSX8Len() > nGetSX8Len )
				ConfirmSX8()
			End While

		EndIF

	CursorArrow()

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
           INNDJA003EXEC()
        NDJA003ALT()
        NDJA003DEL()
        NDJA003INC()
        NDJA003VIS()
		lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )