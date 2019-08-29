#INCLUDE "PAN-AMERICANA.CH"
/*
    Programa:    U_PanCTB04
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descricao:    Definir as Regras de Relacionamento Entre Contas Contabeis
                Centros de Custo e Filial
    Uso:        PAN-AMERICANA
 */
User Function PanCTB04()

    Local aArea                := GetArea(Alias())
    Local aSvKeys            := GetKeys()
    
    Local aAdvSize            := {}
    Local aObjSize            := {}
    Local aObjCoords        := {}
    Local aInfoAdvSize        := {}
    
    Local aRegras            := {}
    Local aGetFileRegra        := {}
    Local aFieldsGetPut        := {}
    
    Local aCols                := {}
    Local aHeader            := {}
    Local aFldCT1            := {}
    Local aFldCTT            := {}
    Local aFldFil            := {}
    Local aColsTmp            := {}
    Local aSvCols            := {}
    
    Local aButtons            := {}
    Local aBtnCusto            := {}
    Local aBtnFilial        := {}
    
    Local bSet15            := { || NIL }
    Local bSet24            := { || NIL }
    Local bShowFile            := { || NIL }
    Local bGdLinOk            := { |oBrowse| PanCTB04LinOk( oBrowse ) }
    Local bGdTudOk            := { |oBrowse| PanCTB04TudOk( oBrowse ) }
    Local bGetConta            := { |oGetDados , cFieldGet , cFieldPut| GetCConta( @oGetDados , @cFieldGet , @cFieldPut ) , SetMemVar( cFieldPut , GdFieldGet( cFieldPut , oGetDados:oBrowse:nAt , .F. , oGetDados:aHeader , oGetDados:aCols ) ) , oGetDados:lNewLine := .F. }
    Local bBtnCusto            := { || NIL }
    Local bDialogInit        := { || NIL }
    Local bSvblDblClick     := { || NIL }

    Local cFileRegra        := ( FILE_AMARRACAO_CT1_CTT_FILIAL )
    
    Local lOk                := .F.
    
    Local nLoop                := 0
    Local nLoops            := 0
    Local nUsado            := 0
    Local nOpcNewGd            := ( GD_INSERT + GD_UPDATE + GD_DELETE    )
    
    Local oDlg                := NIL
    Local oGetDados            := NIL
    
    Private aGets
    Private aTela
    
    Private cMemoEdit
    Private cCadastro        := OemToAnsi( "Regra de Relacionamento Grupo Cotábil, Centro de Custo e Filial :: Empresa: " + cEmpAnt )

    /*
        Poe o Ponteiro do Mouse em Estado de Espera
    */
    CursorWait()
    
    Begin Sequence
    
        IF File( cFileRegra )
            aGetFileRegra := { aRegras }
            u_InPanVld("GetFileRegra", @aGetFileRegra )
            aRegras := aGetFileRegra[1]
        EndIF
        
        /*
            Monta o aHeader
        */
        aFldCT1 := GdMontaHeader(;
                                    @nUsado            ,;    //01 -> Por Referencia contera o numero de campos em Uso
                                    NIL                ,;    //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
                                    NIL                ,;    //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
                                    "CT1"            ,;    //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
                                    { "CT1_CONTA" }    ,;    //05 -> Opcional, Campos que nao Deverao constar no aHeader
                                    .F.                ,;    //06 -> Opcional, Carregar Todos os Campos
                                    .F.                 ,;    //07 -> Nao Carrega os Campos Virtuais
                                    .F.                ,;    //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
                                    .T.                ,;    //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                    .F.                ,;    //10 -> Verifica se Deve Checar se o campo eh usado
                                    .F.                ,;    //11 -> Verifica se Deve Checar o nivel do usuario
                                    .F.                ,;    //12 -> Utiliza Numeracao na GhostCol
                                    .F.                 ;    //13 -> Carrega os Campos de Usuario
                           )
    
        aAdd( aHeader , aClone( aFldCT1[1] ) )
        aHeader[ GdFieldPos( "CT1_CONTA"    , aHeader ) , __AHEADER_FIELD__     ] := "CCONTA"
        aHeader[ GdFieldPos( "CCONTA"         , aHeader ) , __AHEADER_TITLE__     ] := "Grupo da Conta"
        aHeader[ GdFieldPos( "CCONTA"         , aHeader ) , __AHEADER_F3__         ] := "CT1"
        aHeader[ GdFieldPos( "CCONTA"        , aHeader ) , __AHEADER_VALID__        ] := ""
        
        aAdd( aFieldsGetPut , { "CCONTA" , "CCONTA" , .F. , NIL , bGetConta , NIL } )
    
        aFldCTT := GdMontaHeader(;
                                    @nUsado            ,;    //01 -> Por Referencia contera o numero de campos em Uso
                                    NIL                ,;    //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
                                    NIL                ,;    //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
                                    "CTT"            ,;    //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
                                    {"CTT_CUSTO"}    ,;    //05 -> Opcional, Campos que nao Deverao constar no aHeader
                                    .F.                ,;    //06 -> Opcional, Carregar Todos os Campos
                                    .F.                 ,;    //07 -> Nao Carrega os Campos Virtuais
                                    .T.                ,;    //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
                                    .T.                ,;    //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                    .F.                ,;    //10 -> Verifica se Deve Checar se o campo eh usado
                                    .F.                ,;    //11 -> Verifica se Deve Checar o nivel do usuario
                                    .T.                ,;    //12 -> Utiliza Numeracao na GhostCol
                                    .F.                 ;    //13 -> Carrega os Campos de Usuario
                           )
    
        aAdd( aHeader , aClone( aFldCTT[1] ) )
        aHeader[ GdFieldPos( "CTT_CUSTO"    , aHeader ) , __AHEADER_FIELD__     ] := "CCUSTO"
        aHeader[ GdFieldPos( "CCUSTO"         , aHeader ) , __AHEADER_TITLE__     ] := "Centros de Custo"
        aHeader[ GdFieldPos( "CCUSTO"         , aHeader ) , __AHEADER_F3__         ] := "CTT"
        aHeader[ GdFieldPos( "CCUSTO"        , aHeader ) , __AHEADER_VALID__        ] := ""
        aHeader[ GdFieldPos( "CCUSTO"        , aHeader ) , __AHEADER_WIDTH__        ] := 80 
        aHeader[ GdFieldPos( "CCUSTO"         , aHeader ) , __AHEADER_VISUAL__    ] := "V"

        aAdd( aFieldsGetPut , { "CCUSTO" , "CCUSTO" , .T. , aBtnCusto , NIL , VK_F4 } )

        aAdd( aHeader , aClone( aFldCTT[1] ) )
        aHeader[ GdFieldPos( "CTT_CUSTO"    , aHeader ) , __AHEADER_FIELD__     ] := "CFILIAL"
        aHeader[ GdFieldPos( "CFILIAL"         , aHeader ) , __AHEADER_TITLE__     ] := "Filiais"
        aHeader[ GdFieldPos( "CFILIAL"         , aHeader ) , __AHEADER_F3__         ] := "XM0"
        aHeader[ GdFieldPos( "CFILIAL"        , aHeader ) , __AHEADER_VALID__        ] := ""
        aHeader[ GdFieldPos( "CFILIAL"        , aHeader ) , __AHEADER_WIDTH__        ] := 60
        aHeader[ GdFieldPos( "CFILIAL"         , aHeader ) , __AHEADER_VISUAL__     ]:= "V"
        
        aAdd( aFieldsGetPut , { "CFILIAL" , "CFILIAL" , .T. , aBtnFilial , NIL , VK_F4 } )

        aAdd( aHeader , aClone( aFldCTT[2] ) )
    
        /*
            Cria as Variaveis de Memoria
        */
        nLoops := Len( aHeader )
        For nLoop := 1    To nLoops
            SetMemVar( aHeader[ nLoop , __AHEADER_FIELD__ ] , GetValType( aHeader[ nLoop , __AHEADER_TYPE__ ] , aHeader[ nLoop , __AHEADER_WIDTH__ ] ) , .T. )
        Next nLoop

        aColsTmp := GdRmkaCols( aHeader , .F. , .T. , .F. )
    
        /*
            Monta aCols
        */
        nLoops := Len( aRegras )
        For nLoop := 2 To nLoops
            GdFieldPut( "CCONTA"           , PadR( aRegras[ nLoop ][1] , GetSx3Cache( "CT1_CONTA" , "X3_TAMANHO" ) )    , 1 , @aHeader , @aColsTmp )
            GdFieldPut( "CCUSTO"        , aRegras[ nLoop ][2]                                                          , 1 , @aHeader , @aColsTmp )
            IF ( Len( aRegras[ nLoop ] ) >= 3 )
                GdFieldPut( "CFILIAL"    , aRegras[ nLoop ][3]                                                        , 1 , @aHeader , @aColsTmp )
            Else
                GdFieldPut( "CFILIAL"   , ""                                                                        , 1 , @aHeader , @aColsTmp )
            EndIF    
            GdFieldPut( "GHOSTCOL"      , StrZero( nLoop - 1 , 10  )                                                , 1 , @aHeader , @aColsTmp )
            aAdd( aCols , aClone( aColsTmp[1] ) )
        Next nLoop
    
        /*
            Salva aCols para comparacao antes da Gravacao
        */
        aSvCols := aClone( aCols )
        
        /*
            Monta as Dimensoes dos Objetos
        */
        aAdvSize        := MsAdvSize( NIL , .F. )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
        aObjSize        := MsObjSize( aInfoAdvSize , aObjCoords )
    
        /*/
            Define o Botao de Pesquisa na GetDados
        */
        bShowFile := { ||    ShowFile( oGetDados , cFileRegra ),;
                            SetKey( VK_F4 , bShowFile );
                        }
        aAdd(;
                aButtons    ,;
                                {;
                                    "PMSPESQ",;
                                       bShowFile,;
                                          OemToAnsi( "Mostrar Arquivo" + "...<F4>"  ),;
                                          OemToAnsi( "Mostrar Arquivo" );
                                   };
             )

        /*
            Define o Botao para Obtencao do Centro de Custo De/Ate
        */
        bBtnCusto := { ||    GetCCusto(),;
                              SetKey( VK_F4 , bBtnCusto );
                     }          
        aAdd( aBtnCusto ,    {;
                                "BMPPARAM"                                    ,;
                                   bBtnCusto                                    ,;
                                OemToAnsi( "Centro de Custo" + "...<F4>" )    ,;    //"Centro de Custo"
                                OemToAnsi( "Centro de Custo" )                 ;    //"Centro de Custo"
                               };
            )

        /*
            Define o Botao para Obtencao do Centro de Custo De/Ate
        */
        bBtnFilial := { ||    GetCFilial(),;
                              SetKey( VK_F4 , bBtnFilial );
                       }          
        
        aAdd( aBtnFilial ,    {;
                                "BMPPARAM"                            ,;
                                   bBtnFilial                            ,;
                                OemToAnsi( "Filial" + "...<F4>" )    ,;    //"Filial"
                                OemToAnsi( "Filial" )                 ;    //"Filial"
                               };
            )

        /*
            Define o Bloco para a Tecla <CTRL-O>
        */
        bSet15        := { || IF( oGetDados:TudoOk(),;
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
        bSet24        := { || ( GetKeys() , lOk := .F. , oDlg:End() ) }
    
        /*
            Define o Bloco para o Init do Dialog
        */
        bDialogInit := { ||;
                                EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
                                SetKey( VK_F4 , bShowFile  );
                        }
    
        /*
            Monta o Dialogo Principal para a Manutencao das Regras
        */
        DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
    
            /*
                Monta o Objeto GetDados
            */
            oGetDados := MsNewGetDados():New(    aObjSize[1,1]    ,;    //01 -> nTop        Linha Inicial
                                                aObjSize[1,2]    ,;    //02 -> nLelft        Coluna Inicial
                                                aObjSize[1,3]    ,;    //03 -> nBottom        Linha Final    
                                                aObjSize[1,4]    ,;    //04 -> nRight      Coluna Final
                                                nOpcNewGd        ,;    //05 -> nStyle:        Controle do que podera ser realizado na GetDado
                                                bGdLinOk        ,;    //06 -> ulinhaOK:    Funcao ou CodeBlock para validar a edicao da linha
                                                bGdTudOk        ,;    //07 -> uTudoOK:     Funcao ou CodeBlock para validar todas os registros da GetDados
                                                NIL                ,;    //08 -> cIniCpos:    Campo para Numeracao Automatica
                                                NIL                ,;    //09 -> aAlter:     Array unidimensional com os campos Alteraveis
                                                0                ,;    //10 -> nfreeze:    Numero de Colunas para o Freeze
                                                NIL                ,;     //11 -> nMax:        Numero Maximo de Registros na GetDados    
                                                NIL                ,;    //12 -> cFieldOK:    ?
                                                NIL                ,;    //13 -> usuperdel:    Funcao ou CodeBlock para executar SuperDel na GetDados
                                                { || .T. }        ,;    //14 -> udelOK:        Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
                                                oDlg            ,;    //15 -> oWnd:        Objeto Dialog onde a GetDados sera Desenhada
                                                aHeader            ,;    //16 -> aParHeader:    Array com as Informacoes de Cabecalho
                                                aCols             ;    //17 -> aParCols:    Array com as Informacoes de Detalhes
                                             )//...

            bSvblDblClick                     := oGetDados:oBrowse:blDblClick
            oGetDados:oBrowse:blDblClick    := { || PanCTB04MEdit( @aHeader , @aFieldsGetPut , @oGetDados , @bSvblDblClick , .T. ) }
    
        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
        
        IF (;
                ( lOk );
                .and.;
                !( ArrayCompare( aSvCols , aCols ) );
            )    
            WhileYesNoWait(;
                                { || MayIUseCode( "grv"+cFileRegra ) }                            ,;    //Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
                                3                                                                ,;    //Tempo de Espera para a ProcWaiting()
                                .T.                                                                   ,;    //Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
                                "não Foi Possível Salvar as alterações."                        ,;    //Mensagem de Corpo para a MsgInfo
                                "Atenção!!!"                                                    ,;    //Titulo para a MsgInfo
                                "O arquivo está bloiqueado por Outro Usuário. Deseja Aguardar?"    ,;    //Mensagem de Corpo para a MsgYesNo
                                "Atenção!!!!"                                                    ,;    //Titulo para a MsgYesNo
                                "Aguardando Desbloqueio do arquivo..."                            ,;    //Mensagem de corpo para a ProcWaiting
                                "Aguarde..."                                                     ;    //Titulo para a ProcWaiting
                            )
            MsgRun( OemToAnsi( "Aguarde..." ) , OemToAnsi( "Salvando alterações" ) , { || PanCTB04Grv( aHeader , aCols , cFileRegra , .T. ) } )
            Leave1Code( "grv"+cFileRegra )
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

/*
    Função:        PanCTB04Grv    
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:    Gravar as Informacoes em Arquivo
*/    
Static Function PanCTB04Grv( aHeader , aCols , cFileRegra , lGrava )

    Local cDetGrv        := ""
    Local cMsgException    := ""
    
    Local lGrvOk        := .F.
    
    Local nLoop
    Local nLoops
    Local nError
    Local nConta
    Local nFilial

    Local oException

    TRYEXCEPTION

        GdSplitDel( aHeader , aCols , {} )

        nConta        := GdFieldPos( "CCONTA"  , aHeader )
        nFilial        := GdFieldPos( "CFILIAL" , aHeader )

        aSort( aCols , NIL , NIL , { |x,y| ( x[nConta]+x[nFilial] ) < ( y[nConta]+y[nFilial] ) } )
        
        cDetGrv    := ( "CT1_CONTA;CTT_CUSTO;M0_CODFIL" + CRLF )
    
        nLoops := Len( aCols )
        For nLoop := 1 To nLoops
            cDetGrv     += AllTrim( GdFieldGet( "CCONTA"  , nLoop , .F. , aHeader , aCols ) )
            cDetGrv     += ";"
            cDetGrv     += AllTrim( GdFieldGet( "CCUSTO"  , nLoop , .F. , aHeader , aCols ) )
            cDetGrv     += ";"
            cDetGrv     += AllTrim( GdFieldGet( "CFILIAL"  , nLoop , .F. , aHeader , aCols ) )
            cDetGrv     += CRLF
        Next nLoop
    
        DEFAULT lGrava := .T.

        IF ( lGrava )
        
            IF File( cFileRegra )
                lGrvOk := FileErase( cFileRegra , @nError )
                IF !( lGrvOk )
                    cMsgException += "File Error: " + AllTrim( Str( nError ) )
                    cMsgException += CRLF
                    cMsgException += "não foi Possível regravar o o arquivo: "
                    cMsgException += CRLF
                    cMsgException += cFileRegra
                    cMsgException += CRLF
                    cMsgException += "Entre em contato com o Administrador do Sistema!"
                EndIF    
            EndIF
        
            MemoWrite( cFileRegra , cDetGrv )
        
            lGrvOk := File( cFileRegra )
            IF !( lGrvOk )
                cMsgException += "File Error: " + AllTrim( Str( nError ) )
                cMsgException += CRLF
                cMsgException += "não foi Possível regravar o o arquivo: "
                cMsgException += CRLF
                cMsgException += cFileRegra
                cMsgException += CRLF
                cMsgException += "Entre em contato com o Administrador do Sistema!"
            EndIF

        EndIF
            
    CATCHEXCEPTION USING oException
    
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "ERRO DE GRAVAÇƒO:" + CRLF + CRLF + oException:Description ) , 1 , 0 )
    
    ENDEXCEPTION

Return( IF( lGrava , lGrvOk , cDetGrv ) )

/*
    Função:        ShowFile
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:  Mostar o Conteudo do Arquivo
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
    
        cMemoEdit := PanCTB04Grv( oGetDados:aHeader , oGetDados:aCols , cFileShow , .F. )
    
        /*
            Monta as Dimensoes dos Objetos
        */
        aAdvSize        := MsAdvSize( .T. , .T. )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aObjCoords        := { { 0 , 0 , .T. , .T. } }
        aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )
    
        /*
            Salva as Teclas de Atalho
        */    
        aSvKeys := GetKeys()
    
        /*
            Define o Bloco para a Tecla <CTRL-O>
        */
        bSet15    := { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
    
        /*
            Define o Bloco para a Tecla <CTRL-X>
        */
        bSet24    := { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
    
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

/*
    Função:     PanCTB04LinOk
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:  Validar o TudoOk da GetDados
*/
Static Function PanCTB04LinOk( oBrowse )

    Local aCCustos        := {}

    Local lLinOk        := .T.
    
    Local nLoop
    Local nLoops
    Local nPosCConta    := GdFieldPos( "CCONTA" )
    Local nPosCCusto    := GdFieldPos( "CCUSTO" )
    Local nPosFilial    := GdFieldPos( "CFILIAL" )
    
    Begin Sequence

        IF !( GdDeleted() )

            IF Empty( aCols[ n , nPosCConta ] )
                lLinOk := .F.
                Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "CONTEÚDO INVÁLIDO PARA O CAMPO:" +  CRLF + CRLF + aHeader[ nPosCConta , __AHEADER_TITLE__ ]  ) , 1 , 0 )
                Break
            EndIF
            
            IF ( "&" $ aCols[ n , nPosCCusto ] )
                aCCustos    := u_InPanVld("StrToArray" , { aCols[ n , nPosCCusto ] , "&" } )    
                nLoops         := Len( aCCustos )
                For nLoop := 1 To nLoops
                    IF !( ":" $ aCCustos[ nLoop ] )
                        lLinOk := .F.
                        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "CONTEÚDO INVÁLIDO PARA O CAMPO:" +  CRLF + CRLF + aHeader[ nPosCCusto , __AHEADER_TITLE__ ]  ) , 1 , 0 )
                        Break
                    EndIF
                Next nLoop
            ElseIF !( ":" $ aCols[ n , nPosCCusto ] )
                lLinOk := .F.
                Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "CONTEÚDO INVÁLIDO PARA O CAMPO:" +  CRLF + CRLF + aHeader[ nPosCCusto , __AHEADER_TITLE__ ]  ) , 1 , 0 )
                Break
            EndIF

            IF Empty( aCols[ n , nPosFilial ] )
                Break    
            EndIF
            
            IF !( "&" $ aCols[ n , nPosFilial ] )
                lLinOk := .F.
                Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "CONTEÚDO INVÁLIDO PARA O CAMPO:" +  CRLF + CRLF + aHeader[ nPosFilial , __AHEADER_TITLE__ ]  ) , 1 , 0 )
                Break
            EndIF

        EndIF

    End Sequence

Return( lLinOk  )

/*/

    Função:        PanCTB04LinOk
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:    Validar o TudoOk da GetDados
*/
Static Function PanCTB04TudOk( oBrowse )

    Local lTudOk    := .T.
    
    Local nLoop
    Local nLoops    := Len( aCols )

        /*    
            Percorre Todas as Linhas para verificar se Esta Tudo OK
        */
        For nLoop := 1 To nLoops
            n := nLoop
            IF !( lTudoOk := PanCTB04LinOk( oBrowse ) )
                oBrowse:Refresh()
                Break
            EndIF
        Next nLoop 

Return( lTudOk )

/*/
    Função:        PanCTB04MEdit
    Autor:        Marinaldo de Jesusï
    Data:        28/11/2009
    Descrição:  Edit de Campo Memo
*/
Static Function PanCTB04MEdit( aHeader , aFieldsGetPut , oGetDados , blDblClick , lModify , cEditMemo )

    Local aButtons
    Local aAdvSize
    Local aSvKeys
    Local aObjSize
    Local aObjCoords
    Local aInfoAdvSize
    
    Local bSet15
    Local bSet24
    Local bGetBlock
    Local bDialogInit
    
    Local cMemVar
    Local cFieldGet
    Local cFieldPut
    Local cTitCompl
    Local cbGetBlock
    Local cSvMemoEdit
    
    Local lConfOk
    
    Local nColMemo
    Local nPosFldGet
    Local nPosFldPut
    Local nVKey
    
    Local oDlg
    Local oFont
    Local oMemoEdit
    
    Begin Sequence
    
        cMemoEdit := ""

        IF ( cEditMemo <> NIL )
            cMemoEdit := cEditMemo
        EndIF
        
        cMemVar        := aHeader[ oGetDados:oBrowse:nColPos , __AHEADER_FIELD__ ]
    
        DEFAULT aFieldsGetPut    := {}
        
        nPosFldGet    := aScan( aFieldsGetPut , { |x| x[1] == cMemVar } )
        
        IF ( nPosFldGet > 0 )
            cFieldGet    := aFieldsGetPut[nPosFldGet,1]
            cFieldPut    := aFieldsGetPut[nPosFldGet,2]
            IF !( aFieldsGetPut[nPosFldGet][3] )
                IF ( ValType( aFieldsGetPut[nPosFldGet][5] ) == "B" )
                    Eval( aFieldsGetPut[nPosFldGet][5] , oGetDados , cFieldGet , cFieldPut )
                    Break
                EndIF    
            EndIF
        Else
            cFieldGet    := "__NO_FIELD_GET__"
        EndIF    
    
        nColMemo    := GdFieldPos( cFieldGet , oGetDados:aHeader )
    
        /*/
            Se a Coluna Posicionada nao for a Coluna do Memo
        */
        IF !( oGetDados:oBrowse:nColPos == nColMemo )
            GdRstDblClick( oGetDados , blDblClick )
            Break
        EndIF
    
        IF ( ValType( aFieldsGetPut[nPosFldGet][4] ) == "A" )
            aButtons         := aFieldsGetPut[nPosFldGet][4]
            bGetBlock        := aButtons[1,2]
        EndIF
        
        IF ( ValType( aFieldsGetPut[nPosFldGet][6] ) == "N" )
            nVKey := aFieldsGetPut[nPosFldGet][6]
        EndIF
    
        /*/
            Obtem o Memo
        */
        IF Empty( cEditMemo )
            cMemoEdit := GdFieldGet( cFieldGet , oGetDados:oBrowse:nAt , .F. , oGetDados:aHeader , oGetDados:aCols )
        EndIF    
    
        IF ( "&&" $ cMemoEdit )
            cMemoEdit := StrTran( cMemoEdit , "&&" , "&" )
        EndIF    
        
        IF ( "&" $ cMemoEdit )
            cMemoEdit := StrTran( cMemoEdit , "&" , CRLF )
        EndIF    
    
        cSvMemoEdit := cMemoEdit
    
        /*/
            Monta as Dimensoes dos Objetos
        */
        aAdvSize        := MsAdvSize( .T. , .T. )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aObjCoords        := { { 0 , 0 , .T. , .T. } }
        aObjSize         := MsObjSize( aInfoAdvSize , aObjCoords )
    
        /*
            Salva as Teclas de Atalho
        */
        aSvKeys := GetKeys()
    
        /*
            Define o Bloco para a Tecla <CTRL-O>
        */
        bSet15    := { || RestKeys( aSvKeys , .T. ) , lConfOk := .T. , oDlg:End() }
    
        /*
            Define o Bloco para a Tecla <CTRL-X>
        */
        bSet24    := { || RestKeys( aSvKeys , .T. ) , lConfOk := .F. , oDlg:End() }
    
        /*/
            Define o Bloco para o INIT do Dialog
        */
        bDialogInit := { ||;
                                 EnchoiceBar( @oDlg , @bSet15 , @bSet24 , NIL , @aButtons ) ,;
                                 IF( !Empty( nVKey ) , SetKey( nVKey , bGetBlock ) , NIL );
                       }
    
        /*
            Carrega o Complemento do Titulo
        */
        cTitCompl := AllTrim( oGetDados:aHeader[ GdFieldPos( cFieldPut , oGetDados:aHeader ) , 01 ] )
    
        DEFINE FONT oFont NAME "Arial" SIZE 0,-15 //BOLD
        DEFINE MSDIALOG oDlg TITLE cCadastro + OemToAnsi( " :: " + cTitCompl ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL 
                
            @ aObjSize[1,1],aObjSize[1,2] GET oMemoEdit VAR cMemoEdit MEMO SIZE aObjSize[1,4],(aObjSize[1,3]-15) FONT oFont OF oDlg PIXEL WHEN ( .T. )
            oMemoEdit:lReadOnly := !( lModify )
            oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
            
        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
        RestKeys( aSvKeys , .T. )
    
        IF ( lModify )
            IF ( lConfOk )        //<CTRL-O>
                IF ( CRLF $ cMemoEdit )
                    cMemoEdit := StrTran( cMemoEdit , CRLF , "&" )
                    IF ( "&&" $ cMemoEdit )
                        cMemoEdit := StrTran( cMemoEdit , "&&" , "&" )
                    EndIF
                    cMemoEdit := StrTran( cMemoEdit , CRLF , "&" )
                    IF ( SubStr( cMemoEdit , -1 ) == "&" )
                        cMemoEdit := SubStr( cMemoEdit , 1 , ( Len( cMemoEdit ) - 1 ) )    
                    EndIF
                EndIF
                DEFAULT cFieldPut    := cFieldGet
                GdFieldPut( cFieldGet , cMemoEdit , oGetDados:oBrowse:nAt , oGetDados:aHeader , oGetDados:aCols , .F. )
                Private n := oGetDados:oBrowse:nAt
                GdFieldPut( cFieldPut , cMemoEdit , oGetDados:oBrowse:nAt , oGetDados:aHeader , oGetDados:aCols , .T. )
                SetMemVar( cFieldPut , cMemoEdit )
                oGetDados:lNewLine := .F. 
            ElseIF !( lConfOk )    //<CTRL-X>
                IF !( cSvMemoEdit == cMemoEdit )
                    IF !( MsgNoYes( OemToAnsi( "Abandonar as alterações?" ) , cCadastro ) )
                        PanCTB04MEdit( @aHeader , @aFieldsGetPut , @oGetDados , @blDblClick , @lModify , @cMemoEdit )
                    EndIF
                EndIF    
            EndIF
        EndIF
        
    End Sequence
    
    cEditMemo := cMemoEdit
    
Return( NIL )

/*/

    Função:        GetCConta
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:    Obter valores validos para a Conta Contabil
*/
Static Function GetCConta( oGetDados , cFieldGet , cFieldPut )

    Local aArea            := GetArea()
    Local aKeys            := GetKeys()
    Local aCols            := {}
    Local aHeader        := {}
    Local aFldCT1
    Local aFldSP0
    
    Local bSet15        := { || IF( oGDCConta:TudoOk() ,( lOk := .T. , aCols := oGDCConta:aCols , oDlg:End() ) , .F. )  }
    Local bSet24        := { || lOk := .F. , oDlg:End() }
    Local bGdCContaLOk    := { |oBrowse| GetCContaLOk( oBrowse ) }
    Local bGdCContaTOk    := { |oBrowse| GetCContaTOk( oBrowse ) }
    
    Local cGrpPut        := Padr( GdFieldGet( cFieldGet , oGetDados:oBrowse:nAt , .F. , oGetDados:aHeader , oGetDados:aCols ) , GetSx3Cache( "CT1_CONTA" , "X3_TAMANHO" ) )
    
    Local lOk            := .F.

    Local nLoop
    Local nLoops
    Local nUsado        := 0
    Local nGrpIni        := 0
    Local nGrpFim         := 0
    Local nOpcNewGd        := GD_UPDATE

    Local oDlg
    Local oGDCConta
    Local oException

    TRYEXCEPTION

        /*
            Monta o aHeader
        */
        aFldCT1 := GdMontaHeader(;
                                    @nUsado            ,;    //01 -> Por Referencia contera o numero de campos em Uso
                                    NIL                ,;    //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
                                    NIL                ,;    //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
                                    "CT1"            ,;    //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
                                    { "CT1_CONTA" }    ,;    //05 -> Opcional, Campos que nao Deverao constar no aHeader
                                    .F.                ,;    //06 -> Opcional, Carregar Todos os Campos
                                    .F.                 ,;    //07 -> Nao Carrega os Campos Virtuais
                                    .F.                ,;    //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
                                    .T.                ,;    //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                    .F.                ,;    //10 -> Verifica se Deve Checar se o campo eh usado
                                    .F.                ,;    //11 -> Verifica se Deve Checar o nivel do usuario
                                    .F.                ,;    //12 -> Utiliza Numeracao na GhostCol
                                    .F.                 ;    //13 -> Carrega os Campos de Usuario
                           )
    
        aAdd( aHeader , aFldCT1[1] )
    
        aHeader[ GdFieldPos( "CT1_CONTA"    , aHeader ) , __AHEADER_FIELD__         ] := cFieldPut
        aHeader[ GdFieldPos( cFieldPut         , aHeader ) , __AHEADER_TITLE__         ] := "Grupo da Conta"
        aHeader[ GdFieldPos( cFieldPut         , aHeader ) , __AHEADER_F3__             ] := "CT1"
        aHeader[ GdFieldPos( cFieldPut        , aHeader ) , __AHEADER_VALID__            ] := ""
    
        aFldSP0 := GdMontaHeader(;
                                    @nUsado            ,;    //01 -> Por Referencia contera o numero de campos em Uso
                                    NIL                ,;    //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
                                    NIL                ,;    //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
                                    "SP0"            ,;    //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
                                    {;
                                        "P0_CODINI"    ,;
                                        "P0_CODFIM"    ;
                                    }                ,;    //05 -> Opcional, Campos que nao Deverao constar no aHeader
                                    .F.                ,;    //06 -> Opcional, Carregar Todos os Campos
                                    .F.                 ,;    //07 -> Nao Carrega os Campos Virtuais
                                    .T.                ,;    //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
                                    .T.                ,;    //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                    .F.                ,;    //10 -> Verifica se Deve Checar se o campo eh usado
                                    .F.                ,;    //11 -> Verifica se Deve Checar o nivel do usuario
                                    .F.                ,;    //12 -> Utiliza Numeracao na GhostCol
                                    .F.                 ;    //13 -> Carrega os Campos de Usuario
                           )
    
        aAdd( aHeader , aFldSP0[1] )
        aAdd( aHeader , aFldSP0[2] ) 
        aAdd( aHeader , aFldSP0[3] )
    
        aHeader[ GdFieldPos( "P0_CODINI"    , aHeader ) , __AHEADER_FIELD__         ] := "GRPINI"
        aHeader[ GdFieldPos( "P0_CODFIM"    , aHeader ) , __AHEADER_FIELD__         ] := "GRPFIM"
        aHeader[ GdFieldPos( "GRPINI"         , aHeader ) , __AHEADER_TITLE__         ] := "Inicio do Grupo"
        aHeader[ GdFieldPos( "GRPFIM"         , aHeader ) , __AHEADER_TITLE__         ] := "Final do Grupo"    
        aHeader[ GdFieldPos( "GRPINI"        , aHeader ) , __AHEADER_VALID__            ] := "Positivo().and.IF(GdFieldGet('GRPFIM')>0,(GetMemVar('GRPINI')<=GdFieldGet('GRPFIM')),.T.)"
        aHeader[ GdFieldPos( "GRPFIM"        , aHeader ) , __AHEADER_VALID__            ] := "Positivo().and.(GetMemVar('GRPFIM')>=GdFieldGet('GRPINI'))"
    
        /*
            Cria as Variaveis de Memoria
        */
        nLoops := Len( aHeader )
        For nLoop := 1    To nLoops
            SetMemVar( aHeader[ nLoop , __AHEADER_FIELD__ ] , GetValType( aHeader[ nLoop , __AHEADER_TYPE__ ] , aHeader[ nLoop , __AHEADER_WIDTH__ ] ) , .T. )
        Next nLoop

        aCols    := GdRmkaCols( aHeader , .F. , .T. , .F. )
        IF !Empty( cGrpPut )
            GdFieldPut( cFieldPut , cGrpPut    , 1 , @aHeader , @aCols )
            GdFieldPut( "GRPINI"  , 1    , 1 , @aHeader , @aCols )
            GdFieldPut( "GRPFIM"  , Len( AllTrim( cGrpPut )     ) , 1 , @aHeader , @aCols )
        EndIF

        /*
            Monta o Dialogo para Edicao
        */
        DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro + " :: Obter Grupo Cotábil" ) From 196,042 TO 380,680 OF GetWndDefault() PIXEL
            oGDCConta := MsNewGetDados():New(    015                ,;    //01 -> nTop        Linha Inicial
                                                005                ,;    //02 -> nLelft        Coluna Inicial
                                                085                ,;    //03 -> nBottom        Linha Final    
                                                315                ,;    //04 -> nRight      Coluna Final
                                                nOpcNewGd        ,;    //05 -> nStyle:        Controle do que podera ser realizado na GetDados
                                                bGdCContaLOk    ,;    //06 -> ulinhaOK:    Funcao ou CodeBlock para validar a edicao da linha
                                                bGdCContaLOk    ,;    //07 -> uTudoOK:     Funcao ou CodeBlock para validar todas os registros da GetDados
                                                NIL                ,;    //08 -> cIniCpos:    Campo para Numeracao Automatica
                                                NIL                ,;    //09 -> aAlter:     Array unidimensional com os campos Alteraveis
                                                0                ,;    //10 -> nfreeze:    Numero de Colunas para o Freeze
                                                NIL                ,;     //11 -> nMax:        Numero Maximo de Registros na GetDados    
                                                NIL                ,;    //12 -> cFieldOK:    ?
                                                NIL                ,;    //13 -> usuperdel:    Funcao ou CodeBlock para executar SuperDel na GetDados
                                                { || .F. }        ,;    //14 -> udelOK:        Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
                                                oDlg            ,;    //15 -> oWnd:        Objeto Dialog onde a GetDados sera Desenhada
                                                aHeader            ,;    //16 -> aParHeader:    Array com as Informacoes de Cabecalho
                                                aCols             ;    //17 -> aParCols:    Array com as Informacoes de Detalhes
                                             )//...
            
        ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 ) CENTERED
        RestKeys( aKeys )

        IF ( lOk )
            nGrpIni        := Max( GdFieldGet( "GRPINI" , 1 , .F. , aHeader , aCols ) , 1 )
            nGrpFim     := GdFieldGet( "GRPFIM" , 1 , .F. , aHeader , aCols )
            cGrpPut        := SubStr( GdFieldGet( cFieldPut  , 1 , .F. , aHeader , aCols ) , nGrpIni ,  ( nGrpFim - nGrpIni ) + 1 )
            GdFieldPut( cFieldPut , cGrpPut    , oGetDados:oBrowse:nAt , oGetDados:aHeader , oGetDados:aCols )
        EndIF

    CATCHEXCEPTION USING oException
    
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( oException:Description ) , 1 , 0 )        
    
    ENDEXCEPTION
    
    /*/
        Restaura Teclas de Atalho e Ponteiros de Entrada
    */
    RestKeys( aKeys )
    RestArea( aArea )
        
Return( NIL )

/*/

    Função:        GetCContaLOk
    Autor:        Marinaldo de Jesus
    Data:        29/11/2009
    Descrição:  Linha OK

*/
Static Function GetCContaLOk( oBrowse )
    
    Local aArea            := GetArea()
    Local aAreaCT1        := CT1->( GetArea() )

    Local cGrpPut        := ""
    Local cMsgException    := ""

    Local nGrpIni        := 0
    Local nGrpFim         := 0

    Local lLinOk        := .T.

    Local nCT1Order        := RetOrder( "CT1" , "CT1_FILIAL+CT1_CONTA" )
    Local nPosCConta    := GdFieldPos( "CCONTA" )
    Local nPosGrpIni    := GdFieldPos( "GRPINI" )
    Local nPosGrpFim    := GdFieldPos( "GRPFIM" )
    
    Local nPosFieldErr    := 0
        
    Local oException
    
    TRYEXCEPTION
    
        IF Empty( cGrpPut := GdFieldGet( "CCONTA" ) )
            nPosFieldErr := nPosCConta
            UserException( "A Conta é de Preenchimento Obrigatório" )
        EndIF

        IF Empty( nGrpIni := GdFieldGet( "GRPINI" ) )
            nPosFieldErr := nPosGrpIni
            UserException( "Posição Inicial é de Preenchimento Obrigatório" )
        EndIF

        IF Empty( nGrpFim := GdFieldGet( "GRPFIM" ) )
            nPosFieldErr := nPosGrpFim
            UserException( "Posição Final é de Preenchimento Obrigatório" )
        Else
            IF ( nGrpIni > nGrpFim )
                nPosFieldErr := nPosGrpIni
                UserException( "Posição Inicial do Grupo não Pode Ser Maior que Posição Final do Grupo" )
            EndIF
        EndIF

        nGrpIni        := Max( nGrpIni , 1 )
        cGrpPut        := SubStr( cGrpPut , nGrpIni ,  ( nGrpFim - nGrpIni ) + 1 )

        CT1->( dbSeek( xFilial( "CT1" ) + cGrpPut , .T. ) )
        IF !( SubStr( CT1->CT1_CONTA , nGrpIni ,  ( nGrpFim - nGrpIni ) + 1 ) == cGrpPut )
            UserException( "Grupo Cotábil não Cadastrado" )
        EndIF
            
    CATCHEXCEPTION USING oException
    
        lLinOk            := .F.
        IF ( nPosFieldErr > 0 )
            cMsgException    := "CONTEÚDO INVÁLIDO PARA O CAMPO:" +  CRLF + CRLF + aHeader[ nPosFieldErr , __AHEADER_TITLE__ ]
            cMsgException    += CRLF + CRLF 
        EndIF
        cMsgException        += oException:Description

        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( cMsgException ) , 1 , 0 )
    
    ENDEXCEPTION

    RestArea( aAreaCT1 )
    RestArea( aArea )

Return( lLinOk )

/*
    Função:        GetCContaTOk
    Autor:        Marinaldo de Jesus
    Data:        29/11/2009
    Descrição:  TudoOK na Validacao da Conta
*/
Static Function GetCContaTOk( oBrowse )
Return( GetCContaLOk( oBrowse ) )

/*

    Função:        GetCCusto
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição: Obter valores validos para o Centro de Custo
*/
Static Function GetCCusto()

    Local aArea        := GetArea()
    Local aAreaCTT    := CTT->( GetArea() )
    Local aGetKeys    := GetKeys()

    Local aSplitCC 
    
    Local cPerg        := "PANCTB0401"
    Local cPutCC    := cMemoEdit

    Local cCCDe     
    Local cCCAte
    
    Local nCTTOrder    := RetOrder( "CTT" , "CTT_FILIAL+CTT_CUSTO" )
    
    Local oException

    TRYEXCEPTION
    
        IF !( Pergunte( cPerg , .T. ) )
            UserException( cCancel )
        EndIF

        cCCDe    := AllTrim( MV_PAR01 )
        cCCAte  := AllTrim( MV_PAR02 )

        CTT->( dbSetOrder( nCTTOrder ) )
        
        IF (;
                Empty( cCCDe );
                .or.;
                CTT->( !dbSeek( xFilial( "CTT" ) + cCCDe , .F. ) );
            )    
            UserException( "Centro de Custo De Inválido" )
        EndIF

        IF (;
                Empty( cCCAte );
                .or.;
                CTT->( !dbSeek( xFilial( "CTT" ) + cCCAte , .F. ) );
            )    
            UserException( "Centro de Custo Até ‰nvá¬©do" )
        EndIF
        
        IF ( cCCDe > cCCAte )
            UserException( "Centro de Custo 'De' não Pode Ser Maior que Centro de Custo 'Até'" )
        EndIF
    
        cCCDe    := AllTrim( cCCDe )
        cCCAte  := AllTrim( cCCAte )
        
        IF Empty( cPutCC )
            cPutCC := ( cCCDe + ":" + cCCAte )
        ElseIF ( CRLF $ cPutCC )
            aSplitCC := u_InPanVld("StrToArray" , { cPutCC , CRLF } )
            IF ( aScan( aSplitCC , { |x| ( cCCDe $ x ) } ) > 0 )
                UserException( "Centro de Custo De Já Informado  para essa Regra" )
            EndIF
            IF ( aScan( aSplitCC , { |x| ( cCCAte $ x ) } ) > 0 )
                UserException( "Centro de Custo Até ja Informado para essa Regra" )
            EndIF
            cPutCC := ( cPutCC + CRLF + cCCDe + ":" + cCCAte )
        ElseIF ( ":" $ cPutCC )
            cPutCC := ( cPutCC + CRLF + cCCDe + ":" + cCCAte )    
        EndIF

        cMemoEdit := cPutCC

    CATCHEXCEPTION USING oException
    
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( oException:Description ) , 1 , 0 )        
    
    ENDEXCEPTION

    RestKeys( aGetKeys )

    RestArea( aAreaCTT )
    RestArea( aArea )

Return( NIL )

/*
    Função:        GetCFilial
    Autor:        Marinaldo de Jesus
    Data:        28/11/2009
    Descrição:    Obter valores validos para a Filial
*/
Static Function GetCFilial()

    Local aArea        := GetArea()
    Local aAreaSM0    := SM0->( GetArea() )
    Local aGetKeys    := GetKeys()

    Local aSplitFil 

    Local cPerg        := "PANCTB0402"
    Local cPutFil    := cMemoEdit
    
    Local oException

    TRYEXCEPTION
    
        IF !( Pergunte( cPerg , .T. ) )
            UserException( cCancel )
        EndIF

        SM0->( dbSetOrder( 1 ) )
        IF SM0->( !dbSeek( cEmpAnt + MV_PAR01 ) )
            UserException( "Filial não Cadastrada no Sistema" )    
        EndIF

        IF Empty( cPutFil )
            cPutFil := ( MV_PAR01 + CRLF + MV_PAR01 )
        ElseIF ( CRLF $ cPutFil )
            aSplitFil := u_InPanVld("StrToArray" , { cPutFil , CRLF } )
            IF ( aScan( aSplitFil , { |x| ( x == MV_PAR01 ) } ) > 0 )
                UserException( "Filial Já Informada  para essa Regra" )
            EndIF
            cPutFil := ( cPutFil + CRLF + MV_PAR01 )
        EndIF

        cMemoEdit := cPutFil

    CATCHEXCEPTION USING oException
    
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( oException:Description ) , 1 , 0 )        
    
    ENDEXCEPTION
    
    RestKeys( aGetKeys )

Return( NIL )
