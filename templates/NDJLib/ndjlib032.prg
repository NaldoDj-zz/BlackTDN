#include "ndj.ch"
//------------------------------------------------------------------------------------------------
    /*/
        CLASS:tNDJProgress
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:23/12/2013
        Descricao:Progresso em ASCII
        Sintaxe:tNDJProgress():New()->Objeto do Tipo Progress
    /*/
//------------------------------------------------------------------------------------------------
Class tNDJProgress From LongClassName
    
    DATA cClassName
    
    DATA aMethods   AS ARRAY INIT Array(0) HIDDEN
    DATA aProgress  AS ARRAY INIT Array(0) HIDDEN

    DATA lRandom    AS LOGICAL INIT .F.    HIDDEN
    
    DATA nMax       AS NUMERIC INIT 0      HIDDEN
    DATA nMethod    AS NUMERIC INIT 0      HIDDEN
    DATA nMethods   AS NUMERIC INIT 0      HIDDEN
    DATA nProgress  AS NUMERIC INIT 0      HIDDEN
    
    DATA lShuttle   AS LOGICAL INIT .F.    HIDDEN

    Method New(cProgress,cToken)  CONSTRUCTOR

    Method ClassName()

    Method SetProgress(cProgress,cToken)

    Method Eval(cMethod,cAlign)
    Method Progress()
    Method Increment(cAlign)
    Method Decrement(cAlign)
    Method Shuttle(cAlign)
    Method Junction(cAlign)
    Method Dispersion(cAlign)
    Method Disjunction(cAlign)
    Method Union(cAlign)
    Method Occult(cAlign)
    Method Random(cAlign)
    
    Method GetnMax()
    Method GetnProgress()
    
    Method SetRandom(lSet)

EndClass

User Function tNDJProgress(cProgress,cToken)
Return(tNDJProgress():New(@cProgress,@cToken))

Method New(cProgress,cToken) Class tNDJProgress
    self:ClassName()
    self:SetProgress(@cProgress,@cToken)
Return(self)

Method ClassName() Class tNDJProgress
    self:cClassName:="TNDJPROGRESS"
Return(self:cClassName)

Method SetProgress(cProgress,cToken) Class tNDJProgress
    Local lMacro
    DEFAULT cProgress:="-;\;|;/"
    DEFAULT cToken:=";"    
    lMacro:=(SubStr(cProgress,1,1)=="&")
    IF (lMacro)
        cProgress:=SubStr(cProgress,2)
        cProgress:=&(cProgress)
    EndIF
    IF Empty(self:aMethods)
        aAdd(self:aMethods,"PROGRESS")
        aAdd(self:aMethods,"INCREMENT")
        aAdd(self:aMethods,"DECREMENT")
        aAdd(self:aMethods,"SHUTTLE")    
        aAdd(self:aMethods,"JUNCTION")    
        aAdd(self:aMethods,"DISPERSION")
        aAdd(self:aMethods,"DISJUNCTION")
        aAdd(self:aMethods,"UNION")
        aAdd(self:aMethods,"OCCULT")
        aAdd(self:aMethods,"RANDOM")
        self:nMethods:=Len(self:aMethods)
    EndIF
    self:aProgress:=_StrToKArr(@cProgress,@cToken)
    self:lRandom:=.F.
    self:lRandom:=.F.
    self:lShuttle:=.NOT.(self:lShuttle)
    self:nMethod:=0
    self:nMax:=Len(self:aProgress)
    self:nProgress:=0
Return(self)

Method Eval(cMethod,cAlign) Class tNDJProgress
    Local cEval
    Local nMethod
    DEFAULT cMethod:="PROGRESS"
    cMethod:=Upper(AllTrim(cMethod))
    nMethod:=Max(aScan(self:aMethods,{|m|m==cMethod}),1)
    cMethod:=self:aMethods[nMethod]
    DO CASE
    CASE (cMethod=="PROGRESS")
        cEval:=self:Progress()
    CASE (cMethod=="INCREMENT")
        cEval:=self:Increment(@cAlign)
    CASE (cMethod=="DECREMENT")
        cEval:=self:Decrement(@cAlign)
    CASE (cMethod=="SHUTTLE")    
        cEval:=self:Shuttle(@cAlign)
    CASE (cMethod=="JUNCTION")    
        cEval:=self:Junction(@cAlign)
    CASE (cMethod=="DISPERSION")
        cEval:=self:Dispersion(@cAlign)    
    CASE (cMethod=="DISJUNCTION")
        cEval:=self:Disjunction(@cAlign)    
    CASE (cMethod=="UNION")
        cEval:=self:Union(@cAlign)    
    CASE (cMethod=="OCCULT")
        cEval:=self:Occult(@cAlign)    
    CASE (cMethod=="RANDOM")
        cEval:=self:Random(@cAlign)    
    OTHERWISE
        cEval:=self:Progress()    
    ENDCASE
Return(cEval)

Method Progress() Class tNDJProgress
Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])

Method Increment(cAlign) Class tNDJProgress
    Local cPADFunc:="PAD"
    Local cProgress:=""
    Local nProgress
    Local nsProgress
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    nsProgress:=self:nProgress
    IF (cAlign=="C")
++nsProgress
        IF (nsProgress>self:nMax)
            nsProgress:=1
        EndIF
    EndIF
    For nProgress:=1 To nsProgress
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cProgress+=Space(Len(self:aProgress[nProgress]))
        Else
            cProgress+=self:aProgress[nProgress]
        EndIF    
    Next nProgress
    cPADFunc+=cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Decrement(cAlign) Class tNDJProgress
    DEFAULT cAlign:="L"
Return(self:Increment(cAlign))

Method Shuttle(cAlign) Class tNDJProgress
    Local cEval
    IF (.NOT.(self:lShuttle).and.(self:nProgress>=self:nMax))
        self:lShuttle:=.T.
    ElseIF (self:lShuttle.and.(self:nProgress>=self:nMax))
        self:lShuttle:=.F.
    EndIF
    IF (self:lShuttle)
        cEval:="DECREMENT" 
        cAlign:="L"
    Else
        cEval:="INCREMENT"
        cAlign:="R"
    EndIF
Return(self:Eval(cEval,@cAlign))

Method Junction(cAlign) Class tNDJProgress
    Local cLToR:=""
    Local cRToL:=""    
    Local cProgress:=""
    Local cPADFunc:="PAD"
    Local nProgress
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    For nProgress:=1 To self:nProgress 
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cLToR+=Space(Len(self:aProgress[nProgress]))
        Else
            cLToR+=self:aProgress[nProgress]
        EndIF    
    Next nProgress
    For nProgress:=self:nMax To Min(((self:nMax-self:nProgress)+1),self:nMax) STEP (-1)
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cRToL+=Space(Len(self:aProgress[nProgress]))    
        Else
            cRToL+=self:aProgress[nProgress]
        EndIF    
    Next nProgress
    self:nProgress+=Len(cRToL)
    self:nProgress:=Min(self:nProgress,self:nMax)
    cProgress+=cLToR
    cProgress+=Space(self:nMax-self:nProgress)
    cProgress+=cRToL
    cPADFunc+=cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Dispersion(cAlign) Class tNDJProgress
    Local cEval
    DEFAULT cAlign:="R" //L,C,R
    IF Empty(cAlign)
        cAlign:="R"
    EndIF
    IF (cAlign=="R")
        cEval:="INCREMENT"
    Else
        cEval:="DECREMENT"
    EndIF    
Return(self:Eval(cEval,"C"))

Method Disjunction(cAlign) Class tNDJProgress
    Local cPADFunc:="PAD"
    Local cProgress:=""
    Local nAT
    DEFAULT cAlign:="C" //L,C,R
    IF Empty(cAlign)
        cAlign:="C"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    aEval(self:aProgress,{|p,n|cProgress+=IF(self:lRandom.and.((__Random(n,self:nMax)%__Random(1,5))==0),Space(Len(p)),p)})
    IF (self:nProgress>1)
        nAT:=Int(self:nMax/self:nProgress)
        cProgress:=SubStr(cProgress,1,nAT)
        cProgress+=Space(self:nProgress-1)+cProgress
    EndIF
    cPADFunc+=cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Union(cAlign) Class tNDJProgress
    Local cPADFunc:="PAD"
    Local cProgress:=""
    Local nAT
    Local nQT
    DEFAULT cAlign:="C" //L,C,R
    IF Empty(cAlign)
        cAlign:="C"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    aEval(self:aProgress,{|p,n|cProgress+=IF(self:lRandom.and.((__Random(n,self:nMax)%__Random(1,5))==0),Space(Len(p)),p)})
    IF (self:nProgress>1)
        nAT:=Round(self:nMax/self:nProgress,0)
        IF (Mod(self:nMax,2)==0)
            nQT:=((self:nProgress-1)*2)
        Else
            nQT:=((self:nProgress-1)*3)
        EndIF
        cProgress:=Stuff(cProgress,nAT,nQT,"")
    EndIF
    cPADFunc+=cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Occult(cAlign) Class tNDJProgress
    Local cPADFunc:="PAD"
    Local cProgress:=""
    Local nProgress 
    Local nsProgress
    DEFAULT cAlign:="L" //L,C,R
    IF Empty(cAlign)
        cAlign:="L"
    EndIF
    IF (++self:nProgress>self:nMax)
        self:nProgress:=1
    EndIF
    nsProgress:=self:nProgress
    IF (cAlign=="C")
++nsProgress
        IF (nsProgress>self:nMax)
            nsProgress:=1
        EndIF
    EndIF
    For nProgress:=self:nMax To nsProgress STEP (-1)
        IF self:lRandom.and.((__Random(nProgress,self:nMax)%__Random(1,5))==0)
            cProgress+=Space(Len(self:aProgress[(self:nMax-nProgress)+1]))            
        Else
            cProgress+=self:aProgress[(self:nMax-nProgress)+1]
        EndIF    
    Next nProgress
    cPADFunc+=cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Random(cAlign) Class tNDJProgress
    IF ((self:nMethod==0).or.(self:nProgress>=self:nMax))
        self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
        While (("RANDOM"$self:aMethods[self:nMethod]).or.("PROGRESS"$self:aMethods[self:nMethod]))
            self:nMethod:=Min(__Random(1,self:nMethods+1),self:nMethods)
        End While
    EndIF
Return(self:Eval(self:aMethods[self:nMethod],@cAlign))

Method SetRandom(lSet) Class tNDJProgress
    Local lRandom:=self:lRandom
    DEFAULT lSet:=.T.
    self:lRandom:=lSet
Return(lRandom)

Method GetnMax() Class tNDJProgress
Return(self:nMax)

Method GetnProgress() Class tNDJProgress
Return(self:nProgress)

Static Function _StrToKArr(cStr,cToken)
    Local cDToken
    DEFAULT cStr:=""
    DEFAULT cToken:=";"
    cDToken:=(cToken+cToken)
    While (cDToken$cStr)
        cStr:=StrTran(cStr,cDToken,cToken+" "+cToken)
    End While
Return(StrToKArr(cStr,cToken))

Static Function __Random(nB,nE)

    Local nR

    IF nB==0
        nB:=1
    EndIF

    IF nB==nE
++nE        
    EndIF

    nR:=Randomize(nB,nE)        

Return(nR)
