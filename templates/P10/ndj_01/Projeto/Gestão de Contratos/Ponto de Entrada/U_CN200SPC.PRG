#INCLUDE "NDJ.CH"

Static __aMarkRec	:= {}
Static __cMarkKey	:= "__cMarkKey"
Static __lAllMark	:= .F.

/*/
	Data:		11/03/2011
	Autor:		Marinaldo de Jesus
	Programa: 	CN200SPC
	Descricao:	Implementacao do Ponto de Entrada CN200SPC chamado a partir da Funcao CN200AddMark no Programa CNTA200.PRW
				Sera utilizado para Para Modificar a Forma de Selecao de Itens do Pedido de Compras na Geracao da Planilha
				de Contratos.
/*/
User Function CN200SPC()
	
	Local aArea
	Local aCNBArea
	
	Local cMarca
	Local aMarca
	Local cCampoOk
	Local cAlias
	
	Local cKey
	Local cKeySeek

	Local cC7Num
	Local cC7Item
	Local cC7Sequen
	Local cC7Produto
	
	Local cCNAContra
	Local cCNARevisa
	
	Local aCNBGD
	Local lCNBGD
	Local lExists
	Local bExists

	Local nPos
	Local nRecno

	Local nCNBOrder
	Local nCNBXNUMPC
	Local nCNBXITMPC
	Local nCNBXSEQPC
	Local nCNBPRODUT
	Local nGdDeleted

	Local oException

	TRYEXCEPTION

		cMarca		:= ParamIxb[1]
		aMarca		:= ParamIxb[2]
		cCampoOk	:= ParamIxb[3]
		cAlias		:= ParamIxb[4]
		
		IF !( cAlias == "SC7" )
			BREAK
		EndIF

        cC7Num		:= StaticCall( NDJLIB001 , __FieldGet , cAlias , "C7_NUM"        , .T. )
        cC7Item		:= StaticCall( NDJLIB001 , __FieldGet , cAlias , "C7_ITEM"        , .T. )
        cC7Sequen	:= StaticCall( NDJLIB001 , __FieldGet , cAlias , "C7_SEQUEN"    , .T. )
        cC7Produto	:= StaticCall( NDJLIB001 , __FieldGet , cAlias , "C7_PRODUTO"    , .T. )

		cKeySeek	:= cC7Num
		cKeySeek	+= cC7Item
		cKeySeek	+= cC7Sequen
		cKeySeek	+= cC7Produto

		cKey 		:= cEmpAnt
		cKey 		+= cFilAnt
		cKey 		+= cC7Num

		IF (;
				!( __lAllMark );
				.or.;
				!( cKey == __cMarkKey );
			)	

			IF !( cKey == __cMarkKey )
				__cMarkKey := cKey
				nRecno	:= ( cAlias )->( Recno() )
				( cAlias )->( dbSkip() )
				cKey	:= cEmpAnt
				cKey	+= cFilAnt
                cKey	+= StaticCall( NDJLIB001 , __FieldGet , cAlias , "C7_NUM" , .T. )
				IF ( __cMarkKey == cKey )
					__lAllMark	:= !( MsgNoYes( "Selecionar item a item?" , "Itens do Pedido" ) )
				EndIF
				( cAlias )->( MsGoto( nRecno ) )
			EndIF

		EndIF

		IF ( __lAllMark )
			BREAK
		EndIF

		nRecno	:= ( cAlias )->( Recno() )
		nPos	:= aScan( aMarca , { |nReg| ( nReg == nRecno ) } )

		IF ( nPos > 0 )

            StaticCall( NDJLIB001 , __FieldPut , cAlias , "C7_OK" , " " , .T. )
			aDel( aMarca , nPos )
			aSize( aMarca , ( Len( aMarca ) - 1 ) )

			nPos	:= aScan( __aMarkRec , { |nReg| ( nReg == nRecno ) } )
			IF ( nPos > 0 )
				aDel( __aMarkRec , nPos )
				aSize( __aMarkRec , ( Len( __aMarkRec ) - 1 ) )
			EndIF
			
			BREAK

		EndIF

		lExists	:= .F.

		IF ( Type( "oGetDados" ) == "O" )

			aCNBGD	:= { "CNB_XNUMPC" , "CNB_XITMPC" , "CNB_XSEQPC" }
            lCNBGD    := StaticCall( NDJLIB001 , IsInGetDados , @aCNBGD , @oGetDados:aHeader , @oGetDados:aCols , oGetDados:nAt )

			IF ( lCNBGD )

				nCNBXNUMPC	:= GdFieldPos( "CNB_XNUMPC" , oGetDados:aHeader )
				nCNBXITMPC	:= GdFieldPos( "CNB_XITMPC" , oGetDados:aHeader )
				nCNBXSEQPC	:= GdFieldPos( "CNB_XSEQPC" , oGetDados:aHeader )
				nCNBPRODUT	:= GdFieldPos( "CNB_PRODUT" , oGetDados:aHeader )
				nGdDeleted	:= GdFieldPos( "GDDELETED"	, oGetDados:aHeader )

				bExists		:= { |x| ( x[nCNBXNUMPC]+x[nCNBXITMPC]+x[nCNBXSEQPC]+x[nCNBPRODUT] == cKeySeek ) .and. !( x[nGdDeleted] ) }
				lExists		:= ( aScan( oGetDados:aCols , bExists ) > 0 )

			EndIF

		EndIF

		IF !( lExists )
		
			IF (;
					( Type( "aHeader" ) == "A" );
					.and.;
					( Type( "aCols" ) == "A" );
				)	
				
                lCNBGD    := StaticCall( NDJLIB001 , IsInGetDados , @aCNBGD , @aHeader , @aCols , 1 )
				
				IF ( lCNBGD )

					nCNBXNUMPC	:= GdFieldPos( "CNB_XNUMPC" )
					nCNBXITMPC	:= GdFieldPos( "CNB_XITMPC" )
					nCNBXSEQPC	:= GdFieldPos( "CNB_XSEQPC" )
					nCNBPRODUT	:= GdFieldPos( "CNB_PRODUT" )
					nGdDeleted	:= GdFieldPos( "GDDELETED" )
	
					lExists	:= ( aScan( aCols , bExists ) > 0 )

				EndIF	

			EndIF	

		EndIF	

		IF !( lExists )
			
			aArea		:= GetArea()
			aCNBArea	:= CNB->( GetArea() )
			
			nCNBOrder	:= RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_XNUMPC+CNB_XITMPC+CNB_XSEQPC+CNB_PRODUT" )
			CNB->( dbSetOrder( nCNBOrder ) )
            cCNAContra	:= StaticCall( NDJLIB001 , __FieldGet , "CNA" , "CNA_CONTRA" , .F. )
            cCNARevisa	:= StaticCall( NDJLIB001 , __FieldGet , "CNA" , "CNA_REVISA" , .F. )
			lExists		:= CNB->( dbSeek( xFilial( "CNB" ) + cCNAContra + cCNARevisa + cKeySeek , .F.  ) )

			RestArea( aCNBArea )
			RestArea( aArea )
		
		EndIF	

		IF !( lExists )
			nPos	:= aScan( __aMarkRec , { |nReg| ( nReg == nRecno ) } )
			lExists	:= ( nPos > 0 )
		EndIF	

		IF ( lExists )
			MsgInfo( "Esse item já foi Selecionado para o Contrato em Questão" , "Atenção!" )
            StaticCall( NDJLIB001 , __FieldPut , cAlias , "C7_OK" , " " , .T. )
			IF ( aScan( aMarca , { |nReg| ( nReg == 0 ) } ) == 0 )
				aAdd( aMarca , 0 )
			EndIF	
			BREAK
		EndIF

		aAdd( aMarca , nRecno )
		aAdd( __aMarkRec , nRecno )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( IF( __lAllMark , NIL , aMarca ) )

/*/
	Data:		11/03/2011
	Autor:		Marinaldo de Jesus
	Funcao: 	CN200SPCReset
	Descricao:	Reinicializa as Statics em U_CN200SPC.PRG
	Sintxe:		StaticCall( U_CN200SPC , CN200SPCReset )
/*/
Static Function CN200SPCReset()

	IF ( ValType( __aMarkRec ) == "A" )
		aSize( __aMarkRec , 0 )
	EndIF	

	__cMarkKey	:= "__cMarkKey"
	__lAllMark	:= .F.

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		CN200SPCReset()
    	lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )
