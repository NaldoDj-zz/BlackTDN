#IFNDEF _TRYEXCEPTION_CH

	#DEFINE _TRYEXCEPTION_CH

	/*/
		Autor:		Marinaldo de Jesus
		Data:		07/10/2009
		Descricao:	Comandos para Simular TRY & CATCH EXCEPTION em ADVPL

	/*/
	#DEFINE TRY_ERROR_BLOCK			1
	#DEFINE TRY_SYSERROR_BLOCK		2
	#DEFINE TRY_INDEX				3
	#DEFINE TRY_OBJERROR			4
	#DEFINE TRY_ERROR_MESSAGE		5
	#DEFINE TRY_SET_BELL			6

	#DEFINE TRY_ELEMENTS			6
	
	#XTRANSLATE	TRY EXCEPTION	=> TRYEXCEPTION
	#XTRANSLATE	CATCH EXCEPTION	=> CATCHEXCEPTION
	#XTRANSLATE	END TRY			=> ENDEXCEPTION
	#XTRANSLATE	ENDTRY			=> ENDEXCEPTION
	#XTRANSLATE	END EXCEPTION	=> ENDEXCEPTION

	#IFNDEF _SET_BELL
		#DEFINE _SET_BELL         26
	#ENDIF	

	#XCOMMAND TRYEXCEPTION  	=> ;
		IF( !( Type( "aTryException" ) == "A" ) .or. !( Type( "nTryException" ) == "N" ) , PutTryExceptionVars() , NIL ) ;;
		aAdd( aTryException , Array(TRY_ELEMENTS) ) ;;
		++nTryException ;;
		aTryException\[nTryException\]\[TRY_SET_BELL\]			:= Set( _SET_BELL , "OFF" ) ;;
		aTryException\[nTryException\]\[TRY_ERROR_BLOCK\]		:= ErrorBlock( \{ \|oError\| BREAK( @oError ) \} ) ;;
		aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\]	:= SysErrorBlock( \{ \|oError\| BREAK( @oError ) \} ) ;;
		aTryException\[nTryException\]\[TRY_INDEX\]	:= nTryException ;;
		ErrorBlock( \{ \|oError\| aTryException\[nTryException\]\[TRY_OBJERROR\] := oError , BREAK( @oError ) \} ) ;;
		SysErrorBlock( \{ \|oError\| aTryException\[nTryException\]\[TRY_OBJERROR\] := oError , BREAK( @oError ) \} ) ;;
		BEGIN SEQUENCE ;;
	
	#XCOMMAND TRYEXCEPTION USING <bError> [PARAMETERS <aParameters>] => ;
		IF( !( Type( "aTryException" ) == "A" ) .or. !( Type( "nTryException" ) == "N" ) , PutTryExceptionVars() , NIL ) ;;
		aAdd( aTryException , Array( TRY_ELEMENTS ) ) ;;
		++nTryException ;;
		aTryException\[nTryException\]\[TRY_SET_BELL\]			:= Set( _SET_BELL , "OFF" ) ;;
		aTryException\[nTryException\]\[TRY_ERROR_BLOCK\]		:= ErrorBlock( \{ \|oError\| BREAK( @oError ) \} ) ;;
		aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\]	:= SysErrorBlock( \{ \|oError\| BREAK( @oError ) \} ) ;;
		aTryException\[nTryException\]\[TRY_INDEX\]	:= nTryException ;;
		ErrorBlock( \{ \|oError\| aTryException\[nTryException\]\[TRY_OBJERROR\] := oError , Eval( <bError> , @oError , [@<aParameters>] ) \} ) ;;
		SysErrorBlock( \{ \|oError\| aTryException\[nTryException\]\[TRY_OBJERROR\] := oError , Eval( <bError> , @oError , [@<aParameters>] ) \} ) ;;
		BEGIN SEQUENCE ;;

	#XCOMMAND CATCHEXCEPTION	=>  ;
			aTryException\[nTryException\]\[TRY_ERROR_MESSAGE\] := CaptureError( .T. , @nTryException , @nTryException , 1 ) ;; 
			RECOVER ;;
	
	#XCOMMAND CATCHEXCEPTION USING <oException> => ;
		RECOVER ;;
		aTryException\[nTryException\]\[TRY_ERROR_MESSAGE\] := CaptureError( .T. , @nTryException , @nTryException , 1 ) ;; 
		<oException>	:= aTryException\[nTryException\]\[TRY_OBJERROR\] ;;
	
	#XCOMMAND ENDEXCEPTION		=> ;
		END SEQUENCE ;;
		IF ( ( Type( "aTryException" ) == "A" ) .and. ( Type( "nTryException" ) == "N" ) ) ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_ERROR_BLOCK\]) == "B" ) ;;
				ErrorBlock( aTryException\[nTryException\]\[TRY_ERROR_BLOCK\] ) ;;
			ENDIF ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\]) == "B" ) ;;
				SysErrorBlock( aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\] ) ;;
			ENDIF ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_SET_BELL\]) == "L" ) ;;
				IF ( aTryException\[nTryException\]\[TRY_SET_BELL\]) ;;
					Set(_SET_BELL,"ON") ;;
				EndIF ;;	
			ENDIF ;;			
			aDel( aTryException , nTryException ) ;;
			aSize( aTryException , --nTryException ) ;;
		ENDIF ;;

	#XCOMMAND ENDEXCEPTION NODELSTACKERROR		=> ;
		END SEQUENCE ;;
		IF ( ( Type( "aTryException" ) == "A" ) .and. ( Type( "nTryException" ) == "N" ) ) ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_ERROR_BLOCK\]) == "B" ) ;;
				ErrorBlock( aTryException\[nTryException\]\[TRY_ERROR_BLOCK\] ) ;;
			ENDIF ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\]) == "B" ) ;;
				SysErrorBlock( aTryException\[nTryException\]\[TRY_SYSERROR_BLOCK\] ) ;;
			ENDIF ;;
			IF ( ValType(aTryException\[nTryException\]\[TRY_SET_BELL\]) == "L" ) ;;
				IF ( aTryException\[nTryException\]\[TRY_SET_BELL\]) ;;
					Set(_SET_BELL,"ON") ;;
				EndIF ;;	
			ENDIF ;;
			--nTryException ;;
		ENDIF ;;

	Static Function PutTryExceptionVars()
		Public aTryException	:= {}
		Public nTryException	:= 0
	Return( NIL )
	
	Static Function CaptureError( lObjError , nStart , nFinish , nStep )
		Local cError		:= ''
		Local lTryException	:= ( ( Type( 'aTryException' ) == 'A' ) .and. ( Type( 'nTryException' ) == 'N' ) )
		Local nError
		IF ( lTryException )
			lObjError	:= IF( ( lObjError == NIL ) , .F. , lObjError )
			nStart 		:= IF( ( nStart == NIL ) , 1 , nStart )
			nFinish		:= IF( ( nFinish == NIL ) , Len( aTryException ) , nFinish )
			nStep		:= IF( ( nStep == NIL ) , 1 , nStep )
			For nError := nStart To nFinish Step nStep
				IF ( lObjError )
					IF ( ValType( aTryException[nError][TRY_OBJERROR] ) == 'O' )
						cError	+= aTryException[nError][TRY_OBJERROR]:Description
						cError	+= aTryException[nError][TRY_OBJERROR]:ErrorStack
						cError	+= aTryException[nError][TRY_OBJERROR]:ErrorEnv
					EndIF
				Else
					IF ( ValType( aTryException[nError][TRY_ERROR_MESSAGE] ) == 'C' )
						cError += aTryException[nError][TRY_ERROR_MESSAGE]
					EndIF
				EndIF	
			Next nError
		EndIF
	Return( cError )

#ENDIF