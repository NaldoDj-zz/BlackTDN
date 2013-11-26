#INCLUDE "NDJ.CH"
/*/
	Funcao: 	CN200BUT
	Autor:		Marinaldo de Jesus
	Data:		23/12/2010
	Descricao:	Implementacao do Ponto de Entrada CN200BUT executado a partir da Funcao CN200Manut em CNTA200
				Será utilizado para modificar a query que filtra as informacoes dos Itens de Solicitacao de Compras em Contratos
/*/
User Function CN200BUT()

	Local aButtons		:= {}
	
	Local nOpc			:= ParamIxb[1]

	Local oException

	TRYEXCEPTION
		
        IF !( IsInCallStack("NDJCONTRATOS") )            //Ira executar apenas quando proveniente do Pedido de Compras
			StaticCall( U_CN200SPC , CN200SPCReset )	//Limpa o Cache das Statics em U_CN200SPC
			IF IsInCallStack( "CN100MANUT" )
				//Informacoes sobre o Projeto
                aAdd( aButtons , { { "NDJ_PROJETO_INFO" , { || NDJInfoPrj() } , OemToAnsi( "Informações do Projeto" ) , "Info.Proj." } } )
			EndIF
		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	

	ENDEXCEPTION

Return( aButtons )

/*/
    Funcao:        NDJInfoPrj
	Data:		20/12/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Retorna a Consulta Padrao ao Projeto NDJ e Atualiza Resultados.
/*/
Static Function NDJInfoPrj()

	Local cF3			:= "%CNBF3"
	Local cException
	
	Local oException

	TRYEXCEPTION

		IF ( Type( "oGetDados" ) == "O" )
			Private aHeader	:= oGetDados:aHeader
			Private aCols	:= oGetDados:aCols
			Private n		:= oGetDados:nAt
	    EndIF
	    
        IF !( StaticCall( NDJLIB001 , NDJEvalF3 , @cF3 , .F. , @cException ) )
			UserException( cException )
		EndIF

	CATCHEXCEPTION oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    	ConOut( CaptureError() )
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