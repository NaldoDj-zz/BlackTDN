#INCLUDE "NDJ.CH"
/*/
	Funcao:		MA103BUT
	Data:		03/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA103.
				Sera utilizado incluir novo botao na EnchoiceBar dos DC (Documentos de Entrada) de forma a permitir a consulta aos valores Orcados/Empenhados
/*/
User Function MA103BUT()

	Local aMyBtns	:= {}

	Local oException

	TRYEXCEPTION

        aAdd( aMyBtns , { "SALARIOS" , { || NDJSwhEmp() } , "Valores Orçados" , "Orçamento" } )

	CATCHEXCEPTION oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , FunName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION	

Return( aMyBtns )

/*/
    Funcao:        NDJSwhEmp
	Data:		28/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Disponibilizar o Valor do Orcamento baseado na Origem de Recursos e os Valores
				Previamente Empenhados.
/*/
Static Function NDJSwhEmp()

	Local aFldsPos
	Local aFldsGet
	Local aGdFields

	Local cTitle		:= "Orçamento" 
	Local cMsgInfo 		:= "Dados Não Dispiníveis"
	Local cD1XCodOr
	Local cD1CodOrca
	Local cD1XProjet
	Local cD1XCodSBM
	
	Local cDesOrca
	Local cDesProjet
	Local cDesSBM
	Local cDesOrigem

	Local cFil			:= xFilial( "SD1" , cFilAnt )
	Local cAlias		:= "SD1"

	Local nTpRet
	Local nFieldPos
	Local nAF1Order		:= RetOrder( "AF1" , "AF1_FILIAL+AF1_ORCAME" )
	Local nAF8Order		:= RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" )
	Local nSBMOrder		:= RetOrder( "SBM" , "BM_FILIAL+BM_GRUPO" )
	Local nSZFOrder		:= RetOrder( "SZF" , "ZF_FILIAL+STRZERO(ZF_XCODORI,3)" )

	Local nSizeCod		:= 0
	Local nSizeDesc		:= 0
	Local nbdgAmount
	Local nCommitted
	Local nAvailable

	Local oFont

	BEGIN SEQUENCE

		IF !( Type( "aHeader" ) == "A" )
			BREAK
		EndIF

		IF !( Type( "aCols" ) == "A" )
			BREAK
		EndIF

		//Codigo da Despesa
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODSBM " );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "D1_XCODSBM " ) );
			)
			cD1XCodSBM := GdFieldGet( "D1_XCODSBM " )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "D1_XCODSBM " ) )
            cD1XCodSBM := StaticCall(NDJLIB001,GetMemVar, "D1_XCODSBM " )
		ElseIF ( SD1->( nFieldPos := FieldPos( "D1_XCODSBM " ) ) > 0 )
			cD1XCodSBM := SD1->( FieldGet( nFieldPos ) )
		EndIF
		cD1XCodSBM := AllTrim( cD1XCodSBM )

		IF Empty( cD1XCodSBM )
			cMsgInfo	:= "Para que a Origem do Recurso seja carregada,"
			cMsgInfo	+= CRLF
			cMsgInfo	+= "Informe o conteúdo do campo " + GetSx3Cache( "D1_XCODSBM" , "X3_TITULO" )
			BREAK
		EndIF

		//Codigo da Origem do Recurso
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODOR" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "D1_XCODOR" ) );
			)
			cD1XCodOr := GdFieldGet( "D1_XCODOR" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "D1_XCODOR" ) )
            cD1XCodOr := StaticCall(NDJLIB001,GetMemVar, "D1_XCODOR" )
		ElseIF ( SD1->( nFieldPos := FieldPos( "D1_XCODOR" ) ) > 0 )
			cD1XCodOr := SD1->( FieldGet( nFieldPos ) )
		EndIF

		IF Empty( cD1XCodOr )
			cMsgInfo	:= "O Conteúdo para o campo " + GetSx3Cache( "D1_XCODOR" , "X3_TITULO" ) +  " é um conteúdo inválido!"
			BREAK
		EndIF

        StaticCall( U_NDJBLKSCVL , SD1GetInfo , @aGdFields , @aFldsPos , @aFldsGet )

        nTpRet        := NDJ_BLK_GET_ORCAMENTO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nbdgAmount , @nTpRet )
		
        nTpRet        := NDJ_BLK_GET_EMPENHADO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nCommitted , @nTpRet )

		nAvailable	:= ( nbdgAmount - nCommitted )
		nAvailable	:= Max( 0 , nAvailable )

		//Codigo do Orcamento
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_CODORCA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "D1_CODORCA" ) );
			)
			cD1CodOrca := GdFieldGet( "D1_CODORCA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "D1_CODORCA" ) )
            cD1CodOrca := StaticCall(NDJLIB001,GetMemVar, "D1_CODORCA" )
		ElseIF ( SD1->( nFieldPos := FieldPos( "D1_CODORCA" ) ) > 0 )
			cD1CodOrca := SD1->( FieldGet( nFieldPos ) )
		EndIF

		//Codigo do Projeto
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_XPROJET" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "D1_XPROJET" ) );
			)
			cD1XProjet := GdFieldGet( "D1_XPROJET" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "D1_XPROJET" ) )
            cD1XProjet := StaticCall(NDJLIB001,GetMemVar, "D1_XPROJET" )
		ElseIF ( SD1->( nFieldPos := FieldPos( "D1_XPROJET" ) ) > 0 )
			cD1XProjet := SD1->( FieldGet( nFieldPos ) )
		EndIF
        
		nSizeCod	:= Max( nSizeCod , Len( cD1CodOrca ) )
		nSizeCod	:= Max( nSizeCod , Len( cD1XProjet ) )
		nSizeCod	:= Max( nSizeCod , Len( cD1XCodSBM ) )
		nSizeCod	:= Max( nSizeCod , Len( cD1XCodOr  ) )

		cDesOrca	:= AllTrim( PosAlias( "AF1" , cD1CodOrca , NIL , "AF1_DESCRI" , nAF1Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesProjet	:= AllTrim( PosAlias( "AF8" , cD1XProjet , NIL , "AF8_DESCRI" , nAF8Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesSBM		:= AllTrim( PosAlias( "SBM" , cD1XCodSBM , NIL , "BM_DESC"	   , nSBMOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesSBM ) )
		cDesOrigem	:= AllTrim( PosAlias( "SZF" , cD1XCodOr  , NIL , "ZF_XDESORI" , nSZFOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrigem ) )

		cD1CodOrca	:= PadL( cD1CodOrca , nSizeCod )
		cD1XProjet	:= PadL( cD1XProjet , nSizeCod )
		cD1XCodSBM	:= PadL( cD1XCodSBM , nSizeCod )
		cD1XCodOr	:= PadL( cD1XCodOr  , nSizeCod )

		cMsgInfo	:= PadR( "Orçamento:"			, 19 ) + cD1CodOrca + " :: " + PadR( cDesOrca , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Projeto:"				, 19 ) + cD1XProjet + " :: " + PadR( cDesProjet , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Despesa:"				, 19 ) + cD1XCodSBM + " :: " + PadR( cDesSBM , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Origem do Recurso:"	, 19 ) + cD1XCodOr  + " :: " + PadR( cDesOrigem , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Orçado:"		   	    , 19 ) + PadR( Transform( nbdgAmount  , "@Z 999,999,999.99" ) , 15 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Empenhado:"		    , 19 ) + PadR( Transform( nCommitted  , "@Z 999,999,999.99" ) , 15 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Disponível:"			, 19 ) + PadR( Transform( nAvailable  , "@Z 999,999,999.99" ) , 15 )

	END SEQUENCE

	IF !Empty( cMsgInfo )
		DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
        StaticCall( NDJLIB001 , DlgMemoEdit , NIL , @cTitle , .F. , NIL , NIL , @cMsgInfo , @oFont )
	EndIF	

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