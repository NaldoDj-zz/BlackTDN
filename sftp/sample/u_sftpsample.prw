#include "totvs.ch"
User Function SFTPPut()
    Local cSource:="\expordic\*.*"
    Local cTarget:="/INTL/Imports/TEST/Brazil/"
    Local cURL:="FE01.UltiPro.com"
    Local cUSR:="SFTPLAU1001-BrazilTest"
    Local cPWD:="D[4kUUD8bC"
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
    Local cSource:="/INTL/Imports/TEST/Brazil/*.*"
    Local cTarget:="\expordic\"
    Local cURL:="FE01.UltiPro.com"
    Local cUSR:="SFTPLAU1001-BrazilTest"
    Local cPWD:="D[4kUUD8bC"
    Local cMode:="G"
    Local lSrv:=.T.
    Local cPort:="22"
    Local lForceClient:=.T.
    Local ouSFTP:=uSFTP():New()
    ouSFTP:Execute(@cSource,@cTarget,@cURL,@cUSR,@cPWD,@cMode,@lSrv,@cPort,@lForceClient)
    ConOut(ouSFTP:nError)
    ouSFTP:=ouSFTP:FreeObj()
Return(NIL)