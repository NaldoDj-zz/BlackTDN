#INCLUDE "NDJ.CH"

#DEFINE STR0001 "Web Service para Atesto de Notas Fiscais NDJ"
#DEFINE STR0002 "Validar Acesso ao WS Considerando usuario e ID"
#DEFINE STR0003 "Verifica se usuario foi autenticado"
#DEFINE STR0004    "Obter as Notas Fiscais para Atesto"
#DEFINE STR0005 "Enviar as Notas Fiscais Atestadas ou Rejeitadas ( 'A'-Aguardando Atesto;'R'-Rejeitadas;'S'-Atestadas )"
#DEFINE STR0006 "Usuário Inválido: "
#DEFINE STR0007 "Usuário "
#DEFINE STR0008 " não Autenticado"
#DEFINE STR0009 "Chave Inválida: "
#DEFINE STR0010 "Não Existem Notas Fiscais a Serem Atestadas"
#DEFINE STR0011 "Não foi possível carregar os ìtens da Nota Fiscal"
#DEFINE STR0012 "Usuário não informado"
#DEFINE STR0013 "Chave não informada"
#DEFINE STR0014 "Impossível Abrir a Tabela de Itens de Notas Fiscais"
#DEFINE STR0015 "Verificar se Existem Notas Fiscais a Serem Atestadas"
#DEFINE STR0016 "Registro"
#DEFINE STR0017 "Tipo Inválido. Informe 'S' Para Notas Atestadas ou 'R' Para Notas Recusadas"
#DEFINE STR0018 " inválido. Table: "
#DEFINE STR0019 "Obter a Observação referente ao ìtem da Nota Fiscal"
#DEFINE STR0020 "Registro Inválido"
#DEFINE STR0021 "Campo Inválido"
#DEFINE STR0022 "Obter os Nomes dos Campos Memo dos Itens da Nota Fiscal"

WSSTRUCT tGetNFE
    WSDATA tHeader         AS TableView
    WSDATA tItens          AS TableView
ENDWSSTRUCT

WSSTRUCT tGetNFEs
    WSDATA NFE             AS ARRAY OF tGetNFE
    WSDATA Recno        AS STRING
ENDWSSTRUCT

WSSTRUCT tItensAtesto
    WSDATA Recno        AS STRING
    WSDATA Tipo               AS STRING
ENDWSSTRUCT

WSSTRUCT tSendNFE
    WSDATA Recno        AS STRING
    WSDATA Atesto        AS ARRAY OF tItensAtesto
    WSDATA Motivo        AS STRING OPTIONAL
ENDWSSTRUCT

WSSTRUCT tSendNFEs
    WSDATA NFE            AS tSendNFE
ENDWSSTRUCT

WSSTRUCT tMemoField
    WSDATA MEMOFIELD    AS ARRAY OF STRING
ENDWSSTRUCT

/*/
    WebService:    u_wsNDJAtestoNF
    Autor:         Marinaldo de Jesus
    Data:         02/04/2011
    Descricao:    Web Service para Atesto de Notas Fiscais
    Uso:         WebServices
/*/
WSSERVICE u_wsNDJAtestoNF DESCRIPTION STR0001 NAMESPACE "http://200.143.193.18/ws/u_wsNDJatestonf.apw" //"Web Service para Atesto de Notas Fiscais"

    WSDATA UserWs                AS STRING
    WSDATA UserID                AS STRING
    WSDATA MailID                AS BASE64BINARY

    WSDATA NFEGET                AS tGetNFEs
    WSDATA NFESEND                AS tSendNFEs
    WSDATA NFEOK                AS BOOLEAN
    WSDATA EXISTNFE                AS BOOLEAN
    
    WSDATA RECNO                AS STRING
    WSDATA NFEMEMO                AS STRING
    WSDATA NFEMEMOFIELD            AS STRING
    WSDATA MEMOFIELDS            AS tMemoField

    WSDATA lAuthenticated        AS BOOLEAN

    WSMETHOD ValidUser            DESCRIPTION STR0002 //"Validar Acesso ao WS Considerando usuario e ID"
    WSMETHOD IsAuthenticated    DESCRIPTION STR0003    //"Verifica se usuario foi autenticado"

    WSMETHOD GetNFE                DESCRIPTION STR0004    //"Obter as Notas Fiscais para Atesto"
    WSMETHOD SendNFE            DESCRIPTION STR0005 //"Enviar as Notas Fiscais Atestadas ou Rejeitadas ( 'A'-Aguardando Atesto;'R'-Rejeitadas;'S'-Atestadas )"
    WSMETHOD ExistNFE            DESCRIPTION STR0015 //"Verificar se Existem Notas Fiscais a Serem Atestadas"
    WSMETHOD GetNFEObsItem        DESCRIPTION STR0019 //"Obter a Observação referente ao ìtem da Nota Fiscal"
    WSMETHOD GetNFEMemoFields    DESCRIPTION STR0022 //"Obter os Nomes dos Campos Memo dos Itens da Nota Fiscal"

ENDWSSERVICE

/*/
    WSMETHOD:    ValidUser
    Autor:         Marinaldo de Jesus
    Data:         02/04/2011
    Descri‡…o:    Autenticar o Usuario
/*/
WSMETHOD ValidUser WSRECEIVE UserWs, MailID WSSEND UserID WSSERVICE u_wsNDJAtestoNF

    Local cMsgSoapFault
    
    Local lWsMethodRet        := .T.

    Local oException

    TRYEXCEPTION

        DEFAULT Self:UserWs        := ""
        DEFAULT UserWs            := Self:UserWs

        DEFAULT Self:MailID     := ""
        DEFAULT MailID            := Self:MailID

        IF !( Self:IsAuthenticated( UserWs , MailID ) )
            BREAK
        EndIF

        Self:UserID    := StaticCall( NDJLIB014 , UserNRetId , UserWs )
        UserID         := Self:UserID

    CATCHEXCEPTION USING oException

        lWsMethodRet     := .F.
                              
        cMsgSoapFault    := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WSMETHOD:    IsAuthenticated
    Autor:         Marinaldo de Jesus
    Data:         02/04/2011
    Descri‡…o:    Verificar se usuario foi autenticado
/*/
WSMETHOD IsAuthenticated WSRECEIVE UserWs, MailID WSSEND lAuthenticated WSSERVICE u_wsNDJAtestoNF
    
    Local aKeyID
    
    Local cKeyID
    Local cUserID
    Local cTableKey
    Local cTableName
    Local cTableIndex

    Local cMsgSoapFault

    Local lWsMethodRet        := .T.

    Local oException

    TRYEXCEPTION

        DEFAULT Self:UserWs    := ""
        DEFAULT UserWs        := Self:UserWs

        IF !( StaticCall( NDJLIB014 , UserExist , UserWs ) )
            IF Empty( UserWs )
                UserException( STR0012 )            //"Usuário não informado"
            Else    
                UserException( STR0006 + UserWs )    //"Usuário Inválido: "
            EndIF    
        EndIF

        DEFAULT Self:MailID     := ""
        DEFAULT MailID            := Self:MailID

        aKeyID    := DecodeMailID( MailID )
        IF Empty( aKeyID )
            UserException( STR0013 )            //"Chave não informada"
        EndIF
        
        cKeyID    := aKeyID[1]

        IF !( StaticCall( NDJLIB013 , FindKeyID , @cKeyID , @cTableName , @cTableIndex , @cTableKey ) )
            IF Empty( cKeyID )
                UserException( STR0013 )            //"Chave não informada"
            Else
                UserException( STR0009 + Decode64( MailID ) )    //"Chave Inválida: "
            EndIF    
        EndIF

        IF !(;
                ( AllTrim( aKeyID[2] ) == AllTrim( cTableName ) );
                .and.;
                ( AllTrim( aKeyID[3] ) == AllTrim( cTableIndex ) );
                .and.;
                ( AllTrim( aKeyID[4] ) == AllTrim( cTableKey ) );
             )    
            UserException( STR0009 + Decode64( MailID ) )    //"Chave Inválida: "
        EndIF

        cUserID     := StaticCall( NDJLIB014 , UserNRetId , UserWs )
        IF Empty( cUserID )
            UserException( STR0006  + UserWs ) //"Usuário Inválido: "
        EndIF
        Self:UserID    := cUserID

        Self:lAuthenticated := ( Self:UserID == cUserID )
        IF !( Self:lAuthenticated  )
            UserException( STR0007 + UserWs +  STR0008 ) //"Usuário "###" não Autenticado"
        EndIF

        IF !( Type( "cCadastro" ) == "C" )
            StaticCall( NDJLIB004 , SetPublic , "cCadastro" , "" )
        EndIF    

        IF !( Type( "__cUserID" ) == "C" )
            StaticCall( NDJLIB004 , SetPublic , "cCadastro" , "" )
        EndIF
        StaticCall( NDJLIB004 , SetPublic , "__cUserID" , cUserID )

        IF !( Type( "cUserName" ) == "C" )
            StaticCall( NDJLIB004 , SetPublic , "cUserName" , "" )
        EndIF
        StaticCall( NDJLIB004 , SetPublic , "cUserName" , UserWs )

        IF !( Type( "cUsuario" ) == "C" )
            StaticCall( NDJLIB004 , SetPublic , "cUsuario" , "" )
        EndIF
        StaticCall( NDJLIB004 , SetPublic , "cUsuario" , "******" + StaticCall( NDJLIB014 , UsrRetName , __cUserId ) )

    CATCHEXCEPTION USING oException

        lWsMethodRet         := .F.
        Self:lAuthenticated := .F.

        cMsgSoapFault        := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION NODELSTACKERROR

    lAuthenticated        := Self:lAuthenticated

Return( lWsMethodRet )

/*/
    WSMETHOD:    GetNFE
    Autor:         Marinaldo de Jesus
    Data:         02/04/2011
    Descri‡…o:    Obter os Dados das Notas Fiscais
/*/
WSMETHOD GetNFE WSRECEIVE UserID, MailID WSSEND NFEGET WSSERVICE u_wsNDJAtestoNF

    Local aKeyID
    Local aBagName

    Local aSF1Itens
    Local aSF1Header
    Local aSF1Cpos
    Local aSF1Recnos
    
    Local aSD1Cpos
    Local aSD1Itens
    Local aSD1Header
    Local aSD1Recnos

    Local cUserWs
    Local cAliasTmp
    Local cTempFile
        
    Local cMailID
    Local cCodUser
    Local cDBSType
    Local cSD1Alias
    Local cMsgSoapFault

    Local lWsMethodRet        := .T.

    Local nRecno
    Local nRecnos
    Local nFieldPos
    Local nNFEIndex
    Local nFieldIndex

    Local nVField
    Local nSF1Cpos
    Local nSF1Item
    Local nSF1Itens
    Local nSF1Field
    Local nSF1Fields

    Local nSD1Cpos
    Local nSD1Item
    Local nSD1Itens
    Local nSD1Field
    Local nSD1Fields

    Local oException
    
    Local uCntGet

    TRYEXCEPTION

        DEFAULT UserID    := Self:UserID
        DEFAULT MailID    := Self:MailID

        cUserWs    := StaticCall( NDJLIB014 , UsrRetName , UserID )

        IF !( Self:IsAuthenticated( cUserWs , MailID ) )
            BREAK
        EndIF
        
        aKeyID                := DecodeMailID( MailID )
        cCodUser            := UserID

        Self:NFEGET            := WsClassNew( "tGetNFEs" )
        Self:NFEGET:NFE        := {}

        Self:NFEGET:Recno    := aKeyID[Len(aKeyID)]

        ChkFile("SF1")
        aSF1Header    := SF1->( dbStruct() )
        aEval( GetSF1VCpos() , { |aField| aAdd( aSF1Header , aField ) } )
        nSF1Fields    := Len( aSF1Header )
        aSF1Cpos    := GetSF1Cpos()
        nSF1Cpos    := Len( aSF1Cpos )

        aSF1Recnos    := GetSF1Recnos()

        nSF1Itens    := Len( aSF1Recnos )
        IF ( nSF1Itens == 0 )
            UserException( STR0010 )    //"Não Existem Notas Fiscais a Serem Atestadas"
        EndIF

        cSD1Alias := GetNextAlias()
        IF !( ChkFile( "SD1" , .F. , cSD1Alias ) )
            UserException( STR0014 )    //"Impossível Abrir a Tabela de Itens de Notas Fiscais"
        EndIF
        aSD1Header    := ( cSD1Alias )->( dbStruct() )
        aHeaderSD1    := aClone( aSD1Header )
        aEval( GetSD1VCpos() , { |aField| aAdd( aSD1Header , aField ) } )
        nSD1Fields    := Len( aSD1Header )
        aSD1Cpos    := GetSD1Cpos()
        nSD1Cpos    := Len( aSD1Cpos )

        nNFEIndex    := 0
        
        For nSF1Item := 1 To nSF1Itens

            BEGIN SEQUENCE

                SF1->( dbGoto( aSF1Recnos[ nSF1Item ] ) )

                cAliasTmp            := NIL
                cTempFile            := NIL
                aBagName            := {}
                aSD1Recnos            := NIL

                IF !( StaticCall( U_MTA140MNU , BuildSD1Tmp , @cAliasTmp , @cTempFile , @aBagName , @aHeaderSD1 , "A" , @cCodUser , @aSD1Recnos ) )
                    BREAK //"Não foi possível carregar os ìtens da Nota Fiscal"
                EndIF

                StaticCall( NDJLIB007 , CloseTmpFile , @cAliasTmp , @cTempFile , @aBagName )
                
                nRecnos := Len( aSD1Recnos )

                IF ( nRecnos == 0 )
                    BREAK
                EndIF

                ++nNFEIndex
                
                aAdd( Self:NFEGET:NFE , WsClassNew( "tGetNFE" ) )
                
                Self:NFEGET:NFE[nNFEIndex]:tHeader                        := WsClassNew( "TableView" ) 
                Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct            := {}
                Self:NFEGET:NFE[nNFEIndex]:tHeader:TableData            := {}
    
                aAdd( Self:NFEGET:NFE[nNFEIndex]:tHeader:TableData , WsClassNew( "FieldView" ) )
                Self:NFEGET:NFE[nNFEIndex]:tHeader:TableData[1]:FldTag := Array( nSF1Cpos )
    
                nFieldIndex := 0
                
                For nSF1Field := 1 To nSF1Fields
                
                    IF ( ( nFieldPos := aScan( aSF1Cpos , { |cField| cField == aSF1Header[nSF1Field][DBS_NAME] } ) ) == 0 )
                        Loop
                    EndIF
                    
                    ++nFieldIndex
                
                    aAdd( Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct , WsClassNew( "FieldStruct" ) )
                    Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct[nFieldIndex]:FldName := X3Titulo( aSF1Header[nSF1Field][DBS_NAME] )
                    Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct[nFieldIndex]:FldType := aSF1Header[nSF1Field][DBS_TYPE]
                    Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct[nFieldIndex]:FldSize := aSF1Header[nSF1Field][DBS_LEN]
                    Self:NFEGET:NFE[nNFEIndex]:tHeader:TableStruct[nFieldIndex]:FldDec  := aSF1Header[nSF1Field][DBS_DEC]

                    cDBSType        := aSF1Header[nSF1Field][DBS_TYPE]
                    nVField         := aScan( GetSF1VCpos() , { |aField| aField[DBS_NAME] == aSF1Header[nSF1Field][DBS_NAME] } )

                    IF ( nVField > 0 )
                        uCntGet        := SF1->( Eval( GetSF1VCpos()[nVField][DBS_DEC+1] ) )
                    Else
                        uCntGet        := SF1->( FieldGet( nSF1Field ) )
                    EndIF    
                    Do Case
                        Case ( cDBSType == "N" )
                            uCntGet := Str( uCntGet , aSF1Header[nSF1Field][DBS_LEN] , aSF1Header[nSF1Field][DBS_DEC] )
                        Case ( cDBSType == "D" )
                            uCntGet := Dtos( uCntGet )
                        Case ( cDBSType == "L" )
                            uCntGet := IF( uCntGet , ".T." , ".F." )
                        Case ( cDBSType == "C" )
                            IF (;
                                    ( "USERLG" $ aSF1Header[nSF1Field][DBS_NAME] );
                                    .and.;
                                    !Empty( uCntGet );
                                )    
                                uCntGet := FieldUserLg( uCntGet )
                            EndIF
                    EndCase
                    
                    Self:NFEGET:NFE[nNFEIndex]:tHeader:TableData[1]:FldTag[ nFieldIndex ] := AllTrim( uCntGet )
                
                Next nSF1Field
    
                Self:NFEGET:NFE[nNFEIndex]:tItens                := WsClassNew( "TableView" ) 
                Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct    := {}
                Self:NFEGET:NFE[nNFEIndex]:tItens:TableData         := {}
    
                nFieldIndex    := 0
                
                For nSD1Field := 1 To nSD1Fields
    
                    IF ( ( nFieldPos := aScan( aSD1Cpos , { |cField| cField == aSD1Header[nSD1Field][DBS_NAME] } ) ) == 0 )
                        Loop
                    EndIF
                    
                    ++nFieldIndex
                
                    aAdd( Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct , WsClassNew( "FieldStruct" ) )
                    Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct[nFieldIndex]:FldName := X3Titulo( aSD1Header[nSD1Field][DBS_NAME] )
                    Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct[nFieldIndex]:FldType := aSD1Header[nSD1Field][DBS_TYPE]
                    Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct[nFieldIndex]:FldSize := aSD1Header[nSD1Field][DBS_LEN]
                    Self:NFEGET:NFE[nNFEIndex]:tItens:TableStruct[nFieldIndex]:FldDec  := aSD1Header[nSD1Field][DBS_DEC]
    
                Next nSD1Field
            
                nSD1Item    := 0
                For nRecno := 1 To nRecnos

                    ( cSD1Alias )->( dbGoto( aSD1Recnos[ nRecno ] ) )
                    IF ( cSD1Alias )->( Eof() .or. Bof() )
                        Loop
                    EndIF
                
                    ++nSD1Item
    
                    aAdd( Self:NFEGET:NFE[nNFEIndex]:tItens:TableData , WsClassNew( "FieldView" ) )
                    
                    Self:NFEGET:NFE[nNFEIndex]:tItens:TableData[nSD1Item]:FldTag := Array( nSD1Cpos )
    
                    nFieldIndex    := 0
                    
                    For nSD1Field := 1 To nSD1Fields
    
                        IF ( ( nFieldPos := aScan( aSD1Cpos , { |cField| cField == aSD1Header[nSD1Field][DBS_NAME] } ) ) == 0 )
                            Loop
                        EndIF

                        ++nFieldIndex

                        cDBSType        := aSD1Header[nSD1Field][DBS_TYPE]
                        nVField         := aScan( GetSD1VCpos() , { |aField| aField[DBS_NAME] == aSD1Header[nSD1Field][DBS_NAME] } )

                        IF ( nVField > 0 )
                            uCntGet        := ( cSD1Alias )->( Eval( GetSD1VCpos()[nVField][DBS_DEC+1] ) )
                        Else
                            uCntGet        := ( cSD1Alias )->( FieldGet( nSD1Field ) )
                        EndIF    
                        Do Case
                            Case ( cDBSType == "N" )
                                uCntGet := Str( uCntGet , aSD1Header[nSD1Field][DBS_LEN] , aSD1Header[nSD1Field][DBS_DEC] )
                            Case ( cDBSType == "D" )
                                uCntGet := Dtos( uCntGet )
                            Case ( cDBSType == "L" )
                                uCntGet := IF( uCntGet , ".T." , ".F." )
                            Case ( cDBSType == "C" )
                                IF (;
                                        ( "USERLG" $ aSD1Header[nSD1Field][DBS_NAME] );
                                        .and.;
                                        !Empty( uCntGet );
                                    )    
                                    uCntGet := FieldUserLg( uCntGet )
                                EndIF
                        EndCase
                    
                        Self:NFEGET:NFE[nNFEIndex]:tItens:TableData[nSD1Item]:FldTag[ nFieldIndex ] := AllTrim( uCntGet )
                    
                    Next nSD1Field

                Next nRecno
            
            END SEQUENCE    
        
        Next nSF1Item
        
        IF ( Select( cSD1Alias ) > 0 )
            ( cSD1Alias )->( dbCloseArea() )
        EndIF

        NFEGET := Self:NFEGET

    CATCHEXCEPTION USING oException

        lWsMethodRet             := .F.

        cMsgSoapFault            := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WSMETHOD:    SendNFE
    Autor:         Marinaldo de Jesus
    Data:         02/04/2011
    Descri‡…o:    Efetuar o Atesto das Notas Fiscais
/*/
WSMETHOD SendNFE WSRECEIVE UserID , MailID , NFESEND WSSEND NFEOK WSSERVICE u_wsNDJAtestoNF

    Local cTipo
    Local cUserWs
    Local cObsAtesto
    Local cMsgSoapFault

    Local lWsMethodRet        := .T.
    
    Local nItem
    Local nItens
    Local nSF1Recno
    Local nSD1Recno

    Local oException

    TRYEXCEPTION

        DEFAULT UserID    := Self:UserID
        DEFAULT MailID    := Self:MailID

        cUserWs    := StaticCall( NDJLIB014 , UsrRetName , UserID )

        IF !( Self:IsAuthenticated( cUserWs , MailID ) )
            BREAK
        EndIF

        DEFAULT UserID    := Self:UserID
        DEFAULT NFESEND    := Self:NFESEND

        nSF1Recno        := Val( NFESEND:NFE:Recno )
        SF1->( dbGoto( nSF1Recno ) )
        IF SF1->( Eof() .or. Bof() )
            UserException( STR0016 + ": " + AllTrim( Str( nSF1Recno ) ) + STR0018 + RetSqlName( "SF1" ) )    //"Registro"###" inválido. Table: "
        EndIF
        
        cObsAtesto        := NFESEND:NFE:Motivo
        
        nItens := Len( NFESEND:NFE:Atesto )
        For nItem := 1 To nItens
            
            cTipo        := Upper( AllTrim( NFESEND:NFE:Atesto[ nItem ]:Tipo ) )

            IF !( cTipo $ "S/R" )
                UserException( STR0017 )    //"Tipo Inválido. Informe 'S' Para Notas Atestadas ou 'R' Para Notas Recusadas"
            EndIF

            nSD1Recno    := Val( NFESEND:NFE:Atesto[ nItem ]:Recno )

            SD1->( dbGoto( nSD1Recno ) )
            IF SD1->( Eof() .or. Bof() )
                UserException( STR0016 + ": " + AllTrim( Str( nSF1Recno ) ) + STR0018 + RetSqlName( "SD1" ) )    //"Registro"###" inválido. Table: "
            EndIF

            StaticCall( U_MTA140MNU , NDJEvalAtesto , @cTipo , @nSF1Recno , @cObsAtesto , NIL , NIL , @nSD1Recno )

        Next nItem

        Self:NFEOK        := .T.
        NFEOK            := Self:NFEOK

    CATCHEXCEPTION USING oException

        lWsMethodRet             := .F.

        Self:NFEOK                := .F.
        NFEOK                    := Self:NFEOK

        cMsgSoapFault            := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WSMETHOD:    ExistNFE
    Autor:         Marinaldo de Jesus
    Data:         23/04/2011
     Descri‡…o:    Verificar se Existem Notas a Serem Atestadas
/*/
WSMETHOD ExistNFE WSRECEIVE UserID , MailID WSSEND EXISTNFE WSSERVICE u_wsNDJAtestoNF

    Local aBagName
    Local aSF1Recnos
    Local aSD1Recnos
    Local aHeaderSD1
    
    Local cUserWs
    Local cCodUser
    Local cAliasTmp
    Local cTempFile
    Local cSD1Alias
    Local cMsgSoapFault

    Local lWsMethodRet        := .T.
    
    Local nSF1Item
    Local nSF1Itens
    Local nExistNFE
    Local nSD1Recnos

    Local oException

    TRYEXCEPTION

        Self:EXISTNFE    := .F.
        EXISTNFE        := Self:EXISTNFE
    
        DEFAULT UserID    := Self:UserID
        DEFAULT MailID    := Self:MailID

        cUserWs    := StaticCall( NDJLIB014 , UsrRetName , UserID )

        IF !( Self:IsAuthenticated( cUserWs , MailID ) )
            BREAK
        EndIF

        cCodUser        := UserID

        aSF1Recnos        := GetSF1Recnos()
        nSF1Itens        := Len( aSF1Recnos )

        BEGIN SEQUENCE
            
            IF ( nSF1Itens == 0 )
                BREAK
            EndIF

            cSD1Alias := GetNextAlias()
            IF !( ChkFile( "SD1" , .F. , cSD1Alias ) )
                UserException( STR0014 )    //"Impossível Abrir a Tabela de Itens de Notas Fiscais"
            EndIF
            aHeaderSD1    := ( cSD1Alias )->( dbStruct() )
            ( cSD1Alias )->( dbCloseArea() )

            nExistNFE    := 0
            
            For nSF1Item := 1 To nSF1Itens
                
                SF1->( dbGoto( aSF1Recnos[ nSF1Item ] ) )

                cAliasTmp    := NIL
                cTempFile    := NIL
                aBagName    := {}
                aSD1Recnos    := NIL

                IF StaticCall( U_MTA140MNU , BuildSD1Tmp , @cAliasTmp , @cTempFile , @aBagName , @aHeaderSD1 , "A" , @cCodUser , @aSD1Recnos )
                    nSD1Recnos    := Len( aSD1Recnos )
                    nExistNFE    += IF( nSD1Recnos > 0 , 1 , 0 )
                EndIF

                StaticCall( NDJLIB007 , CloseTmpFile , @cAliasTmp , @cTempFile , @aBagName )

            Next nSF1Item

            Self:EXISTNFE        := ( nExistNFE > 0 )
            EXISTNFE            := Self:EXISTNFE

        END SEQUENCE

    CATCHEXCEPTION USING oException

        lWsMethodRet             := .F.

        Self:EXISTNFE            := .F.
        NFEOK                    := Self:EXISTNFE

        cMsgSoapFault            := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

WSMETHOD GetNFEMemoFields WSRECEIVE UserID , MailID WSSEND MEMOFIELDS WSSERVICE u_wsNDJAtestoNF

    Local aNFEMemo            := {}

    Local cUserWs
    Local cMsgSoapFault

    Local lWsMethodRet        := .T.

    Local oException

    TRYEXCEPTION

        DEFAULT UserID        := Self:UserID
        DEFAULT MailID        := Self:MailID

        cUserWs                := StaticCall( NDJLIB014 , UsrRetName , UserID )

        IF !( Self:IsAuthenticated( cUserWs , MailID ) )
            BREAK
        EndIF

        IF !( ChkFile( "SD1" ) )
            UserException( STR0014 )    //"Impossível Abrir a Tabela de Itens de Notas Fiscais"
        EndIF

        Self:MEMOFIELDS                := WsClassNew( "tMemoField" )
        Self:MEMOFIELDS:MEMOFIELD    := {}

        aEval( SD1->( dbStruct() ) , { |aField| IF( aField[ DBS_TYPE ] == "M" , aAdd( aNFEMemo , aField[ DBS_NAME ] ) , NIL ) } )
        aEval( aNFEMemo , { |cField| aAdd( Self:MEMOFIELDS:MEMOFIELD , cField ) } )
        MEMOFIELDS                    := Self:MEMOFIELDS

    CATCHEXCEPTION USING oException

        lWsMethodRet    := .F.

        Self:NFEMEMO    := ""
        NFEMEMO            := Self:NFEMEMO

        cMsgSoapFault    := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    WSMETHOD:    GetNFEObsItem
    Autor:         Marinaldo de Jesus
    Data:         23/04/2011
     Descri‡…o:    Verificar se Existem Notas a Serem Atestadas
/*/
WSMETHOD GetNFEObsItem WSRECEIVE UserID , MailID , RECNO , NFEMEMOFIELD WSSEND NFEMEMO WSSERVICE u_wsNDJAtestoNF

    Local aNFEMemo                := {}

    Local cUserWs
    Local cMsgSoapFault

    Local nRecno
    Local nField

    Local lWsMethodRet            := .T.

    Local oException

    TRYEXCEPTION

        DEFAULT UserID            := Self:UserID
        DEFAULT MailID            := Self:MailID
        DEFAULT RECNO            := Self:RECNO
        DEFAULT NFEMEMOFIELD    := Self:NFEMEMOFIELD

        cUserWs                    := StaticCall( NDJLIB014 , UsrRetName , UserID )

        IF !( Self:IsAuthenticated( cUserWs , MailID ) )
            BREAK
        EndIF

        IF !( ChkFile( "SD1" ) )
            UserException( STR0014 )    //"Impossível Abrir a Tabela de Itens de Notas Fiscais"
        EndIF

        nRecno            := Val( RECNO )

        IF Empty( nRecno )
            UserException( STR0020 )    //"Registro Inválido"
        EndIF

        SD1->( MsGoto( nRecno ) )
        IF SD1->( Eof() .or. Bof() )
            UserException( STR0020 )    //"Registro Inválido"
        EndIF

        aEval( SD1->( dbStruct() ) , { |aField| IF( aField[ DBS_TYPE ] == "M" , aAdd( aNFEMemo , aField[ DBS_NAME ] ) , NIL ) } )

        NFEMEMOFIELD    := Upper( AllTrim( NFEMEMOFIELD ) )
        nField        := aScan( aNFEMemo , { |cField| ( cField == NFEMEMOFIELD ) } )
        IF ( nField == 0 )
            UserException( STR0021  )    //"Campo Inválido"
        EndIF

        Self:NFEMEMO    := NoAcento( AnsiToOem( StaticCall( NDJLIB001 , __FieldGet , "SD1" , aNFEMemo[ nField ] , .T. ) ) )
        NFEMEMO            := Self:NFEMEMO

    CATCHEXCEPTION USING oException

        lWsMethodRet    := .F.

        Self:NFEMEMO    := ""
        NFEMEMO            := Self:NFEMEMO

        cMsgSoapFault    := OemToAnsi( CaptureError( .T. ) )

        SetSoapFault( ProcName() , cMsgSoapFault )

    ENDEXCEPTION

Return( lWsMethodRet )

/*/
    Funcao:        GetSF1Recnos
    Autor:         Marinaldo de Jesus
    Data:         23/04/2011
    Descri‡…o:    Retornar Array com os Registros da Tabela SF1
/*/
Static Function GetSF1Recnos()

    Local aSF1Recnos    := {}

    Local cWhere
    Local cQFind
    Local cQRepl
    Local cQuery

    StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATESTO" , .T. , .T. , .T. )
    StaticCall( NDJLIB001 , SetMemVar , "NDJ_ATTIPO" , "A" , .T. , .T. )

    cWhere    := U_MT140FIL()
    cQFind    := "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
    cQRepl  := StrTran( cQFind , "F1_" , "WSSF1.F1_" )
    IF ( cQFind $ cWhere )
        cWhere := StrTran( cWhere , cQFind  , cQRepl )
    Else
        cQFind    := "F1_XATESTO"
        cQRepl  := "WSSF1.F1_XATESTO"
        cWhere := StrTran( cWhere , cQFind  , cQRepl )
    EndIF

    cQuery        := "SELECT "
    cQuery        += "    WSSF1.R_E_C_N_O_ AS SF1RECNO "
    cQuery        += "FROM "
    cQuery        +=         RetSqlName( "SF1" ) + " WSSF1 "
    cQuery        += "WHERE "
    cQuery        +=        cWhere

    cSF1Alias    := GetNextAlias()

    TCQUERY ( cQuery ) ALIAS ( cSF1Alias ) NEW

    While ( cSF1Alias )->( !Eof() )
        ( cSF1Alias )->( aAdd( aSF1Recnos , SF1RECNO ) )
        ( cSF1Alias )->( dbSkip() )
    End While

    ( cSF1Alias )->( dbCloseArea() )
    dbSelectArea( "SF1" )

Return( aSF1Recnos )

/*/
    Funcao:        GetSF1Cpos
    Autor:         Marinaldo de Jesus
    Data:         04/04/2011
    Descri‡…o:    Retornar os Campos para a SF1
/*/
Static Function GetSF1Cpos()

    Local aSF1Cpos := {}

    aAdd( aSF1Cpos , "F1_DOC"        )
    aAdd( aSF1Cpos , "F1_SERIE"        )
    aAdd( aSF1Cpos , "F1_FORNECE"    )
    aAdd( aSF1Cpos , "F1_LOJA"        )
    aAdd( aSF1Cpos , "F1_XATESTO"    )
    aAdd( aSF1Cpos , "F1_DUPL"        )
    aAdd( aSF1Cpos , "F1_EMISSAO"    )
    aAdd( aSF1Cpos , "F1_TIPO"        )   

    aEval( GetSF1VCpos() , { |aField| aAdd( aSF1Cpos , aField[ DBS_NAME ] ) } )

Return( aSF1Cpos )

/*/
    Funcao:        GetSF1VCpos
    Autor:         Marinaldo de Jesus
    Data:         26/04/2011
    Descri‡…o:    Retornar os Campos Virtuais para a SF1
/*/
Static Function GetSF1VCpos()

    Static aSF1VCpos := {}
    IF Empty( aSF1VCpos )
        ChkFile( "SA2" )
        aAdd( aSF1VCpos , { "R_E_C_N_O_"    , "N" , 12 , 0 , { || Recno() } } )
        aAdd( aSF1VCpos , { "A2_NOME"        , "C" , GetSx3Cache( "A2_NOME" , "X3_TAMANHO" ) , GetSx3Cache( "A2_NOME" , "X3_DECIMAL" ) , { || Posicione( "SA2" , RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" ) , xFilial( "SA2" ) + F1_FORNECE + F1_LOJA , "A2_NOME" ) } } )
    EndIF    

Return( aSF1VCpos )

/*/
    Funcao:        GetSD1Cpos
    Autor:         Marinaldo de Jesus
    Data:         04/04/2011
    Descri‡…o:    Retornar os Campos para a SD1
/*/
Static Function GetSD1Cpos()

    Local aSD1Cpos    := {}

    aAdd( aSD1Cpos , "D1_ITEM"        )
    aAdd( aSD1Cpos , "D1_XCODSBM"    )
    aAdd( aSD1Cpos , "D1_XSBM"        )
    aAdd( aSD1Cpos , "D1_COD"        )
    aAdd( aSD1Cpos , "D1_UM"        )
    aAdd( aSD1Cpos , "D1_QUANT"        )
    aAdd( aSD1Cpos , "D1_VUNIT"        )
    aAdd( aSD1Cpos , "D1_TOTAL"        )
    aAdd( aSD1Cpos , "D1_XPROJET"    )
    aAdd( aSD1Cpos , "D1_XREVIS"    )
    aAdd( aSD1Cpos , "D1_XTAREFA"    )
    aAdd( aSD1Cpos , "D1_XCODOR"    )
    aAdd( aSD1Cpos , "D1_CODORCA"     )
    aAdd( aSD1Cpos , "D1_XATESTO"    )
    aAdd( aSD1Cpos , "D1_XOBS"         )

    aEval( GetSD1VCpos() , { |aField| aAdd( aSD1Cpos , aField[ DBS_NAME ] ) } )

Return( aSD1Cpos )

/*/
    Funcao:        GetSD1VCpos
    Autor:         Marinaldo de Jesus
    Data:         26/04/2011
    Descri‡…o:    Retornar os Campos Virtuais para a SD1
/*/
Static Function GetSD1VCpos()

    Static aSD1VCpos    := {}
    
    IF Empty( aSD1VCpos )
        ChkFile( "AF8" )
        ChkFile( "AF1" ) 
        ChkFile( "SZF" )
        ChkFile( "SB1" )
        aAdd( aSD1VCpos , { "R_E_C_N_O_" , "N" , 12 , 0 , { || Recno() } } )
        aAdd( aSD1VCpos , { "AF8_DESCRI" , "C" , GetSx3Cache( "AF8_DESCRI" , "X3_TAMANHO" ) , GetSx3Cache( "AF8_DESCRI" , "X3_DECIMAL" ) , { || Posicione( "AF8" , RetOrder( "AF8" , "AF8_FILIAL+AF8_PROJET" )             , xFilial( "AF8" ) + D1_XPROJET , "AF8_DESCRI"    ) } } )
        aAdd( aSD1VCpos , { "AF1_DESCRI" , "C" , GetSx3Cache( "AF1_DESCRI" , "X3_TAMANHO" ) , GetSx3Cache( "AF1_DESCRI" , "X3_DECIMAL" ) , { || Posicione( "AF1" , RetOrder( "AF1" , "AF1_FILIAL+AF1_ORCAME" )             , xFilial( "AF1" ) + D1_CODORCA , "AF1_DESCRI"    ) } } )
        aAdd( aSD1VCpos , { "ZF_XDESORI" , "C" , GetSx3Cache( "ZF_XDESORI" , "X3_TAMANHO" ) , GetSx3Cache( "ZF_XDESORI" , "X3_DECIMAL" ) , { || Posicione( "SZF" , RetOrder( "SZF" , "ZF_FILIAL+STRZERO(ZF_XCODORI,3)" )    , xFilial( "SZF" ) + D1_XCODOR  , "ZF_XDESORI"    ) } } )
        aAdd( aSD1VCpos , { "B1_DESC"    , "C" , GetSx3Cache( "B1_DESC"    , "X3_TAMANHO" ) , GetSx3Cache( "B1_DESC"    , "X3_DECIMAL" ) , { || Posicione( "SB1" , RetOrder( "SB1" , "B1_FILIAL+B1_COD" )                    , xFilial( "SB1" ) + D1_COD      , "B1_DESC"     ) } } )
    EndIF

Return( aSD1VCpos )

/*/
    Funcao:        FieldUserLg
    Autor:         Marinaldo de Jesus
    Data:         04/04/2011
    Descri‡…o:    Tratamento para os campos USERLG
/*/
Static Function FieldUserLg( cVal )

    Local cRet := Embaralha( cVal , 1 )

    cRet := Embaralha( cRet , 1 )
    cRet := SubStr( cRet , 1 , 15 ) + "-" + Dtoc( Ctod( "01/01/96" ,"DDMMYY" ) + Load2in4( Substr( cRet , 16 ) ) )

Return( cRet )

/*/
    Funcao:        X3Titulo
    Autor:         Marinaldo de Jesus
    Data:         06/04/2011
    Descri‡…o:    Obtem o Titulo do Campo
/*/
Static Function X3Titulo( cField )

    Local cTitle

    IF ( "R_E_C_N_O_" $ cField )
        cTitle := STR0016    //"Registro"
    Else
        cTitle := AllTrim( GetSx3Cache( cField , "X3_DESCRIC" ) )
    EndIF

Return( cTitle )

/*/
    Funcao:        DecodeMailID
    Autor:         Marinaldo de Jesus
    Data:         26/04/2011
    Descri‡…o:    Decodifica o Conteudo de MailID
/*/
Static Function DecodeMailID( cMailID )

    Local cToken        := NDJ_TOKEN_MAILD
    Local aKeyID
    
    Local cKeyId        := Decode64( Decode64( cMailID ) )

    BEGIN SEQUENCE

        IF Empty( cKeyId )
            BREAK
        EndIF

        aKeyID    := StrTokArr2( cKeyId , cToken )

    END SEQUENCE

Return( aKeyID )
