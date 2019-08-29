#INCLUDE "NDJ.CH"
/*/
    Funcao: MT160QRY
    Autor:    Marinaldo de Jesus
    Data:    14/12/2010
    Uso:    Executada MATA160. 
            Sera utilizado adicionar filtro ao Browse da SC8.
/*/
User Function MT160QRY()

    Local cAliasSC8

    Local uFilter
    
    Local lU_MATA160    := IsInCallStack( "U_MATA160" )

    BEGIN SEQUENCE

        IF !( lU_MATA160 )
            BREAK
        EndIF

        cAliasSC8        := ParamIxb[1]

        uFilter            :=    "C8_FILIAL='" + xFilial( "SC8" ) +  "'"
        uFilter            +=    " AND "
        uFilter         +=    "C8_USERSC='"+StaticCall( NDJLIB014 , RetCodUsr )+"'"
        uFilter            +=    " AND "
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
