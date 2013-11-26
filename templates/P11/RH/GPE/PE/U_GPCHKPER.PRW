#INCLUDE "PROTHEUS.CH"     
/*
	Programa	: U_GPCHKPER.PRW
	Funcao		: U_GPCHKPER()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Ponto de Entrada GPCHKPER executado no  GPER040
				  Chamada a Rotina Customizada de Impressao.
*/ 
USER FUNCTION GPCHKPER()
	
	Local lRet	:= .T.
	Local cFun
	
	IF IsInCallStack("u_btdnGR07")
		cFun := "U_GPER040X"
		IF ( FindFunction(cFun) )
			lRet := &cFun.(,)
		EndIF
	EndIF
	
Return( lRet )