#include "ndj.ch"

//------------------------------------------------------------------------------------------------
    /*/
        CLASS:TFINI
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Manipulacao de Arquivos .INI
        Sintaxe:TFINI():New(cINIFile,cIgnoreToken)->Objeto do Tipo TFINI
    /*/
//------------------------------------------------------------------------------------------------
CLASS TFINI FROM THASH

    DATA cINIFile
    DATA cClassName

    METHOD NEW(cINIFile,cIgnoreToken) CONSTRUCTOR

    METHOD ClassName()

    METHOD GetAtProperty(cSession,cPropertyKey)
    METHOD GetKeyProperty(cSession,cPropertyKey)
    METHOD SetKeyProperty(cSession,cPropertyKey,cNewPropertyKey)
    METHOD GetNameProperty(cSession,cPropertyKey)
    METHOD GetPropertyValue(cSession,cPropertyKey,cDefaultValue)
    METHOD SetPropertyValue(cSession,cPropertyKey,cValue)
    METHOD AddNewProperty(cSession,cPropertyKey,cValue)
    METHOD RemoveProperty(cSession,cPropertyKey)
    METHOD GetAllProperties(cSession)

    METHOD AddNewSession(cSession)
    METHOD RemoveSession(cSession)
    METHOD GetSession(cSession)
    METHOD CloneSession(cSession)
    METHOD GetAllSessions()
    METHOD CopySession(cSession,cNewSession)
    METHOD ExistSession(cSession,nSession)
    METHOD ChangeSession(cSession,cNewSession)

    METHOD SaveAs(cFileName)
    METHOD SaveAsXML(cXMLFile)

    METHOD ToXML()

ENDCLASS

User Function TFINI(cINIFile,cIgnoreToken)
Return(TFINI():New(cINIFile,cIgnoreToken))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:New
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:CONSTRUCTOR
        Sintaxe:TFINI():New(cINIFile,cIgnoreToken)->self
    /*/
//------------------------------------------------------------------------------------------------
METHOD New(cINIFile,cIgnoreToken) CLASS TFINI

    Local aTFINI

    _Super:New()

    self:cINIFile:=cINIFile
    self:cClassName:="TFINI"

    aTFINI:=self:aTHASH

    TINILoad(@aTFINI,@cINIFile,@cIgnoreToken)

Return(self)

//------------------------------------------------------------------------------------------------
    /*/
        Function:TINILoad
        Autor:Marinaldo de Jesus
        Data:03/11/2011
        Descricao:Carregar os Dados do arquivo INI
        Sintaxe:TINILoad(oTIni,cIgnoreToken)
    /*/
//------------------------------------------------------------------------------------------------
Static Function TINILoad(aTFINI,cINIFile,cIgnoreToken)

    Local cLine

    Local lExit

    Local nAT
    Local nATLine
    Local nSession
    Local nProperty
    Local nATIgnoreTkn

    Local ofT

    Local lLoad:=.F.

    BEGIN SEQUENCE
    
        IF Empty(cINIFile)
            BREAK
        EndIF

        IF .NOT.(File(cINIFile))
            BREAK
        ENDIF

        ofT:=fTDB():New()

        IF (ofT:ft_fUse(cINIFile)<=0)
            ofT:ft_fUse()
            BREAK
        EndIF

        DEFAULT cIgnoreToken:=";"

        While .NOT.(ofT:ft_fEof())
            cLine:=ofT:ft_fReadLn()
            BEGIN SEQUENCE
                IF Empty(cLine)
                    BREAK
                EndIF
                IF (cIgnoreToken$cLine)
                    cLine:=AllTrim(cLine)
                    nATIgnoreTkn:=AT(cIgnoreToken,cLine)
                    IF (nATIgnoreTkn==1)
                        BREAK
                    EndIF
                    cLine:=SubStr(cLine,1,nATIgnoreTkn-1)
                EndIF    
                IF .NOT.("["$cLine)
                    BREAK
                ENDIF
                lExit:=.F.
                nATLine:=0
                aAdd(aTFINI,{Lower(AllTrim(StrTran(StrTran(cLine,"[",""),"]",""))),Array(0)})
                nSession:=Len(aTFINI)
                ofT:ft_fSkip()
                While .NOT.(ofT:ft_fEof())
                    cLine:=ofT:ft_fReadLn()
                     BEGIN SEQUENCE
                         IF Empty(cLine)
                             BREAK
                         EndIF
                        IF (cIgnoreToken$cLine)
                            cLine:=AllTrim(cLine)
                            nATIgnoreTkn:=AT(cIgnoreToken,cLine)
                            IF (nATIgnoreTkn==1)
                                IF ("["$cLine)
                                    nATLine:=0
                                    lExit:=.T.
                                EndIF
                                BREAK
                            EndIF
                            cLine:=SubStr(cLine,1,nATIgnoreTkn-1)
                        EndIF
                        IF ("["$cLine)
                            lExit:=.T.
                            BREAK
                        EndIF
                         aAdd(aTFINI[nSession][PROPERTY_POSITION],Array(PROPERTY_ELEMENTS))
                         nProperty:=Len(aTFINI[nSession][PROPERTY_POSITION])
                         nAT:=AT("=",cLine)
                         aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]:=Lower(AllTrim(SubStr(cLine,1,nAT-1)))
                         aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]:=SubStr(cLine,nAT+1)
                         cLine:=""
                    END SEQUENCE
                    IF (lExit)
                        EXIT
                    EndIF
                    nATLine:=ofT:ft_fRecno()
                    ofT:ft_fSkip()
                End While
                IF (nATLine>0)
                    ofT:ft_fGoto(nATLine)
                EndIF
            END SEQUENCE
            ofT:ft_fSkip()
        End While

        ofT:ft_fUse()

        lLoad:=.T.

    END SEQUENCE

Return(lLoad)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ClassName
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Retornar o Nome da Classe
        Sintaxe:TFINI():ClassName()->cClassName
    /*/
//------------------------------------------------------------------------------------------------
METHOD ClassName() CLASS TFINI
Return(self:cClassName)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAtProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter a Posicao da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:TFINI():GetAtProperty(cSession,cPropertyKey)->nATProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAtProperty(cSession,cPropertyKey) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
Return(_Super:GetAtProperty(@cSession,@cPropertyKey))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetKeyProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter a Chave da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:TFINI():GetKeyProperty(cSession,cPropertyKey)->cNameProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetKeyProperty(cSession,cPropertyKey) CLASS TFINI
    Local cKeyproperty
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
    cKeyproperty:=_Super:GetKeyProperty(@cSession,@cPropertyKey)
    DEFAULT cKeyproperty:=""
Return(cKeyproperty)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SetKeyProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Setar a Chave da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:TFINI():SetKeyProperty(cSession,cPropertyKey)->cNameProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD SetKeyProperty(cSession,cPropertyKey,cNewPropertyKey) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
    cNewPropertyKey:=Lower(AllTrim(cNewPropertyKey))
Return(_Super:SetKeyProperty(cSession,cPropertyKey,cNewPropertyKey))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetNameProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter o Nome da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:TFINI():GetNameProperty(cSession,cPropertyKey)->cNameProperty
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetNameProperty(cSession,cPropertyKey) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
Return(self:GetKeyProperty(@cSession,@cPropertyKey))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetPropertyValue
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter o valor da Propriedade Passada por parametro e de acordo com a Secao
        Sintaxe:TFINI():GetPropertyValue(cSession,cPropertyKey,cDefaultValue)->uPropertyValue
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetPropertyValue(cSession,cPropertyKey,cDefaultValue) CLASS TFINI
    Local cValue
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
    cValue:=_Super:GetPropertyValue(@cSession,@cPropertyKey,@cDefaultValue)
    DEFAULT cValue:=""
Return(cValue)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SetPropertyValue
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Setar o Valor em uma determinada Propriedade
        Sintaxe:TFINI():SetPropertyValue(cSession,cPropertyKey,cValue)->cPropertyLastValue
    /*/
//------------------------------------------------------------------------------------------------
METHOD SetPropertyValue(cSession,cPropertyKey,cValue) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
Return(_Super:SetPropertyValue(@cSession,@cPropertyKey,@cValue))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:AddNewProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Adicionar uma nova propriedade
        Sintaxe:TFINI():AddNewProperty(cSession,cPropertyKey,cValue)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD AddNewProperty(cSession,cPropertyKey,cValue) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
Return(_Super:AddNewProperty(@cSession,@cPropertyKey,@cValue))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:RemoveProperty
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Remover Determinada Propriedade
        Sintaxe:TFINI():RemoveProperty(cSession,cPropertyKey)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD RemoveProperty(cSession,cPropertyKey) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cPropertyKey:=Lower(AllTrim(cPropertyKey))
Return(Super:RemoveProperty(cSession,cPropertyKey))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAllProperties
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Retornar todas as propriedades
        Sintaxe:TFINI():GetAllProperties(cSession)->aAllProperties
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAllProperties(cSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(_Super:GetAllProperties(@cSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:AddNewSession
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Adicionar nova Secao
        Sintaxe:TFINI():AddNewSession(cSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD AddNewSession(cSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(_Super:AddNewSession(@cSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:RemoveSession
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Remover Determinada Secao
        Sintaxe:TFINI():RemoveSession(cSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD RemoveSession(cSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(_Super:RemoveSession(@cSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetSession
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter uma Secao 
        Sintaxe:TFINI():GetSession(uSession)->aSession
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetSession(cSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(_Super:GetSession(cSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:CloneSession
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Clonar uma Secao 
        Sintaxe:TFINI():CloneSession(uSession)->aClone
    /*/
//------------------------------------------------------------------------------------------------
METHOD CloneSession(cSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(self:GetSession(cSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:GetAllSessions
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Obter Todas as Secoes do INI
        Sintaxe:TFINI():GetAllSessions()->aAllSessions
    /*/
//------------------------------------------------------------------------------------------------
METHOD GetAllSessions() CLASS TFINI
Return(_Super:GetAllSessions())

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:CopySession
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Copiar uma Secao 
        Sintaxe:TFINI():CopySession(cSession,cNewSession)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD CopySession(cSession,cNewSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cNewSession:=Lower(AllTrim(cNewSession))
Return(_Super:CopySession(@cSession,@cNewSession))

METHOD ExistSession(cSession,nSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
Return(_Super:ExistSession(cSession,@nSession))

METHOD ChangeSession(cSession,cNewSession) CLASS TFINI
    cSession:=Lower(AllTrim(cSession))
    cNewSession:=Lower(AllTrim(cNewSession))
Return(_Super:ChangeSession(cSession,cNewSession))

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SaveAs
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Salvar Como
        Sintaxe:TFINI():SaveAs(cFileName)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD SaveAs(cFileName) CLASS TFINI
Return(SaveAs(self:aTHASH,cFileName))
Static Function SaveAs(aTFINI,cFileName)

    Local cLine
    Local cCRLF

    Local nSession
    Local nSessions
    Local nProperty
    Local nProperties
    
    Local nfHandle
    
    Local lSuccess:=.F.

    BEGIN SEQUENCE

        IF Empty(cFileName)
            cFileName:=self:cINIFile
            IF Empty(cFileName)
                BREAK
            EndIF
        EndIF

        nfHandle:=fCreate(cFileName)
        IF (nfHandle<=0)
            BREAK
        EndIF

        cCRLF:=CRLF

        nSessions:=Len(aTFINI)
        For nSession:=1 To nSessions

            cLine:="["
            cLine+=aTFINI[nSession][SESSION_POSITION]
            cLine+="]"
            cLine+=cCRLF

            fWrite(nfHandle,cLine)

            nProperties:=Len(aTFINI[nSession][PROPERTY_POSITION])
            For nProperty:=1 To nProperties

                 cLine:=aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]
                 cLine+="="
                 cLine+=aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE]
                cLine+=cCRLF
                
                fWrite(nfHandle,cLine)

            Next nProperty

            cLine:=cCRLF

            fWrite(nfHandle,cLine)

        Next nSession

        fClose(nfHandle)

        lSuccess:=File(cFileName)

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:SaveAsXML
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Salvar como XML
        Sintaxe:TFINI():SaveAsXML(cXMLFile)->lSuccess
    /*/
//------------------------------------------------------------------------------------------------
METHOD SaveAsXML(cXMLFile) CLASS TFINI
    Local aXML:=self:ToXML()
    Local cSPPath
    Local cSPDriver
    Local cSPFileName
    IF Empty(cXMLFile)
        cXMLFile:=self:cINIFile
        SplitPath(cXMLFile,@cSPDriver,@cSPPath,@cSPFileName)
        cXMLFile:=cSPDriver
        cXMLFile+=cSPPath
        cXMLFile+=cSPFileName
        cXMLFile+=".xml"
    EndIF
Return(SaveAsXml(@aXML,@cXMLFile))
Static Function SaveAsXml(aXML,cXMLFile) 

    Local cLine
    Local cCRLF

    Local lSuccess:=.F.

    Local nAT
    Local nATEnd
    Local nfHandle

    BEGIN SEQUENCE

        IF Empty(cXMLFile)
            BREAK
        EndIF

        nATEnd:=Len(aXML)
        IF (nATEnd==0)
            BREAK
        EndIF

        nfHandle:=fCreate(cXMLFile)
        IF (nfHandle<=0)
            BREAK
        EndIF

        cCRLF:=CRLF

        For nAT:=1 To nATEnd

            cLine:=aXML[nAT]
            cLine+=cCRLF

            fWrite(nfHandle,cLine)

        Next nSession

        fClose(nfHandle)

        lSuccess:=File(cXMLFile)

    END SEQUENCE

Return(lSuccess)

//------------------------------------------------------------------------------------------------
    /*/
        METHOD:ToXML
        Autor:Marinaldo de Jesus
        Data:27/05/2011
        Descricao:Converter para XML
        Sintaxe:TFINI():ToXML()->aXML
    /*/
//------------------------------------------------------------------------------------------------
METHOD ToXML() CLASS TFINI
Return(ToXML(self:aTHASH))
Static Function ToXML(aTFINI)

    Local aXML:={}

    Local cSpace4:=Space(4)
    Local cSpace8:=Space(8)
    Local cLClassName:=Lower(self:cClassName)

    Local nSession
    Local nSessions
    Local nProperty
    Local nProperties

    aAdd(aXML,"<?xml version='1.0' encoding='ISO-8859-1'?>")
    aAdd(aXML,"<"+cLClassName+">")
    nSessions:=Len(aTFINI)
    For nSession:=1 To nSessions

        aAdd(aXML,cSpace4)
        aAdd(aXML,"<"+aTFINI[nSession][SESSION_POSITION]+">")

        nProperties:=Len(aTFINI[nSession][PROPERTY_POSITION])
        For nProperty:=1 To nProperties

            aAdd(aXML,cSpace8)
            aAdd(aXML,"<"+aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]+">")
             aAdd(aXML,aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_VALUE])
            aAdd(aXML,"</"+aTFINI[nSession][PROPERTY_POSITION][nProperty][PROPERTY_KEY]+">")

        Next nProperty

        aAdd(aXML,cSpace4)
        aAdd(aXML,"</"+aTFINI[nSession][SESSION_POSITION]+">")

    Next nSession

    aAdd(aXML,"</"+cLClassName+">")

Return(aXML)

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
