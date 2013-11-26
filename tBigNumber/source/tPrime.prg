#include "fileio.ch"
#include "directry.ch"
#include "tBigNumber.ch"

THREAD Static __aPTables
THREAD Static __nPTables

THREAD Static __oIPfRead
THREAD Static __nIPfRead
THREAD Static __aIPLRead

THREAD Static __oNPfRead
THREAD Static __nNPfRead
THREAD Static __aNPLRead

/*
	Class		: tPrime
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Instancia um novo objeto do tipo tPrime
	Sintaxe		: tPrime():New() -> self
	Obs.		: Obter os Numeros Primos a Partir das Tabelas de Numeros Primos 
				  fornecidas por primes.utm.edu (http://primes.utm.edu/lists/small/millions/)	
*/
CLASS tPrime

	DATA cPrime
	DATA cFPrime
	DATA cLPrime
	
	DATA nSize

	Method New( cPath ) CONSTRUCTOR

	Method ClassName()

	Method IsPrime(cN,lForce)
	Method IsPReset()

	Method NextPrime(cN,lForce)
	Method NextPReset()

	Method ResetAll()

END CLASS

/*
	Função		: tPrime():New
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Instancia um novo Objeto tPrime
	Sintaxe		: tPrime():New() -> self
*/
#IFDEF __PROTHEUS__
	User Function tPrime( cPath )
	Return( tPrime():New( cPath ) )
#ENDIF

/*
	Method		: New
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: CONSTRUCTOR
	Sintaxe		: tPrime():New( cPath ) -> self
*/
Method New( cPath ) CLASS tPrime 

	Local aLine
	Local aFiles
	
	Local cLine
	Local cFile

	Local cFPrime
	Local cLPrime

	Local nSize
	Local nLine
	Local nFile
	Local nFiles
	Local ofRead

	DEFAULT __aPTables	:= Array(0)

	IF Empty( __aPTables )
		self:nSize	:= 10
        #IFDEF __HARBOUR__
	        DEFAULT cPath := hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir()+hb_ps()+"PrimesTables"+hb_ps()
		#ELSE //__PROTHEUS__
	        DEFAULT cPath := "\PrimesTables\"
		#ENDIF
		aFiles	:= Directory( cPath + "prime*.txt" )
		nFiles	:= Len( aFiles )
		nSize	:= 10	
		ofRead	:= tfRead():New()
		For nFile := 1 To nFiles
			cFile	:= cPath+aFiles[nFile][F_NAME]
			nLine	:= 0
			ofRead:Open(cFile)
			ofRead:ReadLine()
			While ofRead:MoreToRead()
				cLine := ofRead:ReadLine()
				IF Empty(cLine)
					Loop
    			EndIF
    			nLine	:= Max(nLine,Len(cLine))
    			While "  " $ cLine
    				cLine	:= StrTran(cLine,"  "," ")
    			End While	
    			While SubStr(cLine,1,1) == " "
    				cLine := SubStr(cLine,2)
    			End While
    			While SubStr(cLine,-1) == " "
    				cLine := SubStr(cLine,1,Len(cLine)-1)
    			End While
    			#IFDEF __HARBOUR__
     				aLine := hb_ATokens(cLine," ")
    			#ELSE //__PROTHEUS__
				     aLine := StrTokArr(cLine," ")
			    #ENDIF
			    cFPrime := aLine[1]
			    nSize	:= Max(Len(cFPrime),nSize)
			    cFPrime := PadL(cFPrime,nSize)
			    EXIT
			End While
			ofRead:Seek( -nLine , FS_END )
			While ofRead:MoreToRead()
				cLine := ofRead:ReadLine()
				IF Empty(cLine)
					Loop
    			EndIF
    			nLine	:= Max(nLine,Len(cLine))
    			While "  " $ cLine
    				cLine	:= StrTran(cLine,"  "," ")
    			End While	
    			While SubStr(cLine,1,1) == " "
    				cLine := SubStr(cLine,2)
    			End While
    			While SubStr(cLine,-1) == " "
    				cLine := SubStr(cLine,1,Len(cLine)-1)
    			End While
    			#IFDEF __HARBOUR__
     				aLine := hb_ATokens(cLine," ")
    			#ELSE //__PROTHEUS__
				     aLine := StrTokArr(cLine," ")
			    #ENDIF
				cLPrime := aLine[Len(aLine)]
			    nSize	:= Max(Len(cFPrime),nSize)
			    cLPrime := PadL(cLPrime,nSize)
				EXIT
			End While
			ofRead:Close(.T.)
			aAdd( __aPTables , { cFile , cFPrime , cLPrime , nLine } )
		Next nFile

		nFiles	:= Len( __aPTables )
		IF nFiles > 0
			IF nSize > self:nSize
				self:nSize := nSize
				For nFile := 1 To nFiles
					__aPTables[nFile][2] := PadL(__aPTables[nFile][2],nSize)
					__aPTables[nFile][3] := PadL(__aPTables[nFile][3],nSize)
				Next nFile
			EndIF
			aSort( __aPTables , NIL , NIL , { |x,y| x[2] < y[2] } )
			self:cFPrime	:= __aPTables[1][2]
			self:cLPrime	:= __aPTables[nFiles][3]
		EndIF	

		__nPTables	:= nFiles

	Else

		nFiles	:= __nPTables
		IF nFiles > 0
			self:cFPrime	:= __aPTables[1][2]
			self:cLPrime	:= __aPTables[nFiles][3]
			self:nSize 		:= Len( self:cLPrime )
		EndIF

	EndIF

    self:cPrime	:= ""

	IF self:cFPrime == NIL
		self:cFPrime := ""
	EndIF
	
	IF self:cLPrime == NIL
		self:cLPrime := ""
	EndIF

	IF self:nSize == NIL
		self:nSize := Len(self:cLPrime)
	EndIF

Return( self )

/*
	Method		: ClassName
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: ClassName
	Sintaxe		: tPrime():ClassName() -> cClassName
*/
Method ClassName() CLASS tPrime
Return( "TPRIME" )

/*
	Method		: IsPrime
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Verifica se o Numero passado por Parametro consta nas Tabelas de Numeros Primo
	Sintaxe		: tPrime():IsPrime( cN , lForce ) -> lPrime
*/
Method IsPrime( cN , lForce ) CLASS tPrime

	Local aLine

	Local cLine
	
	Local lPrime	:= .F.
	
	Local nPrime
	Local nTable

	BEGIN SEQUENCE

		IF Empty( __aPTables )
			BREAK
		EndIF

		DEFAULT cN 	:= self:cPrime
		cN			:= PadL( cN , self:nSize )

		nTable		:= aScan( __aPTables , { |x| cN >= x[2] .and. cN <= x[3] } )
		
		IF nTable == 0
			BREAK
		ENDIF

		DEFAULT __oIPfRead	:= tfRead():New()
		DEFAULT __aIPLRead	:= Array(0)

		DEFAULT lForce		:= .F.
		IF ( lForce )
			Self:IsPReset()
		EndIF

		IF .NOT.( __nIPfRead == nTable )
			Self:IsPReset()
			__nIPfRead := nTable
			__oIPfRead:Close(.T.)
			__oIPfRead:Open(__aPTables[nTable][1])
			__oIPfRead:nReadSize := MIN( 65535 , ( __aPTables[nTable][4] + 2 ) * 64 )
			__oIPfRead:ReadLine()
		EndIF

		nPrime	:= aScan( __aIPLRead , { |x| PadL(x,self:nSize) == cN } )
		IF ( lPrime := nPrime > 0 )
			BREAK
		EndIF	

		While __oIPfRead:MoreToRead()
			cLine := __oIPfRead:ReadLine()
			IF Empty(cLine)
				Loop
    		EndIF
    		While "  " $ cLine
    			cLine	:= StrTran(cLine,"  "," ")
    		End While	
    		While SubStr(cLine,1,1) == " "
    			cLine := SubStr(cLine,2)
    		End While
    		While SubStr(cLine,-1) == " "
    			cLine := SubStr(cLine,1,Len(cLine)-1)
    		End While
    		#IFDEF __HARBOUR__
     			aLine := hb_ATokens(cLine," ")
    		#ELSE //__PROTHEUS__
			    aLine := StrTokArr(cLine," ")
		    #ENDIF
			nPrime	:= aScan( aLine , { |x| PadL(x,self:nSize) == cN } )
			IF ( lPrime := nPrime > 0 )
				EXIT
			EndIF	
			IF aScan( aLine , { |x| PadL(x,self:nSize) > cN } ) > 0
				EXIT
			EndIF
		End While

		aSize( __aIPLRead ,  0 )

		IF .NOT.( Empty( aLine ) )
			aEval( aLine , { |x| aAdd( __aIPLRead , x ) } )
		EndIF

	END SEQUENCE

Return( lPrime )

/*
	Method		: IsPReset
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Reset IsPrime Cache
	Sintaxe		: tPrime():IsPReset() -> .T.
*/
Method IsPReset() CLASS tPrime
	__nIPfRead	:= NIL
	IF .NOT.( __aIPLRead == NIL )
		aSize( __aIPLRead , 0 )
	EndIF
Return( .T. )

/*
	Method		: NextPrime
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Obtem o Proximo Numero da Tabela de Numeros Primos
	Sintaxe		: tPrime():NextPrime( cN , lForce ) -> lPrime
*/
Method NextPrime( cN , lForce ) CLASS tPrime

	Local aLine

	Local cLine
	Local cPrime
	
	Local lPrime	:= .F.
	
	Local nPrime
	Local nTable

	BEGIN SEQUENCE
	
		IF Empty( __aPTables )
			BREAK
		EndIF

		DEFAULT cN 	:= self:cPrime
		cN			:= PadL( cN , self:nSize )
		self:cPrime	:= cN

		IF Empty( cN )
			nTable := 1
		Else
			nTable	:= aScan( __aPTables , { |x| cN >= x[2] .and. cN <= x[3] } )
		EndIF	

		IF nTable == 0
			BREAK
		ENDIF

		DEFAULT __oNPfRead	:= tfRead():New()
		DEFAULT __aNPLRead	:= Array(0)

		DEFAULT lForce		:= .F.
		IF ( lForce )
			Self:NextPReset()
		EndIF

		IF .NOT.( __nNPfRead == nTable )
			Self:NextPReset()
			__nNPfRead := nTable
			__oNPfRead:Close(.T.)
			__oNPfRead:Open(__aPTables[nTable][1])
			__oNPfRead:nReadSize := MIN( 65535 , ( __aPTables[nTable][4] + 2 ) * 64 )
			__oNPfRead:ReadLine()
		EndIF

		nPrime	:= aScan( __aNPLRead , { |x| ( cPrime := PadL(x,self:nSize) ) > cN } )
		IF ( lPrime := nPrime > 0 )
			self:cPrime := cPrime
			BREAK
		EndIF	

		While __oNPfRead:MoreToRead()
			cLine := __oNPfRead:ReadLine()
			IF Empty(cLine)
				Loop
    		EndIF
    		While "  " $ cLine
    			cLine	:= StrTran(cLine,"  "," ")
    		End While	
    		While SubStr(cLine,1,1) == " "
    			cLine := SubStr(cLine,2)
    		End While
    		While SubStr(cLine,-1) == " "
    			cLine := SubStr(cLine,1,Len(cLine)-1)
    		End While
    		#IFDEF __HARBOUR__
     			aLine := hb_ATokens(cLine," ")
    		#ELSE //__PROTHEUS__
			    aLine := StrTokArr(cLine," ")
		    #ENDIF
			nPrime	:= aScan( aLine , { |x| ( cPrime := PadL(x,self:nSize) ) > cN } )
			IF ( lPrime := nPrime > 0 )
				EXIT
			EndIF	
		End While

		aSize( __aNPLRead ,  0 )

		IF .NOT.( Empty( aLine ) )
			aEval( aLine , { |x| aAdd( __aNPLRead , x ) } )
		EndIF

		DEFAULT cPrime	:= ""
		self:cPrime 	:= cPrime

	END SEQUENCE

Return( lPrime )

/*
	Method		: NextPReset
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Reset NextPrime Cache
	Sintaxe		: tPrime():NextPReset() -> .T.
*/
Method NextPReset() CLASS tPrime
	__nNPfRead	:= 0
	IF .NOT.( __aNPLRead == NIL )
		aSize( __aNPLRead , 0 )		
	EndIF
Return( .T. )

/*
	Method		: ResetAll
	Autor		: Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data		: 16/03/2013
	Descricao	: Reset All Cache
	Sintaxe		: tPrime():ResetAll() -> .T.
*/
Method ResetAll() CLASS tPrime
	__nPTables	:= 0
	IF .NOT.( __aPTables == NIL )
		aSize( __aPTables , 0 )
	EndIF
	Self:IsPReset()
	Self:NextPReset()
Return( .T. )