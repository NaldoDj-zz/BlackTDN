#include "totvs.ch"

/*
    class:utThread
    Autor:Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data:30/07/2015
    Descricao:Instancia um novo objeto do tipo utThread
    Sintaxe:utThread():New(oProcess) -> self
    Obs.: A classe utThread dependente de tBigNThread (tBigNThread.prg: um vez que deriva desta) 
          então, para instanciar um objeto da clase abaixo, compile, também, os programas que se 
          encontram aqui: https://goo.gl/bqjWz5
          Read more: http://www.blacktdn.com.br/#ixzz3hSL9YIDx
*/
class utThread from tBigNThread
    METHOD New(cMTXKey,oProcess) CONSTRUCTOR /*(/!\)*/
end class

user function tThread(cMTXKey,oProcess)
return(utThread():New(cMTXKey,oProcess))

method New(cMTXKey,oProcess) Class utThread
    _Super:New(cMTXKey,oProcess)
return(self)
