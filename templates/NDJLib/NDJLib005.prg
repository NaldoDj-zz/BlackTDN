#INCLUDE "NDJ.CH"
/*/
	Funcao:		Modelo3
	Autor:		Marinaldo de Jesus
	Data:		05/01/2011
    Sintaxe:    StaticCall( NDJLIB005 , Modelo3 , <...> )
/*/
Static Function Modelo3(;
					   		cTitulo			,;	//01 -> Titulo da Janela
					   		cAliasEnchoice	,;	//02 -> Alias da Enchoice
					   		uUndefinedPar	,;	//03 -> Nao Usado ( Para Compatibilizar com a Modelo3 Padrao equivalente a cAlias2 )
					   		aFieldsEnchoice	,;	//04 -> Array com campos da Enchoice
					   		uGdLinhaOk		,;	//05 -> Linha OK na GetDados ( Public Function or CodeBlock )
					   		uGdTudoOk		,;	//06 -> Tudo Ok na GetDados  ( Public Function or CodeBlock )
					   		nOpcEnchoice	,;	//07 -> nOpc da Enchoice
					   		nOpcGetDados	,;	//08 -> nOpc da GetDados
					   		cFieldOk		,;	//09 -> Validacao para todos os campos da GetDados
					   		lVirtual		,;	//10 -> Permite visualizar campos virtuais na enchoice
					   		nLinhas			,;	//11 -> Numero Maximo de linhas na getdados	
					   		aAlteraEnchoice	,;	//12 -> Array com campos da Enchoice Alteraveis
					   		nFreeze			,;	//13 -> Congelamento das colunas na GetDados
					   		oEnchoice		,;	//14 -> Objeto Enchoiche ( MsMGet():New() )
					   		oGetDados		,;	//15 -> Objeto GetDados ( MsNewGetDados:New() )
					   		aAlteraGetDados ,;	//16 -> Array com campos da GetDados Alteraveis
					   		uGdDelOk		,;	//17 -> Validar Delecao de Item na GetDados ( Public Function or CodeBlock )
							aGdHeader	 	,;	//18 -> Array com os Campos da GetDados
							aGdCols			,;	//19 -> Array com os Itens da GetDados
							cGdAutFieldNum	,;	//20 -> Campo para Numeracao Automatica na GetDados ( Sample: "+ZF_SEQ" )
					   		aEncValid		,;	//21 -> Array com campos que devem ser Validados na Enchoice
					   		aEncNotValid	,;	//22 -> Array com campos que nao devem ser Validados na Enchoice
					   		aButtons		,;	//23 -> Array com os Botoes para a EnchoiceBar
					   		lDlgPadSiga		,;	//24 -> Dialog Padrao Siga
					   		oDlg			,;	//25 -> Objeto Dialog
							aObjSize		,;  //26 -> Coordenadas Para os Objetos Enchoice e GetDados
					   		cTudoOk			,;	//27 -> String Com Funcao para o TudoOk da Enchoice
					   		bTudoOk			,;	//28 -> Bloco para Validar Todas as Informacoes da GetDados e da Enchoice
							bSet15			,;	//29 -> Bloco para Acao do Botao OK
							bSet24			,;	//30 -> Bloco para Acao do Botao Cancel
							bMsDialogInit	,;	//31 -> Bloco para a Inicializacao do Dialog
							cAtela			,;	//32 ->	cAtela ( Enchoice )
							lNoFolder		,;	//33 -> lNoFolder ( Enhcoice )
							lColumn			,;	//34 -> Se os Dados ficarao em apenas uma coluna ( Enchoice )
							lDisableF3		,;	//35 -> Desabilitar Consulta via Tecla F3 ( Enchoice )
							nColMens		,;	//36 -> nColMens ( Enchoice )
							cMensagem		,;	//37 -> cMensagem ( Enchoice )
							uSuperDel		 ;  //38 -> Funcao ou CodeBlock para executar SuperDel na GetDados
						)	//-> lRet ( .T. Confirma, .F. Abandona )

Local aSvKeys			:= GetKeys()
Local bModelo3			:= { || Modelo3() }

Local aAdvSize
Local aInfoAdvSize
Local aObjCoords

Local lRet
Local lActivate			:= !( ValType( "oDlg" ) == "O" )
Local lObjSize			:= !( ValType( aObjSize ) == "A" )

Local nOpca				:= 0
Local nReg				:= ( cAliasEnchoice )->( Recno() )

Private aTela
Private aGets

Private Altera			:= .T.
Private Inclui			:= .T.
Private lRefresh		:= .T.

DEFAULT nOpcEnchoice	:= 3
DEFAULT nOpcGetDados	:= 3
DEFAULT lVirtual		:= .T.
DEFAULT nLinhas			:= 9999
DEFAULT lDlgPadSiga		:= .F.

IF (;
		( lObjSize );
		.or.;
		( lActivate );
	)	
	aAdvSize		:= MsAdvSize( NIL , lDlgPadSiga )
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
EndIF	

IF ( lActivate )
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
EndIF	

IF ( lObjSize )
	aObjCoords		:= Array( 2 )
	aObjCoords[1]	:= { 000 , 035 , .T. , .F. }
	aObjCoords[2]	:= { 000 , 000 , .T. , .T. }
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
EndIF

	oEnchoice 		:= MsMGet():New(;
										cAliasEnchoice	,;	//01 -> cAlias		-> Alias da Tabela
										nReg			,;	//02 -> nReg		-> Registro ( Recno() )
										nOpcEnchoice	,;	//03 -> nOpc		-> Opcao retornada pelo aRotina
										NIL				,;	//04 -> aCra
										NIL				,;	//05 -> cLetras
										NIL				,;	//06 -> cTexto
										aFieldsEnchoice	,;	//07 -> aAcho 		-> Array de Campos que aparecerao na Enchoice
										aObjSize[1]		,;	//08 -> aPos		-> Array com as Coordenadas da Enchoice
										aAlteraEnchoice	,;	//09 -> aCpos		-> Array de Campos Alteraveis
										3				,;	//10 -> nModelo
										nColMens		,;	//11 ->	nColMens
										cMensagem		,;	//12 ->	cMensagem
										cTudoOk			,;	//13 ->	cTudoOk		-> String Com Funcao para o TudoOk da Enchoice
										oDlg			,;	//14 -> oWnd		-> Objeto Dialog para a Enchoice
										lDisableF3		,;	//15 -> lF3			-> Desabilitar Consulta via Tecla F3
										lVirtual		,;	//16 ->	lMemoria	-> Se os Dados são de Memoria ( DEFAULT ) ou Arquivo
										lColumn			,;	//17 ->	lColumn		-> Se os Dados ficarao em apenas uma coluna
										cAtela			,;	//18 ->	cAtela
										lNoFolder		 ;	//19 ->	lNoFolder
									)

	oGetDados		:=	MsNewGetDados():New(;
												aObjSize[2,1]			,;	//01 -> nTop		Linha Inicial
					  							aObjSize[2,2]			,;	//02 -> nLelft		Coluna Inicial
					  							aObjSize[2,3]			,;	//03 -> nBottom		Linha Final	
					  							aObjSize[2,4]			,;	//04 -> nRight      Coluna Final
					  							nOpcGetDados			,;	//05 -> nStyle:		Controle do que podera ser realizado na GetDado
					  							uGdLinhaOk			 	,;	//06 -> ulinhaOK:	Funcao ou CodeBlock para validar a edicao da linha
					  							uGdTudoOk				,;	//07 -> uTudoOK: 	Funcao ou CodeBlock para validar todas os registros da GetDados
					  							cGdAutFieldNum			,;	//08 -> cIniCpos:	Campo para Numeracao Automatica
					  							aAlteraGetDados			,;	//09 -> aAlter: 	Array unidimensional com os campos Alteraveis
					  							nFreeze					,;	//10 -> nfreeze:	Numero de Colunas para o Freeze
					  							nLinhas					,;	//11 -> nMax:		Numero Maximo de Registros na GetDados	
												cFieldOk				,;	//12 -> cFieldOK:	
												uSuperDel				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
												uGdDelOk				,;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
												oDlg					,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
												aGdHeader	 		 	,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
												aGdCols					 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
										   )

	DEFAULT bTudoOk			:= { || EnchoTudOk( @oEnchoice , @aEncValid , @aEncNotValid ) .and. oGetDados:TudoOk() }
	DEFAULT bSet15			:= { || IF( Eval( bTudoOk ) , ( nOpca := 1 , oDlg:End() , RestKeys( aSvKeys , .T. ) ) , nOpca := 0 ) }
	DEFAULT bSet24			:= { || nOpca := 0 , oDlg:End() , RestKeys( aSvKeys , .T. ) }

	DEFAULT bMsDialogInit	:= { || EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
									AlignObject( oDlg , { oEnchoice:oBox , oGetDados:oBrowse } , 1 , NIL , { 110 } ); 
					   		   }

IF ( lActivate )
	ACTIVATE MSDIALOG oDlg ON INIT Eval( bMsDialogInit ) CENTERED
EndIF
RestKeys( aSvKeys , .T. )

lRet := ( nOpca == 1 )

Return( lRet )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )