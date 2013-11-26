#INCLUDE "NDJ.CH"
/*/
	Programa:	MT140COR
	Autor:		Marinaldo de Jesus
	Data:		14/02/2011
	Descricao:	Ponto de Entrada MT140COR. Executado a Partir do MATA140
	Uso:		Sera usado para adicionar novas cores à mBrowse
/*/
User Function MT140COR()
Return( U_MT103COR() )

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