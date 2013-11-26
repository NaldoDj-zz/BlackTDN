#INCLUDE "PROTHEUS.CH"

#DEFINE SESSION_POSITION	1
#DEFINE PROPERTY_POSITION	2

#DEFINE PROPERTY_NAME		1
#DEFINE PROPERTY_VALUE		2

#DEFINE PROPERTY_ELEMENTS	2

/*/
	CLASS:		TFINI
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Manipulacao de Arquivos .INI
	Sintaxe:	TFINI():New( cINIFile , cIgnoreToken) -> Objeto do Tipo TFINI
/*/
CLASS TFINI FROM LongClassName

	DATA aTFINI
	
	DATA cINIFile
	DATA cClassName

	METHOD NEW( cINIFile , cIgnoreToken ) CONSTRUCTOR

	METHOD ClassName()

	METHOD GetPropertyValue( cSession , cPropertyName , cDefaultValue )
	METHOD SetPropertyValue( cSession , cPropertyName , cValue )
	METHOD AddNewProperty( cSession , cPropertyName , cValue )
	METHOD RemoveProperty( cSession , cPropertyName )
	METHOD GetAllProperties( cSession )

	METHOD AddNewSession( cSession )
	METHOD RemoveSession( cSession )
	METHOD GetAllSessions()
	METHOD CopySession( cSession , cNewSession )
	METHOD ExistSession( cSession )

	METHOD SaveAs( cINIFile )
	METHOD SaveAsXML( cXMLFile )

	METHOD ToXML()

ENDCLASS

User Function TFINI( cINIFile , cIgnoreToken )
Return( TFINI():New( cINIFile , cIgnoreToken ) )

/*/
	METHOD:		New
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	CONSTRUCTOR
	Sintaxe:	TFINI():New( cINIFile , cIgnoreToken) -> Self
/*/
METHOD New( cINIFile , cIgnoreToken ) CLASS TFINI

	Local aTFINI

	Self:aTFINI			:= {}
	Self:cINIFile		:= cINIFile
	Self:cClassName		:= "TFINI"

	aTFINI				:= Self:aTFINI

	TINILoad( @aTFINI , @cINIFile , @cIgnoreToken )

Return( Self )

/*/
	Function:	TINILoad
	Autor:		Marinaldo de Jesus
	Data:		03/11/2011
	Descricao:	Carregar os Dados do arquivo INI
	Sintaxe:	TINILoad( oTIni , cIgnoreToken )
/*/
Static Function TINILoad( aTFINI , cINIFile , cIgnoreToken )

	Local cLine

	Local lExit

	Local nAT
	Local nATLine
	Local nSession
	Local nProperty
	Local nATIgnoreTkn

	Local ofT

	Local lLoad	:= .F.

	BEGIN SEQUENCE
	
		IF Empty( cINIFile )
			BREAK
		EndIF

		IF !File( cINIFile )
        	BREAK
		ENDIF

		ofT	:= fT():New()

		IF ( ofT:ft_fUse( cINIFile ) <= 0 )
			ofT:ft_fUse()
			BREAK
		EndIF

		DEFAULT cIgnoreToken	:= ";"

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
				aAdd( aTFINI , { Lower( AllTrim( StrTran( StrTran( cLine , "[" , "" ) , "]" , "" ) ) ) , Array( 0 ) } )
				nSession	:= Len( aTFINI )
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
								IF ( "[" $ cLine )
									nATLine		:= 0
									lExit		:= .T.
								EndIF
								BREAK
							EndIF
							cLine	:= SubStr( cLine , 1  , nATIgnoreTkn - 1 )
						EndIF
						IF ( "[" $ cLine )
							lExit := .T.
							BREAK
						EndIF
		 				aAdd( aTFINI[ nSession ][ PROPERTY_POSITION ] , Array( PROPERTY_ELEMENTS ) )
		 				nProperty	:= Len( aTFINI[ nSession ][ PROPERTY_POSITION ] )
		 				nAT			:= AT( "=" , cLine )
		 				aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ] := Lower( AllTrim( SubStr( cLine , 1 , nAT - 1 ) ) )
		 				aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ] := SubStr( cLine , nAT + 1 )
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

		lLoad	:= .T.

	END SEQUENCE

Return( lLoad )

/*/
	METHOD:		ClassName
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Retornar o Nome da Classe
	Sintaxe:	TFINI():ClassName() -> cClassName
/*/
METHOD ClassName()  CLASS TFINI
Return( Self:cClassName )

/*/
	METHOD:		GetPropertyValue
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Obter o valor da Propriedade Passada por parametro e de acordo com a Secao
	Sintaxe:	TFINI():GetPropertyValue( cSession , cPropertyName , cDefaultValue ) -> cPropertyValue
/*/
METHOD GetPropertyValue( cSession , cPropertyName , cDefaultValue ) CLASS TFINI

	Local cPropertyValue	:= "@__PROPERTY_NOT_FOUND__@"

	Local nSession
	Local nProperty

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF
		
		IF Empty( cPropertyName )
			BREAK
		EndIF

		cSession		:= Lower( AllTrim( cSession ) )
		cPropertyName	:= Lower( AllTrim( cPropertyName ) )

		nSession		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		nProperty		:= aScan( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , { |aValues| ( aValues[ PROPERTY_NAME ] == cPropertyName ) } )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		cPropertyValue	:= Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ]

	END SEQUENCE

	IF ( cPropertyValue == "@__PROPERTY_NOT_FOUND__@" )
		IF !Empty( cDefaultValue )
			cPropertyValue	:= cDefaultValue
		Else
			cPropertyValue	:= ""
		EndIF	
	EndIF

Return( cPropertyValue )

/*/
	METHOD:		SetPropertyValue
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Setar o Valor em uma determinada Propriedade
	Sintaxe:	TFINI():SetPropertyValue( cSession , cPropertyName , cValue ) -> cPropertyLastValue
/*/
METHOD SetPropertyValue( cSession , cPropertyName , cValue ) CLASS TFINI

	Local cPropertyLastValue

	Local nSession
	Local nProperty

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF
		
		IF Empty( cPropertyName )
			BREAK
		EndIF
		
		cSession			:= Lower( AllTrim( cSession ) )
		cPropertyName		:= Lower( AllTrim( cPropertyName ) )

		nSession			:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		nProperty			:= aScan( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , { |aValues| ( aValues[ PROPERTY_NAME ] == cPropertyName ) } )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		cPropertyLastValue	:= Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ]			
		Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ] := cValue

	END SEQUENCE

Return( cPropertyLastValue )

/*/
	METHOD:		AddNewProperty
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Adicionar uma nova propriedade
	Sintaxe:	TFINI():AddNewProperty( cSession , cPropertyName , cValue ) -> lSuccess
/*/
METHOD AddNewProperty( cSession , cPropertyName , cValue ) CLASS TFINI

	Local lSuccess			:= .F.
	
	Local nSession
	Local nProperty

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF
		
		IF Empty( cPropertyName )
			BREAK
		EndIF

		cSession			:= Lower( AllTrim( cSession ) )
		cPropertyName		:= Lower( AllTrim( cPropertyName ) )

		nSession			:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		aAdd( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , Array( PROPERTY_ELEMENTS ) )
		nProperty			:= Len( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] )

		Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ] := cPropertyName
		Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ] := cValue

		lSuccess			:= .T.

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		RemoveProperty
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Remover Determinada Propriedade
	Sintaxe:	TFINI():RemoveProperty( cSession , cPropertyName ) -> lSuccess
/*/
METHOD RemoveProperty( cSession , cPropertyName ) CLASS TFINI

	Local lSuccess		:= .F.
	
	Local nSession
	Local nProperty

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF
		
		IF Empty( cPropertyName )
			BREAK
		EndIF

		cSession		:= Lower( AllTrim( cSession ) )
		cPropertyName	:= Lower( AllTrim( cPropertyName ) )

		nSession		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		nProperty		:= aScan( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , { |aValues| ( aValues[ PROPERTY_NAME ] == cPropertyName ) } )
		IF ( nProperty == 0 )
			BREAK
		EndIF

		lSuccess		:= .T.

		aDel( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , nProperty )
		aSize( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] , Len( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] ) - 1 )

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		GetAllProperties
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Retornar todas as propriedades
	Sintaxe:	TFINI():GetAllProperties( cSession ) -> aAllProperties
/*/
METHOD GetAllProperties( cSession) CLASS TFINI

	Local aAllProperties	:= {}

	Local nSession

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF

		cSession			:= Lower( AllTrim( cSession ) )
		nSession			:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		aAllProperties		:= Self:aTFINI[ nSession ][ PROPERTY_POSITION ]

	END SEQUENCE

Return( aAllProperties )

/*/
	METHOD:		AddNewSession
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Adicionar nova Secao
	Sintaxe:	TFINI():AddNewSession( cSession ) -> lSuccess
/*/
METHOD AddNewSession( cSession ) CLASS TFINI

	Local lSuccess		:= .F.

	Local nSession

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF

		cSession		:= Lower( AllTrim( cSession ) )

		nSession		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession > 0 )
			BREAK
		EndIF

		aAdd( Self:aTFINI , { cSession , Array( 0 ) } )

		lSuccess		:= .T.

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		RemoveSession
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Remover Determinada Secao
	Sintaxe:	TFINI():RemoveSession( cSession ) -> lSuccess
/*/
METHOD RemoveSession( cSession ) CLASS TFINI

	Local lSuccess		:= .F.

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF

		cSession		:= Lower( AllTrim( cSession ) )

		nSession		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSession == 0 )
			BREAK
		EndIF

		aDel( Self:aTFINI , nSession )
		aSize( Self:aTFINI , Len( Self:aTFINI ) - 1 )

		lSuccess		:= .T.

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		GetAllSessions
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Obter Todas as Secoes do INI
	Sintaxe:	TFINI():GetAllSessions() -> aSessionsName
/*/
METHOD GetAllSessions() CLASS TFINI

	Local aSessionsName	:= {}

	Local nSession
	Local nSessions

	BEGIN SEQUENCE

		IF Empty( Self:aTFINI )
			BREAK
		EndIF

		nSessions := Len( Self:aTFINI )
		For nSession := 1 To nSessions
			aAdd( aSessionsName	, Self:aTFINI[ nSession ][ SESSION_POSITION ] )
		Next nSession

	END SEQUENCE

Return( aSessionsName )

/*/
	METHOD:		CopySession
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Copiar uma Secao 
	Sintaxe:	TFINI():CopySession( cSession , cNewSession ) -> lSuccess
/*/
METHOD CopySession( cSession , cNewSession ) CLASS TFINI

	Local aProperties
	
	Local nSource
	Local nTarget
	
	Local lSuccess	:= .F.

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF

		cSession	:= Lower( AllTrim( cSession ) )
		cNewSession	:= Lower( AllTrim( cNewSession ) )

		nSource		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		IF ( nSource == 0 )
			BREAK
		EndIF

		IF !( Self:AddNewSession( cNewSession ) )
			BREAK
		EndIF

		aProperties	:= Self:GetAllProperties( cSession )
		nTarget		:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cNewSession ) } )
		IF ( nTarget == 0 )
			BREAK
		EndIF
		
		Self:aTFINI[ nTarget ][ PROPERTY_POSITION ]	:= aClone( aProperties )
		
		lSuccess	:= ArrayCompare( Self:aTFINI[ nSource ][ PROPERTY_POSITION ] , Self:aTFINI[ nTarget ][ PROPERTY_POSITION ] )
	
	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		ExistSession
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Copiar uma Secao 
	Sintaxe:	TFINI():ExistSession( cSession ) -> lExist
/*/
METHOD ExistSession( cSession ) CLASS TFINI

	Local lExist	:= .F.

	Local nSession

	BEGIN SEQUENCE

		IF Empty( cSession )
			BREAK
		EndIF

		cSession	:= Lower( AllTrim( cSession ) )

		nSession	:= aScan( Self:aTFINI , { |aFindSession| ( aFindSession[ SESSION_POSITION ] == cSession ) } )
		lExist		:= ( nSession > 0 )

	END SEQUENCE

Return( lExist )

/*/
	METHOD:		SaveAs
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Salvar Como
	Sintaxe:	TFINI():SaveAs( cINIFile ) -> lSuccess
/*/
METHOD SaveAs( cINIFile ) CLASS TFINI

	Local cLine
	Local cCRLF

	Local nSession
	Local nSessions
	Local nProperty
	Local nProperties
	
	Local nfHandle
	
	Local lSuccess	:= .F.

	BEGIN SEQUENCE

		IF Empty( cINIFile )
			cINIFile := Self:cINIFile
			IF Empty( cINIFile )
				BREAK
			EndIF
		EndIF

		nfHandle	:= fCreate( cINIFile )
		IF ( nfHandle <= 0 )
			BREAK
		EndIF

		cCRLF		:= CRLF

		nSessions	:= Len( Self:aTFINI )
		For nSession := 1 To nSessions

			cLine := "["
			cLine += Self:aTFINI[ nSession ][ SESSION_POSITION ]
			cLine += "]"
			cLine += cCRLF

			fWrite( nfHandle , cLine )

			nProperties := Len( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] )
			For nProperty := 1 To nProperties

		 		cLine := Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ]
		 		cLine += "="
		 		cLine += Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ]
				cLine += cCRLF
				
				fWrite( nfHandle , cLine )

			Next nProperty

			cLine := cCRLF

			fWrite( nfHandle , cLine )

		Next nSession

		fClose( nfHandle )

		lSuccess	:= File( cINIFile )

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		SaveAsXML
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Salvar como XML
	Sintaxe:	TFINI():SaveAsXML( cXMLFile ) -> lSuccess
/*/
METHOD SaveAsXML( cXMLFile ) CLASS TFINI

	Local aXML

	Local cLine
	Local cCRLF
	
	Local cSPPath
	Local cSPDriver
	Local cSPFileName

	Local lSuccess	:= .F.

	Local nAT
	Local nATEnd
	Local nfHandle

	BEGIN SEQUENCE

		IF Empty( cXMLFile )
			cXMLFile	:= Self:cINIFile
			IF Empty( cXMLFile )
				BREAK
			EndIF
			SplitPath( cXMLFile , @cSPDriver , @cSPPath , @cSPFileName )
			cXMLFile	:= cSPDriver
			cXMLFile	+= cSPPath
			cXMLFile	+= cSPFileName
			cXMLFile	+= ".xml"
		EndIF

		aXML			:= Self:ToXML()
		nATEnd			:= Len( aXML )
		IF ( nATEnd == 0 )
			BREAK
		EndIF

		nfHandle	:= fCreate( cXMLFile )
		IF ( nfHandle <= 0 )
			BREAK
		EndIF

		cCRLF		:= CRLF

		For nAT := 1 To nATEnd

			cLine := aXML[ nAT ]
			cLine += cCRLF

			fWrite( nfHandle , cLine )

		Next nSession

		fClose( nfHandle )

		lSuccess	:= File( cXMLFile )

	END SEQUENCE

Return( lSuccess )

/*/
	METHOD:		ToXML
	Autor:		Marinaldo de Jesus
	Data:		27/05/2011
	Descricao:	Converter para XML
	Sintaxe:	TFINI():ToXML() -> aXML
/*/
METHOD ToXML() CLASS TFINI

	Local aXML			:= {}

	Local cSpace4		:= Space(4)
	Local cSpace8		:= Space(8)
	Local cLClassName   := Lower( Self:cClassName )

	Local nSession
	Local nSessions
	Local nProperty
	Local nProperties

	aAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1'?>" )
	aAdd( aXML , "<" + cLClassName  + ">" )
	nSessions	:= Len( Self:aTFINI )
	For nSession := 1 To nSessions

		aAdd( aXML , cSpace4 )
		aAdd( aXML , "<" + Self:aTFINI[ nSession ][ SESSION_POSITION ] + ">" )

		nProperties := Len( Self:aTFINI[ nSession ][ PROPERTY_POSITION ] )
		For nProperty := 1 To nProperties

			aAdd( aXML , cSpace8 )
			aAdd( aXML , "<" + Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ] + ">" )
	 		aAdd( aXML , Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_VALUE ] )
			aAdd( aXML , "</" + Self:aTFINI[ nSession ][ PROPERTY_POSITION ][ nProperty ][ PROPERTY_NAME  ] + ">" )

		Next nProperty

		aAdd( aXML , cSpace4 )
		aAdd( aXML , "</" + Self:aTFINI[ nSession ][ SESSION_POSITION ] + ">" )

	Next nSession

	aAdd( aXML , "</" + cLClassName + ">" )

Return( aXML )
