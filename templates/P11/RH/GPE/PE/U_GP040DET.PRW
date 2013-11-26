#INCLUDE "PROTHEUS.CH"     
/*
	Programa	: U_GP040DET.PRW
	Funcao		: U_GP040DET()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 23/06/2013
	Descricao	: Ponto de Entrada GP040DET executado no  GPER040
				  Sera utilizado para verificar se as informacoes
				  foram impressas
*/                          
USER FUNCTION GP040DET()
	
	Local lRet	:= .F.
	
	IF IsInCallStack("u_btdnGR07")
		IF ( Type("__lGP040DET")=="L" )
			__lGP040DET	:= .T.
		Else
			_SetNamedPrvt( "__lGP040DET" , .T. , "u_btdnGR07" )
		EndIF	
	EndIF

Return( lRet )