#INCLUDE "NDJ.CH"
/*/
    Fun‡ao:        SXBSBMX
    Autor:        Marinaldo de Jesus
    Data:        04/11/2010
    Descri‡…o:    Filtro de Consulta Padrao para o SBMX Grupo de Produto vs Despesas
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSBMX)
/*/
Static Function SXBSBMX()

    Local aArea            := GetArea()

    Local cRet            := "@#.T.@#"
    Local cQuery        := ""
    Local cRevisa        := ""
    Local cCodProjeto    := ""
    Local cCodTarefa    := ""
    
    Local cNextAlias    := GetNextAlias()
    
    BEGIN SEQUENCE
        
        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_PROJET" )
            cCodProjeto    := GdFieldGet( "C1_PROJET" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_PROJET" )
            cCodProjeto    := StaticCall( NDJLIB001 , GetMemVar , "C1_PROJET" )
        EndIF    

        IF Empty( cCodProjeto )
            IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XPROJET" )
                cCodProjeto    := GdFieldGet( "C1_XPROJET" )
            ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_XPROJET" )
                cCodProjeto    := StaticCall( NDJLIB001 , GetMemVar , "C1_XPROJET" )
            EndIF    
            IF Empty( cCodProjeto )
                BREAK
            EndIF
        EndIF

        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_TAREFA" )
            cCodTarefa    := GdFieldGet( "C1_TAREFA" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_TAREFA" )
            cCodTarefa    := StaticCall( NDJLIB001 , GetMemVar , "C1_TAREFA" )
        EndIF    
        
        IF Empty( cCodTarefa )
            IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XTAREFA" )
                cCodTarefa    := GdFieldGet( "C1_XTAREFA" )
            ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_XTAREFA" )
                cCodTarefa    := StaticCall( NDJLIB001 , GetMemVar , "C1_XTAREFA" )
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
        cQuery    +=  "    AF8.AF8_PROJET = '" + cCodProjeto + "' " + CRLF
        cQuery    +=  "AND" + CRLF
        cQuery    +=  "    AFB.AFB_PROJET = AF8.AF8_PROJET " + CRLF
        IF !Empty( cCodTarefa )
            cQuery    +=  "AND" + CRLF
            cQuery    +=  "    AFB.AFB_TAREFA = '" + cCodTarefa + "' " + CRLF
        EndIF
        IF !Empty( cRevisa )
            cQuery    +=  "AND" + CRLF
            cQuery    +=  "    AFB.AFB_REVISA = '" + cRevisa + "' " + CRLF
        EndIF

        TCQUERY ( cQuery ) ALIAS ( cNextAlias ) NEW

        IF ( cNextAlias )->( Eof() )
            BREAK
        EndIF

        cRet :=    "@#"
        cRet +=        "SBM->( BM_GRUPO $ '"
        While ( cNextAlias )->( !Eof() )
            cRet += ( cNextAlias )->AFB_TIPOD + ","
            ( cNextAlias )->( dbSkip() )    
        End While
        cRet +=    "'"
        cRet +=    ")"
        cRet += "@#"

    END SEQUENCE

    IF ( Select( cNextAlias ) > 0 )
        ( cNextAlias )->( dbCloseArea() )
    EndIF

    RestArea( aArea )

Return( cRet )

/*/
    Fun‡ao:        SXBSB1X
    Autor:        Marinaldo de Jesus
    Data:        04/11/2010
    Descri‡…o:    Filtro de Consulta Padrao para o SB1X Grupo de Produto vs Despesas
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSB1X)
/*/
Static Function SXBSB1X()

    Local cRet            := "@#.T.@#"

    Local cCodGrupo        := ""

    BEGIN SEQUENCE

        IF StaticCall( NDJLIB001 , IsInGetDados , "C1_XCODSBM" )
            cCodGrupo    := GdFieldGet( "C1_XCODSBM" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "C1_XCODSBM" )
            cCodGrupo    := StaticCall( NDJLIB001 , GetMemVar , "C1_XCODSBM" )
        EndIF    

        IF Empty( cCodGrupo )
            BREAK
        EndIF

        cRet :=    "@#SB1->( B1_GRUPO == '" + Padr( cCodGrupo , GetSx3Cache( "B1_GRUPO" , "X3_TAMANHO" ) ) + "' )@#"

    END SEQUENCE

Return( cRet )

/*/
    Fun‡ao:        SXBB1SD1X
    Autor:        Marinaldo de Jesus
    Data:        04/11/2010
    Descri‡…o:    Filtro de Consulta Padrao para o B1SD1X Grupo de Produto vs Despesas
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBB1SD1X)
/*/
Static Function SXBB1SD1X()

    Local cRet            := "@#.T.@#"

    Local cCodGrupo        := ""

    BEGIN SEQUENCE

        IF StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODSBM" )
            cCodGrupo    := GdFieldGet( "D1_XCODSBM" )
        ElseIF StaticCall( NDJLIB001 , IsMemVar , "D1_XCODSBM" )
            cCodGrupo    := StaticCall( NDJLIB001 , GetMemVar , "D1_XCODSBM" )
        EndIF    

        IF Empty( cCodGrupo )
            BREAK
        EndIF

        cRet :=    "@#SB1->( B1_GRUPO == '" + Padr( cCodGrupo , GetSx3Cache( "B1_GRUPO" , "X3_TAMANHO" ) ) + "' )@#"

    END SEQUENCE

Return( cRet )

/*/
    Fun‡ao:        SXBSZ3
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descri‡…o:    Filtro de Consulta Padrao para o SZ5
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSZ3)
/*/
Static Function SXBSZ3()

    Local cRet            := "@#.T.@#"
    Local cCond1
    Local cCond2
    Local cNumSc
    Local cNumZ3
    
    Local lCond1
    Local lCond2

    BEGIN SEQUENCE

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_NUM" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_NUM" ) );
            )
            cNumSc := GdFieldGet( "C1_NUM" )
        ElseIF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C8_NUMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C8_NUMSC" ) );
                )
            cNumSc := GdFieldGet( "C8_NUMSC" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
            cNumSc := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C8_NUMSC" ) )
            cNumSc := StaticCall( NDJLIB001 , GetMemVar , "C8_NUMSC" )
        ElseIF ( Type( "cA110Num" ) == "C" )
            cNumSc := cA110Num
        EndIF

        IF !Empty( cNumSc )
            cCond1    := "Z3_NUMSC == '" + cNumSc + "'"
            lCond1    := .T.
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C1_XSZ2COD" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C1_XSZ2COD" ) );
            )
            cNumZ3    := GdFieldGet( "C1_XSZ2COD" )
        ElseIF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "C8_XSZ2COD" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "C8_XSZ2COD" ) );
                )
            cNumZ3    := GdFieldGet( "C8_XSZ2COD" )
        EndIF

        IF !Empty( cNumZ3 )
            cCond2    := "Z3_CODIGO == '" + cNumZ3 + "'"
            lCond2    := .T.
        EndIF
        
        IF (;
                !( lCond1 );
                .and.;
                !( lCond2 );
            )        
            BREAK
        EndIF

        cRet    :=    "@#SZ3->("

        IF ( lCond1 )
            cRet    +=    cCond1
        EndIF

        IF ( lCond2 )
            IF ( lCond1 )
                cRet    +=    ".and."
            EndIF    
            cRet    +=    cCond2
        EndIF

        cRet    += ")@#"

    END SEQUENCE

Return( cRet )

/*/
    Fun‡ao:        SXBSZ5
    Autor:        Marinaldo de Jesus
    Data:        20/11/2010
    Descri‡…o:    Filtro de Consulta Padrao para o SZ5
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSZ5)
/*/
Static Function SXBSZ5()

    Local cRet            := "@#.T.@#"
    Local cCond1
    Local cCond2
    Local cNumSc
    Local cNumZ5
    
    Local lCond1
    Local lCond2

    BEGIN SEQUENCE

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_NUMSC" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C7_NUMSC" ) );
            )
            cNumSc := GdFieldGet( "C7_NUMSC" )
        ElseIF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_XNUMSC" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XNUMSC" ) );
                )
            cNumSc := GdFieldGet( "D1_XNUMSC" )
        ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "C1_NUM" ) )
            cNumSc := StaticCall( NDJLIB001 , GetMemVar , "C1_NUM" )
        ElseIF ( Type( "cA110Num" ) == "C" )
            cNumSc := cA110Num
        EndIF

        IF !Empty( cNumSc )
            cCond1    := "Z5_NUMSC == '" + cNumSc + "'"
            lCond1    := .T.
        EndIF

        IF (;
                StaticCall( NDJLIB001 , IsInGetDados , "C7_XSZ2COD" );
                .and.;
                !( StaticCall( NDJLIB001 , IsCpoVar , "C7_XSZ2COD" ) );
            )
            cNumZ5    := GdFieldGet( "C7_XSZ2COD" )
        ElseIF (;
                    StaticCall( NDJLIB001 , IsInGetDados , "D1_XSZ2COD" );
                    .and.;
                    !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XSZ2COD" ) );
                )
            cNumZ5    := GdFieldGet( "D1_XSZ2COD" )
        EndIF

        IF !Empty( cNumZ5 )
            cCond2    := "Z5_CODIGO == '" + cNumZ5 + "'"
            lCond2    := .T.
        EndIF
        
        IF (;
                !( lCond1 );
                .and.;
                !( lCond2 );
            )        
            BREAK
        EndIF

        cRet    :=    "@#SZ5->("

        IF ( lCond1 )
            cRet    +=    cCond1
        EndIF

        IF ( lCond2 )
            IF ( lCond1 )
                cRet    +=    ".and."
            EndIF    
            cRet    +=    cCond2
        EndIF

        cRet    += ")@#"

    END SEQUENCE

Return( cRet )

/*/
    Fun‡ao:        SXBSZ8CNE
    Autor:        Marinaldo de Jesus
    Data:        18/05/2011
    Descri‡…o:    Filtro de Consulta Padrao para o SZ8CNE
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSZ8CNE)
/*/
Static Function SXBSZ8CNE()

    Local cRet            := "@#.T.@#"
    Local cZ8Codigo        := StaticCall( NDJLIB001 , __FieldGet,"CNE","CNE_XCIRQT" , .F. )

    cRet :=    "@#SZ8->( Z8_CODIGO == '" + cZ8Codigo + "' )@#"

Return( cRet  )

/*/
    Fun‡ao:        SXBSZ8CN9
    Autor:        Marinaldo de Jesus
    Data:        18/05/2011
    Descri‡…o:    Filtro de Consulta Padrao para o SZ8CN9
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBSZ8CN9)
/*/
Static Function SXBSZ8CN9()
    
    Local cRet            := "@#.T.@#"
    Local cCN9Numero    := StaticCall( NDJLIB001 , __FieldGet , "CN9" , "CN9_NUMERO" )

    cRet :=    "@#SZ8->( Z8_CONTRA == '" + cCN9Numero + "' )@#"

Return( cRet )

/*/
    Fun‡ao:        SXBCNBCN9
    Autor:        Marinaldo de Jesus
    Data:        18/05/2011
    Descri‡…o:    Filtro de Consulta Padrao para o CNBCN9
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBCNBCN9)
/*/
Static Function SXBCNBCN9()

    Local cRet            := "@#.T.@#"
    Local cCN9Numero    := StaticCall( NDJLIB001 , __FieldGet , "CN9" , "CN9_NUMERO" )
    Local cCN9Revisa    := StaticCall( NDJLIB001 , __FieldGet , "CN9" , "CN9_REVISA" )

    cRet :=    "@#CNB->( CNB_CONTRA == '" + cCN9Numero + "' .AND. CNB_REVISA  == '" + cCN9Revisa +  "' )@#"

Return( cRet )

/*/
    Fun‡ao:        SXBNDJSA2
    Autor:        Marinaldo de Jesus
    Data:        18/05/2011
    Descri‡…o:    Filtro de Consulta Padrao para o NDJSA2
    Uso:        Consulta Padrao (SXB)
    Sintaxe:    @#STATICCALL(U_NDJSXB,SXBNDJSA2)
/*/
Static Function SXBNDJSA2()

    Local cRet            := "@#.T.@#"

    IF SA2->( FieldPos( "A2_MSBLQL" ) > 0 )
        cRet :=    "@#SA2->( A2_MSBLQL <> '1' )@#"
    EndIF    

Return( cRet )             

/*/
    Fun‡ao:        D1XPROJETxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XPROJET de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XPROJETxbRet)
/*/
Static Function D1XPROJETxbRet()
    Local cProjeto    := AFB->AFB_PROJET
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XPROJET" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XPROJET" ) );
        )
        GdFieldPut( "D1_XPROJET" , cProjeto )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XPROJET" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XPROJET" , cProjeto )
    EndIF
Return( cProjeto )

/*/
    Fun‡ao:        D1XRevisxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XREVIS de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XRevisxbRet)
/*/
Static Function D1XRevisxbRet()
    Local cRevisa    := AFB->AFB_REVISA
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XREVIS" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XREVIS" ) );
        )
        GdFieldPut( "D1_XREVIS" , cRevisa )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XREVIS" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XREVIS" , cRevisa )
    EndIF
Return( cRevisa )

/*/
    Fun‡ao:        D1CODORCAxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_CODORCA de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1CODORCAxbRet)
/*/
Static Function D1CODORCAxbRet()
    Local cCodOrcamento    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_ORCAME",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.)
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_CODORCA" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_CODORCA" ) );
        )
        GdFieldPut( "D1_CODORCA" , cCodOrcamento )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_CODORCA" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_CODORCA" , cCodOrcamento )
    EndIF
Return( cCodOrcamento )

/*/
    Fun‡ao:        D1XCODORxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XCODOR de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XCODORxbRet)
/*/
Static Function D1XCODORxbRet()
    Local cCodOrigem    := AFB->AFB_XCODOR
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODOR" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XCODOR" ) );
        )
        GdFieldPut( "D1_XCODOR" , cCodOrigem )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XCODOR" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XCODOR" , cCodOrigem )
    EndIF
Return( cCodOrigem )

/*/
    Fun‡ao:        D1XTAREFAxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XTAREFA de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XTAREFAxbRet)
/*/
Static Function D1XTAREFAxbRet()
    Local cTarefa    := AFB->AFB_TAREFA
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XTAREFA" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XTAREFA" ) );
        )
        GdFieldPut( "D1_XTAREFA" , cTarefa )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XTAREFA" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XTAREFA" , cTarefa )
    EndIF
Return( cTarefa )

/*/
    Fun‡ao:        D1CCxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_CC de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1CCxbRet)
/*/
Static Function D1CCxbRet()
    Local cCC    := ( AFB->AFB_XCODOR+AFB->AFB_PROJET )
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_CC" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_CC" ) );
        )
        GdFieldPut( "D1_CC" , cCC )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_CC" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_CC" , cCC )
    EndIF
Return( cCC )

/*/
    Fun‡ao:        D1CLVLxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_CLVL de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1CLVLxbRet)
/*/
Static Function D1CLVLxbRet()
    Local cClasVlr    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODIN",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Indicador
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_CLVL" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_CLVL" ) );
        )
        GdFieldPut( "D1_CLVL" , cClasVlr )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_CLVL" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_CLVL" , cClasVlr )
    EndIF
Return( cClasVlr )

/*/
    Fun‡ao:        D1ITEMCTAxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_ITEMCTA de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1ITEMCTAxbRet)
/*/
Static Function D1ITEMCTAxbRet()
    Local cItemCta    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODMA",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.)    //Código do Macro Processo
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_ITEMCTA" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_ITEMCTA" ) );
        )
        GdFieldPut( "D1_ITEMCTA" , cItemCta )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_ITEMCTA" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_ITEMCTA" , cItemCta )
    EndIF
Return( cItemCta )

/*/
    Fun‡ao:        D1XCODSBMxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XCODSBM de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XCODSBMxbRet)
/*/
Static Function D1XCODSBMxbRet()
    Local cCodSBM    := AFB->AFB_TIPOD
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODSBM" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XCODSBM" ) );
        )
        GdFieldPut( "D1_XCODSBM"  , cCodSBM )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XCODSBM" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XCODSBM" , cCodSBM )
    EndIF
Return( cCodSBM )

/*/
    Fun‡ao:        D1XSBMxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XSBM de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XSBMxbRet)
/*/
Static Function D1XSBMxbRet()
    Local cDescSBM    := PosAlias("SBM",AFB->AFB_TIPOD,NIL,"BM_DESC",RetOrder("SBM","BM_FILIAL+BM_GRUPO"),.T.)
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XSBM" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XSBM" ) );
        )
        GdFieldPut( "D1_XSBM"  , cDescSBM )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XSBM" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XSBM" , cDescSBM )
    EndIF
Return( cDescSBM )

/*/
    Fun‡ao:        D1XCODGExbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XCODGE de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XCODGExbRet)
/*/
Static Function D1XCODGExbRet()
    Local cGeCodUser    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) ////Código do Usuario Gerente
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XCODGE" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XCODGE" ) );
        )
        GdFieldPut( "D1_XCODGE"  , cGeCodUser )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XCODGE" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XCODGE" , cGeCodUser )
    EndIF
Return( cGeCodUser ) 

/*/
    Fun‡ao:        D1XUSERxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo D1_XUSER de acordo com a Consulta Padrao
    Uso:        Consulta Padrao NDJPRJ (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,D1XUSERxbRet)
/*/
Static Function D1XUSERxbRet()
    Local cCodUser    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Usuario
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "D1_XUSER" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "D1_XUSER" ) );
        )
        GdFieldPut( "D1_XUSER"  , cCodUser )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "D1_XUSER" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "D1_XUSER" , cCodUser )
    EndIF
Return( cCodUser )  

/*/
    Fun‡ao:        CNBXPROJExbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XPROJE de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXPROJExbRet)
/*/
Static Function CNBXPROJExbRet()
    Local cProjeto    := AFB->AFB_PROJET
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XPROJE" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XPROJE" ) );
        )
        GdFieldPut( "CNB_XPROJE" , cProjeto )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XPROJE" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XPROJE" , cProjeto )
    EndIF
Return( cProjeto )

/*/
    Fun‡ao:        CNBXPROJExbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XREVIS de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXPROJExbRet)
/*/
Static Function CNBXREVISxbRet()
    Local cRevisa    := AFB->AFB_REVISA
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XREVIS" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XREVIS" ) );
        )
        GdFieldPut( "CNB_XREVIS" , cRevisa )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XREVIS" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XREVIS" , cRevisa )
    EndIF
Return( cRevisa )

/*/
    Fun‡ao:        CNBXCODCAxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCODCA de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCODCAxbRet)
/*/
Static Function CNBXCODCAxbRet()
    Local cXCODCAmento    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_ORCAME",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.)
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCODCA" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCODCA" ) );
        )
        GdFieldPut( "CNB_XCODCA" , cXCODCAmento )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCODCA" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCODCA" , cXCODCAmento )
    EndIF
Return( cXCODCAmento )

/*/
    Fun‡ao:        CNBXCODORxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCODOR de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCODORxbRet)
/*/
Static Function CNBXCODORxbRet()
    Local cCodOrigem    := AFB->AFB_XCODOR
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCODOR" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCODOR" ) );
        )
        GdFieldPut( "CNB_XCODOR" , cCodOrigem )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCODOR" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCODOR" , cCodOrigem )
    EndIF
Return( cCodOrigem )

/*/
    Fun‡ao:        CNBXTAREFxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XTAREF de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXTAREFxbRet)
/*/
Static Function CNBXTAREFxbRet()
    Local cTarefa    := AFB->AFB_TAREFA
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XTAREF" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XTAREF" ) );
        )
        GdFieldPut( "CNB_XTAREF" , cTarefa )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XTAREF" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XTAREF" , cTarefa )
    EndIF
Return( cTarefa )

/*/
    Fun‡ao:        CNBXCCxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCC de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCCxbRet)
/*/
Static Function CNBXCCxbRet()
    Local cCC    := ( AFB->AFB_XCODOR+AFB->AFB_PROJET )
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCC" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCC" ) );
        )
        GdFieldPut( "CNB_XCC" , cCC )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCC" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCC" , cCC )
    EndIF
Return( cCC )

/*/
    Fun‡ao:        CNBXCLVLxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCLVL de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCLVLxbRet)
/*/
Static Function CNBXCLVLxbRet()
    Local cClasVlr    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODIN",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Indicador
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCLVL" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCLVL" ) );
        )
        GdFieldPut( "CNB_XCLVL" , cClasVlr )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCLVL" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCLVL" , cClasVlr )
    EndIF
Return( cClasVlr )

/*/
    Fun‡ao:        CNBXITCTAxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XITCTA de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXITCTAxbRet)
/*/
Static Function CNBXITCTAxbRet()
    Local cXITCTA    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODMA",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.)    //Código do Macro Processo
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XITCTA" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XITCTA" ) );
        )
        GdFieldPut( "CNB_XITCTA" , cXITCTA )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XITCTA" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XITCTA" , cXITCTA )
    EndIF
Return( cXITCTA )

/*/
    Fun‡ao:        CNBXCODSBxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCODSB de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCODSBxbRet)
/*/
Static Function CNBXCODSBxbRet()
    Local cCodSBM    := AFB->AFB_TIPOD
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCODSB" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCODSB" ) );
        )
        GdFieldPut( "CNB_XCODSB"  , cCodSBM )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCODSB" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCODSB" , cCodSBM )
    EndIF
Return( cCodSBM )

/*/
    Fun‡ao:        CNBXSBMxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XSBM de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXSBMxbRet)
/*/
Static Function CNBXSBMxbRet()
    Local cDescSBM    := PosAlias("SBM",AFB->AFB_TIPOD,NIL,"BM_DESC",RetOrder("SBM","BM_FILIAL+BM_GRUPO"),.T.)
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XSBM" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XSBM" ) );
        )
        GdFieldPut( "CNB_XSBM"  , cDescSBM )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XSBM" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XSBM" , cDescSBM )
    EndIF
Return( cDescSBM )

/*/
    Fun‡ao:        CNBXCODGExbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_XCODGE de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBXCODGExbRet)
/*/
Static Function CNBXCODGExbRet()
    Local cGeCodUser    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Usuario Gerente
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_XCODGE" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_XCODGE" ) );
        )
        GdFieldPut( "CNB_XCODGE"  , cGeCodUser )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_XCODGE" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_XCODGE" , cGeCodUser )
    EndIF
Return( cGeCodUser ) 

/*/
    Fun‡ao:        CNBUSERPCxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_USERPC de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBUSERPCxbRet)
/*/
Static Function CNBUSERPCxbRet()
    Local cCodUser    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Usuario
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_USERPC" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_USERPC" ) );
        )
        GdFieldPut( "CNB_USERPC"  , cCodUser )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_USERPC" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_USERPC" , cCodUser )
    EndIF
Return( cCodUser )  

/*/
    Fun‡ao:        CNBUSERSCxbRet
    Autor:        Marinaldo de Jesus
    Data:        30/12/2010
    Descri‡…o:    Retornar o Conteudo para o campo CNB_USERSC de acordo com a Consulta Padrao
    Uso:        Consulta Padrao %CNBF3 (SXB)
    Sintaxe:    StaticCall(U_NDJSXB,CNBUSERSCxbRet)
/*/
Static Function CNBUSERSCxbRet()
    Local cCodUser    := PosAlias("AF8",AFB->AFB_PROJET,NIL,"AF8_XCODGE",RetOrder("AF8","AF8_FILIAL+AF8_PROJET"),.T.) //Código do Usuario
    IF (;
            StaticCall( NDJLIB001 , IsInGetDados , "CNB_USERSC" );
            .and.;
            !( StaticCall( NDJLIB001 , IsCpoVar , "CNB_USERSC" ) );
        )
        GdFieldPut( "CNB_USERSC"  , cCodUser )
    ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CNB_USERSC" ) )
        StaticCall( NDJLIB001 ,SetMemVar , "CNB_USERSC" , cCodUser )
    EndIF
Return( cCodUser )                                     

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CNBXCCXBRET()
        CNBUSERPCXBRET()
        CNBUSERSCXBRET()
        CNBXCLVLXBRET()
        CNBXCODCAXBRET()
        CNBXCODGEXBRET()
        CNBXCODORXBRET()
        CNBXCODSBXBRET()
        CNBXITCTAXBRET()
        CNBXPROJEXBRET()
        CNBXREVISXBRET()
        CNBXSBMXBRET()
        CNBXTAREFXBRET()
        D1CCXBRET()
        D1CLVLXBRET()
        D1CODORCAXBRET()
        D1ITEMCTAXBRET()
        D1XCODGEXBRET()
        D1XCODORXBRET()
        D1XCODSBMXBRET()
        D1XPROJETXBRET()
        D1XREVISXBRET()
        D1XSBMXBRET()
        D1XTAREFAXBRET()
        D1XUSERXBRET()
        SXBB1SD1X()
        SXBSB1X()
        SXBSBMX()
        SXBSZ3()
        SXBSZ5()
        SXBSZ8CNE()
        SXBSZ8CN9()
        SXBCNBCN9()
        SXBNDJSA2()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
