#INCLUDE "NDJ.CH"
/*/
    Funcao:        MT110VLD
    Data:        24/11/2010
    Autor:        Marinaldo de Jesus
    Descricao:    Ponto de Entrada para validar a Inclusao de uma Solicitacao de Compras
                Sera utilizado para definir que a inclusao de uma SC devera ser permitida
                apenas pelo PMS
/*/
User Function MT110VLD()

    Local cNumSC
    Local cITemSC
    
    Local cModulo        := "SIGAPMS"
    Local cModDesc        := ""
    Local cMsgHelp      := ""

    Local cC1COTACAO
    Local cSC7KeySeek
    Local cSC8KeySeek

    Local lPms            := .F.
    Local lOk            := .T.

    Local nPms            := 0
    Local nRecno        := SC1->( Recno() )
    Local nOpcX            := IF( ( ( Type( "ParamIxb" ) == "A" ) .and. ( Len( ParamIxb ) >= 1 ) ) , ParamIxb[1] , 0 )
    Local nC1QUJE
    
    Local nSC7Order
    Local nSC8Order

    BEGIN SEQUENCE

        //Utilizo o PE mais Externo para Garantir a Liberacao de Todos os Locks Pendentes
        StaticCall( NDJLIB003 , AliasUnLock )

        nOpcX    := IF( ( ValType( nOpcX ) == "N" ) , nOpcX , 0 )
        IF (;
                ( nOpcX == 3 );        //Inclusao
                .or.;
                IsInCallStack( "A110Inclui" );
            )
            lPms    := IsInCallStack( "PMSA410" )
            lOk        := ( lPms )    //Apenas pelo PMS
            IF !( lOk )
                nPms := aScan( RetModName() , { |aModulo| Upper( AllTrim( aModulo[2] ) ) == cModulo } )
                IF ( nPms > 0 )
                    cModDesc := RetModName()[nPms][3] 
                EndIF
                cMsgHelp := "A solicitação de Compras só poderá ser incluida pelo Ambiente " + cModDesc + CRLF
                cMsgHelp += "Módulo: " + cModulo + CRLF
                cMsgHelp += "Programa: PMSA410"
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                BREAK
            EndIF
        EndIF

        IF (;
                ( nOpcX == 4 );    //Alteracao
                .or.;
                IsInCallStack( "A110Altera" );
            )

            lOk    := !( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_MSBLQL" , .T. ) == "1" )     // "1" Bloqueada
            IF !( lOk )
                cMsgHelp := "Esta Solicitação de Compras encontra-se Bloqueada"
                IF ( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_APROV" , .T. ) == "R" )
                    cMsgHelp += " em função de 'Recusa' "
                EndIF
                cMsgHelp += " e, por isso, não pode ser alterada"
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                BREAK
            EndIF
            lPms    := IsInCallStack( "PMSA410" )
            IF ( lPms )
                lOk    := ( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_APROV" , .T. ) $ "1,2" )     // "1"-Em Pre-Analise;"2"-Suspensa ou Aguardando Alteracoes
                IF !( lOk )
                    cMsgHelp := "Esta Solicitação Encontra-se em Processo de Compra" 
                    cMsgHelp += " e, por isso, não pode ser alterada"
                    Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                    BREAK
                EndIF
            EndIF

            cNumSC        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_NUM"    , .T. )
            cITemSC        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_ITEM"    , .T. )

            nSC7Order    := RetOrder( "SC7" , "C7_FILIAL+C7_NUMSC+C7_ITEMSC" )
            SC7->( dbSetOrder( nSC7Order ) )
            cSC7KeySeek    := xFilial( "SC7" )
            cSC7KeySeek    += cNumSC
            cSC7KeySeek    += cITemSC
            lOk            := SC7->( !dbSeek( cSC7KeySeek , .F. ) )
            IF !( lOk )
                cMsgHelp := "Esta Solicitação Encontra-se em Processo de Compras" 
                cMsgHelp += " e, por isso, não pode ser alterada"
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                BREAK
            EndIF

            nSC8Order    := RetOrder( "SC8" , "C8_FILIAL+C8_NUMSC+C8_ITEMSC" )
            SC8->( dbSetOrder( nSC8Order ) )
            cSC8KeySeek    := xFilial( "SC8" )
            cSC8KeySeek    += cNumSC
            cSC8KeySeek    += cITemSC
            lOk            := SC8->( !dbSeek( cSC8KeySeek , .F. ) )
            IF !( lOk )
                cMsgHelp := "Esta Solicitação Encontra-se em Processo de Cotação" 
                cMsgHelp += " e, por isso, não pode ser alterada"
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                BREAK
            EndIF

        EndIF

        IF (;
                ( nOpcX == 5 );        //Exclusao
                .or.;
                IsInCallStack( "A110Deleta" );
            )

            lOk        := ( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_APROV" , .T. ) $ "1,2" )     // "1"-Em Pre-Analise;"2"-Suspensa ou Aguardando Alteracoes
            IF !( lOk )
                IF ( StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_MSBLQL" , .T. ) == "1" )
                    cMsgHelp := "Esta Solicitação Encontra-se em Bloqueada"
                    cMsgHelp += " e, por isso, não pode ser excluida"
                Else
                    cMsgHelp := "Esta Solicitação Encontra-se em Processo de Compra"
                    cMsgHelp += " e, por isso, não pode ser excluida"
                EndIF
                Help( "" , 1 , ProcName() , NIL , OemToAnsi( cMsgHelp ) , 1 , 0 )
                BREAK
            EndIF

            lPms    := IsInCallStack( "PMSA410" )

            IF ( lPms ) 
                
                //Conceito Anterior Permitia a Exclusao no PMS revisto em 10/05/2011 de acordo com o tiquete: 
                //#209538: Solicitação [ERP - Protheus] SC após liberadarejeitada, não pode ser alterada
                
                IF ( lOk )
                    nC1QUJE        := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_QUJE"    , .T. )
                    cC1COTACAO    := StaticCall( NDJLIB001 , __FieldGet , "SC1" , "C1_COTACAO" , .T. )
                    lOk            := ( ( nC1QUJE == 0 ) .and. Empty( cC1COTACAO ) )
                EndIF    
            
            EndIF

            IF ( lOk )
                lOk := .F.
                IF !( IsBlind() )
                    IF !MsgYesNo( "Solicitação não Pode ser ex]cluida. Deseja Bloquea-la?" , ProcName() )
                        BREAK
                    EndIF
                    StaticCall( U_MT110ROT , PutC1Aprov , @nRecno , "R" )                        //Rejeita a SC
                    StaticCall( U_MT110ROT , PutC1Aprov , @nRecno , "R" , .F. , .T. , .T. )    //Se o Status for Rejeitado, Bloqueia o Registro para uso C1_MSBLQL == "1"
                EndIF
            EndIF

        EndIF

        //Nao Permito a liberacao dos Locks da SZ2 e SZ3 na Inclusao de Destinos
        StaticCall( NDJLIB003 , IFreeLocks , "SZ2" )
        StaticCall( NDJLIB003 , IFreeLocks , "SZ3" )

    END SEQUENCE

Return( lOk )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        MMFrmMail()
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
