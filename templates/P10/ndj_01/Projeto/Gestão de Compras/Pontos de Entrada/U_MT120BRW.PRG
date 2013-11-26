#INCLUDE "NDJ.CH"

#DEFINE ITEM_CN9NUMERO	1
#DEFINE ITEM_CN9REVISA	2
#DEFINE ITEM_CN9RECNO	3
#DEFINE ITEM_CN9OPC		4
#DEFINE ITEM_CN9PLAN	5
#DEFINE ITEM_CN9PLIT	6

#DEFINE CN9_ITENS		6

/*/
	Funcao: 	MT120BRW
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Descricao:	Implementacao do Ponto de Entrada MT120BRW para a Inclusao de Novas Opcoes no Menu do aRotina do programa MATA120
/*/
User Function MT120BRW()

	Local aMnuPopUP
	
	Local cExecute
	Local cMsgHelp

	Local lChkGrpCnt

	Local nBL
	Local nEL
	
	Local nBPop
	Local nEPop
	
	Local nIndex

	Local oException

	TRYEXCEPTION

        StaticCall( NDJLIB004 , SetPublic , "cNDJSC7FMbr" , NIL , "C" , 0 , .F. )

		IF !( Type( "aRotina" ) == "A" )
			BREAK
		EndIF

		nEL := Len( aRotina )
		For nBL := 1 To nEL
			IF ( aRotina[ nBL ][ 2 ] == "A" )
				nEPop := Len( aRotina[ nBL ][ 2 ] )
				For nBPop := 1 To nEPop
					cExecute := "StaticCall( U_MT120BRW , MATA120 , Alias() , (Alias())->(Recno()) , " + Str( aRotina[ nBL ][ 2 ][ nEPop ][ 4 ] ) + ", '" + aRotina[ nBL ][ 2 ][ nEPop ][ 2 ] +"' )"
					aRotina[ nBL ][ 2 ][ nEPop ][ 2 ] := cExecute
				Next nBPop
			Else
				cExecute := "StaticCall( U_MT120BRW , MATA120 , Alias() , (Alias())->(Recno()) , " + Str( aRotina[ nBL ][ 4 ] ) + ", '" + aRotina[ nBL ][ 2 ] +"' )"
				aRotina[ nBL ][ 2 ]	:= cExecute
			EndIF
		Next nBL

		aMenuPopUp	:= {}

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Solicitar Contrato"	)
        aMenuPopUp[nIndex][2]	:= "StaticCall(U_MT120BRW,NDJContratos,9)"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 2

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Solicitar Aditivo"	)
        aMenuPopUp[nIndex][2]	:= "StaticCall(U_MT120BRW,NDJContratos,9,.T.)"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 2

        lChkCntGrp    := NDJGCTGRP()
		IF ( lChkCntGrp )

			aAdd( aMenuPopUp , Array( 4 ) )
			nIndex 		:= Len( aMenuPopUp )
	
			aMenuPopUp[nIndex][1]	:= OemToAnsi( "Gerar Contrato"	)
            aMenuPopUp[nIndex][2]	:= "StaticCall(U_MT120BRW,NDJContratos,3)"
			aMenuPopUp[nIndex][3]	:= 0
			aMenuPopUp[nIndex][4]	:= 3

		EndIF

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Consultar Contrato"	)
        aMenuPopUp[nIndex][2]	:= "StaticCall(U_MT120BRW,NDJContratos,2)"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 2

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
		aRotina[ nIndex ][1]	:= OemToAnsi( "Contratos" )
		aRotina[ nIndex ][2]	:= aMenuPopUp
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 4

		aMenuPopUp	:= {}

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Filtrar Legenda" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MT120BRW , SC7FiltLeg )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3 

		aAdd( aMenuPopUp , Array( 4 ) )
		nIndex 		:= Len( aMenuPopUp )

		aMenuPopUp[nIndex][1]	:= OemToAnsi( "Limpar Filtro" )
		aMenuPopUp[nIndex][2]	:= "StaticCall( U_MT120BRW , MbrRstFilter )"
		aMenuPopUp[nIndex][3]	:= 0
		aMenuPopUp[nIndex][4]	:= 3

		aAdd( aRotina , Array( 4 ) )
		nIndex 	:= Len( aRotina )
        aRotina[ nIndex ][1]	:= "Filtro &NDJ"
		aRotina[ nIndex ][2]	:= aMenuPopUp
		aRotina[ nIndex ][3]	:= 0
		aRotina[ nIndex ][4]	:= 1

		IF ( IsBuyer() )

			aMenuPopUp	:= {}
			
			aAdd( aMenuPopUp , Array( 4 ) )
			nIndex 		:= Len( aMenuPopUp )

			aMenuPopUp[nIndex][1]	:= OemToAnsi( "Alterar Fornecedor" )
			aMenuPopUp[nIndex][2]	:= "StaticCall( U_MT120BRW , ChgSupplier )"
			aMenuPopUp[nIndex][3]	:= 0
			aMenuPopUp[nIndex][4]	:= 4

			aAdd( aMenuPopUp , Array( 4 ) )
			nIndex 		:= Len( aMenuPopUp )
	
			aMenuPopUp[nIndex][1]	:= OemToAnsi( "Hist.Alteração" )
			aMenuPopUp[nIndex][2]	:= "StaticCall( U_MT120BRW , SC7HChgSupplier )"
			aMenuPopUp[nIndex][3]	:= 0
			aMenuPopUp[nIndex][4]	:= 2

			aAdd( aRotina , Array( 4 ) )
			nIndex 	:= Len( aRotina )
			aRotina[ nIndex ][1]	:= OemToAnsi( "Alt.Fornecedor" )
			aRotina[ nIndex ][2]	:= aMenuPopUp
			aRotina[ nIndex ][3]	:= 0
			aRotina[ nIndex ][4]	:= 4

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

Return( NIL )

/*/
	Funcao:		MATA120
	Autor:		Marinaldo de Jesus
	Data:		20/03/2011
	Descricao:	Chamada as Rotinas do menu
	Sintaxe:	StaticCall( U_MT120BRW , MATA120 , cAlias , nReg , nOpc , cExecute )
/*/
Static Function MATA120( cAlias , nReg , nOpc , cExecute )

	Local uRet

	aRotSetOpc( cAlias , @nReg , nOpc )

	IF ( "(" $ cExecute )
		uRet	:= &cExecute
	Else
		uRet	:= &cExecute.( @cAlias , @nReg , @nOpc )
	EndIF

	//Forca o Commit dos Destinos da SC7
    StaticCall( U_NDJA002 , SZ4SZ5Commit )

	//Libera os Locks Pendentes
    StaticCall( NDJLIB003 , AliasUnLock )

Return( uRet )

/*/
	Funcao:		SC7FiltLeg
	Autor:		Marinaldo de Jesus
	Data:		20/03/2011
	Descricao:	Filtra o Browse de acordo com a Opcao da Legenda da mBrowse
/*/
Static Function SC7FiltLeg()

	Local aGetSC7
	Local aColors
	Local aLegend

	Local cSvExprFilTop

	aGetSC7			:= StaticCall( U_MT120COR , GetC7Status , "SC7" , NIL , .T. )
	aColors			:= aGetSC7[1]
	aLegend			:= aGetSC7[2]

    cSvExprFilTop    := StaticCall( NDJLIB001 , BrwFiltLeg , "SC7" , @aColors , @aLegend , "Solicitação de Compras" , "Legenda" , "Duplo Clique para ativar o Filtro" , "cNDJSC7FMbr" )

Return( cSvExprFilTop )

/*/
	Funcao:		MbrRstFilter
	Autor:		Marinaldo de Jesus
	Data:		20/03/2011
	Descricao:	Restaura o Filtro de Browse
/*/
Static Function MbrRstFilter()
Return( StaticCall( NDJLIB001 , MbrRstFilter , "SC7" , "cNDJSC7FMbr" ) )

/*/
    Funcao: NDJGCTGRP
	Autor:	Marinaldo de Jesus
	Data:	05/01/2011
    Uso:    Verificar se o parametro NDJ_GCTGRP esta setado permitindo a geração de Contratos apenas para
            usuarios pertencentes ao(s) grupo(s) cadastrado(s) no parametro NDJ_GRPGCT.
/*/
Static Function NDJGCTGRP()

    Local aNDJGrpGCT    := {}
	
	Local cUserId

	Local lChkCntGrp	:= .F.
	
	Local nGrp
	Local nGrps

	BEGIN SEQUENCE

        lChkCntGrp    := GetNewPar( "NDJ_GCTGRP" , .F. )
		IF !( lChkCntGrp )
			BREAK
		EndIF

        cUserId      := StaticCall( NDJLIB014 , RetCodUsr )
        aNDJGrpGCT   := StrTokArr( GetNewPar( "NDJ_GRPGCT" , "" ) , ";" )
        nGrps        := Len( aNDJGrpGCT )
		For nGrp := 1 To nGrps
            lChkCntGrp := PswUsrGrp( cUserId , aNDJGrpGCT[ nGrp ] )
			IF ( lChkCntGrp )
				Exit
			EndIF
		Next nGrp 

	END SEQUENCE

Return( lChkCntGrp )

/*/
    Funcao:     NDJContratos
	Autor:		Marinaldo de Jesus
	Data:		22/12/2010
	Descricao:	Chamada a Rotina de Inclusao e/ou Visualizacao de Contratos
/*/
Static Function NDJContratos( nOpc , lAditivo )

	Local aArea			:= GetArea()
	Local aAreaSC7		:= SC7->( GetArea() )
	Local aAreaCN9		:= CN9->( GetArea() )

	Local cAlias		:= "CN9"
	Local cMsgHelp		:= ""
	Local cTypeRet
	Local cCN9Filial	:= xFilial( "CN9" , SC7->C7_FILIAL )
	Local cC7Contrato	:= SC7->C7_XCTNCNB
	Local cC7ContRev	:= SC7->C7_XREVCNB
	Local cCN9KeySeek	:= ( cCN9Filial + cC7Contrato + cC7ContRev )

	Local lFound		:= .F.
	Local lPendente		:= SC7->( ( C7_QUJE == 0 ) .and. ( C7_QTDACLA == 0 ) )
    Local lChkCntGrp    := NDJGCTGRP()

	Local nReg		    := 0
	Local nSC7Recno		:= SC7->( Recno() )
	Local nCN9Order		:= RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )

	Local oException

	Local uRet

	TRYEXCEPTION

		DEFAULT lAditivo	:= .F.

		IF !( nOpc == 2 )
			IF !( lAditivo )
				IF !( lPendente )
					IF ( lChkCntGrp )
						UserException( "O Status desse Pedido de Compras não permite a Geração de Contrato!" )
					Else
						IF ( lAditivo )
							UserException( "O Status desse Pedido de Compras não permite a Solicitação de Aditivo!" )
						Else
							UserException( "O Status desse Pedido de Compras não permite a Solicitação de Contrato!" )
						EndIF	
					EndIF	
				EndIF
			EndIF
		EndIF

		IF ( nOpc <> 4 )

			cC7Contrato	:= SC7->C7_XCTNCNB
			IF Empty( cC7Contrato )
				cC7Contrato	:= SC7->C7_CONTRA
			EndIF
	
			cC7ContRev	:= SC7->C7_XREVCNB
			IF Empty( cC7ContRev )
				cC7ContRev	:= SC7->C7_CONTREV
			EndIF	

		Else

			cC7Contrato	:= CN9->CN9_NUMERO
			cC7ContRev	:= CN9->CN9_REVISA

		EndIF

		cCN9KeySeek	:= ( cCN9Filial + cC7Contrato + cC7ContRev )

		( cAlias )->( dbSetOrder( nCN9Order ) )
		lFound	:= ( cAlias )->( dbSeek( cCN9KeySeek  , .F. ) )
		IF ( lFound )
			nReg := ( cAlias )->( Recno() )
		EndIF

		IF ( nOpc == 2 )
			IF !( lFound )
				UserException( "Não Existe Contrato Vinculado a esse Pedido de Compras." + CRLF + CRLF + "Use a opção 'Gerar Contratos'" )
			EndIF
		ElseIF ( nOpc == 3 )
			IF !( lFound )
				PutFileInEof( cAlias )
				PutFileInEof( "CNC" )
				PutFileInEof( "CNA" )
				PutFileInEof( "CNB" )
				PutFileInEof( "CNH" )
			Else
				nOpc	:= 2
				IF !( MsgYesNo( "Já Existe Contrato Vinculado à esse Pedido. Deseja Visualizá-lo?" , "Atenção" ) )
					BREAK
				EndIF
			EndIF	
		ElseIF ( nOpc == 9 )
			IF (;
					( lFound );
					.and.;
					!( lAditivo );
				)	
				nOpc	:= 2
				IF !( MsgYesNo( "Já Existe Contrato Vinculado à esse Pedido. Deseja Visualizá-lo?" , "Atenção" ) )
					BREAK
				EndIF
			Else
				IF ( lAditivo )
					MSAguarde( { || CNTSendMail( @lAditivo ) } , "Aguarde..." , "Enviando e-mail de Solicitação de Aditivo" , .F. )
				Else
					MSAguarde( { || CNTSendMail() } , "Aguarde..." , "Enviando e-mail de Solicitação de Contrato" , .F. )
				EndIF	
				BREAK
			EndIF
		EndIF

		Private aTela    	:= {}
		Private aGets    	:= {}
		Private aRotina		:= StaticCall( CNTA100 , MenuDef )
		
		uRet				:= CN100Manut( @cAlias , @nReg , @nOpc )
		cTypeRet			:= ValType( uRet )

		DO CASE
			CASE !( cTypeRet $ "L/N" )
				BREAK
			CASE ( ( cTypeRet == "L" ) .and. !( uRet ) )
				BREAK
			CASE ( ( cTypeRet == "N" ) .and. !( uRet == 1 ) )
				BREAK
			CASE ( ( cTypeRet == "N" ) .and. ( uRet == 1 ) .and. CN100Cancel() )
				BREAK
			OTHERWISE
				SC7LinkCN9( @nSC7Recno , @lAditivo )
		END CASE
    
	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

    StaticCall( NDJLIB003 , AliasUnLock )

	MbrChgLoop( .F. )

	RestArea( aAreaCN9 )
	RestArea( aAreaSC7 )
	RestArea( aArea )

Return( uRet )

/*/
	Funcao: 	CN100Cancel
	Autor:		Marinaldo de Jesus
	Data:		25/12/2010
	Descricao:	Verifica se a Inclusao de um Contrato foi Cancelada
	Sintaxe:	StaticCall( U_MT120BRW , CN100Cancel , lSet )
/*/
Static Function CN100Cancel( lSet )

	Local lCancel

	Static lCN100Cancel	:= .F.

	DEFAULT lSet		:= .F.
	lCancel				:= lCN100Cancel
	lCN100Cancel		:= lSet

Return( lCancel )

/*/
	Funcao: 	SC7LinkCN9
	Autor:		Marinaldo de jesus
	Data:		25/12/2010
	Descricao:	Efetua o Link da SC7 com a CN9
	Sintaxe:	StaticCall( U_MT120BRW , SC7LinkCN9 , nSC7Recno )
/*/
Static Function SC7LinkCN9( nSC7Recno , lAditivo )

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )
	Local aCN9Area		:= CN9->( GetArea() )
	Local aCNAArea		:= CNA->( GetArea() )
	Local aCNBArea		:= CNB->( GetArea() )

	Local aUsers
	Local aGroups
	Local aCN9Plan
	Local aCN9PlIt
	Local aCN9UsrGrp
	Local aCpyUsrGrp
    Local aNDJGrpGCT
	Local aCN9GetSetCNT := CN9GetSetCNT()

	Local cMsgHelp
	Local cCN9Numero
	Local cCN9Revisa
	Local cCN9Filial	:= xFilial( "CN9" )
	Local cCNAFilial	:= xFilial( "CNA" )
	Local cCNBFilial	:= xFilial( "CNB" )
	Local cSC7Filial
	Local cCN9KeySeek
	Local cCNAKeySeek
	Local cCNBKeySeek
	Local cSC7KeySeek

	Local nGrp
	Local nGrps
	Local nCN9Opc
	Local nGrpPos
	Local nCN9Recno
	Local nCN9Order			:= RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )
	Local nCNAOrder			:= RetOrder( "CNA" , "CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO" )
	Local nCNBOrder			:= RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM" )
	Local nSC7Order			:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN" )

	TRYEXCEPTION

		DEFAULT lAditivo	:= .F.

		cCN9Numero			:= aCN9GetSetCNT[ITEM_CN9NUMERO]
		cCN9Revisa			:= aCN9GetSetCNT[ITEM_CN9REVISA]
		nCN9Recno			:= aCN9GetSetCNT[ITEM_CN9RECNO]
		nCN9Opc				:= aCN9GetSetCNT[ITEM_CN9OPC]
		aCN9Plan			:= aCN9GetSetCNT[ITEM_CN9PLAN]
		aCN9PlIt			:= aCN9GetSetCNT[ITEM_CN9PLIT]
	
		CN9->( dbSetOrder( nCN9Order ) )
		CNA->( dbSetOrder( nCNAOrder ) )
		SC7->( dbSetOrder( nSC7Order ) )

		cSC7Filial	:= xFilial( "SC7" , SC7->C7_FILIAL )

		IF !( lAditivo )

			SC7->( MsGoto( nSC7Recno ) )
			
			nCNBOrder := RetOrder( "CNB" , "CNB_FILIAL+CNB_XNUMPC+CNB_XITMPC+CNB_XSEQPC" )
			CNB->( dbSetOrder( nCNBOrder ) )

			cSC7KeySeek := cSC7Filial
			cSC7KeySeek	+= SC7->C7_NUM
			IF SC7->( dbSeek( cSC7KeySeek , .F. ) )
				While SC7->( !Eof() .and. C7_FILIAL+C7_NUM == cSC7KeySeek )
					cCNBKeySeek := cCNBFilial
					cCNBKeySeek += SC7->C7_NUM
					cCNBKeySeek += SC7->C7_ITEM
					cCNBKeySeek += SC7->C7_SEQUEN
					IF CNB->( dbSeek( cCNBKeySeek , .F. ) )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XNUMCNB" , CNB->CNB_NUMERO        , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XITMCNB" , CNB->CNB_ITEM        , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCTNCNB" , cCN9Numero            , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XREVCNB" , cCN9Revisa             , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_CONAPRO" , "B"                    , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QUJE"    , SC7->C7_QUANT        , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QTDACLA" , SC7->C7_QUANT        , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_ENCER"   , "E"                    , .T. )
                        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_MSBLQL"  , "1"                    , .T.    )    //Bloqueado
					EndIF
					SC7->( dbSkip() )
				End While
			EndIF

		EndIF
			
		cCN9KeySeek	:= cCN9Filial
		cCN9KeySeek	+= cCN9Numero
		cCN9KeySeek	+= cCN9Revisa

		CN9->( MsGoto( nCN9Recno ) )
		IF CN9->( !MsSeek( cCN9KeySeek , .F. ) )
			BREAK
		EndIF

		aUsers		:= AllUsers()
		aGroups		:= AllGroups()

		aCN9UsrGrp	:= CN240ArrUsr( @cCN9Numero , @aUsers , @aGroups )
		aCpyUsrGrp	:= aClone( aCN9UsrGrp )
        aNDJGrpGCT    := StrTokArr( GetNewPar( "NDJ_GRPGCT" , "" ) , ";" )
        nGrps         := Len( aNDJGrpGCT )
		
		For nGrp := 1 To nGrps
            IF ( aScan( aCN9UsrGrp[2] , {|x| ( x[1] == aNDJGrpGCT[nGrp] ) } ) == 0 )
                nGrpPos    := aScan( aGroups , {|x| ( x[1,1] == aNDJGrpGCT[nGrp] ) } )
				IF ( nGrpPos > 0 )
                    aAdd( aCN9UsrGrp[2] , { aNDJGrpGCT[nGrp] , "001" , aGroups[nGrp,1,2] , "A" } )
				EndIF	
			EndIF	
		Next nGrp
		
		IF !( ArrayCompare( @aCpyUsrGrp , @aCN9UsrGrp ) )
			CN240Grv( @aCN9UsrGrp , @cCN9Numero )
		EndIF	

		cCNAKeySeek	:= cCNAFilial
		cCNAKeySeek	+= cCN9Numero
		cCNAKeySeek	+= cCN9Revisa

		IF CNA->( !dbSeek( cCNAKeySeek , .F. ) )
			BREAK
		EndIF

		cCNBKeySeek	:= cCNBFilial
		cCNBKeySeek	+= cCN9Numero
		cCNBKeySeek	+= cCN9Revisa

		nCNBOrder := RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM" )

		CNB->( dbSetOrder( nCNBOrder ) )

		IF CNB->( !dbSeek( cCNBKeySeek , .F. ) )
			BREAK
		EndIF

		While CNB->( !Eof() .and. CNB_FILIAL+CNB_CONTRA+CNB_REVISA == cCNBKeySeek )
			cSC7KeySeek	:= cSC7Filial
			cSC7KeySeek	+= CNB->CNB_XNUMPC
			cSC7KeySeek	+= CNB->CNB_XITMPC
			cSC7KeySeek	+= CNB->CNB_XSEQPC
			IF SC7->( dbSeek( cSC7KeySeek , .F. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XNUMCNB" , CNB->CNB_NUMERO        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XITMCNB" , CNB->CNB_ITEM        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCTNCNB" , cCN9Numero            , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XREVCNB" , cCN9Revisa             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_CONAPRO" , "B"                    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QUJE"    , SC7->C7_QUANT        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QTDACLA" , SC7->C7_QUANT        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_ENCER"   , "E"                    , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_MSBLQL"  , "1"                    , .T. )    //Bloqueado
			EndIF
			CNB->( dbSkip() )
		End While

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			ConOut( CaptureError() )
		EndIF

	ENDEXCEPTION

	RestArea( aCNBArea )
	RestArea( aCNAArea )
	RestArea( aCN9Area )
	RestArea( aSC7Area )
	RestArea( aArea )

Return( NIL )

/*/
	Funcao: 	CN9GetSetCNT
	Autor:		Marinaldo de jesus
	Data:		25/12/2010
	Descricao:	Obter e/ou Setar a ultima informacao de Contrato e Revisao utilizados
	Sintaxe:	StaticCall( U_MT120BRW , CN9GetSetCNT , cContrato , cRevisa , nRecno , nOpc , aPlan , aPlIt )
/*/
Static Function CN9GetSetCNT( cContrato , cRevisa , nRecno , nOpc , aPlan , aPlIt )

	Local aCN9Plan
	Local aCN9PlIt
	Local aReturn		:= Array( CN9_ITENS )
	
	Local cCN9Numero
	Local cCN9Revisa

	Local nCN9Opc
	Local nCN9Recno
	
	Static cStcCN9Num
	Static cStcCN9Rev
	Static nStcCN9Rec
	Static nStcCN9Opc
	Static aStcCN9Plan
	Static aStcCN9PlIt

	DEFAULT cContrato	:= Space( GetSX3Cache( "CN9_NUMERO" , "X3_TAMANHO" ) )
	DEFAULT cRevisa		:= Space( GetSX3Cache( "CN9_REVISA" , "X3_TAMANHO" ) )
	DEFAULT nRecno		:= 0
	DEFAULT nOpc		:= 0
	DEFAULT aPlan		:= {}
	DEFAULT aPlIt		:= {}

	cCN9Numero	:= cStcCN9Num
	cCN9Revisa	:= cStcCN9Rev
	nCN9Recno	:= nStcCN9Rec
	nCN9Opc		:= nStcCN9Opc
	aCN9Plan	:= aStcCN9Plan
	aCN9PlIt	:= aStcCN9PlIt

	cStcCN9Num	:= cContrato
	cStcCN9Rev	:= cRevisa
	nStcCN9Rec	:= nRecno
	nStcCN9Opc  := nOpc
	aStcCN9Plan := aPlan
	aStcCN9PlIt := aPlIt

	aReturn[ITEM_CN9NUMERO]	:= cCN9Numero
	aReturn[ITEM_CN9REVISA]	:= cCN9Revisa
	aReturn[ITEM_CN9RECNO]	:= nCN9Recno
	aReturn[ITEM_CN9OPC]	:= nCN9Opc
	aReturn[ITEM_CN9PLAN]	:= aCN9Plan
	aReturn[ITEM_CN9PLIT]	:= aCN9PlIt

Return( aReturn )

/*/
	Funcao: CNTSendMail
	Autor:	Marinaldo de Jesus
	Data:	03/01/2011
	Uso:	Envia e-mail de Solicitacao de Contrato
/*/
Static Function CNTSendMail( lAditivo )

	Local aTo			:= {}

	Local cBody
	Local cSubject

	DEFAULT lAditivo	:= .F.

	cBody	:= OemToAnsi( BuildHtml( @lAditivo , .T.  ) )
	IF !Empty( cBody )
        StaticCall( NDJLIB002 , AddMailDest , @aTo , GetNewPar( "NDJ_MAILCT" , GetNewPar("NDJ_EGCT","ndjadvpl@gmail.com") ) )
		IF ( lAditivo )
			cSubject    := "Solicitação de Aditivo Contratual - Pedido Número: " + SC7->C7_NUM
		Else
			cSubject    := "Solicitação de Contrato - Pedido Número: " + SC7->C7_NUM
		EndIF	
        IF !( StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo , NIL , NIL , NIL , .F. ) )
			UserException( "Problema no Envio de e-mail de Contratos. " + CRLF + "Entre em Contato com o Administrador do Sistema." )
		EndIF
	EndIF

Return( NIL )

/*/
	Funcao: BuildHtml
	Autor:	Marinaldo de Jesus
	Data:	03/01/2011
	Uso:	Monta o HTML de Solicitacao de Contrato
/*/
Static Function BuildHtml( lAditivo , lRmvCRLF )

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )
	Local aSC7Recnos	:= {}

	Local cCRLF			:= CRLF
	Local cHtml 		:= ""
	Local cSC7Filial	:= xFilial( "SC7" , SC7->C7_FILIAL )
	Local cSC7Num		:= SC7->C7_NUM
	Local cC7XEquipa
	Local cSC7KeySeek

	Local nRecno
	Local nRecnos
	Local nSC7Recno
	Local nSC7Order		:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM+S7_SEQUEN" )

	SC7->( dbSetOrder( nSC7Order ) )
	
	cSC7KeySeek := cSC7Filial
	cSC7KeySeek += cSC7Num

	BEGIN SEQUENCE

		DEFAULT lAditivo	:= .F.

		IF SC7->( !dbSeek( cSC7KeySeek , .F. ) )
			BREAK
		EndIF

		nRecno	:= SC7->( Recno() )

		While SC7->( !Eof() .and. C7_FILIAL+C7_NUM == cSC7KeySeek )
			SC7->( aAdd( aSC7Recnos , Recno() ) )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCNTSOL" , .T.     )
			IF ( lAditivo )
                StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCNTADT" , .T.     )
			EndIF
			SC7->( dbSkip() )
		End While

		nRecnos	:= Len( aSC7Recnos )
		IF Empty( nRecnos )
			BREAK
		EndIF
		
		SC7->( dbGoto( nRecno ) )

		cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + cCRLF
		cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' + cCRLF 
		cHtml += '	<head>' + cCRLF 
		cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' + cCRLF 
        cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Solicitação de Geração de Contrato</title>' + cCRLF 
		cHtml += '	</head>' + cCRLF 
		cHtml += '	<body bgproperties="0" bottommargin="0" leftmargin="0" marginheight="0" marginwidth="0" >' + cCRLF 
		cHtml += '		<table cellpadding="0" cellspacing="0"  width"100%" border="0" >' + cCRLF 
		cHtml += '			<tr bgcolor="#EEEEEE">' + cCRLF 
		cHtml += '				<td>' + cCRLF 
        cHtml += '                    <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0">' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr bgcolor="#BEBEBE">' + cCRLF 
		cHtml += '				<td height="20">' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr>' + cCRLF 
		cHtml += '				<td>' + cCRLF 
		cHtml += '					<br />' + cCRLF 
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<b>' + cCRLF 
		IF ( lAditivo )
		cHtml += '							SOLICITAÇÃO DE GERAÇÃO DE ADITIVO CONTRATUAL'
		Else
		cHtml += '							SOLICITAÇÃO DE GERAÇÃO DE CONTRATO'
		EndIF
		cHtml += '						</b>' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr>' + cCRLF  
		cHtml += '				<td>' + cCRLF 
		cHtml += '					<p>' + cCRLF 
		cHtml += '						<font face="arial" size="2">' + cCRLF  
		cHtml += '							Prezado(s) Administrador(es) de Contrato,'
		cHtml += '						</font>' + cCRLF 
		cHtml += '						<font face="arial" size="2">' + cCRLF 
		cHtml += '							<br />' + cCRLF
		cHtml += '							<br />' + cCRLF
		IF ( lAditivo )
		cHtml += ' Uma nova Solicitação de Aditivo Contratual foi incluída no sistema com os seguintes dados abaixo:'
		Else
		cHtml += ' Uma nova Solicitação de Contrato foi incluído no sistema com os seguintes dados abaixo:'  
		EndIF
		cHtml += '						</font>' + cCRLF
		cHtml += '						<br />' + cCRLF
		cHtml += '					</p>' + cCRLF 
		cHtml += '				</td>' + cCRLF
		cHtml += '			</tr>' + cCRLF
		cHtml += '			<tr>' + cCRLF
		cHtml += '				<td align="right" valign="top">' + cCRLF 
		cHtml += '					<br />' + cCRLF  
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<table width="100%" border="0" cellspacing="2" cellpadding="0">' + cCRLF
		cHtml += '							<tr>' + cCRLF
		cHtml += '								<td width="18%" height="19" >' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Número do Pedido de Compras:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td width="82%">' + cCRLF 
		cHtml += '									<font size="2" face="arial">' + cCRLF 
		cHtml += cSC7Num
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF 
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Data de Emissão:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>'
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<font size="2" face="arial">' + cCRLF 
		cHtml += Dtoc( dDataBase , "DDMMYYYY" )
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				  			<tr>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				  							Código do Fornecedor'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				  					</b>' + cCRLF 
		cHtml += '				  				</td>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_FORNECE
		cHtml += '									</font>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '							</tr>' + cCRLF
		cHtml += '				  			<tr>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				  							Loja do Fornecedor'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				  					</b>' + cCRLF 
		cHtml += '				  				</td>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_LOJA
		cHtml += '									</font>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '							</tr>' + cCRLF
		cHtml += '				  			<tr>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				  							Nome Fantasia'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				  					</b>' + cCRLF 
		cHtml += '				  				</td>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_XDESFOR
		cHtml += '									</font>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '							</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF 
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Projeto:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>'
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_XPROJET + " - " + PosAlias( "AF8" , SC7->C7_XPROJET , NIL , "AF8_DESCRI" , RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" ) , .F. )  
		cHtml += '				   					</font>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   			</tr>' + cCRLF
		cHtml += '				   			<tr>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				   					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				   							Tarefa:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				   					</b>' + cCRLF 
		cHtml += '				   				</td>' + cCRLF
		cHtml += '				   				<td>' + cCRLF 
		cHtml += '				  					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_XTAREFA  
		cHtml += '				  					</font>' + cCRLF 
		cHtml += '				  				</td>' + cCRLF
		cHtml += '				  			</tr>' + cCRLF
		cHtml += '				  			<tr>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '				  							Centro de Custo:'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '				  					</b>' + cCRLF 
		cHtml += '				  				</td>' + cCRLF
		cHtml += '				  				<td>' + cCRLF 
		cHtml += '				  					<font size="2" face="arial">' + cCRLF 
		cHtml += SC7->C7_CC  
		cHtml += '									</font>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '							</tr>' + cCRLF
		cHtml += '						</table>' + cCRLF
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td>' + cCRLF
		cHtml += '			</tr>' + cCRLF 
		cHtml += '			<tr>' + cCRLF
		cHtml += '				<td colspan="2">' + cCRLF
		cHtml += '					<font face="arial" size="2">' + cCRLF 
		cHtml += '						<table width="100%" border="1" cellspacing="1" cellpadding="2">' + cCRLF
		cHtml += '							<tr  bgcolor="#cccccc">' + cCRLF
		cHtml += '								<td width="60">' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Item'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '											<font face="arial" size="2">' + cCRLF  
		cHtml += '										Código do Produto'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Descrição do Produto'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Unidade'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Quantidade'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Preço Unitário'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Valor Total'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Número da SC'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Item da SC'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '								<td>' + cCRLF 
		cHtml += '									<b>' + cCRLF 
		cHtml += '										<font face="arial" size="2">' + cCRLF  
		cHtml += '											Sequencia do PC'  
		cHtml += '										</font>' + cCRLF  
		cHtml += '									</b>' + cCRLF 
		cHtml += '								</td>' + cCRLF  
		cHtml += '							</tr>' + cCRLF
		For nRecno := 1 To nRecnos
			nSC7Recno	:= aSC7Recnos[ nRecno ]
			SC7->( dbGoto( nSC7Recno ) )
			cHtml += '						<tr>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += SC7->C7_ITEM
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += SC7->C7_PRODUTO
			cHtml += '								</font>' + cCRLF  	
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += SC7->C7_DESCRI
			cHtml += '								</font>' + cCRLF  	
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += SC7->C7_UM
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += Transform( SC7->C7_QUANT , GetSx3Cache( "C7_QUANT" , "X3_PICTURE" ) )
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += Transform( SC7->C7_PRECO  , GetSx3Cache( "C7_PRECO" , "X3_PICTURE" ) )
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += Transform( SC7->C7_TOTAL    , GetSx3Cache( "C7_TOTAL  " , "X3_PICTURE" ) )
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '			  				<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += SC7->C7_NUMSC
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += SC7->C7_ITEMSC
			cHtml += '							</font>' + cCRLF  
			cHtml += '							<td>' + cCRLF 
			cHtml += '								<font face="arial" size="2">' + cCRLF  
			cHtml += SC7->C7_SEQUEN
			cHtml += '								</font>' + cCRLF  
			cHtml += '							</td>' + cCRLF 
			cHtml += '						</tr>' + cCRLF
			cC7XEquipa	:= AllTrim( SC7->C7_XEQUIPA )
			IF !Empty( cC7XEquipa )
				cHtml += '						<tr>' + cCRLF
				cHtml += '								<td colspan="10">' + cCRLF 
				cHtml += '									<b>' + cCRLF 
				cHtml += '										<font face="arial" size="2">' + cCRLF  
				cHtml += '											Especificação Técnica'  
				cHtml += '										</font>' + cCRLF  
				cHtml += '									</b>' + cCRLF 
				cHtml += '								</td>' + cCRLF  
				cHtml += '						</tr>' + cCRLF
				cHtml += '						<tr>' + cCRLF
				cHtml += '								<td colspan="10">' + cCRLF 
				cHtml += '									<b>' + cCRLF 
				cHtml += '										<font face="arial" size="2">' + cCRLF  
				cHtml += cC7XEquipa
				cHtml += '										</font>' + cCRLF  
				cHtml += '									</b>' + cCRLF 
				cHtml += '								</td>' + cCRLF  
				cHtml += '						</tr>' + cCRLF
	    	EndIF
		Next nRecno
		cHtml += '						</table>' + cCRLF
		cHtml += '						<hr/>' + cCRLF
		cHtml += '					</font>' + cCRLF 
		cHtml += '				</td">' + cCRLF
		cHtml += '			</tr>' + cCRLF
		cHtml += '			<tr>' + cCRLF
		cHtml += '				<td>' + cCRLF
		cHtml += '					<br />' + cCRLF
		cHtml += '					<font face="arial" size="2" color="#CC0000">' + cCRLF
		cHtml += '						OBS.:. Favor verificar as informações do Contrato e o Objeto do mesmo, antes da Aprovação e execução das Medições.
		cHtml += '						<br />' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '						<br />' + cCRLF 
		cHtml += '					</font>' + cCRLF 
		cHtml += '				 </td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF
		cHtml += '			<tr bgcolor="#BEBEBE">'
		cHtml += '				<td>' + cCRLF 
		cHtml += '					.'  
		cHtml += '				</td>' + cCRLF 
		cHtml += '			</tr>' + cCRLF
		cHtml += '		</table>' + cCRLF
		cHtml += '	</body>' + cCRLF
		cHtml += '</html>' + cCRLF
		
		DEFAULT lRmvCRLF := .F.
		IF ( lRmvCRLF )
			cHtml := StrTran( cHtml , cCRLF , "" )
		EndIF

	END SEQUENCE		

	RestArea( aSC7Area )
	RestArea( aArea )

Return( cHtml )

/*/
	Funcao:		IsBuyer()
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Verifica se Usuario eh Comprador
/*/
Static Function IsBuyer( nSY1Recno )

	Local aArea		:= GetArea()
	Local aSY1Area	:= SY1->( GetArea() )
	
    Local cCodUser    := StaticCall( NDJLIB014 , RetCodUsr )
	Local cY1Filial	:= xFilial( "SY1" )
	Local cKeySeek	:= ( cY1Filial + cCodUser )

	Local lIsBuyer	:= .F.
	
	Local nSY1Order	:= RetOrder( "SY1" , "Y1_FILIAL+Y1_USER" )

	SY1->( dbSetOrder( nSY1Order ) )
	lIsBuyer		:= SY1->( dbSeek( cKeySeek , .F. ) )
	IF ( lIsBuyer )
		nSY1Recno	:= SY1->( Recno() )
	Else
		nSY1Recno	:= 0
	EndIF

	RestArea( aSY1Area )
	RestArea( aArea )

Return( lIsBuyer )

/*/
	Funcao:		ChgSupplier()
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Alterado o Fornecedor e a Loja
/*/
Static Function ChgSupplier()

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )
	Local aSC7Recnos	:= {}
	Local aSC1Recnos	:= {}
	Local aSC8Recnos	:= {}
	Local aSCERecnos	:= {}
	Local aSCYRecnos	:= {}

    Local cF3           := "NDJSA2"
	Local cCRLF			:= CRLF
	Local cTime			:= Time()
	Local cNumPC		:= ""
	Local cXVISCTB		:= ""
	Local cXDESFOR		:= ""
	
    Local cUserId       := StaticCall( NDJLIB014 , RetCodUsr )
    Local cUserFullName	:= StaticCall( NDJLIB014 , UsrFullName )

	Local cSA2Filial	:= xFilial( "SA2" )
	Local cSC1Filial	:= xFilial( "SC1" )
	Local cSC7Filial	:= xFilial( "SC7" )
	Local cSC8Filial	:= xFilial( "SC8" )
	Local cSCEFilial	:= xFilial( "SCE" )
	Local cSCYFilial	:= xFilial( "SCY" )
	Local cSD1Filial	:= xFilial( "SD1" )
	Local cCNBFilial	:= xFilial( "CNB" )
	Local cSZ6Filial	:= xFilial( "SZ6" )

	Local cOldFornece	:= ""
	Local cOldLojForn	:= ""
	Local cNewFornece	:= ""
	Local cNewLojForn	:= ""

	Local cSC1KeySeek	:= ""
	Local cSC7KeySeek	:= ""
	Local cSC8KeySeek	:= ""
	Local cSCEKeySeek	:= ""
	Local cSCYKeySeek	:= ""
	Local cSD1KeySeek	:= ""
	Local cCNBKeySeek	:= ""
	
	Local cMsgHelp
	Local cMotivo		:= ""
	Local cMotAltera	:= ""
    
	Local dDate			:= MsDate()
	
	Local lConpad1		:= .F.
	Local lChgSupplier	:= .F.

	Local nRecno
	Local nRecnos
	Local nAttempts

	Local nSA2Order		:= RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" )
	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+D1_NUM+C1_ITEM" )
	Local nSC7Order		:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN" )
	Local nSC8Order		:= RetOrder( "SC8" , "C8_FILIAL+C8_NUMSC+C8_ITEMSC" )
	Local nSCEOrder		:= RetOrder( "SCE" , "CE_FILIAL+CE_NUMCOT+CE_ITEMCOT+CE_PRODUTO+CE_FORNECE+CE_LOJA" )
	Local nSCYOrder		:= RetOrder( "SCY" , "CY_FILIAL+CY_NUM+CY_ITEM" )
	Local nSD1Order		:= RetOrder( "SD1" , "D1_FILIAL+D1_PEDIDO+D1_ITEMPC" )
	Local nCNBOrder		:= RetOrder( "CNB" , "CNB_FILIAL+CNB_XNUMPC+CNB_XITMPC+CNB_XSEQPC" )
	
	Local oFont
	
	BEGIN SEQUENCE

        cOldFornece		:= StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_FORNECE" )
		IF Empty( cOldFornece )
			cMsgHelp	:= "Não Existe Fornecedor Vinculado à esse Pedido. Impossível efetuar a Troca."
			BREAK
		EndIF
        cOldLojForn		:= StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_LOJA" )

        cNumPC			:= StaticCall( NDJLIB001 , __FieldGet , "SC7" , "C7_NUM"  )

		cSD1KeySeek		:= cSD1Filial
		cSD1KeySeek		+= cNumPC

		SD1->( dbSetOrder( nSD1Order ) )
		IF SD1->( dbSeek( cSD1KeySeek , .F. ) )
			cMsgHelp	:= "Este Pedido já está Vinculado a Documento Fiscal. Impossível efetuar a Troca."
			BREAK
		EndIF

		cCNBKeySeek		:= cCNBFilial
		cCNBKeySeek		+= cNumPC

		CNB->( dbSetOrder( nCNBOrder ) )
		IF CNB->( dbSeek( cCNBKeySeek , .F. ) )
			cMsgHelp	:= "Este Pedido já está Vinculado a Planilha de Contratos. Impossível efetuar a Troca."
			BREAK
		EndIF

		lConpad1		:= ConPad1( NIL , NIL , NIL , @cF3 )
		IF !( lConpad1 )
			cMsgHelp	:= "Seleção de Fornecedor Não Confirmada. Impossível efetuar a Troca."
			BREAK
		EndIF

		cNewFornece	:= SA2->A2_COD
		cNewLojForn	:= SA2->A2_LOJA
		cXVISCTB	:= SA2->A2_XVISCTB
		cXDESFOR	:= SA2->A2_NREDUZ

		nAttempts	:= 0
         
		DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

		While (;
					Empty( cMotAltera );
					.or.;
					( Len( cMotAltera ) < 10 );
				)
			IF ( ( ++nAttempts ) > 3 )
				cMsgHelp	:= "Solicitante não incluiu uma justiticativa plausível!. Impossível efetuar a Troca."
				BREAK
			EndIF
            cMotAltera := StaticCall( NDJLIB001 , DlgMemoEdit , NIL , "Justificativa da Alteração de Fornecedor" , NIL , NIL , NIL , cMotAltera , @oFont )
		End While

		cMotivo			:= cMotAltera 
		
		cMotAltera 		:= "Informações da Alteração"
		cMotAltera		+= cCRLF
		cMotAltera		+= cCRLF
		cMotAltera 		+= "De" 
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Fornecedor: " + cOldFornece
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Loja: " + cOldLojForn
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Nome Fantasia: " + Posicione( "SA2" , nSA2Order , cSA2Filial + cOldFornece + cOldLojForn , "A2_NREDUZ" )
		cMotAltera 		+= cCRLF
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Para" 
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Fornecedor: " + cNewFornece
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Loja: " + cNewLojForn
		cMotAltera 		+= cCRLF
		cMotAltera 		+= "Nome Fantasia: " + cXDESFOR
		cMotAltera		+= cCRLF
		cMotAltera		+= cCRLF
		cMotAltera 		+= "Alterado Por "
		cMotAltera		+= cCRLF
		cMotAltera 		+= "User ID: " + cUserId
		cMotAltera		+= cCRLF
		cMotAltera		+= "User Name: " + cUserFullName
		cMotAltera		+= cCRLF
		cMotAltera 		+= "Às: " + cTime + " Horas"
		cMotAltera		+= cCRLF
		cMotAltera 		+= "De: " + Dtoc( dDate , "DD/MM/YYYY" )
		cMotAltera		+= cCRLF
		cMotAltera		+= cCRLF
		cMotAltera		+= "Justificativa:"
		cMotAltera		+= cCRLF
		cMotAltera		+= cCRLF
		cMotAltera 		+= cMotivo

		cMotivo			:= ""

		SC1->( dbSetOrder( nSC1Order ) )
		SC7->( dbSetOrder( nSC7Order ) )
		SC8->( dbSetOrder( nSC8Order ) )
		SCE->( dbSetOrder( nSCEOrder ) )
		SCY->( dbSetOrder( nSCYOrder ) )

		cSC7KeySeek		:= cSC7Filial
		cSC7KeySeek		+= cNumPC

		SC7->( dbSeek( cSC7KeySeek , .F. ) )
		While SC7->( !Eof() .and. C7_FILIAL+C7_NUM == cSC7KeySeek )
			IF SC7->( !RecLock( "SC7" , .F. ) )
				cMsgHelp	:= "Não foi possível Obter Exclusividade no Registro de Pedido de Compras.  Impossível efetuar a Troca."
				BREAK
			EndIF
			SC7->( aAdd( aSC7Recnos , Recno() ) )
			cSC1KeySeek := cSC1Filial
			cSC1KeySeek += SC7->C7_NUMSC
			cSC1KeySeek += SC7->C7_ITEMSC
			//Solicitação de Compras
			IF SC1->( dbSeek( cSC1KeySeek , .F. ) )
				While SC1->( !Eof() .and. C1_FILIAL+C1_NUM+C1_ITEM == cSC1KeySeek )
					IF SC1->( !RecLock( "SC1" , .F. ) )
						cMsgHelp	:= "Não foi possível Obter Exclusividade no Registro de Solicitação de Compras.  Impossível efetuar a Troca."
						BREAK
					EndIF
					SC1->( aAdd( aSC1Recnos , Recno() ) )
					SC1->( dbSkip() )
				End While
			EndIF
			cSC8KeySeek := cSC8Filial
			cSC8KeySeek += SC7->C7_NUMSC
			cSC8KeySeek += SC7->C7_ITEMSC
			//Cotacao
			IF SC8->( dbSeek( cSC1KeySeek , .F. ) )
				While SC8->( !Eof() .and. C8_FILIAL+C8_NUMSC+C8_ITEMSC == cSC8KeySeek )
					IF SC8->( !RecLock( "SC8" , .F. ) )
						cMsgHelp	:= "Não foi possível Obter Exclusividade no Registro de Cotação.  Impossível efetuar a Troca."
						BREAK
					EndIF
					SC8->( aAdd( aSC8Recnos , Recno() ) )
					cSCEKeySeek	:= cSCEFilial
					cSCEKeySeek	+= SC8->C8_NUM
					cSCEKeySeek	+= SC8->C8_ITEM
					//Encerramento de Cotacoes
					IF SCE->( dbSeek( cSCEKeySeek , .F. ) )
						While SCE->( !Eof() .and. cSCEKeySeek == CE_FILIAL+CE_NUMCOT+CE_ITEMCOT )
							IF SCE->( !RecLock( "SCE" , .F. ) )
								cMsgHelp	:= "Não foi possível Obter Exclusividade no Encerramento de Cotações.  Impossível efetuar a Troca."
								BREAK
							EndIF
							SCE->( aAdd( aSCERecnos , Recno() ) )
							SCE->( dbSkip() )
						End While
					EndIF
					SC8->( dbSkip() )
				End While
			EndIF
			//Historico Pedido de Compras
			cSCYKeySeek := cSCYFilial
			cSCYKeySeek += SC7->C7_NUM
			cSCYKeySeek += SC7->C7_ITEM
			IF SCY->( dbSeek( cSCYKeySeek , .F.  ) )
				While SCY->( !Eof() .and. cSCYKeySeek == CY_FILIAL+CY_NUM+CY_ITEM )
					IF SCY->( !RecLock( "SCY" , .F. ) )
						cMsgHelp	:= "Não foi possível Obter Exclusividade no Histórico Pedido de Compras.  Impossível efetuar a Troca."
						BREAK
					EndIF
					SCY->( aAdd( aSCYRecnos , Recno() ) )
					SCY->( dbSkip() )
				End While
			EndIF
			SC7->( dbSkip() )
		End While

		nRecnos := Len( aSC7Recnos )
		For nRecno := 1 To nRecnos
			SC7->( dbGoto( aSC7Recnos[ nRecno ] ) )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_FORNECE"	, cNewFornece	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_LOJA"		, cNewLojForn	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XDESFOR"	, cXDESFOR      , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XVISCTB"	, cXVISCTB      , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XALTFOR"	, .T.			, .T. )
			IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SC7"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC7Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"		, SC7->C7_NUMSC		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"	, SC7->C7_ITEMSC	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"		, SC7->C7_NUM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMPC"	, SC7->C7_ITEM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_SEQPC"		, SC7->C7_SEQUEN	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALTFOR"	, .T.				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTCFOR"	, cOldFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTFORL"	, cOldLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUCFOR"	, cNewFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUFORL"	, cNewLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cMotAltera		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, cUserId			, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DUSER"		, cUserFullName		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC7Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC8"	, SC7->C7_NUMCOT	, .T. )
				SZ6->( MsUnLock() )
			EndIF
		Next nRecno

		nRecnos := Len( aSC1Recnos )
		For nRecno := 1 To nRecnos
			SC1->( dbGoto( aSC1Recnos[ nRecno ] ) )
            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_FORNECE"	, cNewFornece	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_LOJA"		, cNewLojForn	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XVISCTB"	, cXVISCTB      , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XALTFOR"	, .T.			, .T. )
			IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SC1"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC1Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"		, SC1->C1_NUM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"	, SC1->C1_ITEM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"		, SC1->C1_PEDIDO	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMPC"	, SC1->C1_ITEMPED	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALTFOR"	, .T.				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTCFOR"	, cOldFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTFORL"	, cOldLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUCFOR"	, cNewFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUFORL"	, cNewLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cMotAltera		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, cUserId			, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DUSER"		, cUserFullName		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC1Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate				, .T. )
				SZ6->( MsUnLock() )
			EndIF
		Next nRecno

		nRecnos := Len( aSC8Recnos )
		For nRecno := 1 To nRecnos
			SC8->( dbGoto( aSC8Recnos[ nRecno ] ) )
            StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_FORNECE"	, cNewFornece	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_LOJA"		, cNewLojForn	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_XDESFOR"	, cXDESFOR      , .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_XVISCTB"	, cXVISCTB		, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SC8" , "C8_XALTFOR"	, .T.			, .T. )
			IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SC8"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC8Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"		, SC8->C8_NUMSC		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"	, SC8->C8_ITEMSC	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"		, SC8->C8_NUMPED	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMPC"	, SC8->C8_ITEMPED	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALTFOR"	, .T.				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTCFOR"	, cOldFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTFORL"	, cOldLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUCFOR"	, cNewFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUFORL"	, cNewLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cMotAltera		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, cUserId			, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DUSER"		, cUserFullName		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSC1Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC8"	, SC8->C8_NUM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC8"	, SC8->C8_ITEM		, .T. )
				SZ6->( MsUnLock() )
			EndIF
		Next nRecno

		nRecnos := Len( aSCERecnos )
		For nRecno := 1 To nRecnos
			SCE->( dbGoto( aSCERecnos[ nRecno ] ) )
            StaticCall( NDJLIB001 , __FieldPut , "SCE" , "CE_FORNECE"	, cNewFornece	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SCE" , "CE_LOJA"		, cNewLojForn	, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SCE" , "CE_XALTFOR"	, .T.			, .T. )
			IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SCE"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSCEFilial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"		, cNumPC            , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALTFOR"	, .T.				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTCFOR"	, cOldFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTFORL"	, cOldLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUCFOR"	, cNewFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUFORL"	, cNewLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cMotAltera		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, cUserId			, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DUSER"		, cUserFullName		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSCEFilial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC8"	, SCE->CE_NUMCOT	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC8"	, SCE->CE_ITEMCOT	, .T. )
				SZ6->( MsUnLock() )
			EndIF
		Next nRecno

		nRecnos := Len( aSCYRecnos )
		For nRecno := 1 To nRecnos
			SCY->( dbGoto( aSCYRecnos[ nRecno ] ) )
            StaticCall( NDJLIB001 , __FieldPut , "SCY" , "CY_FORNECE"    	, cNewFornece		, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SCY" , "CY_LOJA"       	, cNewLojForn		, .T. )
            StaticCall( NDJLIB001 , __FieldPut , "SCY" , "CY_XALTFOR"    	, .T.				, .T. )
			IF SZ6->( RecLock( "SZ6" , .T. ) )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_FILIAL"	, cSZ6Filial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALIAS"		, "SCY"             , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSCYFilial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC"		, SCY->CY_NUMSC		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMSC"	, SCY->CY_ITEMSC	, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMPC"		, SCY->CY_NUM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ITEMPC"	, SCY->CY_ITEM		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ALTFOR"	, .T.				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTCFOR"	, cOldFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ANTFORL"	, cOldLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUCFOR"	, cNewFornece		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_ATUFORL"	, cNewLojForn		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_OBS"		, cMotAltera        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_USER"		, cUserId			, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DUSER"		, cUserFullName		, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_XFILIAL"	, cSCYFilial        , .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_HORA"		, cTime				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_DATA"		, dDate				, .T. )
                StaticCall( NDJLIB001 , __FieldPut , "SZ6" , "Z6_NUMSC8"	, SCY->CY_NUMCOT	, .T. )
				SZ6->( MsUnLock() )
			EndIF
		Next nRecno

		lChgSupplier	:= .T.

        StaticCall( NDJLIB001 , DlgMemoEdit , NIL , "Alteração de Fornecedor :: Alterado com Sucesso!!!" , .F. , NIL , NIL , @cMotAltera , @oFont ) 

	END SEQUENCE

	nRecnos := Len( aSC7Recnos )
	For nRecno := 1 To nRecnos
		SC7->( dbGoto( aSC7Recnos[ nRecno ] ) )
		SC7->( MsUnLock() )
	Next nRecno

	nRecnos := Len( aSC1Recnos )
	For nRecno := 1 To nRecnos
		SC1->( dbGoto( aSC1Recnos[ nRecno ] ) )
		SC1->( MsUnLock() )
	Next nRecno

	nRecnos := Len( aSC8Recnos )
	For nRecno := 1 To nRecnos
		SC8->( dbGoto( aSC8Recnos[ nRecno ] ) )
		SC8->( MsUnLock() )
	Next nRecno

	nRecnos := Len( aSCERecnos )
	For nRecno := 1 To nRecnos
		SCE->( dbGoto( aSCERecnos[ nRecno ] ) )
		SCE->( MsUnLock() )
	Next nRecno

	nRecnos := Len( aSCYRecnos )
	For nRecno := 1 To nRecnos
		SCY->( dbGoto( aSCYRecnos[ nRecno ] ) )
		SCY->( MsUnLock() )
	Next nRecno

	IF !( lChgSupplier )
		IF !Empty( cMsgHelp )
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
		EndIF
	Else
		MSAguarde( { || MailChgSupplier( @cNumPC , @cMotAltera ) } , "Aguarde..." , "Enviando e-mail de Alteração de Fornecedor" , .F. )
	EndIF

	RestArea( aSC7Area )
	RestArea( aArea )

Return( lChgSupplier )

/*/
	Funcao:		MailChgSupplier()
	Autor:		Marinaldo de Jesus
	Data:		15/03/2011
	Descricao:	Envia E-mail da Alteracao do Fornecedor/Loja
/*/
Static Function MailChgSupplier( cNumPC , cMotAltera )

	Local aTo	:= {}

	Local cBody
	Local cSubject

    StaticCall( NDJLIB002 , AddMailDest , @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )
	cSubject	:= "ALTERACAO DE FORNECEDOR - Pedido Numero: " + cNumPC
	
	cBody 		:= '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	cBody 		+= '<html xmlns="http://www.w3.org/1999/xhtml">' 
	cBody 		+= '	<head>' 
	cBody 		+= '		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' 
    cBody       += '        <title>NDJ - ENVIO DE E-MAIL - Alteração de Fornecedor no Pedido de Compras</title>' 
	cBody 		+= '	</head>' 
	cBody 		+= '	<body bgproperties="0" bottommargin="0" leftmargin="0" marginheight="0" marginwidth="0" >' 
	cBody 		+= '		<table cellpadding="0" cellspacing="0"  width"100%" border="0" >' 
	cBody 		+= '			<tr bgcolor="#EEEEEE">' 
	cBody 		+= '				<td>' 
    cBody       += '                    <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0">' 
	cBody 		+= '				</td>' 
	cBody 		+= '			</tr>' 
	cBody 		+= '			<tr bgcolor="#BEBEBE">' 
	cBody 		+= '				<td height="20">' 
	cBody 		+= '				</td>' 
	cBody 		+= '			</tr>' 
	cBody 		+= '			<tr>' 
	cBody 		+= '				<td>' 
	cBody 		+= '					<br />' 
	cBody 		+= '					<font face="arial" size="2">' 
	cBody 		+= '						<b>' 
	cBody 		+= '							ALTERAÇÃO DE FORNECEDOR NO PEDIDO DE COMPRAS'
	cBody 		+= '						</b>' 
	cBody 		+= '						<br />' 
	cBody 		+= '						<br />' 
	cBody 		+= '					</font>' 
	cBody 		+= '				</td>' 
	cBody 		+= '			</tr>' 
	cBody 		+= '			<tr>'  
	cBody 		+= '				<td>' 
	cBody 		+= '					<p>' 
	cBody 		+= '						<font face="arial" size="2">'  
	cBody 		+= '							Prezado(s) Compradores,'
	cBody 		+= '						</font>' 
	cBody 		+= '						<font face="arial" size="2">' 
	cBody 		+= '							<br />'
	cBody 		+= '							<br />'
	cBody 		+= ' O Fornecedor do Pedido de Compras Número: ' + cNumPC + ' Foi Alterado no sistema com os seguintes dados abaixo:'
	cBody 		+= '						</font>'
	cBody 		+= '						<br />'
	cBody 		+= '					</p>' 
	cBody 		+= '				</td>'
	cBody 		+= '			</tr>'
	cBody 		+= '			<tr>'
	cBody 		+= '				<td align="right" valign="top">' 
	cBody 		+= '					<br />'  
	cBody 		+= '					<font face="arial" size="2">' 
	cBody 		+= '						<table width="100%" border="0" cellspacing="2" cellpadding="0">'
	cBody 		+= '							<tr>'
	cBody 		+= '								<td width="100%">' 
	cBody 		+= '									<b>' 
	cBody 		+= '										<font face="arial" size="2">'  
	cBody 		+= '											<pre>
	cBody 		+= cMotAltera
	cBody 		+= '											</pre>
	cBody 		+= '										</font>'  
	cBody 		+= '									</b>' 
	cBody 		+= '								</td>'
	cBody 		+= '							</tr>'
	cBody 		+= '						</table>'
	cBody 		+= '					</font>' 
	cBody 		+= '				</td>'
	cBody 		+= '			</tr>' 
	cBody 		+= '			<tr bgcolor="#BEBEBE">'
	cBody 		+= '				<td>' 
	cBody 		+= '					.'  
	cBody 		+= '				</td>' 
	cBody 		+= '			</tr>'
	cBody 		+= '		</table>'
	cBody 		+= '	</body>'
	cBody 		+= '</html>'

    IF !( StaticCall( NDJLIB002 , SendMail , @cSubject , @cBody , @aTo , NIL , NIL , NIL , .F. ) )
		UserException( "Problema no Envio de e-mail de Alteração de Forcecedor. " + CRLF + "Entre em Contato com o Administrador do Sistema." )
	EndIF

Return( NIL )     

/*/
	Funcao:		SC7HChgSupplier
	Autor:		Marinaldo de Jesus
	Data:		04/05/2011
	Descricao:	Apresenta o Historico de Alteracao de Fornecedores
/*/
Static Function SC7HChgSupplier()

	Local aFixe				:= {}
	Local aArea				:= GetArea()
	Local aSC7Area			:= SC7->( GetArea() )
	
	Local cExprFilTop

	Local nFixe				:= 0
	Local nIndex			:= 0
	Local nSZ6Order			:= RetOrder( "SZ6" , "Z6_FILIAL+Z6_NUMPC" )

	Private aRotina			:= {}
	
	Private aGets
	Private aTela

	Private cCadastro		:= "Histórico de Troca de Fornecedores"

	aAdd( aRotina , Array( 4 ) )
	nIndex 	:= Len( aRotina )
	aRotina[ nIndex ][1]	:= "Pesquisar"
	aRotina[ nIndex ][2]	:= "PesqBrw"
	aRotina[ nIndex ][3]	:= 0
	aRotina[ nIndex ][4]	:= 1

	aAdd( aRotina , Array( 4 ) )
	nIndex 	:= Len( aRotina )
	aRotina[ nIndex ][1]	:= "Visualizar"
	aRotina[ nIndex ][2]	:= "AxVisual"
	aRotina[ nIndex ][3]	:= 0
	aRotina[ nIndex ][4]	:= 2

	SZ6->( dbSetOrder( nSZ6Order ) )

    cExprFilTop 	:= "Z6_NUMPC='" + SC7->C7_NUM + "' AND Z6_ALTFOR='T'"
    cNDJSC7FMbr        := StaticCall( NDJLIB001 , GetSetMbFilter , cExprFilTop )

	SetMBTopFilter( "SC7" , ""  )
	SetMBTopFilter( "SZ6" , cExprFilTop , .F. )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ALIAS" , "X3_TITULO"	)
	aFixe[nFixe][2] := "Z6_ALIAS"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ALIAS" , "X3_TIPO"		)
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ALIAS" , "X3_TAMANHO"	)
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ALIAS" , "X3_DECIMAL"	)
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ALIAS" , "X3_PICTURE"	)

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_NUMPC" , "X3_TITULO"	)
	aFixe[nFixe][2] := "Z6_NUMPC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_NUMPC" , "X3_TIPO"		)
	aFixe[nFixe][4] := GetSx3Cache( "Z6_NUMPC" , "X3_TAMANHO"	)
	aFixe[nFixe][5] := GetSx3Cache( "Z6_NUMPC" , "X3_DECIMAL"	)
	aFixe[nFixe][6] := GetSx3Cache( "Z6_NUMPC" , "X3_PICTURE"	)

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ITEMPC" , "X3_TITULO"	)
	aFixe[nFixe][2] := "Z6_ITEMPC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ITEMPC" , "X3_TIPO"	)
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ITEMPC" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ITEMPC" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ITEMPC" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_SEQPC" , "X3_TITULO"	)
	aFixe[nFixe][2] := "Z6_SEQPC"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_SEQPC" , "X3_TIPO"		)
	aFixe[nFixe][4] := GetSx3Cache( "Z6_SEQPC" , "X3_TAMANHO"	)
	aFixe[nFixe][5] := GetSx3Cache( "Z6_SEQPC" , "X3_DECIMAL"	)
	aFixe[nFixe][6] := GetSx3Cache( "Z6_SEQPC" , "X3_PICTURE"	)

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ANTCFOR" , "X3_TITULO"	 )
	aFixe[nFixe][2] := "Z6_ANTCFOR"                            	
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ANTCFOR" , "X3_TIPO"	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ANTCFOR" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ANTCFOR" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ANTCFOR" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ANTFORL" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_ANTFORL"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ANTFORL" , "X3_TIPO"	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ANTFORL" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ANTFORL" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ANTFORL" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DANTFOR" , "X3_TITULO"	 )
	aFixe[nFixe][2] := "Z6_DANTFOR"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DANTFOR" , "X3_TIPO"	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DANTFOR" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DANTFOR" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DANTFOR" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ATUCFOR" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_ATUCFOR"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ATUCFOR" , "X3_TIPO"	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ATUCFOR" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ATUCFOR" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ATUCFOR" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_ATUFORL" , "X3_TITULO"	 )
	aFixe[nFixe][2] := "Z6_ATUFORL"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_ATUFORL" , "X3_TIPO"	 )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_ATUFORL" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_ATUFORL" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_ATUFORL" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DATUFOR" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_DATUFOR"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DATUFOR" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DATUFOR" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DATUFOR" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DATUFOR" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_USER" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_USER"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_USER" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_USER" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_USER" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_USER" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DUSER" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_DUSER"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DUSER" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DUSER" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DUSER" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DUSER" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_DATA" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_DATA"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_DATA" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_DATA" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_DATA" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_DATA" , "X3_PICTURE" )

	aAdd( aFixe , Array( 6 ) )
	nFixe := Len( aFixe )
	aFixe[nFixe][1] := GetSx3Cache( "Z6_HORA" , "X3_TITULO"  )
	aFixe[nFixe][2] := "Z6_HORA"
	aFixe[nFixe][3] := GetSx3Cache( "Z6_HORA" , "X3_TIPO"    )
	aFixe[nFixe][4] := GetSx3Cache( "Z6_HORA" , "X3_TAMANHO" )
	aFixe[nFixe][5] := GetSx3Cache( "Z6_HORA" , "X3_DECIMAL" )
	aFixe[nFixe][6] := GetSx3Cache( "Z6_HORA" , "X3_PICTURE" )

    mBrowse( 6 , 1 , 22 , 75 , "SZ6" , @aFixe , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , @cExprFilTop )

	CursorWait()
	
	MbrRstFilter()	

	IF ( Type( "bFiltraBrw" ) == "B" )
		IF ( "SC7" $ GetCbSource( bFiltraBrw ) )
			Eval( bFiltraBrw )
		EndIF
	EndIF

	RestArea( aSC7Area )
	RestArea( aArea )

	CursorArrow()

Return( NIL )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
        NDJGCTGRP()
        NDJContratos()
		CN100Cancel()
		SC7LinkCN9()
		CN9GetSetCNT()
		CNTSendMail()
		BuildHtml()
		SC7FiltLeg()
		MbrRstFilter()
		ChgSupplier()
		SC7HChgSupplier()
		MATA120()
		lRecursa := __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )