#INCLUDE "NDJ.CH"
User Function MA030BUT()

	Local aButtons		:= {}
	
	Local lOrgOrInst
	Local lA030Inclui

	Local oException
	
	TRYEXCEPTION

		lA030Inclui		:= IsInCallStack( "A030Inclui" )
        lOrgOrInst        := ( IsInCallStack( "U_NDJA001O" ) .or. IsInCallStack( "U_NDJA001I" ) )
		
		IF (;
				( lA030Inclui );
				.and.;
				!( lOrgOrInst );
			)	
			UserException( "Inclusão de Clientes não Poder ser Feita por Essa Rotina " )
		EndIF	

	CATCHEXCEPTION USING oException
	
		IF ( ValType( oException ) == "O" )
			Final( OemToAnsi( oException:Description ) ) 
		EndIF	
	
	ENDEXCEPTION

Return( aButtons )

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