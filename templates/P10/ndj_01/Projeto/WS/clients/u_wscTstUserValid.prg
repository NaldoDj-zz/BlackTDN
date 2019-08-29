#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.143.193.18/ws/U_WSTSTUSERVALID.apw?WSDL
Gerado em        05/25/11 19:19:23
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.101007
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _DMDPQJO ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSTSTUSERVALID
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSTSTUSERVALID

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD SAMPLEVLD01
    WSMETHOD SAMPLEVLD02
    WSMETHOD SAMPLEVLD03
    WSMETHOD SAMPLEVLD04
    WSMETHOD SAMPLEVLD05
    WSMETHOD SAMPLEVLD06
    WSMETHOD SAMPLEVLD07
    WSMETHOD SAMPLEVLD08
    WSMETHOD SAMPLEVLD09
    WSMETHOD SAMPLEVLD10
    WSMETHOD SAMPLEVLD11
    WSMETHOD SAMPLEVLD12
    WSMETHOD SAMPLEVLD13
    WSMETHOD SAMPLEVLD14
    WSMETHOD SAMPLEVLD15
    WSMETHOD SAMPLEVLD16
    WSMETHOD SAMPLEVLD17
    WSMETHOD SAMPLEVLD18
    WSMETHOD SAMPLEVLD19
    WSMETHOD SAMPLEVLD20
    WSMETHOD SAMPLEVLD21
    WSMETHOD SAMPLEVLD22
    WSMETHOD SAMPLEVLD23
    WSMETHOD SAMPLEVLD24
    WSMETHOD SAMPLEVLD25
    WSMETHOD SAMPLEVLD26
    WSMETHOD SAMPLEVLD27
    WSMETHOD SAMPLEVLD28
    WSMETHOD SAMPLEVLD29
    WSMETHOD SAMPLEVLD30
    WSMETHOD SAMPLEVLD31
    WSMETHOD SAMPLEVLD32
    WSMETHOD SAMPLEVLD33

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   cUSR                      AS string
    WSDATA   cPWD                      AS string
    WSDATA   nCHECKSUM                 AS integer
    WSDATA   lSAMPLEVLD01RESULT        AS boolean
    WSDATA   lSAMPLEVLD02RESULT        AS boolean
    WSDATA   lSAMPLEVLD03RESULT        AS boolean
    WSDATA   lSAMPLEVLD04RESULT        AS boolean
    WSDATA   lSAMPLEVLD05RESULT        AS boolean
    WSDATA   lSAMPLEVLD06RESULT        AS boolean
    WSDATA   lSAMPLEVLD07RESULT        AS boolean
    WSDATA   lSAMPLEVLD08RESULT        AS boolean
    WSDATA   lSAMPLEVLD09RESULT        AS boolean
    WSDATA   lSAMPLEVLD10RESULT        AS boolean
    WSDATA   lSAMPLEVLD11RESULT        AS boolean
    WSDATA   lSAMPLEVLD12RESULT        AS boolean
    WSDATA   lSAMPLEVLD13RESULT        AS boolean
    WSDATA   lSAMPLEVLD14RESULT        AS boolean
    WSDATA   lSAMPLEVLD15RESULT        AS boolean
    WSDATA   lSAMPLEVLD16RESULT        AS boolean
    WSDATA   lSAMPLEVLD17RESULT        AS boolean
    WSDATA   lSAMPLEVLD18RESULT        AS boolean
    WSDATA   lSAMPLEVLD19RESULT        AS boolean
    WSDATA   lSAMPLEVLD20RESULT        AS boolean
    WSDATA   lSAMPLEVLD21RESULT        AS boolean
    WSDATA   lSAMPLEVLD22RESULT        AS boolean
    WSDATA   lSAMPLEVLD23RESULT        AS boolean
    WSDATA   lSAMPLEVLD24RESULT        AS boolean
    WSDATA   lSAMPLEVLD25RESULT        AS boolean
    WSDATA   lSAMPLEVLD26RESULT        AS boolean
    WSDATA   lSAMPLEVLD27RESULT        AS boolean
    WSDATA   lSAMPLEVLD28RESULT        AS boolean
    WSDATA   lSAMPLEVLD29RESULT        AS boolean
    WSDATA   lSAMPLEVLD30RESULT        AS boolean
    WSDATA   lSAMPLEVLD31RESULT        AS boolean
    WSDATA   lSAMPLEVLD32RESULT        AS boolean
    WSDATA   cSAMPLEVLD33RESULT        AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSTSTUSERVALID
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.101202A-20110330] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSTSTUSERVALID
Return

WSMETHOD RESET WSCLIENT WSU_WSTSTUSERVALID
    ::cUSR               := NIL 
    ::cPWD               := NIL 
    ::nCHECKSUM          := NIL 
    ::lSAMPLEVLD01RESULT := NIL 
    ::lSAMPLEVLD02RESULT := NIL 
    ::lSAMPLEVLD03RESULT := NIL 
    ::lSAMPLEVLD04RESULT := NIL 
    ::lSAMPLEVLD05RESULT := NIL 
    ::lSAMPLEVLD06RESULT := NIL 
    ::lSAMPLEVLD07RESULT := NIL 
    ::lSAMPLEVLD08RESULT := NIL 
    ::lSAMPLEVLD09RESULT := NIL 
    ::lSAMPLEVLD10RESULT := NIL 
    ::lSAMPLEVLD11RESULT := NIL 
    ::lSAMPLEVLD12RESULT := NIL 
    ::lSAMPLEVLD13RESULT := NIL 
    ::lSAMPLEVLD14RESULT := NIL 
    ::lSAMPLEVLD15RESULT := NIL 
    ::lSAMPLEVLD16RESULT := NIL 
    ::lSAMPLEVLD17RESULT := NIL 
    ::lSAMPLEVLD18RESULT := NIL 
    ::lSAMPLEVLD19RESULT := NIL 
    ::lSAMPLEVLD20RESULT := NIL 
    ::lSAMPLEVLD21RESULT := NIL 
    ::lSAMPLEVLD22RESULT := NIL 
    ::lSAMPLEVLD23RESULT := NIL 
    ::lSAMPLEVLD24RESULT := NIL 
    ::lSAMPLEVLD25RESULT := NIL 
    ::lSAMPLEVLD26RESULT := NIL 
    ::lSAMPLEVLD27RESULT := NIL 
    ::lSAMPLEVLD28RESULT := NIL 
    ::lSAMPLEVLD29RESULT := NIL 
    ::lSAMPLEVLD30RESULT := NIL 
    ::lSAMPLEVLD31RESULT := NIL 
    ::lSAMPLEVLD32RESULT := NIL 
    ::cSAMPLEVLD33RESULT := NIL 
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSTSTUSERVALID
Local oClone := WSU_WSTSTUSERVALID():New()
    oClone:_URL          := ::_URL 
    oClone:cUSR          := ::cUSR
    oClone:cPWD          := ::cPWD
    oClone:nCHECKSUM     := ::nCHECKSUM
    oClone:lSAMPLEVLD01RESULT := ::lSAMPLEVLD01RESULT
    oClone:lSAMPLEVLD02RESULT := ::lSAMPLEVLD02RESULT
    oClone:lSAMPLEVLD03RESULT := ::lSAMPLEVLD03RESULT
    oClone:lSAMPLEVLD04RESULT := ::lSAMPLEVLD04RESULT
    oClone:lSAMPLEVLD05RESULT := ::lSAMPLEVLD05RESULT
    oClone:lSAMPLEVLD06RESULT := ::lSAMPLEVLD06RESULT
    oClone:lSAMPLEVLD07RESULT := ::lSAMPLEVLD07RESULT
    oClone:lSAMPLEVLD08RESULT := ::lSAMPLEVLD08RESULT
    oClone:lSAMPLEVLD09RESULT := ::lSAMPLEVLD09RESULT
    oClone:lSAMPLEVLD10RESULT := ::lSAMPLEVLD10RESULT
    oClone:lSAMPLEVLD11RESULT := ::lSAMPLEVLD11RESULT
    oClone:lSAMPLEVLD12RESULT := ::lSAMPLEVLD12RESULT
    oClone:lSAMPLEVLD13RESULT := ::lSAMPLEVLD13RESULT
    oClone:lSAMPLEVLD14RESULT := ::lSAMPLEVLD14RESULT
    oClone:lSAMPLEVLD15RESULT := ::lSAMPLEVLD15RESULT
    oClone:lSAMPLEVLD16RESULT := ::lSAMPLEVLD16RESULT
    oClone:lSAMPLEVLD17RESULT := ::lSAMPLEVLD17RESULT
    oClone:lSAMPLEVLD18RESULT := ::lSAMPLEVLD18RESULT
    oClone:lSAMPLEVLD19RESULT := ::lSAMPLEVLD19RESULT
    oClone:lSAMPLEVLD20RESULT := ::lSAMPLEVLD20RESULT
    oClone:lSAMPLEVLD21RESULT := ::lSAMPLEVLD21RESULT
    oClone:lSAMPLEVLD22RESULT := ::lSAMPLEVLD22RESULT
    oClone:lSAMPLEVLD23RESULT := ::lSAMPLEVLD23RESULT
    oClone:lSAMPLEVLD24RESULT := ::lSAMPLEVLD24RESULT
    oClone:lSAMPLEVLD25RESULT := ::lSAMPLEVLD25RESULT
    oClone:lSAMPLEVLD26RESULT := ::lSAMPLEVLD26RESULT
    oClone:lSAMPLEVLD27RESULT := ::lSAMPLEVLD27RESULT
    oClone:lSAMPLEVLD28RESULT := ::lSAMPLEVLD28RESULT
    oClone:lSAMPLEVLD29RESULT := ::lSAMPLEVLD29RESULT
    oClone:lSAMPLEVLD30RESULT := ::lSAMPLEVLD30RESULT
    oClone:lSAMPLEVLD31RESULT := ::lSAMPLEVLD31RESULT
    oClone:lSAMPLEVLD32RESULT := ::lSAMPLEVLD32RESULT
    oClone:cSAMPLEVLD33RESULT := ::cSAMPLEVLD33RESULT
Return oClone

// WSDL Method SAMPLEVLD01 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD01 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD01RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD01 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD01>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD01",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD01RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD01RESPONSE:_SAMPLEVLD01RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD02 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD02 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD02RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD02 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD02>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD02",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD02RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD02RESPONSE:_SAMPLEVLD02RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD03 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD03 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD03RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD03 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD03>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD03",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD03RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD03RESPONSE:_SAMPLEVLD03RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD04 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD04 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD04RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD04 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD04>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD04",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD04RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD04RESPONSE:_SAMPLEVLD04RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD05 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD05 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD05RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD05 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD05>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD05",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD05RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD05RESPONSE:_SAMPLEVLD05RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD06 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD06 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD06RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD06 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD06>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD06",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD06RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD06RESPONSE:_SAMPLEVLD06RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD07 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD07 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD07RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD07 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD07>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD07",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD07RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD07RESPONSE:_SAMPLEVLD07RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD08 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD08 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD08RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD08 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD08>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD08",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD08RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD08RESPONSE:_SAMPLEVLD08RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD09 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD09 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD09RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD09 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD09>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD09",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD09RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD09RESPONSE:_SAMPLEVLD09RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD10 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD10 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD10RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD10 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD10>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD10",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD10RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD10RESPONSE:_SAMPLEVLD10RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD11 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD11 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD11RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD11 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD11>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD11",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD11RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD11RESPONSE:_SAMPLEVLD11RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD12 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD12 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD12RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD12 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD12>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD12",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD12RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD12RESPONSE:_SAMPLEVLD12RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD13 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD13 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD13RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD13 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD13>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD13",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD13RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD13RESPONSE:_SAMPLEVLD13RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD14 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD14 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD14RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD14 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD14>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD14",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD14RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD14RESPONSE:_SAMPLEVLD14RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD15 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD15 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD15RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD15 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD15>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD15",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD15RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD15RESPONSE:_SAMPLEVLD15RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD16 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD16 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD16RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD16 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD16>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD16",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD16RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD16RESPONSE:_SAMPLEVLD16RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD17 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD17 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD17RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD17 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD17>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD17",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD17RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD17RESPONSE:_SAMPLEVLD17RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD18 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD18 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD18RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD18 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD18>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD18",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD18RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD18RESPONSE:_SAMPLEVLD18RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD19 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD19 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD19RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD19 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD19>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD19",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD19RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD19RESPONSE:_SAMPLEVLD19RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD20 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD20 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD20RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD20 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD20>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD20",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD20RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD20RESPONSE:_SAMPLEVLD20RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD21 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD21 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD21RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD21 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD21>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD21",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD21RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD21RESPONSE:_SAMPLEVLD21RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD22 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD22 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD22RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD22 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD22>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD22",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD22RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD22RESPONSE:_SAMPLEVLD22RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD23 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD23 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD23RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD23 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD23>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD23",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD23RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD23RESPONSE:_SAMPLEVLD23RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD24 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD24 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD24RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD24 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD24>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD24",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD24RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD24RESPONSE:_SAMPLEVLD24RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD25 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD25 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD25RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD25 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD25>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD25",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD25RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD25RESPONSE:_SAMPLEVLD25RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD26 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD26 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD26RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD26 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD26>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD26",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD26RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD26RESPONSE:_SAMPLEVLD26RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD27 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD27 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD27RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD27 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD27>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD27",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD27RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD27RESPONSE:_SAMPLEVLD27RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD28 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD28 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD28RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD28 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD28>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD28",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD28RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD28RESPONSE:_SAMPLEVLD28RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD29 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD29 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD29RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD29 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD29>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD29",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD29RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD29RESPONSE:_SAMPLEVLD29RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD30 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD30 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD30RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD30 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD30>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD30",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD30RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD30RESPONSE:_SAMPLEVLD30RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD31 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD31 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD31RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD31 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD31>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD31",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD31RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD31RESPONSE:_SAMPLEVLD31RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD32 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD32 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE lSAMPLEVLD32RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD32 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD32>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD32",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::lSAMPLEVLD32RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD32RESPONSE:_SAMPLEVLD32RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAMPLEVLD33 of Service WSU_WSTSTUSERVALID

WSMETHOD SAMPLEVLD33 WSSEND cUSR,cPWD,nCHECKSUM WSRECEIVE cSAMPLEVLD33RESULT WSCLIENT WSU_WSTSTUSERVALID
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAMPLEVLD33 xmlns="http://200.143.193.18/ws/u_wststuservalid.apw">'
cSoap += WSSoapValue("USR", ::cUSR, cUSR , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("PWD", ::cPWD, cPWD , "string", .T. , .F., 0 , NIL, .T.) 
cSoap += WSSoapValue("CHECKSUM", ::nCHECKSUM, nCHECKSUM , "integer", .T. , .F., 0 , NIL, .T.) 
cSoap += "</SAMPLEVLD33>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://200.143.193.18/ws/u_wststuservalid.apw/SAMPLEVLD33",; 
    "DOCUMENT","http://200.143.193.18/ws/u_wststuservalid.apw",,"1.031217",; 
    "http://200.143.193.18/ws/U_WSTSTUSERVALID.apw")

::Init()
::cSAMPLEVLD33RESULT :=  WSAdvValue( oXmlRet,"_SAMPLEVLD33RESPONSE:_SAMPLEVLD33RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.
