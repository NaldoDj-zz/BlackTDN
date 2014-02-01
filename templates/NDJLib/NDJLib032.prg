#include "ndj.ch"
Class tNDJProgress From LongClassName
	
	DATA aProgress	AS ARRAY INIT Array(0) HIDDEN
	
	DATA nMax		AS NUMERIC INIT 0      HIDDEN
	DATA nProgress	AS NUMERIC INIT 0      HIDDEN
	
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
	
	Method GetnMax()
	Method GetnProgress()

EndClass

User Function tNDJProgress(cProgress,cToken)
Return(tNDJProgress():New(@cProgress,@cToken))

Method New(cProgress,cToken) Class tNDJProgress
	self:SetProgress(@cProgress,@cToken)
Return(self)

Method ClassName() Class tNDJProgress
Return("TNDJPROGRESS")

Method SetProgress(cProgress,cToken) Class tNDJProgress
	Local lMacro
	DEFAULT cProgress	:= "-;\;|;/"
	DEFAULT cToken		:= ";"	
	lMacro := (SubStr(cProgress,1,1)=="&")
	IF (lMacro)
		cProgress		:= SubStr(cProgress,2)
		cProgress		:= &(cProgress)
	EndIF
	self:aProgress		:= _StrToKArr(@cProgress,@cToken)
	self:nMax			:= Len(self:aProgress)
	self:nProgress		:= 0
Return(self)

Method Eval(cMethod,cAlign) Class tNDJProgress
	Local cEval
	DEFAULT cMethod := "PROGRESS"
	cMethod := Upper(AllTrim(cMethod))
	DO CASE
	CASE (cMethod=="PROGRESS")
		cEval := self:Progress()
	CASE (cMethod=="INCREMENT")
		cEval := self:Increment(@cAlign)
	CASE (cMethod=="DECREMENT")
		cEval := self:Decrement(@cAlign)
	CASE (cMethod=="SHUTTLE")	
		cEval := self:Shuttle(@cAlign)
	CASE (cMethod=="JUNCTION")	
		cEval := self:Junction(@cAlign)
	CASE (cMethod=="DISPERSION")
		cEval := self:Dispersion(@cAlign)	
	CASE (cMethod=="DISJUNCTION")
		cEval := self:Disjunction(@cAlign)	
	CASE (cMethod=="UNION")
		cEval := self:Union(@cAlign)	
	OTHERWISE
		cEval := self:Progress()	
	ENDCASE
Return(cEval)

Method Progress() Class tNDJProgress
Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])

Method Increment(cAlign) Class tNDJProgress
	Local cPADFunc  := "PAD"
	Local cProgress := ""
	Local nProgress
	DEFAULT cAlign  := "R" //L,C,R
	IF Empty(cAlign)
		cAlign := "R"
	EndIF
	IF (cAlign=="C")
		++self:nProgress
	EndIF
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	For nProgress := 1 To self:nProgress
		cProgress += self:aProgress[nProgress]
	Next nProgress
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Decrement(cAlign) Class tNDJProgress
	Local cPADFunc  := "PAD"
	Local cProgress := ""
	Local nProgress
	DEFAULT cAlign  := "L" //L,C,R
	IF Empty(cAlign)
		cAlign := "L"
	EndIF
	IF (cAlign=="C")
		--self:nProgress
	EndIF
	IF (--self:nProgress<=0)
		self:nProgress := self:nMax
	EndIF
	For nProgress := self:nMax To self:nProgress STEP (-1)
		cProgress += self:aProgress[nProgress]
	Next nProgress
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Shuttle(cAlign) Class tNDJProgress
	Local cEval
	IF (.NOT.(self:lShuttle).and.(self:nProgress==self:nMax))
		self:lShuttle := .T.
	ElseIF (self:lShuttle.and.(self:nProgress==self:nMax))
		self:lShuttle := .F.
	EndIF
	IF (self:lShuttle)
		cEval  := "DECREMENT"
		cAlign := "L"
	Else
		cEval  := "INCREMENT"
		cAlign := "R"
	EndIF
Return(self:Eval(cEval,@cAlign))

Method Junction(cAlign) Class tNDJProgress
	Local cLToR		:= ""
	Local cRToL		:= ""	
	Local cProgress	:= ""
	Local cPADFunc  := "PAD"
	Local nProgress
	DEFAULT cAlign  := "R" //L,C,R
	IF Empty(cAlign)
		cAlign := "R"
	EndIF
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	For nProgress := 1 To self:nProgress 
		cLToR += self:aProgress[nProgress]
	Next nProgress
	For nProgress := self:nMax To Min(((self:nMax-self:nProgress)+1),self:nMax) STEP (-1)
		cRToL += self:aProgress[nProgress]
	Next nProgress
	self:nProgress += Len(cRToL)
	self:nProgress := Min(self:nProgress,self:nMax)
	cProgress += cLToR
	cProgress += Space(self:nMax-self:nProgress)
	cProgress += cRToL
	cPADFunc  += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Dispersion(cAlign) Class tNDJProgress
	Local cEval := "DECREMENT"
	cAlign      := "C"
Return(self:Eval(cEval,@cAlign))

Method Disjunction(cAlign) Class tNDJProgress
	Local cPADFunc  := "PAD"
	Local cProgress	:= ""
	Local nAT
	cAlign := "C"
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	aEval(self:aProgress,{|p|cProgress+=p})
	IF (self:nProgress>1)
		nAT       := Int(self:nMax/self:nProgress)
		cProgress := SubStr(cProgress,1,nAT)
		cProgress += Space(self:nProgress-1)+cProgress
	EndIF
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Union(cAlign) Class tNDJProgress
	Local cPADFunc  := "PAD"
	Local cProgress	:= ""
	Local nAT
	Local nQT
	cAlign := "C"
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	aEval(self:aProgress,{|p|cProgress+=p})
	IF (self:nProgress>1)
		nAT := Round(self:nMax/self:nProgress,0)
		IF (Mod(self:nMax,2)==0)
			nQT := ((self:nProgress-1)*2)
		Else
			nQT := ((self:nProgress-1)*3)
		EndIF
		cProgress := Stuff(cProgress,nAT,nQT,"")
	EndIF
	cPADFunc  += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method GetnMax() Class tNDJProgress
Return(self:nMax)

Method GetnProgress() Class tNDJProgress
Return(self:nProgress)

Static Function _StrToKArr(cStr,cToken)
	Local cDToken
	DEFAULT cStr   := ""
	DEFAULT cToken := ";"
	cDToken := (cToken+cToken)
	While (cDToken$cStr)
		cStr := StrTran(cStr,cDToken,cToken+" "+cToken)
	End While
Return(StrToKArr(cStr,cToken))