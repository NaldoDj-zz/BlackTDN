#INCLUDE "NDJ.CH"
/*/
	Funcao: MT160PLN
	Autor:	Marinaldo de Jesus
	Data:	27/10/2010
	Uso:	Executada a partir da A160Analis em MATA160. 
			Sera utilizado para Pre-Selecionar a Cotacao Vencedora.
/*/
User Function MT160PLN()

	Local aPlanilha
	Local aAuditoria
	Local aCotacao
	Local nOpcX
	Local aCpoSC8

	Local lU_MATA160		:= IsInCallStack( "U_MATA160" )

	Local oException

	TRYEXCEPTION

		aPlanilha			:= ParamIxb[1]
		aAuditoria			:= ParamIxb[2]
		aCotacao			:= ParamIxb[3]
		nOpcX     			:= ParamIxb[4]
		aCpoSC8				:= ParamIxb[5]

		IF !( lU_MATA160 )
			BREAK
		EndIF
		
		aPlanilha[1][1][PLAN_MARK]	:= "XX"

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			cMsgHelp += CRLF
			cMsgHelp += oException:ErrorStack
			ConOut( cMsgHelp )
		EndIF

	ENDEXCEPTION

Return( { aPlanilha , aAuditoria } )

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