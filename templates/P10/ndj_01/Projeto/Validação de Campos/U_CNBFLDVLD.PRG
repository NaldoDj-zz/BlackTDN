#INCLUDE "NDJ.CH"
/*/
	Function:	CNBNumScVld
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Validar o conteudo do campo CNB_NUMSC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBNumScVld,<cCNBNumSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBNumScVld( cCNBNumSc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBNumSc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_NUMSC" )

		IF !( lFieldOk := !Empty( cCNBNumSc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_NUMSC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_NUMSC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBNumSc )
            StaticCall(NDJLIB001,SetMemVar, "CNB_NUMSC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_NUMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBNumScWhen
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Verificar se o campo CNB_NUMSC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBNumScWhen)
/*/
Static Function CNBNumScWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_NUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBNumScInit
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Inicializadora Padrao para o Campo "CNB_NUMSC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBNumScInit)
/*/
Static Function CNBNumScInit()

	Local cCNBNumSc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
		
			cCNBNumSc	:= SC7->C7_NUMSC
		
		Else
		
			cCNBNumSc	:= Space( GetSx3Cache( "CNB_NUMSC" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_NUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBNumSc )

/*/
	Function:	CNBItemScVld
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Validar o conteudo do campo CNB_ITEMSC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBItemScVld,<cCNBItemSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBItemScVld( cCNBItemSc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBItemSc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_ITEMSC" )

		IF !( lFieldOk := !Empty( cCNBItemSc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_ITEMSC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_ITEMSC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBItemSc )
               StaticCall(NDJLIB001,SetMemVar, "CNB_ITEMSC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_ITEMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBItemScWhen
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Verificar se o campo CNB_ITEMSC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBItemScWhen)
/*/
Static Function CNBItemScWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_ITEMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBItemScInit
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Inicializadora Padrao para o Campo "CNB_ITEMSC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBItemScInit)
/*/
Static Function CNBItemScInit()

	Local cCNBItemSc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBItemSc	:= SC7->C7_ITEMSC
		
		Else
			
			cCNBItemSc	:= Space( GetSx3Cache( "CNB_ITEMSC" , "X3_TAMANHO" ) )		
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_ITEMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBItemSc )

/*/
	Function:	CNBXNumScVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XNUMSC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumScVld,<cCNBXNumSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXNumScVld( cCNBXNumSc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXNumSc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XNUMSC" )

		IF !( lFieldOk := !Empty( cCNBXNumSc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XNUMSC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XNUMSC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXNumSc )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XNUMSC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XNUMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXNumScWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XNUMSC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumScWhen)
/*/
Static Function CNBXNumScWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXNumScInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XNUMSC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumScInit)
/*/
Static Function CNBXNumScInit()

	Local cCNBXNumSc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXNumSc	:= SC7->C7_NUMSC
		
		Else
			
			cCNBXNumSc	:= Space( GetSx3Cache( "CNB_XNUMSC" , "X3_TAMANHO" ) )		
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXNumSc )

/*/
	Function:	CNBXItmScVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XITMSC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmScVld,<cCNBXItmSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXItmScVld( cCNBXItmSc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXItmSc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XITMSC" )

		IF !( lFieldOk := !Empty( cCNBXItmSc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XITMSC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XITMSC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXItmSc )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XITMSC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XITMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXItmScWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XITMSC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmScWhen)
/*/
Static Function CNBXItmScWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXItmScInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XITMSC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmScInit)
/*/
Static Function CNBXItmScInit()

	Local cCNBXItmSc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXItmSc	:= SC7->C7_ITEMSC
		
		Else
			
			cCNBXItmSc	:= Space( GetSx3Cache( "CNB_XITMSC" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXItmSc )

/*/
	Function:	CNBXNumPcVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XNUMPC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumPcVld,<cCNBXNumPc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXNumPcVld( cCNBXNumPc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXNumPc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XNUMPC" )

		IF !( lFieldOk := !Empty( cCNBXNumPc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XNUMPC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XNUMPC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXNumPc )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XNUMPC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XNUMPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXNumPcWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XNUMPC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumPcWhen)
/*/
Static Function CNBXNumPcWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNUMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXNumPcInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XNUMPC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNumPcInit)
/*/
Static Function CNBXNumPcInit()

	Local cCNBXNumPc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXNumPc	:= SC7->C7_NUM
		
		Else
			
			cCNBXNumPc	:= Space( GetSx3Cache( "CNB_XNUMPC" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNUMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXNumPc )

/*/
	Function:	CNBXItmPcVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XITMPC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmPcVld,<cCNBXItmPc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXItmPcVld( cCNBXItmPc , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXItmPc := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XITMPC" )

		IF !( lFieldOk := !Empty( cCNBXItmPc ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XITMPC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XITMPC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXItmPc )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XITMPC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XITMPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXItmPcWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XITMPC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmPcWhen)
/*/
Static Function CNBXItmPcWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXItmPcInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XITMPC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXItmPcInit)
/*/
Static Function CNBXItmPcInit()

	Local cCNBXItmPc

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXItmPc	:= SC7->C7_ITEM
		
		Else
			
			cCNBXItmPc	:= Space( GetSx3Cache( "CNB_XITMPC" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXItmPc )

/*/
	Function:	CNBXSeqPCVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XSEQPC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSeqPCVld,<cCNBXSeqPC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXSeqPCVld( cCNBXSeqPC , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXSeqPC := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XSEQPC" )

		IF !( lFieldOk := !Empty( cCNBXSeqPC ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XSEQPC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XSEQPC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXSeqPC )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XSEQPC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XSEQPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXSeqPCWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XSEQPC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSeqPCWhen)
/*/
Static Function CNBXSeqPCWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSEQPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXSeqPCInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XSEQPC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSeqPCInit)
/*/
Static Function CNBXSeqPCInit()

	Local cCNBXSeqPC

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXSeqPC	:= SC7->C7_SEQUEN
		
		Else
			
			cCNBXSeqPC	:= Space( GetSx3Cache( "CNB_XSEQPC" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSEQPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXSeqPC )

/*/
	Function:	CNBXSZ2COVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XSZ2CO
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSZ2COVld,<cCNBXSZ2CO>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXSZ2COVld( cCNBXSZ2CO , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXSZ2CO := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XSZ2CO" )

		IF !( lFieldOk := !Empty( cCNBXSZ2CO ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XSZ2CO" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XSZ2CO )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXSZ2CO )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XSZ2CO" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XSZ2CO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXSZ2COWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XSZ2CO pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSZ2COWhen)
/*/
Static Function CNBXSZ2COWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSZ2CO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXSZ2COInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XSZ2CO"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSZ2COInit)
/*/
Static Function CNBXSZ2COInit()

	Local cCNBXSZ2CO

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXSZ2CO	:= SC7->C7_XSZ2COD
		
		Else
			
			cCNBXSZ2CO	:= Space( GetSx3Cache( "CNB_XSZ2CO" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSZ2CO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXSZ2CO )

/*/
	Function:	CNBXCODSBVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCODSB
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODSBVld,<cCNBXCODSB>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCODSBVld( cCNBXCODSB , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCODSB := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCODSB" )

		IF !( lFieldOk := !Empty( cCNBXCODSB ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCODSB" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCODSB )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCODSB )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCODSB" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCODSB" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCODSBWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XCODSB pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODSBWhen)
/*/
Static Function CNBXCODSBWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODSB" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCODSBInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCODSB"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODSBInit)
/*/
Static Function CNBXCODSBInit()

	Local cCNBXCODSB

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCODSB	:= SC7->C7_XCODSBM
		
		Else
			
			cCNBXCODSB	:= Space( GetSx3Cache( "CNB_XCODSB" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODSB" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCODSB )

/*/
	Function:	CNBXSBMVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XSBM
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSBMVld,<cCNBXSBM>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXSBMVld( cCNBXSBM , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXSBM := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XSBM" )

		IF !( lFieldOk := !Empty( cCNBXSBM ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XSBM" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XSBM )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXSBM )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XSBM" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XSBM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXSBMWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XSBM pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSBMWhen)
/*/
Static Function CNBXSBMWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSBM" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXSBMInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XSBM"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXSBMInit)
/*/
Static Function CNBXSBMInit()

	Local cCNBXSBM

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXSBM	:= SC7->C7_XSBM

		Else
			
			cCNBXSBM	:= Space( GetSx3Cache( "CNB_XSBM" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XSBM" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXSBM )

/*/
	Function:	CNBXPROJEVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XPROJE
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROJEVld,<cCNBXPROJE>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXPROJEVld( cCNBXPROJE , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXPROJE := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XPROJE" )

		IF !( lFieldOk := !Empty( cCNBXPROJE ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XPROJE" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XPROJE )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXPROJE )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XPROJE" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XPROJE" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXPROJEWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XPROJE pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROJEWhen)
/*/
Static Function CNBXPROJEWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XPROJE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXPROJEInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XPROJE"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROJEInit)
/*/
Static Function CNBXPROJEInit()

	Local cCNBXPROJE

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXPROJE	:= SC7->C7_XPROJET

		Else
			
			cCNBXPROJE	:= Space( GetSx3Cache( "CNB_XPROJE" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XPROJE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXPROJE )

/*/
	Function:	CNBXREVISVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XREVIS
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXREVISVld,<cCNBXREVIS>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXREVISVld( cCNBXREVIS , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXREVIS := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XREVIS" )

		IF !( lFieldOk := !Empty( cCNBXREVIS ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XREVIS" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XREVIS )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXREVIS )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XREVIS" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XREVIS" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXREVISWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XREVIS pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXREVISWhen)
/*/
Static Function CNBXREVISWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XREVIS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXREVISInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XREVIS"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXREVISInit)
/*/
Static Function CNBXREVISInit()

	Local cCNBXREVIS
    
	Local nSC1Order		:= RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			IF ( SC7->( FieldPos( "C7_XREVIS" ) ) > 0 )
				cCNBXREVIS	:= SC7->C7_XREVIS
			EndIF
			IF Empty( cCNBXREVIS )
				cCNBXREVIS	:= SC7->( Posicione( "SC1" , nSC1Order , xFilial( "SC1" ) + C7_NUMSC + C7_ITEMSC , "C1_REVISA" ) )
			EndIF	
	
		Else
			
			cCNBXREVIS	:= Space( GetSx3Cache( "CNB_XREVIS" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XREVIS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXREVIS )

/*/
	Function:	CNBXTAREFVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XTAREF
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXTAREFVld,<cCNBXTAREF>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXTAREFVld( cCNBXTAREF , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXTAREF := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XTAREF" )

		IF !( lFieldOk := !Empty( cCNBXTAREF ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XTAREF" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XTAREF )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXTAREF )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XTAREF" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XTAREF" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXTAREFWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XTAREF pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXTAREFWhen)
/*/
Static Function CNBXTAREFWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XTAREF" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXTAREFInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XTAREF"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXTAREFInit)
/*/
Static Function CNBXTAREFInit()

	Local cCNBXTAREF

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXTAREF	:= SC7->C7_XTAREFA
	
		Else
			
			cCNBXTAREF	:= Space( GetSx3Cache( "CNB_XTAREF" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XTAREF" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXTAREF )

/*/
	Function:	CNBXCODORVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCODOR
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODORVld,<cCNBXCODOR>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCODORVld( cCNBXCODOR , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCODOR := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCODOR" )

		IF !( lFieldOk := !Empty( cCNBXCODOR ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCODOR" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCODOR )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCODOR )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCODOR" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCODOR" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCODORWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XCODOR pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODORWhen)
/*/
Static Function CNBXCODORWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODOR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCODORInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCODOR"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODORInit)
/*/
Static Function CNBXCODORInit()

	Local cCNBXCODOR

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCODOR	:= SC7->C7_XCODOR
	
		Else
			
			cCNBXCODOR	:= Space( GetSx3Cache( "CNB_XCODOR" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODOR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCODOR )

/*/
	Function:	CNBXCODCAVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCODCA
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODCAVld,<cCNBXCODCA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCODCAVld( cCNBXCODCA , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCODCA := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCODCA" )

		IF !( lFieldOk := !Empty( cCNBXCODCA ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCODCA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCODCA )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCODCA )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCODCA" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCODCA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCODCAWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XCODCA pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODCAWhen)
/*/
Static Function CNBXCODCAWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCODCAInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCODCA"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODCAInit)
/*/
Static Function CNBXCODCAInit()

	Local cCNBXCODCA

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCODCA	:= SC7->C7_CODORCA
	
		Else
			
			cCNBXCODCA	:= Space( GetSx3Cache( "CNB_XCODCA" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCODCA )

/*/
	Function:	CNBXINCHRVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XINCHR
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXINCHRVld,<cCNBXINCHR>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXINCHRVld( cCNBXINCHR , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException

	TRYEXCEPTION

        DEFAULT cCNBXINCHR := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XINCHR" )

		IF !( lFieldOk := !Empty( cCNBXINCHR ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XINCHR" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XINCHR )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

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
				Help( "" , 1 , "CNB_XINCHR" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk )

/*/
	Function:	CNBXINCHRWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XINCHR pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXINCHRWhen)
/*/
Static Function CNBXINCHRWhen()
	Local lChange := .F.
Return( lChange  )

/*/
	Function:	CNBXINCHRInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XINCHR"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXINCHRInit)
/*/
Static Function CNBXINCHRInit()

	Local cCNBXINCHR

	Local oException

	TRYEXCEPTION

		cCNBXINCHR	:= Time()

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XINCHR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXINCHR )

/*/
	Function:	CNBXALHRSVld
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Validar o conteudo do campo CNB_XALHRS
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXALHRSVld,<cCNBXALHRS>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXALHRSVld( cCNBXALHRS , lShowHelp , cMsgHelp )
	Local lFieldOk		:= .T.
Return( lFieldOk )

/*/
	Function:	CNBXALHRSWhen
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Verificar se o campo CNB_XALHRS pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXALHRSWhen)
/*/
Static Function CNBXALHRSWhen()
	Local lChange := .F.
Return( lChange  )

/*/
	Function:	CNBXALHRSInit
	Autor:		Marinaldo de Jesus
	Data:		24/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XALHRS"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXALHRSInit)
/*/
Static Function CNBXALHRSInit()

	Local cCNBXALHRS

	Local oException

	TRYEXCEPTION

		cCNBXALHRS	:= Space( GetSX3Cache( "CNB_XALHRS" , "X3_TAMANHO" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XALHRS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXALHRS )

/*/
	Function:	CNBXEQUIPVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XEQUIP
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXEQUIPVld,<cCNBXEQUIP>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXEQUIPVld( cCNBXEQUIP , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF
        
        DEFAULT cCNBXEQUIP := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XEQUIP" )

		IF !( lFieldOk := !Empty( cCNBXEQUIP ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XEQUIP" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XEQUIP )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXEQUIP )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XEQUIP" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XEQUIP" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXEQUIPWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XEQUIP pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXEQUIPWhen)
/*/
Static Function CNBXEQUIPWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XEQUIP" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXEQUIPInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XEQUIP"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXEQUIPInit)
/*/
Static Function CNBXEQUIPInit()

	Local cCNBXEQUIP

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXEQUIP	:= SC7->C7_XEQUIPA
	
		Else
			
			cCNBXEQUIP	:= Space( GetSx3Cache( "CNB_XEQUIP" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XEQUIP" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXEQUIP )

/*/
	Function:	CNBXNRPROVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XNRPRO
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNRPROVld,<cCNBXNRPRO>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXNRPROVld( cCNBXNRPRO , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXNRPRO := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XNRPRO" )

		IF !( lFieldOk := !Empty( cCNBXNRPRO ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XNRPRO" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XNRPRO )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXNRPRO )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XNRPRO" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XNRPRO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXNRPROWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XNRPRO pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNRPROWhen)
/*/
Static Function CNBXNRPROWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNRPRO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXNRPROInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XNRPRO"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXNRPROInit)
/*/
Static Function CNBXNRPROInit()

	Local cCNBXNRPRO

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXNRPRO	:= SC7->C7_XNUMPRO
	
		Else
			
			cCNBXNRPRO	:= Space( GetSx3Cache( "CNB_XNRPRO" , "X3_TAMANHO" ) )
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XNRPRO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXNRPRO )

/*/
	Function:	CNBXMODALVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XMODAL
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODALVld,<cCNBXMODAL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXMODALVld( cCNBXMODAL , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXMODAL := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XMODAL" )

		IF !( lFieldOk := !Empty( cCNBXMODAL ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XMODAL" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XMODAL )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXMODAL )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XMODAL" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XMODAL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXMODALWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XMODAL pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODALWhen)
/*/
Static Function CNBXMODALWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMODAL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXMODALInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XMODAL"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODALInit)
/*/
Static Function CNBXMODALInit()

	Local cCNBXMODAL

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXMODAL	:= SC7->C7_XMODALI

		Else

			cCNBXMODAL	:= Space( GetSx3Cache( "CNB_XMODAL" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMODAL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXMODAL )

/*/
	Function:	CNBXPROP1Vld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XPROP1
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROP1Vld,<cCNBXPROP1>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXPROP1Vld( cCNBXPROP1 , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXPROP1 := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XPROP1" )

		IF !( lFieldOk := !Empty( cCNBXPROP1 ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XPROP1" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XPROP1 )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXPROP1 )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XPROP1" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XPROP1" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXPROP1When
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XPROP1 pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROP1When)
/*/
Static Function CNBXPROP1When()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XPROP1" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXPROP1Init
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XPROP1"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXPROP1Init)
/*/
Static Function CNBXPROP1Init()

	Local cCNBXPROP1

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXPROP1	:= SC7->C7_XPROP1

		Else

			cCNBXPROP1	:= Space( GetSx3Cache( "CNB_XPROP1" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XPROP1" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXPROP1 )

/*/
	Function:	CNBXMARCAVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XMARCA
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMARCAVld,<cCNBXMARCA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXMARCAVld( cCNBXMARCA , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXMARCA := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XMARCA" )

		IF !( lFieldOk := !Empty( cCNBXMARCA ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XMARCA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XMARCA )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXMARCA )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XMARCA" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XMARCA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXMARCAWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XMARCA pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMARCAWhen)
/*/
Static Function CNBXMARCAWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMARCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXMARCAInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XMARCA"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMARCAInit)
/*/
Static Function CNBXMARCAInit()

	Local cCNBXMARCA

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXMARCA	:= SC7->C7_XMARCA

		Else

			cCNBXMARCA	:= Space( GetSx3Cache( "CNB_XMARCA" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMARCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXMARCA )

/*/
	Function:	CNBXMODELVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XMODEL
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODELVld,<cCNBXMODEL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXMODELVld( cCNBXMODEL , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXMODEL := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XMODEL" )

		IF !( lFieldOk := !Empty( cCNBXMODEL ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XMODEL" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XMODEL )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXMODEL )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XMODEL" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XMODEL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXMODELWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XMODEL pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODELWhen)
/*/
Static Function CNBXMODELWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMODEL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXMODELInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XMODEL"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXMODELInit)
/*/
Static Function CNBXMODELInit()

	Local cCNBXMODEL

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXMODEL	:= SC7->C7_XMODELO

		Else

			cCNBXMODEL	:= Space( GetSx3Cache( "CNB_XMODEL" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XMODEL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXMODEL )

/*/
	Function:	CNBXGARAVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XGARA
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXGARAVld,<cCNBXGARA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXGARAVld( cCNBXGARA , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXGARA := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XGARA" )

		IF !( lFieldOk := !Empty( cCNBXGARA ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XGARA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XGARA )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXGARA )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XGARA" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XGARA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXGARAWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XGARA pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXGARAWhen)
/*/
Static Function CNBXGARAWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XGARA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXGARAInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XGARA"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXGARAInit)
/*/
Static Function CNBXGARAInit()

	Local nCNBXGARA

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			nCNBXGARA	:= SC7->C7_XGARA

		Else

			nCNBXGARA	:= 0

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XGARA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( nCNBXGARA )

/*/
	Function:	CNBXCCVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCCVld,<cCNBXCC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCCVld( cCNBXCC , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCC := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCC" )

		IF !( lFieldOk := !Empty( cCNBXCC ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCC )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCCWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XCC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCCWhen)
/*/
Static Function CNBXCCWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCCInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCCInit)
/*/
Static Function CNBXCCInit()

	Local cCNBXCC

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCC	:= SC7->C7_CC

		Else

			cCNBXCC	:= Space( GetSx3Cache( "CNB_XCC" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCC )

/*/
	Function:	CNBXCONTAVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCONTA
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCONTAVld,<cCNBXCONTA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCONTAVld( cCNBXCONTA , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCONTA := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCONTA" )

		IF !( lFieldOk := !Empty( cCNBXCONTA ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCONTA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCONTA )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCONTA )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCONTA" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCONTA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCONTAWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XCONTA pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCONTAWhen)
/*/
Static Function CNBXCONTAWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCONTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCONTAInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCONTA"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCONTAInit)
/*/
Static Function CNBXCONTAInit()

	Local cCNBXCONTA

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCONTA	:= SC7->C7_CONTA

		Else

			cCNBXCONTA	:= Space( GetSx3Cache( "CNB_XCONTA" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCONTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCONTA )

/*/
	Function:	CNBXITCTAVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XITCTA
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXITCTAVld,<cCNBXITCTA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXITCTAVld( cCNBXITCTA , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXITCTA := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XITCTA" )

		IF !( lFieldOk := !Empty( cCNBXITCTA ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XITCTA" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XITCTA )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXITCTA )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XITCTA" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XITCTA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXITCTAWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XITCTA pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXITCTAWhen)
/*/
Static Function CNBXITCTAWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITCTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXITCTAInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XITCTA"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXITCTAInit)
/*/
Static Function CNBXITCTAInit()

	Local cCNBXITCTA

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXITCTA	:= SC7->C7_ITEMCTA

		Else

			cCNBXITCTA	:= Space( GetSx3Cache( "CNB_XITCTA" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XITCTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXITCTA )

/*/
	Function:	CNBXCLVLVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCLVL
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCLVLVld,<cCNBXCLVL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCLVLVld( cCNBXCLVL , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBXCLVL := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCLVL" )

		IF !( lFieldOk := !Empty( cCNBXCLVL ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_XCLVL" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_XCLVL )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBXCLVL )
            StaticCall(NDJLIB001,SetMemVar, "CNB_XCLVL" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_XCLVL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBXCLVLWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XCLVL pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCLVLWhen)
/*/
Static Function CNBXCLVLWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCLVL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCLVLInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCLVL"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCLVLInit)
/*/
Static Function CNBXCLVLInit()

	Local cCNBXCLVL

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCLVL	:= SC7->C7_CLVL

		Else

			cCNBXCLVL	:= Space( GetSx3Cache( "CNB_XCLVL" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCLVL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCLVL )

/*/
	Function:	CNBUSERPCVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_USERPC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERPCVld,<cCNBUSERPC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBUSERPCVld( cCNBUSERPC , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBUSERPC := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_USERPC" )

		IF !( lFieldOk := !Empty( cCNBUSERPC ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_USERPC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_USERPC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBUSERPC )
            StaticCall(NDJLIB001,SetMemVar, "CNB_USERPC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_USERPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBUSERPCWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_USERPC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERPCWhen)
/*/
Static Function CNBUSERPCWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_USERPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBUSERPCInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_USERPC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERPCInit)
/*/
Static Function CNBUSERPCInit()

	Local cCNBUSERPC

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBUSERPC	:= SC7->C7_USER

		Else

			cCNBUSERPC	:= Space( GetSx3Cache( "CNB_USERPC" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_USERPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBUSERPC )

/*/
	Function:	CNBUSERSCVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_USERSC
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERSCVld,<cCNBUSERSC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBUSERSCVld( cCNBUSERSC , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBUSERSC := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_USERSC" )

		IF !( lFieldOk := !Empty( cCNBUSERSC ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_USERSC" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_USERSC )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBUSERSC )
            StaticCall(NDJLIB001,SetMemVar, "CNB_USERSC" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_USERSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBUSERSCWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_USERSC pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERSCWhen)
/*/
Static Function CNBUSERSCWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_USERSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBUSERSCInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_USERSC"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBUSERSCInit)
/*/
Static Function CNBUSERSCInit()

	Local cCNBUSERSC

	Local oException

	TRYEXCEPTION
		
        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBUSERSC	:= SC7->C7_USERSC

		Else

			cCNBUSERSC	:= Space( GetSx3Cache( "CNB_USERSC" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_USERSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBUSERSC )

/*/
	Function:	CNBXCODGEInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCODGE"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCODGEInit)
/*/
Static Function CNBXCODGEInit()

	Local cCNBXCODGE

	Local oException

	TRYEXCEPTION
		
        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCODGE	:= SC7->C7_XCODGE

		Else

			cCNBXCODGE	:= Space( GetSx3Cache( "CNB_XCODGE" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCODGE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCODGE )

/*/
	Function:	CNBXVISCTInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XVISCT"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXVISCTInit)
/*/
Static Function CNBXVISCTInit()

	Local cCNBXVISCT

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXVISCT	:= SC7->C7_XVISCTB

		Else

			cCNBXVISCT	:= Space( GetSx3Cache( "CNB_XVISCT" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XVISCT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXVISCT )

/*/
	Function:	CNBXCIRQTWhen
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Verificar se o campo CNB_XCIRQT pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCIRQTWhen)
/*/
Static Function CNBXCIRQTWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCIRQT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBXCIRQTInit
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Inicializadora Padrao para o Campo "CNB_XCIRQT"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCIRQTInit)
/*/
Static Function CNBXCIRQTInit()

	Local cCNBXCIRQT

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBXCIRQT	:= Space( GetSx3Cache( "CNB_XCIRQT" , "X3_TAMANHO" ) )

		Else

			cCNBXCIRQT	:= Space( GetSx3Cache( "CNB_XCIRQT" , "X3_TAMANHO" ) )

		EndIF

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_XCIRQT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBXCIRQT )

/*/
	Function:	CNBXCIRQTVld
	Autor:		Marinaldo de Jesus
	Data:		26/12/2010
	Descricao:	Validar o conteudo do campo CNB_XCIRQT
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBXCIRQTVld,<cCNBXCIRQT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBXCIRQTVld( cCNBXCIRQT , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        DEFAULT cCNBXCIRQT := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_XCIRQT" )

		IF ( lFieldOk := Empty( cCNBXCIRQT ) )
			BREAK
		EndIF
        
		lFieldOk	:= ExistCpo( "SZ8" , cCNBXCIRQT , RetOrder("SZ8","Z8_FILIAL+Z8_CODIGO" , NIL , @lShowHelp ) )
		IF !( lFieldOk )
			BREAK
		EndIF
		
		StaticCall( U_XALTHRS , XALTHRS , "CNB" )

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
				Help( "" , 1 , "CNB_XCIRQT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBITEGRDVld
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Validar o conteudo do campo CNB_ITEGRD
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBITEGRDVld,<cCNBITEGRD>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNBITEGRDVld( cCNBITEGRD , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.

	Local oException
	
	Local uLastCnt

	TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
			StaticCall( U_XALTHRS , XALTHRS , "CNB" )
			BREAK
		EndIF

        DEFAULT cCNBITEGRD := StaticCall( NDJLIB001 , __FieldGet , "CNB" , "CNB_ITEGRD" )

		IF !( lFieldOk := !Empty( cCNBITEGRD ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "CNB_ITEGRD" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( CNB_ITEGRD )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		uLastCnt	:= StaticCall( U_XALTHRS , GetChkAlt )
		IF !( uLastCnt == cCNBITEGRD )
            StaticCall(NDJLIB001,SetMemVar, "CNB_ITEGRD" , uLastCnt )
		EndIF	

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
				Help( "" , 1 , "CNB_ITEGRD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk  )

/*/
	Function:	CNBITEGRDWhen
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Verificar se o campo CNB_ITEGRD pode ser alterado
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBITEGRDWhen)
/*/
Static Function CNBITEGRDWhen()

	Local lChange		:= .T.

	Local oException

	TRYEXCEPTION

		StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_ITEGRD" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( lChange  )

/*/
	Function:	CNBITEGRDInit
	Autor:		Marinaldo de Jesus
	Data:		18/04/2011
	Descricao:	Inicializadora Padrao para o Campo "CNB_ITEGRD"
	Sintaxe:	StaticCall(U_CNBFLDVLD,CNBITEGRDInit)
/*/
Static Function CNBITEGRDInit()

	Local cCNBITEGRD

	Local oException

	TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )

			cCNBITEGRD	:= SC7->C7_ITEMGRD
		
		Else
			
			cCNBITEGRD	:= Space( GetSx3Cache( "CNB_ITEGRD" , "X3_TAMANHO" ) )		
		
		EndIF	

	CATCHEXCEPTION USING oException

		IF ( ValType( oException ) == "O" )
			Help( "" , 1 , "CNB_ITEGRD" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
	    EndIF

	ENDEXCEPTION

Return( cCNBITEGRD )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		CNBITEMSCINIT()
		CNBITEMSCVLD()
		CNBITEMSCWHEN()
		CNBNUMSCINIT()
		CNBNUMSCVLD()
		CNBNUMSCWHEN()
		CNBUSERPCINIT()
		CNBUSERPCVLD()
		CNBUSERPCWHEN()
		CNBUSERSCINIT()
		CNBUSERSCVLD()
		CNBUSERSCWHEN()
		CNBXALHRSINIT()
		CNBXALHRSVLD()
		CNBXALHRSWHEN()
		CNBXCCINIT()
		CNBXCCVLD()
		CNBXCCWHEN()
		CNBXCIRQTINIT()
		CNBXCIRQTVLD()
		CNBXCIRQTWHEN()
		CNBXCLVLINIT()
		CNBXCLVLVLD()
		CNBXCLVLWHEN()
		CNBXCODCAINIT()
		CNBXCODCAVLD()
		CNBXCODCAWHEN()
		CNBXCODGEINIT()
		CNBXCODORINIT()
		CNBXCODORVLD()
		CNBXCODORWHEN()
		CNBXCODSBINIT()
		CNBXCODSBVLD()
		CNBXCODSBWHEN()
		CNBXCONTAINIT()
		CNBXCONTAVLD()
		CNBXCONTAWHEN()
		CNBXEQUIPINIT()
		CNBXEQUIPVLD()
		CNBXEQUIPWHEN()
		CNBXGARAINIT()
		CNBXGARAVLD()
		CNBXGARAWHEN()
		CNBXINCHRINIT()
		CNBXINCHRVLD()
		CNBXINCHRWHEN()
		CNBXITCTAINIT()
		CNBXITCTAVLD()
		CNBXITCTAWHEN()
		CNBXITMPCINIT()
		CNBXITMPCVLD()
		CNBXITMPCWHEN()
		CNBXITMSCINIT()
		CNBXITMSCVLD()
		CNBXITMSCWHEN()
		CNBXMARCAINIT()
		CNBXMARCAVLD()
		CNBXMARCAWHEN()
		CNBXMODALINIT()
		CNBXMODALVLD()
		CNBXMODALWHEN()
		CNBXMODELINIT()
		CNBXMODELVLD()
		CNBXMODELWHEN()
		CNBXNRPROINIT()
		CNBXNRPROVLD()
		CNBXNRPROWHEN()
		CNBXNUMPCINIT()
		CNBXNUMPCVLD()
		CNBXNUMPCWHEN()
		CNBXNUMSCINIT()
		CNBXNUMSCVLD()
		CNBXNUMSCWHEN()
		CNBXPROJEINIT()
		CNBXPROJEVLD()
		CNBXPROJEWHEN()
		CNBXPROP1INIT()
		CNBXPROP1VLD()
		CNBXPROP1WHEN()
		CNBXREVISINIT()
		CNBXREVISVLD()
		CNBXREVISWHEN()
		CNBXSBMINIT()
		CNBXSBMVLD()
		CNBXSBMWHEN()
		CNBXSEQPCINIT()
		CNBXSEQPCVLD()
		CNBXSEQPCWHEN()
		CNBXSZ2COINIT()
		CNBXSZ2COVLD()
		CNBXSZ2COWHEN()
		CNBXTAREFINIT()
		CNBXTAREFVLD()
		CNBXTAREFWHEN()
		CNBXVISCTINIT()
		CNBITEGRDINIT()
		CNBITEGRDVLD()
		CNBITEGRDWHEN()
		__cCRLF		:= NIL	
		lRecursa	:= __Dummy( .F. )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )