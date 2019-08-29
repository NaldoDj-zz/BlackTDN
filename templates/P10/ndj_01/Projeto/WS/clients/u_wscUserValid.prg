#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.143.193.18/ws/U_WSUSERVALID.apw?WSDL
Gerado em        05/03/11 11:46:53
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.101007
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _YCTJFPW ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSUSERVALID
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSUSERVALID

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD ISAUTHENTICATED
    WSMETHOD VALIDUSERWS

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   cTOKEN                    AS string
    WSDATA   lLUSETIMEOUT              AS boolean
    WSDATA   lISAUTHENTICATEDRESULT    AS boolean
    WSDATA   cUSERWS                   AS string
    WSDATA   cUSERWSPASSWD             AS string
    WSDATA   nCHECKSUM                 AS integer
    WSDATA   lHASHMD5USERANDPSW        AS boolean
    WSDATA   cLANGUAGE                 AS string
    WSDATA   lEMBARALHA                AS boolean
    WSDATA   cVALIDUSERWSRESULT        AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSUSERVALID
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110330] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSUSERVALID
Return

WSMETHOD RESET WSCLIENT WSU_WSUSERVALID
    ::cTOKEN             := NIL 
    ::lLUSETIMEOUT       := NIL 
    ::lISAUTHENTICATEDRESULT := NIL 
    ::cUSERWS            := NIL 
    ::cUSERWSPASSWD      := NIL 
    ::nCHECKSUM          := NIL 
    ::lHASHMD5USERANDPSW := NIL 
    ::cLANGUAGE          := NIL 
    ::lEMBARALHA         := NIL 
    ::cVALIDUSERWSRESULT := NIL 
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSUSERVALID
Local oClone := WSU_WSUSERVALID():New()
    oClone:_URL          := ::_URL 
    oClone:cTOKEN        := ::cTOKEN
    oClone:lLUSETIMEOUT  := ::lLUSETIMEOUT
    oClone:lISAUTHENTICATEDRESULT := ::lISAUTHENTICATEDRESULT
    oClone:cUSERWS       := ::cUSERWS
    oClone:cUSERWSPASSWD := ::cUSERWSPASSWD
    oClone:nCHECKSUM     := ::nCHECKSUM
    oClone:lHASHMD5USERANDPSW := ::lHASHMD5USERANDPSW
    oClone:cLANGUAGE     := ::cLANGUAGE
    oClone:lEMBARALHA    := ::lEMBARALHA
    oClone:cVALIDUSERWSRESULT := ::cVALIDUSERWSRESULT
Return oClone

// WSDL Method ISAUTHENTICATED of Service WSU_WSUSERVALID

WSMETHOD ISAUTHENTICATED WSSEND cTOKEN,lLUSETIMEOUT WSRECEIVE lISAUTHENTICATEDRESULT WSCLIENT WSU_WSUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ISAUTHENTICATED xmlns="http://200.143.193.18/ws/u_wsuservalid.apw">'
cSoap += WSSoapValue("TOKEN", ::cTOKEN, cTOKEN , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("LUSETIMEOUT", ::lLUSETIMEOUT, lLUSETIMEOUT , "boolean", .F. , .F., 0 , NIL, .T.) 
cSoap += "</ISAUTHENTICATED>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wsuservalid.apw/ISAUTHENTICATED",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wsuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSUSERVALID.apw")

::Init()
::lISAUTHENTICATEDRESULT :=  WSAdvValue( oXmlRet,"_ISAUTHENTICATEDRESPONSE:_ISAUTHENTICATEDRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method VALIDUSERWS of Service WSU_WSUSERVALID

WSMETHOD VALIDUSERWS WSSEND cUSERWS,cUSERWSPASSWD,nCHECKSUM,lHASHMD5USERANDPSW,cLANGUAGE,lEMBARALHA WSRECEIVE cVALIDUSERWSRESULT WSCLIENT WSU_WSUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VALIDUSERWS xmlns="http://200.143.193.18/ws/u_wsuservalid.apw">'
cSoap += WSSoapValue("USERWS", ::cUSERWS, cUSERWS , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("USERWSPASSWD", ::cUSERWSPASSWD, cUSERWSPASSWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("HASHMD5USERANDPSW", ::lHASHMD5USERANDPSW, lHASHMD5USERANDPSW , "boolean", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("LANGUAGE", ::cLANGUAGE, cLANGUAGE , "string", .F. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("EMBARALHA", ::lEMBARALHA, lEMBARALHA , "boolean", .F. , .F., 0 , NIL, .T.) 
cSoap += "</VALIDUSERWS>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wsuservalid.apw/VALIDUSERWS",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wsuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSUSERVALID.apw")

::Init()
::cVALIDUSERWSRESULT :=  WSAdvValue( oXmlRet,"_VALIDUSERWSRESPONSE:_VALIDUSERWSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.
