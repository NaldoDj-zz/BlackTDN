#INCLUDE "NDJ.CH"
/*/
	Function:	CN120ENCMD
	Autor:		Marinaldo de Jesus
	Data:		14/04/2011
	Descricao:	Ponto de Entrada apos a gravacao do Pedido de compras e na Rotina de Encerramento de Medicao CN120MedEnc
/*/
User Function CN120ENCMD()

	Local aStackParam
	
	Local cNumPed
	Local cEspCtr

	Local oException

	TRYEXCEPTION

        cNumPed    := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN120MedEnc" ) , Upper( "cNumPed" ) , NIL , NIL , @aStackParam )
        cEspCtr    := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN120MedEnc" ) , Upper( "cEspCtr" ) , NIL , NIL , @aStackParam )

		U_CN120PDM( @cNumPed , @cEspCtr )
	
	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
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