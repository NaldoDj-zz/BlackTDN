#include "ndj.ch"
Class tNDJProgress From LongClassName
	
	DATA aProgress	AS ARRAY INIT Array(0)
	
	DATA nMax		AS NUMERIC INIT 0 HIDDEN
	DATA nProgress	AS NUMERIC INIT 0 HIDDEN

	Method New(cProgress,cToken)  CONSTRUCTOR
	Method ClassName()
	Method Eval(cMethod,uPar01)
	Method Progress()
	Method Increment(cAlign)
	Method Decrement(cAlign)
	Method SetProgress(cProgress,cToken)

EndClass

User Function tNDJProgress(cProgress,cToken)
Return(tNDJProgress():New(@cProgress,@cToken))

Method New(cProgress,cToken) Class tNDJProgress
	self:SetProgress(@cProgress,@cToken)
Return(self)

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

Method ClassName() Class tNDJProgress
Return("TNDJPROGRESS")

Method Eval(cMethod,uPar01) Class tNDJProgress
	Local cEval
	DEFAULT cMethod := "PROGRESS"
	DO CASE
	CASE (cMethod=="PROGRESS")
		cEval := self:Progress()
	CASE (cMethod=="INCREMENT")
		cEval := self:Increment(@uPar01)
	CASE (cMethod=="DECREMENT")
		cEval := self:Decrement(@uPar01)
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
	IF (++self:nProgress>self:nMax)
		self:nProgress := 1
	EndIF
	For nProgress := 1 To self:nProgress
		cProgress += self:aProgress[nProgress]
	Next nProgress
	DEFAULT cAlign := "R" //L,C,R
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Method Decrement(cAlign) Class tNDJProgress
	Local cPADFunc  := "PAD"
	Local cProgress := ""
	Local nProgress
	IF (--self:nProgress<=0)
		self:nProgress := self:nMax
	EndIF
	For nProgress := self:nMax To self:nProgress STEP (-1)
		cProgress += self:aProgress[nProgress]
	Next nProgress
	DEFAULT cAlign := "L" //L,C,R
	cPADFunc += cAlign
Return(&cPADFunc.(cProgress,self:nMax))

Static Function _StrToKArr(cStr,cToken)
	Local cDToken
	DEFAULT cStr   := ""
	DEFAULT cToken := ";"
	cDToken := (cToken+cToken)
	While (cDToken$cStr)
		cStr := StrTran(cStr,cDToken,cToken+" "+cToken)
	End While
Return(StrToKArr(cStr,cToken))