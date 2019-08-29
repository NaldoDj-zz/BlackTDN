#INCLUDE "NDJ.CH"
/*/
    Funcao: MT160FIL
    Autor:    Marinaldo de Jesus
    Data:    14/12/2010
    Uso:    Executada MATA160. 
            Sera utilizado adicionar filtro ao Browse da SC8.
/*/
User Function MT160FIL()
    
    Local cCodUsr
    Local cAliasSC8

    Local uFilter
    
    Local lMaMontaCot    := IsInCallStack( "MaMontaCot" )
    Local lUMata160

    BEGIN SEQUENCE

        IF !( lMaMontaCot )
            BREAK
        EndIF
        
        lUMata160        := IsInCallStack( "U_MATA160"  )
        IF !( lUMata160 )
            BREAK
        EndIF

        cCodUsr            := StaticCall( NDJLIB014 , RetCodUsr )
        cAliasSC8        := ParamIxb[1]
        
        uFilter            :=    "C8_FILIAL='" + xFilial( "SC8" ) +  "'"
        uFilter            +=    " .AND. "
        uFilter            +=    "("
        uFilter            +=    "    C8_USERSC='"+cCodUsr+"'"
        uFilter            +=    ".OR. "
        uFilter            +=    "    C8_XCODGE='"+cCodUsr+"'"
        uFilter            +=    ")"
        uFilter            +=    " .AND. "
        uFilter            +=    "C8_XSTATCO='1'"

    END SEQUENCE

Return( uFilter  )

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
