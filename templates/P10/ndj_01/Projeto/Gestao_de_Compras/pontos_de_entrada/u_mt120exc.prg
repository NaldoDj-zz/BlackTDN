#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT120EXC
    Data:        07/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada executado no progama MATA120 atraves da chamada aa MaAvalPC em CONXFUN.PRX.
                - Sera utilizado para excluir as correlacoes do Item do Pedido com as tabelas SX5 e SZ4.
/*/
User Function MT120EXC()

    Local oException

    TRYEXCEPTION

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
