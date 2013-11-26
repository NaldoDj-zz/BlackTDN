#INCLUDE "NDJ.CH"
/*/
	Funcao: M160PLAN
	Autor:	Marinaldo de Jesus
	Data:	14/12/2010
	Uso:	Executada MATA160. 
			Sera utilizado adicionar filtro ao Browse da SC8.
/*/
User Function M160PLAN()
	
	Local aRetM160PL		:= ParamIxb[2]

	Local cAliasSC8
	Local aCpoSC8
                        	
	Local lMaMontaCot		:= IsInCallStack( "MaMontaCot" )
	Local lUMata160

	BEGIN SEQUENCE

		IF !( lMaMontaCot )
			BREAK
		EndIF

		lUMata160			:= IsInCallStack( "U_MATA160"  )
		IF !( lUMata160 )
			BREAK
		EndIF

		cAliasSC8			:= ParamIxb[1]
		aCpoSC8				:= ParamIxb[3]

		aRetM160PL[1][PLAN_MARK]	:= "XX"

	END SEQUENCE

Return( aRetM160PL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )