#include "tBigNumber.ch"

#IFDEF __PROTHEUS__
	Static __cEnvSrv
#ENDIF

Static __o0
Static __o1
Static __o2
Static __o5
Static __o10
Static __cstcZ0
Static __nstcZ0
Static __cstcN9
Static __nstcN9
Static __lstbNSet

#IFDEF TBN_ARRAY
	THREAD Static __aZAdd
	THREAD Static __aZSub
	THREAD Static __aZMult
#ENDIF

#IFDEF TBN_DBFILE
	THREAD Static __aFiles
	Static __nThdID
#ENDIF

THREAD Static __nthRootAcc
THREAD Static __nSetDecimals

THREAD Static __eqoN1
THREAD Static __eqoN2

THREAD Static __gtoN1
THREAD Static __gtoN2

THREAD Static __ltoN1
THREAD Static __ltoN2

THREAD Static __adoNR
THREAD Static __adoN1
THREAD Static __adoN2

THREAD Static __sboNR
THREAD Static __sboN1
THREAD Static __sboN2

THREAD Static __mtoNR
THREAD Static __mtoN1
THREAD Static __mtoN2

THREAD Static __dvoNR
THREAD Static __dvoN1
THREAD Static __dvoN2
THREAD Static __dvoRDiv	

THREAD Static __pwoA
THREAD Static __pwoB
THREAD Static __pwoNP
THREAD Static __pwoNR
THREAD Static __pwoNT
THREAD Static __pwoGCD

THREAD Static __oeDivN
THREAD Static __oeDivD
THREAD Static __oeDivR

THREAD Static __oSysSQRT

THREAD Static __lsthdSet

#DEFINE RANDOM_MAX_EXIT			5
#DEFINE EXIT_MAX_RANDOM			50
#IFDEF __PROTHEUS__
	#DEFINE MAX_LENGHT_ADD_THREAD   1000 //Achar o Melhor Valor para q seja compensador
#ELSE
	#DEFINE MAX_LENGHT_ADD_THREAD   1000 //Achar o Melhor Valor para q seja compensador
#ENDIF	

#DEFINE NTHROOT_EXIT		3
#DEFINE MAX_SYS_SQRT		"9999999999999999"

/*
*	Alternative Compile Options: /D
*
*	#IFDEF __PROTHEUS__
*		/DTBN_ARRAY
*		/DTBN_DBFILE 
*		/D__TBN_DYN_OBJ_SET__ 
*		/D__POWMT__
*		/D__ROOTMT__
*		/D__ADDMT__
*		/D__SUBTMT__
*		/D__MULTMT__
*	#ELSE //__HARBOUR__
*		/DTBN_ARRAY
*		/DTBN_DBFILE 
*		/DTBN_MEMIO 
*		/D__TBN_DYN_OBJ_SET__ 
*		/D__POWMT__ 
*		/D__ROOTMT__
*		/D__ADDMT__
*		/D__SUBTMT__
*		/D__MULTMT__
*	#ENDIF
*/

/*
	Class		: tBigNumber
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Instancia um novo objeto do tipo BigNumber
	Sintaxe     : tBigNumber():New(uBigN) -> self
*/
CLASS tBigNumber

#IFNDEF __PROTHEUS__
	#IFNDEF __TBN_DYN_OBJ_SET__
		PROTECTED:
	#ENDIF
#ENDIF
	/* Keep in alphabetical order */
	DATA cDec  AS CHARACTER INIT ""
	DATA cInt  AS CHARACTER INIT ""
	DATA cRDiv AS CHARACTER INIT ""
	DATA cSig  AS CHARACTER INIT ""
	DATA lNeg  AS LOGICAL   INIT .F. 
	DATA nBase AS NUMERIC   INIT 0
	DATA nDec  AS NUMERIC   INIT 0
	DATA nInt  AS NUMERIC   INIT 0
	DATA nSize AS NUMERIC   INIT 0

#IFNDEF __PROTHEUS__
	PROTECTED:
#ENDIF

	Method Normalize(oBigN)

#IFNDEF __PROTHEUS__
	EXPORTED:
#ENDIF	
	
	Method New(uBigN,nBase) CONSTRUCTOR

#IFNDEF __PROTHEUS__
	#IFDEF TBN_DBFILE
		#IFNDEF TBN_MEMIO
			DESTRUCTOR tBigNGC
		#ENDIF	
	#ENDIF	
#ENDIF	

	Method Clone()
	Method ClassName()

	Method SetDecimals(nSet)

	Method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc)
	Method GetValue(lAbs,lObj)
	Method ExactValue(lAbs,lObj)

	Method Abs(lObj)
	
	Method Int(lObj,lSig)
	Method Dec(lObj,lSig,lNotZ)

	Method eq(uBigN)
	Method ne(uBigN)
	Method gt(uBigN)
	Method lt(uBigN)
	Method gte(uBigN)
	Method lte(uBigN)
	
	Method Max(uBigN,lObj)
	Method Min(uBigN,lObj)
	
	Method Add(uBigN)	//TODO: Implementar Adicao Binaria e Hexa
	Method Sub(uBigN)	//TODO: Implementar Subtracao Binaria e Hexa
	
	Method Mult(uBigN,leMult)	//TODO: Implementar Multiplicacao Binaria e Hexa	
	Method Div(uBigN,lFloat)	//TODO: Implementar Divisao Binaria e Hexa

	Method Mod(uBigN)
	Method Pow(uBigN)	//TODO: Validar o Calculo quando expoente fracionario
	
	Method e(lForce)
	Method Exp(lForce)
	Method PI(lForce)	//TODO: Implementar o calculo.
	Method GCD(uBigN)
	Method LCM(uBigN)
	
	Method nthRoot(uBigN)
	Method nthRootAcc(nSet)

	Method SQRT()
	Method SysSQRT(uSet)

	Method Log(uBigNB)	//TODO: Validar Calculo.
	Method Log2()		//TODO: Validar Calculo.
	Method Log10()		//TODO: Validar Calculo.
	Method Ln()			//TODO: Validar Calculo.

	Method aLog(uBigNB)	//TODO: Validar Calculo.
	Method aLog2()		//TODO: Validar Calculo.
	Method aLog10()		//TODO: Validar Calculo.
	Method aLn()		//TODO: Validar Calculo.

	Method MathC(uBigN1,cOperator,uBigN2)
	Method MathN(uBigN1,cOperator,uBigN2)

	Method Rnd(nAcc)
	Method NoRnd(nAcc)
	Method Truncate(nAcc)

	Method D2H(cHexB)
	Method H2D()

	Method H2B()
	Method B2H(cHexB)

	Method D2B(cHexB)
	Method B2D()

	Method Randomize(uB,uE,nExit)

	Method millerRabin(uI)
	
	Method FI()
	
	Method PFactors()
	Method Factorial()	//TODO: Otimizar

#IFNDEF __PROTHEUS__

	OPERATOR "==" ARG uBigN INLINE (self:eq(uBigN))

	OPERATOR "!=" ARG uBigN INLINE (self:ne(uBigN))
	OPERATOR "#"  ARG uBigN INLINE (self:ne(uBigN))
	OPERATOR "<>" ARG uBigN INLINE (self:ne(uBigN))
		
	OPERATOR ">"  ARG uBigN INLINE (self:gt(uBigN))
	OPERATOR ">=" ARG uBigN INLINE (self:gte(uBigN))

	OPERATOR "<"  ARG uBigN INLINE (self:lt(uBigN))
	OPERATOR "<=" ARG uBigN INLINE (self:lte(uBigN))
	
	OPERATOR "+"  ARG uBigN INLINE (self:Add(uBigN))
	OPERATOR "++" INLINE (self:SetValue(self:Add(__o1)))
	OPERATOR "+=" ARG uBigN INLINE (self:SetValue(self:Add(uBigN)))

	OPERATOR "-"  ARG uBigN INLINE (self:Sub(uBigN))
	OPERATOR "--" INLINE (self:SetValue(self:Sub(__o1)))
	OPERATOR "-=" ARG uBigN INLINE (self:SetValue(self:Sub(uBigN)))
	
	OPERATOR "*"  ARG uBigN INLINE (self:Mult(uBigN))
	OPERATOR "*=" ARG uBigN INLINE (self:SetValue(self:Mult(uBigN)))

	OPERATOR "/"  ARGS uBigN,lFloat INLINE (self:Div(uBigN,lFloat))
	OPERATOR "/=" ARGS uBigN,lFloat INLINE (self:SetValue(self:Div(uBigN,lFloat)))
	
	OPERATOR "%"  ARG uBigN INLINE (self:Mod(uBigN))
	OPERATOR "%=" ARG uBigN INLINE (self:SetValue(self:Mod(uBigN)))
	
	OPERATOR "^"  ARG uBigN INLINE (self:Pow(uBigN))
	OPERATOR "**" ARG uBigN INLINE (self:Pow(uBigN))
	OPERATOR "^=" ARG uBigN INLINE (self:SetValue(self:Pow(uBigN)))
	
	OPERATOR ":=" ARGS uBigN,nBase,cRDiv,lLZRmv,nAcc INLINE (self:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))
	OPERATOR "="  ARGS uBigN,nBase,cRDiv,lLZRmv,nAcc INLINE (self:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))

#ENDIF
                    
ENDCLASS

/*
	Função		: tBigNumber():New
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Instancia um novo Objeto tBigNumber
	Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
#IFDEF __PROTHEUS__
	User Function tBigNumber(uBigN,nBase)
	Return(tBigNumber():New(uBigN,nBase))
#ENDIF

/*
	Method		: New
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : CONSTRUCTOR
	Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
Method New(uBigN,nBase) CLASS tBigNumber
	
	/* workaround for problem with command DEFAULT*/
	IF ValType(nBase)<>"N"
		nBase := 10	
	EndIF
	self:nBase    := nBase

	IF __lsthdSet==NIL
	
		__lsthdSet := .F.
		
		self:SetDecimals()
		self:nthRootAcc()
		
		__cstcZ0 := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
		__nstcZ0 := 150
		
		__cstcN9 := "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
		__nstcN9 := 150
		
		#IFDEF TBN_ARRAY
			__aZAdd	 := Array(0)
			__aZSub	 := Array(0)
			__aZMult := Array(0)
		#ENDIF    
		#IFDEF TBN_DBFILE
			__aFiles := Array(0)
		#ENDIF

		__eqoN1 := tBigNumber():New()
		__eqoN2 := tBigNumber():New()

		__gtoN1 := tBigNumber():New()	
		__gtoN2 := tBigNumber():New()

		__ltoN1 := tBigNumber():New()	
		__ltoN2 := tBigNumber():New()

		__adoNR := tBigNumber():New()
		__adoN1 := tBigNumber():New()
		__adoN2 := tBigNumber():New()

		__sboNR := tBigNumber():New()
		__sboN1 := tBigNumber():New()
		__sboN2 := tBigNumber():New()

		__mtoNR := tBigNumber():New()
		__mtoN1 := tBigNumber():New()
		__mtoN2 := tBigNumber():New()

		__dvoNR   := tBigNumber():New()
		__dvoN1   := tBigNumber():New()
		__dvoN2   := tBigNumber():New()
		__dvoRDiv := tBigNumber():New()

		__pwoA	 := tBigNumber():New()
		__pwoB	 := tBigNumber():New()
		__pwoNP	 := tBigNumber():New()
		__pwoNR	 := tBigNumber():New()
		__pwoNT	 := tBigNumber():New()	
		__pwoGCD := tBigNumber():New()
		
		__oeDivN := tBigNumber():New()
		__oeDivD := tBigNumber():New()
		__oeDivR := tBigNumber():New()

		__oSysSQRT := tBigNumber():New()
	
		__lsthdSet := .T.
	
	EndIF

	/* workaround for problem with command DEFAULT*/
	IF .NOT.(ValType(uBigN)$"O/C")
		uBigN := "0"
	EndIF
	self:SetValue(uBigN,nBase)

	IF __lstbNSet==NIL
		__lstbNSet := .F.
		__o0  := tBigNumber():New("0",nBase)
		__o1  := tBigNumber():New("1",nBase)
		__o2  := tBigNumber():New("2",nBase)
		__o5  := tBigNumber():New("5",nBase)
		__o10 := tBigNumber():New("10",nBase)		 	
		#IFDEF __PROTHEUS__
			DEFAULT __cEnvSrv := GetEnvServer()
		#ENDIF
		#IFDEF TBN_DBFILE
			#IFDEF __PROTHEUS__
				__nThdID := ThreadID()
			#ELSE
				__nThdID := hb_ThreadID()
			#ENDIF	
		#ENDIF
		__lstbNSet := .T.
	EndIF

Return(self)

/*
	Method		: tBigNGC
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 03/03/2013
	Descricao   : DESTRUCTOR
*/
#IFDEF __PROTHEUS__
STATIC PROCEDURE tBigNGC(lGC)
#ELSE
#IFDEF TBN_DBFILE
	#IFNDEF TBN_MEMIO
		METHOD tBigNGC() CLASS tBigNumber		
		Return(tBigNGC())
	#ENDIF
#ENDIF
PROCEDURE tBigNGC(lGC)
#ENDIF
	#IFDEF TBN_DBFILE
		Local nFile
		Local nFiles
		#IFDEF __PROTHEUS__
			DEFAULT lGC	:= .NOT.(__nThdID==ThreadID())
		#ELSE
			DEFAULT lGC	:= .NOT.(__nThdID==hb_ThreadID())
		#ENDIF
		IF lGC
			nFiles	:= Len(__aFiles)
			For nFile := 1 To nFiles
				IF Select(__aFiles[nFile][1])>0
					(__aFiles[nFile][1])->(dbCloseArea())
				EndIF			
				#IFDEF __PROTHEUS__
					MsErase(__aFiles[nFile][2],NIL,IF((Type("__LocalDriver")=="C"),__LocalDriver,"DBFCDXADS"))
				#ELSE
					#IFDEF TBN_MEMIO
						dbDrop(__aFiles[nFile][2])
					#ELSE
						fErase(__aFiles[nFile][2])
					#ENDIF
				#ENDIF
			Next nFile
			aSize(__aFiles,0)
		ENDIF
	#ELSE
		SYMBOL_UNUSED( lGC )
	#ENDIF
Return

/*
	Method		: Clone
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 27/03/2013
	Descricao   : Clone
	Sintaxe     : tBigNumber():Clone() -> oClone
*/
Method Clone() CLASS tBigNumber
Return(tBigNumber():New(self))

/*
	Method		: ClassName
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : ClassName
	Sintaxe     : tBigNumber():ClassName() -> cClassName
*/
Method ClassName() CLASS tBigNumber
Return("TBIGNUMBER")

/*
	Method:		SetDecimals
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		04/02/2013
	Descricao:	Setar o Numero de Casas Decimais
	Sintaxe:	tBigNumber():SetDecimals(nSet) -> nLastSet
*/
Method SetDecimals(nSet) CLASS tBigNumber

	Local nLastSet 			:= __nSetDecimals

	DEFAULT __nSetDecimals	:= IF(nSet==NIL,32,nSet)
	DEFAULT nSet			:= __nSetDecimals
	DEFAULT nLastSet		:= nSet

	IF nSet>MAX_DECIMAL_PRECISION
	    nSet := MAX_DECIMAL_PRECISION
	EndIF

	__nSetDecimals	:= nSet

Return(nLastSet)

/*
	Method:		nthRootAcc
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		04/02/2013
	Descricao:	Setar a Precisao para nthRoot
	Sintaxe:	tBigNumber():nthRootAcc(nSet) -> nLastSet
*/
Method nthRootAcc(nSet) CLASS tBigNumber

	Local nLastSet 			:= __nthRootAcc

	DEFAULT __nthRootAcc	:= IF(nSet==NIL,6,nSet)
	DEFAULT nSet			:= __nthRootAcc
	DEFAULT nLastSet		:= nSet

	IF nSet>MAX_DECIMAL_PRECISION
	    nSet := MAX_DECIMAL_PRECISION
	EndIF

	__nthRootAcc := Min(self:SetDecimals()-1,nSet)

Return(nLastSet)

/*
	Method		: SetValue
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : SetValue
	Sintaxe     : tBigNumber():SetValue(uBigN,nBase,cRDiv,lLZRmv) -> self
*/
Method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc) CLASS tBigNumber

	Local cType	:= ValType(uBigN)

	Local nFP

	#IFDEF __TBN_DYN_OBJ_SET__
	Local nP
		#IFDEF __HARBOUR__
			MEMVAR This
		#ENDIF
		Private This
	#ENDIF	

	IF cType=="O"
	
		DEFAULT cRDiv := uBigN:cRDiv

		#IFDEF __TBN_DYN_OBJ_SET__

			#IFDEF __PROTHEUS__
	
				This  := self
				uBigN := ClassDataArr(uBigN)
				nFP   := Len(uBigN)
				
				For nP := 1 To nFP
					&("This:"+uBigN[nP][1]) := uBigN[nP][2]
				Next nP	
		    
		    #ELSE
	
				__objSetValueList(self,__objGetValueList(uBigN))
	
			#ENDIF	
			
		#ELSE

			self:cDec  := uBigN:cDec
			self:cInt  := uBigN:cInt
			self:cRDiv := uBigN:cRDiv
			self:cSig  := uBigN:cSig
			self:lNeg  := uBigN:lNeg
			self:nBase := uBigN:nBase
			self:nDec  := uBigN:nDec
			self:nInt  := uBigN:nInt
			self:nSize := uBigN:nSize
			
		#ENDIF
	
	ElseIF cType=="A"

		DEFAULT cRDiv := uBigN[3][2]
		
		#IFDEF __TBN_DYN_OBJ_SET__

			This := self
			nFP  := Len(uBigN)
	
			For nP := 1 To nFP
				&("This:"+uBigN[nP][1]) := uBigN[nP][2]
			Next nP	
		
		#ELSE

			self:cDec  := uBigN[1][2]
			self:cInt  := uBigN[2][2]
			self:cRDiv := uBigN[3][2]
			self:cSig  := uBigN[4][2]
			self:lNeg  := uBigN[5][2]
			self:nBase := uBigN[6][2]
			self:nDec  := uBigN[7][2]
			self:nInt  := uBigN[8][2]
			self:nSize := uBigN[9][2]
		
		#ENDIF
	
	ElseIF cType=="C"

	    While " " $ uBigN
	    	uBigN := StrTran(uBigN," ","")	
	    End While

	    self:lNeg := SubStr(uBigN,1,1)=="-"

		IF self:lNeg
			uBigN := SubStr(uBigN,2)
			self:cSig := "-"
		Else
			self:cSig := ""
		EndIF

		nFP := AT(".",uBigN)

		DEFAULT nBase := self:nBase

		self:cInt := "0"
		IF self:nBase==10
			self:cDec := "0"
		Else
			self:cDec := ""
		EndIF

		DO CASE
		CASE nFP==0
			self:cInt := SubStr(uBigN,1)
			IF self:nBase==10
				self:cDec := "0"
			Else
				self:cDec := ""
			EndIF	
		CASE nFP==1
		    self:cInt := "0"
		    self:cDec := SubStr(uBigN,nFP+1)
		OTHERWISE
		    self:cInt := SubStr(uBigN,1,nFP-1)
		    self:cDec := SubStr(uBigN,nFP+1)
		ENDCASE
		
		IF self:nBase<>10
			IF self:cDec=="0"
				self:cDec := ""
			EndIF
		EndIF

		IF self:cInt=="0" .and. self:cDec=="0"
			self:lNeg := .F.
			self:cSig := ""
		EndIF

	    self:nInt  := Len(self:cInt)
	    self:nDec  := Len(self:cDec)
	    self:nSize := self:nInt+self:nDec

	EndIF

	IF Empty(cRDiv)
		cRDiv := "0"
	EndIF
	self:cRDiv := cRDiv

	DEFAULT lLZRmv := (self:nBase==10)
    IF lLZRmv
		While self:nInt>1 .and. SubStr(self:cInt,1,1)=="0"
			self:cInt := SubStr(self:cInt,2)
			--self:nInt
		End While
	EndIF

	DEFAULT nAcc := __nSetDecimals
	IF self:nDec>nAcc
		self:nDec := nAcc
		self:cDec := SubStr(self:cDec,1,self:nDec)
	EndIF

    self:nSize := (self:nInt+self:nDec)

Return(self)

/*
	Method		: GetValue
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : GetValue
	Sintaxe     : tBigNumber():GetValue(lAbs,lObj) -> uNR
*/
Method GetValue(lAbs,lObj) CLASS tBigNumber

	Local uNR

	DEFAULT lAbs := .F.
	DEFAULT lObj := .F.
	
    uNR	:= IF(lAbs,"",self:cSig)
    uNR	+= self:cInt
    uNR	+= "."
    uNR	+= self:cDec

	IF lObj
		uNR	:= tBigNumber():New(uNR)
	EndIF

Return(uNR)        

/*
	Method		: ExactValue
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : ExactValue
	Sintaxe     : tBigNumber():ExactValue(lAbs) -> uNR
*/
Method ExactValue(lAbs,lObj) CLASS tBigNumber

	Local cDec

	Local uNR

	DEFAULT lAbs := .F.
	DEFAULT lObj := .F.

    uNR	 := IF(lAbs,"",self:cSig)

    uNR	 += self:cInt
    cDec := self:Dec(NIL,NIL,self:nBase==10)

	IF .NOT.(Empty(cDec))
	    uNR	+= "."
	    uNR	+= cDec
	EndIF

	IF lObj
		uNR	:= tBigNumber():New(uNR)
	EndIF

Return(uNR)

/*
	Method		: Abs
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Retorna o Valor Absoluto de um Numero
	Sintaxe     : tBigNumber():Abs() -> uNR
*/
Method Abs(lObj) CLASS tBigNumber
Return(self:GetValue(.T.,lObj))

/*
	Method		: Int
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Retorna a Parte Inteira de um Numero
	Sintaxe     : tBigNumber():Int(lObj,lSig) -> uNR
*/
Method Int(lObj,lSig) CLASS tBigNumber
	Local uNR
	DEFAULT lObj := .F.
	DEFAULT lSig := .F.
	uNR	:= IF(lSig,self:cSig,"")+self:cInt
	IF lObj
		uNR	:= tBigNumber():New(uNR)
	EndIF
Return(uNR)

/*
	Method		:	Dec
	Autor       :	Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        :	04/02/2013
	Descricao   :	Retorna a Parte Decimal de um Numero
	Sintaxe     :	tBigNumber():Dec(lObj,lSig,lNotZ) -> uNR
*/
Method Dec(lObj,lSig,lNotZ) CLASS tBigNumber

    Local cDec := self:cDec
    
    Local nDec
    
    Local uNR

	DEFAULT lNotZ := .F.
	IF lNotZ
		nDec := self:nDec
		While SubStr(cDec,-1)=="0"
			cDec := SubStr(cDec,1,--nDec)
		End While
	EndIF

	DEFAULT lObj := .F.
	DEFAULT lSig := .F.
	IF lObj
		uNR	:= tBigNumber():New(IF(lSig,self:cSig,"")+"0."+cDec)
	Else
		uNR	:= IF(lSig,self:cSig,"")+cDec
	EndIF

Return(uNR)

/*
	Method		: eq
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Compara se o valor corrente eh igual ao passado como parametro
	Sintaxe     : tBigNumber():eq(uBigN) -> leq
*/
Method eq(uBigN) CLASS tBigNumber

	Local leq

	__eqoN1:SetValue(self)
	__eqoN2:SetValue(uBigN)
	
	__eqoN1:Normalize(@__eqoN2)

	leq	:= __eqoN1:GetValue(.T.)==__eqoN2:GetValue(.T.) .and. __eqoN1:lNeg==__eqoN2:lNeg

Return(leq)

/*
	Method		: ne
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Verifica se o valor corrente eh igual ao valor passado como parametro
	Sintaxe     : tBigNumber():ne(uBigN) -> .NOT.(leq)
*/
Method ne(uBigN) CLASS tBigNumber
Return(.NOT.(self:eq(uBigN)))

/*
	Method		: gt
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Verifica se o valor corrente eh maior que o valor passado como parametro
	Sintaxe     : tBigNumber():gt(uBigN) -> lgt
*/
Method gt(uBigN) CLASS tBigNumber

	Local cN1
	Local cN2

	Local lgt

	__gtoN1:SetValue(self)
	__gtoN2:SetValue(uBigN)
	
	__gtoN1:Normalize(@__gtoN2)

	cN1	:= __gtoN1:GetValue(.T.)
	cN2	:= __gtoN2:GetValue(.T.)

	IF __gtoN1:lNeg .or. __gtoN2:lNeg
		IF __gtoN1:lNeg .and. __gtoN2:lNeg
			lgt := cN1<cN2
		ElseIF __gtoN1:lNeg .and. .NOT.(__gtoN2:lNeg)
			lgt := .F.
		ElseIF .NOT.(__gtoN1:lNeg) .and. __gtoN2:lNeg
			lgt := .T.
		EndIF
	Else
		lgt := cN1>cN2
	EndIF	

Return(lgt)

/*
	Method		: lt
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Verifica se o valor corrente eh menor que o valor passado como parametro
	Sintaxe     : tBigNumber():lt(uBigN) -> llt
*/
Method lt(uBigN) CLASS tBigNumber

	Local cN1
	Local cN2
	
	Local llt

	__ltoN1:SetValue(self)
	__ltoN2:SetValue(uBigN)
	
	__ltoN1:Normalize(@__ltoN2)
	
	cN1	:= __ltoN1:GetValue(.T.)
	cN2	:= __ltoN2:GetValue(.T.)

	IF __ltoN1:lNeg .or. __ltoN2:lNeg
		IF __ltoN1:lNeg .and. __ltoN2:lNeg
			llt := cN1>cN2
		ElseIF __ltoN1:lNeg .and. .NOT.(__ltoN2:lNeg)
			llt := .T.
		ElseIF .NOT.(__ltoN1:lNeg) .and. __ltoN2:lNeg
			llt := .F.
		EndIF
	Else
		llt := cN1<cN2
	EndIF	

Return(llt)

/*
	Method		: gte
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Verifica se o valor corrente eh maior ou igual ao valor passado como parametro
	Sintaxe     : tBigNumber():gte(uBigN) -> lgte
*/
Method gte(uBigN) CLASS tBigNumber
Return(self:gt(uBigN).or.self:eq(uBigN))

/*
	Method		: lte
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Verifica se o valor corrente eh menor ou igual ao valor passado como parametro
	Sintaxe     : tBigNumber():lte(uBigN) -> lte
*/
Method lte(uBigN) CLASS tBigNumber
Return(self:lt(uBigN).or.self:eq(uBigN))

/*
	Method		: Max
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Retorna o maior valor entre o valor corrente e o valor passado como parametro
	Sintaxe     : tBigNumber():Max(uBigN) -> uNR
*/
Method Max(uBigN,lObj) CLASS tBigNumber
	
	Local lgte := self:gte(uBigN)

	Local uNR
	
	IF lgte
		uNR	:= self:Clone()
	Else
		DEFAULT lObj := .T.
		IF lObj .and. .NOT.(ValType(uBigN)=="O")
			uNR	:= tBigNumber():New(uBigN)
		Else
			uNR	:= uBigN:Clone()
		EndIF	
	EndIF

Return(uNR)

/*
	Method		: Min
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Retorna o menor valor entre o valor corrente e o valor passado como parametro
	Sintaxe     : tBigNumber():Min(uBigN) -> uNR
*/
Method Min(uBigN,lObj) CLASS tBigNumber
	
	Local llte := self:lte(uBigN)

	Local uNR
	
	IF llte
		uNR	:= self:Clone()
	Else
		DEFAULT lObj := .T.
		IF lObj .and. .NOT.(ValType(uBigN)=="O")
			uNR	:= tBigNumber():New(uBigN)
		Else
			uNR	:= uBigN:Clone()
		EndIF
	EndIF

Return(uNR)

/*
	Method		: Add
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Soma
	Sintaxe     : tBigNumber():Add(uBigN) -> oBigNR
*/
Method Add(uBigN) CLASS tBigNumber

	Local cInt		
	Local cDec		

	Local cN1
	Local cN2
	Local cNT

	Local lNeg	 	
	Local lInv
	Local lAdd		:= .T.

	Local n1
	Local n2

	Local nDec		
	Local nSize 	

	__adoN1:SetValue(self)
	__adoN2:SetValue(uBigN)
	
	__adoN1:Normalize(@__adoN2)

	BEGIN SEQUENCE

		IF __adoN1:nBase==10 .and. __adoN1:nSize<=14 .and. __adoN2:nSize<=14
			n1	:= Val(__adoN1:ExactValue())
			n2	:= Val(__adoN2:ExactValue())
			IF n1<=999999999.9999 .and. __adoN1:nDec<=4 .and. n2<=999999999.9999 .and. __adoN2:nDec<=4
				cNT	:= hb_ntos(n1+n2)
				__adoNR:SetValue(cNT)
				BREAK
			EndIF
		EndIF	

	    nDec  := __adoN1:nDec
	    nSize := __adoN1:nSize
	
	    cN1	:= __adoN1:cInt
	    cN1	+= __adoN1:cDec
	
	    cN2	:= __adoN2:cInt
	    cN2	+= __adoN2:cDec
	
	    lNeg := (__adoN1:lNeg .and. .NOT.(__adoN2:lNeg)) .or. (.NOT.(__adoN1:lNeg) .and. __adoN2:lNeg)
	
		IF lNeg
			lAdd := .F.
			lInv :=  cN1<cN2
			lNeg := (__adoN1:lNeg .and. .NOT.(lInv)) .or. (__adoN2:lNeg .and. lInv)
			IF lInv
				cNT	:= cN1
				cN1	:= cN2
				cN2	:= cNT
				cNT	:= NIL
			EndIF
	    Else
	    	lNeg := __adoN1:lNeg
	    EndIF
	
		IF lAdd
			#IFDEF __ADDMT__
		        IF nSize>MAX_LENGHT_ADD_THREAD .and. Int(nSize/MAX_LENGHT_ADD_THREAD)>=2
			        __adoNR:SetValue(AddThread(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
		        Else
		        	__adoNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
		        EndIF
			#ELSE
				__adoNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
			#ENDIF
		Else
			#IFDEF __SUBMT__
				__adoNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
			#ELSE
				__adoNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
			#ENDIF
		EndIF
	
	    cNT  := __adoNR:cInt
	    cDec := SubStr(cNT,-nDec)
	    cInt := SubStr(cNT,1,Len(cNT)-nDec)
	
	    cNT	:= cInt
	    cNT	+= "."
	    cNT	+= cDec
	
		__adoNR:SetValue(cNT)
	
		IF lNeg
			IF  __adoNR:gt(__o0)
				__adoNR:cSig := "-"
				__adoNR:lNeg := lNeg
			EndIF
		EndIF

	END SEQUENCE

Return(__adoNR)

#IFDEF __ADDMT__

	/*/
		Funcao:		AddThread
		Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data:		25/02/2013
		Descricao:	ADD via JOB
		Sintaxe:	AddThread(oN1,oN2)
	/*/
	Static Function AddThread(cN1,cN2,nSize,nBase)
	
		Local aNR

		Local cNR
		Local cT1
		Local cT2

		Local aThreads

	#IFDEF __PROTHEUS__
		Local cGlbV
		Local cThread := hb_ntos(ThreadID())
	#ENDIF	

		Local lAdd1 := .F.
		Local lExit := .F.

	#IFDEF __PROTHEUS__
		Local nNR
	#ENDIF
		Local nID
	#IFDEF __PROTHEUS__
		Local nIDs
		Local n
		Local t
	#ENDIF		
		Local w
		Local x
		Local y := Mod(nSize,MAX_LENGHT_ADD_THREAD)
		Local z
	
		BEGIN SEQUENCE

			lAdd1 := (y>0)
			
			IF (lAdd1)
				cT1 := SubStr(cN1,1,y)
				cT2 := SubStr(cN2,1,y)
				y   := 1
			EndIF

			aNR := Array(Int(nSize/MAX_LENGHT_ADD_THREAD)+y,5)
			
			IF (lAdd1)
				aNR[1][2]	:= cT1
				aNR[1][3]	:= cT2
				x			:= 2
				y			:= Len(cT1)+1
				cT1			:= SubStr(cN1,y)
				cT2			:= SubStr(cN2,y)
			Else
				x   		:= 1
				cT1			:= cN1
				cT2			:= cN2
			EndIF

			z := 1
			y := Len(aNR)
			
			For x := x To y
				aNR[x][2]	:= SubStr(cT1,z,MAX_LENGHT_ADD_THREAD)
				aNR[x][3]	:= SubStr(cT2,z,MAX_LENGHT_ADD_THREAD)
				z			+= MAX_LENGHT_ADD_THREAD
			Next x
            
			x := 0
			z := 0

			aThreads := Array(0)

			For x := 1 TO y

				#IFDEF __PROTHEUS__
					lExit := KillApp()
					IF lExit
						EXIT
					EndIF
				#ENDIF	
            
				++z

				nID	:= x
	
				aNR[nID][1]	:= .F.

	        	#IFDEF __HARBOUR__
		        	aNR[nID][4]	:= hb_threadStart("ThAdd",aNR[nID][2],aNR[nID][3],Len(aNR[nID][2]),nBase)
		        	aNR[nID][5]	:= Array(0)
		        	hb_threadJoin(aNR[nID][4],@aNR[nID][5])
		        	aAdd(aThreads,aNR[nID][4])
				#ELSE //__PROTHEUS__
		        	aNR[nID][4]	:= ("__ADD__"+"ThAdd__"+cThread+"__ID__"+hb_ntos(nID))
		        	PutGlbValue(aNR[nID][4],"")
		        	StartJob("U_ThAdd",__cEnvSrv,.F.,aNR[nID][2],aNR[nID][3],Len(aNR[nID][2]),nBase,aNR[nID][4])
		        	aAdd(aThreads,nID)
		        #ENDIF //__HARBOUR__

				IF z==y .or. Mod(z,5)==0
					
					#IFDEF __HARBOUR__
					
						hb_threadWaitForAll(aThreads)

					#ELSE //__PROTHEUS__

						t    := Len(aThreads)
						nIDs := t
	
						While .NOT.(lExit)
						
							lExit := lExit .or. KillApp()
							IF lExit
								EXIT
							EndIF
	
							nNR := 0

							For n := 1 To t
								
								nID := aThreads[n]
			
								IF .NOT.(aNR[nID][1])
				
									cGlbV := GetGlbValue(aNR[nID][4])
									
									IF .NOT.(cGlbV=="")
					
										aNR[nID][1] := .T.
										aNR[nID][5] := cGlbV
						
										cGlbV := NIL
				
										ClearGlbValue(aNR[nID][4])
				
										lExit := ++nNR==nIDs
				                                                                      	
										IF lExit
											EXIT
										EndIF
				
									EndIF
				
								Else
				
									lExit := ++nNR==nIDs
				
									IF lExit
										EXIT
									EndIF
							
								EndIF
				
							Next i
				
							IF lExit
								EXIT
							EndIF
	
						End While
	
					#ENDIF	//__HARBOUR__

					aSize(aThreads,0)

				EndIF

			Next x

			For x := y To 1 STEP -1
				z 	:= x-1
				cT1	:= aNR[x][5]
				IF z>0 .and. Len(cT1)>MAX_LENGHT_ADD_THREAD
					cT2 := SubStr(cT1,1,1)
					cT1	:= SubStr(cT1,2)
					IF cT2<>"0"
						w   		:= Len(aNR[z][5])
						cT2			:= Add(aNR[z][5],PadL(cT2,w,"0"),w,nBase)
						aNR[z][5]	:= IF(SubStr(cT2,1,1)=="0",SubStr(cT2,2),cT2)
					EndIF
					aNR[x][5] 		:= cT1
				EndIF
			Next x

			cNR := ""
			For x := 1 To y
				cNR += aNR[x][5]
			Next x

		END SEQUENCE
	
	Return(cNR)

	#IFDEF __PROTHEUS__
		User Function ThAdd(cN1,cN2,nSize,nBase,cID)
			PTInternal(1,"[tBigNumber][ADD][U_THADD]["+cID+"][CALC]["+cN1+"+"+cN2+"]")
				PutGlbValue(cID,Add(cN1,cN2,nSize,nBase))
			PTInternal(1,"[tBigNumber][ADD][U_THADD]["+cID+"][END]["+cN1+"+"+cN2+"]")
			tBigNGC(.T.)
		Return(.T.)
	#ELSE
		Function ThAdd(cN1,cN2,nSize,nBase)
		Return(Add(cN1,cN2,nSize,nBase))
	#ENDIF

#ENDIF

/*
	Method		: Sub
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Soma
	Sintaxe     : tBigNumber():Sub(uBigN) -> oBigNR
*/
Method Sub(uBigN) CLASS tBigNumber

	Local cInt		
	Local cDec		

	Local cN1 	
	Local cN2 	
	Local cNT 		

	Local lNeg		
	Local lInv		
	Local lSub	:= .T.

	Local n1
	Local n2

	Local nDec		
	Local nSize 	

	__sboN1:SetValue(self)
	__sboN2:SetValue(uBigN)
	
	__sboN1:Normalize(@__sboN2)

	BEGIN SEQUENCE

		IF __sboN1:nBase==10 .and. __sboN1:nSize<=14 .and. __sboN2:nSize<=14
			n1	:= Val(__sboN1:ExactValue())
			n2	:= Val(__sboN2:ExactValue())
			IF n1<=999999999.9999 .and. __sboN1:nDec<=4 .and. n2<=999999999.9999 .and. __sboN2:nDec<=4
				cNT	:= hb_ntos(n1-n2)
				__sboNR:SetValue(cNT)
				BREAK
			EndIF
		EndIF	
	
	    nDec  := __sboN1:nDec
	    nSize := __sboN1:nSize
	
	    cN1	:= __sboN1:cInt
	    cN1	+= __sboN1:cDec
	
	    cN2	:= __sboN2:cInt
	    cN2	+= __sboN2:cDec
	
	    lNeg := (__sboN1:lNeg .and. .NOT.(__sboN2:lNeg)) .or. (.NOT.(__sboN1:lNeg) .and. __sboN2:lNeg)
	
		IF lNeg
			lSub := .F.
			lNeg := __sboN1:lNeg
		Else
			lInv := cN1<cN2
			lNeg := __sboN1:lNeg .or. lInv
			IF lInv
				cNT	:= cN1
				cN1	:= cN2
				cN2	:= cNT
				cNT	:= NIL
			EndIF
		EndIF
	
	    IF lSub
			#IFDEF __SUBMT__
				__sboNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
	    	#ELSE
				__sboNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
	    	#ENDIF
	    Else
			#IFDEF __ADDMT__
		        IF nSize>MAX_LENGHT_ADD_THREAD .and. Int(nSize/MAX_LENGHT_ADD_THREAD)>=2
			        __sboNR:SetValue(AddThread(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
		        Else
		        	__sboNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
		        EndIF
	    	#ELSE
				__sboNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)    		
	    	#ENDIF
	    EndIF
	
	    cNT	 := __sboNR:cInt
	    
	    cDec := SubStr(cNT,-nDec)
	    cInt := SubStr(cNT,1,Len(cNT)-nDec)
	    
	    cNT	:= cInt
	    cNT	+= "."
	    cNT	+= cDec
		
		__sboNR:SetValue(cNT)
	
		IF lNeg
			IF __sboNR:gt(__o0)
			    __sboNR:cSig := "-"
			    __sboNR:lNeg := lNeg
			EndIF
		EndIF

	END SEQUENCE

Return(__sboNR)

/*
	Method		: Mult
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Multiplicacao 
	Sintaxe     : tBigNumber():Mult(uBigN,leMult) -> oBigNR
*/
Method Mult(uBigN,leMult) CLASS tBigNumber

	Local cInt
	Local cDec

	Local cN1
	Local cN2
	Local cNT

	Local lNeg	
	Local lNeg1 
	Local lNeg2 

	Local n1
	Local n2

	Local nDec	
	Local nSize 

	__mtoN1:SetValue(self)
	__mtoN2:SetValue(uBigN)
	
	__mtoN1:Normalize(@__mtoN2)

	BEGIN SEQUENCE

		IF __mtoN1:nBase==10 .and. __mtoN1:nSize<=9 .and. __mtoN2:nSize<=9
			n1	:= Val(__mtoN1:ExactValue())
			n2	:= Val(__mtoN2:ExactValue())
			IF n1<=2999999.90 .and. __mtoN1:nDec<=2 .and. n2<=2999999.90 .and. __mtoN2:nDec<=2
				cNT	:= hb_ntos(n1*n2)
				__mtoNR:SetValue(cNT)
				BREAK
			EndIF
		EndIF	

	    nDec  := __mtoN1:nDec*2
	    nSize := __mtoN1:nSize
	
	    lNeg1 := __mtoN1:lNeg
	    lNeg2 := __mtoN2:lNeg	
	    lNeg  := (lNeg1 .and. .NOT.(lNeg2)) .or. (.NOT.(lNeg1) .and. lNeg2)
	
	    cN1	:= __mtoN1:cInt
	    cN1	+= __mtoN1:cDec
	
	    cN2	:= __mtoN2:cInt
	    cN2	+= __mtoN2:cDec
	
	    DEFAULT leMult := .F.
	
	    IF leMult
			__mtoNR:SetValue(eMult(cN1,cN2),NIL,NIL,.F.)    		
	    Else
			__mtoNR:SetValue(Mult(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
	    EndIF	
	
	    cNT	:= __mtoNR:cInt
	    
	    cDec := SubStr(cNT,-nDec)
	    cInt := SubStr(cNT,1,Len(cNT)-nDec)
	    
	    cNT	:= cInt
	    cNT	+= "."
	    cNT	+= cDec
		
		__mtoNR:SetValue(cNT)
	    
	    cNT	:= __mtoNR:ExactValue()
		
		__mtoNR:SetValue(cNT)
	
		IF lNeg
			IF __mtoNR:gt(__o0)
			    __mtoNR:cSig := "-"
			    __mtoNR:lNeg := lNeg
			EndIF
		EndIF

	END SEQUENCE

Return(__mtoNR)

/*
	Method		: Div
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Divisao
	Sintaxe     : tBigNumber():Div(uBigN,lFloat) -> oBigNR
*/
Method Div(uBigN,lFloat) CLASS tBigNumber

	Local cDec
	
	Local cN1
	Local cN2
	Local cNR

	Local lNeg	
	Local lNeg1 
	Local lNeg2
	
	Local nAcc := __nSetDecimals
	Local nDec 
	
	BEGIN SEQUENCE

		IF __o0:eq(uBigN)
			__dvoNR:SetValue(__o0)
			BREAK
		EndIF

		__dvoN1:SetValue(self)
		__dvoN2:SetValue(uBigN)
		
		__dvoN1:Normalize(@__dvoN2)
	
	    lNeg1 := __dvoN1:lNeg
	    lNeg2 := __dvoN2:lNeg	
	    lNeg  := (lNeg1 .and. .NOT.(lNeg2)) .or. (.NOT.(lNeg1) .and. lNeg2)
	
	    cN1	:= __dvoN1:cInt
	    cN1	+= __dvoN1:cDec
	
	    cN2	:= __dvoN2:cInt
	    cN2	+= __dvoN2:cDec

		DEFAULT lFloat := .T.

		__dvoNR:SetValue(eDiv(cN1,cN2,nAcc,lFloat))
	
		__dvoRDiv:SetValue(__dvoNR:cRDiv,NIL,NIL,.F.)
	
		IF lFloat
			
			IF __dvoRDiv:gt(__o0)
	
				cDec := ""
		
				__dvoN2:SetValue(cN2)
		
				While __dvoRDiv:lt(__dvoN2)
					__dvoRDiv:cInt	+= "0"
					__dvoRDiv:nInt++
					__dvoRDiv:nSize++
					IF __dvoRDiv:lt(__dvoN2)
						cDec += "0"
					EndIF
				End While
		
				While __dvoRDiv:gte(__dvoN2)
					
					__dvoRDiv:Normalize(@__dvoN2)
			
		    		cN1	:= __dvoRDiv:cInt
		    		cN1	+= __dvoRDiv:cDec
		
		    		cN2	:= __dvoN2:cInt
		    		cN2	+= __dvoN2:cDec

					__dvoRDiv:SetValue(eDiv(cN1,cN2,nAcc,lFloat))

					cDec += __dvoRDiv:ExactValue(.T.)
					nDec := Len(cDec)
		
					__dvoRDiv:SetValue(__dvoRDiv:cRDiv,NIL,NIL,.F.)
					__dvoRDiv:SetValue(__dvoRDiv:ExactValue(.T.))

					IF __dvoRDiv:eq(__o0) .or. nDec>=nAcc
						EXIT
					EndIF
		
					__dvoN2:SetValue(cN2)		
					
					While __dvoRDiv:lt(__dvoN2)
						__dvoRDiv:cInt	+= "0"
						__dvoRDiv:nInt++
						__dvoRDiv:nSize++
						IF __dvoRDiv:lt(__dvoN2)
							cDec += "0"
						EndIF
					End While
				
				End While
		
				cNR	:= __dvoNR:ExactValue(.T.)
				cNR	+= "."
				cNR	+= SubStr(cDec,1,nAcc)
		
				__dvoNR:SetValue(cNR,NIL,__dvoRDiv:ExactValue(.T.))
	
			EndIF
	
		EndIF
	
		IF lNeg
			IF __dvoNR:gt(__o0)
			    __dvoNR:cSig	:= "-"
			    __dvoNR:lNeg	:= lNeg
			EndIF
		EndIF

	End Sequence

Return(__dvoNR)

/*
	Method		: Mod
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 05/03/2013
	Descricao   : Resto da Divisao
	Sintaxe     : tBigNumber():Mod(uBigN) -> oMod
*/
Method Mod(uBigN) CLASS tBigNumber
	Local oMod	 := tBigNumber():New(self:Div(uBigN,.F.))
    oMod:SetValue(oMod:cRDiv,NIL,NIL,.F.)
Return(oMod)

/*
	Method		: Pow
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 05/03/2013
	Descricao   : Caltulo de Potencia
	Sintaxe     : tBigNumber():Pow(uBigN) -> oBigNR
*/
Method Pow(uBigN) CLASS tBigNumber

	Local oSelf	:= self:Clone()
	
	Local cM10
	
	Local cPowB
	Local cPowA
	
	Local lPoWN
	Local lPowF
	
	Local nZS

#IFDEF __HARBOUR__
	#IFDEF __POWMT__
	Local aThreads
	Local aResults
	#ENDIF
#ENDIF		

	lPoWN	:= __pwoNP:SetValue(uBigN):lt(__o0)

	BEGIN SEQUENCE

		IF oSelf:eq(__o0) .and. __pwoNP:eq(__o0)
			__pwoNR:SetValue(__o1)
			BREAK
		EndIF

		IF oSelf:eq(__o0)
			__pwoNR:SetValue(__o0)
			BREAK
		EndIF

		IF __pwoNP:eq(__o0)
			__pwoNR:SetValue(__o1)
			BREAK
		EndIF

		__pwoNR:SetValue(oSelf)

		IF __pwoNR:eq(__o1)
			__pwoNR:SetValue(__o1)
			BREAK
		EndIF

		IF __o1:eq(__pwoNP:SetValue(__pwoNP:Abs()))
			BREAK
		EndIF

		lPowF := __pwoA:SetValue(__pwoNP:cDec):gt(__o0)
		
		IF lPowF

			cPowA	:= __pwoNP:cInt+__pwoNP:Dec(NIL,NIL,.T.)
			__pwoA:SetValue(cPowA)

			nZS := Len(__pwoNP:Dec(NIL,NIL,.T.))
			While nZS>__nstcZ0
				__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
				__nstcZ0+=__nstcZ0
			End While
			
			cM10	:= "1"
			cM10	+= SubStr(__cstcZ0,1,nZS)
			
			cPowB	:= cM10

			IF __pwoB:SetValue(cPowB):gt(__o1)
				__pwoGCD:SetValue(__pwoA:GCD(__pwoB))
				#IFDEF __HARBOUR__
					#IFDEF __POWMT__

						aThreads := Array(2)
						aResults := Array(2)
						
						aThreads[1]	:= hb_threadStart("ThPowDiv",__pwoA,__pwoGCD)
						hb_threadJoin(aThreads[1],@aResults[1])
					
						aThreads[2]	:= hb_threadStart("ThPowDiv",__pwoB,__pwoGCD)
						hb_threadJoin(aThreads[2],@aResults[2])
						
						hb_threadWaitForAll(aThreads)
						
						__pwoA:SetValue(aResults[1])
						__pwoB:SetValue(aResults[2])
						
					#ELSE
						__pwoA:SetValue(__pwoA:Div(__pwoGCD))
						__pwoB:SetValue(__pwoB:Div(__pwoGCD))
					#ENDIF
				#ELSE
					__pwoA:SetValue(__pwoA:Div(__pwoGCD))
					__pwoB:SetValue(__pwoB:Div(__pwoGCD))
				#ENDIF
			EndIF

			__pwoA:Normalize(@__pwoB)
	
			__pwoNP:SetValue(__pwoA)

		EndIF

		BEGIN SEQUENCE

			#IFDEF __POWMT__
				IF __pwoNP:gt(__o10)
					__pwoNR:SetValue(PowThread(__pwoNR,__pwoNP))
					BREAK
				EndIF
			#ENDIF	

			__pwoNT:SetValue(__o0)
			__pwoNP:SetValue(__pwoNP:Sub(__o1))
			While __pwoNT:lt(__pwoNP)
				__pwoNR:SetValue(__pwoNR:Mult(oSelf))
				__pwoNT:SetValue(__pwoNT:Add(__o1))
			End While

		END SEQUENCE
	
		IF lPowF
			__pwoNR:SetValue(__pwoNR:nthRoot(__pwoB))
		EndIF

	END SEQUENCE

	IF lPoWN
		__pwoNR:SetValue(__o1:Div(__pwoNR))	
	EndIF

Return(__pwoNR)

#IFDEF __POWMT__

	/*/
		Funcao:		PowThread
		Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data:		25/02/2013
		Descricao:	Utilizada no Metodo Pow para o Calculo da Potencia via Job
		Sintaxe:	PowThread(oN1,oN2)
	/*/
	Static Function PowThread(oN1,oN2)
	
		Local aNR
	
		Local oNR		:= tBigNumber():New()
	
		Local oNO		:= __o1:Clone()
	
		Local oN5		:= __o5:Clone()
		Local oM10		:= __o10:Clone()

		Local oQ10		:= tBigNumber():New()
		Local oQTh		:= tBigNumber():New()

		Local oCN1		:= tBigNumber():New(oN1)
		Local oCN2		:= tBigNumber():New(oN2)

	#IFDEF __HARBOUR__
		Local aThreads
		Local aResults
	#ELSE //__PROTHEUS__
		Local cGlbV
		Local cThread	:= hb_ntos(ThreadID())
	#ENDIF	
	
		Local lM10		:= .F.
		Local lExit		:= .F.
		
	#IFDEF __PROTHEUS__
		Local nNR
	#ENDIF
		Local nID
		Local nIDs
	
		BEGIN SEQUENCE
	
			IF oCN2:lt(oM10)
				oNR:SetValue(oN1:Pow(oN2))
				BREAK
			EndIF
	        
			lM10		:= oCN2:eq(oM10)
			
			IF .NOT.(lM10)
				lM10	:= oCN2:Mod(oM10):eq(__o0)
			EndIF	
	
			oQ10:SetValue(oCN2:Div(oM10):Int(.T.))
			oCN2:SetValue(oCN2:Sub(oQ10:Mult(oM10)))

			oNR:SetValue(oCN1)
	
			aNR	:= Array(0)

			While oQ10:gt(__o0)
	
				oQTh:SetValue(oN5:Min(oQ10))
				oQ10:SetValue(oQ10:Sub(oQTh))
	
				#IFDEF __PROTHEUS__
					lExit	:= lExit .or. KillApp()
					IF lExit
						EXIT
					EndIF
				#ENDIF	
	
				While oQTh:gt(__o0)
					
					oQTh:SetValue(oQTh:Sub(oNO))
	
					aAdd(aNR,Array(5))

					nID	:= Len(aNR)
	
					aNR[nID][4]	:= .F.

		        	#IFDEF __HARBOUR__
			        	aNR[nID][1]	:= oCN1
		        		aNR[nID][2]	:= oM10
					#ELSE //__PROTHEUS__
			        	aNR[nID][1]	:= oCN1:GetValue()
		        		aNR[nID][2]	:= oM10:GetValue()
			        	aNR[nID][3]	:= ("__POW__"+"ThreadID__"+cThread+"__ID__"+hb_ntos(nID))
			        	PutGlbValue(aNR[nID][3],"")
			        	StartJob("U_POWJOB",__cEnvSrv,.F.,aNR[nID][1],aNR[nID][2],aNR[nID][3],__nSetDecimals,__nthRootAcc)
			        #ENDIF //__HARBOUR__

				End While
	
				nIDs := nID

				#IFDEF __HARBOUR__

					aThreads := Array(nIDs)
				    aResults := Array(nIDs)
      				For nID := 1 To nIDs
         				aThreads[nID] := hb_threadStart("PowJob",aNR[nID][1],aNR[nID][2],__nSetDecimals,__nthRootAcc)
						hb_threadJoin(aThreads[nID],@aResults[nID])
      				Next nID
					
					hb_threadWaitForAll(aThreads)
      				
      				For nID := 1 To nIDs
						aNR[nID][4]	:= .T.
						aNR[nID][5]	:= aResults[nID]
      				Next nID

				#ELSE //__PROTHEUS__

					While .NOT.(lExit)
					
						lExit	:= lExit .or. KillApp()
						IF lExit
							EXIT
						EndIF

						nNR		:= 0
		
						For nID := 1 To nIDs
		
							IF .NOT.(aNR[nID][4])
			
								cGlbV	:= GetGlbValue(aNR[nID][3])
								
								IF .NOT.(cGlbV=="")
				
									aNR[nID][4]	:= .T.
									aNR[nID][5]	:= cGlbV
			
									cGlbV	:= NIL
			
									ClearGlbValue(aNR[nID][3])
			
									lExit	:= ++nNR==nIDs
			                                                                      	
									IF lExit
										EXIT
									EndIF
			
								EndIF
			
							Else
			
								lExit := ++nNR==nIDs
			
								IF lExit
									EXIT
								EndIF
						
							EndIF
			
						Next nID	
			
						IF lExit
							EXIT
						EndIF

					End While

				#ENDIF	//__HARBOUR__
	
				For nID := 1 To nIDs
					oNR:SetValue(oNR:Mult(aNR[nID][5]))
				Next nID
				
				aSize(aNR,0)
	
			End While
	
			aNR		:= NIL

			IF lM10
				oNR:SetValue(oNR:Div(oCN1))
				BREAK
			EndIF

			While oCN2:gt(oNO)
				oCN2:SetValue(oCN2:Sub(oNO))
				oNR:SetValue(oNR:Mult(oCN1))
			End While

		END SEQUENCE
	
	Return(oNR)

	#IFDEF __HARBOUR__

		/*/
			Funcao:		PowJob
			Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data:		25/02/2013
			Descricao:	Utilizada no Metodo Pow para o Calculo da Potencia via Job
			Sintaxe:	hb_threadStart("PowJob",oN1,oN2,nSetDecimals,nthRootAcc)
		/*/
		Function PowJob(oN1,oN2,nSetDecimals,nthRootAcc)
		
			Local oTh1	:= tBigNumber():New(oN1)
			Local oTh2	:= tBigNumber():New(oN2)
			Local oThR	:= tBigNumber():New()

			__nthRootAcc	:= nthRootAcc
			__nSetDecimals	:= nSetDecimals

			oThR:SetValue(oTh1:Pow(oTh2))

		Return(oThR)

		Function ThPowDiv(oX,oY)
			Local oThX	:= tBigNumber():New(oX)
			Local oThY	:= tBigNumber():New(oY)
		Return(oThX:Div(oThY))
	
	#ELSE //__PROTHEUS__

		/*/
			Funcao:		U_PowJob
			Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data:		25/02/2013
			Descricao:	Utilizada no Metodo Pow para o Calculo da Potencia via Job
			Sintaxe:	StartJob("U_POWJOB",cEnvironment,lWaitRun,cN1,cN2,cID,nSetDecimals,nthRootAcc)
		/*/
		User Function PowJob(cN1,cN2,cID,nSetDecimals,nthRootAcc)
		
			Local cNR
		
			Local oN1	:= tBigNumber():New(cN1)
			Local oN2	:= tbigNumber():New(cN2)
		
			__nthRootAcc	:= nthRootAcc
			__nSetDecimals	:= nSetDecimals
		
			PTInternal(1,"[tBigNumber][POW][U_POWJOB]["+cID+"][CALC]["+cN1+" ^ "+cN2+"]")
				cNR := oN1:Pow(oN2):GetValue()
				PutGlbValue(cID,cNR)	
			PTInternal(1,"[tBigNumber][POW][U_POWJOB]["+cID+"][RESULT]["+cNR+"]")
			
			tBigNGC(.T.)

		Return(.T.)

	#ENDIF //__HARBOUR__

#ENDIF	//__POWMT__

/*
	Method		: e
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 06/02/2013
	Descricao   : Retorna o Numero de Neper (2.718281828459045235360287471352662497757247...)
	Sintaxe     : tBigNumber():e(lForce) -> oeTthD
	(((n+1)^(n+1))/(n^n))-((n^n)/((n-1)^(n-1)))
*/
Method e(lForce) CLASS tBigNumber

	Local oeTthD

	Local oPowN
	Local oDiv1P
	Local oDiv1S
	Local oBigNC
	Local oAdd1N
	Local oSub1N
	Local oPoWNAd
	Local oPoWNS1

	BEGIN SEQUENCE
		
		DEFAULT lForce	:= .F.

		IF .NOT.(lForce)

			oeTthD	:= tBigNumber():New()
			oeTthD:SetValue(__eTthD())

			BREAK

		EndIF

		oBigNC	:= self:Clone()
		
		IF oBigNC:eq(__o0)
			oBigNC:SetValue(__o1)
		EndIF

		oPowN   := oBigNC:Clone()
		
		oPowN:SetValue(oPowN:Pow(oPowN))
		
		oAdd1N	:= oBigNC:Add(__o1)
		oSub1N	:= oBigNC:Sub(__o1)

		oPoWNAd	:= oAdd1N:Pow(oAdd1N)
		oPoWNS1	:= oSub1N:Pow(oSub1N)
        
		oDiv1P	:= oPoWNAd:Div(oPowN)
		oDiv1S	:= oPowN:Div(oPoWNS1)

		oeTthD:SetValue(oDiv1P:Sub(oDiv1S))

	END SEQUENCE

Return(oeTthD)

/*
	Method:		Exp
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/02/2013
	Descricao:	Potencia do Numero de Neper e^cN
	Sintaxe:	tBigNumber():Exp(lForce) -> oBigNR
*/
Method Exp(lForce) CLASS tBigNumber
	Local oBigNe := self:e(lForce)
	Local oBigNR := oBigNe:Pow(self)
Return(oBigNR)

/*
	Method:		PI
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		04/02/2013
	Descricao:	Retorna o Numero Irracional PI (3.1415926535897932384626433832795...)
	Sintaxe:	tBigNumber():PI(lForce) -> oPITthD
*/
Method PI(lForce) CLASS tBigNumber
	
	Local oPITthD

	DEFAULT lForce	:= .F.

	BEGIN SEQUENCE

		lForce := .F.	//TODO: Implementar o calculo.

		IF .NOT.(lForce)

			oPITthD	:= tBigNumber():New()
			oPITthD:SetValue(__PITthD())

			BREAK

		EndIF

		//TODO: Implementar o calculo,Depende de Pow com Expoente Fracionario

	END SEQUENCE

Return(oPITthD)

/*
	Method:		GCD
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		23/02/2013
	Descricao:	Retorna o GCD/MDC
	Sintaxe:	tBigNumber():GCD(uBigN) -> oGCD
*/
Method GCD(uBigN) CLASS tBigNumber

 	Local oNX	:= tBigNumber():New(uBigN)
 	Local oNT	:= tBigNumber():New()
 	Local oGCD	:= self:Clone()

 	oNT:SetValue(oGCD:Max(oNX))
 	oNX:SetValue(oGCD:Min(oNX))
 	oGCD:SetValue(oNT)

	oGCD:SetValue(oGCD:Mod(oNX))
	
	oNT:SetValue(oGCD)
	oGCD:SetValue(oNX)
	
	oNX:SetValue(oNT)

	While oNX:ne(__o0)
		oGCD:SetValue(oGCD:Mod(oNX))
		oNT:SetValue(oGCD)
		oGCD:SetValue(oNX)
		oNX:SetValue(oNT)
	End While

Return(oGCD)

/*
	Method:		LCM
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		23/02/2013
	Descricao:	Retorna o LCM/MMC
	Sintaxe:	tBigNumber():LCM(uBigN) -> oLCM
*/
Method LCM(uBigN) CLASS tBigNumber
	
	Local oN1	:= self:Clone()
	Local oN2	:= tBigNumber():New(uBigN)

	Local oNI	:= __o2:Clone()
	
	Local oLCM	:= __o1:Clone()

	BEGIN SEQUENCE

		While .T.
			While oN1:Mod(oNI):eq(__o0) .or. oN2:Mod(oNI):eq(__o0)
				oLCM:SetValue(oLCM:Mult(oNI))
				IF oN1:Mod(oNI):eq(__o0)
					oN1:SetValue(oN1:Div(oNI,.F.))
				EndIF
				IF oN2:Mod(oNI):eq(__o0)
					oN2:SetValue(oN2:Div(oNI,.F.))
				EndIF
			End While
			IF oN1:eq(__o1) .and. oN2:eq(__o1)
				BREAK
			EndIF
			oNI:SetValue(oNI:Add(__o1))		
		End While

	END SEQUENCE

Return(oLCM)

/*

	Method:		nthRoot
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		05/03/2013
	Descricao:	Radiciação 
	Sintaxe:	tBigNumber():nthRoot(uBigN) -> othRoot
*/
Method nthRoot(uBigN) CLASS tBigNumber

	Local aIPF
	Local aDPF

	Local cFExit

#IFNDEF __ROOTMT__
	Local nPF
#ENDIF

	Local nZS
	Local nPFs

	Local oRootB
	Local oRootD
	Local othRoot

#IFNDEF __ROOTMT__
	Local oRootT
	Local othRootD
#ELSE
	#IFDEF __HARBOUR__
	Local aThreads
	Local aResults
	#ENDIF
#ENDIF

	Local oRootE
	Local oFExit

	othRoot	:= tBigNumber():New()

	BEGIN SEQUENCE

		oRootB := self:Clone()

		IF oRootB:eq(__o0)
			BREAK
		EndIF

		IF oRootB:lNeg
			BREAK
		EndIF

		IF oRootB:eq(__o1)
			othRoot:SetValue(__o1)
			BREAK
		EndIF

		oRootE := tBigNumber():New(uBigN)

		IF oRootE:eq(__o0)
			BREAK
		EndIF

		IF oRootE:eq(__o1)
			othRoot:SetValue(oRootB)
			BREAK
		EndIF

		nZS := __nthRootAcc-1
		While nZS>__nstcZ0
			__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
			__nstcZ0+=__nstcZ0
		End While
	
		cFExit := "0."+SubStr(__cstcZ0,1,nZS)+"1"
			
		oFExit := tBigNumber():New()
		oFExit:SetValue(cFExit,NIL,NIL,NIL,__nthRootAcc)

		IF oRootB:Dec(.T.):gt(__o0)
			
			nZS := Len(oRootB:Dec(NIL,NIL,.T.))
			While nZS>__nstcZ0
				__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
				__nstcZ0+=__nstcZ0
			End While
			oRootD	:= tBigNumber():New("1"+SubStr(__cstcZ0,1,nZS))
			oRootB:SetValue(oRootB:cInt+oRootB:cDec)
			
			#IFDEF __HARBOUR__
			
				#IFDEF __ROOTMT__
					
					aThreads := Array(2)
					aResults := Array(2)
					
					aThreads[1]	:= hb_threadStart("ThPFactors",oRootB)
					hb_threadJoin(aThreads[1],@aResults[1])
			
					aThreads[2]	:= hb_threadStart("ThPFactors",oRootD)
					hb_threadJoin(aThreads[2],@aResults[2])
					
					hb_threadWaitForAll(aThreads)
					
					aIPF := aResults[1]
					aDPF := aResults[2]
				
				#ELSE
				
					aIPF := oRootB:PFactors()
					aDPF := oRootD:PFactors()
				
				#ENDIF //__ROOTMT__
			
			#ELSE //__PROTHEUS__
			
				aIPF := oRootB:PFactors()
				aDPF := oRootD:PFactors()
			
			#ENDIF	//__HARBOUR__
		
		Else
		
			aIPF := oRootB:PFactors()
			aDPF := Array(0)
		
		EndIF

		nPFs := Len(aIPF)

		IF nPFs>0
			#IFDEF __ROOTMT__
				othRoot:SetValue(RootThread(aIPF,aDPF,oRootE,oFExit))
			#ELSE
				othRoot:SetValue(__o1)
				othRootD := tBigNumber():New()
				oRootT   := tBigNumber():New()
				For nPF := 1 To nPFs
					IF oRootE:eq(aIPF[nPF][2])
						othRoot:SetValue(othRoot:Mult(aIPF[nPF][1]))
					Else
						oRootT:SetValue(aIPF[nPF][1])
						oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
						oRootT:SetValue(oRootT:Pow(aIPF[nPF][2]))
						othRoot:SetValue(othRoot:Mult(oRootT))
					EndIF	
				Next nPF
				IF .NOT.(Empty(aDPF))
					nPFs := Len(aDPF)
					IF nPFs>0
						othRootD:SetValue(__o1)
						For nPF := 1 To nPFs
							IF oRootE:eq(aDPF[nPF][2])
								othRootD:SetValue(othRootD:Mult(aDPF[nPF][1]))
							Else
								oRootT:SetValue(aDPF[nPF][1])
								oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
								oRootT:SetValue(oRootT:Pow(aDPF[nPF][2]))
								othRootD:SetValue(othRootD:Mult(oRootT))
							EndIF
						Next nPF
						IF othRootD:gt(__o0)
							othRoot:SetValue(othRoot:Div(othRootD))	
						EndIF
					EndIF	
				EndIF
			#ENDIF //__ROOTMT__
			BREAK
		EndIF

		othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

	END SEQUENCE

Return(othRoot)

#IFDEF __ROOTMT__

	/*/
		Funcao:		RootThread
		Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data:		20/03/2013
		Descricao:	Utilizada no Metodo nthRoot para o Calculo da Raiz via Job
		Sintaxe:	RootThread(aIPF,aDPF,oRootE,oAccTo)
	/*/
	Static Function RootThread(aIPF,aDPF,oRootE,oAccTo)

	Local aNR

	Local nID
	Local nIDs

	Local nIPF
	Local nIPFs := Len(aIPF)

	Local nDPF
	Local nDPFs := Len(aDPF)
	
	Local othRoot
	
	Local othTRoot
	Local othIRoot
	Local othDRoot

	#IFDEF __HARBOUR__

		Local aThreads
		Local aResults

	#ELSE //__PROTHEUS__

		Local cGlbV
		Local cFExit  := oAccTo:GetValue()
		Local cRootE  := oRootE:GetValue()	
		Local cThread := hb_ntos(ThreadID())
		
		Local nNR
		Local lExit   := .F.

	#ENDIF	//__HARBOUR__

		nIDs := (nIPFs+nDPFs)
		aNR  := Array(nIDs,6)
		nID  := 0

		For nIPF := 1 To nIPFs
            ++nID
        	aNR[nID][1]	:= aIPF[nIPF][1]
        	aNR[nID][2]	:= "I"
	        #IFDEF __HARBOUR__
				aNR[nID][3]	:= nID
			#ELSE //__PROTHEUS__
		        aNR[nID][3]	:= ("__ROOT__I__"+"ThreadID__"+cThread+"__ID__"+hb_ntos(nID))
	        #ENDIF //__HARBOUR__
			IF oRootE:eq(aIPF[nIPF][2])
				aNR[nID][4] := .T.
				aNR[nID][5] := aIPF[nIPF][1]
				aNR[nID][6] := "1"
			Else
				aNR[nID][4] := .F.
				aNR[nID][6] := aIPF[nIPF][2]
			EndIF
		Next nIPF

		For nDPF := 1 To nDPFs
            ++nID
        	aNR[nID][1]	:= aDPF[nDPF][1]
        	aNR[nID][2]	:= "D"
	        #IFDEF __HARBOUR__
				aNR[nID][3]	:= nID
			#ELSE //__PROTHEUS__
		        aNR[nID][3]	:= ("__ROOT__D__"+"ThreadID__"+cThread+"__ID__"+hb_ntos(nID))
	        #ENDIF //__HARBOUR__
			IF oRootE:eq(aDPF[nDPF][2])
				aNR[nID][4] := .T.
				aNR[nID][5] := aDPF[nDPF][1]
				aNR[nID][6] := "1"
			Else
				aNR[nID][4] := .F.
				aNR[nID][6] := aDPF[nDPF][2]
			EndIF	
		Next nDPF

		#IFDEF __HARBOUR__
			aThreads := Array(nIDs)
			aResults := Array(nIDs)
		#ENDIF

		For nID := 1 To nIDs
			IF aNR[nID][4]
				LOOP
			EndIF
			#IFDEF __HARBOUR__
				aThreads[nID] := hb_threadStart("RootJob",aNR[nID][1],oRootE,oAccTo,__nSetDecimals,__nthRootAcc)
				hb_threadJoin(aThreads[nID],@aResults[nID])
			#ELSE	//__PROTHEUS__
				StartJob("U_RootJob",__cEnvSrv,.F.,aNR[nID][1],cRootE,cFExit,__nSetDecimals,__nthRootAcc,aNR[nID][3])
			#ENDIF
		Next nID

		#IFDEF __HARBOUR__

			hb_threadWaitForAll(aThreads)
      				
      		For nID := 1 To nIDs
				IF aNR[nID][4]
					LOOP
				EndIF
				aNR[nID][4]	:= .T.
				aNR[nID][5]	:= aResults[nID]
			Next nID

		#ELSE	//__PROTHEUS__

			While .NOT.(lExit)

				lExit := lExit .or. KillApp()
				IF lExit
					EXIT
				EndIF

				nNR := 0

				For nID := 1 To nIDs

					IF .NOT.(aNR[nID][4])

						cGlbV := GetGlbValue(aNR[nID][3])

						IF .NOT.(cGlbV=="")

							aNR[nID][4]	:= .T.
							aNR[nID][5]	:= cGlbV

							cGlbV := NIL
	
							ClearGlbValue(aNR[nID][3])
	
							lExit := ++nNR==nIDs
	                                                                      	
							IF lExit
								EXIT
							EndIF

						EndIF

					Else

						lExit := ++nNR==nIDs
	
						IF lExit
							EXIT
						EndIF
				
					EndIF
	
				Next nID	
	
				IF lExit
					EXIT
				EndIF

			End While

		#ENDIF

		othTRoot := tBigNumber():New()
		othIRoot := __o1:Clone()
		othDRoot := __o1:Clone()

		For nID := 1 To nIDs
			othTRoot:SetValue(aNR[nID][5])
			IF aNR[nID][2]=="I"
				othIRoot:SetValue(othIRoot:Mult(othTRoot:Pow(aNR[nID][6])))
			Else
				othDRoot:SetValue(othDRoot:Mult(othTRoot:Pow(aNR[nID][6])))
			EndIF	
		Next nID	

		othRoot := othIRoot:Div(othDRoot):Clone()

	Return(othRoot)

	#IFDEF __HARBOUR__

		/*/
			Funcao:		RootJob
			Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data:		20/03/2013
			Descricao:	Utilizada no Metodo nthroot para o Calculo da Raiz via Job
			Sintaxe:	hb_threadStart("RootJob",cRootB,oRootE,oFExit,nSetDecimals,nthRootAcc)
		/*/
		Function RootJob(cRootB,oRootE,oFExit,nSetDecimals,nthRootAcc)

			Local oThB		:= tBigNumber():New(cRootB)
			Local oThE		:= tBigNumber():New(oRootE)
			Local oThExit	:= tBigNumber():New(oFExit)
		
			Local oThR		:= tBigNumber():New()
		
			__nthRootAcc	:= nthRootAcc
			__nSetDecimals	:= nSetDecimals
			
			oThR:SetValue(nthRoot(oThB,oThE,oThExit,nSetDecimals))

		Return(oThR)

		Function ThPFactors(oNR)
			Local oThR := tBigNumber():New(oNR)
		Return(oThR:PFactors())

	#ELSE //__PROTHEUS__

		/*/
			Funcao:		U_RootJob
			Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data:		20/03/2013
			Descricao:	Utilizada no Metodo nthroot para o Calculo da Raiz via Job
			Sintaxe:	StartJob("U_RootJob",cEnvironment,lWaitRun,cRootB,cRootE,cFExit,nSetDecimals,nthRootAcc,cID)
		/*/
		User Function RootJob(cRootB,cRootE,cFExit,nSetDecimals,nthRootAcc,cID)

			Local cNR
		
			Local oTh_B   := tBigNumber():New(cRootB)
			Local oTh_E   := tbigNumber():New(cRootE)
			Local oThExit := tbigNumber():New(cFExit)

			__nthRootAcc   := nthRootAcc
			__nSetDecimals := nSetDecimals

			PTInternal(1,"[tBigNumber][POW][U_ROOTJOB]["+cID+"][CALC][nthRoot("+cRootB+","+cRootE+")]")
				cNR := nthRoot(oTh_B,oTh_E,oThExit,nSetDecimals):GetValue()
				PutGlbValue(cID,cNR)
			PTInternal(1,"[tBigNumber][POW][U_ROOTJOB]["+cID+"][RESULT]["+cNR+"]")

			tBigNGC(.T.)

		Return(.T.)	

	#ENDIF //__HARBOUR__

#ENDIF	//__ROOTMT__

/*
	Method:		SQRT
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/03/2013
	Descricao:	Retorna a Raiz Quadrada (radix quadratum -> O Lado do Quadrado) do Numero passado como parametro
	Sintaxe:	tBigNumber():SQRT() -> oSQRT
*/
Method SQRT() CLASS tBigNumber

	Local oSQRT := self:Clone()	
	
	BEGIN SEQUENCE

		IF oSQRT:lte(oSQRT:SysSQRT())
			oSQRT:SetValue(__SQRT(hb_ntos(Val(oSQRT:GetValue()))))
			BREAK
		EndIF

		IF oSQRT:eq(__o0)
			oSQRT:SetValue(__o0)
			BREAK
		EndIF

		oSQRT:SetValue(__SQRT(oSQRT))

	END SEQUENCE

Return(oSQRT)

/*
	Method:		SysSQRT
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/03/2013
	Descricao:	Define o valor maximo para calculo da SQRT considerando a funcao padrao
	Sintaxe:	tBigNumber():SysSQRT(uSet) -> oSysSQRT
*/
Method SysSQRT(uSet) CLASS tBigNumber

	Local cType
	
	cType := ValType(uSet)
	IF ( cType $ "C|N|O" )
		__oSysSQRT:SetValue(IF(cType$"C|O",uSet,IF(cType=="N",hb_ntos(uSet),"0")))
		IF __oSysSQRT:gt(MAX_SYS_SQRT)
			__oSysSQRT:SetValue(MAX_SYS_SQRT)
		EndIF
	EndIF
	
Return(__oSysSQRT)

/*
	Method		: Log
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o logaritmo na Base N DEFAULT 10
	Sintaxe     : tBigNumber():Log(Log(uBigNB) -> oBigNR
	Referencia	: //http://www.vivaolinux.com.br/script/Calculo-de-logaritmo-de-um-numero-por-um-terceiro-metodo-em-C
*/
Method Log(uBigNB) CLASS tBigNumber

	Local oS  := tBigNumber():New()
	Local oT  := tBigNumber():New()
	Local oI  := __o1:Clone()
	Local oX  := self:Clone()
	Local oY  := tBigNumber():New()
	Local oLT := tBigNumber():New()

	Local lflag := .F.

	DEFAULT uBigNB := self:e()

	oT:SetValue(uBigNB)

	IF __o0:lt(oT) .and. oT:lt(__o1)
	 	lflag := .NOT.(lflag)
	 	oT:SetValue(__o1:Div(oT))
	EndIF

	While oX:gt(oT) .and. oT:gt(__o1)
		oY:SetValue(oY:Add(oI))
		oX:SetValue(oX:Div(oT))
	End While 

	oS:SetValue(oS:Add(oY))
	oY:SetValue(__o0)
*	oT:SetValue(oT:Sqrt())
	oT:SetValue(__SQRT(oT))
	oI:SetValue(oI:Div(__o2))
    
	While oT:gt(__o1)

		While oX:gt(oT) .and. oT:gt(__o1)
			oY:SetValue(oY:Add(oI))
			oX:SetValue(oX:Div(oT))
		End While 
	
		oS:SetValue(oS:Add(oY))
		oY:SetValue(__o0)
		oLT:SetValue(oT)
*		oT:SetValue(oT:Sqrt())
		oT:SetValue(__SQRT(oT))
		IF oT:eq(oLT)
        	oT:SetValue(__o0)	
		EndIF 
		oI:SetValue(oI:Div(__o2))

	End While

	IF lflag
		oS:SetValue(oS:Mult("-1"))
	EndIF	

Return(oS)

/*
	Method		: Log2
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o logaritmo Base 2
	Sintaxe     : tBigNumber():Log2() -> oBigNR
*/
Method Log2() CLASS tBigNumber
	Local ob2 := __o2:Clone()
Return(self:Log(ob2))

/*
	Method		: Log10
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o logaritmo Base 10
	Sintaxe     : tBigNumber():Log10() -> oBigNR
*/
Method Log10() CLASS tBigNumber
	Local ob10 := __o10:Clone()
Return(self:Log(ob10))

/*
	Method		: Ln
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Logaritmo Natural
	Sintaxe     : tBigNumber():Ln() -> oBigNR
*/
Method Ln() CLASS tBigNumber
Return(self:Log(__o1:Exp()))

/*
	Method		: aLog
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o Antilogaritmo 
	Sintaxe     : tBigNumber():aLog(Log(uBigNB) -> oBigNR
*/
Method aLog(uBigNB) CLASS tBigNumber
	Local oaLog  := tBigNumber():New(uBigNB)
Return(oaLog:Pow(self))

/*
	Method		: aLog2
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o Antilogaritmo Base 2
	Sintaxe     : tBigNumber():aLog2() -> oBigNR
*/
Method aLog2() CLASS tBigNumber
	Local ob2 := __o2:Clone()
Return(self:aLog(ob2))

/*
	Method		: aLog10
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o Antilogaritmo Base 10
	Sintaxe     : tBigNumber():aLog10() -> oBigNR
*/
Method aLog10() CLASS tBigNumber
	Local ob10 := __o10:Clone()
Return(self:aLog(ob10))

/*
	Method		: aLn
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 20/02/2013
	Descricao   : Retorna o AntiLogaritmo Natural
	Sintaxe     : tBigNumber():aLn() -> oBigNR
*/
Method aLn() CLASS tBigNumber
Return(self:aLog(__o1:Exp()))

/*
	Method:		MathC
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		05/03/2013
	Descricao:	Operacoes Matematicas
	Sintaxe:	tBigNumber():MathC(uBigN1,cOperator,uBigN2) -> cNR
*/
Method MathC(uBigN1,cOperator,uBigN2) CLASS tBigNumber
Return(MathO(uBigN1,cOperator,uBigN2,.F.))

/*
	Method		: MathN
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Operacoes Matematicas
	Sintaxe     : tBigNumber():MathN(uBigN1,cOperator,uBigN2) -> oBigNR
*/
Method MathN(uBigN1,cOperator,uBigN2) CLASS tBigNumber
Return(MathO(uBigN1,cOperator,uBigN2,.T.))

/*
	Method		: Rnd
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 06/02/2013
	Descricao   : Redefine a Precisao de Numero em PF
	Sintaxe     : tBigNumber():Rnd(nAcc) -> oRND
*/
Method Rnd(nAcc) CLASS tBigNumber

	Local oRnd := self:Clone()
	Local oDec := tBigNumber():New(oRnd:cDec)

	Local cAdd
	Local oAcc

	DEFAULT nAcc := Min(oRnd:nDec,__nSetDecimals)

	IF .NOT.(oDec:eq(__o0))
		oAcc := tBigNumber():New(SubStr(oDec:ExactValue(),nAcc+1,1))
		IF oAcc:gte(__o5)
			oDec:SetValue(__o10)
			cAdd := "0."
			While nAcc>__nstcZ0
				__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
				__nstcZ0+=__nstcZ0
			End While
			cAdd += SubStr(__cstcZ0,1,nAcc)
			cAdd += oDec:Sub(oAcc):cInt
		Else
			oAcc := tBigNumber():New(SubStr(oDec:ExactValue(),nAcc,1))
			IF oAcc:gte(__o5)
				oDec:SetValue(__o10)
				cAdd := "0."
				While nAcc>__nstcZ0
					__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
					__nstcZ0+=__nstcZ0
				End While
				cAdd += SubStr(__cstcZ0,1,nAcc-1)
				cAdd += oDec:Sub(oAcc):cInt
			Else
				cAdd := "0"
			EndIF	
		EndIF
		IF .NOT.(cAdd=="0")
			oRnd:SetValue(oRnd:Add(cAdd))
		EndIF
		oRnd:SetValue(oRnd:cInt+"."+SubStr(oRnd:cDec,1,nAcc),NIL,oRnd:cRDiv)
	EndIF

Return(oRnd)

/*
	Method		: NoRnd
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 06/02/2013
	Descricao   : Redefine a Precisao de Numero em PF
	Sintaxe     : tBigNumber():NoRnd(nAcc) -> oBigNR
*/
Method NoRnd(nAcc) CLASS tBigNumber
Return(Self:Truncate(nAcc))

/*
	Method		: Truncate
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 06/02/2013
	Descricao   : Redefine a Precisao de Numero em PF
	Sintaxe     : tBigNumber():Truncate(nAcc) -> oTrc
*/
Method Truncate(nAcc) CLASS tBigNumber

	Local oTrc	:= self:Clone()
	Local oDec	:= tBigNumber():New(oTrc:cDec)

	DEFAULT nAcc := Min(oTrc:nDec,__nSetDecimals)

	IF .NOT.(oDec:eq(__o0))
		oDec:SetValue(SubStr(oDec:ExactValue(),1,nAcc))
		oTrc:SetValue(oTrc:cInt+"."+oDec:cInt)
	EndIF

Return(oTrc)

/*
	Method		: Normalize
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Normaliza os Dados
	Sintaxe     : tBigNumber():Normalize(oBigN) -> self
*/
Method Normalize(oBigN) CLASS tBigNumber

	Local cInt
	Local cDec

	Local nPadL	:= Max(self:nInt,oBigN:nInt)
	Local nPadR := Max(self:nDec,oBigN:nDec)
	Local nSize := (nPadL+nPadR)

    cInt := PadL(self:cInt,nPadL,"0")
    cDec := PadR(self:cDec,nPadR,"0")

	self:cInt	:= cInt
	self:nInt	:= nPadL
	self:cDec	:= cDec
	self:nDec	:= nPadR
	self:nSize	:= nSize

    cInt := PadL(oBigN:cInt,nPadL,"0")
    cDec := PadR(oBigN:cDec,nPadR,"0")

	oBigN:cInt	:= cInt
	oBigN:nInt	:= nPadL
	oBigN:cDec	:= cDec
	oBigN:nDec	:= nPadR
	oBigN:nSize	:= nSize

Return(self)

/*
	Method		: D2H
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 07/02/2013
	Descricao   : Converte Decimal para Hexa
	Sintaxe     : tBigNumber():D2H(cHexB) -> cHexN
*/
Method D2H(cHexB) CLASS tBigNumber

	Local otH	:= tBigNumber():New()
	Local otN	:= tBigNumber():New(self:cInt)

	Local cHexN	:= ""
	Local cHexC	:= "0123456789ABCDEFGHIJKLMNOPQRSTUV"

	Local cInt
	Local cDec
	Local cSig	:= self:cSig

	Local oHexN

	Local nAT
	
	DEFAULT cHexB	:= "16"

	otH:SetValue(cHexB)
	
	While otN:gt(__o0)
		otN:SetValue(otN:Div(otH,.F.))
		nAT   := Val(otN:cRDiv)+1
		cHexN := SubStr(cHexC,nAT,1)+cHexN
	End While

	IF cHexN==""
		cHexN := "0"		
	EndIF

	cInt := cHexN

	cHexN := ""
	otN   := tBigNumber():New(self:Dec(NIL,NIL,.T.))

	While otN:gt(__o0)
		otN:SetValue(otN:Div(otH,.F.))
		nAT   := Val(otN:cRDiv)+1
		cHexN := SubStr(cHexC,nAT,1)+cHexN
	End While

	IF cHexN==""
		cHexN := "0"		
	EndIF

	cDec  := cHexN

	oHexN := tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

Return(oHexN)

/*
	Method		: H2D
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 07/02/2013
	Descricao   : Converte Hexa para Decimal
	Sintaxe     : tBigNumber():H2D() -> otNR
*/
Method H2D() CLASS tBigNumber

	Local otH  := tBigNumber():New()
	Local otNR := tBigNumber():New()
	Local otLN := tBigNumber():New()
	Local otPw := tBigNumber():New()
	Local otNI := tBigNumber():New()
	Local otAT := tBigNumber():New()

	Local cHexB := hb_ntos(self:nBase)
	Local cHexC := "0123456789ABCDEFGHIJKLMNOPQRSTUV"
	Local cHexN := self:cInt
	
	Local cInt
	Local cDec
	Local cSig := self:cSig

	Local nLn  := Len(cHexN)
	Local nI   := nLn

	otH:SetValue(cHexB)
	otLN:SetValue(hb_ntos(nLn))

	While nI>0
		otNI:SetValue(hb_ntos(--nI))
	    otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1))) 
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:Sub(__o1))
		otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    End While

	cInt  := otNR:cInt

	cHexN := self:cDec
	nLn   := Len(cHexN)
	nI    := nLn

	otLN:SetValue(hb_ntos(nLn))

	While nI>0
		otNI:SetValue(hb_ntos(--nI))
	    otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1)))
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:Sub(__o1))
		otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    End While

	cDec := otNR:cDec

	otNR:SetValue(cSig+cInt+"."+cDec)

Return(otNR)

/*
	Method		: H2B
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 07/02/2013
	Descricao   : Converte Hex para Bin
	Sintaxe     : tBigNumber():H2B(cHexN) -> cBin
*/
Method H2B() CLASS tBigNumber

	Local aH2B	:= {;
							{"0","00000"},;
							{"1","00001"},;
							{"2","00010"},;
							{"3","00011"},;
							{"4","00100"},;
							{"5","00101"},;
							{"6","00110"},;
							{"7","00111"},;
							{"8","01000"},;
							{"9","01001"},;
							{"A","01010"},;
							{"B","01011"},;
							{"C","01100"},;
							{"D","01101"},;
							{"E","01110"},;
							{"F","01111"},;
							{"G","10000"},;
							{"H","10001"},;
							{"I","10010"},;
							{"J","10011"},;
							{"K","10100"},;
							{"L","10101"},;
							{"M","10110"},;
							{"N","10111"},;
							{"O","11000"},;
							{"P","11001"},;
							{"Q","11010"},;
							{"R","11011"},;
							{"S","11100"},;
							{"T","11101"},;
							{"U","11110"},;
							{"V","11111"};
						}

	Local cChr
	Local cBin  := ""

	Local cInt
	Local cDec

	Local cSig	:= self:cSig
	Local cHexB := hb_ntos(self:nBase)
	Local cHexN := self:cInt

	Local oBin  := tBigNumber():New(NIL,2)

	Local nI    := 0
	Local nLn   := Len(cHexN)
	Local nAT

	Local l16

	BEGIN SEQUENCE

		IF Empty(cHexB)
			 BREAK
		EndIF

		IF .NOT.(cHexB $ "[16][32]")
			BREAK
		EndIF

		l16	:= cHexB=="16"

		While ++nI<=nLn
			cChr := SubStr(cHexN,nI,1)
			nAT  := aScan(aH2B,{|aE|(aE[1]==cChr)})
			IF nAT>0
				cBin += IF(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
			EndIF
		End While

		cInt := cBin

		nI    := 0
		cBin  := ""
		cHexN := self:cDec
		nLn   := Len(cHexN)
		
		While ++nI<=nLn
			cChr := SubStr(cHexN,nI,1)
			nAT  := aScan(aH2B,{|aE|(aE[1]==cChr)})
			IF nAT>0
				cBin += IF(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
			EndIF
		End While

		cDec := cBin

		oBin:SetValue(cSig+cInt+"."+cDec)

	END SEQUENCE

Return(oBin)

/*
	Method		: B2H
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 07/02/2013
	Descricao   : Converte Bin para Hex
	Sintaxe     : tBigNumber():B2H(cHexB) -> cHexN
*/
Method B2H(cHexB) CLASS tBigNumber
	
	Local aH2B	:= {;
							{"0","00000"},;
							{"1","00001"},;
							{"2","00010"},;
							{"3","00011"},;
							{"4","00100"},;
							{"5","00101"},;
							{"6","00110"},;
							{"7","00111"},;
							{"8","01000"},;
							{"9","01001"},;
							{"A","01010"},;
							{"B","01011"},;
							{"C","01100"},;
							{"D","01101"},;
							{"E","01110"},;
							{"F","01111"},;
							{"G","10000"},;
							{"H","10001"},;
							{"I","10010"},;
							{"J","10011"},;
							{"K","10100"},;
							{"L","10101"},;
							{"M","10110"},;
							{"N","10111"},;
							{"O","11000"},;
							{"P","11001"},;
							{"Q","11010"},;
							{"R","11011"},;
							{"S","11100"},;
							{"T","11101"},;
							{"U","11110"},;
							{"V","11111"};
						}

	Local cChr
	Local cInt
	Local cDec
	Local cSig	:= self:cSig
	Local cBin	:= self:cInt
	Local cHexN	:= ""

	Local oHexN

	Local nI	:= 1
	Local nLn	:= Len(cBin)
	Local nAT

	Local l16
    
	BEGIN SEQUENCE

		IF Empty(cHexB)
			BREAK
		EndIF

		IF .NOT.(cHexB $ "[16][32]")
			oHexN := tBigNumber():New(NIL,16)
			BREAK
		EndIF

		l16 := cHexB=="16"

		While nI<=nLn
			cChr	:= SubStr(cBin,nI,IF(l16,4,5))
			nAT		:= aScan(aH2B,{|aE|(IF(l16,SubStr(aE[2],2),aE[2])==cChr)})
			IF nAT>0
				cHexN += aH2B[nAT][1]
			EndIF
			nI += IF(l16,4,5)
		End While
    
		cInt	:= cHexN

		nI		:= 1
		cBin	:= self:cDec
		nLn		:= Len(cBin)
		cHexN	:= ""

		While nI<=nLn
			cChr	:= SubStr(cBin,nI,IF(l16,4,5))
			nAT		:= aScan(aH2B,{|aE|(IF(l16,SubStr(aE[2],2),aE[2])==cChr)})
			IF nAT>0
				cHexN += aH2B[nAT][1]
			EndIF
			nI += IF(l16,4,5)
		End While

		cDec	:= cHexN

		oHexN	:= tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

	END SEQUENCE

Return(oHexN)

/*
	Method		: D2B
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 23/03/2013
	Descricao   : Converte Dec para Bin
	Sintaxe     : tBigNumber():D2B(cHexB) -> cBin
*/
Method D2B(cHexB) CLASS tBigNumber
	Local oHex	:= self:D2H(cHexB)
	Local oBin	:= oHex:H2B()
Return(oBin)

/*
	Method		: B2D
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 23/03/2013
	Descricao   : Converte Bin para Dec
	Sintaxe     : tBigNumber():B2D(cBin,cHexB) -> oBigNR
*/
Method B2D(cHexB) CLASS tBigNumber
	Local oHex	:= self:B2H(cHexB) 
	Local oDec	:= oHex:H2D()
Return(oDec)

/*
	Method		: Randomize
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 03/03/2013
	Descricao   : Randomize BigN Integer
	Sintaxe     : tBigNumber():Randomize(uB,uE,nExit) -> oR
*/
Method Randomize(uB,uE,nExit) CLASS tBigNumber

	Local aE
	
	Local oB	:= tBigNumber():New()
	Local oE	:= tBigNumber():New()
	Local oT	:= tBigNumber():New()
	Local oM	:= tBigNumber():New()
	Local oR	:= tBigNumber():New()

	Local cR    := ""

	Local nB
	Local nE
	Local nR
	Local nS
	Local nT

	Local lI

	#IFDEF __HARBOUR__
		oM:SetValue("9999999999999999999999999999")
	#ELSE //__PROTHEUS__
		oM:SetValue("999999999")
	#ENDIF	

	DEFAULT uB	:= "1"
	DEFAULT uE	:= oM:ExactValue()

	oB	:= tBigNumber():New(uB)
	oE	:= tBigNumber():New(uE)

	oB:SetValue(oB:Int(.T.):Abs(.T.))
	oE:SetValue(oE:Int(.T.):Abs(.T.))
	
	oT:SetValue(oB:Min(oE))
	oE:SetValue(oB:Max(oE))
	oB:SetValue(oT)

	BEGIN SEQUENCE
	
		IF oB:gt(oM)
	
			nE	:= Val(oM:ExactValue())
			nB	:= Int(nE/2)
			nR	:= __Random(nB,nE)
			cR	:= hb_ntos(nR)
			
			oR:SetValue(cR)
			
			lI	:= .F.
			nS	:= oE:nInt
			
			While oR:lt(oM)
				nR	:= __Random(nB,nE)
				cR	+= hb_ntos(nR)
				nT	:= nS
				IF lI
					While nT>0
						nR := -(__Random(1,nS))
						oR:SetValue(oR:Add(SubStr(cR,1,nR)))
						IF oR:gte(oE)
							EXIT
						EndIF
						nT += nR
					End While
				Else
					While nT>0
						nR	:= __Random(1,nS)
						oR:SetValue(oR:Add(SubStr(cR,1,nR)))
						IF oR:gte(oE)
							EXIT
						EndIF
						nT -= nR
					End While
				EndIF
				lI := .NOT.(lI)
			End While
			
			DEFAULT nExit := EXIT_MAX_RANDOM
			aE	:= Array(0)

			nS	:= oE:nInt
			
			While oR:lt(oE)
				nR	:= __Random(nB,nE)
				cR	+= hb_ntos(nR)
				nT	:= nS
				IF lI
					While  nT>0
						nR := -(__Random(1,nS))
						oR:SetValue(oR:Add(SubStr(cR,1,nR)))
						IF oR:gte(oE)
							EXIT
						EndIF
						nT += nR
					End While
				Else
					While nT>0
						nR	:= __Random(1,nS)
						oR:SetValue(oR:Add(SubStr(cR,1,nR)))
						IF oR:gte(oE)
							EXIT
						EndIF
						nT -= nR
					End While
				EndIF
				lI := .NOT.(lI)
				nT := 0
				IF aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
					EXIT
				EndIF
				IF nT<=RANDOM_MAX_EXIT
					aAdd(aE,__Random(1,nExit))
				EndIF
			End While

			BREAK
		
		EndIF
		
		IF oE:lte(oM)
			nB	:= Val(oB:ExactValue())
			nE	:= Val(oE:ExactValue())
			nR	:= __Random(nB,nE)	
			cR	+= hb_ntos(nR)
			oR:SetValue(cR)
		    BREAK
		EndIF

		DEFAULT nExit := EXIT_MAX_RANDOM 
		aE	:= Array(0)

		lI	:= .F.
		nS	:= oE:nInt

		While oR:lt(oE)
			nB	:= Val(oB:ExactValue())
			nE	:= Val(oM:ExactValue())
			nR	:= __Random(nB,nE)
			cR	+= hb_ntos(nR)
			nT	:= nS
			IF lI
				While nT>0
					nR := -(__Random(1,nS))
					oR:SetValue(oR:Add(SubStr(cR,1,nR)))
					IF oR:gte(oE)
						EXIT
					EndIF
					nT += nR
				End While
			Else
				While nT>0
					nR	:= __Random(1,nS)
					oR:SetValue(oR:Add(SubStr(cR,1,nR)))
					IF oR:gte(oE)
						EXIT
					EndIF
					nT	-= nR
				End While
			EndIF
			lI := .NOT.(lI)
			nT := 0
			IF aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
				EXIT
			EndIF
			IF nT<=RANDOM_MAX_EXIT
				aAdd(aE,__Random(1,nExit))
			EndIF
		End While
	
	END SEQUENCE
	
	IF oR:lt(oB) .or. oR:gt(oE)

		nT	:= Min(oE:nInt,oM:nInt)
		While nT>__nstcN9
			__cstcN9+=SubStr(__cstcN9,1,__nstcN9)
			__nstcN9+=__nstcN9
		End While
		cR	:= SubStr(__cstcN9,1,nT)
		oT:SetValue(cR)
		cR	:= oM:Min(oE:Min(oT)):ExactValue()
		nT	:= Val(cR)

		oT:SetValue(oE:Sub(oB):Div(__o2):Int(.T.))

		While oR:lt(oB)
			oR:SetValue(oR:Add(oT))
			nR	:= __Random(1,nT)
			cR	:= hb_ntos(nR)
			oR:SetValue(oR:Sub(cR))
		End	While 
	
		While oR:gt(oE)
			oR:SetValue(oR:Sub(oT))
			nR	:= __Random(1,nT)
			cR	:= hb_ntos(nR)
			oR:SetValue(oR:Add(cR))
		End While

	EndIF

Return(oR)

/*
	Funcao		: __Random
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 03/03/2013
	Descricao   : Define a chamada para a funcao Random Padrao
	Sintaxe     : __Random(nB,nE)
*/
Static Function __Random(nB,nE)

	Local nR

	IF nB==0
		nB := 1
	EndIF

	IF nB==nE
		++nE		
	EndIF

	#IFDEF __HARBOUR__
		nR := Abs(HB_RandomInt(nB,nE))
	#ELSE //__PROTHEUS__
		nR := Randomize(nB,nE)		
	#ENDIF	

Return(nR)

/*
	Method		: millerRabin
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 03/03/2013
	Descricao   : Miller-Rabin Method (Primality test)
	Sintaxe     : tBigNumber():millerRabin(uI) -> lPrime
	Ref.:		: http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
Method millerRabin(uI) CLASS tBigNumber

	Local o2		:= __o2:Clone()

	Local oN		:= self:Clone()
	Local oD		:= tBigNumber():New(oN:Sub(__o1))
	Local oS		:= tBigNumber():New()
	Local oI		:= tBigNumber():New()
	Local oA		:= tBigNumber():New()

	Local lPrime	:= .T.

	BEGIN SEQUENCE

		IF oN:lte(__o1)
			lPrime	:= .F.
			BREAK
		EndIF

		While oD:Mod(o2):eq(__o0)
			oD:SetValue(oD:Div(o2,.F.))
			oS:SetValue(oS:Add(__o1))
		End While
	
		DEFAULT uI	:= __o2:Clone()

		oI:SetValue(uI)
		While oI:gt(__o0)
			oA:SetValue(oA:Randomize(__o1,oN))
			lPrime := mrPass(oA,oS,oD,oN)
			IF .NOT.(lPrime)
				BREAK
			EndIF
			oI:SetValue(oI:Sub(__o1))
		End While

	END SEQUENCE

Return(lPrime)

/*
	Function	: mrPass
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 03/03/2013
	Descricao   : Miller-Rabin Pass (Primality test)
	Sintaxe     : mrPass(uA,uS,uD,uN)
	Ref.:		: http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
Static Function mrPass(uA,uS,uD,uN)

	Local oA	:= tBigNumber():New(uA)
	Local oS	:= tBigNumber():New(uS)
	Local oD	:= tBigNumber():New(uD)
	Local oN	:= tBigNumber():New(uN)
	Local oM	:= tBigNumber():New(oN:Sub(__o1))

	Local oP	:= tBigNumber():New(oA:Pow(oD):Mod(oN))
	Local oW	:= tBigNumber():New(oS:Sub(__o1))
	
	Local lmrP  := .T.

	BEGIN SEQUENCE

		IF oP:eq(__o1)
			BREAK
		EndIF

		While oW:gt(__o0)
			lmrP	:= 	oP:eq(oM)
			IF lmrP
				BREAK
			EndIF
			oP:SetValue(oP:Mult(oP):Mod(oN))
			oW:SetValue(oW:Sub(__o1))
		End While

		lmrP	:= 	oP:eq(oM)		

	END SEQUENCE

Return(lmrP)

/*
	Method		: FI
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 10/03/2013
	Descricao   : Euler's totient function
	Sintaxe     : tBigNumber():FI() -> oT
	Ref.:		: (Euler's totient function) http://community.topcoder.com/tc?module=Static&d1=tutorials&d2=primeNumbers
	Consultar	: http://www.javascripter.net/math/calculators/eulertotientfunction.htm para otimizar.
	
	int fi(int n) 
     {
       int result = n; 
       for(int i=2;i*i<=n;i++) 
       {
         if (n % i==0) result -= result/i; 
         while (n % i==0) n /= i; 
      } 
       if (n>1) result -= result/n; 
       return result; 
    } 
	
*/
Method FI() CLASS tBigNumber

	Local oC	:= self:Clone()
	Local oT	:= tBigNumber():New(oC:Int(.T.))

	Local oI	:= __o2:Clone()
	Local oN	:= oT:Clone()

	While oI:Mult(oI):lte(oC)
		IF oN:Mod(oI):eq(__o0)
			oT:SetValue(oT:Sub(oT:Div(oI,.F.)))
		EndIF
		While oN:Mod(oI):eq(__o0)
			oN:SetValue(oN:Div(oI,.F.))
		End While
		oI:SetValue(oI:Add(__o1))
	End While
	IF oN:gt(__o1)
		oT:SetValue(oT:Sub(oT:Div(oN,.F.)))		
	EndIF

Return(oT)

/*
	Method		: PFactors
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 19/03/2013
	Descricao   : Fatores Primos
	Sintaxe     : tBigNumber():PFactors() -> aPFactors
*/
Method PFactors() CLASS tBigNumber
	
	Local aPFactors	:= Array(0)
	
	Local cP		:= ""

	Local oN		:= self:Clone()
	Local oP		:= tBigNumber():New()
	Local oT		:= tBigNumber():New()

	Local otP		:= tPrime():New()
	
	Local nP
	Local nC		:= 0
	
	Local lPrime	:= .T.

	otP:IsPReset()
	otP:NextPReset()

	While otP:NextPrime(cP)
		cP := LTrim(otP:cPrime)
		oP:SetValue(cP)
		IF oP:gte(oN) .or. IF(lPrime,lPrime := otP:IsPrime(oN:cInt),lPrime .or. (++nC>1 .and. oN:gte(otP:cLPrime)))
			aAdd(aPFactors,{oN:cInt,"1"})
			EXIT
		EndIF
		While oN:Mod(oP):eq(__o0)
			nP := aScan(aPFactors,{|e|e[1]==cP})
			IF nP==0
				aAdd(aPFactors,{cP,"1"})
			Else
				oT:SetValue(aPFactors[nP][2])
				aPFactors[nP][2]	:= oT:SetValue(oT:Add(__o1)):ExactValue()
			EndIF
			oN:SetValue(oN:Div(oP,.F.))
			nC 		:= 0
			lPrime	:= .T.
		End While
		IF oN:lte(__o1)
			EXIT
		EndIF
	End While

Return(aPFactors)

/*
	Method		: Factorial 
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 19/03/2013
	Descricao   : Fatorial de Numeros Inteiros
	Sintaxe     : tBigNumber():Factorial() -> oF
	TODO        : Otimizar. 
				  Referencias: http://www.luschny.de/math/factorial/FastFactorialFunctions.htm
						       http://www.luschny.de/math/factorial/index.html 
*/
Method Factorial() CLASS tBigNumber 
	Local oN := self:Clone():Int(.T.,.F.)
	Local oF := oN:Clone()
    IF oN:eq(__o0)
		oF:SetValue(__o1)
	EndIF	
    While oN:gt(__o1)
		oN:SetValue(oN:Sub(__o1))
		oF:SetValue(oF:Mult(oN))
	End While	
Return(oF)                                

/*
	Funcao		: eMult
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Multiplicacao Egipcia (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
	Sintaxe     : eMult(cN1,cN2,nAcc) -> oNR
	Obs.		: Interessante+lenta... Utiliza Soma e Subtracao para obter o resultado
*/
Static Function eMult(cN1,cN2,nAcc)

	Local aE 		:= Array(0)
                	
	Local nI		:= 0
	
	Local oPe
	Local oPd
	Local ocT
	
	Local oN1		:= tBigNumber():New(cN1)

	Local oNR
	
	Local nBkpAcc	:= __nSetDecimals 

	DEFAULT nAcc	:= __nSetDecimals
	__nSetDecimals	:= nAcc

	oPe	:= __o1:Clone()
	oPd := tBigNumber():New(cN2)
	
	While .T.
		++nI
		aAdd(aE,{oPe:Clone(),oPd:Clone(),.F.})
		IF oPe:gte(oN1)
			EXIT
		EndIF
		oPe:SetValue(oPe:Add(oPe))
		oPd:SetValue(oPd:Add(oPd))
	End While

	ocT	:= __o0:Clone()
	While nI>0
		ocT:SetValue(ocT:Add(aE[nI][1]))
		IF ocT:lte(oN1)
			aE[nI][3] := .T. 
			IF ocT:eq(oN1)
				EXIT
			EndIF	
		Else
			ocT:SetValue(ocT:Sub(aE[nI][1]))
		EndIF
		--nI
	End While

	oNR	:= tBigNumber():New()
	For nI := 1 To Len(aE) 
		IF aE[nI][3]
			oNR:SetValue(oNR:Add(aE[nI][2]))
		EndIF
	Next nI

	__nSetDecimals := nBkpAcc

Return(oNR)
	
/*
	Funcao		: eDiv
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Divisao Egipcia (http://cognosco.blogs.sapo.pt/13236.html)
	Sintaxe     : eDiv(cN,cD,nAcc,lFloat) -> cNR
*/
Static Function eDiv(cN,cD,nAcc,lFloat)

	Local aE 		:= Array(0)
	
	Local cRDiv
                	
	Local nI		:= 0

	Local oPe
	Local oPd
    
	Local nBkpAcc	:= __nSetDecimals

	__nSetDecimals	:= nAcc
	
	__oeDivN:SetValue(cN)
	__oeDivD:SetValue(cD)
	__oeDivR:SetValue(__o0)

	oPe	:= __o1:Clone()
	oPd	:= __oeDivD:Clone()

	While .T.
		++nI
		aAdd(aE,{oPe:Clone(),oPd:Clone(),.F.})
		oPe:SetValue(oPe:Add(oPe))
		oPd:SetValue(oPd:Add(oPd))
		IF oPd:gt(__oeDivN)
			EXIT
		EndIF
	End While

	While nI>0
		__oeDivR:SetValue(__oeDivR:Add(aE[nI][2]))
		IF __oeDivR:lte(__oeDivN)
			aE[nI][3] := .T.
			IF __oeDivR:eq(__oeDivN)
				EXIT
			EndIF	
		Else
			__oeDivR:SetValue(__oeDivR:Sub(aE[nI][2]))
		EndIF
		--nI
	End While

	__oeDivR:SetValue(__oeDivN:Sub(__oeDivR))
	cRDiv := __oeDivR:ExactValue(.T.)
	__oeDivR:SetValue(__o0)
	
	For nI := 1 To Len(aE)
		IF aE[nI][3]
			__oeDivR:SetValue(__oeDivR:Add(aE[nI][1]))
		EndIF
	Next nI

	__oeDivR:SetValue(__oeDivR,NIL,cRDiv)
	IF .NOT.(lFloat) .and. .NOT.(cRDiv=="0") .and. SubStr(cRDiv,-1)=="0"
		cRDiv := SubStr(cRDiv,1,Len(cRDiv) -1)
		__oeDivR:SetValue(__oeDivR,NIL,cRDiv)
		IF Empty(cRDiv)
			cRDiv := "0"	
			__oeDivR:SetValue(__oeDivR,NIL,cRDiv)
		EndIF
	EndIF

	__nSetDecimals := nBkpAcc

Return(__oeDivR:Clone())

/*
	Funcao		: nthRoot
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 10/02/2013
	Descricao   : Metodo Newton-Raphson
	Sintaxe     : nthRoot(oRootB,oRootE,oAcc) -> othRoot
*/
Static Function nthRoot(oRootB,oRootE,oAcc)   
Return(__Pow(oRootB,__o1:Div(oRootE),oAcc))

/*
	Funcao		: __Pow
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 10/02/2013
	Descricao   : Metodo Newton-Raphson
	Sintaxe     : __Pow(base,exp,EPS) -> oPow
	Ref.        : http://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function 
	            : http://stackoverflow.com/questions/2882706/how-can-i-write-a-power-function-myself
*/
Static Function __Pow(base,expR,EPS)

    Local acc
    Local sqr
    Local tmp

   	Local low
   	Local mid
   	Local lst
    Local high
    
    Local exp := expR:Clone()

	if base:eq(__o1) .or. exp:eq(__o0)
		return(__o1:Clone())
	elseif base:eq(__o0)
		return(__o0:Clone())
	elseif exp:lt(__o0)
		acc := __pow(base,exp:Abs(.T.),EPS)
		return(__o1:Div(acc))
	elseif exp:Mod(__o2):eq(__o0)
 		acc := __pow(base,exp:Div(__o2),EPS)
    	return(acc:Mult(acc))
	elseif exp:Dec(.T.):gt(__o0) .and. exp:Int(.T.):gt(__o0)
		acc := base:Pow(expR)
		return(acc)
	elseif exp:gte(__o1)
    	acc := base:Mult(__pow(base,exp:Sub(__o1),EPS))
    	return(acc)
    else
    	low  := tBigNumber():New()
    	high := __o1:Clone()
    	sqr  := __SQRT(base)
    	acc  := sqr:Clone()    
    	mid  := high:Div(__o2)
    	tmp	 := mid:Sub(exp):Abs(.T.)
    	lst  := __o0:Clone()	
    	while tmp:gte(EPS)
    		sqr:SetValue(__SQRT(sqr))
			if mid:lte(exp)
				low:SetValue(mid)
				acc:SetValue(acc:Mult(sqr))
    	  	else
    	  		high:SetValue(mid)
    	  		acc:SetValue(__o1:Div(sqr))
    	  	endif
    	  	mid:SetValue(low:Add(high):Div(__o2))
    	  	tmp:SetValue(mid:Sub(exp):Abs(.T.))
    	  	if tmp:eq(lst)
    	  		exit
    	  	endif
    	  	lst:SetValue(tmp)
		end while
	endif

return(acc)

/*
	Funcao		: __SQRT
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 10/02/2013
	Descricao   : SQRT
	Sintaxe     : __SQRT(p) -> oSQRT
*/
Static Function __SQRT(p)
	Local l
	Local r
	Local t
	Local s
	Local n
	Local EPS
	Local q := tBigNumber():New(p)
	IF q:lte(q:SysSQRT())
		r := tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
	Else
		n := __nthRootAcc-1
		While n>__nstcZ0
			__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
			__nstcZ0+=__nstcZ0
		End While
		s   := "0."+SubStr(__cstcZ0,1,n)+"1"
		EPS := tBigNumber():New()
		EPS:SetValue(s,NIL,NIL,NIL,__nthRootAcc)
		r := q:Div(__o2)
		t := r:Pow(__o2):Sub(q):Abs(.T.)
		l := tBigNumber():New()
		while t:gte(EPS)
			r:SetValue(r:pow(__o2):Add(q):Div(__o2:Mult(r)))
			t:SetValue(r:Pow(__o2):Sub(q):Abs(.T.))
			if t:eq(l)
				exit
			endif
			l:SetValue(t)
		end while
	EndIF
Return(r)

#IFDEF TBN_DBFILE

	/*
		Funcao		: Add
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Adicao
		Sintaxe     : Add(a,b,n,nBase) -> cNR
	*/
	Static Function Add(a,b,n,nBase)
	
		Local c

		Local y := n+1
		Local k := 1

		#IFDEF __HARBOUR__
			FIELD FN
		#ENDIF	
		
		While y>__nstcZ0
			__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
			__nstcZ0+=__nstcZ0
		End While

		c := aNumber(SubStr(__cstcZ0,1,y),y,"ADD_C")
	
		While n>0
			(c)->(dbGoTo(k))
			IF (c)->(rLock())
				#IFDEF __PROTHEUS__
					(c)->FN += Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
				#ELSE
					(c)->FN += Val(a[n])+Val(b[n])
				#ENDIF
				IF (c)->FN>=nBase
					(c)->FN	-= nBase
					(c)->(dbUnLock())
					(c)->(dbGoTo(k+1))
					IF (c)->(rLock())
						(c)->FN	+= 1
					EndIF	
				EndIF
				(c)->(dbUnLock())
			EndIF
			++k
			--n
		End While
	
	Return(dbGetcN(c,y))
	
	/*
		Funcao		: Sub
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Subtracao
		Sintaxe     : Sub(a,b,n,nBase) -> cNR
	*/
	Static Function Sub(a,b,n,nBase)

		Local c

		Local y := n
		Local k := 1
	
		#IFDEF __HARBOUR__
			FIELD FN
		#ENDIF
		
		While y>__nstcZ0
			__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
			__nstcZ0+=__nstcZ0
		End While
		
		c := aNumber(SubStr(__cstcZ0,1,y),y,"SUB_C")

		While n>0
			(c)->(dbGoTo(k))
			IF (c)->(rLock())
				#IFDEF __PROTHEUS__
					(c)->FN += Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
				#ELSE
					(c)->FN += Val(a[n])-Val(b[n])
				#ENDIF
				IF (c)->FN<0
					(c)->FN += nBase
					(c)->(dbUnLock())
					(c)->(dbGoTo(k+1))
					IF (c)->(rLock())
						(c)->FN -= 1
					EndIF
				EndIF
				(c)->(dbUnLock())
			EndIF
			++k
			--n
		End While
		
	Return(dbGetcN(c,y))
	
	/*
		Funcao		: Mult
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Multiplicacao de Inteiros
		Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
		Obs.		: Mais rapida,usa a multiplicacao nativa
	*/
	Static Function Mult(cN1,cN2,n,nBase)

		Local c
		
		Local a	:= tBigNInvert(cN1,n)
		Local b	:= tBigNInvert(cN2,n)
		Local y	:= n+n
	
		Local i := 1
		Local k := 1
		Local l := 2
		
		Local s
		Local x
		Local j
		Local w
			
		#IFDEF __HARBOUR__
			FIELD FN
		#ENDIF
		
		While y>__nstcZ0
			__cstcZ0+=SubSTr(__cstcZ0,1,__nstcZ0)
			__nstcZ0+=__nstcZ0
		End While
		
		c := aNumber(SubStr(__cstcZ0,1,y),y,"MULT_C")
	
		While i<=n
			s := 1
			j := i
			(c)->(dbGoTo(k))
			IF (c)->(rLock())
				While s<=i
					#IFDEF __PROTHEUS__
						(c)->FN += Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
					#ELSE
						(c)->FN += Val(a[s++])*Val(b[j--])
					#ENDIF
				End While
				IF (c)->FN>=nBase
					x := k+1
					w := Int((c)->FN/nBase)
					(c)->(dbGoTo(x))
					IF (c)->(rLock())
						(c)->FN	:= w
						(c)->(dbUnLock())
						w := (c)->FN*nBase
						(c)->(dbGoTo(k))
						(c)->FN	-= w
					EndIF	
				EndIF
				(c)->(dbUnLock())
			EndIF
			k++
			i++
		End While
	
		While l<=n
			s := n
			j := l
			(c)->(dbGoTo(k))
			IF (c)->(rLock())
				While s>=l
				#IFDEF __PROTHEUS__
					(c)->FN	+= Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
				#ELSE
					(c)->FN	+= Val(a[s--])*Val(b[j++])	
				#ENDIF
				End While
				IF (c)->FN>=nBase
					x := k+1
					w := Int((c)->FN/nBase)
					(c)->(dbGoTo(x))
					IF (c)->(rLock())
						(c)->FN := w
						(c)->(dbUnLock())
						w := (c)->FN*nBase
						(c)->(dbGoTo(k))
						(c)->FN -= w
					EndIF	
				EndIF
				(c)->(dbUnLock())
			EndIF
			IF ++k>=y
				EXIT
			EndIF
			l++
		End While
		
	Return(dbGetcN(c,y))

	/*
		Funcao		: aNumber
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Array OF Numbers
		Sintaxe     : aNumber(c,n) -> a
	*/
	Static Function aNumber(c,n,o)
	
		Local a	:= dbNumber(o)
	
		Local y	:= 0
	
		#IFDEF __HARBOUR__
			FIELD FN
		#ENDIF	
	
		While ++y<=n
			(a)->(dbAppend(.T.))
		#IFDEF __PROTHEUS__
			(a)->FN	:= Val(SubStr(c,y,1))
		#ELSE
			(a)->FN	:= Val(c[y])
		#ENDIF	
			(a)->(dbUnLock())
		End While
	
	Return(a)
	
	/*
		Funcao		: dbGetcN
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Montar a String de Retorno
		Sintaxe     : dbGetcN(a,x) -> s
	*/
	Static Function dbGetcN(a,n)
	
		Local s	:= ""
		Local y	:= n
	
		#IFDEF __HARBOUR__
			FIELD FN
		#ENDIF	
	
		While y>=1
			(a)->(dbGoTo(y))
			While y>=1 .and. (a)->FN==0
				(a)->(dbGoTo(--y))
			End While
			While y>=1
				(a)->(dbGoTo(y--))
				s	+= hb_ntos((a)->FN)
			End While
		End While
	
		IF s==""
			s := "0"	
		EndIF
	
		IF Len(s)<n
			s := PadL(s,n,"0")
		EndIF
	
	Return(s)
	
	Static Function dbNumber(cAlias)
		Local aStru		:= {{"FN","N",4,0}}
		Local cFile
	#IFNDEF __HARBOUR__
		Local cLDriver
		Local cRDD		:= IF((Type("__LocalDriver")=="C"),__LocalDriver,"DBFCDXADS")
	#ELSE
		#IFNDEF TBN_MEMIO
		Local cRDD		:= "DBFCDX"
		#ENDIF
	#ENDIF
	#IFNDEF __HARBOUR__
		IF .NOT.(Type("__LocalDriver")=="C")
			Private __LocalDriver
		EndIF
		cLDriver		:= __LocalDriver
		__LocalDriver	:= cRDD
	#ENDIF
		IF Select(cAlias)==0
	#IFNDEF __HARBOUR__
			cFile := CriaTrab(aStru,.T.,GetdbExtension())
			IF .NOT.( GetdbExtension() $ cFile )
				cFile += GetdbExtension()
			EndIF
			dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
	#ELSE
			#IFNDEF TBN_MEMIO
				cFile := CriaTrab(aStru,cRDD)
				dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
			#ELSE
				cFile := CriaTrab(aStru,cAlias)
			#ENDIF	
	#ENDIF
			aAdd(__aFiles,{cAlias,cFile})
		Else
			(cAlias)->(dbRLock())
	#IFDEF __HARBOUR__		
			(cAlias)->(hb_dbZap())
	#ELSE
			(cAlias)->(__dbZap())
	#ENDIF		
			(cAlias)->(dbRUnLock())
		EndIF	
	#IFNDEF __HARBOUR__
		IF .NOT.(Empty(cLDriver))
			__LocalDriver := cLDriver
		EndIF	
	#ENDIF
	Return(cAlias)
	
	#IFDEF __HARBOUR__
		#IFNDEF TBN_MEMIO
			Static Function CriaTrab(aStru,cRDD)
				Local cFolder	:= tbNCurrentFolder()+hb_ps()+"tbigN_tmp"+hb_ps()
				Local cFile 	:= cFolder+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
				Local lSuccess	:= .F.
				While .NOT.(lSuccess)
					Try
					  MakeDir(cFolder)
					  dbCreate(cFile,aStru,cRDD)
					  lSuccess	:= .T.
					Catch
					  cFile		:= "TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
					  lSuccess	:= .F.
					End
				End While	
			Return(cFile)
		#ELSE
			Static Function CriaTrab(aStru,cAlias)
				Local cFile		:= "mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
				Local lSuccess	:= .F. 	
				While .NOT.(lSuccess)
					Try
					  dbCreate(cFile,aStru,NIL,.T.,cAlias)
					  lSuccess	:= .T.
					Catch
					  cFile		:= "mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
					  lSuccess	:= .F.
					End
				End While	
			Return(cFile)
		#ENDIF
	#ENDIF

#ELSE

	#IFDEF TBN_ARRAY

	/*
		Funcao		: Add
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Adicao
		Sintaxe     : Add(a,b,n,nBase) -> cNR
	*/
	Static Function Add(a,b,n,nBase)

		Local y	:= n+1
		Local c := aFill(aSize(__aZAdd,y),0)
		Local k := 1

		While n>0
		#IFDEF __PROTHEUS__
			c[k] += Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
		#ELSE
			c[k] += Val(a[n])+Val(b[n])
		#ENDIF
			IF c[k]>=nBase
				c[k+1]	+= 1
				c[k]	-= nBase
			EndIF
			++k
			--n
		End While

	Return(aGetcN(c,y))
	
	/*
		Funcao		: Sub
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Subtracao
		Sintaxe     : Sub(a,b,n,nBase) -> cNR
	*/
	Static Function Sub(a,b,n,nBase)

		Local y := n
		Local c := aFill(aSize(__aZSub,y),0)
		Local k := 1
	
		While n>0
		#IFDEF __PROTHEUS__
			c[k] += Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
		#ELSE
			c[k] += Val(a[n])-Val(b[n])
		#ENDIF
			IF c[k]<0
				c[k+1]	-= 1
				c[k]	+= nBase
			EndIF
			++k
			--n
		End While

	Return(aGetcN(c,y))
	
	/*
		Funcao		: Mult
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Multiplicacao de Inteiros
		Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
		Obs.		: Mais rapida,usa a multiplicacao nativa
	*/
	Static Function Mult(cN1,cN2,n,nBase)

		Local a	:= tBigNInvert(cN1,n)
		Local b	:= tBigNInvert(cN2,n)

		Local y	:= n+n
		Local c	:= aFill(aSize(__aZMult,y),0)
	
		Local i := 1
		Local k := 1
		Local l := 2
		
		Local s
		Local x
		Local j
	
		While i<=n
			s := 1
			j := i
			While s<=i
			#IFDEF __PROTHEUS__
				c[k] += Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
			#ELSE
				c[k] += Val(a[s++])*Val(b[j--])
			#ENDIF
			End While
			IF c[k]>=nBase
				x		:= k+1
				c[x]	:= Int(c[k]/nBase)
				c[k]	-= c[x]*nBase
			EndIF
			k++
			i++
		End While
	
		While l<=n
			s := n
			j := l
			While s>=l
			#IFDEF __PROTHEUS__
				c[k] += Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
			#ELSE
				c[k] += Val(a[s--])*Val(b[j++])	
			#ENDIF
			End While
			IF c[k]>=nBase
				x		:= k+1
				c[x]	:= Int(c[k]/nBase)
				c[k]	-= c[x]*nBase
			EndIF
			IF ++k>=y
				EXIT
			EndIF
			l++
		End While

	Return(aGetcN(c,y))

	/*
		Funcao		: aGetcN
		Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
		Data        : 04/02/2013
		Descricao   : Montar a String de Retorno
		Sintaxe     : aGetcN(a,x) -> s
	*/
	Static Function aGetcN(a,n)
	
		Local s	:= ""
		Local y	:= n
	
		While y>=1
			While y>=1 .and. a[y]==0
				y--
			End While
			While y>=1
				s	+= hb_ntos(a[y])
				y--
			End While
		End While
	
		IF s==""
			s := "0"
		EndIF
	
		IF Len(s)<n
			s := PadL(s,n,"0")
		EndIF
	
	Return(s)
	
	#ELSE

		/*
			Funcao		: Add
			Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data        : 04/02/2013
			Descricao   : Adicao
			Sintaxe     : Add(a,b,n,nBase) -> cNR
		*/
		#IFDEF __PROTHEUS__
			Static Function Add(a,b,n,nBase)

				Local c

				Local y	:= n+1
				Local k := 1
			
				Local v := 0
				Local v1
				
				While y>__nstcZ0
					__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
					__nstcZ0+=__nstcZ0
				End While
				
				c := SubStr(__cstcZ0,1,y)

				While n>0
					#IFDEF __PROTHEUS__
						v += Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
					#ELSE
						v += Val(a[n])+Val(b[n])
					#ENDIF
					IF v>=nBase
						v  -= nBase
						v1 := 1
					Else
						v1 := 0
					EndIF
					#IFDEF __PROTHEUS__
						c := Stuff(c,k,1,hb_ntos(v))
						c := Stuff(c,k+1,1,hb_ntos(v1)) 
					#ELSE
						c[k]   := hb_ntos(v)
						c[k+1] := hb_ntos(v1)
					#ENDIF
					v := v1
					++k
					--n
				End While

			Return(cGetcN(c,y))
		#ELSE
			Static Function Add(a,b,n,nB)
				Local c := tBigNAdd(a,b,n,nB)
			Return(cGetcN(c,n+1))
			#pragma BEGINDUMP
				#include "hbapi.h"
				#include "hbapiitm.h"
				HB_FUNC( TBIGNADD ){	
					const char * a  = hb_itemGetCPtr(hb_param(1,HB_IT_STRING));
					const char * b  = hb_itemGetCPtr(hb_param(2,HB_IT_STRING));
					HB_SIZE n  = (HB_SIZE)hb_parnint(3);
					HB_SIZE y  = n+1;
					HB_ISIZ nB = hb_parns(4);
					char * c = ( char * ) hb_xgrab(y+1);
					HB_SIZE k = 0;
					int v = 0;
					int v1;
					a += n-1;
					b += n-1;
					while (n--){
						v += hb_strVal((char*)a--,(HB_SIZE)1)+hb_strVal((char*)b--,(HB_SIZE)1);
						if ( v>=nB ){
							v  -= nB;
							v1 = 1;
						}	
						else{
							v1 = 0;
						}
						c[k]   = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v%nB];
						c[k+1] = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v1%nB];
						v = v1;
						++k;
					}
					hb_retclen_buffer(c,y);
				}
			#pragma ENDDUMP
		#ENDIF
		
		/*
			Funcao		: Sub
			Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data        : 04/02/2013
			Descricao   : Subtracao
			Sintaxe     : Sub(a,b,n,nBase) -> cNR
		*/
		#IFDEF __PROTHEUS__
			Static Function Sub(a,b,n,nBase)

				Local c

				Local y := n
				Local k := 1
				
				Local v := 0
				Local v1
				
				While y>__nstcZ0
					__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
					__nstcZ0+=__nstcZ0
				End While
				
				c := SubStr(__cstcZ0,1,y)
			
				While n>0
					#IFDEF __PROTHEUS__
						v += Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
					#ELSE
						v += Val(a[n])-Val(b[n])
					#ENDIF
					IF v<0
						v  += nBase
						v1 := -1
					Else
						v1 := 0
					EndIF
					#IFDEF __PROTHEUS__
						c := Stuff(c,k,1,hb_ntos(v)) 
					#ELSE
						c[k] := hb_ntos(v)
					#ENDIF
					v := v1
					++k
					--n
				End While

			Return(cGetcN(c,y))
		#ELSE
			Static Function Sub(a,b,n,nB)
				Local c := tBigNSub(a,b,n,nB)
			Return(cGetcN(c,n))
			#pragma BEGINDUMP
				#include "hbapi.h"
				#include "hbapiitm.h"
				HB_FUNC( TBIGNSUB ){	
					const char * a  = hb_itemGetCPtr(hb_param(1,HB_IT_STRING));
					const char * b  = hb_itemGetCPtr(hb_param(2,HB_IT_STRING));
					HB_SIZE n  = (HB_SIZE)hb_parnint(3);
					HB_SIZE y  = n;
					HB_ISIZ nB = hb_parns(4);
					char * c = ( char * ) hb_xgrab(y+1);
					HB_SIZE k = 0;
					int v = 0;
					int v1;
					a += n-1;
					b += n-1;
					while (n--){
						v += hb_strVal((char*)a--,(HB_SIZE)1)-hb_strVal((char*)b--,(HB_SIZE)1);
						if ( v<0 ){
							v  += nB;
							v1 = -1;
						}	
						else{
							v1 = 0;
						}
						c[k]   = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v%nB];
						c[k+1] = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v1%nB];
						v = v1;
						++k;
					}
					hb_retclen_buffer(c,y);
				}
			#pragma ENDDUMP
		#ENDIF
		/*
			Funcao		: Mult
			Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data        : 04/02/2013
			Descricao   : Multiplicacao de Inteiros
			Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
			Obs.		: Mais rapida, usa a multiplicacao nativa
		*/
		#IFDEF __PROTHEUS__
			Static Function Mult(cN1,cN2,n,nBase)

				Local c

				Local a	:= tBigNInvert(cN1,n)
				Local b	:= tBigNInvert(cN2,n)

				Local y	:= n+n

				Local i := 1
				Local k := 1
				Local l := 2
				
				Local s
				Local j
				
				Local v	:= 0
				Local v1
				
				While y>__nstcZ0
					__cstcZ0+=SubStr(__cstcZ0,1,__nstcZ0)
					__nstcZ0+=__nstcZ0
				End While
				
				c	:= SubStr(__cstcZ0,1,y)
					
				While i<=n
					s := 1
					j := i
					While s<=i
					#IFDEF __PROTHEUS__
						v += Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
					#ELSE
						v += Val(a[s++])*Val(b[j--])
					#ENDIF
					End While
					IF v>=nBase
						v1	:= Int(v/nBase)
						v	-= v1*nBase
					Else
						v1	:= 0	
					EndIF
					#IFDEF __PROTHEUS__
						c := Stuff(c,k,1,hb_ntos(v))
						c := Stuff(c,k+1,1,hb_ntos(v1)) 
					#ELSE
						c[k]   := hb_ntos(v)
						c[k+1] := hb_ntos(v1)
					#ENDIF
					v := v1
					k++
					i++
				End While

				While l<=n
					s := n
					j := l
					While s>=l
					#IFDEF __PROTHEUS__
						v += Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
					#ELSE
						v += Val(a[s--])*Val(b[j++])	
					#ENDIF
					End While
					IF v>=nBase
						v1	:= Int(v/nBase)
						v	-= v1*nBase
					Else
						v1	:= 0	
					EndIF
					#IFDEF __PROTHEUS__
						c := Stuff(c,k,1,hb_ntos(v))
						c := Stuff(c,k+1,1,hb_ntos(v1)) 
					#ELSE
						c[k]   := hb_ntos(v)
						c[k+1] := hb_ntos(v1)
					#ENDIF
					v := v1
					IF ++k>=y
						EXIT
					EndIF
					l++
				End While

			Return(cGetcN(c,y))
		#ELSE
			Static Function Mult(cN1,cN2,n,nB)
				Local c
				Local a	:= tBigNInvert(cN1,n)
				Local b	:= tBigNInvert(cN2,n)
				c := tBigNMult(a,b,n,nB)
			Return(cGetcN(c,Len(c)))			
			#pragma BEGINDUMP
				#include "hbapi.h"
				#include "hbapiitm.h"
				HB_FUNC( TBIGNMULT ){
					
					const char * a = hb_itemGetCPtr(hb_param(1,HB_IT_STRING));
					const char * b = hb_itemGetCPtr(hb_param(2,HB_IT_STRING));
					
					HB_SIZE n  = (HB_SIZE)hb_parnint(3);
					HB_SIZE y  = n+n;
					
					HB_ISIZ nB = hb_parns(4);
												
					char * c = ( char * ) hb_xgrab(y+1);

					HB_SIZE i = 0;
					HB_SIZE k = 0;
					HB_SIZE l = 1;
					
					HB_SIZE s;
					HB_SIZE j;
					
					int v = 0;
					int v1;

					n-=1;
					
					while (i<=n){
						s = 0;
						j = i;
						while (s<=i){
							v += hb_strVal(&a[s++],(HB_SIZE)1)*hb_strVal(&b[j--],(HB_SIZE)1);
						}
						if (v>=nB){
							v1 = v/nB;
							v -= v1*nB;
						}else{
							v1 = 0;
						}
						c[k]   = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v%nB];
						c[k+1] = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v1%nB];
						v = v1;
						k++;
						i++;
					}
				
					while (l<=n){
						s = n;
						j = l;
						while (s>=l){
							v += hb_strVal(&a[s--],(HB_SIZE)1)*hb_strVal(&b[j++],(HB_SIZE)1);
						}
						if (v>=nB){
							v1 = v/nB;
							v -= v1*nB;
						}else{
							v1 = 0;	
						}
						c[k]   = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v%nB];
						c[k+1] = "0123456789ABCEFGHIJKLMNOPQRSTUV"[v1%nB];
						v = v1;
						if (++k>=y){
							break;
						}
						l++;
					}		
					hb_retclen_buffer(c,y);
				}
			#pragma ENDDUMP
		#ENDIF

		/*
			Funcao		: cGetcN
			Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
			Data        : 04/02/2013
			Descricao   : Montar a String de Retorno
			Sintaxe     : cGetcN(c,n) -> s
		*/
		Static Function cGetcN(c,n)
		
		#IFDEF __HARBOUR__
			Local s := SubStr(tBigNInvert(c,n),-n)
		#ELSE		
			Local s	:= ""
			Local y	:= n
		
			While y>=1
			#IFDEF __PROTHEUS__
				While y>=1 .and. SubStr(c,y,1)=="0"
			#ELSE
				While y>=1 .and. c[y]=="0"
			#ENDIF	
					y--
				End While
				While y>=1
				#IFDEF __PROTHEUS__
					s += SubStr(c,y,1)
				#ELSE
					s += c[y]
				#ENDIF
					y--
				End While
			End While
		#ENDIF
			IF s==""
				s := "0"
			EndIF
		
			IF Len(s)<n
				s := PadL(s,n,"0")
			EndIF
		
		Return(s)
	
	#ENDIF

#ENDIF

/*
	Funcao		: tBigNInvert
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Inverte o Numero
	Sintaxe     : tBigNInvert(c,n) -> s
*/
#IFDEF __PROTHEUS__
	Static Function tBigNInvert(c,n)
		Local s := ""
		Local y	:= n
		While y>0
		#IFDEF __PROTHEUS__
			s += SubStr(c,y--,1)
		#ELSE
			s += c[y--]
		#ENDIF
		End While
	Return(s)
#ELSE
	#pragma BEGINDUMP
		#include "hbapi.h"
		#include "hbapiitm.h"
		HB_FUNC( TBIGNINVERT ){
			PHB_ITEM pItem = hb_param(1,HB_IT_STRING);
			HB_SIZE s = (HB_SIZE)hb_parnint(2);
			HB_SIZE f = s;
			HB_SIZE t = 0;
			char * szStringTo = ( char * ) hb_xgrab(s+1);
			const char * szStringFrom = hb_itemGetCPtr(pItem);
			for(;f;){
				szStringTo[t++]=szStringFrom[--f];
			}
			hb_retclen_buffer(szStringTo,s);
		}
	#pragma ENDDUMP
#ENDIF

/*
	Funcao		: MathO
	Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data        : 04/02/2013
	Descricao   : Operacoes matematicas
	Sintaxe     : MathO(uBigN1,cOperator,uBigN2,lRetObject)
*/
Static Function MathO(uBigN1,cOperator,uBigN2,lRetObject)

	Local oBigNR := tBigNumber():New()

	Local oBigN1 := tBigNumber():New(uBigN1)
	Local oBigN2 := tBigNumber():New(uBigN2)

	DO CASE
		CASE (aScan(OPERATOR_ADD,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Add(oBigN2))
		CASE (aScan(OPERATOR_SUBTRACT,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Sub(oBigN2))
		CASE (aScan(OPERATOR_MULTIPLY,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Mult(oBigN2))
		CASE (aScan(OPERATOR_DIVIDE,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Div(oBigN2))
		CASE (aScan(OPERATOR_POW,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Pow(oBigN2))
		CASE (aScan(OPERATOR_MOD,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:Mod(oBigN2))
		CASE (aScan(OPERATOR_ROOT,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:nthRoot(oBigN2))
		CASE (aScan(OPERATOR_SQRT,{|cOp|cOperator==cOp})>0)
			oBigNR:SetValue(oBigN1:SQRT())
	ENDCASE

	DEFAULT lRetObject := .T.

Return(IF(lRetObject,oBigNR,oBigNR:ExactValue()))

#IFDEF __PROTHEUS__
	Static Function __eTthD()
	Return(StaticCall(__pteTthD,__eTthD))
	Static Function __PITthD()
	Return(StaticCall(__ptPITthD,__PITthD))
#ELSE
	Static Function __eTthD()
	Return(__hbeTthD())
	Static Function __PITthD()
	Return(__hbPITthD())
#ENDIF