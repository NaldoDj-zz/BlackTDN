#INCLUDE "NDJ.CH"
/*/
	Function:	F1FORNECEVld
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo F1_FORNECE
	Sintaxe:	StaticCall(U_SF1FLDVLD,F1FORNECEVld,<cF1FORNECE>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function F1FORNECEVld( cF1FORNECE , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_SD1FLDVLD , D1XVISCTBInit )

		StaticCall( U_XALTHRS , XALTHRS , "SF1" )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "F1_FORNECE" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		F1FORNECEVLD()
		__cCRLF		:= NIL	
		lRecursa	:= __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )