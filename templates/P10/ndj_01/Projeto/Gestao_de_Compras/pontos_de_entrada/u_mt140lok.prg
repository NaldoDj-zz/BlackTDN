#INCLUDE "NDJ.CH"
/*/
    Funcao:     MT140LOK()
    Autor:        Marinaldo de Jesus
    Data:        08/08/2011
    Descricao:    Validar a Linha OK na GetDados de Pré-Nota de Entrada, Programa MATA140
/*/
User Function MT140LOK()

    Local lLinOk    := .T.

    BEGIN SEQUENCE

        //Nao Valida Item Deletado
        IF GdDeleted()
            BREAK
        EndIF

        //Verificar se Os Destinos deverao ser Replicados
        ReplicaDest()

        //Valida o Conteudo do Campo D1_XSZ2COD
        lLinOk := StaticCall( U_NDJA002 , D1XSZ2CodVld )
        IF !( lLinOk )
            BREAK
        EndIF

        //Valida a Quantidade do campo D1_QUANT de Acordo com a Quantidade em Destinos Z4_QUANT
        lLinOk := ChkD1Quant()
        IF !( lLinOk )
            BREAK
        EndIF

        //Atualiza As informacoes Dependentes de D1_TOTAL
        lLinOk :=  StaticCall(U_SD1FLDVLD,D1QUANTVld)
        IF !( lLinOk )
            BREAK
        EndIF

        //Atualiza As informacoes Dependentes de D1_TOTAL
        lLinOk :=  StaticCall(U_SD1FLDVLD,D1VUNITVld)
        IF !( lLinOk )
            BREAK
        EndIF

    END SEQUENCE

Return( lLinOk )

/*/
    Funcao:     ReplicaDest()
    Autor:        Marinaldo de Jesus
    Data:        29/06/2011
    Descricao:    Verificar se Os Destinos deverao ser Replicados
/*/
Static Function ReplicaDest()

    Local aSZ5Fields
    Local aSZ4Fields

    Local cSZ5Filial
    Local cSZ4Filial
    Local cD1XSZ2Cod
    Local cSZ4KeySeek

    Local cD1XNumSc
    Local cD1XItemSc
    Local cD1XSequen

    Local lDRepeat
    Local lReplicate    := .F.
    
    Local nSZ4Order
    Local nSZ5Order

    Local nRecno
    Local nField
    Local nFields
    Local nD1Quant

    Local nZ5NumSC

    Local nZ4Quant
    Local nZ4NumSC
    Local nZ4SecItem

    BEGIN SEQUENCE

        IF !( IsInCallStack( "NDJPreNFA" ) )
            BREAK
        EndIF

        cSZ5Filial        := xFilial( "SZ5" )
        cSZ4Filial        := xFilial( "SZ4" , cSZ5Filial )

        nSZ4Order        := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
        nSZ5Order        := RetOrder( "SZ5" , "Z5_FILIAL+Z5_NUMSC" )

        IF !( Type( "__nSZ5LstRec" ) == "N" )
            BREAK
        EndIF

        SZ5->( MsGoto( __nSZ5LstRec ) )
        IF SZ5->( Eof() .or. Bof() )
            BREAK
        EndIF

        lDRepeat := StaticCall( NDJLIB001 , __FieldGet , "SZ5" , "Z5_DREPEAT" , .T. )
        DEFAULT lDRepeat := .F.

        IF !( lDRepeat )
            BREAK
        EndIF

        IF !( StaticCall( NDJLIB001 , IsInGetDados , { "D1_XNUMSC" , "D1_XITEMSC" , "D1_XSEQUEN" , "D1_QUANT" } ) )
            BREAK
        EndIF

        aSZ5Fields    := SZ5->( StaticCall( NDJLIB001 , RegToArray , "SZ5" ) )

        cD1XNumSc    := GdFieldGet( "D1_XNUMSC"  )

        SZ5->( dbSetOrder( nSZ5Order ) )
        IF SZ5->( !dbSeek( cSZ5Filial + cD1XNumSc , .F. ) )
            IF SZ5->( !RecLock( "SZ5" , .T. ) )
                BREAK
            EndIF
            nZ5NumSC    := SZ5->( FieldPos( "Z5_NUMSC" ) )
            nFields        := Len( aSZ5Fields )
            For nField := 1 To nFields
                DO CASE
                CASE ( nField == nZ5NumSC )
                    SZ5->( FieldPut( nField , cD1XNumSc ) )
                OTHERWISE
                    SZ5->( FieldPut( nField , aSZ5Fields[ nField ] ) )
                ENDCASE
            Next nField
            SZ5->( MsUnLock() )
            SZ5->( StaticCall( NDJLIB003 , LockSoft , "SZ5" ) )
            __nSZ5LstRec    := SZ5->( Recno() )
        Else
            SZ5->( StaticCall( NDJLIB003 , LockSoft , "SZ5" ) )
        EndIF

        SZ5->( StaticCall( U_NDJA002 , SZ4SZ5TTS ) )

        cD1XSZ2Cod    := StaticCall( NDJLIB001 , __FieldGet , "SZ5" , "Z5_CODIGO" , .T. )

        cD1XItemSc    := GdFieldGet( "D1_XITEMSC" )
        cD1XSequen    := GdFieldGet( "D1_XSEQUEN" )

        nD1Quant    := GdFieldGet( "D1_QUANT" )

        cSZ4KeySeek    := cSZ4Filial
        cSZ4KeySeek    += cD1XSZ2Cod
        cSZ4KeySeek    += cD1XNumSc
        cSZ4KeySeek    += cD1XItemSc
        cSZ4KeySeek    += cD1XSequen

        SZ4->( dbSetOrder( nSZ4Order ) )
                    
        IF SZ4->( dbSeek( cSZ4KeySeek , .F. ) )
            BREAK
        EndIF

        cSZ4KeySeek    := cSZ4Filial
        cSZ4KeySeek    += cD1XSZ2Cod

        IF SZ4->( !dbSeek( cSZ4KeySeek , .F. ) )
            BREAK
        EndIF

        While SZ4->( !Eof() .and. ( cSZ4KeySeek == Z4_FILIAL+Z4_CODIGO ) )
            nRecno    := SZ4->( Recno() )
            SZ4->( dbSkip() )
        End While

        SZ4->( dbGoTo( nRecno ) )
        IF SZ4->( Bof() .or. Eof() )
            BREAK
        EndIF

        aSZ4Fields     := SZ4->( StaticCall( NDJLIB001 , RegToArray , "SZ4" ) )

        nZ4Quant    := SZ4->( FieldPos( "Z4_QUANT"  ) )

        nZ4NumSC    := SZ4->( FieldPos( "Z4_NUMSC"   ) )
        nZ4ItemSC    := SZ4->( FieldPos( "Z4_ITEMSC"  ) )
        nZ4SecItem    := SZ4->( FieldPos( "Z4_SECITEM" ) )

        IF SZ4->( !RecLock( "SZ4" , .T. ) )
            BREAK
        EndIF

        nFields        := Len( aSZ4Fields )
        For nField := 1 To nFields
            DO CASE
            CASE ( nField == nZ4NumSC )
                SZ4->( FieldPut( nField , cD1XNumSc ) )
            CASE ( nField == nZ4ItemSC )
                SZ4->( FieldPut( nField , cD1XItemSc ) )
            CASE ( nField == nZ4SecItem )
                SZ4->( FieldPut( nField , cD1XSequen ) )
            CASE ( nField == nZ4Quant )
                SZ4->( FieldPut( nField , nD1Quant ) )
            OTHERWISE
                SZ4->( FieldPut( nField , aSZ4Fields[ nField ] ) )
            ENDCASE
        Next nField

        SZ4->( MsUnLock() )
        SZ4->( StaticCall( NDJLIB003 , LockSoft , "SZ4" ) )

        StaticCall( U_NDJA002 , lUseD1ToZ5 , xFilial( "SZ5" ) , cD1XSZ2Cod , .F. , .F. )

        StaticCall( NDJLIB001 , __FieldPut , "SD1" , "D1_XSZ2COD" , cD1XSZ2Cod , .F. )

        lReplicate    := .T.

        StaticCall( U_NDJA002 , SZ4ChkLnk , .F. )

    END SEQUENCE

Return( lReplicate )

/*/
    Funcao:     ChkD1Quant()
    Autor:        Marinaldo de Jesus
    Data:        29/06/2011
    Descricao:    Verificar se a quantidade Informada no D1_QUANT esta OK
/*/
Static Function ChkD1Quant()

    Local cD1XNumSc
    Local cD1XItemSC
    Local cD1XSequen

    Local cSZ4Filial
    Local cD1XSZ2Cod
    Local cSZ4KeySeek

    Local lD1QuantOk    := .T.

    Local nD1Quant        := 0
    Local nZ4Quant        := 0
    Local nSZ4Order
    
    BEGIN SEQUENCE

        IF !( StaticCall( NDJLIB001 , IsInGetDados , { "D1_QUANT" , "D1_XSZ2COD" , "D1_XNUMSC" , "D1_XITEMSC" , "D1_XSEQUEN" } ) )
            BREAK
        EndIF

        nD1Quant    := GdFieldGet( "D1_QUANT" )

        cD1XNumSc    := GdFieldGet( "D1_XNUMSC"  )
        cD1XItemSc    := GdFieldGet( "D1_XITEMSC" )
        cD1XSequen    := GdFieldGet( "D1_XSEQUEN" )
        cD1XSZ2Cod    := GdFieldGet( "D1_XSZ2COD" )

        nSZ4Order    := RetOrder( "SZ4" , "Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM" )
            
        SZ4->( dbSetOrder( nSZ4Order ) )

        cSZ4Filial    := xFilial( "SZ4" )
            
        cSZ4KeySeek    := cSZ4Filial
        cSZ4KeySeek    += cD1XSZ2Cod
        cSZ4KeySeek    += cD1XNumSc
        cSZ4KeySeek    += cD1XItemSC
        cSZ4KeySeek    += cD1XSequen

        lD1QuantOk    := SZ4->( dbSeek( cSZ4KeySeek , .F. ) )
        IF !( lD1QuantOk )
            Help( "" , 1 , "D1XSZ2COD" , NIL , OemToAnsi( "Destino não Localizado" ) , 1 , 0 )
            BREAK
        EndIF

        While SZ4->( !Eof() .and. Z4_FILIAL+Z4_CODIGO+Z4_NUMSC+Z4_ITEMSC+Z4_SECITEM == cSZ4KeySeek )
            nZ4Quant += SZ4->Z4_QUANT
            SZ4->( dbSkip() )
        End While
    
        lD1QuantOk := ( nZ4Quant == nD1Quant )

        IF !( lD1QuantOk )
            Help( "" , 1 , "Z4QUANT" , NIL , OemToAnsi( "Quantidade Informada não Corresponde ao Total informado nos Destinos" ) , 1 , 0 )
            BREAK
        EndIF

    END SEQUENCE

Return( lD1QuantOk )

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
