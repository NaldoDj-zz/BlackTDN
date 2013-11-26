#INCLUDE "NDJ.CH"
/*/
	Funcao: 	FT340MNU
	Autor:		Marinaldo de Jesus
	Data:		20/12/2010
	Descricao:	Implementacao do Ponto de Entrada FT340MNU para a tratamento do Menu aRotina programa FATA340
/*/
User Function FT340MNU()

	Local nIndex	:= 0

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJSCDoc" ) )
			BREAK
		EndIF

		IF !( ValType( aRotina ) == "A" )
			UserException( "aRotina not defined in " + ProcName() )
		EndIF

		nIndex		:= aScan( aRotina , { |aElem| Upper( "Ft340Pesqui" ) $ Upper( aElem[2] ) } )
		IF ( nIndex > 0 ) //Achou a Rotina de Pesquisa
			aRotina[ nIndex ][2] := "MsgInfo( 'Opção não Disponível nessa operação do sistema' )"
		EndIF

		IF (;
				LinkedFile();
				.or.;
                IsInCallStack( "NDJPCDoc" );
			)	
			nIndex		:= aScan( aRotina , { |aElem| Upper( "Ft340Inclu" ) $ Upper( aElem[2] ) } )
			IF ( nIndex > 0 ) //Achou a Rotina de Inclusao
				aRotina[ nIndex ][2] := "MsgInfo( 'Opção não Disponível nessa operação do sistema' )"
			EndIF
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
	Funcao: 	LinkedFile
	Autor:		Marinaldo de Jesus
	Data:		20/12/2010
	Descricao:	Verifica se já algum arquivo já foi vinculado a essa solicitacao de Compras
/*/
Static Function LinkedFile( cNumSC , lDeleted )

	Local aArea			:= GetArea()
	
	Local cQuery		:= ""
	Local cTamDoc		:= ""
	Local cNextAlias	:= GetNextAlias()

	Local lLinkedFile	:= .F.
	
	Local nRecno
	Local nTamDoc

	IF !( Type( "cA110Num" ) == "C" )
		cA110Num := ""
	EndIF

	DEFAULT cNumSC		:= cA110Num
	nTamDoc				:= ( GetSx3Cache( "C1_NUM" , "X3_TAMANHO" ) + 2 )
	cTamDoc				:= AllTrim( Str( nTamDoc , 0 ) )

	cQuery	:= "SELECT "
	cQuery	+= "	ACB.R_E_C_N_O_ "
	cQuery	+= " FROM " 
	cQuery	+= 		RetSqlName( "ACB" ) + " ACB "
	cQuery	+= " WHERE "
	cQuery	+= "	ACB.ACB_FILIAL = '" + xFilial("ACB") + "'"
	cQuery	+= " AND "
	cQuery	+= " ( "
	cQuery	+= "	SUBSTRING(ACB.ACB_OBJETO,1,2)='SC' AND SUBSTRING(ACB.ACB_OBJETO,1,"+cTamDoc+")='SC"+cNumSC+"'"
	cQuery	+= " )"
	DEFAULT lDeleted := .T.
	IF ( lDeleted )
		cQuery	+= " AND "
		cQuery	+= "	ACB.D_E_L_E_T_<>'*'
	EndIF

	TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

	nRecno		:= ( cNextAlias )->R_E_C_N_O_
	lLinkedFile	:= !Empty( nRecno )
	IF ( lLinkedFile )
		ACB->( MsGoto( nRecno ) )
	EndIF
	( cNextAlias )->( dbCloseArea() )
	dbSelectArea( "ACB" )

	RestArea( aArea )

Return( lLinkedFile )

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