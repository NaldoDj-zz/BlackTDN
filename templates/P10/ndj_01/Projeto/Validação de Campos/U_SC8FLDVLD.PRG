#INCLUDE "NDJ.CH"
/*/
	Function:	C8PRECOVld
	Autor:		Marinaldo de Jesus
	Data:		09/12/2010
	Descricao:	Validar o conteudo do campo C8_PRECO
	Sintaxe:	StaticCall(U_SC8FLDVLD,C8PRECOVld,<nC8PRECO>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function C8PRECOVld( nC8PRECO , lShowHelp , cMsgHelp )

	Local lFieldOk		:= .T.
	
	Local oException

	TRYEXCEPTION

        DEFAULT nC8PRECO := StaticCall( NDJLIB001 , __FieldGet , "SC8" , "C8_PRECO" )

		IF !( lFieldOk := !Empty( nC8PRECO ) )
			IF !Empty( cMsgHelp )
				cMsgHelp += CRLF
			EndIF
			DEFAULT cMsgHelp	:= ""
			cMsgHelp += "O Campo:"
			cMsgHelp += CRLF
			cMsgHelp += GetCache( "SX3" , "C8_PRECO" , NIL , "X3Titulo()" , 2 , .F. )
			cMsgHelp += " "
			cMsgHelp += "( C8_PRECO )"
			cMsgHelp += CRLF
			cMsgHelp += "deve ser preenchido."
			UserException( cMsgHelp )
		EndIF

		//Atualiza As informacoes Dependentes de C8_TOTAL
        IF ( StaticCall( NDJLIB001 , IsInGetDados , {  } ) )
            lFieldOk := StaticCall( NDJLIB001 , ForceReadVar , "C8_TOTAL" )
			IF !( lFieldOk )
				cMsgHelp += "O Campo:"
				cMsgHelp += CRLF
				cMsgHelp += GetCache( "SX3" , "C8_PRECO" , NIL , "X3Titulo()" , 2 , .F. )
				cMsgHelp += " "
				cMsgHelp += "( C8_PRECO )"
				cMsgHelp += CRLF
				cMsgHelp += "Está com Conteúdo Inválido."
				UserException( cMsgHelp )
			EndIF
		EndIF

		StaticCall( U_XALTHRS , XALTHRS , "SC8" )

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
				Help( "" , 1 , "C8_PRECO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
			EndIF	
	    EndIF

	ENDEXCEPTION

Return( lFieldOk )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL	
		C8PRECOVLD()
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )