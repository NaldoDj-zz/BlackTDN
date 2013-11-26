#INCLUDE "NDJ.CH"
/*/
	Funcao:		U_MT140TOK
	Autor:		Marinaldo de Jesus
	Data:		29/06/2011
	Uso:		Validacao de Todas as Linhas da Pre-Nota de Entrada
	Descricao:  Ponto de Entrada MT140TOK executado em MA140Tudok do Programa MATA140 (Pre-Nota de Entrada)
/*/
User Function MT140TOK()

	Local lTudoOK	:= .T.

	Local nSvn		:= n

	Local nItem
	Local nItens	:= Len( aCols )

	Local oException

	TRYEXCEPTION

		For nItem := 1 To nItens
			n := nItem
			IF !( GdDeleted() )
				lTudoOK := U_MT140LOK()
				IF !( lTudoOK )
					UserException( "Existem Inconsisências na Pré-Nota." + CRLF + "Linha: " + Str( n ) )
				EndIF
			EndIF
		Next nItem

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF	

	ENDEXCEPTION

	n	:= nSvn 

Return( lTudoOK  )

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