#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT150LOK
	Data:		16/08/2011
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MT150LOK.
				Implementação do Ponto de Entrada MT150LOK que srá utilizado para validar a Linha Digitada da GetDados
/*/
User Function MT150LOK()

	Local lLinOk	:= .T.

	BEGIN SEQUENCE

		IF GdDeleted()
			BREAK
		EndIF

		lLinOk := StaticCall(U_SC8FLDVLD,C8PRECOVld)
		IF !( lLinOk )
			BREAK
		EndIF

	END SEQUENCE

Return( lLinOk )

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