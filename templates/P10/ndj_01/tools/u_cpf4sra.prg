#INCLUDE "ndj.ch"
/*
    Fun‡…o:        U_CPF4SRA
    Autor:        Marinaldo de Jesus
    Data:        08/03/2012
    Descri‡…o:    Funcao para Popular o SRA com CPFs Validos baseado no meu original U_SRACPF de 14/11/2009
    Sintaxe:    <Vide Parametros Formais>
    Parametros:    <Vide Parametros Formais>
    Uso:        Popular o SRA com CPFs Validos
*/
User Function CPF4SRA(ldbPack,lAllTables,cRDD)

    DEFAULT ldbPack        := .F.
    DEFAULT lAllTables    := .T.
    DEFAULT cRDD        := "TOPCONN"

    Private lAbortPrint := .F.

    SYMBOL_UNUSED( __cCRLF )

Return( Processa( { |lEnd| CPF4SRA(@ldbPack,@lAllTables,@cRDD) } , "Aguarde..." , "Carregando CPFs" , .T. ) )

/*
    Fun‡…o:        CPF4SRA
    Autor:        Marinaldo de Jesus
    Data:        08/03/2012
    Descri‡…o:    Funcao para Popular o SRA com CPFs Validos
    Sintaxe:    <Vide Parametros Formais>
    Parametros:    <Vide Parametros Formais>
    Uso:        Popular o SRA com CPFs Validos
*/
Static Function CPF4SRA(ldbPack,lAllTables,cRDD)
    

    Local bGetCPF        := { || StaticCall( NDJLIB024 , NextCPF , cCPF , nCPFStart , nCPFFinish ) }

    Local cMsg
    Local cCPF             := "10656875917"
    Local cAlias
    Local cTable
    
    Local nLoop
    Local nLoops         := 990
    Local nRecCount        := 0
    Local nCPFStart        := 106568759
    Local nCPFFinish
    
    Local oError
    
    IF !( lAllTables )
        nLoops := 1
    EndIF

    TRYEXCEPTION

        ProcRegua( nLoops )
        
        For nLoop := 0 To nLoops STEP 10

            cTable     := "SRA" + StrZero( nLoop , 3 )
            cMsg    := ( cTable + " :: " + "Verificando Registros... " +  AllTrim( Str( Int( nLoop / nLoops * 100 ) ) ) + "%" )
            ChkAbort( .T. , cMsg )
            
            IF !( MsFile( cTable , NIL , cRDD ) )
                Loop
            EndIF
    
            cAlias    := GetNextAlias()
            
            IF !( MsOpenDbf(.T.,cRDD,cTable,cAlias,.F.,.F.,.T.,.F.) )
                Loop
            EndIF

            IF ( ldbPack )
                MyPack( @cAlias , @cTable )
            EndIF    

            nRecCount += (cAlias)->( RecCount() )

            (cAlias)->( dbCloseArea() )
    
        Next nLoop
    
        nCPFFinish    := ( nCPFStart + nRecCount )
        MsgRun( "Obtendo CPFS" , "Aguarde..." , bGetCPF )

        ProcRegua( nLoops )
        
        For nLoop := 0 To nLoops STEP 10

            cTable    := "SRA" + StrZero( nLoop , 3 )
            cMsg    := ( cTable + " :: " + "Atualizando CPF... " +  AllTrim( Str( Int( nLoop / nLoops * 100 ) ) ) + "%" )
            ChkAbort( .T. , cMsg )
            
            IF !( MsFile( cTable , NIL , cRDD ) )
                Loop
            EndIF
    
            cAlias    := GetNextAlias()
            
            IF !( MsOpenDbf(.T.,cRDD,cTable,cAlias,.F.,.F.,.T.,.F.) )
                Loop
            EndIF

            (cAlias)->( dbGoTop())

            While (cAlias)->( !Eof() )

                ChkAbort( .F. , cMsg )

                cCPF := Eval( bGetCPF )
    
                (cAlias)->RA_CIC := cCPF
    
                (cAlias)->( dbSkip())
        
            End While
            
            IF ( nLoop < nLoops )
                (cAlias)->( dbCloseArea() )
            EndIF    
        
        Next nLoop

    CATCHEXCEPTION USING oError
    
        Final( oError:Description )
    
    ENDEXCEPTION
    
Return( NIL )

/*
    Fun‡…o:        ChkAbort
    Autor:        Marinaldo de Jesus
    Data:        08/03/2012
    Descri‡…o:    Verifica se Deve Abortar o Processo
    Sintaxe:    <Vide Parametros Formais>
    Parametros:    <Vide Parametros Formais>
    Uso:        Popular o SRA com CPFs Validos
*/
Static Function ChkAbort( lProcessMessage , cMsgProc )

    DEFAULT lProcessMessage := .T.

    IF ( lProcessMessage )
        ProcessMessage()
    EndIF    

    IF ( lAbortPrint )
        lAbortPrint := MsgNoYes( OemToAnsi( "Deseja Abortar a Operação" ) , OemToAnsi( "Atenção" ) )
        IF ( lAbortPrint )
            UserException( cCancel )
        EndIF
    Else
        IncProc( cMsgProc )
    EndIF

Return( NIL )

/*
    Fun‡…o:        MyPack
    Autor:        Marinaldo de Jesus
    Data:        08/03/2012
    Descri‡…o:    Eliminar Registros Deletados
*/
Static Function MyPack( cAlias , cRetSqlName )
Return( StaticCall( NDJLIB001 , __dbDelete , @cAlias , .T. , @cRetSqlName ) )
