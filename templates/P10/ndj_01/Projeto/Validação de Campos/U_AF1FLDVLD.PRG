#INCLUDE "NDJ.CH"
/*/
	Function:	AF1XCodorVld
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODOR
	Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCodorVld,<cAF1XCodDor>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function AF1XCodorVld( cAF1XCodDor , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local nSZFOrder

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCodDor := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODOR" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCodDor ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODOR" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODOR )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF
		
		cAF1XCodDor	:= StrZero( Val( cAF1XCodDor ) , TamSx3("AF1_XCODOR")[1] )
        StaticCall(NDJLIB001,SetMemVar, cAF1XCodDor )

		nSZFOrder	:= RetOrder( "SZF" , "ZF_FILIAL+STRZERO(ZF_XCODORI,3)" )
		lFieldOk	:= ExistCpo( "SZF" , @cAF1XCodDor , @nSZFOrder , @cMsgHelp , @lShowHelp )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODOR" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	AF1XCODINVLD
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODIN
		Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCODINVLD,<cAF1XCODIN>,<lShowHelp>,<cMsgHelp>)
/*/										   
Static Function AF1XCodInVld( cAF1XCODIN , lShowHelp , cMsgHelp )

	Local aArea			:= GetArea()
	
	Local cAF1CodMac
	Local cNextAlias	:= GetNextAlias()
	
	Local lFieldOk		:= .T.

	Local nSZBOrder

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCODIN := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODIN" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCODIN ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODIN" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODIN )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		nSZBOrder	:= RetOrder( "SZB" , "ZB_FILIAL+ZB_XCODIND" )
		lFieldOk	:= ExistCpo( "SZB" , @cAF1XCODIN , @nSZBOrder , @cMsgHelp , @lShowHelp )
		IF !( lFieldOk )
			BREAK
		EndIF

        cAF1CodMac := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODMA" , .F. )

		BEGINSQL ALIAS cNextAlias
			SELECT
				ZB_XCODIND
			FROM
				%table:SZB% SZB
			WHERE
				SZB.ZB_FILIAL = %exp:xFilial("SZB")%
			AND
		   		SZB.ZB_XCODMAC = %exp:cAF1CodMac%
		   	AND
		   		SZB.ZB_XCODIND = %exp:cAF1XCODIN%
			AND
				SZB.%NotDel%
		ENDSQL

		lFieldOk	:= (cNextAlias)->( !Eof() .and. !Bof() )
		IF !( lFieldOk )
			UserException( "Informação inválida para o Campo" )
		EndIF
		IF ( lFieldOk )
			lFieldOk := ( cAF1XCODIN == (cNextAlias)->ZB_XCODIND )
			IF !( lFieldOk )
				UserException( "Informação inválida para o Campo" )
			EndIF
		EndIF
		(cNextAlias)->( dbCloseArea() )

	CATCHEXCEPTION USING oException
	
		IF ( Select( cNextAlias ) > 0 )
			( cNextAlias )->( dbCloseArea() )
		EndIF

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODIN" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

	RestArea( aArea )

Return( lFieldOk )

/*/
	Function:	AF1XCODISVLD
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODIS
	Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCODISVLD,<cAF1XCODIS>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function AF1XCODISVld( cAF1XCODIS , lShowHelp , cMsgHelp )

	Local aArea			:= GetArea()
	
	Local cAF1xCodMa
	Local cNextAlias	:= GetNextAlias()

	Local lFieldOk		:= .T.

	Local nSZBOrder

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCODIS := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODIS" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCODIS ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODIS" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODIS )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		nSZBOrder	:= RetOrder( "SZB" , "ZB_FILIAL+ZB_XCODIND" )
		lFieldOk	:= ExistCpo( "SZB" , @cAF1XCODIS , @nSZBOrder , @cMsgHelp , @lShowHelp )
		IF !( lFieldOk )
			BREAK
		EndIF

        cAF1xCodMa := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODMA" , .F. )

		BEGINSQL ALIAS cNextAlias
			SELECT
				ZB_XCODIND
			FROM
				%table:SZB% SZB
			WHERE
				SZB.ZB_FILIAL = %exp:xFilial("SZB")%
			AND
		   		SZB.ZB_XCODMAC = %exp:cAF1xCodMa%
		   	AND
		   		SZB.ZB_XCODIND = %exp:cAF1XCODIS%
			AND
				SZB.%NotDel%
		ENDSQL

		lFieldOk	:= (cNextAlias)->( !Eof() .and. !Bof() )
		IF !( lFieldOk )
			UserException( "Informação inválida para o Campo" )
		EndIF
		IF ( lFieldOk )
			lFieldOk := ( cAF1XCODIS == (cNextAlias)->ZB_XCODIND )
			IF !( lFieldOk )
				UserException( "Informação inválida para o Campo" )
			EndIF
		EndIF
		(cNextAlias)->( dbCloseArea() )

	CATCHEXCEPTION USING oException
	
		IF ( Select( cNextAlias ) > 0 )
			( cNextAlias )->( dbCloseArea() )
		EndIF

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODIS" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

	RestArea( aArea )

Return( lFieldOk )

/*/
	Function:	AF1XCODOEVLD
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODOE
	Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCODOEVLD,<cAF1XCODOE>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function AF1XCODOEVld( cAF1XCODOE , lShowHelp , cMsgHelp )

	Local aArea			:= GetArea()
	
	Local cAF1xCodTe
	Local cNextAlias	:= GetNextAlias()

	Local lFieldOk		:= .T.

	Local nSZEOrder

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCODOE := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODOE" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCODOE ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODOE" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODOE )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		nSZEOrder	:= RetOrder( "SZE" , "ZE_FILIAL+ZE_XCODOBJ" )
		lFieldOk	:= ExistCpo( "SZE" , @cAF1XCODOE , @nSZEOrder , @cMsgHelp , @lShowHelp )
		IF !( lFieldOk )
			BREAK
		EndIF

        cAF1xCodTe := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODTE" , .F. )

		BEGINSQL ALIAS cNextAlias
			SELECT
				ZE_XCODOBJ
			FROM
				%table:SZE% SZE
			WHERE
				SZE.ZE_FILIAL = %exp:xFilial("SZE")%
			AND
		   		SZE.ZE_XCODTEM = %exp:cAF1xCodTe%
		   	AND
		   		SZE.ZE_XCODOBJ = %exp:cAF1XCODOE%
			AND
				SZE.%NotDel%
		ENDSQL

		lFieldOk	:= (cNextAlias)->( !Eof() .and. !Bof() )
		IF !( lFieldOk )
			UserException( "Informação inválida para o Campo" )
		EndIF
		IF ( lFieldOk )
			lFieldOk := ( cAF1XCODOE == (cNextAlias)->ZE_XCODOBJ )
			IF !( lFieldOk )
				UserException( "Informação inválida para o Campo" )
			EndIF
		EndIF
		(cNextAlias)->( dbCloseArea() )

	CATCHEXCEPTION USING oException
	
		IF ( Select( cNextAlias ) > 0 )
			( cNextAlias )->( dbCloseArea() )
		EndIF

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODOE" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

	RestArea( aArea )

Return( lFieldOk )

/*/
	Function:	AF1XCODSPVLD
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODSP
	Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCODSPVLD,<cAF1XCODSP>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function AF1XCODSPVld( cAF1XCODSP , lShowHelp , cMsgHelp )

	Local aArea			:= GetArea()

	Local lFieldOk		:= .T.

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCODSP := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODSP" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCODSP ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODSP" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODSP )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		PswOrder(1)
		lFieldOk	:= PswSeek( cAF1XCODSP )
		IF !( lFieldOk )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "Usuário não Cadastrado"
			UserException( cMsgHelp )
		EndIF

        StaticCall(NDJLIB001,SetMemVar, "AF1_XSPON" , PswRet(1)[1][4] )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODSP" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

	RestArea( aArea )

Return( lFieldOk )

/*/
	Function:	AF1XCODGEVLD
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo AF1_XCODGE
	Sintaxe:	StaticCall(U_AF1FLDVLD,AF1XCODGEVLD,<cAF1XCODGE>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function AF1XCODGEVld( cAF1XCODGE , lShowHelp , cMsgHelp )

	Local aArea			:= GetArea()

	Local lFieldOk		:= .T.

	Local oException

	TRYEXCEPTION

        DEFAULT cAF1XCODGE := StaticCall( NDJLIB001 , __FieldGet , "AF1" , "AF1_XCODGE" , .F. )

		IF !( lFieldOk := !Empty( cAF1XCODGE ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "AF1_XCODGE" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( AF1_XCODGE )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		PswOrder(1)
		lFieldOk	:= PswSeek( cAF1XCODGE )
		IF !( lFieldOk )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp := ""
			cMsgHelp += "Usuário não Cadastrado"
			UserException( cMsgHelp )
		EndIF

        StaticCall(NDJLIB001,SetMemVar, "AF1_XGER" , PswRet(1)[1][4] )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			cMsgHelp := oException:Description
			DEFAULT lShowHelp := .T.
			IF (;
			    	!( lFieldOk );
			    	.and.;
			    	( lShowHelp );
			    	.and.;
					!( Empty( cMsgHelp ) );
				)
				Help( "" , 1 , "AF1_XCODGE" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

	RestArea( aArea )

Return( lFieldOk )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		AF1XCODGEVLD()
    	AF1XCODINVLD()
    	AF1XCODISVLD()
    	AF1XCODOEVLD()
    	AF1XCODORVLD()
    	AF1XCODSPVLD()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )