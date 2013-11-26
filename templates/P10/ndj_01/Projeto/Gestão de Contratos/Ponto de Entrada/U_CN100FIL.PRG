#INCLUDE "NDJ.CH"
/*/
	Funcao:		CN100FIL
	Autor:		Marinaldo de Jesus
	Data:		05/11/2011
	Descricao:	Ponto de Entrada CN100FIL, executado na CTA100, sera utilizado para Setar o Filtro para A CN9 Contratos
/*/
User Function CN100FIL()

	Local cCn100Fil
	
	Local oException

	TRYEXCEPTION

		cCn100Fil	:= StaticCall( U_CNTA100F , CNTA100Filter )
		IF !Empty( cCn100Fil )
			cCn100Fil := "@"+cCn100Fil
		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
		EndIF

	ENDEXCEPTION

Return( cCn100Fil )

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