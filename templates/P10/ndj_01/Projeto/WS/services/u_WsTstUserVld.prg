#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"

/*/
WebService:    u_wsTstUserValid
Autor:         Marinaldo de Jesus
Data:         01/04/2011
Descricao:    Web Service para Teste Validacao de Usuario do WS usando MD5
Uso:         WebServices
Versao:        3.0
/*/
WSSERVICE u_wsTstUserValid DESCRIPTION "Web Service para Teste Validacao de Usuario do WS usando MD5" NAMESPACE "http://200.143.193.18/ws/u_wststuservalid.apw"

    WSDATA lUserOk    AS Boolean
    WSDATA Usr        AS String
    WSDATA Pwd        AS String
    WSDATA CheckSum    As Integer
    
    WSDATA Message    AS String

    WSMETHOD SampleVld01 Description "Exemplo 01 - Usando Language igual a PT, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld02 Description "Exemplo 02 - Usando Language igual a ENG, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld03 Description "Exemplo 03 - Usando Language igual a SPA, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld04 Description "Exemplo 04 - Usando Language em Branco, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"

    WSMETHOD SampleVld05 Description "Exemplo 05 - Usando Language igual a PT, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld06 Description "Exemplo 06 - Usando Language igual a ENG, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld07 Description "Exemplo 07 - Usando Language igual a SPA, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld08 Description "Exemplo 08 - Usando Language em Branco, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"

    WSMETHOD SampleVld09 Description "Exemplo 09 - Usando Language igual a PT, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld10 Description "Exemplo 10 - Usando Language igual a ENG, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld11 Description "Exemplo 11 - Usando Language igual a SPA,, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld12 Description "Exemplo 12 - Usando Language em Branco, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"

    WSMETHOD SampleVld13 Description "Exemplo 13 - Usando Language igual a PT, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld14 Description "Exemplo 14 - Usando Language igual a ENG, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld15 Description "Exemplo 15 - Usando Language igual a SPA,, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"
    WSMETHOD SampleVld16 Description "Exemplo 16 - Usando Language em Branco, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado Varias Vezes. Eliminado por Time Out)"

    WSMETHOD SampleVld17 Description "Exemplo 17 - Usando Language igual a PT, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld18 Description "Exemplo 18 - Usando Language igual a ENG, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld19 Description "Exemplo 19 - Usando Language igual a SPA, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld20 Description "Exemplo 20 - Usando Language em Branco, Usuário e Senhas originais e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"

    WSMETHOD SampleVld21 Description "Exemplo 21 - Usando Language igual a PT, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld22 Description "Exemplo 22 - Usando Language igual a ENG, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld23 Description "Exemplo 23 - Usando Language igual a SPA, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld24 Description "Exemplo 24 - Usando Language em Branco, Usuário e Senhas originais e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"

    WSMETHOD SampleVld25 Description "Exemplo 25 - Usando Language igual a PT, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld26 Description "Exemplo 26 - Usando Language igual a ENG, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld27 Description "Exemplo 27 - Usando Language igual a SPA,, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld28 Description "Exemplo 282 - Usando Language em Branco, Hash de Usuário e Senha e Não Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"

    WSMETHOD SampleVld29 Description "Exemplo 29 - Usando Language igual a PT, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld30 Description "Exemplo 30 - Usando Language igual a ENG, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld31 Description "Exemplo 31 - Usando Language igual a SPA,, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    WSMETHOD SampleVld32 Description "Exemplo 32 - Usando Language em Branco, Hash de Usuário e Senha e Embaralha (Token Pode ser Utilizado apenas uma vez. Eliminado apos o uso)"
    
    WSMETHOD SampleVld33 Description "Exemplo 33 - Forcando a 'Limpeza' da pilha de mensagens"

ENDWSSERVICE

/*/
WSMETHOD:    SampleVld01
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld01 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.

            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld02
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld02 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    
    TRYEXCEPTION
    
        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()             
        

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld03
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld03 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
        
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld04
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld04 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld05
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld05 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld06
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld06 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld07
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld07 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld08
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld08 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION
    
        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld09
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld09 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld10
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld10 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld11
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld11 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld12
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld12 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld13
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld13 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION


Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld14
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld14 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                           := ""
    Local cMD5Hash                           := ""
    Local cMsgSoapFault                       := ""

    Local lWsMethodRet                       := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld15
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld15 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld16
Autor:        Marinaldo de Jesus
Data:        29/07/2010
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld16 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld17
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld17 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld18
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld18 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld19
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld19 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld20
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld20 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld21
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld21 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld22
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld22 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld23
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld23 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld24
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld24 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( Self:Usr )
        oValidUser:cUSERWSPASSWD        := Encode64( Self:Pwd )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .F.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld25
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld25 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld26
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld26 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld27
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld27 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage
    
    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld28
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld28 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld29
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld29 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "PT"
        oValidUser:lEMBARALHA           := .F.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld30
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld30 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION    

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "ENG"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF

    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld31
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld31 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := "SPA"
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld32
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld32 WSRECEIVE Usr, Pwd, CheckSum WSSEND lUserOk WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""
                                    
    Local lWsMethodRet                      := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oValidUser:cTOKEN                := cMD5Hash
        oValidUser:ISAUTHENTICATED()
    
        Self:lUserOk                    := oValidUser:lISAUTHENTICATEDRESULT 

        IF ( Self:lUserOk )
            oClearMessage                        := WSU_WSCLEARMESSAGES():New()
            oClearMessage:cTOKEN                := cMD5Hash
            oClearMessage:lCLEARALLMD5HASH        := .F.
            oClearMessage:cMD5HASHCLEAR            := cMD5Hash
            oClearMessage:ClearStackMD5Hash()
        EndIF
    
    CATCHEXCEPTION USING oException
    
        Self:lUserOk        := .F.

        IF ( ValType( oException ) == "O" )

            lWsMethodRet     := .F.
        
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        
            SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
        EndIF    
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
WSMETHOD:    SampleVld33
Autor:        Marinaldo de Jesus
Data:        01/04/2011
Descri‡…o:    Exemplo de Validacao de WS Usando MD5
Uso:        WS
/*/
WSMETHOD SampleVld33 WSRECEIVE Usr, Pwd, CheckSum WSSEND Message WSSERVICE u_wsTstUserValid
    
    Local cMessage                        := ""
    Local cMD5Hash                        := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local oException
    Local oValidUser
    Local oClearMessage

    TRYEXCEPTION

        oValidUser                        := WSU_WSUSERVALID():New()

        oValidUser:cUSERWS              := Encode64( MD5( Self:Usr ) )
        oValidUser:cUSERWSPASSWD        := Encode64( MD5( Self:Pwd ) )
        oValidUser:nCHECKSUM            := Self:CheckSum
        oValidUser:lHASHMD5USERANDPSW    := .T.
        oValidUser:cLANGUAGE            := ""
        oValidUser:lEMBARALHA           := .T.

        oValidUser:VALIDUSERWS()

        cMessage                        := oValidUser:cVALIDUSERWSRESULT
        IF Empty( cMessage  )
            cMsgSoapFault                := "Usuario sem direitos para Limpar a pilha de Mensagens"
            BREAK
        EndIF
        cMD5Hash                        := Encode64( MD5( Decode64( cMessage ) , 2 ) )

        oClearMessage                        := WSU_WSCLEARMESSAGES():New()
        oClearMessage:cTOKEN                := cMD5Hash
        oClearMessage:lCLEARALLMD5HASH        := .T.
        oClearMessage:cMD5HASHCLEAR            := ""
        oClearMessage:ClearStackMD5Hash()

        Self:Message                        := oClearMessage:cCLEARSTACKMD5HASHRESULT

    CATCHEXCEPTION USING oException

        lWsMethodRet    := .F.

        IF ( ValType( oException ) == "O" )
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        EndIF    

        SetSoapFault( "ValidUserWs" , cMsgSoapFault )
    
    ENDEXCEPTION

Return( lWsMethodRet )
