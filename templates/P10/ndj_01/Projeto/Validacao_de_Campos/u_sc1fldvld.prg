#INCLUDE "NDJ.CH"
/*/
    Function:    C1NumVld
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo C1_NUM
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1NumVld,<cC1Num>,<lShowHelp>,<cMsgHelp>)
/*/
Static Function C1NumVld( cC1Num , lShowHelp , cMsgHelp )
    
    Local lFieldOk        := .T.
    
    Local oException

    TRYEXCEPTION

        IF ( Type( "cA110Num" ) == "C" )
            DEFAULT cC1Num := cA110Num
        Else
            DEFAULT cC1Num := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_CODCOMP" , .F. )
        EndIF    

        IF !( lFieldOk := !Empty( cC1Num ) )
            IF !Empty( cMsgHelp )
                cMsgHelp += CRLF
            EndIF
            DEFAULT cMsgHelp    := ""
            cMsgHelp += "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "C1_NUM" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( C1_NUM )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF

        cA110Num := cC1Num
        cA110Num := C1NumInit( cA110Num , @lFieldOk , .F. , .F. )
        IF ( lFieldOk )
            StaticCall( NDJLIB001 , SetMemVar , "C1_NUM" , cA110Num )
        EndIF

        StaticCall( U_XALTHRS , XALTHRS , "SC1" )

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
                Help( "" , 1 , "C1_NUM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Function:    C1NumInit
    Autor:        Marinaldo de Jesus
    Data:        09/12/2010
    Descricao:    Validar o conteudo do campo C1_NUM
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1NumInit,cC1Num,lNumOK,lExistChav,lShowHelp)
/*/
Static Function C1NumInit( cC1Num , lNumOK , lExistChav , lShowHelp )

    Local bGetNumExc    := { || cC1Num := __Soma1( cC1Num ) }
    Local cSC1Filial    := xFilial( "SC1" )

    TRYEXCEPTION

        IF Empty( cC1Num )
            cC1Num := StaticCall( NDJLIB001 , QryMaxCod , "SC1" , "C1_NUM" , "SC1.C1_FILIAL='" + cSC1Filial +"'" , .T. )
            IF Empty( cC1Num )
                cC1Num := Replicate( "0" , GetSx3Cache( "C1_NUM" , "X3_TAMANHO" ) )
            EndIF
            cC1Num := Eval( bGetNumExc )
        EndIF
    
        SetMaxCode( NDJ_MAX_CODE )
        StaticCall( RHLIBLCK , MySetMaxCode , NDJ_MAX_CODE )
        lNumOK        := GetNrExclOk( @cC1Num , "SC1" , "C1_NUM" , "C1_FILIAL+C1_NUM" , bGetNumExc , lExistChav , lShowHelp )

    CATCHEXCEPTION

        cC1Num    := GetSX8Num( "SC1" )

        While !( StaticCall( NDJLIB003 , UseCode , "SC1" + cEmpAnt + cFilAnt + cC1Num ) )
            ConfirmSx8()
            cC1Num    := GetSX8Num("SC1")
        End While

        lNumOK    := .T.                                                                                                                               

    ENDEXCEPTION

Return( cC1Num )

/*/
    Funcao:        C1QuantVld
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Validar se a quantidade Pode ser Alterada
    Uso:        X3_VLDUSER do campo C1_QUANT
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1QuantVld,nC1Quant,lShowHelp,cMsgHelp)
/*/
Static Function C1QuantVld( nC1Quant , lShowHelp , cMsgHelp )
    StaticCall( U_XALTHRS , XALTHRS )
Return( StaticCall( U_NDJBLKSCVL , C1QuantVld , @nC1Quant , @lShowHelp , @cMsgHelp ) )

/*/
    Funcao:        C1QuantWhen
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Verifica se a Quantidade pode ser Alterada
    Uso:        X3_WHEN do campo C1_QUANT
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1QuantWhen)
/*/
Static Function C1QuantWhen()
    Local lWhen            := .T.
    Local lC1XREFCNT    := .F.
    StaticCall(U_XALTHRS,SetChkAlt)
    IF !( Type( "ALTERA" ) == "L" )
        Private ALTERA := .F.
    EndIF
    IF ( ALTERA )
        lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .F. )
        DEFAULT lC1XREFCNT    := .F.
        lWhen                := !( lC1XREFCNT )
    EndIF
Return( lWhen )

/*/
    Funcao:        C1XPrecoVld
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Validar o Preço a ser digitado
    Uso:        X3_VLDUSER do campo C1_XPRECO
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XPrecoVld,nC1XPreco,lShowHelp,cMsgHelp)
/*/
Static Function C1XPrecoVld( nC1XPreco , lShowHelp , cMsgHelp )
    StaticCall( U_XALTHRS , XALTHRS )
Return( StaticCall( U_NDJBLKSCVL , C1XPrecoVld , @nC1XPreco , @lShowHelp , @cMsgHelp ) )

/*/
    Funcao:        C1XPrecoWhen
    Autor:        Marinaldo de Jesus
    Data:        09/11/2010
    Descricao:    Verifica se o Preco pode ser Alterada
    Uso:        X3_WHEN do campo C1_XPRECO
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XPrecoWhen)
/*/
Static Function C1XPrecoWhen()
    Local lWhen            := .T.
    Local lC1XREFCNT    := .F.
    StaticCall(U_XALTHRS,SetChkAlt)
    IF !( Type( "ALTERA" ) == "L" )
        Private ALTERA := .F.
    EndIF
    IF ( ALTERA )
        lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .F. )
        DEFAULT lC1XREFCNT    := .F.
        lWhen                := !( lC1XREFCNT )
    EndIF
Return( lWhen )

/*/
    Function:    C1XCODGEInit
    Autor:        Marinaldo de Jesus
    Data:        10/01/2011
    Descricao:    Validar o conteudo do campo C1_XCODGE
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XCODGEInit)
/*/
Static Function C1XCODGEInit()
    cC1XCODGE := AF8->AF8_XCODGE
Return( cC1XCODGE )

/*/
    Funcao:        C1XCodSbmVld
    Autor:        Marinaldo de Jesus
    Data:        10/11/2010
    Descricao:    Validar o campo C1_XCODSBM
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XCodSbmVld)
/*/
Static Function C1XCodSbmVld( cC1CodSbm , lShowHelp , cMsgHelp , lChgProduto )

    Local aArea            := GetArea()
    
    Local cCC
    Local cQuery
    Local cClasVlr
    Local cItemCta
    Local cRevisa
    Local cTarefa
    Local cProjeto
    Local cNextAlias
    Local cNewCodSbm
    Local cLastCodSbm

    Local lMemVar
    Local lGetDados
    Local lC1XCodSbmOk    := .T.

    Local nSBMOrder
    Local nFieldPos

    Local oException

    TRYEXCEPTION

        DEFAULT cC1CodSbm := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XCODSBM" , .F. )

        IF !( lC1XCodSbmOk := !Empty( cC1CodSbm ) )
            cMsgHelp := "O Campo:"
            cMsgHelp += CRLF
            cMsgHelp += GetCache( "SX3" , "C1_XCODSBM" , NIL , "X3Titulo()" , 2 , .F. )
            cMsgHelp += " "
            cMsgHelp += "( C1_XCODSBM )"
            cMsgHelp += CRLF
            cMsgHelp += "deve ser preenchido."
            UserException( cMsgHelp )
        EndIF
    
        nSBMOrder := RetOrder( "SBM" , "BM_FILIAL+BM_GRUPO" )
    
        IF !( lC1XCodSbmOk := ExistCpo( "SBM" , @cC1CodSbm , @nSBMOrder , @cMsgHelp , @lShowHelp ) )
            Break
        EndIF

        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_PROJET" )
            cProjeto    := GdFieldGet( "C1_PROJET" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_PROJET" )
            cProjeto   := StaticCall( NDJLIB001 , GetMemVar , "C1_PROJET" )
        EndIF    

        IF Empty( cProjeto )
            IF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C1_XPROJET" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XPROJET" ) );
                )
                cProjeto := GdFieldGet( "C1_XPROJET" )
            ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XPROJET" ) )
                cProjeto := StaticCall( NDJLIB001 , GetMemVar , "C1_XPROJET" )
            EndIF
        EndIF

        IF Empty( cProjeto )
            cProjeto := AF8->AF8_PROJET
        EndIF        

        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_TAREFA" )
            cTarefa    := GdFieldGet( "C1_TAREFA" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_TAREFA" )
            cTarefa    := StaticCall( NDJLIB001 , GetMemVar , "C1_TAREFA" )
        EndIF    

        IF Empty( cTarefa )
            IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XTAREFA" )
                cTarefa    := GdFieldGet( "C1_XTAREFA" )
            ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_XTAREFA" )
                cTarefa    := StaticCall( NDJLIB001 , GetMemVar , "C1_XTAREFA" )
            EndIF
        EndIF

        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_REVISA" )
            cRevisa    := GdFieldGet( "C1_REVISA" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_REVISA" )
            cRevisa    := StaticCall( NDJLIB001 , GetMemVar , "C1_REVISA" )
        EndIF    

        IF Empty( cRevisa )
            IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XREVISA" )
                cRevisa    := GdFieldGet( "C1_XREVISA" )
            ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_XREVISA" )
                cRevisa    := StaticCall( NDJLIB001 , GetMemVar , "C1_XREVISA" )
            EndIF
        EndIF

        cNextAlias    := GetNextAlias()

        cQuery    := "SELECT " + CRLF
        cQuery    += "    DISTINCT AFB_TIPOD " + CRLF
        cQuery    +=  "FROM " + CRLF
        cQuery    +=  "    " + RetSqlName( "AF8" ) +  " AF8, " + CRLF
        cQuery    +=  "    " + RetSqlName( "AFB" ) +  " AFB " + CRLF
        cQuery    +=  "WHERE " + CRLF
        cQuery    +=  "    AF8.D_E_L_E_T_ <> '*' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AFB.D_E_L_E_T_ <> '*' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AF8.AF8_FILIAL = '" + xFilial( "AF8" )  + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AFB.AFB_FILIAL = '" + xFilial( "AFB" )  + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AF8.AF8_PROJET = '" + cProjeto + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AFB.AFB_PROJET = AF8.AF8_PROJET " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AFB.AFB_TIPOD = '" + cC1CodSbm + "'" + CRLF
        IF !Empty( cTarefa )
            cQuery    +=  "AND" + CRLF
            cQuery    +=  "    AFB.AFB_TAREFA = '" + cTarefa + "' " + CRLF
        EndIF
        IF !Empty( cRevisa )
            cQuery    +=  "AND" + CRLF
            cQuery    +=  "    AFB.AFB_REVISA = '" + cRevisa + "' " + CRLF
        EndIF

        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

        lC1XCodSbmOk    := (cNextAlias)->( !Eof() .and. !Bof() )
        IF !( lC1XCodSbmOk )
            UserException( "Informação inválida para o Campo: " + cC1CodSbm )
        EndIF
        IF ( lC1XCodSbmOk )
            lC1XCodSbmOk := ( cC1CodSbm == (cNextAlias)->AFB_TIPOD )
            IF !( lC1XCodSbmOk )
                UserException( "Informação inválida para o Campo: " + cC1CodSbm )
            EndIF
        EndIF
        
        (cNextAlias)->( dbCloseArea() )
        dbSelectArea( "SC1" )

        IF ( StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODSBM" ) )
            cLastCodSbm    := GdFieldGet( "C1_XCODSBM" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XCODSBM" ) )
            cLastCodSbm    := StaticCall( NDJLIB001 , GetMemVar , "C1_XCODSBM" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XCODSBM" ) ) > 0 )
            cLastCodSbm    := SC1->( FieldGet( nFieldPos ) )
        EndIF

        DEFAULT lChgProduto    := .T.
        IF ( lChgProduto )
            cNewCodSbm := &( ReadVar() )
            IF !( cNewCodSbm == cLastCodSbm )
                lMemVar     := StaticCall( NDJLIB001 , IsMemVar , "C1_PRODUTO" )
                lGetDados    := StaticCall( NDJLIB001 , IsInGetDados , "C1_PRODUTO" ) 
                IF ( ( lMemVar ) .and. ( lGetDados ) )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_PRODUTO"     , Space( GetSx3Cache( "C1_PRODUTO" , "X3_TAMANHO" ) ) )
                    GdFieldPut( "C1_PRODUTO" , Space( GetSx3Cache( "C1_PRODUTO" , "X3_TAMANHO" ) ) )
                ElseIF ( lGetDados )
                    GdFieldPut( "C1_PRODUTO" , Space( GetSx3Cache( "C1_PRODUTO" , "X3_TAMANHO" ) ) )
                ElseIF ( lMemVar )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_PRODUTO"  , Space( GetSx3Cache( "C1_PRODUTO" , "X3_TAMANHO" ) ) )
                ElseIF ( SC1->( nFieldPos := FieldPos( "C1_PRODUTO" ) ) > 0 )
                    SC1->( FieldPut( nFieldPos , Space( GetSx3Cache( "C1_PRODUTO" , "X3_TAMANHO" ) ) ) )
                EndIF
            EndIF
        EndIF    
    
        lMemVar        := (;
                            StaticCall( NDJLIB001 , IsMemVar , "C1_XCODOR" );
                            .and.;
                            StaticCall( NDJLIB001 , IsMemVar , "C1_CODORCA" );
                            .and.;
                            StaticCall( NDJLIB001 , IsMemVar , "C1_CC" );
                            .and.;
                            StaticCall( NDJLIB001 , IsMemVar , "C1_CLVL" );
                            .and.;
                            StaticCall( NDJLIB001 , IsMemVar , "C1_ITEMCTA" );
                        )
        lGetDados    := StaticCall( NDJLIB001 , IsInGetDados , { "C1_XCODOR" , "C1_CODORCA" , "C1_CC" , "C1_CLVL" , "C1_ITEMCTA" } )

        IF ( ( lMemVar ) .or. ( lGetDados ) )

            cQuery    := "SELECT " + CRLF
            cQuery    += "    AFB_XCODOR, " + CRLF
            cQuery    += "    AFB_XORCAM  " + CRLF
            cQuery    +=  "FROM " + CRLF
            cQuery    +=  "    " + RetSqlName("AFB" ) +  " AFB " + CRLF
            cQuery    +=  "WHERE " + CRLF
            cQuery    +=  "    AFB.D_E_L_E_T_ <> '*' " + CRLF
            cQuery    +=  "AND" + CRLF                               
            cQuery    +=  "    AFB.AFB_FILIAL = '" + xFilial( "AFB" , cFilAnt ) + "' " + CRLF
            cQuery    +=  "AND" + CRLF
            cQuery    +=  "    AFB.AFB_TIPOD = '" + cC1CodSbm + "' " + CRLF
            IF IsInCallStack( "PMSA410" )
                cQuery    +=  "AND" + CRLF
                cQuery    +=  "    AFB.AFB_XORCAM = '" + AF8->AF8_ORCAME + "' " + CRLF
                IF !Empty( cRevisa )
                    cQuery    +=  "AND" + CRLF
                    cQuery    +=  "    AFB.AFB_REVISA = '" + cRevisa + "' " + CRLF
                EndIF
            EndIF

            TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

            IF ( cNextAlias )->( !Eof( ) )

                cCC            := ( ( cNextAlias )->AFB_XCODOR + AF8->AF8_PROJET )
                cClasVlr    := AF8->AF8_XCODIN    //Código do Indicador
                cItemCta    := AF8->AF8_XCODMA    //Código do Macro Processo

                IF ( ( lMemVar ) .and. ( lGetDados ) )
                    
                    StaticCall( NDJLIB001 , SetMemVar , "C1_CC"       , cCC      )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_CLVL"     , cClasVlr )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_ITEMCTA"  , cItemCta )

                    GdFieldPut( "C1_CC"      , cCC      )
                    GdFieldPut( "C1_CLVL"    , cClasVlr )
                    GdFieldPut( "C1_ITEMCTA" , cItemCta )

                    ( cNextAlias )->( StaticCall( NDJLIB001 , SetMemVar , "C1_XCODOR"   , AFB_XCODOR ) )
                    ( cNextAlias )->( StaticCall( NDJLIB001 , SetMemVar , "C1_CODORCA"  , AFB_XORCAM ) )

                    ( cNextAlias )->( GdFieldPut( "C1_XCODOR"  , AFB_XCODOR ) )
                    ( cNextAlias )->( GdFieldPut( "C1_CODORCA" , AFB_XORCAM ) )

                ElseIF ( lMemVar )

                    StaticCall( NDJLIB001 , SetMemVar , "C1_CC"       , cCC      )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_CLVL"     , cClasVlr )
                    StaticCall( NDJLIB001 , SetMemVar , "C1_ITEMCTA"  , cItemCta )

                    ( cNextAlias )->( StaticCall( NDJLIB001 , SetMemVar , "C1_XCODOR"   , AFB_XCODOR ) )
                    ( cNextAlias )->( StaticCall( NDJLIB001 , SetMemVar , "C1_CODORCA"  , AFB_XORCAM ) )

                ElseIF ( lGetDados )
                    
                    GdFieldPut( "C1_CC"      , cCC      )
                    GdFieldPut( "C1_CLVL"    , cClasVlr )
                    GdFieldPut( "C1_ITEMCTA" , cItemCta )

                    ( cNextAlias )->( GdFieldPut( "C1_XCODOR"  , AFB_XCODOR ) )
                    ( cNextAlias )->( GdFieldPut( "C1_CODORCA" , AFB_XORCAM ) )

                EndIF

            EndIF

            ( cNextAlias )->( dbCloseArea() )
            dbSelectArea( "SC1" )

        EndIF

        StaticCall(U_XALTHRS,XALTHRS)

    CATCHEXCEPTION USING oException

        IF (;
                !Empty( cNextAlias );
                .and.;
                ( Select( cNextAlias ) > 0 );
            )
            ( cNextAlias )->( dbCloseArea() )
            dbSelectArea( "SC1" )
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
                !( lC1XCodSbmOk );
                .and.;
                ( lShowHelp );
                .and.;
                !( Empty( cMsgHelp ) );
            )
            Help( "" , 1 , "C1_XCODSBM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
        EndIF    
        ConOut( CaptureError() )

    ENDEXCEPTION

    RestArea( aArea )

Return( lC1XCodSbmOk )

/*/
    Funcao:     C1ProdutoVld
    Autor:        Marinaldo de Jesus
    Data:        23/11/2010
    Descricao:    Validar o Codigo do Produto
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1ProdutoVld)
/*/
Static Function C1ProdutoVld( cC1Produto , lShowHelp , cMsgHelp )

    Local aArea            := GetArea()
    
    Local cC1CodSbm
    Local cNextAlias

    Local lFieldOk        := .T.

    Local nFieldPos

    Local oException

    TRYEXCEPTION

        lFieldOk    := ExistCpo("SB1")
        IF !( lFieldOk )
            BREAK
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODSBM" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XCODSBM" ) );
            )
            cC1CodSbm := GdFieldGet( "C1_XCODSBM" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XCODSBM" ) )
            cC1CodSbm := StaticCall( NDJLIB001 , GetMemVar , "C1_XCODSBM" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XCODSBM" ) ) > 0 )
            cC1CodSbm := SC1->( FieldGet( nFieldPos ) )
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_PRODUTO" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_PRODUTO" ) );
            )
            cC1Produto := GdFieldGet( "C1_PRODUTO" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_PRODUTO" ) )
            cC1Produto := StaticCall( NDJLIB001 , GetMemVar , "C1_PRODUTO" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_PRODUTO" ) ) > 0 )
            cC1Produto := SC1->( FieldGet( nFieldPos ) )
        EndIF

        cNextAlias    := GetNextAlias()

        BEGINSQL ALIAS cNextAlias
            SELECT
                B1_COD
            FROM
                %table:SB1% SB1
            WHERE
                SB1.B1_FILIAL = %exp:xFilial( "SB1" )%
            AND
                   SB1.B1_GRUPO = %exp:cC1CodSbm%
            AND
                   SB1.B1_COD = %exp:cC1Produto%
            AND
                SB1.%NotDel%
        ENDSQL

        lFieldOk    := (cNextAlias)->( !Eof() .and. !Bof() )
        IF !( lFieldOk )
            UserException( "Informação inválida para o Campo: " + cC1Produto + CRLF + " Informe um Produto de Acordo com o Tipo de Despesa" )
        EndIF
        IF ( lFieldOk )
            lFieldOk := ( cC1Produto == (cNextAlias)->B1_COD )
            IF !( lFieldOk )
                UserException( "Informação inválida para o Campo: " + cC1Produto + CRLF + " Informe um Produto de Acordo com o Tipo de Despesa" )
            EndIF
        EndIF

        (cNextAlias)->( dbCloseArea() )
        dbSelectArea( "SC1" )

        StaticCall(U_XALTHRS,XALTHRS)

    CATCHEXCEPTION USING oException

        IF (;
                !Empty( cNextAlias );
                .and.;
                ( Select( cNextAlias ) > 0 );
            )
            ( cNextAlias )->( dbCloseArea() )
            dbSelectArea( "SC1" )
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
            Help( "" , 1 , "C1_PRODUTO" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
        EndIF    
        ConOut( CaptureError() )


    ENDEXCEPTION

    IF ( lFieldOk )
        lFieldOk    := C1XCodSbmVld(NIL,.T.,NIL,.F.)
    EndIF    

    RestArea( aArea )

Return( lFieldOk )

/*/
    Funcao:     C1PROJETInit
    Autor:        Marinaldo de Jesus
    Data:        03/03/2010
    Descricao:    Inicializador Padrao do campo C1_PROJET
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1PROJETInit)
/*/
Static Function C1PROJETInit()

    Local cC1Projet
    Local cC1XProjet
    
    Local nFieldPos
    
    Local oException
    
    TRYEXCEPTION

        IF IsInCallStack( "PMSA410" )
            cC1Projet := AF8->AF8_PROJET
            BREAK
        EndIF    

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XPROJET" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XPROJET" ) );
            )
            cC1XProjet := GdFieldGet( "C1_XPROJET" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XPROJET" ) )
            cC1XProjet := StaticCall( NDJLIB001 , GetMemVar , "C1_XPROJET" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XPROJET" ) ) > 0 )
            cC1XProjet := SC1->( FieldGet( nFieldPos ) )
        EndIF

        cC1Projet := cC1XProjet

    CATCHEXCEPTION USING oException
    
        IF ( ValType( oException ) == "O" )
            cC1Projet := Space( GetSx3Cache( "C1_PROJET" , "X3_TAMANHO" ) )
        Help( "" , 1 , "C1_PROJET" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF
    
    ENDEXCEPTION

Return( cC1Projet )

/*/
    Funcao:     C1REVISAInit
    Autor:        Marinaldo de Jesus
    Data:        03/03/2010
    Descricao:    Inicializador Padrao do campo C1_REVISA
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1REVISAInit)
/*/
Static Function C1REVISAInit()

    Local cC1REVISA
    Local cC1XREVISA
    
    Local nFieldPos
    
    Local oException
    
    TRYEXCEPTION

        IF IsInCallStack( "PMSA410" )
            cC1REVISA := AF8->AF8_REVISA
            BREAK
        EndIF    

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XREVISA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XREVISA" ) );
            )
            cC1XREVISA := GdFieldGet( "C1_XREVISA" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XREVISA" ) )
            cC1XREVISA := StaticCall( NDJLIB001 , GetMemVar , "C1_XREVISA" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XREVISA" ) ) > 0 )
            cC1XREVISA := SC1->( FieldGet( nFieldPos ) )
        EndIF

        cC1REVISA := cC1XREVISA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cC1REVISA := Space( GetSx3Cache( "C1_REVISA" , "X3_TAMANHO" ) )
            Help( "" , 1 , "C1_REVISA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF
    
    ENDEXCEPTION

Return( cC1REVISA )

/*/
    Funcao:     C1TAREFAInit
    Autor:        Marinaldo de Jesus
    Data:        03/03/2010
    Descricao:    Inicializador Padrao do campo C1_TAREFA
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1TAREFAInit)
/*/
Static Function C1TAREFAInit()

    Local cC1TAREFA
    Local cC1XTAREFA
    
    Local nFieldPos
    
    Local oException
    
    TRYEXCEPTION

        IF IsInCallStack( "PMSA410" )
            cC1TAREFA := AF9->AF9_TAREFA
            BREAK
        EndIF    

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XTAREFA" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XTAREFA" ) );
            )
            cC1XTAREFA := GdFieldGet( "C1_XTAREFA" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_XTAREFA" ) )
            cC1XTAREFA := StaticCall( NDJLIB001 , GetMemVar , "C1_XTAREFA" )
        ElseIF ( SC1->( nFieldPos := FieldPos( "C1_XTAREFA" ) ) > 0 )
            cC1XTAREFA := SC1->( FieldGet( nFieldPos ) )
        EndIF

        cC1TAREFA := cC1XTAREFA

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cC1TAREFA := Space( GetSx3Cache( "C1_TAREFA" , "X3_TAMANHO" ) )
            Help( "" , 1 , "C1_TAREFA" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF
    
    ENDEXCEPTION

Return( cC1TAREFA )

/*/
    Funcao:     C1XANEXOInit
    Autor:        Marinaldo de Jesus
    Data:        15/03/2010
    Descricao:    Inicializador Padrao do campo C1_XANEXO
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XANEXOInit)
/*/
Static Function C1XANEXOInit()

    Local cC1Num        := ""
    Local cIniBrw        := "BR_CANCEL"
    
    Local lC1XPAnexo    := .F.    

    Local oException
    
    TRYEXCEPTION
        
        lC1XPAnexo            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XPANEXO" )
        DEFAULT lC1XPAnexo    := .F.

        IF !( lC1XPAnexo )

            IF (;
                    !( Type( "cA110Num" ) == "C" );
                    .or.;
                    Empty( cA110Num );
                )    
                cC1Num    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM" )
            Else
                cC1Num    := cA110Num
            EndIF    

            lC1XPAnexo := StaticCall( U_FT340MNU , LinkedFile , @cC1Num )

        EndIF

        IF ( lC1XPAnexo )
            cIniBrw    := "CLIPS_PQ"
        EndIF

    CATCHEXCEPTION USING oException
    
        cIniBrw := "CANCEL"

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "C1_XANEXO" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF
    
    ENDEXCEPTION

Return( cIniBrw )

/*/
    Funcao:     C1CODCOMPVld
    Autor:        Marinaldo de Jesus
    Data:        07/04/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_CODCOMP
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1CODCOMPVld)
/*/
Static Function C1CODCOMPVld( cC1CodComp , lShowHelp , cMsgHelp )

    Local cC1XCODCOM
    Local cC1XDESCOM

    Local lFieldOk        := .T.
    Local lC1CodComp
    Local lC1XCodCom
    Local lC1XDesCom

    Local nSY1Order
    
    Local nFieldPos
    Local nC1CodComp
    Local nC1XCodCom
    Local nC1XDESCOM

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "cCodCompr" ) )
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , GetMemVar , "cCodCompr" )
        Else
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_CODCOMP" , .F. )
        EndIF

        IF Empty( cC1CodComp )
            BREAK
        EndIF

        lC1CodComp    := StaticCall( NDJLIB001 , IsInGetDados , "C1_CODCOMP" )
        IF ( lC1CodComp )
            nC1CodComp := GdFieldPos( "C1_CODCOMP" )
            aEval( aCols , { |aElem,nItem| aCols[nItem][nC1CodComp] := cC1CodComp } )
        EndIF

        lC1XCodCom    := StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODCOM" )
        lC1XDesCom    := StaticCall( NDJLIB001 , IsInGetDados , "C1_XDESCOM" )

        IF (;
                ( lC1XCodCom );
                .or.;
                ( lC1XDesCom );
            )    

            IF ( lC1XCodCom )
                nSY1Order    := RetOrder( "SY1" , "Y1_FILIAL+Y1_COD" )
                cC1XCODCOM    := Posicione( "SY1" , nSY1Order , xFilial( "SY1" ) + cC1CodComp , "Y1_USER" )
                nC1XCodCom    := GdFieldPos( "C1_XCODCOM" )
                aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XCodCom] := cC1XCODCOM } )
            EndIF
    
            IF ( lC1XDesCom )
                nSY1Order    := RetOrder( "SY1" , "Y1_FILIAL+Y1_COD" )
                cC1XDESCOM    := Posicione( "SY1" , nSY1Order , xFilial( "SY1" ) + cC1CodComp , "Y1_NOME" )
                nC1XDESCOM    := GdFieldPos( "C1_XDESCOM" )
                aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XDESCOM] := cC1XDESCOM } )
            EndIF

        EndIF

        GetdRefresh() //Forco o Refresh da GetDados

        StaticCall( U_XALTHRS , XALTHRS , "SC1" )

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
                Help( "" , 1 , "C1_CODCOMP" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Funcao:     C1XCODCOMInit
    Autor:        Marinaldo de Jesus
    Data:        07/04/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XCODCOM
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XCODCOMInit)
/*/
Static Function C1XCODCOMInit()

    Local cMsgHelp
    Local cC1CodComp
    Local cC1XCODCOM

    Local lC1CodComp
    Local lC1XCodCom

    Local nSY1Order
    
    Local nFieldPos
    Local nC1CodComp
    Local nC1XCodCom

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "cCodCompr" ) )
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , GetMemVar , "cCodCompr" )
        Else
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_CODCOMP" , .F. )
        EndIF

        IF Empty( cC1CodComp )
            BREAK
        EndIF

        nSY1Order    := RetOrder( "SY1" , "Y1_FILIAL+Y1_COD" )
        cC1XCODCOM    := Posicione( "SY1" , nSY1Order , xFilial( "SY1" ) + cC1CodComp , "Y1_USER" )

    CATCHEXCEPTION USING oException

        cC1XCODCOM    := Space( GetSx3Cache( "C1_XCODCOM" , "X3_TAMANHO" ) )
        
        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            IF !Empty( cMsgHelp )
                Help( "" , 1 , "C1_XCODCOM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( cC1XCODCOM )

/*/
    Funcao:     C1XDESCOMInit
    Autor:        Marinaldo de Jesus
    Data:        07/04/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XDESCOM
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XDESCOMInit)
/*/
Static Function C1XDESCOMInit()

    Local cMsgHelp
    Local cC1CodComp
    Local cC1XDESCOM

    Local lC1CodComp
    Local lC1XDESCOM

    Local nSY1Order
    
    Local nFieldPos
    Local nC1CodComp
    Local nC1XDESCOM

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "cCodCompr" ) )
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , GetMemVar , "cCodCompr" )
        Else
            DEFAULT cC1CodComp := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_CODCOMP" , .F. )
        EndIF

        IF Empty( cC1CodComp )
            BREAK
        EndIF

        nSY1Order    := RetOrder( "SY1" , "Y1_FILIAL+Y1_COD" )
        cC1XDESCOM    := Posicione( "SY1" , nSY1Order , xFilial( "SY1" ) + cC1CodComp , "Y1_NOME" )

    CATCHEXCEPTION USING oException

        cC1XDESCOM    := Space( GetSx3Cache( "C1_XDESCOM" , "X3_TAMANHO" ) )
        
        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            IF !Empty( cMsgHelp )
                Help( "" , 1 , "C1_XDESCOM" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( cC1XDESCOM )

/*/
    Funcao:     C1XC7STATInit
    Autor:        Marinaldo de Jesus
    Data:        10/05/2011
    Descricao:    Inicializador Padrao do campo C1_XC7STAT
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XC7STATInit)
/*/
Static Function C1XC7STATInit()

    Local cIniBrw        := ""
    Local cC1Num        := ""
    Local cC1Item        := ""
    Local cSC7Filial    := xFilial( "SC7" )
    Local cSC7KeySeek    := cSC7Filial
    
    Local nSC7Order        := RetOrder( "SC7" , "C7_FILIAL+C7_NUMSC+C7_ITEMSC" )

    Local oException
    
    TRYEXCEPTION

        IF (;
                !( Type( "cA110Num" ) == "C" );
                .or.;
                Empty( cA110Num );
            )    
            cC1Num    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM" )
        Else
            cC1Num    := cA110Num
        EndIF
        cSC7KeySeek += cC1Num

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_ITEM" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_ITEM" ) );
            )
            cC1Item := GdFieldGet( "C1_ITEM" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_ITEM" ) )
            cC1Item := StaticCall( NDJLIB001 , GetMemVar , "C1_ITEM" )
        Else
            cC1Item := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_ITEM" , .T. )
        EndIF
        cSC7KeySeek += cC1Item
        
        SC7->( dbSetOrder( nSC7Order ) )

        IF SC7->( !dbSeek( cSC7KeySeek , .F. ) )
            BREAK
        EndIF

        cIniBrw    := GetC7Status()

    CATCHEXCEPTION USING oException

        cIniBrw := ""

        IF ( ValType( oException ) == "O" )
            Help( "" , 1 , "C1_XC7STAT" , NIL , OemToAnsi( oException:Description ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( cIniBrw )

/*/
    Funcao:        GetC7Status
    Autor:        Marinaldo de Jesus
    Descricao:    Retornar o Status da SC7 conforme Array de Cores da mBrowse
    Sintaxe:    StaticCall(U_SC1FLDVLD,GetC7Status)
/*/
Static Function GetC7Status()

    Local aArea            := GetArea()
    Local aSC1Area        := SC1->( GetArea() )
    Local bGetColors    := { || Mata120() }
    Local bGetLegend    := { || A120Legenda() }

    Local cAlias         := "SC7"
    Local cStatus        := ""

    Private nTipoPed    := 1
    
    cStatus                := StaticCall( NDJLIB001 , BrwGetSLeg , @cAlias , @bGetColors , @bGetLegend , NIL, .F. )

    RestArea( aSC1Area )
    RestArea( aArea )

Return( cStatus ) 


/*/
    Funcao:     C1XREFCNTVld
    Autor:        Marinaldo de Jesus
    Data:        13/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XREFCNT
    Sintaxe:    StaticCall( U_SC1FLDVLD , C1XREFCNTVld )
/*/
Static Function C1XREFCNTVld( lC1XREFCNT , lShowHelp , cMsgHelp )

    Local dC1XDTPPAG

    Local lFieldOk        := .T.
    Local lC1XDTPPAG

    Local nC1XREFCNT
    Local nC1XDTPPAG

    Local oException

    TRYEXCEPTION

        DEFAULT lC1XREFCNT    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .F. )

        IF ( lC1XREFCNT )

            DEFAULT dC1XDTPPAG := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XDTPPAG" , .F. )

        Else

            dC1XDTPPAG    := Ctod( "//" )

        EndIF

        nC1XREFCNT    := GdFieldPos( "C1_XREFCNT" )
        IF ( nC1XREFCNT > 0 )
            aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XREFCNT] := lC1XREFCNT } )
        EndIF

        lC1XDTPPAG    := StaticCall( NDJLIB001 , IsInGetDados , "C1_XDTPPAG" )

        IF ( lC1XDTPPAG )
            nC1XDTPPAG    := GdFieldPos( "C1_XDTPPAG" )
            aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XDTPPAG] := dC1XDTPPAG } )
        EndIF

        StaticCall( NDJLIB001 , SetMemVar , "C1_XDTPPAG" , dC1XDTPPAG , .T. , .T. , .F. , .T. , NIL , .T. )

        GetdRefresh() //Forco o Refresh da GetDados

        StaticCall( U_XALTHRS , XALTHRS , "SC1" )

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
                Help( "" , 1 , "C1_XREFCNT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Funcao:     C1XREFCNTInit
    Autor:        Marinaldo de Jesus
    Data:        13/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XREFCNT
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XREFCNTInit)
/*/
Static Function C1XREFCNTInit()

    Local cMsgHelp
    Local lC1XREFCNT

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "lC1XREFCNT" ) )
            DEFAULT lC1XREFCNT    := StaticCall( NDJLIB001 , GetMemVar , "lC1XREFCNT" )
        Else
            DEFAULT lC1XREFCNT    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .F. )
        EndIF    

    CATCHEXCEPTION USING oException

        lC1XREFCNT    := .F.
        
        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            IF !Empty( cMsgHelp )
                Help( "" , 1 , "C1_XREFCNT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( lC1XREFCNT )

/*/
    Funcao:     C1XDTPPAGVld
    Autor:        Marinaldo de Jesus
    Data:        13/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XREFCNT
    Sintaxe:    StaticCall( U_SC1FLDVLD , C1XDTPPAGVld )
/*/
Static Function C1XDTPPAGVld( dC1XDTPPAG , lShowHelp , cMsgHelp )

    Local lFieldOk        := .T.
    Local lC1XREFCNT
    Local lC1XDTPPAG

    Local nC1XREFCNT
    Local nC1XDTPPAG

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "lC1XREFCNT" ) )
            DEFAULT lC1XREFCNT    := StaticCall( NDJLIB001 , GetMemVar , "lC1XREFCNT" )
        Else
            DEFAULT lC1XREFCNT    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .F. )
        EndIF    

        IF ( lC1XREFCNT )

            DEFAULT dC1XDTPPAG := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XDTPPAG" , .F. )

            lFieldOk    := ( dC1XDTPPAG >= MsDate() )
            IF !( lFieldOk )
                UserException( "Data Prevista para Pagamento Inválida" )
                BREAK
            EndIF

        Else

            dC1XDTPPAG    := Ctod( "//" )

        EndIF

        nC1XREFCNT    := GdFieldPos( "C1_XREFCNT" )
        IF ( nC1XREFCNT > 0 )
            aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XREFCNT] := lC1XREFCNT } )
        EndIF

        lC1XDTPPAG    := StaticCall( NDJLIB001 , IsInGetDados , "C1_XDTPPAG" )

        IF ( lC1XDTPPAG )
            nC1XDTPPAG    := GdFieldPos( "C1_XDTPPAG" )
            aEval( aCols , { |aElem,nItem| aCols[nItem][nC1XDTPPAG] := dC1XDTPPAG } )
        EndIF

        StaticCall( NDJLIB001 , SetMemVar , "C1_XDTPPAG" , dC1XDTPPAG , .T. , .T. , .F. , .T. , NIL , .T. )

        GetdRefresh() //Forco o Refresh da GetDados

        StaticCall( U_XALTHRS , XALTHRS , "SC1" )

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
                Help( "" , 1 , "C1_XREFCNT" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF    
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( lFieldOk  )

/*/
    Funcao:     C1XDTPPAGInit
    Autor:        Marinaldo de Jesus
    Data:        13/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XDTPPAG
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XDTPPAGInit)
/*/
Static Function C1XDTPPAGInit()

    Local cMsgHelp
    Local dC1XDTPPAG

    Local oException

    TRYEXCEPTION

        IF ( StaticCall( NDJLIB001 , IsMemVar , "dC1XDTPPAG" ) )
            dC1XDTPPAG            := StaticCall( NDJLIB001 , GetMemVar , "dC1XDTPPAG" )
        Else
            DEFAULT dC1XDTPPAG    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XDTPPAG" , .F. )
        EndIF

    CATCHEXCEPTION USING oException

        dC1XDTPPAG    := Ctod("//")

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            IF !Empty( cMsgHelp )
                Help( "" , 1 , "C1_XDTPPAG" , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            EndIF
            ConOut( CaptureError() )
        EndIF

    ENDEXCEPTION

Return( dC1XDTPPAG )

/*/
    Funcao:     C1DescriVld
    Autor:        Marinaldo de Jesus
    Data:        30/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_DESCRI
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1DescriVld)
/*/
Static Function C1DescriVld()
    Local lFieldOk := Texto()
    IF ( lFieldOk )
        StaticCall(U_XALTHRS,XALTHRS)
    EndIF    
Return( lFieldOk )

/*/
    Funcao:     C1XVisCTBVld
    Autor:        Marinaldo de Jesus
    Data:        30/08/2011
    Descricao:    Validar o conteudo do campo Padrao do C1_XVISCTB
    Sintaxe:    StaticCall(U_SC1FLDVLD,C1XVisCTBVld)
/*/
Static Function C1XVisCTBVld()

    Local lFieldOk    := .T.
    
    BEGIN SEQUENCE

        lFieldOk    := VAZIO()
        IF ( lFieldOk )
            BREAK
        EndIF

        lFieldOk    := EXISTCPO( "CTD" )
        IF !( lFieldOk )
            BREAK
        EndIF
    
    END SEQUENCE

    IF ( lFieldOk )
        StaticCall(U_XALTHRS,XALTHRS)    
    EndIF    

Return( lFieldOk )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        C1NumVld()
        C1NumInit()
        C1XCODGEInit()
        C1XCodSbmVld()
        C1ProdutoVld()
        C1PROJETInit()
        C1REVISAInit()
        C1TAREFAInit()
        C1TAREFAInit()
        C1XANEXOInit()
        C1CodCompVld()
        C1XCODCOMInit()
        C1XDESCOMInit()
        C1XC7STATInit()
        C1XDTPPAGINIT()
        C1XDTPPAGVLD()
        C1XREFCNTINIT()
        C1XREFCNTVLD()
        C1QUANTWHEN()
        C1XPRECOWHEN()
        C1DESCRIVLD()
        C1XVISCTBVLD()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
