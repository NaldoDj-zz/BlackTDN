#INCLUDE "NDJ.CH"
/*/
    Funcao: U_MATA140A
    Autor:    Marinaldo de Jesus
    Data:    07/01/2010
    Uso:    Chamada a Partir do Menu do Sistema.
            Sera utilizada para executar a Rotina MATA140 com Opcao de Aprovacao de Atesto.
/*/
User Function MATA140A()

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local aModuloReSet    := SetModulo( "SIGACOM" , "COM" )
    
    Local oException
    
    TRYEXCEPTION

        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATESTO" , .T. , .T. , .T. )
        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATTIPO" , "A" , .T. , .T. )

        uRet := __Execute( "MATA140()" , "xxxxxxxxxxxxxxxxxxxx" , "MATA140" , AllTrim(Str(nModulo)) , "" , 1 , .T. )

        StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATESTO" , .F. , .T. , .F. )

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
