#INCLUDE "PROTHEUS.CH"
#DEFINE SESSION_POSITION	1
#DEFINE PROPERTY_POSITION	2

#DEFINE PROPERTY_NAME		1
#DEFINE PROPERTY_VALUE		2

#DEFINE PROPERTY_ELEMENTS	2

/*/
	Funcao:		INIGetPValue
	Autor:		Marinaldo de Jesus
	Data:		26/05/2011
	Uso:		Retornar o Valor Atribuido a uma Propriedade de Acordo com a Sessao em um arquivo .INI
	Sintaxe:	StaticCall( INIGetPValue , INIGetPValue , cFile , cSession , cPropertyName , cDefault )
/*/
Static Function INIGetPValue( cFile , cSession , cPropertyName , cDefaultValue , cIgnoreToken )

	Local aProperties		:= {}
	
	Local cPropertyValue	:= "@__PROPERTY_NOT_FOUND__@"

	Local lExit
	
	Local nAT
	Local nATLine
	Local nSession
	Local nProperty
	Local nProperties
	Local nATIgnoreTkn

	Local ofT

	BEGIN SEQUENCE
	
		IF Empty( cFile )
			BREAK
		EndIF

		IF !File( cFile )
        	BREAK
		ENDIF

		ofT	:= fT():New()

		IF ( ofT:ft_fUse( cFile ) <= 0 )
			ofT:ft_fUse()
			BREAK
		EndIF

		DEFAULT cSession		:= Chr(255)
		DEFAULT cPropertyName	:= ""
		DEFAULT cIgnoreToken	:= ";"
		
		cSession		:= Lower( AllTrim( cSession ) )
		cPropertyName	:= Lower( AllTrim( cPropertyName ) )

		While !( ofT:ft_fEof() )
			cLine		:= ofT:ft_fReadLn()
			BEGIN SEQUENCE
				IF Empty( cLine )
					BREAK
				EndIF
				IF ( cIgnoreToken $ cLine )
					cLine			:= AllTrim( cLine )
					nATIgnoreTkn	:= AT( cIgnoreToken , cLine )
					IF ( nATIgnoreTkn == 1 )
						BREAK
					EndIF
					cLine	:= SubStr( cLine , 1  , nATIgnoreTkn - 1 )
				EndIF	
				IF !( "[" $ cLine )
					BREAK
				ENDIF
				lExit		:= .F.
				nATLine		:= 0
				aAdd( aProperties , { Lower( AllTrim( StrTran( StrTran( cLine , "[" , "" ) , "]" , "" ) ) ) , Array( 0 ) } )
				nProperties	:= Len( aProperties )
				ofT:ft_fSkip()
				While !( ofT:ft_fEof() )
					cLine	:= ofT:ft_fReadLn()
 					BEGIN SEQUENCE
	 					IF Empty( cLine )
	 						BREAK
	 					EndIF
						IF ( cIgnoreToken $ cLine )
							cLine			:= AllTrim( cLine )
							nATIgnoreTkn	:= AT( cIgnoreToken , cLine )
							IF ( nATIgnoreTkn == 1 )
								nATLine		:= 0
								lExit		:= .T.
								BREAK
							EndIF
							cLine	:= SubStr( cLine , 1  , nATIgnoreTkn - 1 )
						EndIF
						IF ( "[" $ cLine )
							lExit := .T.
							BREAK
						EndIF
		 				aAdd( aProperties[ nProperties ][ PROPERTY_POSITION ] , Array( PROPERTY_ELEMENTS ) )
		 				nProperty	:= Len( aProperties[ nProperties ][ PROPERTY_POSITION ] )
		 				nAT			:= AT( "=" , cLine )
		 				aProperties[ nProperties ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ] := Lower( AllTrim( SubStr( cLine , 1 , nAT - 1 ) ) )
		 				aProperties[ nProperties ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ] := SubStr( cLine , nAT + 1 )
		 				cLine		:= ""
					END SEQUENCE
					IF ( lExit )
						EXIT
					EndIF
					nATLine		:= ofT:ft_fRecno()
					ofT:ft_fSkip()
				End While
				IF ( nATLine > 0 )
					ofT:ft_fGoto( nATLine )
				EndIF
			END SEQUENCE
			ofT:ft_fSkip()
		End While

		ofT:ft_fUse()

		nSession	:= aScan( aProperties , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		nProperty		:= aScan( aProperties[ nSession ][ PROPERTY_POSITION ] , { |aValues| ( aValues[ PROPERTY_NAME ] == cPropertyName ) } )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		cPropertyValue	:= aProperties[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ]

	END SEQUENCE

	IF ( cPropertyValue == "@__PROPERTY_NOT_FOUND__@" )
		IF !Empty( cDefaultValue )
			cPropertyValue	:= cDefaultValue
		Else
			cPropertyValue	:= ""
		EndIF	
	EndIF

Return( cPropertyValue )

Static Function __Dummy( lRecursa )
	BEGIN SEQUENCE
		lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		INIGetPValue()
	   	lRecursa := __Dummy( lRecursa )
	END SEQUENCE
Return( lRecursa )