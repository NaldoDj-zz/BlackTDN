#INCLUDE "NDJ.CH"
/*/
    Funcao: MT140SAI
    Autor:    Marinaldo de Jesus
    Data:    07/01/2010
    Uso:    Executada a partir da A140NFiscal em MATA140.
            Sera utilizado para efetivar os Links entre os Destinos da Pre-Nota.
/*/
User Function MT140SAI()

    Local aArea            := GetArea()
    Local aLstSF1SD1
    Local aNewSF1SD1

    Local cLoja
    Local cTipo
    Local cSerie
    Local cA100For
    Local cNFiscal
    Local cSF1Filial    := xFilial( "SF1" )
    
    Local lInclui        := .F.
    Local lDeleta        := .F.
    Local lModify        := .F.
    Local lNDJAtesto    := .F.
    Local lSetDeleted    := .F.

    Local nOpc
    Local nOpcA
    Local nRecSF1
    Local nSF1Order        := RetOrder( "SF1" , "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO" )

    TRYEXCEPTION 

        //Forca o Commit das Alteracoes de Destinos
        StaticCall( U_NDJA002 , SZ4SZ5Commit )

        //Forca o Commit das Alteracoes de Empenho
        StaticCall( U_NDJBLKSCVL , SZ0TTSCommit )

        nOpc            := ParamIxb[1]
        cNFiscal        := ParamIxb[2]
        cSerie            := ParamIxb[3]
        cA100For        := ParamIxb[4]
        cLoja            := ParamIxb[5]
        cTipo            := ParamIxb[6]

        lNDJAtesto        := ( IsInCallStack( "NDJAtesto" ) .or. IsInCallStack( "NDJRecusa" ) )
        nOpcA            := StaticCall( NDJLIB006 , ReadStackParameters , Upper( "A140NFiscal" ) , Upper( "nOpcA" ) )

        IF (;
                ( lNDJAtesto );
                .or.;
                ( nOpc == 2 );
            )    
            IF ( lNDJAtesto )
                StaticCall( NDJLIB001 , SetMemVar , "nOpcaNDJAt" , nOpcA , .T. , .F. )
            EndIF    
            BREAK
        EndIF

        lDeleta            := ( nOpc == 5 )    //Exclusao de Pre-Nota
        IF !( lDeleta )
            lInclui        := ( nOpc == 3 )    //Inclusao de Pre-Nota
        EndIF    

        IF ( nOpcA == 1 )
            //Obtem a Pilha de Valores de SF1 e SD1 Antes da Gravacao
            aLstSF1SD1        := StaticCall( U_MT140APV , SF1SD1Arr , .F. , !( Inclui ) , .F. )
            IF !( lDeleta )
                IF (;
                        !( lInclui );
                        .and.;
                        !Empty( aLstSF1SD1 );
                    )    
                    //Obtem a Pilha de Valores de SF1 e SD1 Apos a Gravacao
                    aNewSF1SD1        := StaticCall( U_MT140APV , SF1SD1Arr , .F. , .F. , .F. )
                    //Verifica se Ocorreu alguma Modificacao
                    lModify    := !( ArrayCompare( aLstSF1SD1 , aNewSF1SD1 ) )
                    IF !( lModify )
                        BREAK
                    EndIF
                EndIF
                ForceAtesto( @cNFiscal , @cSerie ,  @cA100For , @cLoja , @cTipo )
            Else
                lModify    := .F.    
            EndIF
        EndIF

        //Garanto o Posicionamento na SF1 conforme parametros
        cSF1KeySeek := cSF1Filial
        cSF1KeySeek += cNFiscal
        cSF1KeySeek += cSerie
        cSF1KeySeek += cA100For
        cSF1KeySeek += cLoja
        cSF1KeySeek += cTipo

        SF1->( dbSetOrder( nSF1Order ) )

        IF ( lDeleta )
            lSetDeleted := Set( _SET_DELETED , .F. )
        EndIF
        
        IF SF1->( MsSeek( cSF1KeySeek , .F. ) )
            nRecSF1 := SF1->( Recno() )
        EndIF

        IF ( lDeleta )
            Set( _SET_DELETED , lSetDeleted )
        EndIF

        //Verifica os Links da SD1 com a AFN
        StaticCall( U_SD1ToAFN , SD1ToAFN , @nRecSF1 , @cNFiscal , @cSerie , @cA100For , @cLoja , @cTipo , @lDeleta )

        //Envia as Solicitacoes de Atesto
        IF ( nOpcA == 1 )
            StaticCall( U_MTA140MNU , NDJSolAtesto , @nRecSF1 , @lModify , @lDeleta , @aLstSF1SD1 )
        EndIF

    CATCHEXCEPTION USING oException

        IF ( ValType( oException ) == "O" )
            cMsgHelp := oException:Description
            Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
            ConOut( CaptureError( .T. ) )
        EndIF

    ENDEXCEPTION

    //Limpa a Pilha de Valores de SF1 e SD1
    StaticCall( U_MT140APV , SF1SD1Arr , .F. , .F. , .T. ) 
    
    IF !( lNDJAtesto )
        IF !( SD1->( RddName() ) == "TOPCONN" )
            SD1->( dbCloseArea() )
            ChkFile( "SD1" )
        EndIF
    EndIF

    //Libera os Locks Pendentes
    StaticCall( NDJLIB003 , AliasUnLock )

    //Start da verificacao dos Links da SZ4/SZ5 vs SD1
    StaticCall( U_NDJA002 , SZ4ChkLnk , .T. )

    //Reinicializa a Variavel Publica __nSZ5LstRec
    StaticCall( NDJLIB004 , SetPublic , "__nSZ5LstRec" , 0 , "N" , 0 , .T. )

    RestArea( aArea )

Return( NIL )

/*/
    Funcao: ForceAtesto
    Autor:    Marinaldo de Jesus
    Data:    30/01/2011
    Uso:    Forcar o Atesto se Ocorreu Alguma Alteracao na Pre-Nota
/*/
Static Function ForceAtesto( cNFiscal , cSerie , cA100For , cLoja , cTipo )

    Local aArea            := GetArea()
    Local aAreaSF1        := SF1->( GetArea() )
    Local aAreaSD1        := SD1->( GetArea() )
    Local aAreaSB1        := SB1->( GetArea() )
    
    Local cCodUsr        := StaticCall( NDJLIB014 , RetCodUsr )
    Local cXAtesto        := "A"    //A=Aguardando Atesto
    Local cObsAtesto    := ""
    Local cSF1Filial    := xFilial( "SF1" )
    Local cSD1Filial    := xFilial( "SD1" )
    Local cSB1Filial    := xFilial( "SB1" )

    Local cSF1KeySeek
    Local cSD1KeySeek
    Local cSB1KeySeek
    
    Local lB1Atesta        := .T.
    Local lChkFull        := .F.
    
    Local nSF1Recno        := 0
    Local nSF1Order        := RetOrder( "SF1" , "F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO" )
    Local nSD1Order     := RetOrder( "SD1" , "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM" )
    Local nSB1Order        := RetOrder( "SB1" , "B1_FILIAL+B1_COD" )

    cSF1KeySeek := cSF1Filial
    cSF1KeySeek += cNFiscal
    cSF1KeySeek += cSerie
    cSF1KeySeek += cA100For
    cSF1KeySeek += cLoja
    cSF1KeySeek += cTipo

    SF1->( dbSetOrder( nSF1Order ) )
    IF SF1->( dbSeek( cSF1KeySeek , .F. ) )
    
        nSF1Recno    := SF1->( Recno() )

        cSD1KeySeek := cSD1Filial
        cSD1KeySeek += cNFiscal
        cSD1KeySeek += cSerie
        cSD1KeySeek += cA100For
        cSD1KeySeek += cLoja

        SD1->( dbSetOrder( nSD1Order ) )
        IF SD1->( dbSeek( cSD1KeySeek , .F. ) )
            While SD1->(;
                            !Eof();
                            .and.;
                            ( cSD1KeySeek == D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA );
                        )
                IF ( SD1->D1_TIPO == cTipo )
                    IF SD1->( RecLock( "SD1" , .F.) )
                        cSB1KeySeek    := ( cSB1Filial + SD1->D1_COD )
                        lB1Atesta    := ( Posicione( "SB1" , @nSB1Order , @cSB1KeySeek , "B1_XATESTO" ) == "1" )
                        IF ( lB1Atesta )
                            SD1->D1_XATESTO    := cXAtesto //A=Aguardando Atesto
                            SD1->D1_XCUSERA    := Space( GetSX3Cache( "D1_XCUSERA" , "X3_TAMANHO" ) )
                            SD1->D1_XDTATES    := Ctod("")
                            SD1->D1_XHRATES    := Space( GetSX3Cache( "D1_XHRATES" , "X3_TAMANHO" ) )
                        Else
                            cObsAtesto         := "Atesto Automático pois o Produto Cod.: " + SD1->D1_COD
                            cObsAtesto         += "Desc.: " + AllTrim( Posicione( "SB1" , @nSB1Order , @cSB1KeySeek , "B1_DESC" ) )
                            cObsAtesto         += " não necessita de Atesto"
                            SD1->D1_XATESTO    := "S" //S=Atestado
                            SD1->D1_XCUSERA    := cCodUsr
                            SD1->D1_XDTATES    := MsDate()
                            SD1->D1_XHRATES    := Time()
                            SD1->D1_XOBS       := cObsAtesto
                            lChkFull        := .T.
                        EndIF
                        SD1->( MsUnLock() )
                    EndIF
                EndIF
                SD1->( dbSkip() )
            End While
        EndIF

        IF SF1->( RecLock( "SF1" , .F. ) )
            IF (;
                    ( lChkFull );
                    .and.;
                    ( StaticCall( U_MTA140MNU , NDJFullAtesto , @nSF1Recno , "S" ) );
                )    
                cXAtesto := "S"    //S=Atestada
            EndIF
            SF1->F1_XATESTO := cXAtesto
            SF1->( MsUnLock() )
        EndIF

    EndIF    

    RestArea( aAreaSB1 )
    RestArea( aAreaSD1 )
    RestArea( aAreaSF1 )
    RestArea( aArea )

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
