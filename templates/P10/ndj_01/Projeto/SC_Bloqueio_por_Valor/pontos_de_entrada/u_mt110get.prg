#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT110GET
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Implementacao do Ponto de Entrada MT110GET. Usado no MATA110 esse Ponto de Entrada Redimensiona o DIALOG para manipulacao
                do Cabecalho da Solicitacao de Compras.
/*/
User Function MT110GET()

    Local aPosObj
    Local nOpc

    aPosObj            := ParamIxb[1]
    nOpc            := ParamIxb[2]

    aPosObj[2][1]    +=    20

Return( aPosObj )

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
