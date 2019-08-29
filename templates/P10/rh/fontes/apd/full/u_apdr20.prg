#INCLUDE "PROTHEUS.CH"
#INCLUDE "TRYEXCEPTION.CH"
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
?rograma  ?PDR20    ?utor?arinaldo de Jesus                   ?ata  ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
?escricoes?elat?io de Avaliacao por Compet?cia                                 ?
]ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?so       ?INAF                                                                 ?
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?           ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                    ?
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?rogramador ?ata      ?ro. Ocorr.?otivo da Alteracao                         ?
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?           ?         ?          ?                                            ?
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function APDR20()
    
    /*/
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ?Mascara do Relat?io (220 Colunas)                           ?
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
        1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          EMPRESA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXX                                                                                                                        AVALIAÇÃO INDIVIDUAL
        ?EA: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                        
        AVALIAÇÃO: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                     
        ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
                                                                                           AUTO AVALIAÇÃO             %         |                     AVALIAÇÃO                    |                 CONSENSO                     
          ITEM   COMPET?CIA                                                  QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) | QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) | QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) 
          999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX     999.99      999.99   999.99      999         |     999.99      999.99   999.99      999         |     999.99      999.99   999.99      999         
    /*/

    Local aArea        := GetArea()
    Local aOrd        := {}
    Local aImpress    := aClone( __aImpress )
    
    Local cDesc1    := OemToAnsi("Relat?io de Avaliação por Compet?cia")
    Local cDesc2    := OemToAnsi("Ser  impresso de acordo com os parametros solicitados pelo")
    Local cDesc3    := OemToAnsi("usu rio.")
    Local cAlias    := "RD0"    //Alias do arquivo Principal ( Base )
    Local cPerg        := Padr( "U_APDR20" , Len( SX1->X1_GRUPO ) )
    
    Local wnRel
    Local cMsgAlert
    
    Private aReturn  := {;
                            "Zebrado"        ,;    //01 -> "Zebrado" -> Descricao do Tipo de Formulario que aparecera na Pasta Opcionais
                            NIL                ,;  //02 -> Reservado...
                            "Administra‡„o"    ,;    //03 -> "Administra‡„o" -> Descricao do Destinatario que aparecera na Pasta Opcionais
                            2                ,;  //04 -> Orientacao do Relat?io 1=Retrato;2=Paisagem
                            NIL                ,;  //05 -> Local da Impressao
                            NIL                ,;    //06 -> Nome com que o arquivo sera salvo
                            NIL                ,;    //07 -> Filtro DEFAULT do Relat?io que sera utilizado na Pasta Filtro
                            1                 ;    //08 -> Ordem DEFAULT do Relat?io que srea utilizado na Pasta Ordem
                        }
    
    Private NomeProg := FunName()
    Private Titulo   := cDesc1
    Private nTamanho := "G"
    Private wCabec0  := 3
    Private wCabec1  := "EMPRESA:"
    Private wCabec2  := "?EA:"
    Private wCabec3  := "AVALIAÇÃO:"
    
    Private ContFl   := 1
    Private Li       := 0
    Private nLastKey := 0

    Private cAPDRAva
    Private cAPDRDep
    Private cAPDREmp
    Private cAPDRFil
    
    BEGIN SEQUENCE

        Pergunte( cPerg , .F. )

        APDR20AvaVld(.F.)
        APDR20DepVld(.F.)
        APDR20EmpVld(.F.)
        APDR20FilVld(.F.)
    
        __aImpress[1] := 1

        /*/
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        ?Envia controle para a funcao SETPRINT                        ?
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
        wnRel := NomeProg
        wnRel := SetPrint(;
                            ""            ,;    //01 -> cAlias:            Alias da Tabela
                            wnRel        ,;    //02 -> cNome:             Nome do Relat?io
                            cPerg        ,;    //03 -> cPerg:             Grupo de Perguntas
                            @Titulo     ,;    //04 -> cDesc:             Descricao do Relat?io
                            cDesc1        ,;    //05 -> cCnt1:             1a. Descricao que aparecera no Rodape da Pasta Impressao
                            cDesc2        ,;    //06 -> cCnt2:             2a. Descricao que aparecera no Rodape da Pasta Impressao    
                            cDesc3        ,;    //07 -> cCnt3:             3a. Descricao que aparecera no Rodape da Pasta Impressao
                            .F.            ,;    //08 -> lDic:              Se Disponibilizara Pasta para Selecao dos Campos
                            aOrd        ,;    //09 -> aOrd:              Array com a Descricao das Ordens para Selecao    
                            .T.            ,;    //10 -> lCompres:         Se habilitara compressao do Relat?io
                            nTamanho    ,;    //11 -> cSize:             Tamanho do Relat?io "P=80Colunas";"M=132Colunas";"G=220Colunas"
                            NIL            ,;    //12 -> aFilter:         Array com expressao de Filtro
                            .F.            ,;    //13 -> lFiltro:         Se habilitara a Pasta Filtro
                            .F.            ,;    //14 -> lCrystal:         Se Relat?io esta integrado ao Crystal Report
                            NIL            ,;    //15 -> cNameDrv:         Nome do Drive que sera utilizado para a impressao
                            NIL            ,;    //16 -> lNoAsc:         Se mostrara a Caixa de Dialogo para a SetPrint
                            NIL            ,;    //17 -> lServer:         Se a impressao sera no servidor
                            NIL             ;    //18 -> cPortToPrint:    Porta para a Impressao
                        )
    
        /*/
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        ?Se pressionou a Tecla "ESC" abandona                         ?
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
        IF ( nLastKey == 27 )
            Break
        EndIF
    
        /*/
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        ?Chamada a SetDefault para carga das Informacoes do  Seleciona?
        ?das na SetPrint()                                               ?
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
        SetDefault(;
                        @aReturn    ,;    //01 -> aRet:        Array com a Estrutura do aReturn    
                        cAlias        ,;    //02 -> cAlias:        Alias do Arquivo
                        NIL            ,;    //03 -> lPortr:        Se Retrato 
                        NIL            ,;    //04 -> lNoAsk:        Se tera Display
                        @nTamanho    ,;    //05 -> cSize:        Tamanho do Relat?io
                        2             ;    //06 -> nOrienta:    Orientacao do Relat?io ( 1-Retrato; 2-Paisagem )
                    )
    
        /*/
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        ?Se pressionou a Tecla "ESC" abandona                         ?
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
        IF ( nLastKey == 27 )
           Break
        EndIF
        
        Pergunte( cPerg , .F. )

        IF !( APDR20AvaVld() )
            Break
        EndIF
        
        IF !( APDR20DepVld() )
            Break
        EndIF
        
        IF !( APDR20EmpVld() )
            Break
        EndIF
        
        IF !( APDR20FilVld() )
            Break
        EndIF
        
        /*/
        ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        ?Chamda a execussao da Impressao                               ?
        ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
        RptStatus( { |lEnd| PrintRel( @lEnd , @wnRel , @cPerg ) } , Titulo )
        
    END SEQUENCE
    
    /*/
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ?Restaura os Ponteiros de Entrada                               ?
    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
    __aImpress := aClone( aImpress )
    RestArea( aArea )

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
?un‡„o    ?_InAPDR20    ?utor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
?escri‡„o ?xecutar Funcoes Dentro de APDR010                           ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?intaxe   ?_InAPDR20( cExecIn , aFormParam )                              ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?arametros?Vide Parametros Formais>                                     ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?etorno   ?Ret                                                          ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?bserva‡„o?                                                              ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
?so       ?enerico                                                      ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function InAPDR20( cExecIn , aFormParam )
         
Local uRet

DEFAULT cExecIn        := ""
DEFAULT aFormParam    := {}

IF !Empty( cExecIn )
    cExecIn    := BldcExecInFun( cExecIn , aFormParam )
    uRet    := &( cExecIn )
EndIF

Return( uRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
?un‡…o    ?rintRel    ?Autor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
?escri‡…o ?mprime Detalhes do Relat?io                                ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?intaxe   ?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?arametros?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?so       ?IGAAPD                                                        ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/
Static Function PrintRel( lEnd , wnRel , cPerg )

    Local cAlsQry        := GetNextAlias()
    
    Local cDet            := ""
    Local cDetCab0        := OemToAnsi("                                                                                  AUTO AVALIAÇÃO          %          |                     AVALIAÇÃO         %          |                 CONSENSO              %          ")
    Local cDetCab1        := OemToAnsi("ITEM   COMPET?CIA                                                  QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) | QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) | QTD. RESPOSTA(S)  ?EA  EMPRESA (?EA x EMPRESA) ")
    
    Local cCodAva        := MV_PAR01
    Local cCodDep       := MV_PAR02
    Local cCodEmp       := MV_PAR03
    Local cCodFil       := MV_PAR04
    
    Local cSvEmpAnt        := cEmpAnt
    Local cSvFilAnt        := cFilAnt
    
    Local cCodComp        := GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_CODCOM" , RetOrder( "RD6", "RD6_FILIAL+RD6_CODIGO" ) , .F. )

    Local nTp1Cnt         := 0
    Local nTp1AvgDep    := 0
    Local nTp1AvgEmp    := 0
    Local nTp1DepEmp    := 0    

    Local nTp2Cnt         := 0
    Local nTp2AvgDep    := 0
    Local nTp2AvgEmp    := 0
    Local nTp2DepEmp    := 0

    Local nTp3Cnt         := 0
    Local nTp3AvgDep    := 0
    Local nTp3AvgEmp    := 0
    Local nTp3DepEmp    := 0

    Local oException    
    
    TRYEXCEPTION
        
        SM0->( dbSetOrder( 1 ) )
        IF SM0->( !dbSeek( cCodEmp + cCodFil ) )
            UserExeption( "Empresa ou Filial n? Cadastrada no SIGAMAT.EMP!" )
        EndIF

        IF ( cCodEmp <> cEmpAnt )
            GetEmpr( cCodEmp + cCodFil ) 
        EndIF

        wCabec1     += SM0->( M0_NOMECOM + "/" + M0_FILIAL + "/" + M0_NOME )
        wCabec1     += "                                                                                                                        "
        wCabec1     += "AVALIAÇÃO INDIVIDUAL"
        wCabec1     := OemToAnsi(wCabec1)
    
        wCabec2     += GetCache( "SQB" , cCodDep , xFilial("SQB",cCodFil) , "QB_DESCRIC" , RetOrder( "SQB" , "QB_FILIAL+QB_DEPTO" ) , .F. )
        wCabec2     := OemToAnsi(wCabec2)
        
        wCabec3     += GetCache( "RD6" , cCodAva , xFilial("RD6",cCodFil) , "RD6_DESC" , RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) , .F. )  
        wCabec3     := OemToAnsi(wCabec3)
        
        BEGINSQL ALIAS cAlsQry

            SELECT 
                RD2.RD2_ITEM,
                RD2_DESC,
                ISNULL((
                        SELECT
                             COUNT(*)
                        FROM
                            %table:RDD% RDD, 
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE 
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '1' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                      ),0.00) TP1CNT,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)%AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '1' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                      ),0.00) TP1AVGDEP,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '1' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                    ),0.00) TP1AVGEMP,
                ISNULL((
                        SELECT
                             COUNT(*)
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE 
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '2' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                      ),0.00) TP2CNT,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '2' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                    ),0.00) TP2AVGDEP,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '2' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                    ),0.00) TP2AVGEMP,
                    ISNULL((
                        SELECT
                             COUNT(*)
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE 
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '3' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                      ),0.00) TP3CNT,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6,
                            %table:SRA% SRA
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            SRA.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDZ.RDZ_FILENT = %exp:cCodFil% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            SRA.RA_FILIAL = %exp:xFilial("SRA",cCodFil)% AND
                            RDZ.RDZ_CODRD0 = RDD.RDD_CODADO AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '3' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM AND
                            SRA.RA_FILIAL+RA_MAT = RDZ.RDZ_CODENT AND
                            SRA.RA_DEPTO = %exp:cCodDep%
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                    ),0.00) TP3AVGDEP,
                ISNULL((
                        SELECT
                            ROUND(AVG(RDD.RDD_RESOBT),2) RDD_RESOBT
                        FROM
                            %table:RDD% RDD,
                            %table:RDZ% RDZ,
                            %table:RD6% RD6
                        WHERE
                            RDD.%NotDel% AND
                            RDZ.%NotDel% AND
                            RD6.%NotDel% AND
                            RDZ.RDZ_FILIAL = %exp:xFilial("RDZ",cCodFil)% AND
                            RDZ.RDZ_EMPENT = %exp:cCodEmp% AND
                            RDD.RDD_FILIAL = %exp:xFilial("RDD",cCodFil)% AND
                            RD6.RD6_FILIAL = %exp:xFilial("RD6",cCodFil)% AND
                            RD6.RD6_CODIGO = %exp:cCodAva% AND
                            RDD.RDD_CODAVA = RD6.RD6_CODIGO    AND
                            RDD.RDD_TIPOAV = '3' AND
                            RDD.RDD_CODCOM = RDM.RDM_CODIGO AND
                            RDD.RDD_ITECOM = RD2.RD2_ITEM
                        GROUP BY
                            RDD.RDD_FILIAL,RDD.RDD_CODAVA,RDD.RDD_TIPOAV
                    ),0.00) TP3AVGEMP
            FROM
                %table:RDM% RDM,
                %table:RD2% RD2
            WHERE
                RDM.%NotDel% AND
                RD2.%NotDel% AND
                RDM.RDM_FILIAL = %exp:xFilial("RDM",cCodFil)% AND
                RD2.RD2_FILIAL = %exp:xFilial("RD2",cCodFil)% AND
                RDM.RDM_CODIGO = %exp:cCodComp% AND
                RD2.RD2_CODIGO = RDM.RDM_CODIGO
            ORDER BY
                RD2.RD2_FILIAL,RD2.RD2_CODIGO,RD2.RD2_ITEM

        ENDSQL
        
        Impr( cDetCab0 )
        Impr( cDetCab1 ) 
        Impr( "" )
        
        SetRegua( 0 )
    
        While (cAlsQry)->( !Eof() )
    
            IncRegua()
            
            IF ( lEnd )
                Impr( OemToAnsi( cCancel ) )
                Exit
            EndIF

            cDet := ""
            
            cDet += (cAlsQry)->RD2_ITEM
            cDet += " "
            cDet += (cAlsQry)->RD2_DESC
            cDet += "     "

            nTp1Cnt     := (cAlsQry)->TP1CNT
            nTp1AvgDep    := (cAlsQry)->TP1AVGDEP
            nTp1AvgEmp    := (cAlsQry)->TP1AVGEMP
            nTp1DepEmp    := NoRound( ( ( nTp1AvgDep/nTp1AvgEmp) * 100 ) , 2 )

            nTp2Cnt     := (cAlsQry)->TP2CNT
            nTp2AvgDep    := (cAlsQry)->TP2AVGDEP
            nTp2AvgEmp    := (cAlsQry)->TP2AVGEMP
            nTp2DepEmp    := NoRound( ( ( nTp2AvgDep/nTp2AvgEmp) * 100 ) , 2 )

            nTp3Cnt     := (cAlsQry)->TP3CNT
            nTp3AvgDep    := (cAlsQry)->TP3AVGDEP
            nTp3AvgEmp    := (cAlsQry)->TP3AVGEMP
            nTp3DepEmp    := NoRound( ( ( nTp3AvgDep/nTp3AvgEmp) * 100 ) , 2 )
            
            cDet += TransForm( nTp1Cnt , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp1AvgDep , "@E 999.99" )
            cDet += "   "
            cDet += TransForm( nTp1AvgEmp , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp1DepEmp , "@E 999.99" )

            cDet += "      |     "

            cDet += TransForm( nTp2Cnt , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp2AvgDep , "@E 999.99" )
            cDet += "   "
            cDet += TransForm( nTp2AvgEmp , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp2DepEmp , "@E 999.99" )

            cDet += "      |     "
            
            cDet += TransForm( nTp3Cnt , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp3AvgDep , "@E 999.99" )
            cDet += "   "
            cDet += TransForm( nTp3AvgEmp , "@E 999.99" )
            cDet += "      "
            cDet += TransForm( nTp3DepEmp , "@E 999.99" )
    
            IF ( Li == 57 )
                ++LI
                Impr( cDetCab0 )
                Impr( cDetCab1 )
                Impr( "" )
            EndIF 
    
            Impr( OemToAnsi( cDet ) )
            
            (cAlsQry)->( dbSkip() )
            
        End While
        
        (cAlsQry)->( dbCloseArea() )
    
        SET DEVICE TO SCREEN
        IF ( aReturn[5] == 1 )
            SET PRINTER TO
            dbCommit()
            OurSpool( wnRel )
        EndIF
        
        Ms_Flush()
    
    CATCHEXCEPTION USING oException
    
        MsgAlert( oException:Description , "Alerta!" )

    ENDEXCEPTION

    IF !( cSvEmpAnt == cEmpAnt )
        GetEmpr( cSvEmpAnt+cSvFilAnt )        
    EndIF
    
Return( NIL  )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
?un‡…o    ?PDR20AvaVld?Autor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
?escri‡…o ?alida o Codigo da Avaliação                                ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?intaxe   ?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?arametros?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?so       ?IGAAPD                                                        ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/
Static Function APDR20AvaVld( lValid )
    
    Local lRet := .T.
    Local oException
    
    cAPDRAva := MV_PAR01
    
    TRYEXCEPTION
        DEFAULT lValid := .T.
        IF ( lValid )
            RD6->( dbSetOrder( RetOrder( "RD6" , "RD6_FILIAL+RD6_CODIGO" ) ) )
            IF RD6->( !dbSeek( xFilial( "RD6" ) + cAPDRAva ) )
                UserException( "C?igo de Avaliação Informado N? Existente na Tabela RD6" )
            EndIF
        EndIF    
    CATCHEXCEPTION USING oException
        lRet := .F.
        MsgAlert( oException:Description , "Alerta!" )
    ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
?un‡…o    ?PDR20DepVld?Autor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
?escri‡…o ?alida o Codigo do Departamento                                ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?intaxe   ?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?arametros?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?so       ?IGAAPD                                                        ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/
Static Function APDR20DepVld( lValid )

    Local lRet := .T.
    Local oException

    cAPDRDep := MV_PAR02

    TRYEXCEPTION
        DEFAULT lValid := .T.
        IF ( lValid )
            SQB->( dbSetOrder( RetOrder( "SQB" , "QB_FILIAL+QB_DEPTO" ) ) )
            IF SQB->( !dbSeek( xFilial( "SQB" ) + cAPDRDep ) )
                UserException( "C?igo do Departamento Informado N? Existente na Tabela SQB" )
            EndIF
        EndIF    
    CATCHEXCEPTION USING oException
        lRet := .F.
        MsgAlert( oException:Description , "Alerta!" )
    ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
?un‡…o    ?PDR20EmpVld?Autor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
?escri‡…o ?alida o Codigo da Empresa                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?intaxe   ?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?arametros?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?so       ?IGAAPD                                                        ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/
Static Function APDR20EmpVld( lValid )

    Local lRet := .T.
    Local oException

    cAPDREmp := MV_PAR03

    TRYEXCEPTION
        DEFAULT lValid := .T.
        IF ( lValid )
            SM0->( dbSetOrder( 1 ) )
            SM0->( dbSeek( cAPDREmp , .T. ) )
            IF !( SM0->M0_CODIGO == cAPDREmp )
                UserException( "C?igo da Empresa Informado Inv?ido" )
            EndIF
        EndIF    
    CATCHEXCEPTION USING oException
        lRet := .F.
        MsgAlert( oException:Description , "Alerta!" )
    ENDEXCEPTION

Return( lRet )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
?un‡…o    ?PDR20FilVld?Autor ?arinaldo de Jesus   ?Data ?0/11/2009?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
?escri‡…o ?alida o Codigo da Filial                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?intaxe   ?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?arametros?vide parametros formais>                                    ?
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?so       ?IGAAPD                                                        ?
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?*/
Static Function APDR20FilVld( lValid )

    Local lRet := .T.
    Local oException

    cAPDREmp := MV_PAR03
    cAPDRFil := MV_PAR04

    TRYEXCEPTION
        DEFAULT lValid := .T.
        IF ( lValid )
            SM0->( dbSetOrder( 1 ) )
            IF SM0->( !dbSeek( cAPDREmp + cAPDRFil ) )
                UserException( "Filial Inv?ida" )
            EndIF
        ENDIF    
    CATCHEXCEPTION USING oException
        lRet := .F.
        MsgAlert( oException:Description  , "Alerta!" )
    ENDEXCEPTION

Return( lRet )
