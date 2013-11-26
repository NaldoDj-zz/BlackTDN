#INCLUDE "NDJ.CH"
/*/
	Function:	CN120PDM
	Autor:		Marinaldo de Jesus
	Data:		28/12/2010
	Descricao:	Ponto de Entrada apos a gravacao do Pedido de compras pela Rotina Automatica em CN120GrvPeD
				Sera utilizado Gravar informacoes Adicionais ao Pedido de Compras
/*/
User Function CN120PDM( cNumPed , cEspCtr )

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )
	
	Local aStackParam
	
	Local cSC7Filial
	Local cSC7KeySeek
	
	Local lRet			:= .F.
	
	Local nRecno
	Local nRecnos
	Local nSC7Order
		
	Local oException

	TRYEXCEPTION

		IF IsInCallStack( "CN120GrvPeD" )

			lRet	:= ParamIxb[1]

			IF (;
					( Type( "lMsErroAuto" ) == "L" );
					.and.;
					( lMsErroAuto );
				)
				lRet := .F.	//Nao Permite a Geracao do Pedido se ocorreu erro na ExecAuto
				BREAK
			EndIF

		EndIF	
	
		IF !( Type( "__aCNERecnos" ) == "A" )
			BREAK
		EndIF

        DEFAULT cEspCtr := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN120GrvPeD" ) , Upper( "cEspCtr" ) , NIL , NIL , @aStackParam )
		IF !( cEspCtr == "1" )	//Pedido de Compras
			BREAK
		EndIF

        DEFAULT cNumPed        := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "CN120GrvPeD" ) , Upper( "cNumPed" ) , NIL , NIL , @aStackParam )
		cSC7Filial	:= xFilial( "SC7" )
		nSC7Order	:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_CONTRA+C7_CONTREV+C7_PLANILH+C7_MEDICAO+C7_ITEMED" )
		
		SC7->( dbSetOrder( nSC7Order ) )
	
		//Atualizando Informacoes que nao Puderam ser gravadas via ExecAuto
		nRecnos := Len( __aCNERecnos )
		For nRecno := 1 To nRecnos
			CNE->( dbGoto( __aCNERecnos[ nRecno ] ) )
			cSC7KeySeek := cSC7Filial
			cSC7KeySeek += cNumPed
			cSC7KeySeek += CNE->CNE_CONTRA
			cSC7KeySeek += CNE->CNE_REVISA
			cSC7KeySeek += CNE->CNE_NUMERO
			cSC7KeySeek += CNE->CNE_NUMMED
			cSC7KeySeek += CNE->CNE_ITEM
 			IF SC7->( dbSeek( cSC7KeySeek , .F. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_NUMSC"        , CNE->CNE_XNUMSC , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_ITEMSC"    , CNE->CNE_XITMSC , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_SEQUEN"    , CNE->CNE_XSEQPC , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XSZ2COD"    , CNE->CNE_XSZ2CO , .T. )
			EndIF
		Next nRecno
		
		lRet	:= .T.

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF	

	ENDEXCEPTION

	//Forca o Commit das Alteracoes de Empenho
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

	//Forca o Commit das Alteracoes de Destinos	
    StaticCall( U_NDJA002 , SZ4SZ5Commit )

	RestArea( aSC7Area )
	RestArea( aArea )

Return( lRet )

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