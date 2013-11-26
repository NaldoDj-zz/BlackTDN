#INCLUDE "PAN-AMERICANA.CH"
/*/
	Programa:	U_PanCTB02
	Autor:		Marinaldo de Jesus
	Data:		25/11/2009
	Descrição:	Definir os Centros de Custo que nao Poderao ser utilizados em determinada Filial
*/
User Function PanCTB02()

	Local aArea				:= GetArea(Alias())
	Local aSvKeys			:= GetKeys()
	
	Local aAdvSize			:= {}
	Local aInfoAdvSize		:= {}
	Local aObjSize			:= {}
	Local aObjCoords		:= {}
	
	Local aNotFields		:= { "CTT_CUSTO" , "CTT_DESC01" }
	Local aNotCTT			:= {}
	
	Local aCols				:= {}
	Local aHeader			:= {}
	Local aColsTmp			:= {}
	Local aSvCols			:= {}
	
	Local aButtons			:= {}
	
	Local bSet15			:= { || NIL }
	Local bSet24			:= { || NIL }
	Local bGdLinOk			:= { |oBrowse| PanCtb02LinOk( oBrowse ) }
	Local bGdTudOk			:= { |oBrowse| PanCtb02TudOk( oBrowse ) }

	Local bDialogInit		:= { || NIL }
	
	Local bShowFile			:= { || NIL }
	Local bCCDeAte			:= { || NIL }

	Local cCusto
	Local cCTTCustoVld
	Local cxFilialCTT		:= xFilial("CTT")
	Local cFileNotCTT		:= ( FILE_EXCLUI_CTT )
	
	Local lOk				:= .F.
	
	Local nLoop				:= 0
	Local nLoops			:= 0
	Local nCTTOrder			:= RetOrder( "CTT" , "CTT_FILIAL+CTT_CUSTO" )
	
	Local nOpcNewGd			:= ( GD_INSERT + GD_UPDATE + GD_DELETE	)
	
	Local nUsado			:= 0
	
	Local oDlg				:= NIL
	Local oGetDados			:= NIL
	
	Private aGets
	Private aTela
	
	Private cCadastro		:= OemToAnsi( "Definir os Centros de Custo que nç¡¯ Poderã¯ ser utilizados na Filial : " + cFilAnt ) 
	
	/*/
		Poe o Ponteiro do Mouse em Estado de Espera
	*/
	CursorWait()
	
	Begin Sequence
	
		IF File( cFileNotCTT )
			aNotCTT := u_InPanVld("FileToArr", { cFileNotCTT } )
		EndIF
	    
		/*
			Monta o aHeader
		*/
		aHeader := GdMontaHeader(;
									@nUsado			,;	//01 -> Por Referencia contera o numero de campos em Uso
									NIL				,;	//02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
									NIL				,;	//03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
									"CTT"			,;	//04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
									aNotFields		,;	//05 -> Opcional, Campos que nao Deverao constar no aHeader
									.F.				,;	//06 -> Opcional, Carregar Todos os Campos
									.F.		 		,;	//07 -> Nao Carrega os Campos Virtuais
									.T.				,;	//08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
									.T.				,;	//09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
									.F.				,;	//10 -> Verifica se Deve Checar se o campo eh usado
									.F.				,;	//11 -> Verifica se Deve Checar o nivel do usuario
									.F.				,;	//12 -> Utiliza Numeracao na GhostCol
									.F.				 ;	//13 -> Carrega os Campos de Usuario
						   )
	
		
		cCTTCustoVld := "(GdFieldPut('CTT_DESC01',PosAlias('CTT',GetMemVar('CTT_CUSTO'),'"+cxFilialCTT+"','CTT_DESC01',"+AllTrim(Str(nCTTOrder))+",.F.)),.T.)"
		
		aHeader[ GdFieldPos( "CTT_CUSTO"	, aHeader ) , __AHEADER_VALID__	  ] := cCTTCustoVld
		aHeader[ GdFieldPos( "CTT_CUSTO"	, aHeader ) , __AHEADER_F3__	  ] := "CTT"
		aHeader[ GdFieldPos( "CTT_DESC01" 	, aHeader ) , __AHEADER_VISUAL__ ]	:= "V"
	
		/*
			Cria as Variaveis de Memoria
		*/
		nLoops := Len( aHeader )
		For nLoop := 1	To nLoops
			SetMemVar( aHeader[ nLoop , __AHEADER_FIELD__ ] , GetValType( aHeader[ nLoop , __AHEADER_TYPE__ ] , aHeader[ nLoop , __AHEADER_WIDTH__ ] ) , .T. )
		Next nLoop
	
		/*/
			Monta aCols
		*/
		nLoops := Len( aNotCTT )
		For nLoop := 1 To nLoops
			aColsTmp := GdRmkaCols( aHeader , .F. , .T. , .F. )
			aAdd( aCols , aColsTmp[1] )
			cCusto	:= PadR( aNotCTT[ nLoop ] , GetSx3Cache( "CTT_CUSTO" , "X3_TAMANHO" ) )
			GdFieldPut( "CTT_CUSTO"   , cCusto , nLoop , aHeader , aCols )
			GdFieldPut( "CTT_DESC01"  , PosAlias( "CTT" , cCusto , cxFilialCTT , "CTT_DESC01" , nCTTOrder , .F. ) , nLoop , aHeader , aCols )
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
		bShowFile := { ||	ShowFile( oGetDados , cFileNotCTT ),;
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

		bCCDeAte := { || CCDeAte( oGetDados ),;
						 SetKey( VK_F5 , bCCDeAte );
					}	 

		aAdd(;
				aButtons	,;
								{;
									"DESTINOS",;
		   							bCCDeAte,;
		       	   					OemToAnsi( "CC De/Até...<F5>"  ),;
		       	   					OemToAnsi( "CC De/Até");
		           				};
		     )
	
		/*
			Define o Bloco para a Tecla <CTRL-O>
		*/
		bSet15		:= { ||;
							 IF( oGetDados:TudoOk(),;
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
								SetKey( VK_F4 , bShowFile  ),;
								SetKey( VK_F5 , bCCDeAte );
						}
	
		/*
			Monta o Dialogo Principal para a Manutencao das Formulas
		*/
		DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Definição das Contas Contábeis Não utilizadas na Filial: " + cFilAnt ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
	
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
								{ || MayIUseCode( "grv"+cFileNotCTT ) }							,;	//Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
								3																,;	//Tempo de Espera para a ProcWaiting()
								.T.									   							,;	//Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
								"Não Foi Possível Salvar as alterações."						,;	//Mensagem de Corpo para a MsgInfo
								"Atenção!!!"													,;	//Titulo para a MsgInfo
								"O arquivo está bloqueado por Outro usuário. Deseja Aguardar?"	,;	//Mensagem de Corpo para a MsgYesNo
								"Atenção!!!!"													,;	//Titulo para a MsgYesNo
								"Aguardando Desbloqueio do arquivo..."							,;	//Mensagem de corpo para a ProcWaiting
								"Aguarde..." 													;	//Titulo para a ProcWaiting
							)
			MsgRun( OemToAnsi( "Aguarde..." ) , OemToAnsi( "Salvando alterações" ) , { || PANCTB02Grv( aHeader , aCols , cFileNotCTT , .T. ) } )
			Leave1Code( "grv"+cFileNotCTT )
		EndIF
	
	End Sequence
	
	/*
		Coloca o Ponteiro do Mouse em Estado de Espera
	*/
	CursorWait()
	
	/*
		Restaura os Dados de Entrada
	*/
	RestArea( aArea )
	
	/*
		Restaura as Teclas de Atalho
	*/	
	RestKeys( aSvKeys , .T. )
	
	/*
		Restaura o Ponteiro do Mouse
	*/
	CursorArrow()

Return( NIL )

/*/

	Função: 	PANCTB02Grv
	Autor:		Marinaldo de Jesus
	Data:		25/11/2009
	Descrição:	Gravar as Informacoes em Arquivo
*/
Static Function PANCTB02Grv( aHeader , aCols , cFileNotCTT , lGrava )

	Local cDetGrv		:= ""
	Local cMsgException	:= ""
	
	Local lGrvOk		:= .F.
	
	Local nLoop
	Local nLoops
	Local nError
	Local nCttCusto
	
	Local oException
	
	TRYEXCEPTION
	
		GdSplitDel( aHeader , aCols , {} )
	
		nCttCusto		:= GdFieldPos( "CTT_CUSTO" , aHeader )
		
        aSort( aCols , NIL , NIL , { |x,y| x[nCttCusto] < y[nCttCusto] } )
	
		nLoops := Len( aCols )
		For nLoop := 1 To nLoops
			cDetGrv 	+= GdFieldGet( "CTT_CUSTO" , nLoop , .F. , aHeader , aCols )
			cDetGrv 	+= CRLF 
		Next nLoop

		IF ( lGrava )
	
			IF File( cFileNotCTT )
				lGrvOk := FileErase( cFileNotCTT , @nError )
				IF !( lGrvOk )
					cMsgException += "File Error: " + AllTrim( Str( nError ) )
					cMsgException += CRLF
					cMsgException += "Não foi Possível regravar o o arquivo: "
					cMsgException += CRLF
					cMsgException += cFileNotCTT
					cMsgException += CRLF
					cMsgException += "Entre em contato com o Administrador do Sistema!"
				EndIF	
			EndIF
		
			MemoWrite( cFileNotCTT , cDetGrv )
		
			lGrvOk := File( cFileNotCTT )
			IF !( lGrvOk )
				cMsgException += "File Error: " + AllTrim( Str( nError ) )
				cMsgException += CRLF
				cMsgException += "Não foi Possível regravar o o arquivo: "
				cMsgException += CRLF
				cMsgException += cFileNotCTT
				cMsgException += CRLF
				cMsgException += "Entre em contato com o Administrador do Sistema!"
			EndIF
		
		EndIF
			
	CATCHEXCEPTION USING oException
	
		Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "ERRO DE GRAVAÇÃO:" + CRLF + CRLF + oException:Description ) , 1 , 0 )
	
	ENDEXCEPTION

Return( IF( lGrava , lGrvOk , cDetGrv ) )

/*/
	Função: 	ShowFile
	Autor:		Marinaldo de Jesus
	Data:		28/11/2009
	Descrição:  Mostrar o Conteudo do Arquivo
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
	
		cMemoEdit := PANCtb02Grv( oGetDados:aHeader , oGetDados:aCols , cFileShow , .F. )
	
		/*
			Monta as Dimensoes dos Objetos
		*/
		aAdvSize		:= MsAdvSize( .T. , .T. )
		aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
		aObjCoords		:= { { 0 , 0 , .T. , .T. } }
		aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )
	
		/*
			 Salva as Teclas de Atalho
		*/
		aSvKeys := GetKeys()
	
		/*
			 Define o Bloco para a Tecla <CTRL-O>
		*/
		bSet15	:= { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
	
		/*
			 Define o Bloco para a Tecla <CTRL-X>
		*/
		bSet24	:= { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
	
		/*
			 Define o Bloco para o INIT do Dialog
		*/
		bDialogInit := { ||  EnchoiceBar( @oDlg , @bSet15 , @bSet24  ) }
	
		/*
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
	
	Função: 	CCDeAte
	Auto:		Marinaldo de Jesus
	Data:		25/11/2009
	Descrição:	Informar os Centros de Custo De/Ate
*/
Static Function CCDeAte( oGetDados , lProcess )

	Local aArea			:= GetArea()
	Local aAreaCTT		:= CTT->( GetArea() )
	Local aColsTmp

	Local cCCDe
	Local cCCAte
	Local cCusto
	Local cDesc01
	Local cFilCTT
	
	Local nCTTCusto
	Local nOrderCTT

	Local lPergunte

	Local oException

	DEFAULT lProcess := .F.

	BEGIN SEQUENCE

		IF !( lProcess )

			lPergunte := ( Pergunte( "U_PANCTB02" , .T. ) )
			
			IF !( lPergunte )
				Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( cCancel ) , 1 , 0 )
				Break
			EndIF

			Processa( { || CCDeAte( oGetDados , .T. )  }	)

			Break

		EndIF
	
		TRYEXCEPTION
	
			cFilCTT			:= xFilial( "CTT" )
			nOrderCTT		:= RetOrder( "CTT" , "CTT_FILIAL+CTT_CUSTO" )
	
			nCTTCusto := GdFieldPos( "CTT_CUSTO" , oGetDados:aHeader )
			
			CTT->( dbSetOrder( nOrderCTT ) )
	
			cCCDe 	:= MV_PAR01
			cCCAte	:= MV_PAR02
		
			CTT->( dbSeek( cFilCTT + cCCDe ) )

			ProcRegua(0)
			
			While CTT->(;
							 !Eof();
							 .and.;
							 (;
							 	( cFilCTT == CTT_FILIAL );
							 	.and.;
							 	(; 
							 			( CTT_CUSTO >= cCCDe );
							 			.and.;
							 			( CTT_CUSTO <= cCCAte );
						 	 	);
						 	  );
						 )	  	 
	
				IncProc()
				
				cCusto	:= CTT->CTT_CUSTO
	
	            IF ( aScan( oGetDados:aCols , { |x| x[nCTTCusto] == cCusto } ) == 0 )
	
					aColsTmp := GdRmkaCols( oGetDados:aHeader , .F. , .T. , .F. )
					
					cDesc01 := CTT->CTT_DESC01
		
					GdFieldPut( "CTT_CUSTO"   , cCusto  , 1 , oGetDados:aHeader , @aColsTmp )
					GdFieldPut( "CTT_DESC01"  , cDesc01 , 1 , oGetDados:aHeader , @aColsTmp )
		
					aAdd( oGetDados:aCols , aColsTmp[1] )
		        
				EndIF
				
				CTT->( dbSkip() )
	
			End While
	
		CATCHEXCEPTION USING oException
	
			Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    
		ENDEXCEPTION
		
	END SEQUENCE	
	
	RestArea( aAreaCTT )
	RestArea( aArea )

Return( NIL )

/*/
	Função: 	PanCtb02LinOk
	Autor:		Marinaldo de Jesus
	Data:		25/11/2009
	Descrição:  Validar o TudoOk da GetDados
*/
Static Function PanCtb02LinOk( oBrowse )

	Local lLinOk	:= .T.
	Local aCposKey	:= { "CTT_CUSTO" }
	
	Begin Sequence

		IF !( GdDeleted() )
	
			IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
				Break
			EndIF
		
		EndIF

	End Sequence

Return( lLinOk  )

/*/
	Função:		PanCtb02LinOk
	Autor:		Marinaldo de Jesus
	Data:		25/11/2009
	Descrição:	Validar o TudoOk da GetDados
¯*/
Static Function PanCtb02TudOk( oBrowse )

	Local lTudOk	:= .T.
	
	Local nLoop
	Local nLoops	:= Len( aCols )

	    /*
			Percorre Todas as Linhas para verificar se Esta Tudo OK
		*/
		For nLoop := 1 To nLoops
			n := nLoop
			IF !( lTudoOk := PanCtb02LinOk( oBrowse ) )
				oBrowse:Refresh()
				Break
			EndIF
		Next nLoop 

Return( lTudOk )