#include "NDJ.CH"
/*
	Programa : U_ChgPrDir.prg
	Função   : U_ChgPrDir
	Autor    : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data     : 07/09/2012
	Uso      : Tratamento customizado para o Diretorio de Gravacao de Relatorios
	Sintaxe  : Ponto de Entrada ChgPrDir
	Obs.     : Caso nao Possua o PE ChgPrDir compilado em seu ambiente, retire o
	           comentario (*) das linhas abaixo antes de compilar este fonte.
*/
*User Function ChgPrDir()
*Return(StaticCall(U_ChgPrDir,ChgPrDir))

/*
	Programa : U_ChgPrDir.prg
	Função   : ChgPrDir
	Autor    : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
	Data     : 07/09/2012
	Uso      : Tratamento customizado para o Diretorio de Gravacao de Relatorios
	Sintaxe  : StaticCall(U_ChgPrDir,ChgPrDir)
			   Execute a partir do Ponto de Entrada U_ChgPrDir.
			   Ex.:
			   User Function ChgPrDir()
			   Return(StaticCall(U_ChgPrDir,ChgPrDir))
*/
Static Function ChgPrDir()
	Local cRelDir := IF( ( Type( "__RELDIR" ) == "C" ) , __RELDIR , NIL )
    /*	
      Obs.: O PE ChgPrDir normalmente utilizado para alterar o diretorio
			para gravacao dos relatorios sera utilizado, tambem,    caso 
			faca referencia a este programa, a personalizar a tela    de
			login do by You substituindo as imagens padroes por  imagens
			customizadas.
   */
   StaticCall(BTDNCustomLogin,CustomLogin) //Tratamento para Login Customizado
Return( cRelDir )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		ChgPrDir()
		SYMBOL_UNUSED( __cCRLF )
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )