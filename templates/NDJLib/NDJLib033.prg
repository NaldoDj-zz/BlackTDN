#include "ndj.ch"
CLASS tNDJTimeCalc FROM LongClassName
	METHOD New() CONSTRUCTOR
	METHOD ClassName()	
	METHOD HMSToTime(nHours,nMinuts,nSeconds)
	METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
	METHOD SecsToTime(nSecs)
	METHOD TimeToSecs(cTime)
	METHOD SecsToHrs(nSeconds)
	METHOD HrsToSecs(nHours)
	METHOD SecsToMin(nSeconds)
	METHOD MinToSecs(nMinuts)
	METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
	METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
	METHOD Time2NextDay(cTime,dDate)
	METHOD ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet)
	METHOD MediumTime(cTime,nDividendo,lMiliSecs)
ENDCLASS

METHOD New() CLASS tNDJTimeCalc
Return(self)

METHOD ClassName() CLASS tNDJTimeCalc
Return("TNDJTIMECALC")

METHOD HMSToTime(nHours,nMinuts,nSeconds) CLASS tNDJTimeCalc

	Local cTime
	
	DEFAULT nHours		:= 0
	DEFAULT nMinuts		:= 0
	DEFAULT nSeconds	:= 0
	
	cTime := AllTrim(Str(nHours))
	cTime := StrZero(Val(cTime),Max(Len(cTime),2))
	cTime += ":"
	cTime += StrZero(Val(AllTrim(Str(nMinuts))),2)
	cTime += ":"
	cTime += StrZero(Val(AllTrim(Str(nSeconds))),2)

Return(cTime)

METHOD SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) CLASS tNDJTimeCalc

	Local nRet	:= 0
	
	DEFAULT nSecsToHMS	:= 0
	DEFAULT cRet		:= "H"
	
	nHours		:= self:SecsToHrs(nSecsToHMS)
	nMinuts		:= self:SecsToMin(nSecsToHMS)
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts))
	nSeconds	:= (nSecsToHMS-nSeconds)
	nSeconds	:= Int(nSeconds)
	nSeconds	:= Mod(nSeconds,60)
	
	IF (cRet$"Hh")
		nRet := nHours
	ElseIF (cRet$"Mm")
		nRet := nMinuts
	ElseIF (cRet$"Ss")
		nRet := nSeconds
	EndIF

Return(nRet)

METHOD SecsToTime(nSecs) CLASS tNDJTimeCalc
	Local nHours
	Local nMinuts
	Local nSeconds
	self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
Return(self:HMSToTime(nHours,nMinuts,nSeconds))

METHOD TimeToSecs(cTime) CLASS tNDJTimeCalc

	Local nHours
	Local nMinuts
	Local nSeconds
	
	DEFAULT cTime	:= "00:00:00"
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nMinuts		+= __Hrs2Min(nHours)
	nSeconds	+= (nMinuts*60)

Return(nSeconds)

METHOD SecsToHrs(nSeconds) CLASS tNDJTimeCalc
	Local nHours
	nHours	:= (nSeconds/3600)
	nHours	:= Int(nHours)
Return(nHours)

METHOD HrsToSecs(nHours) CLASS tNDJTimeCalc
Return((nHours*3600))

METHOD SecsToMin(nSeconds) CLASS tNDJTimeCalc
	Local nMinuts
	nMinuts		:= (nSeconds/60)
	nMinuts		:= Int(nMinuts)
	nMinuts		:= Mod(nMinuts,60)
Return(nMinuts)

METHOD MinToSecs(nMinuts) CLASS tNDJTimeCalc
Return((nMinuts*60))

METHOD IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) CLASS tNDJTimeCalc

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nIncHours	:= 0
	DEFAULT nIncMinuts	:= 0
	DEFAULT nIncSeconds	:= 0
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nHours		+= nIncHours
	nMinuts		+= nIncMinuts
	nSeconds	+= nIncSeconds
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
	
Return(self:SecsToTime(nSeconds))

METHOD DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) CLASS tNDJTimeCalc

	Local nSeconds
	Local nMinuts
	Local nHours
	
	DEFAULT nDecHours	:= 0
	DEFAULT nDecMinuts	:= 0
	DEFAULT nDecSeconds	:= 0
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nHours		-= nDecHours
	nMinuts		-= nDecMinuts
	nSeconds	-= nDecSeconds
	nSeconds	:= (self:HrsToSecs(nHours)+self:MinToSecs(nMinuts)+nSeconds)
	
Return(self:SecsToTime(nSeconds))

METHOD Time2NextDay(cTime,dDate) CLASS tNDJTimeCalc
	While (Val(cTime)>=24)
		cTime := self:DecTime(cTime,24)
		++dDate
	End While
Return({cTime,dDate})

METHOD ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet) CLASS tNDJTimeCalc

	Local nRet		:= 0
	
	Local nAT
	
	DEFAULT cTime	:= "00:00:00"
	DEFAULT cRet	:= "H"
	
	nAT	:= AT(":",cTime)
	
	IF (nAT == 0)
		nHours	:= Val(cTime)
		nMinutes:= 0
		nSeconds:= 0
	Else
		nHours	:= Val(SubStr(cTime,1,nAT-1))
		cTime	:= SubStr(cTime,nAT+1)
		nAT		:= (At(":",cTime))
		IF (nAT == 0)
			nMinutes := Val(cTime)
			nSeconds := 0
		Else
			nMinutes := Val(SubStr(cTime,1,nAT-1))
			nSeconds := Val(SubStr(cTime,nAT+1))
		EndIF
	EndIF
	
	IF (cRet$"Hh")
		nRet := nHours
	ElseIF (cRet$"Mm")
		nRet := nMinutes
	ElseIF (cRet$"Ss")
		nRet := nSeconds
	EndIF

Return(nRet)

METHOD MediumTime(cTime,nDividendo,lMiliSecs) CLASS tNDJTimeCalc

	Local cMediumTime	:= "00:00:00"
	
	Local nSeconds
	Local nMediumTime
	Local nMiliSecs
	
	IF (nDividendo>0)
	
		nSeconds	:= self:TimeToSecs(cTime)
		nSeconds	:= (nSeconds/nDividendo)
		nMediumTime	:= Int(nSeconds)
	
		nMiliSecs	:= (nSeconds-nMediumTime)
		nMiliSecs	*= 100
		nMiliSecs	:= Int(nMiliSecs)
	
		cMediumTime	:= self:SecsToTime(nMediumTime)
	
		DEFAULT lMiliSecs	:= .F.
		IF (;
				(lMiliSecs);
				.and.;
				(nMiliSecs>0);
			)
			cMediumTime += (":"+StrZero(nMiliSecs,02))
		EndIF
	
	EndIF

Return(cMediumTime)

CLASS tNDJRemaining FROM tNDJTimeCalc
	
	CLASSDATA cMediumTime	HIDDEN
	CLASSDATA cEndTime		HIDDEN
	CLASSDATA cStartTime	HIDDEN
	CLASSDATA cTimeDiff		HIDDEN
	CLASSDATA cTRemaining	HIDDEN
	CLASSDATA dEndTime		HIDDEN
	CLASSDATA dIncTime		HIDDEN
	CLASSDATA dStartTime	HIDDEN
	CLASSDATA nIncTime		HIDDEN
	CLASSDATA nProgress     HIDDEN
	CLASSDATA nSRemaining   HIDDEN
	CLASSDATA nTotal     	HIDDEN

	METHOD New(nTotal) CONSTRUCTOR
	METHOD ClassName()

	METHOD SetRemaining(nTotal)

	METHOD Calcule()
	METHOD RemainingTime()
	METHOD CalcEndTime()
	
	METHOD GetcMediumTime()
	METHOD GetcEndTime()
	METHOD GetcStartTime()
	METHOD GetcTimeDiff()
	METHOD GetcTRemaining()
	METHOD GetdEndTime()
	METHOD GetdIncTime()
	METHOD GetdStartTime()
	METHOD GetnIncTime()
	METHOD GetnProgress()
	METHOD GetnSRemaining()
	METHOD GetnTotal()
	
ENDCLASS

METHOD New(nTotal) CLASS tNDJRemaining
Return(self:SetRemaining(@nTotal))

METHOD ClassName() CLASS tNDJRemaining
Return("TNDJREMAINING")

METHOD SetRemaining(nTotal) CLASS tNDJRemaining
	DEFAULT nTotal 		:= 0
	self:cMediumTime	:= "00:00:00"	
	self:cEndTime		:= Time()
	self:cStartTime		:= self:cEndTime
	self:cTimeDiff		:= "00:00:00"
	self:cTRemaining	:= "00:00:00"
	self:dEndTime		:= Date()
	self:dIncTime		:= self:dEndTime
	self:dStartTime		:= self:dEndTime
	self:nIncTime		:= 0
	self:nProgress		:= 0
	self:nSRemaining	:= 0
	self:nTotal			:= nTotal
Return(self)

METHOD Calcule() CLASS tNDJRemaining
	Local aEndTime
	self:RemainingTime()
	self:cMediumTime		:= self:MediumTime(self:cTimeDiff,++self:nProgress,.T.)
	self:cEndTime			:= self:CalcEndTime()
	self:cEndTime			:= self:IncTime(Time(),NIL,NIL,self:TimeToSecs(self:cEndTime))
	aEndTime				:= self:Time2NextDay(self:cEndTime,Date())
	self:cEndTime			:= aEndTime[1]
	self:dEndTime			:= aEndTime[2]
Return(self)

METHOD RemainingTime() CLASS tNDJRemaining

	Local cTime		:= Time()
	Local dDate		:= Date()

	Local nHrsInc
	Local nMinInc
	Local nSecInc

	DEFAULT cTime	:= self:cStartTime

	IF .NOT.(self:dIncTime==dDate)
		self:dIncTime := dDate
		++self:nIncTime
	EndIF

	IF (self:nIncTime>0)
	    self:ExtractTime(self:cStartTime,@nHrsInc,@nMinInc,@nSecInc)
		cTime := self:IncTime(self:HMSToTime((nIncTime*24)),nHrsInc,nMinInc,nSecInc)
	EndIF

	self:cTimeDiff		:= ElapTime(self:cStartTime,cTime)
	self:cTRemaining	:= ElapTime(self:cTimeDiff,self:cStartTime)
	self:nSRemaining	:= self:TimeToSecs(self:cTimeDiff)

Return(self)

METHOD CalcEndTime() CLASS tNDJRemaining
	Local nTimeEnd := (((self:nTotal-self:nProgress)*self:nSRemaining)/self:nProgress)
Return(self:SecsToTime(nTimeEnd))

METHOD GetcMediumTime() CLASS tNDJRemaining
Return(self:cMediumTime)

METHOD GetcEndTime() CLASS tNDJRemaining
Return(self:cEndTime)

METHOD GetcStartTime() CLASS tNDJRemaining
Return(self:cStartTime)

METHOD GetcTimeDiff() CLASS tNDJRemaining
Return(self:cTimeDiff)

METHOD GetcTRemaining() CLASS tNDJRemaining
Return(self:cTRemaining)

METHOD GetdEndTime() CLASS tNDJRemaining
Return(self:dEndTime)

METHOD GetdIncTime() CLASS tNDJRemaining
Return(self:dIncTime)

METHOD GetdStartTime() CLASS tNDJRemaining
Return(self:dStartTime)

METHOD GetnIncTime() CLASS tNDJRemaining
Return(self:nIncTime)

METHOD GetnProgress() CLASS tNDJRemaining
Return(self:nProgress)

METHOD GetnSRemaining() CLASS tNDJRemaining
Return(self:nSRemaining)

METHOD GetnTotal() CLASS tNDJRemaining
Return(self:nTotal)