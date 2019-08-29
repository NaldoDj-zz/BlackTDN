#INCLUDE "NDJ.CH"
#INCLUDE "U_NDJA001.CH"

Static __aTTS    := {}
Static __nTTS    := 0

/*/
    Function:    NDJA001
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ
    Sintaxe:    StaticCall(U_NDJA001,NDJA001,cAlias,nReg,nOpc,lExecAuto)
/*/
Static Function NDJA001( cAlias , nReg , nOpc , lExecAuto )
                                                            
    Local aArea     := GetArea()
    Local aAreaSZ3    := SZ3->( GetArea() )
    Local aAreaSZ2    := SZ2->( GetArea() )
    Local aSaveGet    := SaveoGet()
    
    Local lExistOpc    := ( ValType( nOpc ) == "N" )

    Private nPrvtN    := IF( ( Type( "n" ) == "N" ) , n , NIL )
    
    BEGIN SEQUENCE

        cAlias    := "SZ3"
    
        Private aRotina        := {;
                                    { STR0001 , "AxPesqui"     , 0 , 01 } ,; //"Pesquisar"
                                    { STR0002 , "NDJA001Mnt" , 0 , 02 } ,; //"Visualizar"
                                    { STR0003 , "NDJA001Mnt" , 0 , 03 } ,; //"Incluir"
                                    { STR0004 , "NDJA001Mnt" , 0 , 04 } ,; //"Alterar"
                                    { STR0005 , "NDJA001Mnt" , 0 , 05 }  ; //"Excluir"
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
    
                NDJA001Mnt( @cAlias , @nReg , @nOpc , .T. )
            
            EndIF    
        
        Else
    
            mBrowse( 6 , 1 , 22 , 75 , cAlias )
    
        EndIF
        
    END SEQUENCE
    
    CursorWait()

    RestArea( aAreaSZ2 )
    RestArea( aAreaSZ3 )
    RestArea( aArea )
    
    CursorArrow()

    RestartoGet( aSaveGet )

Return( NIL )

/*/
    Function:    NDJA001Vis
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Visualizar)
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Vis,cAlias,nReg)
/*/
Static Function NDJA001Vis( cAlias , nReg )
    Local nOpc := 2
Return( NDJA001( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA001Inc
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Incluir)
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Inc,cAlias,nReg)
/*/
Static Function NDJA001Inc( cAlias , nReg )
    Local nOpc := 3
    IF ( nReg > 0 )
        nOpc := 4
    EndIF
Return( NDJA001( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA001Alt
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Alt,cAlias,nReg)
/*/
Static Function NDJA001Alt( cAlias , nReg )
    Local nOpc := 4
Return( NDJA001( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA001Del
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Alterar)
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Del,cAlias,nReg)
/*/
Static Function NDJA001Del( cAlias , nReg )
    Local nOpc := 5
Return( NDJA001( @cAlias , @nReg , @nOpc ) )

/*/
    Function:    NDJA001Mnt
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Cadastro de Tabela Locais NDJ (Manutencao)
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Mnt,cAlias,nReg,lDlgPadSiga)
/*/
Static Function NDJA001Mnt( cAlias , nReg , nOpc , lDlgPadSiga )

    Local aArea            := GetArea(Alias())
    Local aAreaSZ3        := SZ3->( GetArea() )
    Local aSvKeys        := GetKeys()
    Local aAdvSize        := {}
    Local aInfoAdvSize    := {}
    Local aObjSize        := {}
    Local aObjCoords    := {}
    Local aSZ3Header    := {}
    Local aSZ3Cols        := {}
    Local aSvSZ3Cols    := {}
    Local aSZ3Fields    := {}
    Local aSZ3Altera    := {}
    Local aSZ3NaoAlt    := {}
    Local aSZ3VirtEn    := {}
    Local aSZ3NotFields    := {}
    Local aSZ3Recnos    := {}
    Local aSZ3Keys        := {}
    Local aSZ3VisuEn    := {}
    Local aSZ2GdAltera  := {}
    Local aSZ2GdNaoAlt    := {}
    Local aSZ2Recnos    := {}
    Local aSZ2Keys        := {}
    Local aSZ2NotFields    := {}
    Local aSZ2VirtGd    := {}
    Local aSZ2VisuGd    := {}
    Local aSZ2Header    := {}
    Local aSZ2Cols        := {}
    Local aSvSZ2Cols    := {}
    Local aSZ2Query        := {}
    Local aButtons        := {}
    Local aFreeLocks    := {}
    Local aLog            := {}
    Local aLogTitle        := {}
    Local aLogGer        := {}
    Local aLogGerTitle    := {}
    
    Local bSZ2GdDelOk    := { |lDelOk| CursorWait() , lDelOk := SZ2GdDelOk( "SZ2" , NIL , nOpc , cZ3Codigo , nSZ2Order ) , CursorArrow() , lDelOk }
    Local bSet15        := { || NIL }
    Local bSet24        := { || NIL }
    Local bGdSZ2Seek    := { || NIL }
    Local bDialogInit    := { || NIL }
    Local bGetSZ3        := { || NIL } 
    Local bGetSZ2        := { || NIL }
    Local bSZ2Sort        := { || NIL }
    Local bSZ2LinOk        := { |oBrowse| oGdSZ2LinOk( oBrowse ) }
    Local bSZ2TudOk        := { |oBrowse| oGdSZ2TudOk( oBrowse ) }
    
    Local cKTTS            := ""
    Local cNumSC        := ""
    Local cItemSC        := ""
    Local cFilSZ3        := ""
    Local cZ3Codigo        := ""
    Local cZ3KeySeek    := ""
    Local cMsgYesNo        := ""
    Local cTitLog        := ""
    
    Local lLocks        := .F.
    Local lExecLock        := ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
    Local lExcGeraLog    := .F.
    Local lFreeLocks    := .F.
    Local lC1XREFCNT    := .F.
    
    Local nOpcAlt        := 0
    Local nSZ3Usado        := 0
    Local nSZ2Usado        := 0
    Local nLoop            := 0
    Local nLoops        := 0
    Local nOpcNewGd        := 0
    Local nSZ2MaxLocks    := 50
    Local nSZ2GhostCol    := 0
    Local nSZ2Order        := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
    Local nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )
    Local nSZ3GDElem    := 0
    
    Local oDlg            := NIL
    Local oEnSZ3        := NIL    
    Local oGdSZ2        := NIL
    Local oPanel
    
    Private aGets
    Private aTela

    Private n            := IF( ( Type( "nPrvtN" ) == "N" ) , nPrvtN , 1 )
    Private nGetSX8Len    := GetSX8Len()
    
    CursorWait()
    
    BEGIN SEQUENCE

        IF !( IsInCallStack( "MATA110" ) )
            nOpc := 2
        EndIF

        NDJPubMemVar(3)
    
        aRotSetOpc( cAlias , @nReg , nOpc )
    
        aSZ3NotFields    := { "Z3_FILIAL" }
        bGetSZ3            := { |lLock,lExclu|    IF( lExecLock , ( lLock := .T. , lExclu    := .T. ) , aSZ3Keys := NIL ),;
                                            aSZ3Cols := SZ3->(;
                                                                GdBuildCols(    @aSZ3Header        ,;    //01 -> Array com os Campos do Cabecalho da GetDados
                                                                                @nSZ3Usado        ,;    //02 -> Numero de Campos em Uso
                                                                                @aSZ3VirtEn        ,;    //03 -> [@]Array com os Campos Virtuais
                                                                                @aSZ3VisuEn        ,;    //04 -> [@]Array com os Campos Visuais
                                                                                "SZ3"            ,;    //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
                                                                                aSZ3NotFields    ,;    //06 -> Opcional, Campos que nao Deverao constar no aHeader
                                                                                @aSZ3Recnos        ,;    //07 -> [@]Array unidimensional contendo os Recnos
                                                                                "SZ3"               ,;    //08 -> Alias do Arquivo Pai
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
                                                                                @aSZ3Keys        ,;    //24 -> [@]Array que contera as chaves conforme recnos
                                                                                @lLock            ,;    //25 -> [@]Se devera efetuar o Lock dos Registros
                                                                                @lExclu             ;    //26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
                                                                            );
                                                              ),;
                                            IF( lExecLock , ( lLock .and. lExclu ) , .T. );
                              } 

        IF !( lLocks := WhileNoLock( "SZ3" , NIL , NIL , 1 , 1 , .T. , 1 , 5 , bGetSZ3 ) )
            BREAK
        EndIF
        cFilSZ3            := SZ3->Z3_FILIAL
        cZ3Codigo        := SZ3->Z3_CODIGO
        cZ3KeySeek        := ( cFilSZ3 + cZ3Codigo )

        SZ3->( dbSetOrder( nSZ3Order ) )
        IF SZ3->( !dbSeek( cZ3KeySeek , .F. ) )
            nOpc        := 3
            aRotSetOpc( cAlias , @nReg , @nOpc )
            aSvSZ3Cols    := {}
        Else
            aSvSZ3Cols    := aClone( aSZ3Cols )
        EndIF

        SZ3->( RestArea( aAreaSZ3 ) )

        lExecLock    := ( ( nOpc <> 2 ) .and. ( nOpc <> 3 ) )
        lExcGeraLog    := .F.
        IF (;
                ( Type( "__aHeader" ) == "A" );
                .and.;
                ( Type( "__aCols" ) == "A" );
                .and.;
                ( Type( "__N" ) == "N" );
                .and.;
                ( __N > 0 );
            )
            IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XREFCNT" , __aHeader , __aCols , __nN )
                lC1XREFCNT    := GdFieldGet( "C1_XREFCNT" , __nN , .F. , __aHeader , __aCols )
            EndIF    
        EndIF
        IF ( lC1XREFCNT )
            nOpcNewGd    := IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_UPDATE + GD_DELETE )
            nSZ3GDElem    := 1
        Else
            nOpcNewGd    := IF( ( ( nOpc == 2 ) .or. ( nOpc == 5 ) ) , 0 , GD_INSERT + GD_UPDATE + GD_DELETE    )
            nSZ3GDElem    := Val(Replicate("9",GetSx3Cache( "Z2_SECITEM" , "X3_TAMANHO" )))
        EndIF    

        For nLoop := 1 To nSZ3Usado
            aAdd( aSZ3Fields , aSZ3Header[ nLoop , 02 ] )
            StaticCall( NDJLIB001 , SetMemVar , aSZ3Header[ nLoop , 02 ] , aSZ3Cols[ 01 , nLoop ] , .T. )
        Next nLoop
        
        IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
    
            nLoops := Len( aSZ3VisuEn )
            For nLoop := 1 To nLoops
                aAdd( aSZ3NaoAlt , aSZ3VisuEn[ nLoop ] )
            Next nLoop
            IF ( nOpc == 4 )
                aAdd( aSZ3NaoAlt , "Z3_CODIGO" )
            EndIF
            nLoops := Len( aSZ3Fields )
            For nLoop := 1 To nLoops
                IF ( aScan( aSZ3NaoAlt , { |cNaoA| cNaoA == aSZ3Fields[ nLoop ] } ) == 0 )
                    aAdd( aSZ3Altera , aSZ3Fields[ nLoop ] )
                EndIF
            Next nLoop
        
        EndIF

        GetSCNumItem( @cNumSC , @cItemSC )

        IF (;
                !( Type( "cA110Num" ) == "C" );
                .or.;
                Empty( cA110Num );
            )
            IF !Empty( cNumSC )
                Private cA110Num    := cNumSC
            EndIF    
        EndIF        

        cZ3KeySeek += cNumSC
        cZ3KeySeek += cItemSC

        aAdd( aSZ2NotFields , "Z2_FILIAL"  )
        aAdd( aSZ2NotFields , "Z2_CODIGO"    )
        #IFDEF TOP
            aSZ2Query        := Array( 09 )
            aSZ2Query[01]    := "    D_E_L_E_T_<>'*' "
            aSZ2Query[02]    := " AND "
            aSZ2Query[03]    := "    Z2_FILIAL='"+cFilSZ3+"'"
            aSZ2Query[04]    := " AND "
            aSZ2Query[05]    := "    Z2_CODIGO='"+cZ3Codigo+"'"
            aSZ2Query[06]    := " AND "
            aSZ2Query[07]    := "    Z2_NUMSC='"+cNumSC+"'"
            aSZ2Query[08]    := " AND "
            aSZ2Query[09]    := "    Z2_ITEMSC='"+cItemSC+"'"
        #ENDIF

        IF ( nOpc == 3  ) //Inclusao
            PutFileInEof( "SZ2" )
        EndIF

        bGetSZ2    := { |lLock,lExclu|    IF( lExecLock , ( lLock := .T. , lExclu := .T. ) , aSZ2Keys := NIL ),;
                                         aSZ2Cols := SZ2->(;
                                                        GdBuildCols(    @aSZ2Header        ,;    //01 -> Array com os Campos do Cabecalho da GetDados
                                                                        @nSZ2Usado        ,;    //02 -> Numero de Campos em Uso
                                                                        @aSZ2VirtGd        ,;    //03 -> [@]Array com os Campos Virtuais
                                                                        @aSZ2VisuGd        ,;    //04 -> [@]Array com os Campos Visuais
                                                                        "SZ2"            ,;    //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
                                                                        aSZ2NotFields    ,;    //06 -> Opcional, Campos que nao Deverao constar no aHeader
                                                                        @aSZ2Recnos        ,;    //07 -> [@]Array unidimensional contendo os Recnos
                                                                        "SZ3"               ,;    //08 -> Alias do Arquivo Pai
                                                                        cZ3KeySeek        ,;    //09 -> Chave para o Posicionamento no Alias Filho
                                                                        NIL                ,;    //10 -> Bloco para condicao de Loop While
                                                                        NIL                ,;    //11 -> Bloco para Skip no Loop While
                                                                        NIL                ,;    //12 -> Se Havera o Elemento de Delecao no aCols 
                                                                        NIL                ,;    //13 -> Se Sera considerado o Inicializador Padrao
                                                                        NIL                ,;    //14 -> Opcional, Carregar Todos os Campos
                                                                        NIL                ,;    //15 -> Opcional, Nao Carregar os Campos Virtuais
                                                                        aSZ2Query        ,;    //16 -> Opcional, Utilizacao de Query para Selecao de Dados
                                                                        .F.                ,;    //17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
                                                                        .F.                ,;    //18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
                                                                        Altera            ,;    //19 -> Carregar Coluna Fantasma
                                                                        NIL                ,;    //20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                                                        NIL                ,;    //21 -> Verifica se Deve Checar se o campo eh usado
                                                                        NIL                ,;    //22 -> Verifica se Deve Checar o nivel do usuario
                                                                        NIL                ,;    //23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
                                                                        @aSZ2Keys        ,;    //24 -> [@]Array que contera as chaves conforme recnos
                                                                        @lLock            ,;    //25 -> [@]Se devera efetuar o Lock dos Registros
                                                                        @lExclu            ,;    //26 -> [@]Se devera obter a Exclusividade nas chaves dos registros
                                                                        nSZ2MaxLocks    ,;    //27 -> Numero maximo de Locks a ser efetuado
                                                                        Altera             ;    //28 -> Utiliza Numeracao na GhostCol
                                                                    );
                                                          ),;
                                        IF( lExecLock , ( lLock .and. lExclu ) , .T. );
                      }

        IF !( lLocks := WhileNoLock( "SZ2" , NIL , NIL , 1 , 1 , .T. , nSZ2MaxLocks , 5 , bGetSZ2 ) )
            BREAK
        EndIF
        CursorWait()
    
        IF ( Len( aSZ2Cols ) == 1 )
            IF Empty( GdFieldGet( "Z2_SECITEM" , 1, .F. , aSZ2Header , aSZ2Cols ) )
                GdFieldPut( "Z2_SECITEM" , StrZero( 1 , GetSx3Cache( "Z2_SECITEM" , "X3_TAMANHO" ) ) , 1 , aSZ2Header , aSZ2Cols , .F. )
            EndIF
        EndIF
        IF ( ( nSZ2GhostCol := GdFieldPos( "GHOSTCOL" , aSZ2Header ) ) > 0 )
            bSZ2Sort := { |x,y| ( x[ nSZ2GhostCol ] < y[ nSZ2GhostCol ] ) }
        EndIF
    
        aSvSZ2Cols    := aClone( aSZ2Cols )

        For nLoop := 1    To nSZ2Usado
            StaticCall( NDJLIB001 , SetMemVar , aSZ2Header[ nLoop , 02 ] , GetValType( aSZ2Header[ nLoop , 08 ] , aSZ2Header[ nLoop , 04 ] ) , .T. )
            IF (;
                    ( aScan( aSZ2VirtGd        , aSZ2Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ2VisuGd        , aSZ2Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ2NotFields    , aSZ2Header[ nLoop , 02 ] ) == 0 ) .and.    ;
                       ( aScan( aSZ2GdNaoAlt    , aSZ2Header[ nLoop , 02 ] ) == 0 )        ;
                  )
                aAdd( aSZ2GdAltera , aSZ2Header[ nLoop , 02 ] )
            EndIF               
        Next nLoop

        IF ( nOpc == 5 ) 
            IF !( ApdChkDel( cAlias , nReg , nOpc , cZ3Codigo , .F. , @aLog , @aLogTitle , { "SZ2" } ) )
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

        bGdSZ2Seek := { ||    GdSZ2Seek( oGdSZ2 )                ,;
                            SetKey( VK_F4 , bGdSZ2Seek )     ;
                   }
        aAdd(;
                aButtons    ,;
                                {;
                                    "PMSPESQ",;
                                       bGdSZ2Seek,;
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
                                    NDJA001TEncOk( nOpc , oEnSZ3 );                            //Valida Todos os Campos da Enchoice
                                    .and.;
                                    oGdSZ2:TudoOk(),;                                        //Valida as Informacoes da GetDados
                                    (;
                                        nOpcAlt     := 1 ,;
                                        aSZ2Cols    := oGdSZ2:aCols,;                        //Redireciona o Ponteiro do aSZ2Cols
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
                                SetKey( VK_F4 , bGdSZ2Seek  ),;
                        }
    
        DEFINE MSDIALOG oDlg TITLE OemToAnsi( STR0006 ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL

            @ 000,000 MSPANEL oPanel OF oDlg
            oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

            oEnSZ3    := MsmGet():New(    cAlias        ,;
                                        nReg        ,;
                                        nOpc        ,;
                                        NIL            ,;
                                        NIL            ,;
                                        NIL            ,;
                                        aSZ3Fields    ,;
                                        aObjSize[1]    ,;
                                        aSZ3Altera    ,;
                                        NIL            ,;
                                        NIL            ,;
                                        NIL            ,;
                                        oPanel        ,;
                                        NIL            ,;
                                        .F.            ,;
                                        NIL            ,;
                                        .F.             ;
                                    )

            oGdSZ2    := MsNewGetDados():New(    aObjSize[2,1]    ,;
                                            aObjSize[2,2]    ,;
                                            aObjSize[2,3]    ,;
                                            aObjSize[2,4]    ,;
                                            nOpcNewGd        ,;
                                            bSZ2LinOk        ,;
                                            bSZ2TudOk        ,;
                                            "+Z2_SECITEM"    ,;
                                            aSZ2GdAltera    ,;
                                            0                ,;
                                            nSZ3GDElem        ,; 
                                            NIL                ,;
                                            NIL                ,;
                                            bSZ2GdDelOk        ,;
                                            oPanel            ,;
                                            aSZ2Header        ,;
                                            aSZ2Cols         ;
                                         )

        
            oGdSZ2:SetEditLine( .F. )

            AlignObject( oPanel , { oEnSZ3:oBox , oGdSZ2:oBrowse } , 1 , NIL , { 60 } ); 
            
        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
    
        CursorWait()
    
        IF( nOpcAlt == 1 )
             IF ( nOpc != 2 )
                MsAguarde(;
                            { ||;
                                    aSort( aSZ2Cols , NIL , NIL , bSZ2Sort ),;    //Sorteia as Informacoes do SZ2 para Comparacao Antes da Gravacao
                                    NDJA001Grava(;
                                                    nOpc        ,;    //Opcao de Acordo com aRotina
                                                     nReg        ,;    //Numero do Registro do Arquivo Pai ( SZ3 )
                                                     aSZ3Header    ,;    //Campos do Arquivo Pai ( SZ3 )
                                                     aSZ3VirtEn    ,;    //Campos Virtuais do Arquivo Pai ( SZ3 )
                                                     aSZ3Cols    ,;    //Conteudo Atual dos Campos do Arquivo Pai ( SZ3 )
                                                     aSvSZ3Cols    ,;    //Conteudo Anterior dos Campos do Arquivo Pai ( SZ3 )
                                                     aSZ2Header    ,;    //Campos do Arquivo Filho ( SZ2 )
                                                     aSZ2Cols    ,;    //Itens Atual do Arquivo Filho ( SZ2 )
                                                     aSvSZ2Cols    ,;    //Itens Anterior do Arquivo Filho ( SZ2 )
                                                     aSZ2VirtGd    ,;    //Campos Virtuais do Arquivo Filho ( SZ2 )
                                                     aSZ2Recnos     ;    //Recnos do Arquivo Filho ( SZ2 )
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

    lFreeLocks    := ( StaticCall( NDJLIB003 , IFreeLocks , "SZ3" ) .and. StaticCall( NDJLIB003 , IFreeLocks , "SZ2" ) )

    WhileNoLock( "SZ3" , NIL , NIL , 1 , 1 , .T. , 100 , 5 , bGetSZ3 )
    WhileNoLock( "SZ2" , NIL , NIL , 1 , 1 , .T. , 100 , 5 , bGetSZ2 )

    IF ( lFreeLocks )
        aAdd( aFreeLocks , { "SZ3" , aSZ3Recnos , aSZ3Keys } )
        aAdd( aFreeLocks , { "SZ2" , aSZ2Recnos , aSZ2Keys } )
        StaticCall( NDJLIB003 , _FreeLocks , @aFreeLocks )
    Else
        StaticCall( NDJLIB003 , SetFreeLock , "SZ3" , aSZ3Recnos , aSZ3Keys )
        StaticCall( NDJLIB003 , SetFreeLock , "SZ2" , aSZ2Recnos , aSZ2Keys )
    EndIF

    cKTTS    := StaticCall( NDJLIB001 , GetMemVar , "Z3_CODIGO" )
    aEval( aSZ3Recnos , { |nRecno| SZ2SZ3TTS( @cKTTS , @nRecno ) } )

    RestArea( aArea )

    RestKeys( aSvKeys , .T. )

    CursorArrow()

Return( nOpcAlt )

/*/
    Function:    SZ2SZ3TTS
    Autor:        Marinaldo de Jesus
    Data:        28/08/2011
    Descricao:    Armazena Registros da SZ3 para Commit
    Sintaxe:    StaticCall( U_NDJA001 , SZ2SZ3TTS , cKTTS , nRecno )
/*/
Static Function SZ2SZ3TTS( cKTTS , nRecno )

    Local nATTTS

    DEFAULT cKTTS    := SZ3->Z3_CODIGO
    DEFAULT nRecno    := SZ3->( Recno() )

    nATTTS    := aScan( __aTTS , { |aElem| ( aElem[ 1 ] == cKTTS ) } )

    IF ( nATTTS == 0 )
        aAdd( __aTTS    , { cKTTS , Array( 0 ) } )
        ++__nTTS
        nATTTS := __nTTS
    EndIF
    aAdd( __aTTS[ nATTTS ][ 2 ] , nRecno )

    IF SZ3->( !Eof() .and. !Bof() )
        SZ3->( MsGoto( nRecno ) )
        StaticCall( NDJLIB003 , LockSoft , "SZ3" )
    EndIF    

Return( NIL )

/*/
    Function:    SZ2SZ3Commit
    Autor:        Marinaldo de Jesus
    Data:        28/08/2011
    Descricao:    Efetiva o Link da SC1 com SZ2 e SZ3
    Sintaxe:    StaticCall( U_NDJA001 , SZ2SZ3Commit )
/*/
Static Function SZ2SZ3Commit()
    Local lSZ2ChkLnk    := SZ2ChkLnk( .T. )
    While ( __nTTS > 0 )
        ChkSZ3ToSC1( __aTTS[ __nTTS ][ 2 ] , .F. )
        aDel( __aTTS , __nTTS )
        aSize( __aTTS , --__nTTS )
    End While
    SZ2ChkLnk( lSZ2ChkLnk )
Return( NIL )

/*/
    Function:    GdSZ2Seek
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Efetuar Pesquisa na GetDados
    Sintaxe:    StaticCall(U_NDJA001,GdSZ2Seek,oGdSZ2)
/*/
Static Function GdSZ2Seek( oGdSZ2 )

    Local aSvKeys        := GetKeys()
    Local cProcName3    := Upper( AllTrim( ProcName( 3 ) ) )
    Local cProcName5    := Upper( AllTrim( ProcName( 5 ) ) )
    
    BEGIN SEQUENCE
    
        IF !( "NDJA001MNT" $ ( cProcName3 + cProcName5  ) )
            BREAK
        EndIF
        
        GdSeek( oGdSZ2 , OemToAnsi( STR0001 ) )    //"Pesquisar"
    
    END SEQUENCE    
    
    RestKeys( aSvKeys , .T. )

Return( NIL )

/*/
    Function:    NDJA001TEncOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Tudo Ok para a Enchoice
    Sintaxe:    StaticCall(U_NDJA001,NDJA001TEncOk,nOpc,oEnSZ3)
/*/
Static Function NDJA001TEncOk( nOpc , oEnSZ3 )

    Local lTudoOk := .T.
                    
    IF ( ( nOpc == 3 ) .or. ( nOpc == 4 ) )
        lTudoOk := EnchoTudOk( oEnSZ3 )
    EndIF
    
Return( lTudoOk )

/*/
    Function:    oGdSZ2LinOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Linha OK da GetDados
    Sintaxe:    StaticCall(U_NDJA001,oGdSZ2LinOk,oBrowse)
/*/
Static Function oGdSZ2LinOk( oBrowse )

    Local lLinOk          := .T.

    Local aCposKey
    
    CursorWait()
    
        BEGIN SEQUENCE

            IF !( GdDeleted() )

                aCposKey := GdObrigat( aHeader )
                IF !( lLinOk := GdNoEmpty( aCposKey ) )
                    BREAK
                EndIF

                aCposKey := GetArrUniqe( "SZ2" )
                IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
                    BREAK
                EndIF

                aCposKey := {;
                                    "Z2_CODIGO"     ,;
                                    "Z2_NUMSC"        ,;
                                    "Z2_ITEMSC"     ,;
                                    "Z2_XCLIORG"    ,;
                                    "Z2_XCLIINS"    ,;
                                    "Z2_XLOJAIN"    ,;
                                    "Z2_XRESPON"    ,;
                                    "Z2_XCONTAT"     ;
                            }
                IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
                    BREAK
                EndIF

            EndIF

        END SEQUENCE
        
        IF !( lLinOk )
            oBrowse:SetFocus()
        EndIF
    
        PutFileInEof( "SZ2" )
    
    CursorArrow()
    
Return( lLinOk )

/*/
    Function:    oGdSZ2TudOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Tudo Ok da GetDados
    Sintaxe:    StaticCall(U_NDJA001,oGdSZ2TudOk,oBrowse)
/*/
Static Function oGdSZ2TudOk( oBrowse )

    Local cMsgHelp

    Local lTudoOk     := .T.
    Local lZ2Quant    := StaticCall( NDJLIB001 , IsInGetDados , "Z2_QUANT" )

    Local nLoop
    Local nLoops
    Local nC1Quant
    Local nZ2Quant    := 0

    CursorWait()
    
        BEGIN SEQUENCE

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C1_QUANT" , __aHeader , __aCols , __nN );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C1_QUANT" ) );
                )
                DEFAULT nC1Quant := GdFieldGet( "C1_QUANT" , __nN , .F. , __aHeader , __aCols )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
                DEFAULT nC1Quant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
            Else
                DEFAULT nC1Quant := 0
            EndIF

            Private n

            nLoops := Len( aCols )
            For nLoop := 1 To nLoops
                n := nLoop
                IF !( lTudoOk := oGdSZ2LinOk( oBrowse ) )
                    oBrowse:Refresh()
                    BREAK
                EndIF
                IF (;
                        ( lZ2Quant );
                        .and.;
                        !( GdDeleted() );
                    )    
                    nZ2Quant += GdFieldGet( "Z2_QUANT" )
                EndIF
            Next nLoop 

            IF ( lZ2Quant )
                cMsgHelp := STR0020 + CRLF //"A soma das Quantidades está ¥rrada" 
                cMsgHelp += STR0018 + Transform( nZ2Quant , GetSx3Cache( "C1_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Informado: "
                cMsgHelp += STR0019 + Transform( nC1Quant , GetSx3Cache( "C1_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Disponí¶¥l: "
                lTudoOk := Z2QantVld( @nZ2Quant , .T. , cMsgHelp , .T. )
            EndIF
            
            IF !( lTudoOk )
                oBrowse:Refresh()
                BREAK
            EndIF

        END SEQUENCE

    CursorArrow()

Return( lTudoOk  )

/*/
    Function:    SZ2GdDelOk
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Validar a Delecao na GetDados
    Sintaxe:    StaticCall(U_NDJA001,SZ2GdDelOk,cAlias,nRecno,nOpc,cCodigo,nSZ2Order)
/*/
Static Function SZ2GdDelOk( cAlias , nRecno , nOpc , cCodigo , nSZ2Order )
         
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
    Function:    NDJA001Grava
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Gravar as informacoes da SZ2 e SZ3
    Sintaxe:    StaticCall(U_NDJA001,NDJA001Grava)
/*/
Static Function NDJA001Grava(    nOpc        ,;    //Opcao de Acordo com aRotina
                                 nReg        ,;    //Numero do Registro do Arquivo Pai ( SZ3 )
                                 aSZ3Header    ,;    //Campos do Arquivo Pai ( SZ3 )
                                 aSZ3VirtEn    ,;    //Campos Virtuais do Arquivo Pai ( SZ3 )
                                 aSZ3Cols    ,;    //Conteudo Atual dos Campos do Arquivo Pai ( SZ3 )
                                 aSvSZ3Cols    ,;    //Conteudo Anterior dos Campos do Arquivo Pai ( SZ3 )
                                 aSZ2Header    ,;    //Campos do Arquivo Filho ( SZ2 )
                                 aSZ2Cols    ,;    //Itens Atual do Arquivo Filho ( SZ2 )
                                 aSvSZ2Cols    ,;    //Itens Anterior do Arquivo Filho ( SZ2 )
                                 aSZ2VirtGd    ,;    //Campos Virtuais do Arquivo Filho ( SZ2 )
                                 aSZ2Recnos     ;    //Recnos do Arquivo Filho ( SZ2 )
                              )

    Local aMestre        := GdPutIStrMestre( 01 )
    Local aItens        := {}

    Local cOpcao        := IF( ( nOpc == 5 ) , "DELETE" , IF( ( ( nOpc == 3 ) .or. ( nOpc == 4 ) ) , "PUT" , NIL ) )

    Local lAllModif        := .F.
    Local lSZ3Modif        := .F.
    Local lSZ2Modif        := .F.
    Local lSZ2Delet        := .F.
    
    Local aSZ2ColDel
    Local aSZ2RecDel
    Local nLoop
    Local nLoops
    Local nItens
    
    CursorWait()
    
        IF ( cOpcao <> "DELETE" )
            IF ( lSZ2Modif := !ArrayCompare( aSZ2Cols , aSvSZ2Cols ) )
                GdSuperDel( @aSZ2Header , @aSZ2Cols , NIL , .T. , GdGetBlock( "SZ2" , @aSZ2Header , .F. ) ) 
                lSZ2Delet := GdSplitDel( @aSZ2Header , @aSZ2Cols , @aSZ2Recnos , @aSZ2ColDel , @aSZ2RecDel  )
                IF ( lSZ2Delet )
                    SZ2->( DelRecnos( "SZ2" , @aSZ2RecDel ) )
                    lSZ2Delet    := .F.
                EndIF
                SZ2->( DelRecnos( "SZ2" , @aSZ2Recnos ) )
            EndIF
        Else
            lSZ2Modif := .T.
            lSZ3Modif := .T.
        EndIF
    
        IF ( lSZ2Modif )

            aAdd( aItens , GdPutIStrItens() )
            nItens := Len( aItens )
            aItens[ nItens , 01 ] := "SZ2"
            aItens[ nItens , 02 ] := {;
                                        { "FILIAL" , xFilial( "SZ2" , xFilial( "SZ3" ) ) },;
                                        { "CODIGO" , StaticCall( NDJLIB001 , GetMemVar , "Z3_CODIGO" ) };
                                      }
            aItens[ nItens , 03 ] := aClone( aSZ2Header )
            aItens[ nItens , 04 ] := aClone( aSZ2Cols   )
            aItens[ nItens , 05 ] := aClone( aSZ2VirtGd )
            aItens[ nItens , 06 ] := aClone( aSZ2Recnos )
    
        EndIF        
    
        IF !( lSZ3Modif )
            nLoops := Len( aSZ3Header )
            For nLoop := 1 To nLoops
                aSZ3Cols[ 01 , nLoop ] := StaticCall( NDJLIB001 , GetMemVar , aSZ3Header[ nLoop , 02 ] )
            Next nLoop
            lSZ3Modif := !( ArrayCompare( aSZ3Cols , aSvSZ3Cols ) )
        EndIF

         lAllModif := ( ( lSZ2Modif ) .or. ( lSZ3Modif ) )
    
        IF ( lAllModif )
    
            aMestre[ 01 , 01 ]    := "SZ3"
            aMestre[ 01 , 02 ]    := nReg
            aMestre[ 01 , 03 ]    := lSZ3Modif
            aMestre[ 01 , 04 ]    := aClone( aSZ3Header )
            aMestre[ 01 , 05 ]    := aClone( aSZ3VirtEn )
            aMestre[ 01 , 06 ]    := {}
            aMestre[ 01 , 07 ]    := aClone( aItens )
        
            GdPutInfoData( aMestre , cOpcao , .F. , .F. )
    
            While ( GetSX8Len() > nGetSX8Len )
                ConfirmSX8()
            End While

            SZ2ChkLnk( .F. )

        EndIF

        StaticCall( NDJLIB003 , LockSoft , "SZ3" )

        lUseC1ToZ3( xFilial( "SZ3" ) , StaticCall( NDJLIB001 , GetMemVar , "Z3_CODIGO" ) , .F. , .F. )

    CursorArrow()

Return( NIL )

/*/
    Funcao:    RpcSZ2Lnk()
    Autor:    Marinaldo de Jesus
    Data:    11/01/2011
    Uso:    Chamada Via RPC da Verificacao do "Link" de Bloqueios por Valor
    Sintaxe: 1 - RpcSZ2Lnk( { cEmp , cFil } )     //Chamada Direta
             2 - RpcSZ2Lnk( cEmp , cFil )         //Chamada Via Agendamento
/*/
User Function RpcSZ2Lnk( aParameters )

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
        
            SZ2ChkLnk( .T. )
            ChkSZ3ToSC1() //Verificar se Existem Itens de Enderecamento Sem Vinculo com a SC1

        RESET ENVIRONMENT

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( NIL )

/*/
    Funcao:     SC1LinkSZ2()
    Autor:        Marinaldo de Jesus
    Data:        27/11/2010
    Descricao:    Verificar o Link entre os Registros das Tabelas SC1 e SZ2
    Sintaxe:    StaticCall( U_NDJA001 , SC1LinkSZ2 , lDelete )
/*/
Static Function SC1LinkSZ2( lDelete )

    Local aSZ2Area        := SZ2->( GetArea() )
    Local aSZ3Area        := SZ3->( GetArea() )

    Local cXSZ2Cod
    Local cSC1Filial
    Local cSZ2Filial
    Local cSZ3Filial
    Local cSZ2KeySeek
    Local cSZ3KeySeek

    Local lSetDeleted

    Local nSZ2Order
    Local nSZ3Order

    BEGIN SEQUENCE

        DEFAULT lDelete    := .F.

        IF ( lDelete )
            lSetDeleted        := Set( _SET_DELETED , .F. )
        EndIF    
            
            cSC1Filial        := SC1->C1_FILIAL
            
            cXSZ2Cod        := SC1->C1_XSZ2COD
            cZ2NumSC        := SC1->C1_NUM
            cZ2ItemSC        := SC1->C1_ITEM
        
            cSZ3Filial        := xFilial( "SZ3" , cSC1Filial )
            cSZ3KeySeek        := ( cSZ3Filial + cXSZ2Cod )
    
        IF ( lDelete )
            Set( _SET_DELETED , lSetDeleted )
        EndIF    
    
        StaticCall( U_NDJA001 , lUseC1ToZ3 , cSZ3Filial , cXSZ2Cod , .F. , .F. )

            nSZ2Order        := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
            SZ2->( dbSetOrder( nSZ2Order ) )

            nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" ) 
            SZ3->( dbSetOrder( nSZ3Order ) )

            IF SZ3->( dbSeek( cSZ3KeySeek , .F. ) )
                IF SZ3->( RecLock( "SZ3" , .F. ) )
                    cSZ2Filial    := xFilial( "SZ2" , SZ3->Z3_FILIAL )
                    cSZ2KeySeek    := cSZ2Filial
                    cSZ2KeySeek    += cXSZ2Cod
                    cSZ2KeySeek    += cZ2NumSC
                    cSZ2KeySeek    += cZ2ItemSC
                    IF SZ2->( dbSeek( cSZ2KeySeek , .F. ) )
                        While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC == cSZ2KeySeek )
                            IF SZ2->( RecLock( "SZ2" , .F. ) )
                                IF ( lDelete )
                                    SZ2->( dbDelete() )
                                ElseIF !( SZ2->Z2_LINKED )
                                    SZ2->Z2_LINKED    := .T.
                                EndIF    
                                SZ2->( MsUnLock() )
                                SZ2->( dbSkip() )
                            EndIF
                        End While
                    EndIF
                    IF ( lDelete )
                        lDelete := IsSC1AllDeleted( @cSC1Filial , @cZ2NumSC )
                    EndIF
                    IF ( lDelete )
                        SZ3->( dbDelete() )
                    EndIF    
                    SZ3->( MsUnLock() )
                EndIF
            EndIF
    
        StaticCall( U_NDJA001 , lUseC1ToZ3 , cSZ3Filial , cXSZ2Cod , .T. , .T. )    
        
    END SEQUENCE        

    RestArea( aSZ2Area )
    RestArea( aSZ3Area )

Return( NIL  )

/*/
    Funcao:        IsSC1AllDeleted
    Data:        03/06/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Verifica se Todos os Itens da SC1 estã¯ Deletados
/*/
Static Function IsSC1AllDeleted( cSC1Filial , cNumSc )

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    
    Local cNextAlias    := GetNextAlias()
    
    Local nDel            := 0
    Local nItens        := 0

    BEGINSQL ALIAS cNextAlias
        SELECT
            Count(1) AS NISDEL
        FROM
            %table:SC1% SC1
        WHERE
            SC1.C1_FILIAL = %exp:cSC1Filial%
        AND
            SC1.C1_NUM = %exp:cNumSC%
        AND
            SC1.D_E_L_E_T_ = '*'
    ENDSQL

    nDel    := ( cNextAlias )->( NISDEL )
    ( cNextAlias )->( dbCloseArea() )

    BEGINSQL ALIAS cNextAlias
        SELECT
            Count(1) AS NALLITENS
        FROM
            %table:SC1% SC1
        WHERE
            SC1.C1_FILIAL = %exp:cSC1Filial%
        AND
            SC1.C1_NUM = %exp:cNumSC%
    ENDSQL

    nItens    := ( cNextAlias )->( NALLITENS )
    ( cNextAlias )->( dbCloseArea() )

    lIsAllDeleted    := ( nDel == nItens )

    RestArea( aSC1Area )
    RestArea( aArea )

Return( lIsAllDeleted  )

/*/
    Funcao:        ChkSZ3ToSC1
    Data:        24/11/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Verificar se existe Itens de Enderecamento sem Vinculo com a SC1 e elimina-los
/*/
Static Function ChkSZ3ToSC1( aSZ3Recnos , lLoadRecnos )

    Local aArea            := GetArea()
    Local aAreaSC1        := SC1->( GetArea() )

    Local cXSZ2Cod
    Local cSC1Filial
    Local cSZ2Filial
    Local cSZ3Filial
    Local cSC1KeySeek
    Local cSZ2KeySeek

    Local nRecno
    Local nRecnos

    Local nSC1Order
    Local nSZ2Order
    Local nSZ3Order

    BEGIN SEQUENCE

        IF !( SZ2ChkLnk() )
            BREAK
        EndIF

        cSC1Filial        := xFilial( "SC1" )
        cSZ2Filial        := xFilial( "SZ2" )
        cSZ3Filial        := xFilial( "SZ3" )
    
        nSC1Order        := RetOrder( "SC1" , "C1_FILIAL+C1_XSZ2COD+C1_NUM+C1_ITEM" )
        nSZ2Order        := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
        nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" ) 
    
        SC1->( dbSetOrder( nSC1Order ) )
        SZ2->( dbSetOrder( nSZ2Order ) )
        SZ3->( dbSetOrder( nSZ3Order ) )

        DEFAULT lLoadRecnos    := .T.
        IF Empty( aSZ3Recnos )
            IF ( lLoadRecnos )
                aSZ3Recnos    := {}
                SZ3->( dbGotop() )
                While SZ3->( !Eof() )
                    SZ3->( aAdd( aSZ3Recnos , Recno() ) )
                    SZ3->( dbSkip() )
                End While 
            Else
                BREAK
            EndIF
        EndIF

        nRecnos    := Len( aSZ3Recnos )
        For nRecno := 1 To nRecnos
            SZ3->( dbGoto( aSZ3Recnos[ nRecno ] ) )
            IF SZ3->( Eof() .or. Bof() )
                Loop
            EndIF
            cXSZ2Cod    := SZ3->Z3_CODIGO
            IF !( lUseC1ToZ3( cSZ3Filial , cXSZ2Cod , .F. , .T. ) )
                Loop
            EndIF
            IF SZ3->( !RecLock( "SZ3" , .F. ) )
                Loop
            EndIF
            cSC1KeySeek := cSC1Filial
            cSC1KeySeek += cXSZ2Cod
            IF SC1->( !dbSeek( cSC1KeySeek , .F. ) )
                IF SZ3->( RecLock( "SZ3" , .F. ) )
                    cSZ2KeySeek    := cSZ2Filial
                    cSZ2KeySeek    += cXSZ2Cod
                    IF SZ2->( dbSeek( cSZ2KeySeek , .F. ) )
                        While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO == cSZ2KeySeek )
                            IF SZ2->( RecLock( "SZ2" , .F. ) )
                                SZ2->( dbDelete() )
                                SZ2->( MsUnLock() )
                                SZ2->( dbSkip() )
                            EndIF
                        End While
                    EndIF
                    SZ3->( dbDelete() )
                    SZ3->( MsUnLock() )
                EndIF
            Else
                cSZ2KeySeek    := cSZ2Filial
                cSZ2KeySeek    += cXSZ2Cod
                IF SZ2->( dbSeek( cSZ2KeySeek , .F. ) )
                    While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO == cSZ2KeySeek )
                        cSC1KeySeek := cSC1Filial
                        cSC1KeySeek += cXSZ2Cod
                        cSC1KeySeek += SZ2->Z2_NUMSC
                        cSC1KeySeek += SZ2->Z2_ITEMSC
                        IF SC1->( !dbSeek( cSC1KeySeek , .F. ) )
                            IF SZ2->( RecLock( "SZ2" , .F. ) )
                                SZ2->( dbDelete() )
                                SZ2->( MsUnLock() )
                            EndIF
                        ElseIF !( SZ2->Z2_LINKED )
                            IF SZ2->( RecLock( "SZ2" , .F. ) )
                                SZ2->Z2_LINKED := .T.
                                SZ2->( MsUnLock() )
                            EndIF
                        EndIF
                        SZ2->( dbSkip() )
                    End While
                EndIF
            EndIF
            lUseC1ToZ3( cSZ3Filial , cXSZ2Cod , .T. , .T. )
            SZ3->( MsUnLock() )
        Next nRecno
        
    END SEQUENCE

    RestArea( aAreaSC1 )
    RestArea( aArea )

Return( NIL )

/*/
    Function:    SZ2ChkLnk
    Autor:        Marinaldo de Jesus
    Data:        24/01/2011
    Descricao:    Verificar os Links de Destinos na SZ3 e SZ2
    Sintaxe:    StaticCall(U_NDJA001,SZ2ChkLnk,lCheck)
/*/
Static Function SZ2ChkLnk( lCheck )

    Local lSZ2ChkLnk
    
    Static lStkSZ2Lnk
    
    DEFAULT lCheck         := .F.
    DEFAULT lStkSZ2Lnk    := .F.
    lSZ2ChkLnk            := lStkSZ2Lnk
    lStkSZ2Lnk             := lCheck

Return( lSZ2ChkLnk )

/*/
    Function:    lUseC1ToZ3
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Obter/Liberar a Reserva dos Links do SC1 com a SZ3
    Sintaxe:    StaticCall(U_NDJA001,lUseC1ToZ3,cFil,cZ3Codigo,lFreeMyIUse,lChkDel)
/*/
Static Function lUseC1ToZ3( cFil , cZ3Codigo , lFreeMyIUse , lChkDel )

    Local aArea            := GetArea()
    
    Local cQuery        := ""
    Local cMyIUse        := ""
    Local cNextAlias    := GetNextAlias()
    
    Local lMyIUse        := .T.

    DEFAULT cFil        := xFilial( "SZ3" )

    BEGIN SEQUENCE

        DEFAULT lChkDel    := .F.

        cQuery    := "SELECT " + CRLF      
        cQuery    += "    SZ3.R_E_C_N_O_ " + CRLF
        cQuery    +=  "FROM " + CRLF
        cQuery    +=  "    " + RetSqlName( "SZ3" ) +  " SZ3 " + CRLF
        cQuery    +=  "WHERE " + CRLF
        IF !( lChkDel )
            cQuery    +=  "    SZ3.D_E_L_E_T_ <> '*' " + CRLF
            cQuery    +=  "AND" + CRLF
        EndIF    
        cQuery    +=  "    SZ3.Z3_FILIAL = '" + cFil + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    SZ3.Z3_CODIGO = '" + cZ3Codigo + "' " + CRLF
    
        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW
    
        IF ( cNextAlias )->( Eof() )
            BREAK
        EndIF
    
        cMyIUse    := ( cEmpAnt + "SC1_SZ3" + ( cNextAlias )->( AllTrim( StrZero( R_E_C_N_O_ ) ) ) )

        ( cNextAlias )->( dbCloseArea() )

        DEFAULt lFreeMyIUse    := .F.
        IF ( lFreeMyIUse )
            lMyIUse    := StaticCall( NDJLIB003 , ReleaseCode , cMyIUse )
        Else
            lMyIUse := StaticCall( NDJLIB003 , UseCode , cMyIUse )
        EndIF    
        IF !( lMyIUse )
            BREAK
        EndIF

        cQuery    := "SELECT " + CRLF      
        cQuery    += "    SZ2.R_E_C_N_O_ " + CRLF
        cQuery    +=  "FROM " + CRLF
        cQuery    +=  "    " + RetSqlName( "SZ2" ) +  " SZ2 " + CRLF
        cQuery    +=  "WHERE " + CRLF
        IF !( lChkDel )
            cQuery    +=  "    SZ2.D_E_L_E_T_ <> '*' " + CRLF
            cQuery    +=  "AND" + CRLF
        EndIF    
        cQuery    +=  "    SZ2.Z2_FILIAL = '" + cFil + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    SZ2.Z2_CODIGO = '" + cZ3Codigo + "' " + CRLF

        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

        IF ( cNextAlias )->( Eof() )
            BREAK
        EndIF

        While ( cNextAlias )->( !Eof())

            cMyIUse    := ( cEmpAnt + "SC1_SZ2" + ( cNextAlias )->( AllTrim( StrZero( R_E_C_N_O_ ) ) ) )

            IF ( lFreeMyIUse )
                lMyIUse := StaticCall( NDJLIB003 , ReleaseCode , cMyIUse )
            Else
                lMyIUse := StaticCall( NDJLIB003 , UseCode , cMyIUse )
            EndIF    
            IF !( lMyIUse )
                BREAK
            EndIF

            ( cNextAlias )->( dbSkip() )

        End While
    
        ( cNextAlias )->( dbCloseArea() )

    END SEQUENCE

    RestArea( aArea )

Return( lMyIUse )

/*/
    Function:    Z3CodigoVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Funcao para Validar o Conteudo do Campo Z3_CODIGO
    Sintaxe:    StaticCall(U_NDJA001,Z3CodigoVld)
/*/
Static Function Z3CodigoVld()

    Local cZ3Codigo        := StaticCall( NDJLIB001 , GetMemVar , "Z3_CODIGO" )
    Local lSZ3CodigoOk    := .T.
    
    BEGIN SEQUENCE
    
        IF !( lSZ3CodigoOk := Z3GetCodigo( @cZ3Codigo , .F. , .F. ) )
            BREAK
        EndIF
    
        StaticCall( NDJLIB001 , SetMemVar , "Z3_CODIGO" , cZ3Codigo )
    
    END SEQUENCE
    
Return( lSZ3CodigoOk )

/*/
    Function:    Z3GetCodigo
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Funcao para Validar o Conteudo do Campo Z3_CODIGO
    Sintaxe:    StaticCall(U_NDJA001,Z3GetCodigo)
/*/
Static Function Z3GetCodigo( cZ3Codigo , lExistChav , lShowHelp )
    Local bGetNumExc    := { || cZ3Codigo := __Soma1( cZ3Codigo ) }
    Local cSZ3Filial    := xFilial( "SZ3" )
    IF Empty( cZ3Codigo )
        cZ3Codigo := StaticCall( NDJLIB001 , QryMaxCod , "SZ3" , "Z3_CODIGO" , "SZ3.Z3_FILIAL='" + cSZ3Filial +"'" , .T. )
        IF Empty( cZ3Codigo )
            cZ3Codigo := Replicate( "0" , GetSx3Cache( "Z3_CODIGO" , "X3_TAMANHO" ) )
        EndIF
        cZ3Codigo := Eval( bGetNumExc )
    EndIF
    SetMaxCode( NDJ_MAX_CODE )
    StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
Return(;
            GetNrExclOk(    @cZ3Codigo                 ,;
                            "SZ3"                    ,;
                            "Z3_CODIGO"                ,;
                            "Z3_FILIAL+Z3_CODIGO"    ,;
                            bGetNumExc                ,;
                            lExistChav                ,;
                            lShowHelp                  ;
                        );
        )

/*/
    Function:    Z3CodigoInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo Z3_CODIGO
    Sintaxe:    StaticCall(U_NDJA001,Z3CodigoInit)
/*/
Static Function Z3CodigoInit()
    Local cZ3Codigo
    Z3GetCodigo( @cZ3Codigo , .F. , .F. )
Return( cZ3Codigo )

/*/
    Function:    Z3NumScInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo Z3_NUMSC
    Sintaxe:    StaticCall(U_NDJA001,Z3NumScInit)
/*/
Static Function Z3NumScInit()

    Local cSZ3NumSc

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C1_NUM" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C1_NUM" ) );
        )
        cSZ3NumSc := GdFieldGet( "C1_NUM" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( Type( "cA110Num" ) == "C" )
        cSZ3NumSc := cA110Num
    Else
        DEFAULT cSZ3NumSc := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM" )
    EndIF

Return( cSZ3NumSc )

/*/
    Function:    Z2CodigoVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo Z2_CODIGO
    Sintaxe:    StaticCall(U_NDJA001,Z2CodigoVld)
/*/
Static Function Z2CodigoVld( cZ2Codigo , lShowHelp , cMsgHelp )

    Local lSZ2CodigoOK    := .T.
    
    Local nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )
    
    BEGIN SEQUENCE

        DEFAULT cZ2Codigo := StaticCall( NDJLIB001 , __FieldGet , "SZ2" , "Z2_CODIGO" )

        IF !( lSZ2CodigoOK := !Empty( cZ2Codigo ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "Z2_CODIGO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( Z2_CODIGO )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF
    
        IF !( lSZ2CodigoOK := ExistCpo("SZ3",cC1XSZ2Cod,nSZ3Order) )
            BREAK
        EndIF

    END SEQUENCE    
    
Return( lSZ2CodigoOK )

/*/
    Function:    Z2NumSCInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z2NumSC
    Sintaxe:    StaticCall(U_NDJA001,Z2NumSCInit)
/*/
Static Function Z2NumSCInit()

    Local cZ2NumSc

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C1_NUM" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C1_NUM" ) );
        )
        DEFAULT cZ2NumSc := GdFieldGet( "C1_NUM" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
        DEFAULT cZ2NumSc := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
    ElseIF ( Type( "cA110Num" ) == "C" )
        DEFAULT cZ2NumSc := cA110Num
    Else
        cZ2NumSc := Space( GetSx3Cache( "C1_NUM" , "X3_TAMANHO" ) )
    EndIF

Return( cZ2NumSc )

/*/
    Function:    Z2NumSCInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z2ItemSC
    Sintaxe:    StaticCall(U_NDJA001,Z2ItemSCInit)
/*/
Static Function Z2ItemSCInit()

    Local cZ2ItemSC

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C1_ITEM" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C1_ITEM" ) );
        )
        DEFAULT cZ2ItemSC := GdFieldGet( "C1_ITEM" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_ITEM" ) )
        DEFAULT cZ2ItemSC := StaticCall( NDJLIB001 , GetMemVar , "C1_ITEM" )
    Else
        DEFAULT cZ2ItemSC := Space( GetSx3Cache( "C1_NUM" , "X3_TAMANHO" ) )
    EndIF

Return( cZ2ItemSC )

/*/
    Function:    Z2QantVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z2Quant
    Sintaxe:    StaticCall(U_NDJA001,Z2QantVld)
/*/
Static Function Z2QantVld( nZ2Quant , lShowHelp , cMsgHelp , lTudoOk )

    Local lZ2QuantOk    := .T.

    Local nC1Quant

    BEGIN SEQUENCE

        DEFAULT nZ2Quant := StaticCall( NDJLIB001 , __FieldGet , "SZ2" , "Z2_QUANT" )

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_QUANT" , __aHeader , __aCols , __nN );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_QUANT" ) );
            )
            DEFAULT nC1Quant := GdFieldGet( "C1_QUANT" , __nN , .F. , __aHeader , __aCols )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
            DEFAULT nC1Quant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
        Else
            DEFAULT nC1Quant := 0
        EndIF

        DEFAULT lTudoOk := .F.
        lZ2QuantOk := ( ( nZ2Quant > 0 ) .and. IF( ( lTudoOk ) , ( nZ2Quant == nC1Quant ) , ( nZ2Quant <= nC1Quant ) ) )
        IF !( lZ2QuantOk )
            cMsgHelp := STR0017 + CRLF //"Quantidade Informada invá¬©da!"
            cMsgHelp += STR0018 + Transform( nZ2Quant , GetSx3Cache( "C1_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Informado: "
            cMsgHelp += STR0019 + Transform( nC1Quant , GetSx3Cache( "C1_QUANT" , "X3_PICTURE"  ) ) +  CRLF //"Disponí¶¥l: "
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lZ2QuantOk );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "Z2_QUANT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lZ2QuantOk )

/*/
    Function:    Z2QuantInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializadora Padrao do Campo Z2_QUANT
    Sintaxe:    StaticCall(U_NDJA001,Z2QuantInit)
/*/
Static Function Z2QuantInit()

    Local nZ2Quant
    
    Local nLoop
    Local nLoops
    Local nLastVal

    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C1_QUANT" , __aHeader , __aCols , __nN );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C1_QUANT" ) );
        )
        DEFAULT nZ2Quant := GdFieldGet( "C1_QUANT" , __nN , .F. , __aHeader , __aCols )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_QUANT" ) )
        DEFAULT nZ2Quant := StaticCall( NDJLIB001 , GetMemVar , "C1_QUANT" )
    Else
        DEFAULT nZ2Quant := 0
    EndIF

    IF StaticCall( NDJLIB001 , IsInGetDados , "Z2_QUANT" )
        nLoops := Len( aCols )
        For nLoop := 1 To nLoops
            IF (;
                    ( nLoop > n );
                    .or.;
                    GdDeleted( nLoop );
                )    
                Loop
            EndIF
            nLastVal := GdFieldGet( "Z2_QUANT" , nLoop )
            IF (;
                    !Empty( nLastVal );
                    .and.;
                    ( nZ2Quant >= nLastVal );
                )    
                nZ2Quant -= nLastVal
            EndIF    
        Next nLoop
    EndIF

Return( nZ2Quant )

/*/
    Function:    C1XSZ2CodWhen
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Modo de Edicao do campo    C1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C1XSZ2CodWhen)
/*/
Static Function C1XSZ2CodWhen()

    Local lIsInGD    := StaticCall( NDJLIB001 , IsInGetDados , "C1_XSZ2COD" )
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
    Function:    C8XSZ2CodWhen
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Modo de Edicao do campo    C8_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C8XSZ2CodWhen)
/*/
Static Function C8XSZ2CodWhen()

    Local lIsInGD    := StaticCall( NDJLIB001 , IsInGetDados , "C8_XSZ2COD" )
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
    Function:    C1XSZ2CodVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo C1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C1XSZ2CodVld)
/*/
Static Function C1XSZ2CodVld( cC1XSZ2Cod , lShowHelp , cMsgHelp )

    Local cNumSC
    Local cItemSC

    Local lSC1XSZ2CodOK    := .T.

    Local nSZ2Order
    Local nSZ3Order

    BEGIN SEQUENCE

        DEFAULT cC1XSZ2Cod := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XSZ2COD" )

        IF !( lSC1XSZ2CodOK := !Empty( cC1XSZ2Cod ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "C1_XSZ2COD" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( C1_XSZ2COD )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF

        IF ( Type( "cA110Num" ) == "C" )
            DEFAULT cNumSC    := cA110Num
        Else
            DEFAULT cNumSC    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM" )
        EndIF        

        nSZ3Order := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )

        IF !( lSC1XSZ2CodOK := ExistCpo("SZ3",cC1XSZ2Cod+cNumSC,nSZ3Order ) )
            cMsgHelp    := STR0023 //"A Distribuiç£¯ para esse item da SC nã¯ foi efetuada"
            BREAK
        EndIF

        DEFAULT cItemSC := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_ITEM" )

        nSZ2Order := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )

        IF !( lSC1XSZ2CodOK := ExistCpo("SZ2",cC1XSZ2Cod+cNumSC+cItemSC,nSZ2Order ) )
            cMsgHelp    := STR0023 //"A Distribuiç£¯ para esse item da SC nã¯ foi efetuada"
            BREAK
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lSC1XSZ2CodOK );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "C1_XSZ2COD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lSC1XSZ2CodOK )             

/*/
    Function:    C1XSZ2CodInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo C1_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C1XSZ2CodInit)
/*/
Static Function C1XSZ2CodInit()

    Local cC1NumSc
    Local cC1XSZ2Cod

    Local nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_NUMSC" )

    IF ( Type( "cA110Num" ) == "C" )
        cC1NumSc := cA110Num
    Else
        cC1NumSc := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM" )
    EndIF    

    SZ3->( dbSetOrder( nSZ3Order ) )
    IF SZ3->( dbSeek(  xFilial( "SZ3" ) + cC1NumSc , .F. ) )
        cC1XSZ2Cod := SZ3->Z3_CODIGO
    Else
        cC1XSZ2Cod := Space( GetSx3Cache( "C1_XSZ2COD" , "X3_TAMANHO" ) )
    EndIF

Return( cC1XSZ2Cod )

/*/
    Function:    GetSCNumItem
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Obter o Numero e o Item da SC
    Sintaxe:    StaticCall(U_NDJA001,GetSCNumItem)
/*/
Static Function GetSCNumItem( cNumSC , cItemSC )

    Local lSC1
    Local lSC8
    
    BEGIN SEQUENCE
    
        lSC1    :=    (;
                        ( StaticCall( NDJLIB001 , IsInGetDados , "C1_NUM" ) );
                        .or.;
                        ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) );
                        .or.;
                        ( Type( "cA110Num" ) == "C" );
                     )    

        lSC8    := (;
                        ( StaticCall( NDJLIB001 , IsInGetDados , "C8_NUMSC" ) );
                            .or.;
                        ( StaticCall( NDJLIB001 , IsMemVar , "C8_NUMSC" ) );
                    )    

        DO CASE
            
            CASE ( lSC1 )

                IF (;
                        StaticCall( NDJLIB001 , IsInGetDados , "C1_NUM" );
                        .and.;
                        !( StaticCall( NDJLIB001 , IsCpoVar , "C1_NUM" ) );
                    )
                    cNumSC := GdFieldGet( "C1_NUM" )
                ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
                    cNumSC := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
                ElseIF ( Type( "cA110Num" ) == "C" )
                    cNumSC := cA110Num
                EndIF
            
                IF (;
                        StaticCall( NDJLIB001 , IsInGetDados , "C1_ITEM" );
                        .and.;
                        !( StaticCall( NDJLIB001 , IsCpoVar , "C1_ITEM" ) );
                    )
                    cItemSC := GdFieldGet( "C1_ITEM" )
                ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_ITEM" ) )
                    cItemSC := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
                EndIF
            
                BREAK
        
        CASE ( lSC8 )

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C8_NUMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C8_NUMSC" ) );
                )
                cNumSC := GdFieldGet( "C8_NUMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C8_NUMSC" ) )
                cNumSC := StaticCall( NDJLIB001 , GetMemVar , "C8_NUMSC" )
            EndIF
        
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C8_ITEMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C8_ITEMSC" ) );
                )
                cItemSC := GdFieldGet( "C8_ITEMSC" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C8_ITEMSC" ) )
                cItemSC := StaticCall( NDJLIB001 , GetMemVar , "C8_ITEMSC" )
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
    Sintaxe:    StaticCall(U_NDJA001,NDJPubMemVar)
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
            aSC1Fields    := { "C1_NUM" , "C1_ITEM" , "C1_QUANT" }
            aAllACFlds    := {;
                                { "C1_NUM"         , "C1_ITEM"        , "C1_QUANT" },;
                                { "C8_NUMSC"      , "C8_ITEMSC"    , "C7_QUANT" };
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
    Function:    C8XSZ2CodVld
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Valid do Campo C8_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C8XSZ2CodVld)
/*/
Static Function C8XSZ2CodVld( cC8XSZ2Cod , lShowHelp , cMsgHelp )

    Local cNumSC
    Local cItemSC

    Local lSC8XSZ2CodOK    := .T.

    Local nSZ2Order
    Local nSZ3Order

    BEGIN SEQUENCE

        DEFAULT cC8XSZ2Cod := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_XSZ2COD" )

        IF !( lSC8XSZ2CodOK := !Empty( cC8XSZ2Cod ) )
            cMsgHelp := STR0021    //"O Campo:"
            cMsgHelp += " "
            cMsgHelp += GetCache( "SX3" , "C8_XSZ2COD" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( C8_XSZ2COD )"
            cMsgHelp += " "
            cMsgHelp += STR0022    //"deve ser preenchido."
            BREAK
        EndIF

        IF ( Type( "cA110Num" ) == "C" )
            DEFAULT cNumSC    := cA110Num
        Else
            DEFAULT cNumSC := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_NUMSC" )
        EndIF        

        nSZ3Order := RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )

        IF !( lSC8XSZ2CodOK := ExistCpo("SZ3",cC8XSZ2Cod+cNumSC,nSZ3Order ) )
            BREAK
        EndIF

        DEFAULT cItemSC := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_ITEMSC" )

        nSZ2Order := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )

        IF !( lSC8XSZ2CodOK := ExistCpo("SZ2",cC8XSZ2Cod+cNumSC+cItemSC,nSZ2Order ) )
            BREAK
        EndIF

    END SEQUENCE    

    DEFAULT lShowHelp := .T.
    IF (;
            !( lSC8XSZ2CodOK );
            .and.;
            ( lShowHelp );
            .and.;
            !( Empty( cMsgHelp ) );
        )
        Help( "" , 1 , "C8_XSZ2COD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
    EndIF    

Return( lSC8XSZ2CodOK )             

/*/
    Function:    C8XSZ2CodInit
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descricao:    Inicializador Padrao do Campo C8_XSZ2COD
    Sintaxe:    StaticCall(U_NDJA001,C8XSZ2CodInit)
/*/
Static Function C8XSZ2CodInit()

    Local cC8NumSc
    Local cC8XSZ2Cod
    
    Local nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_NUMSC" )

    TRYEXCEPTION

        DEFAULT cC8NumSc := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_NUMSC" )

        SZ3->( dbSetOrder( nSZ3Order ) )
        IF (;
                !Empty( cC8NumSc );
                .and.;
                SZ3->( dbSeek(  xFilial( "SZ3" ) + cC8NumSc , .F. ) );
            )    
            cC8XSZ2Cod := SZ3->Z3_CODIGO
        Else
            cC8XSZ2Cod := Space( GetSx3Cache( "C8_XSZ2COD" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION

        cC8XSZ2Cod := Space( GetSx3Cache( "C8_XSZ2COD" , "X3_TAMANHO" ) )
    
    ENDEXCEPTION

Return( cC8XSZ2Cod )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        NDJA001()
        NDJA001Vis()
        NDJA001Inc()
        NDJA001Alt()
        NDJA001Del()
        NDJA001Mnt()
        GdSZ2Seek()
        NDJA001TEncOk()
        oGdSZ2LinOk()
        oGdSZ2TudOk()
        SZ2GdDelOk()
        NDJA001Grava()
        SC1LinkSZ2()
        ChkSZ3ToSC1()
        SZ2ChkLnk()
        lUseC1ToZ3()
        Z3CodigoVld()
        Z3GetCodigo()
        Z3CodigoInit()
        Z3NumScInit()
        Z2CodigoVld()
        Z2NumSCInit()
        Z2ItemSCInit()
        Z2QantVld()
        Z2QuantInit()
        C1XSZ2CodWhen()
        C8XSZ2CodWhen()
        C1XSZ2CodVld()
        C1XSZ2CodInit()
        GetSCNumItem()
        NDJPubMemVar()
        C8XSZ2CodVld()
        C8XSZ2CodInit()
        SZ2SZ3COMMIT()
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
