#INCLUDE "NDJ.CH"
/*/
	Funcao:		MA110BAR
	Data:		28/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA110.
				Sera utilizado para:
				1 ) incluir novo botao na EnchoiceBar da SC de forma a permitir a consulta aos valores Orcados/Empenhados;
				2 ) incluir novo botao na EnchoiceBar da SC de forma a permitir a vinculação de Documentos aa SC;
/*/
User Function MA110BAR()

	Local aMyBtns	:= {}

	Local nOpcx		:= ParamIxb[1]

	Local oException
	
	TRYEXCEPTION

		IF ( nOpcx == 5 )
			BREAK
		EndIF

        aAdd( aMyBtns , { "SALARIOS" , { || NDJSwhEmp() } , "Valores Orçados"         , "Orçamento" } )
        aAdd( aMyBtns , { "BMPSDOC"  , { || NDJSCDoc()  } , "Documentos Anexos"    , "Anexos"    } )

	CATCHEXCEPTION oException
	
		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
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
	Local cC1XCodOr
	Local cC1CodOrca
	Local cC1XProjet
	Local cC1XCodSBM
	
	Local cDesOrca
	Local cDesProjet
	Local cDesSBM
	Local cDesOrigem

	Local cFil			:= xFilial( "SC1" , cFilAnt )
	Local cAlias		:= "SC1"

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
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODSBM " );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C1_XCODSBM " ) );
			)
			cC1XCodSBM := GdFieldGet( "C1_XCODSBM " )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C1_XCODSBM " ) )
            cC1XCodSBM := StaticCall(NDJLIB001,GetMemVar, "C1_XCODSBM " )
		ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XCODSBM " ) ) > 0 )
			cC1XCodSBM := SC1->( FieldGet( nFieldPos ) )
		EndIF
		
		cC1XCodSBM := AllTrim( cC1XCodSBM )

		IF Empty( cC1XCodSBM )
			cMsgInfo	:= "Para que a Origem do Recurso seja carregada,"
			cMsgInfo	+= CRLF
			cMsgInfo	+= "Informe o conteúdo do campo " + GetSx3Cache( "C1_XCODSBM" , "X3_TITULO" )
			BREAK
		EndIF

		//Codigo da Origem do Recurso
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODOR" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C1_XCODOR" ) );
			)
			cC1XCodOr := GdFieldGet( "C1_XCODOR" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C1_XCODOR" ) )
            cC1XCodOr := StaticCall(NDJLIB001,GetMemVar, "C1_XCODOR" )
		ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XCODOR" ) ) > 0 )
			cC1XCodOr := SC1->( FieldGet( nFieldPos ) )
		EndIF

		IF Empty( cC1XCodOr )
			cMsgInfo	:= "O Conteúdo para o campo " + GetSx3Cache( "C1_XCODOR" , "X3_TITULO" ) +  " é um conteúdo inválido!"
			BREAK
		EndIF

        StaticCall( U_NDJBLKSCVL , SC1GetInfo , @aGdFields , @aFldsPos , @aFldsGet )

        nTpRet        := NDJ_BLK_GET_ORCAMENTO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nbdgAmount , @nTpRet )
		
        nTpRet        := NDJ_BLK_GET_EMPENHADO
        StaticCall( U_NDJBLKSCVL , FldChkBlk , @cFil , @cAlias , @aGdFields , @aFldsPos , @aFldsGet , @0 , @nCommitted , @nTpRet )

		nAvailable	:= ( nbdgAmount - nCommitted )
		nAvailable	:= Max( 0 , nAvailable )

		//Codigo do Orcamento
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_CODORCA" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C1_CODORCA" ) );
			)
			cC1CodOrca := GdFieldGet( "C1_CODORCA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C1_CODORCA" ) )
            cC1CodOrca := StaticCall(NDJLIB001,GetMemVar, "C1_CODORCA" )
		ElseIF ( SC1->( nFieldPos := FieldPos( "C1_CODORCA" ) ) > 0 )
			cC1CodOrca := SC1->( FieldGet( nFieldPos ) )
		EndIF

		//Codigo do Projeto
		IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XPROJET" );
				.and.;
                !( StaticCall( NDJLIB001 , IsCpoVar ,  "C1_XPROJET" ) );
			)
			cC1XProjet := GdFieldGet( "C1_XPROJET" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "C1_XPROJET" ) )
            cC1XProjet := StaticCall(NDJLIB001,GetMemVar, "C1_XPROJET" )
		ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XPROJET" ) ) > 0 )
			cC1XProjet := SC1->( FieldGet( nFieldPos ) )
		EndIF
        
		nSizeCod	:= Max( nSizeCod , Len( cC1CodOrca ) )
		nSizeCod	:= Max( nSizeCod , Len( cC1XProjet ) )
		nSizeCod	:= Max( nSizeCod , Len( cC1XCodSBM ) )
		nSizeCod	:= Max( nSizeCod , Len( cC1XCodOr  ) )

		cDesOrca	:= AllTrim( PosAlias( "AF1" , cC1CodOrca , NIL , "AF1_DESCRI" , nAF1Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesProjet	:= AllTrim( PosAlias( "AF8" , cC1XProjet , NIL , "AF8_DESCRI" , nAF8Order , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrca ) )
		cDesSBM		:= AllTrim( PosAlias( "SBM" , cC1XCodSBM , NIL , "BM_DESC"	   , nSBMOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesSBM ) )
		cDesOrigem	:= AllTrim( PosAlias( "SZF" , cC1XCodOr  , NIL , "ZF_XDESORI" , nSZFOrder , .F. ) )
		nSizeDesc	:= Max( nSizeDesc , Len( cDesOrigem ) )

		cC1CodOrca	:= PadL( cC1CodOrca , nSizeCod )
		cC1XProjet	:= PadL( cC1XProjet , nSizeCod )
		cC1XCodSBM	:= PadL( cC1XCodSBM , nSizeCod )
		cC1XCodOr	:= PadL( cC1XCodOr  , nSizeCod )

		cMsgInfo	:= PadR( "Orçamento:"			, 19 ) + cC1CodOrca + " :: " + PadR( cDesOrca , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Projeto:"				, 19 ) + cC1XProjet + " :: " + PadR( cDesProjet , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Despesa:"				, 19 ) + cC1XCodSBM + " :: " + PadR( cDesSBM , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Origem do Recurso:"	, 19 ) + cC1XCodOr  + " :: " + PadR( cDesOrigem , nSizeDesc )
		cMsgInfo	+= CRLF
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Orçado:"		   	    , 19 ) + PadR( Transform( nbdgAmount  , "@E 999,999,999,999.99" ) , 18 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Empenhado:"		    , 19 ) + PadR( Transform( nCommitted  , "@E 999,999,999,999.99" ) , 18 )
		cMsgInfo	+= CRLF
		cMsgInfo	+= PadR( "Disponível:"			, 19 ) + PadR( Transform( nAvailable  , "@E 999,999,999,999.99" ) , 18 )

	END SEQUENCE

	IF !Empty( cMsgInfo )
		DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
        StaticCall( NDJLIB001 , DlgMemoEdit , NIL , @cTitle , .F. , NIL , NIL , @cMsgInfo , @oFont )
	EndIF	

Return( NIL )

/*/
    Funcao:        NDJSCDoc
	Data:		20/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Armazenamento e Consulta de Documentos Vinculados a SC.
/*/
Static Function NDJSCDoc()

	Local aIndex		:= {}
	Local cStrLen		:= AllTrim( Str( Len( "SC"+cA110Num ) ) )
	Local cFiltra		:= "@SUBSTRING(ACB_OBJETO,1,"+cStrLen+")='SC"+cA110Num+"' OR SUBSTRING(ACB_OBJETO,1,"+cStrLen+")='sc"+cA110Num+"'"

	Local nC1XAnexo
	Local nC1XPAnexo

	Private bFiltraBrw	:= { || FilBrowse( "ACB" , @aIndex , @cFiltra ) }

	TRYEXCEPTION 
	
		IF !( StaticCall( U_SC1FLDVLD , C1NumVld ) )
			BREAK
		EndIF

		Eval( bFiltraBrw )

			Fata340()

		EndFilBrw( "ACB" , @aIndex )
		
		IF ( StaticCall( U_FT340MNU , LinkedFile , cA110Num ) )
			IF ( IsInGetDados( "C1_XANEXO" ) )
				nC1XAnexo	:= GdFieldPos( "C1_XANEXO" )
				IF ( nC1XAnexo > 0 )
					aEval( aCols , { |aColsn| aColsn[nC1XAnexo] := "CLIPS_PQ" } )
				EndIF
			EndIF
			IF ( IsInGetDados( "C1_XPANEXO" ) )
				nC1XPAnexo	:= GdFieldPos( "C1_XPANEXO" )
				IF ( nC1XPAnexo > 0 )
					aEval( aCols , { |aColsn| aColsn[nC1XPAnexo] := .T. } )
				EndIF
            EndIF
		EndIF

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