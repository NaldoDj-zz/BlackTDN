#include "ndj.ch"

Static oNDJLIB019

CLASS NDJLIB019

    METHOD NEW() CONSTRUCTOR

    METHOD IniGetPValue(cFile,cSession,cPropertyName,cDefaultValue,cIgnoreToken)  
    
ENDCLASS

User Function DJLIB019()
    DEFAULT oNDJLIB019:=NDJLIB019():New()
Return(oNDJLIB019)

METHOD NEW() CLASS NDJLIB019
RETURN(self)

//------------------------------------------------------------------------------------------------
    /*/
        Funcao:IniGetPValue
        Autor:Marinaldo de Jesus
        Data:11/01/2011
        Uso:Retornar o Valor Atribuido a uma Propriedade de Acordo com a Sessao em um arquivo .INI
        Sintaxe:StaticCall(NDJLIB019,IniGetPValue,cFile,cSession,cPropertyName,cDefault)
    /*/
//------------------------------------------------------------------------------------------------
METHOD IniGetPValue(cFile,cSession,cPropertyName,cDefaultValue,cIgnoreToken) CLASS NDJLIB019
Static Function IniGetPValue(cFile,cSession,cPropertyName,cDefaultValue,cIgnoreToken)
    Local oTFINI:=TFINI():New(@cFile,@cIgnoreToken)
    Local cPropertyValue:=oTFINI:GetPropertyValue(@cSession,@cPropertyName,@cDefaultValue)
    oTFINI:=NIL
Return(cPropertyValue)
