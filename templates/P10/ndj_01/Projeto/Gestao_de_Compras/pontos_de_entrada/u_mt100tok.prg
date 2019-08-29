#INCLUDE "NDJ.CH"
/*/
    Funcao: MT100TOK
    Autor:    Marinaldo de Jesus
    Data:    29/01/2011
    Uso:    Implmentação do Ponto de Endrada Executado a partir da A103Tudok em MATA103.
            Sera utilizado para Verificar se uma Pre-Nota Podera ser Classificada em Funcao do Atesto.
/*/
User Function MT100TOK()

    Local cAtesto
    
    Local lRet         := .F.

    Local oException
    
    TRYEXCEPTION
    
        IF (;
                !( Type( "l103Class" ) == "L" );
                .or.;
                !( l103Class );
            )
            lRet    := .T.
            BREAK
        EndIF        

        cAtesto    := SF1->F1_XATESTO

        DO CASE
            CASE ( cAtesto == "A" )
                UserException( "Esta Nota Fiscal Não Pode Ser Classificada. Aguardando ATESTO..." )
            CASE ( cAtesto == "R" )
                UserException( "Esta Nota Fiscal Não Pode Ser Classificada. O ATESTO foi RECUSADO..." )
        OTHERWISE
            lRet := .T.
        END CASE    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION    

Return( lRet )

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
