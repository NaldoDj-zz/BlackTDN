#INCLUDE "NDJ.CH"
/*/
	Programa:	U_CN130VLIN
	Autor:		Marinaldo de Jesus
	Data:		17/05/2011
	Descricao:	Implementacao do Ponto de Entrada CN130VLIN executado na Funcao CN130LinOk do Programa CNTA130.PRW
	Uso:		Sera usado para validacao especifica na Linha da GetDados
/*/
User Function CN130VLIN()

	Local lLinOK	:= .T.

	Local oException

	TRYEXCEPTION

        IF StaticCall( NDJLIB001 , IsInGetDados , "CNE_XCIRQT" )
			lLinOK	:= StaticCall( U_CNEFLDVLD , CNEXITMCQVld )
			IF !( lLinOK )
				BREAK	
			EndIF	
		EndIF

        lLinOK    := StaticCall( U_NDJBLKSCVL , CNEQuantVld )
		IF !( lLinOK )
			BREAK
		EndIF

        lLinOK    := StaticCall( U_NDJBLKSCVL , CNEQuantVld )
		IF !( lLinOK )
			BREAK
		EndIF

        lLinOK    := StaticCall( U_NDJBLKSCVL , CNEVlUnitVld )
		IF !( lLinOK )
			BREAK
		EndIF

	CATCHEXCEPTION USING oException
	
		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( lLinOK )

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