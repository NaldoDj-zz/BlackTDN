#INCLUDE "NDJ.CH"

/*/
	CLASS:		uTRect
	Autor:		Marinaldo de Jesus
	Data:		26/03/2012
	Descricao:	Customizacao da Classe TRect
	Sintaxe:	uTRect():New() -> Objeto do Tipo uTRect
/*/
CLASS uTRect FROM LongClassName

	DATA cClassName

	DATA nTop
	DATA nLeft
	DATA nWidth
	DATA nHeight

	METHOD NEW(nTop,nLeft,nWidth,nHeight) CONSTRUCTOR

	METHOD ClassName()

ENDCLASS

User Function TRect(nTop,nLeft,nWidth,nHeight)
Return( uTRect():New(@nTop,@nLeft,@nWidth,@nHeight) )

/*/
	METHOD:		New
	Autor:		Marinaldo de Jesus
	Data:		26/03/2012
	Descricao:	CONSTRUCTOR
	Sintaxe:	uTRect():New() -> Self
/*/
METHOD New(nTop,nLeft,nWidth,nHeight) CLASS UTRECT

	DEFAULT nTop 	:= 0
	DEFAULT nLeft	:= 0
	DEFAULT nWidth 	:= 0
	DEFAULT nHeight	:= 0

	Self:cClassName	:= "UTRECT"

	Self:nTop		:= nTop
	Self:nLeft		:= nLeft
	Self:nWidth 	:= nWidth
	Self:nHeight	:= nHeight

Return( Self )

/*/
	METHOD:		ClassName
	Autor:		Marinaldo de Jesus
	Data:		26/03/2012
	Descricao:	Retornar o Nome da Classe
	Sintaxe:	uTRect():ClassName() -> cClassName
/*/
METHOD ClassName() CLASS UTRECT
Return( Self:cClassName )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )