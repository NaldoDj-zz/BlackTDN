#include "NDJ.CH"

Static __uSession
Static __nSession:=0
Static __nTHashID:=0
Static __nLTHashID:=0

//------------------------------------------------------------------------------------------------
    /*/
        CLASS:THash
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Simular Hash no Protheus
        Sintaxe:THash():New()->Objeto do Tipo THash
    /*/
//------------------------------------------------------------------------------------------------
CLASS THASH FROM LongClassName

    DATA aTHash
    DATA nTHashID

    DATA cClassName

    METHOD NEW() CONSTRUCTOR

    METHOD ClassName()

    METHOD Set(uPropertyKey,uValue)
    METHOD Get(uPropertyKey,uDefaultValue)

    METHOD GetAtProperty(uSession,uPropertyKey,nSession)
    METHOD GetNameProperty(uSession,uPropertyKey)
    METHOD GetKeyProperty(uSession,uPropertyKey)
    METHOD SetKeyProperty(uSession,uPropertyKey,uNewPropertyKey)
    METHOD GetPropertyValue(uSession,uPropertyKey,uDefaultValue)
    METHOD SetPropertyValue(uSession,uPropertyKey,uValue)
    METHOD AddNewProperty(uSession,uPropertyKey,uValue)
    METHOD RemoveProperty(uSession,uPropertyKey)
    METHOD GetAllProperties(uSession)

    METHOD AddNewSession(uSession)
    METHOD RemoveSession(uSession)
    METHOD GetSession(uSession)
    METHOD CloneSession(uSession)
    METHOD GetAllSessions()
    METHOD CopySession(uSession,uNewSession)
    METHOD ExistSession(uSession,nSession)
    METHOD ChangeSession(uSession,uNewSession)

ENDCLASS

User Function THash()
Return(THash():New())

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:New
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:CONSTRUCTOR
        Sintaxe:THash():New()->self
    /*/
//------------------------------------------------------------------------------------------------
METHOD New() CLASS THASH

    self:aTHash:=Array(0)
    self:cClassName:="THASH"
    self:nTHashID:=++__nTHashID

Return(self)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ClassName
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Retornar o Nome da Classe
        Sintaxe:THash():ClassName()->cClassName
    /*/
//------------------------------------------------------------------------------------------------
METHOD ClassName() CLASS THASH
Return(self:cClassName)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:Set
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:31/12/2014
        Descricao:Adicionar uma nova propriedade/Valor
        Sintaxe:THash():Set(uPropertyKey,uValue)
    /*/
//------------------------------------------------------------------------------------------------
METHOD Set(uPropertyKey,uValue) CLASS THASH
    Local nSession
    Local nProperty
    Local uSession:=uPropertyKey
    Local uPropertyLastValue
    IF .NOT.(self:ExistSession(@uSession,@nSession))
        self:AddNewSession(@uSession)
    EndIF
    nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
    IF (nProperty==0)
        uPropertyLastValue:=uValue
        self:AddNewProperty(@uSession,@uPropertyKey,uValue)
    Else
        uPropertyLastValue:=self:SetPropertyValue(@uSession,@uPropertyKey,uValue)
    EndIF
Return(uPropertyLastValue)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:Get
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:31/12/2014
        Descricao:Obter o Valor atribuido a uma Propriedade
        Sintaxe:THash():Get(uPropertyKey)->uValue
    /*/
//------------------------------------------------------------------------------------------------
METHOD Get(uPropertyKey,uDefaultValue) CLASS THASH
    Local uSession:=uPropertyKey
Return(self:GetPropertyValue(uSession,uPropertyKey,uDefaultValue))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAtProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter a Posicao da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:THash():GetAtProperty(uSession,uPropertyKey,nSession)->nATProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAtProperty(uSession,uPropertyKey,nSession) CLASS THASH

    Local nATProperty:=0

    BEGIN SEQUENCE

        IF Empty(nSession)
            IF .NOT.(self:ExistSession(@uSession,@nSession))
                BREAK
            EndIF
        EndIF

        nATProperty:=aScan(self:aTHash[nSession][PROPERTY_POSITION],{|aValues|(Compare(aValues[PROPERTY_KEY],uPropertyKey))})

    END SEQUENCE

Return(nATProperty)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetNameProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter o Nome da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:THash():GetNameProperty(uSession,uPropertyKey)->cNameProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetNameProperty(uSession,uPropertyKey) CLASS THASH
Return(self:GetKeyProperty(uSession,uPropertyKey))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetKeyProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter o Chave da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:THash():GetKeyProperty(uSession,uPropertyKey)->uKeyProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetKeyProperty(uSession,uPropertyKey) CLASS THASH

    Local uKeyProperty

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
        IF (nProperty==0)
            BREAK
        EndIF

        uKeyProperty:=self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]

    END SEQUENCE

Return(uKeyProperty)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SetKeyProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Setar a Chave da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:THash():SetKeyProperty(uSession,uPropertyKey,uNewPropertyKey)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD SetKeyProperty(uSession,uPropertyKey,uNewPropertyKey) CLASS THASH

    Local lSuccess:=.F.

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
        IF (nProperty==0)
            BREAK
        EndIF

        self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]:=uNewPropertyKey
        lSuccess:=.T.

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetPropertyValue
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter o valor da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:THash():GetPropertyValue(uSession,uPropertyKey,uDefaultValue)->uPropertyValue
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetPropertyValue(uSession,uPropertyKey,uDefaultValue) CLASS THASH

    Local uPropertyValue:="@__PROPERTY_NOT_FOUND__@"

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
        IF (nProperty==0)
            BREAK
        EndIF

        uPropertyValue:=self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]

    END SEQUENCE

    IF (Compare(uPropertyValue,"@__PROPERTY_NOT_FOUND__@"))
        IF .NOT.(Empty(uDefaultValue))
            uPropertyValue:=uDefaultValue
        Else
            uPropertyValue:=NIL
        EndIF
    EndIF

Return(uPropertyValue)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SetPropertyValue
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Setar o Valor em uma determinada Propriedade
        Sintaxe:THash():SetPropertyValue(uSession,uPropertyKey,uValue)->uPropertyLastValue
    /*/
//------------------------------------------------------------------------------------------------
METHOD SetPropertyValue(uSession,uPropertyKey,uValue) CLASS THASH

    Local uPropertyLastValue

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
        IF (nProperty==0)
            BREAK
        EndIF

        uPropertyLastValue:=self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]
        self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]:=uValue

    END SEQUENCE

Return(uPropertyLastValue)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:AddNewProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Adicionar uma nova propriedade
        Sintaxe:THash():AddNewProperty(uSession,uPropertyKey,uValue)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD AddNewProperty(uSession,uPropertyKey,uValue) CLASS THASH

    Local lSuccess:=.F.

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)

        IF (nProperty==0)
            aAdd(self:aTHash[nSession][PROPERTY_POSITION],Array(PROPERTY_ELEMENTS))
            nProperty:=Len(self:aTHash[nSession][PROPERTY_POSITION])
        EndIF

        self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]:=uPropertyKey
        self:aTHash[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]:=uValue

        lSuccess:=.T.

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:RemoveProperty
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Remover Determinada Propriedade
        Sintaxe:THash():RemoveProperty(uSession,uPropertyKey)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD RemoveProperty(uSession,uPropertyKey) CLASS THASH

    Local lSuccess:=.F.

    Local nSession
    Local nProperty

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            lSuccess:=.T.
            BREAK
        EndIF

        nProperty:=self:GetAtProperty(@uSession,@uPropertyKey,@nSession)
        IF (nProperty==0)
            BREAK
        EndIF

        lSuccess:=.T.

        aDel(self:aTHash[nSession][PROPERTY_POSITION],nProperty)
        aSize(self:aTHash[nSession][PROPERTY_POSITION],Len(self:aTHash[nSession][PROPERTY_POSITION])-1)

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAllProperties
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Retornar todas as propriedades
        Sintaxe:THash():GetAllProperties(uSession)->aAllProperties
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAllProperties(uSession) CLASS THASH

    Local aAllProperties:=Array(0)

    Local nSession

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        aAllProperties:=self:aTHash[nSession][PROPERTY_POSITION]

    END SEQUENCE

Return(aAllProperties)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:AddNewSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Adicionar nova Secao
        Sintaxe:THash():AddNewSession(uSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD AddNewSession(uSession) CLASS THASH

    Local lSuccess:=.F.

    Local nSession

    BEGIN SEQUENCE

        IF (self:ExistSession(@uSession,@nSession))
            lSuccess:=.T.
            BREAK
        EndIF

        aAdd(self:aTHash,{uSession,Array(0)})
        __uSession:=uSession
        __nSession:=Len(self:aTHash)
        __nLTHashID:=self:nTHashID

        lSuccess:=.T.

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:RemoveSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Remover Determinada Secao
        Sintaxe:THash():RemoveSession(uSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD RemoveSession(uSession) CLASS THASH

    Local lSuccess:=.F.

    Local nSession

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            lSuccess:=.T.
            BREAK
        EndIF

        aDel(self:aTHash,nSession)
        aSize(self:aTHash,Len(self:aTHash)-1)

        __uSession:=NIL
        __nSession:=0
        __nLTHashID:=0

        lSuccess:=.T.

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter uma Secao
        Sintaxe:THash():GetSession(uSession)->aSession
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetSession(uSession) CLASS THASH

    Local aSession:=Array(0)

    Local nSession

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSession))
            BREAK
        EndIF

        aSession:=self:aTHash[nSession]

    END SEQUENCE

Return(aSession)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:CloneSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Clonar uma Secao
        Sintaxe:THash():CloneSession(uSession)->aClone
    /*/
//------------------------------------------------------------------------------------------------
METHOD CloneSession(uSession) CLASS THASH
Return(aClone(self:GetSession(uSession)))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAllSessions
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Obter Todas as Secoes do INI
        Sintaxe:THash():GetAllSessions()->aAllSessions
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAllSessions() CLASS THASH

    Local aAllSessions:=Array(0)

    Local nSession
    Local nSessions

    BEGIN SEQUENCE

        IF Empty(self:aTHash)
            BREAK
        EndIF

        nSessions:=Len(self:aTHash)
        For nSession:=1 To nSessions
            aAdd(aAllSessions,self:aTHash[nSession][SESSION_POSITION])
        Next nSession

    END SEQUENCE

Return(aAllSessions)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:CopySession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Copiar uma Secao
        Sintaxe:THash():CopySession(uSession,uNewSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD CopySession(uSession,uNewSession) CLASS THASH

    Local aProperties

    Local nSource
    Local nTarget

    Local lSuccess:=.F.

    BEGIN SEQUENCE

        IF .NOT.(self:ExistSession(@uSession,@nSource))
            BREAK
        EndIF

        IF .NOT.(self:AddNewSession(@uNewSession))
            BREAK
        EndIF

        aProperties:=self:GetAllProperties(uSession)
        IF .NOT.(self:ExistSession(@uNewSession,@nTarget))
            BREAK
        EndIF

        self:aTHash[nTarget][PROPERTY_POSITION]:=aClone(aProperties)

        lSuccess:=ArrayCompare(self:aTHash[nSource][PROPERTY_POSITION],self:aTHash[nTarget][PROPERTY_POSITION])

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ExistSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Copiar uma Secao
        Sintaxe:THash():ExistSession(uSession,nSession)->lExist
    /*/
//------------------------------------------------------------------------------------------------
METHOD ExistSession(uSession,nSession) CLASS THASH

    Local lExistSession:=((__nLTHashID==self:nTHashID).and.(__nSession>0).and.Compare(__uSession,uSession))

    IF (lExistSession)
        nSession:=__nSession
    Else
        nSession:=aScan(self:aTHash,{|aFindSession|(Compare(aFindSession[SESSION_POSITION],uSession))})
        __nSession:=nSession
        __uSession:=uSession
        __nLTHashID:=self:nTHashID
        lExistSession:=(nSession>0)
    EndIF

Return(lExistSession)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ChangeSession
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:04/12/2011
        Descricao:Renomear uma Secao
        Sintaxe:THash():ChangeSession(uSession,nSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD ChangeSession(uSession,uNewSession) CLASS THASH

    Local nSession
    Local lSuccess:=.F.

    IF (self:ExistSession(uSession,@nSession))
        self:aTHash[nSession][SESSION_POSITION]:=uNewSession
        lSuccess:=.T.
    EndIF

Return(lSuccess)

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF .NOT.(lRecursa)
            BREAK
        EndIF
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)