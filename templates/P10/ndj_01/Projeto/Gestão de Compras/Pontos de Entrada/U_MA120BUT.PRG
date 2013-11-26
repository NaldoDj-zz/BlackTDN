#INCLUDE "NDJ.CH"
/*/
	Funcao:		MA120BUT
	Data:		28/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				Sera utilizado incluir novo botao na EnchoiceBar da PC de forma a permitir a consulta aos valores Orcados/Empenhados
/*/
User Function MA120BUT()

	Local aMyBtns	:= {}
	
	Local oException

	TRYEXCEPTION

        aAdd( aMyBtns , { "SALARIOS" , { || NDJSwhEmp() } , "Valores Orçados"         , "Orçamento" } )
        aAdd( aMyBtns , { "BMPSDOC"  , { || NDJPCDoc()  } , "Documentos Anexos"    , "Anexos"    } )

	CATCHEXCEPTION oException
	
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
	Local cC7XCodOr
	Local cC7CodOrca
	Local cC7XProjet
	Local cC7XCodSBM
	
	Local cDesOrca
	Local cDesProjet
	Local cDesSBM
	Local cDesOrigem

	Local cFil			:= xFilial( "SC7" , cFilAnt )
	Local cAlias		:= "SC7"

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

	BEGIN SEQUENCE

		IF !( Type( "aHeader" ) == "A" )
			BREAK
		EndIF

		IF !( Type( "aCols" ) == "A" )
			BREAK
		EndIF

		//Codigo da Despesa
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_XCODSBM " );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C7_XCODSBM " ) );
			)
			cC7XCodSBM := GdFieldGet( "C7_XCODSBM " )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C7_XCODSBM " ) )
            cC7XCodSBM := StaticCall(NDJLIB001,GetMemVar, "C7_XCODSBM " )
		ElseIF ( SC7->( nFieldPos := FieldPos( "C7_XCODSBM " ) ) > 0 )
			cC7XCodSBM := SC7->( FieldGet( nFieldPos ) )
		EndIF

		IF Empty( cC7XCodSBM )
			cMsgInfo	:= "Para que a Origem do Recurso seja carregada,"
			cMsgInfo	+= CRLF
			cMsgInfo	+= "Informe o conteúdo do campo " + GetSx3Cache( "C7_XCODSBM" , "X3_TITULO" )
			BREAK
		EndIF

		//Codigo da Origem do Recurso
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_XCODOR" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C7_XCODOR" ) );
			)
			cC7XCodOr := GdFieldGet( "C7_XCODOR" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C7_XCODOR" ) )
            cC7XCodOr := StaticCall(NDJLIB001,GetMemVar, "C7_XCODOR" )
		ElseIF ( SC7->( nFieldPos := FieldPos( "C7_XCODOR" ) ) > 0 )
			cC7XCodOr := SC7->( FieldGet( nFieldPos ) )
		EndIF

		IF Empty( cC7XCodOr )
			cMsgInfo	:= "O Conteúdo para o campo " + GetSx3Cache( "C7_XCODOR" , "X3_TITULO" ) +  " é um conteúdo inválido!"
			BREAK
		EndIF

        StaticCall( U_NDJBLKSCVL , SC7GetInfo , @aGdFields , @aFldsPos , @aFldsGet )

        nTpRet        := NDJ_BLK_GET_ORCAMENTO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nbdgAmount , @nTpRet )
		
        nTpRet        := NDJ_BLK_GET_EMPENHADO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nCommitted , @nTpRet )

		nAvailable	:= ( nbdgAmount - nCommitted )
		nAvailable	:= Max( 0 , nAvailable )

		//Codigo do Orcamento
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_CODORCA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C7_CODORCA" ) );
			)
			cC7CodOrca := GdFieldGet( "C7_CODORCA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C7_CODORCA" ) )
            cC7CodOrca := StaticCall(NDJLIB001,GetMemVar, "C7_CODORCA" )
		ElseIF ( SC7->( nFieldPos := FieldPos( "C7_CODORCA" ) ) > 0 )
			cC7CodOrca := SC7->( FieldGet( nFieldPos ) )
		EndIF

		//Codigo do Projeto
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_XPROJET" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C7_XPROJET" ) );
			)
			cC7XProjet := GdFieldGet( "C7_XPROJET" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C7_XPROJET" ) )
            cC7XProjet := StaticCall(NDJLIB001,GetMemVar, "C7_XPROJET" )
		ElseIF ( SC7->( nFieldPos := FieldPos( "C7_XPROJET" ) ) > 0 )
			cC7XProjet := SC7->( FieldGet( nFieldPos ) )
		EndIF
        
		nSizeCod	:= Max( nSizeCod , Len( cC7CodOrca ) )
		nSizeCod	:= Max( nSizeCod , Len( cC7XProjet ) )
		nSizeCod	:= Max( nSizeCod , Len( cC7XCodSBM ) )
		nSizeCod	:= Max( nSizeCod , Len( cC7XCodOr  ) )

		cDesOrca	:= AllTrim( PosAlias( "AF1" , cC7CodOrca , NIL , "AF1_DESCRI" , nAF1Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesProjet	:= AllTrim( PosAlias( "AF8" , cC7XProjet , NIL , "AF8_DESCRI" , nAF8Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesSBM		:= AllTrim( PosAlias( "SBM" , cC7XCodSBM , NIL , "BM_DESC"	   , nSBMOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesSBM ) )
		cDesOrigem	:= AllTrim( PosAlias( "SZF" , cC7XCodOr  , NIL , "ZF_XDESORI" , nSZFOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrigem ) )

		cC7CodOrca	:= PadL( cC7CodOrca , nSizeCod )
		cC7XProjet	:= PadL( cC7XProjet , nSizeCod )
		cC7XCodSBM	:= PadL( cC7XCodSBM , nSizeCod )
		cC7XCodOr	:= PadL( cC7XCodOr  , nSizeCod )

		cMsgInfo	:= PadR( "Orçamento:"			, 31 ) + cC7CodOrca + " :: " + PadL( cDesOrca , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Projeto:"				, 36 ) + cC7XProjet + " :: " + PadL( cDesProjet , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Despesa:"				, 27 ) + cC7XCodSBM + " :: " + PadL( cDesSBM , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Origem do Recurso:"	, 19 ) + cC7XCodOr  + " :: " + PadL( cDesOrigem , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadL( "Orçado:"		   	    , 18 ) + PadL( Transform( nbdgAmount  , "@E 999,999,999,999.99" ) , 18 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadL( "Empenhado:"		    , 15 ) + PadL( Transform( nCommitted  , "@E 999,999,999,999.99" ) , 18 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadL( "Disponível:"			, 18 ) + PadL( Transform( nAvailable  , "@E 999,999,999,999.99" ) , 18 )

	END SEQUENCE

	IF !Empty( cMsgInfo )
		MsgInfo( OemToAnsi( cMsgInfo ) , cTitle )
	EndIF	

Return( NIL )

/*/
    Funcao:        NDJSCDoc
	Data:		20/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Consulta de Documentos Vinculados a SC.
/*/
Static Function NDJPCDoc()

	Private cA110Num

	IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" );
			.and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "C7_NUMSC" ) );
		)
		cA110Num := GdFieldGet( "C7_NUMSC" )
    ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C7_NUMSC" ) )
        cA110Num := StaticCall(NDJLIB001,GetMemVar, "C7_NUMSC" )
	Else
		cA110Num := Space( GetSx3Cache( "C7_NUMSC" , "X3_TAMANHO" ) )
	EndIF

Return( StaticCall( U_MA110BAR , NDJSCDoc ) )

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