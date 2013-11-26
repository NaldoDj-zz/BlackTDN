#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IUSUARIO Autor ³ LAPORTE               º Data ³  28/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA USADO PARA LIBERAR MUDAR A FASE DO   º±±
±±º          ³ PROJETO QUANDO FOR LIBERADO O CENTRO DE CUSTOS             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTT                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 


User Function CTA030TOK()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ESTA FUNÇÃO TEM O OBJETIVO DE LIBERAR O PROJETO PARA EXECUCAO
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
AF8->(DBSETORDER(1))
WCODPROJ = SPACE(10)
WCODPROJ = SUBSTR(CTT->CTT_CUSTO,4,10) 
IF AF8->(DBSEEK(XFILIAL("AF8")+WCODPROJ)) 
   IF AF8->AF8_FASE = "01"
      msgbox("A fase do Projeto foi alterada para 03 - Execução", "ATENÇÃO","INFO")
      RecLock("AF8",.F.)
      AF8->AF8_FASE := "03"            
      MSUNLOCK() 
   ENDIF 
   EmailLib() 
ENDIF             

Return

//************************************************************************************************
Static Function EmailLib()
//************************************************************************************************

Local cBody         := ""
Local cCC           := ""
Local cMailServer	:= Alltrim(GETMV("MV_RELSERV"))
Local cMailConta	:= Alltrim(GETMV("MV_RELACNT"))
Local cMailSenha	:= Alltrim(GETMV("MV_RELPSW"))

Local lEmail



SZF->(DBSETORDER(1))
SZF->(DBSEEK(XFILIAL("SZF")+SUBSTR(CTT->CTT_CUSTO,1,3)))  
cDest1   := StaticCall( NDJLIB014 , UsrRetMail , AF8->AF8_XCODGE )
cCc      := GetNewPar("NDJ_EFIN","ndjadvpl@gmail.com")

cSubject := "LIBERACAO DE CENTRO DE CUSTOS - PROJETO "+AF8->AF8_PROJET+"-"+AF8->AF8_DESCRI

cBody :='<html>'
cBody +=	'<head>'
cBody +=		'<meta http-equiv="Content-Type" content="text/html charset=ISO-8859-1">'
cBody +=	'</head>'
cBody +='<body>'
cBody +=	'<div marginheight="0" marginwidth="0">'
cBody +=	'<table border="0" cellpadding="0" cellspacing="0">'
cBody +=		'<tbody>'
cBody +=            '<tr bgcolor="#eeeeee"><td> <img src="' + GetNewPar("NDJ_ELGURL " , "" ) + '" border="0"></td></tr>'
cBody +=			'<tr bgcolor="#bebebe"><td height="20"></td></tr>'
cBody +=			'<tr><td><font face="arial" size="2"><b>LIBERAÇÃO DE CENTRO DE CUSTOS</b><p></font></td></tr>'
cBody +=			'<tr><td><p><font face="arial" size="2">Caro Gerente - '+ALLTRIM(AF8->AF8_XGER)+',</p>'
cBody +=					'<p>O centro de custo '+CTT->CTT_CUSTO+' foi criado pela Gerência Finaceira, sendo assim, '
cBody +=					'o seu projeto está pronto para ser executado conforme informação abaixo.</p></font>' 
cBody +=			'<p><font face="arial" size="2">Seguem as informações do Projeto:</font></p></td></tr>'
cBody +=	'<tr><td><p></p></td></tr></table>'
cBody +=	'<table border="0" cellpadding="0" cellspacing="0">'		
cBody +=		'<tr><font face="arial" size="2"><td>Projeto:</td><td>'+AF8->AF8_PROJET+'</td></font></tr>'
cBody +=		'<tr><font face="arial" size="2"><td>Descrição:</td><td>'+AF8->AF8_DESCRI+'</td></font></tr>'
cBody +=		'<tr><font face="arial" size="2"><td>Origem do Recurso:</td><td>'+SUBSTR(CTT->CTT_CUSTO,1,3)+'</td></font></tr>'
cBody +=		'<tr><font face="arial" size="2"><td>Descrição da O.R.:</td><td>'+SZF->ZF_XDESORI+'</td></font></tr>'
cBody +=		'<tr><font face="arial" size="2"><td>Gerente:</td><td>'+AF8->AF8_XGER+'</td></font></tr>'
cBody +=	'</table>'  

Connect SMTP Server cMailServer Account cMailConta Password cMailSenha RESULT lEmail
		
If !lEmail
	Alert("Erro ao conectar no servidor SMTP")
Endif
		
If !lEmail
	Alert("Erro ao autenticar no servidor SMTP")
Endif
		

SEND MAIL FROM cMailConta TO cDest1	;
CC cCc ;
SUBJECT cSubject ;
BODY cBody
Get Mail Error cErro
		
DISCONNECT SMTP SERVER
		
RETURN

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
    	lRecursa	:= __Dummy( .F. )
    	__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )