#INCLUDE "NDJ.CH"
/*/
    Funcao:        M020ALT
    Autor:        Marinaldo de Jesus
    Data:        03/03/2011
    Descricao:    Ponto de Entrada Executado na Inclusao de Fornecedor
    Uso:        Sera utilizado para incluir a 4aVisao no CTD
/*/
User Function M020ALT()

    Local aArea        := GetArea()

    Local oException

    TRYEXCEPTION

        Chg4Visao()

    CATCHEXCEPTION USING oException

        IF ValType( oException ) == "O"
            Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

    RestArea( aArea )

Return( NIL )

/*/
    Funcao:        Chg4Visao
    Autor:        Marinaldo de Jesus
    Data:        03/03/2011
    Uso:        Sera utilizado para alterar informacoes  da 4aVisao no CTD
    Sintaxe:    StaticCall( U_M020INC , Add4aVisao() )
/*/
Static Function Chg4Visao()

    Local aArea        := GetArea()
    Local aSA2Area    := SA2->( GetArea() )
    Local aCTDArea    := CTD->( GetArea() )

    Local c4aVisao
    Local cCTDFilial
    
    Local nCTDOrder

    Local oException

    TRYEXCEPTION

        c4aVisao    := StaticCall( NDJLIB001 , __FieldGet , "SA2" , "A2_XVISCTB" , .F. )
        IF Empty( c4aVisao )
            BREAK
        EndIF
        
        cCTDFilial    := xFilial( "CTD" )
        nCTDOrder    := RetOrder( "CTD" , "CTD_FILIAL+CTD_ITEM" )
        
        CTD->( dbSetOrder( nCTDOrder ) )

        IF CTD->( !dbSeek( cCTDFilial + c4aVisao , .F. ) )
            StaticCall( U_M020INC , Add4aVisao , @cCTDFilial , @c4aVisao )
            BREAK
        EndIF    

        IF CTD->( !RecLock( "CTD" , .F. ) )
            BREAK
        EndIF

        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_DESC01" , StaticCall( NDJLIB001 , __FieldGet , "SA2" , "A2_NOME" , .F. ) , .T. )

        CTD->( MsUnLock() )

    CATCHEXCEPTION USING oException

        IF ValType( oException ) == "O"
            Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

    RestArea( aCTDArea )
    RestArea( aSA2Area )
    RestArea( aArea )

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
