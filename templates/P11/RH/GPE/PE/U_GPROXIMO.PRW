#INCLUDE "PROTHEUS.CH"     
/*
    Programa    : U_GPROXIMO.PRW
    Funcao        : U_GPROXIMO()
    Autor        : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 23/06/2013
    Descricao    : Ponto de Entrada GPROXIMO executado no  GPER040
                  Sera utilizado para verificar se as informacoes
                  foram impressas
*/                          
USER FUNCTION GPROXIMO()
    
    Local lRet    := .F.
    
    IF IsInCallStack("u_btdnGR07")
        IF ( Type("__lGPROXIMO")=="L" )
            __lGPROXIMO    := .T.
        Else
            _SetNamedPrvt( "__lGPROXIMO" , .T. , "u_btdnGR07" )
        EndIF    
    EndIF

Return( lRet )
