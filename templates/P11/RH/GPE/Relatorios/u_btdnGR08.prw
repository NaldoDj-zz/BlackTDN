#INCLUDE "PROTHEUS.CH"
/*
	Programa	: u_btdnGR08.PRW
	Funcao		: u_btdnGR08()
	Autor		: Marinaldo de Jesus [http://www.blacktdn.com.br]
	Data		: 24/06/2013
	Descricao	: Chamada ao Progama Customizado para Integracao com o WORD
*/                          
User Function btdnGR08()
	Private cCadastro 		:= OemToAnsi("Geração Folha de Ponto")
	Private __lSatSunOnly	:= .T.
	Private __lEndDepto		:= .T.
Return(U_GpeWordX(cCadastro,.F.))