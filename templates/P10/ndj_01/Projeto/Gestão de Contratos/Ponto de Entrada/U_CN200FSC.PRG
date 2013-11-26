#INCLUDE "NDJ.CH"
/*/
	Funcao: 	CN200FSC
	Autor:		Marinaldo de Jesus
	Data:		23/12/2010
	Descricao:	Implementacao do Ponto de Entrada CN200FSC executado a partir da Funcao CN200SC em CNTA200
				Será utilizado para filtrar as informacoes da Solicitacao de Compras em Contratos
/*/
User Function CN200FSC()

	Local cCn200SCF

	Local oException
	
	TRYEXCEPTION

        IF !( IsInCallStack("NDJCONTRATOS") )    //Ira executar apenas quando proveniente do Pedido de Compras
			BREAK
		EndIF

		cCn200SCF	:= ".F."

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	

	ENDEXCEPTION

Return( cCn200SCF )

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