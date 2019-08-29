#INCLUDE "NDJ.CH"
#Include "CTBR195.CH"
#DEFINE  TAM_VALOR 32

/*
=============================================================================
Função......: NDJCTB01
Data .......: 31/01/2011
Descrição ..: Balancete Centro de Custo/Conta/Item/Cl. Valor    
Uso ........: SIGACTB
=============================================================================
*/
User Function NDJCTB01()

Local aArea         := GetArea()
Local oReport          

Local lOk           := .T.
Local aCtbMoeda        := {}
Local nDivide        := 1
Local nQuadro        := 0 

PRIVATE cTipoAnt    := ""
PRIVATE cPerg         := "CTR591"
PRIVATE nomeProg      := "CTBR591"
PRIVATE aQuadro     := { "","","","","","","",""}              
PRIVATE oTRF1
PRIVATE oTRF2
PRIVATE nTotMov        := 0
PRIVATE lMov        := .F. // variável privativa por necessidade da TRFunction.
PRIVATE nTotdbt        := 0
PRIVATE nTotcrt        := 0
PRIVATE titulo

//If MsgYesNo( "Gerar relatório IReport ?" ) 
//   CallAppJava()

//ELseIf FindFunction("TRepInUse") .And. TRepInUse()

If FindFunction("TRepInUse") .And. TRepInUse()
        
   For nQuadro :=1 To Len(aQuadro)
       aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
   Next    
        
   CtbCarTxt()

   //Perguntas ativadas antes das definições.
   Pergunte(cPerg,.T.) 

   //Acesso somente pelo SIGACTB.
   If ( !AMIIn(34) )
      lOk := .F.
   EndIf
        
   //Verificação de uso do Set Of Books + Plano Gerencial 
   //(Caso use o Plano Gerencial efetua montagem específica para impressão).
   If !ct040Valid(mv_par12) // Set Of Books
        lOk := .F.
   EndIf 

   If     mv_par29 == 2          //Divide por cem
          nDivide := 100
   ElseIf mv_par29 == 3          //Divide por mil
          nDivide := 1000
   ElseIf mv_par29 == 4          //Divide por milhão
          nDivide := 1000000
   EndIf    

   If lOk
         aCtbMoeda      := CtbMoeda(mv_par13,nDivide) // Moeda?
      If Empty(aCtbMoeda[1])
         Help(" ",1,"NOMOEDA")
         lOk := .F.
      Endif
   Endif

   If lOk
         oReport := ReportDef(aCtbMoeda,nDivide,aQuadro)
      oReport:PrintDialog()
   EndIf
Else
   Ctbr591R3() //Executa versão anterior do fonte.
Endif
    
RestArea(aArea)

Return

/*
=============================================================================
Programa ...: ReportDef
Data .......: 31/01/2011
Descrição ..: Definição do objeto do relatório personalizável e das seções que serão utilizadas
Parametros .: aCtbMoeda  - Matriz ref. a moeda
Uso ........: SIGACTB
=============================================================================
*/
Static Function ReportDef(aCtbMoeda,nDivide,aQuadro)

Local oReport
Local oS1CCusto
Local oS2Conta 
Local oS3Item
Local oS4CVlr

Local oBreak

Local cSayCC        := CtbSayApro("CTT")
Local cSayItem        := CtbSayApro("CTD")
Local cSayClVl        := CtbSayApro("CTH")

Local cDesc1         := STR0001+ Upper(cSayCC)+ " / " + Upper(STR0021)+" / "+Upper(cSayItem    ) + " / " + Upper(cSayClVl) //"Este programa irá imprimir o Balancete de  / Conta  / "
Local cDesc2         := STR0002  //"de acordo com os parametros solicitados pelo Usuario"

Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes     := TAMSX3("CTT_RES")
Local aTamConta        := TAMSX3("CT1_CONTA")
Local aTamCtaRes    := TAMSX3("CT1_RES")
Local aTamItem      := TAMSX3("CTD_ITEM")
Local aTamItRes     := TAMSX3("CTD_RES")    
Local aTamClVl      := TAMSX3("CTH_CLVL")
Local aTamCvRes     := TAMSX3("CTH_RES")
                                            
Local nTamCC          := Len(CriaVar("CTT->CTT_DESC"+mv_par13))
Local nTamCta         := Len(CriaVar("CT1->CT1_DESC"+mv_par13))
Local nTamItem        := Len(CriaVar("CTD->CTD_DESC"+mv_par13))
Local nTamClVl        := Len(CriaVar("CTH->CTH_DESC"+mv_par13))

Local lPula            := Iif(mv_par23==1,.T.,.F.) 

Local lCNormal        := Iif(mv_par25==1,.T.,.F.)
Local lCCNormal        := Iif(mv_par26 == 1,.T.,.F.)
Local lItNormal        := Iif(mv_par27 == 1,.T.,.F.)
Local lCvNormal        := Iif(mv_par28 == 1,.T.,.F.)

Local lPrintZero    := Iif(mv_par24==1,.T.,.F.)
Local cSegAte            := mv_par16 // Imprimir ate o Segmento?
Local lPulaPag        := Iif(mv_par22==1,.T.,.F.)

Local nDigitAte        := 0
Local cSepara1        := ""
Local cSepara2        := ""
Local cSepara3        := ""
Local cSepara4        := ""
Local aSetOfBook    := CTBSetOf(mv_par13)    
    
Local cMascara1        := IIF (Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSepara1))//Mascara do Centro de Custo
Local cMascara2        := IIF (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara2))//Mascara da Conta
Local cMascara3        := IIF (Empty(aSetOfBook[7]),"",RetMasCtb(aSetOfBook[7],@cSepara3))//Mascara do Item 
Local cMascara4        := IIF (Empty(aSetOfBook[8]),"",RetMasCtb(aSetOfBook[8],@cSepara4))//Mascara da Classe de Valor

Local cPicture         := aSetOfBook[4]
Local nDecimais     := DecimalCTB(aSetOfBook,mv_par13)
Local cDescMoeda     := aCtbMoeda[2]

Local bCdCUSTO        := {|| EntidadeCTB(cArqTmp->CUSTO,,,20,.F.,cMascara1,cSepara1,,,,,.F.) }
Local bCdCCRES        := {|| EntidadeCTB(cArqTmp->CCRES,,,20,.F.,cMascara1,cSepara1,,,,,.F.) }

Local bCdCONTA        := {|| IIF(Empty(cArqTmp->ITEM) .And. Empty(cArqTmp->CLVL),IIF(cArqTmp->TIPOCONTA=="1","","  ")+EntidadeCTB(cArqTmp->CONTA,,,25 ,.F.,cMascara2,cSepara2,,,,,.F.),"")}
Local bCdCTRES        := {|| IIF(Empty(cArqTmp->ITEM) .And. Empty(cArqTmp->CLVL),IIF(cArqTmp->TIPOCONTA=="1","","  ")+EntidadeCTB(cArqTmp->CTARES,,,20,.F.,,,,,,,.F.),"")}

Local bCdITEM        := {|| IIF(Empty(cArqTmp->CLVL),EntidadeCTB(cArqTmp->ITEM,,,20,.F.,cMascara3,cSepara3,,,,,.F.),"")}
Local bCdITRES        := {|| IIF(Empty(cArqTmp->CLVL),EntidadeCTB(cArqTmp->ITEMRES,,,20,.F.,,,,,,,.F.),"")}

Local bCdCVRL        := {|| EntidadeCTB(cArqTmp->CLVL,,,20,.F.,cMascara4,cSepara4,,,,,.F.) }
Local bCdCVRES        := {|| EntidadeCTB(cArqTmp->CLVLRES,,,20,.F.,,,,,,,.F.) }

titulo               := STR0003+ Upper(cSayCC)+ " / " +  Upper(STR0021)+" / "+Upper(cSayItem)+ " / " + Upper(cSayClVl)    //"Balancete de Verificacao  / Conta / "
lMov                   := IIF(mv_par21 == 1,.T.,.F.) //Imprime movimento ?

/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */

oReport   := TReport():New(nomeProg,Capital(titulo),cPerg,{|oReport| ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCC,cSayItem,cSayClVl,nDivide)},cDesc1+cDesc2)
oReport:SetLandScape(.T.)

// Sessao 1
oS1CCusto := TRSection():New(oReport,STR0040 ,{"cArqTmp", "CTT"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)  //"Centro de Custo"
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)

TRCell():New(oS1CCusto,"CUSTO"        ,"cArqTmp",STR0040,/*Picture*/,aTamCC[1]    ,/*lPixel*/,bCdCUSTO ) //"Centro de Custo"
TRCell():New(oS1CCusto,"CCRES"        ,"cArqTmp",STR0041,/*Picture*/,aTamCCRes[1]    ,/*lPixel*/,bCdCCRES ) //"CODIGO REDUZIDO C. CUSTO"
TRCell():New(oS1CCusto,"DESCCC"        ,"cArqTmp",STR0042,/*Picture*/,nTamCC        ,/*lPixel*/,/*{|| }*/) //"DESCRICAO"

TRPosition():New( oS1CCusto, "CTT", 1, {|| xFilial("CTT") + cArqTMP->CUSTO })
oS1CCusto:SetLineStyle()
oS1CCusto:SetNoFilter({"cArqTmp", "CTT"})

If lCCNormal
   oS1CCusto:Cell("CCRES"):Disable()
Else
   oS1CCusto:Cell("CUSTO"):Disable() 
EndIf

If lPulaPag
   oS1CCusto:SetPageBreak(.T.)
EndIf

//Somente sera impresso centro de custo analitico    
oS1CCusto:SetLineCondition( {|| IIF(cArqTmp->TIPOCC == "1",.F.,.T.) })

//Sessao 2
oS2Conta := TRSection():New(oS1CCusto, UPPER(STR0043),{"cArqTmp", "CT1", "CTH", "CTD"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)  //
oS2Conta:SetTotalInLine(.F.)
oS2Conta:SetHeaderPage()

TRCell():New(oS2Conta,"CONTA"        ,"cArqTmp",UPPER(STR0043),/*Picture*/,aTamConta[1] ,/*lPixel*/, bCdCONTA ) //"CONTA"            
TRCell():New(oS2Conta,"CTARES"        ,"cArqTmp",UPPER(STR0044),/*Picture*/,aTamCtaRes[1],/*lPixel*/, bCdCTRES ) //"CONTA RES"
TRCell():New(oS2Conta,"ITEM"        ,"cArqTmp",UPPER(STR0045),/*Picture*/,aTamItem[1]  ,/*lPixel*/, bCdITEM  ) //"ITEM"
TRCell():New(oS2Conta,"ITEMRES"        ,"cArqTmp",UPPER(STR0046),/*Picture*/,aTamItRes[1] ,/*lPixel*/, bCdITRES )  //"ITEM RES"
TRCell():New(oS2Conta,"CLVL"        ,"cArqTmp",UPPER(STR0047),/*Picture*/,aTamClVl[1]  ,/*lPixel*/, bCdCVRL  ) //"CL.VALOR"        
TRCell():New(oS2Conta,"CLVLRES"        ,"cArqTmp",UPPER(STR0048),/*Picture*/,aTamCVRes[1] ,/*lPixel*/, bCdCVRES ) //"CL.VALOR RES."
TRCell():New(oS2Conta,"DESC"        ,"cArqTmp",UPPER(STR0042),/*Picture*/,nTamCta-10   ,/*lPixel*/,{|| IIF( !Empty(cArqTmp->CLVL), cArqTmp->DESCCLVL, IIF( !Empty(cArqTmp->ITEM), cArqTmp->DESCITEM,cArqTmp->DESCCTA ) ) },,.T., )   //"DESCRICAO"        
TRCell():New(oS2Conta,"SALDOANT"    ,"cArqTmp",UPPER(STR0049),/*Picture*/,TAM_VALOR       ,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR  ,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"CENTER") //"SALDO ANTERIOR"
TRCell():New(oS2Conta,"SALDODEB"    ,"cArqTmp",UPPER(STR0050),/*Picture*/,TAM_VALOR       ,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"CENTER") //"DEBITO"
TRCell():New(oS2Conta,"SALDOCRD"    ,"cArqTmp",UPPER(STR0051),/*Picture*/,TAM_VALOR       ,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"CENTER") //"CREDITO"
TRCell():New(oS2Conta,"MOVIMENTO"    ,"cArqTmp",UPPER(STR0052),/*Picture*/,TAM_VALOR       ,/*lPixel*/,{|| ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR  ,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"CENTER") //"MOVIMENTO DO PERIODO"
TRCell():New(oS2Conta,"SALDOATU"    ,"cArqTmp",UPPER(STR0053),/*Picture*/,TAM_VALOR       ,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR+5,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"CENTER") //"SALDO ATUAL"
TRPosition():New( oS2Conta, "CTH", 1, {|| xFilial("CTH") + cArqTMP->CLVL })
TRPosition():New( oS2Conta, "CTD", 1, {|| xFilial("CTD") + cArqTMP->ITEM })
TRPosition():New( oS2Conta, "CT1", 1, {|| xFilial("CT1") + cArqTMP->CONTA})

If lCNormal
   oS2Conta:Cell("CTARES"    ):Disable()
Else
   oS2Conta:Cell("CONTA"    ):Disable() 
EndIf

If lItNormal
   oS2Conta:Cell("ITEMRES"):Disable()
Else
   oS2Conta:Cell("ITEM"):Disable() 
EndIf

//Se Imprime Codigo Reduzido
If lCvNormal 
   oS2Conta:Cell("CLVLRES"):Disable()
Else
   oS2Conta:Cell("CLVL"):Disable()
EndIf

//Nao Imprime Coluna Movimento!!
If !lMov 
    oS2Conta:Cell("MOVIMENTO"):Disable()
EndIf  

If oReport:GetOrientation() == 1
   If lMov
         oS2Conta:Cell("DESC"):Disable() 
   EndIf
EndIf

oS2Conta:SetNoFilter({"cArqTmp", "CT1", "CTH", "CTD"})
oS2Conta:SetLinesBefore(0)

oS2Conta:OnPrintLine( {|| ( IIf( lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL), cTipoAnt := cArqTmp->TIPOCONTA ) })

oS2Conta:SetLineCondition({|| f591Fil(cSegAte, nDigitAte,cMascara2) })
    
oBreak:= TRBreak():New(oS2Conta,{ || cArqTmp->CUSTO },Capital(STR0020+cSayCC),.F.)
    
oBreak:OnBreak({ || nTotdbt := oTRF1:GetValue(),nTotcrt := oTRF2:GetValue() })

oTRF1 := TRFunction():New(oS2Conta:Cell("SALDODEB"),nil,"SUM"    ,oBreak,/*Titulo*/,/*cPicture*/,{ || f591Soma("D",cSegAte) },.F.,.F.,.F.,oS2Conta)
oTRF1:disable()

TRFunction():New(oS2Conta:Cell("SALDODEB")         ,nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ValorCTB(nTotdbt,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oS2Conta)
    
oTRF2 := TRFunction():New(oS2Conta:Cell("SALDOCRD"),nil,"SUM"    ,oBreak,/*Titulo*/,/*cPicture*/,{ || f591Soma("C",cSegAte) },.F.,.F.,.F.,oS2Conta)
oTRF2:disable()

TRFunction():New(oS2Conta:Cell("SALDOCRD")         ,nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ValorCTB(nTotcrt,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oS2Conta)
    
TRFunction():New(oS2Conta:Cell("MOVIMENTO")        ,nil,"ONPRINT",oBreak,/*Titulo*/,/*cPicture*/,{ || ( nTotMov := (nTotcrt - nTotdbt),;
IIF( lMov, IIF( nTotMov < 0,ValorCTB(nTotMov,,,TAM_VALOR,nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.),IIF( nTotMov > 0,ValorCTB(nTotMov,,,TAM_VALOR,nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.),nil) ), nil) )},.F.,.F.,.F.,oS2Conta )

/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------------------------------------- */

Return oReport

/*
=============================================================================
Programa ...: ReportPrint
Data .......: 31/01/2011
Descrição ..: Definição do objeto do relatório personalizável e das seções que serão utilizadas
Parametros .: 
Uso ........: SIGACTB
=============================================================================
*/
Static Function ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCC,cSayItem,cSayClVl,nDivide)

Local oS1CCusto     := oReport:Section(1)
Local oS2Conta        := oReport:Section(1):Section(1)

Local cArqTmp        := ""
Local cFiltro        := oS1CCusto:GetAdvplExp("CTT")

Local dDataLP          := mv_par31
Local dDataFim         := mv_par02

Local lImpAntLP        := Iif(mv_par30==1,.T.,.F.)
Local lPrintZero    := Iif(mv_par24==1,.T.,.F.)    

If oReport:GetOrientation() == 1
    If lMov
        oS2Conta:Cell("DESC"):Disable() 
    Else
        oS2Conta:Cell("DESC"):SetSize(28)    
    EndIf
EndIf

//Carrega titulo do relatorio: Analitico / Sintetico
IF     mv_par11 == 1
       titulo :=    STR0006       //"BALANCETE ANALITICO DE  "
ElseIf mv_par11 == 2
       titulo :=    STR0007     //"BALANCETE SINTETICO DE  "
ElseIf mv_par11 == 3
       titulo :=    STR0008     //"BALANCETE DE  "
EndIf
                                                               
titulo +=     Upper(cSayCC) + "/" + Upper(STR0021) + "/" + Upper(cSayItem) + "/" + Upper(cSayClVl)
titulo +=     STR0009 + DTOC(mv_par01) + STR0010 + Dtoc(mv_par02) +     STR0011 + cDescMoeda
    
If mv_par15 > "1"
   titulo += " (" + Tabela("SL", mv_par13, .F.) + ")"
EndIf
    
If nDivide > 1            
   titulo += " (" + STR0022 + Alltrim(Str(nDivide)) + ")"
EndIf    
    
//oReport:SetTitle(titulo)
oReport:SetPageNumber(mv_par14) //mv_par14    -    Pagina Inicial
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )
    
//Monta Arquivo Temporario para Impressão
MsgMeter({|    oMeter, oText, oDlg, lEnd | ;                        
            CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
             mv_par01,mv_par02,"CTI","",mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09,mv_par10,mv_par13,;
              mv_par15,aSetOfBook,mv_par17,mv_par18,mv_par19,mv_par20,;
               .F.,.T.,,"CTT",lImpAntLP,dDataLP, nDivide,.F.,,,,,,,,,,,,,,,cFiltro /*aReturn[7]*/,,,,,.T.)},;                                    
                (STR0014),;  //"Criando Arquivo Temporário..."
                 (STR0003)+Upper(cSayCC)+ " / "+Upper(STR0021)+ " / " + Upper(cSayItem)+ " / " + Upper(cSayClVl)) //"Balancete Verificacao "

//Inicia a impressao do relatorio                                               ³
dbSelectArea("cArqTmp")
dbGotop()
//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial nao esta disponivel e sai da rotina.
If !( RecCount() == 0 .And. !Empty(aSetOfBook[5]) )
   oS2Conta:SetParentFilter( { |cParam| cArqTmp->CUSTO == cParam },{ || cArqTmp->CUSTO }) //SERVE PARA IMPRIMIR O TITULO DA SECAO PAI
   oS1CCusto:Print()
EndIf
    
dbSelectArea("cArqTmp")
cArqTmp->( dbclearfilter() )

dbCloseArea()
If Select("cArqTmp") == 0
   //Ferase(cArqTmp+GetDBExtension())
   //FErase("cArqInd"+OrdBagExt())
EndIf    
dbselectArea("CT2")
Return

/*
=============================================================================
Programa ...: f591Soma
Data .......: 31/01/2011
Descrição ..: 
Parametros .: 
Uso ........: 
=============================================================================
*/
Static Function f591Soma(cTipo,cSegAte)

Local nRetValor        := 0

If Empty(cArqTmp->ITEM) .And. Empty(cArqTmp->CLVL)
   If mv_par11 == 1                    // So imprime Sinteticas - Soma Sinteticas
         If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1
         If     cTipo == "D"
                nRetValor := cArqTmp->SALDODEB
         ElseIf cTipo == "C"
                nRetValor := cArqTmp->SALDOCRD
         EndIf
      EndIf
   Else    //Soma Analiticas
      If Empty(cSegAte)    //Se nao tiver filtragem ate o nivel
         If cArqTmp->TIPOCONTA == "2"
            If     cTipo == "D"
                   nRetValor := cArqTmp->SALDODEB
            ElseIf cTipo == "C"
                   nRetValor := cArqTmp->SALDOCRD
            EndIf
         EndIf
      Else //Se tiver filtragem, somo somente as sinteticas
           If cArqTmp->TIPOCONTA == "1" .And. cArqTmp->NIVEL1
            If     cTipo == "D"
                      nRetValor := cArqTmp->SALDODEB
            ElseIf cTipo == "C"
                   nRetValor := cArqTmp->SALDOCRD
            EndIf
         EndIf
      Endif
   EndIf                     
EndIf
    
Return nRetValor                                                                         

/*
=============================================================================
Programa ...: f591Fil
Data .......: 31/01/2011
Descrição ..: 
Parametros .: 
Uso ........: 
=============================================================================
*/
Static Function f591Fil(cSegAte, nDigitAte,cMascara2)

Local lDeixa := .T.
Local nCont  := 0

If mv_par11 == 1                //So imprime Sinteticas
   If cArqTmp->TIPOCONTA == "2"
         lDeixa := .F.
   EndIf
ElseIf mv_par11 == 2            //So imprime Analiticas
   If cArqTmp->TIPOCONTA == "1"
      lDeixa := .F.
   EndIf
EndIf

//Verifica Se existe filtragem Ate o Segmento
//Filtragem ate o Segmento (antigo nivel do SIGACON)        
If !Empty(cSegAte)
   For nCont := 1 to Val(cSegAte)
       nDigitAte += Val(Subs(cMascara2,nCont,1))    
   Next
   If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
         lDeixa := .F.
   Endif
EndIf

dbSelectArea("cArqTmp")

Return (lDeixa)

/* ------------------------------------------------------ RELESE 3 ------------------------------------------------------------ */
#DEFINE     COL_SEPARA1            1
#DEFINE     COL_CONTA              2
#DEFINE     COL_SEPARA2            3
#DEFINE     COL_ITEM               4
#DEFINE     COL_SEPARA3            5
#DEFINE     COL_CLVL               6
#DEFINE     COL_SEPARA4            7
#DEFINE     COL_DESCRICAO        8
#DEFINE     COL_SEPARA5            9
#DEFINE     COL_SALDO_ANT        10
#DEFINE     COL_SEPARA6            11
#DEFINE     COL_VLR_DEBITO       12
#DEFINE     COL_SEPARA7            13
#DEFINE     COL_VLR_CREDITO      14
#DEFINE     COL_SEPARA8            15
#DEFINE     COL_MOVIMENTO         16
#DEFINE     COL_SEPARA9            17                                                                                       
#DEFINE     COL_SALDO_ATU         18
#DEFINE     COL_SEPARA10        19

/*
=============================================================================
Programa ...: Ctbr591R3()
Data .......: 31/01/2011
Descrição ..: Balancete Centro de Custo/Conta/Item/Cl. Valor
Parametros .: 
Uso ........: 
=============================================================================
*/
Static Function Ctbr591R3()

Local aSetOfBook
Local aCtbMoeda        := {}

Local cSayCC        := CtbSayApro("CTT")
Local cSayItem        := CtbSayApro("CTD")
Local cSayClVl        := CtbSayApro("CTH")
Local cDesc1         := STR0001+ Upper(cSayCC)+ " / " + Upper(STR0021)+" / "+Upper(cSayItem    ) + " / " + Upper(cSayClVl) //"Este programa ira imprimir o Balancete de  / Conta  / "
Local cDesc2         := STR0002  //"de acordo com os parametros solicitados pelo Usuario"
Local cString        := "CTT"

Local lRet            := .T.

Local nDivide        := 1
Local nQuadro        := 0 

Local wnrel
Local titulo         := STR0003+ Upper(cSayCC)+ " / " +  Upper(STR0021)+" / "+Upper(cSayItem)+ " / " + Upper(cSayClVl)    //"Balancete de Verificacao  / Conta / "

PRIVATE aReturn     := { STR0015, 1,STR0016, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha        := {}
PRIVATE cPerg         := "CTR591"
PRIVATE nLastKey     := 0
PRIVATE nomeProg      := "CTBR591"
PRIVATE Tamanho        :="G"

//Acesso somente pelo SIGACTB
If ( !AMIIn(34) )        
   Return
EndIf
                                                                     
li       := 80
m_pag := 1

Private aQuadro := { "","","","","","","",""}              

For nQuadro :=1 To Len(aQuadro)
    aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next    

CtbCarTxt()

Pergunte("CTR591",.F.)

//Variaveis utilizadas para parametros                                 
//mv_par01                // Data Inicial                             
//mv_par02                // Data Final                              
//mv_par03                // Conta Inicial                           
//mv_par04                // Conta Final                             
//mv_par05                // Do Centro de Custo                  
//mv_par06                // Ate Centro de Custo                     
//mv_par07                // Do Item                                 
//mv_par08                // Ate o Item                          
//mv_par09                // Da Classe de Valor                      
//mv_par10                // Ate a Classe de Valor                   
//mv_par11                // Imprime Contas: Sintet/Analit/Ambas     
//mv_par12                // Configuracao de Livros                      
//mv_par13                // Moeda?                                      
//mv_par14                // Pagina Inicial                              
//mv_par15                // Saldos? Reais / Orcados    /Gerenciais    
//mv_par16                // Imprimir ate o Segmento?                   
//mv_par17                // Filtra Segmento?                           
//mv_par18                // Conteudo Inicial Segmento?               
//mv_par19                // Conteudo Final Segmento?                   
//mv_par20                // Conteudo Contido em?                       
//mv_par21                // Imprime Coluna Mov ?                       
//mv_par22                // Pula Pagina                             
//mv_par23                // Salta linha sintetica ?               
//mv_par24                // Imprime valor 0.00    ?               
//mv_par25                // Imprimir Conta?Normal/Reduzido          
//mv_par26                // Imprimir CC?Normal / Reduzido           
//mv_par27                // Imprimir Item?Normal / Reduzido                                                                             
//mv_par28                // Imprimir Cl.Valor?Normal/Reduzido                                                                         
//mv_par29                // Divide por ?                                                                                                
//mv_par30                // Posicao Ant. L/P? Sim / Nao             
//mv_par31                 // Data Lucros/Perdas?                    

wnrel    := "CTBR591" //Nome Default do relatorio em Disco
//wnrel     := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

//Removido para teste - Robert - 31/01/2011
wnrel     := SetPrint(,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
   dbclearfilter()
   Return
Endif

//Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano Gerencial -> montagem especifica para impressao)
If !ct040Valid(mv_par12)
   lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par12)
Endif

If     mv_par29 == 2    //Divide por cem
       nDivide := 100 
ElseIf mv_par29 == 3    //Divide por mil
       nDivide := 1000
ElseIf mv_par29 == 4    //Divide por milhao
    nDivide := 1000000
EndIf    

If lRet
   aCtbMoeda      := CtbMoeda(mv_par13,nDivide)
   If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet
   dbclearfilter()
   Return
EndIf

If nLastKey == 27
   dbclearfilter()
   Return
Endif

RptStatus({|lEnd| CTR591Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,cSayItem,cSayClVl,nDivide)})

//CTR591Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,cSayItem,cSayClVl,nDivide)

Return

/*
=============================================================================
Program   : CTR591IMP 
Descrição : Imprime relatorio -> Balancete Centro de Custo/Conta/Item
Sintaxe   : (lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,cSayItem,cSayClVl,nDivide)
Retorno   : Nenhum                                                  
Uso       : 
Parametros: ExpL1 - Ação do Codeblock                               
            ExpC1 - Título do relat¢rio                             
            ExpC2 - Mensagem                                        
            ExpA1 - Matriz ref. Config. Relatorio                   
            ExpA2 - Matriz ref. a moeda                             
            ExpC3 - Descricao do C.custo utilizada pelo usuario.     
            ExpC4 - Descricao do Item utilizado pelo usuario.        
            ExpC5 - Descricao da Classe de Valor utiliz.pelo usuario 
            ExpN1 - Fator de divisao dos valores.                    
=============================================================================
*/
Static Function CTR591Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,cSayItem,cSayClVl,nDivide)

LOCAL CbTxt            := Space(10)
Local CbCont        := 0
LOCAL tamanho        := "G"
LOCAL limite        := 220
Local cabec1          := ""
Local cabec2        := ""

Local aColunas

Local cSepara1      := ""
Local cSepara2      := ""
Local cSepara3        := ""
Local cSepara4        := ""
Local cPicture
Local cDescMoeda
Local cMascara1
Local cMascara2          
Local cMascara3          
Local cMascara4
Local cGrupo        := ""
Local cItemAnt        := ""
Local cItemRes        := ""
Local cSegAte       := mv_par16
Local cArqTmp        := ""
Local cCCSup        := ""//Centro de Custo Superior do centro de custo atual
Local cAntCCSup        := ""//Centro de Custo Superior do centro de custo anterior
Local lCCNormal        := Iif(mv_par26 == 1,.T.,.F.)

Local dDataLP        := mv_par31
Local dDataFim        := mv_par02

Local lImpAntLP        := Iif(mv_par30 == 1,.T.,.F.)
Local lFirstPage    := .T.
Local lPula            := Iif(mv_par23==1,.T.,.F.) 
Local lJaPulou        := .F.
Local lPrintZero    := Iif(mv_par24==1,.T.,.F.)
Local lImpMov        := .F.
Local lSaltaPag        := .F.
Local lPulaPag        := Iif(mv_par22==1,.T.,.F.)

Local nHandle

Local nDecimais
Local nTotDeb        := 0
Local nTotCrd        := 0
Local nTotMov        := 0
Local nCCTMov         := 0
Local nTamCC        := 0
Local nTotCCDeb        := 0
Local nTotCCCrd        := 0
Local nCCSldAnt        := 0
Local nCCSldAtu        := 0
Local nTotSldAnt    := 0
Local nTotSldAtu    := 0
Local nDigitAte        := 0
Local nDigCCAte        := 0
Local nRegTmp        := 0    
Local n         
Local nCont            := 0 

cDescMoeda      := aCtbMoeda[2]
nDecimais      := DecimalCTB(aSetOfBook,mv_par13)

// Mascara do Centro de Custo
If Empty(aSetOfBook[6])
   cMascara1 := GetMv("MV_MASCCUS")
Else
   cMascara1 := RetMasCtb(aSetOfBook[6],@cSepara1)
EndIf

//Mascara da Conta
If Empty(aSetOfBook[2])
   cMascara2 := GetMv("MV_MASCARA")
Else
   cMascara2 := RetMasCtb(aSetOfBook[2],@cSepara2)
EndIf             

//Mascara do Item 
If !Empty(aSetOfBook[7])
   cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
Else
   cMascara3 := ""
EndIf                                       

If !Empty(aSetOfBook[8])
   cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
Else
   cMascara4 := ""
EndIf

cPicture := aSetOfBook[4]

lImpMov     := Iif(mv_par21 == 1,.T.,.F.)

If lImpMov
   cabec1     := STR0004  //"|  CODIGO              | 
   cabec1    += SPACE(5)+UPPER(cSayItem)+SPACE(5)+"|"
   cabec1    += SPACE(5)+UPPER(cSayClVl)+SPACE(5)
   cabec1    += STR0005  //"|  D E S C R I C A O                          |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
Else
   cabec1     := STR0004  //"|  CODIGO              | 
   cabec1    += SPACE(5)+UPPER(cSayItem)+SPACE(5) +"|"
   cabec1    += SPACE(5)+UPPER(cSayClVl)+SPACE(5)     
   cabec1    += STR0012  //"|D E S C R I C A O                          |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |    SALDO ATUAL               |"
EndIf             

tamanho := "G"
limite    := 220        

SetDefault(aReturn,cString,,,Tamanho,2)    

//Carrega titulo do relatorio: Analitico / Sintetico
IF     mv_par11 == 1
       Titulo := STR0006       //"BALANCETE ANALITICO DE  "
ElseIf mv_par11 == 2
       Titulo := STR0007     //"BALANCETE SINTETICO DE  "
ElseIf mv_par11 == 3
       Titulo := STR0008     //"BALANCETE DE  "
EndIf
                                                           
Titulo += Upper(cSayCC) + "/" + Upper(STR0021) + "/" + Upper(cSayItem) + "/" + Upper(cSayClVl)
Titulo += STR0009 + DTOC(mv_par01) + STR0010 + Dtoc(mv_par02) +     STR0011 + cDescMoeda

If mv_par15 > "1"
   Titulo += " (" + Tabela("SL", mv_par13, .F.) + ")"
EndIf

If nDivide > 1            
   Titulo += " (" + STR0022 + Alltrim(Str(nDivide)) + ")"
EndIf    

If lImpMov
   aColunas := { 000,001, 027, 028, 048,049, 069, 070, 106, 107, 130, 131,151,152,172,173,195,196,218 }
Else
   aColunas := { 000,001, 027, 028, 048,049, 069, 070, 112, 113, 143, 144,165,166,,,189,190,219 }    
EndIf

nTamCC := 40         

m_pag  := mv_par14

//Monta Arquivo Temporario para Impressao
MsgMeter({|    oMeter, oText, oDlg, lEnd | ;                        
            CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
            mv_par01,mv_par02,"CTI","",mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09,mv_par10,mv_par13,;
            mv_par15,aSetOfBook,mv_par17,mv_par18,mv_par19,mv_par20,;
            .F.,.T.,,"CTT",lImpAntLP,dDataLP, nDivide,.F.,,,,,,,,,,,,,,,aReturn[7],,,,,.T.)},;                                    
            (STR0014),;  //"Criando Arquivo Temporário..."
            (STR0003)+Upper(cSayCC)+ " / "+Upper(STR0021)+ " / " + Upper(cSayItem)+ " / " + Upper(cSayClVl)) //"Balancete Verificacao "
            
//Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
    For n := 1 to Val(cSegAte)
        nDigitAte += Val(Subs(cMascara2,n,1))    
    Next
EndIf        

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()             

nHandle := FCreate(cFile)

//GerarDBF()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
   dbCloseArea()
   //FErase(cArqTmp+GetDBExtension())
   //FErase("cArqInd"+OrdBagExt())
   Return
Endif

SetRegua(RecCount())

cCCAnt := cArqTmp->CUSTO
dbSelectArea("cArqTmp")

While !Eof()

    If lEnd
       @Prow()+1,0 PSAY STR0017   //"***** CANCELADO PELO OPERADOR *****"
       Exit
    EndIF

    IncRegua()

    ******************** "FILTRAGEM" PARA IMPRESSAO *************************
    If mv_par11 == 1        //So imprime Sinteticas
       If TIPOCONTA == "2"
          dbSkip()
          Loop
       EndIf
    ElseIf mv_par11 == 2    //So imprime Analiticas
       If TIPOCONTA == "1"
          dbSkip()
          Loop
       EndIf
    EndIf

    //Somente sera impresso centro de custo analitico    
    If TIPOCC == "1"
       dbSkip()
       Loop
    EndIf    

    //Filtragem ate o Segmento da Conta(antigo nivel do SIGACON)        
    If !Empty(cSegAte)
        If Len(Alltrim(CONTA)) > nDigitAte
            dbSkip()
            Loop
        Endif
    EndIf

    ************************* ROTINA DE IMPRESSAO *************************        
    cCCAnt         := cArqTmp->CUSTO
    cCCAntRes     := cArqTmp->CCRES

    If li > 58 .Or. lFirstPage .Or. lSaltaPag .Or. lPulaPag
        If !lFirstPage
            @Prow()+1,00 PSAY    Replicate("-",limite)
        EndIf
        CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
        lFirstPage := .F.
    EndIf    
    
    @ li,000 PSAY "|"                                
    @ li,001 PSAY Upper(cSayCC) + " : "
    If lCCNormal .or. TIPOCC == "1"
        EntidadeCTB(CUSTO,li,17,nTamCC+Len(cSepara1),.F.,cMascara1,cSepara1)                    
    Else
        EntidadeCTB(CCRES,li,17,nTamCC+Len(cSepara1),.F.,cMascara1,cSepara1)        
    Endif                        
    
    @ li,aColunas[COL_SEPARA4] PSAY " - " +cArqTMP->DESCCC
    @ li,aColunas[COL_SEPARA10] PSAY "|"                                                

    li++
    @ li,000 PSAY REPLICATE("-",limite)        
    li+=1                                                                            
   
    While !Eof() .And. cCCAnt == cArqTmp->CUSTO

        If mv_par11 == 1                    // So imprime Sinteticas
            If TIPOCONTA == "2"
                dbSkip()
                Loop
            EndIf
        ElseIf mv_par11 == 2                // So imprime Analiticas
            If TIPOCONTA == "1"
                dbSkip()
                Loop
            EndIf
        EndIf

        //Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)        
        If !Empty(cSegAte)
            If Len(Alltrim(CONTA)) > nDigitAte
                dbSkip()
                Loop
            Endif
        EndIf    

        @ li,aColunas[COL_SEPARA1] PSAY "|"
                
        If Empty(ITEM) .And. Empty(CLVL) //Se o item e a cl.valor estiverem em branco, imprime o codigo da conta) 
            If mv_par25 == 1 .or. TIPOCONTA == "1"    //Imprime cod. conta notrmal ou é sintetica
                EntidadeCTB(CONTA,li,aColunas[COL_CONTA],25,.F.,cMascara2,cSepara2)            
            Else
                EntidadeCTB(CTARES,li,aColunas[COL_CONTA],20,.F.,,)                                                                                                            
            EndIf            
            @ li,aColunas[COL_SEPARA2] PSAY "|"        
            @ li,aColunas[COL_SEPARA3] PSAY "|"                
            @ li,aColunas[COL_SEPARA4] PSAY "|"                                        
            If lImpMov
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCTA,1,36)                        

                FWrite(nHandle,Substr(DESCCTA,1,36))

            Else    
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCTA,1,42)            
                
                FWrite(nHandle,Substr(DESCCTA,1,36))                
            EndIf
            
        ElseIf Empty(CLVL) .And. !Empty(ITEM)        //Imprimir o item
            @ li,aColunas[COL_SEPARA2] PSAY "|"                
            If mv_par27 == 1 .or. TIPOITEM == "1"     //Se imprime cod. item normal ou é sintetico
                EntidadeCTB(ITEM,li,aColunas[COL_ITEM],20,.F.,cMascara3,cSepara3)                            
            Else
                EntidadeCTB(ITEMRES,li,aColunas[COL_ITEM],20,.F.,,)            
            EndIf                
            @ li,aColunas[COL_SEPARA3] PSAY "|"                
            @ li,aColunas[COL_SEPARA4] PSAY "|"                            
            If lImpMov
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCITEM,1,36)                        
            Else            
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCITEM,1,42)                    
            EndIf
        ElseIf !Empty(CLVL)                         //Imprimir a classe de valor
            @ li,aColunas[COL_SEPARA2] PSAY "|"            
            @ li,aColunas[COL_SEPARA3] PSAY "|"        
            If mv_par28 == 1 .or. TIPOCLVL == "1"    
                EntidadeCTB(CLVL,li,aColunas[COL_CLVL],20,.F.,cMascara4,cSepara4)                            
            Else
                EntidadeCTB(CLVLRES,li,aColunas[COL_CLVL],20,.F.,,)                                        
            EndIf
            @ li,aColunas[COL_SEPARA4] PSAY "|"                                
            If lImpMov
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCLVL,1,36)                        
            Else                        
                @ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCLVL,1,42)                        
            EndIf
        EndIf                                        

        @ li,aColunas[COL_SEPARA5] PSAY "|"                
        ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT]  ,17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
        @ li,aColunas[COL_SEPARA6] PSAY "|"
        ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO] ,16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
        @ li,aColunas[COL_SEPARA7] PSAY "|"
        ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)

        If lImpMov
              @ li,aColunas[COL_SEPARA8] PSAY "|"        
           ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
        Endif

        @ li,aColunas[COL_SEPARA9] PSAY "|"            
        ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
        @ li,aColunas[COL_SEPARA10] PSAY "|"
        
        lJaPulou := .F.
        
        If lPula .And. TIPOCONTA == "1"                // Pula linha entre sinteticas
            li++
            @ li,aColunas[COL_SEPARA1] PSAY "|"
            @ li,aColunas[COL_SEPARA2] PSAY "|"
            @ li,aColunas[COL_SEPARA3] PSAY "|"    
            @ li,aColunas[COL_SEPARA4] PSAY "|"
            @ li,aColunas[COL_SEPARA5] PSAY "|"
            @ li,aColunas[COL_SEPARA6] PSAY "|"
            @ li,aColunas[COL_SEPARA7] PSAY "|"

            If lImpMov
                 @ li,aColunas[COL_SEPARA8] PSAY "|"
            EndIf

            @ li,aColunas[COL_SEPARA9]  PSAY "|"
            @ li,aColunas[COL_SEPARA10] PSAY "|"            
            li++
            lJaPulou := .T.
        Else
            li++
        EndIf               
        
        If Empty(cArqTmp->ITEM) .And. Empty(cArqTmp->CLVL)
            If mv_par11 == 1                    // So imprime Sinteticas - Soma Sinteticas
                If TIPOCONTA == "1"
                    If NIVEL1
                        nTotDeb   += SALDODEB
                        nTotCrd   += SALDOCRD
                        nTotCCDeb += SALDODEB
                        nTotCCCrd += SALDOCRD
                    EndIf
                EndIf
            Else                                // Soma Analiticas
                If Empty(cSegAte)                //Se nao tiver filtragem ate o nivel
                    If TIPOCONTA == "2"
                        nTotDeb   += SALDODEB
                        nTotCrd   += SALDOCRD
                        nTotCCDeb += SALDODEB
                        ntotCCCrd += SALDOCRD
                    EndIf
                Else                            //Se tiver filtragem, somo somente as sinteticas
                    If TIPOCONTA == "1"
                        If NIVEL1
                            nTotDeb   += SALDODEB
                            nTotCrd   += SALDOCRD
                            nTotCCDeb += SALDODEB
                            nTotCCCrd += SALDOCRD
                        EndIf
                    EndIf    
                Endif            
            EndIf
        EndIf                    
        dbSkip()  
        
        If lPula .And. TIPOCONTA == "1"  //Pula linha entre sinteticas
            If !lJaPulou
                @ li,aColunas[COL_SEPARA1] PSAY "|"
                @ li,aColunas[COL_SEPARA2] PSAY "|"
                @ li,aColunas[COL_SEPARA3] PSAY "|"    
                @ li,aColunas[COL_SEPARA4] PSAY "|"
                @ li,aColunas[COL_SEPARA5] PSAY "|"
                @ li,aColunas[COL_SEPARA6] PSAY "|"
                @ li,aColunas[COL_SEPARA7] PSAY "|"

                If lImpMov
                   @ li,aColunas[COL_SEPARA8] PSAY "|"
                EndIf

                @ li,aColunas[COL_SEPARA9]  PSAY "|"
                @ li,aColunas[COL_SEPARA10] PSAY "|"
                li++
            EndIf    
        EndIf
        
        If li > 58 
           If !lFirstPage
              @Prow()+1,00 PSAY Replicate("-",limite)
           EndIf        
           CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
           lFirstPage := .F.
        EndIf    
        
    EndDo
    
    // Impressao do Totalizador do Centro de Custo
    @li,00 PSAY    Replicate("-",limite)
    li++
    
    @li,00 PSAY "|"                      
    @li,01 PSAY STR0020+ Upper(cSayCC)+" : " //"T O T A I S  D O  "

    If lCCNormal .or. TIPOCC == "1"          //Codigo Normal do Centro de Custo ou sintetico
          EntidadeCTB(cCCAnt,li,33,40,.F.,cMascara1,cSepara1)        
    Else
       EntidadeCTB(cCCAntRes,li,33,40,.F.,cMascara1,cSepara1)
    EndIf                              
    
    @ li,aColunas[COL_SEPARA6] PSAY "|"    
    ValorCTB(nTotCCDeb,li,aColunas[COL_VLR_DEBITO] ,16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
    @ li,aColunas[COL_SEPARA7] PSAY "|"
    ValorCTB(nTotCCCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)            

    If lImpMov    
          @ li,aColunas[COL_SEPARA8] PSAY "|"
       nTotMov := (nTotCCCrd - nTotCCDeb)

       If     Round(NoRound(nTotMov,3),2) < 0
              ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
       ElseIf Round(NoRound(nTotMov,3),2) > 0
              ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
       EndIf
    EndIf
    @ li,aColunas[COL_SEPARA9]  PSAY "|"    
    @ li,aColunas[COL_SEPARA10] PSAY "|"
    li++

    nTotCCDeb := 0
    nTotCCCrd := 0                     
        
    If li > 58      
       If !lFirstPage
          @Prow()+1,00 PSAY Replicate("-",limite)
       EndIf
       CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
       lFirstPage := .F.             
    EndIf                        
    
    nRegTmp    := cArqTmp->(Recno())    
    dbSelectArea("cArqTmp")
    dbGoto(nRegTmp)                            
EndDO                           

@li,00 PSAY REPLICATE("-",limite)
li++                

If aReturn[5] = 1
    Set Printer To
    Commit
    Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
( cArqTmp )->( dbclearfilter() )
dbCloseArea()
If Select("cArqTmp") == 0
   //Ferase(cArqTmp+GetDBExtension())
   //FErase("cArqInd"+OrdBagExt())
EndIf    

FClose(nHandle)

dbselectArea("CT2")

MS_FLUSH()

/*/
±±³ Fun‡…o      ³Ctb591ImpQ³ Autor ³ Simone Mie Sato          ³ Data ³ 06/10/04 ³±±
±±³ Descri‡…o ³ Impressao dos Quadros finais do balancete                  ³±±
±±³ Sintaxe   ³ ImpQuadro()                                                ³±±
±±³ Uso          ³ SIGACTB                                                    ³±±
/*/
Static Function Ctb591ImpQ(Tamanho,lDigVer,dData,cMoeda,aQuadro,cDescMoeda,nomeprog,dDataLP,cPicture,nDecimais,lPrintZero,cTpSald,cCusto,cMascara2,cSepara2)

Local aSaveArea    := GetArea()
Local cData     :=    StrZero(Month(dData),2) +"/" + Str(Year(dData),4)
Local nTotMov    := 0
Local nResult    := 0
Local nPtmCorr  := 0
Local nPtmLiq   := 0
Local nReceita  := 0
Local nDespesa  := 0
Local nVal1        := 0
Local nVal2        := 0
Local nRectmp    := 0

Cabec1 := STR0023 // "QUADROS DEMONSTRATIVOS"
Cabec2 := " "

//³ Quadro 1: Totais do Ativo / Passivo.                         ³
Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 15 )

li++           

@li,00 PSAY "+" + Repl( "-", 100 ) + "+"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "|" + PadC( STR0024 , 100, " " ) + "|" // "TOTAIS DO ATIVO / PASSIVO"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++   
@li,00 PSAY "+" + Repl( "-", 100 ) + "|"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

DbSelectArea("CT1")
dbSeek( xFilial("CT1") +  aQuadro[1] ) // Totalizadora do Ativo - mv _par08
@li,00 PSAY "|"
If lDigVer 
//    @li,02 PSAY Mascara(Alltrim(aQuadro[1])+CT1->CT1_DC)
    EntidadeCTB(aQuadro[1],li,02,28,.F.,cMascara2,cSepara2)
Else                                                     
    EntidadeCTB(CT1->CT1_CONTA,li,02,28,.F.,cMascara2,cSepara2)
//    @li,02 PSAY Mascara(CT1->CT1_CONTA)
EndIf    

@li,035 PSAY STR0025 // "Total do Ativo"

dbSelectArea("cArqTmp")
dbSetOrder(1)
nRecTmp    := Recno()

MsSeek(cCusto+aQuadro[1])
nTotMov    := SALDOATU
ValorCTB(nTotMov,li,80,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)

dbGoto(nRecTmp)    

@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

DbSelectArea("CT1")
MsSeek( xFilial("CT1")+ aQuadro[2]) //Totalizadora do Passivo - mv_par09
@li,00 PSAY "|"

If lDigVer 
   EntidadeCTB(Alltrim(CT1->CT1_CONTA+CT1->CT1_DC),li,02,28,.F.,cMascara2,cSepara2)
Else
   EntidadeCTB(Alltrim(CT1->CT1_CONTA),li,02,28,.F.,cMascara2,cSepara2)
EndIf

@li,35 PSAY STR0026 // "Total do Passivo"
dbSelectArea("cArqTmp")
dbSetOrder(1)
nRecTmp    := Recno()

If MsSeek(cCusto+aQuadro[2])
   nTotMov    := SALDOATU
   ValorCTB(nTotMov,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
EndIf             

dbGoto(nRecTmp)
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "+" + Repl( "-", 100 ) + "+"

//³ Quadro 2: Demonstracao de resultados                         ³
li += 4

@li,00 PSAY "+" + Repl( "-", 100 ) + "+"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "|" + PadC( STR0027 , 100, " " ) + "|" // "DEMONSTRATIVO DE RESULTADOS - MENSAL"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++ 
@li,00 PSAY "+" + Repl( "-", 100 ) + "|"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

DbSelectArea("CT1")
dbSeek( xFilial("CT1") + aQuadro[3] ) // Resultado a debito

@li,00 PSAY "|"

If lDigVer 
   //@li,02 PSAY Mascara(Alltrim(CT1->CT1_CONTA)+CT1->CT1_DC)
   EntidadeCTB(Alltrim(CT1->CT1_CONTA+CT1->CT1_DC),li,02,28,.F.,cMascara2,cSepara2)
Else
   //@li,02 PSAY Mascara(CT1->CT1_CONTA)
   EntidadeCTB(CT1->CT1_CONTA,li,02,28,.F.,cMascara2,cSepara2)
EndIf    

@li,35 PSAY OemToAnsi(STR0028)  + OemToAnsi(STR0039) // "CONTAS DE RESULTADO - "

DbSelectArea("cArqTmp")
DbSetOrder(1)

If MsSeek(cCusto+aQuadro[3])
   nTotMov    := MOVIMENTO
   nVal1     := SALDOATU
   ValorCTB(nTotMov,li,80,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
Endif    

nResult := nTotMov

@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

DbSelectArea("CT1")
MsSeek( xFilial("CT1") + aQuadro[4] ) // Resultado a credito

@li,00 PSAY "|"

If lDigVer 
   //@li,02 PSAY Mascara(Alltrim(CT1->CT1_CONTA)+CT1->CT1_DC)
   EntidadeCTB(Alltrim(CT1->CT1_CONTA+CT1->CT1_DC),li,02,28,.F.,cMascara2,cSepara2)
Else
   //@li,02 PSAY Mascara(CT1->CT1_CONTA)
   EntidadeCTB(CT1->CT1_CONTA,li,02,28,.F.,cMascara2,cSepara2)
EndIf    

@li,35 PSAY STR0028  + STR0029 // "CONTAS DE RESULTADO - "
DbSelectArea("cArqTmp")
DbSetOrder(1)

If MsSeek(cCusto+aQuadro[4])
   nTotMov    := MOVIMENTO
   nVal2    := SALDOATU
Else
   nTotMov    := 0 
Endif                  

ValorCTB(nTotMov,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)

nResult    += nTotMov

DbSelectArea("CT1")
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

@li,00 PSAY "|"
@li,02 PSAY STR0030 + cData // "RESULTADO DO MES "

ValorCTB(nResult,li,80,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

@li,00 PSAY "|"
@li,02 PSAY STR0031 + cData  // "RESULTADO ACUMULADO ATE "
nTotMov    := nVal1+nVal2
ValorCTB(nTotMov,li,80,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "+" + Repl( "-", 100 ) + "+"

//Quadro 3: Demonstracao de Patrimonio Liquido destacado
Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 15 )

@li,00 PSAY "+" + Repl( "-", 100 ) + "+"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "|" + PadC( STR0032, 100, " " ) + "|" // "DEMONSTRACAO DO PATRIMONIO LIQUIDO DESTACADO"
li++         
@li,00 PSAY "|" + PadC( STR0033 + cData, 100, " " ) + "|" // "PARA O MES "
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "+" + Repl( "-", 100 ) + "|"
li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

//Procura a conta de patrimonio Liquido.
MsSeek( xFilial("CT1") + aQuadro[5] )

@ li,00 PSAY STR0034 // "| PATRIMONIO LIQUIDO"
DbSelectArea("cArqTmp")
DbSetOrder(1)

If MsSeek(cCusto+aQuadro[5])
   nPtmLiq := SALDOATU
   ValorCTB(nPtmLiq,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
Endif                   

DbSelectArea("CT1")
@ li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

//³ Procura a conta de receita.                                  ³
dbSeek( xFilial("CT1") + aQuadro[6] )

@li,00 PSAY STR0035 // "| TOTAL DA RECEITA"
DbSelectArea("cArqTmp")
DbSetOrder(1)

If MsSeek(cCusto+aQuadro[6])
   nReceita := SALDOATU
   ValorCTB(nReceita,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
Endif

DbSelectArea("CT1")    
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

//³ Procura a conta de despesa.                                  ³
MsSeek( xFilial("CT1") + aQuadro[7] )

@li,00 PSAY STR0036 // "| TOTAL DA DESPESA"
DbselectArea("cArqTmp")
DbSetOrder(1)
If MsSeek(cCusto+aQuadro[7])
    nDespesa := SALDOATU
    ValorCTB(nDespesa,li,80,17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
Endif
DbSelectArea("CT1")    
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

//³ Calcula o patrimonio liquido corrigido.                      ³
nPtmCorr := nPtmLiq + nReceita + nDespesa
@li,00 PSAY STR0037+cData // "| PATRIMONIO LIQUIDO CORRIGIDO " + cData
ValorCTB(nPtmCorr,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++

//³ Calcula Lancamento de Correcao                                  ³
nLctoCorr := nPtmLiq + ( nReceita + nDespesa )
@li,00 PSAY STR0038 // "| LANCAMENTO DE CORRECAO"
ValorCTB(nLctoCorr,li,80,17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
@li,101 PSAY "|"

li++
@li,00 PSAY "|" + Repl( " ", 100 ) + "|"
li++
@li,00 PSAY "|" + Repl( "-", 100 ) + "|"
li++

/* Modo de construcao do quadro 3 - conforme analise SBPS
1 - Patrimonio liquido
6.0.0.00.00.2

2 - Receita
7.0.0.00.00.9

3 - Despesa
8.0.0.00.00.6

4 - Patrimonio Liquido corrigido ate a data
1 + 2 + 3

6 - Lancamento de correcao
1 + ( 2 + 3 ) 
*/

RestArea(aSaveArea)

Return

Static Function ExReport( cRelatorio/*, cParameters*/ )
//  cString := "java -jar "+'"'+cRelatorio+'"'//+" "+'"'+"'"+cParameters+"'"+'"'
//  winexec(&(ReadVar()):=cString)                
Return

Static Function CallAppJava()
//Local nPergunta := "IRIND" 
//Local cDirFile  := "D:\Desenv\RPN\Relat\BLCT_CCICCV\dist\BLCT_CCICCV.jar"           
//Pergunte( nPergunta, .T. )
//cParameters := MV_PAR01
//ExReport( cDirFile )

Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        CALLAPPJAVA()
        CTB591IMPQ()
        EXREPORT()
        lRecursa := __Dummy( .F. )
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
