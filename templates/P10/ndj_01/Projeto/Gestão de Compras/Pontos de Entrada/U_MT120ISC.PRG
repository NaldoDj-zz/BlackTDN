#INCLUDE "NDJ.CH"
/*/
	Funcao:		MT120ISC
	Data:		03/12/2010
	Autor:		Marinaldo de Jesus
	Descricao:	Ponto de Entrada executado no progama MATA120.
				- Implementação do Ponto de Entrada MT120ISC que srá utilizado para gravar campos específicos 
				  das Solicitações de Compras Selecionados Via Tecla <F4> ou <F5> no programa MATA120(1)
/*/
User Function MT120ISC()

	Local aAreaSZ2		:= SZ2->( GetArea() )
	Local aAreaSZ3		:= SZ3->( GetArea() )
	Local aAreaSZ4		:= SZ4->( GetArea() )
	Local aFields		:= {;
								{ "C7_XEQUIPA" , "C1_XEQUIPA" },;
								{ "C7_XCLIORG" , "C1_XCLIORG" },;
								{ "C7_XCONTAT" , "C1_XCONTAT" },;
								{ "C7_XENDER"  , "C1_XENDER"  },;
								{ "C7_XCODSBM" , "C1_XCODSBM" },;
								{ "C7_XSBM"    , "C1_XSBM"    },;
								{ "C7_XLOJAIN" , "C1_XLOJAIN" },;
								{ "C7_XRESPON" , "C1_XRESPON" },;
								{ "C7_XCLIINS" , "C1_XCLIINS" },;
								{ "C7_XMODALI" , "C1_XMODALI" },;
								{ "C7_XNUMPRO" , "C1_XNUMPRO" },;
								{ "C7_XPROP1"  , "C1_XPROP1"  },;
								{ "C7_XPROJET" , "C1_XPROJET" },;
								{ "C7_XCODOR"  , "C1_XCODOR"  },;
								{ "C7_XSZ2COD" , "C1_XSZ2COD" },;
								{ "C7_CODORCA" , "C1_CODORCA" },;
								{ "C7_CC"      , "C1_CC"      },;
								{ "C7_CLVL"    , "C1_CLVL"    },;
								{ "C7_ITEMCTA" , "C1_ITEMCTA" },;
								{ "C7_XTAREFA" , "C1_XTAREFA" },;
								{ "C7_PRECO"   , "C1_XPRECO"  },;
								{ "C7_XREVIS"  , "C1_REVISA"  },;
								{ "C7_USERSC"  , "C1_USER"    },;
								{ "C7_XCODGE"  , "C1_XCODGE"  },;
								{ "C7_XVISCTB" , "C1_XVISCTB" },;
								{ "C7_XREFCNT" , "C1_XREFCNT" },;
								{ "C7_XDTPPAG" , "C1_XDTPPAG" };
							}

	Local cA2Reduz
	Local cC7Item		:= ""
	Local cC7Sequen		:= StrZero( 1 , GetSx3Cache( "C7_SEQUEN" , "X3_TAMANHO" ) )
	Local cC7XSZ2Cod	:= ""
	Local cSZ2Filial	:= xFilial( "SZ2" )
	Local cSZ2KeySeek	:= ""
	Local cSZ4KeySeek	:= ""
	Local cSZ5KeySeek	:= ""
	Local cSZ4Filial	:= xFilial( "SZ4" )
	Local cSZ5Filial	:= xFilial( "SZ5" )

	Local cMsgHelp
	Local cFieldPut
	Local cFieldGet

	Local lSZ4AddNew	:= .F.
	Local lSZ5AddNew	:= .F.
	Local lDistributing	:= .F.

	Local nSvN			:= n
	Local nField    	
	Local nFields		:= Len( aFields )
	Local nC7Quant		:= 0
	Local nC7Preco		:= 0
	Local nFieldPos		:= 0
	Local nSZ3Order		:= RetOrder( "SZ3" , "Z3_FILIAL+Z3_CODIGO+Z3_NUMSC" )
	Local nSZ2Order 	:= RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
	Local nSZ4Order 	:= RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
	Local nSZ5Order		:= RetOrder( "SZ5" , "Z5_FILIAL+Z5_CODIGO+Z5_NUMSC" )
	Local nSA2Order		:= RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" )    

	Local oException

	Local uGetPut

	TRYEXCEPTION

        StaticCall( NDJLIB001 , PutIncHrs , "SC7" , .F. )
		For nField := 1 To nFields
			cFieldPut := aFields[ nField ][1]
			IF ( IsInGetDados( cFieldPut ) )
				cFieldGet := aFields[ nField ][2]
				nFieldPos := SC1->( FieldPos( cFieldGet ) )
				IF ( nFieldPos > 0 )
				 	uGetPut := 	SC1->( FieldGet( nFieldPos ) )
					GdFieldPut( cFieldPut , uGetPut )
				EndIF
			EndIF
		Next nField
		cA2Reduz := PosAlias( "SA2" , cA120Forn+cA120Loj , NIL , "A2_NREDUZ" , nSA2Order , .F. )
        StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XDESFOR" , cA2Reduz , .F. )

		nC7Quant		:= GdFieldGet( "C7_QUANT" )
		lDistributing	:= ( ( nC7Quant > 0 ) .and. ( nC7Quant <> 1 ) )

		cC7Item		:= GdFieldGet( "C7_ITEM" 	)
		cC7XSZ2Cod	:= GdFieldGet( "C7_XSZ2COD"	)

		cSZ2KeySeek := cSZ2Filial
		cSZ2KeySeek += cC7XSZ2Cod
		cSZ2KeySeek += GdFieldGet( "C7_NUMSC"  )

		SZ2->( dbSetOrder( nSZ2Order ) )
		SZ3->( dbSetOrder( nSZ3Order ) )
		SZ4->( dbSetOrder( nSZ4Order ) )
		SZ5->( dbSetOrder( nSZ5Order ) )

		IF SZ3->( !dbSeek( cSZ2KeySeek , .F. ) )
			BREAK
		EndIF

		cSZ2KeySeek += GdFieldGet( "C7_ITEMSC" )

		IF SZ2->( !dbSeek( cSZ2KeySeek , .F. ) )
			BREAK
		EndIF

        SZ3->( StaticCall( U_NDJA001 , SZ2SZ3TTS ) )

		cSZ5KeySeek := cSZ5Filial
		cSZ5KeySeek += SZ3->Z3_CODIGO
		cSZ5KeySeek += SZ3->Z3_NUMSC

		lSZ5AddNew	:= SZ5->( !dbSeek( cSZ5KeySeek , .F. ) )

		IF SZ5->( RecLock( "SZ5" , lSZ5AddNew ) )
			SZ5->Z5_FILIAL	:= cSZ5Filial
			SZ5->Z5_CODIGO	:= SZ3->Z3_CODIGO
			SZ5->Z5_NUMSC	:= SZ3->Z3_NUMSC
			SZ5->( MsUnLock() )
		EndIF
        SZ5->( StaticCall( NDJLIB003 , LockSoft , "SZ5" ) )

        SZ5->( StaticCall( U_NDJA002 , SZ4SZ5TTS ) )

		nFields		:= Len( aHeader )

		nC7Preco	:= GdFieldGet( "C7_PRECO" )
		GdFieldPut( "C7_SEQUEN" , cC7Sequen )
		GdFieldPut( "C7_QUANT"  , SZ2->Z2_QUANT )
		GdFieldPut( "C7_TOTAL"	, SZ2->Z2_QUANT * nC7Preco )

		cSZ4KeySeek := cSZ4Filial
		cSZ4KeySeek += SZ2->Z2_CODIGO
		cSZ4KeySeek += GdFieldGet( "C7_NUMSC" )
		cSZ4KeySeek += GdFieldGet( "C7_ITEMSC" )
		cSZ4KeySeek += GdFieldGet( "C7_SEQUEN" )

		lSZ4AddNew	:= SZ4->( !dbSeek( cSZ4KeySeek , .F. ) )
	
		IF SZ4->( RecLock( "SZ4" , lSZ4AddNew ) )
			SZ4->Z4_FILIAL 	:= cSZ4Filial
			SZ4->Z4_CODIGO 	:= SZ2->Z2_CODIGO
			SZ4->Z4_NUMSC  	:= GdFieldGet( "C7_NUMSC" )
			SZ4->Z4_ITEMSC 	:= GdFieldGet( "C7_ITEMSC" )
			SZ4->Z4_SECITEM	:= GdFieldGet( "C7_SEQUEN" )
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
			SZ4->( MsUnLock() )
		EndIF
        SZ4->( StaticCall( NDJLIB003 , LockSoft , "SZ4" ) )

		IF !( lDistributing )
			BREAK
		EndIF

		SZ2->( dbSkip() )
		While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC == cSZ2KeySeek )

			cC7Item		:= __Soma1( cC7Item )
			cC7Sequen	:= __Soma1( cC7Sequen )

			aAdd( aCols , aClone( aCols[1] ) )
			++n

			For nField := 1 To nFields
				IF ( ( AllTrim( aHeader[ nField ] ) ) $ "C7_ITEM,C7_SEQUEN,C7_QUANT,C7_TOTAL" )
					Loop
				EndIF
				aCols[ n , nField ] := aCols[ 1 , nField ]
			Next nField

			GdFieldPut( "C7_ITEM" 	, cC7Item   )
			GdFieldPut( "C7_SEQUEN" , cC7Sequen )
			GdFieldPut( "C7_QUANT"  , SZ2->Z2_QUANT )
			GdFieldPut( "C7_TOTAL"	, SZ2->Z2_QUANT * nC7Preco )

			cSZ4KeySeek := cSZ4Filial
			cSZ4KeySeek += SZ2->Z2_CODIGO
			cSZ4KeySeek += GdFieldGet( "C7_NUMSC" )
			cSZ4KeySeek += GdFieldGet( "C7_ITEMSC" )
			cSZ4KeySeek += GdFieldGet( "C7_SEQUEN" )
			
			lSZ4AddNew	:= SZ4->( !dbSeek( cSZ4KeySeek , .F. ) )

			IF SZ4->( RecLock( "SZ4" , lSZ4AddNew ) )
				SZ4->Z4_FILIAL 	:= cSZ4Filial
				SZ4->Z4_CODIGO 	:= SZ2->Z2_CODIGO
				SZ4->Z4_NUMSC  	:= GdFieldGet( "C7_NUMSC" )
				SZ4->Z4_ITEMSC 	:= GdFieldGet( "C7_ITEMSC" )
				SZ4->Z4_SECITEM	:= GdFieldGet( "C7_SEQUEN" )
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
				SZ4->( MsUnLock() )
			EndIF

            SZ4->( StaticCall( NDJLIB003 , LockSoft , "SZ4" ) )
            
			MyFiscal()

			SZ2->( dbSkip() )

		End While

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			cMsgHelp += CRLF
			cMsgHelp += oException:ErrorStack
			ConOut( cMsgHelp )
		EndIF	

	ENDEXCEPTION

	n := nSvN

	RestArea( aAreaSZ4 )
	RestArea( aAreaSZ3 )
	RestArea( aAreaSZ2 )

Return( NIL )

Static Function MyFiscal()

	Local nPosCod	:= GdFieldPos( "C7_PRODUTO" )
	Local nPosPrc	:= GdFieldPos( "C7_PRECO" )
	Local nPosQuant := GdFieldPos( "C7_QUANT" )
	Local nPosDsc	:= GdFieldPos( "C7_VLDESC" )
	Local nPosTotal	:= GdFieldPos( "C7_TOTAL" )
	Local nPosGrade	:= GdFieldPos( "C7_GRADE" )
	Local nPosItGra	:= GdFieldPos( "C7_ITEMGRD" )
	Local nPosCC	:= GdFieldPos( "C7_CC" )
	Local nInclui

	IF ( nTipoPed == 1 )
		aCols[n,nPosGrade]		:= SC1->C1_GRADE
		aCols[n,nPosItGra]		:= SC1->C1_ITEMGRD
	ElseIF ( nTipoPed == 2 )
		aCols[n,nPosGrade]		:= SC3->C3_GRADE
		aCols[n,nPosItGra]		:= SC3->C3_ITEMGRD
		IF ( nPosCC > 0 )
			aCols[n][nPosCC]	:= SC3->C3_CC
		EndIf                	
		cCondicao	:= SC3->C3_COND
		cTpFrete	:= SC3->C3_TPFRETE+If(SC3->C3_TPFRETE="C","-CIF","-FOB")
	EndIF

	/*/
		Inicia a Carga do item nas funcoes MATXFIS
	/*/
	IF MaFisFound("IT",n)
		MaFisAlt("IT_QUANT",SuperVal(TransForm(0,PesqPictQt("C1_QUANT"))),n)
		MaColsToFis(aHeader,aCols,n,"MT120",.T.)
	EndIF

	nInclui := aScan(aCols,{|x| x[nPosQuant] == 0 .and. x[nPosTotal] == 0} )
	IF ( nInclui == 0 )
		MaFisAdd(aCols[n][nPosCod],"",aCols[n][nPosQuant],aCols[n][nPosPrc],aCols[n][nPosDsc],"","",,0,0,0,0,aCols[n][nPosTotal])
	EndIF

	MaFisAlt("IT_FRETE",SC3->C3_VALFRE,n)
	A120Tabela("C7_QUANT",SuperVal(TransForm(0,PesqPictQt("C1_QUANT"))))

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