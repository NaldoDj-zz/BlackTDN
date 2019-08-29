#INCLUDE "PAN-AMERICANA.CH"
/*/
    Programa:        U_PanCTB03
    Autor:            Marinaldo de Jesus
    Data:            26/11/2009
    Descrição:        Configurar o Relacionamento dos campos do CT1 (Plano de  Contas) com o CTT (Centros de Custo)
*/
User Function PanCTB03()

    Local aHeader            := {}
    Local aCols                := {}
    Local aArea                := GetArea()
    Local aColsAll            := {}
    Local aX2Fields            := {} 
    Local aMakeInfo            := {}
    Local aCT1RelCTT         := {}
    Local aSvColsAll        := {}
    Local aMrkBrwExec        := {} 
    Local aX2FieldsBrw      := {}
    Local aGetFileFields    := {}
    Local aX2Colors            := {}
    
    Local bCT1RelCTT        := { || CT1RelCTT( IF( ( lShowAll ) , "" , _X2->X2_CHAVE ) , @aHeader , @aColsAll , @lShowAll , @cX2Alias , @cCTTCT1File ) }

    Local cX2Alias            := "_X2"
    Local cAliasCpo
    Local cCTTCT1File        := FILE_FIELDS_CT1_CTT

    Local lOk
    Local lShowAll            := .F.

    Local nLoop
    Local nLoops
    Local nUsado            := 0
    Local nOpcRel            := 0
    Local nAliasCpo

    Private aGets
    Private aTela

    Private cCadastro        := OemToAnsi( "Configurar o Relacionamento dos campos do CT1 (Plano de  Contas) com o CTT (Centros de Custo) :: Empresa: " + cEmpAnt )

    BEGIN SEQUENCE

        CursorWait()

            nOpcRel := OpcShowRel()
            IF ( nOpcRel == 0 )
                Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( cCancel ) , 1 , 0 )
                Break
            EndIF

            lShowAll    := ( nOpcRel == 1 )

            IF !( lShowAll )
            
                lOk := MakeSX2( @cX2Alias ,  @aMakeInfo )
                IF !( lOk )
                    Break
                EndIF

            EndIF        
    
            IF File( cCTTCT1File )
                aCT1RelCTT         := {}
                aGetFileFields    := { aCT1RelCTT }
                U_InPanVld( "GetFileFields" , @aGetFileFields )
                aCT1RelCTT        := aGetFileFields[1]
            EndIF

            ++nUsado
            aAdd( aHeader , Array( __ELEMENTOS_AHEADER__ ) )
            aHeader[ nUsado , __AHEADER_TITLE__        ]    := "Field CT1"
            aHeader[ nUsado , __AHEADER_FIELD__        ]    := "CT1_FIELD"
            aHeader[ nUsado , __AHEADER_PICTURE__    ]    := "@!"
            aHeader[ nUsado , __AHEADER_WIDTH__        ]    := 10
            aHeader[ nUsado , __AHEADER_DEC__        ]    := 0
            aHeader[ nUsado , __AHEADER_VALID__        ]    := "IF(!Empty(GetSx3Cache(GetMemVar('CT1_FIELD'),'X3_CAMPO')),(GdFieldPut('CT1_FIELDD',GetSx3Cache(GetMemVar('CT1_FIELD'),'X3_TITULO')),.T.),(GdFieldPut('CT1_FIELDD',Space(Len(SX3->X3_TITULO))),.F.))"
            aHeader[ nUsado , __AHEADER_USE__        ]    := Chr(251)
            aHeader[ nUsado , __AHEADER_TYPE__        ]    := "C"
            aHeader[ nUsado , __AHEADER_F3__        ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV10__    ]    := ""
            aHeader[ nUsado , __AHEADER_CBOX__        ]    := ""
            aHeader[ nUsado , __AHEADER_INITPAD__    ]    := ""
            aHeader[ nUsado , __AHEADER_WHEN__        ]    := ""
            aHeader[ nUsado , __AHEADER_VISUAL__    ]    := "R"
            aHeader[ nUsado , __AHEADER_VLDUSR__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV16__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV17__    ]    := .F.

            ++nUsado
            aAdd( aHeader , Array( __ELEMENTOS_AHEADER__ ) )
            aHeader[ nUsado , __AHEADER_TITLE__        ]    := OemToAnsi( "Título CT1" )
            aHeader[ nUsado , __AHEADER_FIELD__        ]    := "CT1_FIELDD"
            aHeader[ nUsado , __AHEADER_PICTURE__    ]    := "@!"
            aHeader[ nUsado , __AHEADER_WIDTH__        ]    := Len(SX3->X3_TITULO)
            aHeader[ nUsado , __AHEADER_DEC__        ]    := 0
            aHeader[ nUsado , __AHEADER_VALID__        ]    := ""
            aHeader[ nUsado , __AHEADER_USE__        ]    := Chr(251)
            aHeader[ nUsado , __AHEADER_TYPE__        ]    := "C"
            aHeader[ nUsado , __AHEADER_F3__        ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV10__    ]    := ""
            aHeader[ nUsado , __AHEADER_CBOX__        ]    := ""
            aHeader[ nUsado , __AHEADER_INITPAD__    ]    := ""
            aHeader[ nUsado , __AHEADER_WHEN__        ]    := ""
            aHeader[ nUsado , __AHEADER_VISUAL__    ]    := "R"
            aHeader[ nUsado , __AHEADER_VLDUSR__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV16__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV17__    ]    := .F.

            ++nUsado
            aAdd( aHeader , Array( __ELEMENTOS_AHEADER__ ) )
            aHeader[ nUsado , __AHEADER_TITLE__        ]    := "Field CTT"
            aHeader[ nUsado , __AHEADER_FIELD__        ]    := "CTT_FIELD"
            aHeader[ nUsado , __AHEADER_PICTURE__    ]    := "@!"
            aHeader[ nUsado , __AHEADER_WIDTH__        ]    := 10
            aHeader[ nUsado , __AHEADER_DEC__        ]    := 0
            aHeader[ nUsado , __AHEADER_VALID__        ]    := "IF(!Empty(GetSx3Cache(GetMemVar('CTT_FIELD'),'X3_CAMPO')),(GdFieldPut('CTT_FIELDD',GetSx3Cache(GetMemVar('CTT_FIELD'),'X3_TITULO')),.T.),(GdFieldPut('CTT_FIELDD',Space(Len(SX3->X3_TITULO))),.F.))"
            aHeader[ nUsado , __AHEADER_USE__        ]    := Chr(251)
            aHeader[ nUsado , __AHEADER_TYPE__        ]    := "C"
            aHeader[ nUsado , __AHEADER_F3__        ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV10__    ]    := ""
            aHeader[ nUsado , __AHEADER_CBOX__        ]    := ""
            aHeader[ nUsado , __AHEADER_INITPAD__    ]    := ""
            aHeader[ nUsado , __AHEADER_WHEN__        ]    := ""
            aHeader[ nUsado , __AHEADER_VISUAL__    ]    := "R"
            aHeader[ nUsado , __AHEADER_VLDUSR__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV16__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV17__    ]    := .F.

            ++nUsado
            aAdd( aHeader , Array( __ELEMENTOS_AHEADER__ ) )
            aHeader[ nUsado , __AHEADER_TITLE__        ]    := OemToAnsi( "Título CTT" )
            aHeader[ nUsado , __AHEADER_FIELD__        ]    := "CTT_FIELDD"
            aHeader[ nUsado , __AHEADER_PICTURE__    ]    := "@!"
            aHeader[ nUsado , __AHEADER_WIDTH__        ]    := Len(SX3->X3_TITULO)
            aHeader[ nUsado , __AHEADER_DEC__        ]    := 0
            aHeader[ nUsado , __AHEADER_VALID__        ]    := ""
            aHeader[ nUsado , __AHEADER_USE__        ]    := Chr(251)
            aHeader[ nUsado , __AHEADER_TYPE__        ]    := "C"
            aHeader[ nUsado , __AHEADER_F3__        ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV10__    ]    := ""
            aHeader[ nUsado , __AHEADER_CBOX__        ]    := ""
            aHeader[ nUsado , __AHEADER_INITPAD__    ]    := ""
            aHeader[ nUsado , __AHEADER_WHEN__        ]    := ""
            aHeader[ nUsado , __AHEADER_VISUAL__    ]    := "R"
            aHeader[ nUsado , __AHEADER_VLDUSR__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV16__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV17__    ]    := .F.

            ++nUsado
            aAdd( aHeader , Array( __ELEMENTOS_AHEADER__ ) )
            aHeader[ nUsado , __AHEADER_TITLE__        ]    := ""
            aHeader[ nUsado , __AHEADER_FIELD__        ]    := "GHOSTCOL"
            aHeader[ nUsado , __AHEADER_PICTURE__    ]    := ""
            aHeader[ nUsado , __AHEADER_WIDTH__        ]    := 10
            aHeader[ nUsado , __AHEADER_DEC__        ]    := 0
            aHeader[ nUsado , __AHEADER_VALID__        ]    := ""
            aHeader[ nUsado , __AHEADER_USE__        ]    := Chr(251)
            aHeader[ nUsado , __AHEADER_TYPE__        ]    := "C"
            aHeader[ nUsado , __AHEADER_F3__        ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV10__    ]    := ""
            aHeader[ nUsado , __AHEADER_CBOX__        ]    := ""
            aHeader[ nUsado , __AHEADER_INITPAD__    ]    := ""
            aHeader[ nUsado , __AHEADER_WHEN__        ]    := ""
            aHeader[ nUsado , __AHEADER_VISUAL__    ]    := "V"
            aHeader[ nUsado , __AHEADER_VLDUSR__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV16__    ]    := ""
            aHeader[ nUsado , __AHEADER_RESERV17__    ]    := .F.

            nLoops := Len( aCT1RelCTT )
            For nLoop := 2 To nLoops
                cAliasCpo := AliasCpo( aCT1RelCTT[nLoop][1] )
                IF ( ( nAliasCpo := aScan( aColsAll , { |x| x[1] == cAliasCpo } ) ) == 0 )
                    aAdd( aColsAll , { cAliasCpo , {} } )
                EndIF
            Next nLoop

            aCols := GdRmkaCols( aHeader , .F. , .T. , .F. )
            For nLoop := 2 To nLoops

                cAliasCpo    := AliasCpo( aCT1RelCTT[nLoop][1] )

                GdFieldPut( "CT1_FIELD"  , aCT1RelCTT[nLoop][1] , 1 , aHeader , aCols )
                GdFieldPut( "CTT_FIELD"  , aCT1RelCTT[nLoop][2] , 1 , aHeader , aCols )
              
                GdFieldPut( "CT1_FIELDD" , GetSx3Cache(aCT1RelCTT[nLoop][1],'X3_TITULO') , 1 , aHeader , aCols )
                GdFieldPut( "CTT_FIELDD" , GetSx3Cache(aCT1RelCTT[nLoop][2],'X3_TITULO') , 1 , aHeader , aCols )

                IF ( ( nAliasCpo := aScan( aColsAll , { |x| x[1] == cAliasCpo } ) ) > 0 )
                    aAdd( aColsAll[ nAliasCpo ][2] , aClone( aCols[1] ) )
                EndIF

                IF !( lShowAll )
                    IF (cX2Alias)->( dbSeek( cAliasCpo , .F. ) )
                        IF (cX2Alias)->( RecLock( cX2Alias , .F. ) )
                            (cX2Alias)->X2_REL := "S"
                            (cX2Alias)->( MsUnLock() )
                        EndIF
                    EndIF
                EndIF    

            Next nLoop
            
            IF ( lShowAll )
                Eval( bCT1RelCTT )
                Break
            EndIF

        CursorArrow()

        aX2Fields        :=    {;
                                "X2_OK",;
                                {;
                                    "X2_CHAVE",;
                                    "X2_REL";
                                };
                            }

        aX2FieldsBrw    := {;
                                { "X2_OK"     , NIL , ""                            , NIL    },;
                                { "X2_CHAVE" , NIL , OemToAnsi( "Tabela" )        , NIL    },;
                                { "X2_NOME"     , NIL , OemToAnsi( "Descriç£¯" )    , NIL    };
                            }    

        aX2Colors        := {;
                                { "X2_REL=='S'"    , "BR_VERDE"    } ,;
                                { "X2_REL<>'S'"    , "BR_VERMELHO"    } ;
                            }                    

        aMrkBrwExec        := {;
                                cX2Alias                    ,;    //01 -> Alias para MarkBrowse
                                aX2Fields                    ,;    //02 -> Array Bidimentisonal com o Campo para o Mark e os campos chaves
                                bCT1RelCTT                    ,;    //03 -> Bloco a ser executado a Cada Registro
                                NIL                            ,;    //04 -> Bloco a ser executado para Verificacao de Erro e Geracao do Log
                                "Relacionamento CT1 vs CTT"    ,;    //05 -> Titulo do Dialog
                                .F.                            ,;    //06 -> Se na Ativacao do Dialog inicializa a opcao para efetuar o Filtro
                                NIL                             ,;    //07 -> Expressao com a Condicao para o Mark
                                aX2FieldsBrw                ,;    //08 -> Campos que constarao no Browse
                                NIL                            ,;    //09 -> Expressao de Filtro do Grid ( Top )
                                NIL                            ,;    //10 -> Expressao de Filtro do Grid ( Bottom )
                                NIL                            ,;    //11 -> Coordenadas do Objeto
                                NIL                            ,;    //12 -> Conteudo a Ser Gravado no campo de controle do Mark
                                NIL                            ,;    //13 -> Objeto Dialog ( Por referencia )
                                __LocalDriver                ,;    //14 -> Rdd do DataBase
                                .F.                            ,;    //15 -> Se deverá ¥xecutar Proc2BarGauge() ao clicar no Botao Confirmar.
                                aX2Colors                    ,;    //16 -> Cores para o Browse
                                NIL                            ,;    //17 -> aIdxCol ?
                                NIL                            ,;    //18 -> Expressao de Filtro
                                .T.                            ,;    //19 -> Se Atualiza o Browse a Cada Registro Processado    
                                NIL                            ,;    //20 -> Objeto MsSelect por Referencia
                                .F.                              ;    //21 -> Se o Dialog devera ser Montado no Padrao do Siga
                                }

        IF U_LIB01Exec( "MrkBrwExec" , aMrkBrwExec )
            IF !( ArrayCompare( aSvColsAll , aColsAll ) )
                WhileYesNoWait(;
                                    { || MayIUseCode( "grv"+cCTTCT1File ) }                            ,;    //Bloco a Ser Executando Enquando ( Devera Retornar Valor Logico )
                                    3                                                                ,;    //Tempo de Espera para a ProcWaiting()
                                    .T.                                                                   ,;    //Se podera Encerrar as as Tentativas ( Button Cancel Enabled )
                                    "Não Foi Possível Salvar as alterações."                        ,;    //Mensagem de Corpo para a MsgInfo
                                    "Atenção!!!"                                                    ,;    //Titulo para a MsgInfo
                                    "O arquivo está bloqueado por Outro usuário. Deseja Aguardar?"    ,;    //Mensagem de Corpo para a MsgYesNo
                                    "Atenção!!!!"                                                    ,;    //Titulo para a MsgYesNo
                                    "Aguardando Desbloqueio do arquivo..."                            ,;    //Mensagem de corpo para a ProcWaiting
                                    "Aguarde..."                                                     ;    //Titulo para a ProcWaiting
                                )
                MsgRun( OemToAnsi( "Aguarde..." ) , OemToAnsi( "Salvando alterações" ) , { || PANCtb03Grv( aHeader , aColsAll , cCTTCT1File , .T. ) } )
                Leave1Code( "grv"+cCTTCT1File )
            EndIF
        EndIF    

    END SEQUENCE

    CursorWait()

        nLoops := Len( aMakeInfo )
        For nLoop := 1 To nLoops
            IF ( Select( aMakeInfo[nLoop][1] ) > 0 )
                CloseTmpFile( aMakeInfo[nLoop][1] , aMakeInfo[nLoop][2] , aMakeInfo[nLoop][3] )
            EndIF
        Next nLoop
    
        RestArea( aArea )

    CursorArrow()    

Return( NIL ) 

/*/

    Função:        MakeSX2
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:    Montar o SX2
*/
Static Function MakeSX2( cX2Alias , aMakeInfo )

    Local aArea            := GetArea()
    Local aAreaSX2        := SX2->( GetArea() )
    Local aAreaSX3        := SX3->( GetArea() )
    Local aX2dbStru        := {}        
    Local aX2BagName    := {}
    
    Local bSx2Skip        := { || ( SX2->X2_CHAVE $ 'CT1|&|CTT|&|SI1' ) .or. SX2->( !ChkSx3Grp( "SX2" ) ) }

    Local cX2TmpFile
    
    Local lMakeOk        := .F.

    Local oException
    
    TRYEXCEPTION

        IF ( Select( cX2Alias ) > 0 )
            (cX2Alias)->( dbCloseArea() )    
        EndIF

        aAdd( aX2dbStru , Array( DBS_ALEN ) )
        aX2dbStru[ 1 , DBS_NAME ]    := "X2_OK"
        aX2dbStru[ 1 , DBS_TYPE ]    := "C"
        aX2dbStru[ 1 , DBS_LEN ]    := 2
        aX2dbStru[ 1 , DBS_DEC ]    := 0

        aAdd( aX2dbStru , Array( DBS_ALEN ) )
        aX2dbStru[ 2 , DBS_NAME ]    := "X2_CHAVE"
        aX2dbStru[ 2 , DBS_TYPE ]    := "C"
        aX2dbStru[ 2 , DBS_LEN ]    := Len( SX2->X2_CHAVE )
        aX2dbStru[ 2 , DBS_DEC ]    := 0

        aAdd( aX2dbStru , Array( DBS_ALEN ) )
        aX2dbStru[ 3 , DBS_NAME ]    := "X2_NOME"
        aX2dbStru[ 3 , DBS_TYPE ]    := "C"
        aX2dbStru[ 3 , DBS_LEN ]    := Len( SX2->X2_NOME )
        aX2dbStru[ 3 , DBS_DEC ]    := 0

        aAdd( aX2dbStru , Array( DBS_ALEN ) )
        aX2dbStru[ 4 , DBS_NAME ]    := "X2_REL"
        aX2dbStru[ 4 , DBS_TYPE ]    := "C"
        aX2dbStru[ 4 , DBS_LEN ]    := 1
        aX2dbStru[ 4 , DBS_DEC ]    := 0

        cX2TmpFile    := ( CriaTrab( NIL , .F. ) + GetdbExtension() )

        aX2BagName     := GetArrBagName( "SX2" , @cX2TmpFile )
        
        aX2BagName[ 2 , 1 , 1 ] := cX2Alias+"1"
        aX2BagName[ 2 , 1 , 2 ] := "X2_CHAVE"
        aX2BagName[ 2 , 1 , 3 ] := __ExecMacro( "{ ||" + "X2_CHAVE" + "}" )
        aX2BagName[ 2 , 1 , 4 ] := cX2Alias+"1"

        SX3->( dbSetOrder( 3 ) ) //X3_GRPSXG+X3_ARQUIVO
        SX2->( dbSetOrder( 1 ) ) //X2_CHAVE
        lMakeOk := MakeTmpFile(;
                                    "SX2"            ,;    //01 -> Alias aberto para a Criaç£¯ do Temporario ( Obrigatorio )
                                    @cX2Alias        ,;    //02 -> Alias atribuido a Area de Trabalho do Temporario ( Por Referencia )
                                    @cX2TmpFile        ,;    //03 -> Nome do Arquivo Temporario Criado ( Por Referencia )
                                    NIL                ,;    //04 -> Bloco para Posicionamento de Registro ( Opcional )
                                    NIL                ,;    //05 -> Bloco para a Condicao While ( Opcional )
                                    @bSx2Skip        ,;    //06 -> Bloco para a Skip de Registro ( Opcional )
                                    @aX2BagName        ,;    //07 -> Indices a Serem Criados Para o Temporario ( Opcional )
                                    @aX2dbStru        ,;    //08 -> Array com a Estrutura da Tabela ( Opcional )
                                    NIL                ,;    //09 -> Array com os Recnos para a Montagem do Arquivo ( Opcional )
                                    @__LocalDriver    ;    //10 -> Rdd Para a Criacao do Arquivo Temporario
                                )

        IF !( lMakeOk )
            UserException( OemToansi( "Não foi Possível instanciar o Dicionário de Tabelas" ) )
        EndIF    
    
        DEFAULT aMakeInfo    := {}
        
        aAdd( aMakeInfo , { cX2Alias , cX2TmpFile , aX2BagName }  )

    CATCHEXCEPTION USING oException

        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "ERRO GRAVE:" + CRLF + CRLF + oException:Description ) , 1 , 0 )
    
    ENDEXCEPTION

    RestArea( aAreaSX3 )
    RestArea( aAreaSX2 )
    RestArea( aArea )

Return( lMakeOk  )

/*/

    Função:        ChkSx3Grp
    Autor:         Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:  Verifica se para o X2_CHAVE existe Grupo 003 e 004
*/
Static Function ChkSx3Grp( cAlias )
    
    Local lFound    := .F.

    lFound := SX3->( dbSeek( "003" + (cAlias)->X2_CHAVE , .F. ) )
    IF ( lFound )
        lFound := SX3->( dbSeek( "004" + (cAlias)->X2_CHAVE , .F. ) )
    EndIF

Return( lFound  )

/*/

    Função:        MakeTmpFile
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:    Cria Arquivo Temporario a Partir de um Alias
*/
Static Function MakeTmpFile(;
                                cAlias        ,;    //01 -> Alias aberto para a Criaç£¯ do Temporario ( Obrigatorio )
                                cAliasTmp    ,;    //02 -> Alias atribuido a Area de Trabalho do Temporario ( Por Referencia )
                                cTempFile    ,;    //03 -> Nome do Arquivo Temporario Criado ( Por Referencia )
                                bdbSeek        ,;    //04 -> Bloco para Posicionamento de Registro ( Opcional )
                                bWhileCond    ,;    //05 -> Bloco para a Condicao While ( Opcional )
                                bSkipCond    ,;    //06 -> Bloco para a Skip de Registro ( Opcional )
                                aBagName    ,;    //07 -> Indices a Serem Criados Para o Temporario ( Opcional )
                                aStructTmp    ,;    //08 -> Array com a Estrutura da Tabela ( Opcional )
                                aRecnos        ,;    //09 -> Array com os Recnos para a Montagem do Arquivo ( Opcional )
                                cRddName     ;    //10 -> Rdd Para a Criacao do Arquivo Temporario
                            )

    Local aFieldPos1    := {}
    Local aFieldPos2    := {}

    Local cBagName
    
    Local lMakeOk
    Local lRecnos
    
    Local nBag
    Local nBags
    Local nField
    Local nRecno
    Local nFields
    Local nRecnos
    Local nBagName
    
    Begin Sequence
    
        DEFAULT aStructTmp    := ( cAlias )->( dbStruct() )
        DEFAULT cTempFile    := ( CriaTrab( NIL , .F. ) + GetdbExtension() )
        DEFAULT cRddName    := "DBFCDXADS"
    
        IF !( lMakeOk := MsCreate( cTempFile , aStructTmp , cRddName ) )
            Break
        EndIF
    
        DEFAULT cAliasTmp := GetNextAlias()
        IF !( lMakeOk := MsOpenDbf(.T.,cRddName,cTempFile,cAliasTmp,.T.,.F.,.T.,.F.) )
            Break
        EndIF
    
        DEFAULT bWhileCond    := { || .T. }
        DEFAULT bSkipCond    := { || .F. }
    
        nFields := Len( aStructTmp )
        For nField := 1 To nFields
            aAdd( aFieldPos1 , ( cAliasTmp )->( FieldPos( aStructTmp[ nField , DBS_NAME ] ) ) )
            aAdd( aFieldPos2 , ( cAlias )->( FieldPos( aStructTmp[ nField , DBS_NAME ] ) ) )
        Next nPosCpo 
    
        lRecnos    := ( ValType( aRecnos ) == "A" .and. !Empty( aRecnos ) )
    
        IF !( lRecnos )
            IF ( ValType( bdbSeek ) == "B" )
                ( cAlias )->( Eval( bdbSeek ) )
            Else
                ( cAlias )->( dbGotop() )
            EndIF
        Else
            nRecno    := 0
            nRecnos    := Len( aRecnos )
        EndIF    
    
        While (;
                    IF(;
                            ( lRecnos ),;
                            ( ( ++nRecno ) <= nRecnos ) ,;
                            ( cAlias )->(;
                                            !Eof();
                                            .and.;
                                            Eval( bWhileCond );
                                            );
                        );
                )                            
    
            IF !( lRecnos )
                IF ( cAlias )->( Eval( bSkipCond ) )
                    ( cAlias )->( dbSkip() )
                    Loop
                EndIF
            Else
                ( cAlias )->( dbGoto( aRecnos[ nRecno ] ) )
                IF ( cAlias )->( Eof() )
                    Loop
                EndIF
            EndIF    
    
            ( cAliasTmp )->( dbAppend( .T. ) )
    
            For nField := 1 To nFields
                IF ( aFieldPos2[ nField ] > 0 )
                    ( cAliasTmp )->( FieldPut( aFieldPos1[ nField ] , ( cAlias )->( FieldGet( aFieldPos2[ nField ] ) ) ) )
                EndIF    
            Next nField
    
            IF !( lRecnos )
                ( cAlias )->( dbSkip() )
            EndIF    
    
        End While
    
        IF Empty( aBagName )
            aBagName := GetArrBagName( @cAlias , @cTempFile )
        EndIF
    
        IF !Empty( aBagName )
    
            nBags := Len( aBagName[ 2 ] )
            For nBag := 1 To nBags
                ( cAliasTmp )->( OrdCreate( aBagName[ 1 ] , aBagName[ 2 , nBag , 1 ] , aBagName[ 2 , nBag , 2 ] , aBagName[ 2 , nBag , 3 ] , .F. ) )
            Next nBag
            ( cAliasTmp )->( dbClearIndex() )
            For nBag := 1 To nBags
                ( cAliasTmp )->( OrdListAdd( aBagName[ 1 ] , aBagName[ 2 , nBag , 1 ] ) )
                ( cAliasTmp )->( dbSetNickName( aBagName[ 1 ] , aBagName[ 2 , nBag , 4 ] ) )
            Next nBag
    
        EndIF
    
    End Sequence

Return( lMakeOk )

/*/
    Função:        CloseTmpFile
    Autor:        Marinaldo de Jesus
    Data:        26/11/2009
    Descrição:  Fechar e Apagar Temporarios Criados pela MakeTmpFile
*/
Static Function CloseTmpFile( cAlias , cTableName , aBagName )
    
    Local lCloseOK        := .T.
    
    Begin Sequence
    
        IF (;
                Empty( cAlias );
                .or.;
                ( Select( cAlias ) == 0 );
            )
            Break
        EndIF        
    
        ( cAlias )->( dbCloseArea() )
    
        IF File( cTableName )
            IF !( lCloseOK := FileErase( cTableName ) )
                Break
            EndIF
        EndIF
    
        IF (;
                !( ValType( aBagName ) == "A" );
                .or.;
                Empty( aBagName );
            )    
            Break
        EndIF
    
        IF File( aBagName[ 1 ] )
            IF !( lCloseOK := FileErase( aBagName[ 1 ] ) )
                Break
            EndIF
        EndIF
    
    End Sequence

Return( lCloseOK )

/*/
    Função:        GetArrBagName
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:    Obtem Array com as Ordens para o Arquivo Temporario
*/
Static Function GetArrBagName( cAlias , cdbFile )

    Local aBagName
    
    Local cBagName
    
    Local nBagName
    
    DEFAULT cdbFile    := CriaTrab( NIL , .F. )
    cBagName        := ( RetFileName( cdbFile ) + RetIndExt() )
    aBagName        := { cBagName , {} }
    
    IF PosAlias( "SIX" , cAlias , NIL , NIL , 1 , .T. )
        While SIX->( INDICE == cAlias )
            aAdd( aBagName[2] , Array( 4 ) )
            nBagName := Len( aBagName[2] )
               aBagName[ 2 , nBagName , 1 ] := SIX->( INDICE + ORDEM )
               aBagName[ 2 , nBagName , 2 ] := SIX->CHAVE
               aBagName[ 2 , nBagName , 3 ] := __ExecMacro( "{ ||" + SIX->CHAVE + "}" )
            aBagName[ 2 , nBagName , 4 ] := SIX->NICKNAME
            SIX->( dbSkip() )
        End While
    Else
        aAdd( aBagName[2] , Array( 4 ) )
    EndIF

Return( aBagName )


/*/
    Função:        RetFileName
    Autor:         Marinaldo de Jesus
    Data:        26/11/2009
    Descrição:  Retorna o Nome do Arquivo sem a Extensao e sem o Path
*/
Static Function RetFileName( cFile )
    Local n  := rAt( "." , cFile )
    Local nI := rAt("\",cFile)
Return( SubStr( cFile , IF( nI > 0 , nI + 1 , 1 ) ,IF( n > 0 , n-1 , Len( cFile ) - nI ) ) )

/*/

    Função:        CT1RelCTT
    Autor:         Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:  Relacionar Campos do CT1 com o CTT
*/
Static Function CT1RelCTT( cAlias , aHeader , aColsAll , lShowAll , cX2Alias , cCTTCT1File )

    Local aArea                := GetArea(Alias())
    Local aSvKeys            := GetKeys()
    
    Local aAdvSize            := {}
    Local aInfoAdvSize        := {}
    Local aObjSize            := {}
    Local aObjCoords        := {}
    
    Local aCols                := {}
    
    Local aButtons            := {}
    
    Local bSet15            := { || NIL }
    Local bSet24            := { || NIL }
    Local bGdLinOk            := { |oBrowse| PanCtb03LinOk( oBrowse ) }
    Local bGdTudOk            := { |oBrowse| PanCtb03TudOk( oBrowse ) }

    Local bDialogInit        := { || NIL }
    
    Local bShowFile            := { || NIL }
    Local bCT1vsCTT            := { || NIL }

    Local lOk                := .F.

    Local nLoop                := 0
    Local nLoops            := 0
    Local nItem                := 0
    Local nItens            := 0

    Local nOpcNewGd            := IF( ( lShowAll ) , 0 ,  ( GD_INSERT + GD_UPDATE + GD_DELETE    ) )

    Local nPosAlias            := IF( ( lShowAll ) , 0 ,  aScan( aColsAll , { |x| ( x[1] == cAlias ) } ) )
    
    Local nGdDeleted        := GdFieldPos( "GDDELETED" , aHeader )

    Local oDlg                := NIL
    Local oGetDados            := NIL
    
    Private aGets
    Private aTela
    
    /*/
        Poe o Ponteiro do Mouse em Estado de Espera
    */
    CursorWait()
    
    Begin Sequence

        /*
            Cria as Variaveis de Memoria
        */
        nLoops := Len( aHeader )
        For nLoop := 1    To nLoops
            SetMemVar( aHeader[ nLoop , __AHEADER_FIELD__ ] , GetValType( aHeader[ nLoop , __AHEADER_TYPE__ ] , aHeader[ nLoop , __AHEADER_WIDTH__ ] ) , .T. )
        Next nLoop 
        
        IF ( nPosAlias > 0 )
            aCols    := aColsAll[ nPosAlias ][2]
        Else
            IF ( lShowAll )
                nLoops    := Len( aColsAll )
                aCols    := {}
                For nLoop := 1 To nLoops
                    nItens := Len( aColsAll[ nLoop ][2] )
                    For nItem := 1 To nItens
                        aAdd( aCols , aColsAll[ nLoop ][2][nItem] )
                    Next nItem
                Next nLoop
            Else
                aCols    := GdRmkaCols( aHeader , .F. , .T. , .F. )
            EndIF
        EndIF

        /*
            Monta as Dimensoes dos Objetos
        */
        aAdvSize        := MsAdvSize( NIL , .F. )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
        aObjSize        := MsObjSize( aInfoAdvSize , aObjCoords )
    
        /*
            Define o Botao de Pesquisa na GetDados
        */
        bShowFile := { ||    ShowFile( oGetDados , aColsAll , cCTTCT1File ),;
                            SetKey( VK_F4 , bShowFile );
                   }
        aAdd(;
                aButtons    ,;
                                {;
                                    "PMSPESQ",;
                                       bShowFile,;
                                          OemToAnsi( "Pesquisar" + "...<F4>"  ),;
                                          OemToAnsi( "Pesquisar" );
                                   };
             )

        /*
            Define o Botao Para o Relacionamento da CT1 com a CTT
        */
        IF !( lShowAll )
            bCT1vsCTT := { ||    CT1vsCTT( @cAlias , @oGetDados , @cX2Alias ),;
                                SetKey( VK_F5 , bCT1vsCTT );
                            }
            aAdd(;
                    aButtons    ,;
                                    {;
                                        "DESTINOS",;
                                           bCT1vsCTT,;
                                              OemToAnsi( "Relacionar" + "...<F5>"  ),;
                                              OemToAnsi( "Relacionar" );
                                       };
                 )
        EndIF
        
        /*
            Define o Bloco para a Tecla <CTRL-O>
        */
        IF ( lShowAll )
            bSet15        := { || ( GetKeys() , lOk := .F. , oDlg:End() ) }
        Else
            bSet15        := { ||;
                                 IF( oGetDados:TudoOk(),;
                                        (;
                                              GetKeys() ,;
                                              lOk := .T.,;
                                              IF(;
                                                      ( nPosAlias > 0 ) ,;
                                                      IF( !ArrayCompare( aColsAll[nPosAlias][2] , oGetDados:aCols ) ,;
                                                           aColsAll[nPosAlias][2] := oGetDados:aCols , .T.; 
                                                        ) ,;
                                                      aAdd( aColsAll , { cAlias , oGetDados:aCols } ) ) ,;
                                              oDlg:End(); 
                                        ),;
                                        .F.;
                                    );
                             }
        EndIF
        
        /*
            Define o Bloco para a Teclas <CTRL-X>
        */
        bSet24        := { || ( GetKeys() , lOk := .F. , oDlg:End() ) }
    
        /*    
            Define o Bloco para o Init do Dialog
        */
        bDialogInit := { ||;
                                EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),;
                                SetKey( VK_F4 , bShowFile  ),;
                                IF( !( lShowAll ) , SetKey( VK_F5 , bCT1vsCTT ) , NIL );
                        }
    
        /*
            Monta o Dialogo Principal para a Manutencao das Formulas
        */
        DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Relacionando Campos do CT1 ( Plano de Contas ) com o CTT ( Centros de Custo) Empresa: " + cEmpAnt ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
    
            /*
                Monta o Objeto GetDados
            */
            oGetDados := MsNewGetDados():New(    aObjSize[1,1]    ,;    //01 -> nTop        Linha Inicial
                                                aObjSize[1,2]    ,;    //02 -> nLelft        Coluna Inicial
                                                aObjSize[1,3]    ,;    //03 -> nBottom        Linha Final    
                                                aObjSize[1,4]    ,;    //04 -> nRight      Coluna Final
                                                nOpcNewGd        ,;    //05 -> nStyle:        Controle do que podera ser realizado na GetDado
                                                bGdLinOk        ,;    //06 -> ulinhaOK:    Funcao ou CodeBlock para validar a edicao da linha
                                                bGdTudOk        ,;    //07 -> uTudoOK:     Funcao ou CodeBlock para validar todas os registros da GetDados
                                                NIL                ,;    //08 -> cIniCpos:    Campo para Numeracao Automatica
                                                NIL                ,;    //09 -> aAlter:     Array unidimensional com os campos Alteraveis
                                                0                ,;    //10 -> nfreeze:    Numero de Colunas para o Freeze
                                                NIL                ,;     //11 -> nMax:        Numero Maximo de Registros na GetDados    
                                                NIL                ,;    //12 -> cFieldOK:    ?
                                                NIL                ,;    //13 -> usuperdel:    Funcao ou CodeBlock para executar SuperDel na GetDados
                                                { || .T. }        ,;    //14 -> udelOK:        Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
                                                oDlg            ,;    //15 -> oWnd:        Objeto Dialog onde a GetDados sera Desenhada
                                                aHeader            ,;    //16 -> aParHeader:    Array com as Informacoes de Cabecalho
                                                aCols             ;    //17 -> aParCols:    Array com as Informacoes de Detalhes
                                             )//...
            
    
        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
    
    End Sequence

    /*/
        Verifica se Todos os Itens Foram Deletados
    */
    IF (;
            ( lOk );
            .and.;
            ( nPosAlias > 0 );
        )
        IF ( aScan( aColsAll[nPosAlias][2] , { |x| !x[nGdDeleted] } ) == 0 )
            IF (cX2Alias)->( dbSeek( aColsAll[nPosAlias][1] , .F. ) )
                IF (cX2Alias)->( RecLock( cX2Alias , .F. ) )
                    (cX2Alias)->X2_REL := " "
                    (cX2Alias)->( MsUnLock() )
                EndIF
            EndIF
        EndIF
    EndIF        
        
    /*
        Restaura os Dados de Entrada
    */
    RestArea( aArea )
    
    /*
        Restaura as Teclas de Atalho
    */
    RestKeys( aSvKeys , .T. )
    
    /*    
        Restaura o Ponteiro do Mouse
    */
    CursorArrow()

Return( NIL )

/*
    Função:        PANCtb03Grv
    Autor:         Marinaldo de Jesus
    Data:         25/11/2009
    Descrição:    Gravar as Informacoes em Arquivo
*/
Static Function PANCtb03Grv( aHeader , aColsAll , cCTTCT1File , lGrava )
    
    Local aCols            := {}
    Local aFields        := { "CT1_FIELD" , "CTT_FIELD" }

    Local bCondDel        := { || .F. }

    Local cbCondDel        := ""
    Local cConcat        := ".or."
    Local cDetGrv        := ""
    Local cMsgException    := ""
    
    Local lGrvOk        := .F.

    Local nLoop
    Local nLoops
    Local nItem
    Local nItens
    Local nError
    
    Local nField
    Local nFields
    Local nConcat
    Local nCt1Field
    Local nCttField
    Local nFieldPos

    Local oException

    TRYEXCEPTION

        nLoops := Len( aColsAll )
        For nLoop := 1 To nLoops
            nItens := Len( aColsAll[nLoop][2] )
            For nItem := 1 To nItens
                aAdd( aCols , aColsAll[nLoop][2][nItem] )
            Next nItem
        Next nLoop    

        nFields := Len( aFields )
        For nField := 1 To nFields
            nFieldPos := GdFieldPos( aFields[ nField ] , aHeader )
            IF ( nFieldPos > 0 )
                cbCondDel += "Empty(aColsItem[" + AllTrim( Str( nFieldPos ) ) + "])"
                cbCondDel += cConcat
            EndIF
        Next nField
        
        IF !Empty( cbCondDel )
            nConcat    := Len( cConcat )
            IF ( SubStr( cbCondDel , -( nConcat ) ) == cConcat )
                cbCondDel := SubStr( cbCondDel , 1 , ( Len( cbCondDel ) - nConcat ) )
            EndIF
            cbCondDel    := "{ |aColsItem| " + cbCondDel + "}"
            bCondDel    := __ExecMacro( cbCondDel )
        EndIF

        GdSuperDel( @aHeader , @aCols , NIL , .T. , bCondDel )
        GdSplitDel( @aHeader , @aCols , {} )

        nCt1Field        := GdFieldPos( "CT1_FIELD" , aHeader )
        nCttField        := GdFieldPos( "CTT_FIELD" , aHeader )

        aSort( aCols , NIL , NIL , { |x,y| AliasCpo(x[nCttField]) < AliasCpo(y[nCttField]) } )

        cDetGrv := ( "CT1_FIELD;CTT_FIELD" + CRLF )

        nLoops := Len( aCols )
        For nLoop := 1 To nLoops
            cDetGrv     += GdFieldGet( "CT1_FIELD" , nLoop , .F. , aHeader , aCols )
            cDetGrv     += ";"
            cDetGrv     += GdFieldGet( "CTT_FIELD" , nLoop , .F. , aHeader , aCols )
            cDetGrv     += CRLF 
        Next nLoop

        DEFAULT lGrava    := .T.
        IF ( lGrava )

            IF File( cCTTCT1File )
                lGrvOk := FileErase( cCTTCT1File , @nError )
                IF !( lGrvOk )
                    cMsgException += "File Error: " + AllTrim( Str( nError ) )
                    cMsgException += CRLF
                    cMsgException += "Não foi Possível regravar o o arquivo: "
                    cMsgException += CRLF
                    cMsgException += cCTTCT1File
                    cMsgException += CRLF
                    cMsgException += "Entre em contato com o Administrador do Sistema!"
                EndIF    
            EndIF
        
            MemoWrite( cCTTCT1File , cDetGrv )
        
            lGrvOk := File( cCTTCT1File )
            IF !( lGrvOk )
                cMsgException += "File Error: " + AllTrim( Str( nError ) )
                cMsgException += CRLF
                cMsgException += "Não foi Possível regravar o o arquivo: "
                cMsgException += CRLF
                cMsgException += cCTTCT1File
                cMsgException += CRLF
                cMsgException += "Entre em contato com o Administrador do Sistema!"
            EndIF

        EndIF
            
    CATCHEXCEPTION USING oException
    
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "ERRO DE GRAVAÇÃO:" + CRLF + CRLF + oException:Description ) , 1 , 0 )
    
    ENDEXCEPTION

Return( IF( lGrava , lGrvOk , cDetGrv ) )

/*/
    Função:        ShowFile
    Autor:         Marinaldo de Jesus
    Data:         28/11/2009
    Descrição:    Mostrar o Conteudo do Arquivo
*/
Static Function ShowFile( oGetDados , aColsAll , cFileShow )

    Local aAdvSize
    Local aSvKeys
    Local aObjSize
    Local aObjCoords
    Local aInfoAdvSize
    
    Local bSet15
    Local bSet24
    Local bDialogInit

    Local cMemoEdit
    Local cTitCompl
    
    Local oDlg
    Local oFont
    Local oMemoEdit
    
    Begin Sequence
    
        cMemoEdit := PANCtb03Grv( oGetDados:aHeader , aColsAll , cFileShow , .F. )
    
        /*
            Monta as Dimensoes dos Objetos
        */
        aAdvSize        := MsAdvSize( .T. , .T. )
        aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
        aObjCoords        := { { 0 , 0 , .T. , .T. } }
        aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )
    
        /*
            Salva as Teclas de Atalho
        */
        aSvKeys := GetKeys()
    
        /*
            Define o Bloco para a Tecla <CTRL-O>
        */
        bSet15    := { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
    
        /*
            Define o Bloco para a Tecla <CTRL-X>
        */
        bSet24    := { || RestKeys( aSvKeys , .T. ) , oDlg:End() }
    
        /*/
            Define o Bloco para o INIT do Dialog
        */
        bDialogInit := { ||  EnchoiceBar( @oDlg , @bSet15 , @bSet24  ) }
    
        /*
            Carrega o Complemento do Titulo
        */
        cTitCompl := cFileShow
    
        DEFINE FONT oFont NAME "Arial" SIZE 0,-15 //BOLD
        DEFINE MSDIALOG oDlg TITLE cCadastro + OemToAnsi( " :: " + cTitCompl ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() STYLE DS_MODALFRAME STATUS PIXEL 
                
            @ aObjSize[1,1],aObjSize[1,2] GET oMemoEdit VAR cMemoEdit MEMO SIZE aObjSize[1,4],(aObjSize[1,3]-15) FONT oFont OF oDlg PIXEL WHEN ( .T. )
            oMemoEdit:lReadOnly := .T.
            oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
            
        ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit ) CENTERED
        RestKeys( aSvKeys , .T. )
    
    End Sequence

Return( NIL )

/*/
    Função:        CT1vsCTT
    Autor:         Marinaldo de Jesus
    Data:         27/11/2009
    Descrição:    Efetuar Relacionamento entre os campos do CT1 vs CTT
*/
Static Function CT1vsCTT( cAlias , oGetDados , cX2Alias )

    Local aCT1Fields    := {}
    Local aCTTFields    := {}
    Local aArea            := GetArea()
    Local aAreaSX3        := SX3->( GetArea() )

    Local cX3Campo        := ""

    Local nLoop
    Local nLoops
    Local nSpace
    
    Local nCt1Field        := GdFieldPos( "CT1_FIELD" , oGetDados:aHeader )
    Local nCttField        := GdFieldPos( "CTT_FIELD" , oGetDados:aHeader )
    
    Local oDlg
    Local oFont

    Begin Sequence

        SX3->( dbSetOrder( 3 ) ) //X3_GRPSXG+X3_ARQUIVO
        SX3->( dbSeek( "003" + cAlias ) )
        While SX3->(;
                        !Eof();
                        .and.;
                        ( X3_GRPSXG == "003" );
                        .and.;
                        ( X3_ARQUIVO == cAlias );
                    )
            cX3Campo := SX3->X3_CAMPO
            cX3Campo := Upper( AllTrim( cX3Campo ) )
            IF ( aScan( oGetDados:aCols , { |x| Upper( AllTrim( x[nCt1Field] ) ) == cX3Campo } ) == 0 )
                aAdd( aCT1Fields , { "" , cX3Campo } )
            EndIF
            SX3->( dbSkip() )
        End While

        nLoops := Len( aCT1Fields )
        For nLoop := 1 To nLoops
            aCT1Fields[ nLoop , 1 ] := AllTrim( Str(nLoop ) )
        Next nLoop            

        SX3->( dbSeek( "004" + cAlias ) )
        While SX3->(;
                        !Eof();
                        .and.;
                        ( X3_GRPSXG == "004" );
                        .and.;
                        ( X3_ARQUIVO == cAlias );
                    )
            cX3Campo := SX3->X3_CAMPO
            cX3Campo := Upper( AllTrim( cX3Campo ) )
            IF ( aScan( oGetDados:aCols , { |x| Upper( AllTrim( x[nCttField] ) ) == cX3Campo } ) == 0 )
                aAdd( aCTTFields , { "  " , cX3Campo } )
            EndIF
            SX3->( dbSkip() )
        End While            

        MakeRelView( @oGetDados , @aCT1Fields , @aCTTFields , @cX2Alias )

    End Sequence

    RestArea( aAreaSX3 )
    RestArea( aArea )

Return( NIL )

/*/
    Função:        PanCtb03LinOk
    Autor:         Marinaldo de Jesus
    Data:         25/11/2009
    Descrição:    Validar o TudoOk da GetDados
*/
Static Function PanCtb03LinOk( oBrowse )

    Local lLinOk    := .T.
    Local aCposKey    := { "CT1_FIELD" , "CTT_FIELD" }
    
    Begin Sequence

        IF !( GdDeleted() )
    
            IF !( lLinOk := GdCheckKey( aCposKey , 4 ) )
                Break
            EndIF
        
        EndIF

    End Sequence

Return( lLinOk  )

/*/

    Função:        PanCtb03LinOk
    Autor:         Marinaldo de Jesus
    Data:         25/11/2009
    Descrição:  Validar o TudoOk da GetDados
*/
Static Function PanCtb03TudOk( oBrowse )

    Local lTudOk    := .T.
    
    Local nLoop
    Local nLoops    := Len( aCols )

        /*
            Percorre Todas as Linhas para verificar se Esta Tudo OK
        */
        For nLoop := 1 To nLoops
            n := nLoop
            IF !( lTudoOk := PanCtb03LinOk( oBrowse ) )
                oBrowse:Refresh()
                Break
            EndIF
        Next nLoop 

Return( lTudOk )

/*/
    Função:           OpcShowRe
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:  Dialogo com as Opcoes para o Relacionamento
    Sintaxe        OpcRecRes( nOpc )
    Retorno:    Numero da Opcao do Relatorio: 0 -> Sair
                1 -> Consultar
                2 -> Alterar
*/
Static Function OpcShowRel()

    Local aSvKeys    := GetKeys()
    Local nOpcRel    := 1
    Local bSet15    := { || lOpcOk := .T.    , RestKeys( aSvKeys , .T. ) , oDlg:End() }
    Local bSet24    := { || nOpcRel := 0    , RestKeys( aSvKeys , .T. ) , oDlg:End() }
    Local lOpcOk    := .F.
    
    Local oRadio
    Local oDlg
    Local oGroup
    Local oFont
    
    DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
    DEFINE MSDIALOG oDlg FROM  094,001 TO 250,350 TITLE OemToAnsi( "Relacionamento CT1 vs CTT" ) PIXEL
    
        @ 015,005    GROUP oGroup TO 075,172 LABEL OemToAnsi("Escolha a Opção:") OF oDlg PIXEL
        oGroup:oFont:=oFont
    
        @ 025,010    RADIO oRadio VAR nOpcRel ITEMS     OemToAnsi("&Consultar"),;
                                                    OemToAnsi("&Alterar");
                    SIZE 115,010 OF oDlg PIXEL
        
        oDlg:bSet24 := { || nOpcRel := 0 , oDlg:End() }
        bSvSet24 := SetKey( 24 , oDlg:bSet24 )
    
        oDlg:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
        
    ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )
    RestKeys( aSvKeys , .T. )
    
    IF !( lOpcOk )
        nOpcRel := 0
    EndIF

Return( nOpcRel )

/*

    Função:        MakeRelView
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:    Dialogo com as Opcoes para o Relacionamento
*/
Static Function MakeRelView( oGetDados , aCT1Fields , aCTTFields , cX2Alias )

    Local aSvKeys        := GetKeys()
    Local aAdvSize        := {}
    Local aInfoAdvSize    := {}
    Local aObjCoords    := {}
    Local aObjSize        := {}
    
    Local aColsTmp        := {}
    
    Local asvCTTFields    := aClone( aCTTFields )
    
    Local aCT1Gets        := Array( Len( aCT1Fields ) )
    Local aCT1Says        := Array( Len( aCT1Fields ) )
    Local aCT1Caption    := Array( Len( aCT1Fields ) )
    
    Local aCTTGets        := Array( Len( aCTTFields ) )
    Local aCTTSays        := Array( Len( aCTTFields ) )
    Local aCTTCaption    := Array( Len( aCTTFields ) )
    
    Local bCT1GetSet    := { || __ExecMacro( "{ |u| IF( PCount() == 0 , aCT1Fields["+AllTrim(Str(nItem))+ ","+AllTrim(Str(1))+"],aCT1Fields["+AllTrim(Str(nItem))+","+AllTrim(Str(1))+"] := u ) }" ) }
    Local bCT1GetVar    := { || "aCT1Fields["+AllTrim(Str(nItem))+","+AllTrim(Str(1))+"]" }
    
    Local bCT1CGetSet    := { || __ExecMacro( "{ |u| IF( PCount() == 0 , aCT1Says["+AllTrim(Str(nItem))+"] , aCT1Says["+AllTrim(Str(nItem))+"] := u ) }" ) }
    Local bCT1CGetVar    := { || "aCT1Says["+AllTrim(Str(nItem))+"]" }
    
    Local bCTTGetSet    := { || __ExecMacro( "{ |u| IF( PCount() == 0 , aCTTFields["+AllTrim(Str(nItem))+ ","+AllTrim(Str(1))+"],aCTTFields["+AllTrim(Str(nItem))+","+AllTrim(Str(1))+"] := u ) }" ) }
    Local bCTTGetVar    := { || "aCTTFields["+AllTrim(Str(nItem))+","+AllTrim(Str(1))+"]" }
    
    Local bCTTCGetSet    := { || __ExecMacro( "{ |u| IF( PCount() == 0 , aCTTSays["+AllTrim(Str(nItem))+"] , aCTTSays["+AllTrim(Str(nItem))+"] := u ) }" ) }
    Local bCTTCGetVar    := { || "aCTTSays["+AllTrim(Str(nItem))+"]" }
    
    Local lbSet15        := .F.
    
    Local cCntRel
    Local cAliasCpo
    
    Local nRow
    Local nCol
    Local nItem
    Local nItens
    Local nPosRel
    Local naColsLen
    
    Local oDlg            := NIL
    Local oFont            := NIL
    Local oCT1Group        := NIL
    Local oCT1Scroll    := NIL
    Local oCTTGroup        := NIL
    Local oCTTScroll    := NIL
    
    aAdvSize        := MsAdvSize( .T. , .T. )
    
    aInfoAdvSize    := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
    aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
    aObjSize        := MsObjSize( aInfoAdvSize , aObjCoords )
    
    bSet15 := { ||    (;
                        IF(;
                            CT1vsCttVld( @aCT1Fields , @aCTTFields ),;
                            (;
                                lbSet15 := .T. ,;
                                GetKeys(),;
                                oDlg:End();
                            ),;
                            NIL;
                           );
                      );
                }
    
    bSet24 := { || GetKeys() , oDlg:End() }
    
    DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
    DEFINE MSDIALOG oDlg TITLE OemToAnsi("Relacionar CT1 vs CTT") From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF GetWndDefault() PIXEL
    
        @ aObjSize[1,1] , aObjSize[1,2]+2 GROUP oCT1Group TO aObjSize[1,3],aObjSize[1,4]/2-5 LABEL OemToAnsi("CT1") OF oDlg PIXEL
        oCT1Group:oFont:= oFont
    
        @ aObjSize[1,1]+6,aObjSize[1,2]+5 SCROLLBOX oCT1Scroll VERTICAL SIZE aObjSize[1,3]-20,aObjSize[1,4]/2-13 OF oDlg BORDER
    
        nRow        := ( aObjSize[ 1 , 1 ] ) - 10
        nCol        := aObjSize[ 1 , 2 ]
        
        nItens        := Len( aCT1Gets )
        For nItem := 1 To nItens
    
            aCT1Gets[nItem] := TGet():New(;        
                                                nRow                ,;    //01 -> <nRow>
                                                nCol                ,;    //02 -> <nCol>
                                                Eval( bCT1GetSet )    ,;    //03 -> bSETGET(<uVar>)
                                                 oCT1Scroll            ,;    //04 -> [<oWnd>]
                                                 10                    ,;    //05 -> <nWidth>
                                                 10                    ,;    //06 -> <nHeight>
                                                 "99"                ,;    //07 -> <cPict>
                                                 NIL                    ,;    //08 -> <{ValidFunc}>
                                                 CLR_WHITE            ,;    //09 -> <nClrFore>
                                                 CLR_BLUE            ,;    //10 -> <nClrBack>
                                                 oFont                ,;    //11 -> <oFont>
                                                 .T.                    ,;    //12 -> <.design.>
                                                 NIL                    ,;    //13 -> <oCursor>
                                                 .T.                    ,;    //14 -> <.pixel.>
                                                 NIL                    ,;    //15 -> <cMsg>
                                                 .F.                 ,;    //16 -> <.update.>
                                                 { || .F. }            ,;    //17 -> <{uWhen}>
                                                 .T.                    ,;    //18 -> <.lCenter.>
                                                 .F.                    ,;    //19 -> <.lRight.>
                                                 NIL                    ,;    //20 -> [\{|nKey, nFlags, Self| <uChange>\}]
                                                 .T.                    ,;    //21 -> <.readonly.>
                                                 .F.                    ,;    //22 -> <.pass.>
                                                 NIL                    ,;    //23 -> <cF3>
                                                 Eval( bCT1GetVar )    ,;    //24 -> <(uVar)>
                                                 NIL                    ,;    //25 -> ?
                                                 NIL                    ,;    //26 -> [<.lNoBorder.>]
                                                 NIL                    ,;    //27 -> [<nHelpId>]
                                                 NIL                      ;    //28 -> [<.lHasButton.>]
                                             )
    
            aCT1Says[nItem]        := aCT1Fields[nItem][2] + ' (' + AllTrim(GetSx3Cache(aCT1Fields[nItem][2],'X3_TITULO')) + ')'
    
            aCT1Caption[nItem]    := TGet():New(;        
                                                nRow                ,;    //01 -> <nRow>
                                                nCol + 15            ,;    //02 -> <nCol>
                                                Eval( bCT1CGetSet )    ,;    //03 -> bSETGET(<uVar>)
                                                 oCT1Scroll            ,;    //04 -> [<oWnd>]
                                                 120                    ,;    //05 -> <nWidth>
                                                 10                    ,;    //06 -> <nHeight>
                                                 "@!"                ,;    //07 -> <cPict>
                                                 NIL                    ,;    //08 -> <{ValidFunc}>
                                                 CLR_WHITE            ,;    //09 -> <nClrFore>
                                                 CLR_BLUE            ,;    //10 -> <nClrBack>
                                                 oFont                ,;    //11 -> <oFont>
                                                 .T.                    ,;    //12 -> <.design.>
                                                 NIL                    ,;    //13 -> <oCursor>
                                                 .T.                    ,;    //14 -> <.pixel.>
                                                 NIL                    ,;    //15 -> <cMsg>
                                                 .F.                 ,;    //16 -> <.update.>
                                                 { || .F. }            ,;    //17 -> <{uWhen}>
                                                 .T.                    ,;    //18 -> <.lCenter.>
                                                 .F.                    ,;    //19 -> <.lRight.>
                                                 NIL                    ,;    //20 -> [\{|nKey, nFlags, Self| <uChange>\}]
                                                 .T.                    ,;    //21 -> <.readonly.>
                                                 .F.                    ,;    //22 -> <.pass.>
                                                 NIL                    ,;    //23 -> <cF3>
                                                 Eval( bCT1CGetVar )    ,;    //24 -> <(uVar)>
                                                 NIL                    ,;    //25 -> ?
                                                 NIL                    ,;    //26 -> [<.lNoBorder.>]
                                                 NIL                    ,;    //27 -> [<nHelpId>]
                                                 NIL                      ;    //28 -> [<.lHasButton.>]
                                             )
            nRow    += 013
    
        Next nItem
                                                                 
    
        @ aObjSize[1,1] , aObjSize[1,4]/2+2 GROUP oCTTGroup TO aObjSize[1,3],aObjSize[1,4] LABEL OemToAnsi("CTT") OF oDlg PIXEL
        oCTTGroup:oFont:= oFont
    
        @ aObjSize[1,1]+6,aObjSize[1,4]/2+5 SCROLLBOX oCTTScroll VERTICAL SIZE aObjSize[1,3]-20,aObjSize[1,4]/2-8 OF oDlg BORDER
    
        nRow        := ( aObjSize[ 1 , 1 ] ) - 10
    
        nItens        := Len( aCTTGets )
        For nItem := 1 To nItens
    
            aCTTGets[nItem] := TGet():New(;        
                                                nRow                ,;    //01 -> <nRow>
                                                nCol                ,;    //02 -> <nCol>
                                                Eval( bCTTGetSet )    ,;    //03 -> bSETGET(<uVar>)
                                                 oCTTScroll            ,;    //04 -> [<oWnd>]
                                                 10                    ,;    //05 -> <nWidth>
                                                 10                    ,;    //06 -> <nHeight>
                                                 "99"                ,;    //07 -> <cPict>
                                                 NIL                    ,;    //08 -> <{ValidFunc}>
                                                 NIL                    ,;    //09 -> <nClrFore>
                                                 NIL                    ,;    //10 -> <nClrBack>
                                                 oFont                ,;    //11 -> <oFont>
                                                 .T.                    ,;    //12 -> <.design.>
                                                 NIL                    ,;    //13 -> <oCursor>
                                                 .T.                    ,;    //14 -> <.pixel.>
                                                 NIL                    ,;    //15 -> <cMsg>
                                                 .F.                 ,;    //16 -> <.update.>
                                                 { || .T. }            ,;    //17 -> <{uWhen}>
                                                 .T.                    ,;    //18 -> <.lCenter.>
                                                 .F.                    ,;    //19 -> <.lRight.>
                                                 NIL                    ,;    //20 -> [\{|nKey, nFlags, Self| <uChange>\}]
                                                 .F.                    ,;    //21 -> <.readonly.>
                                                 .F.                    ,;    //22 -> <.pass.>
                                                 NIL                    ,;    //23 -> <cF3>
                                                 Eval( bCTTGetVar )    ,;    //24 -> <(uVar)>
                                                 NIL                    ,;    //25 -> ?
                                                 NIL                    ,;    //26 -> [<.lNoBorder.>]
                                                 NIL                    ,;    //27 -> [<nHelpId>]
                                                 NIL                      ;    //28 -> [<.lHasButton.>]
                                             )
    
            aCTTSays[nItem]        := aCTTFields[nItem][2] + ' (' + AllTrim(GetSx3Cache(aCTTFields[nItem][2],'X3_TITULO')) + ')'
    
            aCTTCaption[nItem]    := TGet():New(;        
                                                nRow                ,;    //01 -> <nRow>
                                                nCol + 15            ,;    //02 -> <nCol>
                                                Eval( bCTTCGetSet )    ,;    //03 -> bSETGET(<uVar>)
                                                 oCTTScroll            ,;    //04 -> [<oWnd>]
                                                 120                    ,;    //05 -> <nWidth>
                                                 10                    ,;    //06 -> <nHeight>
                                                 "@!"                ,;    //07 -> <cPict>
                                                 NIL                    ,;    //08 -> <{ValidFunc}>
                                                 CLR_WHITE            ,;    //09 -> <nClrFore>
                                                 CLR_BLUE            ,;    //10 -> <nClrBack>
                                                 oFont                ,;    //11 -> <oFont>
                                                 .T.                    ,;    //12 -> <.design.>
                                                 NIL                    ,;    //13 -> <oCursor>
                                                 .T.                    ,;    //14 -> <.pixel.>
                                                 NIL                    ,;    //15 -> <cMsg>
                                                 .F.                 ,;    //16 -> <.update.>
                                                 { || .F. }            ,;    //17 -> <{uWhen}>
                                                 .T.                    ,;    //18 -> <.lCenter.>
                                                 .F.                    ,;    //19 -> <.lRight.>
                                                 NIL                    ,;    //20 -> [\{|nKey, nFlags, Self| <uChange>\}]
                                                 .T.                    ,;    //21 -> <.readonly.>
                                                 .F.                    ,;    //22 -> <.pass.>
                                                 NIL                    ,;    //23 -> <cF3>
                                                 Eval( bCTTCGetVar )    ,;    //24 -> <(uVar)>
                                                 NIL                    ,;    //25 -> ?
                                                 NIL                    ,;    //26 -> [<.lNoBorder.>]
                                                 NIL                    ,;    //27 -> [<nHelpId>]
                                                 NIL                      ;    //28 -> [<.lHasButton.>]
                                             )
            nRow    += 015
    
        Next nItem

        IF (;
                ( Len( aCTTGets ) >= 1 );
                .and.;
                ( Valtype( aCTTGets[1] ) == "O" );
            )    
            aCTTGets[1]:SetFocus()
        EndIF
    
    ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )
    
    IF (;
            ( lbSet15 );
            .and.;
            !( ArrayCompare( aCTTFields , asvCTTFields ) );
        )

        aColsTmp := GdRmkaCols( oGetDados:aHeader , .F. , .T. , .F. )
        
        naColsLen := Len( oGetDados:aCols )
        nItens := Len( aCTTFields )
        For nItem := 1 To nItens
            
            cCntRel := Upper( AllTrim( aCTTFields[nItem][1] ) )
            
            IF Empty( cCntRel )
                Loop
            EndIF
            
            nPosRel := aScan( aCTTFields , { |x| Upper( AllTrim( x[1] ) ) == cCntRel } )
            
            IF (;
                    ( naColsLen == 1 );
                    .and.;
                    Empty( GdFieldGet( "CT1_FIELD" , naColsLen , .F. , oGetDados:aHeader , oGetDados:aCols ) );
                )

                GdFieldPut( "CT1_FIELD"  , aCT1Fields[nPosRel][2]    , 1 , oGetDados:aHeader , oGetDados:aCols )
                GdFieldPut( "CTT_FIELD"  , aCTTFields[nItem][2]     , 1 , oGetDados:aHeader , oGetDados:aCols )

                GdFieldPut( "CT1_FIELDD" , GetSx3Cache(aCT1Fields[nPosRel][2],'X3_TITULO') , 1 , oGetDados:aHeader , oGetDados:aCols )
                GdFieldPut( "CTT_FIELDD" , GetSx3Cache(aCTTFields[nItem][2],'X3_TITULO')     , 1 , oGetDados:aHeader , oGetDados:aCols )

                naColsLen := 0

            Else

                GdFieldPut( "CT1_FIELD"  , aCT1Fields[nPosRel][2]    , 1 , oGetDados:aHeader , aColsTmp )
                GdFieldPut( "CTT_FIELD"  , aCTTFields[nItem][2]     , 1 , oGetDados:aHeader , aColsTmp )

                GdFieldPut( "CT1_FIELDD" , GetSx3Cache(aCT1Fields[nPosRel][2],'X3_TITULO') , 1 , oGetDados:aHeader , aColsTmp )
                GdFieldPut( "CTT_FIELDD" , GetSx3Cache(aCTTFields[nItem][2],'X3_TITULO')     , 1 , oGetDados:aHeader , aColsTmp )

                aAdd( oGetDados:aCols , aClone( aColsTmp[1] ) )
                
                naColsLen := Len( oGetDados:aCols )
                
            EndIF
            
            cAliasCpo := AliasCpo( aCT1Fields[nPosRel][2] )
            IF (cX2Alias)->( dbSeek( cAliasCpo , .F. ) )
                IF (cX2Alias)->( RecLock( cX2Alias , .F. ) )
                    (cX2Alias)->X2_REL := "S"
                    (cX2Alias)->( MsUnLock() )
                EndIF
            EndIF

        Next nItem         

    EndIF        
    
    RestKeys( aSvKeys , .T. )

Return( NIL )

/*/
    Função:        CT1vsCttVld
    Autor:        Marinaldo de Jesus
    Data:         26/11/2009
    Descrição:    Validar o Relacionamento
*/
Static Function CT1vsCttVld( aCT1Fields , aCTTFields )

    Local cCntRel
    
    Local nLoop
    Local nLoops
    
    Local nPosRel
    
    Local lValid        := .T.
    
    Local oException
    
    TRYEXCEPTION
        
        nLoops := Len( aCTTFields )
        For nLoop := 1 To nLoops
        
            cCntRel := AllTrim( aCTTFields[nLoop][1] )
            IF Empty( cCntRel  )
                Loop
            EndIF
            
            nPosRel := aScan( aCT1Fields , { |x| AllTrim( x[1] ) == cCntRel } )
            IF ( nPosRel == 0 )
                UserException( "Existe Relacionamento inválido para o campo: " + CRLF + aCTTFields[nLoop][2] )
            EndIF

        Next nLoop
    
    CATCHEXCEPTION USING oException
    
        lValid    := .F.
        Help( "" , 1 , OemToAnsi( "ATENÇÃO!!!" ) , NIL , OemToAnsi( "Problema no Relacionamento CT1 vs CTT:" + CRLF + CRLF + oException:Description ) , 1 , 0 )        
    
    ENDEXCEPTION

Return( lValid )
