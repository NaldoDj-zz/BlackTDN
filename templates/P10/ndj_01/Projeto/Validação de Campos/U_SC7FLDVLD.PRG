#INCLUDE "NDJ.CH"
/*/
	Function:	C7REAJUSTInit
	Autor:		Marinaldo de Jesus
	Data:		28/12/2010
	Descricao:	Inicializador Padrao para o campo C7_REAJUST
	Sintaxe:	StaticCall(U_SC7FLDVLD,C7REAJUSTInit)
/*/
Static Function C7REAJUSTInit()

	Local cCNEAlias
	Local cC7Reajust

	Local oException

	TRYEXCEPTION

		cC7Reajust	:= Space( GetSx3Cache( "C7_REAJUST" , "X3_TAMANHO" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	

	ENDEXCEPTION

Return( cC7Reajust )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		C7REAJUSTINIT()
		lRecursa := __Dummy( .F. )
		__cCRLF	 := NIL	
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )