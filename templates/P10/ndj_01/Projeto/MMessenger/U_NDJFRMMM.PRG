#INCLUDE "NDJ.CH"
/*/
	A Base para esse programa eh o MATXFUNC. Funcao: MEnviaMail()
	Usados em: MATA045.PRX
/*/
/*/
	Funcao:		MMSetText()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Setar o Texto Para a Formatacao no Formato NDJ
/*/
Static Function MMSetText( cText )
	Local cLastText
    StaticCall( NDJLIB004 , SetPublic , "_cNDJMMMsg" , "" )
	DEFAULT cText	:= ""
    cLastText        := _cNDJMMMsg
    _cNDJMMMsg        := cText
Return( cLastText )

/*/
	Funcao:		MMGetText()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Obter o Texto Para a Formatacao no Formato NDJ
/*/
Static Function MMGetText()
	Local cText := ""
    IF ( Type( "_cNDJMMMsg" ) == "C" )
        cText := _cNDJMMMsg
	EndIF
	DEFAULT cText := ""
Return( cText )

/*/
	Funcao:		MMFrmMail()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Formatar os e-mails emitidos pelo MMessenger com as características da NDJ
/*/
Static Function MMFrmMail( cMMText 	)

	Local cHtml		:= ""
	
	DEFAULT cMMText	:= MMGetText()

	cHtml += '<html>' + CRLF
	cHtml += '	<head>' + CRLF
    cHtml += '    <title>NDJ MMessenger mail</title>' + CRLF
	cHtml += '	<body>' + CRLF
	cHtml += '		<table cellpadding="0" cellspacing="0" border="0" width="100%" border="0">' + CRLF
	cHtml += '			<tr>' + CRLF
    cHtml += '                <td> <img src="' + GetNewPar("NDJ_MMFURL " , "" ) + '" border="0"></td>' + CRLF
	cHtml += '			</tr>' + CRLF
	cHtml += '			<tr>' + CRLF
	cHtml += '				<td>' + CRLF
	cHtml += '					<font face="arial" size="2">' + CRLF
	cHtml += '					' + cMMText
	cHtml += '					</font>' + CRLF
	cHtml += '				</td>' + CRLF
	cHtml += '			</tr>' + CRLF
	cHtml += '			<tr bgcolor="#BEBEBE">' + CRLF
	cHtml += '				<td>' + CRLF
	cHtml += '					.' + CRLF
	cHtml += '				</td>' + CRLF
	cHtml += '			</tr>' + CRLF
	cHtml += '		</table>' + CRLF
	cHtml += '	</body>' + CRLF
	cHtml += '</html>' + CRLF

Return( cHtml )

/*/
	Funcao:		MMENS000()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS000()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS001()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS001()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS002()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS002()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS003()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS003()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS004()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS004()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS005()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS005()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS006()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS006()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS007()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS007()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS008()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS008()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS009()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS009()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS010()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS010()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS011()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS011()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS012()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS012()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS013()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS013()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS014()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS014()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS015()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS015()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS016()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS016()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS017()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS017()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS018()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS018()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS019()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS019()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS020()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS020()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS021()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS021()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS022()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS022()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS023()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS023()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS024()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS024()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS025()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS025()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS026()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS026()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS027()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS027()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS028()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS028()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS029()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS029()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS030()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS030()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS031()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS031()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS032()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS032()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS033()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS033()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS034()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS034()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS035()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS035()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS036()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS036()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS037()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS037()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS038()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS038()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS039()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS039()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS040()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS040()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS041()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS041()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS042()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS042()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS043()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS043()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS044()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS044()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS045()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS045()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS046()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS046()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS047()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS047()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS048()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS048()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS049()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS049()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS050()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS050()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS051()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS051()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS052()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS052()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS053()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS053()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS054()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS054()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS055()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS055()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS056()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS056()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS057()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS057()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS058()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS058()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS059()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS059()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS060()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS060()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS061()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS061()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS062()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS062()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS063()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS063()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS064()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS064()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS065()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS065()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS066()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS066()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS067()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS067()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS068()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS068()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS069()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS069()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS070()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS070()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )                                 

/*/
	Funcao:		MMENS071()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS071()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS072()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS072()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS073()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS073()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS074()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS074()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS075()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS075()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS076()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS076()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS077()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS077()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS078()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS078()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS079()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS079()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS080()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS080()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS081()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS081()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS082()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS082()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS083()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS083()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS084()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS084()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS085()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS085()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS086()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS086()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS087()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS087()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS088()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS088()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )      

/*/
	Funcao:		MMENS089()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS089()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS090()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS090()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS091()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS091()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS092()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS092()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS093()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS093()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS094()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS094()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS095()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS095()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS096()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS096()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS097()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS097()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS098()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS098()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS099()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS099()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS100()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS100()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS101()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS101()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS102()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS102()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS103()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS103()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS104()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS104()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS105()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS105()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS106()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS106()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS107()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS107()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS108()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS108()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS109()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS109()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

/*/
	Funcao:		MMENS110()
	Data:		05/11/2010
	Autor:		Marinaldo de Jesus
    Descricao:    Implementacao do Ponto de Entrada conforme evento do MMessenger Ira setar o Texto a Ser Formatado no Padrao NDJ
/*/
User Function MMENS110()
	Local aDados	:= ParamIxb[1]
	Local cText		:= ParamIxb[2]
	IF ( ValType( aDados )  == "A" )
		//Implementar Algo se Precisar de aDados
	EndIF
	MMSetText( @cText )
Return( cText )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		MMFrmMail()
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )