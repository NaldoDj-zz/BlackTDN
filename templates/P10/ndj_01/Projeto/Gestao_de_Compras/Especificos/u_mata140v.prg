#INCLUDE "NDJ.CH"
/*/
    Funcao: U_MATA140V
    Autor:    Marinaldo de Jesus
    Data:    07/01/2010
    Uso:    Chamada a Partir do Menu do Sistema.
            Sera utilizada para executar a Rotina MATA140 com Opcao de Consulta aos Atestos Aprovados ou Regeitados.
/*/
User Function MATA140V()

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local aModuloReSet    := SetModulo( "SIGACOM" , "COM" )
    
    Local cTipo
    
    Local nOpcAT
    
    Local oException
    
    Local uRet
    
    TRYEXCEPTION

        nOpcAT := OpcAtesto()
        
        IF ( nOpcAT == 0 )
            BREAK
        ElseIF ( nOpcAT == 1 )    //Atestadas
            cTipo := "S"
        ElseIF ( nOpcAT == 2 )    //Recusadas
            cTipo := "R"
        ElseIF ( nOpcAT == 3 )    //Aguardando Atesto
            cTipo := "A"
        EndIF    

        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATESTO" , .T. , .T. , .T. )

        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATTIPO" , cTipo , .T. , .T. )

        uRet    := __Execute( "MATA140()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA140" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATESTO" , .F. , .T. , .F. )

        IF !( nOpcAT == 0 )
            U_MATA140V()
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

    ReSetModulo( aModuloReSet )

    RestArea( aArea )
    RestArea( aSC1Area )

Return( uRet )

/*/
    Funcao:        OpcAtesto
    Autor:        Marinaldo de Jesus 
    Data:        07/01/2010
    Descricao:    Dialogo com as Opcoes para o Atesto
    Sintaxe:    <Vide Parametros Formais>
/*/
Static Function OpcAtesto()

Local aSvKeys    := GetKeys()
Local bSet15    := { || lOpcOk := .T.    , RestKeys( aSvKeys , .T. ) , oDlg:End() }
Local bSet24    := { || nOpcAT := 0    , RestKeys( aSvKeys , .T. ) , oDlg:End() }
Local lOpcOk    := .F.

Local oRadio
Local oGroup
Local oFont
Local oDlg

Local oPanel

Static nOpcAT    := 1

DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg FROM  094,001 TO 250,350 TITLE OemToAnsi( "Defina o Tipo de Consulta aos Atestos" ) PIXEL

    @ 000,000 MSPANEL oPanel OF oDlg
    oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

    @ 015,005    GROUP oGroup TO 075,172 LABEL OemToAnsi("Escolha a Opção") OF oDlg PIXEL
    oGroup:oFont:=oFont

    @ 025,010    RADIO oRadio VAR nOpcAT ITEMS     OemToAnsi( "Atestadas" ),;
                                                OemToAnsi( "Recusadas" ),;
                                                OemToAnsi( "Aguardando Atesto" );
                SIZE 115,010 OF oPanel PIXEL
    
    oDlg:bSet24 := { || nOpcAT := 0 , oDlg:End() }
    bSvSet24    := SetKey( 24 , oDlg:bSet24 )

    oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
    
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )
RestKeys( aSvKeys , .T. )

IF !( lOpcOk )
    nOpcAT := 0
EndIF

Return( nOpcAT )
