#INCLUDE "NDJ.CH"
/*/
    Funcao: MT120VLD
    Autor:    Marinaldo de Jesus
    Data:    03/12/2010
    Uso:    Ponto de Entrada MT120VLD na Rotina MATA120 no Pedido de Compras.
            Sera utilizado para Validar o Conteudo dos campos Preco e Valor e
            para gerenciar o Empenho/Bloqueio por Valor.
/*/
User Function MT120VLD()

    Local lRet := .T.
    
    Local cMsgHelp
    
    Local oException

    TRYEXCEPTION

        IF !( GdDeleted() )
            lRet := StaticCall(U_NDJA002,C7XSZ2CodVld)
            IF !( lRet )
                BREAK
            EndIF
        EndIF    

        lRet := StaticCall(U_NDJBLKSCVL,C7QuantVld)
        IF !( lRet )
            BREAK
        EndIF

        lRet := StaticCall(U_NDJBLKSCVL,C7PrecoVld)
        IF !( lRet )
            BREAK
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            cMsgHelp += CRLF
            cMsgHelp += oException:ErrorStack
            ConOut( cMsgHelp )
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
