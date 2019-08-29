#INCLUDE "NDJ.CH"
/*/
    Function:    CN9NumeroVld
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Validar o conteudo do campo CN9_NUMERO
    Sintaxe:    StaticCall(U_CN9FLDVLD,CN9NumeroVld,<cCN9Numero>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function CN9NumeroVld( cCN9Numero , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    Local lChkLastCnt    := .F.

    Local nRepeat
    Local nFieldPos
    
    Local oException
    
    Local uLastCnt

    TRYEXCEPTION

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

        cCN9Numero    := CN9NumeroInit( cCN9Numero , @lFieldOk , .T. )
        nRepeat        := 0
        While !( lFieldOk )
            cCN9Numero    := CN9NumeroInit( cCN9Numero , @lFieldOk , .T. )
            IF ( ( ++nRepeat ) > 50 )
                Exit
            EndIF
        End While

        uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
        lChkLastCnt    := ( uLastCnt    == cCN9Numero )
        IF !( lChkLastCnt )
            StaticCall( U_XALTHRS , SetChkAlt )    
            lChkLastCnt    := .T.
        EndIF

        IF !( lFieldOk )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CN9_NUMERO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CN9_NUMERO )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF !( lFieldOk := !Empty( cCN9Numero ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "CN9_NUMERO" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( CN9_NUMERO )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        IF ( IsInCallStack( "NDJCONTRATOS" ) )
            uLastCnt    := StaticCall( U_XALTHRS , GetChkAlt )
            IF !( uLastCnt == cCN9Numero )
                StaticCall(NDJLIB001,SetMemVar, "CN9_NUMERO" , uLastCnt )
            EndIF    
        Else
            StaticCall( U_XALTHRS , XALTHRS , "CN9" )
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
                Help( "" , 1 , "CN9_NUMERO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    CN9GetNumero
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Obter numeracao exclusiva para o CN9_NUMERO
    Sintaxe:    StaticCall(U_CN9FLDVLD,CN9GetNumero)
/*/
Static Function CN9GetNumero( cCN9Numero , lExistChav , lShowHelp )
    Local bGetNumExc    := { || cCN9Numero := __Soma1( cCN9Numero ) }
    Local cCN9Filial    := xFilial( "CN9" )
    IF Empty( cCN9Numero )
        cCN9Numero := StaticCall( NDJLIB001 , QryMaxCod , "CN9" , "CN9_NUMERO" , "CN9.CN9_FILIAL='" + cCN9Filial +"'" , .T. )
        IF Empty( cCN9Numero )
            cCN9Numero := Replicate( "0" , GetSx3Cache( "CN9_NUMERO" , "X3_TAMANHO" ) )
        EndIF
        cCN9Numero := Eval( bGetNumExc )
    EndIF
    SetMaxCode( NDJ_MAX_CODE )
    StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
Return(;
            GetNrExclOk(    @cCN9Numero                ,;
                            "CN9"                    ,;
                            "CN9_NUMERO"            ,;
                            "CN9_FILIAL+CN9_NUMERO"    ,;
                            bGetNumExc                ,;
                            lExistChav                ,;
                            lShowHelp                  ;
                        );
        )

/*/
    Function:    CN9NumeroWhen
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Verificar se o campo CN9_NUMERO pode ser alterado
    Sintaxe:    StaticCall(U_CN9FLDVLD,CN9NumeroWhen)
/*/
Static Function CN9NumeroWhen()

    Local cCN9Numero

    Local lChange        := .T.

    Local oException

    TRYEXCEPTION

        lChange := .F.

        StaticCall( U_XALTHRS , SetChkAlt )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CN9_NUMERO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( lChange )

/*/
    Function:    CN9NumeroInit
    Autor:        Marinaldo de Jesus
    Data:        25/12/2010
    Descricao:    Inicializadora Padrao para o Campo "CN9_NUMERO"
    Sintaxe:    StaticCall(U_CN9FLDVLD,CN9NumeroInit)
/*/
Static Function CN9NumeroInit( cCN9Numero , lOk , lSetMemVar )

    Local oException

    TRYEXCEPTION

        lOk    := CN9GetNumero( @cCN9Numero , .F. , .F. )

        DEFAULT lSetMemVar    := .T.
        IF ( ( lOk ) .and. ( lSetMemVar ) )
            StaticCall(NDJLIB001,SetMemVar, "CN9_NUMERO" , cCN9Numero )
        EndIF    

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "CN9_NUMERO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
        EndIF

    ENDEXCEPTION

Return( cCN9Numero )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CN9NUMEROVLD()
        CN9NUMEROWHEN()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
