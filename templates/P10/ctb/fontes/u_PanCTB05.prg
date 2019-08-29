#INCLUDE "PAN-AMERICANA.CH"
#INCLUDE "U_PanCTB05.CH"

/*/
    1) Registro CabeГalho

    PosiГЦo 08 - 10    :    NЗmero sequencial do arquivo
    PosiГЦo 10 - 17    :    Data para o LanГamento ContАbil
    PosiГЦo 18 - 19    :    Constante "FP" para indicar que И um arquivo da Folha de Pagamento
    PosiГЦo 25 - 26    :    Filial do LanГamento
 
    2) Registro Detalhe (corresponde a cada lanГamento contАbil CT2)

    PosiГЦo 08 - 16    :    NЗmero da Conta ContАbil
    PosiГЦo 19 - 22    :    Centro de Custo
    PosiГЦo 23 - 36    :    Valor do LanГamento
    PosiГЦo 37 - 37    :    Tipo (DИbito ou CrИdito)
    PosiГЦo 38 - 41    :    HistСrico PadrЦo (cСdigo do histСrico no sistema Acol)
    PosiГЦo 42 - 72    :    HistСrico Complementar

    3) Registro Total (somente para efeito de validaГЦo)

    PosiГЦo 06 - 20    : Total de lanГamentos a dИbito
    PosiГЦo 21 - 35    : Total de lanГamentos a crИdito
/*/

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁU_PanCTB05ЁAutorЁMarinaldo de Jesus       Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁContabilizacao de Arquivo CSV/RM                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           Ё
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                Ё
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                                   Ё
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддды/*/
User Function PanCTB05()

    Local aArea            := GetArea()
    Local aAreaCT1        := CT1->( GetArea() )
    Local aAreaCT2        := CT2->( GetArea() )
    Local aAreaCT8        := CT8->( GetArea() )
    Local bProcess        := { |oProcess| PanCTB05( oProcess , @lError ) }

    Local cPerg            := "U_PANCTB05"
    Local cDescri        := OemToAnsi( STR0001 )    //"Este Programa IrА efetuar a ContabilizaГЦo da Folha de Pagamento RM conforme ParБmetros Selecionados"
    Local cProcess        := "RMTOCTB"
    
    Local dSvDataBase    := dDataBase

    Local lError        := .F.
    
    Local oProcess

    Private aRotina     := {;
                                { "" , "" , 0 , 1 },;
                                { "" , "" , 0 , 2 },;
                                { "" , "" , 0 , 3 },;
                                { "" , "" , 0 , 4 };
                               }

    Private Inclui         := .T.                            

    Private cCadastro    := OemtoAnsi( STR0002 )  //"Contabiliza┤└o de Arquivos Folha de Pagamento RM"

    oProcess            := tNewProcess():New( cProcess , cCadastro , bProcess , cDescri , cPerg , NIL , NIL , NIL , NIL , .T. , .T. )

    IF ( lError )
        //"Ocorreram Erros Durante o Processo de ContabilizaГЦo. Retorne a Rotina para Visualizar o LOG de Processo"###
        MsgAlert( STR0026 , "AVISO!!!" )
    EndIF

    dDataBase := dSvDataBase

    RestArea( aAreaCT1 )
    RestArea( aAreaCT2 )
    RestArea( aAreaCT8 )
    RestArea( aArea )

Return( NIL )

/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁPanCTB05      ЁAutor ЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar a Contabilizacao da Folha de Pagamento RM           Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_PanCTB05()                                                 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>                                     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                          Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                               Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_PanCTB05()                                                 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function PanCTB05( oProcess , lError )

    Local oException

    oProcess:SaveLog( OemToAnsi( STR0003 ) )    //"Inicio da ContabilizaГЦo"

    TRYEXCEPTION 

        IF !PgsExclusive()
           UserException( GetHelp( "PGSEXC" ) )
        EndIF

        IF ( FindFunction("CTBSERIALI") )
            While !( CTBSerialI("CTBPROC","ON") )
            End While
        EndIF

        RMToCTB( oProcess , @lError )

        IF ( FindFunction("CTBSERIALF") )
            CTBSerialF("CTBPROC","ON")
        EndIF

    CATCHEXCEPTION USING oException

        lError := .T.
        oProcess:SaveLog( "ERRO: " + OemToAnsi( oException:Description )  )

    ENDEXCEPTION

    PgsShared()

    oProcess:SaveLog( OemToAnsi( STR0004  ) )    //"Final da ContabilizaГЦo"

Return( NIL  )

/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁRMToCTB          ЁAutor ЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar a Contabilizacao da Folha de Pagamento RM           Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_PanCTB05()                                                 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>                                     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                          Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                               Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_PanCTB05()                                                 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function RMToCTB( oProcess , lError )

    Local aDet            := {}
    Local aFile            := {}
    Local aDetCab        := {}
    Local aDetRoda        := {}
    Local aRMVars        := {}

    Local cLine            := ""
    Local cFile            := MV_PAR03
    Local cTpReg
    Local cLote            := GpeLotCont( "GPE" , cFilAnt )
    Local cPadrao        := MV_PAR05
    Local cX2CT2Modo    := PosAlias( "SX2" , "CT2" , NIL , "X2_MODO" , 1 , .F. )

    Local cCC
    Local cIsFP
    Local cTPDC
    Local cHist
    Local cConta
    Local cValor
    Local cHistPD
    Local cCT1Fil        := xFilial( "CT1" )
    Local cCT8Fil        := xFilial( "CT8" )
    Local cCTTFil        := xFilial( "CTT" )
    Local cOrigem
    Local cHistCom
    Local cFilContab
    Local cDiaContab
    Local cMesContab
    Local cAnoContab

    Local dSvDtBase        := dDataBase

    Local lHead            := .F.
    Local lPadrao        := VerPadrao( cPadrao )
    Local lAglut        := ( MV_PAR02 == 1 )
    Local lDigita        := ( MV_PAR01 == 1 )
    Local lQuebra        := ( MV_PAR04 == 1 )

    Local nVar
    Local nVars
    Local nLoop
    Local nLoops
    Local nTotal
    Local nValor
    Local nHdlPrv
    Local nCT1Order        := RetOrder( "CT1" , "CT1_FILIAL+CT1_CONTA" )
    Local nCT8Order        := RetOrder( "CT8" , "CT8_FILIAL+CT8_HIST" )
    Local nCTTOrder        := RetOrder( "CTT" , "CTT_FILIAL+CTT_CUSTO" )

    Local oException

    TRYEXCEPTION

        IF Empty( cFile )
            UserException( GetHelp("NOFLEIMPOR") + " " + OemToAnsi( STR0005 + cFile + " " + STR0006 )  )    //"Arquivo : "###"NЦo Encontrado"
        EndIF
        oProcess:SaveLog( STR0028 + cLote ) //"Contabilizando o Arquivo: "

        IF Empty( cLote )
            UserException( GetHelp("NOCT210LOT") + " " +  OemToAnsi( STR0007 + cLote + STR0008 )  ) //"Lote ContАbil ("###
        EndIF
        oProcess:SaveLog( STR0028 + cLote ) //"Contabilizando no Lote: "

        IF !( lPadrao )
            UserException( GetHelp("NOLANCPADRAO") + " " +  OemToAnsi( STR0009 + cPadrao + STR0010 )  )  //"LanГamento PadrЦo ("###") InvАlido"
        EndIF

        aFile    := u_InPanVld("FileToArr", { cFile } )
        IF ( Empty( aFile ) )
            UserException( OemToAnsi( STR0011 + cFile + STR0012 )  ) //"O arquivo Informado ("###") nЦo possЗi conteЗdo para ContabilizaГЦo"
        EndIF

        nLoops := Len( aFile )

        oProcess:SetRegua1( nLoops )

        For nLoop := 1 To nLoops

            oProcess:IncRegua1( STR0014 ) //"Obtendo InformaГУes para a ContabilizaГЦo. Aguarde..."
            IF ( oProcess:lEnd )
                UserException( cCancel )
            EndIF

            cLine  := aFile[ nLoop ]
            cTpReg := SubStr( cLine , 1 , 1 ) 
            IF ( cTpReg == "1"  )
                aAdd( aDetCab , cLine )
            ElseIF ( cTpReg == "2"  )
                aAdd( aDet , cLine )
            ElseIF ( cTpReg == "3"  )
                aAdd( aDetRoda , cLine )
            EndIF

        Next nLoop

        aAdd( aRMVars , { "RM_FILIAL"    , "CT2_FILIAL"    , .F. } )
        aAdd( aRMVars , { "RM_TPDC"     , "CT5_DC"        , .T. } )
        aAdd( aRMVars , { "RM_CREDITO"     , "CT1_CONTA"    , .T. } )
        aAdd( aRMVars , { "RM_DEBITO"     , "CT1_CONTA"    , .T. } )
        aAdd( aRMVars , { "RM_VLR01"     , "CT2_VALOR"    , .T. } )
        aAdd( aRMVars , { "RM_HP"         , "CT2_HP"        , .T. } )
        aAdd( aRMVars , { "RM_HIST"         , "CT2_HIST"    , .T. } )
        aAdd( aRMVars , { "RM_HIST"         , "CT2_HIST"    , .T. } )
        aAdd( aRMVars , { "RM_CCC"         , "CTT_CUSTO"    , .T. } )
        aAdd( aRMVars , { "RM_CCD"         , "CTT_CUSTO"    , .T. } )
        aAdd( aRMVars , { "RM_ORIGEM"     , "CT2_ORIGEM"    , .F. } )

        nVars := Len( aRMVars )
        For nVar := 1 To nVars
            SetMemVar( aRMVars[nVar][1]  , GetValType( GetSx3Cache( aRMVars[nVar][2]    , "X3_TIPO" ) , GetSx3Cache( aRMVars[nVar][2] , "X3_TAMANHO" ) ) , .T. )
        Next nVar

        cIsFP        := SubStr( aDetCab[ 1 ] , 18 , 2 )
        IF !( cIsFP == "FP" )
            UserException( STR0018 ) //"O arquivo Informado nЦo И um Arquivo provenitente da Folha de Pagamento"
        EndIF

        cFilContab    := SubStr( aDetCab[ 1 ] , 25 , 2 )
        IF (;
                ( cX2CT2Modo == "E" );
                .and.;
                !( cFilContab == cFilAnt );
            )
            //"Filial do Arquivo para ContabilizaГЦo Diferente da Filial Corrente"###"Filial do Arquivo : '"
            UserException( STR0015 + CRLF + CRLF + STR0015 + cFilContab + "'" ) 
        EndIF        

        SetMemVar( "RM_FILIAL"     , cFilContab )

        cDiaContab    := SubStr( aDetCab[ 1 ] , 10 , 2 )
        cMesContab  := SubStr( aDetCab[ 1 ] , 12 , 2 )
        cAnoContab  := SubStr( aDetCab[ 1 ] , 14 , 4 )

        dDataBase    := Ctod(  cDiaContab + "/" + cMesContab + "/" + cAnoContab , "DDMMYYYY" )  
        IF Empty( dDataBase )
            UserException( STR0016 + " " + Dtoc( dDataBase ) ) //"Data Para ContabilizaГЦo do Arquivo InvАlida!"  
        EndIF

        oProcess:SetRegua1( nLoops )

        nLoops    := Len( aDet )
        For nLoop := 1 To nLoops

            oProcess:IncRegua1( STR0019 )    //"Validando as InformaГУes do Arquivo. Aguarde..."
            IF ( oProcess:lEnd )
                UserException( cCancel )
            EndIF

            cLine    := aDet[ nLoop ]
            cHistPD := SubStr( cLine , 38 , 4 )
            IF ( "0" $ SubStr( cHistPD , 1 , 1 ) )
                cHistPD := SubStr( cHistPD , 2 )
            EndIF
            IF !( PosAlias( "CT8" , cHistPD , cCT8Fil , NIL , nCT8Order , .F. ) )
                //UserException( STR0020 + ": " + cHistPD  ) //"CСdigo de HistСrico PadrЦo NЦo Localizado na Tabela CT8" 
            EndIF
            cConta    := SubStr( cLine ,  8 , 9 )
            IF !( PosAlias( "CT1" , cConta , cCT1Fil , NIL , nCT1Order , .F. ) )
                UserException( STR0021 ) //"CСdigo da Conta ContАbil NЦo Localizado na Tabela CT1" 
            EndIF
            cCC        := SubStr( cLine , 19 , 4 )
            IF ( "0" $ SubStr( cCC , 1 , 1 ) )
                cCC := SubStr( cCC , 2 )
            EndIF
            IF (;
                    ( Empty( StrTran( cCC , "0", "" ) ) );
                     .or.;
                     !( PosAlias( "CTT" , cCC , cCTTFil , NIL , nCTTOrder , .F. ) );
                )
                IF ( PosAlias( "CT1" , cConta , cCT1Fil , "CT1_CCOBRG" , nCT1Order , .F. ) == "1" )
                    UserException( STR0040 + cConta + STR0041 ) //"Para essa conta ("###")o CСdigo de Centro de Custo И de Preenchimento ObrigatСrio" 
                ElseIF !Empty( StrTran( cCC , "0", "" ) )
                    UserException( STR0021 + " : " + cCC ) //"CСdigo de Centro de Custo NЦo Localizado na Tabela CTT"                     
                EndIF
            Else
                IF ( PosAlias( "CT1" , cConta , cCT1Fil , "CT1_ACCUST" , nCT1Order , .F. ) == "2" )
                    UserException( STR0024 + ": " + cConta ) //"Esta conta nЦo permite a informaГЦo de Centro de Custo" 
                EndIF    
            EndIF
        Next nLoop

        nTotal    := 0

        oProcess:SetRegua1( nLoops )

        cOrigem := " "
        cOrigem += "Usuario: "
        cOrigem += AllTrim( UsrRetName( __cUserId ) )
        cOrigem += " "
        cOrigem += "Data: " 
        cOrigem += DtoC(MsDate())
        cOrigem += " "
        cOrigem += "Hora: "
        cOrigem += Time()

        SetMemVar( "RM_ORIGEM" , cOrigem )

        For nLoop := 1 To nLoops

            oProcess:IncRegua1( STR0017 )    //"Efetuando a ContabilizaГЦo. Aguarde..."
            IF ( oProcess:lEnd )
                UserException( cCancel )
            EndIF

            cLine        := aDet[ nLoop ]

            cTPDC        := SubStr( cLine , 37 , 1 )
            SetMemVar( "RM_TPDC"     , cTPDC )

            cConta        := SubStr( cLine ,  8 , 9 )
            cCC            := SubStr( cLine , 19 , 4 )
            IF ( "0" $ SubStr( cCC , 1 , 1 ) )
                cCC := SubStr( cCC , 2 )
            EndIF
            IF Empty( StrTran( cCC , "0", "" ) )
                cCC := GetValType( GetSx3Cache( "CTT_CUSTO"    , "X3_TIPO" ) , GetSx3Cache( "CTT_CUSTO" , "X3_TAMANHO" ) )
            EndIF
            
            cValor        := SubStr( cLine , 23 , 14 )
            nValor        := ( Val( cValor ) / 100 )
            cHistPD     := SubStr( cLine , 38 , 4 )
            IF ( "0" $ SubStr( cHistPD , 1 , 1 ) )
                cHistPD := SubStr( cHistPD , 2 )
            EndIF
            cHistCom    := AllTrim( SubStr( cLine , 42 , 30 ) )
            IF !( PosAlias( "CT8" , cHistPD , cCT8Fil , NIL , nCT8Order , .F. ) )
                cHist    := cHistCom
            Else
                cHist    := AllTrim( PosAlias( "CT8" , cHistPD , cCT8Fil , "CT8_DESC" , nCT8Order , .F. ) ) + " :: " + cHistCom
            EndIF

            IF ( cTPDC == "D" )
                SetMemVar( "RM_DEBITO"     , cConta     )
                SetMemVar( "RM_CCD"        , cCC         )
                SetMemVar( "RM_VLR01"      , nValor     )
            ElseIF ( cTPDC == "C" )
                SetMemVar( "RM_CREDITO" , cConta     )        
                SetMemVar( "RM_CCC"        , cCC         )
                SetMemVar( "RM_VLR01"      , nValor     )
            Else
                SetMemVar( "RM_DEBITO"     , cConta     )                
                SetMemVar( "RM_CREDITO" , cConta     )        
                SetMemVar( "RM_CCC"        , cCC         )
                SetMemVar( "RM_CCD"        , cCC         )
                SetMemVar( "RM_VLR01"      , nValor    )
            EndIF

            SetMemVar( "RM_HP"        , cHistPD     )
            SetMemVar( "RM_HIST"    , cHist     )
            SetMemVar( "RM_HISTAGL" , cHist     )

            IF !( lHead )
                lHead    := .T.
                nHdlPrv    := HeadProva( cLote , FunName() , SubStr( cUsuario , 7 , 6 ) , @cFile )
            EndIF
            nTotal += DetProva( nHdlPrv , cPadrao , FunName() , cLote )
            IF ( lQuebra )    //Cada linha contabilizada sera um documento
                RodaProva( @nHdlPrv , @nTotal )
                cA100Incl( @cFile , @nHdlPrv , 3 , @cLote , @lDigita , @lAglut )
                lHead    := .F.
            EndIF

            For nVar := 1 To nVars
                IF ( aRMVars[nVar][3] )
                    SetMemVar( aRMVars[nVar][1] , GetValType( GetSx3Cache( aRMVars[nVar][2] , "X3_TIPO" ) , GetSx3Cache( aRMVars[nVar][2] , "X3_TAMANHO" ) ) )
                EndIF    
            Next nVar

        Next nLoop

        IF ( lHead )
            RodaProva( @nHdlPrv , @nTotal )
            cA100Incl( @cFile , @nHdlPrv , 3 , @cLote , @lDigita , @lAglut )
        EndIF
        
        oProcess:SaveLog( STR0029 +  cFile )    //"Arquivo Contabilizado: "

        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Move o arquivo contabilizado para a pasta de "backup"           Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        BackupFile( oProcess , cFile , FilePath( cFile ) , FileNoPath( cFile ) )

    CATCHEXCEPTION USING oException

        lError := .T.
        oProcess:SaveLog( "ERRO: " + OemToAnsi( oException:Description )  )

    ENDEXCEPTION

    dDataBase := dSvDtBase

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁBackupFile      ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁMover o Arquivo contabilizado para a pasta \back            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_PanCTB05                                                     Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function BackupFile( oProcess , cPathFile , cPath , cFile )

    Local cNewPath
    Local cNewPathFile
    
    Begin Sequence

        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Define o "Path" para "Backup" das imagens                       Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        cNewPath := ( cPath + "back_ctb_rm\" )
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Verifica se o "Path" para "Backup" existe e, se nao  existir,Ё
        Ё cria-o                                                       Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF !( MyMakeDir( cNewPath ) )
            oProcess:SaveLog( OemToAnsi( STR0022 + " " + cNewPath )  ) //"NЦo Foi PossМvel Criar o DiretСrio para Backup do Arquivo Processado"
            Break
        EndIF
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Define o novo "Path" e nome do arquivo.                        Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        cNewPathFile := ( cNewPath + cFile )
    
        /*/
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Move o arquivo para o "Path" de "Backup"                       Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
        IF MoveFile( cPathFile , cNewPathFile )
            oProcess:SaveLog( OemToAnsi( STR0005 + cPathFile + STR0013 + cNewPathFile  )  ) //"Arquivo: "###"Contabilizado e Salvo como: "
        Else
            oProcess:SaveLog( STR0023 + ": " + cNewPathFile ) //"NЦo foi possМvel Salvar o arquivo Contabilizado"
        EndIF
    
    End Sequence

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁMyMakeDir     ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁCria um Diretorio                                           Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function MyMakeDir( cMakeDir , nTimes , nSleep )

    Local lMakeOk
    Local nMakeOk
    
    IF !( lMakeOk := lIsDir( cMakeDir ) )
        MakeDir( cMakeDir )
        nMakeOk            := 0
        DEFAULT nTimes    := 10
        DEFAULT nSleep    := 1000
        While (;
                !( lMakeOk := lIsDir( cMakeDir ) );
                .and.;
                ( ++nMakeOk <= nTimes );
           )
            Sleep( nSleep )
            MakeDir( cMakeDir )
        End While
    EndIF

Return( lMakeOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁMoveFile      ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁMover um arquivo de Diretorio                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function MoveFile( cOldPathFile , cNewPathFile , lErase , nFullPath , lEqualFile )

    Local lMoveFile
    
    Begin Sequence
    
        DEFAULT lEqualFile := .F.
        IF !(;
                lMoveFile := (;
                                ( __CopyFile( cOldPathFile , cNewPathFile , nFullPath ) );
                                .and.;
                                File( cNewPathFile , nFullPath );
                                .and.;
                                IF( lEqualFile , EqualFile( cOldPathFile , cNewPathFile , nFullPath ) , .T. );
                             );
            )
            Break
        EndIF
    
        DEFAULT lErase := .T.
        IF ( lErase )
            FileErase( cOldPathFile )
        EndIF    
    
    End Sequence

Return( lMoveFile )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁFilePath      ЁAutorЁMarinaldo de Jesus   Ё Data Ё10/06/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁObtem o Path do arquivo                                      Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function FilePath( cFile )

    Local cFilePath
    Local nPos
    
    IF ( ( nPos := rAt( "\" , cFile ) ) != 0 )
        cFilePath := SubStr( cFile , 1 , nPos )
    Else
        cFilePath := ""
    EndIF

Return( cFilePath )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁFileNoPath    ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁExtrai o arquivo                                             Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function FileNoPath( cPathFile )
Return( RetFileName( @cPathFile ) )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁRetFileName   ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna o Nome do Arquivo sem a Extensao e sem o Path        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function RetFileName( cFile )
    Local n  := rAt( "." , cFile )
    Local nI := rAt("\",cFile)
Return( SubStr( cFile , IF( nI > 0 , nI + 1 , 1 ) ,IF( n > 0 , n-1 , Len( cFile ) - nI ) ) )

/*/
зддддддддддбдддддддддддддддддбдддддбддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁFileErase         ЁAutorЁMarinaldo de JesusЁ Data Ё01/12/2009Ё
цддддддддддедддддддддддддддддадддддаддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁExclui Arquivo e Retorna nErr por Referencia                Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                     Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function FileErase( cFile , nErr )

    Local lEraseOk := .F.
    
    Local nEraseOk
    
    IF ( lEraseOk    := File( cFile ) )
        fErase( cFile )
        nEraseOk := 0
        While (;
                    ( ( nErr := fError() ) <> 0 );
                    .and.;
                    ( ++nEraseOk <= 50 );
                )
            Sleep( 1000 )
            IF ( fErase( cFile ) <> -1 )
                Exit
            EndIF
        End While
        lEraseOk    := !( File( cFile ) )
    EndIF

Return( lEraseOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁEqualFile     ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁVerifica se Dois Arquivos sao Iguais                        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function EqualFile( cFile1 , cFile2 , nFullPath )

    Local lIsEqualFile    := .F.

    Local nfhFile1    := fOpen( cFile1 , NIL , nFullPath )
    Local nfhFile2    := fOpen( cFile2 , NIL , nFullPath )

    Begin Sequence

        IF (;
                ( nfhFile1 <= 0 );
                .or.;
                ( nfhFile2 <= 0 );
            )
            Break
        EndIF

        lIsEqualFile := ArrayCompare( GetAllTxtFile( nfhFile1 ) , GetAllTxtFile( nfhFile2 ) )

        fClose( nfhFile1 )
        fClose( nfhFile2 )

    End Sequence

Return( lIsEqualFile )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁGpeLotCont    ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna o Lote ContАbil para o GPE                            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function GpeLotCont( cChave , cFil )
    
    Local aArea        := GetArea()
    Local aAreaSX5    := SX5->( GetArea() )     
    Local cLote
    
    Local nSX5Order := RetOrder( "SX5" , "X5_FILIAL+X5_TABELA+X5_CHAVE" )
    
    DEFAULT cChave    := "GPE"
    DEFAULT cFil    := cFilAnt
    
    IF CtbInUse()
        cLote := fDesc( "SX5" , "09" + AllTrim( cChave ) , "X5Descri()" , 6 , cFil , nSX5Order )
    Else
        cLote := fDesc( "SX5" , "09" + AllTrim( cChave ) , "X5Descri()" , 4 , cFil , nSX5Order )
    EndIF
    
    RestArea( aAreaSX5 )
    RestArea( aArea )

Return( cLote )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁGetHelp       ЁAutorЁMarinaldo de Jesus   Ё Data Ё01/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna a DescriГЦo do Help                                   Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function GetHelp( cHelp )
Return( StrTran( Ap5GetHelp(cHelp) , CRLF , " " ) )

/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁU_InRm2Ctb    ЁAutor ЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar Funcoes Dentro de U_PANCTB05                         Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( cExecIn , aFormParam )                              Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>                                     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                          Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                               Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                      Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function InRm2Ctb( cExecIn , aFormParam )
         
    Local uRet
    
    DEFAULT cExecIn        := ""
    DEFAULT aFormParam    := {}
    
    IF !Empty( cExecIn )
        cExecIn    := BldcExecInFun( cExecIn , aFormParam )
        uRet    := &( cExecIn )
    EndIF

Return( uRet )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Vlr01Cre   ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna Valor de Credito para o Lancamento Padrao            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Vlr01Cre" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Vlr01Cre()
    
    Local nValor    := 0

    IF (;
            ( IsMemVar("RM_VLR01") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "C" ) ;
        )    
        nValor := GetMemVar("RM_VLR01")
    EndIF    

Return( nValor  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Vlr01Deb   ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna Valor de Debito para o Lancamento Padrao            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Vlr01Deb" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Vlr01Deb()
    
    Local nValor    := 0

    IF (;
            ( IsMemVar("RM_VLR01") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "D" ) ;
        )    
        nValor := GetMemVar("RM_VLR01")
    EndIF    

Return( nValor  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Credito    ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna a Conta de Credito para o Lancamento Padrao            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Credito" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Credito()

    Local cCta :=     ""
    
    IF (;
            ( IsMemVar("RM_CREDITO") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "C" ) ;
        )    
        cCta := GetMemVar("RM_CREDITO")
    EndIF    

Return( cCta  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Debito     ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna a Conta de Credito para o Lancamento Padrao            Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Debito" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Debito()

    Local cCta :=     ""
    
    IF (;
            ( IsMemVar("RM_DEBITO") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "D" ) ;
        )    
        cCta := GetMemVar("RM_DEBITO")
    EndIF    

Return( cCta  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5CCC        ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna o Centro de Custo Credito para o Lancamento Padrao    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5CCC" )                                         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5CCC()
    
    Local cCC := ""

    IF (;
            ( IsMemVar("RM_CCC") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "C" ) ;
        )    
        cCC := GetMemVar("RM_CCC")
    EndIF    

Return( cCc  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5CCD        ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna o Centro de Custo Debito para o Lancamento Padrao    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5CCD" )                                         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5CCD()

    Local cCC := ""

    IF (;
            ( IsMemVar("RM_CCD") ) ;
            .and.;
            ( IsMemVar("RM_TPDC") ) ;
            .and.;
            ( GetMemVar("RM_TPDC") == "D" ) ;
        )    
        cCC := GetMemVar("RM_CCD")
    EndIF    

Return( cCc  )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Hist       ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna Historico para o Lancamento Padrao                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Hist" )                                         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Hist()
    Local cHist := IF(IsMemVar("RM_HIST"),GetMemVar("RM_HIST"),"")
Return( cHist )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCTGHistAgl    ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna Historico Aglutinado para o Lancamento Padrao        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CTGHistAgl" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CTGHistAgl()
    Local cHAglu := IF(IsMemVar("RM_HISTAGL"),GetMemVar("RM_HISTAGL"),"")
Return( cHAglu )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁCT5Origem     ЁAutorЁMarinaldo de Jesus   Ё Data Ё02/12/2009Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁRetorna a Origem do Lancamento para o Lancamento Padrao        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_InRm2Ctb( "CT5Origem" )                                     Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁLancamento Padrao para Contabilizacao da Folha RM            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function CT5Origem()
    Local cOrigem := IF(IsMemVar("RM_ORIGEM"),GetMemVar("RM_ORIGEM"),"")
Return( cOrigem )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        CT5CCC()
        CT5CCD()
        CT5CREDITO()
        CT5DEBITO()
        CT5HIST()
        CT5ORIGEM()
        CT5VLR01CRE()
        CT5VLR01DEB()
        CTGHISTAGL()
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
