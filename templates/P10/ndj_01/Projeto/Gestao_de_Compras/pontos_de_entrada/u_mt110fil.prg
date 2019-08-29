#INCLUDE "NDJ.CH"
/*/
    Funcao: MT110FIL
    Autor:    Marinaldo de Jesus
    Data:    07/01/2010
    Uso:    Executada no MATA110.
            Sera utilizado adicionar Expressao de Filtro na SC do PMS.
/*/
User Function MT110FIL()

    Local cFiltro    := ""
    Local cCodUsr
    
    Local nOpcFiltro
    
    Local oException

    TRYEXCEPTION

        IF IsInCallStack( "NDJShwSC" )
            cCodUsr        := StaticCall( NDJLIB014 , RetCodUsr )
            nOpcFiltro    := OpcFiltro()
            IF ( nOpcFiltro <= 2 )
                //Por DEFAULT, Filtra o Projeto ( nOpcFiltro == 1 )
                cFiltro        := "C1_XPROJET == '" + AF8->AF8_PROJET + "'"
                //e Complementa o Filtro baseado no Codigo do Usuario Corrente
                IF ( nOpcFiltro == 2 )
                    cFiltro += " .AND. "
                    cFiltro += " C1_USER == '" + cCodUsr + "'"
                EndIF
            ElseIF ( nOpcFiltro == 3 ) //Filtra Todas as SCs do Usuario Corrente
                cFiltro := " C1_USER == '" + cCodUsr + "'"
            EndIF
            BREAK
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( cFiltro )

/*/
    Funcao:        OpcFiltro
    Autor:        Marinaldo de Jesus
    Data:        02/03/2011
    Descricao:    Dialogo com as Opcoes para o Filtro
    Sintaxe:    <Vide Parametros Formais>
/*/
Static Function OpcFiltro()

Local aSvKeys    := GetKeys()
Local bSet15    := { || lOpcOk := .T.    , RestKeys( aSvKeys , .T. ) , oDlg:End() }
Local bSet24    := { || nOpcAT := 0        , RestKeys( aSvKeys , .T. ) , oDlg:End() }
Local lOpcOk    := .F.

Local oDlg
Local oFont
Local oPanel
Local oRadio
Local oGroup

Static nOpcAT    := 1

DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg FROM 094,001 TO 250,350 TITLE OemToAnsi( "Opções de Filtro" ) PIXEL

    @ 000,000 MSPANEL oPanel OF oDlg
    oPanel:Align    := CONTROL_ALIGN_ALLCLIENT

    @ 015,005    GROUP oGroup TO 075,172 LABEL OemToAnsi( "Escolha a Opção" ) OF oPanel PIXEL
    oGroup:oFont:=oFont

    @ 025,010    RADIO oRadio VAR nOpcAT ITEMS     OemToAnsi( "Todas as Solicitações do Projeto" ),;
                                                OemToAnsi( "Todas as Minhas Solicitações no Projeto" ),;
                                                OemToAnsi( "Todas as Minhas Solicitações" );
                SIZE 115,010 OF oPanel PIXEL
    
    oDlg:bSet24    := { || nOpcAT := 0 , oDlg:End() }
    bSvSet24    := SetKey( 24 , oDlg:bSet24 )

    oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
    
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )
RestKeys( aSvKeys , .T. )

IF !( lOpcOk )
    nOpcAT := 1
EndIF

Return( nOpcAT )
