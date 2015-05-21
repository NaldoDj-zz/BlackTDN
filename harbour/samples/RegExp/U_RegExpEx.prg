#include "protheus.ch"

#DEFINE N_ATTEMPTS          5
#DEFINE MSECONDS_WAIT    5000

Static __cCRLF:=CRLF

/*/

    Funcao:RegExpEx
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp 
    
    Ezzy Learning
    Regular Expression Validation Web Service
    http://www.ezzylearning.com/services/RegularExpressionValidationService.aspx

/*/
User Function RegExpEx()

    Local nVarNameL:=SetVarNameLen(20)

    /*         

        http://www.rafaelalmeida.net/post/regex_alguns_regex
    
        [ REGEX ] - Alguns Regex
    
        EMAIL:^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})$
        CNPJ:^(\d{2}.?\d{3}.?\d{3}/?\d{4}-?\d{2})$
        CPF:(^\d{3}\.?\d{3}\.?\d{3}-\d{2})|(^\d{3}\d{3}\d{3}\d{2})$
        PASSWORD:^(.*(([^a-z1-9]+.*\d+)|(\d+.*[^a-z1-9]+)).*)$
        
        OBS:Com regex são validades somente a disposição dos caracteres,logo o CPF 000.000.000-00 seria validado. Para evitar esse tipo validação,seria necessario implementar funções especificas.
        
        Ainda Sobre os REGEX,o CNPJ e o CPF podem ser escritos com ou sem pontuação. A senha precisa conter números e letras maiúsculas.

    */
    
    //Valido
    MailRegExp("mail@blacktdn.com.br")

    //Invalido
    MailRegExp("mail_blacktdn.com.br")

    //Valido
    CPFRegExp("111.111.111-11")
    
    //Valido
    CPFRegExp("111111111-11")

    //Invalido
    CPFRegExp("1a1.111.111-11")
    
    //Valido
    CNPJRegExp("53.113.791/0001-22")

    //Valido
    CNPJRegExp("53113791/0001-22")

    //InValido
    CNPJRegExp("53113791000122")
    
    //Valido
    PWDRegExp("123PWDRegEx436")

    //InValido
    PWDRegExp("@#PWDRegEx#@")

    SetVarNameLen(nVarNameL)

Return()

/*/
    Funcao:MailRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function MailRegExp(cMail)

    Local cConta:="^[a-zA-Z0-9\._-]+@"
    Local cDominio:="[a-zA-Z0-9\._-]+."
    Local cExtensao:="([a-zA-Z]{2,4})$"
    Local cPattern:=(cConta+cDominio+cExtensao)

    Local lValid:=.F.

    lValid:=SoapRegExp(cMail,cPattern,"1.1")
    ConOut("","RegExp:[SoapRegExp][1.1]["+cMail+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=SoapRegExp(cMail,cPattern,"1.2")
    ConOut("","RegExp:[SoapRegExp][1.2]["+cMail+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpGetRegExp(cMail,cPattern)
    ConOut("","RegExp:[HttpGetRegExp]["+cMail+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpPostRegExp(cMail,cPattern)
    ConOut("","RegExp:[HttpPostRegExp]["+cMail+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=PSRegEx(cMail,cPattern)
    ConOut("","RegExp:[PSRegEx]["+cMail+"]["+cPattern+"]["+AllToChar(lValid)+"]","")

Return(lValid )

/*/
    Funcao:CPFRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function CPFRegExp(cCPF)

    Local cPattern:="(^\d{3}\.?\d{3}\.?\d{3}-\d{2})|(^\d{3}\d{3}\d{3}\d{2})$"

    Local lValid:=.F.

    lValid:=SoapRegExp(cCPF,cPattern,"1.1")
    ConOut("","RegExp:[SoapRegExp][1.1]["+cCPF+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=SoapRegExp(cCPF,cPattern,"1.2")
    ConOut("","RegExp:[SoapRegExp][1.2]["+cCPF+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpGetRegExp(cCPF,cPattern)
    ConOut("","RegExp:[HttpGetRegExp]["+cCPF+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpPostRegExp(cCPF,cPattern)
    ConOut("","RegExp:[HttpPostRegExp]["+cCPF+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=PSRegEx(cCPF,cPattern)
    ConOut("","RegExp:[PSRegEx]["+cCPF+"]["+cPattern+"]["+AllToChar(lValid)+"]","")

Return(lValid )

/*/
    Funcao:CNPJRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function CNPJRegExp(cCNPJ)

    Local cPattern:="^(\d{2}.?\d{3}.?\d{3}/?\d{4}-?\d{2})$"

    Local lValid:=.F.

    lValid:=SoapRegExp(cCNPJ,cPattern,"1.1")
    ConOut("","RegExp:[SoapRegExp][1.1]["+cCNPJ+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=SoapRegExp(cCNPJ,cPattern,"1.2")
    ConOut("","RegExp:[SoapRegExp][1.2]["+cCNPJ+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpGetRegExp(cCNPJ,cPattern)
    ConOut("","RegExp:[HttpGetRegExp]["+cCNPJ+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpPostRegExp(cCNPJ,cPattern)
    ConOut("","RegExp:[HttpPostRegExp]["+cCNPJ+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=PSRegEx(cCNPJ,cPattern)
    ConOut("","RegExp:[PSRegEx]["+cCNPJ+"]["+cPattern+"]["+AllToChar(lValid)+"]","")

Return(lValid )

/*/
    Funcao:PWDRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function PWDRegExp(cPWD)

    Local cPattern:="^(.*(([^a-z1-9]+.*\d+)|(\d+.*[^a-z1-9]+)).*)$"

    Local lValid:=.F.

    lValid:=SoapRegExp(cPWD,cPattern,"1.1")
    ConOut("","RegExp:[SoapRegExp][1.1]["+cPWD+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=SoapRegExp(cPWD,cPattern,"1.2")
    ConOut("","RegExp:[SoapRegExp][1.2]["+cPWD+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpGetRegExp(cPWD,cPattern)
    ConOut("","RegExp:[HttpGetRegExp]["+cPWD+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=HttpPostRegExp(cPWD,cPattern)
    ConOut("","RegExp:[HttpPostRegExp]["+cPWD+"]["+cPattern+"]["+AllToChar(lValid)+"]","")
    lValid:=PSRegEx(cPWD,cPattern)
    ConOut("","RegExp:[PSRegEx]["+cPWD+"]["+cPattern+"]["+AllToChar(lValid)+"]","")

Return(lValid )

/*/
    Funcao:SoapRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function SoapRegExp(cInput,cPattern,cVersion)

    Local cXML:=""
    Local cError:=""
    Local cRequest:=""
    Local cWarning:=""
    Local cXMLResult:=""

    Local lMatch:=.F.

    Local oXML

    DEFAULT cVersion:="1.2"

    BEGIN SEQUENCE

        BEGIN SEQUENCE

            IF ("1.1"$cVersion)

                cXml+='<?xml version="1.0" encoding="utf-8"?>'+__cCRLF
                cXml+='<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+__cCRLF
                cXml+='<soap:Body>'+__cCRLF
                cXml+='<Validate xmlns="http://www.ezzylearning.com/services/RegularExpressionValidationService.asmx">'+__cCRLF
                cXml+='  <input>'+cInput+'</input>'+__cCRLF
                cXml+='  <pattern>'+cPattern+'</pattern>'+__cCRLF
                cXml+='</Validate>'+__cCRLF
                cXml+='</soap:Body>'+__cCRLF
                cXml+='</soap:Envelope>'+__cCRLF
                
                cRequest+='POST /services/RegularExpressionValidationService.asmx HTTP/1.1'+__cCRLF
                cRequest+='Host:www.ezzylearning.com'+__cCRLF
                cRequest+='Content-Type:text/xml; charset=utf-8'+__cCRLF
                cRequest+='Content-Length:'+ AllTrim(Str(Len(cXml)))+__cCRLF
                cRequest+='SOAPAction:"http://www.ezzylearning.com/services/RegularExpressionValidationService.asmx/Validate"'+__cCRLF
                cRequest+=__cCRLF 
                cRequest+=cXml
            
                BREAK
            
            EndIF
    
            cXml+='<?xml version="1.0" encoding="utf-8"?>'+__cCRLF
            cXml+='<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">'+__cCRLF
            cXml+='  <soap12:Body>'+__cCRLF
            cXml+='    <Validate xmlns="http://www.ezzylearning.com/services/RegularExpressionValidationService.asmx">'+__cCRLF
            cXml+='          <input>'+cInput+'</input>'+__cCRLF
            cXml+='          <pattern>'+cPattern+'</pattern>'+__cCRLF
            cXml+='    </Validate>'+__cCRLF
            cXml+='  </soap12:Body>'+__cCRLF
            cXml+='</soap12:Envelope>'+__cCRLF
    
            cRequest+='POST /services/RegularExpressionValidationService.asmx HTTP/1.1'+__cCRLF
            cRequest+='Host:www.ezzylearning.com'+__cCRLF
            cRequest+='Content-Type:application/soap+xml; charset=utf-8'+__cCRLF
            cRequest+='Content-Length:'+ AllTrim(Str(Len(cXml)))+__cCRLF
            cRequest+=__cCRLF
            cRequest+=cXml
    
        END SEQUENCE

        cXMLResult:=SocketRequest(80,"www.ezzylearning.com",cRequest)

        IF Empty(cXMLResult)
            BREAK
        EndIF

        IF !("<?xml"$cXMLResult)
            BREAK
        EndIF

        oXML:=XmlParser(SubStr(cXMLResult,AT("<?xml",cXMLResult )),"_",@cError,@cWarning)
        IF !(ValType(oXML)=="O")
            BREAK
        EndIF
        
        oXML:=XmlGetChild(oXML:_SOAP_ENVELOPE,XmlChildCount(oXML:_SOAP_ENVELOPE))            
        IF !(ValType(oXML)=="O")
            BREAK
        EndIF
        
        oXML:=XmlGetChild(oXML:_VALIDATERESPONSE,XmlChildCount(oXML:_VALIDATERESPONSE))                
        IF !(ValType(oXML)=="O")
            BREAK
        EndIF

        IF !(oXML:RealName=="ValidateResult")
            BREAK
        EndIF
        lMatch:=("true"==oXML:Text)

    END SEQUENCE

Return(lMatch)

/*/
    Funcao:HttpGetRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function HttpGetRegExp(cInput,cPattern)

    Local cError:=""
    Local cRequest:=""
    Local cWarning:=""
    Local cXMLResult:=""
    Local cGetParams:=""

    Local lMatch:=.F.

    Local oXML
    Local oTDecode
    BEGIN SEQUENCE

        oTDecode:=TDecode():New()

        cRequest+='www.ezzylearning.com/services/RegularExpressionValidationService.asmx/Validate?'
        cGetParams+='input='+oTDecode:Encode(cInput)+'&pattern='+oTDecode:Encode(cPattern)
        cRequest+=cGetParams

        cXMLResult:=HTTPGet(cRequest)

        IF Empty(cXMLResult)
            BREAK
        EndIF

        IF !("<?xml"$cXMLResult)
            BREAK
        EndIF

        oXML:=XmlParser(SubStr(cXMLResult,AT("<?xml",cXMLResult )),"_",@cError,@cWarning)

        IF !(ValType(oXML)=="O")
            BREAK
        EndIF   
        
        lMatch:=(oXML:_BOOLEAN:Text=="true")

    END SEQUENCE
    
Return(lMatch)

/*/
    Funcao:HttpPostRegExp
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function HttpPostRegExp(cInput,cPattern)

    Local cError:=""
    Local cRequest:=""
    Local cWarning:=""
    Local cXMLResult:=""
    Local cPostParams:=""

    Local lMatch:=.F.

    Local oXML
    Local oTDecode

    BEGIN SEQUENCE
    
        oTDecode:=TDecode():New()

        cRequest +='www.ezzylearning.com/services/RegularExpressionValidationService.asmx/Validate?'
        cPostParams +='input='+oTDecode:Encode(cInput)+'&pattern='+oTDecode:Encode(cPattern)

        cXMLResult:=HTTPPost(cRequest,NIL,cPostParams)

        IF Empty(cXMLResult)
            BREAK
        EndIF
    
        IF !("<?xml"$cXMLResult)
            BREAK
        EndIF

        oXML:=XmlParser(SubStr(cXMLResult,AT("<?xml",cXMLResult )),"_",@cError,@cWarning)

        IF !(ValType(oXML)=="O")
            BREAK
        EndIF   
        
        lMatch:=(oXML:_BOOLEAN:Text=="true")

    END SEQUENCE
    
Return(lMatch)

/*/
    Funcao:SocketRequest
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp
/*/
Static Function SocketRequest(nPort,cHost,ctSocketSend)

    Local ctSocketReceive:=""

    Local nAttempts
    Local ntSocketSend
    Local ntSocketReceive
    Local ntSocketConnected

    Local otSocketC:=tSocketClient():New()

    BEGIN SEQUENCE

        DEFAULT nPort:=80

        nAttempts:=0
        ntSocketConnected:=otSocketC:Connect(nPort,cHost,MSECONDS_WAIT)
        While !(otSocketC:IsConnected()) //ntSocketConnected==0 OK
            Sleep(MSECONDS_WAIT/(MSECONDS_WAIT/2)) 
            ntSocketConnected:=otSocketC:Connect(nPort,cHost,MSECONDS_WAIT)
            IF (++nAttempts > N_ATTEMPTS)
                BREAK
            EndIF
        End While

        nAttempts:=0
        ntSocketSend:=otSocketC:Send(ctSocketSend)
        While !(ntSocketSend==Len(ctSocketSend))
            Sleep(MSECONDS_WAIT/(MSECONDS_WAIT/2)) 
            ntSocketSend:=otSocketC:Send(ctSocketSend)
            IF (++nAttempts > N_ATTEMPTS)
                BREAK
            EndIF
        End While

        Sleep(MSECONDS_WAIT/(MSECONDS_WAIT/2)) 

        nAttempts:=0
        ntSocketReceive:=otSocketC:Receive(@ctSocketReceive,MSECONDS_WAIT)
        While ((ntSocketReceive==0) .or. !("<?xml"$ctSocketReceive))
            Sleep(MSECONDS_WAIT/(MSECONDS_WAIT/2)) 
            ntSocketReceive:=otSocketC:Receive(@ctSocketReceive,MSECONDS_WAIT)
            IF (++nAttempts > N_ATTEMPTS)
                BREAK
            EndIF
        End While

    END SEQUENCE

    otSocketC:CloseConnection()
    otSocketC:=FreeObj(otSocketC)

Return(ctSocketReceive)

/*/
    Funcao:PSRegEx
    Autor:Marinaldo de Jesus (www.blacktdn.com.br)
    Data:03/04/2012
    Uso:Exemplo de Uso de RegExp via PowerShell
/*/
Static Function PSRegEx(cString,cPattern)

    Local cMatch:=""
    Local cPSScript:=""
    Local cPSOutPath:=GetTempPath()
    Local cPSOutFile:=CriaTrab(NIL,.F.)
    Local cPSOutPathFile:=(cPSOutPath+cPSOutFile+".ini")
    Local cPSFileScript:=cPSOutFile
    Local cPSScriptPathFile:=(cPSOutPath+cPSFileScript+".ps1")

    Local oTFIni

    Local lMatch:=.F.

    BEGIN SEQUENCE

        While File(cPSOutPathFile) .or. File(cPSScriptPathFile)
            cPSOutFile:=CriaTrab(NIL,.F.)
            cPSOutPathFile:=(cPSOutPath+cPSOutFile+".ini")
            cPSFileScript:=cPSOutFile
            cPSScriptPathFile:=(cPSOutPath+cPSFileScript+".ps1")
        End While

        cPSScript+='"'
        cPSScript+='[PS_REGEX]'
        cPSScript+='`r`n'
        cPSScript+='match='
        cPSScript+='"'
        cPSScript+='+'
        cPSScript+='([regex]::ismatch("'+cString+'","'+cPattern+'")).ToString()'
        cPSScript+=' | '
        cPSScript+='Out-File -Encoding "ASCII" "'+cPSOutPathFile+'"'

        MemoWrite(cPSScriptPathFile,cPSScript)

        IF !File(cPSScriptPathFile)
            BREAK
        EndIF

        WaitRun("POWERSHELL "+cPSScriptPathFile )
        
        IF !File(cPSOutPathFile)
            BREAK
        EndIF

        oTFIni:=TFINI():New(cPSOutPathFile)
        cMatch:=oTFIni:GetPropertyValue("PS_REGEX","match")
        DEFAULT cMatch:="FALSE"
        cMatch:=Upper(cMatch)
        lMatch:=(cMatch=="TRUE")
        oTFIni:=FreeObj(oTFIni)

    END SEQUENCE

    IF File(cPSScriptPathFile)
        fErase(cPSScriptPathFile)
    EndIF

    IF File(cPSOutPathFile)
        fErase(cPSOutPathFile)
    EndIF

Return(lMatch)
