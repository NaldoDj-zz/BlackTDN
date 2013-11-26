#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT120ALT
	Data:		28/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				- Implementação do Ponto de Entrada MT120ALT que srá utilizado para verificar se o Pedido esta bloqueado por
				  Contrato e Nao Permite alteracao	
/*/
User Function MT120ALT()

	Local cMsgHelp
	
	Local lAltera	:= .T.
	
	Local nOpc		:= ParamIxb[1]
	
	Local oException
	
	TRYEXCEPTION
	
		IF ( nOpc <> 2 )
			IF SC7->( C7_CONAPRO == "B" .and. !Empty(C7_XCTNCNB) .and. C7_QUJE>=C7_QUANT )
            	lAltera	:= .F.
            	UserException( "Apenas operação de visualçização poderá ser efetuado para Pedidos Bloquados por Contrato" )
			EndIF
		EndIF
	
	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
		EndIF

	ENDEXCEPTION

Return( lAltera  )

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