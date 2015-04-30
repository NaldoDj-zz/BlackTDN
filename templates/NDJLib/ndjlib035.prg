#include "totvs.ch"
//------------------------------------------------------------------------------------------------
    /*/
        CLASS:tGetAdvFVal
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:09/03/2015
        Descricao:Encapsular GetAdvFVal 
        Sintaxe:tGetAdvFVal():New(<cAlias>,<uFields>,[uKeySeek],[nOrder],[uDefault])->Objeto do Tipo tGetAdvFVal
    /*/
//------------------------------------------------------------------------------------------------
CLASS tGetAdvFVal FROM tHash

    DATA cAlias
    DATA nOrder
    DATA uFields
    DATA uKeySeek
    DATA uDefault
    
    METHOD NEW(cAlias,uFields,uKeySeek,nOrder,uDefault) CONSTRUCTOR
    METHOD FreeObj() /*DESTRUCTOR*/

    METHOD ClassName()
    
    METHOD SetAlias(cAlias)
    METHOD SetOrder(nOrder)
    METHOD SetFields(uFields)
    METHOD SetKeySeek(uKeySeek)
    METHOD SetDefault(uDefault)
    
    METHOD GetValue(cField)
    METHOD SetValue(cField,xValue)
        
    METHOD GetbyKey(uKeySeek,nOrder,uDefault)
    METHOD GetAdvFVal(cAlias,uFields,uKeySeek,nOrder,uDefault)

ENDCLASS

User Function GetAdvFVal(cAlias,uFields,uKeySeek,nOrder,uDefault)
Return(tGetAdvFVal():New(@cAlias,@uFields,@uKeySeek,@nOrder,@uDefault))

METHOD NEW(cAlias,uFields,uKeySeek,nOrder,uDefault) CLASS tGetAdvFVal
    _Super:New()
    self:SetAlias(cAlias)
    self:SetOrder(nOrder)
    self:SetFields(uFields)
    self:SetKeySeek(uKeySeek)
    self:SetDefault(uDefault)
Return(self)

METHOD ClassName() CLASS tGetAdvFVal
    IF (ValType(self:cClassName)=="C")
        self:cClassName:="TGETADVFVAL"
    EndIF
Return("TGETADVFVAL")

METHOD SetAlias(cAlias) CLASS tGetAdvFVal
    Local cLAlias:=self:cAlias
    self:cAlias:=cAlias
Return(cLAlias)

METHOD SetOrder(nOrder) CLASS tGetAdvFVal
    Local nLOrder:=self:nOrder
    self:nOrder:=nOrder
Return(nLOrder)

METHOD SetFields(uFields) CLASS tGetAdvFVal
    Local uLFields:=self:uFields
    self:uFields:=uFields
Return(uLFields)

METHOD SetKeySeek(uKeySeek) CLASS tGetAdvFVal
    Local uLKeySeek:=self:uKeySeek
    self:uKeySeek:=uKeySeek
Return(uLKeySeek)

METHOD SetDefault(uDefault) CLASS tGetAdvFVal
    Local uLDefault:=self:uDefault
    self:uDefault:=uDefault
Return(uLDefault)

METHOD GetValue(cField) CLASS tGetAdvFVal
Return(self:Get(cField))

METHOD SetValue(cField,xValue) CLASS tGetAdvFVal
    Local xLValue:=self:GetValue(cField)
    self:Set(cField,xValue)  
Return(xLValue)

METHOD GetbyKey(uKeySeek,nOrder,uDefault) CLASS tGetAdvFVal
Return(self:GetAdvFVal(NIL,NIL,@uKeySeek,@nOrder,@uDefault))

METHOD GetAdvFVal(cAlias,uFields,uKeySeek,nOrder,uDefault) CLASS tGetAdvFVal
    local uAdvFVal
    DEFAULT cAlias:=self:cAlias 
    DEFAULT uFields:=self:uFields
    DEFAULT uKeySeek:=self:uKeySeek
    DEFAULT nOrder:=self:nOrder
    DEFAULT uDefault:=self:uDefault
    self:SetAlias(cAlias)
    self:SetOrder(nOrder)
    self:SetFields(uFields)
    self:SetKeySeek(uKeySeek)
    self:SetDefault(uDefault)
    uAdvFVal:=GetAdvFVal(self:cAlias,self:uFields,self:uKeySeek,self:nOrder,self:uDefault)
    if (ValType(uAdvFVal)=="A")
        aEval(uFields,{|cField,nAT|self:Set(cField,uAdvFVal[nAT])})
    Else
        self:Set(uFields,uAdvFVal)
    Endif
Return(self)

METHOD FreeObj() CLASS tGetAdvFVal
    Local aAdvFVal:=self:GetAllSessions()
    aEval(aAdvFVal,{|c|self:Del(c)})
    aSize(aAdvFVal,0)
    self:=FreeObj(self)
Return(self)