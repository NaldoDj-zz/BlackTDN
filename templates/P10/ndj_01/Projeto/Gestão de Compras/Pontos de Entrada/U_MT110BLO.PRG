#INCLUDE "NDJ.CH"
/*/
	Funcao: 	MT110BLO
	Autor:		Marinaldo de Jesus
	Data:		30/12/2010
	Descricao:	Salvar a Opcao Selecionada no Processo de Aprovacao
/*/
User Function MT110BLO()

	Local lNotBlocked	:= .T.
	
	Local nOpcA			:= ParamIxb[1]
	
	TRYEXCEPTION

		//Passou pelo Ponto de Entrada MT110BLO
        StaticCall( NDJLIB004 , SetPublic , "__nMT110BLO" , nOpcA , "N" , 1 , .T. )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
		EndIF
	
	ENDEXCEPTION

Return( lNotBlocked )

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