#INCLUDE "NDJ.CH"
/*/
    Function:    CN100CAN
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Implementacao do Ponto de Entrada CN100CAN que eh usado no Programa CNTA100 para verificar se a opcao foi cancelada
/*/
User Function CN100CAN()

    Local lInclui    := .F.
    
    Local nOpc        := ParamIxb[1]
    
    Local oException
    
    TRYEXCEPTION

        StaticCall( U_MT120BRW , CN100Cancel , .T. )

        IF !( IsInCallStack( "NDJContratos" ) )
            BREAK
        EndIF
        
        lInclui    := ( ( Type( "INCLUI" ) == "L" ) .and. INCLUI )

        IF (;
                ( nOpc == 3 );
                .or.;
                ( lInclui );
            )    
            MbrChgLoop( .F. )
        EndIF    

    CATCHEXCEPTION USING oException
    
        IF ( ValType( oException ) == "O" )
            ConOut( oException:Description , oException:ErrorStack )
        EndIF

    ENDEXCEPTION

Return( NIL )

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
