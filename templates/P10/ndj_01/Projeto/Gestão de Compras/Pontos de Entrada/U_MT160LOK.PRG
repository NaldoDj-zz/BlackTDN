#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT160LOK
	Data:		16/08/2011
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MT160LOK.
				Implementação do Ponto de Entrada MT160LOK que srá utilizado para validar a Linha Digitada da GetDados
/*/
User Function MT160LOK()

	Local cReadVar	:= __ReadVar

	Local lLinOk	:= .T.

	BEGIN SEQUENCE

		IF GdDeleted()
			BREAK
		EndIF

        IF ( StaticCall( NDJLIB001 , IsInGetDados , { "C8_TOTAL" } ) )
			__ReadVar		:= "M->C8_TOTAL"
			&( __ReadVar )	:= GdFieldGet( "C8_TOTAL" )
			IF ExistTrigger( "C8_TOTAL" ) 
				RunTrigger( 1 , NIL , NIL , NIL , "C8_TOTAL" )
			EndIF	
			lLinOk			:= CheckSX3( "C8_TOTAL" , &( ReadVar() ) )
			IF !( lLinOk )
				BREAK
			EndIF
		EndIF

	END SEQUENCE

	__ReadVar		:= cReadVar

Return( lLinOk )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )
