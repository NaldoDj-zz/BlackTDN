#INCLUDE "PAN-AMERICANA.CH"
#INCLUDE "U_PANLIB01.CH"

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд?
?rograma  ?ANLIB01  ?utor?arinaldo de Jesus       ?Data ?6/11/2009?
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд?
?escri┤└o ?uncoes Genericas para uso em MarkBrowse com Filtro         ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                    ?
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?           ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           ?
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд?
?rogramador ?ata      ?ro. Ocorr.?otivo da Alteracao                ?
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд?
?           ?         ?          ?                                  ?
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддд?*/
/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
?un┤└o    ?_LIB01Exec   ?utor ?arinaldo de Jesus   ?Data ?6/11/2009?
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
?escri┤└o ?xecutar Funcoes Dentro de PANLIB01                          ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?intaxe   ?_LIB01Exec( cExecIn , aFormParam )                              ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?arametros?Vide Parametros Formais>                                     ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?etorno   ?Ret                                                          ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?bserva┤└o?                                                              ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?so       ?enerico                                                      ?
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function LIB01Exec( cExecIn , aFormParam )
         
    Local uRet
    
    DEFAULT cExecIn        := ""
    DEFAULT aFormParam    := {}
    
    IF !Empty( cExecIn )
        cExecIn    := BldcExecInFun( cExecIn , aFormParam )
        uRet    := &( cExecIn )
    EndIF
    
Return( uRet )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?rkBrwExec       ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arkBrowse com Filtro                                       ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MrkBrwExec(;
                                cAlias            ,;    //01 -> Alias para MarkBrowse
                                aFields            ,;    //02 -> Array Bidimentisonal com o Campo para o Mark e os campos chaves
                                bExec            ,;    //03 -> Bloco a ser executado a Cada Registro
                                bError            ,;    //04 -> Bloco a ser executado para Verificacao de Erro e Geracao do Log
                                cDlgTitle        ,;    //05 -> Titulo do Dialog
                                lInitFilter        ,;    //06 -> Se na Ativacao do Dialog inicializa a opcao para efetuar o Filtro
                                cCondMark         ,;    //07 -> Expressao com a Condicao para o Mark
                                aBrwFields        ,;    //08 -> Campos que constarao no Browse
                                cTopFilter        ,;    //09 -> Expressao de Filtro do Grid ( Top )
                                cBotFilter        ,;    //10 -> Expressao de Filtro do Grid ( Bottom )
                                aCoords            ,;    //11 -> Coordenadas do Objeto
                                cMark            ,;    //12 -> Conteudo a Ser Gravado no campo de controle do Mark
                                oDlg            ,;    //13 -> Objeto Dialog ( Por referencia )
                                cRdd            ,;    //14 -> Rdd do DataBase
                                lProc2Barg        ,;    //15 -> Se dever?executar Proc2BarGauge() ao clicar no Botao Confirmar.
                                aColors            ,;    //16 -> Cores para o Browse
                                aIdxCol            ,;    //17 -> aIdxCol ?
                                cFilter            ,;    //18 -> Expressao de Filtro
                                lForceRefresh    ,;    //19 -> Se Atualiza o Browse a Cada Registro Processado    
                                oMsSelect        ,;    //20 -> Objeto MsSelect por Referencia
                                lDlgPadSiga         ;    //21 -> Se o Dialog devera ser Montado no Padrao do Siga
                           )    //-> lButtonOk

    Local aArea                := GetArea()
    Local aAreaAlias        := ( cAlias )->( GetArea() )
    
    Local aSvKeys
    Local aButtons
    Local aAdvSize
    Local aInfoAdvSize
    Local aObjCoords
    
    Local bMrkBrwExec        := { || MrkBrwExec() } 
    
    Local cFieldMrkBrw        := aFields[ 1 ]
    
    Local bAllMark
    Local bConfirme
    Local bLDblClick
    Local bAllUnMark
    Local bMarkFilter
    Local bBeforeFilter
    
    Local bSet15
    Local bSet24
    Local bInitDlg
    Local bBtnSeek
    Local bBtnFilter
    Local bBtnMarkAll
    Local bBtnUnMarkAll
    Local bBtnReverse
    Local bBtnExecute
    
    Local lButtonOk
    Local lInverte
    Local lNewDialog
    
    Begin Sequence
    
        IF ( ( cAlias )->( FieldPos( cFieldMrkBrw ) ) == 0 ) 
            Break
        EndIF
    
        DEFAULT cMark            := GetMark()
        DEFAULT cRdd            := __cRdd
        DEFAULT lProc2Barg        := .T.
        DEFAULT lForceRefresh    := .F.
    
        IF !( Type( "aNewAlsIndex" ) == "A" )
            Private aNewAlsIndex      := {}
        EndIF    
        IF !( Type( "aMrkRecnos" ) == "A" )
            Private aMrkRecnos        := {}
        EndIF    
        IF !( Type( "aMrkKeys" ) == "A" )
            Private aMrkKeys        := {}
        EndIF    
    
        IF !( Type( "bNewFiltroBrw" ) == "B" )
            Private bNewFiltroBrw     := {|| NIL }
        EndIF    
        IF !( Type( "cCntMarkPut" ) == "C" )
            Private cCntMarkPut        := cMark
        EndIF    
        IF !( Type( "cSpcMarkPut" ) == "C" )
            Private cSpcMarkPut        := ( cAlias )->( Space( dbFieldInfo( DBS_LEN , FieldPos( cFieldMrkBrw ) ) ) )
        EndIF    
        IF !( Type("lAbortPrint") == "L" )
            Private lAbortPrint        := .F.
        EndIF    
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Define as Dimensoes dos Objetos                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        bLDblClick                := { || MarkOne( cAlias , cFieldMrkBrw , aFields , NIL , .T. , ( cAlias )->( !IsMark( cFieldMrkBrw , cCntMarkPut ) ) ) }
        bAllMark                := { || MarkAll( cAlias , cFieldMrkBrw , aFields , .T. , .T. , .F. ) , oMsSelect:oBrowse:Refresh() }
        bAllUnMark                := { || MarkAll( cAlias , cFieldMrkBrw , aFields , .F. , .T. , .F. ) , oMsSelect:oBrowse:Refresh() }
        bReverseMark            := { || MarkAll( cAlias , cFieldMrkBrw , aFields , NIL , .T. , .F. ) , oMsSelect:oBrowse:Refresh() }
        bConfirme                := { || Confirme( cAlias , cFieldMrkBrw , aFields , bExec , bError , lProc2Barg , IF( lForceRefresh , oMsSelect , NIL ) ) , oMsSelect:oBrowse:Refresh() }
        bBeforeFilter            := { || IF( Len( aMrkRecnos ) > 0  , Proc2BarGauge( bAllUnMark , OemToAnsi( STR0001 ) , NIL , NIL , .T. , .T. , .F. , .F. ) , .T. ) }    //"Retirando a Sele┤└o" 
        bMarkFilter                := { |cFilter| MarkFilter( cAlias , bBeforeFilter , cRdd , cFilter ) , oMsSelect:oBrowse:Refresh() }
        lButtonOk                := .F.
        lNewDialog                := !( ValType( oDlg ) == "O" )
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Define as Dimensoes dos Objetos                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        DEFAULT lDlgPadSiga        := .F.
        aAdvSize                 := MsAdvSize( NIL , lDlgPadSiga )
        IF Empty( aCoords )
            aInfoAdvSize        := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
            aObjCoords            := { { 000 , 000 , .T. , .T. } }
            aCoords                := MsObjSize( aInfoAdvSize , aObjCoords )
            aObjCoords[1,1]     := aCoords[1,4]
            aCoords[1,4]        := aCoords[1,3] 
            aCoords[1,4]        := aObjCoords[1,1]
        EndIF    
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Monta Dialog...                                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF ( lNewDialog )
            aButtons    := {}
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Pesquisa <F4>                   ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnSeek    := { || (;
                                     CursorWait() ,;
                                     MyPesqBrw(;
                                                 cAlias,;
                                                 ( cAlias )->( Recno() ),;
                                                 bNewFiltroBrw,;
                                                 cRdd,;
                                               ),;
                                     oMsSelect:oBrowse:Refresh(),;
                                     CursorArrow(),;
                                     SetKey( VK_F4 , bBtnSeek );
                                );
                            }
            aAdd( aButtons ,    {;
                                    "BMPCONS"                            ,;
                                       bBtnSeek                            ,;
                                    OemToAnsi( STR0003 + "...<F4>" )    ,;            //"Pesquisar"
                                    OemToAnsi( STR0003 )                 ;            //"Pesquisar"
                                   };
                )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Pesquisa <F4>                   ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnFilter    := { || (;
                                     CursorWait() ,;
                                     Eval( bMarkFilter ),;
                                     oMsSelect:oBrowse:Refresh(),;
                                         CursorArrow(),;
                                     SetKey( VK_F5 , bBtnFilter );
                                 );
                            }
            aAdd( aButtons ,    {;
                                    "FILTRO"                            ,;
                                       bBtnFilter                            ,;
                                    OemToAnsi( STR0004 + "...<F5>" )    ,;            //"Filtro"
                                    OemToAnsi( STR0004 )                 ;            //"Filtro"
                                   };
                )
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Marcar Todos <F9>                     ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnMarkAll    := { || CursorWait() ,;
                                Proc2BarGauge( bAllMark , OemToAnsi( STR0030 /*/"Selecionando..."/*/ ) , NIL , NIL , .T. , .T. , .F. , .F. ),;
                                CursorArrow(),;
                                SetKey( VK_F6 , bBtnMarkAll );
                            }
            aAdd( aButtons ,    {;
                                    "CHECKED"                            ,;
                                       bBtnMarkAll                            ,;
                                    OemToAnsi( STR0005 + "...<F6>" )    ,;            //"Marca Todos"
                                    OemToAnsi( STR0029 )                 ;            //"Mrc.Todos"
                                   };
                )
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Desmarcar Todos <F10>                 ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnUnMarkAll    := { || CursorWait() ,;
                                    Proc2BarGauge( bAllUnMark , OemToAnsi( STR0001 /*/"Retirando a SeleГЦo..."/*/ ) , NIL , NIL , .T. , .T. , .F. , .F. ),;        //"Desmarca Todos"
                                    CursorArrow(),;
                                    SetKey( VK_F7 , bBtnUnMarkAll );
                                }
            aAdd( aButtons ,    {;
                                    "UNCHECKED"                            ,;
                                       bBtnUnMarkAll                        ,;
                                    OemToAnsi( STR0027 + "...<F7>" )    ,;            //"Desmarca Todos"
                                    OemToAnsi( STR0028 )                 ;            //"Dsm.Todos"
                                   };
                )
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Desmarcar Todos <F11>                 ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnReverse    := { || CursorWait() ,;
                                Proc2BarGauge( bReverseMark , OemToAnsi( STR0026 /*/"Invertendo a SeleГЦo..."/*/ ) , NIL , NIL , .T. , .T. , .F. , .F. ),;
                                CursorArrow(),;
                                SetKey( VK_F8 , bBtnReverse );
                            }
            aAdd( aButtons ,    {;
                                    "S4WB014B"                            ,;
                                       bBtnReverse                            ,;
                                    OemToAnsi( STR0024 + "...<F8>" )    ,;            //"Inverte Sele┤└o"
                                    OemToAnsi( STR0025 )                 ;            //"Inverte"
                                   };
                )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Desmarcar Todos <F11>                 ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnExecute    := { ||;
                                Eval( bConfirme ),;
                                SetKey( VK_F9 , bConfirme );
                            }
            aAdd( aButtons ,    {;
                                    "DBG03"                                ,;
                                       bConfirme                            ,;
                                    OemToAnsi( STR0031 + "...<F9>" )    ,;            //"Executar..."
                                    OemToAnsi( STR0031 )                 ;            //"Executar..."
                                   };
                )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para as Teclas <CTRL-O>                       ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bSet15         := { || lButtonOk := .T. , oDlg:End() }
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para as Teclas <CTRL-X>                           ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bSet24        := { || lButtonOk := .F. , GetKeys() , oDlg:End() }
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para o INIT do DIALOG                         ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bInitDlg    := { ||;    
                                EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
                                Eval( oMsSelect:oBrowse:bGotop )    ,;
                                oMsSelect:oBrowse:Refresh()            ,;
                                SetKey( VK_F4 , bBtnSeek )            ,;
                                SetKey( VK_F5 , bBtnFilter )        ,;
                                SetKey( VK_F6 , bBtnMarkAll )        ,;
                                SetKey( VK_F7 , bBtnUnMarkAll )        ,;
                                SetKey( VK_F8 , bBtnReverse )        ,;
                                SetKey( VK_F9 , bConfirme )             ;    
                             }
    
            aSvKeys := GetKeys()
            DEFINE MSDIALOG oDlg TITLE cDlgTitle FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL 
            oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
        EndIF
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Monta MarkBrowse...                                                      ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            oMsSelect := MsSelect():New(;
                                            cAlias                ,;    //01 -> Alias    do Arquivo de Filtro
                                            cFieldMrkBrw        ,;    //02 -> Campo para controle do mark
                                            cCondMark            ,;    //03 -> Condicao para o Mark
                                            aBrwFields            ,;    //04 -> Array com os Campos para o Browse e.g.: { { FIELD_NAME , "" , FIELD_DESC , FIELD_PICTURE } }
                                            @lInverte            ,;    //05 -> Logico, e por referencia, Condicao do Mark
                                            cCntMarkPut            ,;    //06 -> Conteudo a Ser Gravado no campo de controle do Mark
                                            aCoords[1]            ,;    //07 -> Coordenadas do Objeto
                                            cTopFilter            ,;  //08 -> Expressao de Filtro do Grid ( Top )
                                            cBotFilter            ,;    //09 -> Expressao de Filtro do Grid ( Bottom )
                                            oDlg                ,;    //10 -> Objeto Dialog
                                            aIdxCol                ,;    //11 -> ?
                                            aColors                 ;    //12 -> Array com as Cores para o Browse e.g.:  { { cCond1 , "BR_VERDE" } , { cCond2 , "BR_VERMELHO" } }
                                        )
            oMsSelect:oBrowse:bLDblClick    := bLDblClick
            oMsSelect:oBrowse:lAllMark        := .F.
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Ativa o Dialogo...                                                       ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF ( lNewDialog )
    
            DEFAULT lInitFilter := .F.
            IF !Empty( cFilter )
                lInitFilter := .T.
                Eval( bMarkFilter , cFilter )
            EndIF
    
            ACTIVATE DIALOG oDlg CENTERED ON INIT Eval( bInitDlg )
            ObjFree( @oMsSelect )
            ObjFree( @oDlg )
            RestKeys( aSvKeys , .T. )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Fim da Rotina Principal                                                  ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            IF ( Len( aMrkRecnos ) > 0 )
                Proc2BarGauge( { || MarkAll( cAlias , cFieldMrkBrw , aFields , .F. , .F. , .F. ) } , OemToAnsi( STR0001 /*/"Retirando a Sele┤└o" /*/ ) , NIL , NIL , .T. , .T. , .F. , .F. )
                aMrkRecnos    := {}
                aMrkKeys    := {}
            EndIF
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Finaliza Filtro                                                           ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            MyEndFilBrw( @cAlias , @aNewAlsIndex , cRdd )
    
        EndIF
    
    End Sequence
    
    RestArea( aAreaAlias )
    RestArea( aArea )
    
    Return( lButtonOk )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?arkFilter         ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?iltra os registros da MarkBrowse                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MarkFilter( cAlias , bBeforeFilter , cRdd , cFilter )

    Local lExecFilter
    
    Local nPosAlias
    
    Static aFilterRet
    
    DEFAULT aFilterRet    := {}
    
    nPosAlias := aScan( aFilterRet , { |aElem| ( aElem[ 1 ] == cAlias ) } )
    IF ( nPosAlias == 0 )
        aAdd( aFilterRet , { cAlias , "" } )
        nPosAlias := Len( aFilterRet )
    EndIF
    
    IF Empty( cFilter )
        cFilter := aFilterRet[ nPosAlias , 2 ]
        IF GpFltBldExp( cAlias , NIL , @cFilter , NIL )
            lExecFilter := ( !Empty( cFilter ) .and. ( cFilter <> aFilterRet[ nPosAlias , 2 ] ) )
        EndIF
        aFilterRet[ nPosAlias , 2 ] := cFilter
        IF ( lExecFilter )
            Eval( bBeforeFilter )
        EndIF
    Else
        aFilterRet[ nPosAlias , 2 ]    := cFilter
    EndIF
    
    MyEndFilBrw( @cAlias , @aNewAlsIndex , cRdd )
    aNewAlsIndex    := {}
    bNewFiltroBrw    := { || ( cAlias )->( FilBrowse( cAlias , @aNewAlsIndex , @cFilter ) ) }
    MsAguarde( bNewFiltroBrw , STR0006 )    //"Filtrando Registros"
    
    ( cAlias )->( dbGoTop() )

Return( lExecFilter )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?arkAll          ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arca/Desmarca todos os elementos do browse                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MarkAll( cAlias , cFieldMrkBrw , aFields , lMarca , lShowMsg , lInsiste )

    Local aNoLocks        := {}
    Local aRecnos        := {}
    
    Local bWhile        := { |cWhile| &( cWhile ) } 
    
    Local cAliasFil        := IF( FilChkField( cAlias ) , xFilial( cAlias ) , "" )
    Local cMsg            := ""
    Local cAliasFilter    := ( cAlias )->( dbFilter() )
    Local cAliasFldFil  := ""
    Local cTimeIni        := Time()
    
    Local lLock            := .F.
    Local lChkMrk        := .T.
    Local lUseCode        := lMarca
    Local lMaxAdsLckRec    := .F.
    
    Local nRecno        := ( cAlias )->( Recno() )
    Local nLocks        := 0
    
    Local nLoop
    Local nLoops
    Local nNoLock
    Local nLastSize
    Local nProcRegua
    
    DEFAULT lShowMsg    := .T.
    DEFAULT lInsiste    := .T.
    
    CursorWait()
        IF (;
                !( lMarca == NIL );
                .and.;
                !( lMarca );
            )    
            IF !( lAbortPrint )
                cAliasFilter += IF( !Empty( cAliasFilter ) , " .and. IsMark('"+cFieldMrkBrw+"','"+cCntMarkPut+"')" , "IsMark('"+cFieldMrkBrw+"','"+cCntMarkPut+"')" )
            EndIF
        EndIF
        IF FilChkField( cAlias , @cAliasFldFil )
            IF ( !Empty( cAliasFilter ) )
                cAliasFilter += " .and. " + cAliasFldFil + " == '" + cAliasFil + "'"
            Else
                cAliasFilter += cAliasFldFil + " == '" + cAliasFil + "'"
            EndIF
        Else
            cAliasFldFil := ""
            IF ( Empty( cAliasFilter ) )
                cAliasFilter := " .T. "
            EndIF
        EndIF
        IF (;
                ( lMarca == NIL );
                .or.;
                ( lMarca );
                .or.;
                Empty( aMrkRecnos );
            )    
            CREATE SCOPE aScopeCount FOR &( cAliasFilter )
            IF ( FilChkField( cAlias ) )
                ( cAlias )->( dbSeek( cAliasFil , .F. ) )
            Else
                ( cAlias )->( dbGoTop() )
            EndIF
            nProcRegua    :=     ( cAlias )->( ScopeCount( aScopeCount , cAlias , @aRecnos ) )
        Else
            aRecnos        := aClone( aMrkRecnos )
            nProcRegua    := Len( aRecnos )
        EndIF
        RstTimeRemaining() //Reinicializa o Contador de Tempos em Proc2BarGauge()
        BarGauge1Set( nProcRegua )
    CursorArrow()
    
    lAbortPrint := .F.
    
    nLoop    := 0
    nLoops    := nProcRegua
    While ( ( ++nLoop ) <= nLoops )
    
        IncPrcG1Time( NIL , nProcRegua , cTimeIni , .T. , NIL , 1 )
        IF ( lAbortPrint )
            Exit
        EndIF
    
        ( cAlias )->( dbGoTo( aRecnos[ nLoop ] ) )
        IF ( cAlias )->( Eof() )
            Loop
        EndIF
    
        lLock := ( cAlias )->( MarkOne( cAlias , cFieldMrkBrw , aFields , lMarca , lInsiste , lUseCode ) )
    
        IF ( lMarca )
            IF ( lLock )
                ++nLocks
            Else
                aAdd( aNoLocks , ( cAlias )->( Recno() ) )
            EndIF
        EndIF
    
    End While
    
    IF ( lMarca )
        IF ( Len( aNoLocks ) > 0 )
            IF ( nLocks == 0 )
                cMsg := STR0007    //"N? foi poss?el a reserva dos registros"
                cMsg += CRLF
                lChkMrk := .F.
            Else
                cMsg := STR0008    //"N? foi poss?el a reserva de alguns registros"
                cMsg += CRLF
            EndIF
            IF ( lMaxAdsLckRec := U_LIB02Exec( "MaxAdsLckRec" ) )
                cMsg += STR0009    //"Excedeu o n?ero de registros a serem reservados."
                CursorWait()
                nLoops := Len( aNoLocks )
                For nLoop := 1 To nLoops
                    IF ( ( nNoLock := aScan( aMrkRecnos , { |x| ( x == aNoLocks[ nLoop ] ) } ) ) > 0 )
                        U_LIB02Exec( "FreeCodeUsed" , { cAlias , aMrkKeys[ nNoLock ] } )
                        nLastSize := Len( aMrkRecnos )
                        aDel( aMrkRecnos     , nNoLock )
                        aDel( aMrkKeys         , nNoLock )
                        aSize( aMrkRecnos    , ( nLastSize - 1 ) )
                        aSize( aMrkKeys        , ( nLastSize - 1 ) )
                    EndIF
                Next nLoop
                CursorArrow()
            Else
                cMsg += STR0010    //"Estes registros est? reservados para outro usu?io."
            EndIF
            cMsg += CRLF
            cMsg += STR0011    //"O Processo, para estes registros, n? ser?efetuado."
        EndIF
        IF ( lShowMsg )
            IF ( !Empty( cMsg ) )
                MsgInfo( OemToAnsi( cMsg ) )
            EndIF
        EndIF
    EndIF
        
    IF ( lChkMrk )
        lMarca := !( lMarca )
    EndIF
    
    ( cAlias )->( MsGoto( nRecno ) )

Return( lChkMrk )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?arkOne           ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arca/desmarca um elemento do browse.                        ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MarkOne(;
                                cAlias            ,;
                                cFieldMrkBrw    ,;
                                aFields            ,;
                                lAll            ,;
                                lShowHelp        ,;
                                lUseCode         ;
                          )

    Local aRec        := Array( 1 )
    Local aKey        := Array( 1 )
    
    Local lLock        := .F.
    
    Local bMark        := { || MarkUnMark( cAlias , cFieldMrkBrw , aFields , lAll ) }
    
    Local bLock
    
    Local cMsg
    
    Local nPos
    
    DEFAULT cAlias        := Alias()
    DEFAULT lShowHelp    := .T.
    
    Begin Sequence
    
         aRec[1]    := ( cAlias )->( Recno() )
        aKey[1]    := aFlds2Str( cAlias , aFields[ 2 ] )
    
        IF ( lShowHelp )
            cMsg := OemToAnsi( STR0012 /*/"O Registro "/*/ + " " + AllTrim( Str( aRec[1] ) ) + " " + STR0013 /*/" est?reservado para outro usu?io."/*/ )
            bLock := { || LockRegs( cAlias , cFieldMrkBrw , aFields , aRec , aKey , cMsg , .T. , lUseCode ) }
        Else
            bLock := { || U_LIB02Exec( "LockRegsCode" , { cAlias , aRec , aKey , 0 , 0 , lUseCode , NIL } ) }
        EndIF
    
        IF !( lLock := ( cAlias )->( Eval( bLock ) ) )
            Break
        EndIF
    
        lLock := ( cAlias )->( Eval( bMark ) )
    
    End Sequence

Return( lLock )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?arkUnMark       ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arca/desmarca um elemento do browse.                        ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MarkUnMark( cAlias , cFieldMrkBrw , aFields , lAll )

    Local lIsMark     := ( cAlias )->( IsMark( cFieldMrkBrw , cCntMarkPut ) )
    Local lIsLocked    := ( cAlias )->( !Eof() .and. U_LIB02Exec( "IsLocked" , { cAlias , Recno() } ) )
    
    IF ( lIsLocked )
        IF ( lAll == NIL )    //Inverte
            IF ( lIsMark )
                ( cAlias )->( FieldPut( FieldPos( cFieldMrkBrw ) , cSpcMarkPut ) )
                AddRmvMrk( cAlias , aFields , .T. )
            Else
                ( cAlias )->( FieldPut( FieldPos( cFieldMrkBrw ) , cCntMarkPut ) )
                AddRmvMrk( cAlias , aFields , .F. )
            EndIF
        Else
            IF ( lAll )
                ( cAlias )->( FieldPut( FieldPos( cFieldMrkBrw ) , cCntMarkPut ) )
                AddRmvMrk( cAlias , aFields , .F. )
            ElseIF ( lIsMark )
                ( cAlias )->( FieldPut( FieldPos( cFieldMrkBrw ) , cSpcMarkPut ) )
                AddRmvMrk( cAlias , aFields , .T. )
            EndIF
        EndIF
    EndIF
    
Return( lIsLocked )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?ddRmvMrk        ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?eserva/Liberacao do(s) Recno(s) e Chave(s) qdo Mark/UnMark ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function AddRmvMrk( cAlias , aFields , lRmv )

    Local cKey      := aFlds2Str( cAlias , aFields[ 2 ] )
    
    Local nRec      := ( cAlias )->( Recno() )
    Local nPos        := aScan( aMrkRecnos , { |x| ( x == nRec ) } )
    
    Local nLastSize
    
    DEFAULT lRmv := .F.
    
    IF ( lRmv )
        IF ( U_LIB02Exec( "IsLocked" , { cAlias , nRec } ) )
            MyUnLockRegs( cAlias , nRec , cKey )
        EndIF
        IF ( nPos > 0 )
            nLastSize := Len( aMrkRecnos )
            aDel( aMrkRecnos     , nPos )
            aDel( aMrkKeys         , nPos )
            aSize( aMrkRecnos    , ( nLastSize - 1 ) )
            aSize( aMrkKeys        , ( nLastSize - 1 ) )
        EndIF
    Else
        IF ( nPos == 0 )
            aAdd( aMrkRecnos , nRec )
            aAdd( aMrkKeys     , cKey )
        EndIF
    EndIF

Return( NIL )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?onfirme         ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?hama a rotina a ser processada para os regostros  seleciona?
?         ?os                                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function Confirme( cAlias , cFieldMrkBrw , aFields , bExec , bError , lProc2Barg , oMsSelect )

    Local bLock                 := { || CursorWait() , lLocksOk := LockRegs( cAlias , cFieldMrkBrw , aFields ) , CursorArrow() , lLocksOk }
    Local bUnLock            := { || CursorWait() , MyUnLockRegs( cAlias ) , CursorArrow() }
    Local bExecute            := { || CursorWait() , uReturn := Execute( @cAlias , @bExec , @bError , @aLogDet , @aLogTit , @lProc2Barg , @oMsSelect ) , CursorArrow() }
    
    Local lLocksOk            := .T.
    
    Local aLogDet
    Local aLogTit
    
    Local uReturn
    
    Begin Sequence
    
        MsAguarde( bLock , OemToAnsi( STR0014 ) ) //"Reservando o(s) Registro(s)"
        IF !( lLocksOk )
            Break
        EndIF
    
        IF Empty( aMrkRecnos )
            MsgInfo( OemToAnsi( STR0015 ) )    //"N? existe(m) Registro(s) selecionado(s)"
            Break
        EndIF
    
        IF ( lProc2Barg )
            Proc2BarGauge( bExecute , NIL , NIL , NIL , .T. , .T. , .F. , .F. )
        Else
            Eval( bExecute )
        EndIF    
    
        MsAguarde( bUnLock , OemToAnsi( STR0016 ) )    //"Liberando o(s) Registro(s)"
    
    End Sequence
    
    IF ( Len( aMrkRecnos ) > 0 )
        //"Retirando a SeleГЦo"
        Proc2BarGauge( { || MarkAll( cAlias , cFieldMrkBrw , aFields , .F. , .F. , .F. ) } , OemToAnsi( STR0001 /*/"Retirando a Sele┤└o" /*/ ) , NIL , NIL , .T. , .T. , .F. , .F. )
        aMrkRecnos    := {}
        aMrkKeys    := {}
    EndIF    
    
    IF (;
            ( ValType( aLogDet ) == "A" );
            .and.;
            ( ValType( aLogTit ) == "A" );
            .and.;
            !Empty( aLogDet );
            .and.;    
            MsgNoYes( STR0017 );    //"Deseja Consultar o Log?"
        )    
        MsAguarde(;
                    { ||;
                            fMakeLog(    aLogDet        ,;    //Array que contem os Detalhes de Ocorrencia de Log
                                        aLogTit        ,;    //Array que contem os Titulos de Acordo com as Ocorrencias
                                        NIL            ,;    //Pergunte a Ser Listado
                                        .T.            ,;    //Se Havera "Display" de Tela
                                        FunName()    ,;    //Nome Alternativo do Log
                                        NIL            ,;    //Titulo Alternativo do Log
                                        "G"            ,;    //Tamanho Vertical do Relatorio de Log ("P","M","G")
                                        "L"            ,;    //Orientacao do Relatorio ("P" Retrato ou "L" Paisagem )
                                        NIL            ,;    //Array com a Mesma Estrutura do aReturn
                                        .T.             ;    //Se deve Manter ( Adicionar ) no Novo Log o Log Anterior
                                    ),;
                            STR0018; //"Montando Relat?io de Log..."
                    };
                  )
    EndIF

Return( uReturn )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?xecute          ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?xecuta a Rotina para Cada Registro                         ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function Execute( cAlias , bExec , bError , aLogDet , aLotTit , lProc2Barg , oMsSelect )

    Local aRecnosOk        := {}
    Local aRecnosNoOk    := {}
    
    Local cTimeIni        := Time()
    
    Local lForceRefresh    := ( ValType( oMsSelect ) == "O" )
    
    Local nRecno
    Local nRecnos
    
    Local uRet
    Local uError
    
    RstTimeRemaining() //Reinicializa o Contador de Tempos em Proc2BarGauge()
    
    nRecnos := Len( aMrkRecnos )
    
    IF ( lProc2Barg )
        BarGauge1Set( nRecnos )
    EndIF    
    
    For nRecno := 1 To nRecnos
    
        IF ( lProc2Barg )
    
            IncPrcG1Time( NIL , nRecnos , cTimeIni , .T. , NIL , 1 )
    
            IF ( lAbortPrint )
                Exit
            EndIF
    
        EndIF
    
        ( cAlias )->( dbGoTo( aMrkRecnos[ nRecno ] ) )
        IF ( cAlias )->( Eof() )
            Loop
        EndIF
    
        IF ( lForceRefresh )
            oMsSelect:oBrowse:Refresh()
        EndIF    
    
        DEFAULT bExec    := { |nRecno,lLastRegister| .T. }
        uRet     := ( cAlias )->( Eval( bExec , aMrkRecnos[ nRecno ] , ( nRecno == nRecnos ) ) )
        IF ( ValType( uRet ) == "L" )
            IF !( uRet )
                aAdd( aRecnosNoOk    , aMrkRecnos[ nRecno ] )
            Else
                aAdd( aRecnosOk        , aMrkRecnos[ nRecno ] )
            EndIF
        EndIF
    
    Next nRecno
    
    IF ( ValType( bError ) == "B" )
        MsAguarde( { || uError := Eval( bError , aRecnosOk , aRecnosNoOk ) } , STR0019 )    //"Verificando InformaГУes para a GeraГЦo do Log..."
        IF (;
                ( ValType( uError ) == "A" );
                .and.;
                !Empty( uError );
            )    
            IF ( Len( uError ) >= 1 )
                aLogDet    := uError[1]
            EndIF    
            IF ( Len( uError ) >= 2 )
                aLotTit    := uError[2]
            EndIF    
        EndIF
    EndIF    

Return( uRet )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?ockRegs         ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?ock dos Registros                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function LockRegs(;
                                cAlias            ,;
                                cFieldMrkBrw    ,;
                                aFields            ,;
                                aRecnos            ,;
                                aKeys            ,;
                                cMsg1            ,;
                                lMultLock        ,;
                                lUseCode         ;
                            )

    Local lLocks        := .T.
    
    Local aHeaderFields
    
    Local bSkip
    Local bLock
    
    Local cAliasFil
    Local cQueryCond
    Local cAliasFilter
    Local cAliasFldFil
    
    DEFAULT aMrkRecnos    := {}
    DEFAULT aMrkKeys    := {}
    DEFAULT aRecnos     := aMrkRecnos
    DEFAULT aKeys        := aMrkKeys
    DEFAULT cMsg1        := STR0020    //"N? foi possivel reservar todos os registros"
    DEFAULT lMultLock    := .T.
    DEFAULT lUseCode    := .T.
    
    Begin Sequence
    
        IF ( lMultLock )
            IF ( Empty( aRecnos ) .and. Empty( aKeys ) )
                cAliasFil := IF( FilChkField( cAlias ) , xFilial( cAlias ) , "" )
                #IFDEF TOP
                    cQueryCond    := ""
                    IF FilChkField( cAlias , @cAliasFldFil )
                        cQueryCond += cAliasFldFil+"='"+cAliasFil+"'"
                        cQueryCond += " AND "
                    EndIF
                    cQueryCond += cFieldMrkBrw+"='"+cCntMarkPut+"'"
                    cQueryCond += " AND "
                    cQueryCond += "D_E_L_E_T_<>'*' "
                #ENDIF
                aFlds2Str( cAlias , aFields[ 2 ] )
                aHeaderFields    := aFields[ 2 ]
                aAdd( aHeaderFields , cFieldMrkBrw )
                IF Empty( cAliasFilter := ( cAlias )->( dbFilter() ) )
                    bSkip    := { || !IsMark( cFieldMrkBrw , cCntMarkPut ) }
                Else
                    bSkip    := { || !IsMark( cFieldMrkBrw , cCntMarkPut ) .or. !( &( cAliasFilter ) ) }
                EndIF    
                aKeys     := {}
                aRecnos := {}
                bLock     := { |lLock,lExclu|    lLock     := .T.    ,;
                                            lExclu    := .T.    ,;
                                            GdMontaCols(    NIL                ,;    //01 -> Array com os Campos do Cabecalho da GetDados
                                                            NIL                ,;    //02 -> Numero de Campos em Uso
                                                            NIL                ,;    //03 -> [@]Array com os Campos Virtuais
                                                            NIL                ,;    //04 -> [@]Array com os Campos Visuais
                                                            cAlias             ,;    //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
                                                            aHeaderFields    ,;    //06 -> Opcional, Campos que nao Deverao constar no aHeader
                                                            @aRecnos        ,;    //07 -> [@]Array unidimensional contendo os Recnos
                                                            cAlias               ,;    //08 -> Alias do Arquivo Pai
                                                            cAliasFil        ,;    //09 -> Chave para o Posicionamento no Alias Filho
                                                            NIL              ,;    //10 -> Bloco para condicao de Loop While
                                                            bSkip            ,;    //11 -> Bloco para Skip no Loop While
                                                            .F.             ,;    //12 -> Se Havera o Elemento de Delecao no aCols 
                                                            .F.             ,;    //13 -> Se cria variaveis Publicas
                                                            .F.             ,;    //14 -> Se Sera considerado o Inicializador Padrao
                                                            NIL              ,;    //15 -> Lado para o inicializador padrao
                                                            .F.               ,;    //16 -> Opcional, Carregar Todos os Campos
                                                            .T.             ,;    //17 -> Opcional, Nao Carregar os Campos Virtuais
                                                            cQueryCond        ,;    //18 -> Opcional, Utilizacao de Query para Selecao de Dados
                                                            .F.                ,;    //19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
                                                            .T.                ,;    //20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
                                                            .F.                ,;    //21 -> Carregar Coluna Fantasma
                                                            .T.                ,;    //22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
                                                            .F.                ,;    //23 -> Verifica se Deve verificar se o campo eh usado
                                                            .F.                ,;    //24 -> Verifica se Deve verificar o nivel do usuario
                                                            .F.                ,;    //25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
                                                            @aKeys            ,;    //26 -> [@]Array que contera as chaves conforme recnos
                                                            @lLock            ,;    //27 -> [@]Se devera efetuar o Lock dos Registros
                                                            @lExclu             ;    //28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
                                                        ),;
                                            ( lLock .and. lExclu );
                            }
                aMrkRecnos    := aClone( aRecnos )
                aMrkKeys    := aClone( aKeys   )                
            Else
                bLock := { || U_LIB02Exec( "LockRegsCode" , { cAlias , aRecnos , aKeys , 0 , 0 , lUseCode , NIL } ) }
            EndIF
        EndIF
    
        IF !( lLocks := WhileYesNoWait(;
                                            bLock                                                                ,;    //Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
                                            5                                                                    ,;    //Numero de Tentativas
                                            .T.                                                                    ,;    //Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
                                            OemToAnsi( cMsg1 )                                                    ,;    //Mensagem de Corpo para a MsgInfo
                                            OemToAnsi( STR0021 ) /*/"Lock de Registro"/*/                        ,;    //Titulo para a MsgInfo 
                                            OemToAnsi( STR0022 ) /*/"Tentar novamente?"/*/                         ,;    //Mensagem de Corpo para a MsgYesNo
                                            OemToAnsi( STR0021 ) /*/"Lock de Registro"/*/                        ,;    //Titulo para a MsgYesNo
                                            OemToAnsi( STR0023 ) /*/"Tentando reservar o(s) registro(s)." )/*/    ,;    //Mensagem de corpo para a ProcWaiting
                                            OemToAnsi( STR0021 ) /*/"Lock de Registro"/*/                          ;    //Titulo para a ProcWaiting
                                      );
            )
            Break
        EndIF
    
    End Sequence
    
Return( lLocks )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?yUnLockRegs     ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?ibera os Locks dos Registros                                ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MyUnLockRegs( cAlias , nRecno , cUsedCod )
Return( U_LIB02Exec( "FreeLocks" , { cAlias , nRecno , .T. , cUsedCod } ) )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?yEndFilBrw      ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?inaliza o Filtro da Tabela                                  ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MyEndFilBrw( cAlias , aIndex , cRdd )

    IF (;
            PosAlias( "SX2" , cAlias , NIL , NIL , 1 , .F. );
            .and.;
            ( PosAlias( "SX2" , cAlias , NIL , "X2_CHAVE" , 1 , .F. ) == cAlias );
            .and.;
            Sx2ChkTable( cAlias , cRdd );
        )
        ( cAlias )->( EndFilBrw( @cAlias , @aIndex ) )
    Else
        ( cAlias )->( dbClearFilter() )
    EndIF
    
Return( NIL )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?yPesqBrw         ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?fetuar Pesquisa no Browse                                   ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MyPesqBrw( cAlias , nRecno , bNewFiltroBrw , cRdd , nOrder )

    IF (;
            PosAlias( "SX2" , cAlias , NIL , NIL , 1 , .F. );
            .and.;
            ( PosAlias( "SX2" , cAlias , NIL , "X2_CHAVE" , 1 , .F. ) == cAlias );
            .and.;
            Sx2ChkTable( cAlias , cRdd );
        )
        ( cAlias )->( PesqBrw( cAlias , nRecno , bNewFiltroBrw ) )
    Else
        MyBrwPesq( cAlias , nOrder )    
    EndIF
    
Return( NIL )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?yBrwPesq        ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?esquisa Especifica                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?rkBrwExec                                                  ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MyBrwPesq( cAlias , nOrder )

    Local aGetKeys    := GetKeys()
    Local oDlg
    Local cPesq        := Space( 100 )
    
    Local bSet15    := { || lPesq := .T. , oDlg:End() }
    Local bSet24    := { || oDlg:End() }
    
    Local lPesq        := .F.
    Local lFound    := .F.
    
    Local oPesq
    
    DEFINE MSDIALOG oDlg TITLE OemToAnsi( STR0003 ) From 0,0 TO 100,300 OF GetWndDefault() STYLE DS_MODALFRAME STATUS  PIXEL    //"Pesquisar"
        @ 025,010 MSGET oPesq VAR cPesq    SIZE 130,010 OF oDlg PIXEL PICTURE "@!" 
    ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )
    
    IF ( lPesq )
        DEFAULT nOrder := 1
        (cAlias)->( dbSetOrder( 1 ) )
        (cAlias)->( dbSeek( AllTrim( Upper( cPesq ) ) ) )
    EndIF
    
    RestKeys( aGetKeys )
    
Return( lFound  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?roc2BarGauge ?utor?arinaldo de Jesus   ?Data ?5/09/2006?
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?rocessa com 2 Barras de Gauge                              ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function Proc2BarGauge(;
                                bAction        ,;    //01 -> Acao a ser Executada
                                   cTitle        ,;    //02 -> Titulo do Dialogo
                                cMsg1        ,;    //03 -> Mensagem para a 1a. BarGauge
                                cMsg2        ,;    //04 -> Mensagem para a 2a. BarGauge
                                lAbort        ,;    //05 -> Se habilitara o botao para "Abortar" o processo
                                lProcTime1    ,;    //06 -> Se havera controle de estimativa de tempo na 1a. BarGauge
                                lProcTime2    ,;    //07 -> Se havera conteole de estimativa de tempo na 2a. BarGauge
                                lShow2Gauge     ;    //08 -> Se ira mostrar a 2a. BarGauge
                               )
                               
    Local aProc2BarGauge    := {;
                                    bAction        ,;    //01 -> Acao a ser Executada
                                       cTitle        ,;    //02 -> Titulo do Dialogo
                                    cMsg1        ,;    //03 -> Mensagem para a 1a. BarGauge
                                    cMsg2        ,;    //04 -> Mensagem para a 2a. BarGauge
                                    lAbort        ,;    //05 -> Se habilitara o botao para "Abortar" o processo
                                    lProcTime1    ,;    //06 -> Se havera controle de estimativa de tempo na 1a. BarGauge
                                    lProcTime2    ,;    //07 -> Se havera conteole de estimativa de tempo na 2a. BarGauge
                                    lShow2Gauge     ;    //08 -> Se ira mostrar a 2a. BarGauge
                                }
    
    Local uRet                := U_LIB03Exec( "Proc2BarGauge" , @aProc2BarGauge )
    
    bAction        := aProc2BarGauge[1]    //01 -> Acao a ser Executada
    cTitle        := aProc2BarGauge[2]    //02 -> Titulo do Dialogo
    cMsg1        := aProc2BarGauge[3]    //03 -> Mensagem para a 1a. BarGauge
    cMsg2        := aProc2BarGauge[4]    //04 -> Mensagem para a 2a. BarGauge
    lAbort        := aProc2BarGauge[5]    //05 -> Se habilitara o botao para "Abortar" o processo
    lProcTime1    := aProc2BarGauge[6]    //06 -> Se havera controle de estimativa de tempo na 1a. BarGauge
    lProcTime2    := aProc2BarGauge[7]    //07 -> Se havera conteole de estimativa de tempo na 2a. BarGauge
    lShow2Gauge    := aProc2BarGauge[8]    //08 -> Se ira mostrar a 2a. BarGauge

Return( uRet )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?arGauge1Set  ?utor?arinaldo de Jesus   ?Data ?5/09/2006?
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?eta o Totalizador da Gauge1                                  ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function BarGauge1Set( nProcRegua )
Return( U_LIB03Exec( "BarGauge1Set" , { nProcRegua } ) )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?ncPrcG1Time  ?utor?arinaldo de Jesus   ?Data ?5/09/2006?
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?hamada a IncProcG1() com calculo de Tempo de Processamento ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function IncPrcG1Time(;
                                cMsgIncProc        ,;    //01 -> Inicio da Mensagem
                                nLastRec        ,;    //02 -> Numero de Registros a Serem Processados
                                cTimeIni        ,;    //03 -> Tempo Inicial
                                lOnlyOneProc    ,;    //04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
                                nCountTime        ,;    //05 -> Contador de Processos
                                nPercent         ,;    //06 -> Percentual para Incremento
                                lIncProcG1        ,;    //07 -> Se Deve Incrementar a Barra ou Apenas Atualizar a Mensagem
                                lForceRefresh     ;    //08 -> Se Forca a Atualizacao das Mensagens
                             )

    Local aIncPrcG1Time    := {;
                                cMsgIncProc        ,;    //01 -> Inicio da Mensagem
                                nLastRec        ,;    //02 -> Numero de Registros a Serem Processados
                                cTimeIni        ,;    //03 -> Tempo Inicial
                                lOnlyOneProc    ,;    //04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
                                nCountTime        ,;    //05 -> Contador de Processos
                                nPercent         ,;    //06 -> Percentual para Incremento
                                lIncProcG1        ,;    //07 -> Se Deve Incrementar a Barra ou Apenas Atualizar a Mensagem
                                lForceRefresh     ;    //08 -> Se Forca a Atualizacao das Mensagens
                            }
Return( U_LIB03Exec( "IncPrcG1Time" , @aIncPrcG1Time ) )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?sBrowser        ?utor?arinaldo de Jesus?Data ?6/11/2009?
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arkBrowse com Filtro                                       ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?sBrowser                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MsBrowser(;
                                cAlias            ,;    //01 -> Alias para MarkBrowse
                                cDlgTitle        ,;    //05 -> Titulo do Dialog
                                aBrwFields        ,;    //08 -> Campos que constarao no Browse
                                cTopFilter        ,;    //09 -> Expressao de Filtro do Grid ( Top )
                                cBotFilter        ,;    //10 -> Expressao de Filtro do Grid ( Bottom )
                                aCoords            ,;    //11 -> Coordenadas do Objeto
                                oDlg            ,;    //13 -> Objeto Dialog ( Por referencia )
                                cRdd            ,;    //14 -> Rdd do DataBase
                                aColors            ,;    //16 -> Cores para o Browse
                                aIdxCol            ,;    //17 -> aIdxCol ?
                                lDlgPadSiga         ;    //21 -> Se o Dialog devera ser Montado no Padrao do Siga
                           )

    Local aArea                := GetArea()
    Local aAreaAlias        := ( cAlias )->( GetArea() )
    
    Local aSvKeys
    Local aButtons
    Local aAdvSize
    Local aInfoAdvSize
    Local aObjCoords
    
    Local bMsBrowser        := { || MsBrowser() } 
    
    Local bMarkFilter
    
    Local bSet15
    Local bSet24
    Local bInitDlg
    Local bBtnSeek
    Local bBtnFilter
    
    Local lButtonOk
    Local lNewDialog
    
    Begin Sequence
    
        DEFAULT cRdd            := __cRdd
    
        Private aNewAlsIndex      := {}
    
        Private bNewFiltroBrw     := {|| NIL }
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Define as Dimensoes dos Objetos                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        bMarkFilter                := { |cFilter| MarkFilter( cAlias , NIL , cRdd , cFilter ) , oMsSelect:oBrowse:Refresh() }
        lButtonOk                := .F.
        lNewDialog                := !( ValType( oDlg ) == "O" )
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Define as Dimensoes dos Objetos                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        DEFAULT lDlgPadSiga        := .F.
        aAdvSize                 := MsAdvSize( NIL , lDlgPadSiga )
        IF Empty( aCoords )
            aInfoAdvSize        := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
            aObjCoords            := { { 000 , 000 , .T. , .T. } }
            aCoords                := MsObjSize( aInfoAdvSize , aObjCoords )
            aObjCoords[1,1]     := aCoords[1,4]
            aCoords[1,4]        := aCoords[1,3] 
            aCoords[1,4]        := aObjCoords[1,1]
        EndIF    
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Monta Dialog...                                                          ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF ( lNewDialog )
            aButtons    := {}
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Pesquisa <F4>                   ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnSeek    := { || (;
                                     CursorWait() ,;
                                     MyPesqBrw(;
                                                 cAlias,;
                                                 ( cAlias )->( Recno() ),;
                                                 bNewFiltroBrw,;
                                                 cRdd,;
                                               ),;
                                     oMsSelect:oBrowse:Refresh(),;
                                     CursorArrow(),;
                                     SetKey( VK_F4 , bBtnSeek );
                                );
                            }
            aAdd( aButtons ,    {;
                                    "BMPCONS"                            ,;
                                       bBtnSeek                            ,;
                                    OemToAnsi( STR0003 + "...<F4>" )    ,;            //"Pesquisar"
                                    OemToAnsi( STR0003 )                 ;            //"Pesquisar"
                                   };
                )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?efine a Tecla de Atalho para Pesquisa <F4>                   ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bBtnFilter    := { || (;
                                     CursorWait() ,;
                                     Eval( bMarkFilter ),;
                                     oMsSelect:oBrowse:Refresh(),;
                                         CursorArrow(),;
                                     SetKey( VK_F5 , bBtnFilter );
                                 );
                            }
            aAdd( aButtons ,    {;
                                    "FILTRO"                            ,;
                                       bBtnFilter                            ,;
                                    OemToAnsi( STR0004 + "...<F5>" )    ,;            //"Filtro"
                                    OemToAnsi( STR0004 )                 ;            //"Filtro"
                                   };
                )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para as Teclas <CTRL-O>                       ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bSet15         := { || lButtonOk := .T. , GetKeys() , oDlg:End() }
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para as Teclas <CTRL-X>                           ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bSet24        := { || lButtonOk := .F. , GetKeys() , oDlg:End() }
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Define o Bloco para o INIT do DIALOG                         ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            bInitDlg    := { ||;    
                                EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
                                Eval( oMsSelect:oBrowse:bGotop )    ,;
                                oMsSelect:oBrowse:Refresh()            ,;
                                SetKey( VK_F4 , bBtnSeek )            ,;
                                SetKey( VK_F5 , bBtnFilter )         ;
                             }
    
            aSvKeys := GetKeys()
            DEFINE MSDIALOG oDlg TITLE cDlgTitle FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL 
            oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
        EndIF
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Monta MarkBrowse...                                                      ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            oMsSelect := MsSelect():New(;
                                            cAlias                ,;    //01 -> Alias    do Arquivo de Filtro
                                            NIL                    ,;    //02 -> Campo para controle do mark
                                            NIL                    ,;    //03 -> Condicao para o Mark
                                            aBrwFields            ,;    //04 -> Array com os Campos para o Browse e.g.: { { FIELD_NAME , "" , FIELD_DESC , FIELD_PICTURE } }
                                            NIL                    ,;    //05 -> Logico, e por referencia, Condicao do Mark
                                            NIL                    ,;    //06 -> Conteudo a Ser Gravado no campo de controle do Mark
                                            aCoords[1]            ,;    //07 -> Coordenadas do Objeto
                                            cTopFilter            ,;  //08 -> Expressao de Filtro do Grid ( Top )
                                            cBotFilter            ,;    //09 -> Expressao de Filtro do Grid ( Bottom )
                                            oDlg                ,;    //10 -> Objeto Dialog
                                            aIdxCol                ,;    //11 -> ?
                                            aColors                 ;    //12 -> Array com as Cores para o Browse e.g.:  { { cCond1 , "BR_VERDE" } , { cCond2 , "BR_VERMELHO" } }
                                        )
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        ?Ativa o Dialogo...                                                       ?
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF ( lNewDialog )
    
            ACTIVATE DIALOG oDlg CENTERED ON INIT Eval( bInitDlg )
            ObjFree( @oMsSelect )
            ObjFree( @oDlg )
            RestKeys( aSvKeys , .T. )
    
            /*/
            здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
            ?Finaliza Filtro                                                           ?
            юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
            MyEndFilBrw( @cAlias , @aNewAlsIndex , cRdd )
    
        EndIF
    
    End Sequence
    
    RestArea( aAreaAlias )
    RestArea( aArea )

Return( lButtonOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?bjFree            ?utor?arinaldo de Jesus   ?Data ?6/11/2009?
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?inalizacao dos Objetos                                       ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?vide parametros formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?vide parametros formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function ObjFree( oObjFree )

    TRYEXCEPTION

        IF ( ValType( oObjFree ) == "O" )
            DeleteObject( @oObjFree )
            IF ( ValType( oObjFree ) == "O" )
                TRYEXCEPTION 
                    oObjFree:End()
                ENDEXCEPTION
                RELEASE OBJECTS oObjFree
                oObjFree    := NIL
            EndIF
        EndIF

    ENDEXCEPTION

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?bjFree            ?utor?arinaldo de Jesus   ?Data ?6/11/2009?
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?inalizacao dos Objetos                                       ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?vide parametros formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?vide parametros formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function FilChkField( cAlias , cAliasFldFil  )
    
    Local lExistField := FilExistField( @cAlias , @cAliasFldFil )

    IF ( lExistField )
        lExistField := ( ( cAlias  )->( FieldPos( cAliasFldFil ) ) > 0 )
        IF !( lExistField )
            cAliasFldFil := ""
        EndIF
    EndIF

Return( lExistField )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
