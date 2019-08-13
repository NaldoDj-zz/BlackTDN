#include "ndj.ch"
#DEFINE MAIL_TIME_OUT    60
/*/
    Funcao:        SendMail
    Autor:        Marinaldo de Jesus
    Data:        25/11/2010
    Descricao:    Envio de e-mail
    Sintaxe:    <Vide Parametros Formais>
/*/
Static Function SendMail(;
                            cSubject,;  //01->Assunto
                            cBody,;     //02->Corpo do e-mail
                            aTo,;       //03->Array com e-mail dos Destinatarios
                            aCc,;       //04->Array com e-mail dos Destinatarios a Serem Copiados
                            aBCc,;      //05->Array com e-mail dos Destinatorios a Serem Copiados "Ocultamente"
                            aFiles,;    //06->Array com os arquivos anexos
                            lText,;     //07->lText Format
                            cServer,;   //08->Servidor a ser utilizado para envio
                            cUser,;     //09->Conta a ser utilizada para envio
                            cPassWord,; //10->Senha a ser utilizada para envio
                            cFrom,;     //11->Email a ser utilizado para envio
                            lAuth,;     //12->Servidor Requer Autenticacao
                            cUserAuth,; //13->Usuario para Autenticacao
                            cPassAuth,; //14->Senha para Autenticacao
                            nTimeOut,;  //15->TimeOut
                            nAttempts;  //16->Numero de Tentativas
                    )

    /*/
        MailAuth(cUser,cPassword)
        MailGetErr(<void>)->cErr
        MailGetNumErr(<void>)->nNumErr
        MailFormatText(lTextPlain)
        MailSmtpOn(cSmtp,cUser,cPassword,nTimeOut)->lSmtpOk
            MailSend(cFrom,aTo,aCc,aBcc,cSubject,cBody,aFiles,lText)->lSendOk
        MailSmtpOf(<void>)
    /*/
    
    Local cException
    
    Local lSendOk:=.T.
    
    Local nItried
    
    TRYEXCEPTION
    
        DEFAULT cServer:=SuperGetMv("MV_RELSERV")
        IF !(lSendOk:=!Empty(cServer))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"][MV_RELSERV invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT cUser:=SuperGetMv("MV_RELACNT")
        IF !(lSendOk:=!Empty(cUser))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"][MV_RELACNT invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT cPassWord:=SuperGetMv("MV_RELPSW")
        IF !(lSendOk:=!Empty(cPassWord))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MV_RELPSW invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT cFrom:=SuperGetMv("MV_RELFROM")
        IF Empty(cFrom)                
            cFrom:=cUser
        EndIF
    
        DEFAULT nTimeOut:=MAIL_TIME_OUT
        DEFAULT nAttempts:=5
    
        DEFAULT lAuth:=SuperGetMv("MV_RELAUTH")
        DEFAULT cUserAuth:=SuperGetMv("MV_RELAUSR")
        DEFAULT cPassAuth:=SuperGetMv("MV_RELAPSW")
    
        nItried:=0
        While !(lSendOk:=MailSmtpOn(cServer,cUser,cPassWord,nTimeOut))
            IF ((++nItried) > nAttempts)
                cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailSmtpOn][Impossivel conectar-se ao Smtp]"
                cException+=CRLF
                cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
                cException+=CRLF
                cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
                cException+=CRLF
                ConOut(cException)
                UserException(cException)
            EndIF    
            Sleep(100)
        End While
    
        IF (lAuth)
            nItried:=0
            While !(lSendOk:=MailAuth(cUserAuth,cPassAuth))
                IF ((++nItried) > nAttempts)
                    cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailAuth][Impossivel autenticar-se]"
                    cException+=CRLF
                    cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
                    cException+=CRLF
                    cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
                    cException+=CRLF
                    ConOut(cException)
                    UserException(cException)
                EndIF    
                Sleep(100)
            End While
        EndIF
    
        DEFAULT aTo:={}
        DEFAULT aCc:={}
        DEFAULT aBCc:={}
        DEFAULT cBody:=""
        DEFAULT aFiles:={}
        DEFAULT lText:=.F.

        aEval(aClone(aTo),{|cMail|aTo:=AddMailDest(aTo,@cMail)})
        aEval(aClone(aCc),{|cMail|aCc:=AddMailDest(aCc,@cMail)})
        aEval(aClone(aBCc),{|cMail|aBCc:=AddMailDest(aBCc,@cMail)})

        IF !(lSendOk:=MailSend(cFrom,aTo,aCc,aBCc,cSubject,cBody,aFiles,lText))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailSend][Impossivel enviar o e-mail]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
            cException+=CRLF
            ConOut(cException)
            UserException(cException)
        EndIF

        MailSmtpOff()

    CATCHEXCEPTION

        MailSmtpOff()

        lSendOk:=.F.

        ConOut("","")

        ConOut(CaptureError(.T.))

        ConOut("","")

        IF (;
                IsInCallStack("MsAguarde");
                .or.;
                IsInCallStack("MsgRun");
        )
            Final("Problema No envio de e-mail","Contacte o Administrador do Sistema")
        EndIF

    ENDEXCEPTION

Return(lSendOk)

/*/
    Funcao:        ReceiveMail
    Autor:        Marinaldo de Jesus
    Data:        25/11/2010
    Descricao:    Recebimento de e-mail
    Sintaxe:    <Vide Parametros Formais>
/*/
Static Function ReceiveMail(;
                                cServer,;       //01->Servidor a ser utilizado para recebimento
                                 cUser,;        //02->Conta a ser utilizada para recebimento
                                 cPassWord,;    //03->Senha a ser utilizada para recebimento
                                cPath,;         //04->Path para a Gravacao das Mensagens Recebidas
                                lDelete,;       //05->Se Deleta as Mensagens ja Recebidas
                                nTimeOut,;      //06->Tempo de TimeOut
                                nAttempts,;     //07->Numero de Tentativas
                                 aReceiveMail;  //08->Array com os emails recebidos
                        )

    /*/
        MailAuth(cUser,cPassword)
        MailGetErr(<void>)->cErr
        MailGetNumErr(<void>)->nNumErr
        MailFormatText(lTextPlain)
        MailPopOn(cServer,cUser,cPassword,nTimeOut)->lPopOk
            PopMsgCount(@nPopMsgCount)->lPopMsgCount
            _PopMsgCount(<void>)->aPopMsgCount[1]->nPopMsgCount; aPopMsgCount[2]->lPopMsgCount
            _MailReceive(nMsgNumber,cPath,lDelete)->aMailReceive
            MailReceive(nMsgNumber,@cFrom,@cTo,@cCc,@cBcc,@cSubject,@cBody,@aFiles,cPath,lDelete)->lReceiveOk
            ConfirmMailRead(bFlag)
        MailPopOf(<void>)
    /*/
    
    Local bReceiveMail:={||ReceiveMail()}
    
    Local nMsgNumber
    Local nNumberMsg
    Local nItried
    
    Local lReceiveOk:=.T.
    
    TRYEXCEPTION
    
        DEFAULT cServer:=SuperGetMv("MV_RELSERV")
        IF !(lReceiveOk:=!Empty(cServer))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MV_RELSERV invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT cUser:=SuperGetMv("MV_RELACNT")
        IF !(lReceiveOk:=!Empty(cUser))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MV_RELACNT invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT cPassWord:=SuperGetMv("MV_RELPSW")
        IF !(lReceiveOk:=!Empty(cPassWord))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MV_RELPSW invalido]"
            ConOut(cException)
            UserException(cException)
        EndIF
    
        DEFAULT nTimeOut:=MAIL_TIME_OUT
        DEFAULT nAttempts:=5
    
        nItried:=0
        While !(lReceiveOk:=MailPopOn(cServer,cUser,cPassWord,nTimeOut))
            IF ((++nItried) > nAttempts)
                cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailPopOn][Impossivel conectar-se ao POP]"
                cException+=CRLF
                cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
                cException+=CRLF
                cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
                cException+=CRLF
                ConOut(cException)
                UserException(cException)
            EndIF    
            Sleep(100)
        End While
    
        IF !(lReceiveOk:=PopMsgCount(@nNumberMsg))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]PopMsgCount][Nao existem mensagem a serem recebidas]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
            cException+=CRLF
            ConOut(cException)
            UserException(cException)
        EndIF
    
        nMsgNumber:=0
        DEFAULT aReceiveMail:={}
        While ((++nMsgNumber) <=nNumberMsg)
            aAdd(aReceiveMail,_MailReceive(nMsgNumber,cPath,lDelete))
        End While

        IF !(lReceiveOk:=!Empty(aReceiveMail))
            cException:="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]aReceiveMail][Nao existem mensagem a serem recebidas]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetNumErr]["+Str(MailGetNumErr())+"]"
            cException+=CRLF
            cException+="[SendMail][Error]["+Dtoc(Date())+"]["+Time()+"]MailGetErr]["+MailGetErr()+"]"
            cException+=CRLF
            ConOut(cException)
            UserException(cException)
        EndIF
    
        MailPopOff()
    
    CATCHEXCEPTION

        lReceiveOk:=.F.

        MailPopOff()

        IF (;
                IsInCallStack("MsAguarde");
                .or.;
                IsInCallStack("MsgRun");
        )
            Final("Problema No Recebimento de e-mail","Contacte o Administrador do Sistema")
        EndIF

    ENDEXCEPTION

Return(lReceiveOk)

/*/
    Funcao: AddMailDest
    Autor:    Marinaldo de Jesus
    Data:    17/02/2011
    Uso:    Adiciona Destinatarios de Email
    
/*/
Static Function AddMailDest(aDest,cMailDest)

    Local aMails
    
    Local cMailAdd:=cMailDest

    Local nBL
    Local nEL

    IF !Empty(cMailDest)
        aMails:=StrTokArr2(cMailDest,";")
        nEL:=Len(aMails)
        For nBL:=1 To nEL
            cMailAdd:=aMails[ nBL ]
            cMailAdd:=StaticCall(NDJLIB014,WF4Mail,@cMailAdd)
            cMailAdd:=Lower(AllTrim(cMailAdd))
            IF (aScan(aDest,{|cMail|(cMail ==cMailAdd)}) ==0)
                aAdd(aDest,cMailAdd)
            EndIF
        Next nBL
    EndIF

Return(aClone(aDest))

Static Function __Dummy(lRecursa)
    Local oException
    TRYEXCEPTION
        lRecursa:=.F.
        IF !(lRecursa)
            BREAK
        EndIF
        SendMail()
        ReceiveMail()
        lRecursa:=__Dummy(.F.)
        SYMBOL_UNUSED(__cCRLF)
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return(lRecursa)
