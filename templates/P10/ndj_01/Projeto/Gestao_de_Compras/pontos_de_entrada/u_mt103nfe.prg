#INCLUDE "NDJ.CH"
/*/
    Programa:    MT103NFE
    Autor:        Marinaldo de Jesus
    Data:        24/08/2011
    Descricao:    Ponto de Entrada Executado no programas MATA103 Na Inicializacao do Documento de Entrada
/*/                                       
User Function MT103NFE()
    StaticCall( NDJLIB004 , SetPublic , "__lMT103CAN" , .F. , "L" , 1 , .T. )    //Seta o Cancelamento como Falso
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
