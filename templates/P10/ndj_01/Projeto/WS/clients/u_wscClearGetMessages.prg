#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.143.193.18/ws/U_WSCLEARMESSAGES.apw?WSDL
Gerado em        05/03/11 11:46:37
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.101007
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _OLOMCDL ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSCLEARMESSAGES
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSCLEARMESSAGES

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD CLEARSTACKMD5HASH

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   cTOKEN                    AS string
    WSDATA   lCLEARALLMD5HASH          AS boolean
    WSDATA   cMD5HASHCLEAR             AS string
    WSDATA   cCLEARSTACKMD5HASHRESULT  AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSCLEARMESSAGES
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110330] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSCLEARMESSAGES
Return

WSMETHOD RESET WSCLIENT WSU_WSCLEARMESSAGES
    ::cTOKEN             := NIL 
    ::lCLEARALLMD5HASH   := NIL 
    ::cMD5HASHCLEAR      := NIL 
    ::cCLEARSTACKMD5HASHRESULT := NIL 
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSCLEARMESSAGES
Local oClone := WSU_WSCLEARMESSAGES():New()
    oClone:_URL          := ::_URL 
    oClone:cTOKEN        := ::cTOKEN
    oClone:lCLEARALLMD5HASH := ::lCLEARALLMD5HASH
    oClone:cMD5HASHCLEAR := ::cMD5HASHCLEAR
    oClone:cCLEARSTACKMD5HASHRESULT := ::cCLEARSTACKMD5HASHRESULT
Return oClone

// WSDL Method CLEARSTACKMD5HASH of Service WSU_WSCLEARMESSAGES

WSMETHOD CLEARSTACKMD5HASH WSSEND cTOKEN,lCLEARALLMD5HASH,cMD5HASHCLEAR WSRECEIVE cCLEARSTACKMD5HASHRESULT WSCLIENT WSU_WSCLEARMESSAGES
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CLEARSTACKMD5HASH xmlns="http://localhost/naldo/u_wsclearmessages.apw">'
cSoap += WSSoapValue("TOKEN", ::cTOKEN, cTOKEN , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CLEARALLMD5HASH", ::lCLEARALLMD5HASH, lCLEARALLMD5HASH , "boolean", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("MD5HASHCLEAR", ::cMD5HASHCLEAR, cMD5HASHCLEAR , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += "</CLEARSTACKMD5HASH>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://localhost/naldo/u_wsclearmessages.apw/CLEARSTACKMD5HASH",; 
    "DOCUMENT","http://localhost/naldo/u_wsclearmessages.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSCLEARMESSAGES.apw")

::Init()
::cCLEARSTACKMD5HASHRESULT :=  WSAdvValue( oXmlRet,"_CLEARSTACKMD5HASHRESPONSE:_CLEARSTACKMD5HASHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.
