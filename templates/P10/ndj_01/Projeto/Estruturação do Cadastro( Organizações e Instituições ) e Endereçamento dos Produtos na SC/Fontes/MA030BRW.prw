#INCLUDE "NDJ.CH"
/*
	Programa	MA030BRW
	Autor		Rafael Rezende
	Data		01/10/2010
	Ponto de Entrada executado no filtro do mBrowse da Rotina
	Cadastro de Clientes MATA030.PRW com o Objetivo de Filtrar A Loja dos Clientes de acordo com a Regra abaixo:
	SA1->A1_LOA == "00" --> Organizaç£¯
	SA1->A1_LOA != "00" --> Instituiç£¯
*/
User Function MA030BRW()

	Local _cRet 		:= ""                                                    
	
	Local lOrgOrInst    := ( IsInCallStack( "U_NDJA001O" ) .or. IsInCallStack( "U_NDJA001I" ) )
	
	IF !( lOrgOrInst )
		Final( OemToAnsi( "Inclusão de Clientes não Poder ser Feita por Essa Rotina " ) ) 
	EndIF
	
	If _c_p_Tipo_Menu == "O"
		cCadastro := "Cadastro de Organização"
		_cRet 	  := ' SA1->A1_LOJA == "00" '        
	Else
	  	cCadastro := "Cadastro de Instituição"
		_cRet     := ' SA1->A1_LOJA != "00" '        
	End If 

Return _cRet

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
Return( lRecursa )