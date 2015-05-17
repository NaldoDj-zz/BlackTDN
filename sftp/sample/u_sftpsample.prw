#include "totvs.ch"
//------------------------------------------------------------------------------------------------
    /*/
        Programa:u_sftpsample.prw
        Funcao:U_SFTPPut()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura (PUT) usando o protocolo SFTP a partir do pscp.exe
        Sintaxe:U_SFTPPut()
    /*/
//------------------------------------------------------------------------------------------------
User Function SFTPPut()
    Local cSource:="\expordic\*.*"
    Local cTarget:="/TARGET/"
    Local cURL:="URL"
    Local cUSR:="USER"
    Local cPWD:="P@SSWORD"
    Local cMode:="P"
    Local lSrv:=.T.
    Local cPort:="22"
    Local lForceClient:=.T.
    Local ouSFTP:=uSFTP():New()
    ouSFTP:Execute(@cSource,@cTarget,@cURL,@cUSR,@cPWD,@cMode,@lSrv,@cPort,@lForceClient)
    ConOut(ouSFTP:nError)
    aEval(ouSFTP:aSFTPLog,{|l|ConOut(l)})
    ouSFTP:=ouSFTP:FreeObj()
Return(NIL)

//------------------------------------------------------------------------------------------------
    /*/
        Programa:u_sftpsample.prw
        Funcao:U_SFTPGet()
        Autor:Marinaldo de Jesus [BlackTDN:(http://www.blacktdn.com.br/)]
        Data:29/04/2015
        Descricao:Transferencia de dados segura (GET) usando o protocolo SFTP a partir do pscp.exe
        Sintaxe:U_SFTPPut()
    /*/
//------------------------------------------------------------------------------------------------
User Function SFTPGet()
    Local cSource:="/SOURCE/*.*"
    Local cTarget:="\expordic\"
    Local cURL:="URL"
    Local cUSR:="USER"
    Local cPWD:="P@SSWORD"
    Local cMode:="G"
    Local lSrv:=.T.
    Local cPort:="22"
    Local lForceClient:=.T.
    Local ouSFTP:=uSFTP():New()
    ouSFTP:Execute(@cSource,@cTarget,@cURL,@cUSR,@cPWD,@cMode,@lSrv,@cPort,@lForceClient)
    ConOut(ouSFTP:nError)
    aEval(ouSFTP:aSFTPLog,{|l|ConOut(l)})
    ouSFTP:=ouSFTP:FreeObj()
Return(NIL)
