#INCLUDE "NDJ.CH"

/*/
	CLASS:		uTVector3D
	Autor:		Marinaldo de Jesus
	Data:		29/03/2012
	Descricao:	Vector3D
	Sintaxe:	uTVector3D():New() -> Objeto do Tipo uTVector3D
/*/
CLASS uTVector3D FROM uTVector2D

	DATA z

	METHOD NEW(x,y,z) CONSTRUCTOR

	METHOD ClassName()

ENDCLASS

User Function TVector3D(x,y,z)
Return( uVector2D():New(@x,@y,@z) )

/*/
	METHOD:		New
	Autor:		Marinaldo de Jesus
	Data:		29/03/2012
	Descricao:	CONSTRUCTOR
	Sintaxe:	uTVector3D():New() -> Self
/*/
METHOD New(x,y,z) CLASS uTVector3D

	DEFAULT x	:= 0
	DEFAULT y	:= 0
	DEFAULT z	:= 0

	Self:x		:= x
	Self:y		:= y
	Self:z		:= z

	Self:cClassName	:= "UTVECTOR3D"

Return( Self )

/*/
	METHOD:		ClassName
	Autor:		Marinaldo de Jesus
	Data:		26/03/2012
	Descricao:	Retornar o Nome da Classe
	Sintaxe:	uTVector3D():ClassName() -> cClassName
/*/
METHOD ClassName() CLASS uTVector3D
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