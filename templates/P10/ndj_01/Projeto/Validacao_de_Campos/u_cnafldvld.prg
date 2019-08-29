#INCLUDE "NDJ.CH"

/*/
    Function:    CNAContraVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNA_CONTRA
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAContraVld,<cCNAContra>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNAContraVld( cCNAContra , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local nFieldPos
    Local nCN9Order        := RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )    
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        CposInitWhen()

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_CONTRA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_CONTRA" ) );
            )
            DEFAULT cCNAContra := GdFieldGet( "CNA_CONTRA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_CONTRA" ) )
            DEFAULT cCNAContra := StaticCall(NDJLIB001,GetMemVar, "CNA_CONTRA" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_CONTRA" ) ) > 0 )
            DEFAULT cCNAContra := CNA->( FieldGet( nFieldPos ) )
        EndIF

        lFieldOk := ExistCpo( "CN9" , cCNAContra , nCN9Order )
        IF !( lFieldOk )
            BREAK
        EndIF

        IF !( lFieldOk := !Empty( cCNAContra ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNA_CONTRA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNA_CONTRA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNAContra )
                StaticCall(NDJLIB001,SetMemVar, "CNA_CONTRA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNA" )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            DEFAULT lShowHelp := .T.
            IF (;
                    !( lFieldOk );
                    .and.;
                    ( lShowHelp );
                    .and.;
                    !( Empty( cMsgHelp ) );
                )
                Help( "" , 1 , "CNA_CONTRA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNAContraWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_CONTRA pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAContraWhen)
/*/
Static Function CNAContraWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        CNAWhen()

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange    := !( IsInCallStack( "CNTA100" ) )
        IF ( lChange )
            lChange := !( IsInCallStack( "CN100Manut" ) )
            IF ( lChange )
                lChange := !( IsInCallStack( "NDJCONTRATOS" ) )
            EndIF
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_CONTRA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNAContraInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNA_CONTRA"
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAContraInit)
/*/
Static Function CNAContraInit()

    Local cCN9Numero
    Local cCNAContra

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CN9_NUMERO" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CN9_NUMERO" ) );
                )
                DEFAULT cCN9Numero := GdFieldGet( "CN9_NUMERO" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CN9_NUMERO" ) )
                DEFAULT cCN9Numero := StaticCall(NDJLIB001,GetMemVar, "CN9_NUMERO" )
            ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_NUMERO" ) ) > 0 )
                DEFAULT cCN9Numero := CN9->( FieldGet( nFieldPos ) )
            EndIF
            cCNAContra    := cCN9Numero
        Else
            cCNAContra    := Space( GETSX3Cache( "CNA_CONTRA" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_CONTRA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNAContra )

/*/
    Function:    CNARevisaVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNA_CONTRA
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNARevisaVld,<cCNARevisa>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNARevisaVld( cCNARevisa , lShowHelp , cMsgHelp )

    Local cCNAContra
    
    Local lFieldOk        := .T.

    Local nFieldPos
    Local nCN9Order        := RetOrder( "CN9" , "CN9_FILIAL+CN9_NUMERO+CN9_REVISA" )
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        CposInitWhen()

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_CONTRA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_CONTRA" ) );
            )
            cCNAContra := GdFieldGet( "CNA_CONTRA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_CONTRA" ) )
            cCNAContra := StaticCall(NDJLIB001,GetMemVar, "CNA_CONTRA" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_CONTRA" ) ) > 0 )
            cCNAContra := CNA->( FieldGet( nFieldPos ) )
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_REVISA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_REVISA" ) );
            )
            DEFAULT cCNARevisa := GdFieldGet( "CNA_REVISA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_REVISA" ) )
            DEFAULT cCNARevisa := StaticCall(NDJLIB001,GetMemVar, "CNA_REVISA" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_REVISA" ) ) > 0 )
            DEFAULT cCNARevisa := CNA->( FieldGet( nFieldPos ) )
        EndIF

        lFieldOk := ExistCpo( "CN9" , cCNAContra+cCNARevisa , nCN9Order )
        IF !( lFieldOk )
            BREAK
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNARevisa )
                StaticCall(NDJLIB001,SetMemVar, "CNA_REVISA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNA" )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            DEFAULT lShowHelp := .T.
            IF (;
                    !( lFieldOk );
                    .and.;
                    ( lShowHelp );
                    .and.;
                    !( Empty( cMsgHelp ) );
                )
                Help( "" , 1 , "CNA_CONTRA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNARevisaWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_CONTRA pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNARevisaWhen)
/*/
Static Function CNARevisaWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        CNAWhen()

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange    := !( IsInCallStack( "CNTA100" ) )
        IF ( lChange )
            lChange := !( IsInCallStack( "CN100Manut" ) )
            IF ( lChange )
                lChange := !( IsInCallStack( "NDJCONTRATOS" ) )
            EndIF
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_REVISA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNARevisaInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNA_CONTRA"
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNARevisaInit)
/*/
Static Function CNARevisaInit()

    Local cCN9Revisa
    Local cCNARevisa

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CN9_REVISA" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CN9_REVISA" ) );
                )
                DEFAULT cCN9Revisa := GdFieldGet( "CN9_REVISA" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CN9_REVISA" ) )
                DEFAULT cCN9Revisa := StaticCall(NDJLIB001,GetMemVar, "CN9_REVISA" )
            ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_REVISA" ) ) > 0 )
                DEFAULT cCN9Revisa := CN9->( FieldGet( nFieldPos ) )
            EndIF
            cCNARevisa    := cCN9Revisa
        Else
            cCNARevisa    := Space( GETSX3Cache( "CNA_REVISA" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_REVISA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNARevisa )

/*/
    Function:    CNAFornecVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNA_FORNEC
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAFornecVld,<cCNAFornec>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNAFornecVld( cCNAFornec , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local nFieldPos
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        CposInitWhen()

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_FORNEC" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_FORNEC" ) );
            )
            DEFAULT cCNAFornec := GdFieldGet( "CNA_FORNEC" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_FORNEC" ) )
            DEFAULT cCNAFornec := StaticCall(NDJLIB001,GetMemVar, "CNA_FORNEC" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_FORNEC" ) ) > 0 )
            DEFAULT cCNAFornec := CNA->( FieldGet( nFieldPos ) )
        EndIF

        IF !( lFieldOk := !Empty( cCNAFornec ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNA_FORNEC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNA_FORNEC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNAFornec )
                StaticCall(NDJLIB001,SetMemVar, "CNA_FORNEC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNA" )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            DEFAULT lShowHelp := .T.
            IF (;
                    !( lFieldOk );
                    .and.;
                    ( lShowHelp );
                    .and.;
                    !( Empty( cMsgHelp ) );
                )
                Help( "" , 1 , "CNA_FORNEC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNAFornecWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_FORNEC pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAFornecWhen)
/*/
Static Function CNAFornecWhen()

    Local cCNAFornec
    Local cCNAClient
    Local cCNALojaCL

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        CNAWhen()

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )
        
        IF !( lChange )
            BREAK
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_CLIENT" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_CLIENT" ) );
            )
            DEFAULT cCNAClient := GdFieldGet( "CNA_CLIENT" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_CLIENT" ) )
            DEFAULT cCNAClient := StaticCall(NDJLIB001,GetMemVar, "CNA_CLIENT" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_CLIENT" ) ) > 0 )
            DEFAULT cCNAClient := CNA->( FieldGet( nFieldPos ) )
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_LOJACL" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_LOJACL" ) );
            )
            DEFAULT cCNALojaCL := GdFieldGet( "CNA_LOJACL" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_LOJACL" ) )
            DEFAULT cCNALojaCL := StaticCall(NDJLIB001,GetMemVar, "CNA_LOJACL" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_LOJACL" ) ) > 0 )
            DEFAULT cCNALojaCL := CNA->( FieldGet( nFieldPos ) )
        EndIF

        lChange := ( Empty( cCNAClient ) .and. Empty( cCNALojaCL ) )

        IF ( lChange )

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CNA_FORNEC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_FORNEC" ) );
                )
                DEFAULT cCNAFornec := GdFieldGet( "CNA_FORNEC" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_FORNEC" ) )
                DEFAULT cCNAFornec := StaticCall(NDJLIB001,GetMemVar, "CNA_FORNEC" )
            ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_FORNEC" ) ) > 0 )
                DEFAULT cCNAFornec := CNA->( FieldGet( nFieldPos ) )
            EndIF

            lChange    := ( GetNewPar( "NDJ_CNAFOR" , .F. ) .or. Empty( cCNAFornec ) )

            IF !( lChange )
                BREAK
            EndIF
           
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_FORNEC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNAFornecInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNA_FORNEC"
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAFornecInit)
/*/
Static Function CNAFornecInit()

    Local cCNAFornec
    Local nFieldPos

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJADITIVOS" ) )
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" , oGetDad1:aHeader , oGetDad1:aCols , oGetDad1:nAt );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_CODIGO" ) );
                )
                cCNAFornec := GdFieldGet( "CNC_CODIGO" , oGetDad1:nAt , .F. , oGetDad1:aHeader , oGetDad1:aCols )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNC_CODIGO" ) )
                cCNAFornec := StaticCall( NDJLIB001 , GetMemVar , "CNC_CODIGO" )
            ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_CODIGO" ) ) > 0 )
                cCNAFornec := CNC->( FieldGet( nFieldPos ) )
            EndIF
        ElseIF ( IsInCallStack( "NDJCONTRATOS" ) )
            cCNAFornec    := SC7->C7_FORNECE
        Else
            cCNAFornec    := Space( GETSX3Cache( "CNA_FORNEC" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_FORNEC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConCout( CaptureError())
        EndIF

    ENDEXCEPTION

Return( cCNAFornec )

/*/
    Function:    CNALjFornVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNA_LJFORN
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNALjFornVld,<cCNALjForn>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNALjFornVld( cCNALjForn , lShowHelp , cMsgHelp )
    
    Local lFieldOk        := .T.

    Local nFieldPos
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        CposInitWhen()

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_LJFORN" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_LJFORN" ) );
            )
            DEFAULT cCNALjForn := GdFieldGet( "CNA_LJFORN" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_LJFORN" ) )
            DEFAULT cCNALjForn := StaticCall(NDJLIB001,GetMemVar, "CNA_LJFORN" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_LJFORN" ) ) > 0 )
            DEFAULT cCNALjForn := CNA->( FieldGet( nFieldPos ) )
        EndIF

        IF !( lFieldOk := !Empty( cCNALjForn ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNA_LJFORN" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNA_LJFORN )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNALjForn )
                StaticCall(NDJLIB001,SetMemVar, "CNA_LJFORN" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNA" )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            DEFAULT lShowHelp := .T.
            IF (;
                    !( lFieldOk );
                    .and.;
                    ( lShowHelp );
                    .and.;
                    !( Empty( cMsgHelp ) );
                )
                Help( "" , 1 , "CNA_LJFORN" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNALjFornWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_LJFORN pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNALjFornWhen)
/*/
Static Function CNALjFornWhen()

    Local cCNALjForn
    Local cCNAClient
    Local cCNALojaCL
    
    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        CNAWhen()

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

        IF !( lChange )
            BREAK
        EndIF
        
        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_CLIENT" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_CLIENT" ) );
            )
            DEFAULT cCNAClient := GdFieldGet( "CNA_CLIENT" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_CLIENT" ) )
            DEFAULT cCNAClient := StaticCall(NDJLIB001,GetMemVar, "CNA_CLIENT" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_CLIENT" ) ) > 0 )
            DEFAULT cCNAClient := CNA->( FieldGet( nFieldPos ) )
        EndIF
        
        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNA_LOJACL" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_LOJACL" ) );
            )
            DEFAULT cCNALojaCL := GdFieldGet( "CNA_LOJACL" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_LOJACL" ) )
            DEFAULT cCNALojaCL := StaticCall(NDJLIB001,GetMemVar, "CNA_LOJACL" )
        ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_LOJACL" ) ) > 0 )
            DEFAULT cCNALojaCL := CNA->( FieldGet( nFieldPos ) )
        EndIF
        
        lChange    := ( Empty( cCNAClient ) .and. Empty( cCNALojaCL ) )

        IF ( lChange )

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CNA_LJFORN" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNA_LJFORN" ) );
                )
                DEFAULT cCNALjForn := GdFieldGet( "CNA_LJFORN" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNA_LJFORN" ) )
                DEFAULT cCNALjForn := StaticCall(NDJLIB001,GetMemVar, "CNA_LJFORN" )
            ElseIF ( CNA->( nFieldPos := FieldPos( "CNA_LJFORN" ) ) > 0 )
                DEFAULT cCNALjForn := CNA->( FieldGet( nFieldPos ) )
            EndIF

            lChange    := ( GetNewPar( "NDJ_CNAFOR" , .F. ) .or. Empty( cCNALjForn ) )

            IF !( lChange )
                BREAK
            EndIF
           
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_LJFORN" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNALjFornInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo CNA_LJFORN
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNALjFornInit)
/*/
Static Function CNALjFornInit()

    Local cCNALjForn

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            cCNALjForn    := SC7->C7_LOJA
        Else
            cCNALjForn    := Space( GETSX3Cache( "CNA_LJFORN" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNA_LJFORN" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNALjForn )

/*/
    Function:    CNATipPlaVld
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Descricao:    Validar o conteudo do campo CNA_TIPPLA
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNATipPlaVld)
/*/
Static Function CNATipPlaVld()
    CposInitWhen()
Return( .T. )

/*/
    Function:    CNATipPlaWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_TIPPLA pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNATipPlaWhen)
/*/
Static Function CNATipPlaWhen()
    CNAWhen()
Return( .T. )

/*/
    Function:    CNADTIniVld
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Descricao:    Validar o conteudo do campo CNA_DTINI
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNADTIniVld)
/*/
Static Function CNADTIniVld()
    CposInitWhen()
Return( .T. )

/*/
    Function:    CNADTIniWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_DTINI pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNADTIniWhen)
/*/
Static Function CNADTIniWhen()
    CNAWhen()
Return( .T. )

/*/
    Function:    CNADTFimVld
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Descricao:    Validar o conteudo do campo CNA_DTFIM
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNADTFimVld)
/*/
Static Function CNADTFimVld()
    CposInitWhen()
Return( .T. )

/*/
    Function:    CNADTFimWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_DTFIM pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNADTFimWhen)
/*/
Static Function CNADTFimWhen()
    CNAWhen()
Return( .T. )

/*/
    Function:    CNAFlReajVld
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Descricao:    Validar o conteudo do campo CNA_FLREAJ
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAFlReajVld)
/*/
Static Function CNAFlReajVld()
    CposInitWhen()
Return( .T. )

/*/
    Function:    CNAFlReajWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNA_FLREAJ pode ser alterado
    Sintaxe:    StaticCall(U_CNAFLDVLD,CNAFlReajWhen)
/*/
Static Function CNAFlReajWhen()
    CNAWhen()
Return( .T. )

/*/
    Funcao:     CNAWhen
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Uso:        When para os campos da tabela CNA
    Sintaxe:    CNAWhen()
/*/
Static Function CNAWhen()

    Local cVar        := Upper( Alltrim( ReadVar() ) )
    Local lRet        := .T.
    Local lExecute    := .T.

    Static __cWhenLastVar__

    DEFAULT __cWhenLastVar__ := "__cWhenLastVar__"

    TRYEXCEPTION

        lExecute    := ( IsInCallStack( "CN200Manut" ) .or. IsInCallStack( "CN100INCPLA" ) .or. ( SubStr( cVar , 4 , 3 ) == "CNA" ) )

        IF !( lExecute )
            BREAK
        EndIF

        IF !( __cWhenLastVar__ == cVar )
            CposInitWhen()
        EndIF

        IF ( CposInitWhen( NIL , .T. ) )

            CNABtnCancel()

            CposInitWhen( .F. )

        EndIF

    CATCHEXCEPTION

        CposInitWhen()

    ENDEXCEPTION

    __cWhenLastVar__ := cVar

Return( lRet )

/*/
    Function:    CNABtnCancel
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Descricao:    Acao do Botao Cancelar na Inclusao de Planilhas
    Sintaxe:    CNABtnCancel()
/*/
Static Function CNABtnCancel()

    Local bAction

    Local cRpoVersion    := GetSrvProfString( "RpoVersion", "" )
    Local cNewAction    := Upper( AllTrim( "{ || Eval( bAction ) , StaticCall( U_CN200SPC , CN200SPCReset ) }" ) )

    Local oBtnCancel

    IF ( cRpoVersion == "101" )
        oBtnCancel    := GetBtn10CNA()
    ElseIF ( cRpoVersion == "110" )
        oBtnCancel    := GetBtn11CNA()
    EndIF

    IF ( ValType( oBtnCancel ) == "O" )
        bAction        := oBtnCancel:bAction
        IF !( cNewAction $ Upper( AllTrim( GetCBSource( bAction ) ) ) )
            oBtnCancel:bAction    := &( cNewAction )
        EndIF    
    EndIF    

Return( .T. )

/*/
    Funcao:     GetBtn10CNA
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Uso:        Retorna o Objeto do Botao Cancelar P10
    Sintaxe:    GetBtn10CNA()
/*/
Static Function GetBtn10CNA()

    Local aBtnBmp        := FindMsObject( "TBTNBMP" )

    Local nAt            := aScan( aBtnBmp , { |oObj| ( oObj:cCaption == "Cancelar" ) } )

    Local oBtnCancel

    IF ( nAt > 0 )
        oBtnCancel        := aBtnBmp[ nAt ]
    EndIF

Return( oBtnCancel )

/*/
    Funcao:     GetBtn11CNA
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Uso:        Retorna o Objeto do Botao Fechar P11
    Sintaxe:    GetBtn11CNA()
/*/
Static Function GetBtn11CNA()

    Local aBtnBrwButton    := FindMsObject( "TBROWSEBUTTON" )

    Local nAt            := aScan( aBtnBrwButton , { |oObj| ( oObj:cCaption == "Fechar" ) } ) 

    Local oBtnFechar

    IF ( nAt > 0 )
        oBtnFechar        := aBtnBrwButton[ nAt ]
    EndIF

Return( oBtnFechar )

/*/
    Funcao:     FindMsObject
    Autor:        Marinaldo de Jesus
    Data:        02/08/2011
    Uso:        Retornar Array com os Objetos conforme cMsClassName
    Sintaxe:    FindMsObject( cMsClassName , oWnd )
/*/
Static Function FindMsObject( cMsClassName , oWnd )
Return( StaticCall( NDJLIB016 , FindMsObject , @cMsClassName , @oWnd ) )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CNACONTRAINIT()
        CNACONTRAVLD()
        CNACONTRAWHEN()
        CNAFORNECINIT()
        CNAFORNECVLD()
        CNAFORNECWHEN()
        CNALJFORNINIT()
        CNALJFORNVLD()
        CNALJFORNWHEN()
        CNAREVISAINIT()
        CNAREVISAVLD()
        CNAREVISAWHEN()
        CNADTFIMVLD()
        CNADTFIMWHEN()
        CNADTINIVLD()
        CNADTINIWHEN()
        CNAFLREAJVLD()
        CNAFLREAJWHEN()
        CNATIPPLAVLD()
        CNATIPPLAWHEN()
           lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
