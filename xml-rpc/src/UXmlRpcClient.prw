#include 'protheus.ch'
#DEFINE CRLF  Chr(13)+Chr(10)

CLASS UXmlRpcDateTime
	DATA dDate
	DATA cTime
	METHOD New(dDate,cTime) CONSTRUCTOR
ENDCLASS

METHOD New(dDate,cTime) CLASS UXmlRpcDateTime
Default dDate := Date()
Default cTime := Time()
	::dDate := dDate
	::cTime := cTime
Return

CLASS UXmlRpcStruct
	DATA aData AS Array
	METHOD New() CONSTRUCTOR
	METHOD SetMember(cName,xValue)
	METHOD DelMember(cName)
	METHOD GetValue(cName)
	METHOD Clear()
	METHOD GetLen()
ENDCLASS

METHOD New() CLASS UXmlRpcStruct
	::aData := {}
Return

METHOD SetMember(cName,xValue) CLASS UXmlRpcStruct
Local nPos := 0
	If ValType(cName) <> "C"
		Return .F.
	EndIf
	If (nPos := AScan(::aData,{ |x| x[1] == cName})) > 0
		::aData[nPos][2] := xValue
	Else
		AAdd(::aData,{cName,xValue})
	EndIf
Return .T.

METHOD DelMember(cName,cTime) CLASS UXmlRpcStruct
Local nPos   := 0
Local xValue := Nil
	If ValType(cName) <> "C"
		Return xValue
	EndIf
	If (nPos := AScan(::aData,{ |x| x[1] == cName})) > 0
		xValue := ::aData[nPos][2]
		ADel(::aData,nPos)
		ASize(::aData,Len(::aData)-1)
	EndIf
Return xValue

METHOD GetValue(cName) CLASS UXmlRpcStruct
Local nPos   := 0
Local xValue := Nil
	If ValType(cName) <> "C"
		Return xValue
	EndIf
	If (nPos := AScan(::aData,{ |x| x[1] == cName})) > 0
		xValue := ::aData[nPos][2]
	EndIf
Return xValue

METHOD GetLen() CLASS UXmlRpcStruct
Return Len(::aData)

METHOD Clear() CLASS UXmlRpcStruct
	ASize(::aData,0)
Return

CLASS UXmlRpcClient FROM LongCLASSName

	DATA cServer AS Character
	DATA nPort AS Numeric
	DATA nTimeOut AS Numeric
	DATA cMethod AS Character
	DATA cError AS Character
	DATA lError AS Logic
	METHOD New(cServer,nPort,nTimeOut) CONSTRUCTOR
	METHOD getServer()
	METHOD setServer(cServer)
	METHOD getPort()
	METHOD setPort(nPort)
	METHOD getMethod()
	METHOD setMethod(cMethod)
	METHOD getTimeOut()
	METHOD setTimeOut(nTimeOut)
	METHOD HeaderGenerate()
	METHOD SocketConn()
	METHOD ProcessResponse(cResponse)
	METHOD AddNodeReturn(oXML,aReturn,oStruct,lMember)
	METHOD AddNodeParam(oXML,aParams,lParam,lArray,lStruct)
	METHOD Execute(cMethod,aParams)
	METHOD HasError()
	METHOD GetError()
ENDCLASS

METHOD New(cServer, nPort, nTimeOut) CLASS UXmlRpcClient
Default cServer  := "localhost"
Default nPort    := 80
Default nTimeOut := 5 //5 Segundos
	::cServer  := cServer
	::nPort    := nPort
	::cMethod  := "system.listMethods"
	::nTimeOut := nTimeOut
	::lError   := .F.
	::cError   := ""
Return

METHOD getServer() CLASS UXmlRpcClient
Return ::cServer

METHOD setServer(cServer) CLASS UXmlRpcClient
	::cServer := cServer
Return

METHOD getPort() CLASS UXmlRpcClient
Return ::nPort

METHOD setPort(nPort) CLASS UXmlRpcClient
	::nPort := nPort
Return

METHOD getMethod() CLASS UXmlRpcClient
Return ::cMethod

METHOD setMethod(cMethod) CLASS UXmlRpcClient
	::cMethod := cMethod
Return

METHOD getTimeOut() CLASS UXmlRpcClient
Return ::TimeOut

METHOD setTimeOut(nTimeOut) CLASS UXmlRpcClient
	::nTimeOut := nTimeOut
Return

METHOD GetError() CLASS UXmlRpcClient
Return ::cError

METHOD HasError() CLASS UXmlRpcClient
Return ::lError

METHOD HeaderGenerate(nLenBody) CLASS UXmlRpcClient
Local cHeader := ""
	cHeader := "POST /RPC2 HTTP/1.1"+CRLF
	cHeader += "User-Agent: XML-RPC Protheus Client"+CRLF
	cHeader += "Host: "+AllTrim(::cServer)+Iif(::nPort == 80,"",":"+AllTrim(Str(::nPort)))+CRLF
	cHeader += "Content-Type: text/xml"+CRLF
	cHeader += "Content-length: "+AllTrim(Str(nLenBody))+CRLF+CRLF
Return cHeader

METHOD Execute(cMethod,aParams) CLASS UXmlRpcClient
Local cHeader   := ""
Local cBodySend := ""
Local cHttpPost := ""
Local cResponse := ""
Local aResponse := {}
Local oXML      := Nil
/*
<?xml version="1.0"?>
<methodCall>
  <methodName>examples.callMethod</methodName>
  <params>
	 <param>
		  <value><string>String</string></value>
		  <value><int>41</int></value>
		  <value><i4>41</i4></value>
	 </param>
  </params>
</methodCall>
*/
	::lError := .F.
	::cError := ""
	If ValType(cMethod) == "C" .And. !Empty(cMethod)
		::cMethod := cMethod
	EndIf
	//Somente aceita parametros no formato de array
	If aParams <> Nil .And. ValType(aParams) <> "A"
		::lError := .T.
		::cError := "Os parametros devem ser no formato array."
		conout("[XML-RPC ERROR] Os parametros devem ser no formato array.")
		Return aResponse
	EndIf
	//Monta a requisição HTTP
	cBodySend := '<?xml version="1.0"?>'+CRLF
	cBodySend += "<methodCall>"+CRLF
	cBodySend += "   <methodName>"+AllTRim(::cMethod)+"</methodName>"+CRLF
	If aParams <> Nil .And. !Empty(aParams)
		cBodySend += "   <params></params>"+CRLF
	EndIf
	cBodySend += "</methodCall>"+CRLF
	If aParams <> Nil .And. !Empty(aParams)
		//Gera um XML com os parametros
		oXML := TXMLManager():New()
		oXML:Parse(cBodySend)
		oXML:DOMChildNode() //methodName
		oXML:DOMNextNode() //params
		//Transforma os arrays em parâmetros
		::AddNodeParam(oXML,aParams,.T.,.F.)
		//Transforma o XML em texto puro para ser enviado ao servidor
		cBodySend := oXML:Save2String()
	EndIf
	cHeader := ::HeaderGenerate(Len(cBodySend))
Return ::SocketConn(cHeader + cBodySend)

METHOD SocketConn(cHttpPost) CLASS UXmlRpcClient
Local cResponse  := ""
Local aResponse  := {}
Local oSocketCli := TSocketClient():New()
Local nLenSend   := 0
Local nLenRecv   := 0
Local cError     := ""

	//Envia a requisição ao servidor XML-RPC
	oSocketCli:Connect(::nPort,::cServer,::nTimeOut*1000)
	If !oSocketCli:IsConnected()
		::lError := .T.
		::cError := "Não foi possível conectar ao servidor."+CRLF
		//::cError += oSocketCli:GetError()
		Return aResponse
	EndIf
	nLenSend := oSocketCli:Send( cHttpPost )
	//Se a mensagem foi totalmente enviada
	If ( nLenSend == Len( cHttpPost ) )
		//Tentamos Obter a Resposta aguardando por n milisegundos
		nLenRecv := oSocketCli:Receive( @cResponse , ::nTimeOut*1000)
		//Processa resposta do servidor XML-RPC
		If ( nLenRecv > 0 )
			aResponse := ::ProcessResponse(cResponse)
		Else
			::lError := .T.
			::cError := "Não foi possível receber a resposta do servidor."+CRLF
			//oSocketCli:GetError(@cError)
			//::cError += oSocketCli:GetError()
		EndIf
	Else
		::lError := .T.
		::cError := "Não foi possível enviar todos os dados ao servidor."+CRLF
		//::cError += oSocketCli:GetError()
	EndIf
	oSocketCli:CloseConnection()
	FreeObj(oSocketCli)
Return aResponse

METHOD AddNodeParam(oXML,aParams,lParam,lArray,lStruct) CLASS UXmlRpcClient
Local cClassName := ""
Local aDataAttrs := {}
Local cValue     := ""
Local nX         := 0
Default lParam   := .T.
Default lArray   := .F.
Default lStruct  := .F.

	For nX := 1 To Len(aParams)
		If lParam
			oXML:DOMNewChildNode("param","")
			oXML:DOMChildNode() //param
			While oXML:DOMNextNode()
			EndDo
		EndIf
		If lStruct
			oXML:DOMNewChildNode("member","")
		Else
			oXML:DOMNewChildNode("value","")
		EndIf
		oXML:DOMChildNode() //member/value
		//Posiciona sempre no último filho
		While oXML:DOMNextNode()
		EndDo
		If Empty(aParams[nX])
			oXML:DOMNewChildNode("nil","")
		ElseIf ValType(aParams[nX]) == "A" //Array
			If lStruct .And. Len(aParams[nX]) >= 2 //http://tdn.totvs.com/display/tec/ClassDataArr
				oXML:DOMNewChildNode("name",aParams[nX][1])
				::AddNodeParam(oXML,{aParams[nX][2]},.F.)
			Else
				oXML:DOMNewChildNode("array","")
				oXML:DOMChildNode() //array
				oXML:DOMNewChildNode("data","")
				oXML:DOMChildNode() //data
				::AddNodeParam(oXML,aParams[nX],.F.,.T.) //É um sub-array, não um parametro novo
				oXML:DOMParentNode() //array
			EndIf
		ElseIf ValType(aParams[nX]) == "C" //Caracter
			oXML:DOMSetNode("value",aParams[nX])
		ElseIf ValType(aParams[nX]) == "N" //Numérico
			cValue := AllTrim(Str(aParams[nX]))
			If At(".",cValue) > 0
				oXML:DOMNewChildNode("double",cValue)
			Else
				oXML:DOMNewChildNode("int",cValue)
			EndIf
		ElseIf ValType(aParams[nX]) == "L" //Lógico
			oXML:DOMNewChildNode("boolean",Iif(aParams[nX],"1","0"))
		ElseIf ValType(aParams[nX]) == "D" //Data
			cValue := DtoS(aParams[nX])+"T00:00:00"
			oXML:DOMNewChildNode("dateTime.iso8601",cValue)
		ElseIf ValType(aParams[nX]) == "O" //Objeto
			cClassName := GetClassName(aParams[nX])
			If Upper(cClassName) == "UXMLRPCDATETIME"
				cValue := DtoS(aParams[nX]:dDate)+"T"+aParams[nX]:cTime
				oXML:DOMNewChildNode("dateTime.iso8601",cValue)
			ElseIf Upper(cClassName) == "UXMLRPCSTRUCT"
				If aParams[nX]:GetLen() > 0
					oXML:DOMNewChildNode("struct","")
					oXML:DOMChildNode() //struct
					::AddNodeParam(oXML,aParams[nX]:aData,.F.,.F.,.T.)
				EndIf
			Else
				aDataAttrs := ClassDataArr(aParams[nX],.T.)
				If Len(aDataAttrs) > 0
					oXML:DOMNewChildNode("struct","")
					oXML:DOMChildNode() //struct
					::AddNodeParam(oXML,aDataAttrs,.F.,.F.,.T.)
				EndIf
			EndIf
		EndIf
		If !lStruct
			oXML:DOMParentNode()
		EndIf
		If lParam
			oXML:DOMParentNode()
		EndIf
	Next
Return oXML:DOMParentNode()

METHOD ProcessResponse(cResponse) CLASS UXmlRpcClient
Local aResponse := {}
Local nPosFind  := 0
Local cStatHttp := ""
Local cContLen  := ""
Local cBodyRecv := ""
Local nLenBody  := 0
Local oXML      := Nil
Local oNode     := Nil
/*
<?xml version="1.0"?>
<methodResponse>
  <params>
	 <param>
		  <value><string>South Dakota</string></value>
	 </param>
  </params>
</methodResponse>
*/
	nPosFind := At(CRLF, cResponse)
	If nPosFind > 0
		cStatHttp := SubStr(cResponse,1,nPosFind)
		cResponse := SubStr(cResponse,nPosFind)
	Else
		::lError := .T.
		::cError := "Não foi possível identificar o status da requisição HTTP na resposta do servidor."
		Return aResponse
	EndIf
	//Procura o Status da resposta
	If At("200 OK", cStatHttp) <= 0
		::lError := .T.
		::cError := "HTTP Status Code: "+AllTrim(SubStr(cStatHttp,8)) //HTTP/1.1
		Return aResponse
	EndIf
	//Procura o tamanho do corpo da resposta
	If (nPosFind := At("Content-length",cResponse)) > 0
		cResponse := SubStr(cResponse,nPosFind+15)
		nPosFind  := At(CRLF, cResponse)
		cContLen  := SubStr(cResponse,1,nPosFind)
		nLenBody  := Val(AllTrim(cContLen))
	Else
		::lError := .T.
		::cError := "Não foi possível determinar o Content-length na resposta do servidor."
		Return aResponse
	EndIf
	//Procura o corpo da resposta
	If (nPosFind := At(CRLF+CRLF,cResponse)) > 0 .And. nLenBody > 0
		cBodyRecv := SubStr(cResponse,nPosFind+4,nLenBody)
	Else
		::lError := .T.
		::cError := "Não foi possível determinar o início do corpo na resposta do servidor."
		Return aResponse
	EndIf
	//Efetua o tratamento da resposta
	oXML := TXMLManager():New()
	If !oXML:Parse(cBodyRecv)
		::lError := .T.
		::cError := "Ocorreu um erro ao interpretar a resposta do servidor."+CRLF
		::cError += oXML:LastError()
		Return aResponse
	EndIf

	If oXML:cName == "methodResponse" .And. oXML:DOMChildNode()
		If oXML:cName == "params" .And. oXML:DOMChildNode()
			::AddNodeReturn(oXML,aResponse)
		ElseIf oXML:cName == "fault" .And. oXML:DOMChildNode()
			::lError := .T.
			::AddNodeReturn(oXML,aResponse)
			If Len(aResponse) > 0 .And. ValType(aResponse[1]) == "O"
				cResponse := aResponse[1]:GetValue("faultString")
				If cResponse <> Nil .And. ValType(cResponse) == "C"
					::cError := "Ocorreu um erro na execução do método no servidor."+CRLF
					::cError += cResponse
				Else
					::cError := "Ocorreu um erro indeterminado na execução do método no servidor."
				EndIf
			Else
				::cError := "Ocorreu um erro indeterminado na execução do método no servidor."
			EndIf
			aResponse := {}
		EndIf
	EndIf
Return aResponse

//Processa os resultados de acordo com o formato
//http://en.wikipedia.org/wiki/XML-RPC
/*
<?xml version="1.0"?>
<methodResponse>
	<params>
		<param>
			<value>
				<array>
					<data>
						<value>label.GetLabels</value>
						<value>label.PrinterByDatabase</value>
						<value>label.PrinterByParams</value>
						<value>label.PrinterNoData</value>
						<value>model.GetModels</value>
						<value>system.listMethods</value>
						<value>system.methodHelp</value>
						<value>type.GetTypes</value>
						<value>system.multicall</value>
					</data>
				</array>
			</value>
		</param>
	</params>
</methodResponse>
*/
METHOD AddNodeReturn(oXML,aReturn,oStruct,lMember)  CLASS UXmlRpcClient
Local cName   := ""
Local aSubRet := {}
Local nPosT   := 0
Default oStruct := Nil
Default lMember := .F.

	If oXML:cName == "param" .And. oXML:DOMChildNode()
		::AddNodeReturn(oXML,aReturn)
	ElseIf oXML:cName == "array" .And. oXML:DOMChildNode()
		::AddNodeReturn(oXML,aReturn)
	ElseIf oXML:cName == "data" .And. oXML:DOMChildNode()
		aSubRet := {}
		AAdd(aReturn,aSubRet)
		::AddNodeReturn(oXML,aSubRet)
	ElseIf oXML:cName == "struct" .And. oXML:DOMChildNode()
		oStruct := UXmlRpcStruct():New()
		AAdd(aReturn,oStruct)
		::AddNodeReturn(oXML,aReturn,oStruct)
	ElseIf oXML:cName == "member" .And. oXML:DOMChildNode()
		While .T.
			::AddNodeReturn(oXML,aReturn,oStruct,.T.)
			If !oXML:DOMNextNode()
				Exit
			EndIf
		EndDo
	ElseIf oXML:cName == "name"
		cName := oXML:cText
		If oXML:DOMNextNode()
			aSubRet := {cName}
			::AddNodeReturn(oXML,aSubRet)
			If Len(aSubRet) >= 2
				oStruct:SetMember(aSubRet[1],aSubRet[2])
			EndIf
		EndIf
	ElseIf oXML:cName == "value"
		While .T.
			If oXML:DOMChildNode()
				::AddNodeReturn(oXML,aReturn)
			ElseIf ValType(oXML:cText) == "C"
				AAdd(aReturn,oXML:cText)
			EndIf
			If !oXML:DOMNextNode()
				Exit
			EndIf
		EndDo
	ElseIf oXML:cName == "boolean"
		AAdd(aReturn,Iif(Val(oXML:cText)<>0,.T.,.F.))
	ElseIf oXML:cName == "int" .Or. oXML:cName == "i4"
		AAdd(aReturn,Val(oXML:cText))
	ElseIf oXML:cName == "double"
		AAdd(aReturn,Val(oXML:cText))
	ElseIf oXML:cName == "dateTime.iso8601"
		nPosT := At("T",oXML:cText)
		AAdd(aReturn,UXmlRpcDateTime():New(StoD(SubStr(oXML:cText,1,nPosT)),SubStr(oXML:cText,nPosT+1)))
	ElseIf ValType(oXML:cText) == "C"
		AAdd(aReturn,oXML:cText)
	EndIf
	If !lMember
		oXML:DOMParentNode()
	EndIf
Return .T.
