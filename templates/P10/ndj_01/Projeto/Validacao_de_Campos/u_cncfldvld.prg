#INCLUDE "NDJ.CH"
/*/
    Function:    CNCCodigoVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNC_CODIGO
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCCodigoVld,<cCNCCodigo>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNCCodigoVld( cCNCCodigo , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local nFieldPos
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_CODIGO" ) );
            )
            DEFAULT cCNCCodigo := GdFieldGet( "CNC_CODIGO" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNC_CODIGO" ) )
            DEFAULT cCNCCodigo := StaticCall(NDJLIB001,GetMemVar, "CNC_CODIGO" )
        ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_CODIGO" ) ) > 0 )
            DEFAULT cCNCCodigo := CNC->( FieldGet( nFieldPos ) )
        EndIF

        IF !( lFieldOk := !Empty( cCNCCodigo ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNC_CODIGO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNC_CODIGO )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNCCodigo )
                StaticCall(NDJLIB001,SetMemVar, "CNC_CODIGO" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNC" )
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
                Help( "" , 1 , "CNC_CODIGO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNCCodigoWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNC_CODIGO pode ser alterado
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCCodigoWhen)
/*/
Static Function CNCCodigoWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNC_CODIGO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNCCodigoInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNC_CODIGO"
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCCodigoInit)
/*/
Static Function CNCCodigoInit()

    Local cCNCCodigo

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            cCNCCodigo    := SC7->C7_FORNECE
        Else
            cCNCCodigo    := Space( GETSX3Cache( "CNC_CODIGO" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNC_CODIGO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNCCodigo )

/*/
    Function:    CNCLojaVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNC_LOJA
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCLojaVld,<cCNCLoja>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNCLojaVld( cCNCLoja , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local nFieldPos
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "CNC_LOJA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_LOJA" ) );
            )
            DEFAULT cCNCLoja := GdFieldGet( "CNC_LOJA" )
        ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNC_LOJA" ) )
            DEFAULT cCNCLoja := StaticCall(NDJLIB001,GetMemVar, "CNC_LOJA" )
        ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_LOJA" ) ) > 0 )
            DEFAULT cCNCLoja := CNC->( FieldGet( nFieldPos ) )
        EndIF

        IF !( lFieldOk := !Empty( cCNCLoja ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNC_LOJA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNC_LOJA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNCLoja )
                StaticCall(NDJLIB001,SetMemVar, "CNC_LOJA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNC" )
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
                Help( "" , 1 , "CNC_LOJA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNCLojaWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNC_LOJA pode ser alterado
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCLojaWhen)
/*/
Static Function CNCLojaWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNC_LOJA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNCLojaInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo CNC_LOJA
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCLojaInit)
/*/
Static Function CNCLojaInit()

    Local cCNCLoja

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            cCNCLoja    := SC7->C7_LOJA
        Else
            cCNCLoja    := Space( GETSX3Cache( "CNC_LOJA" , "X3_TAMANHO" ) )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNC_LOJA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNCLoja )

/*/
    Function:    CNCNomeInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo CNC_NOME
    Sintaxe:    StaticCall(U_CNCFLDVLD,CNCNomeInit)
/*/
Static Function CNCNomeInit()

    Local cCNCNome
    Local cCNCLoja
    Local cCNCCodigo

    Local nSA2Order    := RetOrder( "SA2" , "A2_FILIAL+A2_COD+A2_LOJA" )

    Local oException

    TRYEXCEPTION

        IF ( IsInCallStack( "NDJADITIVOS" ) )

            IF (;
                    ( Type( "oGetDad1" ) == "O" ) .and. StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" , oGetDad1:aHeader , oGetDad1:aCols , oGetDad1:nAt );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_CODIGO" ) );
                )
                cCNCCodigo := GdFieldGet( "CNC_CODIGO" , oGetDad1:nAt , .F. , oGetDad1:aHeader , oGetDad1:aCols )
            ElseIF (;
                        StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" );
                        .and.;
                        !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_CODIGO" ) );
                    )
                    cCNCCodigo := GdFieldGet( "CNC_CODIGO" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNC_CODIGO" ) )
                cCNCCodigo := StaticCall( NDJLIB001 , GetMemVar , "CNC_CODIGO" )
            ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_CODIGO" ) ) > 0 )
                cCNCCodigo := CNC->( FieldGet( nFieldPos ) )
            EndIF

            IF (;
                    ( Type( "oGetDad1" ) == "O" ) .and. StaticCall( NDJLIB001 , IsInGetDados , "CNC_LOJA" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_LOJA" ) );
                )
                cCNCLoja := GdFieldGet( "CNC_LOJA" , oGetDad1:nAt , .F. , oGetDad1:aHeader , oGetDad1:aCols )
            ElseIF (;
                        StaticCall( NDJLIB001 , IsInGetDados , "CNC_LOJA" );
                           .and.;
                           !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_LOJA" ) );
                       )
                cCNCLoja := GdFieldGet( "CNC_LOJA" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNC_LOJA" ) )
                cCNCLoja := StaticCall(NDJLIB001,GetMemVar, "CNC_LOJA" )
            ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_LOJA" ) ) > 0 )
                cCNCLoja := CNC->( FieldGet( nFieldPos ) )
            EndIF

        ElseIF ( IsInCallStack( "NDJCONTRATOS" ) )

            cCNCCodigo    := SC7->C7_FORNECE    
            cCNCLoja    := SC7->C7_LOJA

        Else

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CNC_CODIGO" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_CODIGO" ) );
                )
                cCNCCodigo := GdFieldGet( "CNC_CODIGO" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNC_CODIGO" ) )
                cCNCCodigo := StaticCall(NDJLIB001,GetMemVar, "CNC_CODIGO" )
            ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_CODIGO" ) ) > 0 )
                cCNCCodigo := CNC->( FieldGet( nFieldPos ) )
            EndIF

            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "CNC_LOJA" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "CNC_LOJA" ) );
                )
                cCNCLoja := GdFieldGet( "CNC_LOJA" )
            ElseIF ( StaticCall(NDJLIB001,IsMemVar, "CNC_LOJA" ) )
                cCNCLoja := StaticCall(NDJLIB001,GetMemVar, "CNC_LOJA" )
            ElseIF ( CNC->( nFieldPos := FieldPos( "CNC_LOJA" ) ) > 0 )
                cCNCLoja := CNC->( FieldGet( nFieldPos ) )
            EndIF
        
        EndIF

        cCNCNome    := Posicione( "SA2" , nSA2Order , xFilial( "SA2" ) + cCNCCodigo + cCNCLoja , "A2_NOME" )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNC_LOJA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNCNome )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CNCCODIGOINIT()
        CNCCODIGOVLD()
        CNCCODIGOWHEN()
        CNCLOJAINIT()
        CNCLOJAVLD()
        CNCLOJAWHEN()
        CNCNOMEINIT()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL    
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
