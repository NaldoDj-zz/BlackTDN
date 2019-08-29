#INCLUDE "NDJ.CH"
/*/
    Function:    D1XNumScVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XNUMSC
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XNumScVld,<cD1XNumSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function D1XNumScVld( cD1XNumSc , lShowHelp , cMsgHelp )

    Local bGetNumExc
    
    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        DEFAULT cD1XNumSc := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XNUMSC" )

        IF !( lFieldOk := !Empty( cD1XNumSc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "D1_XNUMSC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_XNUMSC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        cA110Num := cD1XNumSc
        cA110Num := D1XNumScInit( cA110Num , @lFieldOk , .F. , .F. )
        IF ( lFieldOk )
            StaticCall( NDJLIB001 , SetMemVar , "D1_XNUMSC" , cA110Num )
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SD1" )

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
                Help( "" , 1 , "D1_XNUMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    D1XNumScInit
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XNUMSC
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XNumScInit,cD1XNumSc,lNumOK,lExistChav,lShowHelp)
/*/
Static Function D1XNumScInit( cD1XNumSc , lNumOK , lExistChav , lShowHelp )
    
    Local bGetNumExc    := { || cD1XNumSc := __Soma1( cD1XNumSc ) }

    Local nLoop
    Local nLoops
    Local nD1XNumSc
    Local nReplicate

    TRYEXCEPTION

        IF IsInCallStack( "NDJPreNFA" )
            nReplicate            := ( GetSx3Cache( "D1_XNUMSC" , "X3_TAMANHO" ) - 3 )
            IF Empty( cD1XNumSc )
                cD1XNumSc        := StaticCall( NDJLIB001 , QryMaxCod , "SD1" , "D1_XNUMSC" , "SUBSTRING(SD1.D1_XNUMSC,1,3)='NDJ'" , .T. )
                IF Empty( cD1XNumSc )    
                    cD1XNumSc     := "NDJ" + Replicate( "0" , nReplicate )
                EndIF
                cD1XNumSc        := Eval( bGetNumExc )
            EndIF
            SetMaxCode( NDJ_MAX_CODE )
            StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
            lNumOK                := GetNrExclOk( @cD1XNumSc , "SD1" , "D1_XNUMSC" , "D1_FILIAL+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN" , bGetNumExc , lExistChav , lShowHelp )
            IF StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" )
                nD1XNumSc        := GdFieldPos( "D1_XNUMSC" )
                nLoops            := Len( aCols )
                For nLoop := 1 To nLoops
                    IF ( nLoop == n )
                        Loop
                    EndIF
                    IF !( ValType( aCols[ nLoop ][ nD1XNumSc ] ) == GetSx3Cache( "D1_XNUMSC" , "X3_TIPO" ) )
                        aCols[ nLoop ][ nD1XNumSc ] := cD1XNumSc
                    EndIF
                    IF ( aCols[ nLoop ][ nD1XNumSc ] == cD1XNumSc )
                        cD1XNumSc    := Soma1( cD1XNumSc )
                        SetMaxCode( NDJ_MAX_CODE )
                        StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
                        lNumOK        := GetNrExclOk( @cD1XNumSc , "SD1" , "D1_XNUMSC" , "D1_FILIAL+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN" , bGetNumExc , lExistChav , lShowHelp )
                    EndIF
                Next nLoop
            EndIF
        Else
            lNumOK            := .T.
            IF Empty( cD1XNumSc )
                cD1XNumSc    := Space( GetSx3Cache( "D1_XNUMSC" , "X3_TAMANHO" ) )
            EndIF    
        EndIF    

    CATCHEXCEPTION

        ConfirmSx8()

        cD1XNumSc    := GetSX8Num( "SD1" )

        While !( StaticCall( NDJLIB003 , UseCode , "SD1" + cEmpAnt + cFilAnt + cD1XNumSc ) )
            ConfirmSx8()
            cD1XNumSc    := GetSX8Num( "SD1" )
        End While

        lNumOK    := .T.

    ENDEXCEPTION

Return( cD1XNumSc )

/*/
    Function:    D1XItemScVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XITEMSC
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XItemScVld,<cD1XItemSc>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function D1XItemScVld( cD1XItemSc , lShowHelp , cMsgHelp )

    Local bGetNumExc
    
    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        DEFAULT cD1XItemSc := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XITEMSC" )

        IF !( lFieldOk := !Empty( cD1XItemSc ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "D1_XITEMSC" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_XITEMSC )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        cD1XItemSc := D1XItemScInit( cD1XItemSc , @lFieldOk , .F. , .F. )
        IF ( lFieldOk )
            StaticCall( NDJLIB001 , SetMemVar , "D1_XITEMSC" , cD1XItemSc )
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SD1" )

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
                Help( "" , 1 , "D1_XITEMSC" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    D1XItemScInit
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XITEMSC
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XItemScInit,cD1XItemSc,lNumOK,lExistChav,lShowHelp)
/*/
Static Function D1XItemScInit( cD1XItemSc , lNumOK , lExistChav , lShowHelp )

    Local bGetNumExc    := { || cD1XItemSc := __Soma1( cD1XItemSc ) }

    Local cNumSc
    Local cSD1Filial    := xFilial( "SD1" )
    Local cPrefixKey        
    
    Local nReplicate

    TRYEXCEPTION

        IF IsInCallStack( "NDJPreNFA" )

            nReplicate            := GetSx3Cache( "D1_XITEMSC" , "X3_TAMANHO" )
            DEFAULT cD1XItemSc    := Replicate( "0" , nReplicate )

            cNumSc := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XNUMSC" )
    
            cPrefixKey            := ( cSD1Filial + cNumSc )
            SetMaxCode( NDJ_MAX_CODE )
            StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
            IF Empty( cD1XItemSc )
                cD1XItemSc := StaticCall( NDJLIB001 , QryMaxCod , "SD1" , "D1_XITEMSC" , "SD1.D1_FILIAL='" + cSD1Filial + "' AND SD1.D1_XNUMSC='"+cNumSc+"'" , .T. )
                IF Empty( cD1XItemSc )
                    cD1XItemSc    := Replicate( "0" , GetSx3Cache( "D1_XITEMSC" , "X3_TAMANHO" ) )
                EndIF
            EndIF
            lNumOK                := GetNrExclOk( @cD1XItemSc , "SD1" , "D1_XITEMSC" , "D1_FILIAL+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN" , bGetNumExc , lExistChav , lShowHelp , cPrefixKey , NIL , .F. )
        
        Else
        
            lNumOK                := .T.
            
            IF Empty( cD1XItemSc )
                cD1XItemSc        := Space( GetSx3Cache( "D1_XITEMSC" , "X3_TAMANHO" ) )
            EndIF
        
        EndIF
    
    CATCHEXCEPTION
        
        ConfirmSx8()
        
        cD1XItemSc    := GetSX8Num( "SD1" )

        While !( StaticCall( NDJLIB003 , UseCode , "SD1" + cEmpAnt + cFilAnt + cD1XItemSc ) )
            ConfirmSx8()
            cD1XItemSc    := GetSX8Num( "SD1" )
        End While

        lNumOK    := .T.

    ENDEXCEPTION

Return( cD1XItemSc )

/*/
    Function:    D1XSequenVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XSEQUEN
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XSequenVld,<cD1XSequen>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function D1XSequenVld( cD1XSequen , lShowHelp , cMsgHelp )

    Local bGetNumExc
    
    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        DEFAULT cD1XSequen := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XSEQUEN" )

        IF !( lFieldOk := !Empty( cD1XSequen ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "D1_XSEQUEN" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_XSEQUEN )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        cD1XSequen := D1XSequenInit( cD1XSequen , @lFieldOk , .F. , .F. )
        IF ( lFieldOk )
            StaticCall( NDJLIB001 , SetMemVar , "D1_XSEQUEN" , cD1XSequen )
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SD1" )

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
                Help( "" , 1 , "D1_XSEQUEN" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    D1XSequenInit
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XSEQUEN
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XSequenInit,cD1XSequen,lNumOK,lExistChav,lShowHelp)
/*/
Static Function D1XSequenInit( cD1XSequen , lNumOK , lExistChav , lShowHelp )

    Local bGetNumExc    := { || cD1XSequen := __Soma1( cD1XSequen ) }

    Local cNumSc
    Local cItemSc
    Local cPrefixKey        
    
    Local nReplicate

    TRYEXCEPTION

        IF IsInCallStack( "NDJPreNFA" )
        
            nReplicate            := GetSx3Cache( "D1_XSEQUEN" , "X3_TAMANHO" )
            DEFAULT cD1XSequen    := Replicate( "0" , nReplicate )
    
            cNumSc    := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XNUMSC" )

            cItemSc    := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XITEMSC" )
    
            cPrefixKey    := ( xFilial( "SD1" ) + cNumSc + cItemSc )
            SetMaxCode( NDJ_MAX_CODE )
            StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
            lNumOK        := GetNrExclOk( @cD1XSequen , "SD1" , "D1_XSEQUEN" , "D1_FILIAL+D1_XNUMSC+D1_XITEMSC+D1_XSEQUEN" , bGetNumExc , lExistChav , lShowHelp , cPrefixKey , NIL , .F. )
            
        Else
    
            lNumOK         := .T.
            IF Empty( cD1XSequen )
                cD1XSequen  := Space( GetSx3Cache( "D1_XSEQUEN" , "X3_TAMANHO" ) )    
            EndIF    

        EndIF            
    
    CATCHEXCEPTION

        ConfirmSx8()
        
        cD1XSequen    := GetSX8Num( "SD1" )

        While !( StaticCall( NDJLIB003 , UseCode , "SD1" + cEmpAnt + cFilAnt + cD1XSequen ) )
            ConfirmSx8()
            cD1XSequen    := GetSX8Num( "SD1" )
        End While

        lNumOK        := .T.

    ENDEXCEPTION

Return( cD1XSequen )

/*/
    Function:    D1XProp1When
    Autor:        Marinaldo de Jesus
    Data:        03/01/2011
    Descricao:    Habilitar a digitacao do campo D1_XPROP1
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XProp1When)
/*/
Static Function D1XProp1When()
    Local lWhen    := IsInCallStack( "NDJPreNFA" )
    IF ( lWhen )
        StaticCall(U_XALTHRS,SetChkAlt)
    EndIF
Return( lWhen )

/*/
    Function:    D1XEquipaWhen()
    Autor:        Marinaldo de Jesus
    Data:        03/01/2011
    Descricao:    Habilitar a digitacao do campo D1_XEQUIPA
        Sintaxe:    StaticCall(U_SD1FLDVLD,D1XEquipaWhen)
/*/
Static Function D1XEquipaWhen()
    Local lWhen    := IsInCallStack( "NDJPreNFA" )
    IF ( lWhen )
        StaticCall(U_XALTHRS,SetChkAlt)
    EndIF
Return( lWhen )
               
/*/
    Function:    D1XNUMPROWhen()
    Autor:        Marinaldo de Jesus
    Data:        03/01/2011
    Descricao:    Habilitar a digitacao do campo D1_XNUMPRO
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XNUMPROWhen)
/*/
Static Function D1XNUMPROWhen()
    Local lWhen    := IsInCallStack( "NDJPreNFA" )
    IF ( lWhen )
        StaticCall(U_XALTHRS,SetChkAlt)
    EndIF
Return( lWhen )

/*/
    Function:    D1XMODALIWhen()
    Autor:        Marinaldo de Jesus
    Data:        03/01/2011
    Descricao:    Habilitar a digitacao do campo D1_XMODALI
        Sintaxe:    StaticCall(U_SD1FLDVLD,D1XMODALIWhen)
/*/
Static Function D1XMODALIWhen()
    Local lWhen    := IsInCallStack( "NDJPreNFA" )
    IF ( lWhen )
        StaticCall(U_XALTHRS,SetChkAlt)
    EndIF
Return( lWhen )

/*/
    Funcao:     D1ProdutoVld
    Autor:        Marinaldo de Jesus
    Data:        11/01/2011
    Descricao:    Validar o Codigo do Produto D1_COD
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1ProdutoVld)
/*/
Static Function D1ProdutoVld( cD1Produto , lShowHelp , cMsgHelp )

    Local aArea            := GetArea()
    
    Local cD1CodSbm
    Local cNextAlias

    Local lFieldOk        := .T.

    Local oException

    TRYEXCEPTION

        cD1CodSbm    := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_XCODSBM" )
        cD1Produto    := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_COD" )

        cNextAlias    := GetNextAlias()

        BEGINSQL ALIAS cNextAlias
            SELECT
                B1_COD
            FROM
                %table:SB1% SB1
            WHERE
                SB1.B1_FILIAL = %exp:xFilial( "SB1" )%
            AND
                   SB1.B1_GRUPO = %exp:cD1CodSbm%
            AND
                   SB1.B1_COD = %exp:cD1Produto%
            AND
                SB1.%NotDel%
        ENDSQL

        lFieldOk    := (cNextAlias)->( !Eof() .and. !Bof() )
        IF !( lFieldOk )
            UserException( "Informação inválida para o Campo: " + cD1Produto + CRLF + " Informe um Produto de Acordo com o Tipo de Despesa" )
        EndIF
        IF ( lFieldOk )
            lFieldOk := ( cD1Produto == (cNextAlias)->B1_COD )
            IF !( lFieldOk )
                UserException( "Informação inválida para o Campo: " + cD1Produto + CRLF + " Informe um Produto de Acordo com o Tipo de Despesa" )
            EndIF
        EndIF

        (cNextAlias)->( dbCloseArea() )
        dbSelectArea( "SD1" )

        StaticCall( U_XALTHRS , XALTHRS )

    CATCHEXCEPTION USING oException

        IF (;
                !Empty( cNextAlias );
                .and.;
                ( Select( cNextAlias ) > 0 );
            )
            ( cNextAlias )->( dbCloseArea() )
            dbSelectArea( "SD1" )
        EndIF

        IF ( ValType( oException ) == "O" )
            DEFAULT cMsgHelp    := ""
            IF !Empty( cMsgHelp )
                cMsgHelp    += CRLF
            EndIF    
            cMsgHelp        += oException:Description
        EndIF

        DEFAULT lShowHelp := .T.
        IF (;
                !( lFieldOk );
                .and.;
                ( lShowHelp );
                .and.;
                !( Empty( cMsgHelp ) );
            )
            Help( "" , 1 , "D1_COD" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

    RestArea( aArea )

Return( lFieldOk )

/*/
    Funcao:     D1TesVld
    Autor:        Marinaldo de Jesus
    Data:        11/01/2011
    Descricao:    Validar o Codigo do Produto D1_TES
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1TesVld)
/*/
Static Function D1TesVld( cD1Tes , lShowHelp , cMsgHelp )

    Local aArea            := GetArea()
    
    Local cB1Filial        := xFilial( "SB1" )
    Local cD1Cod
    Local cNatureza
    
    Local lFieldOk        := .T.

    Local nSF4Order        := RetOrder( "SF4" , "F4_FILIAL+F4_CODIGO" )
    Local nSB1Order        := RetOrder( "SB1" , "B1_FILIAL+B1_COD" )

    Local oException

    TRYEXCEPTION

        cD1Tes := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_TES" )
        cD1Cod := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_COD" )
        
        IF ( Posicione( "SF4" , nSF4Order , cB1Filial + cD1Tes , "F4_ATUATF" ) == "S" )
            cNatureza := Posicione( "SB1" , nSB1Order , cB1Filial + cD1Cod , "B1_XNATURE" )
        Else
            cNatureza := Posicione( "SB1" , nSB1Order , cB1Filial + cD1Cod , "B1_XNATU02" )
        EndIF    

         MaFisAlt( "NF_NATUREZA" , cNatureza )

        StaticCall( U_XALTHRS , XALTHRS )

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            DEFAULT cMsgHelp    := ""
            IF !Empty( cMsgHelp )
                cMsgHelp    += CRLF
            EndIF    
            cMsgHelp        += oException:Description
        EndIF

        DEFAULT lShowHelp := .T.
        IF (;
                !( lFieldOk );
                .and.;
                ( lShowHelp );
                .and.;
                !( Empty( cMsgHelp ) );
            )
            Help( "" , 1 , "D1_TES" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

    RestArea( aArea )

Return( lFieldOk )

/*/
    Function:    D1XVISCTBInit
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_XVISCTB
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1XVISCTBInit,cD1XVISCTB,lNumOK,lExistChav,lShowHelp)
/*/
Static Function D1XVISCTBInit( cD1XVISCTB , lNumOK , lExistChav , lShowHelp )

    Local cMsgHelp

    Local c4aVisao
    Local cCTDFilial
    
    Local nCTDOrder
    
    Local oException

    TRYEXCEPTION
        
        IF (;
                !( Type( "cA100For" ) == "C" );
                .or.;
                Empty( cA100For );
            )    
            BREAK
        EndIF

        c4aVisao    := ( "200" + cA100For )
        cCTDFilial    := xFilial( "CTD" )
        nCTDOrder    := RetOrder( "CTD" , "CTD_FILIAL+CTD_ITEM" )
        
        CTD->( dbSetOrder( nCTDOrder ) )

        IF CTD->( !dbSeek( cCTDFilial + c4aVisao , .F. ) )
            BREAK
        EndIF    

        cD1XVISCTB := c4aVisao

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "D1_XVISCTB" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XVISCTB" ) );
            )
            GdFieldPut( "D1_XVISCTB" , cD1XVISCTB )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XVISCTB" ) )
            StaticCall( NDJLIB001 , SetMemVar , "D1_XVISCTB" , cD1XVISCTB )
        EndIF

    CATCHEXCEPTION USING oException

        IF Empty( cD1XVISCTB )
            cD1XVISCTB  := Space( GetSx3Cache( "D1_XVISCTB" , "X3_TAMANHO" ) )    
        EndIF    

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            DEFAULT lShowHelp := .T.
            IF (;
                    ( lShowHelp );
                    .and.;
                    !( Empty( cMsgHelp ) );
                )
                Help( "" , 1 , "D1_XVISCTB" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( cD1XVISCTB )

/*/
    Function:    D1QUANTVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_QUANT
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1QUANTVld,<nD1QUANT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function D1QUANTVld( nD1QUANT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        lFieldOk    := StaticCall(U_NDJBLKSCVL,D1QuantVld)
        IF !( lFieldOk )
            BREAK
        EndIF

        DEFAULT nD1QUANT := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_QUANT" )

        IF !( lFieldOk := !Empty( nD1QUANT ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "D1_QUANT" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_QUANT )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        //Atualiza As informacoes Dependentes de D1_TOTAL
        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , { "D1_TOTAL" } );
                .and.;
                ( GdFieldGet( "D1_TOTAL" ) > 0 );
            )
            lFieldOk := StaticCall( NDJLIB001 , ForceReadVar , "D1_TOTAL" )
            IF !( lFieldOk )
                cMsgHelp += "O Campo:"
                cMsgHelp += CRLF
                cMsgHelp += GetCache( "SX3" , "D1_QUANT" , NIL , "X3Titulo()" , 2 , .F. )
                cMsgHelp += " "
                cMsgHelp += "( D1_QUANT )"
                cMsgHelp += CRLF
                cMsgHelp += "Está com Conteúdo Inválido."
                UserException( cMsgHelp )
            EndIF
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SD1" )

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
                Help( "" , 1 , "D1_QUANT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    D1VUNITVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo D1_VUNIT
    Sintaxe:    StaticCall(U_SD1FLDVLD,D1VUNITVld,<nD1VUNIT>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function D1VUNITVld( nD1VUNIT , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        lFieldOk := StaticCall(U_NDJBLKSCVL,D1VUnitVld)
        IF !( lFieldOk )
            BREAK
        EndIF

        DEFAULT nD1VUNIT := StaticCall( NDJLIB001 , __FieldGet , "SD1" , "D1_VUNIT" )

        IF !( lFieldOk := !Empty( nD1VUNIT ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "D1_VUNIT" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( D1_VUNIT )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        //Atualiza As informacoes Dependentes de D1_TOTAL
        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , { "D1_TOTAL" } );
                .and.;
                ( GdFieldGet( "D1_TOTAL" ) > 0 );
            )
            lFieldOk := StaticCall( NDJLIB001 , ForceReadVar , "D1_TOTAL" )
            IF !( lFieldOk )
                cMsgHelp += "O Campo:"
                cMsgHelp += CRLF
                cMsgHelp += GetCache( "SX3" , "D1_QUANT" , NIL , "X3Titulo()" , 2 , .F. )
                cMsgHelp += " "
                cMsgHelp += "( D1_QUANT )"
                cMsgHelp += CRLF
                cMsgHelp += "Está com Conteúdo Inválido."
                UserException( cMsgHelp )
            EndIF
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SD1" )

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
                Help( "" , 1 , "D1_VUNIT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
        EndIF

    ENDEXCEPTION

Return( lFieldOk )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        D1XNumScVld()
        D1XNumScInit()
        D1XItemScVld()
        D1XItemScInit()
        D1XSequenVld()
        D1XSequenInit()
        D1XItemScVld()
        D1XSequenVld()
        D1XSequenInit()
        D1XProp1When()
        D1XEquipaWhen()
        D1XNUMPROWhen()
        D1XMODALIWhen()
        D1ProdutoVld()
        D1TesVld()
        D1XVISCTBInit()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL    
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
