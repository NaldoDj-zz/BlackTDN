#INCLUDE "NDJ.CH"
#DEFINE STR0001 "Servi&ccedil;o Inclus&atilde;o de Clientes"
#DEFINE STR0002	"Método de inclusão/Alteração de informações do Cliente"

WSSTRUCT tMATA030Ret 
	WSDATA A1_FILIAL	AS STRING
	WSDATA A1_COD		AS STRING
	WSDATA A1_LOJA		AS STRING
ENDWSSTRUCT

WSSTRUCT tMATA030Get
	WSDATA A1_FILIAL	AS STRING
	WSDATA A1_COD		AS STRING
	WSDATA A1_LOJA		AS STRING
	WSDATA A1_NOME		AS STRING
	WSDATA A1_NREDUZ	AS STRING
	WSDATA A1_TIPO		AS STRING
	WSDATA A1_END		AS STRING
	WSDATA A1_T_TPDCP	AS STRING
	WSDATA A1_T_CDDCP	AS STRING
	WSDATA A1_X_MUN		AS STRING
	WSDATA A1_MUN		AS STRING
	WSDATA A1_EST		AS STRING
	WSDATA A1_BAIRRO	AS STRING
	WSDATA A1_CEP		AS STRING
	WSDATA A1_PAIS		AS STRING
	WSDATA A1_CGC		AS STRING
	WSDATA A1_INSCR		AS STRING
	WSDATA A1_CONTA		AS STRING
	WSDATA A1_TPFRET	AS STRING
	WSDATA A1_COND		AS STRING
	WSDATA A1_RISCO		AS STRING
	WSDATA A1_VENCLC	AS DATE
	WSDATA A1_EMAIL		AS STRING
	WSDATA A1_COD_MUN	AS STRING
	WSDATA A1_X_CT		AS STRING
	WSDATA A1_CODPAIS	AS STRING
	WSDATA A1_CONTRIB	AS STRING
ENDWSSTRUCT

WSSERVICE uMATA030 DESCRIPTION STR0001 NAMESPACE "http://www.blacktdn.com.br"  //"Servi&ccedil;o Inclus&atilde;o de Clientes"

	WSDATA GetMATA030	AS tMATA030Get
	WSDATA RetMATA030	AS tMATA030Ret

	WSMETHOD evalMATA030	DESCRIPTION STR0002	//"Método de inclusão/Alteração de informações do Cliente"

ENDWSSERVICE

WSMETHOD evalMATA030 WSRECEIVE GetMATA030 WSSEND RetMATA030 WSSERVICE uMATA030

	Local aErros     		:= Array(0)	
	Local xRotAuto			:= Array(0)
	
	Local cStrErro     		:= ""	
	Local cSA1Filial		:= ""
	
	Local lFound			:= .F.
	Local lAddNew			:= .F.
	Local lReturn			:= .T.	
	
	Local nErro        		:= 0	
	Local nErros			:= 0	
	
	PRIVATE lMsErroAuto    	:= .F.	
	PRIVATE lAutoErrNoFile	:= .T.	
	
	BEGIN SEQUENCE

		::GetMATA030:A1_CGC := UnMaskCNPJ( ::GetMATA030:A1_CGC )
		
		cSA1Filial			:= xFilial( "SA1" )
		
		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )
		lFound	:= SA1->( dbSeek( cSA1Filial + ::GetMATA030:A1_CGC , .F. ) )
		lAddNew	:= .NOT.( lFound )
		
		IF ( lFound )
			::GetMATA030:A1_FILIAL	:= SA1->A1_FILIAL
			::GetMATA030:A1_COD		:= SA1->A1_COD
			::GetMATA030:A1_LOJA	:= SA1->A1_LOJA
		ELSE
			::GetMATA030:A1_FILIAL	:= cSA1Filial
			::GetMATA030:A1_COD		:= gA1Cod(@cSA1Filial)
			::GetMATA030:A1_LOJA	:= CriaVar("A1_LOJA")
			::GetMATA030:A1_CODPAIS := CriaVar("A1_CODPAIS")
			::GetMATA030:A1_CONTA	:= CriaVar("A1_CONTA")
			::GetMATA030:A1_X_CT	:= "OUT"
			::GetMATA030:A1_CONTRIB	:= "2"
			::GetMATA030:A1_VENCLC	:= Ctod("31/12/2999")
			::GetMATA030:A1_T_TPDCP	:= "C"
			::GetMATA030:A1_T_CDDCP	:= ::GetMATA030:A1_X_MUN
		EndIF

		aAdd(xRotAuto,{"A1_FILIAL"	,::GetMATA030:A1_FILIAL,NIL})
		aAdd(xRotAuto,{"A1_COD"		,::GetMATA030:A1_COD,NIL})
		aAdd(xRotAuto,{"A1_LOJA"	,::GetMATA030:A1_LOJA,NIL})
		aAdd(xRotAuto,{"A1_NOME"	,::GetMATA030:A1_NOME,NIL})
		aAdd(xRotAuto,{"A1_NREDUZ"	,::GetMATA030:A1_NREDUZ,NIL})
		aAdd(xRotAuto,{"A1_TIPO"	,::GetMATA030:A1_TIPO,NIL})
		aAdd(xRotAuto,{"A1_END"		,::GetMATA030:A1_END,NIL})
		aAdd(xRotAuto,{"A1_T_TPDCP"	,::GetMATA030:A1_T_TPDCP,NIL})
		aAdd(xRotAuto,{"A1_T_CDDCP"	,::GetMATA030:A1_T_CDDCP,NIL})
		aAdd(xRotAuto,{"A1_X_MUN"	,::GetMATA030:A1_X_MUN,NIL})
		aAdd(xRotAuto,{"A1_MUN"		,::GetMATA030:A1_MUN,NIL})
		aAdd(xRotAuto,{"A1_EST"		,::GetMATA030:A1_EST,NIL})
		aAdd(xRotAuto,{"A1_BAIRRO"	,::GetMATA030:A1_BAIRRO,NIL})
		aAdd(xRotAuto,{"A1_CEP"		,::GetMATA030:A1_CEP,NIL})
		aAdd(xRotAuto,{"A1_PAIS"	,::GetMATA030:A1_PAIS,NIL})
		aAdd(xRotAuto,{"A1_CGC"		,::GetMATA030:A1_CGC,NIL})
		aAdd(xRotAuto,{"A1_INSCR"	,::GetMATA030:A1_INSCR,NIL})
		aAdd(xRotAuto,{"A1_CONTA"	,::GetMATA030:A1_CONTA,NIL})
		aAdd(xRotAuto,{"A1_TPFRET"	,::GetMATA030:A1_TPFRET,NIL})
		aAdd(xRotAuto,{"A1_COND"	,::GetMATA030:A1_COND,NIL})
		aAdd(xRotAuto,{"A1_RISCO"	,::GetMATA030:A1_RISCO,NIL})
		aAdd(xRotAuto,{"A1_VENCLC"	,::GetMATA030:A1_VENCLC,NIL})
		aAdd(xRotAuto,{"A1_EMAIL"	,::GetMATA030:A1_EMAIL,NIL})
		aAdd(xRotAuto,{"A1_COD_MUN"	,::GetMATA030:A1_COD_MUN,NIL})
		aAdd(xRotAuto,{"A1_X_CT"	,::GetMATA030:A1_X_CT,NIL})
		aAdd(xRotAuto,{"A1_CODPAIS"	,::GetMATA030:A1_CODPAIS,NIL})
		aAdd(xRotAuto,{"A1_CONTRIB"	,::GetMATA030:A1_CONTRIB,NIL})

		xRotAuto := WsAutoOpc( xRotAuto )

		MATA030( @xRotAuto , IF( lAddNew , 3 , 4 ) )
	
		IF ( lMsErroAuto )
			aErros 	:= GetAutoGRLog()
			nErros	:= Len( aErros )
			For nErro := 1 To nErros
				cStrErro += ( aErros[ nErro ] + __cCRLF )
			Next nErros
			SetSoapFault( ProcName() , cStrErro )
			lReturn := .F.
			BREAK
		EndIF

		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC" ) ) )

		lFound	:= SA1->( dbSeek( cSA1Filial + ::GetMATA030:A1_CGC , .F. ) )
		
		IF ( lFound )
		
			::RetMATA030	:= WsClassNew( "tMATA030Ret" )
			
			::RetMATA030:A1_FILIAL	:= SA1->A1_FILIAL
			::RetMATA030:A1_COD		:= SA1->A1_COD	
			::RetMATA030:A1_LOJA	:= SA1->A1_LOJA
		
		Else
		
			lReturn 	:= .F.
			SetSoapFault( ProcName() , "Problema na Inclusao do Cliente" )
		
		EndIF	

	END SEQUENCE

Return( lReturn )

Static Function UnMaskCNPJ( cCNPJ )

	Local cCNPJClear := cCNPJ
	
	BEGIN SEQUENCE
		
		IF Empty( cCNPJClear )
			BREAK
		EndIF
	
		cCNPJClear := StrTran( cCNPJClear , "." , "" )
		cCNPJClear := StrTran( cCNPJClear , "/" , "" )
		cCNPJClear := StrTran( cCNPJClear , "-" , "" )
		
		cCNPJClear := AllTrim( cCNPJClear )
	
	END SEQUENCE
	
Return( cCNPJClear )

Static Function gA1Cod(cSA1Filial,cSA1SQLName)
	Local adbQuery	:= Array(0)
	Local cQuery
	Local cSA1Cod
	Local nSaveSX8	:= GetSX8Len() 
	cSA1Cod			:= GetSXENum("SA1","A1_COD")
	While (GetSx8Len()>nSaveSx8)
		ConfirmSX8()
	End While
	DEFAULT cSA1Filial	:= xFilial("SA1")
	DEFAULT cSA1SQLName	:= RetSQLName("SA1")
	cQuery := "SELECT "
	cQuery += cSA1SQLName+".R_E_C_N_O_ "
	cQuery += "  FROM "+cSA1SQLName
	cQuery += " WHERE "
	cQuery += cSA1SQLName+".A1_FILIAL='"+cSA1Filial+"'"
	cQuery += "   AND "
	cQuery += cSA1SQLName+".A1_COD='"+cSA1Cod+"'"
	While dbQuery(@adbQuery,cQuery) 
		nSaveSX8	:= GetSX8Len() 
		cSA1Cod		:= GetSXENum("SA1","A1_COD")
		While (GetSx8Len()>nSaveSx8)
			ConfirmSX8()
		End While
	End While
	dbQueryClear(@adbQuery)
Return(cSA1Cod)

Static Function dbQuery(adbQuery,cQuery,cAlias,lChgQuery,nTCLink)
Return(StaticCall(NDJLIB001,dbQuery,@adbQuery,@cQuery,@cAlias,@lChgQuery,@nTCLink))

Static Function dbQueryClear(adbQuery)
Return(StaticCall(NDJLIB001,dbQueryClear,@adbQuery))