#INCLUDE "PAN-AMERICANA.CH"
#INCLUDE "U_PANLIB02.CH"

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?efine o Numero Maximo de Locks.                             ?
?                                                          ?
?ax AdsLockRecord (5000), else Lock table full.              ?
?                                                            ?
? Locks > 5000 == Maximum number of locks exceeded )          ?
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
#DEFINE __MaxAdsLockRecord__    4950 //DEFAULT ( 5000 - 50 ) Reservo, no minimo, 50 Locks para Operacoes de Sistema
Static __nMaxAdsLockRecord__    := GetAdsLckRec()

/*/
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?tatics Utilizadas para Controle de Locks e Codigos Excluivos?
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static __aLockRegs__    := {}
Static __aMayIUseCode__    := {}
Static __nMayIUseCode__    := 0

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд?
?rograma  ?ANLIB02  ?utor?arinaldo de Jesus       ?Data ?6/11/2009?
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд?
?escri┤└o ?liblioteca de Funcoes Genericas da PAN   para Geracao de Nu?
?         ?eracao Automatica                                           ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                    ?
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?           ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           ?
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд?
?rogramador ?ata      ?ro. Ocorr.?otivo da Alteracao                ?
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд?
?           ?         ?          ?                                  ?
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддд?*/
/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
?un┤└o    ?_LIB02Exec      ?utor ?arinaldo de Jesus   ?Data ?6/11/2009?
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
?escri┤└o ?xecutar Funcoes Dentro de PANLIB02                          ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?intaxe   ?_LIB02Exec( cExecIn , aFormParam )                             ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?arametros?Vide Parametros Formais>                                     ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?etorno   ?Ret                                                          ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?bserva┤└o?                                                              ?
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
?so       ?enerico                                                      ?
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function LIB02Exec( cExecIn , aFormParam )
         
    Local uRet
    
    DEFAULT cExecIn        := ""
    DEFAULT aFormParam    := {}
    
    IF !Empty( cExecIn )
        cExecIn    := BldcExecInFun( cExecIn , aFormParam )
        uRet    := &( cExecIn )
    EndIF
    
Return( uRet )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?hileNoLock        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?hamada a LockRegsCode() atraves da WhileYesNoWait()        ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?LockOk                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function WhileNoLock(    cAlias            ,;    //01 -> Alias 
                                    aRegsLock        ,;    //02 -> Array com os Recnos
                                aKeysCode        ,;    //03 -> Array com as Chaves
                                nTentaLocks        ,;    //04 -> Numero de Tentativas
                                nSecondsWait    ,;    //05 -> Segundos a Aguardar para Nova Tentativa
                                lMayIUseCode    ,;    //06 -> Se Usara MayIUseCode()
                                nMaxLocks        ,;    //07 -> Numero Maximo de Locks
                                nWaiting        ,;    //08 -> Vezes a Executar ProcWaiting()
                                bLockRegsCode    ,;    //09 -> Bloco a Ser Executado
                                lShowProc         ;    //10 -> Se ira Mostrar Mensagens
                            )

    Local lLockOk                    := .F.
    
    Local cTitleInfo
    Local cMsgYesNo
    Local cTitleYesNo
    Local cTitleProc
    Local cMsgInfo
    Local cProcWaiting
    
    DEFAULT aRegsLock                := {}
    DEFAULT aKeysCode                := {}
    DEFAULT nTentaLocks             := 5
    DEFAULT nSecondsWait            := 1
    DEFAULT lMayIUseCode            := .F.
    DEFAULT nMaxLocks                := __nMaxAdsLockRecord__
    DEFAULT nWaiting                := 5
    DEFAULT bLockRegsCode            := { || LockRegsCode( cAlias , aRegsLock , aKeysCode , nTentaLocks , nSecondsWait , lMayIUseCode , nMaxLocks ) }
    DEFAULT lShowProc                 := .T.
    
    IF ( lShowProc )
    
        cTitleInfo        := STR0001    //"Aviso!"
        cMsgYesNo        := STR0002    //"Tentar novamente?"
        cTitleYesNo        := STR0003    //"Reserva de Registros"
        cTitleProc        := STR0004    //"Aguarde..."
    
        IF (;
                ( Len( aRegsLock ) > 1 );
                .or.;
                ( Len( aKeysCode ) > 1 );
            )
            cMsgInfo        := OemToAnsi( STR0005 )    //"Os Registros est? reservados para outro usu═rio."
            cProcWaiting    := OemToAnsi( STR0006 )    //"Tentando reservar os registros."
        Else
            cMsgInfo        := OemToAnsi( STR0007 )    //"O Registro est═ reservado para outro usu═rio."
            cProcWaiting    := OemToAnsi( STR0008 )    //"Tentando reservar o registro."
        EndIF
    
        lLockOk := WhileYesNoWait(;
                                        bLockRegsCode    ,;    //Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
                                        nWaiting        ,;    //Numero de Vezes que a ProcWaiting() sera executada
                                        .T.                ,;    //Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
                                        cMsgInfo        ,;    //Mensagem de Corpo para a MsgInfo
                                        cTitleInfo        ,;    //Titulo para a MsgInfo 
                                        cMsgYesNo        ,;    //Mensagem de Corpo para a MsgYesNo
                                        cTitleYesNo        ,;    //Titulo para a MsgYesNo
                                        cProcWaiting    ,;    //Mensagem de corpo para a ProcWaiting
                                        cTitleProc         ;    //Titulo para a ProcWaiting
                                    )
    Else
    
        lLockOk := Eval( bLockRegsCode )
    
    EndIF

Return( lLockOk )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?ockRegsCode    ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?entativa de Lock em Varios Registros e/ou reserva de codigo?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?Locked                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function LockRegsCode(    cAlias            ,;    //01 -> Alias onde os Registros devera haver Lock dos Registros
                                   aRegsLock        ,;    //02 -> Array com os Recnos para Lock
                                aKeysCode        ,;    //03 -> Array com as Chaves para MayIUseCode
                                nTentaLocks        ,;    //04 -> Numero de Tentativas de Lock
                                nSecondsWait    ,;    //05 -> Segundos a aguardar para nova tentativa
                                lMayIUseCode    ,;    //06 -> Se ira utilizar MayIUseCode
                                nMaxLocks         ;    //07 -> Numero maximo de Locks
                            )

    Local lLocked := .T.
    
    DEFAULT cAlias            := Alias()
    DEFAULT aRegsLock        := {}
    DEFAULT aKeysCode        := {}
    DEFAULT nTentaLocks        := 1
    DEFAULT nSecondsWait    := 1
    DEFAULT lMayIUseCode    := .F.
    
    nTentaLocks := Max( nTentaLocks , 1 )
    
    Begin Sequence
    
        IF (;
                ( lMayIUseCode );
                .and.;
                !Empty( aKeysCode );
             )
            MySetMaxCode( Len( aKeysCode ) )
            IF !( lLocked := ( UseCode( cAlias , aKeysCode , nTentaLocks , nSecondsWait ) ) )
                FreeCodeUsed( cAlias )
                Break
            EndIF
        EndIF
        
        IF !Empty( aRegsLock )
            IF !( lLocked := ( MultLocks( cAlias , aRegsLock , nTentaLocks , nSecondsWait , nMaxLocks ) ) )
                IF ( lMayIUseCode )
                    FreeCodeUsed( cAlias )
                EndIF
            EndIF
        EndIF
    
    End Sequence

Return( lLocked )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?ySetMaxCode    ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?etorna o Numero Maximo de Codigos a Serem Setados pela  Set?
?         ?axCode()                                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?MyMaxCode                                                     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MySetMaxCode( nMyMaxCode )

    Static nOldMaxCode    := SetMaxCode( _SET_MAX_CODE )
    
    DEFAULT nMyMaxCode    := nOldMaxCode
    
Return( SetMaxCode( Max( nOldMaxCode , nMyMaxCode ) ) )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?reeLocks        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?ibera todos os Semaforos e Locks conseguidos pela    funcao?
?         ?ockRegs()                                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function FreeLocks( cAlias , uReg , lFreeUseCode , uUseCode )

    Local lExistAls            := ( cAlias     <> NIL )
    Local lExistReg         := ( uReg       <> NIL )
    Local lExistCode        := ( uUseCode    <> NIL )
    
    Local cUseCode
    Local cTypeReg
    Local cTypeUseCode
    Local nReg
    Local nPosReg
    Local nTotReg
    
    DEFAULT lFreeUseCode    := .F.
    
    IF (;
            ( lExistReg );
            .or.;
            ( lExistCode );
         )
        IF ( lExistAls )
            IF ( lExistReg )
                cTypeReg    := ValType( uReg )
                IF ( cTypeReg == "N" )
                    DEFAULT nReg := uReg
                    ( cAlias )->( UnLockRegs( cAlias , nReg ) )
                ElseIF ( cTypeReg == "A" )
                    nTotReg := Len( uReg )
                    For nPosReg := 1 To nTotReg
                        nReg := uReg[ nPosReg ]
                        ( cAlias )->( UnLockRegs( cAlias , nReg ) )
                    Next nPosReg
                EndIF
            EndIF    
            IF (;
                    ( lExistCode );
                    .and.;
                    ( lFreeUseCode );
                 )
                cTypeUseCode    := ValType( uUseCode )
                IF ( cTypeUseCode == "C" )
                    DEFAULT cUseCode := uUseCode
                    FreeCodeUsed( cAlias , cUseCode )
                ElseIF ( cTypeUseCode == "A" )
                    nTotReg := Len( uUseCode )
                    For nPosReg := 1 To nTotReg
                        cUseCode := uUseCode[ nPosReg ]
                        FreeCodeUsed( cAlias , cUseCode )
                    Next nPosReg
                EndIF    
            EndIF
        EndIF    
    Else    
        IF ( lExistAls )
            cAlias := Upper( AllTrim( cAlias ) )
            IF ( Select( cAlias ) > 0 )
                ( cAlias )->( UnLockRegs( cAlias , NIL ) )
            EndIF
            IF ( ( nPosReg := aScan( __aLockRegs__ , { |x| ( x == cAlias ) } ) ) > 0 )
                __aLockRegs__[ nPosReg ] := ""
            EndIF
            IF ( lFreeUseCode )
                FreeCodeUsed( cAlias )
            EndIF
        Else
            nTotReg := Len( __aLockRegs__ )
            For nPosReg := 1 To nTotReg
                cAlias    := __aLockRegs__[ nPosReg ]
                IF ( Select( cAlias ) > 0 )
                    ( cAlias )->( UnLockRegs( cAlias , NIL ) )
                EndIF    
            Next nPosReg
            __aLockRegs__ := {}
            IF ( lFreeUseCode )
                FreeCodeUsed()
            EndIF
        EndIF
    EndIF

Return( NIL )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?axWorkAreas      ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?etorna o Numero Maximo de Areas de Trabalho                ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?etorna o Numero Maximo de Areas de Trabalho                ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                        ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MaxWorkAreas()
Return( Val( GetPvProfString( GetEnvServer() , "MaxWorkAreas" , "512" , GetAdv97() ) ) )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?llRegsLocks      ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?umero de Locks Existentes em Todas as Areas de Trabalho    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?umero de Locks Existentes em Todas as Areas de Trabalho    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                        ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function AllRegsLocks( nSelect )

    Local cFirstAls    := "__cFirstAlsAllRegsLocks__"
    Local nLocks     := 0
    
    Local adbrLockLists
    Local cAlias
    Local nArea
    Local nLocksArea
    Local nPosRecZero
    
    IF ( nSelect == NIL )
        nSelect     := 0
        cFirstAls    := Alias( nSelect )
        nAreas        := MaxWorkAreas()
    Else
        nAreas    := nSelect
    EndIF    
    
    nArea := ( nSelect - 1 )
    While ( ( ++nArea ) <= nAreas )
        cAlias := Alias( nArea )
        IF ( Empty( cAlias ) )
            Exit
        EndIF
        IF ( cAlias == cFirstAls )
            IF ( nArea <> nSelect )
                Loop
            EndIF
        EndIF
        adbrLockLists    := ( cAlias )->( dbrLockLists() )
        nLocksArea        := Len( adbrLockLists )
        nPosRecZero        := 0
        While ( aScan( adbrLockLists , { |x| ( x == 0 ) } , ++nPosRecZero ) > 0 )
            --nLocksArea
        End While
        nLocks += nLocksArea
    End While

Return( nLocks )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?ultLocks        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?entativa de Lock em Varios Registros                         ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?Locked                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?onLockRegs                                                    ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MultLocks( cAlias , aRegsLock , nTentaLocks , nSecondsWait , nMaxLocks )
                
    Local lLocksOk                := .F.
    Local lTentaLocks            := .T.
    
    Local nTentouLock
    Local nReg
    Local nTotRegs
    Local nAllRegsLocks
    Local nSelect
    
    DEFAULT cAlias                    := Alias()
    DEFAULT aRegsLock                := {}
    DEFAULT nTentaLocks                := 1
    DEFAULT nSecondsWait            := 1
    DEFAULT nMaxLocks                := __nMaxAdsLockRecord__
    
    nTentaLocks := Max( nTentaLocks , 1 )
    
    Begin Sequence
    
        IF ( lLocksOk := MaxAdsLckRec() )
            Break        
        EndIF
    
        cAlias    := Upper( AllTrim( cAlias ) )
        nSelect    := Select( cAlias )
    
        IF ( aScan( __aLockRegs__ , { |x| ( x == cAlias ) } ) == 0 )
            IF ( ( nReg := aScan( __aLockRegs__ , { |x| Empty( x ) } ) ) == 0 )
                aAdd( __aLockRegs__ , cAlias )
            Else
                __aLockRegs__[ nReg ] := cAlias
            EndIF
        EndIF        
    
        nSecondsWait *= 1000
    
        nTotRegs := Len( aRegsLock )
        For nReg := 1 To nTotRegs
    
            IF ( lLocksOk := ( IsLocked( cAlias , aRegsLock[ nReg ] ) ) )
                Loop
            EndIF
    
            IF ( lLocksOk := MaxAdsLckRec() )
                Break
            EndIF
    
            nAllRegsLocks := AllRegsLocks( nSelect )
            IF ( lLocksOk := ( ( ++nAllRegsLocks ) > nMaxLocks ) )
                Exit
            EndIF
    
            lTentaLocks    := .T.
            nTentouLock    := 0
            While ( lTentaLocks )
                IF !( lLocksOk := ( cAlias )->( MsRLock( aRegsLock[ nReg ] ) ) )
                    ( cAlias )->( MsGoto( aRegsLock[ nReg ] ) )
                    IF ( ( ++nTentouLock ) > nTentaLocks )
                        nTentouLock := 0
                        lTentaLocks    := .F.
                        Exit
                    EndIF
                    Sleep( nSecondsWait )
                    IF ( lLocksOk := MaxAdsLckRec() )
                        Break
                    EndIF
                Else
                    nTentouLock := 0
                    lTentaLocks    := .F.
                    Exit
                EndIF    
            End While
        
            IF !( lLocksOk )                     
                Exit
            EndIF
    
        Next nReg
    
    End Sequence
        
Return( lLocksOk )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?seCode            ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?arantir a Exclusividade de Um usuario sobre um Grupo de Cha?
?         ?es                                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?Locked                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function UseCode( cAlias , uKeysCode , nTentaUseCode , nSecondsWait )

    Local lOkMayIUseCode    := .T.
    
    Local aKeysCode
    Local cKeyCode
    Local lMayIUseCode
    Local nMayIUseCode
    Local nLoop
    Local nLoops
    Local nPosAlias
    
    DEFAULT cAlias            := Alias()
    DEFAULT nTentaUseCode    := 1
    DEFAULT nSecondsWait    := 1
    
    nTentaUseCode := Max( nTentaUseCode , 1 )
    
    DEFAULT __aMayIUseCode__    := {}
    DEFAULT __nMayIUseCode__    := 0
    
    IF ( ValType( uKeysCode ) == "C" )
        aKeysCode := { uKeysCode }
    Else
        aKeysCode := uKeysCode
    EndIF
    
    IF !Empty( aKeysCode )
        nLoops := Len( aKeysCode )
        IF ( ( nPosAlias := aScan( __aMayIUseCode__ , { |x| ( x[1] == cAlias ) } ) ) == 0 )
            aAdd( __aMayIUseCode__ , { cAlias , {} } )
            nPosAlias := Len( __aMayIUseCode__ )
        EndIF
        nSecondsWait *= 1000
        For nLoop := 1 To nLoops
            cKeyCode := Upper( AllTrim( ( cAlias + aKeysCode[ nLoop ] ) ) )
            IF ( aScan( __aMayIUseCode__[ nPosAlias , 02 ] , { |x| ( x == cKeyCode ) } ) > 0 )
                Loop
            EndIF
            MySetMaxCode( ( __nMayIUseCode__ + 1 ) )
            lMayIUseCode    := .T.
            nMayIUseCode    := 0
            While ( lMayIUseCode )
                IF !( lOkMayIUseCode := MayIUseCode( cKeyCode ) )
                    IF ( ( ++nMayIUseCode ) > nTentaUseCode )
                        nMayIUseCode    := 0
                        lMayIUseCode    := .F.
                        Exit
                    EndIF
                    Sleep( nSecondsWait )
                Else
                    nMayIUseCode    := 0
                    lMayIUseCode    := .F.
                    Exit
                EndIF
            End While
            IF !( lOkMayIUseCode )
                Exit
            EndIF
            aAdd( __aMayIUseCode__[ nPosAlias , 02 ] , cKeyCode )
            ++__nMayIUseCode__
        Next nLoop
    EndIF

Return( lOkMayIUseCode )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?etCodeMayIUse    ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?etorna Array onde o primeiro Elemento eh o numero de   Codi?
?         ?os em uso e o segundo Elemento eh o Array com os codigos em?
?         ?so                                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?Locked                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function GetCodeMayIUse()
Return( { __nMayIUseCode__ , __aMayIUseCode__ } )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?reeCodeUsed     ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?ibera as Chaves Reservadas pela UseCode()                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                          ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                       ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function FreeCodeUsed( cAlias , cCodeUsed )

    Local lExistAls := ( cAlias <> NIL )
    Local lExistCod    := ( cCodeUsed <> NIL )
    
    Local cKeyCode
    Local nLoop
    Local nLoops
    Local nLoop1
    Local nLoops1
    Local nLastSize
    Local nPosAls
    Local nPosCod
    
    DEFAULT __aMayIUseCode__    := {}
    DEFAULT __nMayIUseCode__ := 0
    
    cAlias := Upper( AllTrim( cAlias ) )
    
    Begin Sequence
    
        IF ( lExistAls )
            IF ( ( nPosAls := aScan( __aMayIUseCode__ , { |x| ( x[1] == cAlias ) } ) ) == 0 )
                Break
            EndIF
            IF ( lExistCod )
                cKeyCode := Upper( AllTrim( cAlias+cCodeUsed ) )
                IF ( ( nPosCod := aScan( __aMayIUseCode__[ nPosAls , 02 ] , { |x| ( x == cKeyCode ) } ) ) == 0 )
                    Break
                EndIF
            EndIF
        EndIF
        
        DEFAULT nPosAls := 1
        IF ( lExistAls )
            nLoops := nPosAls
        Else
            nLoops := Len( __aMayIUseCode__ )
        EndIF
        For nLoop := nPosAls To nLoops
            IF ( lExistCod )
                nLoops1 := nPosCod
            Else
                nPosCod := 1
                nLoops1 := Len( __aMayIUseCode__[ nLoop , 02 ] )
            EndIF    
            For nLoop1 := nPosCod To nLoops1
                Leave1Code( __aMayIUseCode__[ nLoop , 02 , nLoop1 ] )
                --__nMayIUseCode__
            Next nLoop1
        Next nLoop
    
        IF ( lExistAls )
            IF ( lExistCod )
                nLastSize := Len( __aMayIUseCode__[ nPosAls , 02 ] )
                aDel( __aMayIUseCode__[ nPosAls , 02 ] , nPosCod )
                aSize( __aMayIUseCode__[ nPosAls , 02 ] , --nLastSize )
                IF ( nLastSize <= 0 )
                    nLastSize := Len( __aMayIUseCode__ )
                    aDel( __aMayIUseCode__ , nPosAls )
                    aSize( __aMayIUseCode__ , --nLastSize )
                EndIF
            Else
                nLastSize := Len( __aMayIUseCode__ )
                aDel( __aMayIUseCode__ , nPosAls )
                aSize( __aMayIUseCode__ , --nLastSize )
            EndIF    
        EndIF
    
    End Sequence
    
    __nMayIUseCode__ := Max( __nMayIUseCode__ , 0 )
    
    IF ( __nMayIUseCode__ == 0 )
        __aMayIUseCode__ := {}
    ElseIF Empty( __aMayIUseCode__ )
        __nMayIUseCode__ := 0    
    EndIF

Return( NIL )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?nLockRegs        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?iberar os Locks                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?UnLockOk                                                      ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function UnLockRegs( cAlias , nReg )

    Local lUnLockOk    := .T.
    Local lExistAls    := ( cAlias <> NIL )
    Local lExistReg    := ( nReg <> NIL )
    
    Local nArea
    
    Begin Sequence
    
        IF ( lExistReg )
            DEFAULT cAlias := Alias()
            cAlias := Upper( AllTrim( cAlias ) )
            IF ( nReg > 0 )
                While ( IsLocked( cAlias , nReg ) )
                    ( cAlias )->( MsGoto( nReg ) )
                    ( cAlias )->( MsRUnlock( nReg ) )
                End While    
            EndIF
        Else
            IF ( lExistAls )
                cAlias    := Upper( AllTrim( cAlias ) )
                nArea    := Select( cAlias )
                IF !( lUnLockOk := ( AllRegsLocks( nArea ) > 0 ) )
                    Break
                EndIF
            EndIF
            IF ( lExistAls )
                nArea    := Select( cAlias )
                While ( AllRegsLocks( nArea ) > 0 )
                    ( cAlias )->( dbUnLock() )
                End While
            Else
                nArea := MaxWorkAreas()
                While ( nArea >= 0 )
                    IF !( Empty( cAlias := Alias( nArea ) ) )
                        While ( AllRegsLocks( nArea ) > 0 )
                            ( cAlias )->( dbUnLock() )
                        End While
                    EndIF
                    --nArea
                End While
            EndIF    
        EndIF
    
    End Sequence
    
    IF ( lExistAls )
        IF ( lExistReg )
            lUnLockOk := !( IsLocked( cAlias , nReg ) )
        Else
            lUnLockOk := ( AllRegsLocks( Select( cAlias ) ) == 0 )
        EndIF
    Else
        lUnLockOk := ( AllRegsLocks() == 0 )
    EndIF

Return( lUnLockOk )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?sLocked        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?erifica se um determinado Recno esta na pilha de Locks        ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                          ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function IsLocked( cAlias , nRecno )

Local lIsLocked

DEFAULT cAlias    := Alias()
DEFAULT nRecno    := ( cAlias )->( Recno() )

lIsLocked := ( aScan( ( cAlias )->( dbrLockLists() ) , nRecno ) > 0 )

Return( lIsLocked )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?axAdsLckRec    ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?erifica se Excedeu o Numero Maximo de Locks permitidos pelo?
?         ?DS                                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                          ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function MaxAdsLckRec( nAllRegsLocks )

    nAllRegsLocks := AllRegsLocks()

Return( ( nAllRegsLocks >= __nMaxAdsLockRecord__ ) )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?etAdsLckRec    ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?btem o Numero Maximo de Locks Definido no ADSLOCAL.CFG     ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                          ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function GetAdsLckRec()

    Local nNumberDataLocks    := Val( GetPvProfString( "SETTINGS" , "LOCKS" , "5000" , "ADSLOCAL.CFG" ) )
    
    IF Empty( nNumberDataLocks )
        nNumberDataLocks := __MaxAdsLockRecord__
    Else
        nNumberDataLocks -= 50 //Reservo, no minimo, 50 Locks para Operacoes de Sistema
    EndIF
    
Return( nNumberDataLocks )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o       ?stGetAdsLckRec ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?einicializa __nMaxAdsLockRecord__                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?etorno   ?IL                                                          ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function RstGetAdsLckRec()

    __nMaxAdsLockRecord__ := GetAdsLckRec()

Return( __nMaxAdsLockRecord__ )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?etNewCodigo ?utor?arinaldo de Jesus    ?Data ?6/11/2009?
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?btem Nova Numeracao Exclusiva utilizando GetNrExclOk       ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?bter Numeracao Exclusiva                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function GetNewCodigo(    cAlias        ,;    //Alias para a Numeracao Exclusiva
                                   cFldNumExc    ,;    //Campo para a Numeracao Exclusiva
                                cIndexKey    ,;    //Chave de Indice para Pesquisa
                                bGetNumExc    ,;    //Bloco com a Funcao para Retorno da Numeracao Exclusiva
                                lExistChav    ,;    //Se Executara Existe chave, cMDJ contrario dbSeek()
                                lShowHelp    ,;    //Se Devera Mostrar Help cMDJ hava inconsistencia
                                cKeyAuxP    ,;    //Chave Auxiliar para pesquisa ( "P"refixo )
                                cKeyAuxS    ,;    //Chave Auxiliar para pesquisa ( "S"ufixo  )
                                cLstCodigo    ,;    //Codigo Anterior que sera validado na verificacao de Exclusividade
                                lChkFil         ;    //Se deve Considerar o Campo Filial
                             )

    Local cNewCodigo := cLstCodigo
    
    GetNrExclOk(    @cNewCodigo ,;    //Numeracao Exclusiva ( Por Referencia )
                    cAlias        ,;    //Alias para a Numeracao Exclusiva
                    cFldNumExc    ,;    //Campo para a Numeracao Exclusiva
                    cIndexKey    ,;    //Chave de Indice para Pesquisa
                    bGetNumExc    ,;    //Bloco com a Funcao para Retorno da Numeracao Exclusiva
                    lExistChav    ,;    //Se Executara Existe chave, cMDJ contrario dbSeek()
                    lShowHelp    ,;    //Se Devera Mostrar Help cMDJ hava inconsistencia
                    cKeyAuxP    ,;    //Chave Auxiliar para pesquisa ( "P"refixo )
                    cKeyAuxS    ,;    //Chave Auxiliar para pesquisa ( "S"ufixo  )
                    lChkFil         ;    //Se deve Considerar o Campo Filial
                )
    
DEFAULT cNewCodigo := Space( GetSx3Cache( cFldNumExc , "X3_TAMANHO" ) )

Return( cNewCodigo )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?etNrExclOk  ?utor?arinaldo de Jesus    ?Data ?6/11/2009?
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?erifica se a Numeracao Exclusiva Esta Ok                   ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?alidar e/ou Obter Numeracao Exclusiva                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function GetNrExclOk(    cRetNumExcl ,;    //Numeracao Exclusiva ( Por Referencia )
                                   cAlias        ,;    //Alias para a Numeracao Exclusiva
                                cFldNumExc    ,;    //Campo para a Numeracao Exclusiva
                                cIndexKey    ,;    //Chave de Indice para Pesquisa
                                bGetNumExc    ,;    //Bloco com a Funcao para Retorno da Numeracao Exclusiva
                                lExistChav    ,;    //Se Executara Existe chave, cMDJ contrario dbSeek()
                                lShowHelp    ,;    //Se Devera Mostrar Help cMDJ hava inconsistencia
                                cKeyAuxP    ,;    //Chave Auxiliar para pesquisa ( "P"refixo )
                                cKeyAuxS    ,;    //Chave Auxiliar para pesquisa ( "S"ufixo  )
                                lChkFil         ;    //Se deve Considerar o Campo Filial
                            )

    Local lGetNumExclOk        := .F.
    Local lExistKeyAux        := ( ( ValType( cKeyAuxP ) == "C" ) .or. ( ValType( cKeyAuxS ) == "C" ) )
    Local nSvMaxCode        := SetMaxCode( _SET_MAX_CODE )
    Local nCodesUse            := 0
    
    Local cPrefixoCpo
    Local cFieldFil
    Local cAlsNumExc
    Local cKeySeek
    Local cArqInd
    Local cUseCode
    Local cX2Path
    Local lFound
    Local nFldNumExc
    Local nFieldFil
    Local nSvRecno
    Local nOrder
    
    SetMaxCode( Max( nSvMaxCode , _SET_MAX_CODE ) )
    
    DEFAULT cAlias            := Alias()
    cAlias                    := Upper( AllTrim( cAlias ) )
    nSvOrder                := ( cAlias )->( IndexOrd() )
    DEFAULT lExistChav        := .F.
    DEFAULT cKeyAuxP        := ""
    DEFAULT cKeyAuxS        := ""
    DEFAULT lChkFil            := .T.
    
    IF ( lExistChav )
        DEFAULT lShowHelp    := .T.
    Else
        DEFAULT lShowHelp    := .F.
    EndIF
    
    IF ( Type( "Inclui" ) <> "L" )
        Private Inclui := .F.
    EndIF
    
    IF ( Type( "__n"+cAlias+"SvRecno__" ) == "N" )
        nSvRecno := __ExecMacro( "__n"+cAlias+"SvRecno__" )
    Else
        nSvRecno := ( cAlias )->( Recno() )
    EndIF
    
    Begin Sequence
    
        nFldNumExc := ( cAlias )->( FieldPos( cFldNumExc ) )
        IF ( nFldNumExc > 0 )
            DEFAULT bGetNumExc    := { || GetSx8Num( cAlias , cFldNumExc , cAlsNumExc , nOrder ) }
        Else
            DEFAULT bGetNumExc    := { || Soma1( cRetNumExcl ) }
        EndIF
    
        IF !( lExistKeyAux )
    
            cPrefixoCpo := ( PrefixoCpo( cAlias ) + "_" )
            cFieldFil    := cPrefixoCpo + "FILIAL"
            nFieldFil    := ( cAlias )->( FieldPos( cFieldFil ) )
    
            IF ( Empty( cIndexKey ) )
                IF (;
                        ( nFieldFil > 0 );
                        .and.;
                        ( lChkFil );
                    )    
                    cIndexKey := ( cFieldFil + "+" + cFldNumExc )
                Else
                    cIndexKey := cFldNumExc
                EndIF
            EndIF
    
            IF (;
                    ( nFieldFil > 0 );
                    .and.;
                    ( lChkFil );
                    .and.;
                    ( cFieldFil == SubStr( cIndexKey , 1 , Len( cFieldFil ) ) );
                )
                IF !( lExistChav )
                    cKeyAuxP := xFilial( cAlias )
                EndIF
            EndIF
    
        EndIF
    
        IF ( ( nOrder := RetOrder( cAlias , cIndexKey , .T. ) ) == 0 )
            IF !(;
                    Upper( StrTran( cIndexKey , " " , "" ) );
                    $;
                    SubStr( Upper( StrTran( ( cAlias )->( IndexKey() ) , " " , "" ) ) , 1 , Len( cIndexKey ) );
                 )
                cArqInd := ( CriaTrab( "" , .F. ) + OrdBagExt() )
                ( cAlias )->( IndRegua( cAlias , cArqInd , cIndexKey , NIL , NIL , NIL , .F. ) )
            EndIF
            nOrder := ( cAlias )->( IndexOrd() )
        EndIF
    
        IF ( nFldNumExc > 0 )
            cX2Path := AllTrim( x2Path( cAlias ) )
            IF ( ValType( cFldNumExc ) == "C" )
                cAlsNumExc := ( cKeyAuxP + cX2Path + "\" + cFldNumExc )
            Else
                cAlsNumExc := ( cKeyAuxP + cX2Path )
            EndIF
        EndIF    
    
        ( cAlias )->( dbSetOrder( nOrder ) )
    
        While !( lGetNumExclOk )
    
            IF (;
                    ( nCodesUse > 0 );
                    .or.;
                    Empty( cRetNumExcl );
                )    
                IF !( CheckExecForm( { || cRetNumExcl := Eval( bGetNumExc ) } , lShowHelp ) )
                    Break
                EndIF
            EndIF
    
            ++nCodesUse
    
            IF (;
                    ( nSvRecno > 0 );
                    .and.;
                    !( Inclui );
                 )
                ( cAlias )->( MsGoto( nSvRecno ) )
            ElseIF ( Inclui )
                PutFileInEof( cAlias )
            EndIF
    
            cKeySeek := ( cKeyAuxP + cRetNumExcl + cKeyAuxS )
    
            IF ( lExistChav )
    
                lFound    := !( ExistChav( cAlias , cKeySeek , nOrder ) )
    
            Else
    
                lFound    := ( cAlias )->( MsSeek( cKeySeek , .F. ) )
    
            EndIF
    
            IF ( lFound )
                IF (;
                        ( nSvRecno > 0 );
                        .and.;
                        !( Inclui );
                    )
                    IF ( lGetNumExclOk := ( ( cAlias )->( Recno() ) == nSvRecno ) )
                        Break
                    EndIF
                EndIF
                Loop
            EndIF
    
            IF ( ValType( cFldNumExc ) == "C" )
                cUseCode := ( cFldNumExc + cKeySeek )
            Else
                cUseCode := cKeySeek
            EndIF
    
            MySetMaxCode( Max( ( nCodesUse + 1 ) , nSvMaxCode ) )
            IF !( lGetNumExclOk := UseCode( cAlias , cUseCode ) )
                FreeCodeUsed( cAlias , cUseCode )
            EndIF
    
        End While
    
    End Sequence
    
    IF !Empty( cArqInd )
        IF ( nSvOrder > 0 )
            CheckExecForm( { || ( cAlias )->( RetIndex( cAlias ) ) } , .F.  )
        EndIF
        IF File( cArqInd )
            fErase( cArqInd )
        EndIF
    EndIF
    
    SetMaxCode( nSvMaxCode )
    IF (;
            ( nSvOrder > 0 );
            .and.;
            ( cAlias )->( !Empty( IndexKey( nSvOrder ) ) );
        )    
        ( cAlias )->( dbSetOrder( nSvOrder ) )
    EndIF    
    IF ( nSvRecno > 0 )
        ( cAlias )->( MsGoto( nSvRecno ) )
    ElseIF ( Inclui )
        PutFileInEof( cAlias )
    EndIF

Return( lGetNumExclOk )

/*/
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд?
?un┤┘o    ?srRecLock        ?utor?arinaldo de Jesus ?Data ?6/11/2009?
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд?
?escri┤┘o ?ock de Registro                                            ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?intaxe   ?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?arametros?Vide Parametros Formais>                                    ?
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?
?so       ?enerico                                                      ?
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд?*/
Static Function UsrRecLock( cAlias  , lAddNew , lRecLock )

    Local lLocked
    
    DEFAULT cAlias         := Alias()
    DEFAULT lAddNew        := .F.
    DEFAULT lRecLock    := .T.     
    
    IF ( lRecLock )
        ( cAlias )->( RecLock( cAlias , lAddNew ) )
    Else
        IF ( lAddNew )
            ( cAlias )->( dbAppend( .F. ) )
            lLocked := !NetErr()
        Else
            lLocked := ( cAlias )->( rLock() )
        EndIF
    EndIF

Return( lLocked )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
         FREELOCKS()
        GETCODEMAYIUSE()
        GETNEWCODIGO()
        RSTGETADSLCKREC()
        USRRECLOCK()
        WHILENOLOCK()
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
