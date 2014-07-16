#ifdef TOTVS
    #include "totvs.ch"
#else
    #include "protheus.ch"
#endif    
//----------------------------------------------------------------------------
    /*
        Programa    : btdnChkSum.prg
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 27/09/2012 
    */
//----------------------------------------------------------------------------
    /*
        Para autorizar UTCREPORT : StaticCall(btdnChkSum,BTDNAuth,"UTCREPORT")
    */
//----------------------------------------------------------------------------
Static Function BTDNRPTCHK(cTypeChk,cAddStack)
    #IFNDEF __BTDNCHECKSUM
        Local lBTDNRPTCHK    := .T.
        DEFAULT cTypeChk     := ""
        _SetNamedPrvt( "__lBTDNRPTCHK" , .T.              , "btdnChkSum" )
        _SetNamedPrvt( "__cBTDNRPTCHK" , Upper(cTypeChk)  , "btdnChkSum" )
        _SetNamedPrvt( "__dBTDNRPTCHK" , StoD("29701215") , "btdnChkSum" )
    #ELSE
        Local aStack         := Array(0)
        Local cStack
        Local nStack
        Local nStacks
    #IFNDEF __BTDNVDEMO
        Local aSM0           := Array(0)
    #ENDIF    
        Local lBTDNRPTCHK    := .F.
        DEFAULT cTypeChk     := ""
        BEGIN SEQUENCE
            aAdd(aStack,{.F.,Upper("__SetPrint")})
            aAdd(aStack,{.F.,Upper("__CheckSum")})
            aAdd(aStack,{.F.,Upper("u_uTCREPORT")})
            aAdd(aStack,{.F.,Upper("New")})
            aAdd(aStack,{.F.,Upper("SetTReport")})
            IF .NOT.( Empty(cAddStack) )
                IF ( aScan( aStack , {|e| ( e[2]==cAddStack) } ) == 0 )
                    aAdd(aStack,{.F.,cAddStack})
                EndIF    
            EndIF
            nStacks := Len(aStack)
            For nStack := 1 To nStacks
                cStack               := aStack[nStack][2]
                aStack[nStack][1]    := IsInCallStack(cStack)
            Next nStack    
            lBTDNRPTCHK := ( aScan( aStack , {|e| e[1] } ) > 0 )
            IF .NOT.(lBTDNRPTCHK)
                BREAK
            EndIF
            lBTDNRPTCHK := IsInCallStack("btdnChkSum")
            IF .NOT.(lBTDNRPTCHK)
                BREAK
            EndIF
            #IFNDEF __BTDNVDEMO
                IF (Type("cEmpAnt")=="C")
                    IF (Select("SM0") > 0)
                        SM0->( dbSetOrder(1))
                        SM0->( dbSeek( cEmpAnt , .F. ) )
                        While SM0->( .NOT.( Eof() ) )
                            SM0->(aAdd(aSM0,Recno()))
                            SM0->( dbSkip() )
                        End While
                    EndIF
                    lBTDNRPTCHK := CheckSM0(@aSM0,Len(aSM0),Lower(cTypeChk))
                    SM0->( dbSetOrder(1))
                    IF .NOT.(Type("cFilAnt")=="C")
                        Private cFilAnt := ""
                    EndIF
                    SM0->( dbSeek( cEmpAnt+cFilAnt , .F. ) )
                    IF .NOT.(lBTDNRPTCHK)
                        BREAK
                    EndIF
                EndIF
            #ENDIF //__BTDNVDEMO
            _SetNamedPrvt( "__lBTDNRPTCHK" , .T.              , "btdnChkSum" )
            _SetNamedPrvt( "__cBTDNRPTCHK" , Upper(cTypeChk)  , "btdnChkSum" )
            _SetNamedPrvt( "__dBTDNRPTCHK" , StoD("29701215") , "btdnChkSum" )
        END SEQUENCE
    #ENDIF
Return(lBTDNRPTCHK)

Static Function CheckSM0( aSM0 , nEmps , cTypeChk )
    
    Local aFEmp
    Local aREmp
    
    Local aLockByName   := Array(0)
    Local aFieldName    := Array(0)
    
    Local cCGC
    Local cFile
    Local cLockByName
    Local cFieldName
    
    Local lSM0OK        := .F.
    
    Local nEmp
    Local nRecno
    Local nField        := 0
    
    Local nAttempts
    
    aAdd( aFieldName , "M0_CODIGO" )
    aAdd( aFieldName , "M0_CODFIL" )
    aAdd( aFieldName , "M0_FILIAL" )
    aAdd( aFieldName , "M0_NOME"   )
    aAdd( aFieldName , "M0_NOMECOM")
    aAdd( aFieldName , "M0_CGC"    )
    aAdd( aFieldName , "M0_INSC"   )

    For nEmp := 1 To nEmps
        nRecno    := aSM0[nEmp]
        SM0->( dbGoTo( nRecno ) )
        cCGC    := AllTrim(SM0->M0_CGC)
        cFile   := cCGC
        cFile   += "_"
        cFile   += cTypeChk
        lSM0OK  := File("\btdn\"+cFile+".mzp")
        IF .NOT.(lSM0OK)
            EXIT
        EndIF
        cLockByName := cFile
        aAdd( aLockByName , cLockByName )
        lSM0OK      := LockByName( @cLockByName , .T. , .F. , .T. )
        nAttempts   := 0
        While .NOT.( lSM0OK )
            lSM0OK  := LockByName( @cLockByName , .T. , .F. , .T. )    
            IF ( lSM0OK )
                EXIT
            EndIF
            IF ( ( ++nAttempts ) > 10 )
                EXIT    
            EndIF
            Sleep(300)
        End While
        IF .NOT.(lSM0OK)
            EXIT
        EndIF
        lSM0OK := MsDecomp("\btdn\"+cFile,"\btdn\",Embaralha(EncodeUTF8(Encode64("@#BlackTDN@"+cTypeChk+"@"+cFile+"@"+cCGC+"@19701215#@")),0)) 
        IF .NOT.(lSM0OK)
            EXIT
        EndIF
        cFile   := ("\btdn\"+cFile)
        lSM0OK  := File(cFile)
        IF .NOT.(lSM0OK)
            EXIT
        EndIF
        aFEmp   := RestArray( cFile )
        fErase(cFile)
        UnLockByName( @cLockByName , .T. , .F. , .T. )
        aREmp   := SM0->( RegToArray() )
        lSM0OK  := Compare(aFEmp,aREmp,@nField)
        IF .NOT.(lSM0OK) .and. ( nField > 0 )
            cFieldName  := Upper(AllTrim(SM0->(FieldName(nField))))
            lSM0OK      := (aScan(aFieldName,{|cField|(cField==cFieldName)})==0)
        EndIF
        IF (lSM0OK)
            EXIT
        EndIF
    Next nEmp    

    aEval( aLockByName , { |cLockByName| UnLockByName( @cLockByName , .T. , .F. , .T. ) } )

Return(lSM0OK)

Static Function RegToArray( cAlias , nRecno )

    Local aValues   := Array(0)
    Local adbStruct
    
    Local nField
    Local nFields

    DEFAULT cAlias  := Alias()
    DEFAULT nRecno  := (cAlias)->( Recno() )

    adbStruct   := (cAlias)->( dbStruct() )

    (cAlias)->( MsGoto( nRecno ) )
    
    nFields := Len( adbStruct )
    aValues := Array( nFields )

    For nField := 1 To nFields
        aValues[ nField ] := (cAlias)->( FieldGet( nField ) )
    Next nField

Return( aValues  )

Static Function ArrayCompare( aArray1 , aArray2 , nPosDif )

    Local cType1    := ValType( aArray1 )
    Local cType2    := ValType( aArray2 )
    
    Local lCompare
    Local nArray
    Local nArray1Size
    Local nArray2Size
    Local nHalfToBeg
    Local nHalfToEnd
    
    Begin Sequence
    
        IF .NOT.( lCompare := ( cType1 == cType2 ) )
            Break
        EndIF
    
        IF ( cType1 == "O" )
            lCompare := Compare( aArray1 , aArray2 , @nPosDif )
            Break
        EndIF
    
        IF .NOT.( lCompare := ( cType1 == "A" ) )
            Break
        EndIF
                
        IF .NOT.( lCompare := ( ( nArray1Size := Len( aArray1 ) ) == ( nArray2Size := Len( aArray2 ) ) ) )
            nPosDif := ( Min( nArray1Size , nArray2Size ) + 1 )
            Break
        EndIF
                
        nHalfToBeg := ( IF( ( ( nArray1Size % 2 ) > 0 ) , ( ( nArray1Size + 1 ) ) , nArray1Size ) / 2 )
        nHalfToEnd := Min( nArray1Size , ( nHalfToBeg + 1 ) )
        For nArray := 1 To nArray1Size
            IF ( nArray <= nHalfToBeg )
                IF .NOT.( lCompare := Compare( aArray1[ nArray ] , aArray2[ nArray ] ) )
                    nPosDif := nArray
                    Break
                EndIF
            Else
                Break
            EndIF
            IF ( nHalfToBeg > nArray )
                IF .NOT.( lCompare := Compare( aArray1[ nHalfToBeg ] , aArray2[ nHalfToBeg ] ) )
                    nPosDif := nHalfToBeg
                    Break
                EndIF
                --nHalfToBeg
            EndIF
            IF ( nHalfToEnd < nArray1Size )
                IF .NOT.( lCompare := Compare( aArray1[ nHalfToEnd ] , aArray2[ nHalfToEnd ] ) )
                    nPosDif := nHalfToEnd
                    Break
                EndIF
                ++nHalfToEnd
            EndIF
            IF ( nArray1Size >= nHalfToEnd )
                IF .NOT.( lCompare := Compare( aArray1[ nArray1Size ] , aArray2[ nArray1Size ] ) )
                    nPosDif := nArray1Size
                    Break
                EndIF
                --nArray1Size
            EndIF
        Next nArray
    
    End Sequence

Return( lCompare )

Static Function Compare( uCompare1 , uCompare2 , nPosDif )

    Local cType1    := ValType( uCompare1 )
    Local cType2    := ValType( uCompare2 )

    Local lCompare

    IF ( lCompare := ( cType1 == cType2 ) )
        IF ( cType1 == "A" )
            lCompare := ArrayCompare( uCompare1 , uCompare2 , @nPosDif )
        ElseIF ( cType1 == "O" )
            lCompare := ArrayCompare( ClassDataArr( uCompare1 ) , ClassDataArr( uCompare2 ) , @nPosDif )
        ElseIF ( cType1 == "B" )
            lCompare := ( GetCBSource( uCompare1 ) == GetCBSource( uCompare2 ) )
        Else
            lCompare := ( uCompare1 == uCompare2 )
        EndIF
    EndIF
    
Return( lCompare )

Static Function SaveArray( uArray , cFileName , nErr )

Local cValTypeuArray    := ValType( uArray )
Local lSaveArray        := .F.

Local aArray
Local nfHandle

Begin Sequence

    IF .NOT.( cValTypeuArray $ "A/O" )
        Break
    EndIF

    IF ( cValTypeuArray == "O" )
        aArray := ClassDataArr( uArray )
    Else
        aArray := uArray
    EndIF

    lSaveArray := FileCreate( cFileName , @nfHandle , @nErr )
    IF .NOT.( lSaveArray )
        Break
    EndIF

    SaveArr( nfHandle , aArray )
    fClose( nfHandle )

End Sequence    

Return( lSaveArray )

Static Function SaveArr( nfHandle , aArray )

    Local cElemType
    
    Local uCntSave
    
    Local nLoop
    Local nLoops
        
    nLoops      := Len( aArray )
    uCntSave    := ( "A" + StrZero( nLoops , 10 ) )
    fWrite( nfHandle , uCntSave )
    For nLoop := 1 To nLoops
        cElemType := ValType( aArray[ nLoop ] )
        IF ( cElemType $ "A/O" )
            IF ( cElemType == "A" )
                SaveArr( nfHandle , aArray[ nLoop ] )
            Else
                SaveArr( nfHandle , ClassDataArr( aArray[ nLoop ] ) )
            EndIF
        Else
            IF ( cElemType == "B" )
                uCntSave    := GetCBSource( aArray[ nLoop ] )
            ElseIF ( cElemType == "C" )
                uCntSave    := aArray[ nLoop ]
            ElseIF ( cElemType == "D" )
                uCntSave    := Dtos( aArray[ nLoop ] )
            ElseIF ( cElemType == "L" )
                uCntSave    := IF( aArray[ nLoop ] , ".T." , ".F." )
            ElseIF ( cElemType == "N" )
                uCntSave    := Transform( aArray[ nLoop ] , RetPictVal( aArray[ nLoop ] ) )
            EndIF
            uCntSave := ( cElemType + StrZero( Len( uCntSave ) , 5 ) + uCntSave )
            fWrite( nfHandle , uCntSave )
        EndIF
    Next nLoop

Return( NIL )

Static Function RestArray( cFileName , nErr )

    Local aRestArray := Array(0)
    
    Local nfHandle
    
    Begin Sequence
    
        IF .NOT.( File( cFileName ) )
            Break
        EndIF
        
        nfHandle := fOpen( cFileName )
    
        IF ( nfHandle <= 0 )
            nErr := fError()
            Break
        EndIF
    
        fReadStr( nfHandle , 1 )
        aRestArray := RestArr( nfHandle )
        fClose( nfHandle )
    
    End Sequence

Return( aRestArray )

Static Function RestArr( nfHandle )

    Local aArray
    Local cElemType
    Local cElemSize
    
    Local nLoop
    Local nLoops
    
    Local uCnt
    
    nLoop     := 0
    nLoops    := Val( fReadStr( nfHandle , 10 ) )
    aArray    := Array( nLoops )
    
    While ( ( ++nLoop ) <= nLoops )
    
        cElemType   := fReadStr( nfHandle , 1 )
        IF ( cElemType $ "A/O" )
            aArray[ nLoop ] := RestArr( nfHandle )
        Else
            cElemSize   := fReadStr( nfHandle , 5 )
            uCnt        := fReadStr( nfHandle , Val( cElemSize ) )
            IF ( cElemType $ "B/L" )
                aArray[ nLoop ] := __ExecMacro( uCnt )
            ElseIF ( cElemType == "C" )
                aArray[ nLoop ] := uCnt
            ElseIF ( cElemType == "D" )
                aArray[ nLoop ] := Stod( AllTrim( uCnt ) )
            ElseIF ( cElemType == "N" )
                aArray[ nLoop ] := Val( AllTrim( uCnt ) )
            EndIF
        EndIF
    
    End While
    
Return( aArray )

Static Procedure BTDNAuth(cTypeChk,aCGC)
    
    Local aRCGC
    Local aRDDs
    
    Local aTypeChk    := GetTypeChk()
    
    Local bErrorBlock
    
    Local cCGC
    Local cRDD
    Local cFile
    Local cAlias

    Local lCGC
    Local lOpenned
    
    Local nCGC
    Local nRDD
    Local nRDDs
    Local nAttempts
    
    BEGIN SEQUENCE

        IF .NOT.(lIsDir("\btdn\"))
            MakeDir("\btdn\")
        EndIF

        IF .NOT.(lIsDir("\btdn\"))
            MsgInfo("Diretório \btdn\ não Encontrado" , "A T E N Ç Ã O ! ! !" )
            BREAK
        ENDIF

        IF .NOT.( File("\btdn\sigamat.emp") )
            MsgInfo("Arquivo sigamat.emp não Localizado em \btdn\" , "A T E N Ç Ã O ! ! !" )
            BREAK
        ENDIF
        
        IF ( ( Empty(cTypeChk) ) .or. ( .NOT.(ValType(cTypeChk)=="C") ) )
            MsgInfo("Tipo de Autorização em Branco ou Inválido" , "A T E N Ç Ã O ! ! !" )
            BREAK
        EndIF
        
        cTypeChk := Lower(AllTrim(cTypeChk))
        nType    := aScan(aTypeChk,{|cType|(cType==Upper(cTypeChk))})
        IF ( nType == 0 )
            MsgInfo("Tipo de Autorização Inválido" , "A T E N Ç Ã O ! ! !" )
            BREAK
        EndIF
        
        aRDDs := Array(0)
        
        IF ( Type( "__LocalDriver" ) == "C" )
            aAdd(aRDDs,__LocalDriver)
        EndIF    

        aAdd(aRDDs,"DBFCDXAX")
        aAdd(aRDDs,"DBFCDXADS")
        aAdd(aRDDs,"CTREECDX")
        aAdd(aRDDs,"BTVCDX")

        nRDDs := Len(aRDDs)

        cAlias := GetNextAlias()

        bErrorBlock := ErrorBlock({|e|Break(e)})
        For nRDD := 1 To nRDDs
            cRDD := aRDDs[nRDD]
            BEGIN SEQUENCE
                dbUseArea( .T. , cRDD , "\btdn\sigamat.emp" , cAlias , .F. , .F. )
                lOpenned := ( Select(cAlias) > 0 )
                IF ( lOpenned )
                    BREAK
                EndIF
            END SEQUENCE
            IF ( lOpenned )
                EXIT
            EndIF
        Next nRDD
        ErrorBlock(bErrorBlock)
        
        IF .NOT.( lOpenned )
            MsgInfo("Impossível abrir \btdn\sigamat.emp " , "A T E N Ç Ã O ! ! !" )            
            BREAK
        EndIF

        lCGC := ( .NOT.( Empty( aCGC ) ) .and. ( ValType(aCGC)== "A" ) )
        IF .NOT.( lCGC )
            aCGC := Array(0)
        EndIF

        (cAlias)->( dbGoTop() )
        While (cAlias)->( .NOT.( Eof() ) )
            cCGC := AllTrim((cAlias)->M0_CGC)
            IF .NOT.( lCGC )
                aAdd( aCGC , cCGC )
            EndIF    
            nCGC := aScan(aCGC,{|c|AllTrim(c)==cCGC})
            IF ( nCGC > 0)
                aRCGC   := (cAlias)->( RegToArray() )
                cFile   := AllTrim((cAlias)->M0_CGC)
                cFile   += "_"
                cFile   += cTypeChk
                SaveArray(aRCGC,cFile)
                IF ( File(cFile) )
                    IF ( File("\btdn\"+cFile+".mzp") )
                        fErase("\btdn\"+cFile+".mzp")
                    EndIF
                    MSCompress(cFile,"\btdn\"+cFile,Embaralha(EncodeUTF8(Encode64("@#BlackTDN@"+cTypeChk+"@"+cFile+"@"+cCGC+"@19701215#@")),0))
                    fErase(cFile)
                EndIF    
            EndIF
            (cAlias)->( dbSkip() )
        End While

        (cAlias)->( dbCloseArea() )

    END SEQUENCE

Return

Static Function GetTypeChk()
    Local aTypeChk := Array(0)
    aAdd(aTypeChk,"UTCREPORT")
Return(aTypeChk)

Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        BTDNAUTH()
        BTDNRPTCHK()
        CHECKSM0()
   EndIF
Return(lRecursa)