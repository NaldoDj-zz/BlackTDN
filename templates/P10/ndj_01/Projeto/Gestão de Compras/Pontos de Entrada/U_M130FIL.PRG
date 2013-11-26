#INCLUDE "NDJ.CH"
/*/
	Funcao: M130FIL
	Autor:	Marinaldo de Jesus
	Data:	30/08/2011
	Uso:	Ponto de Entrada M130FIL na Rotina MATA130 na Geracao da Cotacao.
			Sera utilizado para Complementar o Filtro para Disponibilizar as SCs Liberadas para a Geracao da Cotacao
/*/
User Function M130FIL()
	Local cC1MsBlQl		:= Space( GetSx3Cache( "C1_MSBLQL" , "X3_TAMANHO" ) )
	Local cC1Cotacao	:= Space( GetSx3Cache( "C1_COTACAO" , "X3_TAMANHO" ) )
	Local cFiltro		:= ""
	Local lNCotacao		:= MsgYesNo( OemToAnsi( "Deseja Filtrar apenas SCs Não Cotadas?" ) , ProcName() + OemToAnsi( ": Filtro de Cotação" ) )
	cFiltro		+= "("
	cFiltro		+= 		"("
	cFiltro		+= 			"(C1_MSBLQL=='"+cC1MsBlQl+"')"
	cFiltro		+= 			".or."
	cFiltro		+= 			"(C1_MSBLQL=='2')
	cFiltro		+= 		")"
	cFiltro		+= 		".and."
	cFiltro		+= 		"(C1_APROV=='L')
	IF ( lNCotacao )
		cFiltro		+= 		".and."
		cFiltro		+= 		"(C1_COTACAO=='"+cC1Cotacao+"')"
	EndIF	
	cFiltro		+= ")"
Return( cFiltro )

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