#INCLUDE "PAN-AMERICANA.CH"
/*/
    Programa:    U_PanVldCtb
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡„o:    Validar Amarracao Conta Contabil x CC x Filial
*/
User Function PanVldCtb( cField )

    Local aRegra        := {}
    Local aFields        := {}

    Local cField003
    Local cField004

    Local cGrpChk        := "003"
    Local cException    := ""

    Local lValid        := .F.
    
    Local oException
    
    Local uCntFld003    := ""
    Local uCntFld004    := ""
    
    TRYEXCEPTION

        IF !( GetNewPar( "PAN_VLDCTB" , .F. ) )
            lValid := .T.
            BREAK
        EndIF

        IF !( GetFileRegra( @aRegra , @oException ) )
            UserException( OemToAnsi( oException:Description ) )
        EndIF

        IF !( GetFileFields( @aFields , @oException ) )
            UserException( OemToAnsi( oException:Description ) )
        EndIF

        nFieldPos := ChkField( @aFields , @cField , @cGrpChk )

        IF ( nFieldPos == 0 )
            cGrpChk := "004"
            nFieldPos := ChkField( @aFields , @cField , @cGrpChk )
            IF ( nFieldPos == 0 )
                lValid := .T.
                Break
            EndIF
        EndIF

        cField003 := Upper( AllTrim( aFields[ nFieldPos , 1 ] ) )
        cField004 := Upper( AllTrim( aFields[ nFieldPos , 2 ] ) )

        IF (;
                IsInGetDados( { cField003 } );
                .and.;
                !( IsCpoVar( cField003 ) );
            )    
            uCntFld003 := GdFieldGet( cField003 )
        ElseIF ( IsMemVar( cField003 ) )
            uCntFld003 := GetMemVar( cField003 )
        ElseIF ( (Alias())->( FieldPos( cField003 ) ) > 0 )
            uCntFld003 := (Alias())->( FieldGet( FieldPos( cField003 ) ) )
        ElseIF ( (AliasCpo(cField003))->( FieldPos( cField003 ) ) > 0 )
            uCntFld003 := (AliasCpo(cField003))->( FieldGet( FieldPos( cField003 ) ) )
        EndIF

        IF (;
                IsInGetDados( { cField004 } );
                .and.;
                !( IsCpoVar( cField004 ) );
            )    
            uCntFld004 := GdFieldGet( cField004 )
        ElseIF ( IsMemVar( cField004 ) )
            uCntFld004 := GetMemVar( cField004 )
        ElseIF ( (Alias())->( FieldPos( cField004 ) ) > 0 )
            uCntFld004 := (Alias())->( FieldGet( FieldPos( cField004 ) ) )
        ElseIF ( (AliasCpo(cField004))->( FieldPos( cField004 ) ) > 0 )
            uCntFld004 := (AliasCpo(cField004))->( FieldGet( FieldPos( cField004 ) ) )
        EndIF        

        IF ( cGrpChk == "003" )
            lValid := MayIUseCT1( uCntFld003 )
            IF !( lValid )
                UserException( OemToAnsi( "Essa Conta Contábil não pode ser utilizada nessa Filial" ) )
            EndIF
        EndIF    
        
        IF ( cGrpChk == "004" )
            lValid := MayIUseCTT( uCntFld004 )
            IF !( lValid )
                UserException( OemToAnsi( "Esse Centro de Custo não pode ser utilizada nessa Filial" ) )
            EndIF
        EndIF    

        IF (;
                Empty( uCntFld003 );
                .or.;
                Empty( uCntFld004 );
            )
            lValid := .T.
            Break
        EndIF

        lValid := ChkRegra( @aRegra , @cGrpChk , @uCntFld003 , @uCntFld004 , @cException )
        IF !( lValid )
            UserException( OemToAnsi( cException ) )
        EndIF

        IF (;
                ( lValid );
                .and.;
                ( cGrpChk == "003" );
                .and.;
                ( PosAlias( "CT1" , uCntFld003 , xFilial("CT1") , "CT1_CCOBRG" , RetOrder("CT1","CT1_FILIAL+CT1_CONTA") , .T. ) == "1" );
                .and.;
                Empty( uCntFld004 );
            )

            IF (;
                    IsInGetDados( { cField004 } );
                    .and.;
                    !( IsCpoVar( cField004 ) );
                )    
                GdFieldPut( cField004 , "OBRIGATORIO" )
            ElseIF ( IsMemVar( cField004 ) )
                SetMemVar( cField004 , "OBRIGATORIO" )
            ElseIF ( (Alias())->( FieldPos( cField004 ) ) > 0 )
                IF (Alias())->( RecLock( Alias() , .F. ) )
                    (Alias())->( FieldPut( FieldPos( cField004 ) , "OBRIGATORIO" ) )
                    (Alias())->( MsUnLock() )
                EndIF    
            ElseIF ( (AliasCpo(cField004))->( FieldPos( cField004 ) ) > 0 )
                IF (AliasCpo(cField004))->( RecLock( (AliasCpo(cField004)) , .F. ) )
                    (AliasCpo(cField004))->( FieldPut( FieldPos( cField004 ) , "OBRIGATORIO" ) )
                    (AliasCpo(cField004))->( MsUnLock() )
                EndIF    
            EndIF
            
        EndIF

        IF ( lValid )
            IF (;
                    ( cField003 == "CP_CONTA" );
                     .and.;
                     ( cField == cField003 );
                )     
                IF CT1->( FieldPos( "CT1_XCDESP" ) > 0 )
                    lValid := CT1->CT1_XCDESP
                Else
                    lValid := ( AllTrim( uCntFld003 ) > GetNewPar( "PAN_CTDESP" , "411101000" ) )
                EndIF
                IF !( lValid )
                    UserException( "Informe uma Conta de DESPESA" )
                EndIF    
            EndIF
        EndIF        

    CATCHEXCEPTION USING oException

        IF !( lValid )
            Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "INCONSITÊNCIA:" + CRLF + oException:Description ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

Return( lValid )

/*/
    Fun‡„o:        U_InPanVld
    Autor:        Marinaldo de Jesus
    Data:        25/11/2009
    Descri‡„o:    Executar Funcoes Dentro de U_PANVLDCTB
    Sintaxe:    U_InPanVld( cExecIn , aFormParam )
*/
User Function InPanVld( cExecIn , aFormParam )
         
    Local uRet
    
    DEFAULT cExecIn        := ""
    DEFAULT aFormParam    := {}
    
    IF !Empty( cExecIn )
        cExecIn    := BldcExecInFun( cExecIn , aFormParam )
        uRet    := &( cExecIn )
    EndIF

Return( uRet )

/*/
    Fun‡…o:        MayIUseCT1
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Verificar se Conta Contabil Pode Ser Utilizada
*/
Static Function MayIUseCT1( cCusto )
    
    Local aNotCT1
    
    Local cNotCusto
    Local cFileNotCT1    := ( FILE_EXCLUI_CT1 )

    Local lUse             := .T.          

    Local nLoop
    Local nLoops
    Local nCustoSize
    
    Begin Sequence

        IF !File( cFileNotCT1 )
            Break
        EndIF
        
        aNotCT1 := FileToArr( cFileNotCT1 )

        nLoops := Len( aNotCT1 )
        For nLoop := 1 To nLoops
                cNotCusto    := Upper( AllTrim( aNotCT1[ nLoop ] ) )
            nCustoSize    := Len( cNotCusto )

            IF ( nCustoSize == 0 )
                Loop
            EndIF

            IF ( cNotCusto == SubStr( cCusto , 1 , nCustoSize ) )
                lUse := .F.
                Break
            EndIF

        Next nLoop

    End Sequence    

Return( lUse  )

/*/
    Fun‡…o:        MayIUseCTT
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Verificar se Conta Contabil Pode Ser Utilizada
*/
Static Function MayIUseCTT( cCC )
    
    Local aNotCTT
    
    Local cNotCC
    Local cFileNotCTT    := FILE_EXCLUI_CTT

    Local lUse             := .T.          
    
    Local nLoop
    Local nLoops
    Local nCttSize

    Begin Sequence

        IF !File( cFileNotCTT )
            Break
        EndIF
        
        aNotCTT := FileToArr( cFileNotCTT )

        nLoops := Len( aNotCTT )
        For nLoop := 1 To nLoops
        
            cNotCC        := Upper( AllTrim( aNotCTT[ nLoop ] ) )
            nCttSize    := Len( cNotCC )
            
            IF ( nCttSize == 0 )
                Loop
            EndIF

            IF ( cNotCC == SubStr( cCC , 1 , nCttSize ) )
                lUse := .F.
                Break
            EndIF

        Next nLoop

    End Sequence    

Return( lUse  )

/*/

    Fun‡…o:        ChkRegra
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Valida a Regra
*/
Static Function ChkRegra( aRegra , cGrpChk , uCntFld003 , uCntFld004 , cException )

    Local aIntCcs    := {}
    Local aAndCcs    := {}
    
    Local cbVldCC    := ""
    Local cGrupo    := ""
    
    Local lChkRegra := .T.
    
    Local nAndCc    := 0
    Local nAndCcs   := 0
    Local nGrpSize    := 0
    Local nRegra    := 0
    
    DEFAULT cException := ""

    nRegras := Len( aRegra )
    For nRegra := 2 To nRegras
        
        cGrupo         := Upper( AllTrim( aRegra[ nRegra , 1 ] ) )
        nGrpSize    := Len( cGrupo )

        IF !( cGrupo == SubStr( uCntFld003 , 1 , nGrpSize ) )
            Loop
        EndIF

        IF ( Len( aRegra[ nRegra ] ) > 2 )
            IF ( "&" $ aRegra[ nRegra , 3 ] )
                IF !( cFilAnt $ aRegra[ nRegra , 3 ] )
                    Loop
                EndIF
            EndIF
        EndIF    

        IF (;
                ( "&" $ aRegra[ nRegra , 2 ] );
                .and.;
                ( ":" $ aRegra[ nRegra , 2 ] );
            )    
            aAndCcs := StrToArray( aRegra[ nRegra , 2 ] , "&" )
            nAndCcs := Len( aAndCcs )
            aIntCcs := {}
            For nAndCc := 1 To nAndCcs
                aAdd( aIntCcs , StrToArray( aAndCcs[ nAndCc ] , ":" ) )
            Next nAndCc
            nAndCcs := Len( aIntCcs )
            cbVldCC := ""
            For nAndCc := 1 To nAndCcs 
                cbVldCC += "('" + uCntFld004 + "' >= '" + aIntCcs[nAndCc,1] + "' .and. '" + uCntFld004 + "' <= '" + aIntCcs[nAndCc,2] + "')"     
                IF ( nAndCc < nAndCcs )
                    cbVldCC += " .or. "
                EndIF
            Next nAndCc
            lChkRegra := &( cbVldCC )
            IF !( lChkRegra )
                cException := "Centro de Custo Inválido Para o Grupo de Conta"
            EndIF
            Exit    
        EndIF

        IF (;
                ( "&" $ aRegra[ nRegra , 2 ] );
                .or.;
                (  ":" $ aRegra[ nRegra , 2 ] );
            )    
            IF ( "&" $ aRegra[ nRegra , 2 ] )
                lChkRegra := ( uCntFld004 $ aRegra[ nRegra , 2 ] )
                IF !( lChkRegra )
                    Exit
                EndIF
            EndIF
            IF ( ":" $ aRegra[ nRegra , 2 ] )
                aAdd( aIntCcs , StrToArray( aRegra[ nRegra , 2 ] , ":" ) )
                nAndCcs := Len( aIntCcs )
                cbVldCC := ""
                For nAndCc := 1 To nAndCcs 
                    cbVldCC += "'" + uCntFld004 + "' >= '" + aIntCcs[nAndCc,1] + "' .and. '" + uCntFld004 + "' <= '" + aIntCcs[nAndCc,2] + "'    
                    IF ( nAndCc < nAndCcs )
                        cbVldCC += " .or. "
                    EndIF
                Next nAndCc
                lChkRegra := &( cbVldCC )
                IF !( lChkRegra )
                    cException := "Centro de Custo Inválido Para o Grupo de Conta"
                    Exit    
                EndIF
            EndIF
        EndIF

    Next nRegra

Return( lChkRegra  )

/*
    Fun‡…o:        ChkField
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Verifica se Campo Deve Ser Validado
*/
Static Function ChkField( aFields , cField , cGrp , nLastPos )

    Local nFieldPos
    
    Local oException

    TRYEXCEPTION

        DEFAULT nLastPos    := 0

        IF Empty( cField  )
            cField := Upper( AllTrim( SubStr( ReadVar() , 4 ) ) )
        EndIF
    
        IF ( cGrp == "003" )
            nFieldPos := aScan( aFields , { |x| Upper( AllTrim( x[1] ) ) == cField } , ++nLastPos )
        ElseIF ( cGrp == "004" )
            nFieldPos := aScan( aFields , { |x| Upper( AllTrim( x[2] ) ) == cField } , ++nLastPos )
        Else
            UserException( OemToAnsi( "Grupo Inválido" ) )
        EndIF

    CATCHEXCEPTION USING oException

        nFieldPos := 0
    
    ENDEXCEPTION

Return( nFieldPos )

/*/
    Fun‡…o:        GetFileRegra
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Obter o Conteudo do arquivo de Amarracao
*/
Static Function GetFileRegra( aLines , oException , lShowError )

    Local aLineRead
    
    Local cFile            := FILE_AMARRACAO_CT1_CTT_FILIAL
    Local cLineRead
    Local cException
    
    Local lGetFile

    TRYEXCEPTION 
    
        lGetFile := File( cFile )
        
        IF !( lGetFile )
            cException := "O arquivo de Regras Amaração CT1 vs CTT não foi localizado"
            cException += CRLF 
            cException += "Arquivo: " + cFile
            cException += CRLF
            cException += "Entre em contato com o Administrador do Sistema"
            UserException( OemToAnsi( cException ) )
        EndIF
        
        ft_fUse( cFile )
    
        ft_fGoTop()
    
        DEFAULT aLines := {}
        
        While ( !ft_fEof() )
    
            cLineRead := ft_fReadLn()
            aLineRead := StrToArray( cLineRead , ";" )
            aAdd( aLines , aLineRead )
    
            ft_fSkip()
        
        End While
    
        ft_fUse()
    
        lGetFile    := !Empty( aLines )
        
        IF !( lGetFile )
            cException := "O conteúdo arquivo de Regras Amaração CT1 vs CTT é inválido"
            cException += CRLF 
            cException += "Arquivo: " + cFile
            cException += CRLF
            cException += "Entre em contato com o Administrador do Sistema"
            UserException( OemToAnsi( cException ) )
        EndIF
    
    CATCHEXCEPTION USING oException

        lGetFile            := .F.

        DEFAULT lShowError    := .F.
        IF ( lShowError )
            Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "INCONSITÊNCIA:" + CRLF +  oException:Description ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

Return( lGetFile )

/*/
    Fun‡…o:        GetFileFields
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡…o:    Obter os Campos de amarracao CT1 vs CTT
*/
Static Function GetFileFields( aLines , oException , lShowError )

    Local aLineRead
    
    Local cFile            := FILE_FIELDS_CT1_CTT
    Local cField
    Local cLineRead
    Local cException
    
    Local lGetFile
    
    Local nLine
    Local nLines

    TRYEXCEPTION 
    
        lGetFile := File( cFile )
        
        IF !( lGetFile )
            cException := "O arquivo de Relacionamento CT1 vs CTT não foi localizado "
            cException += CRLF 
            cException += cFile
            cException += CRLF
            cException += "Entre em contato com o Administrador do Sistema"
            UserException( OemToAnsi( cException ) )
        EndIF
        
        ft_fUse( cFile )
    
        ft_fGoTop()
    
        DEFAULT aLines := {}
        
        While ( !ft_fEof() )
    
            cLineRead := ft_fReadLn()
            aLineRead := StrToArray( cLineRead , ";" )
            aAdd( aLines , aLineRead )
    
            ft_fSkip()
        
        End While
    
        ft_fUse()
    
        nLines        := Len( aLines )
        lGetFile    := ( nLines > 1 )
        
        IF !( lGetFile )
            cException := "O Conteúdo arquivo de Relacionamento CT1 vs CTT é inválido"
            cException += CRLF 
            cException += "Arquivo: " + cFile
            cException += CRLF
            cException += "Entre em contato com o Administrador do Sistema"
            UserException( OemToAnsi( cException ) )
        EndIF

        For nLine := 2 To nLines

            cField    := aLines[ nLine , 1 ]
            cSXGGRP := GetSx3Cache( cField , "X3_GRPSXG" )

            IF !( cSXGGRP == "003" )
                cException := "O Conteúdo arquivo de Relacionamento CT1 vs CTT é inválido"
                cException += CRLF 
                cException += "Arquivo: " + cFile
                cException += CRLF
                cException += "Linha: " + AllTrim( Str( nLine ) )
                cException += CRLF
                cException += "Coluna (1): " + aLines[ 1 , 1 ]
                cException += CRLF
                cException += "Entre em contato com o Administrador do Sistema"
                UserException( OemToAnsi( cException ) )
            EndIF

            cField    := aLines[ nLine , 2 ]
            cSXGGRP := GetSx3Cache( cField , "X3_GRPSXG" )

            IF !( cSXGGRP == "004" )
                cException := "O Conteúdo arquivo de Relacionamento CT1 vs CTT é inválido"
                cException += CRLF 
                cException += "Arquivo: " + cFile
                cException += CRLF
                cException += "Linha: " + AllTrim( Str( nLine ) )
                cException += CRLF
                cException += "Coluna (2): " + aLines[ 1 , 2 ]
                cException += CRLF
                cException += "Entre em contato com o Administrador do Sistema"
                UserException( OemToAnsi( cException ) )
            EndIF

        Next nLine
    
    CATCHEXCEPTION USING oException

        lGetFile            := .F.

        DEFAULT lShowError    := .F.
        IF ( lShowError )
            Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "INCONSITÊNCIA:" + CRLF +  oException:Description ) , 1 , 0 )
        EndIF    

    ENDEXCEPTION

Return( lGetFile )

/*/
    Fun‡…o:        StrToArray
    Autor:        Marinaldo de Jesus
    Data:        23/11/2009
    Descri‡…o:    Retornar Array com o Parser de Uma String Concatenada
*/
Static Function StrToArray( cString , cConcat , bAddParser )

    Local aParser    := {}
    
    Local cParser
    
    Local nSize
    Local nParser
    Local nRealSize
    
    DEFAULT cConcat        := "+"
    DEFAULT bAddParser    := { || .T. }
    
    IF ( ( nParser := At( cConcat , cString ) ) > 0 )
        nRealSize    := Len( cConcat )
        nSize         := Max( ( nRealSize - 1  ) , 0 )
        While ( ( nParser := At( cConcat , cString ) ) > 0 )
            IF ( nParser > 1 )
                cParser := AllTrim( SubStr( cString , 1 , ( nParser - 1 ) ) )
                cString := SubStr( cString , ( nParser + nRealSize ) )
            Else
                cParser := ""
                cString := SubStr( cString , ( nParser + nRealSize ) )
            EndIF
            IF Eval( bAddParser , @cParser )
                aAdd( aParser , cParser )
            EndIF
        End While
        IF ( !Empty( cString ) )
            cParser := AllTrim( cString )
            IF Eval( bAddParser , @cParser )
                aAdd( aParser , cParser ) 
            EndIF
        EndIF    Else
    EndIF

Return( aParser )

/*/
    Fun‡…o:        IsCpoVar
    Autor:        Marinaldo de Jesus
    Data:        24/11/2005
    Descri‡…o:    Verificar se a Variavel de Memoria Ativa corresponde ao  campo passado por Parametro.
*/
Static Function IsCpoVar( cField )

    Local cVar    := Upper( AllTrim( SubStr( ReadVar() , 4 ) ) )
                                          
    DEFAULT cField := ""                  
    cField := Upper( AllTrim( cField ) )

Return( ( cVar == cField ) )

/*/
    Fun‡„o:        FileToArr
    Autor:        Marinaldo de Jesus
    Data:        24/11/2009
    Descri‡„o:    Retorna Array com as informacoes de um arquivo Texto
*/
Static Function FileToArr( cFile )
         
    Local aFile := {}
    
    Local cLine
        Local uUsed
    
    Begin Sequence
    
        IF !( File( cFile ) )
            Break
        EndIF
    
        uUsed := ft_fUse( cFile )
        IF (;
                ( ( ValType( uUsed ) == "N" ) .and. ( uUsed < 0 ) );
                .or.;
                ( ( ValType( uUsed ) == "L" ) .and. !( uUsed ) );            
            )    
            Break
        EndIF
    
        ft_fGoTop()
        While !( ft_fEof() )
            cLine := ft_fReadLn()
            aAdd( aFile , cLine )
            ft_fSkip()
        End While
        ft_fUse()
    
    End Sequence

Return( aFile )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
