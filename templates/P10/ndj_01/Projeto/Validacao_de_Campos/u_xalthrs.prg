#INCLUDE "NDJ.CH"
/*/
    Progama:    XALTHRS
    Autor:        Marinaldo de Jesus
    Data:        10/11/2010
    Descricao:    Gravar a Data da Alteração da Informacao
    Sintaxe:    StaticCall(U_XALTHRS,XALTHRS)
/*/
Static Function XALTHRS( cAlias , cField , cXAltHrs , lChkChange )
Return(StaticCall(NDJLIB001,XALTHRS,@cAlias,@cField,@cXAltHrs,@lChkChange))

/*/
    Funcao:        SetChkAlt
    Autor:        Marinaldo de Jesus 
    Data:        10/11/2010
    Descricao:    SetChkAlt armazena valor original
    Sintaxe:    StaticCall(U_XALTHRS,SetChkAlt)
/*/
Static Function SetChkAlt()
Return(StaticCall(NDJLIB001,SetStackVar))

/*/
    Funcao:        GetChkAlt
    Autor:        Marinaldo de Jesus 
    Data:        10/11/2010
    Descricao:    SetChkAlt obtem valor original
    Sintaxe:    StaticCall(U_XALTHRS,GetChkAlt)
/*/
Static Function GetChkAlt( cReadVar )
Return(StaticCall(NDJLIB001,GetStackVar))

/*/
    Funcao:        ClsChkAlt
    Autor:        Marinaldo de Jesus 
    Data:        10/11/2010
    Descricao:    SetChkAlt obtem valor original
    Sintaxe:    StaticCall(U_XALTHRS,ClsChkAlt)
    Uso:        X3_VLDUSER
/*/
Static Function ClsChkAlt( cReadVar , lForce )
Return(StaticCall(NDJLIB001,ClsStackVar,@cReadVar,@lForce))

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CLSCHKALT()
        GETCHKALT()
        SETCHKALT()
        XALTHRS()
        SYMBOL_UNUSED( __CCRLF )
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
