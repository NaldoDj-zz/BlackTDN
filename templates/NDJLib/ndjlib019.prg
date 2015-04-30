#INCLUDE "NDJ.CH"
//------------------------------------------------------------------------------------------------
    /*/
        Funcao:IniGetPValue
        Autor:Marinaldo de Jesus
        Data:11/01/2011
        Uso:Retornar o Valor Atribuido a uma Propriedade de Acordo com a Sessao em um arquivo .INI
        Sintaxe:StaticCall(NDJLIB019,IniGetPValue,cFile,cSession,cPropertyName,cDefault)
    /*/
//------------------------------------------------------------------------------------------------
Static Function IniGetPValue(cFile,cSession,cPropertyName,cDefaultValue,cIgnoreToken)

    Local oTFINI:=TFINI():New(@cFile,@cIgnoreToken)
    Local cPropertyValue:=oTFINI:GetPropertyValue(@cSession,@cPropertyName,@cDefaultValue)

    oTFINI:=NIL

Return(cPropertyValue)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        IniGetPValue()
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)