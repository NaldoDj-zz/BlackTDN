#INCLUDE "NDJ.CH"
/*/
    Programa:    PMA200Tr
    Autor:        Marinaldo de Jesus
    Data:        10/02/2011
    Descricao:    Ponto de Entrada PMA200Tr, executado em PMS200to201 (Funcao que monta o a Tarefa no Tree do Projeto) no PMSA200.
    Uso:        Sua implementação será utilizada para Não Permitir a Exclusão de EDT/Tarefa
/*/
User Function PMA200Tr()

    Local aArea        := GetArea()
    Local aSD1Area    := SD1->( GetArea() )

    Local cEdt
    Local cRevisa
    Local cProjeto
    Local cSD1Filial
    Local cAlias4Fld
    Local cSD1KeySeek

    Local lContinua    := .T.

    Local nOpc
    Local nSD1Order

    Local oException

    TRYEXCEPTION

        nOpc        := ParamIxb[1]

        IF ( nOpc == 5 ) //Exclusao

            cSD1Filial    := xFilial( "SD1" , AF8->AF8_FILIAL )
            cProjeto    := AF8->AF8_PROJET
            cRevisa        := AF8->AF8_REVISA
            cEDT        := ParamIxb[2]
            
            IF Empty( cEDT )
                cAlias4Fld := Alias()
                IF (;
                        ( cAlias4Fld )->( FieldPos( "XF9_TAREFA" ) > 0 );
                        .or.;
                        ( cAlias4Fld := "" , StaticCall( NDJLIB001 , GetAlias4Fields , @cAlias4Fld , { "XF9_TAREFA" } ) );
                    )    
                    cEDT := ( cAlias4Fld )->( XF9_TAREFA )
                EndIF
                IF Empty( cEDT )
                    BREAK
                EndIF
            EndIF
            
            cSD1KeySeek    := cSD1Filial
            cSD1KeySeek    += cProjeto
            cSD1KeySeek    += cRevisa
            cSD1KeySeek    += cEDT

            nSD1Order    := RetOrder( "SD1" , "D1_FILIAL+D1_XPROJET+D1_XREVIS+D1_XTAREFA+D1_DOC" )
            
            SD1->( dbSetOrder( nSD1Order ) )
    
            lContinua    := SD1->( !dbSeek( cSD1KeySeek  , .F. ) ) 
            
            IF !( lContinua )
                UserException( "Já existem Notas Fiscais Para a Tarefa : " + AllTrim( cEdt ) + CRLF + " A tarefa : " + AllTrim( cEdt ) + " não Poderá ser Excluida" )
            EndIF

            BREAK

        EndIF        

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( oException:Description , oException:ErrorStack )
        EndIF

    ENDEXCEPTION

    RestArea( aSD1Area )
    RestArea( aArea )

Return( lContinua )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
