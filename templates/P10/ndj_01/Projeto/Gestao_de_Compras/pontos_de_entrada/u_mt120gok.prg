#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT120GOK
    Data:        03/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada executado em A120Pedido no progama MATA120.
                Executado apos a gravacao do Pedido sera usado para verificar itens pendentes.
/*/
User Function MT120GOK()

    Local cA120Num
    Local l120Inclui
    Local l120Altera
    Local l120Deleta
    
    BEGIN SEQUENCE
    
        cA120Num    := ParamIxb[1]
        l120Inclui    := ParamIxb[2]
        l120Altera    := ParamIxb[3]
        l120Deleta    := ParamIxb[4]

        IF ( l120Inclui )
            GCTAprova( @cA120Num )
            MT120C7SZ0( cA120Num , .F. )
            BREAK
        EndIF

        IF ( l120Altera )
            MT120C7SZ0( cA120Num , .F. )
            BREAK
        EndIF

        IF ( l120Deleta )
            MT120C7SZ0( cA120Num , .T. )
            BREAK
        EndIF

    END SEQUENCE

    //Forca o Commit das Alteracoes de Destinos
    StaticCall( U_NDJA002 , SZ4SZ5Commit )

    StaticCall( NDJLIB003 , AliasUnLock )

Return( NIL )

/*/
    Funcao:        MT120C7SZ0
    Data:        03/12/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Verifica os Vinculos da SC7 com a SZ0
/*/
Static Function MT120C7SZ0( cA120Num , lDeleta )

    Local aArea            := GetArea()
    Local aAreaSC7        := SC7->( GetArea() )

    Local cAlias        := GetNextAlias()

    Local cQuery        := ""

    Local cSC7Filial    := xFilial( "SC7" )

    Local nRecno

    cQuery := "SELECT" + __cCRLF
    cQuery += "        SC7.R_E_C_N_O_ SC7RECNO" + __cCRLF
    cQuery += "FROM" + __cCRLF
    cQuery += "        " + RetSqlName("SC7") + " SC7 " + __cCRLF
    cQuery += "WHERE" + __cCRLF
    IF ( lDeleta )
        cQuery += "        SC7.D_E_L_E_T_ = '*'" + __cCRLF
    Else
        cQuery += "        SC7.D_E_L_E_T_ = ' '" + __cCRLF
    EndIF    
    cQuery += "AND" + __cCRLF
    cQuery += "        SC7.C7_FILIAL = '" + cSC7Filial + "'" + __cCRLF
    cQuery += "AND" + __cCRLF
    cQuery += "        SC7.C7_NUM = '" + cA120Num + "'" + __cCRLF

    TCQUERY ( cQuery ) ALIAS ( cAlias ) NEW

    TcSetField( cAlias , "SC7RECNO" , "N" , 15 , 0 )

    While ( cAlias )->( !Eof() )
        nRecno    := ( cAlias )->SC7RECNO
        SC7->( dbGoto( nRecno ) )
        IF SC7->( !Eof() .and. !Bof() )
            StaticCall( U_NDJBLKSCVL , AliasSZ0Lnk , "SC7" , @lDeleta ) //Verifica os Links do SC7 com o SZ0
        EndIF
        ( cAlias )->( dbSkip() )
    End While

    //Forca o Commit das Alteracoes de Empenho
    StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

    RestArea( aAreaSC7 )
    RestArea( aArea )

Return( NIL )

/*/
    Programa:    GCTAprova
    Autor:        Marinaldo de Jesus
    Data:        17/02/2011
    Uso:        Sera utilizado para Modificar o Status do campo C7_CONAPRO de "B"loqueado para "L"iberado e alterar o conteudo do campo C7_APROV infor
                mando o Grupo de Aprovadores correspondentes a Contratos.
/*/
Static Function GCTAprova( cA120Num )

    Local cDBMS
    Local cQuery
    Local cSC7Table
    Local cGCTGrupo
    Local cTCSrvType
    Local cSC7Filial
    Local cSALFilial
    
    Local lAs400
    Local lGrvInGCT            := IsInCallStack( "CN120GrvPeD" )    //Apenas se o Pedido Veio de Contratos
    Local lGCTGrupo
    
    Local nSALOrder

    BEGIN SEQUENCE

        IF !( lGrvInGCT )    
            BREAK
        EndIF
    
        cGCTGrupo            := AllTrim( GetNewPar( "NDJ_GAPGCT" , "" ) )    //Grupo de Usuarios de Aprovadores do GCT. Conforme Tabela SAL
        IF Empty( cGCTGrupo )
            BREAK
        EndIF

        cSALFilial            := xFilial( "SAL" )
        nSALOrder            := RetOrder( "SAL" , "AL_FILIAL+AL_COD" )
        
        lGCTGrupo            := SAL->( dbSeek( cSALFilial + cGCTGrupo , .F. ) )
        IF !( lGCTGrupo )
            BREAK
        EndIF
    
        cTCSrvType            := TcSrvType()
        lAs400                := ( cTCSrvType == "AS/400" )
    
        cSC7Table            := RetSqlname( "SC7" )
        cSC7Filial            := xFilial( "SC7" )
    
        //Atualiza o Grupo de Aprovadores, Substituindo o Grupo de Aprovadores Informado pelo Sistema pelo Grupo de Aprovadores do GCT
        cQuery                 := "UPDATE" + __cCRLF
        cQuery                 += "        " + cSC7Table + __cCRLF
        cQuery                 += "SET" + __cCRLF
        cQuery                 += "        C7_APROV='" + cGCTGrupo + "'" + __cCRLF
        cQuery                 += "WHERE " + __cCRLF
        cQuery                 += "        C7_FILIAL='" + cSC7Filial + "'" + __cCRLF
        cQuery                 += "AND" + __cCRLF
        cQuery                 += "        C7_NUM='" + cA120Num +"'" + __cCRLF
        cQuery                 += "AND" + __cCRLF
        cQuery                 += "        C7_APROV<>'" + cGCTGrupo + "'" + __cCRLF
        IF ( lAs400 )
            cQuery             += "AND" + __cCRLF
            cQuery            += "    @DELETED@<>'*'" + __cCRLF
        Else
            cQuery             += "AND" + __cCRLF
            cQuery            += "    D_E_L_E_T_<>'*'" + __cCRLF
        EndIF
    
        cQuery                := StaticCall( NDJLIB001 , ClearQuery , cQuery )
        
        TcSqlExec( cQuery )
    
        //Deixa o Pedido como Liberado caso o Grupo de Aprovadores seja do GCT
        cQuery                 := "UPDATE" + __cCRLF
        cQuery                 += "        " + cSC7Table + __cCRLF
        cQuery                 += "SET" + __cCRLF
        cQuery                 += "        C7_CONAPRO='L'" + __cCRLF
        cQuery                 += "WHERE " + __cCRLF
        cQuery                 += "        C7_FILIAL='" + cSC7Filial + "'" + __cCRLF
        cQuery                 += "AND" + __cCRLF
        cQuery                 += "        C7_NUM='" + cA120Num +"'" + __cCRLF
        cQuery                 += "AND" + __cCRLF
        cQuery                 += "        C7_APROV='" + cGCTGrupo + "'" + __cCRLF
        IF ( lAs400 )
            cQuery             += "AND" + __cCRLF
            cQuery            += "    @DELETED@<>'*'" + __cCRLF
        Else
            cQuery             += "AND" + __cCRLF
            cQuery            += "    D_E_L_E_T_<>'*'" + __cCRLF
        EndIF

        cQuery                := StaticCall( NDJLIB001 , ClearQuery , cQuery )

        TcSqlExec( cQuery )

        IF ( Type( "__TTSInUse" ) == "L" )
            cDBMS :=  Upper( Alltrim( TCGetDb() ) )
            IF (;
                    ( "ORACLE" $ cDBMS );
                    .and.;
                    ( __TTSInUse );
                )
                TcSqlExec( "COMMIT" )
            EndIF
        EndIF
    
    END SEQUENCE

Return( NIL )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
