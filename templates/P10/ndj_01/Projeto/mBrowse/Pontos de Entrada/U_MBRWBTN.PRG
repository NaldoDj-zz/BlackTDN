#INCLUDE "NDJ.CH"
/*/
	Funcao: 	MBRWBTN
	Autor:		Marinaldo de Jesus
	Data:		30/08/2011
	Uso:		Ponto de Entrada MBRWBTN (Eh executado ao Clicar nos Botoes do aRotina da mBrowse )
/*/
User Function MBRWBTN()

	Local cAlias		:= ParamIxb[ 1 ] 
	Local nRecno		:= ParamIxb[ 2 ] 
	Local nOption		:= ParamIxb[ 3 ] 
	Local cFunction		:= ParamIxb[ 4 ] 

	Local lRetMbrw		:= .T.
	
	Local oMarkBrow		:= GetMarkBrow()

	IF IsInCallStack( "MATA130" )
		IF ( "A130Gera" $ cFunction )
			lRetMbrw	:= MATA130Brow( @cAlias , @nRecno , @nOption , @cFunction , @oMarkBrow )
		EndIF	
	EndIF

Return( lRetMbrw )

/*/
	Funcao: 	MATA130Brow
	Autor:		Marinaldo de Jesus
	Data:		30/08/2011
	Uso:		Marcar Todas as SCs que Referem-se a Contratos
/*/
Static Function MATA130Brow( cAlias , nRecno , nOption , cFunction , oMarkBrow )

	Local aArea				:= GetArea()
	Local aAreaSC1			:= SC1->( GetArea() )
	Local aAreaAlias		:= ( cAlias )->( GetArea() )

	Local aKMark			:= {}
	Local aRecnos
	Local aStackP

	Local bKeySeek

	Local cStack
	Local cMarca
	Local cCampo
	Local cKeySeek

	Local lMarca
	Local lRetMbrw			:= .T.
	Local lC1XREFCNT

	Local nBL
	Local nEL
	Local nSC1Order

	BEGIN SEQUENCE

		cStack				:= Upper( "MarkBrowse" )
                    	
		cParameter			:= Upper( "cCampo" )
        cCampo                := StaticCall( NDJLIB006 , ReadStackParameters , @cStack , @cParameter , NIL , NIL , @aStackP )
		cParameter			:= Upper( "cMarca" )
        cMarca                := StaticCall( NDJLIB006 , ReadStackParameters , @cStack , @cParameter , NIL , NIL , @aStackP )

		bKeySeek			:= { || C1_FILIAL+C1_XNUMSC }

		( cAlias  )->( dbGoTop() )
		While ( cAlias )->( !Eof() )
            lMarca                := ( StaticCall( NDJLIB001 , __FieldGet , cAlias , cCampo  , .T. ) == cMarca )
            lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , cAlias , "C1_XREFCNT" , .T. )
			DEFAULT lC1XREFCNT	:= .F.
			IF (;
					( lMarca ) ;
					.and.;
					( lC1XREFCNT );
				)	
				cKeySeek		:= ( cAlias )->( Eval( bKeySeek ) )
				IF ( aScan( aKMark , { |cKey| ( cKey == cKeySeek ) } ) == 0 )
					aAdd( aKMark , cKeySeek )
				EndIF
			EndIF
			( cAlias )->( dbSkip() )
		End While

		nEL := Len( aKMark )
		IF ( nEL == 0 )
			BREAK
		EndIF

		nSC1Order	:= RetOrder( "SC1" , "C1_FILIAL+C1_XNUMSC+C1_XITEMSC" )
		( cAlias )->( dbSetOrder( nSC1Order ) )

		aRecnos		:= {}

		For nBL := 1 To nEL

			cKeySeek	:= aKMark[ nBL ]
			
			( cAlias )->( dbSeek( cKeySeek , .F. ) )

			While ( cAlias )->( !Eof() .and. Eval( bKeySeek ) == cKeySeek )
				( cAlias )->( aAdd( aRecnos , Recno() ) )
				( cAlias )->( dbSkip() )
			End While	

		Next nBL

		nEL	:= Len( aRecnos )
		IF ( nEL == 0 )
			BREAK
		EndIF

		For nBL := 1 To nEL
			( cAlias )->( dbGoto( aRecnos[ nBL ] ) )
			IF ( cAlias )->( !Eof() .and. !Bof() )
                IF !( StaticCall( NDJLIB001 , __FieldGet , cAlias , cCampo  , .T. ) == cMarca )
					( cAlias )->( Eval( oMarkBrow:bAval ) )
				EndIF
			EndIF
		Next nBL

		( cAlias )->( dbGoto( nRecno ) )

		oMarkBrow:oBrowse:Refresh()

		lRetMbrw	:= MsgYesNo( "Existe(m) Item(ns) Referente(s) a Contrato(s) Automaticamente Selecionado(s)" + CRLF + "Deseja Continuar?" )

	END SEQUENCE

	( cAlias )->( MsGoto( nRecno ) )

	RestArea( aAreaSC1 )
	RestArea( aAreaAlias )
	RestArea( aArea )

Return( lRetMbrw )

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