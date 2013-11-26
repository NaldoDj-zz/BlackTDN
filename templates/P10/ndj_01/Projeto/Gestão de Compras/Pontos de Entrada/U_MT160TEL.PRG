#INCLUDE "NDJ.CH"
/*/
	Funcao: MT160TEL
	Autor:	Marinaldo de Jesus
	Data:	10/12/2010
	Uso:	Executada a partir da A160Analis em MATA160. Originalmente usado para carregar novas informações no Dialog.
	Sera utilizado para capturar o Objeto Dialog de forma a obter o Controle Sobre ele.
/*/
User Function MT160TEL()

	Local oDlg		:= ParamIxb[1]
	Local aPosGet	:= ParamIxb[2]
	Local nOpcx		:= ParamIxb[3]
	Local nReg		:= ParamIxb[4]

	ParamIxb[1]		:= oDlg
	ParamIxb[2]		:= aPosGet
	ParamIxb[3]		:= nOpcx
	ParamIxb[4]		:= nReg

	IF IsInCallStack( "U_MATA160" )
		oDlg:cCaption	:= 	OemToAnsi( "Aprovação de Cotação" )
	EndIF

Return( NIL )

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