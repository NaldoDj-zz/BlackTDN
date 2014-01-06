#include "ndj.ch"
Class tNDJTimeCalc From LongClassName
	Method New() CONSTRUCTOR
	Method ClassName()	
	Method HMSToTime(nHours,nMinuts,nSeconds)
	Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet)
	Method SecsToTime(nSecs)
	Method TimeToSecs(cTime)
	Method SecsToHrs(nSeconds)
	Method HrsToSecs(nHours)
	Method SecsToMin(nSeconds)
	Method MinToSecs(nMinuts)
	Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds)
	Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds)
	Method Time2NextDay(cTime,dDate)
	Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet)
	Method MediumTime(cTime,nDividendo,lMiliSecs)
EndClass

Method New() Class tNDJTimeCalc
Return(self)

Method ClassName() Class tNDJTimeCalc
Return("TNDJTIMECALC")

Method HMSToTime(nHours,nMinuts,nSeconds) Class tNDJTimeCalc

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

Method SecsToHMS(nSecsToHMS,nHours,nMinuts,nSeconds,cRet) Class tNDJTimeCalc

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

Method SecsToTime(nSecs) Class tNDJTimeCalc
	Local nHours
	Local nMinuts
	Local nSeconds
	self:SecsToHMS(nSecs,@nHours,@nMinuts,@nSeconds)
Return(self:HMSToTime(nHours,nMinuts,nSeconds))

Method TimeToSecs(cTime) Class tNDJTimeCalc

	Local nHours
	Local nMinuts
	Local nSeconds
	
	DEFAULT cTime	:= "00:00:00"
	
	self:ExtractTime(cTime,@nHours,@nMinuts,@nSeconds)
	
	nMinuts		+= __Hrs2Min(nHours)
	nSeconds	+= (nMinuts*60)

Return(nSeconds)

Method SecsToHrs(nSeconds) Class tNDJTimeCalc
	Local nHours
	nHours	:= (nSeconds/3600)
	nHours	:= Int(nHours)
Return(nHours)

Method HrsToSecs(nHours) Class tNDJTimeCalc
Return((nHours*3600))

Method SecsToMin(nSeconds) Class tNDJTimeCalc
	Local nMinuts
	nMinuts		:= (nSeconds/60)
	nMinuts		:= Int(nMinuts)
	nMinuts		:= Mod(nMinuts,60)
Return(nMinuts)

Method MinToSecs(nMinuts) Class tNDJTimeCalc
Return((nMinuts*60))

Method IncTime(cTime,nIncHours,nIncMinuts,nIncSeconds) Class tNDJTimeCalc

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

Method DecTime(cTime,nDecHours,nDecMinuts,nDecSeconds) Class tNDJTimeCalc

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

Method Time2NextDay(cTime,dDate) Class tNDJTimeCalc
	While (Val(cTime)>=24)
		cTime := self:DecTime(cTime,24)
		++dDate
	End While
Return({cTime,dDate})

Method ExtractTime(cTime,nHours,nMinutes,nSeconds,cRet) Class tNDJTimeCalc

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

Method MediumTime(cTime,nDividendo,lMiliSecs) Class tNDJTimeCalc

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

Class tNDJRemaining From tNDJTimeCalc
	
	DATA cMediumTime	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cEndTime  		AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cStartTime  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cTimeDiff  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA cTRemaining  	AS CHARACTER INIT "00:00:00" HIDDEN
	DATA dEndTime		AS DATE      INIT Ctod("//") HIDDEN
	DATA dStartTime		AS DATE      INIT Ctod("//") HIDDEN
	DATA nCount			AS NUMERIC   INIT 0			 HIDDEN
	DATA nIncTime		AS NUMERIC   INIT 0			 HIDDEN	
	DATA nProgress		AS NUMERIC   INIT 0			 HIDDEN	
	DATA nSRemaining	AS NUMERIC   INIT 0			 HIDDEN
	DATA nTotal			AS NUMERIC   INIT 0			 HIDDEN

	Method New(nTotal) CONSTRUCTOR
	Method ClassName()

	Method SetRemaining(nTotal)

	Method Calcule()
	Method RemainingTime()
	Method CalcEndTime()
	
	Method GetcMediumTime()
	Method GetcEndTime()
	Method GetcStartTime()
	Method GetcTimeDiff()
	Method GetcTRemaining()
	Method GetdEndTime()
	Method GetdStartTime()
	Method GetnCount()
	Method GetnIncTime()
	Method GetnProgress()
	Method GetnSRemaining()
	Method GetnTotal()
	
ENDClass

Method New(nTotal) Class tNDJRemaining
	_Super:New()
	self:SetRemaining(@nTotal)
Return(self)

Method ClassName() Class tNDJRemaining
Return("TNDJREMAINING")

Method SetRemaining(nTotal) Class tNDJRemaining
	DEFAULT nTotal 		:= 1
	self:cMediumTime	:= "00:00:00"	
	self:cEndTime		:= "00:00:00"
	self:cStartTime		:= Time()
	self:cTimeDiff		:= "00:00:00"
	self:cTRemaining	:= "00:00:00"
	self:dEndTime		:= CToD("//")
	self:dStartTime		:= Date()
	self:nCount			:= 0
	self:nIncTime		:= 0
	self:nProgress		:= 0
	self:nSRemaining	:= 0
	self:nTotal			:= nTotal
Return(self)

Method Calcule() Class tNDJRemaining
	Local aEndTime
	self:nCount++
	self:RemainingTime()
	self:cMediumTime		:= self:MediumTime(self:cTimeDiff,++self:nProgress,.T.)
	self:cEndTime			:= self:CalcEndTime()
	self:cEndTime			:= self:IncTime(Time(),NIL,NIL,self:TimeToSecs(self:cEndTime))
	aEndTime				:= self:Time2NextDay(self:cEndTime,Date())
	self:cEndTime			:= aEndTime[1]
	self:dEndTime			:= aEndTime[2]
Return(self)

Method RemainingTime() Class tNDJRemaining

	Local cTime		:= Time()
	Local dDate		:= Date()

	Local nHrsInc
	Local nMinInc
	Local nSecInc

	self:nIncTime  := abs(dDate-self:dStartTime)

	IF (self:nIncTime>0)
	    self:ExtractTime(self:cStartTime,@nHrsInc,@nMinInc,@nSecInc)
		cTime := self:IncTime(self:HMSToTime((self:nIncTime*24)),nHrsInc,nMinInc,nSecInc)
	EndIF

	self:cTimeDiff		:= ElapTime(self:cStartTime,cTime)
	self:cTRemaining	:= ElapTime(self:cTimeDiff,self:cStartTime)
	self:nSRemaining	:= self:TimeToSecs(self:cTimeDiff)

Return(self)

Method CalcEndTime() Class tNDJRemaining
	Local nTimeEnd := (((self:nTotal-self:nProgress)*self:nSRemaining)/self:nProgress)
Return(self:SecsToTime(nTimeEnd))

Method GetcMediumTime() Class tNDJRemaining
Return(self:cMediumTime)

Method GetcEndTime() Class tNDJRemaining
Return(self:cEndTime)

Method GetcStartTime() Class tNDJRemaining
Return(self:cStartTime)

Method GetcTimeDiff() Class tNDJRemaining
Return(self:cTimeDiff)

Method GetcTRemaining() Class tNDJRemaining
Return(self:cTRemaining)

Method GetdEndTime() Class tNDJRemaining
Return(self:dEndTime)

Method GetdStartTime() Class tNDJRemaining
Return(self:dStartTime)

Method GetnCount() Class tNDJRemaining
Return(self:nCount)

Method GetnIncTime() Class tNDJRemaining
Return(self:nIncTime)

Method GetnProgress() Class tNDJRemaining
Return(self:nProgress)

Method GetnSRemaining() Class tNDJRemaining
Return(self:nSRemaining)

Method GetnTotal() Class tNDJRemaining
Return(self:nTotal)