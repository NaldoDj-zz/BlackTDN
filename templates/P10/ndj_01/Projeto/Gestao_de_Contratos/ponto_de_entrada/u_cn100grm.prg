#INCLUDE "NDJ.CH"
/*/
    Funcao:     CN100GRM
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Implementacao do Ponto de Entrada CN100GRM executado na CN100Grv em CNTA100, antes da Gravacao do Contrato
/*/
User Function CN100GRM()

    Local lRet        := .T.
    
    Local oException

    TRYEXCEPTION

        nOpc        := ParamIxb[1]

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( cMsgHelp , oException:ErrorStack )
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
