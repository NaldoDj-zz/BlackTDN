#include "protheus.ch"
#include "rwmake.ch"

CLASS UTesteA FROM LongCLASSName
   DATA cData01
   DATA nData02
   DATA dData03
   METHOD New() CONSTRUCTOR
ENDCLASS

METHOD New() CLASS UTesteA
   ::cData01 := "TesteA-01"
   ::nData02 := 50
   ::dData03 := Date()
Return

CLASS UTesteB FROM LongCLASSName
   DATA cData01
   DATA nData02
   DATA oData03
   METHOD New() CONSTRUCTOR
ENDCLASS

METHOD New() CLASS UTesteB
   ::cData01 := "TesteB-02"
   ::nData02 := 95.23
   ::oData03 := UTesteA():New()
Return

CLASS EtiProduto
   DATA ATRIBUTO01
   DATA ATRIBUTO02
   DATA ATRIBUTO03
   METHOD New(cFamilia,cProduto,cDescricao) CONSTRUCTOR
ENDCLASS 

METHOD New(cFamilia,cProduto,cDescricao) CLASS EtiProduto
Default cFamilia   := ""
Default cProduto   := ""
Default cDescricao := ""
   ::ATRIBUTO01 := cFamilia
   ::ATRIBUTO02 := cProduto
   ::ATRIBUTO03 := cDescricao
Return

User Function My1XmlRpc()
Local oXmlRpc  := UXmlRpcClient():New("localhost",4560)
Local aReturn  := {}
Local aMethods := {}
Local aParams  := {}
Local nX       := 0
Local oStruct := UXmlRpcStruct():New()
Local oEtiPrd := Nil 

   //Listando os metodos disponíveis no serviço de impressão
	oXmlRpc:setMethod("system.listMethods")
	aReturn := oXmlRpc:Execute()
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else
	   VarInfo( "Methods", aReturn )
	EndIf 
	
	//Listando os Helps dos métodos disponíveis no sistema
	If !Empty(aReturn)
   	oXmlRpc:setMethod("system.methodHelp")
   	aMethods := aReturn[1]
   	For nX := 1 To Len(aMethods)
   		aReturn := oXmlRpc:Execute(,{aMethods[nX]})
      	If oXmlRpc:HasError()
      	   conout(oXmlRpc:GetError())
      	Else 
   		   VarInfo( "Help", aReturn )
      	EndIf 
   	Next
   EndIf

	//Montando um array com vários valores para testar a montagem do XML
	oStruct:SetMember("Chave01","Valor01")
	oStruct:SetMember("Chave02","Valor02")
	oStruct:SetMember("Chave03","Valor03")
	
	VarInfo( "Struct", oStruct )
	
	aParams := {;
	            "Param01",;
	            45,;
	            98.34,;
	            .T.,;
	            Date(),;
	            Time(),;
	            {Date(),Time()},;
	            {{"Pos01","Pos02"},{"Pos03","Pos04"}},;
	            UTesteA():New(),;
	            UTesteB():New(),;
	            oStruct;
	           }
	VarInfo( "Params", aParams )

	//Forçando a execução de umátodo que não existe no sistema
	oXmlRpc:setMethod("system.methodError")
	oXmlRpc:Execute(,aParams)
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	EndIf 
	//Recuperando todos os tipos de etiquetas cadastrados
	aReturn := oXmlRpc:Execute("type.GetTypes")
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Types", aReturn )
	EndIf 
	//Recuperando todos os modelos de etiquetas cadastrados para o tipo TIP000001
	aReturn := oXmlRpc:Execute("model.GetModels",{"TIP000001"})
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Models", aReturn )
	EndIf 
	//Recuperando todas as etiquetas cadastradas para o modelo MOD000011
	aReturn := oXmlRpc:Execute("label.GetLabels",{"MOD000011"})
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Labels", aReturn )
	EndIf	
	//Imprimimdo uma etiqueta com o auxilio da classe UXmlRpcStruct
	oStruct:Clear()
	oStruct:SetMember("ATRIBUTO01","Perecível")
	oStruct:SetMember("ATRIBUTO02","7892004567452")
	oStruct:SetMember("ATRIBUTO03","Iogurte Longa Vida")	
	aReturn := oXmlRpc:Execute("label.PrinterByParams",{ "ETQ000101", oStruct } )
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Status", aReturn )
	EndIf	
	//Imprimimdo uma etiqueta com o auxilio de uma classe específica com os atributos
	oEtiPrd := EtiProduto():New("Limpeza","7892004569831","Agua Sanitária")
	aReturn := oXmlRpc:Execute("label.PrinterByParams",{ "ETQ000101", oEtiPrd } )
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Status", aReturn )
	EndIf
   //Imprimindo os dois produtos numa unica chamada
	aReturn := oXmlRpc:Execute("label.PrinterByParams",{ "ETQ000101" , { oStruct, oEtiPrd } })
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())
	Else 
	   VarInfo( "Status", aReturn )
	EndIf
	FreeObj(oEtiPrd)
	FreeObj(oStruct)
	FreeObj(oXmlRpc)
Return


User Function My2XmlRpc()
Local oXmlRpc := UXmlRpcClient():New("localhost",4560)
Local oStruct := UXmlRpcStruct():New()
Local aReturn := {}
	//Imprimimdo uma etiqueta com o auxilio da classe UXmlRpcStruct
	oStruct:SetMember("ATRIBUTO01","Perecível")
	oStruct:SetMember("ATRIBUTO02","7892004567452")
	oStruct:SetMember("ATRIBUTO03","Iogurte Longa Vida")	
	aReturn := oXmlRpc:Execute("label.PrinterByParams",{ "ETQ000101", oStruct } )
	If oXmlRpc:HasError()
	   conout(oXmlRpc:GetError())  //Imprimindo o retorno de erro no console
	Else 
	   VarInfo( "Status", aReturn ) //Imprimindo o retorno no console
	EndIf
	FreeObj(oStruct)
	FreeObj(oXmlRpc)
Return
