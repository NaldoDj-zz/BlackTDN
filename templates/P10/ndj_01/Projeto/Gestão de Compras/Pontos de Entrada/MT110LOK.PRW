#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT110LOK บ Autor ณ Jose Carlos Noronhaบ Data ณ  22/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na solicitacao de compras para  นฑฑ
ฑฑ             preencher automaticamente a linha do item da SC.           นฑฑ
ฑฑ                                                                        นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function MT110LOK()

	Local lRet 			:= .T.

	BEGIN SEQUENCE

		IF GdDeleted()
			BREAK
		EndIF

		ChkPmsInfo()	/*/ Recarrega o Conteudo dos campos C1_PROJET, C1_REVISA e C1_TAREFA /*/

		ReplicaDest()	/*/	Replica os Destinos /*/

		IF !( GdDeleted() )
            lRet := StaticCall(U_NDJA001,C1XSZ2CodVld)
			IF !( lRet )
				BREAK
			EndIF
		EndIF	

		lRet := ChkC1Quant()	/*/	Valida a Quantidade /*/
		IF !( lRet )
			BREAK
		EndIF

        lRet := StaticCall(U_NDJBLKSCVL,C1XPrecoVld)    /*/    Empenho por Valor /*/
		IF !( lRet )
			BREAK
		EndIF

		CopiaItem()

	END SEQUENCE

Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCopiaItem บ Autor ณ Jose Carlos Noronhaบ Data ณ  22/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada executado na solicitacao de compras para  นฑฑ
ฑฑ             preencher automaticamente a linha do item da SC.           นฑฑ
ฑฑ                                                                        นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
Static Function CopiaItem()

	Local lCopia := .F.
	Local nX

	BEGIN SEQUENCE

		IF IsInCallStack( "U_MT110TOK" )
			BREAK
		EndIF

		IF !( ALLTRIM(UPPER(Funname())) $ "MATA110|PMSA410" )
			BREAK
		EndIF

		Private nCopias  := 0
		If Type("N") <> "U"
			nUsado := Len(aHeader)
			If Len(aCols) >= 1 .AND. (IIf(ALTERA,IIf( N=Len(aCols),.T.,.F.),.T.)) .AND. Acols[N,nUsado+1] = .F.
				If GdFieldget("C1_XCOPIA") == "S"
					nIt       := N
					nSeq      := Val(GdFieldget("C1_ITEM"))
					nPos      := Len(aCols)
					nCopias   := 1
					GdFieldPut("C1_XCOPIA","N")
					For nx:= 1 To nCopias
						nSeq++
						nPos++
						cSeq = StrZero(nSeq,4)
						AADD(aCols, Aclone(aCols[nIt]))
						GdFieldPut("C1_ITEM",cSeq,nPos)
						GdFieldPut("C1_XCOPIA","N",nPos)
					Next nx
					lCopia := .T.
				Endif
			Endif
		Endif

	END SEQUENCE

Return( lCopia  )

/*/
	Funcao: 	ChkPmsInfo()
	Autor:		Marinaldo de Jesus
	Data:		18/11/2010
	Descricao:	Carregar os campos para uso no PMS que sao Obrigatorios
/*/
Static Function ChkPmsInfo()

	Local aFieldsS		:= { "C1_XPROJET"  , "C1_XREVISA" , "C1_XTAREFA" }
	Local aFieldsT		:= { "C1_PROJET"   , "C1_REVISA"  , "C1_TAREFA"  }
	Local aFieldsC		:= { NIL , NIL  , NIL }

	Local cField

	Local nField
	Local nFields
	Local nFieldPos

	Local uCnt

	BEGIN SEQUENCE

        IF !( StaticCall( NDJLIB001 , IsInGetDados , aFieldsS ) )
			BREAK
		EndIF

        IF !( StaticCall( NDJLIB001 , IsInGetDados , aFieldsT ) )
			BREAK
		EndIF

		nFields			:= Len( aFieldsS )
		For nField := 1 To nFields
			cField	 	:= 	aFieldsS[ nField ]
			nFieldPos	:= GdFieldPos( cField )
			IF ( nFieldPos > 0 )
				uCnt := GdFieldGet( cField )
				aFieldsC[ nField ] := uCnt
			EndIF
		Next nField

		nFields			:= Len( aFieldsT )
		For nField := 1 To nFields
			cField	 	:= 	aFieldsT[ nField ]
			nFieldPos	:= GdFieldPos( cField )
			IF ( nFieldPos > 0 )
				uCnt := aFieldsC[ nField ]
				GdFieldPut( cField , uCnt )
			EndIF
		Next nField

	END SEQUENCE

Return( NIL )

/*/
	Funcao: 	ReplicaDest()
	Autor:		Marinaldo de Jesus
	Data:		29/06/2011
	Descricao:	Verificar se Os Destinos deverao ser Replicados
/*/
Static Function ReplicaDest()

	Local aSZ2Fields

	Local cC1Item
	Local cSZ3Filial	:= xFilial( "SZ3" )
	Local cSZ2Filial	:= xFilial( "SZ2" , cSZ3Filial )
	Local cC1XSZ2Cod
	Local cSZ2KeySeek

	Local lDRepeat
	Local lReplicate	:= .F.

	Local nSZ2Order		:= RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
	Local nSZ3Order		:= RetOrder( "SZ3" , "Z3_FILIAL+Z3_NUMSC" )

	Local nRecno
	Local nField
	Local nFields
	Local nC1Quant
	Local nZ2Quant
	Local nZ2ItemSC

	BEGIN SEQUENCE

		SZ3->( dbSetOrder( nSZ3Order ) )
		IF SZ3->( !dbSeek( cSZ3Filial + cA110Num , .F. ) )
			BREAK
		EndIF

        SZ3->( StaticCall( U_NDJA001 , lUseC1ToZ3 , cSZ3Filial , Z3_CODIGO , .F. , .F. ) )

        SZ3->( StaticCall( NDJLIB003 , LockSoft , "SZ3" ) )

        lDRepeat := StaticCall( NDJLIB001 , __FieldGet , "SZ3" , "Z3_DREPEAT" , .T. )
		DEFAULT lDRepeat := .F.
		
		IF !( lDRepeat )
			BREAK
		EndIF

        IF !( StaticCall( NDJLIB001 , IsInGetDados , { "C1_ITEM" , "C1_QUANT" } ) )
			BREAK
		EndIF

		cC1Item		:= GdFieldGet( "C1_ITEM" )
		nC1Quant	:= GdFieldGet( "C1_QUANT" )
		
        cC1XSZ2Cod    := StaticCall( NDJLIB001 , __FieldGet , "SZ3" , "Z3_CODIGO" , .T. )

		cSZ2KeySeek	:= cSZ2Filial
		cSZ2KeySeek	+= cC1XSZ2Cod
		cSZ2KeySeek	+= cA110Num
		cSZ2KeySeek	+= cC1Item

		SZ2->( dbSetOrder( nSZ2Order ) )
					
		IF SZ2->( dbSeek( cSZ2KeySeek , .F. ) )
			BREAK
		EndIF

		cSZ2KeySeek	:= cSZ2Filial
		cSZ2KeySeek	+= cC1XSZ2Cod
		cSZ2KeySeek	+= cA110Num

		IF SZ2->( !dbSeek( cSZ2KeySeek , .F. ) )
			BREAK
		EndIF

		While SZ2->( !Eof() .and. ( cSZ2KeySeek == Z2_FILIAL+Z2_CODIGO+Z2_NUMSC ) )
			nRecno	:= SZ2->( Recno() )
			SZ2->( dbSkip() )
		End While

		SZ2->( dbGoTo( nRecno ) )
		IF SZ2->( Bof() .or. Eof() )
			BREAK
		EndIF

        aSZ2Fields     := SZ2->( StaticCall( NDJLIB001 , RegToArray , "SZ2" ) )
		nZ2ItemSC	:= SZ2->( FieldPos( "Z2_ITEMSC" ) )
		nZ2Quant	:= SZ2->( FieldPos( "Z2_QUANT"  ) )

		IF SZ2->( !RecLock( "SZ2" , .T. ) )
			BREAK
		EndIF

		nFields		:= Len( aSZ2Fields )
		For nField := 1 To nFields
			DO CASE
			CASE ( nField == nZ2ItemSC )
				SZ2->( FieldPut( nField , cC1Item ) )
			CASE ( nField == nZ2Quant )
				SZ2->( FieldPut( nField , nC1Quant ) )
			OTHERWISE
				SZ2->( FieldPut( nField , aSZ2Fields[ nField ] ) )
			ENDCASE
		Next nField

		SZ2->( MsUnLock() )
        SZ2->( StaticCall( NDJLIB003 , LockSoft , "SZ2" ) )

		lReplicate	:= .T.

	END SEQUENCE

Return( lReplicate )

/*/
	Funcao: 	ChkC1Quant()
	Autor:		Marinaldo de Jesus
	Data:		29/06/2011
	Descricao:	Verificar se a quantidade Informada no C1_QUANT esta OK
/*/
Static Function ChkC1Quant()

	Local cC1Item
	Local cSZ2Filial
	Local cC1XSZ2Cod
	Local cSZ2KeySeek

	Local lC1QuantOk	:= .T.

	Local nC1Quant		:= 0
	Local nZ2Quant		:= 0
	Local nSZ2Order
	
	BEGIN SEQUENCE

        IF !( StaticCall( NDJLIB001 , IsInGetDados , { "C1_QUANT" , "C1_XSZ2COD" , "C1_ITEM" } ) )
			BREAK
		EndIF
	
		nC1Quant	:= GdFieldGet( "C1_QUANT" )
		cC1Item		:= GdFieldGet( "C1_ITEM" )
		cC1XSZ2Cod	:= GdFieldGet( "C1_XSZ2COD" )

		nSZ2Order	:= RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
			
		SZ2->( dbSetOrder( nSZ2Order ) )

		cSZ2Filial	:= xFilial( "SZ2" )
			
		cSZ2KeySeek	:= cSZ2Filial
		cSZ2KeySeek	+= cC1XSZ2Cod
		cSZ2KeySeek	+= cA110Num
		cSZ2KeySeek	+= cC1Item

		lC1QuantOk	:= SZ2->( dbSeek( cSZ2KeySeek , .F. ) )
		IF !( lC1QuantOk )
			Help( "" , 1 , "C1XSZ2COD" , NIL , OemToAnsi( "Destino nใo Localizado" ) , 1 , 0 )
			BREAK
		EndIF

		While SZ2->( !Eof() .and. Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC == cSZ2KeySeek )
			nZ2Quant += SZ2->Z2_QUANT
			SZ2->( dbSkip() )
		End While
	
		lC1QuantOk := ( nZ2Quant == nC1Quant )
	
		IF !( lC1QuantOk )
			Help( "" , 1 , "Z2QUANT" , NIL , OemToAnsi( "Quantidade Informada nใo Corresponde ao Total informado nos Destinos" ) , 1 , 0 )
			BREAK
		EndIF

	END SEQUENCE

Return( lC1QuantOk )

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