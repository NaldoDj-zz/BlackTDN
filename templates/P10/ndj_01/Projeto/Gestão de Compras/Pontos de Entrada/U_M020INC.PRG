#INCLUDE "NDJ.CH"
/*/
	Funcao:		M020INC
	Autor:		Marinaldo de Jesus
	Data:		03/03/2011
	Descricao:	Ponto de Entrada Executado na Inclusao de Fornecedor
	Uso:		Sera executado no Processo de Inclusao do Fornecedor para Carregar informacoes Complementares
/*/
User Function M020INC()

	Local aArea		:= GetArea()
	Local oException

	TRYEXCEPTION

		Add4aVisao()

	CATCHEXCEPTION USING oException

		IF ValType( oException ) == "O"
			Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
		EndIF	

	ENDEXCEPTION

	RestArea( aArea )

Return( NIL )

/*/
	Funcao:		Add4aVisao
	Autor:		Marinaldo de Jesus
	Data:		03/03/2011
	Descricao:	Ponto de Entrada Executado na Inclusao de Fornecedor
	Uso:		Sera utilizado para incluir a 4aVisao no CTD
	Sintaxe:	StaticCall( U_M020INC , Add4aVisao , cCTDFilial , c4aVisao )
/*/
Static Function Add4aVisao( cCTDFilial , c4aVisao )

	Local aArea		:= GetArea()
	Local aSA2Area	:= SA2->( GetArea() )
	Local aCTDArea	:= CTD->( GetArea() )

	Local nCTDOrder

	Local oException

	TRYEXCEPTION

        DEFAULT c4aVisao    := StaticCall( NDJLIB001 , __FieldGet , "SA2" , "A2_XVISCTB" , .F. )
		IF Empty( c4aVisao )
			BREAK
		EndIF
		
		DEFAULT cCTDFilial	:= xFilial( "CTD" )
		nCTDOrder	:= RetOrder( "CTD" , "CTD_FILIAL+CTD_ITEM" )
		
		CTD->( dbSetOrder( nCTDOrder ) )

		IF CTD->( dbSeek( cCTDFilial + c4aVisao , .F. ) )
			BREAK
		EndIF	

		IF CTD->( !RecLock( "CTD" , .T. ) )
			BREAK
		EndIF

         StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_FILIAL"    , xFilial( "CTD" ) , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_ITEM"     , c4aVisao , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_ITLP"     , c4aVisao , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_ITSUP"     , "200"    , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_CLASSE"    , "2" , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_CLOBRG"    , "2" , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_ACCLVL"    , "1" , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_DESC01"    , StaticCall( NDJLIB001 , __FieldGet , "SA2" , "A2_NOME" , .F. ) , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_BLOQ"        , "2" , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_DTEXIS"    , Ctod("01/01/1980") , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "CTD" , "CTD_XVISAO"    , "1" , .T. )

		CTD->( MsUnLock() )

	CATCHEXCEPTION USING oException

		IF ValType( oException ) == "O"
			Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
		EndIF	

	ENDEXCEPTION

	RestArea( aCTDArea )
	RestArea( aSA2Area )
	RestArea( aArea )

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