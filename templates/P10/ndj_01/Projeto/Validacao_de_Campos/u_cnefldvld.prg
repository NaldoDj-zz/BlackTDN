#INCLUDE "NDJ.CH"
/*/
    Function:    CNEXNumScVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XNUMSC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumScVld,<cCNEXNumSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXNumScVld( cCNEXNumSc , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXNumSc := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XNUMSC" )

        IF !( lFieldOk := !Empty( cCNEXNumSc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XNUMSC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XNUMSC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXNumSc )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XNUMSC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XNUMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXNumScWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XNUMSC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumScWhen)
/*/
Static Function CNEXNumScWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXNumScInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XNUMSC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumScInit)
/*/
Static Function CNEXNumScInit()

    Local cCNEXNumSc

    Local oException

    TRYEXCEPTION

        cCNEXNumSc    := CNB->CNB_XNUMSC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNUMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXNumSc )

/*/
    Function:    CNEXItmScVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XITMSC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmScVld,<cCNEXItmSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXItmScVld( cCNEXItmSc , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXItmSc := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XITMSC" )

        IF !( lFieldOk := !Empty( cCNEXItmSc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XITMSC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XITMSC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXItmSc )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XITMSC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XITMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXItmScWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XITMSC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmScWhen)
/*/
Static Function CNEXItmScWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXItmScInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XITMSC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmScInit)
/*/
Static Function CNEXItmScInit()

    Local cCNEXItmSc

    Local oException

    TRYEXCEPTION

        cCNEXItmSc    := CNB->CNB_XITMSC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITMSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXItmSc )

/*/
    Function:    CNEXNumPcVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XNUMPC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumPcVld,<cCNEXNumPc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXNumPcVld( cCNEXNumPc , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXNumPc := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XNUMPC" )

        IF !( lFieldOk := !Empty( cCNEXNumPc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XNUMPC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XNUMPC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXNumPc )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XNUMPC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XNUMPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXNumPcWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XNUMPC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumPcWhen)
/*/
Static Function CNEXNumPcWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNUMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXNumPcInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XNUMPC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNumPcInit)
/*/
Static Function CNEXNumPcInit()

    Local cCNEXNumPc

    Local oException

    TRYEXCEPTION

        cCNEXNumPc    := CNB->CNB_XNUMPC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNUMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXNumPc )

/*/
    Function:    CNEXItmPcVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XITMPC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmPcVld,<cCNEXItmPc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXItmPcVld( cCNEXItmPc , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXItmPc := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XITMPC" )

        IF !( lFieldOk := !Empty( cCNEXItmPc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XITMPC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XITMPC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXItmPc )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XITMPC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XITMPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXItmPcWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XITMPC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmPcWhen)
/*/
Static Function CNEXItmPcWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXItmPcInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XITMPC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXItmPcInit)
/*/
Static Function CNEXItmPcInit()

    Local cCNEXItmPc

    Local oException

    TRYEXCEPTION

        cCNEXItmPc    := CNB->CNB_XITMPC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITMPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXItmPc )

/*/
    Function:    CNEXSeqPCVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XSEQPC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSeqPCVld,<cCNEXSeqPC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXSeqPCVld( cCNEXSeqPC , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXSeqPC := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XSEQPC" )

        IF !( lFieldOk := !Empty( cCNEXSeqPC ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XSEQPC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XSEQPC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXSeqPC )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XSEQPC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XSEQPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXSeqPCWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XSEQPC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSeqPCWhen)
/*/
Static Function CNEXSeqPCWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSEQPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXSeqPCInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XSEQPC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSeqPCInit)
/*/
Static Function CNEXSeqPCInit()

    Local cCNEXSeqPC

    Local oException

    TRYEXCEPTION

        cCNEXSeqPC    := CNB->CNB_XSEQPC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSEQPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXSeqPC )

/*/
    Function:    CNEXSZ2COVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XSZ2CO
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSZ2COVld,<cCNEXSZ2CO>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXSZ2COVld( cCNEXSZ2CO , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXSZ2CO := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XSZ2CO" )

        IF !( lFieldOk := !Empty( cCNEXSZ2CO ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XSZ2CO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XSZ2CO )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXSZ2CO )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XSZ2CO" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XSZ2CO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXSZ2COWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XSZ2CO pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSZ2COWhen)
/*/
Static Function CNEXSZ2COWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSZ2CO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXSZ2COInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XSZ2CO"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSZ2COInit)
/*/
Static Function CNEXSZ2COInit()

    Local cCNEXSZ2CO

    Local oException

    TRYEXCEPTION

        cCNEXSZ2CO    := CNB->CNB_XSZ2CO

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSZ2CO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXSZ2CO )

/*/
    Function:    CNEXCODSBVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCODSB
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODSBVld,<cCNEXCODSB>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCODSBVld( cCNEXCODSB , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCODSB := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCODSB" )

        IF !( lFieldOk := !Empty( cCNEXCODSB ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCODSB" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCODSB )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCODSB )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCODSB" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCODSB" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCODSBWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XCODSB pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODSBWhen)
/*/
Static Function CNEXCODSBWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODSB" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCODSBInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCODSB"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODSBInit)
/*/
Static Function CNEXCODSBInit()

    Local cCNEXCODSB

    Local oException

    TRYEXCEPTION

        cCNEXCODSB    := CNB->CNB_XCODSB

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODSB" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCODSB )

/*/
    Function:    CNEXSBMVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XSBM
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSBMVld,<cCNEXSBM>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXSBMVld( cCNEXSBM , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXSBM := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XSBM"  )

        IF !( lFieldOk := !Empty( cCNEXSBM ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XSBM" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XSBM )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXSBM )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XSBM" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XSBM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXSBMWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XSBM pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSBMWhen)
/*/
Static Function CNEXSBMWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSBM" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXSBMInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XSBM"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXSBMInit)
/*/
Static Function CNEXSBMInit()

    Local cCNEXSBM

    Local oException

    TRYEXCEPTION

        cCNEXSBM    := CNB->CNB_XSBM

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XSBM" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXSBM )

/*/
    Function:    CNEXPROJEVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XPROJE
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROJEVld,<cCNEXPROJE>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXPROJEVld( cCNEXPROJE , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXPROJE := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XPROJE" )

        IF !( lFieldOk := !Empty( cCNEXPROJE ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XPROJE" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XPROJE )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXPROJE )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XPROJE" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XPROJE" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXPROJEWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XPROJE pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROJEWhen)
/*/
Static Function CNEXPROJEWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XPROJE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXPROJEInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XPROJE"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROJEInit)
/*/
Static Function CNEXPROJEInit()

    Local cCNEXPROJE

    Local oException

    TRYEXCEPTION

        cCNEXPROJE    := CNB->CNB_XPROJE

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XPROJE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXPROJE )

/*/
    Function:    CNEXREVISVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XREVIS
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXREVISVld,<cCNEXREVIS>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXREVISVld( cCNEXREVIS , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXREVIS := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XREVIS" )

        IF !( lFieldOk := !Empty( cCNEXREVIS ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XREVIS" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XREVIS )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXREVIS )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XREVIS" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XREVIS" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXREVISWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XREVIS pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXREVISWhen)
/*/
Static Function CNEXREVISWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XREVIS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXREVISInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XREVIS"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXREVISInit)
/*/
Static Function CNEXREVISInit()

    Local cCNEXREVIS
    
    Local nSC1Order        := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )

    Local oException

    TRYEXCEPTION

        IF ( CNB->( FieldPos( "CNB_XREVIS" ) ) > 0 )
            cCNEXREVIS    := CNB->CNB_XREVIS
        EndIF
        IF Empty( cCNEXREVIS )
            cCNEXREVIS    := CNB->( Posicione( "SC1" , nSC1Order , xFilial( "SC1" ) + CNB_XNUMSC + CNB_XITMSC , "C1_REVISA" ) )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XREVIS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXREVIS )

/*/
    Function:    CNEXTAREFVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XTAREF
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXTAREFVld,<cCNEXTAREF>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXTAREFVld( cCNEXTAREF , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXTAREF := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XTAREF" )

        IF !( lFieldOk := !Empty( cCNEXTAREF ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XTAREF" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XTAREF )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXTAREF )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XTAREF" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XTAREF" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXTAREFWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XTAREF pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXTAREFWhen)
/*/
Static Function CNEXTAREFWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XTAREF" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXTAREFInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XTAREF"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXTAREFInit)
/*/
Static Function CNEXTAREFInit()

    Local cCNEXTAREF

    Local oException

    TRYEXCEPTION

        cCNEXTAREF    := CNB->CNB_XTAREF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XTAREF" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXTAREF )

/*/
    Function:    CNEXCODORVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCODOR
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODORVld,<cCNEXCODOR>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCODORVld( cCNEXCODOR , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCODOR := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCODOR" )

        IF !( lFieldOk := !Empty( cCNEXCODOR ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCODOR" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCODOR )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCODOR )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCODOR" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCODOR" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCODORWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XCODOR pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODORWhen)
/*/
Static Function CNEXCODORWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODOR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCODORInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCODOR"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODORInit)
/*/
Static Function CNEXCODORInit()

    Local cCNEXCODOR

    Local oException

    TRYEXCEPTION

        cCNEXCODOR    := CNB->CNB_XCODOR

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODOR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCODOR )

/*/
    Function:    CNEXCODCAVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCODCA
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODCAVld,<cCNEXCODCA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCODCAVld( cCNEXCODCA , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCODCA := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCODCA" )

        IF !( lFieldOk := !Empty( cCNEXCODCA ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCODCA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCODCA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCODCA )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCODCA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCODCA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCODCAWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XCODCA pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODCAWhen)
/*/
Static Function CNEXCODCAWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCODCAInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCODCA"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODCAInit)
/*/
Static Function CNEXCODCAInit()

    Local cCNEXCODCA

    Local oException

    TRYEXCEPTION

        cCNEXCODCA    := CNB->CNB_XCODCA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCODCA )

/*/
    Function:    CNEXINCHRVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XINCHR
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXINCHRVld,<cCNEXINCHR>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXINCHRVld( cCNEXINCHR , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException

    TRYEXCEPTION

        DEFAULT cCNEXINCHR := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XINCHR" )

        IF !( lFieldOk := !Empty( cCNEXINCHR ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XINCHR" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XINCHR )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
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
                Help( "" , 1 , "CNE_XINCHR" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk )

/*/
    Function:    CNEXINCHRWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XINCHR pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXINCHRWhen)
/*/
Static Function CNEXINCHRWhen()
    Local lChange := .F.
Return( lChange  )

/*/
    Function:    CNEXINCHRInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XINCHR"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXINCHRInit)
/*/
Static Function CNEXINCHRInit()

    Local cCNEXINCHR

    Local oException

    TRYEXCEPTION

        cCNEXINCHR    := Time()

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XINCHR" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXINCHR )

/*/
    Function:    CNEXALHRSVld
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Validar o conteudo do campo CNE_XALHRS
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXALHRSVld,<cCNEXALHRS>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXALHRSVld( cCNEXALHRS , lShowHelp , cMsgHelp )
    Local lFieldOk        := .T.
Return( lFieldOk )

/*/
    Function:    CNEXALHRSWhen
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Verificar se o campo CNE_XALHRS pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXALHRSWhen)
/*/
Static Function CNEXALHRSWhen()
    Local lChange := .F.
Return( lChange  )

/*/
    Function:    CNEXALHRSInit
    Autor:        Marinaldo de Jesus
    Data:        24/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XALHRS"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXALHRSInit)
/*/
Static Function CNEXALHRSInit()

    Local cCNEXALHRS

    Local oException

    TRYEXCEPTION

        cCNEXALHRS    := Space( GetSX3Cache( "CNE_XALHRS" , "X3_TAMANHO" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XALHRS" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXALHRS )

/*/
    Function:    CNEXEQUIPVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XEQUIP
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXEQUIPVld,<cCNEXEQUIP>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXEQUIPVld( cCNEXEQUIP , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXEQUIP := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XEQUIP" )

        IF !( lFieldOk := !Empty( cCNEXEQUIP ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XEQUIP" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XEQUIP )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXEQUIP )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XEQUIP" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XEQUIP" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXEQUIPWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XEQUIP pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXEQUIPWhen)
/*/
Static Function CNEXEQUIPWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XEQUIP" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXEQUIPInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XEQUIP"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXEQUIPInit)
/*/
Static Function CNEXEQUIPInit()

    Local cCNEXEQUIP

    Local oException

    TRYEXCEPTION

        cCNEXEQUIP    := CNB->CNB_XEQUIP

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XEQUIP" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXEQUIP )

/*/
    Function:    CNEXNRPROVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XNRPRO
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNRPROVld,<cCNEXNRPRO>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXNRPROVld( cCNEXNRPRO , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION
        
        DEFAULT cCNEXNRPRO := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XNRPRO" )

        IF !( lFieldOk := !Empty( cCNEXNRPRO ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XNRPRO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XNRPRO )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXNRPRO )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XNRPRO" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XNRPRO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXNRPROWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XNRPRO pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNRPROWhen)
/*/
Static Function CNEXNRPROWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNRPRO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXNRPROInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XNRPRO"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXNRPROInit)
/*/
Static Function CNEXNRPROInit()

    Local cCNEXNRPRO

    Local oException

    TRYEXCEPTION

        cCNEXNRPRO    := CNB->CNB_XNRPRO

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XNRPRO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXNRPRO )

/*/
    Function:    CNEXMODALVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XMODAL
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODALVld,<cCNEXMODAL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXMODALVld( cCNEXMODAL , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXMODAL := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XMODAL" )

        IF !( lFieldOk := !Empty( cCNEXMODAL ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XMODAL" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XMODAL )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXMODAL )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XMODAL" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XMODAL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXMODALWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XMODAL pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODALWhen)
/*/
Static Function CNEXMODALWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMODAL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXMODALInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XMODAL"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODALInit)
/*/
Static Function CNEXMODALInit()

    Local cCNEXMODAL

    Local oException

    TRYEXCEPTION

        cCNEXMODAL    := CNB->CNB_XMODAL

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMODAL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXMODAL )

/*/
    Function:    CNEXPROP1Vld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XPROP1
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROP1Vld,<cCNEXPROP1>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXPROP1Vld( cCNEXPROP1 , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXPROP1 := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XPROP1" )

        IF !( lFieldOk := !Empty( cCNEXPROP1 ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XPROP1" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XPROP1 )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXPROP1 )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XPROP1" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XPROP1" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXPROP1When
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XPROP1 pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROP1When)
/*/
Static Function CNEXPROP1When()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XPROP1" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXPROP1Init
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XPROP1"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXPROP1Init)
/*/
Static Function CNEXPROP1Init()

    Local cCNEXPROP1

    Local oException

    TRYEXCEPTION

        cCNEXPROP1    := CNB->CNB_XPROP1

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XPROP1" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXPROP1 )

/*/
    Function:    CNEXMARCAVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XMARCA
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMARCAVld,<cCNEXMARCA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXMARCAVld( cCNEXMARCA , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION
        
        DEFAULT cCNEXMARCA := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XMARCA" )

        IF !( lFieldOk := !Empty( cCNEXMARCA ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XMARCA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XMARCA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXMARCA )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XMARCA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XMARCA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXMARCAWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XMARCA pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMARCAWhen)
/*/
Static Function CNEXMARCAWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMARCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXMARCAInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XMARCA"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMARCAInit)
/*/
Static Function CNEXMARCAInit()

    Local cCNEXMARCA

    Local oException

    TRYEXCEPTION

        cCNEXMARCA    := CNB->CNB_XMARCA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMARCA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXMARCA )

/*/
    Function:    CNEXMODELVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XMODEL
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODELVld,<cCNEXMODEL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXMODELVld( cCNEXMODEL , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXMODEL := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XMODEL" )

        IF !( lFieldOk := !Empty( cCNEXMODEL ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XMODEL" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XMODEL )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXMODEL )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XMODEL" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XMODEL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXMODELWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XMODEL pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODELWhen)
/*/
Static Function CNEXMODELWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMODEL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXMODELInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XMODEL"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXMODELInit)
/*/
Static Function CNEXMODELInit()

    Local cCNEXMODEL

    Local oException

    TRYEXCEPTION

        cCNEXMODEL    := CNB->CNB_XMODEL

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XMODEL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXMODEL )

/*/
    Function:    CNEXGARAVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XGARA
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXGARAVld,<cCNEXGARA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXGARAVld( cCNEXGARA , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXGARA := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XGARA" )

        IF !( lFieldOk := !Empty( cCNEXGARA ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XGARA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XGARA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXGARA )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XGARA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XGARA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXGARAWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XGARA pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXGARAWhen)
/*/
Static Function CNEXGARAWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XGARA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXGARAInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XGARA"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXGARAInit)
/*/
Static Function CNEXGARAInit()

    Local cCNEXGARA

    Local oException

    TRYEXCEPTION

        cCNEXGARA    := CNB->CNB_XGARA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XGARA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXGARA )

/*/
    Function:    CNEXCCVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCCVld,<cCNEXCC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCCVld( cCNEXCC , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCC := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCC" )

        IF !( lFieldOk := !Empty( cCNEXCC ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCC )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCCWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XCC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCCWhen)
/*/
Static Function CNEXCCWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCCInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCCInit)
/*/
Static Function CNEXCCInit()

    Local cCNEXCC

    Local oException

    TRYEXCEPTION

        cCNEXCC    := CNB->CNB_XCC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCC )

/*/
    Function:    CNEXCONTAVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCONTA
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCONTAVld,<cCNEXCONTA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCONTAVld( cCNEXCONTA , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCONTA := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCONTA" )

        IF !( lFieldOk := !Empty( cCNEXCONTA ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCONTA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCONTA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCONTA )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCONTA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCONTA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCONTAWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XCONTA pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCONTAWhen)
/*/
Static Function CNEXCONTAWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCONTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCONTAInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCONTA"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCONTAInit)
/*/
Static Function CNEXCONTAInit()

    Local cCNEXCONTA

    Local oException

    TRYEXCEPTION

        cCNEXCONTA    := CNB->CNB_XCONTA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCONTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCONTA )

/*/
    Function:    CNEXITCTAVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XITCTA
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXITCTAVld,<cCNEXITCTA>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXITCTAVld( cCNEXITCTA , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXITCTA := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XITCTA" )

        IF !( lFieldOk := !Empty( cCNEXITCTA ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XITCTA" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XITCTA )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXITCTA )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XITCTA" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XITCTA" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXITCTAWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XITCTA pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXITCTAWhen)
/*/
Static Function CNEXITCTAWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITCTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXITCTAInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XITCTA"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXITCTAInit)
/*/
Static Function CNEXITCTAInit()

    Local cCNEXITCTA

    Local oException

    TRYEXCEPTION

        cCNEXITCTA    := CNB->CNB_XITCTA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XITCTA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXITCTA )

/*/
    Function:    CNEXCLVLVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCLVL
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCLVLVld,<cCNEXCLVL>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCLVLVld( cCNEXCLVL , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCLVL := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCLVL" )

        IF !( lFieldOk := !Empty( cCNEXCLVL ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_XCLVL" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_XCLVL )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCLVL )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCLVL" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCLVL" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXCLVLWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XCLVL pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCLVLWhen)
/*/
Static Function CNEXCLVLWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCLVL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCLVLInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCLVL"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCLVLInit)
/*/
Static Function CNEXCLVLInit()

    Local cCNEXCLVL

    Local oException

    TRYEXCEPTION

        cCNEXCLVL    := CNB->CNB_XCLVL

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCLVL" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCLVL )

/*/
    Function:    CNEUSERPCVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_USERPC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERPCVld,<cCNEUSERPC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEUSERPCVld( cCNEUSERPC , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEUSERPC := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_USERPC" )

        IF !( lFieldOk := !Empty( cCNEUSERPC ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_USERPC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_USERPC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEUSERPC )
                StaticCall(NDJLIB001,SetMemVar, "CNE_USERPC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_USERPC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEUSERPCWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_USERPC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERPCWhen)
/*/
Static Function CNEUSERPCWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_USERPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEUSERPCInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_USERPC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERPCInit)
/*/
Static Function CNEUSERPCInit()

    Local cCNEUSERPC

    Local oException

    TRYEXCEPTION

        cCNEUSERPC    := CNB->CNB_USERPC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_USERPC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEUSERPC )

/*/
    Function:    CNEUSERSCVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_USERSC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERSCVld,<cCNEUSERSC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEUSERSCVld( cCNEUSERSC , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEUSERSC := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_USERSC" )

        IF !( lFieldOk := !Empty( cCNEUSERSC ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_USERSC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_USERSC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEUSERSC )
                StaticCall(NDJLIB001,SetMemVar, "CNE_USERSC" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_USERSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEUSERSCWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_USERSC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERSCWhen)
/*/
Static Function CNEUSERSCWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_USERSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEUSERSCInit
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CNE_USERSC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEUSERSCInit)
/*/
Static Function CNEUSERSCInit()

    Local cCNEUSERSC

    Local oException

    TRYEXCEPTION

        cCNEUSERSC    := CNB->CNB_USERSC

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_USERSC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEUSERSC )

/*/
    Function:    CNEXCODGEInit
    Autor:        Marinaldo de Jesus
    Data:        14/01/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCODGE"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCODGEInit)
/*/
Static Function CNEXCODGEInit()

    Local cCNEXCODGE

    Local oException

    TRYEXCEPTION

        cCNEXCODGE    := CNB->CNB_XCODGE

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCODGE" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCODGE )

/*/
    Function:    CNEXVISCTInit
    Autor:        Marinaldo de Jesus
    Data:        14/01/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_XVISCT"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXVISCTInit)
/*/
Static Function CNEXVISCTInit()

    Local cCNEXVISCT

    Local oException

    TRYEXCEPTION

        cCNEXVISCT    := CNB->CNB_XVISCT

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XVISCT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXVISCT )

/*/
    Function:    CNEXCIRQTInit
    Autor:        Marinaldo de Jesus
    Data:        14/01/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_XCIRQT"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCIRQTInit)
/*/
Static Function CNEXCIRQTInit()

    Local cCNEXCIRQT

    Local oException

    TRYEXCEPTION

        cCNEXCIRQT    := CNB->CNB_XCIRQT

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCIRQT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEXCIRQT )

/*/
    Function:    CNEXCIRQTWhen
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Verificar se o campo CNE_XCIRQT pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCIRQTWhen)
/*/
Static Function CNEXCIRQTWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_XCIRQT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEXCIRQTVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XCIRQT
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXCIRQTVld,<cCNEXCIRQT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEXCIRQTVld( cCNEXCIRQT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        DEFAULT cCNEXCIRQT := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCIRQT" )

        IF ( lFieldOk := Empty( cCNEXCIRQT ) )
            BREAK
        EndIF
        
        lFieldOk    := ExistCpo( "SZ8" , cCNEXCIRQT , RetOrder("SZ8","Z8_FILIAL+Z8_CODIGO" , NIL , @lShowHelp ) )
        IF !( lFieldOk )
            BREAK
        EndIF
        
        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCNEXCIRQT )
                StaticCall(NDJLIB001,SetMemVar, "CNE_XCIRQT" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
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
                Help( "" , 1 , "CNE_XCIRQT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEXITMCQVld
    Autor:        Marinaldo de Jesus
    Data:        26/12/2010
    Descricao:    Validar o conteudo do campo CNE_XITMCQ
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEXITMCQVld)
/*/
Static Function CNEXITMCQVld( cCNEXITMCQ , lShowHelp , cMsgHelp )

    Local cCNEXCIRQT
    
    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        cCNEXCIRQT := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XCIRQT" )

        DEFAULT cCNEXITMCQ := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_XITMCQ" )

        IF ( lFieldOk := Empty( cCNEXCIRQT ) )
            BREAK
        EndIF
        
        lFieldOk    := ExistCpo( "SZ8" , cCNEXCIRQT+cCNEXITMCQ , RetOrder("SZ8","Z8_FILIAL+Z8_CODIGO+Z8_ITEM" , NIL , @lShowHelp ) )
        IF !( lFieldOk )
            BREAK
        EndIF
        
        StaticCall( U_XALTHRS , XALTHRS , "CNE" )

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
                Help( "" , 1 , "CNE_XITMCQ" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEITEGRDVld
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Validar o conteudo do campo CNE_ITEGRD
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEITEGRDVld,<cCNEITEGRD>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEITEGRDVld( cCNEITEGRD , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.

    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

        IF !( IsInCallStack( "NDJCONTRATOS" ) )
            StaticCall( U_XALTHRS , XALTHRS , "CNE" )
            BREAK
        EndIF

        DEFAULT cCNEITEGRD := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_ITEGRD" )

        IF !( lFieldOk := !Empty( cCNEITEGRD ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_ITEGRD" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_ITEGRD )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
        IF !( uLastCnt == cCNEITEGRD )
            StaticCall(NDJLIB001,SetMemVar, "CNE_ITEGRD" , uLastCnt )
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
                Help( "" , 1 , "CNE_ITEGRD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEITEGRDWhen
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Verificar se o campo CNE_ITEGRD pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEITEGRDWhen)
/*/
Static Function CNEITEGRDWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := !( IsInCallStack( "NDJCONTRATOS" ) )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_ITEGRD" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEITEGRDInit
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_ITEGRD"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEITEGRDInit)
/*/
Static Function CNEITEGRDInit()

    Local cCNEITEGRD

    Local oException

    TRYEXCEPTION

        cCNEITEGRD    := CNB->CNB_ITEGRD

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_ITEGRD" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCNEITEGRD )

/*/
    Function:    CNEQUANTVld
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Validar o conteudo do campo CNE_QUANT
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEQUANTVld,<nCNEQUANT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEQUANTVld( nCNEQUANT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , XALTHRS , "CNE" )

        DEFAULT nCNEQUANT := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_QUANT" )

        IF !( lFieldOk := !Empty( nCNEQUANT ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_QUANT" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_QUANT )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        lFieldOk    := StaticCall( U_NDJBLKSCVL , CNEQuantVld )

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
                Help( "" , 1 , "CNE_QUANT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEQUANTWhen
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Verificar se o campo CNE_QUANT pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEQUANTWhen)
/*/
Static Function CNEQUANTWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := .T.

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_QUANT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEQUANTInit
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_QUANT"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEQUANTInit)
/*/
Static Function CNEQUANTInit()

    Local nCNEQUANT

    Local oException

    TRYEXCEPTION

        nCNEQUANT    := 0

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_QUANT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( nCNEQUANT )

/*/
    Function:    CNEPERCVld
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Validar o conteudo do campo CNE_PERC
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEPERCVld,<nCNEPERC>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEPERCVld( nCNEPERC , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , XALTHRS , "CNE" )

        DEFAULT nCNEPERC := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_PERC" )

        IF !( lFieldOk := !Empty( nCNEPERC ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_PERC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_PERC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        lFieldOk    := StaticCall( U_NDJBLKSCVL , CNEQuantVld )

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
                Help( "" , 1 , "CNE_PERC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEPERCWhen
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Verificar se o campo CNE_PERC pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEPERCWhen)
/*/
Static Function CNEPERCWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := .T.

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_PERC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEPERCInit
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_PERC"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEPERCInit)
/*/
Static Function CNEPERCInit()

    Local nCNEPERC

    Local oException

    TRYEXCEPTION

        nCNEPERC    := 0

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_PERC" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( nCNEPERC )

/*/
    Function:    CNEVLUNITVld
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Validar o conteudo do campo CNE_VLUNIT
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLUNITVld,<nCNEVLUNIT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEVLUNITVld( nCNEVLUNIT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , XALTHRS , "CNE" )

        DEFAULT nCNEVLUNIT := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_VLUNIT" )

        IF !( lFieldOk := !Empty( nCNEVLUNIT ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_VLUNIT" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_VLUNIT )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        lFieldOk    := StaticCall( U_NDJBLKSCVL , CNEVLUNITVld )

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
                Help( "" , 1 , "CNE_VLUNIT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEVLUNITWhen
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Verificar se o campo CNE_VLUNIT pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLUNITWhen)
/*/
Static Function CNEVLUNITWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := .T.

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_VLUNIT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEVLUNITInit
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_VLUNIT"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLUNITInit)
/*/
Static Function CNEVLUNITInit()

    Local nCNEVLUNIT

    Local oException

    TRYEXCEPTION

        nCNEVLUNIT    := 0

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_VLUNIT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( nCNEVLUNIT )

/*/
    Function:    CNEVLTOTVld
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Validar o conteudo do campo CNE_VLTOT
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLTOTVld,<nCNEVLTOT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CNEVLTOTVld( nCNEVLTOT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , XALTHRS , "CNE" )

        DEFAULT nCNEVLTOT := StaticCall( NDJLIB001 , __FieldGet , "CNE" , "CNE_VLTOT" )

        IF !( lFieldOk := !Empty( nCNEVLTOT ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CNE_VLTOT" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CNE_VLTOT )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        lFieldOk    := StaticCall( U_NDJBLKSCVL , CNEVLUNITVld )

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
                Help( "" , 1 , "CNE_VLTOT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CNEVLTOTWhen
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Verificar se o campo CNE_VLTOT pode ser alterado
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLTOTWhen)
/*/
Static Function CNEVLTOTWhen()

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        StaticCall( U_XALTHRS , SetChkAlt )

        lChange := .T.

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_VLTOT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange  )

/*/
    Function:    CNEVLTOTInit
    Autor:        Marinaldo de Jesus
    Data:        18/04/2011
    Descricao:    Inicializadora Padrao para o Campo "CNE_VLTOT"
    Sintaxe:    StaticCall(U_CNEFLDVLD,CNEVLTOTInit)
/*/
Static Function CNEVLTOTInit()

    Local nCNEVLTOT

    Local oException

    TRYEXCEPTION

        nCNEVLTOT    := 0

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CNE_VLTOT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( nCNEVLTOT )


Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CNEUSERPCINIT()
        CNEUSERPCVLD()
        CNEUSERPCWHEN()
        CNEUSERSCINIT()
        CNEUSERSCVLD()
        CNEUSERSCWHEN()
        CNEXALHRSINIT()
        CNEXALHRSVLD()
        CNEXALHRSWHEN()
        CNEXCCINIT()
        CNEXCCVLD()
        CNEXCCWHEN()
        CNEXCIRQTINIT()
        CNEXCLVLINIT()
        CNEXCLVLVLD()
        CNEXCLVLWHEN()
        CNEXCODCAINIT()
        CNEXCODCAVLD()
        CNEXCODCAWHEN()
        CNEXCODGEINIT()
        CNEXCODORINIT()
        CNEXCODORVLD()
        CNEXCODORWHEN()
        CNEXCODSBINIT()
        CNEXCODSBVLD()
        CNEXCODSBWHEN()
        CNEXCONTAINIT()
        CNEXCONTAVLD()
        CNEXCONTAWHEN()
        CNEXEQUIPINIT()
        CNEXEQUIPVLD()
        CNEXEQUIPWHEN()
        CNEXGARAINIT()
        CNEXGARAVLD()
        CNEXGARAWHEN()
        CNEXINCHRINIT()
        CNEXINCHRVLD()
        CNEXINCHRWHEN()
        CNEXITCTAINIT()
        CNEXITCTAVLD()
        CNEXITCTAWHEN()
        CNEXITMPCINIT()
        CNEXITMPCVLD()
        CNEXITMPCWHEN()
        CNEXITMSCINIT()
        CNEXITMSCVLD()
        CNEXITMSCWHEN()
        CNEXMARCAINIT()
        CNEXMARCAVLD()
        CNEXMARCAWHEN()
        CNEXMODALINIT()
        CNEXMODALVLD()
        CNEXMODALWHEN()
        CNEXMODELINIT()
        CNEXMODELVLD()
        CNEXMODELWHEN()
        CNEXNRPROINIT()
        CNEXNRPROVLD()
        CNEXNRPROWHEN()
        CNEXNUMPCINIT()
        CNEXNUMPCVLD()
        CNEXNUMPCWHEN()
        CNEXNUMSCINIT()
        CNEXNUMSCVLD()
        CNEXNUMSCWHEN()
        CNEXPROJEINIT()
        CNEXPROJEVLD()
        CNEXPROJEWHEN()
        CNEXPROP1INIT()
        CNEXPROP1VLD()
        CNEXPROP1WHEN()
        CNEXREVISINIT()
        CNEXREVISVLD()
        CNEXREVISWHEN()
        CNEXSBMINIT()
        CNEXSBMVLD()
        CNEXSBMWHEN()
        CNEXSEQPCINIT()
        CNEXSEQPCVLD()
        CNEXSEQPCWHEN()
        CNEXSZ2COINIT()
        CNEXSZ2COVLD()
        CNEXSZ2COWHEN()
        CNEXTAREFINIT()
        CNEXTAREFVLD()
        CNEXTAREFWHEN()
        CNEXVISCTINIT()      
        CNEXCIRQTVLD()
        CNEXCIRQTWHEN()
        CNEXITMCQVld()
        CNEITEGRDINIT()
        CNEITEGRDVLD()
        CNEITEGRDWHEN()
        CNEQUANTINIT()
        CNEQUANTWHEN()
        CNEPERCINIT()
        CNEPERCVLD()
        CNEPERCWHEN()
        CNEVLTOTINIT()
        CNEVLTOTVLD()
        CNEVLTOTWHEN()
        CNEVLUNITINIT()
        CNEVLUNITWHEN()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
