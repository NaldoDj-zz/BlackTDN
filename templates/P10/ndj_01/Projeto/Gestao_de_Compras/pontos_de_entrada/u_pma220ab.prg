#INCLUDE "NDJ.CH"
/*/
    Programa:     PMA220AB
    Data:        14/08/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada PMA220AB, executado em PMS220SC no progama PMSA220 sera utilizado para
                Alterar a chamada da Rotina de Manutencao de Solicitacao de Compras
/*/
User Function PMA220AB()

    Local aRotina    := ParamIxb[ 1 ]

    Local cOpc
    Local cExec

    Local nEL
    Local nBL        := Len( aRotina )

    For nEL := 1 To nBL
        cOpc                := AllTrim( Str( nEL ) )
        cExec                := "StaticCall(U_PMA220AB,__A220ToSC,Alias(),(Alias())->(Recno())," + cOpc + "),"
        aRotina[ nEL ][ 2 ]    := cExec
    Next nEL

Return( aRotina )

/*/
    Funcao:     __A220ToSC
    Data:        14/08/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Substituir a Chamada Padrao a Manutencao de Compras no PMS por rotina customizada
/*/
Static Function __A220ToSC( cAlias , nReg , nOpc )

    Local aArea        := GetArea()
    Local aSC1Area    := SC1->( GetArea() )
    
    Local cNumSC
    
    Local lInclui
    Local lAltera

    Local nTam        := GetSx3Cache( "C1_NUM" , "X3_TAMANHO" )
    
    Local uRet

    cNumSC            := Space( nTam )

    StaticCall( NDJLIB004 , SetPublic , "__c220NRSC"    , cNumSC    , "C" , nTam    , .T. , .F. , "__A220ToSC" )
    StaticCall( NDJLIB004 , SetPublic , "__l220Inclui"    , .F.        , "L" , 0        , .T. , .F. , "__A220ToSC" )
    StaticCall( NDJLIB004 , SetPublic , "__l220Altera"    , .F.         , "L" , 0        , .T. , .F. , "__A220ToSC" )

    aRotSetOpc( cAlias , @nReg , nOpc + 1 )

    uRet            := A220ToSC( @cAlias , @nReg , @nOpc )

    cNumSC            := StaticCall( NDJLIB001 , GetMemVar , "__c220NRSC" )
    lInclui            := StaticCall( NDJLIB001 , GetMemVar , "__l220Inclui" )
    DEFAULT    lInclui    := .F.
    lAltera            := StaticCall( NDJLIB001 , GetMemVar , "__l220Altera" )
    DEFAULT lAltera    := .F.

    //Verifica se Deve Distribuir a SC
    IF ( lInclui )
        SC1->( ChkContrato( @cNumSC , @lInclui , @lAltera ) )
    EndIF

    //Forca o Commit dos Destinos da SC1
    StaticCall( U_NDJA001 , SZ2SZ3Commit )

    //Atualiza as Areas de Trabalho para Obtencao dos Valores Previstos, Empenhados e Realizados
    StaticCall( U_NDJBLKSCVL , EmpFrmTrab )

    //Libera os Locks Pendentes
    StaticCall( NDJLIB003 , AliasUnLock )

    RestArea( aSC1Area )
    RestArea( aArea )

Return( uRet )

/*/
    Funcao:     ChkContrato
    Data:        14/08/2011
    Autor:        Marinaldo de Jesus
    Descricao:    Verificar se a SC Refere-se a Contrato e Distritui-la conforme Parcelas
    /*/
Static Function ChkContrato( cNumSC , lInclui , lAltera )

    Local aArea            := GetArea()

    Local aItens
    Local aPeriodos
    Local aSC1Recnos
    Local aSC1Struct

    Local cC1XNUMSC
    Local cC1KeySeek

    Local cSC1Filial    := xFilial( "SC1" )    
    Local cSZ3Filial    := xFilial( "SZ3" )
    Local cSZ2Filial    := xFilial( "SZ2" , cSZ3Filial )

    Local dC1DATPRF
    Local dC1XDTPPAG
    Local dC1XDATPRF
    Local dLastYDate

    Local lAddNew
    Local lC1DATPRF        := .F.
    Local lC1XDATPRF    := .F.
    Local lC1XREFCNT    

    Local nQtd
    Local nVal

    Local nBL
    Local nEL
    Local nItem
    Local nItens
    Local nField
    Local nFields

    Local nSC1Recno
    Local nCNTMonths

    Local nC1Num
    Local nC1Item
    Local nC1Quant
    Local nC1XPreco
    Local nC1XTotal
    Local nC1XNumSC
    Local nC1DATPRF
    Local nC1XItemSC
    Local nC1XDATPRF
    Local nC1XDTPPAG
    Local nC1Z0LINKD

    Local nSZ2Order        := RetOrder( "SZ2" , "Z2_FILIAL+Z2_CODIGO+Z2_NUMSC+Z2_ITEMSC+Z2_SECITEM" )
    Local nSZ3Order        := RetOrder( "SZ3" , "Z3_FILIAL+Z3_NUMSC" )

    Local uFPut

    Private cA110Num

    Private INCLUI        := lInclui
    Private ALTERA        := lAltera

    BEGIN SEQUENCE

        IF ( lAltera )
            BREAK
        EndIF

        SC1->( dbSetOrder( RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" ) ) )

        cC1KeySeek    := cSC1Filial
        cC1KeySeek    += cNumSC

        IF SC1->( !dbSeek( cC1KeySeek , .F. ) )
            BREAK
        EndIF

        nSC1Recno    := SC1->( Recno() )

        SC1->( StaticCall( NDJLIB003 , LockSoft , "SC1" ) )

        lC1XREFCNT            := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XREFCNT" , .T. )
        DEFAULT lC1XREFCNT    := .F.

        IF !( lC1XREFCNT )
            BREAK
        EndIF

        cC1XNUMSC     := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_XNUMSC" , .T. )
        lC1XREFCNT    := ( Empty( cC1XNUMSC ) .or. ( cC1XNUMSC == cNumSC ) )

        IF !( lC1XREFCNT )
            BREAK
        EndIF

        aItens        := {}
        nItens        := 0
        aSC1Recnos    := {}

        SC1->( MsGoto( nSC1Recno ) )

        While SC1->( !Eof() .and. ( ( C1_FILIAL+C1_NUM ) == cC1KeySeek ) )
            IF !( SC1->( StaticCall( NDJLIB003 , LockSoft , "SC1" ) ) )
                BREAK
            EndIF
            ++nItens
            SC1->( aAdd( aSC1Recnos , Recno() ) )
            SC1->( aAdd( aItens , StaticCall( NDJLIB001 , RegToArray ) ) )
            SC1->( dbSkip() )
        End While

        IF ( nItens == 0 )
            BREAK
        EndIF

        SC1->( MsGoto( nSC1Recno ) )

        IF ( lInclui )

            aSC1Struct    := SC1->( dbStruct() )

            nC1Num        := SC1->( FieldPos( "C1_NUM"      ) )
            nC1Item        := SC1->( FieldPos( "C1_ITEM"      ) )
            nC1Quant    := SC1->( FieldPos( "C1_QUANT"      ) )
            nC1XPreco    := SC1->( FieldPos( "C1_XPRECO"      ) )
            nC1XTotal    := SC1->( FieldPos( "C1_XTOTAL"      ) )
            nC1XNumSC    := SC1->( FieldPos( "C1_XNUMSC"  ) )
            nC1DATPRF    := SC1->( FieldPos( "C1_DATPRF"  ) )
            nC1XItemSC    := SC1->( FieldPos( "C1_XITEMSC" ) )
            nC1XDATPRF    := SC1->( FieldPos( "C1_XDATPRF" ) )
            nC1XDTPPAG    := SC1->( FieldPos( "C1_XDTPPAG" ) )
            nC1Z0LINKD    := SC1->( FieldPos( "C1_Z0LINKD" ) )

            aPeriodos    := {}

            nQtd        := aItens[ 1 ][ nC1Quant   ]
            dC1DATPRF    := aItens[ 1 ][ nC1DATPRF  ]
            dC1XDTPPAG    := aItens[ 1 ][ nC1XDTPPAG ]
            dC1XDATPRF    := aItens[ 1 ][ nC1XDATPRF ]
            dLastYDate    := LastYDate( @dC1XDTPPAG )
            nCNTMonths    := DateDiffMonth( @dLastYDate , @dC1XDTPPAG )
            ++nCNTMonths

            IF ( nQtd <= nCNTMonths )
                BREAK
            EndIF

            IF Empty( dC1XDATPRF )
                dC1XDATPRF    := dC1XDTPPAG
                lC1XDATPRF    := .T.
            EndIF

            IF Empty( dC1DATPRF )
                dC1DATPRF    := dC1XDTPPAG
                lC1DATPRF    := .T.
            EndIF

            aAdd( aPeriodos , { nCNTMonths , dC1XDTPPAG , dC1XDATPRF , dC1DATPRF } )
            nQtd -= nCNTMonths

            While ( nQtd > 12 )
                nQtd -= 12
                dC1XDTPPAG        := YearSum( dC1XDTPPAG , 1 )
                dC1XDTPPAG        := FirstYDate( dC1XDTPPAG )
                dC1DATPRF        := YearSum( dC1DATPRF  , 1 )
                IF ( lC1DATPRF )
                    dC1DATPRF    := FirstYDate( dC1DATPRF )
                EndIF
                dC1XDATPRF        := YearSum( dC1XDATPRF , 1 )
                IF ( lC1XDATPRF )
                    dC1XDATPRF    := FirstYDate( dC1XDATPRF )
                EndIF
                aAdd( aPeriodos , { 12 , dC1XDTPPAG , dC1XDATPRF , dC1DATPRF } )
            End While

            IF ( nQtd > 0 )
                dC1XDTPPAG        := YearSum( dC1XDTPPAG , 1 )
                dC1XDTPPAG        := FirstYDate( dC1XDTPPAG )
                dC1DATPRF        := YearSum( dC1DATPRF  , 1 )
                IF ( lC1DATPRF )
                    dC1DATPRF    := FirstYDate( dC1DATPRF )
                EndIF
                dC1XDATPRF        := YearSum( dC1XDATPRF , 1 )
                IF ( lC1XDATPRF )
                    dC1XDATPRF    := FirstYDate( dC1XDATPRF )
                EndIF
                aAdd( aPeriodos , { nQtd , dC1XDTPPAG , dC1XDATPRF , dC1DATPRF } )
            EndIF

            nEL    := Len( aPeriodos )
            IF ( nEL == 0 )
                BREAK
            EndIF

            For nBL := 1 To nEL

                nQtd        := aPeriodos[ nBL ][ 1 ]
                dC1XDTPPAG    := aPeriodos[ nBL ][ 2 ]
                dC1XDATPRF    := aPeriodos[ nBL ][ 3 ]
                dC1DATPRF    := aPeriodos[ nBL ][ 4 ]

                lAddNew    := !( nBL == 1 )
                IF ( lAddNew )
                    IF !( StaticCall( U_SC1FLDVLD , C1NumVld , @cA110Num , .F. ) )
                        Loop
                    EndIF
                Else
                    cA110Num    := cNumSC
                EndIF

                For nItem := 1 To nItens

                    IF !( lAddNew )
                        SC1->( MsGoto( aSC1Recnos[ nItem ] ) )
                    EndIF

                    IF SC1->( RecLock( "SC1" , lAddNew ) )

                        nVal    := aItens[ nItem ][ nC1XPreco ]
                        nFields    := Len( aItens[ nItem ] )
    
                        For nField := 1 To nFields

                            DO CASE
                            CASE ( ( nField == nC1Num ) .and. ( lAddNew ) )
                                uFPut    := cA110Num
                            CASE ( nField == nC1Quant    )
                                uFPut    := nQtd
                            CASE ( nField == nC1XNumSC  )
                                uFPut    := cNumSC
                            CASE ( nField == nC1XItemSC )
                                uFPut    := aItens[ nItem ][ nC1Item ]
                            CASE ( nField == nC1XTotal )
                                uFPut    := ( nQtd * nVal )
                            CASE ( nField == nC1XDATPRF )
                                uFPut    := dC1XDATPRF
                            CASE ( nField == nC1XDTPPAG )
                                uFPut    := dC1XDTPPAG
                            CASE ( nField == nC1DATPRF )
                                uFPut    := dC1DATPRF
                            CASE ( ( nField == nC1Z0LINKD ) .and. ( lAddNew ) )
                                uFPut    := .F.
                            OTHERWISE
                                uFPut    := aItens[ nItem ][ nField ]
                            ENDCASE

                            StaticCall( NDJLIB001 , SetMemVar , aSC1Struct[ nField ][ DBS_NAME ] , uFPut , .T. )

                            SC1->( FieldPut( nField , uFPut ) )

                            uFPut        := NIL

                        Next nField

                        SC1->( MsUnLock() )

                        SC1->( StaticCall( NDJLIB003 , LockSoft , "SC1" ) )

                        IF !( lAddNew )
                            StaticCall( U_NDJBLKSCVL , C1QuantVld , nC1Quant , .F. )    //Verifica os Valores de Empenho
                        EndIF    

                        StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC1" )                //Verifica os Links do SC1 com o SZ0

                        ReplicaDest( @cNumSC , @cA110Num , @cSZ3Filial , @nSZ3Order , @cSZ2Filial , @nSZ2Order )

                    EndIF
    
                Next nItem

            Next nBL

            SC1->( MsGoto( nSC1Recno ) )

            SC1->( dbSetOrder( RetOrder( "SC1" , "C1_FILIAL+C1_NUM+C1_ITEM" ) ) )
            SC1->( !MsSeek( cC1KeySeek , .F. ) )

            StaticCall( U_M110STTS , SendMail , @cNumSC )
            StaticCall( U_RpcSCPMSChk , SCPMSChk )

        EndIF

    END SEQUENCE
    
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

    RestArea( aArea )    

Return( NIL )

/*/
    Funcao:     ReplicaDest()
    Autor:        Marinaldo de Jesus
    Data:        29/06/2011
    Descricao:    Verificar se Os Destinos deverao ser Replicados
/*/
Static Function ReplicaDest( cNumSC , cA110Num , cSZ3Filial , nSZ3Order , cSZ2Filial , nSZ2Order )

    Local aSZ3Fields
    Local aSZ2Fields

    Local cC1XSZ2Cod
    Local cSZ2KeySeek

    Local lAddNew        := .F.
    Local lReplicate    := .F.

    Local nField
    Local nFields

    Local nZ2Quant
    Local nZ2NumSC
    Local nZ2ItemSC

    Local nZ3NumSC

    Local uFPut

    BEGIN SEQUENCE

        SZ3->( dbSetOrder( nSZ3Order ) )
        IF SZ3->( !dbSeek( cSZ3Filial + cNumSC , .F. ) )
            BREAK
        EndIF

        SZ3->( StaticCall( U_NDJA001 , lUseC1ToZ3 , cSZ3Filial , Z3_CODIGO , .F. , .F. ) )

        SZ3->( StaticCall( NDJLIB003 , LockSoft , "SZ3" ) )

        aSZ3Fields     := SZ3->( StaticCall( NDJLIB001 , RegToArray , "SZ3" ) )

        SZ3->( dbSetOrder( nSZ3Order ) )
        lAddNew    := SZ3->( !dbSeek( cSZ3Filial + cA110Num , .F. ) )
        IF SZ3->( !RecLock( "SZ3" , lAddNew ) )
            BREAK
        EndIF
        nZ3NumSC    := SZ3->( FieldPos( "Z3_NUMSC" ) )
        nFields        := Len( aSZ3Fields )
        For nField := 1 To nFields
            DO CASE
            CASE ( nField == nZ3NumSC )
                uFPut    := cA110Num
            OTHERWISE
                uFPut    := aSZ3Fields[ nField ]
            ENDCASE
            SZ3->( FieldPut( nField , uFPut ) )
        Next nField
        SZ3->( MsUnLock() )
        SZ3->( StaticCall( NDJLIB003 , LockSoft , "SZ3" ) )

        cC1XSZ2Cod    := SZ3->Z3_CODIGO

        SZ3->( StaticCall( U_NDJA001 , SZ2SZ3TTS ) )

        cSZ2KeySeek    := cSZ2Filial
        cSZ2KeySeek    += cC1XSZ2Cod
        cSZ2KeySeek    += cNumSC
        cSZ2KeySeek    += SC1->C1_ITEM

        SZ2->( dbSetOrder( nSZ2Order ) )

        IF SZ2->( !dbSeek( cSZ2KeySeek , .F. ) )
            BREAK
        EndIF

        aSZ2Fields     := SZ2->( StaticCall( NDJLIB001 , RegToArray , "SZ2" ) )

        cSZ2KeySeek    := cSZ2Filial
        cSZ2KeySeek    += cC1XSZ2Cod
        cSZ2KeySeek    += cA110Num
        cSZ2KeySeek    += SC1->C1_ITEM

        lAddNew        := SZ2->( !dbSeek( cSZ2KeySeek , .F. ) )

        nZ2Quant    := SZ2->( FieldPos( "Z2_QUANT"   ) )
        nZ2NumSC    := SZ2->( FieldPos( "Z2_NUMSC"   ) )
        nZ2ItemSC    := SZ2->( FieldPos( "Z2_ITEMSC"  ) )

        IF SZ2->( !RecLock( "SZ2" , lAddNew ) )
            BREAK
        EndIF

        nFields        := Len( aSZ2Fields )
        For nField := 1 To nFields
            DO CASE
            CASE ( nField == nZ2NumSC )
                uFPut    := cA110Num
            CASE ( nField == nZ2ItemSC )
                uFPut    := SC1->C1_ITEM 
            CASE ( nField == nZ2Quant )
                uFPut    := SC1->C1_QUANT
            OTHERWISE
                uFPut    := aSZ2Fields[ nField ]
            ENDCASE
            SZ2->( FieldPut( nField , uFPut ) )
        Next nField

        SZ2->( MsUnLock() )
        SZ2->( StaticCall( NDJLIB003 , LockSoft , "SZ2" ) )

        lReplicate    := .T.

    END SEQUENCE

Return( lReplicate )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        __A220ToSC()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
