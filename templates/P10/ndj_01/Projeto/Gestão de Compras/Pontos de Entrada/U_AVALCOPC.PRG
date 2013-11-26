#INCLUDE "NDJ.CH"
/*/
	Funcao:		AVALCOPC
	Data:		29/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				- Implementação do Ponto de Entrada MT120ISC que srá utilizado para distribuir os Pedidos de Compras de acordo com os Destinos
/*/
User Function AVALCOPC()

	Local aArea			:= GetArea()
	Local aSC7Area		:= SC7->( GetArea() )
	Local aSC1Area		:= SC1->( GetArea() )
	Local aAliasLock	:= {}
	Local aSC7Recnos	:= {}

	Local cMsgHelp

	Local c4aVisao

	Local cSZ0Filial
	
	Local cSC1Filial

	Local cSZ2Filial
	Local cSZ3Filial

	Local cSZ4Filial
	Local cSZ5Filial

	Local lAprova		:= ( IsInCallStack( "U_MATA160" ) )

	Local nRecno
	Local nRecnos
	Local nSC7Recno

	Local nSC1Order
	Local nSC7Order
	Local nSZ3Order
	Local nSZ2Order
	Local nSZ4Order
	Local nSZ5Order
	Local nSZ0Order

	Local oException

	TRYEXCEPTION

		IF !( lAprova )
			BREAK
		EndIF

        IF !( Type( "__aNDJSC7Reg" ) == "A" )
			BREAK
		EndIF

		cSZ0Filial	:= xFilial( "SZ0" )
		cSC1Filial	:= xFilial( "SC1" )
		cSZ2Filial	:= xFilial( "SZ2" )
		cSZ3Filial	:= xFilial( "SZ3" )
		cSZ4Filial	:= xFilial( "SZ4" )
		cSZ5Filial	:= xFilial( "SZ5" )

		nSC1Order	:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
		SC1->( dbSetOrder( nSC1Order ) )
		
		nSC7Order	:= RetOrder( "SC7" , "C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN" )
		SC7->( dbSetOrder( nSC7Order ) )

		nSZ0Order	:= RetOrder( "SZ0" , "Z0_FILIAL+Z0_ALIAS+Z0_XFILIAL+Z0_PROJETO+Z0_REVISAO+Z0_TAREFA+Z0_NUM+Z0_ITEM+Z0_ITEMGRD+Z0_ORCAME+Z0_XCODOR+Z0_XCODSBM+Z0_SEQUEN" )
		SZ0->( dbSetOrder( nSZ0Order ) )

		nSZ2Order 	:= RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
		SZ2->( dbSetOrder( nSZ2Order ) )

		nSZ3Order	:= RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )
		SZ3->( dbSetOrder( nSZ3Order ) )
		
		nSZ4Order 	:= RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
		SZ4->( dbSetOrder( nSZ4Order ) )

		nSZ5Order	:= RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )
		SZ5->( dbSetOrder( nSZ5Order ) )

        nRecnos    := Len( __aNDJSC7Reg )
		For nRecno := 1 To nRecnos
            nSC7Recno    := __aNDJSC7Reg[ nRecno ]
			SC7->( dbGoto( nSC7Recno ) )
			IF SC7->( !Eof() .and. !Bof() )
                While SC7->( !StaticCall( NDJLIB003 , LockSoft , "SC7" , @aAliasLock ) )
					Sleep( 100 )
				End While
				SC7->( SC7LnkSC1( @aAliasLock , @cSC1Filial , @cSZ0Filial ) )
				SC7->( PCDistributing( @aAliasLock , @nSC7Recno , @cSZ2Filial , @cSZ3Filial , @cSZ4Filial , @cSZ5Filial , @aSC7Recnos ) )
                SC7->( StaticCall( NDJLIB003 , AliasUnLock , @aAliasLock ) )
			EndIF
		Next nRecno

        aSize( __aNDJSC7Reg , 0 )

		//Envia e-mail
		nRecnos := Len( aSC7Recnos )
		IF ( nRecnos > 0 )
			nSC7Recno := aSC7Recnos[ 1 ]
			SC7->( dbGoto( nSC7Recno ) )
			SC7->( SendMailPC( @aSC7Recnos , @nRecnos ) )
		EndIF

		//Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA002 , SZ4SZ5Commit )

		//Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

	CATCHEXCEPTION USING oException 

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			cMsgHelp += __cCRLF
			cMsgHelp += oException:ErrorStack
			ConOut( cMsgHelp )
		EndIF	

	ENDEXCEPTION

    StaticCall( NDJLIB003 , AliasUnLock , @aAliasLock )

	RestArea( aSC1Area )
	RestArea( aSC7Area )
	RestArea( aArea )

Return( NIL )

/*/
	Funcao:		SC7LnkSC1
	Data:		15/08/2011
	Autor:		Marinaldo de Jesus
	Descricao:	Efetua o Link da SC7 com a SC1 Atualizando a Solicitacao de Compras com Dados do Pedido
/*/
Static Function SC7LnkSC1( aAliasLock , cSC1Filial , cSZ0Filial )

	Local cSC1KeySeek
	Local cSZ0KeySeek

	Local lC7BlockZ0

	BEGIN SEQUENCE

		cSC1KeySeek	:= cSC1Filial 
		cSC1KeySeek	+= SC7->C7_NUMSC
		cSC1KeySeek	+= SC7->C7_ITEMSC

		IF SC1->( !dbSeek( cSC1KeySeek , .F. ) )
			BREAK
		EndIF

        While SC1->( !StaticCall( NDJLIB003 , LockSoft , "SC1" , @aAliasLock ) )
			Sleep( 100 )
		End While

        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XVISCTB"    , SC7->C7_XVISCTB    , .T. )

        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_QUANT"        , SC7->C7_QUANT        , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XPRECO"    , SC7->C7_PRECO        , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XTOTAL"    , SC7->C7_TOTAL        , .T. )

		cSZ0KeySeek	:= cSZ0Filial											//Z0_FILIAL
		cSZ0KeySeek	+= "SC1"												//Z0_ALIAS
		cSZ0KeySeek	+= cSC1Filial											//Z0_XFILIAL
		cSZ0KeySeek	+= SC7->C7_XPROJET										//Z0_PROJETO
		cSZ0KeySeek	+= SC7->C7_XREVIS 										//Z0_REVISAO
		cSZ0KeySeek	+= SC7->C7_XTAREFA										//Z0_TAREFA
		cSZ0KeySeek	+= SC7->C7_NUMSC										//Z0_NUM
		cSZ0KeySeek	+= SC7->C7_ITEMSC										//Z0_ITEM
		cSZ0KeySeek	+= SC7->C7_ITEMGRD										//Z0_ITEMGRD
		cSZ0KeySeek	+= SC7->C7_CODORCA										//Z0_ORCAME
		cSZ0KeySeek	+= SC7->C7_XCODOR										//Z0_XCODOR
		cSZ0KeySeek	+= SC7->C7_XCODSBM										//Z0_XCODSBM
		cSZ0KeySeek	+= Space( GetSx3Cache( "Z0_SEQUEN" , "X3_TAMANHO" ) )	//Z0_SEQUEN

		IF SZ0->( !dbSeek( cSZ0KeySeek , .F. ) )
			BREAK
		EndIF

        While SZ0->( !StaticCall( NDJLIB003 , LockSoft , "SZ0" , @aAliasLock ) )
			Sleep( 100 )
		End While

        StaticCall( NDJLIB001 , __FieldPut , "SZ0" , "Z0_LASTVAL"        , SZ0->Z0_VALOR        , .T. )
        StaticCall( NDJLIB001 , __FieldPut , "SZ0" , "Z0_VALOR"            , SC7->C7_TOTAL        , .T. )
	
		SZ0->( MsUnLock() )

        While SZ0->( !StaticCall( NDJLIB003 , LockSoft , "SZ0" , @aAliasLock ) )
			Sleep( 100 )
		End While

        SZ0->( StaticCall( NDJLIB004 , SetPublic , "__nSZ0Recno" , Recno() , "N" , 0 , .F. , .T. ) )

        lC7BlockZ0    := !( StaticCall( U_NDJBLKSCVL , C1XPrecoVld ) )
        StaticCall( NDJLIB001 , __FieldPut , "SZ0" , "C7_BLOCKZ0"        , lC7BlockZ0        , .T. )

		IF ( lC7BlockZ0 )
            StaticCall( NDJLIB001 , __FieldPut , "SZ0" , "C7_MSBLQL"    , "1"                , .T. )    
		EndIF

        StaticCall( NDJLIB004 , SetPublic , "__nSZ0Recno" , 0 , "N" , 0 , .T. , .T. )

	END SEQUENCE

Return( NIL )

/*/
	Funcao:		PCDistributing
	Data:		23/11/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Distribui os Pedidos de Compras de Acordo com o SZ2
/*/
Static Function PCDistributing( aAliasLock , nSC7Recno , cSZ2Filial , cSZ3Filial , cSZ4Filial , cSZ5Filial , aSC7Recnos )

	Local aArea			:= GetArea()
	Local aSC7dbStruct	:= SC7->( dbStruct() )
	Local aAreaSC7		:= SC7->( GetArea() )
	Local aAreaSZ2		:= SZ2->( GetArea() )
	Local aAreaSZ3		:= SZ3->( GetArea() )
	Local aAreaSZ4		:= SZ4->( GetArea() )
	Local aSC7Array		:= {}

	Local cC7Item		:= ""
	Local cC7Sequen		:= StrZero( 1 , GetSx3Cache( "C7_SEQUEN" , "X3_TAMANHO" ) )
	Local cC7XSZ2Cod	:= SC7->C7_XSZ2COD
	Local cSC7KeySeek	:= ""
	Local cSZ2KeySeek	:= ""
	Local cSZ3KeySeek	:= ""
	Local cSZ4KeySeek	:= ""
	Local cSZ5KeySeek	:= ""

	Local lSC7AddNew	:= .F.
	Local lSZ4AddNew	:= .F.
	Local lSZ5AddNew	:= .F.
	Local lDistributing	:= .F.

	Local nBL
	Local nEL
	Local nField
	Local nFields
	Local nC7Quant		:= 0
	Local nC7Preco		:= 0

	Local oException

	TRYEXCEPTION

		SC7->( MsGoto( nSC7Recno ) )
        While SC7->( !StaticCall( NDJLIB003 , LockSoft , "SC7" , @aAliasLock ) )
			Sleep( 100 )
		End While

		nC7Quant		:= SC7->C7_QUANT
		lDistributing	:= ( ( nC7Quant > 0 ) .and. ( nC7Quant <> 1 ) )

		cSZ3KeySeek		:= cSZ3Filial
		cSZ3KeySeek		+= cC7XSZ2Cod
		cSZ3KeySeek		+= SC7->C7_NUMSC

		IF SZ3->( !dbSeek( cSZ3KeySeek , .F. ) )
			BREAK
		EndIF
        SZ3->( StaticCall( NDJLIB003 , LockSoft , "SZ3" , @aAliasLock ) )

		cSZ2KeySeek := cSZ2Filial
		cSZ2KeySeek += cC7XSZ2Cod
		cSZ2KeySeek += SC7->C7_NUMSC
		cSZ2KeySeek += SC7->C7_ITEMSC
		IF SZ2->( !dbSeek( cSZ2KeySeek , .F. ) )
			BREAK
		EndIF
        SZ2->( StaticCall( NDJLIB003 , LockSoft , "SZ2" , @aAliasLock ) )

        SZ3->( StaticCall( U_NDJA002 , lUseD1ToZ5 , Z3_FILIAL , Z3_CODIGO , .F. , .F. ) )

		cSZ5KeySeek	:= cSZ5Filial
		cSZ5KeySeek	+= SZ3->Z3_CODIGO
		cSZ5KeySeek	+= SZ3->Z3_NUMSC

		lSZ5AddNew	:= SZ5->( !dbSeek( cSZ5KeySeek , .F. ) )

		IF SZ5->( RecLock( "SZ5" , lSZ5AddNew ) )
			SZ5->Z5_FILIAL	:= cSZ5Filial
			SZ5->Z5_CODIGO	:= SZ3->Z3_CODIGO
			SZ5->Z5_NUMSC	:= SZ3->Z3_NUMSC
			SZ5->( MsUnLock() )
		EndIF
        SZ5->( StaticCall( NDJLIB003 , LockSoft , "SZ5" , @aAliasLock ) )
        SZ5->( StaticCall( U_NDJA002 , SZ4SZ5TTS ) )
		
		cSC7KeySeek	:= SC7->C7_FILIAL
		cSC7KeySeek	+= SC7->C7_NUM

        aSC7Array        := StaticCall( NDJLIB001 , RegToArray , "SC7" , @nSC7Recno )
		nFields			:= Len( aSC7Array )

		nC7Preco	:= SC7->C7_PRECO
		IF SC7->( RecLock( "SC7" , .F. ) )
			cC7Item			:= SC7->C7_ITEM
			SC7->C7_SEQUEN	:= cC7Sequen
			SC7->C7_QUANT	:= SZ2->Z2_QUANT
			SC7->C7_TOTAL	:= ( SZ2->Z2_QUANT * nC7Preco )
			SC7->( MsUnLock() )
		EndIF
        SC7->( StaticCall( NDJLIB003 , LockSoft , "SC7" , @aAliasLock ) )
		SC7->( aAdd( aSC7Recnos , Recno() ) )

		cSZ4KeySeek := cSZ4Filial
		cSZ4KeySeek += SZ2->Z2_CODIGO
		cSZ4KeySeek += SC7->C7_NUMSC
		cSZ4KeySeek += SC7->C7_ITEMSC
		cSZ4KeySeek += SC7->C7_SEQUEN

		lSZ4AddNew	:= SZ4->( !dbSeek( cSZ4KeySeek , .F. ) )

		IF SZ4->( RecLock( "SZ4" , lSZ4AddNew ) )
			SZ4->Z4_FILIAL 	:= cSZ4Filial
			SZ4->Z4_CODIGO 	:= SZ2->Z2_CODIGO
			SZ4->Z4_NUMSC  	:= SC7->C7_NUMSC
			SZ4->Z4_ITEMSC 	:= SC7->C7_ITEMSC
			SZ4->Z4_SECITEM	:= SC7->C7_SEQUEN
			SZ4->Z4_QUANT	:= SZ2->Z2_QUANT
			SZ4->Z4_XCLIORG	:= SZ2->Z2_XCLIORG
			SZ4->Z4_XDESORG	:= SZ2->Z2_XDESORG
			SZ4->Z4_XCLIINS	:= SZ2->Z2_XCLIINS
			SZ4->Z4_XLOJAIN	:= SZ2->Z2_XLOJAIN
			SZ4->Z4_XDESINS	:= SZ2->Z2_XDESINS
			SZ4->Z4_XRESPON	:= SZ2->Z2_XRESPON
			SZ4->Z4_XCONTAT	:= SZ2->Z2_XCONTAT 
			SZ4->Z4_XENDER	:= SZ2->Z2_XENDER
			SZ4->Z4_XESTINS	:= SZ2->Z2_XESTINS
			SZ4->Z4_XCEPINS	:= SZ2->Z2_XCEPINS
			SZ4->Z4_LINKED	:= .T.
			SZ4->( MsUnLock() )
		EndIF
        SZ4->( StaticCall( NDJLIB003 , LockSoft , "SZ4" , @aAliasLock ) )

		IF !( lDistributing )
            SZ3->( StaticCall( U_NDJA002 , lUseD1ToZ5 , Z3_FILIAL , Z3_CODIGO , .T. , .T. ) )
			BREAK
		EndIF

		SZ2->( dbSkip() )
		While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC == cSZ2KeySeek )

            SZ2->( StaticCall( NDJLIB003 , LockSoft , "SZ2" , @aAliasLock ) )

			cC7Item		:= __Soma1( cC7Item   )
			cC7Sequen	:= __Soma1( cC7Sequen )

			lSC7AddNew	:= SC7->( !dbSeek( cSC7KeySeek + cC7Item + cC7Sequen , .F. ) )

			IF SC7->( RecLock( "SC7" , lSC7AddNew ) )

				For nField := 1 To nFields
					IF ( SC7->( AllTrim( FieldName( nField ) ) ) $ "C7_ITEM,C7_SEQUEN,C7_QUANT,C7_TOTAL" )
						Loop
					EndIF
					SC7->( FieldPut( nField , aSC7Array[ nField ] ) )
				Next nField

				SC7->C7_ITEM	:= cC7Item
				SC7->C7_SEQUEN	:= cC7Sequen
				SC7->C7_QUANT	:= SZ2->Z2_QUANT
				SC7->C7_TOTAL	:= ( SZ2->Z2_QUANT * nC7Preco )

				cSZ4KeySeek := cSZ4Filial
				cSZ4KeySeek += SZ2->Z2_CODIGO
				cSZ4KeySeek += SC7->C7_NUMSC
				cSZ4KeySeek += SC7->C7_ITEMSC
				cSZ4KeySeek += SC7->C7_SEQUEN
				
				lSZ4AddNew	:= SZ4->( !dbSeek( cSZ4KeySeek , .F. ) )

				IF SZ4->( RecLock( "SZ4" , lSZ4AddNew ) )
					SZ4->Z4_FILIAL 	:= cSZ4Filial
					SZ4->Z4_CODIGO 	:= SZ2->Z2_CODIGO
					SZ4->Z4_NUMSC  	:= SC7->C7_NUMSC
					SZ4->Z4_ITEMSC 	:= SC7->C7_ITEMSC
					SZ4->Z4_SECITEM	:= SC7->C7_SEQUEN
					SZ4->Z4_QUANT	:= SZ2->Z2_QUANT
					SZ4->Z4_XCLIORG	:= SZ2->Z2_XCLIORG
					SZ4->Z4_XDESORG	:= SZ2->Z2_XDESORG
					SZ4->Z4_XCLIINS	:= SZ2->Z2_XCLIINS
					SZ4->Z4_XLOJAIN	:= SZ2->Z2_XLOJAIN
					SZ4->Z4_XDESINS	:= SZ2->Z2_XDESINS
					SZ4->Z4_XRESPON	:= SZ2->Z2_XRESPON
					SZ4->Z4_XCONTAT	:= SZ2->Z2_XCONTAT 
					SZ4->Z4_XENDER	:= SZ2->Z2_XENDER
					SZ4->Z4_XESTINS	:= SZ2->Z2_XESTINS
					SZ4->Z4_XCEPINS	:= SZ2->Z2_XCEPINS
					SZ4->Z4_LINKED	:= .T.
					SZ4->( MsUnLock() )
				EndIF
                SZ4->( StaticCall( NDJLIB003 , LockSoft , "SZ4" , @aAliasLock ) )

				SC7->( MsUnLock() )
                StaticCall( NDJLIB003 , LockSoft , "SC7" , @aAliasLock )

				SC7->( aAdd( aSC7Recnos , Recno() ) )

			EndIF

			SZ2->( dbSkip() )

		End While

        SZ3->( StaticCall( U_NDJA002 , lUseD1ToZ5 , Z3_FILIAL , Z3_CODIGO , .T. , .T. ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			ConOut( oException:Description , oException:ErrorStack )
		EndIF

	ENDEXCEPTION

	nEL := Len( aSC7Recnos )
	For nBL := 1 To nEL
		nSC7Recno := aSC7Recnos[ nBL ]
		SC7->( dbGoto( nSC7Recno ) )
		IF SC7->( Eof() .or. Bof() )
			Loop
		EndIF
        SC7->( StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC7" )     )//Verifica os Links do SC7 com o SZ0
	Next nBL

	RestArea( aAreaSZ4 )
	RestArea( aAreaSZ3 )
	RestArea( aAreaSZ2 )
	RestArea( aAreaSC7 )
	RestArea( aArea )

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³SendMailPC		 ³Autor³Marinaldo de Jesus³ Data ³15/12/2010³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Envia informacoes sobre a Geracao do Pedido de Compras		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Generico												    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Static Function SendMailPC( aItens , nItens )

	Local aTo		:= {}

	Local cMsgMail
	Local cSubject
	Local cMsgHelp

	Local lSendMail

	TRYEXCEPTION

		cSubject	:= "O Pedido de Compra Número: "
		cSubject	+= SC7->C7_NUM
		cSubject	+= " Processo: "
		cSubject	+= SC7->C7_XNUMPRO
		cSubject	+= " Foi Gerado e Precisa ser Liberado."
		
		cSubject	:= OemToAnsi( cSubject ) 

        StaticCall( NDJLIB002 , AddMailDest , @aTo , GetNewPar("NDJ_ECOM","ndjadvpl@gmail.com") )

		cMsgMail	:= OemToAnsi( BuildHtml( @aItens , @nItens , @aTo , .T. ) )
        lSendMail    := StaticCall( NDJLIB002 , SendMail , @cSubject , @cMsgMail , @aTo , NIL , NIL , NIL , .F. )

		IF !( lSendMail )
			cMsgHelp := "Problema no Envio de Email: "
			cMsgHelp += __cCRLF
			aEval( aTo , { |cMail| ( cMsgHelp += ( cMail + __cCRLF ) ) } )
			UserException( cMsgHelp )
		EndIF

	CATCHEXCEPTION USING oException

		lSendMail	:= .F.

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			cMsgHelp += __cCRLF
			cMsgHelp += oException:ErrorStack
			ConOut( cMsgHelp )
		EndIF

	ENDEXCEPTION

Return( lSendMail )

/*/
	Funcao: BuildHtml
	Autor:	Marinaldo de Jesus
	Data:	15/12/2010
	Uso:	Monta o HTML a ser Enviado para Solicitante e para o Grupo de Compradores
/*/
Static Function BuildHtml( aItens , nItens , aTo , lRmvCRLF )

	Local cHtml := ""

	Local nBL
	Local nEL	:= nItens

	cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + __cCRLF
	cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">' + __cCRLF 
	cHtml += '	<head>' + __cCRLF 
	cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />' + __cCRLF 
    cHtml += '        <title>NDJ - ENVIO DE E-MAIL - Pedido de Compras</title>' + __cCRLF 
	cHtml += '	</head>' + __cCRLF 
	cHtml += '	<body bgproperties="0" bottommargin="0" leftmargin="0" marginheight="0" marginwidth="0" >' + __cCRLF 
	cHtml += '		<table cellpadding="0" cellspacing="0"  width"100%" border="0" >' + __cCRLF 
	cHtml += '			<tr bgcolor="#EEEEEE">' + __cCRLF 
	cHtml += '				<td>' + __cCRLF 
    cHtml += '                    <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0">' + __cCRLF 
	cHtml += '				</td>' + __cCRLF 
	cHtml += '			</tr>' + __cCRLF 
	cHtml += '			<tr bgcolor="#BEBEBE">' + __cCRLF 
	cHtml += '				<td height="20">' + __cCRLF 
	cHtml += '				</td>' + __cCRLF 
	cHtml += '			</tr>' + __cCRLF 
	cHtml += '			<tr>' + __cCRLF 
	cHtml += '				<td>' + __cCRLF 
	cHtml += '					<br />' + __cCRLF 
	cHtml += '					<font face="arial" size="2">' + __cCRLF 
	cHtml += '						<b>' + __cCRLF 
	cHtml += '							PEDIDO DE COMPRAS'
	cHtml += '						</b>' + __cCRLF 
	cHtml += '						<br />' + __cCRLF 
	cHtml += '						<br />' + __cCRLF 
	cHtml += '					</font>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF 
	cHtml += '			</tr>' + __cCRLF 
	cHtml += '			<tr>' + __cCRLF  
	cHtml += '				<td>' + __cCRLF 
	cHtml += '					<p>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Prezado(s) Compradore(s),'
	cHtml += '						</font>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF 
	cHtml += '							<br />' + __cCRLF
	cHtml += '							<br />' + __cCRLF
	cHtml += 'O Pedido Número: '
	cHtml += SC7->( C7_NUM + " Processo: " + C7_XNUMPRO )
	cHtml += ' foi gerado e necessita de sua LIBERAÇÃO para que possa dar continuidade aos processos pertinentes.'  
	cHtml += '							<br />' + __cCRLF
	cHtml += '							<br />' + __cCRLF
	cHtml += 'Favor verficiar validade do pedido e dar continuidade.'  
	cHtml += '							<br />' + __cCRLF
	cHtml += '						</font>' + __cCRLF
	cHtml += '						<br />' + __cCRLF
	cHtml += '					</p>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '			</tr>' + __cCRLF
	cHtml += '			<tr>' + __cCRLF
	cHtml += '				<td colspan="2">' + __cCRLF
	cHtml += '					<font face="arial" size="2">' + __cCRLF 
	cHtml += '						<table width="100%" border="0" cellspacing="2" cellpadding="0">' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td width="25%" height="19">' + __cCRLF
	cHtml += '									&nbsp;'  
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td width="75%">' + __cCRLF 
	cHtml += '									&nbsp;'  
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									&nbsp;'  
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									&nbsp;'  
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<b>' + __cCRLF 
	cHtml += '										<font face="arial" size="2">' + __cCRLF  
	cHtml += '											Código do Fornecedor:'
	cHtml += '										</font>' + __cCRLF  
	cHtml += '									</b>' + __cCRLF 
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += SC7->C7_FORNECE
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<b>' + __cCRLF 
	cHtml += '										<font face="arial" size="2">' + __cCRLF  
	cHtml += '											Loja:'
	cHtml += '										</font>' + __cCRLF  
	cHtml += '									</b>' + __cCRLF 
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += SC7->C7_LOJA
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<b>' + __cCRLF 
	cHtml += '										<font face="arial" size="2">' + __cCRLF  
	cHtml += '											Nome do Fornecedor:'
	cHtml += '										</font>' + __cCRLF  
	cHtml += '									</b>' + __cCRLF 
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<font face="arial" size="2">' + __cCRLF  
	cHtml += PosAlias( "SA2" , SC7->(C7_FORNECE+C7_LOJA) , NIL , "A2_NOME" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , .F. )
	cHtml += '									</font>' + __cCRLF  
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '							<tr>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<b>' + __cCRLF 
	cHtml += '										<font face="arial" size="2">' + __cCRLF  
	cHtml += '											Nome Fantasia:'
	cHtml += '										</font>' + __cCRLF  
	cHtml += '									</b>' + __cCRLF 
	cHtml += '								</td>' + __cCRLF
	cHtml += '								<td>' + __cCRLF 
	cHtml += '									<font face="arial" size="2">' + __cCRLF  
	cHtml += PosAlias( "SA2" , SC7->(C7_FORNECE+C7_LOJA) , NIL , "A2_NREDUZ" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , .F. )
	cHtml += '									</font>' + __cCRLF  
	cHtml += '								</td>' + __cCRLF
	cHtml += '							</tr>' + __cCRLF
	cHtml += '						</table>' + __cCRLF
	cHtml += '					</font>' + __cCRLF
	cHtml += '				</td>' + __cCRLF 
	cHtml += '			</tr>' + __cCRLF
	cHtml += '		</table>' + __cCRLF
	cHtml += '		<table width="800" border="1" cellspacing="1" cellpadding="2">' + __cCRLF
	cHtml += '			<tr  bgcolor="#cccccc">' + __cCRLF
	cHtml += '				<td width="60">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Item'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="60">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Código do Produto'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="58">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Descrição'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="72">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Quantidade'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="46">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Marca'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="49">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Modelo'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="109">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Garantia'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="107">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Data de Entrega'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF  
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Valor Total'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Numero SC'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Item SC'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Cod. Projeto'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Desc. Projeto'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Revisão'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Tarefa'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '				<td width="102">' + __cCRLF 
	cHtml += '					<b>' + __cCRLF 
	cHtml += '						<font face="arial" size="2">' + __cCRLF  
	cHtml += '							Centro de Custo'  
	cHtml += '						</font>' + __cCRLF  
	cHtml += '					</b>' + __cCRLF 
	cHtml += '				</td>' + __cCRLF
	cHtml += '			</tr>' + __cCRLF
	For nBL := 1 To nEL
		SC7->( dbGoto( aItens[ nBL ] ) )
        StaticCall( NDJLIB002 , AddMailDest , @aTo , StaticCall( NDJLIB014 , UsrRetMail , SC7->C7_USERSC ) )
		cHtml += '			<tr>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += SC7->C7_ITEM
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += SC7->C7_PRODUTO  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += PosAlias( "SB1" , SC7->C7_PRODUTO , NIL , "B1_DESC" , RetOrder( "SB1" , "B1_FILIAL+B1_COD" ) , .F. )
		cHtml += '					</font>' + __cCRLF  	
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += Transform( SC7->C7_QUANT , GetSx3Cache( "C7_QUANT" , "X3_PICTURE" ) )
		cHtml += '					</font>' + __cCRLF  	
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += SC7->C7_XMARCA
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += SC7->C7_XMODELO
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += Transform( SC7->C7_XGARA , GetSx3Cache( "C7_XGARA" , "X3_PICTURE" ) )
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += Dtoc(SC7->C7_DATPRF)
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF 
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += Transform( SC7->C7_TOTAL , GetSx3Cache( "C7_TOTAL" , "X3_PICTURE" ) )
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_NUMSC
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_ITEMSC
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_XPROJET
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += PosAlias( "AF8" , SC7->C7_XPROJET , NIL , "AF8_DESCRI" , RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" ) , .F. )  
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_XREVIS
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_XTAREFA
		cHtml += '					</font>' + __cCRLF
		cHtml += '				</td>' + __cCRLF
		cHtml += '				<td>' + __cCRLF 
		cHtml += '					<font face="arial" size="2">' + __cCRLF  
		cHtml += SC7->C7_CC
		cHtml += '					</font>' + __cCRLF  
		cHtml += '				</td>' + __cCRLF
		cHtml += '			</tr>' + __cCRLF
		cHtml += '			<tr bgcolor="#cccccc">' + __cCRLF
		cHtml += '				<td colspan="16">' + __cCRLF 
		cHtml += '					<b>' + __cCRLF 
		cHtml += '						<font face="arial" size="2">' + __cCRLF  
		cHtml += '							Proposta do Fornecedor'  
		cHtml += '						</font>' + __cCRLF  
		cHtml += '					</b>' + __cCRLF 
		cHtml += '				</td>' + __cCRLF 
		cHtml += '			</tr>' + __cCRLF
		cHtml += '			<tr>' + __cCRLF 
		cHtml += '				<td colspan="16">' + __cCRLF 
		cHtml += SC7->C7_XPROP1
		cHtml += '				</td>' + __cCRLF 
		cHtml += '			</tr>' + __cCRLF
	Next nBL
	cHtml += '		</table>' + __cCRLF
	cHtml += '	</body>' + __cCRLF
	cHtml += '</html>' + __cCRLF
	
	DEFAULT lRmvCRLF := .F.
	IF ( lRmvCRLF )
		cHtml := StrTran( cHtml , __cCRLF , "" )
	EndIF

Return( cHtml )
