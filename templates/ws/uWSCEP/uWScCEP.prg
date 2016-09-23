#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8090/UWSCEP.apw?WSDL
Gerado em        09/22/16 21:20:27
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
===============================================================================*/

User Function _KANKVLR; Return  // "dummy" function - Internal Use

/* -------------------------------------------------------------------------------
WSDL Service WSUWSCEP
------------------------------------------------------------------------------- */

WSCLIENT WSUWSCEP

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD CEPSEARCH

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   _COOKIES                  AS Array of String
    WSDATA   cCEP                      AS string
    WSDATA   cCEPSEARCHRESULT          AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSUWSCEP
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160707 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSUWSCEP
Return

WSMETHOD RESET WSCLIENT WSUWSCEP
::cCEP:=NIL
::cCEPSEARCHRESULT:=NIL
::Init()
Return

WSMETHOD CLONE WSCLIENT WSUWSCEP
Local oClone:=WSUWSCEP():New()
    oClone:_URL:=::_URL
    oClone:cCEP:=::cCEP
    oClone:cCEPSEARCHRESULT:=::cCEPSEARCHRESULT
Return oClone

// WSDL Method CEPSEARCH of Service WSUWSCEP

WSMETHOD CEPSEARCH WSSEND cCEP WSRECEIVE cCEPSEARCHRESULT WSCLIENT WSUWSCEP
Local cSoap:="",oXmlRet

BEGIN WSMETHOD

cSoap +='<CEPSEARCH xmlns="http://localhost/naldo/ws/uWSCEP.apw">'
cSoap +=WSSoapValue("CEP",::cCEP, cCEP,"string", .T.,.F., 0,NIL, .F.)
cSoap +="</CEPSEARCH>"

oXmlRet:=SvcSoapCall(Self,cSoap,;
    "http://localhost/naldo/ws/uWSCEP.apw/CEPSEARCH",;
    "DOCUMENT","http://localhost/naldo/ws/uWSCEP.apw",,"1.031217",;
    "http://localhost:8090/UWSCEP.apw")

::Init()
::cCEPSEARCHRESULT:=WSAdvValue(oXmlRet,"_CEPSEARCHRESPONSE:_CEPSEARCHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL)

END WSMETHOD

oXmlRet:=NIL
Return .T.
