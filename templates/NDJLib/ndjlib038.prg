#include "totvs.ch"

Static __aPublicV:={}
Static __nPublicV:=0

Static oNDJLIB038

CLASS NDJLIB038

    DATA cClassName

    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()

    METHOD SetPublic(cPublic,uSet,cType,nSize,lRestart,lModule,cStack)
    METHOD ReSetPublic(lModule,cStack)

ENDCLASS

User Function DJLIB038()
    DEFAULT oNDJLIB038:=NDJLIB038():New()
RETURN(oNDJLIB038)

METHOD NEW() CLASS NDJLIB038
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS NDJLIB038
    self:cClassName:="NDJLIB038"
RETURN(self:cClassName)

/*/
    Funcao:SetPublic
    Autor:Marinaldo de Jesus
    Data:08/08/2011
    Descricao:Define as Variaveis Publicas Utilizadas na NDJ
    Sintaxe:StaticCall(NDJLIB038,SetPublic,cPublic,uSet,cType,nSize,lRestart,lModule,cStack)

/*/
METHOD SetPublic(cPublic,uSet,cType,nSize,lRestart,lModule,cStack) CLASS NDJLIB038
RETURN(SetPublic(@cPublic,@uSet,@cType,@nSize,@lRestart,@lModule,@SScStack))
Static Function SetPublic(cPublic,uSet,cType,nSize,lRestart,lModule,cStack)
    DEFAULT lModule:=.T.
    AddPublic(@cPublic,@uSet,@cType,@nSize,@lRestart,@lModule,@cStack)
Return(aClone(__aPublicV))

/*/
    Funcao:ReSetPublic
    Autor:Marinaldo de Jesus
    Data:08/08/2011
    Descricao:ReDefine as Variaveis Publicas Utilizadas na NDJ
    Sintaxe:StaticCall(NDJLIB038,ReSetPublic,lModule,cStack)

/*/
METHOD ReSetPublic(lModule,cStack) CLASS NDJLIB038
RETURN(ReSetPublic(lModule,cStack))
Static Function ReSetPublic(lModule,cStack)

    Local aStack
    Local aModName

    Local bReset:={||AddPublic(@__aPublicV[nBL][1],NIL,@__aPublicV[nBL][2],@__aPublicV[nBL][3],@.T.,@lModule,@cStack)}

    Local nAT
    Local nBL
    Local nEL

    DEFAULT lModule:=.T.
    IF (lModule)
        aStack:=GetCallStack()
        IF (lModule)
            nEL:=Len(aStack)
            aModName:=RetModName(.T.)
            For nBL:=nEL To 1 STEP-1
                nAT:=aScan(aModName,{|aModName|(("U_"+aModName[2])==aStack[nBL])})
                IF (nAT>0)
                    EXIT
                EndIF
            Next nBL
            IF (nAT>0)
                cStack:=aStack[nBL]
            Else
                cStack:=aStack[nEL]
            EndIF
        Else
            cStack:=aStack[nEL]
        EndIF
        nEL:=__nPublicV
        For nBL:=1 To nEL
            IF (cStack==__aPublicV[nBL][4])
                Eval(bReset)
            EndIF
        Next nBL
    ElseIF (.NOT.(cStack==NIL))
        nEL:=__nPublicV
        For nBL:=1 To nEL
            IF (cStack==__aPublicV[nBL][4])
                Eval(bReset)
            EndIF
        Next nBL
    Else
        nEL:=__nPublicV
        For nBL:=1 To nEL
            cStack:=__aPublicV[nBL][4]
            Eval(bReset)
        Next nBL
    EndIF

Return(.T.)

/*/
    Funcao:AddPublic
    Autor:Marinaldo de Jesus
    Data:08/08/2011
    Descricao:Adiciona as Variaveis Publicas
/*/
Static Function AddPublic(cPublic,uSet,cType,nSize,lRestart,lModule,cStack)

    Local aStack
    Local aModName

    Local cVar

    Local nAT
    Local nBL
    Local nEL

    DEFAULT cPublic:="__UndefPVar__"
    DEFAULT lRestart:=.NOT.(ValType(uSet)=="U")
    DEFAULT lModule:=.T.

    cVar:=Upper(AllTrim(cPublic))
    nAT:=aScan(__aPublicV,{|aPublic|aPublic[1]==cVar})

    IF (nAT==0)
        DEFAULT cType:=ValType(uSet)
        DEFAULT nSize:=0
        IF (cStack==NIL)
            aStack:=GetCallStack()
            nEL:=Len(aStack)
            IF (lModule)
                aModName:=RetModName(.T.)
                For nBL:=nEL To 1 STEP-1
                    nAT:=aScan(aModName,{|aModName|(aModName[2]==aStack[nBL])})
                    IF (nAT>0)
                        EXIT
                    EndIF
                Next nBL
                IF (nAT>0)
                    cStack:=aStack[nBL]
                Else
                    cStack:=aStack[nEL]
                EndIF
            Else
                cStack:=aStack[nEL]
            EndIF
        EndIF
        nAT:=aScan(__aPublicV,{|aPublic|(aPublic[1]==cVar).and.(aPublic[4]==cStack)})
        IF (nAT==0)
            aAdd(__aPublicV,{cVar,cType,nSize,cStack})
            nAT:=Len(__aPublicV)
            __nPublicV:=nAT
            lRestart:=.T.
        EndIF
        DEFAULT uSet:=GetValType(@cType,@nSize)
        IF (.NOT.(Type(cVar)==cType))
            _SetNamedPrvt(@cVar,@uSet,@cStack)
        ElseIF (lRestart)
            IF (cType=="A")
                IF ((ValType(uSet)=="A").or.(.NOT.(Type(cVar)=="A")))
                    _SetNamedPrvt(@cVar,aClone(uSet),@cStack)
                Else
                    aSize(&cVar,@nSize)
                EndIF
            Else
                _SetNamedPrvt(@cVar,@uSet,@cStack)
            EndIF
        EndIF
    ElseIF (lRestart)
        IF (cStack==NIL)
            cStack:=__aPublicV[nAT][4]
        EndIF
        nAT:=aScan(__aPublicV,{|aPublic|(aPublic[1]==cVar).and.(aPublic[4]==cStack)})
        IF (nAT>0)
            IF (cType==NIL)
                cType:=__aPublicV[nAT][2]
            Else
                __aPublicV[nAT][2]:=cType
            EndIF
            IF (nSize==NIL)
                nSize:=__aPublicV[nAT][3]
            Else
                __aPublicV[nAT][3]:=nSize
            EndIF
            IF (cType=="A")
                IF ((ValType(uSet)=="A").or.(.NOT.(Type(cVar)=="A")))
                    _SetNamedPrvt(@cVar,aClone(uSet),@cStack)
                Else
                    aSize(&cVar,@nSize)
                EndIF
            Else
                DEFAULT uSet:=GetValType(@cType,@nSize)
                _SetNamedPrvt(@cVar,@uSet,@cStack)
            EndIF
        EndIF
    EndIF

Return(nAT)

/*/
    Funcao:GetCallStack
    Autor:Marinaldo de Jesus
    Data:11/08/2011
    Descricao:Retorna Array Com Pilha de Chamadas
    Sintaxe:<vide parametros formais>
/*/
Static Function GetCallStack(nStart)
Return(StaticCall(NDJLIB001,GetCallStack,@nStart))

#include "tryexception.ch"
