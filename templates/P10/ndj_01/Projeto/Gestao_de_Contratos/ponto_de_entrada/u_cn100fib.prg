#INCLUDE "NDJ.CH"
/*/
    Funcao:        CN100FIB
    Autor:        Marinaldo de Jesus
    Data:        05/11/2011
    Descricao:    Ponto de Entrada CN100FIB, executado na CTA100, sera utilizado para Setar o Filtro para A CN9 Contratos
/*/
User Function CN100FIB()

    Local cCN100FIB
    
    Local oException

    TRYEXCEPTION

        cCN100FIB    := StaticCall( U_CNTA100F , CNTA100Filter )
        
        StaticCall( U_CNTA100F , CNTA100Filter , cCN100FIB )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCN100FIB )

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
