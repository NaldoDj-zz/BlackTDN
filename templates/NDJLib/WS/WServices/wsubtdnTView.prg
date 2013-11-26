#include "set.ch"
#include "apwebsrv.ch"
#include "protheus.ch"
#include "dbstruct.ch"
#include "topconn.ch"
#include "wsubtdnTView.ch"
#include "tryexception.ch"

Static __lAS400		:= ( TCSrvType() == "AS/400" )
Static __cTCGetDB	:= Upper(AllTrim(TCGetDB())

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uFieldStruct
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Deriva de FieldStruct e carrega informacoes complementares
	Uso: 		WebServices
*/
WSSTRUCT uFieldStruct
	WSDATA FldName 			AS STRING
	WSDATA FldType 			AS STRING
	WSDATA FldSize 			AS INTEGER
	WSDATA FldDec  			AS INTEGER
	WSDATA FldTitle	 		AS STRING
	WSDATA FldMandatory		AS BOOLEAN
	WSDATA FldDescription	AS STRING
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Deriva de FieldStruct e carrega informacoes complementares
	Uso: 		WebServices
*/
WSSTRUCT uFieldsName
	WSDATA uFldName		AS ARRAY OF STRING
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uFieldView
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Semelhanete a FieldView
	Uso: 		WebServices
*/
WSSTRUCT uFieldView
	WSDATA FldTag AS ARRAY OF STRING
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uAnyCodeDesc
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Codigo e Descricao
	Uso: 		WebServices
*/
WSSTRUCT uAnyCodeDesc
	WSDATA Code        AS STRING
	WSDATA Description AS STRING
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uTAliases
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Estrutura para dados do SX2
	Uso: 		WebServices
*/
WSSTRUCT uTAliases
	WSDATA TAliases	AS ARRAY OF uAnyCodeDesc
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebStruct:	uTableView
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Deriva de TableView e carrega informacoes complementares
	Uso: 		WebServices
*/
WSSTRUCT uTableView
	WSDATA TableData	AS ARRAY OF /*u*/FieldView
	WSDATA TableStruct	AS ARRAY OF uFieldStruct
ENDWSSTRUCT

/*
	Progama:	wsubtdnTView.prg
	WebService:	ubtdnTView
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obter dados de uma tabela do Protheus
	Uso: 		WebServices
*/
WSSERVICE ubtdnTView DESCRIPTION STR0001 NAMESPACE "http://www.blacktdn.com.br" //"Obter informacoes de uma tabela do Protheus"

	WSDATA Table		AS uTableView

	WSDATA Alias		AS STRING
	WSDATA TAlias		AS uTAliases

	WSDATA Where		AS STRING

	WSDATA rInit		AS INTEGER
	WSDATA rEnd			AS INTEGER
	WSDATA rMax			AS INTEGER

	WSDATA FieldsName	AS uFieldsName

	WSDATA TableData	AS ARRAY OF /*u*/FieldView
	WSDATA TableStruct	AS ARRAY OF uFieldStruct

	WSDATA rDeleted		AS BOOLEAN
	WSDATA rRecno		AS BOOLEAN

	WSMETHOD getTRMax					DESCRIPTION STR0004 //"Obter o maior registro em uma Tabela"
	WSMETHOD getTAlias					DESCRIPTION STR0017 //"Obter Aliases validos para recuperaÁ„o de dados"

	WSMETHOD getTable					DESCRIPTION STR0002 //"Obter informacoes de uma Tabela"
	WSMETHOD getTbyWhere				DESCRIPTION STR0003 //"Obter informacoes de uma Tabela (Usando Filtro)" 
	
	WSMETHOD getTData					DESCRIPTION STR0006 //"Obter os dados da Tabela"	
	WSMETHOD getTStruct					DESCRIPTION STR0005 //"Obter a estrutura da Tabela"
	WSMETHOD getTFieldsName				DESCRIPTION STR0016 //"Obter os campos de uma Tabela"

	WSMETHOD getTablebyFieldsName		DESCRIPTION STR0012 //"Obter informacoes de uma Tabela baseado na selecao de campos"
	WSMETHOD getTbyWhereAndFieldsName	DESCRIPTION STR0013 //"Obter informacoes de uma Tabela (Usando Filtro) e baseado na selecao de campos" 

	WSMETHOD getTDatabyFieldsName		DESCRIPTION STR0014 //"Obter os dados da Tabela baseado na selecao de campos"	
	WSMETHOD getTStructbyFieldsName		DESCRIPTION STR0015 //"Obter a estrutura da Tabela baseado na selecao de campos" 

ENDWSSERVICE

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTRMax
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem o maior registro em uma tabela
	Uso: 		WebServices
*/
WSMETHOD getTRMax WSRECEIVE Alias , rDeleted , rRecno WSSEND rMax WSSERVICE ubtdnTView

	Local adbQuery		:= Array(0)
	
	Local cAlias
	Local cSQLName
	Local cRddName

	Local lQuery		:= .T. 	
	Local lWsMethodRet	:= .T.
	Local lSetDeleted	:= Set(_SET_DELETED,"ON")

	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	

		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF
    
		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		Set(_SET_DELETED,IF(self:rDeleted,"OFF","ON"))
		
		IF ( Select(self:Alias) == 0 )
			TRYEXCEPTION
				ChkFile(self:Alias)
			ENDEXCEPTION	
		EndIF
		
		TRYEXCEPTION
			cRddName	:= (self:Alias)->( RddName() )
		ENDEXCEPTION	
		
		lQuery		:= ( cRddName == "TOPCONN" )
		IF .NOT.( lQuery )
			rMax	:= (self:Alias)->(RecCount())
  		EndIF
  		
		IF ( lQuery )
		
			cSQLName := RetSQLName(self:Alias)
	
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF	
					
			IF ( __lAS400 )
				cQuery := "SELECT MAX("+self:Alias+".R_E_C_N_O_) MAXRECNO "
			Else
				cQuery := "SELECT MAX(RRN("+cSQLName+")) MAXRECNO "	
			EndIF			
			cQuery += "  FROM "+cSQLName+" "+self:Alias
			IF .NOT.(self:rDeleted)
				IF ( __lAS400 )
					cQuery += " WHERE "+self:Alias+".@DELETED@<>'*'"
				Else
					cQuery += " WHERE "+self:Alias+".D_E_L_E_T_<>'*'"
				EndIf
			EndIF	
	        
	    	IF .NOT.( dbQuery(@adbQuery,cQuery,@cAlias) )
				rMax := 0
	    	ENDIF
    	
    		rMax	:= (cAlias)->MAXRECNO
    	
    	EndIF	
    		
   		self:rMax	:= rMax

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION
	
	aEval( adbQuery , { |cAlias| IF( ( Select( cAlias ) > 0 ) , (cAlias)->( dbCloseArea() ) , NIL ) } )

	Set(_SET_DELETED,IF(lSetDeleted,"ON","OFF"))

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTAlias
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obter Aliases validos para recuperaÁ„o de dados
	Uso: 		WebServices
*/
WSMETHOD getTAlias WSRECEIVE rInit , rEnd WSSEND TAlias WSSERVICE ubtdnTView

	Local lWsMethodRet	:= .T.
	
	Local nAlias		:= 0
	Local nRecno

	Local oException

	TRYEXCEPTION

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF

		TAlias			:= WsClassNew("uTAliases")
		self:TAlias		:= TAlias
		TAlias:TAliases	:= Array(0)

		For nRecno := self:rInit To self:rEnd
			SX2->( dbGoTo(nRecno) )
			IF SX2->( Eof() .or. Bof() )
				Loop
			EndIF
			++nAlias
			aAdd(TAlias:TAliases,WsClassNew("uAnyCodeDesc"))
			TAlias:TAliases[nAlias]:Code		:= SX2->X2_CHAVE
			TAlias:TAliases[nAlias]:Description	:= __UTF8(AllTrim(X2Nome()))
		Next nRecno

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTable
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtendo dados e estrutura de uma tabela
	Uso: 		WebServices
*/
WSMETHOD getTable WSRECEIVE Alias , rInit , rEnd , rDeleted , rRecno WSSEND Table WSSERVICE ubtdnTView

	Local cSQLName
	
	Local lWsMethodRet	:= .T.

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		IF Empty(self:Alias)
			UserException( STR0010 + self:Alias ) //"Alias invalido: "	
		EndIF

		cSQLName := RetSQLName(self:Alias)
		
		IF ( Select(self:Alias) == 0 )
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			Else
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF
		EndIF			

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF

		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		Table       := WsClassNew("uTableView") 
		self:Table	:= Table 

		obtdnTView				:= WsClassNew("ubtdnTView")
		obtdnTView:Alias		:= self:Alias 
		obtdnTView:rInit		:= self:rInit
		obtdnTView:rEnd 		:= self:rEnd
		obtdnTView:FieldsName	:= self:FieldsName
		obtdnTView:rDeleted		:= self:rDeleted
		obtdnTView:rRecno		:= self:rRecno
		
		IF .NOT.( obtdnTView:getTStruct(@Alias,@rDeleted,@rRecno) )
			UserException( STR0008 + self:Alias ) //"Estrutura invalida: "
		EndIF

		Table:TableStruct		:= obtdnTView:TableStruct
		self:Table:TableStruct	:= Table:TableStruct

		IF .NOT.( obtdnTView:getTData(@Alias,@rInit,@rEnd,@rDeleted,@rRecno) )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF

		Table:TableData			:= obtdnTView:TableData
		self:Table:TableData	:= Table:TableData

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTbyWhere
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem dados e estrutura da tabela baseada em condiÁ„o
	Uso: 		WebServices
*/
WSMETHOD getTbyWhere WSRECEIVE Alias , Where , rInit , rEnd, rDeleted , rRecno WSSEND Table WSSERVICE ubtdnTView

	Local adbQuery		:= Array(0)
	
	Local bWhere

	Local cAlias
	Local cQuery
	Local cRecno
	Local cSQLName
	Local cRddName
	
	Local lEXIT
	Local lQuery		:= .T.
	Local lWsMethodRet	:= .T.

	Local nOrder
	Local nRecno
	Local nNextRecno

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		IF Empty(self:Alias)
			UserException( STR0010 + self:Alias ) //"Alias invalido: "
		EndIF

		cSQLName := RetSQLName(self:Alias)
		
		IF ( Select(self:Alias) == 0 )
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			Else
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF
		EndIF
		
		cRddName	:= (self:Alias)->( RddName() )
		lQuery		:= ( cRddName == "TOPCONN" )
		
		self:Where		:= AllTrim( self:Where )
		DEFAULT Where	:= self:Where
		Where			:= AllTrim( Where )
		
		IF ( Empty(self:Where) .and. .NOT.( Empty( Where ) ) )
			self:Where := Where
		EndIF

		IF Empty(self:Where)
			UserException( STR0011 + self:Where )	//"Condicao invalida: "
		EndIF

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF
	
		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		obtdnTView				:= WsClassNew("ubtdnTView")
		obtdnTView:Alias		:= self:Alias
		obtdnTView:FieldsName	:= self:FieldsName
		obtdnTView:rDeleted		:= self:rDeleted
		obtdnTView:rRecno		:= self:rRecno

		IF .NOT.( obtdnTView:getTStruct(@Alias,@rDeleted,@rRecno) )
			UserException( STR0008 + self:Alias ) //"Estrutura invalida: "	
		EndIF

		IF ( lQuery )
			IF ( __lAS400 )
				cQuery	:= "SELECT "+self:Alias+".R_E_C_N_O_ NRECNO"
			Else
				cQuery := "SELECT RRN("+cSQLName+") NRECNO "
			EndIF			
			cQuery	+= "  FROM "+cSQLName+" "+self:Alias
			IF ( __lAS400 )
				cQuery	+= " WHERE "+"RRN("+cSQLName+") BETWEEN "+AllTrim(Str(self:rInit))+" AND "+AllTrim(Str(self:rEnd))
			Else
				cQuery	+= " WHERE "+self:Alias+".R_E_C_N_O_ BETWEEN "+AllTrim(Str(self:rInit))+" AND "+AllTrim(Str(self:rEnd))
			EndIF
			IF .NOT.(self:rDeleted)
				IF ( __lAS400 )
					cQuery	+= "   AND "+self:Alias+".@DELETED@<>'*'"
				Else
					cQuery	+= "   AND "+self:Alias+".D_E_L_E_T_<>'*'"
				EndIF	
			EndIF
			cQuery	+= "   AND "+self:Where
    		IF .NOT.( dbQuery(@adbQuery,cQuery,@cAlias) )
				UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
    		ENDIF
		Else
			bWhere	:= &("{||"+self:Where+"}")
			cAlias	:= self:Alias
			(cAlias)->( dbGoTop() )
		EndIF        

		Table       			:= WsClassNew("uTableView")
		self:Table				:= Table
		
		self:Table:TableStruct	:= obtdnTView:TableStruct
		self:Table:TableData	:= Array(0)

    	While (cAlias)->( .NOT.( Eof() ) )
    	
	    	IF ( lQuery )
	    		nRecno	:= (cAlias)->NRECNO
	    	Else
				lEXIT	:= .NOT.(GetNextRecno(@cAlias,@nNextRecno,@nRecno,@nOrder))
				IF (lEXIT)
					EXIT
				ENDIF
	    		IF (cAlias)->( .NOT.( Eval( bWhere ) ) )
					lExit := .NOT.(GotoNextRecno(@cAlias,@nNextRecno,@nOrder))
					IF ( lExit )
						EXIT
					EndIF
					Loop
	    		EndIF
	    	EndIF	

			IF ( nRecno > 0 )
				obtdnTView:rInit	:= nRecno
				obtdnTView:rEnd 	:= nRecno
				IF ( obtdnTView:getTData(@Alias,@nRecno,@nRecno,@rDeleted,@rRecno) )
					aEval( obtdnTView:TableData , { |e| aAdd( self:Table:TableData , e ) } )					
				EndIF
			EndIF	

			IF ( lQuery )
				(cAlias)->(dbSkip())
			Else
				lExit := .NOT.(GotoNextRecno(@cAlias,@nNextRecno,@nOrder))
				IF ( lExit )
					EXIT
				EndIF
			EndIF	

		End While
		
	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION
	
	aEval( adbQuery , { |cAlias| IF( ( Select( cAlias ) > 0 ) , (cAlias)->( dbCloseArea() ) , NIL ) } )

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTStruct
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem a estrutura da tabela
	Uso: 		WebServices
*/
WSMETHOD getTStruct WSRECEIVE Alias , rDeleted , rRecno WSSEND TableStruct WSSERVICE ubtdnTView

	Local aFields
	Local adbStruct
	Local aFieldsName
	
	Local cAlias
	Local cDBSType
	Local cSQLName

	Local cX3Titulo
	Local cX3Descric
	
	Local lWsMethodRet	:= .T.
	
	Local nAT
	Local nField
	Local nFields

	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		IF Empty(self:Alias)
			UserException( STR0010 + self:Alias ) //"Alias invalido: "
		EndIF
		
		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		cSQLName := RetSQLName(self:Alias)
		
		IF ( Select(self:Alias) == 0 )
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			Else
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF
		EndIF	

		TableStruct			:= Array(0)
		self:TableStruct	:= TableStruct

		adbStruct	:= (self:Alias)->(dbStruct())

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		aFieldsName := self:FieldsName:uFldName
		IF (ValType(aFieldsName)=="A") .and. .NOT.(Empty(aFieldsName))
			aFields	:= Array(0)
			nFields	:= Len(aFieldsName)	
			For nField := 1 To nFields
				nAT	:= aScan(adbStruct,{|e|AllTrim(e[DBS_NAME])==Upper(AllTrim(aFieldsName[nField]))})
				IF ( nAT > 0 )
					aAdd(aFields,adbStruct[nAT])
				EndIF	
			Next nField
			IF Empty(aFields)
				aFields	:= adbStruct
			EndIF
		Else
			aFields	:= adbStruct
		EndIF

		nFields		:= Len(aFields)
		
		#IFDEF SPANISH
			cX3Titulo	:= "X3_TITSPA"
			cX3Descric	:= "X3_DESCSPA"
        #ELSE
        	#IFDEF ENGLISH
				cX3Titulo	:= "X3_TITENG"
				cX3Descric	:= "X3_DESCENG"
			#ELSE
				cX3Titulo	:= "X3_TITULO"
				cX3Descric	:= "X3_DESCRIC"
			#ENDIF
		#ENDIF

		For nField := 1 To nFields
			aAdd( self:TableStruct , WsClassNew("uFieldStruct") )
			self:TableStruct[nField]:FldName 				:= aFields[nField][DBS_NAME]
			self:TableStruct[nField]:FldType 				:= aFields[nField][DBS_TYPE]
			self:TableStruct[nField]:FldSize 				:= aFields[nField][DBS_LEN ]
			self:TableStruct[nField]:FldDec  				:= aFields[nField][DBS_DEC ]
			self:TableStruct[nField]:FldTitle	 			:= __UTF8(GetSx3Cache(aFields[nField][DBS_NAME],cX3Titulo))
			IF Empty(self:TableStruct[nField]:FldTitle)
				self:TableStruct[nField]:FldTitle			:= aFields[nField][DBS_NAME]
				self:TableStruct[nField]:FldMandatory		:= .F.
				self:TableStruct[nField]:FldDescription		:= aFields[nField][DBS_NAME]
			Else
				self:TableStruct[nField]:FldMandatory		:= X3Obrigat(aFields[nField][DBS_NAME])
				self:TableStruct[nField]:FldDescription		:= __UTF8(GetSx3Cache(aFields[nField][DBS_NAME],cX3Descric))
			EndIF
		Next nField
		
		IF ( self:rDeleted )
			aAdd( self:TableStruct , WsClassNew("uFieldStruct") )
			self:TableStruct[nField]:FldName 		:= "DELETED"
			self:TableStruct[nField]:FldType 		:= "C"
			self:TableStruct[nField]:FldSize 		:= 1
			self:TableStruct[nField]:FldDec  		:= 0
			self:TableStruct[nField]:FldTitle	 	:= "DELETED"
			self:TableStruct[nField]:FldMandatory	:= .F.
			self:TableStruct[nField]:FldDescription	:= "DELETED"
		EndIF

		IF ( self:rRecno )
			aAdd( self:TableStruct , WsClassNew("uFieldStruct") )
			self:TableStruct[nField]:FldName 		:= "RECNO"
			self:TableStruct[nField]:FldType 		:= "N"
			self:TableStruct[nField]:FldSize 		:= 16
			self:TableStruct[nField]:FldDec  		:= 0
			self:TableStruct[nField]:FldTitle	 	:= "RECNO"
			self:TableStruct[nField]:FldMandatory	:= .F.
			self:TableStruct[nField]:FldDescription	:= "RECNO"
		EndIF

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem os campos da tabela
	Uso: 		WebServices
*/
WSMETHOD getTFieldsName WSRECEIVE Alias WSSEND FieldsName WSSERVICE ubtdnTView

	Local adbStruct
	
	Local cAlias
	Local cDBSType
	Local cSQLName

	Local lWsMethodRet	:= .T.
	
	Local nField
	Local nFields

	Local oException

	TRYEXCEPTION
		
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		IF Empty(self:Alias)
			UserException( STR0010 + self:Alias ) //"Alias invalido: "
		EndIF

		cSQLName := RetSQLName(self:Alias)
		
		IF ( Select(self:Alias) == 0 )
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			Else
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF
		EndIF	

		FieldsName			:= WsClassNew("uFieldsName")
		FieldsName:uFldName := Array(0)
		self:FieldsName		:= FieldsName

		adbStruct	:= (self:Alias)->(dbStruct())
		nFields		:= Len( adbStruct )

		For nField := 1 To nFields
			aAdd( self:FieldsName:uFldName , adbStruct[nField][DBS_NAME] )
		Next nField	

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTData
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem os registros da Tabela
	Uso: 		WebServices
*/
WSMETHOD getTData WSRECEIVE Alias , rInit , rEnd , rDeleted , rRecno WSSEND TableData WSSERVICE ubtdnTView

	Local adbQuery	:= Array(0)

	Local aFields
	Local adbStruct
	Local aFieldsAT
	Local aFieldsName
	
	Local cValue
	Local cAlias
	Local cQuery
	Local cRecno
	Local cField
	Local cDBSType
	Local cSQLName
	Local cRDDName
	
	Local lQuery		:= .T.
	Local lSetDeleted	:= Set(_SET_DELETED,"ON")
	Local lWsMethodRet	:= .T.

	Local nAT
	Local nItens
	Local nRecno
	Local nField
	Local nFields

	Local oException
	
	Local uValue

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		IF Empty(self:Alias)
			UserException( STR0010 + self:Alias ) //"Alias invalido: "	
		EndIF

		cSQLName := RetSQLName(self:Alias)
		
		IF ( Select(self:Alias) == 0 )
			IF .NOT.( MsFile( cSQLName ) )
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			Else
				IF .NOT.( ChkFile(self:Alias) )
					UserException( STR0007 + self:Alias ) //"Problema na abertura da Tabela: "
				EndIF
			EndIF
		EndIF	
		
		cRDDName := (self:Alias)->( RddName() )
		lQuery	 := ( cRDDName == "TOPCONN" )

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF
				
		IF ( self:rEnd < self:rInit )
			uValue 		:= self:rInit
			self:rInit	:= self:rEnd
			rInit		:= self:rInit
			self:rEnd	:= uValue
			rEnd		:= self:rEnd
		EndIF
		
		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF
		
		Set(_SET_DELETED,IF(self:rDeleted,"OFF","ON"))

		IF ( lQuery )
		
			cQuery	:= "SELECT COUNT(1) ITENS "
			cQuery	+= "  FROM "+cSQLName+" "+self:Alias
			IF ( __lAS400 )
				cQuery	+= " WHERE "+"RRN("+cSQLName+") BETWEEN "+AllTrim(Str(self:rInit))+" AND "+AllTrim(Str(self:rEnd))
			Else
				cQuery	+= " WHERE "+self:Alias+".R_E_C_N_O_ BETWEEN "+AllTrim(Str(self:rInit))+" AND "+AllTrim(Str(self:rEnd))
			EndIF
			IF .NOT.(self:rDeleted)
				IF ( __lAS400 )
					cQuery	+= "   AND "+self:Alias+".@DELETED@<>'*'"
				Else
					cQuery	+= "   AND "+self:Alias+".D_E_L_E_T_<>'*'"
				EndIF	
			EndIF
	        
	    	IF .NOT.( dbQuery(@adbQuery,cQuery,@cAlias) )
				UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
	    	ENDIF
	    	
	    	nItens	:= (cAlias)->ITENS
		
		Else
		
			nItens	:= (self:Alias)->(RecCount())
					
		EndIF
		
		IF ( nItens == 0 )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF
		
		TableData		:= Array(0)
		self:TableData	:= TableData
		
		adbStruct	:= (self:Alias)->(dbStruct())

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		aFieldsName := self:FieldsName:uFldName
		IF (ValType(aFieldsName)=="A") .and. .NOT.(Empty(aFieldsName))
			aFields		:= Array(0)
			aFieldsAT	:= Array(0)
			nFields		:= Len(aFieldsName)	
			For nField := 1 To nFields
				nAT	:= aScan(adbStruct,{|e|AllTrim(e[DBS_NAME])==Upper(AllTrim(aFieldsName[nField]))})
				IF ( nAT > 0 )
					aAdd(aFields,adbStruct[nAT])
					aAdd(aFieldsAT,nAT)
				EndIF	
			Next nField
			IF Empty(aFields)
				aFields		:= adbStruct
				aFieldsAT	:= Array(0)
				aEval(aFields,{|x,y|aAdd(aFieldsAT,y)})
			EndIF
		Else
			aFields		:= adbStruct
			aFieldsAT	:= Array(0)
			aEval(aFields,{|x,y|aAdd(aFieldsAT,y)})
		EndIF

		nFields		:= Len(aFields)
		
		IF ( self:rDeleted )
			++nFields
			aAdd(aFields,Array(DBS_ALEN))
			aFields[nFields][DBS_NAME] := "DELETED"
			aFields[nFields][DBS_TYPE] := "C"
			aFields[nFields][DBS_LEN ] := 1
			aFields[nFields][DBS_DEC ] := 0
		EndIF

		IF ( self:rRecno )
			++nFields
			aAdd(aFields,Array(DBS_ALEN))
			aFields[nFields][DBS_NAME] := "RECNO"
			aFields[nFields][DBS_TYPE] := "N"
			aFields[nFields][DBS_LEN ] := 16
			aFields[nFields][DBS_DEC ] := 0
		EndIF

		nItens	:= 0  

		For nRecno := self:rInit To self:rEnd
			IF ( lQuery )
				cRecno	:= AllTrim(Str(nRecno))
				cQuery	:= "SELECT "+cRecno+"  NRECNO "
				cQuery	+= "  FROM "+cSQLName+" "+self:Alias
				IF ( __lAS400 )
					cQuery	+= " WHERE "+"RRN("+cSQLName+")="+cRecno
				Else
					cQuery	+= " WHERE "+self:Alias+".R_E_C_N_O_="+cRecno
				EndIF				
				IF .NOT.(self:rDeleted)
					IF .NOT.(self:rDeleted)
						IF ( __lAS400 )
							cQuery	+= "   AND "+self:Alias+".@DELETED@<>'*'"
						Else
							cQuery	+= "   AND "+self:Alias+".D_E_L_E_T_<>'*'"
						EndIF	
					EndIF
				EndIF
				IF .NOT.( dbQuery(@adbQuery,cQuery,@cAlias) )
					Loop
    			ENDIF
    		EndIF
			(self:Alias)->( dbGoto( nRecno ) )
			IF (self:Alias)->( Eof() .or. Bof() )
				Loop
			EndIF
			++nItens
			aAdd( self:TableData , WsClassNew(/*u*/"FieldView") )
			self:TableData[nItens]:FldTag	:= Array( nFields )
			For nField := 1 To nFields
				cField		:= aFields[nField][DBS_NAME]
				IF ( cField == "DELETED" )
					uValue	:= (self:Alias)->(IF(Deleted(),"*",""))
				ElseIF ( cField == "RECNO" )
					uValue	:= nRecno
				Else
					nAT		:= aFieldsAT[nField]
					uValue 	:= (self:Alias)->(FieldGet(nAT))
					IF ( ( "_USERLG" $ cField ) .or. ( "_USERG" $ cField ) )
						IF .NOT.( Empty(uValue) )
							uValue := (self:Alias)->(FWLeUserLG(cField,1)+"-"+FWLeUserLG(cField,2))
						EndIF
					EndIF
				EndIF
				cDBSType	:= aFields[nField][DBS_TYPE]
				Do Case
				Case ( cDBSType == "N" )
					cValue	:= Str(uValue,aFields[nAT][DBS_LEN],aFields[nAT][DBS_DEC])
				Case ( cDBSType == "D" )
					cValue	:= Dtos( uValue )
				Case ( cDBSType == "L" )
					cValue	:= IF(uValue,".T.",".F.")
				OtherWise
					cValue	:= __UTF8(uValue)
				EndCase
				self:TableData[nItens]:FldTag[nField] := AllTrim(cValue)
			Next nField
		Next nLoop

		IF ( nItens == 0 )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION
	
	aEval( adbQuery , { |cAlias| IF( ( Select( cAlias ) > 0 ) , (cAlias)->( dbCloseArea() ) , NIL ) } )

	Set(_SET_DELETED,IF(lSetDeleted,"ON","OFF"))

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTablebyFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtendo dados e estrutura de uma tabela
	Uso: 		WebServices
*/
WSMETHOD getTablebyFieldsName WSRECEIVE Alias , rInit , rEnd , FieldsName , rDeleted , rRecno WSSEND Table WSSERVICE ubtdnTView

	Local lWsMethodRet	:= .T.

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF

		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF
		
		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		DEFAULT FieldsName		:= self:FieldsName

		IF (Empty(self:FieldsName:uFldName) .and. .NOT.(Empty(FieldsName:uFldName)))
			self:FieldsName	:= FieldsName
		EndIF
		
		IF (Empty(self:FieldsName:uFldName) .or. .NOT.(ValType(self:FieldsName:uFldName)=="A"))
			xmlGetFields(self:FieldsName)
		EndIF    
	
		obtdnTView				:= WsClassNew("ubtdnTView")
		obtdnTView:Alias		:= self:Alias 
		obtdnTView:rInit		:= self:rInit
		obtdnTView:rEnd 		:= self:rEnd
		obtdnTView:FieldsName	:= self:FieldsName
		obtdnTView:rDeleted		:= self:rDeleted
		obtdnTView:rRecno		:= self:rRecno

		IF .NOT.( obtdnTView:getTable(@Alias,@rInit,@rEnd,@rDeleted,@rRecno) )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF
		
		Table		:= obtdnTView:Table
		self:Table	:= Table

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTbyWhereAndFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem dados e estrutura da tabela baseada em condiÁ„o
	Uso: 		WebServices
*/
WSMETHOD getTbyWhereAndFieldsName WSRECEIVE Alias , Where , rInit , rEnd, FieldsName , rDeleted , rRecno WSSEND Table WSSERVICE ubtdnTView

	Local lWsMethodRet	:= .T.

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		self:Where		:= AllTrim( self:Where )
		DEFAULT Where	:= self:Where
		Where			:= AllTrim( Where )
		
		IF ( Empty(self:Where) .and. .NOT.( Empty( Where ) ) )
			self:Where := Where
		EndIF

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF
	
		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF
		
		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		DEFAULT FieldsName		:= self:FieldsName

		IF (Empty(self:FieldsName:uFldName) .and. .NOT.(Empty(FieldsName:uFldName)))
			self:FieldsName	:= FieldsName
		EndIF

		IF (Empty(self:FieldsName:uFldName) .or. .NOT.(ValType(self:FieldsName:uFldName)=="A"))
			xmlGetFields(self:FieldsName)
		EndIF    

		obtdnTView				:= WsClassNew("ubtdnTView")
		obtdnTView:Alias		:= self:Alias 
		obtdnTView:rInit		:= self:rInit
		obtdnTView:rEnd 		:= self:rEnd
		obtdnTView:FieldsName	:= self:FieldsName
		obtdnTView:rDeleted		:= self:rDeleted
		obtdnTView:rRecno		:= self:rRecno
	
		IF .NOT.( obtdnTView:getTbyWhere(@Alias,@Where,@rInit,@rEnd,@rDeleted,@rRecno) )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF

		Table					:= obtdnTView:Table
		self:Table				:= Table
		
	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTStructbyFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem a estrutura da tabela
	Uso: 		WebServices
*/
WSMETHOD getTStructbyFieldsName WSRECEIVE Alias , FieldsName , rDeleted , rRecno WSSEND TableStruct WSSERVICE ubtdnTView

	Local lWsMethodRet	:= .T.

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF
		
		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		DEFAULT FieldsName		:= self:FieldsName

		IF (Empty(self:FieldsName:uFldName) .and. .NOT.(Empty(FieldsName:uFldName)))
			self:FieldsName	:= FieldsName
		EndIF

		IF (Empty(self:FieldsName:uFldName) .or. .NOT.(ValType(self:FieldsName:uFldName)=="A"))
			xmlGetFields(self:FieldsName)
		EndIF    

		obtdnTView				:= WsClassNew("ubtdnTView")		
		obtdnTView:Alias		:= self:Alias 
		obtdnTView:FieldsName	:= self:FieldsName
		
		IF .NOT.( obtdnTView:getTStruct(@Alias,@rDeleted,@rRecno) )
			UserException( STR0008 + self:Alias ) //"Estrutura invalida: "
		EndIF

		TableStruct     		:= obtdnTView:TableStruct
		self:TableStruct		:= TableStruct

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	WsMethod:	getTDatabyFieldsName
	Autor: 		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data: 		21/11/2013
	Descricao:	Obtem os registros da Tabela
	Uso: 		WebServices
*/
WSMETHOD getTDatabyFieldsName WSRECEIVE Alias , rInit , rEnd , FieldsName , rDeleted , rRecno WSSEND TableData WSSERVICE ubtdnTView

	Local lWsMethodRet	:= .T.

	Local obtdnTView
	Local oException

	TRYEXCEPTION
	
		IF .NOT.(Empty(self:Alias))
			self:Alias		:= Upper(AllTrim(self:Alias))
			DEFAULT Alias	:= self:Alias
		EndIF
	
		IF .NOT.(Empty(Alias))
			Alias	:= Upper(AllTrim(Alias))
		EndIF	
		
		IF (Empty(self:Alias) .and. .NOT.(Empty(Alias)))
			self:Alias := Alias
		EndIF

		DEFAULT self:rInit	:= 0
		DEFAULT rInit		:= self:rInit
		IF (Empty(self:rInit) .and. .NOT.(Empty(rInit)))
			self:rInit := rInit
		EndIF
		
		DEFAULT self:rEnd	:= 0
		DEFAULT rEnd		:= self:rEnd
		IF (Empty(self:rEnd) .and. .NOT.(Empty(rEnd)))
			self:rEnd := rEnd
		EndIF

		DEFAULT self:rDeleted	:= .T.
		DEFAULT rDeleted		:= self:rDeleted
		IF .NOT.( rDeleted == self:rDeleted )
			self:rDeleted := rDeleted
		EndIF

		DEFAULT self:rRecno	:= .T.
		DEFAULT rRecno		:= self:rRecno
		IF .NOT.( rRecno == self:rRecno )
			self:rRecno := rRecno
		EndIF

		DEFAULT self:FieldsName	:= WsClassNew("uFieldsName")
		DEFAULT FieldsName		:= self:FieldsName

		IF (Empty(self:FieldsName:uFldName) .and. .NOT.(Empty(FieldsName:uFldName)))
			self:FieldsName	:= FieldsName
		EndIF

		IF (Empty(self:FieldsName:uFldName) .or. .NOT.(ValType(self:FieldsName:uFldName)=="A"))
			xmlGetFields(self:FieldsName)
		EndIF    

		obtdnTView				:= WsClassNew("ubtdnTView")
		obtdnTView:Alias		:= self:Alias 
		obtdnTView:rInit		:= self:rInit
		obtdnTView:rEnd 		:= self:rEnd
		obtdnTView:FieldsName	:= self:FieldsName
		obtdnTView:rDeleted		:= self:rDeleted
		obtdnTView:rRecno		:= self:rRecno
	
		IF .NOT.( obtdnTView:getTData(@Alias,@rInit,@rEnd,@rDeleted,@rRecno) )
			UserException( STR0009 + self:Alias ) //"Nao Existem Registros a Serem Apresentados para a Tabela: "
		EndIF
		
		TableData		:= obtdnTView:TableData
		self:TableData	:= TableData

	CATCHEXCEPTION USING oException

		lWsMethodRet	:= .F.

		SetSoapFault( ProcName() , oException:Description + CRLF + oException:ErrorStack )

	ENDEXCEPTION

Return( lWsMethodRet )

/*
	Progama:	wsubtdnTView.prg
	Funcao:		xmlGetFields
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Obtem os campos baseado na XMLString obtida a partir da WSEXECUTE
    Sintaxe:    xmlGetFields(FieldsName)
*/
Static Function xmlGetFields(FieldsName)
    
	Local axmlFields
	Local aStackParameters

	Local cXMLError
	Local cXMLReplace
	Local cXMLWarning
	Local cXMLString
	
	Local nNode
	Local nItem
	Local nNodes
	Local nItens
	
	Local oXMLString
	
	IF .NOT.(ValType(FieldsName:uFldName)=="A")
		FieldsName:uFldName := Array(0)	
	EndIF

	cXMLString	:= StaticCall(NDJLIB006,ReadStackParameters,"WSEXECUTE","CXMLSTRING","PARAM",NIL,@aStackParameters)
	IF ( ValType(cXMLString) == "C" )
		cXMLString := AllTrim(cXMLString)
		IF .NOT.(Empty(cXMLString))
			cXMLReplace	:= "_"
			cXMLError	:= ""
			cXMLWarning	:= ""
			oXMLString	:= XmlParser(cXMLString,cXMLReplace,@cXMLError,@cXMLWarning)
			axmlFields	:= Array(0)
			IF xmlFieldsName(oXMLString,@axmlFields)
				nNodes := Len(axmlFields)
				For nNode := 1 To nNodes
					IF (ValType(axmlFields[nNode])=="A")
						nItens := Len(axmlFields[nNode])
						For nItem := 1 To nItens							
							aAdd(FieldsName:uFldName,axmlFields[nNode][nItem]:TEXT)
						Next nItem
					ElseIF (ValType(axmlFields[nNode])=="O")
						aAdd(FieldsName:uFldName,axmlFields[nNode]:TEXT)
					EndIF						
				Next nNode
			EndIF
		EndIF
	EndIF
	
Return(NIL)

/*
	Progama:	wsubtdnTView.prg
	Funcao:		xmlFieldsName
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Retorna o Node correspondente a "UFLDNAME"
    Sintaxe:    xmlFieldsName(oXML,axmlFields)
*/
Static Function xmlFieldsName(oXML,axmlFields,cNodeSup)
	
	Local aXML

	Local nNode
	Local nNodes
	
	BEGIN SEQUENCE

		IF .NOT.(ValType(oXML)=="O")
			BREAK
		EndIF
		
		aXML := ClassDataArray(oXML)
		
		DEFAULT cNodeSup := "__cNodeSup__"
		
		IF ("UFLDNAME"$cNodeSup)
			IF ((Len(aXML)>=1) .and. ("STRING"$aXML[1][1]) .and. .NOT.(ValType(aXML[1][2])=="A"))
				aAdd(axmlFields,aXML[1][2])
				BREAK
			EndIF	
		EndIF
		
		nNodes := Len(aXML)
		For nNode := 1 To nNodes
			IF (ValType(aXML[nNode][2])=="O")
				xmlFieldsName(aXML[nNode][2],@axmlFields,aXML[nNode][1])
				IF ("UFLDNAME"$cNodeSup)
					BREAK
				EndIF
			ElseIF (ValType(cNodeSup)=="C")
				IF ("UFLDNAME"$cNodeSup)
					aAdd(axmlFields,aXML[nNode][2])
				EndIF
			EndIF
		Next nNode
		
	END SEQUENCE
		
Return(.NOT.(Empty(axmlFields)))

/*
	Progama:	wsubtdnTView.prg
	Funcao:		dbQuery()
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Providenciar um Alias Valido para Abertura da View
    Sintaxe:    dbQuery(adbQuery,cQuery,cAlias)
*/
Static Function dbQuery(adbQuery,cQuery,cAlias)
	DEFAULT adbQuery	:= Array(0)
	DEFAULT cAlias 		:= GetNextAlias()
	IF ( Select( @cAlias ) > 0 )
		( cAlias )->( dbCloseArea() )
	EndIF
	TCQUERY ( cQuery ) ALIAS ( cAlias ) NEW
	IF ( ValType(adbQuery)=="A" )
		IF ( aScan( adbQuery , { |e| ( e == cAlias ) } ) == 0 )
			aAdd( adbQuery , cAlias )
		EndIF
	EndIF	
Return( .NOT.( ( cAlias )->( Bof() .and. Eof() ) ) )

/*
	Progama:	wsubtdnTView.prg
	Funcao:		__UTF8
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Retira acentuacao e Converte string para UTF8
    Sintaxe:    __UTF8(s)
*/
Static Function __UTF8(s)
	Local cAsc129	:= Chr(129)
	Local cAsc141	:= Chr(141)
	Local cAsc143	:= Chr(143)
	Local cAsc144	:= Chr(144)
	Local cAsc157 	:= Chr(157)
	s := OemToAnsi(s)
	s := fTAcento(s)
	s := ClearChar(s)
	s := NoAcento(s)
	While ( "<" $ s )
		s := StrTran(s,"<","(")
	End While
	While ( ">" $ s )
		s := StrTran(s,">",")")
	End While
	While ( cAsc129 $ s )
		s := StrTran(s,cAsc129,"u")
	End While
	While ( cAsc141 $ s )
		s := StrTran(s,cAsc141,"i")
	End While
	While ( cAsc143 $ s )
		s := StrTran(s,cAsc143,"a")
	End While
	While ( cAsc144 $ s )
		s := StrTran(s,cAsc144,"e")
	End While
	While ( cAsc157 $ s )
		s := StrTran(s,cAsc157,"o")
	End While
	s := EncodeUTF8(s)
Return(s)

/*
	Progama:	wsubtdnTView.prg
	Funcao:		ClearChar
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Retira acentuacao e CRLF
    Sintaxe:    ClearChar( cString )
*/
Static Function ClearChar( cString )

	Local cNewString
	
	Begin Sequence
	
		IF Empty( @cString )
			cNewString := cString 
			Break
		EndIF
	
		cNewString	:=__TAcento( cString )
	
		IF ( Chr( 13 ) $ cNewString )
			cNewString	:= StrTran( cNewString , Chr( 13 ) , "" )
		EndIF
	
		IF ( Chr( 10 ) $ cNewString )
			cNewString	:= StrTran( cNewString , Chr( 10 ) , "" )
		EndIF	
	
	End Sequence

Return( cNewString )

/*
	Progama:	wsubtdnTView.prg
	Funcao:		__TAcento
	Autor:		Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data:		06/11/2013
	Descricao:	Retira acentuacao
    Sintaxe:    ClearChar( cString )
*/
Static Function __TAcento( cStrAnsi )	//Devera estar no Padrao ANSI utilizar a funcao OemToAnsi() para a conversao

	Local cAcento
	Local cAcentos
	Local cNoAcento
	Local cNoAcentos
	Local cStrAnsiNoAc
	
	Local nAcento
	Local nAcentos
	
	Begin Sequence
	
		IF Empty( cStrAnsi )
			cStrAnsiNoAc := cStrAnsi
			Break
		EndIF
	
		cAcentos		:= "√ƒ≈¿‡Â·‰‚„¶‚À»…ÍÈËÎËœÕÃÌÏÔÓ“”÷’ıÙˆÚÛ‹˙¸˘˚—Ò«Á"
		cNoAcentos		:= "AAAAaaaaaaaaEEEeeeeeIIIiiiiOOOOoooooUuuuuNnCc"
	
		cStrAnsiNoAc	:= cStrAnsi	
	
		nAcentos := Len( cAcentos )
		For nAcento := 1 To nAcentos 
			cAcento := SubStr( cAcentos , nAcento , 1 )
			IF ( cAcento $ cStrAnsiNoAc )
				cNoAcento		:= SubStr( cNoAcentos , nAcento , 1 )
				cStrAnsiNoAc	:= StrTran( cStrAnsiNoAc , cAcento , cNoAcento )
			EndIF
		Next nAcento
	
	End Sequence

Return( cStrAnsiNoAc )