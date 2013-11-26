#INCLUDE "NDJ.CH"
User Function CN100FOL()

	Local nOpc

	Local oException

	TRYEXCEPTION

		nOpc	:= ParamIxb[1]

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

Return( NIL )

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