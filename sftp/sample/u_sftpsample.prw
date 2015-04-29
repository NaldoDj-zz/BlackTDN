#include "totvs.ch"
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
    ouSFTP:=ouSFTP:FreeObj()
Return(NIL)

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
    ouSFTP:=ouSFTP:FreeObj()
Return(NIL)
