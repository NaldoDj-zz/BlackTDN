#ifdef TOTVS
	#include "totvs.ch"
#else
	#include "protheus.ch"
#endif	
/*/
	Function:	hbXMLTest
	Autor:		Marinaldo de Jesus
	Data:		04/12/2011
	Descricao:	Exemplo de uso das classes XML do Harbour no Prothues
	Sintaxe:	U_hbXMLTest()
/*/
User Function hbXMLTest()
	Local nVarNameLen	:= SetVarNameLen(250)
	Local lSetCentury	:= __SetCentury("ON")
	SetsDefault()
	MsgRun( "Gerando Planilhas..." , "Aguarde" , { || hbXmlTest() } )
	SetVarNameLen(nVarNameLen)  
	IF !( lSetCentury )
		__SetCentury("OFF")
	EndIF
	Static Function hbXmlTest()
		Local aExamples := Array(0)            
		aAdd( aExamples , "U_Example1Xls" )
		aAdd( aExamples , "U_Example2Xls" )
		aAdd( aExamples , "U_Example3Xls" )
	Return( aEval( aExamples , { |cExec| IF( FindFunction( cExec ) , &cExec.() , NIL ) } ) )
Return( NIL )