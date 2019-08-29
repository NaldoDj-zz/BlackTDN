#INCLUDE "NDJ.CH"    
#INCLUDE "U_NDJA002.CH"

Static __aTTS    := {}
Static __nTTS    := 0

/*/
    Function:    NDJA002
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ
    Sintaxe:    StaticCall(U_NDJA002,NDJA002,cAlias,nReg,nOpc,lExecAuto)
/*/
Static Function NDJA002( cAlias , nReg , nOpc , lExecAuto )
                                                            
    Local aArea     := GetArea()
    Local aAreaSZ5    := SZ5->( GetArea() )
    Local aAreaSZ4    := SZ4->( GetArea() )
    Local aSaveGet    := SaveoGet()
    
    Local lExistOpc    := ( ValType( nOpc ) == "N" )

    Private nPrvtN    := IF( ( Type( "n" ) == "N" ) , n , NIL )
    
    BEGIN SEQUENCE

        cAlias    := "SZ5"
    
        Private aRotina        := {;
                                    { STR0001 , "AxPesqui"        , 0 , 01 } ,; //"Pesquisar"
                                    { STR0002 , "NDJA002Mnt"    , 0 , 02 } ,; //"Visualizar"
                                    { STR0003 , "NDJA002Mnt"    , 0 , 03 } ,; //"Incluir"
                                    { STR0004 , "NDJA002Mnt"    , 0 , 04 } ,; //"Alterar"
                                    { STR0005 , "NDJA002Mnt"    , 0 , 05 }  ; //"Excluir"
                                }
        
        Private cCadastro    := OemToAnsi( STR0006 )    //"Cadastro de Tabela Locais NDJ"
    
        IF ( lExistOpc )

            DEFAULT nReg    := ( cAlias )->( Recno() )
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
    
                NDJA002Mnt( @cAlias , @nReg , @nOpc , .T. )
            
            EndIF    
        
        Else
    
            mBrowse( 6 , 1 , 22 , 75 , cAlias )
    
        EndIF
        
    END SEQUENCE
    
    CursorWait()
    
    RestArea( aAreaSZ4 )
    RestArea( aAreaSZ5 )
    RestArea( aArea )
    
    CursorArrow()

    RestartoGet( aSaveGet )

Return( NIL )

/*/
    Function:    NDJA002Vis
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Visualizar)
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Vis,cAlias,nReg)
/*/
Static Function NDJA002Vis( cAlias , nReg )
    Local nOpc := 2
Return( NDJA002( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA002Inc
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Incluir)
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Inc,cAlias,nReg)
/*/
Static Function NDJA002Inc( cAlias , nReg )
    Local nOpc := 3
    IF ( nReg > 0 )
        nOpc := 4
    EndIF
Return( NDJA002( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA002Alt
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Alt,cAlias,nReg)
/*/
Static Function NDJA002Alt( cAlias , nReg )
    Local nOpc := 4
Return( NDJA002( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA002Del
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Del,cAlias,nReg)
/*/
Static Function NDJA002Del( cAlias , nReg )
    Local nOpc := 5
Return( NDJA002( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA002Mnt
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Manutencao)
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Mnt,cAlias,nReg,lDlgPadSiga)
/*/
Static Function NDJA002Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

    Local aArea            := GetArea(Alias())
    Local aAreaSZ5        := SZ5->( GetArea() )
    Local aSvKeys        := GetKeys()
    Local aAdvSize        := {}
    Local aInfoAdvSize    := {}
    Local aObjSize        := {}
    Local aObjCoords    := {}
    Local aSZ5Header    := {}
    Local aSZ5Cols        := {}
    Local aSvSZ5Cols    := {}
    Local aSZ5Fields    := {}
    Local aSZ5Altera    := {}
    Local aSZ5NaoAlt    := {}
    Local aSZ5VirtEn    := {}
    Local aSZ5NotFields    := {}
    Local aSZ5Recnos    := {}
    Local aSZ5Keys        := {}
    Local aSZ5VisuEn    := {}
    Local aSZ4GdAltera  := {}
    Local aSZ4GdNaoAlt    := {}
    Local aSZ4Recnos    := {}
    Local aSZ4Keys        := {}
    Local aSZ4NotFields    := {}
    Local aSZ4VirtGd    := {}
    Local aSZ4VisuGd    := {}
    Local aSZ4Header    := {}
    Local aSZ4Cols        := {}
    Local aSvSZ4Cols    := {}
    Local aSZ4Query        := {}
    Local aButtons        := {}
    Local aFreeLocks    := {}
    Local aLog            := {}
    Local aLogTitle        := {}
    Local aLogGer        := {}
    Local aLogGerTitle    := {}
    
    Local bSZ4GdDelOk    := { |lDelOk| CursorWait() , lDelOk := SZ4GdDelOk( "SZ4" , NIL , nOpc , cZ5Codigo , nSZ4Order ) , CursorArrow() , lDelOk }
    Local bSet15        := { || NIL }
    Local bSet24        := { || NIL }
    Local bGdSZ4Seek    := { || NIL }
    Local bDialogInit    := { || NIL }
    Local bGetSZ5        := { || NIL } 
    Local bGetSZ4        := { || NIL }
    Local bSZ4Sort        := { || NIL }
    Local bSZ4LinOk        := { |oBrowse| oGdSZ4LinOk( oBrowse ) }
    Local bSZ4TudOk        := { |oBrowse| oGdSZ4TudOk( oBrowse ) }
    
    Local cKTTS            := ""
    Local cNumSC        := ""
    Local cItemSC        := ""
    Local cSeqItem        := ""
    Local cFilSZ4        := ""
    Local cFilSZ5        := ""
    Local cZ5Codigo        := ""
    Local cZ5KeySeek    := ""
    Local cMsgYesNo        := ""
    Local cTitLog        := ""
    
    Local lLocks        := .F.
    Local lExecLock        := ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
    Local lExcGeraLog    := .F.
    Local lFreeLocks    := .F.
    
    Local nOpcAlt        := 0
    Local nSZ5Usado        := 0
    Local nSZ4Usado        := 0
    Local nLoop            := 0
    Local nLoops        := 0
    Local nOpcNewGd        := 0
    Local nSZ4MaxLocks    := 50
    Local nSZ4GhostCol    := 0
    Local nSZ4Order        := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
    Local nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )
    
    Local oDlg            := NIL
    Local oEnSZ5        := NIL    
    Local oGdSZ4        := NIL
    Local oPanel
    
    Private aGets
    Private aTela

    Private n            := IF( ( Type( "nPrvtN" ) == "N" ) , nPrvtN , 1 )
    Private nGetSX8Len    := GetSX8Len()
    
    CursorWait()
    
    BEGIN SEQUENCE

        IF !( IsInCallStack( "NDJPreNFA" ) )
            nOpc := 2
        EndIF

        NDJPubMemVar(3)

        aRotSetOpc( cAlias , @nReg , nOpc )
    
        aSZ5NotFields    := { "Z5_FILIAL" }
        bGetSZ5            := { |lLock,lExclu|    IF( lExecLock , ( lLock := .T. , lExclu    := .T. ) , aSZ5Keys := NIL ),;
                                            aSZ5Cols := SZ5->(;
                                                                GdBuildCols(    @aSZ5Header        ,;    //01 -> Array com os Campos do Cabecalho da GetDados
                                                                                @nSZ5Usado        ,;    //02 -> Numero de Campos em Uso
                                                                                @aSZ5VirtEn        ,;    //03 -> [@]Array com os Campos Virtuais
                                                                                @aSZ5VisuEn        ,;    //04 -> [@]Array com os Campos Visuais
                                                                                "SZ5"            ,;    //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
                                                                                aSZ5NotFields    ,;    //06 -> Opcional, Campos que nao Deverao constar no aHeader
                                                                                @aSZ5Recnos        ,;    //07 -> [@]Array unidimensional contendo os Recnos
                                                                                "SZ5"               ,;    //08 -> Alias do Arquivo Pai
                                                                                NIL                ,;    //09 -> Chave para o Posicionamento no Alias Filho
                                                                                NIL                ,;    //10 -> Bloco para condicao de Loop While
                                                                                NIL                ,;    //11 -> Bloco para Skip no Loop While
                                                                                NIL                ,;    //12 -> Se Havera o Elemento de Delecao no aCols 
                                                                                NIL                ,;    //13 -> Se Sera considerado o Inicializador Padrao
                                                                                NIL                ,;    //14 -> Opcional, Carregar Todos os Campos
                                                                                NIL                ,;    //15 -> Opcional, Nao Carregar os Campos Virtuais
                                                                                NIL                ,;    //16 -> Opcional, Utilizacao de Query para Selecao de Dados
                                                                                NIL                ,;    //17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
                                                                                NIL                ,;    //18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
                                                                                NIL                ,;    //19 -> Carregar Coluna Fantasma
                                                                                NIL                ,;    //20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                                                                NIL                ,;    //21 -> Verifica se Deve Checar se o campo eh usado
                                                                                NIL                ,;    //22 -> Verifica se Deve Checar o nivel do usuario
                                                                                NIL                ,;    //23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
                                                                                @aSZ5Keys        ,;    //24 -> [@]Array que contera as chaves conforme recnos
                                                                                @lLock            ,;    //25 -> [@]Se devera efetuar o Lock dos Registros
                                                                                @lExclu             ;    //26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
                                                                            );
                                                              ),;
                                            IF( lExecLock , ( lLock .and. lExclu ) , .T. );
                              } 
        IF !( lLocks := WhileNoLock( "SZ5" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZ5 ) )
            BREAK
        EndIF
        cFilSZ5            := SZ5->Z5_FILIAL
        cZ5Codigo        := SZ5->Z5_CODIGO
        cZ5KeySeek        := ( cFilSZ5 + cZ5Codigo )

        SZ5->( dbSetOrder( nSZ5Order ) )
        IF SZ5->( !dbSeek( cZ5KeySeek , .F. ) )
            nOpc        := 3
            aRotSetOpc( cAlias , @nReg , @nOpc )
            aSvSZ5Cols    := {}
        Else
            aSvSZ5Cols    := aClone( aSZ5Cols )
        EndIF

        SZ5->( RestArea( aAreaSZ5 ) )

        lExecLock    := ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
        lExcGeraLog    := .F.
        nOpcNewGd    := IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE    )

        For nLoop := 1 To nSZ5Usado
            aAdd( aSZ5Fields , aSZ5Header[ nLoop , 02 ] )
            StaticCall( NDJLIB001 , SetMemVar , aSZ5Header[ nLoop , 02 ] , aSZ5Cols[ 01 , nLoop ] , .T. )
        Next nLoop
        
        IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
    
            nLoops := Len( aSZ5VisuEn )
            For nLoop := 1 To nLoops
                aAdd( aSZ5NaoAlt , aSZ5VisuEn[ nLoop ] )
            Next nLoop
            IF ( nOpc == 4 )
                aAdd( aSZ5NaoAlt , "Z5_CODIGO" )
            EndIF
            nLoops := Len( aSZ5Fields )
            For nLoop := 1 To nLoops
                IF ( aScan( aSZ5NaoAlt , { |cNaoA| cNaoA == aSZ5Fields[ nLoop ] } ) == 0 )
                    aAdd( aSZ5Altera , aSZ5Fields[ nLoop ] )
                EndIF
            Next nLoop
        
        EndIF

        GetSCNumItem( @cNumSC , @cItemSC , @cSeqItem )

        StaticCall( NDJLIB004 , SetPublic , "cA110Num" , cNumSC )

        cZ5KeySeek    += cNumSC
        cZ5KeySeek    += cItemSC
        cZ5KeySeek    += cSeqItem

        cFilSZ4        := xFilial( "SZ4" , cFilSZ5 )

        aAdd( aSZ4NotFields , "Z4_FILIAL"  )
        aAdd( aSZ4NotFields , "Z4_CODIGO"    )
        #IFDEF TOP
            aSZ4Query        := Array( 11 )
            aSZ4Query[01]    := "    D_E_L_E_T_<>'*' "
            aSZ4Query[02]    := " AND "
            aSZ4Query[03]    := "    Z4_FILIAL='"+cFilSZ4+"'"
            aSZ4Query[04]    := " AND "
            aSZ4Query[05]    := "    Z4_CODIGO='"+cZ5Codigo+"'"
            aSZ4Query[06]    := " AND "
            aSZ4Query[07]    := "    Z4_NUMSC='"+cNumSC+"'"
            aSZ4Query[08]    := " AND "
            aSZ4Query[09]    := "    Z4_ITEMSC='"+cItemSC+"'"
            aSZ4Query[10]    := " AND "
            aSZ4Query[11]    := "    Z4_SECITEM='"+cSeqItem+"'"
        #ENDIF
        IF ( nOpc == 3  ) //Inclusao
            PutFileInEof( "SZ4" )
        EndIF
        bGetSZ4    := { |lLock,lExclu|    IF( lExecLock , ( lLock := .T. , lExclu := .T. ) , aSZ4Keys := NIL ),;
                                         aSZ4Cols := SZ4->(;
                                                        GdBuildCols(    @aSZ4Header        ,;    //01 -> Array com os Campos do Cabecalho da GetDados
                                                                        @nSZ4Usado        ,;    //02 -> Numero de Campos em Uso
                                                                        @aSZ4VirtGd        ,;    //03 -> [@]Array com os Campos Virtuais
                                                                        @aSZ4VisuGd        ,;    //04 -> [@]Array com os Campos Visuais
                                                                        "SZ4"            ,;    //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
                                                                        aSZ4NotFields    ,;    //06 -> Opcional, Campos que nao Deverao constar no aHeader
                                                                        @aSZ4Recnos        ,;    //07 -> [@]Array unidimensional contendo os Recnos
                                                                        "SZ5"               ,;    //08 -> Alias do Arquivo Pai
                                                                        cZ5KeySeek        ,;    //09 -> Chave para o Posicionamento no Alias Filho
                                                                        NIL                ,;    //10 -> Bloco para condicao de Loop While
                                                                        NIL                ,;    //11 -> Bloco para Skip no Loop While
                                                                        NIL                ,;    //12 -> Se Havera o Elemento de Delecao no aCols 
                                                                        NIL                ,;    //13 -> Se Sera considerado o Inicializador Padrao
                                                                        NIL                ,;    //14 -> Opcional, Carregar Todos os Campos
                                                                        NIL                ,;    //15 -> Opcional, Nao Carregar os Campos Virtuais
                                                                        aSZ4Query        ,;    //16 -> Opcional, Utilizacao de Query para Selecao de Dados
                                                                        .F.                ,;    //17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
                                                                        .F.                ,;    //18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
                                                                        Altera            ,;    //19 -> Carregar Coluna Fantasma
                                                                        NIL                ,;    //20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                                                        NIL                ,;    //21 -> Verifica se Deve Checar se o campo eh usado
                                                                        NIL                ,;    //22 -> Verifica se Deve Checar o nivel do usuario
                                                                        NIL                ,;    //23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
                                                                        @aSZ4Keys        ,;    //24 -> [@]Array que contera as chaves conforme recnos
                                                                        @lLock            ,;    //25 -> [@]Se devera efetuar o Lock dos Registros
                                                                        @lExclu            ,;    //26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
                                                                        nSZ4MaxLocks    ,;    //27 -> Numero maximo de Locks a ser efetuado
                                                                        Altera             ;    //28 -> Utiliza Numeracao na GhostCol
                                                                    );
                                                          ),;
                                        IF( lExecLock , ( lLock .and. lExclu ) , .T. );
                      }
        IF !( lLocks := WhileNoLock( "SZ4" , NIL , NIL , 1 , 1 , .T. , nSZ4MaxLocks , 5 , bGetSZ4 ) )
            BREAK
        EndIF
        CursorWait()
    
        IF ( Len( aSZ4Cols ) == 1 )
            IF Empty( GdFieldGet( "Z4_SECITEM" , 1, .F. , aSZ4Header , aSZ4Cols ) )
                GdFieldPut( "Z4_SECITEM" , StrZero( 1 , GetSx3Cache( "Z4_SECITEM" , "X3_TAMANHO" ) ) , 1 , aSZ4Header , aSZ4Cols , .F. )
            EndIF
        EndIF
        IF ( ( nSZ4GhostCol := GdFieldPos( "GHOSTCOL" , aSZ4Header ) ) > 0 )
            bSZ4Sort := { |x,y| ( x[ nSZ4GhostCol ] < y[ nSZ4GhostCol ] ) }
        EndIF
    
        aSvSZ4Cols    := aClone( aSZ4Cols )
        For nLoop := 1    To nSZ4Usado
            StaticCall( NDJLIB001 , SetMemVar , aSZ4Header[ nLoop , 02 ] , GetValType( aSZ4Header[ nLoop , 08 ] , aSZ4Header[ nLoop , 04 ] ) , .T. )
            IF (;
                    ( aScan( aSZ4VirtGd        , aSZ4Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ4VisuGd        , aSZ4Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ4NotFields    , aSZ4Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ4GdNaoAlt    , aSZ4Header[ nLoop , 02 ] ) == 0 )        ;
                  )
                aAdd( aSZ4GdAltera , aSZ4Header[ nLoop , 02 ] )
            EndIF               
        Next nLoop

        IF ( nOpc == 5 ) 
            IF !( ApdChkDel( cAlias , nReg , nOpc , cZ5Codigo , .F. , @aLog , @aLogTitle , { "SZ4" } ) )
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
                    //"A chave a ser excluida estï¿½ sendo utilizada."
                    //"Atï¿½ que as referï¿½ncias a ela sejam eliminadas a mesma nï¿½o pode ser excluida."
                    MsgInfo( OemToAnsi( STR0015 + CRLF + STR0016 ) , cCadastro + " - " + OemToAnsi( cTitLog ) )
                EndIF
                BREAK
            EndIF
            CursorWait()
        EndIF
    
        DEFAULT lDlgPadSiga    := .F.
        aAdvSize        := MsAdvSize( NIL , lDlgPadSiga )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aAdd( aObjCoords , { 000 , 025 , .T. , .F. } )
        aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
        aObjSize        := MsObjSize( aInfoAdvSize , aObjCoords )
    
        bGdSZ4Seek := { ||    GdSZ4Seek( oGdSZ4 )                ,;
                            SetKey( VK_F4 , bGdSZ4Seek )     ;
                   }
        aAdd(;
                aButtons    ,;
                                {;
                                    "PMSPESQ",;
                                       bGdSZ4Seek,;
                                          OemToAnsi( STR0001 + "...<F4>"  ),;    //"Pesquisar"
                                          OemToAnsi( STR0001 );                //"Pesquisar"
                                   };
             )
    
        bSet15        := { || IF(; 
                                    (;
                                        ( nOpc == 3 );    //Inclusao
                                        .or.;
                                        ( nOpc == 4 );    //Alteracao
                                    );                    
                                    .and.;
                                    NDJA002TEncOk( nOpc , oEnSZ5 );                            //Valida Todos os Campos da Enchoice
                                    .and.;
                                    oGdSZ4:TudoOk(),;                                        //Valida as Informacoes da GetDados
                                    (;
                                        nOpcAlt     := 1 ,;
                                        aSZ4Cols    := oGdSZ4:aCols,;                        //Redireciona o Ponteiro do aSZ4Cols
                                        RestKeys( aSvKeys , .T. ),;
                                        oDlg:End();
                                     ),;
                                     IF(; 
                                         (;
                                             ( nOpc == 3 );    //Inclusao
                                             .or.;
                                             ( nOpc == 4 );  //Alteracao
                                         ) ,;                
                                             (;
                                                 nOpcAlt := 0 ,;
                                                 .F.;
                                              ),;    
                                        (;
                                            nOpcAlt := IF( nOpc == 2 , 0 , 1 ) ,;        //Visualizacao ou Exclusao
                                            RestKeys( aSvKeys , .T. ),;
                                            oDlg:End();
                                         );
                                       );
                               );
                         }
        bSet24        := { || ( nOpcAlt := 0 , RestKeys( aSvKeys , .T. ) , oDlg:End() ) }
    
        bDialogInit := { ||;
                                EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
                                SetKey( VK_F4 , bGdSZ4Seek  ),;
                        }
    
        DEFINE MSDIALOG oDlg TITLE OemToAnsi( STR0006 ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDEFAULT() PIXEL

            @ 000,000 MSPANEL oPanel OF oDlg
            oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

            oEnSZ5    := MsmGet():New(    cAlias        ,;
                                        nReg        ,;
                                        nOpc        ,;
                                        NIL            ,;
                                        NIL            ,;
                                        NIL            ,;
                                        aSZ5Fields    ,;
                                        aObjSize[1]    ,;
                                        aSZ5Altera    ,;
                                        NIL            ,;
                                        NIL            ,;
                                        NIL            ,;
                                        oPanel        ,;
                                        NIL            ,;
                                        .F.            ,;
                                        NIL            ,;
                                        .F.             ;
                                    )

            oGdSZ4    := MsNewGetDados():New(    aObjSize[2,1]    ,;
                                            aObjSize[2,2]    ,;
                                            aObjSize[2,3]    ,;
                                            aObjSize[2,4]    ,;
                                            nOpcNewGd        ,;
                                            bSZ4LinOk        ,;
                                            bSZ4TudOk        ,;
                                            ""                ,;
                                            aSZ4GdAltera    ,;
                                            0                ,;
                                            1                ,; 
                                            NIL                ,;
                                            NIL                ,;
                                            bSZ4GdDelOk        ,;
                                            oPanel            ,;
                                            aSZ4Header        ,;
                                            aSZ4Cols         ;
                                         )

            oGdSZ4:SetEditLine( .F. )

            AlignObject( oPanel , { oEnSZ5:oBox , oGdSZ4:oBrowse } , 1 , NIL , { 60 } ); 

        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
    
        CursorWait()
    
        IF( nOpcAlt == 1 )
             IF ( nOpc != 2 )
                MsAguarde(;
                            { ||;
                                    aSort( aSZ4Cols , NIL , NIL , bSZ4Sort ),;    //Sorteia as Informacoes do SZ4 para Comparacao Antes da Gravacao
                                    NDJA002Grava(;
                                                    nOpc        ,;    //Opcao de Acordo com aRotina
                                                     nReg        ,;    //Numero do Registro do Arquivo Pai ( SZ5 )
                                                     aSZ5Header    ,;    //Campos do Arquivo Pai ( SZ5 )
                                                     aSZ5VirtEn    ,;    //Campos Virtuais do Arquivo Pai ( SZ5 )
                                                     aSZ5Cols    ,;    //Conteudo Atual dos Campos do Arquivo Pai ( SZ5 )
                                                     aSvSZ5Cols    ,;    //Conteudo Anterior dos Campos do Arquivo Pai ( SZ5 )
                                                     aSZ4Header    ,;    //Campos do Arquivo Filho ( SZ4 )
                                                     aSZ4Cols    ,;    //Itens Atual do Arquivo Filho ( SZ4 )
                                                     aSvSZ4Cols    ,;    //Itens Anterior do Arquivo Filho ( SZ4 )
                                                     aSZ4VirtGd    ,;    //Campos Virtuais do Arquivo Filho ( SZ4 )
                                                     aSZ4Recnos     ;    //Recnos do Arquivo Filho ( SZ4 )
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

    lFreeLocks    := ( StaticCall( NDJLIB003 , IFreeLocks , "SZ5" ) .and. StaticCall( NDJLIB003 , IFreeLocks , "SZ4" ) )

    WhileNoLock( "SZ5" , NIL , NIL , 1 , 1 , .T. , 100 , 5 , bGetSZ5 )
    WhileNoLock( "SZ4" , NIL , NIL , 1 , 1 , .T. , 100 , 5 , bGetSZ4 )

    IF ( lFreeLocks )
        aAdd( aFreeLocks , { "SZ5" , aSZ5Recnos , aSZ5Keys } )
        aAdd( aFreeLocks , { "SZ4" , aSZ4Recnos , aSZ4Keys } )
        StaticCall( NDJLIB003 , _FreeLocks , @aFreeLocks )
    Else
        StaticCall( NDJLIB003 , SetFreeLock , "SZ5" , aSZ5Recnos , aSZ5Keys )
        StaticCall( NDJLIB003 , SetFreeLock , "SZ4" , aSZ4Recnos , aSZ4Keys )
    EndIF

    cKTTS    := StaticCall( NDJLIB001 , GetMemVar , "Z5_CODIGO" )
    aEval( aSZ5Recnos , { |nRecno| SZ4SZ5TTS( @cKTTS , @nRecno ) } )

    RestArea( aArea )

    RestKeys( aSvKeys , .T. )

    CursorArrow()

Return( nOpcAlt )

/*/
    Function:    SZ4SZ5TTS
    Autor:        Marinaldo de Jesus
    Data:        28/08/2011
    Descricao:    Armazena Registros da SZ5 para Commit
    Sintaxe:    StaticCall( U_NDJA002 , SZ4SZ5TTS , cKTTS , nRecno )
/*/
Static Function SZ4SZ5TTS( cKTTS , nRecno )

    Local nATTTS

    DEFAULT cKTTS    := SZ5->Z5_CODIGO
    DEFAULT nRecno    := SZ5->( Recno() )

    nATTTS    := aScan( __aTTS , { |aElem| ( aElem[ 1 ] == cKTTS ) } )

    IF ( nATTTS == 0 )
        aAdd( __aTTS    , { cKTTS , Array( 0 ) } )
        ++__nTTS
        nATTTS := __nTTS
    EndIF
    aAdd( __aTTS[ nATTTS ][ 2 ] , nRecno )

    IF SZ5->( !Eof() .and. !Bof() )
        SZ5->( MsGoto( nRecno ) )
        StaticCall( NDJLIB003 , LockSoft , "SZ5" )
    EndIF    

Return( NIL )

/*/
    Function:    SZ4SZ5Commit
    Autor:        Marinaldo de Jesus
    Data:        28/08/2011
    Descricao:    Efetiva o Link da SC7/SD1/CNB/CNE com SZ4 e SZ5
    Sintaxe:    StaticCall( U_NDJA002 , SZ4SZ5Commit )
/*/
Static Function SZ4SZ5Commit()
    Local lSZ4ChkLnk    := SZ4ChkLnk( .T. )
    While ( __nTTS > 0 )
        ChkSZ5ToSD1( __aTTS[ __nTTS ][ 2 ] , .F. )
        aDel( __aTTS , __nTTS )
        aSize( __aTTS , --__nTTS )
    End While
    SZ4ChkLnk( lSZ4ChkLnk )
Return( NIL )

/*/
    Function:    GdSZ4Seek
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Efetuar Pesquisa na GetDados
    Sintaxe:    GdSZ4Seek( oGdSZ4 )
/*/
Static Function GdSZ4Seek( oGdSZ4 )

    Local aSvKeys        := GetKeys()
    Local cProcName3    := Upper( AllTrim( ProcName( 3 ) ) )
    Local cProcName5    := Upper( AllTrim( ProcName( 5 ) ) )
    
    BEGIN SEQUENCE
    
        IF !( "NDJA002MNT" $ ( cProcName3 + cProcName5  ) )
            BREAK
        EndIF
        
        GdSeek( oGdSZ4 , OemToAnsi( STR0001 ) )    //"Pesquisar"
    
    END SEQUENCE    
    
    RestKeys( aSvKeys , .T. )

Return( NIL )

/*/
    Function:    NDJA002TEncOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Tudo Ok para a Enchoice
    Sintaxe:    StaticCall(U_NDJA002,NDJA002TEncOk,nOpc,oEnSZ5)
/*/
Static Function NDJA002TEncOk( nOpc , oEnSZ5 )

    Local lTudoOk := .T.
                    
    IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
        lTudoOk := EnchoTudOk( oEnSZ5 )
    EndIF
    
Return( lTudoOk )

/*/
    Function:    oGdSZ4LinOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Linha OK da GetDados
    Sintaxe:    StaticCall(U_NDJA002,oGdSZ4LinOk,oBrowse)
/*/
Static Function oGdSZ4LinOk( oBrowse )

    Local lLinOk          := .T.

    Local aCposKey
    
    CursorWait()
    
        BEGIN SEQUENCE

            IF !( GdDeleted() )

                aCposKey := GdObrigat( aHeader )
                IF !( lLinOk := GdNoEmpty( aCposKey ) )
                    BREAK
                EndIF

                aCposKey := GetArrUniqe( "SZ4" )
                IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
                    BREAK
                EndIF

                aCposKey := {;
                                    "Z4_CODIGO"     ,;
                                    "Z4_NUMSC"        ,;
                                    "Z4_ITEMSC"     ,;
                                    "Z4_XCLIORG"    ,;
                                    "Z4_XCLIINS"    ,;
                                    "Z4_XLOJAIN"    ,;
                                    "Z4_XRESPON"    ,;
                                    "Z4_XCONTAT"     ;
                            }
                IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
                    BREAK
                EndIF

            EndIF

        END SEQUENCE
        
        IF !( lLinOk )
            oBrowse:SetFocus()
        EndIF
    
        PutFileInEof( "SZ4" )
    
    CursorArrow()
    
Return( lLinOk )

/*/
    Function:    oGdSZ4TudOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Tudo Ok da GetDados
    Sintaxe:    StaticCall(U_NDJA002,oGdSZ4TudOk,oBrowse)
/*/
Static Function oGdSZ4TudOk( oBrowse )

    Local cMsgHelp

    Local lTudoOk     := .T.
    Local lZ4Quant    := StaticCall( NDJLIB001 , IsInGetDados , "Z4_QUANT" )

    Local nLoop
    Local nLoops
    Local nQuant
    Local nZ4Quant    := 0

    CursorWait()
    
        BEGIN SEQUENCE

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C7_QUANT" , __aHeader , __aCols , __nN );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C7_QUANT" ) );
                )
                DEFAULT nQuant := GdFieldGet( "C7_QUANT" , __nN , .F. , __aHeader , __aCols )
            ElseIF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_QUANT" , __aHeader , __aCols , __nN );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_QUANT" ) );
                )
                DEFAULT nQuant := GdFieldGet( "D1_QUANT" , __nN , .F. , __aHeader , __aCols )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
                DEFAULT nQuant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
            EndIF    

            Private n

            nLoops := Len( aCols )
            For nLoop := 1 To nLoops
                n := nLoop
                IF !( lTudoOk := oGdSZ4LinOk( oBrowse ) )
                    oBrowse:Refresh()
                    BREAK
                EndIF
                IF (;
                        ( lZ4Quant );
                        .and.;
                        !( GdDeleted() );
                    )    
                    nZ4Quant += GdFieldGet( "Z4_QUANT" )
                EndIF
            Next nLoop 

            IF ( lZ4Quant )
                cMsgHelp := STR0020 + CRLF //"A soma das Quantidades está ¥rrada" 
                cMsgHelp += STR0018 + Transform( nZ4Quant , GetSx3Cache( "Z4_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Informado: "
                cMsgHelp += STR0019 + Transform( nQuant   , GetSx3Cache( "Z4_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Disponí¶¥l: "
                lTudoOk := Z4QantVld( @nZ4Quant , .T. , cMsgHelp , .T. )
            EndIF
            
            IF !( lTudoOk )
                oBrowse:Refresh()
                BREAK
            EndIF

        END SEQUENCE

    CursorArrow()

Return( lTudoOk  )

/*/
    Function:    SZ4GdDelOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Validar a Delecao na GetDados
    Sintaxe:    StaticCall(U_NDJA002,SZ4GdDelOk,cAlias,nRecno,nOpc,cCodigo,nSZ4Order)
/*/
Static Function SZ4GdDelOk( cAlias , nRecno , nOpc , cCodigo , nSZ4Order )
         
    Local lDelOk         := .T.
    Local lStatusDel    := .F.
    
    Static lFirstDelOk
    Static lLstDelOk
    
    DEFAULT lFirstDelOk    := .T.
    DEFAULT lLstDelOk    := .T.
    
    BEGIN SEQUENCE
    
        //Quando for Visualizacao ou Exclusao Abandona
        IF (;
                ( nOpc == 2 ) .or. ;    //Visualizacao
                ( nOpc == 5 );            //Exclusao
            )
            BREAK
        EndIF
    
        //Apenas se for a primeira vez
        IF !( lFirstDelOk )
            lFirstDelOk    := .T.
            lDelOk         := lLstDelOk
            lLstDelOk    := .T.
            BREAK
        EndIF
    
        lStatusDel    := !( GdDeleted() ) //Inverte o Estado

        IF ( lStatusDel )    //Deletar
            IF !( nOpc == 3  )    //Quando nao for Inclusao
                IF !( lDelOk := .T. )
                    CursorArrow()
                    //"A chave a ser excluida estï¿½ sendo utilizada."
                    //"Atï¿½ que as referï¿½ncias a ela sejam eliminadas a mesma nï¿½o pode ser excluida."
                    MsgInfo( OemToAnsi( STR0008 + CRLF + STR0009 ) , cCadastro )
                    lLstDelOk := lDelOk
                    //Ja Passou pela funcao
                    lFirstDelOk := .F.
                    BREAK
                EndIF
            EndIF    
        Else                //Restaurar
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
    Function:    NDJA002Grava
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Gravar as informacoes da SZ4 e SZ5
    Sintaxe:    StaticCall(U_NDJA002,NDJA002Grava)
/*/
Static Function NDJA002Grava(    nOpc        ,;    //Opcao de Acordo com aRotina
                                 nReg        ,;    //Numero do Registro do Arquivo Pai ( SZ5 )
                                 aSZ5Header    ,;    //Campos do Arquivo Pai ( SZ5 )
                                 aSZ5VirtEn    ,;    //Campos Virtuais do Arquivo Pai ( SZ5 )
                                 aSZ5Cols    ,;    //Conteudo Atual dos Campos do Arquivo Pai ( SZ5 )
                                 aSvSZ5Cols    ,;    //Conteudo Anterior dos Campos do Arquivo Pai ( SZ5 )
                                 aSZ4Header    ,;    //Campos do Arquivo Filho ( SZ4 )
                                 aSZ4Cols    ,;    //Itens Atual do Arquivo Filho ( SZ4 )
                                 aSvSZ4Cols    ,;    //Itens Anterior do Arquivo Filho ( SZ4 )
                                 aSZ4VirtGd    ,;    //Campos Virtuais do Arquivo Filho ( SZ4 )
                                 aSZ4Recnos     ;    //Recnos do Arquivo Filho ( SZ4 )
                              )

    Local aMestre        := GdPutIStrMestre( 01 )
    Local aItens        := {}

    Local cOpcao        := IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )

    Local lAllModif        := .F.
    Local lSZ5Modif        := .F.
    Local lSZ4Modif        := .F.
    Local lSZ4Delet        := .F.
    
    Local aSZ4ColDel
    Local aSZ4RecDel
    Local nLoop
    Local nLoops
    Local nItens
    
    CursorWait()
    
        IF ( cOpcao <> "DELETE" )
            IF ( lSZ4Modif := !ArrayCompare( aSZ4Cols , aSvSZ4Cols ) )
                GdSuperDel( @aSZ4Header , @aSZ4Cols , NIL , .T. , GdGetBlock( "SZ4" , @aSZ4Header , .F. ) ) 
                lSZ4Delet := GdSplitDel( @aSZ4Header , @aSZ4Cols , @aSZ4Recnos , @aSZ4ColDel , @aSZ4RecDel  )
                IF ( lSZ4Delet )
                    SZ4->( DelRecnos( "SZ4" , @aSZ4RecDel ) )
                    lSZ4Delet    := .F.
                EndIF
                SZ4->( DelRecnos( "SZ4" , @aSZ4Recnos ) )
            EndIF
        Else
            lSZ4Modif := .T.
            lSZ5Modif := .T.
        EndIF
    
        IF ( lSZ4Modif )

            aAdd( aItens , GdPutIStrItens() )
            nItens := Len( aItens )
            aItens[ nItens , 01 ] := "SZ4"
            aItens[ nItens , 02 ] := {;
                                        { "FILIAL" , xFilial( "SZ4" , xFilial( "SZ5" ) ) },;
                                        { "CODIGO" , StaticCall( NDJLIB001 , GetMemVar , "Z5_CODIGO" ) };
                                      }
            aItens[ nItens , 03 ] := aClone( aSZ4Header )
            aItens[ nItens , 04 ] := aClone( aSZ4Cols   )
            aItens[ nItens , 05 ] := aClone( aSZ4VirtGd )
            aItens[ nItens , 06 ] := aClone( aSZ4Recnos )
    
        EndIF        
    
        IF !( lSZ5Modif )
            nLoops := Len( aSZ5Header )
            For nLoop := 1 To nLoops
                aSZ5Cols[ 01 , nLoop ] := StaticCall( NDJLIB001 , GetMemVar ,  aSZ5Header[ nLoop , 02 ] )
            Next nLoop
            lSZ5Modif := !( ArrayCompare( aSZ5Cols , aSvSZ5Cols ) )
        EndIF
    
         lAllModif := ( ( lSZ4Modif ) .or. ( lSZ5Modif ) )
    
        IF ( lAllModif )
    
            aMestre[ 01 , 01 ]    := "SZ5"
            aMestre[ 01 , 02 ]    := nReg
            aMestre[ 01 , 03 ]    := lSZ5Modif
            aMestre[ 01 , 04 ]    := aClone( aSZ5Header )
            aMestre[ 01 , 05 ]    := aClone( aSZ5VirtEn )
            aMestre[ 01 , 06 ]    := {}
            aMestre[ 01 , 07 ]    := aClone( aItens )
        
            GdPutInfoData( aMestre , cOpcao , .F. , .F. )
    
            While ( GetSX8Len() > nGetSX8Len )
                ConfirmSX8()
            End While

             SZ4ChkLnk( .F. )

        EndIF

        nReg            := SZ5->( Recno() )

        StaticCall( NDJLIB003 , LockSoft , "SZ5" )

        StaticCall( NDJLIB004 , SetPublic , "__nSZ5LstRec" , nReg )

        lUseD1ToZ5( xFilial( "SZ5" ) , StaticCall( NDJLIB001 , GetMemVar , "Z5_CODIGO" ) , .F. , .F. )

    CursorArrow()

Return( NIL )

/*/
    Funcao:    RpcSZ4Lnk()
    Autor:    Marinaldo de Jesus
    Data:    11/01/2011
    Uso:    Chamada Via RPC da Verificacao do "Link" de Bloqueios por Valor
    Sintaxe: 1 - RpcSZ4Lnk( { cEmp , cFil } )     //Chamada Direta
             2 - RpcSZ4Lnk( cEmp , cFil )         //Chamada Via Agendamento
/*/
User Function RpcSZ4Lnk( aParameters )

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
    
        DEFAULT cEmp    := "01"
        DEFAULT cFil    := "01"
        
        PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil )
        
            SZ4ChkLnk( .T. )
            ChkSZ5ToSD1() //Verifica e Confirma os Vinculos de Destinos com a SC7, SD1 e CNB

        RESET ENVIRONMENT

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( NIL )

/*/                          
    Funcao:        ChkSZ5ToSD1
    Data:        07/01/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Verificar se existe Itens de Enderecamento sem Vinculo com a SD1 e elimina-los
    Sintax:        StaticCall(U_NDJA002,ChkSZ5ToSD1)
/*/
Static Function ChkSZ5ToSD1( aSZ5Recnos , lLoadRecnos )

    Local aArea            := GetArea()
    Local aAreaSD1        := SD1->( GetArea() )

    Local cXSZ4Cod
    Local cSD1Filial
    Local cSZ4Filial
    Local cSZ5Filial
    Local cCNBFilial
    Local cSC7Filial
    Local cCNEFilial
    
    Local cSD1KeySeek
    Local cSZ4KeySeek
    Local cCNBKeySeek
    Local cSC7KeySeek
    Local cCNEKeySeek
    
    Local nSD1Order
    Local nSZ4Order
    Local nSZ5Order
    Local nCNBOrder
    Local nSC7Order
    Local nCNEOrder

    Local nRecno
    Local nRecnos

    BEGIN SEQUENCE

        IF !( SZ4ChkLnk() )
            BREAK
        EndIF

        cSD1Filial        := xFilial( "SD1" )
        cSZ4Filial        := xFilial( "SZ4" )
        cSZ5Filial        := xFilial( "SZ5" )
        cCNBFilial        := xFilial( "CNB" )
        cSC7Filial        := xFilial( "SC7" )
        cCNEFilial        := xFilial( "CNE" )
        
        nSD1Order        := RetOrder( "SD1" , "D1_FILIAL+D1_XSZ2COD+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN" )
        nSZ4Order        := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
        nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" ) 
        nCNBOrder        := RetOrder( "CNB" , "CNB_FILIAL+CNB_XSZ2CO+CNB_XNUMSC+CNB_XITMSC+CNB_XSEQPC" )
        nSC7Order        := RetOrder( "SC7" , "C7_FILIAL+C7_XSZ2COD+C7_NUMSC+C7_ITEMSC+C7_SEQUEN" )
        nCNEOrder        := RetOrder( "CNE" , "CNE_FILIAL+CNE_XSZ2CO+CNE_XNUMSC+CNE_XITMSC+CNE_XSEQPC" )
    
        SD1->( dbSetOrder( nSD1Order ) )
        SZ4->( dbSetOrder( nSZ4Order ) )
        SZ5->( dbSetOrder( nSZ5Order ) )
        CNB->( dbSetOrder( nCNBOrder ) )
        SC7->( dbSetOrder( nSC7Order ) )
        CNE->( dbSetOrder( nCNEOrder ) )

        DEFAULT lLoadRecnos    := .T.
        IF Empty( aSZ5Recnos )
            IF ( lLoadRecnos )
                aSZ5Recnos    := {}
                SZ5->( dbGotop() )
                While SZ5->( !Eof() )
                    SZ5->( aAdd( aSZ5Recnos , Recno() ) )
                    SZ5->( dbSkip() )
                End While 
            Else
                BREAK
            EndIF
        EndIF

        nRecnos    := Len( aSZ5Recnos )
        For nRecno := 1 To nRecnos

            SZ5->( dbGoto( aSZ5Recnos[ nRecno ] ) )
            IF SZ5->( Eof() .or. Bof() )
                Loop
            EndIF

            cXSZ4Cod    := SZ5->Z5_CODIGO
            
            IF !( lUseD1ToZ5( @cSZ5Filial , @cXSZ4Cod , .F. , .T. ) )
                SZ5->( dbSkip() )
                Loop
            EndIF

            IF SZ5->( !RecLock( "SZ5" , .F. ) )
                SZ5->( dbSkip() )
                Loop
            EndIF

            cSD1KeySeek := cSD1Filial
            cSD1KeySeek += cXSZ4Cod
            
            cCNBKeySeek    := cCNBFilial
            cCNBKeySeek    += cXSZ4Cod
    
            cSC7KeySeek    := cSC7Filial
            cSC7KeySeek    += cXSZ4Cod
    
            cCNEKeySeek    := cCNEFilial
            cCNEKeySeek    += cXSZ4Cod
            
            IF (;
                    SD1->( !dbSeek( cSD1KeySeek , .F. ) );
                    .and.;
                    CNB->( !dbSeek( cCNBKeySeek , .F. ) );
                    .and.;
                    SC7->( !dbSeek( cSC7KeySeek , .F. ) );
                    .and.;
                    CNE->( !dbSeek( cCNEKeySeek , .F. ) );
                )    
            
                IF SZ5->( RecLock( "SZ5" , .F. ) )
                    cSZ4KeySeek    := cSZ4Filial
                    cSZ4KeySeek    += cXSZ4Cod
                    IF SZ4->( dbSeek( cSZ4KeySeek , .F. ) )
                        While SZ4->( !Eof() .and. Z4_FILIAL+Z4_CODIGO == cSZ4KeySeek )
                            IF SZ4->( RecLock( "SZ4" , .F. ) )
                                SZ4->( dbDelete() )
                                SZ4->( MsUnLock() )
                                SZ4->( dbSkip() )
                            EndIF
                        End While
                    EndIF
                    SZ5->( dbDelete() )
                    SZ5->( MsUnLock() )
                EndIF
            
            Else
                
                cSZ4KeySeek    := cSZ4Filial
                cSZ4KeySeek    += cXSZ4Cod
                
                IF SZ4->( dbSeek( cSZ4KeySeek , .F. ) )
                    
                    While SZ4->( !Eof() .and. Z4_FILIAL+Z4_CODIGO == cSZ4KeySeek )
                        
                        cSD1KeySeek := cSD1Filial
                        cSD1KeySeek += cXSZ4Cod
                        cSD1KeySeek += SZ4->Z4_NUMSC
                        cSD1KeySeek += SZ4->Z4_ITEMSC
                        cSD1KeySeek += SZ4->Z4_SECITEM
    
                        cCNBKeySeek    := cCNBFilial
                        cCNBKeySeek += cXSZ4Cod
                        cCNBKeySeek    += SZ4->Z4_NUMSC
                        cCNBKeySeek += SZ4->Z4_ITEMSC
                        cCNBKeySeek += SZ4->Z4_SECITEM
    
                        cSC7KeySeek    := cSC7Filial
                        cSC7KeySeek += cXSZ4Cod
                        cSC7KeySeek    += SZ4->Z4_NUMSC
                        cSC7KeySeek += SZ4->Z4_ITEMSC
                        cSC7KeySeek += SZ4->Z4_SECITEM
    
                        cCNEKeySeek    := cCNEFilial
                        cCNEKeySeek += cXSZ4Cod
                        cCNEKeySeek    += SZ4->Z4_NUMSC
                        cCNEKeySeek += SZ4->Z4_ITEMSC
                        cCNEKeySeek += SZ4->Z4_SECITEM
    
                        IF (;
                                SD1->( !dbSeek( cSD1KeySeek , .F. ) );
                                .and.;
                                CNB->( !dbSeek( cCNBKeySeek , .F. ) );
                                .and.;
                                SC7->( !dbSeek( cSC7KeySeek , .F. ) );
                                .and.;
                                CNE->( !dbSeek( cCNEKeySeek , .F. ) );
                            )    
                            IF SZ4->( RecLock( "SZ4" , .F. ) )
                                SZ4->( dbDelete() )
                                SZ4->( MsUnLock() )
                            EndIF
                        ElseIF !( SZ4->Z4_LINKED )
                            IF SZ4->( RecLock( "SZ4" , .F. ) )
                                SZ4->Z4_LINKED := .T.
                                SZ4->( MsUnLock() )
                            EndIF
                        EndIF
        
                        SZ4->( dbSkip() )
        
                    End While
        
                EndIF
        
            EndIF
        
            lUseD1ToZ5( @cSZ5Filial , @cXSZ4Cod , .T. , .T. )

            SZ5->( MsUnLock() )

        Next nRecno

    END SEQUENCE

    RestArea( aAreaSD1 )
    RestArea( aArea )

Return( NIL )

/*/
    Function:    SZ4ChkLnk
    Autor:        Marinaldo de Jesus
    Data:        24/01/2011
    Descricao:    Verificar os Links de Destinos na SZ3 e SZ4
    Sintaxe:    StaticCall(U_NDJA002,SZ4ChkLnk,lCheck)
/*/
Static Function SZ4ChkLnk( lCheck )

    Local lSZ4ChkLnk
    
    Static lStkSZ4Lnk
    
    DEFAULT lCheck         := .F.
    DEFAULT lStkSZ4Lnk    := .F.
    lSZ4ChkLnk            := lStkSZ4Lnk
    lStkSZ4Lnk             := lCheck

Return( lSZ4ChkLnk )

/*/
    Function:    lUseD1ToZ5
    Autor:        Marinaldo de Jesus
    Data:        07/01/2011
    Descricao:    Obter/Liberar a Reserva dos Links do SD1 com a SZ5
    Sintaxe:    StaticCall(U_NDJA002,lUseD1ToZ5)
/*/
Static Function lUseD1ToZ5( cFil , cZ5Codigo , lFreeMyIUse , lChkDel )
Return( lUseC7ToZ5( @cFil , @cZ5Codigo , @lFreeMyIUse , @lChkDel , "MyIUse_SZ5" , "MyIUse_SZ4" ) )

/*/
    Function:    lUseC7ToZ5
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Obter/Liberar a Reserva dos Links do SC7 com a SZ5
    Sintaxe:    StaticCall(U_NDJA002,lUseC7ToZ5)
/*/
Static Function lUseC7ToZ5( cFil , cZ5Codigo , lFreeMyIUse , lChkDel , cZ5KeyIUse , cZ4KeyIUse )

    Local aArea            := GetArea()
    
    Local cQuery        := ""
    Local cMyIUse        := ""
    Local cNextAlias    := GetNextAlias()
    
    Local lMyIUse        := .T.

    DEFAULT cFil        := xFilial( "SZ5" )

    BEGIN SEQUENCE

        DEFAULT lChkDel    := .F.

        cQuery    := "SELECT " + CRLF      
        cQuery    += "    SZ5.R_E_C_N_O_ " + CRLF
        cQuery    +=  "FROM " + CRLF
        cQuery    +=  "    " + RetSqlName( "SZ5" ) +  " SZ5 " + CRLF
        cQuery    +=  "WHERE " + CRLF
        IF !( lChkDel )
            cQuery    +=  "    SZ5.D_E_L_E_T_ <> '*' " + CRLF
            cQuery    +=  "AND" + CRLF
        EndIF    
        cQuery    +=  "    SZ5.Z5_FILIAL = '" + cFil + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    SZ5.Z5_CODIGO = '" + cZ5Codigo + "' " + CRLF
    
        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW
    
        IF ( cNextAlias )->( Eof() )
            ( cNextAlias )->( dbCloseArea() )
            BREAK
        EndIF

        DEFAULT cZ5KeyIUse    := "MyIUse_SZ5"

        While ( cNextAlias )->( !Eof() )

            cMyIUse    := ( cEmpAnt + cZ5KeyIUse + ( cNextAlias )->( AllTrim( StrZero( R_E_C_N_O_ ) ) ) )

            DEFAULT lFreeMyIUse    := .F.
            IF ( lFreeMyIUse )
                lMyIUse    := StaticCall( NDJLIB003 , ReleaseCode , cMyIUse )
            Else
                lMyIUse := StaticCall( NDJLIB003 , UseCode , cMyIUse )
            EndIF    

            IF !( lMyIUse )
                ( cNextAlias )->( dbCloseArea() )
                BREAK
            EndIF

            ( cNextAlias )->( dbSkip() )

        End While

        ( cNextAlias )->( dbCloseArea() )

        cQuery    := "SELECT " + CRLF      
        cQuery    += "    SZ4.R_E_C_N_O_ " + CRLF
        cQuery    +=  "FROM " + CRLF
        cQuery    +=  "    " + RetSqlName( "SZ4" ) +  " SZ4 " + CRLF
        cQuery    +=  "WHERE " + CRLF
        IF !( lChkDel )
            cQuery    +=  "    SZ4.D_E_L_E_T_ <> '*' " + CRLF
            cQuery    +=  "AND" + CRLF
        EndIF    
        cQuery    +=  "    SZ4.Z4_FILIAL = '" + cFil + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    SZ4.Z4_CODIGO = '" + cZ5Codigo + "' " + CRLF

        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

        IF ( cNextAlias )->( Eof() )
            BREAK
        EndIF

        DEFAULT cZ4KeyIUse    := "MyIUse_SZ4"
        While ( cNextAlias )->( !Eof())

            cMyIUse    := ( cEmpAnt + cZ4KeyIUse + ( cNextAlias )->( AllTrim( StrZero( R_E_C_N_O_ ) ) ) )

            IF ( lFreeMyIUse )
                lMyIUse := StaticCall( NDJLIB003 , ReleaseCode , cMyIUse )
            Else
                lMyIUse := StaticCall( NDJLIB003 , UseCode , cMyIUse )
            EndIF    
            
            IF !( lMyIUse )
                ( cNextAlias )->( dbCloseArea() )
                BREAK
            EndIF

            ( cNextAlias )->( dbSkip() )

        End While
    
        ( cNextAlias )->( dbCloseArea() )

    END SEQUENCE

    RestArea( aArea )

Return( lMyIUse )

/*/
    Function:    Z5CodigoVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Funcao para Validar o Conteudo do Campo Z5_CODIGO
    Sintaxe:    StaticCall(U_NDJA002,Z5CodigoVld)
/*/
Static Function Z5CodigoVld()

    Local cZ5Codigo        := StaticCall( NDJLIB001 , GetMemVar , "Z5_CODIGO" )
    Local lSZ5CodigoOk    := .T.
    
    BEGIN SEQUENCE
    
        IF !( lSZ5CodigoOk := Z5GetCodigo( @cZ5Codigo , .F. , .F. ) )
            BREAK
        EndIF
    
        StaticCall( NDJLIB001 , SetMemVar , "Z5_CODIGO" , cZ5Codigo )
    
    END SEQUENCE
    
Return( lSZ5CodigoOk )

/*/
    Function:    Z5GetCodigo
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Funcao para Validar o Conteudo do Campo Z5_CODIGO
    Sintaxe:    StaticCall(U_NDJA002,Z5GetCodigo)
/*/
Static Function Z5GetCodigo( cZ5Codigo , lExistChav , lShowHelp )
    Local bGetNumExc    := { || cZ5Codigo := __Soma1( cZ5Codigo ) }
    Local cSZ5Filial    := xFilial( "SZ5" )
    IF Empty( cZ5Codigo )
        cZ5Codigo := StaticCall( NDJLIB001 , QryMaxCod , "SZ5" , "Z5_CODIGO" , "SZ5.Z5_FILIAL='" + cSZ5Filial +"'" , .T. )
        IF Empty( cZ5Codigo )
            cZ5Codigo := Replicate( "0" , GetSx3Cache( "Z5_CODIGO" , "X3_TAMANHO" ) )
        EndIF
        cZ5Codigo := Eval( bGetNumExc )
    EndIF
    SetMaxCode( NDJ_MAX_CODE )
    StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
Return(;
            GetNrExclOk(    @cZ5Codigo                 ,;
                            "SZ5"                    ,;
                            "Z5_CODIGO"                ,;
                            "Z5_FILIAL+Z5_CODIGO"    ,;
                            bGetNumExc                ,;
                            lExistChav                ,;
                            lShowHelp                  ;
                        );
        )

/*/
    Function:    Z5CodigoInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo Z5_CODIGO
    Sintaxe:    StaticCall(U_NDJA002,Z5CodigoInit)
/*/
Static Function Z5CodigoInit()
    Local cZ5Codigo
    Z5GetCodigo( @cZ5Codigo , .F. , .F. )
Return( cZ5Codigo )

/*/
    Function:    Z5NumScInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo Z5_NUMSC
    Sintaxe:    StaticCall(U_NDJA002,Z5NumScInit)
/*/
Static Function Z5NumScInit()

    Local cSZ5NumSc

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_NUMSC" ) );
        )
        DEFAULT cSZ5NumSc    := GdFieldGet( "C7_NUMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XNUMSC" ) );
        )
        DEFAULT cSZ5NumSc    := GdFieldGet( "D1_XNUMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
        DEFAULT cSZ5NumSc    := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
    ElseIF ( Type( "cA110Num" ) == "C" )
        DEFAULT cSZ5NumSc    := cA110Num
    Else
        DEFAULT cSZ5NumSc    := Space( GetSX3Cache( "Z5_NUMSC" , "X3_TAMANHO" ) )
    EndIF

Return( cSZ5NumSc )

/*/
    Function:    Z4CodigoVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo Z4_CODIGO
    Sintaxe:    StaticCall(U_NDJA002,Z4CodigoVld)
/*/
Static Function Z4CodigoVld( cZ4Codigo , lShowHelp , cMsgHelp )

    Local lSZ4CodigoOK    := .T.
    
    Local nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )
    
    BEGIN SEQUENCE

        DEFAULT cZ4Codigo := StaticCall( NDJLIB001 , __FieldGet , "SZ4" , "Z4_CODIGO" )

        IF !( lSZ4CodigoOK := !Empty( cZ4Codigo ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "Z4_CODIGO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( Z4_CODIGO )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF
    
        IF !( lSZ4CodigoOK := ExistCpo("SZ5",cC1XSZ2Cod,nSZ5Order) )
            BREAK
        EndIF

    END SEQUENCE    
    
Return( lSZ4CodigoOK )

/*/
    Function:    Z4NumSCInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z4NumSC
    Sintaxe:    StaticCall(U_NDJA002,Z4NumSCInit)
/*/
Static Function Z4NumSCInit()

    Local cZ4NumSC

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_NUMSC" ) );
        )
        cZ4NumSC    := GdFieldGet( "C7_NUMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XNUMSC" ) );
        )
        cZ4NumSC    := GdFieldGet( "D1_XNUMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
        DEFAULT cZ4NumSC    := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
    ElseIF ( Type( "cA110Num" ) == "C" )
        DEFAULT cZ4NumSC    := cA110Num
    Else
        DEFAULT cZ4NumSC := Space( GetSX3Cache( "Z4_NUMSC" , "X3_TAMANHO" ) )
    EndIF

Return( cZ4NumSC )

/*/
    Function:    Z4NumSCInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z4ItemSC
    Sintaxe:    StaticCall(U_NDJA002,Z4ItemSCInit)
/*/
Static Function Z4ItemSCInit()

    Local cZ4ItemSC

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_ITEMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_ITEMSC" ) );
        )
        DEFAULT cZ4ItemSC := GdFieldGet( "C7_ITEMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XITEMSC" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XITEMSC" ) );
        )
        DEFAULT cZ4ItemSC := GdFieldGet( "D1_XITEMSC" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_ITEM" ) )
        DEFAULT cZ4ItemSC := StaticCall( NDJLIB001 , GetMemVar , "C1_ITEM" )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_ITEM" ) )
        DEFAULT cZ4ItemSC := StaticCall( NDJLIB001 , GetMemVar , "C1_ITEM" )
    Else
        DEFAULT cZ4ItemSC := Space( GetSX3Cache( "Z4_ITEMSC" , "X3_TAMANHO" ) )
    EndIF

Return( cZ4ItemSC )

/*/
    Function:    Z4SecItemInit
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descricao:    Inicializadora Padrao do Campo Z4_SECITEM
    Sintaxe:    StaticCall(U_NDJA002,Z4SecItemInit)
/*/
Static Function Z4SecItemInit()

    Local cZ4SecItem

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_SEQUEN" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_SEQUEN" ) );
        )
        DEFAULT cZ4SecItem := GdFieldGet( "C7_SEQUEN" , __nN , .F. , __aHeader , __aCols )
    ElseIF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_XSEQUEN" , __aHeader , __aCols , __nN );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XSEQUEN" ) );
            )
        DEFAULT cZ4SecItem := GdFieldGet( "D1_XSEQUEN" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_SEQUEN" ) )
        DEFAULT cZ4SecItem := StaticCall( NDJLIB001 , GetMemVar , "C1_SEQUEN" )
    Else
        DEFAULT cZ4SecItem := Space( GetSX3Cache( "Z4_SECITEM" , "X3_TAMANHO" ) )
    EndIF

Return( cZ4SecItem )

/*/
    Function:    Z4QantVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z4Quant
    Sintaxe:    StaticCall(U_NDJA002,Z4QantVld)
/*/
Static Function Z4QantVld( nZ4Quant , lShowHelp , cMsgHelp , lTudoOk )

    Local lZ4QuantOk    := .T.

    Local nQuant

    BEGIN SEQUENCE

        DEFAULT nZ4Quant := StaticCall( NDJLIB001 , __FieldGet , "SZ4" , "Z4_QUANT" )

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_QUANT" , __aHeader , __aCols , __nN );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C7_QUANT" ) );
            )
            DEFAULT nQuant := GdFieldGet( "C7_QUANT" , __nN , .F. , __aHeader , __aCols )
        ElseIF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_QUANT" , __aHeader , __aCols , __nN );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "D1_QUANT" ) );
            )
            DEFAULT nQuant := GdFieldGet( "D1_QUANT" , __nN , .F. , __aHeader , __aCols )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
            DEFAULT nQuant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
        EndIF    

        DEFAULT nQuant        := 0

        DEFAULT lTudoOk := .F.
        lZ4QuantOk := ( ( nZ4Quant > 0 ) .and. IF( ( lTudoOk ) , ( nZ4Quant == nQuant ) , ( nZ4Quant <= nQuant ) ) )
        IF !( lZ4QuantOk )
            cMsgHelp := STR0017 + CRLF //"Quantidade Informada invá¬©da!"
            cMsgHelp += STR0018 + Transform( nZ4Quant    , GetSx3Cache( "Z4_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Informado: "
            cMsgHelp += STR0019 + Transform( nQuant     , GetSx3Cache( "Z4_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Disponí¶¥l: "
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lZ4QuantOk );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "Z4_QUANT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lZ4QuantOk )

/*/
    Function:    Z4QuantInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z4_QUANT
    Sintaxe:    StaticCall(U_NDJA002,Z4QuantInit)
/*/
Static Function Z4QuantInit()

    Local nZ4Quant
    
    Local nLoop
    Local nLoops
    Local nLastVal

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_QUANT" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_QUANT" ) );
        )
        DEFAULT nZ4Quant := GdFieldGet( "C7_QUANT" , __nN , .F. , __aHeader , __aCols )
    ElseIF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_QUANT" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_QUANT" ) );
        )
        DEFAULT nZ4Quant := GdFieldGet( "D1_QUANT" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
        DEFAULT nZ4Quant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
    EndIF    

    DEFAULT nZ4Quant := 0

    IF StaticCall( NDJLIB001 , IsInGetDados , "Z4_QUANT" )
        nLoops := Len( aCols )
        For nLoop := 1 To nLoops
            IF (;
                    ( nLoop > n );
                    .or.;
                    GdDeleted( nLoop );
                )    
                Loop
            EndIF
            nLastVal := GdFieldGet( "Z4_QUANT" , nLoop )
            IF (;
                    !Empty( nLastVal );
                    .and.;
                    ( nZ4Quant >= nLastVal );
                )    
                nZ4Quant -= nLastVal
            EndIF    
        Next nLoop
    EndIF

Return( nZ4Quant )

/*/
    Function:    C7XSZ2CodWhen
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Modo de Edicao do campo    C7_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,C7XSZ2CodWhen)
/*/
Static Function C7XSZ2CodWhen()

    Local lIsInGD    := StaticCall( NDJLIB001 , IsInGetDados , "C7_XSZ2COD" )
    Local lChange    := .T.

    BEGIN SEQUENCE

        NDJPubMemVar(1)

        IF !( lIsInGD )
            BREAK
        EndIF

        NDJPubMemVar(2)    
        NDJPubMemVar(3)

    END SEQUENCE

Return( lChange )

/*/
    Function:    D1XSZ2CodWhen
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Modo de Edicao do campo    D1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,D1XSZ2CodWhen)
/*/
Static Function D1XSZ2CodWhen()

    Local lIsInGD    := StaticCall( NDJLIB001 , IsInGetDados , "D1_XSZ2COD" )
    Local lChange    := .T.

    BEGIN SEQUENCE

        NDJPubMemVar(1)

        IF !( lIsInGD )
            BREAK
        EndIF

        NDJPubMemVar(2)    
        NDJPubMemVar(3)

    END SEQUENCE

Return( lChange )

/*/
    Function:    GetSCNumItem
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Obter o Numero e o Item da SC
    Sintaxe:    StaticCall(U_NDJA002,GetSCNumItem)
/*/
Static Function GetSCNumItem( cNumSC , cItemSC , cSeqItem )

    Local lSC7
    Local lSD1
    
    BEGIN SEQUENCE
    
        lSC7    := (;
                        ( StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" ) );
                        .or.;
                        ( StaticCall( NDJLIB001 , IsMemVar , "C7_NUMSC" ) ) ;
                    )    
                        
        lSD1    := (;
                        ( StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" ) );
                        .or.;
                        ( StaticCall( NDJLIB001 , IsMemVar , "D1_XNUMSC" ) );
                    )    
                        
        DO CASE

        CASE ( lSC7 )

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C7_NUMSC" ) );
                )
                cNumSC := GdFieldGet( "C7_NUMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C7_NUMSC" ) )
                cNumSC := StaticCall( NDJLIB001 , GetMemVar , "C7_NUMSC" )
            EndIF
        
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C7_ITEMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C7_ITEMSC" ) );
                )
                cItemSC := GdFieldGet( "C7_ITEMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C7_ITEMSC" ) )
                cItemSC := StaticCall( NDJLIB001 , GetMemVar , "C7_ITEMSC" )
            EndIF

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C7_SEQUEN" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C7_SEQUEN" ) );
                )
                cSeqItem := GdFieldGet( "C7_SEQUEN" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C7_SEQUEN" ) )
                cSeqItem := StaticCall( NDJLIB001 , GetMemVar , "C7_SEQUEN" )
            EndIF

            BREAK

        CASE ( lSD1 )
        
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XNUMSC" ) );
                )
                cNumSC := GdFieldGet( "D1_XNUMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XNUMSC" ) )
                cNumSC := StaticCall( NDJLIB001 , GetMemVar , "D1_XNUMSC" )
            EndIF
        
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_XITEMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XITEMSC" ) );
                )
                cItemSC := GdFieldGet( "D1_XITEMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XITEMSC" ) )
                cItemSC := StaticCall( NDJLIB001 , GetMemVar , "D1_XITEMSC" )
            EndIF

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_XSEQUEN" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XSEQUEN" ) );
                )
                cSeqItem := GdFieldGet( "D1_XSEQUEN" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XSEQUEN" ) )
                cSeqItem := StaticCall( NDJLIB001 , GetMemVar , "D1_XSEQUEN" )
            EndIF

            BREAK

        END CASE

    END SEQUENCE

Return( NIL )

/*/
    Function:    NDJPubMemVar
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Seta as Variaveis de Memoria para uso no programa
    Sintaxe:    StaticCall(U_NDJA002,NDJPubMemVar)
/*/
Static Function NDJPubMemVar( nOpc )

    Local aSC1Fields
    Local aAllACFlds
    
    Local cField

    Local nAT            := 0
    Local nField        := 0
    Local nFields        := 0
    Local nFieldPos        := 0
    Local nAllACFlds    := 0

    BEGIN SEQUENCE

        DEFAULT nOpc    := 3
        IF ( nOpc == 1 )
            StaticCall( NDJLIB004 , SetPublic , "__aHeader"    , NIL , "A" , 0 , .T. )
            StaticCall( NDJLIB004 , SetPublic , "__aCols"    , NIL , "A" , 0 , .T. )
            StaticCall( NDJLIB004 , SetPublic , "__nN"        , NIL , "N" , 0 , .T. )
            BREAK
        EndIF

        IF ( nOpc == 2 )
            IF ( Type( "aHeader" )  == "A" )
                StaticCall( NDJLIB004 , SetPublic , "__aHeader" , @aHeader , "A" , Len( aHeader ) , .T. )
            EndIF    
            IF ( Type( "aCols" ) == "A" )
                StaticCall( NDJLIB004 , SetPublic , "__aCols" , @aCols , "A" , Len( aCols ) , .T. )
            EndIF
            IF ( Type( "n" ) == "N" )
                StaticCall( NDJLIB004 , SetPublic , "__nN" , n , "N" , 0 , .T. )
            EndIF    
            BREAK
        EndIF

        IF (;
                ( Type( "__aHeader" ) == "A" );
                .and.;
                ( Type( "__aCols" ) == "A" );
                .and.;
                ( Type( "__nN" ) == "N" );
            )    
            aSC1Fields    := { "C1_NUM" , "C1_ITEM" , "C1_SEQUEN" , "C1_QUANT" }
            aAllACFlds    := {;
                                { "C7_NUMSC"      , "C7_ITEMSC"  , "C7_SEQUEN"  , "C7_QUANT"  },;
                                { "D1_XNUMSC"     , "D1_XITEMSC" , "D1_XSEQUEN" , "D1_QUANT"  },;
                                { "CNE_XNUMSC"    , "CNE_XITMSC" , "CNE_XSEQPC" , "CNE_QUANT" },;
                                { "CNB_XNUMSC"    , "CNB_XITMSC" , "CNB_XSEQPC" , "CNB_QUANT" };
                            }
            nFields     := Len( __aHeader )
            nAllACFlds    := Len( aAllACFlds )
            For nField := 1 To nFields
                cField                    := AllTrim( Upper( __aHeader[ nField , __AHEADER_FIELD__] ) ) 
                Private cPVar            := cField
                StaticCall( NDJLIB004 , SetPublic , cPVar , __aCols[ __nN , nField ] )
                For nAT := 1 To nAllACFlds
                    nFieldPos                := aSCan( aAllACFlds[ nAT ] , { |cFld| cFld == cField } )
                    IF ( nFieldPos > 0 )
                        cPVar                := aSC1Fields[ nFieldPos ]
                        StaticCall( NDJLIB004 , SetPublic , cPVar , __aCols[ __nN , nField ] )
                    EndIF
                Next nAT
            Next nField

        EndIF

    END SEQUENCE

Return( NIL )

/*/
    Function:    C7XSZ2CodVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo C7_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,C7XSZ2CodVld)
/*/
Static Function C7XSZ2CodVld( cC7XSZ2Cod , lShowHelp , cMsgHelp )

    Local cNumSC
    Local cItemSC
    Local cSeqItem

    Local lSC7XSZ2CodOK    := .T.

    Local nSZ4Order
    Local nSZ5Order

    BEGIN SEQUENCE

        //Quando a Inclusao for Via CNTA120 (Contratos)
        IF (;
                IsInCallStack( "CN120GrvPeD" );
                .or.;
                IsInCallStack( "MSExecAuto" );
            )
            IF ( Type( "__aCNERecnos" ) == "A" )
                IF !Empty( __aCNERecnos )
                    BREAK
                EndIF    
            EndIF
        EndIF

        DEFAULT cC7XSZ2Cod := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_XSZ2COD" )

        IF !( lSC7XSZ2CodOK := !Empty( cC7XSZ2Cod ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "C7_XSZ2COD" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( C7_XSZ2COD )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF

        DEFAULT cNumSC        := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_NUMSC" )
        
        nSZ5Order := RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )

        IF !( lSC7XSZ2CodOK := ExistCpo("SZ5",cC7XSZ2Cod+cNumSC,nSZ5Order ) )
            BREAK
        EndIF

        DEFAULT cItemSC        := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_ITEMSC" )
        
        DEFAULT cSeqItem    := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_SEQUEN" )

        nSZ4Order := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )

        IF !( lSC7XSZ2CodOK := ExistCpo("SZ4",cC7XSZ2Cod+cNumSC+cItemSC+cSeqItem,nSZ4Order ) )
            BREAK
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lSC7XSZ2CodOK );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "C7_XSZ2COD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lSC7XSZ2CodOK )             

/*/
    Function:    C7XSZ2CodInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo C7_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,C7XSZ2CodInit)
/*/
Static Function C7XSZ2CodInit()

    Local cC7NumSc
    Local cC7XSZ2Cod

    Local nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_NUMSC" )

    TRYEXCEPTION

        DEFAULT cC7NumSc := StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_NUMSC" )

        SZ5->( dbSetOrder( nSZ5Order ) )
        IF (;
                !Empty( cC7NumSc );
                .and.;    
                SZ5->( dbSeek( xFilial( "SZ5" ) + cC7NumSc , .F. ) );
            )    
            cC7XSZ2Cod := SZ5->Z5_CODIGO
        Else
            cC7XSZ2Cod := Space( GetSx3Cache( "C7_XSZ2COD" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION

        cC7XSZ2Cod := Space( GetSx3Cache( "C7_XSZ2COD" , "X3_TAMANHO" ) )

    ENDEXCEPTION

Return( cC7XSZ2Cod )

/*/
    Function:    D1XSZ2CodVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo D1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,D1XSZ2CodVld)
/*/
Static Function D1XSZ2CodVld( cD1XSZ2Cod , lShowHelp , cMsgHelp )

    Local cNumSC
    Local cItemSC

    Local lSD1XSZ2CodOK    := .T.

    Local nSZ4Order
    Local nSZ5Order

    BEGIN SEQUENCE

        DEFAULT cD1XSZ2Cod := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XSZ2COD" )

        IF !( lSD1XSZ2CodOK := !Empty( cD1XSZ2Cod ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "D1_XSZ2COD" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_XSZ2COD )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF

        DEFAULT cNumSC := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XNUMSC" )

        nSZ5Order := RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )

        IF !( lSD1XSZ2CodOK := ExistCpo("SZ5",cD1XSZ2Cod+cNumSC,nSZ5Order ) )
            BREAK
        EndIF

        DEFAULT cItemSC := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XITEMSC" )

        nSZ4Order := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )

        IF !( lSD1XSZ2CodOK := ExistCpo("SZ4",cD1XSZ2Cod+cNumSC+cItemSC,nSZ4Order ) )
            BREAK
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lSD1XSZ2CodOK );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "D1_XSZ2COD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lSD1XSZ2CodOK )             

/*/
    Function:    D1XSZ2CodInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo D1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA002,D1XSZ2CodInit)
/*/
Static Function D1XSZ2CodInit()

    Local cD1NumSc
    Local cD1XSZ2Cod

    Local nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_NUMSC" )

    TRYEXCEPTION
        
        IF !( Type( "INCLUI" ) == "L" )
            Private INCLUI := .F.
        EndIF

        DEFAULT cD1NumSc := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XNUMSC" )

        SZ5->( dbSetOrder( nSZ5Order ) )
        IF (;
                !( INCLUI );
                .and.;
                !Empty( cD1NumSc );
                .and.;
                SZ5->( dbSeek(  xFilial( "SZ5" ) + cD1NumSc , .F. ) );
            )    
            cD1XSZ2Cod := SZ5->Z5_CODIGO
        Else
            cD1XSZ2Cod := Space( GetSx3Cache( "D1_XSZ2COD" , "X3_TAMANHO" ) )
        EndIF
        
    CATCHEXCEPTION

        cD1XSZ2Cod := Space( GetSx3Cache( "D1_XSZ2COD" , "X3_TAMANHO" ) )

    ENDEXCEPTION        

Return( cD1XSZ2Cod )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        NDJA002()
        NDJA002Vis()
        NDJA002Inc()
        NDJA002Alt()
        NDJA002Del()
        NDJA002Mnt()
        GdSZ4Seek()
        NDJA002TEncOk()
        oGdSZ4LinOk()
        oGdSZ4TudOk()
        SZ4GdDelOk()
        NDJA002Grava()
        ChkSZ5ToSD1()
        SZ4ChkLnk()
        lUseD1ToZ5()
        lUseC7ToZ5()
        Z5CodigoVld()
        Z5GetCodigo()
        Z5CodigoInit()
        Z5NumScInit()
        Z4CodigoVld()
        Z4NumSCInit()
        Z4ItemSCInit()
        Z4SecItemInit()
        Z4QantVld()
        Z4QuantInit()
        C7XSZ2CodWhen()
        D1XSZ2CodWhen()
        GetSCNumItem()
        NDJPubMemVar()
        C7XSZ2CodVld()
        C7XSZ2CodInit()
        D1XSZ2CodVld()
        D1XSZ2CodInit()
        SZ4SZ5COMMIT()
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
