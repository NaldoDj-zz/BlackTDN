#INCLUDE "NDJ.CH"
/*/
	Programa:	U_CN130TOK
	Autor:		Marinaldo de Jesus
	Data:		17/05/2011
	Descricao:	Implementacao do Ponto de Entrada CN130TOK executado na Funcao CN130TudOk do Programa CNTA130.PRW
	Uso:		Sera usado para validacao especifica na Linha da GetDados
/*/
User Function CN130TOK()

	Local lTudoOk	:= .T.

	Local nItem
	Local nItens

	Local nSvN		:= n

	Local oException

	TRYEXCEPTION

		nItens	:= Len( aCols )
		For nItem := 1 To nItens
			n := nItem
			lTudoOk	:= U_CN130VLIN()
			IF !( lTudoOk )
				BREAK
			EndIF
		Next nItem

	CATCHEXCEPTION USING oException
	
		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

	IF ( lTudoOk )
		n	:= nSvN
	EndIF

Return( lTudoOk )

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