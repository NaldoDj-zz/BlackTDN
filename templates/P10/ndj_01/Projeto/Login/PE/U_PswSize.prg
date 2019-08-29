#include "NDJ.CH"
/*
    Programa : U_PswSize.prg
    Função   : U_PswSize
    Autor    : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
    Data     : 07/09/2012
    Uso      : Tratamento customizado para o Tamanho da Senha
    Sintaxe  : Ponto de Entrada PswSize
    Obs.     : Caso nao Possua o PE PswSize compilado em seu ambiente, retire o
               comentario (*) das linhas abaixo antes de compilar este fonte.
*/
*User Function PswSize()
*Return(Return(StaticCall(U_PswSize,PswSize)))

/*
    Programa : U_PswSize.prg
    Função   : PswSize
    Autor    : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
    Data     : 07/09/2012
    Uso      : Tratamento customizado para o Tamanho da Senha
    Sintaxe  : StaticCall(U_PswSize,PswSize)
               Execute a partir do Ponto de Entrada U_PswSize.
               Ex.:
               User Function PswSize()
               Return(StaticCall(U_PswSize,PswSize))
*/
Static Function PswSize()
    /*    
      Obs.: O PE PswSize normalmente utilizado para redefinir o tamanho
              da senha sera utilizado, tambem, caso faca referencie      a
              este programa, a personalizar a tela de login do     by You
            substituindo as imagens padroes por  imagens customizadas.
   */
   StaticCall(BTDNCustomLogin,CustomLogin) //Tratamento para Login Customizado
Return( ParamIXB )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        PswSize()
        SYMBOL_UNUSED( __cCRLF )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
