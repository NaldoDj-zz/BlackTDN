#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.39:8087/wsd02/UMATA410.apw?WSDL
Gerado em        12/14/13 13:33:52
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RRCDLJY ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSUMATA410
------------------------------------------------------------------------------- */

WSCLIENT WSUMATA410

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD ADDPEDIDOPECA
    WSMETHOD DELPEDIDOPECA
    WSMETHOD GETPEDIDOKEYPECA
    WSMETHOD GETPEDIDOPECA

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   _COOKIES                  AS Array of String
    WSDATA   cCNPJ                     AS string
    WSDATA   oWSTADDPEDIDO             AS UMATA410_TADDPEDIDOCAB
    WSDATA   cADDPEDIDOPECARESULT      AS string
    WSDATA   cNUMERODOPEDIDO           AS string
    WSDATA   cDELPEDIDOPECARESULT      AS string
    WSDATA   dDINICONSULTA             AS date
    WSDATA   dDFIMCONSULTA             AS date
    WSDATA   oWSGETPEDIDOKEYPECARESULT AS UMATA410_ARRAYOFTGETPEDIDOCAB
    WSDATA   oWSGETPEDIDOPECARESULT    AS UMATA410_TGETPEDIDOCAB

    // Estruturas mantidas por compatibilidade - NÃO USAR
    WSDATA   oWSTADDPEDIDOCAB          AS UMATA410_TADDPEDIDOCAB

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSUMATA410
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131011] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSUMATA410
    ::oWSTADDPEDIDO      := UMATA410_TADDPEDIDOCAB():New()
    ::oWSGETPEDIDOKEYPECARESULT := UMATA410_ARRAYOFTGETPEDIDOCAB():New()
    ::oWSGETPEDIDOPECARESULT := UMATA410_TGETPEDIDOCAB():New()

    // Estruturas mantidas por compatibilidade - NÃO USAR
    ::oWSTADDPEDIDOCAB   := ::oWSTADDPEDIDO
Return

WSMETHOD RESET WSCLIENT WSUMATA410
    ::cCNPJ              := NIL 
    ::oWSTADDPEDIDO      := NIL 
    ::cADDPEDIDOPECARESULT := NIL 
    ::cNUMERODOPEDIDO    := NIL 
    ::cDELPEDIDOPECARESULT := NIL 
    ::dDINICONSULTA      := NIL 
    ::dDFIMCONSULTA      := NIL 
    ::oWSGETPEDIDOKEYPECARESULT := NIL 
    ::oWSGETPEDIDOPECARESULT := NIL 

    // Estruturas mantidas por compatibilidade - NÃO USAR
    ::oWSTADDPEDIDOCAB   := NIL
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSUMATA410
Local oClone := WSUMATA410():New()
    oClone:_URL          := ::_URL 
    oClone:cCNPJ         := ::cCNPJ
    oClone:oWSTADDPEDIDO :=  IIF(::oWSTADDPEDIDO = NIL , NIL ,::oWSTADDPEDIDO:Clone() )
    oClone:cADDPEDIDOPECARESULT := ::cADDPEDIDOPECARESULT
    oClone:cNUMERODOPEDIDO := ::cNUMERODOPEDIDO
    oClone:cDELPEDIDOPECARESULT := ::cDELPEDIDOPECARESULT
    oClone:dDINICONSULTA := ::dDINICONSULTA
    oClone:dDFIMCONSULTA := ::dDFIMCONSULTA
    oClone:oWSGETPEDIDOKEYPECARESULT :=  IIF(::oWSGETPEDIDOKEYPECARESULT = NIL , NIL ,::oWSGETPEDIDOKEYPECARESULT:Clone() )
    oClone:oWSGETPEDIDOPECARESULT :=  IIF(::oWSGETPEDIDOPECARESULT = NIL , NIL ,::oWSGETPEDIDOPECARESULT:Clone() )

    // Estruturas mantidas por compatibilidade - NÃO USAR
    oClone:oWSTADDPEDIDOCAB := oClone:oWSTADDPEDIDO
Return oClone

// WSDL Method ADDPEDIDOPECA of Service WSUMATA410

WSMETHOD ADDPEDIDOPECA WSSEND cCNPJ,oWSTADDPEDIDO WSRECEIVE cADDPEDIDOPECARESULT WSCLIENT WSUMATA410
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ADDPEDIDOPECA xmlns="http://www.blacktdn.com.br">'
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("TADDPEDIDO", ::oWSTADDPEDIDO, oWSTADDPEDIDO , "TADDPEDIDOCAB", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ADDPEDIDOPECA>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://www.blacktdn.com.br/ADDPEDIDOPECA",; 
    "DOCUMENT","http://www.blacktdn.com.br",,"1.031217",; 
    "http://192.168.0.39:8087/wsd02/UMATA410.apw")

::Init()
::cADDPEDIDOPECARESULT :=  WSAdvValue( oXmlRet,"_ADDPEDIDOPECARESPONSE:_ADDPEDIDOPECARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DELPEDIDOPECA of Service WSUMATA410

WSMETHOD DELPEDIDOPECA WSSEND cCNPJ,cNUMERODOPEDIDO WSRECEIVE cDELPEDIDOPECARESULT WSCLIENT WSUMATA410
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DELPEDIDOPECA xmlns="http://www.blacktdn.com.br">'
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NUMERODOPEDIDO", ::cNUMERODOPEDIDO, cNUMERODOPEDIDO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</DELPEDIDOPECA>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://www.blacktdn.com.br/DELPEDIDOPECA",; 
    "DOCUMENT","http://www.blacktdn.com.br",,"1.031217",; 
    "http://192.168.0.39:8087/wsd02/UMATA410.apw")

::Init()
::cDELPEDIDOPECARESULT :=  WSAdvValue( oXmlRet,"_DELPEDIDOPECARESPONSE:_DELPEDIDOPECARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETPEDIDOKEYPECA of Service WSUMATA410

WSMETHOD GETPEDIDOKEYPECA WSSEND cCNPJ,dDINICONSULTA,dDFIMCONSULTA WSRECEIVE oWSGETPEDIDOKEYPECARESULT WSCLIENT WSUMATA410
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPEDIDOKEYPECA xmlns="http://www.blacktdn.com.br">'
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DINICONSULTA", ::dDINICONSULTA, dDINICONSULTA , "date", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DFIMCONSULTA", ::dDFIMCONSULTA, dDFIMCONSULTA , "date", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GETPEDIDOKEYPECA>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://www.blacktdn.com.br/GETPEDIDOKEYPECA",; 
    "DOCUMENT","http://www.blacktdn.com.br",,"1.031217",; 
    "http://192.168.0.39:8087/wsd02/UMATA410.apw")

::Init()
::oWSGETPEDIDOKEYPECARESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETPEDIDOKEYPECARESPONSE:_GETPEDIDOKEYPECARESULT","ARRAYOFTGETPEDIDOCAB",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETPEDIDOPECA of Service WSUMATA410

WSMETHOD GETPEDIDOPECA WSSEND cCNPJ,cNUMERODOPEDIDO WSRECEIVE oWSGETPEDIDOPECARESULT WSCLIENT WSUMATA410
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPEDIDOPECA xmlns="http://www.blacktdn.com.br">'
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NUMERODOPEDIDO", ::cNUMERODOPEDIDO, cNUMERODOPEDIDO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETPEDIDOPECA>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://www.blacktdn.com.br/GETPEDIDOPECA",; 
    "DOCUMENT","http://www.blacktdn.com.br",,"1.031217",; 
    "http://192.168.0.39:8087/wsd02/UMATA410.apw")

::Init()
::oWSGETPEDIDOPECARESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETPEDIDOPECARESPONSE:_GETPEDIDOPECARESULT","TGETPEDIDOCAB",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TADDPEDIDOCAB

WSSTRUCT UMATA410_TADDPEDIDOCAB
    WSDATA   cCONDICAOPAGAMENTO        AS string
    WSDATA   cTRANSPORTADORACLIENTE    AS string
    WSDATA   oWSTZITENSDOPEDIDO        AS UMATA410_ARRAYOFTADDPEDIDODET
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_TADDPEDIDOCAB
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_TADDPEDIDOCAB
Return

WSMETHOD CLONE WSCLIENT UMATA410_TADDPEDIDOCAB
    Local oClone := UMATA410_TADDPEDIDOCAB():NEW()
    oClone:cCONDICAOPAGAMENTO   := ::cCONDICAOPAGAMENTO
    oClone:cTRANSPORTADORACLIENTE := ::cTRANSPORTADORACLIENTE
    oClone:oWSTZITENSDOPEDIDO   := IIF(::oWSTZITENSDOPEDIDO = NIL , NIL , ::oWSTZITENSDOPEDIDO:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT UMATA410_TADDPEDIDOCAB
    Local cSoap := ""
    cSoap += WSSoapValue("CONDICAOPAGAMENTO", ::cCONDICAOPAGAMENTO, ::cCONDICAOPAGAMENTO , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("TRANSPORTADORACLIENTE", ::cTRANSPORTADORACLIENTE, ::cTRANSPORTADORACLIENTE , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("TZITENSDOPEDIDO", ::oWSTZITENSDOPEDIDO, ::oWSTZITENSDOPEDIDO , "ARRAYOFTADDPEDIDODET", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ARRAYOFTGETPEDIDOCAB

WSSTRUCT UMATA410_ARRAYOFTGETPEDIDOCAB
    WSDATA   oWSTGETPEDIDOCAB          AS UMATA410_TGETPEDIDOCAB OPTIONAL
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_ARRAYOFTGETPEDIDOCAB
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_ARRAYOFTGETPEDIDOCAB
    ::oWSTGETPEDIDOCAB     := {} // Array Of  UMATA410_TGETPEDIDOCAB():New()
Return

WSMETHOD CLONE WSCLIENT UMATA410_ARRAYOFTGETPEDIDOCAB
    Local oClone := UMATA410_ARRAYOFTGETPEDIDOCAB():NEW()
    oClone:oWSTGETPEDIDOCAB := NIL
    If ::oWSTGETPEDIDOCAB <> NIL 
        oClone:oWSTGETPEDIDOCAB := {}
        aEval( ::oWSTGETPEDIDOCAB , { |x| aadd( oClone:oWSTGETPEDIDOCAB , x:Clone() ) } )
    Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA410_ARRAYOFTGETPEDIDOCAB
    Local nRElem1, oNodes1, nTElem1
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    oNodes1 :=  WSAdvValue( oResponse,"_TGETPEDIDOCAB","TGETPEDIDOCAB",{},NIL,.T.,"O",NIL,NIL) 
    nTElem1 := len(oNodes1)
    For nRElem1 := 1 to nTElem1 
        If !WSIsNilNode( oNodes1[nRElem1] )
            aadd(::oWSTGETPEDIDOCAB , UMATA410_TGETPEDIDOCAB():New() )
            ::oWSTGETPEDIDOCAB[len(::oWSTGETPEDIDOCAB)]:SoapRecv(oNodes1[nRElem1])
        Endif
    Next
Return

// WSDL Data Structure TGETPEDIDOCAB

WSSTRUCT UMATA410_TGETPEDIDOCAB
    WSDATA   cCODCLIENTE               AS string
    WSDATA   cCODCLIENTEENTREGA        AS string
    WSDATA   cCODLOJACLIENTE           AS string
    WSDATA   cCODLOJAENTREGA           AS string
    WSDATA   cCONDICAOPAGAMENTO        AS string
    WSDATA   dEMISSAOPEDIDO            AS date
    WSDATA   cISSINCLUIDOPRECO         AS string
    WSDATA   nMOEDADOPEDIDO            AS integer
    WSDATA   cNOMEDOCLIENTE            AS string
    WSDATA   cNUMPEDIDOVENDA           AS string
    WSDATA   cTIPODECLIENTE            AS string
    WSDATA   cTIPODEFRETE              AS string
    WSDATA   cTIPODELIBERACAOPEDIDO    AS string
    WSDATA   cTIPODEPEDIDO             AS string
    WSDATA   cTRANSPORTADORACLIENTE    AS string
    WSDATA   oWSTZITENSDOPEDIDO        AS UMATA410_ARRAYOFTGETPEDIDODET
    WSDATA   nTZVALORTOTALDOPEDIDO     AS float
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_TGETPEDIDOCAB
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_TGETPEDIDOCAB
Return

WSMETHOD CLONE WSCLIENT UMATA410_TGETPEDIDOCAB
    Local oClone := UMATA410_TGETPEDIDOCAB():NEW()
    oClone:cCODCLIENTE          := ::cCODCLIENTE
    oClone:cCODCLIENTEENTREGA   := ::cCODCLIENTEENTREGA
    oClone:cCODLOJACLIENTE      := ::cCODLOJACLIENTE
    oClone:cCODLOJAENTREGA      := ::cCODLOJAENTREGA
    oClone:cCONDICAOPAGAMENTO   := ::cCONDICAOPAGAMENTO
    oClone:dEMISSAOPEDIDO       := ::dEMISSAOPEDIDO
    oClone:cISSINCLUIDOPRECO    := ::cISSINCLUIDOPRECO
    oClone:nMOEDADOPEDIDO       := ::nMOEDADOPEDIDO
    oClone:cNOMEDOCLIENTE       := ::cNOMEDOCLIENTE
    oClone:cNUMPEDIDOVENDA      := ::cNUMPEDIDOVENDA
    oClone:cTIPODECLIENTE       := ::cTIPODECLIENTE
    oClone:cTIPODEFRETE         := ::cTIPODEFRETE
    oClone:cTIPODELIBERACAOPEDIDO := ::cTIPODELIBERACAOPEDIDO
    oClone:cTIPODEPEDIDO        := ::cTIPODEPEDIDO
    oClone:cTRANSPORTADORACLIENTE := ::cTRANSPORTADORACLIENTE
    oClone:oWSTZITENSDOPEDIDO   := IIF(::oWSTZITENSDOPEDIDO = NIL , NIL , ::oWSTZITENSDOPEDIDO:Clone() )
    oClone:nTZVALORTOTALDOPEDIDO := ::nTZVALORTOTALDOPEDIDO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA410_TGETPEDIDOCAB
    Local oNode16
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    ::cCODCLIENTE        :=  WSAdvValue( oResponse,"_CODCLIENTE","string",NIL,"Property cCODCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cCODCLIENTEENTREGA :=  WSAdvValue( oResponse,"_CODCLIENTEENTREGA","string",NIL,"Property cCODCLIENTEENTREGA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cCODLOJACLIENTE    :=  WSAdvValue( oResponse,"_CODLOJACLIENTE","string",NIL,"Property cCODLOJACLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cCODLOJAENTREGA    :=  WSAdvValue( oResponse,"_CODLOJAENTREGA","string",NIL,"Property cCODLOJAENTREGA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cCONDICAOPAGAMENTO :=  WSAdvValue( oResponse,"_CONDICAOPAGAMENTO","string",NIL,"Property cCONDICAOPAGAMENTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::dEMISSAOPEDIDO     :=  WSAdvValue( oResponse,"_EMISSAOPEDIDO","date",NIL,"Property dEMISSAOPEDIDO as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
    ::cISSINCLUIDOPRECO  :=  WSAdvValue( oResponse,"_ISSINCLUIDOPRECO","string",NIL,"Property cISSINCLUIDOPRECO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::nMOEDADOPEDIDO     :=  WSAdvValue( oResponse,"_MOEDADOPEDIDO","integer",NIL,"Property nMOEDADOPEDIDO as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
    ::cNOMEDOCLIENTE     :=  WSAdvValue( oResponse,"_NOMEDOCLIENTE","string",NIL,"Property cNOMEDOCLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cNUMPEDIDOVENDA    :=  WSAdvValue( oResponse,"_NUMPEDIDOVENDA","string",NIL,"Property cNUMPEDIDOVENDA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTIPODECLIENTE     :=  WSAdvValue( oResponse,"_TIPODECLIENTE","string",NIL,"Property cTIPODECLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTIPODEFRETE       :=  WSAdvValue( oResponse,"_TIPODEFRETE","string",NIL,"Property cTIPODEFRETE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTIPODELIBERACAOPEDIDO :=  WSAdvValue( oResponse,"_TIPODELIBERACAOPEDIDO","string",NIL,"Property cTIPODELIBERACAOPEDIDO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTIPODEPEDIDO      :=  WSAdvValue( oResponse,"_TIPODEPEDIDO","string",NIL,"Property cTIPODEPEDIDO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTRANSPORTADORACLIENTE :=  WSAdvValue( oResponse,"_TRANSPORTADORACLIENTE","string",NIL,"Property cTRANSPORTADORACLIENTE as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    oNode16 :=  WSAdvValue( oResponse,"_TZITENSDOPEDIDO","ARRAYOFTGETPEDIDODET",NIL,"Property oWSTZITENSDOPEDIDO as s0:ARRAYOFTGETPEDIDODET on SOAP Response not found.",NIL,"O",NIL,NIL) 
    If oNode16 != NIL
        ::oWSTZITENSDOPEDIDO := UMATA410_ARRAYOFTGETPEDIDODET():New()
        ::oWSTZITENSDOPEDIDO:SoapRecv(oNode16)
    EndIf
    ::nTZVALORTOTALDOPEDIDO :=  WSAdvValue( oResponse,"_TZVALORTOTALDOPEDIDO","float",NIL,"Property nTZVALORTOTALDOPEDIDO as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFTADDPEDIDODET

WSSTRUCT UMATA410_ARRAYOFTADDPEDIDODET
    WSDATA   oWSTADDPEDIDODET          AS UMATA410_TADDPEDIDODET OPTIONAL
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_ARRAYOFTADDPEDIDODET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_ARRAYOFTADDPEDIDODET
    ::oWSTADDPEDIDODET     := {} // Array Of  UMATA410_TADDPEDIDODET():New()
Return

WSMETHOD CLONE WSCLIENT UMATA410_ARRAYOFTADDPEDIDODET
    Local oClone := UMATA410_ARRAYOFTADDPEDIDODET():NEW()
    oClone:oWSTADDPEDIDODET := NIL
    If ::oWSTADDPEDIDODET <> NIL 
        oClone:oWSTADDPEDIDODET := {}
        aEval( ::oWSTADDPEDIDODET , { |x| aadd( oClone:oWSTADDPEDIDODET , x:Clone() ) } )
    Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT UMATA410_ARRAYOFTADDPEDIDODET
    Local cSoap := ""
    aEval( ::oWSTADDPEDIDODET , {|x| cSoap := cSoap  +  WSSoapValue("TADDPEDIDODET", x , x , "TADDPEDIDODET", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure ARRAYOFTGETPEDIDODET

WSSTRUCT UMATA410_ARRAYOFTGETPEDIDODET
    WSDATA   oWSTGETPEDIDODET          AS UMATA410_TGETPEDIDODET OPTIONAL
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_ARRAYOFTGETPEDIDODET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_ARRAYOFTGETPEDIDODET
    ::oWSTGETPEDIDODET     := {} // Array Of  UMATA410_TGETPEDIDODET():New()
Return

WSMETHOD CLONE WSCLIENT UMATA410_ARRAYOFTGETPEDIDODET
    Local oClone := UMATA410_ARRAYOFTGETPEDIDODET():NEW()
    oClone:oWSTGETPEDIDODET := NIL
    If ::oWSTGETPEDIDODET <> NIL 
        oClone:oWSTGETPEDIDODET := {}
        aEval( ::oWSTGETPEDIDODET , { |x| aadd( oClone:oWSTGETPEDIDODET , x:Clone() ) } )
    Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA410_ARRAYOFTGETPEDIDODET
    Local nRElem1, oNodes1, nTElem1
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    oNodes1 :=  WSAdvValue( oResponse,"_TGETPEDIDODET","TGETPEDIDODET",{},NIL,.T.,"O",NIL,NIL) 
    nTElem1 := len(oNodes1)
    For nRElem1 := 1 to nTElem1 
        If !WSIsNilNode( oNodes1[nRElem1] )
            aadd(::oWSTGETPEDIDODET , UMATA410_TGETPEDIDODET():New() )
            ::oWSTGETPEDIDODET[len(::oWSTGETPEDIDODET)]:SoapRecv(oNodes1[nRElem1])
        Endif
    Next
Return

// WSDL Data Structure TADDPEDIDODET

WSSTRUCT UMATA410_TADDPEDIDODET
    WSDATA   cPRODUTOPEDIDO            AS string
    WSDATA   nQUANTIDADEPRODUTO        AS integer
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_TADDPEDIDODET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_TADDPEDIDODET
Return

WSMETHOD CLONE WSCLIENT UMATA410_TADDPEDIDODET
    Local oClone := UMATA410_TADDPEDIDODET():NEW()
    oClone:cPRODUTOPEDIDO       := ::cPRODUTOPEDIDO
    oClone:nQUANTIDADEPRODUTO   := ::nQUANTIDADEPRODUTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT UMATA410_TADDPEDIDODET
    Local cSoap := ""
    cSoap += WSSoapValue("PRODUTOPEDIDO", ::cPRODUTOPEDIDO, ::cPRODUTOPEDIDO , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("QUANTIDADEPRODUTO", ::nQUANTIDADEPRODUTO, ::nQUANTIDADEPRODUTO , "integer", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure TGETPEDIDODET

WSSTRUCT UMATA410_TGETPEDIDODET
    WSDATA   cARMAZEM                  AS string
    WSDATA   cBLOQUEIO                 AS string
    WSDATA   cCFOP                     AS string
    WSDATA   dDATAULTIMOFATURAMENTO    AS date
    WSDATA   cDESCRICAOPRODUTO         AS string
    WSDATA   cITEMPEDIDO               AS string
    WSDATA   cNOTAFISCAL               AS string
    WSDATA   nPRECOVENDAPRODUTO        AS float
    WSDATA   cPRODUTOPEDIDO            AS string
    WSDATA   nQUANTIDADEENTREGUE       AS integer
    WSDATA   nQUANTIDADELIBERADA       AS integer
    WSDATA   nQUANTIDADEPRODUTO        AS integer
    WSDATA   cSERIENF                  AS string
    WSDATA   cTIPODEENTRADASAIDA       AS string
    WSDATA   oWSTZSTATUSPEDIDO         AS UMATA410_TSTATUSPEDIDO OPTIONAL
    WSDATA   cUNIDADEMEDIDA            AS string
    WSDATA   nVALORTOTALDOPRODUTO      AS float
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_TGETPEDIDODET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_TGETPEDIDODET
Return

WSMETHOD CLONE WSCLIENT UMATA410_TGETPEDIDODET
    Local oClone := UMATA410_TGETPEDIDODET():NEW()
    oClone:cARMAZEM             := ::cARMAZEM
    oClone:cBLOQUEIO            := ::cBLOQUEIO
    oClone:cCFOP                := ::cCFOP
    oClone:dDATAULTIMOFATURAMENTO := ::dDATAULTIMOFATURAMENTO
    oClone:cDESCRICAOPRODUTO    := ::cDESCRICAOPRODUTO
    oClone:cITEMPEDIDO          := ::cITEMPEDIDO
    oClone:cNOTAFISCAL          := ::cNOTAFISCAL
    oClone:nPRECOVENDAPRODUTO   := ::nPRECOVENDAPRODUTO
    oClone:cPRODUTOPEDIDO       := ::cPRODUTOPEDIDO
    oClone:nQUANTIDADEENTREGUE  := ::nQUANTIDADEENTREGUE
    oClone:nQUANTIDADELIBERADA  := ::nQUANTIDADELIBERADA
    oClone:nQUANTIDADEPRODUTO   := ::nQUANTIDADEPRODUTO
    oClone:cSERIENF             := ::cSERIENF
    oClone:cTIPODEENTRADASAIDA  := ::cTIPODEENTRADASAIDA
    oClone:oWSTZSTATUSPEDIDO    := IIF(::oWSTZSTATUSPEDIDO = NIL , NIL , ::oWSTZSTATUSPEDIDO:Clone() )
    oClone:cUNIDADEMEDIDA       := ::cUNIDADEMEDIDA
    oClone:nVALORTOTALDOPRODUTO := ::nVALORTOTALDOPRODUTO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA410_TGETPEDIDODET
    Local oNode15
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    ::cARMAZEM           :=  WSAdvValue( oResponse,"_ARMAZEM","string",NIL,"Property cARMAZEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cBLOQUEIO          :=  WSAdvValue( oResponse,"_BLOQUEIO","string",NIL,"Property cBLOQUEIO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cCFOP              :=  WSAdvValue( oResponse,"_CFOP","string",NIL,"Property cCFOP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::dDATAULTIMOFATURAMENTO :=  WSAdvValue( oResponse,"_DATAULTIMOFATURAMENTO","date",NIL,"Property dDATAULTIMOFATURAMENTO as s:date on SOAP Response not found.",NIL,"D",NIL,NIL) 
    ::cDESCRICAOPRODUTO  :=  WSAdvValue( oResponse,"_DESCRICAOPRODUTO","string",NIL,"Property cDESCRICAOPRODUTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cITEMPEDIDO        :=  WSAdvValue( oResponse,"_ITEMPEDIDO","string",NIL,"Property cITEMPEDIDO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cNOTAFISCAL        :=  WSAdvValue( oResponse,"_NOTAFISCAL","string",NIL,"Property cNOTAFISCAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::nPRECOVENDAPRODUTO :=  WSAdvValue( oResponse,"_PRECOVENDAPRODUTO","float",NIL,"Property nPRECOVENDAPRODUTO as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
    ::cPRODUTOPEDIDO     :=  WSAdvValue( oResponse,"_PRODUTOPEDIDO","string",NIL,"Property cPRODUTOPEDIDO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::nQUANTIDADEENTREGUE :=  WSAdvValue( oResponse,"_QUANTIDADEENTREGUE","integer",NIL,"Property nQUANTIDADEENTREGUE as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
    ::nQUANTIDADELIBERADA :=  WSAdvValue( oResponse,"_QUANTIDADELIBERADA","integer",NIL,"Property nQUANTIDADELIBERADA as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
    ::nQUANTIDADEPRODUTO :=  WSAdvValue( oResponse,"_QUANTIDADEPRODUTO","integer",NIL,"Property nQUANTIDADEPRODUTO as s:integer on SOAP Response not found.",NIL,"N",NIL,NIL) 
    ::cSERIENF           :=  WSAdvValue( oResponse,"_SERIENF","string",NIL,"Property cSERIENF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cTIPODEENTRADASAIDA :=  WSAdvValue( oResponse,"_TIPODEENTRADASAIDA","string",NIL,"Property cTIPODEENTRADASAIDA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    oNode15 :=  WSAdvValue( oResponse,"_TZSTATUSPEDIDO","TSTATUSPEDIDO",NIL,NIL,NIL,"O",NIL,NIL) 
    If oNode15 != NIL
        ::oWSTZSTATUSPEDIDO := UMATA410_TSTATUSPEDIDO():New()
        ::oWSTZSTATUSPEDIDO:SoapRecv(oNode15)
    EndIf
    ::cUNIDADEMEDIDA     :=  WSAdvValue( oResponse,"_UNIDADEMEDIDA","string",NIL,"Property cUNIDADEMEDIDA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::nVALORTOTALDOPRODUTO :=  WSAdvValue( oResponse,"_VALORTOTALDOPRODUTO","float",NIL,"Property nVALORTOTALDOPRODUTO as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure TSTATUSPEDIDO

WSSTRUCT UMATA410_TSTATUSPEDIDO
    WSDATA   cBLOQCREDITO              AS string OPTIONAL
    WSDATA   cBLOQESTOQUE              AS string OPTIONAL
    WSDATA   cBLOQUEIOWMS              AS string OPTIONAL
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA410_TSTATUSPEDIDO
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA410_TSTATUSPEDIDO
Return

WSMETHOD CLONE WSCLIENT UMATA410_TSTATUSPEDIDO
    Local oClone := UMATA410_TSTATUSPEDIDO():NEW()
    oClone:cBLOQCREDITO         := ::cBLOQCREDITO
    oClone:cBLOQESTOQUE         := ::cBLOQESTOQUE
    oClone:cBLOQUEIOWMS         := ::cBLOQUEIOWMS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA410_TSTATUSPEDIDO
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    ::cBLOQCREDITO       :=  WSAdvValue( oResponse,"_BLOQCREDITO","string",NIL,NIL,NIL,"S",NIL,NIL) 
    ::cBLOQESTOQUE       :=  WSAdvValue( oResponse,"_BLOQESTOQUE","string",NIL,NIL,NIL,"S",NIL,NIL) 
    ::cBLOQUEIOWMS       :=  WSAdvValue( oResponse,"_BLOQUEIOWMS","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return
