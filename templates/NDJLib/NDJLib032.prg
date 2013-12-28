#include "ndj.ch"
CLASS tNDJProgress FROM LongClassName
	
	CLASSDATA aProgress		HIDDEN
	CLASSDATA nMax			HIDDEN
	CLASSDATA nProgress     HIDDEN
	CLASSDATA cClassName	HIDDEN

	METHOD New(cProgress,cToken)  CONSTRUCTOR
	METHOD ClassName()
	METHOD Eval(cMethod,uPar01)
	METHOD Progress()
	METHOD Increment(cAlign)
	METHOD Decrement(cAlign)

ENDCLASS

User Function tNDJProgress(cProgress,cToken)
Return(tNDJProgress():New(cProgress,cToken))

METHOD New(cProgress,cToken) CLASS tNDJProgress
	DEFAULT cProgress	:= "-;\;|;/"
	DEFAULT cToken		:= ";"	
	self:cClassName		:= "TNDJPROGRESS"
	self:aProgress		:= _StrToKArr(@cProgress,@cToken)
	self:nMax			:= Len(self:aProgress)
	self:nProgress		:= 0
Return(self)

METHOD ClassName() CLASS tNDJProgress
Return( ::cClassName )

METHOD Eval(cMethod,uPar01) CLASS tNDJProgress
	Local cEval
	DEFAULT cMethod := "PROGRESS"
	cMethod := Upper(cMethod)
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

METHOD Progress() CLASS tNDJProgress
Return(self:aProgress[IF(++self:nProgress>self:nMax,self:nProgress:=1,self:nProgress)])

METHOD Increment(cAlign) CLASS tNDJProgress
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

METHOD Decrement(cAlign) CLASS tNDJProgress
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