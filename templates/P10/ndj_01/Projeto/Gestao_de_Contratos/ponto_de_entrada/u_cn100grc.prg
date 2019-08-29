#INCLUDE "NDJ.CH"
/*/
    Funcao:     CN100GRC
    Autor:        Marinaldo de Jesus
    Data:        22/12/2010
    Descricao:    Implementacao do Ponto de Entrada CN100GRC executado na CN100Grv em CNTA100
                Sera utilizado para obter informações sobre o ultimo contrato gravado
/*/
User Function CN100GRC()

    Local aPlan
    Local aPlIt
    Local aRecnos
    Local aCNARecnos

    Local cCN9Numero
    Local cCN9Revisa
    Local cSC1Filial
    Local cSC7Filial
    Local cCNAFilial
    Local cCNBFilial
    Local cCN9Filial
    Local cC7ENCER
    Local cC7XNUMCNB
    Local cC7XCTNCNB
    Local cC7XREVCNB
    Local cC7CONAPRO
    Local cC1FLAGGCT
    Local cC1XCONTRA
    Local cSC1KeySeek
    Local cSC7KeySeek
    Local cCN1KeySeek
    Local cCNAKeySeek
    Local cCNBKeySeek

    Local nOpc
    Local nRecno
    Local nRecnos
    Local nCN9Recno
    Local nCNARecno
    Local nCNAOrder
    Local nCNBOrder
    Local nSC7Order
    Local nSC1Order
    Local nCN1Order
    Local nFieldPos
    Local nOpcCN110Manut

    Local oException

    TRYEXCEPTION

        nOpc    := ParamIxb[1]
        aPlan    := ParamIxb[2]
        aPlIt    := ParamIxb[3]

        CN9->( cCN9Numero := CN9_NUMERO , cCN9Revisa := CN9_REVISA , nCN9Recno := Recno() ) 

        IF !( nOpc == 5 )
        
            StaticCall( U_MT120BRW , CN9GetSetCNT , @cCN9Numero , @cCN9Revisa , @nCN9Recno , @nOpc , @aPlan , @aPlIt )
            
            IF (;
                    (;
                        ( nOpc == 3 );    //Inclusao
                        .or.;
                        ( nOpc == 4 );    //Alteracao
                    );    
                    .and.;
                    (;
                        IsInCallStack( "NDJContratos" );
                        .or.;
                        IsInCallStack( "NDJAditivos" );
                     );
                )

                cCN9Filial    := xFilial( "CN9" )
                nCN1Order    := RetOrder( "CN1" , "CN1_FILIAL+CN1_CODIGO" )
                cCN1KeySeek := xFilial( "CN1" , cCN9Filial )
                IF (;
                        StaticCall( NDJLIB001 , IsInGetDados , "CN9_TPCTO" );
                        .and.;
                        !( StaticCall( NDJLIB001 , IsCpoVar ,  "CN9_TPCTO" ) );
                    )
                    cCN1KeySeek    += GdFieldGet( "CN9_TPCTO" )
                ElseIF ( StaticCall( NDJLIB001 , IsMemVar , "CN9_TPCTO" ) )
                    cCN1KeySeek    += StaticCall( NDJLIB001 , GetMemVar , "CN9_TPCTO" )
                ElseIF ( CN9->( nFieldPos := FieldPos( "CN9_TPCTO" ) ) > 0 )
                    cCN1KeySeek    += CN9->( FieldGet( nFieldPos ) )
                EndIF

                //Forco o Posicionamento da Tabela CNA
                nCNAOrder     := RetOrder( "CNA" , "CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO" )
                CNA->( dbSetOrder( nCNAOrder ) )
                cCNAFilial    := xFilial( "CNA" , cCN9Filial )
                cCNAKeySeek    := cCNAFilial
                cCNAKeySeek += cCN9Numero
                cCNAKeySeek += cCN9Revisa
                aCNARecnos    := {}
                IF CNA->( dbSeek( cCNAKeySeek , .F. ) )
                    While CNA->( !Eof() .and. cCNAKeySeek == CNA_FILIAL+CNA_CONTRA+CNA_REVISA )
                        nCNARecno := CNA->( Recno() )
                        IF Empty( CNA->CNA_CRONOG )
                            aAdd( aCNARecnos , nCNARecno )
                        EndIF
                        CNA->( dbSkip() )
                    End While
                EndIF

                nRecnos     := Len( aCNARecnos )
                nCNBOrder    := RetOrder( "CNB" , "CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM" )
                cCNBFilial    := xFilial( "CNB" , cCNAFilial )

                //Se o Tipo de Contrato possuir Cronograma
                IF ( Posicione( "CN1" , @nCN1Order , @cCN1KeySeek , "CN1_MEDEVE" ) == "2" ) 
                    For nRecno := 1 To nRecnos
                        nCNARecno := aCNARecnos[ nRecno ]
                        //Forco o Posicionamento da Tabela CNA
                        CNA->( dbGoto( nCNARecno ) )
                        //Forco o Posicionamento da Tabela CNB
                        cCNBKeySeek    := cCNBFilial
                        cCNBKeySeek += cCN9Numero
                        cCNBKeySeek += cCN9Revisa
                        cCNBKeySeek += CNA->CNA_NUMERO
                        CNB->( dbSeek( cCNBKeySeek , .F. ) )
                        //Defino a opcao como sendo, Sempre, Inclusao de Cronograma
                        nOpcCN110Manut    := 3
                        //Forco CNF em EOF pois sempre sera inclusao de Cronograma
                        PutFileInEof( "CNF" )
                        //Utiliza o Wizard de Cronograma para a Geracao
                        CN110Manut( "CNF" , 0 , @nOpcCN110Manut , NIL , @cCN9Numero , @cCN9Revisa , .T. )
                    Next nRecno
                Else
                    //Atualiza os Valores Empenhados de Acordo com o Periodo do Contrato Conforme Planilha
                    StaticCall( U_NDJBLKSCVL , CNAToSZ0 , @aCNARecnos , @nRecnos , @nCNBOrder , @cCNBFilial )
                EndIF    

                nSC1Order    := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
                nSC7Order    := RetOrder( "SC7" , "C7_FILIAL+C7_XCTNCNB+C7_XREVCNB+C7_XNUMCNB+C7_XITMCNB" )
    
                SC1->( dbSetOrder( nSC1Order ) )
                SC7->( dbSetOrder( nSC7Order ) )
                 
                cSC7Filial    := xFilial( "SC7" )
                cSC1Filial    := xFilial( "SC1" , cSC7Filial )
                cC1FLAGGCT    := "1"

                cSC7KeySeek    := cSC7Filial
                cSC7KeySeek    += cCN9Numero

                IF SC7->( dbSeek( cSC7KeySeek , .F. ) )
                    While SC7->( !Eof() .and. C7_FILIAL+C7_XCTNCNB == cSC7KeySeek )
                        cSC1KeySeek := cSC1Filial
                        cSC1KeySeek += SC7->C7_NUMSC
                        cSC1KeySeek += SC7->C7_ITEMSC
                        IF SC1->( dbSeek( cSC1KeySeek , .F. ) )
                            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XCONTRA" , @cCN9Numero     , .T.    )
                            StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_FLAGGCT" , @cC1FLAGGCT     , .T.    )
                        EndIF
                        SC7->( dbSkip() )
                    End While
                EndIF

            EndIF
        
        Else

            cC7ENCER    := Space( GetSx3Cache( "C7_ENCER"   , "X3_TAMANHO" ) )
            cC7XCTNCNB    := Space( GetSx3Cache( "C7_XCTNCNB" , "X3_TAMANHO" ) )
            cC7XREVCNB    := Space( GetSx3Cache( "C7_XREVCNB" , "X3_TAMANHO" ) )
            cC7XNUMCNB    := Space( GetSx3Cache( "C7_XNUMCNB" , "X3_TAMANHO" ) )
            cC7CONAPRO    := "L"
            
            cC1XCONTRA    := Space( GetSx3Cache( "C1_XCONTRA" , "X3_TAMANHO" ) )
            cC1FLAGGCT    := Space( GetSx3Cache( "C1_FLAGGCT" , "X3_TAMANHO" ) )

            nSC1Order    := RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" )
            nSC7Order    := RetOrder( "SC7" , "C7_FILIAL+C7_XCTNCNB+C7_XREVCNB+C7_XNUMCNB+C7_XITMCNB" )

            SC1->( dbSetOrder( nSC1Order ) )
            SC7->( dbSetOrder( nSC7Order ) )
             
            cSC7Filial    := xFilial( "SC7" )
            cSC1Filial    := xFilial( "SC1" , cSC7Filial )

            cSC7KeySeek    := cSC7Filial
            cSC7KeySeek    += cCN9Numero
            
            aRecnos        := {}

            IF SC7->( dbSeek( cSC7KeySeek , .F. ) )
                While SC7->( !Eof() .and. C7_FILIAL+C7_XCTNCNB == cSC7KeySeek )
                    SC7->( aAdd( aRecnos , Recno() ) )
                    SC7->( dbSkip() )
                End While
                nRecnos := Len( aRecnos )
                For nRecno := 1 To nRecnos
                    SC7->( dbGoto( aRecnos[ nRecno ] ) )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCTNCNB" , @cC7XCTNCNB    , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XREVCNB" , @cC7XREVCNB    , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XNUMCNB" , @cC7XNUMCNB    , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_CONAPRO" , @cC7CONAPRO    , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_ENCER"   , @cC7ENCER        , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_MSBLQL"  , "2"                , .T.    )    //Desbloqueado
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCNTSOL" , .F.            , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_XCNTADT" , .F.            , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QUJE"    , 0                , .T.    )
                    StaticCall( NDJLIB001 , __FieldPut , "SC7" , "C7_QTDACLA" , 0                , .T.    )
                    cSC1KeySeek := cSC1Filial
                    cSC1KeySeek += SC7->C7_NUMSC
                    cSC1KeySeek += SC7->C7_ITEMSC
                    IF SC1->( dbSeek( cSC1KeySeek , .F. ) )
                        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_XCONTRA" , @cC1XCONTRA        , .T.    )
                        StaticCall( NDJLIB001 , __FieldPut , "SC1" , "C1_FLAGGCT" , @cC1FLAGGCT        , .T.    )
                    EndIF
                Next nRecno
            EndIF
        
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( CaptureError() )
        EndIF    

    ENDEXCEPTION

    //Forca o Commit das Alteracoes de Empenho
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

    //Forca o Commit das Alteracoes de Destinos    
    StaticCall( U_NDJA002 , SZ4SZ5Commit )

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
