/*/
    Para Cálculo do MD5 Hash use:    http://md5-hash-online.waraxe.us/
    Para o Encode64 use:             http://www.opinionatedgeek.com/dotnet/tools/base64Encode
    Para o Decode64 use:            http://www.opinionatedgeek.com/dotnet/tools/base64decode
/*/
#INCLUDE "NDJ.CH"

#DEFINE USER_PWD_CFG_FILE    "u_wsuservalid.ini"
#DEFINE USERWS_NAME             1
#DEFINE USERWS_PASSWORD     2

#DEFINE SECONDS_TIME_OUT    3600

#DEFINE TOKEN_PATH_FILE        "\wstoken\"
#DEFINE TOKEN_FILE_EXT        ".tkn"

#DEFINE STR0001 "Web Service para Validacao de Usuario do WS usando MD5"
#DEFINE STR0002 "Validar Acesso ao WS Considerando Usuario, Senha Senha e CheckSum. Retorna Mensagem para autenticacao."
#DEFINE STR0003 "HASH do Usuario Invalido"
#DEFINE STR0004     "HASH da Senha Invalida"
#DEFINE STR0005 "Usuario Invalido"
#DEFINE STR0006 "Senha Invalida"
#DEFINE STR0007 "O Token deve ser informado. Obtenha e Informe um Token"
#DEFINE STR0008 "Token Invalido. Obtenha e Informe um Novo Token"
#DEFINE STR0009 "Mensagens Genéricas"
#DEFINE STR0010     "Obter Mensagen Aleatoria"
#DEFINE STR0011 "Limpar a Pilha de Mensagens"
#DEFINE STR0012 "the stack of MD5Hash is empty"
#DEFINE STR0013 "the last MD5Hash is clean"
#DEFINE STR0014 "Nao foi possivel criar o diretorio de mensagens: "
#DEFINE STR0015 "Nao foi possivel criar o arquivo de Mensagem: "
#DEFINE STR0016 "Usuario ou Senha Invalido(s)"
#DEFINE STR0017 "Token Vencido por 'TimeOut'. Obtenha e Informe um Novo Token"
#DEFINE STR0018 "Limpar pilha de Mensagens Genéricas"
#DEFINE STR0019 "Usuario sem direitos para Limpar a pilha de Mensagens"
#DEFINE STR0020 "Unable to clean up the stack of messages. The following files may be in use:"
#DEFINE STR0021    "Unable to clear the message informed. It may be in use by another user"
#DEFINE STR0022 "Verifica se usuario foi autenticado"
#DEFINE STR0023 "Was not possible to clean the stack of messages. Verify the parameters passed are correct."

Static nStcSeed
Static lAlterna
Static lExistDir    := MyMakeDir( TOKEN_PATH_FILE , NIL , NIL , .T. )

/*/
    WebService:    u_wsUserValid
    Autor:         Marinaldo de Jesus
    Data:         01/04/2011
    Descricao:    Web Service para Validacao de Usuario do WS usando MD5
    Uso:         WebServices
    Versao:        3.0
/*/
WSSERVICE u_wsUserValid DESCRIPTION STR0001 NAMESPACE "http://200.143.193.18/ws/u_wsuservalid.apw" //"Web Service para Validacao de Usuario do WS usando MD5"

    WSDATA UserWs                AS String
    WSDATA UserWsPasswd            AS String
    WSDATA CheckSum                AS Integer
    WSDATA HASHMD5UserAndPsw    AS Boolean    OPTIONAL
    WSDATA Language                AS String    OPTIONAL    //Put <b>; PT; ENG or SPA
    WSDATA Embaralha            AS Boolean    OPTIONAL

    WSDATA Token                AS String
    
    WSDATA lAuthenticated        AS Boolean
    WSDATA lUseTimeOut            AS Boolean    OPTIONAL

    WSMETHOD ValidUserWs        DESCRIPTION STR0002 //"Validar Acesso ao WS Considerando Usuario, Senha Senha e CheckSum. Retorna Mensagem para autenticacao"
    WSMETHOD IsAuthenticated    DESCRIPTION STR0022    //"Verifica se usuario foi autenticado"

ENDWSSERVICE

/*/
    WSMETHOD:    ValidUserWs
    Autor:         Marinaldo de Jesus
    Data:         01/04/2011
    Descri‡…o:    Validar Acesso ao WS Considerando Usuario, Senha e CheckSum
                Atraves de MD5 (Message Digest Algorithm 5)
    Uso:        WS
/*/
WSMETHOD ValidUserWs WSRECEIVE UserWs, UserWsPasswd, CheckSum, HASHMD5UserAndPsw, Language, Embaralha WSSEND Token WSSERVICE u_wsUserValid
    
    Local cMD5Hash                    := ""
    Local cFileMD5Hash                := ""
    Local cMsgSoapFault                := ""

    Local lWsMethodRet                := .T.

    Local nUserName                    := 0
    Local nUserPassWord                := 0

    Local oException
    
    TRYEXCEPTION

        GetUserPwd( Decode64( AllTrim( Self:UserWs ) ) , Decode64( AllTrim( Self:UserWsPasswd ) ) , @nUserName , @nUserPassWord , Self:HASHMD5UserAndPsw )

        IF ( Self:HASHMD5UserAndPsw )
            IF !( nUserName > 0 )
                cMsgSoapFault := STR0003 //"HASH do Usuario Invalido"
                BREAK
            EndIF
            IF !( nUserPassWord > 0 )
                cMsgSoapFault := STR0004 //"HASH da Senha Invalida"
                BREAK
            EndIF
        Else
            IF !( nUserName > 0 )
                cMsgSoapFault := STR0005 //"Usuario Invalido"
                BREAK
            EndIF
            IF !( nUserPassWord > 0 )
                cMsgSoapFault := STR0006    //"Senha Invalida"
                BREAK
            EndIF
        EndIF    

        IF !( ( nUserName + nUserPassWord ) == Self:CheckSum )
            cMsgSoapFault := STR0016    //"Usuario ou Senha Invalido(s)"
            BREAK    
        EndIF

        Self:Token    := GetMessage( Self:Language, Self:Embaralha , @cMsgSoapFault )
        IF !Empty( cMsgSoapFault )
            BREAK
        EndIF

    CATCHEXCEPTION USING oException

        Self:Token            := ""
        lWsMethodRet         := .F.

        IF ( ValType( oException ) == "O" )
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        EndIF    

        SetSoapFault( "ValidUserWs" , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WSMETHOD:    IsAuthenticated
    Autor:         Marinaldo de Jesus
    Data:         01/04/2011
    Descri‡…o:    Verificar se Usuário Foi Autenticado
    Uso:        WS
/*/
WSMETHOD IsAuthenticated WSRECEIVE Token , lUseTimeOut WSSEND lAuthenticated WSSERVICE u_wsUserValid
    
    Local cMD5Hash                    := ""
    Local cFileMD5Hash                := ""
    Local cMsgSoapFault                := ""

    Local lTimeOut                    := .F.
    Local lWsMethodRet                := .T.

    Local oException
    
    TRYEXCEPTION

        cMD5Hash            := AllTrim( Self:Token )
        IF Empty( cMD5Hash  )
            cMsgSoapFault     := STR0007    //"O Token deve ser informado. Obtenha e Informe um Token"
            BREAK
        EndIF

        cMD5Hash            := Decode64( cMD5Hash )
        cFileMD5Hash        := Lower( TOKEN_PATH_FILE + cMD5Hash + TOKEN_FILE_EXT )
        IF !File( cFileMD5Hash )
            cMsgSoapFault     := STR0008 //"Token Invalido. Obtenha e Informe um Novo Token"
            BREAK
        EndIF

        IF ( Self:lUseTimeOut )
            lTimeOut        := ChkTimeOut( @cFileMD5Hash )
        EndIF    

        IF ( lTimeOut )
            cMsgSoapFault    := STR0017 //"Token Vencido por 'TimeOut'. Obtenha e Informe um Novo Token"
            BREAK
        EndIF

        Self:lAuthenticated    := .T.

    CATCHEXCEPTION USING oException

        lWsMethodRet         := .F.
        Self:lAuthenticated    := .F.

        IF ( ValType( oException ) == "O" )
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        EndIF    

        SetSoapFault( "IsAuthenticated" , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WebService:    u_wsClearMessages
    Autor:         Marinaldo de Jesus
    Data:         01/04/2011
    Descricao:    Web Service para Limpar pilha de Mensagens Genéricas
    Uso:         WebServices
    Versao:        3.0
/*/
WSSERVICE u_wsClearMessages DESCRIPTION STR0018 NAMESPACE "http://localhost/naldo/u_wsclearmessages.apw" //"Limpar pilha de Mensagens Genéricas"

    WSDATA Token                AS String
    WSDATA ClearAllMD5Hash      AS Boolean    OPTIONAL
    WSDATA MD5HashClear            AS String    OPTIONAL
    
    WSDATA Message                AS String    

    WSMETHOD ClearStackMD5Hash    DESCRIPTION STR0011 //"Limpar a Pilha de Mensagens"

ENDWSSERVICE

/*/
    WSMETHOD:    ClearStackMD5Hash
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Limpa a Pilha de Mensagens
    Uso:        WS
/*/
WSMETHOD ClearStackMD5Hash WSRECEIVE Token, ClearAllMD5Hash, MD5HashClear WSSEND Message WSSERVICE u_wsClearMessages

    Local aNotDel                        := {}
    
    Local cFileMD5Hash                    := ""
    Local cMsgSoapFault                    := ""

    Local lWsMethodRet                    := .T.

    Local nFile                            := 0
    Local nFiles                        := 0
    Local nLastMessage                    := 0
    
    Local oException
    Local oValidUser                    := WSU_WSUSERVALID():New()

    TRYEXCEPTION    

        oValidUser:cTOKEN                := Self:Token
        oValidUser:ISAUTHENTICATED()

        IF !( oValidUser:lISAUTHENTICATEDRESULT  )
            cMsgSoapFault := STR0019 //"Usuario sem direitos para Limpar a pilha de Mensagens"
            BREAK
        EndIF

        IF !( lExistDir )
            UserException( STR0014 + TOKEN_PATH_FILE ) //"Nao foi possivel criar o diretorio de mensagens: "
        EndIF

        DEFAULT Self:ClearAllMD5Hash        := .F.
        DEFAULT Self:MD5HashClear            := ""        

        Self:MD5HashClear                    := AllTrim( Self:MD5HashClear )
        
        IF ( ;
                ( Self:ClearAllMD5Hash );
                .and.;
                Empty( Self:MD5HashClear );
            )    

            IF ( DelAllTokenFiles( .F. , @aNotDel ) )

                Self:Message                := STR0012 //"the stack of messages is empty"
            
            Else
                
                 Self:Message                 := STR0020 + CRLF //"Unable to clean up the stack of messages. The following files may be in use:"
                 nFiles    := Len( aNotDel )
                For nFile := 1 To nFiles
                    Self:Message             += aNotDel[nFile] + CRLF
                Next nFile            

            EndIF    

        ElseIF !Empty( Self:MD5HashClear )

            cFileMD5Hash        := Lower( TOKEN_PATH_FILE + Decode64( Self:MD5HashClear ) + TOKEN_FILE_EXT )

            IF StaticCall( NDJLIB007 , FileErase , cFileMD5Hash )
    
                Self:Message    := STR0013 //"the last massage is clean"
            
            Else
                
                Self:Message    := STR0021 //"Unable to clear the message informed. It may be in use by another user"
            
            EndIF    

        Else
            
            Self:Message    := STR0023 //"Was not possible to clean the stack of messages. Verify the parameters passed are correct."

        EndIF    

    CATCHEXCEPTION USING oException

        lWsMethodRet := .F.

        IF ( ValType( oException ) == "O" )
            cMsgSoapFault    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cMsgSoapFault    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        EndIF

        SetSoapFault( "ClearStackMD5Hash" , cMsgSoapFault )
    
    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    Function:    GetMessage
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Retorna Mensagem Para Token de Autenticaco de Usuario
    Uso:        WS
/*/
Static Function GetMessage( cLanguage, lEmbaralha , cError )

    Local aRecnos        := {}
    Local aNextDay        := {}
    
    Local cAlias        := ""
    Local cQuery        := ""
    Local cWhere        := ""
    Local cTimeOut        := ""
    Local cMessage        := ""
    Local cMD5Hash        := ""
    Local cFieldDesc    := ""
    Local cFileMD5Hash    := ""

    Local bGetMinRec    := { || nMinRec }
    Local bGetMaxRec    := { || nMaxRec }

    Local nErr            := 0
    Local nHandle        := 0
    Local nMinRec        := 0
    Local nMaxRec        := 0
    Local nSX5Recnos    := 0
    Local nRandomRec    := 0
    Local lLastAlterna    := .F.
    Local lWsMethodRet    := .T.
    
    Local oException

    TRYEXCEPTION    

        IF !( lExistDir )
            UserException( STR0014 + TOKEN_PATH_FILE ) //"Nao foi possivel criar o diretorio de mensagens: "
        EndIF

        DEFAULT lAlterna    := .F.
        lLastAlterna         := lAlterna

        DelAllTokenFiles( .T. )

        IF Empty( cLanguage )
            cLanguage     := "__NALDO_&_SONETA__"
        Else
            cLanguage    := Upper( AllTrim( cLanguage ) )
        EndIF

        IF ( cLanguage $ "PT/ENG/SPA" )

            TRYEXCEPTION
                
                nSX5Recnos        := SX5->( RecCount() )

                IF ( nSX5Recnos == 0 )
                    BREAK    
                EndIF

                 nRandomRec        := Random( nSX5Recnos , 1 , nSX5Recnos )
                 nMaxRec            := nRandomRec
                 nMinRec            := Random( nMaxRec , 1 , nMaxRec )

                cAlias            := GetNextAlias()
            
                IF ( cLanguage == "PT" )
                    cFieldDesc := "X5_DESCRI"
                ELSEIF ( Self:Language == "ENG" )
                    cFieldDesc := "X5_DESCENG"
                ELSEIF ( Self:Language == "SPA" )
                    cFieldDesc := "X5_DESCSPA"
                EndIF

                cQuery := "SELECT "
                cQuery += "R_E_C_N_O_ "
                cQuery += "FROM "
                cQuery += RetSqlName( "SX5" ) + " SX5 "
                cQuery += "WHERE "

                cWhere := "SX5.R_E_C_N_O_ >= " + Str( Eval( bGetMinRec ) )
                cWhere += " AND "
                cWhere += "SX5.R_E_C_N_O_ <= " + Str( Eval( bGetMaxRec ) )

                dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery+cWhere),cAlias,.F.,.T.)

                While (cAlias)->( Eof() )
                    
                    (cAlias)->( dbCloseArea() )
                    
                    nRandomRec        := Random( nSX5Recnos , 1 , nSX5Recnos )
                    IF !( lAlterna )
                        nMinRec        := nRandomRec
                        nMaxRec        := ( nRandomRec * Random( 10 , 2 , 10 ) )
                        lAlterna    := .T.
                    Else
                        nMinRec        := Int( nRandomRec / Random( 5 , 2 , 5 ) )
                        nMaxRec        := nRandomRec
                        lAlterna    := .F.
                    EndIF    
                    
                    cWhere := "SX5.R_E_C_N_O_ >= " + Str( Eval( bGetMinRec ) )
                    cWhere += " AND "
                    cWhere += "SX5.R_E_C_N_O_ <= " + Str( Eval( bGetMaxRec ) )
                    
                    dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery+cWhere),cAlias,.F.,.T.)
                    
                End While

                While (cAlias)->( !Eof() )

                    aAdd( aRecnos , (cAlias)->R_E_C_N_O_ )

                    (cAlias)->( dbSkip() )
    
                End While
                
                (cAlias)->( dbCloseArea() )

                nMaxRec := Len( aRecnos )

                IF ( nMaxRec == 0 )
                    BREAK
                EndIF

                nMinRec := 1

                SX5->( dbGoto( aRecnos[ Random( nMaxRec , nMinRec , nMaxRec ) ] ) )
                cMessage := AllTrim( SX5->( &( cFieldDesc ) ) )

            CATCHEXCEPTION
                
                cLanguage := "__NALDO_&_SONETA__"

            ENDEXCEPTION
        
        EndIF

        IF Empty( cMessage )
            cMessage := ( cLanguage + ProcName() + StrZero( ProcLine() + Seconds() , 10 ) + StrZero( Val( Dtos( MsDate() ) ) + Seconds() , 10 ) + Time() )
        EndIF

        cMessage := ( "@#" + cMessage + "#@" )

        DEFAULT lEmbaralha    := .F.
        IF ( lEmbaralha )
            cMessage := Embaralha( cMessage , IF( lAlterna , 1 , 0 ) )
        EndIF    

        cMD5Hash        := MD5( cMessage , 2 )

        cFileMD5Hash    := Lower( TOKEN_PATH_FILE + cMD5Hash + TOKEN_FILE_EXT )

        IF !( StaticCall( NDJLIB007 , FileCreate , cFileMD5Hash , @nHandle , @nErr , .F. ) )
            UserException( "fError: " + Alltrim( Str( nErr ) ) + "::" + STR0015 + cFileMD5Hash ) //"Nao foi possivel criar o arquivo de Mensagem: "
        EndIF

        aNextDay    := Time2NextDay( IncTime( Time() , NIL , NIL , UserPdwRead( .T. ) ) , Date() )

        cTimeOut    := "[TimeOut]"            + CRLF
        cTimeOut    += "Hours="                + aNextDay[1] + CRLF 
        cTimeOut    += "Date="                 + Dtos( aNextDay[2] ) + CRLF
        cTimeOut    += "SecondsTimeOut="    + AllTrim( Str( UserPdwRead( .T. ) ) ) + CRLF

        fWrite( @nHandle , @cTimeOut , Len( cTimeOut ) )
        fClose( @nHandle )

        cMessage    := Encode64( cMessage )

    CATCHEXCEPTION USING oException

        DEFAULT cError    := ""
        IF ( ValType( oException ) == "O" )
            cError    += IF( !Empty( oException:Description )    , oException:Description    , "" )
            cError    += IF( !Empty( oException:ErrorStack )    , oException:ErrorStack     , "" )
        EndIF    

    ENDEXCEPTION

    lAlterna    := !( lLastAlterna )

Return( cMessage )

/*/
    Fun‡„o:        Random
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡„o:    Gerar Numeros Aleatorios conforme Intervalo
    Sintaxe:    <Vide Parametros Formais>
    Parametros:    <Vide Parametros Formais>
    Uso:        Generico
/*/
Static Function Random( nRange , nMin , nMax )

    Local bRandom    := { ||;
                                ( nRandom := Aleatorio( nRange , @nStcSeed ) ),;
                                ( ( nRandom >= nMin ) .and. ( nRandom <= nMax ) );
                            }        
    
    Local nRandom
    
    DEFAULT nRange        := 1
    DEFAULT nMin         := 0
    DEFAULT nMax         := nRange
    
    DEFAULT nStcSeed    := Int( ( nRange / 2 ) )
    
    nMin                := Max( nMin    , 0 )
    nMax                := Max( nMax    , 1 )
    nRange                := Max( nRange    , 1 )
    
    IF ( nMin > nMax )
        nMin := 0
    EndIF
    
    IF (;
            ( nMax < nMin );
            .or.;
            ( nMax > nRange );
        )
        nMax := nRange    
    EndIF
    
    While !Eval( bRandom )
         IF (;
                 ( nRandom < nMin );
                 .or.;
                 ( nRandom > nMax );
             )    
             IF ( nStcSeed < nMin )
                 nStcSeed += nMin
                 nStcSeed := Min( nMax , nStcSeed ) 
             ElseIF ( nStcSeed > nMax )
                 nStcSeed -= ( nMax - nMin )
                 nStcSeed := Max( nMin , nStcSeed )
             EndIF
         EndIF    
    End While

Return( nRandom )

/*/
    Fun‡…o:        MyMakeDir
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Cria um Diretorio
    Uso:        Generico
/*/
Static Function MyMakeDir( cMakeDir , nTimes , nSleep , lUserPdwRead )

    Local lMakeOk
    Local nMakeOk
    
    IF !( lMakeOk := lIsDir( cMakeDir ) )
        MakeDir( cMakeDir )
        nMakeOk            := 0
        DEFAULT nTimes    := 3
        DEFAULT nSleep    := 100
        While (;
                !( lMakeOk := lIsDir( cMakeDir ) );
                .and.;
                ( ++nMakeOk <= nTimes );
           )
            Sleep( nSleep )
            MakeDir( cMakeDir )
        End While
    EndIF

    DEFAULT lUserPdwRead    := .F.
    IF (;
            ( lMakeOk );
            .and.;
            ( lUserPdwRead );
        )    
        UserPdwRead(.F.)
    EndIF

Return( lMakeOk )

/*/
    Fun‡…o:        GetUserPwd
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Verifica Usuario e Senha
    Uso:        Generico
/*/                                                     ³
Static Function GetUserPwd( cUserWs , cUserWsPasswd , nUserName , nUserPassWord , lHash )

    Local aGetUserPsw    := UserPdwRead()

    Local lOk            := .F.

    DEFAULT lHash        := .F.

    TRYEXCEPTION
    
        IF Empty( aGetUserPsw )
            BREAK
        EndIF

        IF ( lHash )
            nUserName             := aScan( aGetUserPsw[USERWS_NAME] , { |cUsr| ( MD5( cUsr , 2 ) == cUserWs ) } )
            nUserPassWord        := aScan( aGetUserPsw[USERWS_PASSWORD] , { |cPwd| ( MD5( cPwd , 2 ) == cUserWsPasswd ) } )
            BREAK
        EndIF    

        nUserName                 := aScan( aGetUserPsw[USERWS_NAME] , { |cUsr| ( cUsr == cUserWs ) } )
        nUserPassWord            := aScan( aGetUserPsw[USERWS_PASSWORD] , { |cPwd| ( cPwd == cUserWsPasswd ) } )

    ENDEXCEPTION

    DEFAULT nUserName            := 0
    DEFAULT nUserPassWord       := 0

    lOk    := ( ( nUserName > 0 ) .and. ( nUserPassWord > 0 ) )

Return( lOk  )

/*/
    Fun‡…o:        UserPdwRead
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Le o arqivo de Usuarios e Senhas
    Uso:        Generico
/*/
Static Function UserPdwRead( lTimeOut )

    Local aPwds                := {}
    Local aUsers            := {}
    Local aKeyPos            := {}

    Local aUserPwdRead        := {}
    
    Local cLineRead            := ""
    Local cLwrLineRead        := ""
    Local cDefaultUsrPwd    := ""
    Local cPathFileUsrPwd    := ( TOKEN_PATH_FILE + USER_PWD_CFG_FILE )

    Local lFile                := File( cPathFileUsrPwd )
    Local lFtFUse            := .F.

    Local nErr
    Local nHandle
    Local nGoto
    Local nLoop
    Local Loops    
    Local nUsers            := 0
    Local nAttemps            := 0
    Local nPassWords        := 0
    Local nSecondsTimeOut    := 0
    
    Local oFt
    Local oException

    DEFAULT lTimeOut         := .F.

    TRYEXCEPTION

        IF !( lFile )
            
            IF !( StaticCall( NDJLIB007 , FileCreate ,  cPathFileUsrPwd , @nHandle , @nErr , .F. ) )
                BREAK
            EndIF

            cDefaultUsrPwd    := "[UserName]" + CRLF
            cDefaultUsrPwd    += "NDJ" + CRLF
            cDefaultUsrPwd    += "NDJ" + CRLF
            cDefaultUsrPwd    += "Rede Nacional de Ensino e Pesquisa" + CRLF
            cDefaultUsrPwd    += "rede nacional de ensino e pesquisa" + CRLF
            cDefaultUsrPwd    += "REDE NACIONAL DE ENSINO E PESQUISA" + CRLF
            cDefaultUsrPwd    += "TOTVS" + CRLF
            cDefaultUsrPwd    += "totvs" + CRLF
            cDefaultUsrPwd    += "Totvs" + CRLF
            cDefaultUsrPwd    += "Protheus" + CRLF
            cDefaultUsrPwd    += "protheus" + CRLF
            cDefaultUsrPwd    += "PROTHEUS" + CRLF
            cDefaultUsrPwd    += CRLF
            cDefaultUsrPwd    += "[UserPassWord]" + CRLF
            cDefaultUsrPwd    += "b3d28e7f822dac10b74101712651597ba152c2fc" + CRLF
            cDefaultUsrPwd    += "Ly9QYXJhIG8gRGVjb2RlNjQgdXNlOiBodHRwOi8vd3d3Lm9waW5pb25hdGVkZ2Vlay5jb20vZG90bmV0L3Rvb2xzL2Jhc2U2NGRlY29kZS8qLw==" + CRLF
            cDefaultUsrPwd    += "9dd867e76e02c3fa10ae50dcc11081c5d2adec57" + CRLF
            cDefaultUsrPwd    += "6148ea40e060b81e0baa6927adffa3b847e8bf38" + CRLF
            cDefaultUsrPwd    += "9dd867e76e02c3fa10ae50dcc11081c5d2adec57" + CRLF
            cDefaultUsrPwd    += "d5582b0680b92e1e5cf378d62d559e196e4a28a2" + CRLF
            cDefaultUsrPwd    += "e17f619c2c04dbc833c700283f094c29" + CRLF
            cDefaultUsrPwd    += "941006ed741ab68bebccfa32885cf013" + CRLF
            cDefaultUsrPwd    += "OTQxMDA2ZWQ3NDFhYjY4YmViY2NmYTMyODg1Y2YwMTM=" + CRLF
            cDefaultUsrPwd    += "IjlkZDg2N2U3NmUwMmMzZmExMGFlNTBkY2MxMTA4MWM1ZDJhZGVjNTci" + CRLF
            cDefaultUsrPwd    += "Ikx5OVFZWEpoSUc4Z1JHVmpiMlJsTmpRZ2RYTmxPaUJvZEhSd09pOHZkM2QzTG05d2FXNXBiMjVoZEdWa1oyVmxheTVqYjIwdlpHOTBibVYwTDNSdmIyeHpMMkpoYzJVMk5HUmxZMjlrWlM4cUx3PT0i" + CRLF
            cDefaultUsrPwd    += "SWt4NU9WRlpXRXBvU1VjNFoxSkhWbXBpTWxKc1RtcFJaMlJZVG14UGFVSnZaRWhTZDA5cE9IWmtNMlF6VEcwNWQyRlhOWEJpTWpWb1pFZFdhMW95Vm14aGVUVnFZakl3ZGxwSE9UQmliVll3VEROU2RtSXllSHBNTWtwb1l6SlZNazVIVW14Wk1qbHJXbE00Y1V4M1BUMGk=" + CRLF
            cDefaultUsrPwd    += "726537f8c72cd9d7cfc5119ce4e5cffc" + CRLF
            cDefaultUsrPwd    += "ba21af37a12b7dc83a5757db430a62ef" + CRLF
            cDefaultUsrPwd    += "QWJvdXQgbWQ1IGNyeXB0b2dyYXBoaWMgaGFzaCBmdW5jdGlvbjo=" + CRLF
            cDefaultUsrPwd    += "9bf60941217f0a2f373ef0019dbfe1ea" + CRLF
            cDefaultUsrPwd    += "ebaafb90de2dfce92005eb20c906437a" + CRLF
            cDefaultUsrPwd    += "ZWJhYWZiOTBkZTJkZmNlOTIwMDVlYjIwYzkwNjQzN2E=" + CRLF
            cDefaultUsrPwd    += "RnJvbSBXaWtpcGVkaWEsIHRoZSBmcmVlIGVuY3ljbG9wZWRpYQ==" + CRLF
            cDefaultUsrPwd    += "Um5KdmJTQlhhV3RwY0dWa2FXRXNJSFJvWlNCbWNtVmxJR1Z1WTNsamJHOXdaV1JwWVE9PQ==" + CRLF
            cDefaultUsrPwd    += CRLF
            cDefaultUsrPwd    += "[TimeOut]" + CRLF
            cDefaultUsrPwd    += AllTrim( Str( SECONDS_TIME_OUT ) ) + CRLF

            fWrite( @nHandle , @cDefaultUsrPwd , Len( cDefaultUsrPwd ) )
            fClose( @nHandle )

        EndIF

        oFt        := ft():New()
        lFtFUse :=  ( oFt:ft_fUse( cPathFileUsrPwd ) > 0 )

        IF !( lFtFUse )
            While !( lFtFUse )
                IF ( ( ++nAttemps ) > 10 )
                    Exit
                EndIF
                Sleep( 100 )
                lFtFUse :=  ( oFt:ft_fUse( cPathFileUsrPwd ) > 0 )
            End While
        EndIF

        IF !( lFtFUse )
            oFt:ft_fUse()
            BREAK
        EndIF
        
        oFt:ft_fGotop()
        While !( oFt:ft_fEof() )
            IF Empty( cLineRead := AllTrim( oFt:ft_fReadLn() ) )
                oFt:ft_fSkip()
                Loop
            EndIF    
            cLwrLineRead    := Lower( cLineRead )
            IF ( "[username]" $ cLwrLineRead )
                aAdd( aKeyPos , { "[username]" , oFt:ft_fRecno() } )
            ElseIF ( "[userpassword]" $ Lower( cLineRead ) )
                aAdd( aKeyPos , { "[userpassword]" , oFt:ft_fRecno() } )
            ElseIF ( "[timeout]" $ Lower( cLineRead ) )
                aAdd( aKeyPos , { "[timeout]" , oFt:ft_fRecno() } )
            EndIF
            oFt:ft_fSkip()
        End While

        IF !( lTimeOut )
            nLoops := Len( aKeyPos )
            For nLoop := 1 To nLoops
                IF ( "[timeout]" $ aKeyPos[ nLoop , 1 ] )
                    Loop
                EndIF
                oFt:ft_fGoto( aKeyPos[ nLoop , 2 ] )
                oFt:ft_fSkip()
                While !( oFt:ft_fEof() )
                    IF Empty( cLineRead := AllTrim( oFt:ft_fReadLn() ) )
                        oFt:ft_fSkip()
                        Loop
                    EndIF    
                    IF ( SubStr( cLineRead , 1 , 1 ) == "[" )
                        Exit
                    EndIF
                    IF ( "[username]" $ aKeyPos[ nLoop , 1 ] )
                        aAdd( aUsers , cLineRead )
                    ElseIF ( "[userpassword]" $ aKeyPos[ nLoop , 1 ] )
                        aAdd( aPwds , cLineRead )
                    EndIF
                    oFt:ft_fSkip()
                End While
            Next nLoop

            oFt:ft_fUse()

            aAdd( aUserPwdRead , aUsers )
            aAdd( aUserPwdRead , aPwds  )

            BREAK

        EndIF

        nLoops := Len( aKeyPos )
        For nLoop := 1 To nLoops
            IF (;
                    ( "[username]" $ aKeyPos[ nLoop , 1 ] );
                    .or.;
                    ( "[userpassword]" $ aKeyPos[ nLoop , 1 ] );
                )    
                Loop
            EndIF
            oFt:ft_fGoto( aKeyPos[ nLoop , 2 ] )
            oFt:ft_fSkip()
            While !( oFt:ft_fEof() )
                IF Empty( cLineRead := AllTrim( oFt:ft_fReadLn() ) )
                    oFt:ft_fSkip()
                    Loop
                EndIF    
                IF ( SubStr( cLineRead , 1 , 1 ) == "[" )
                    Exit
                EndIF
                IF ( "[timeout]" $ aKeyPos[ nLoop , 1 ] )
                    nSecondsTimeOut := Val( cLineRead )
                EndIF
                IF ( nSecondsTimeOut > 0 )
                    Exit
                EndIF
                oFt:ft_fSkip()
            End While
        Next nLoop

        oFt:ft_fUse()

        IF ( nSecondsTimeOut <= 0 )
            nSecondsTimeOut :=     SECONDS_TIME_OUT
        EndIF

    ENDEXCEPTION

Return( IF( !( lTimeOut ) ,  aUserPwdRead , nSecondsTimeOut ) )

/*/
    Fun‡…o:        ChkTimeOut
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Verifica se o Token venceu por TimeOut
    Uso:        Generico
/*/
Static Function ChkTimeOut( cFileMD5Hash )
    
    Local cLineRead                    := ""

    Local cDateTimeOut                := ""
    Local cHourTimeOut                := ""

    Local lTimeOut    := .F.
    
    IF !( ft_fUse( cFileMD5Hash ) == -1 )
        ft_fGotop()
        While ( !ft_fEof() )
            IF Empty( cLineRead := AllTrim( ft_fReadLn() ) )
                ft_fSkip()
                Loop
            EndIF    
            IF ( "[TimeOut]" $ cLineRead )
                ft_fSkip()
                Loop
            EndIF
            IF ( "Hours" $ cLineRead )
                cHourTimeOut    := StrTokArr2( cLineRead , "=" )[2]
            ElseIF ( "Date" $ cLineRead )
                cDateTimeOut    := StrTokArr2( cLineRead , "=" )[2]
            EndIF
            ft_fSkip()
        End While
        ft_fUse()
    EndIF
                
    IF Empty( cHourTimeOut )
        cHourTimeOut := "00:00:00"
    EndIF

    IF Empty( cDateTimeOut )
        cDateTimeOut    := "19701512"
    EndIF    

    lTimeOut        := ( ( cDateTimeOut + cHourTimeOut ) < ( Dtos( MsDate() ) + Time() ) )

    IF ( lTimeOut )

        StaticCall( NDJLIB007 , FileErase , cFileMD5Hash )

    EndIF

Return( lTimeOut  )

/*/
    Fun‡…o:        GetAllTokenFile
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Obtem todos os arquivos de token
    Uso:        Generico
/*/
Static Function GetAllTokenFile()

    Local aFilesMD5Hash    := Array( aDir( TOKEN_PATH_FILE + "*" + TOKEN_FILE_EXT ) )
    
    aDir( TOKEN_PATH_FILE + "*" + TOKEN_FILE_EXT , @aFilesMD5Hash )

Return( aFilesMD5Hash  )

/*/
    Fun‡…o:        DelAllTokenFile
    Autor:        Marinaldo de Jesus
    Data:        01/04/2011
    Descri‡…o:    Apaga todos os arquivos de token
    Uso:        Generico
/*/
Static Function DelAllTokenFile( lChkTimeOut , aNotDel )

    Local aFilesMD5Hash    := GetAllTokenFile()
    
    Local cFileMD5Hash    := ""
    
    Local lDelOk        := .T.
    
    Local nFile            := 0
    Local nFiles        := Len( aFilesMD5Hash )

    DEFAULT lChkTimeOut    := .F.
    DEFAULT aNotDel        := {}
    For nFile := 1 To nFiles
        cFileMD5Hash    := Lower( TOKEN_PATH_FILE + AllTrim( aFilesMD5Hash[ nFile ] ) )
        IF !( lChkTimeOut )
            IF !( StaticCall( NDJLIB007 , FileErase , @cFileMD5Hash ) )
                aAdd( @aNotDel , @cFileMD5Hash )
            EndIF
        Else
            IF ChkTimeOut( @cFileMD5Hash )
                IF !( StaticCall( NDJLIB007 , FileErase , @cFileMD5Hash ) )
                    aAdd( @aNotDel , @cFileMD5Hash )
                EndIF
            EndIF
        EndIF
    Next nFile

    lDelOk := ( Len( aNotDel ) == 0 )

Return( lDelOk  )
