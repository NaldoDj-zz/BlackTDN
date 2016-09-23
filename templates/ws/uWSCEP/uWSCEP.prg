#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Servico de Constulta ao Codigo de Enderacamento Postal"
#DEFINE STR0002 "Método para pesquisa do CEP"

/*/
    WSSERVICE:uWSCEP
    Autor:Marinaldo de Jesus
    Data:20/09/2010
    Descrição:Servico de Constulta ao Codigo de Enderacamento Postal a partir da URL http://cep.republicavirtual.com.br/web_cep.php?cep=[cep]
    Uso:Consulta ao CEP (Codigo de Enderecamento Postal)
/*/
WSSERVICE uWSCEP DESCRIPTION STR0001 NAMESPACE "http://localhost/naldo/ws/uWSCEP.apw" //"Servico de Constulta ao Codigo de Enderacamento Postal"

    WSDATA CEP                As String
    WSDATA XML                As String

    WSMETHOD CEPSearch        DESCRIPTION STR0002 //"Método para pesquisa do CEP"

ENDWSSERVICE

/*/
    WSMETHOD:CEPSearch
    Autor:Marinaldo de Jesus
    Data:20/09/2010
    Uso:Consulta de CEP
    Obs.:Metodo Para a Pesquisa do CEP
    Retorna:XML com a Consulta do CEP

/*/
WSMETHOD CEPSearch WSRECEIVE CEP WSSEND XML WSSERVICE uWSCEP

    Local cUrl      AS CHARACTER
    Local lWsReturn AS LOGICAL
    
    DEFAULT lWsReturn:=.T.

    DEFAULT CEP:=Self:CEP

    cUrl:="http://cep.republicavirtual.com.br/web_cep.php?cep="+StrTran(CEP,"-","")+"&formato=xml"
    Self:XML:=HttpGet(cUrl)
    XML:=Self:XML

Return(lWsReturn)
