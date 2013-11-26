#INCLUDE "PAN-AMERICANA.CH"
/*/
	Programa:  	U_PanCTB01
	Autor:    	Marinaldo de Jesus
	Data:   	25/11/2009 
	Descrição:	Definir as Contas Contabeis que nao Poderao ser utilizadas em determinada Filial
*/
User Function PanCTB01()

	Local aArea				:= GetArea(Alias())
	Local aSvKeys			:= GetKeys()
	
	Local aAdvSize			:= {}
	Local aInfoAdvSize		:= {}
	Local aObjSize			:= {}
	Local aObjCoords		:= {}
	
	Local aNotCT1			:= {}
	
	Local aCols				:= {}
	Local aHeader			:= {}
	Local aFldCT1			:= {}
	Local aFldSP0			:= {}
	Local aColsTmp			:= {}
	Local aSvCols			:= {}
	
	Local aButtons			:= {}
	
	Local bSet15			:= { || NIL }
	Local bSet24			:= { || NIL }
	Local bGdLinOk			:= { |oBrowse| PanCtb01LinOk( oBrowse ) }
	Local bGdTudOk			:= { |oBrowse| PanCtb01TudOk( oBrowse ) }
	
	Local bDialogInit		:= { || NIL }
	
	Local bShowFile			:= { || NIL }
	
	Local cFileNotCT1		:= ( FILE_EXCLUI_CT1 )
	
	Local lOk				:= .F.
	
	Local nLoop				:= 0
	Local nLoops			:= 0
	
	Local nOpcNewGd			:= ( GD_INSERT + GD_UPDATE + GD_DELETE	)
	
	Local nUsado			:= 0
	
	Local oDlg				:= NIL
	Local oGetDados			:= NIL
	
	Private aGets
	Private aTela
	
	Private cCadastro		:= OemToAnsi( "Definir as Contas Contábeis que não poderão ser utilizadas na Filial: " + cFilAnt )
	
	/*
	 Poe o Ponteiro do Mouse em Estado de Espera				    
	      */
	CursorWait()
	
	Begin Sequence
	
		IF File( cFileNotCT1 )
			aNotCT1 := u_InPanVld("FileToArr", { cFileNotCT1 } )
		EndIF
	    
		/*
		 Monta o aHeader											    
		      */
		aFldCT1 := GdMontaHeader(;
									@nUsado			,;	//01 -> Por Referencia contera o numero de campos em Uso
									NIL				,;	//02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
									NIL				,;	//03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
									"CT1"			,;	//04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
									{ "CT1_CONTA" }	,;	//05 -> Opcional, Campos que nao Deverao constar no aHeader
									.F.				,;	//06 -> Opcional, Carregar Todos os Campos
									.F.		 		,;	//07 -> Nao Carrega os Campos Virtuais
									.F.				,;	//08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
									.T.				,;	//09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
									.F.				,;	//10 -> Verifica se Deve Checar se o campo eh usado
									.F.				,;	//11 -> Verifica se Deve Checar o nivel do usuario
									.F.				,;	//12 -> Utiliza Numeracao na GhostCol
									.F.				 ;	//13 -> Carrega os Campos de Usuario
						   )
	
		aAdd( aHeader , aFldCT1[1] )
	
		aHeader[ GdFieldPos( "CT1_CONTA"	, aHeader ) , __AHEADER_FIELD__ 		] := "CONTA"
		aHeader[ GdFieldPos( "CONTA" 		, aHeader ) , __AHEADER_TITLE__ 		] := "Grupo da Conta"
		aHeader[ GdFieldPos( "CONTA" 		, aHeader ) , __AHEADER_F3__ 			] := "CT1"
		aHeader[ GdFieldPos( "CONTA"		, aHeader ) , __AHEADER_VALID__			] := ""
	
		aFldSP0 := GdMontaHeader(;
									@nUsado			,;	//01 -> Por Referencia contera o numero de campos em Uso
									NIL				,;	//02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
									NIL				,;	//03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
									"SP0"			,;	//04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
									{;
										"P0_CODINI"	,;
										"P0_CODFIM"	;
									}				,;	//05 -> Opcional, Campos que nao Deverao constar no aHeader
									.F.				,;	//06 -> Opcional, Carregar Todos os Campos
									.F.		 		,;	//07 -> Nao Carrega os Campos Virtuais
									.T.				,;	//08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
									.T.				,;	//09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
									.F.				,;	//10 -> Verifica se Deve Checar se o campo eh usado
									.F.				,;	//11 -> Verifica se Deve Checar o nivel do usuario
									.F.				,;	//12 -> Utiliza Numeracao na GhostCol
									.F.				 ;	//13 -> Carrega os Campos de Usuario
						   )
	
		aAdd( aHeader , aFldSP0[1] )
		aAdd( aHeader , aFldSP0[2] ) 
		aAdd( aHeader , aFldSP0[3] )
	
		aHeader[ GdFieldPos( "P0_CODINI"	, aHeader ) , __AHEADER_FIELD__ 		] := "GRPINI"
		aHeader[ GdFieldPos( "P0_CODFIM"	, aHeader ) , __AHEADER_FIELD__ 		] := "GRPFIM"
		aHeader[ GdFieldPos( "GRPINI" 		, aHeader ) , __AHEADER_TITLE__ 		] := "Inicio do Grupo"
		aHeader[ GdFieldPos( "GRPFIM" 		, aHeader ) , __AHEADER_TITLE__ 		] := "Final do Grupo"    
		aHeader[ GdFieldPos( "GRPINI"		, aHeader ) , __AHEADER_VALID__			] := "Positivo().and.IF(GdFieldGet('GRPFIM')>0,(GetMemVar('GRPINI')<=GdFieldGet('GRPFIM')),.T.)"
		aHeader[ GdFieldPos( "GRPFIM"		, aHeader ) , __AHEADER_VALID__			] := "Positivo().and.(GetMemVar('GRPFIM')>=GdFieldGet('GRPINI'))"
	
		/*
		 Cria as Variaveis de Memoria								    
		      */
		nLoops := Len( aHeader )
		For nLoop := 1	To nLoops
			SetMemVar( aHeader[ nLoop , __AHEADER_FIELD__ ] , GetValType( aHeader[ nLoop , __AHEADER_TYPE__ ] , aHeader[ nLoop , __AHEADER_WIDTH__ ] ) , .T. )
		Next nLoop
	
		/*
		 Monta aCols												    
		      */
		nLoops := Len( aNotCT1 )
		For nLoop := 1 To nLoops
			aColsTmp := GdRmkaCols( aHeader , .F. , .T. , .F. )
			aAdd( aCols , aColsTmp[1] )
			GdFieldPut( "CONTA"   , PadR( aNotCT1[ nLoop ] , GetSx3Cache( "CT1_CONTA" , "X3_TAMANHO" ) ) , nLoop , aHeader , aCols )
			GdFieldPut( "GRPINI"  , 1 , nLoop , aHeader , aCols )
			GdFieldPut( "GRPFIM"  , Len( aNotCT1[ nLoop ] ) , nLoop , aHeader , aCols )
		Next nLoop
	
		/*
		 Salva aCols para comparacao antes da Gravacao				    
		      */
		aSvCols := aClone( aCols )
	
		/*
		 Monta as Dimensoes dos Objetos         					    
		      */
		aAdvSize		:= MsAdvSize( NIL , .F. )
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
		aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
	
		/*
		 Define o Botao de Pesquisa na GetDados					    
		      */
		bShowFile := { ||	ShowFile( oGetDados , cFileNotCT1 ),;
							SetKey( VK_F4 , bShowFile );
				   }
		aAdd(;
				aButtons	,;
								{;
									"PMSPESQ",;
		   							bShowFile,;
		       	   					OemToAnsi( "Mostrar Arquivo" + "...<F4>"  ),;
		       	   					OemToAnsi( "Mostrar Arquivo" );
		           				};
		     )
	
		/*
		 Define o Bloco para a Tecla <CTRL-O> 						    
		      */
		bSet15		:= { || IF( oGetDados:TudoOk(),;
								 (;
								 	 GetKeys() ,;
								 	 lOk := .T.,;
								 	 aCols := oGetDados:aCols ,;
								 	 oDlg:End(); 
								  ),;
								  .F.;
							   );
						 }
	
		/*
		 Define o Bloco para a Teclas <CTRL-X>     	   			    
		      */
		bSet24		:= { || ( GetKeys() , lOk := .F. , oDlg:End() ) }
	
		/*
		 Define o Bloco para o Init do Dialog						    
		      */
		bDialogInit := { ||;
								EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
								SetKey( VK_F4 , bShowFile  );
						}
	
		/*
		 Monta o Dialogo Principal para a Manutencao das Formulas	    
		      */
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Definição das Contas Contábeis não utilizadas na Filial: " + cFilAnt ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
	
			/*
			 Monta o Objeto GetDados									    
			      */
	    	oGetDados := MsNewGetDados():New(	aObjSize[1,1]	,;	//01 -> nTop		Linha Inicial
												aObjSize[1,2]	,;	//02 -> nLelft		Coluna Inicial
												aObjSize[1,3]	,;	//03 -> nBottom		Linha Final	
												aObjSize[1,4]	,;	//04 -> nRight      Coluna Final
												nOpcNewGd		,;	//05 -> nStyle:		Controle do que podera ser realizado na GetDado
												bGdLinOk		,;	//06 -> ulinhaOK:	Funcao ou CodeBlock para validar a edicao da linha
												bGdTudOk		,;	//07 -> uTudoOK: 	Funcao ou CodeBlock para validar todas os registros da GetDados
												NIL				,;	//08 -> cIniCpos:	Campo para Numeracao Automatica
												NIL				,;	//09 -> aAlter: 	Array unidimensional com os campos Alteraveis
												0				,;	//10 -> nfreeze:	Numero de Colunas para o Freeze
												NIL				,; 	//11 -> nMax:		Numero Maximo de Registros na GetDados	
												NIL				,;	//12 -> cFieldOK:	?
												NIL				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
												{ || .T. }		,;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
												oDlg			,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
												aHeader			,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
												aCols			 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
										 	)//...
	
		ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
		
		IF (;
				( lOk );
				.and.;
				!( ArrayCompare( aSvCols , aCols ) );
			)	
			WhileYesNoWait(;
								{ || MayIUseCode( "grv"+cFileNotCT1 ) }							,;	//Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
								3																,;	//Tempo de Espera para a ProcWaiting()
								.T.									   							,;	//Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
								"não Foi Possível Salvar as alterações."						,;	//Mensagem de Corpo para a MsgInfo
								"Atenção!!!"													,;	//Titulo para a MsgInfo
								"O arquivo está bloqueado por Outro Usuário. Deseja Aguardar?"	,;	//Mensagem de Corpo para a MsgYesNo
								"Atenção!!!!"													,;	//Titulo para a MsgYesNo
								"Aguardando Desbloqueio do arquivo..."							,;	//Mensagem de corpo para a ProcWaiting
								"Aguarde..." 													;	//Titulo para a ProcWaiting
							)
			MsgRun( OemToAnsi( "Aguarde..." ) , OemToAnsi( "Salvando alterações" ) , { || PANCtb01Grv( aHeader , aCols , cFileNotCT1 , .T. ) } )
			Leave1Code( "grv"+cFileNotCT1 )
		EndIF
	
	End Sequence
	
	/*/
 
	 Coloca o Ponteiro do Mouse em Estado de Espera			    
	      */
	CursorWait()
	
	/*/
 
	 Restaura os Dados de Entrada								    
	      */
	RestArea( aArea )
	
	/*/
 
	 Restaura as Teclas de Atalho                                   
	      */
	RestKeys( aSvKeys , .T. )
	
	/*/
 
	 Restaura o Ponteiro do Mouse 								    
	      */
	CursorArrow()
	
Return( NIL )

/*/
	Função:		PANCtb01Grv
	Autor:     	Marinaldo de Jesus
	Data:   	25/11/2009 
	Descrição:	Gravar as Informacoes em Arquivo							 
*/
Static Function PANCtb01Grv( aHeader , aCols , cFileNotCT1 , lGrava )

	Local cDetGrv		:= ""
	Local cMsgException	:= ""
	
	Local lGrvOk		:= .F.
	
	Local nLoop
	Local nLoops
	Local nError
	Local nConta
	Local nGrpIni
	Local nGrpFim
	
	Local oException
	
	TRYEXCEPTION
	
		GdSplitDel( aHeader , aCols , {} )
	
		nConta		:= GdFieldPos( "CONTA" , aHeader )
		
        aSort( aCols , NIL , NIL , { |x,y| x[nConta] < y[nConta] } )
	
		nLoops := Len( aCols )
		For nLoop := 1 To nLoops
			nGrpIni		:= Max( GdFieldGet( "GRPINI" , nLoop , .F. , aHeader , aCols ) , 1 )
			nGrpFim     := GdFieldGet( "GRPFIM" , nLoop , .F. , aHeader , aCols )
			cDetGrv 	+= SubStr( GdFieldGet( "CONTA"  , nLoop , .F. , aHeader , aCols ) , nGrpIni ,  ( nGrpFim - nGrpIni ) + 1 )
			cDetGrv 	+= CRLF 
		Next nLoop
	
		IF File( cFileNotCT1 )
			lGrvOk := FileErase( cFileNotCT1 , @nError )
			IF !( lGrvOk )
				cMsgException += "File Error: " + AllTrim( Str( nError ) )
				cMsgException += CRLF
				cMsgException += "não foi Possível regravar o o arquivo: "
				cMsgException += CRLF
				cMsgException += cFileNotCT1
				cMsgException += CRLF
				cMsgException += "Entre em contato com o Administrador do Sistema!"
			EndIF	
		EndIF
	
		DEFAULT lGrava	:= .T.
		IF ( lGrava )

			MemoWrite( cFileNotCT1 , cDetGrv )
		
			lGrvOk := File( cFileNotCT1 )
			IF !( lGrvOk )
				cMsgException += "File Error: " + AllTrim( Str( nError ) )
				cMsgException += CRLF
				cMsgException += "não foi Possível regravar o o arquivo: "
				cMsgException += CRLF
				cMsgException += cFileNotCT1
				cMsgException += CRLF
				cMsgException += "Entre em contato com o Administrador do Sistema!"
			EndIF
		
		EndIF
			
	CATCHEXCEPTION USING oException
	
		Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "ERRO DE GRAVAÇÃO:" + CRLF + CRLF + oException:Description ) , 1 , 0 )
	
	ENDEXCEPTION

Return( IF( lGrava , lGrvOk , cDetGrv ) )

/*
	Função:    	ShowFile
	Autor:     	Marinaldo de Jesus
	Data:   	28/11/2009 
	Descrição:	Mostrar o Conteudo do Arquivo

*/
Static Function ShowFile( oGetDados , cFileShow )

	Local aAdvSize
	Local aSvKeys
	Local aObjSize
	Local aObjCoords
	Local aInfoAdvSize
	
	Local bSet15
	Local bSet24
	Local bDialogInit

	Local cMemoEdit
	Local cTitCompl

	Local oDlg
	Local oFont
	Local oMemoEdit

	Begin Sequence
	
		cMemoEdit := PANCtb01Grv( oGetDados:aHeader , oGetDados:aCols , cFileShow , .F. )
	
		/*/
	 
		 Monta as Dimensoes dos Objetos             				    
		      */
		aAdvSize		:= MsAdvSize( .T. , .T. )
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aObjCoords		:= { { 0 , 0 , .T. , .T. } }
		aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )
	
		/*/
	 
		 Salva as Teclas de Atalho                  				    
		      */
		aSvKeys := GetKeys()
	
		/*/
	 
		 Define o Bloco para a Tecla <CTRL-O>						    
		      */
		bSet15	:= { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
	
		/*/
	 
		 Define o Bloco para a Tecla <CTRL-X>     	   				    
		      */
		bSet24	:= { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
	
		/*/
	 
		 Define o Bloco para o INIT do Dialog						    
		      */
		bDialogInit := { ||  EnchoiceBar( @oDlg , @bSet15 , @bSet24  ) }
	
		/*/
	 
		 Carrega o Complemento do Titulo          	   				    
		      */
		cTitCompl := cFileShow
	
		DEFINE FONT oFont NAME "Arial" SIZE 0,-15 //BOLD
		DEFINE MSDIALOG oDlg TITLE cCadastro + OemToAnsi( " :: " + cTitCompl ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL 
				
			@ aObjSize[1,1],aObjSize[1,2] GET oMemoEdit VAR cMemoEdit MEMO SIZE aObjSize[1,4],(aObjSize[1,3]-15) FONT oFont OF oDlg PIXEL WHEN ( .T. )
			oMemoEdit:lReadOnly := .T.
			oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
			
		ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
		RestKeys( aSvKeys , .T. )
	
	End Sequence

Return( NIL )

/*/
	Função:   	PanCtb01LinOk Autor:     
	Autor:		Marinaldo de Jesus     
	Data:   	25/11/2009 
	Descrição:	Validar o TudoOk da GetDados								 
*/
Static Function PanCtb01LinOk( oBrowse )

	Local lLinOk	:= .T.
	Local aCposKey	:= { "CONTA" }
	
	Begin Sequence

		IF !( GdDeleted() )
	
			IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
				Break
			EndIF
		
		EndIF

	End Sequence

Return( lLinOk  )

/*/

	Função:    PanCtb01LinOk
	Autor:     Marinaldo de Jesus
	Data:	   25/11/2009 
	Descrição: Validar o TudoOk da GetDados								 
*/
Static Function PanCtb01TudOk( oBrowse )

	Local lTudOk	:= .T.
	
	Local nLoop
	Local nLoops	:= Len( aCols )

	    /*
			Percorre Todas as Linhas para verificar se Esta Tudo OK
		*/
		For nLoop := 1 To nLoops
			n := nLoop
			IF !( lTudoOk := PanCtb01LinOk( oBrowse ) )
				oBrowse:Refresh()
				Break
			EndIF
		Next nLoop 

Return( lTudOk )