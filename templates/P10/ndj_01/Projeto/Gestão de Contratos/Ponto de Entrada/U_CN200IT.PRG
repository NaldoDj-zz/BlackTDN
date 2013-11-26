#INCLUDE "NDJ.CH"
/*/
	Funcao: 	CN200IT
	Autor:		Marinaldo de Jesus
	Data:		23/12/2010
	Descricao:	Implementacao do Ponto de Entrada CN200IT executado a partir da Funcao CN200SCIT em CNTA200
				Será utilizado para modificar a query que filtra as informacoes dos Itens de Solicitacao de Compras em Contratos
/*/
User Function CN200IT()

	Local cQuerySc1

	Local oException

	TRYEXCEPTION

        IF !( IsInCallStack("NDJCONTRATOS") )    //Ira executar apenas quando proveniente do Pedido de Compras
			BREAK
		EndIF

		cQuerySc1	:= " C1_FILIAL='@@' "

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	

	ENDEXCEPTION

Return( cQuerySc1 )

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