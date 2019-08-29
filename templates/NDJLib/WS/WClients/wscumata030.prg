#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.39:8087/wsd02/UMATA030.apw?WSDL
Gerado em        12/14/13 15:46:08
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _CHKQOJN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSUMATA030
------------------------------------------------------------------------------- */

WSCLIENT WSUMATA030

    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD RESET
    WSMETHOD CLONE
    WSMETHOD EVALMATA030

    WSDATA   _URL                      AS String
    WSDATA   _HEADOUT                  AS Array of String
    WSDATA   _COOKIES                  AS Array of String
    WSDATA   oWSGETMATA030             AS UMATA030_TMATA030GET
    WSDATA   oWSEVALMATA030RESULT      AS UMATA030_TMATA030RET

    // Estruturas mantidas por compatibilidade - NÃO USAR
    WSDATA   oWSTMATA030GET            AS UMATA030_TMATA030GET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSUMATA030
::Init()
If !FindFunction("XMLCHILDEX")
    UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131011] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSUMATA030
    ::oWSGETMATA030      := UMATA030_TMATA030GET():New()
    ::oWSEVALMATA030RESULT := UMATA030_TMATA030RET():New()

    // Estruturas mantidas por compatibilidade - NÃO USAR
    ::oWSTMATA030GET     := ::oWSGETMATA030
Return

WSMETHOD RESET WSCLIENT WSUMATA030
    ::oWSGETMATA030      := NIL 
    ::oWSEVALMATA030RESULT := NIL 

    // Estruturas mantidas por compatibilidade - NÃO USAR
    ::oWSTMATA030GET     := NIL
    ::Init()
Return

WSMETHOD CLONE WSCLIENT WSUMATA030
Local oClone := WSUMATA030():New()
    oClone:_URL          := ::_URL 
    oClone:oWSGETMATA030 :=  IIF(::oWSGETMATA030 = NIL , NIL ,::oWSGETMATA030:Clone() )
    oClone:oWSEVALMATA030RESULT :=  IIF(::oWSEVALMATA030RESULT = NIL , NIL ,::oWSEVALMATA030RESULT:Clone() )

    // Estruturas mantidas por compatibilidade - NÃO USAR
    oClone:oWSTMATA030GET := oClone:oWSGETMATA030
Return oClone

// WSDL Method EVALMATA030 of Service WSUMATA030

WSMETHOD EVALMATA030 WSSEND oWSGETMATA030 WSRECEIVE oWSEVALMATA030RESULT WSCLIENT WSUMATA030
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<EVALMATA030 xmlns="http://www.blacktdn.com.br">'
cSoap += WSSoapValue("GETMATA030", ::oWSGETMATA030, oWSGETMATA030 , "TMATA030GET", .T. , .F., 0 , NIL, .F.) 
cSoap += "</EVALMATA030>"

oXmlRet := SvcSoapCall(    Self,cSoap,; 
    "http://www.blacktdn.com.br/EVALMATA030",; 
    "DOCUMENT","http://www.blacktdn.com.br",,"1.031217",; 
    "http://192.168.0.39:8087/wsd02/UMATA030.apw")

::Init()
::oWSEVALMATA030RESULT:SoapRecv( WSAdvValue( oXmlRet,"_EVALMATA030RESPONSE:_EVALMATA030RESULT","TMATA030RET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TMATA030GET

WSSTRUCT UMATA030_TMATA030GET
    WSDATA   cA1_BAIRRO                AS string
    WSDATA   cA1_CEP                   AS string
    WSDATA   cA1_CGC                   AS string
    WSDATA   cA1_COD                   AS string
    WSDATA   cA1_COD_MUN               AS string
    WSDATA   cA1_CODPAIS               AS string
    WSDATA   cA1_COND                  AS string
    WSDATA   cA1_CONTA                 AS string
    WSDATA   cA1_CONTRIB               AS string
    WSDATA   cA1_EMAIL                 AS string
    WSDATA   cA1_END                   AS string
    WSDATA   cA1_EST                   AS string
    WSDATA   cA1_FILIAL                AS string
    WSDATA   cA1_INSCR                 AS string
    WSDATA   cA1_LOJA                  AS string
    WSDATA   cA1_MUN                   AS string
    WSDATA   cA1_NOME                  AS string
    WSDATA   cA1_NREDUZ                AS string
    WSDATA   cA1_PAIS                  AS string
    WSDATA   cA1_RISCO                 AS string
    WSDATA   cA1_T_CDDCP               AS string
    WSDATA   cA1_T_TPDCP               AS string
    WSDATA   cA1_TIPO                  AS string
    WSDATA   cA1_TPFRET                AS string
    WSDATA   dA1_VENCLC                AS date
    WSDATA   cA1_X_CT                  AS string
    WSDATA   cA1_X_MUN                 AS string
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA030_TMATA030GET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA030_TMATA030GET
Return

WSMETHOD CLONE WSCLIENT UMATA030_TMATA030GET
    Local oClone := UMATA030_TMATA030GET():NEW()
    oClone:cA1_BAIRRO           := ::cA1_BAIRRO
    oClone:cA1_CEP              := ::cA1_CEP
    oClone:cA1_CGC              := ::cA1_CGC
    oClone:cA1_COD              := ::cA1_COD
    oClone:cA1_COD_MUN          := ::cA1_COD_MUN
    oClone:cA1_CODPAIS          := ::cA1_CODPAIS
    oClone:cA1_COND             := ::cA1_COND
    oClone:cA1_CONTA            := ::cA1_CONTA
    oClone:cA1_CONTRIB          := ::cA1_CONTRIB
    oClone:cA1_EMAIL            := ::cA1_EMAIL
    oClone:cA1_END              := ::cA1_END
    oClone:cA1_EST              := ::cA1_EST
    oClone:cA1_FILIAL           := ::cA1_FILIAL
    oClone:cA1_INSCR            := ::cA1_INSCR
    oClone:cA1_LOJA             := ::cA1_LOJA
    oClone:cA1_MUN              := ::cA1_MUN
    oClone:cA1_NOME             := ::cA1_NOME
    oClone:cA1_NREDUZ           := ::cA1_NREDUZ
    oClone:cA1_PAIS             := ::cA1_PAIS
    oClone:cA1_RISCO            := ::cA1_RISCO
    oClone:cA1_T_CDDCP          := ::cA1_T_CDDCP
    oClone:cA1_T_TPDCP          := ::cA1_T_TPDCP
    oClone:cA1_TIPO             := ::cA1_TIPO
    oClone:cA1_TPFRET           := ::cA1_TPFRET
    oClone:dA1_VENCLC           := ::dA1_VENCLC
    oClone:cA1_X_CT             := ::cA1_X_CT
    oClone:cA1_X_MUN            := ::cA1_X_MUN
Return oClone

WSMETHOD SOAPSEND WSCLIENT UMATA030_TMATA030GET
    Local cSoap := ""
    cSoap += WSSoapValue("A1_BAIRRO", ::cA1_BAIRRO, ::cA1_BAIRRO , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_CEP", ::cA1_CEP, ::cA1_CEP , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_CGC", ::cA1_CGC, ::cA1_CGC , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_COD", ::cA1_COD, ::cA1_COD , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_COD_MUN", ::cA1_COD_MUN, ::cA1_COD_MUN , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_CODPAIS", ::cA1_CODPAIS, ::cA1_CODPAIS , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_COND", ::cA1_COND, ::cA1_COND , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_CONTA", ::cA1_CONTA, ::cA1_CONTA , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_CONTRIB", ::cA1_CONTRIB, ::cA1_CONTRIB , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_EMAIL", ::cA1_EMAIL, ::cA1_EMAIL , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_END", ::cA1_END, ::cA1_END , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_EST", ::cA1_EST, ::cA1_EST , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_FILIAL", ::cA1_FILIAL, ::cA1_FILIAL , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_INSCR", ::cA1_INSCR, ::cA1_INSCR , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_LOJA", ::cA1_LOJA, ::cA1_LOJA , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_MUN", ::cA1_MUN, ::cA1_MUN , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_NOME", ::cA1_NOME, ::cA1_NOME , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_NREDUZ", ::cA1_NREDUZ, ::cA1_NREDUZ , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_PAIS", ::cA1_PAIS, ::cA1_PAIS , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_RISCO", ::cA1_RISCO, ::cA1_RISCO , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_T_CDDCP", ::cA1_T_CDDCP, ::cA1_T_CDDCP , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_T_TPDCP", ::cA1_T_TPDCP, ::cA1_T_TPDCP , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_TIPO", ::cA1_TIPO, ::cA1_TIPO , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_TPFRET", ::cA1_TPFRET, ::cA1_TPFRET , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_VENCLC", ::dA1_VENCLC, ::dA1_VENCLC , "date", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_X_CT", ::cA1_X_CT, ::cA1_X_CT , "string", .T. , .F., 0 , NIL, .F.) 
    cSoap += WSSoapValue("A1_X_MUN", ::cA1_X_MUN, ::cA1_X_MUN , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure TMATA030RET

WSSTRUCT UMATA030_TMATA030RET
    WSDATA   cA1_COD                   AS string
    WSDATA   cA1_FILIAL                AS string
    WSDATA   cA1_LOJA                  AS string
    WSMETHOD NEW
    WSMETHOD INIT
    WSMETHOD CLONE
    WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT UMATA030_TMATA030RET
    ::Init()
Return Self

WSMETHOD INIT WSCLIENT UMATA030_TMATA030RET
Return

WSMETHOD CLONE WSCLIENT UMATA030_TMATA030RET
    Local oClone := UMATA030_TMATA030RET():NEW()
    oClone:cA1_COD              := ::cA1_COD
    oClone:cA1_FILIAL           := ::cA1_FILIAL
    oClone:cA1_LOJA             := ::cA1_LOJA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT UMATA030_TMATA030RET
    ::Init()
    If oResponse = NIL ; Return ; Endif 
    ::cA1_COD            :=  WSAdvValue( oResponse,"_A1_COD","string",NIL,"Property cA1_COD as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cA1_FILIAL         :=  WSAdvValue( oResponse,"_A1_FILIAL","string",NIL,"Property cA1_FILIAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
    ::cA1_LOJA           :=  WSAdvValue( oResponse,"_A1_LOJA","string",NIL,"Property cA1_LOJA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return
