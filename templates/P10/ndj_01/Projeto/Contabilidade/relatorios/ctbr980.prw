#Include "CTBR480.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR 17
#DEFINE TAM_CONTA 17

/*
-----------------------------------------------------------------------------
Função ...................: CTBR980
Descrição ................: Emissão do Razão por Visão Contábil
Início Desenvolvimento ...: 04/05/2011
Término Desenvolvimento ..: 
Retorno ..................: Nenhum
Uso ......................: Generico
Parametros ...............: Nenhum                                           
-----------------------------------------------------------------------------
*/
User Function CTBR980( cItemIni ,; 
                       cItemFim ,; 
                       dDataIni ,; 
                       dDataFim ,; 
                       cMoeda   ,; 
                       cSaldo   ,;
                       cBook    ,;
                       cContaIni,; 
                         cContaFim,; 
                         lCusto   ,; 
                       cCustoIni,; 
                         cCustoFim,;
                         lCLVL    ,;
                         cCLVLIni ,;
                         cCLVLFim ,;
                         lSalLin  )
   
Return CTBR980R3( cItemIni ,; 
                  cItemFim ,; 
                  dDataIni ,; 
                  dDataFim ,; 
                  cMoeda   ,;
                  cSaldo   ,;
                  cBook    ,;
                  cContaIni,; 
                  cContaFim,; 
                    lCusto   ,; 
                  cCustoIni,; 
                  cCustoFim,; 
                  lCLVL    ,;
                  cCLVLIni ,;
                  cCLVLFim ,;
                  lSalLin )

/* ------------------------------------------------------------------------------------- */
Static Function CTBR980R3( cItemIni ,;
                           cItemFim ,;
                           dDataIni ,;
                           dDataFim ,;
                           cMoeda   ,;
                           cSaldo   ,;
                           cBook    ,;
                           cContaIni,; 
                           cContaFim,;
                           lCusto   ,; 
                           cCustoIni,;
                           cCustoFim,;
                           lCLVL    ,;
                           cCLVLIni ,;
                           cCLVLFim ,;
                           lSalLin )
/* ------------------------------------------------------------------------------------- */
Local aCtbMoeda        := {}
Local WnRel            := "CTBR980" 
Local cSayCusto        := CtbSayApro("CTT")

Local cSayItem        := OemToAnsi( "Visão Contábil" ) 

Local cSayClVl        := CtbSayApro("CTH")
Local cDesc1        := STR0001 + Alltrim(cSayItem) 
Local cDesc2        := STR0002                       
Local cString        := "CT2"

Local titulo        := STR0006 + Alltrim(cSayItem) 

Local lRet            := .T.
Local lExterno        := cItemIni <> Nil

Local nTamLinha        := 220

Default lCusto        := .T.
Default lCLVL        := .T.
Default lSalLin        := .T.

Private aReturn        := { STR0004, 1,STR0005, 2, 2, 1, "", 1 } //"Zebrado"###"Administracao"
Private aLinha        := {}

Private cPerg        := "CTR980"

Private nLastKey    := 0

Private Tamanho        := "G"    
Private lSaltLin    := .T.
Private NomeProg    := "CTBR980"

If ( !AMIIn(34) )
    Return
EndIf

If !lExterno
   If ! Pergunte( cPerg, .T. )
      Return
   Endif
Else
   Pergunte( cPerg, .F.)
Endif
        
/* ------------------------------------------------------------ */
// mv_par01            // Do Item Contabil                      
// mv_par02            // Ate o Item Contabil                   
// mv_par03            // da data                               
// mv_par04            // Ate a data                            
// mv_par05            // Moeda                                    
// mv_par06            // Saldos                                   
// mv_par07            // Set Of Books                          
// mv_par08            // Analitico ou Resumido dia (resumo)    
// mv_par09            // Imprime conta sem movimento?          
// mv_par10            // Imprime Cod (Normal / Reduzida)       
// mv_par11            // Totaliza tb por Conta?                
// mv_par12            // Da Conta                              
// mv_par13            // Ate a Conta                           
// mv_par14            // Imprime Centro de Custo?                    
// mv_par15            // Do Centro de Custo                    
// mv_par16            // Ate o Centro de Custo                 
// mv_par17            // Imprime Classe de Valor?                  
// mv_par18            // Da Classe de Valor                    
// mv_par19            // Ate a Classe de Valor                 
// mv_par20            // Salta folha por Item?                 
// mv_par21            // Pagina Inicial                        
// mv_par22            // Pagina Final                          
// mv_par23            // Numero da Pag p/ Reiniciar                   
// mv_par24            // Imprime Cod. CCusto(Normal/Reduzido)  
// mv_par25            // Imprime Cod. Item (Normal/Reduzido)   
// mv_par26            // Imprime Cod. Cl.Valor(Normal/Reduzido)               
// mv_par27            // Imprime Valor 0.00                                  
/* ------------------------------------------------------------ */

// Analitico ou Resumido dia (resumo)
lAnalitico := Iif( mv_par08 == 1, .T., .F. ) 

Tamanho       := If( lAnalitico .and. (lCusto .or. lClvl), Tamanho, "M")
nTamLinha  := If( lAnalitico .and. (lCusto .or. lClvl), 220, 132)

wnrel      := SetPrint(cString,wnrel,If (!lExterno,cPerg,),@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If ! lExterno
   //Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC480S
   lCusto  := Iif(mv_par14 == 1,.T.,.F.)
   lCLVL   := Iif(mv_par17 == 1,.T.,.F.)

Else 
  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
  mv_par01 := cItemIni
  mv_par02 := cItemFim
  mv_par03 := dDataIni
  mv_par04 := dDataFim
  mv_par05 := cMoeda
  mv_par06 := cSaldo
  mv_par07 := cBook
  mv_par12 := cContaIni
  mv_par13 := cContaFim
  mv_par14 := If(lCusto =.T.,1,2)
  mv_par15 := cCustoIni
  mv_par16 := cCustoFim
  mv_par17 := If(lClVl =.T.,1,2)
  mv_par18 := cClVlIni
  mv_par19 := cClVlFim
  MV_PAR28 := Iif(lSalLin == .T.,1,2)

  If Empty( mv_par01 ) .And. Empty( mv_par02 )      

      MsgAlert( "Não há dados a exibir" )
     RETURN .F.
  EndIf  
Endif    

lSaltLin    := If(MV_PAR28==1,.T.,.F.)

lAnalitico    := Iif(mv_par08==1,.T.,.F.) //Analitico ou Resumido dia (resumo)

Tamanho        := If( lAnalitico .and. (lCusto .or. lClvl), Tamanho, "M")
nTamLinha    := If( lAnalitico .and. (lCusto .or. lClvl), 220, 132)

If aReturn[4] == 2    //Se forçar formato paisagem

   Tamanho     := "G"
   nTamLinha := 220
EndIf    

If nLastKey = 27

   Set Filter To
   Return
Endif

/* ---------------------------------------------------------- */
// Verifica se usa Set Of Books -> Conf. da Mascara / Valores  
/* ---------------------------------------------------------- */
If ! Ct040Valid(mv_par07)

   lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par07)
EndIf

If lRet

   aCtbMoeda  := CtbMoeda(mv_par05)

   If Empty(aCtbMoeda[1])

      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If ! lRet    

   Set Filter To
   Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27

   Set Filter To
   Return
Endif

RptStatus( {|lEnd| CTR980Imp( @lEnd      , wnRel , cString  , aSetOfBook, lCusto   , lCLVL   ,;
                               lAnalitico, Titulo, nTamlinha, aCtbMoeda , cSayCusto, cSayItem,;
                               cSayClVl ) } )
Return 

/* --------------------------------------------------------------- */
Static Function CTR980Imp( lEnd      ,;
                           WnRel     ,;
                           cString   ,;
                           aSetOfBook,;
                           lCusto    ,;
                           lCLVL     ,;
                           lAnalitico,;
                           Titulo    ,;
                           nTamlinha ,;
                           aCtbMoeda ,;
                           cSayCusto ,;
                           cSayItem  ,;
                           cSayClvl )
/*
Parametros lEnd       - Acao do Codeblock                             
           wnRel      - Nome do Relatorio                             
           cString    - Mensagem                                      
           aSetOfBook - Array de configuracao set of book             
           lCusto     - Imprime Centro de Custo?                      
           lCLVL      - Imprime Classe de Valor?                      
           lAnalitico - Imprime Analitico ou Sintetico?               
           Titulo     - Titulo do Relatorio                           
           nTamLinha  - Tamanho da linha                              
           aCtbMoeda  - Array da Moeda                               
           cSayCusto  - Nomenclatura utilizada para o Centro de Custo 
           cSayItem   - Nomenclatura utilizada para o Item            
           cSayClVl   - Nomenclatura utilizada para a Classe de valor 
*/           
/* --------------------------------------------------------------- */                           

Local CbTxt
Local cbcont
Local Cabec1        := ""
Local Cabec2        := ""

Local aSaldo        := {} 
Local aSaldoAnt        := {}
Local aColunas

Local cDescMoeda
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cPicture
Local cSepara1        := ""
Local cSepara2        := ""
Local cSepara3        := ""
Local cSepara4        := ""
Local cSaldo        := mv_par06
Local cItemIni        := mv_par01
Local cItemFim        := mv_par02
Local cContaIni        := mv_par12
Local cContaFIm        := mv_par13
Local cCustoIni        := mv_par15
Local cCustoFim        := mv_par16
Local cCLVLIni        := mv_par18
Local cCLVLFim        := mv_par19
Local cContaAnt        := ""
Local cCodRes        := ""
Local cResCC        := ""
Local cResItem         := ""
Local cResCLVL        := ""        
Local cMoeda        := mv_par05
Local cArqTmp
Local cNormal         := ""

Local dDataAnt        := CTOD("  /  /  ")
Local dDataIni        := mv_par03
Local dDataFim        := mv_par04        

Local lNoMov        := Iif(mv_par09 == 1,.T.,.F.)
Local lSalto        := Iif(mv_par20 == 1,.T.,.F.)
Local lPrintZero    := Iif(mv_par27 == 1,.T.,.F.)
Local lTotConta

Local nDecimais
Local nTotDeb        := 0
Local nTotCrd        := 0
Local nReinicia     := mv_par23
Local nPagFim        := mv_par22
Local nVlrDeb        := 0
Local nVlrCrd        := 0

Local lQbPg            := .F.
Local l1StQb         := .T.
Local nPagIni        := mv_par21
Local lFirst        := .T.
Local lEmissUnica    := If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.) // U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lNewPAGFIM    := If(nReinicia > nPagFim,.T.,.F.)
Local nBloco        := 0
Local nBlCount        := 0
Local nSpacCta        := 70

m_pag := 1

If lEmissUnica

   CtbQbPg( .T., @nPagIni, @nPagFim, @nReinicia, @m_pag, @nBloco, @nBlCount )
EndIf

cbtxt        := SPACE(10)
cbcont        := 0
li           := 80

cDescMoeda     := Alltrim(aCtbMoeda[2])
nDecimais     := DecimalCTB(aSetOfBook,cMoeda)

//Mascara do Item Contabil
If Empty(aSetOfBook[7])

   cMascara3 := ""
Else
   cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
EndIf

//Mascara da Conta
If Empty(aSetOfBook[2])

   cMascara1 := GetMv("MV_MASCARA")
Else
   cMascara1 := RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf
 
//Mascara do Centro de Custo
If lCusto

   If Empty(aSetOfBook[6])

        cMascara2 := GetMv("MV_MASCCUS")
   Else
         cMascara2 := RetMasCtb(aSetOfBook[6],@cSepara2)
   EndIf                                                
Endif 

//Mascara da Classe de Valor
If lCLVL

   If Empty(aSetOfBook[8])

      cMascara4 := ""
   Else
        cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
   EndIf
EndIf    

cPicture := aSetOfBook[4]

//Titulo do Relatorio
If Type("NewHead")== "U"

   Titulo := STR0007 + Upper(Alltrim(cSayItem)) //"RAZAO POR ITEM  "

   IF lAnalitico
    
      Titulo += STR0008 //"ANALITICO EM"
   Else
      Titulo += STR0021 //"SINTETICO EM"
   EndIf

   Titulo += cDescMoeda + space(01)+ STR0009 + space(01) + DTOC(dDataIni) +; //"DE"
                          space(01)+ STR0010 + space(01) + DTOC(dDataFim)     //"ATE"
    
   If mv_par06 > "1"
   
      Titulo += " (" + Tabela("SL", mv_par06, .F.) + ")"
   EndIf
Else

   Titulo := NewHead
EndIf
    
/* ---------------------------------------------------------------------------------------------------------------------- */
// Resumido
// DATA                                                                             DEBITO               CREDITO            SALDO ATUAL
// XX/XX/XXXX                                                           99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22

// Cabecalho Conta
// DATA
// LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL
// XX/XX/XXXX         
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 9999999999999.99 9999999999999.99 9999999999999.99D
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16    

// Cabecalho Conta + Item + Classe de Valor
// DATA
// LOTE/DOC/LINHA  H I S T O R I C O                        C/PARTIDA                      CENTRO DE CUSTO      CLASSE DE VALOR                     DEBITO               CREDITO           SALDO ATUAL
// XX/XX/XXXX 
// XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22
/* ---------------------------------------------------------------------------------------------------------------------- */
#DEFINE     COL_NUMERO              1
#DEFINE     COL_HISTORICO         2
#DEFINE     COL_CONTRA_PARTIDA     3
#DEFINE     COL_CENTRO_CUSTO       4
#DEFINE     COL_CLASSE_VALOR       5 
#DEFINE     COL_VLR_DEBITO         6
#DEFINE     COL_VLR_CREDITO         7
#DEFINE     COL_VLR_SALDO           8
#DEFINE     TAMANHO_TM            9
#DEFINE     COL_VLR_TRANSPORTE  10

If aReturn[4] == 1 .and. !lCusto .and. !lClVl

   If mv_par10 == 2

         nSpacCta := Len(CT1->CT1_RES)+Len(ALLTRIM(cMascara1))
   Else
        nSpacCta := Len(CT1->CT1_CONTA)
   EndIf
EndIf

If ! lAnalitico

   aColunas := { 000, 019,    ,    ,    , 069, 091, 113, 18, 090 }
Else
   If lCusto .or. lClvl

      aColunas     := { 000, 019, 060, 131, 152, 172, 188, 204, 14,176 }
   Else
         aColunas     := { 000, 019, 060, 0  ,0   , 82 , 98 , 114, 14, 110 }    
      aColunas[6]  := aColunas[3] + nSpacCta
      aColunas[7]  := aColunas[6] + 16
      aColunas[8]  := aColunas[7] + 16
      aColunas[10] := aColunas[7] + 12
   EndIf    
Endif

If lAnalitico            // Relatorio Analitico

   Cabec1  := STR0019    // "DATA"
   Cabec2  := STR0013    // "LOTE/DOC/LINHA    H I S T O R I C O                        C/PARTIDA                    C.CUSTO              CLASSE DE VALOR                      DEBITO                CREDITO            SALDO ATUAL"

   If lCusto .or. lClVl

      Cabec2 += Space(62) + Upper(cSayCusto)+Space(11)+Upper(cSayClvl)+Space(18)
   Else
      Cabec2 += Space(aColunas[6]-aColunas[3])
   EndIf

   Cabec2 += STR0026
Else
   lCusto := .F.
   lCLVL  := .F.

   Cabec1 := STR0025 //"DATA                                                                                                                              DEBITO           CREDITO       SALDO ATUAL"
   Cabec1 := STUFF( Cabec1, AT( "DATA"   , Cabec1 ), 4, "    "    )
   Cabec1 := STUFF( Cabec1, AT( "CREDITO", Cabec1 ), 7, "       " )
   Cabec1 := STUFF( Cabec1, AT( "SALDO"  , Cabec1 ), 5, "     "   )
   Cabec1 := STUFF( Cabec1, AT( "ATUAL"  , Cabec1 ), 5, "     "   )    
EndIf    

m_pag := mv_par21

//Monta Arquivo Temporario para Impressao

MsgMeter({|    oMeter, oText, oDlg, lEnd | ;
            CTBGerRaz( oMeter    ,;
                       oText     ,;
                       oDlg      ,;
                       lEnd      ,;
                       @cArqTmp  ,;
                       cContaIni ,;
                       cContaFim ,;
                       cCustoIni ,;
                       cCustoFim ,;
                        cItemIni  ,;
                        cItemFim  ,;
                        cCLVLIni  ,;
                        cCLVLFim  ,;
                        cMoeda    ,;
                        dDataIni  ,;
                        dDataFim  ,;
                        aSetOfBook,;
                        lNoMov    ,;
                        cSaldo    ,;
                        .T.       ,;
                        "3"       ,;
                        lAnalitico,,,aReturn[7])},;
              STR0018,;                      // "Criando Arquivo Temporario..."
            STR0006+(Alltrim(cSayItem)))  // "Emissao do Razao"
                
dbSelectArea("cArqTmp")
SetRegua(RecCount())
dbGoTop()

//Se tiver parametrizado com Plano Gerencial,
//exibe a mensagem que o Plano Gerencial nao 
//esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       

   dbCloseArea()
   FErase(cArqTmp+GetDBExtension())
   FErase(cArqTmp+OrdBagExt())    
   Return
Endif

While !Eof()

  IF lEnd
     @Prow()+1,0 PSAY STR0015  //"***** CANCELADO PELO OPERADOR *****"
     Exit
  EndIF

  IncRegua()

  //Se imprime centro de custo, ira considerar o filtro do centro de custo para calculo do saldo ant. 

  If lCusto     
       aSaldoAnt := SaldTotCT2(cArqTmp->ITEM,cArqTmp->ITEM,cCustoIni,cCustoFim,cContaIni,cContaFim,;
     dDataIni,cMoeda,cSaldo)
    
     aSaldo    := SaldTotCT2(cArqTmp->ITEM,cArqTmp->ITEM,cCustoIni,cCustoFim,cContaIni,cContaFim,;
     cArqTmp->DATAL,cMoeda,cSaldo)    
  Else        
     aSaldoAnt := SaldTotCT2(cArqTmp->ITEM,cArqTmp->ITEM,space(Len(CTT->CTT_CUSTO)),Repl('Z',Len(CTT->CTT_CUSTO)),;
     cContaIni,cContaFim,dDataIni,cMoeda,cSaldo)
    
     aSaldo    := SaldTotCT2(cArqTmp->ITEM,cArqTmp->ITEM,space(Len(CTT->CTT_CUSTO)),Repl('Z',Len(CTT->CTT_CUSTO)),;
     cContaIni,cContaFim,cArqTmp->DATAL,cMoeda,cSaldo)
  EndIf  
    
  If ! lNoMov //Se imprime sem movimento

     If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 

        dbSelectArea("cArqTmp")
        dbSkip()
        Loop
     Endif    
  Endif             
    
  If lNomov .And. aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
     If CtbExDtFim("CTD")             
        dbSelectArea("CTD")
        dbSetOrder(1)
        SET FILTER TO CTD->CTD_XVISAO == "1"
            
        If MsSeek(xFilial()+cArqTmp->ITEM)
             If !CtbVlDtFim("CTD",dDataIni)         

              dbSelectArea("cArqTmp")
              dbSkip()
              Loop                                
           EndIf
        EndIf
        dbSelectArea("cArqTmp")
     EndIf
  EndIf
    
  If li > 56 .Or. lSalto              
     If lEmissUnica    
        CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)        /// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
     Else
        If m_pag > nPagFim
            If lNewPAGFIM
              nPagFim := m_pag+nPagFim        
              If l1StQb                            //// SE FOR A 1ª QUEBRA
                 m_pag := nReinicia
                 l1StQb := .F.                    //// INDICA Q NÃO É MAIS A 1ª QUEBRA
              Endif
           Else
              m_pag := nReinicia
           Endif
        EndIf    
     Endif

     CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
        
     If !lFirst        
        lQbPg  := .T.
     Else
        lFirst := .F.
     Endif
  EndIf

  nSaldoAtu    := 0
  nTotDeb    := 0
  nTotCrd    := 0
    
  //"Visão 
  @li,011 PSAY Upper(cSayItem) + " - "         

  dbSelectArea("CTD")
  dbSetOrder(1)
    
  SET FILTER TO CTD->CTD_XVISAO == "1"       
    
  dbSeek(xFilial()+cArqTMP->ITEM)
  cResItem := CTD->CTD_RES

  If mv_par25 == 1 //Se imprime cod. normal item
      EntidadeCTB(cArqTmp->ITEM,li,pcol()+2,20,.F.,cMascara3,cSepara3)    
  Else
     EntidadeCTB(cResItem,li,pcol()+2,20,.F.,cMascara3,cSepara3)        
  Endif

  @ li, pCol()+2 PSAY "- " + CtbDescMoeda("CTD->CTD_DESC"+cMoeda)                     
                                                                                        
  If lAnalitico
     @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0027) - 1;
     PSAY STR0027 //"SALDO ANTERIOR: "        
  Else
     @li,aColunas[COL_VLR_CREDITO]  PSAY STR0027 //"SALDO ANTERIOR: "
  EndIf    

  //Impressao do Saldo Anterior do Item.
  ValorCTB(aSaldoAnt[6],li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture)

  nSaldoAtu := aSaldoAnt[6]
  If lSaltLin

     li += 2  
  Else         
     li += 1         
  EndIf
  dbSelectArea("cArqTmp")
    
  cItemAnt := cArqTmp->ITEM
  While cArqTmp->(!Eof()) .And. cArqTmp->ITEM == cItemAnt

        lQbPg      := .T.
        cContaAnt := cArqTmp->CONTA
        dDataAnt  := cArqTmp->DATAL                      
        
        If lAnalitico
         
           nTotCtaDeb := 0
           nTotCtaCrd := 0
        
           If ! Empty(cArqTmp->CONTA)

                If lSaltLin

                   li++
                EndIf
                @li,000 PSAY STR0024 // "CONTA - "
            
                dbSelectArea("CT1")
                dbSetOrder(1)
                dbSeek(xFilial()+cArqTmp->CONTA)
                cCodRes := CT1->CT1_RES
                cNormal := CT1->CT1_NORMAL
        
                If mv_par10 == 1 // Imprime Cod Normal

                   EntidadeCTB(cArqTmp->CONTA,li,pcol()+2,nSpacCta,.F.,cMascara1,cSepara1)
                Else
                   EntidadeCTB(cCodRes,li,pcol()+2,20,.F.,cMascara1,cSepara1)
                EndIf

                @ li, pCol()+2 PSAY CtbDescMoeda("CT1->CT1_DESC"+cMoeda)
                
                 If lSaltLin
                   li+=2            
                Else
                   li+=1
                EndIf
           Endif

           If lQbPg
              @li,000 PSAY cArqTmp->DATAL
              lQbPg := .F.
           EndIf
           
           If ! Empty(cArqTmp->CONTA)
                 li++
           Endif
                    
           lTotConta := .F.
           While cArqTmp->(!Eof()) .And. cArqTmp->ITEM == cItemAnt .And. cArqTmp->CONTA == cContaAnt
        
                If li > 56  
                 
                    If lSaltLin
                    
                          li++
                    EndIf

                    @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1 PSAY STR0022 //"A TRANSPORTAR : "
                    ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)

                    If lEmissUnica
                         CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)        /// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
                    Else
                       If m_pag > nPagFim
                          If lNewPAGFIM
                             nPagFim := m_pag+nPagFim        
                             If l1StQb                            //// SE FOR A 1ª QUEBRA
                                m_pag := nReinicia
                                l1StQb := .F.                    //// INDICA Q NÃO É MAIS A 1ª QUEBRA
                             Endif
                          Else
                              m_pag := nReinicia
                          Endif
                       EndIf                        
                    EndIf
                    CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
                    lQbPg := .T.
            
                    @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1;
                    PSAY STR0023    //"A TRANSPORTAR : "
                    ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
                    li++
                EndIf            
                
                nSaldoAtu     := nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
                nTotDeb        += cArqTmp->LANCDEB
                nTotCrd        += cArqTmp->LANCCRD
                nTotCtaDeb  += cArqTmp->LANCDEB
                nTotCtaCrd  += cArqTmp->LANCCRD
    
                // Imprime os lancamentos para a conta 
                If dDataAnt != cArqTmp->DATAL
                    
                    If lSaltLin
                
                       li+=2 
                    EndIf
                    
                    @li,000 PSAY cArqTmp->DATAL
                    li++
                    dDataAnt := cArqTmp->DATAL
                ElseIf lQbPg

                    @li,000 PSAY dDataAnt
                    li++
                    lQbPg := .F.
                EndIf    
                
                @li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+;
                                              cArqTmp->DOC+cArqTmp->LINHA

                //Robert - 10/05/2011 - Substituir a expressão item contábil por visão contábil
                If Left(Upper(Subs(cArqTmp->HISTORICO,1,40)),10) == "ITEM CONTA"
                
                      @ li,aColunas[COL_HISTORICO] PSAY OemToAnsi("VISÃO CONTÁBIL")+Subs(cArqTmp->HISTORICO,11,40)
                Else
                      @ li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,01,40)
                EndIf

                dbSelectArea("CT1")
                dbSetOrder(1)
                dbSeek(xFilial()+cArqTmp->XPARTIDA)
                cCodRes := CT1->CT1_RES

                If mv_par10 == 1

                   EntidadeCTB(cArqTmp->XPARTIDA,li,aColunas[COL_CONTRA_PARTIDA],nSpacCta,.F.,cMascara1,cSepara1)
                Else
                   EntidadeCTB(cCodRes,li,aColunas[COL_CONTRA_PARTIDA],20,.F.,cMascara1,cSepara1)                
                Endif                              

                If lCusto                 //Se imprime centro de custo
                   
                   If mv_par24 == 1     //Se imprime cod. normal centro de custo
                      EntidadeCTB(cArqTmp->CCUSTO,li,aColunas[COL_CENTRO_CUSTO],20,.F.,cMascara2,cSepara2)
                   Else
                      dbSelectArea("CTT")
                      dbSetOrder(1)
                      dbSeek(xFilial()+cArqTMP->CCUSTO)  
                      cResCC := CTT->CTT_RES
                      EntidadeCTB(cResCC,li,aColunas[COL_CENTRO_CUSTO],20,.F.,cMascara2,cSepara2)
                   Endif
                Endif
                
                If lCLVL //Se imprime classe de valor
                   If mv_par26 == 1
                      EntidadeCTB(cArqTmp->CLVL,li,aColunas[COL_CLASSE_VALOR],20,.F.,cMascara4,cSepara4)
                   Else
                      dbSelectArea("CTH")
                      dbSetOrder(1)
                      dbSeek(xFilial()+cArqTmp->CLVL)                
                      cResClVl := CTH->CTH_RES                        
                      EntidadeCTB(cResClVl,li,aColunas[COL_CLASSE_VALOR],20,.F.,cMascara4,cSepara4)
                   Endif                    
                Endif
                
                ValorCTB(cArqTmp->LANCDEB,li,aColunas[COL_VLR_DEBITO],;
                                             aColunas[TAMANHO_TM],nDecimais,.F.,;
                                             cPicture,"1",,,,,,lPrintZero)
                                              
                ValorCTB(cArqTmp->LANCCRD,li,aColunas[COL_VLR_CREDITO],;
                                             aColunas[TAMANHO_TM],nDecimais,.F.,;
                                             cPicture,"2",,,,,,lPrintZero)
                                              
                ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
                                      aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero)

                // Procura pelo complemento de historico
                dbSelectArea("CT2")
                dbSetOrder(10)   
                
                SET FILTER TO Alltrim( CT2->CT2_XVISCT ) <> ''
                
                If   dbSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
                
                     dbSkip()
                    
                     If CT2->CT2_DC == "4"

                        While !Eof() .And. CT2->CT2_FILIAL  == xFilial()         .And.;
                                           CT2->CT2_LOTE   == cArqTMP->LOTE     .And.;
                                           CT2->CT2_SBLOTE == cArqTMP->SUBLOTE .And.;
                                           CT2->CT2_DOC    == cArqTmp->DOC     .And.;
                                           CT2->CT2_SEQLAN == cArqTmp->SEQLAN     .And.;
                                           CT2->CT2_EMPORI == cArqTmp->EMPORI    .And.;
                                           CT2->CT2_FILORI == cArqTmp->FILORI    .And.;
                                           CT2->CT2_DC     == "4"                 .And.;
                                      DTOS(CT2->CT2_DATA)  == DTOS(cArqTmp->DATAL)                        
                            li++
                            
                            If li > 56
                            
                                If lEmissUnica                                
                                
                                   //// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
                                   CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount) 
                                Else
                                   If m_pag > nPagFim
                                   
                                      If lNewPAGFIM
                                      
                                         nPagFim := m_pag+nPagFim        
                                         
                                         If l1StQb                //// SE FOR A 1ª QUEBRA

                                            m_pag := nReinicia
                                            l1StQb := .F.        //// INDICA Q NÃO É MAIS A 1ª QUEBRA
                                         Endif
                                      Else
                                      
                                         m_pag := nReinicia
                                      Endif
                                   EndIf                                    
                                EndIf
                                
                                CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
                                li++
                                @li,000 PSAY dDataAnt
                                li++
                            EndIf
                            
                            @li,aColunas[COL_NUMERO]      PSAY    CT2->CT2_LOTE+;
                                                                          CT2->CT2_SBLOTE+;
                                                                        CT2->CT2_DOC+;
                                                                        CT2->CT2_LINHA
                            @li,aColunas[COL_HISTORICO] PSAY Subs(CT2->CT2_HIST,1,40)
                            dbSkip()
                        EndDo    
                     EndIf    
                EndIf    
                dbSelectArea("cArqTmp")
                
                li++
            
                If li > 56
                
                   If lSaltLin
                      li++
                   EndIf
                    
                   @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1;
                   PSAY STR0022    //"A TRANSPORTAR : "
                   ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
                   
                   If lEmissUnica                     
                   
                       CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)        /// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
                   Else
                      If m_pag > nPagFim
                        If lNewPAGFIM
                           nPagFim := m_pag+nPagFim        
                           If l1StQb                            //// SE FOR A 1ª QUEBRA
                              m_pag := nReinicia
                              l1StQb := .F.                    //// INDICA Q NÃO É MAIS A 1ª QUEBRA
                           Endif
                        Else
                           m_pag := nReinicia
                        Endif
                      EndIf    
                   EndIf
                    
                   CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
            
                   @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1;
                   PSAY STR0023    //"A TRANSPORTAR : "
                   ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
                   li++
                   @li,000 PSAY dDataAnt
                   li++
                   lQbPg := .F.                  
                   EndIf                       
                   
                 lTotConta := ! Empty(cArqTmp->CONTA)
                dbSelectArea("cArqTmp")
                dDataAnt  := cArqTmp->DATAL
                dbSkip()
           EndDo          
   
           If lTotConta .And. mv_par11 == 1                        // Totaliza tb por Conta
              If lSaltLin
                 li += 1   
              EndIf
              
              @li,aColunas[If(lAnalitico,COL_HISTORICO,COL_NUMERO)] PSAY STR0020  //"T o t a i s  d a  C o n t a  ==> " 
              ValorCTB(nTotCtaDeb,li,aColunas[COL_VLR_DEBITO] ,aColunas[TAMANHO_TM],;
                       nDecimais,.F.,cPicture,"1",,,,,,lPrintZero)
              ValorCTB(nTotCtaCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],;
                       nDecimais,.F.,cPicture,"2",,,,,,lPrintZero)
            
              nTotCtaDeb := 0
              nTotCtaCrd := 0
            
              li++
              @li, 00 PSAY Replicate("-",nTamLinha)
           EndIf    
           If lTotConta
           
              li++
           Endif
        Else

            //Se for resumido
            dbSelectArea("cArqTmp")
            If ! Empty(cArqTmp->CONTA)
        
                CT1->(dbSeek(xFilial()+cArqTmp->CONTA))
                cCodRes := CT1->CT1_RES
                cNormal := CT1->CT1_NORMAL
            Else
                cNormal := ""
            Endif

            If li > 56
        
               If lSaltLin
        
                  li++
               EndIf
                    
               @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1 PSAY STR0022    //"A TRANSPORTAR : "
               ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO], aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
        
               If lEmissUnica    
        
                  CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)        /// FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
               Else            
                  If m_pag > nPagFim
        
                     If lNewPAGFIM
        
                        nPagFim := m_pag+nPagFim        
                        If l1StQb                            //// SE FOR A 1ª QUEBRA
        
                           m_pag := nReinicia
                           l1StQb := .F.                    //// INDICA Q NÃO É MAIS A 1ª QUEBRA
                        Endif
                     Else
                         m_pag := nReinicia
                     Endif
                  EndIf                    
               EndIf                    
        
               CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
        
               @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1 PSAY STR0023    //"A TRANSPORTAR : "
                ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
               li++
            EndIf
            
            @li,000 PSAY cArqTmp->DATAL
            
            While dDataAnt == cArqTmp->DATAL .And. cItemAnt == cArqTmp->ITEM

              nVlrDeb += cArqTmp->LANCDEB                                                 
              nVlrCrd += cArqTmp->LANCCRD                                                 
              dbSkip()                                                                                    
            End           
            
            nSaldoAtu := nSaldoAtu - nVlrDeb + nVlrCrd
            
            ValorCTB(nVlrDeb  ,li,aColunas[COL_VLR_DEBITO] ,aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1"    ,,,,,,lPrintZero)
            ValorCTB(nVlrCrd  ,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2"    ,,,,,,lPrintZero)
            ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO]  ,aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero)
            
            nTotDeb    += nVlrDeb
            nTotCrd    += nVlrCrd
            nVlrDeb    := 0
            nVlrCrd    := 0
        Endif                
        dbSelectArea("cArqTmp")

        li++
  EndDo
        
  If lSaltLin
     li += If(lAnalitico, 0, 1)
  EndIf
    
  If li > 56
  
        If lSaltLin
            li++
        EndIf
                    
        @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1;
                     PSAY STR0022    //"A TRANSPORTAR : "
                     
        ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
                              aColunas[TAMANHO_TM],nDecimais,;
                              .T.,cPicture,cNormal)
        If lEmissUnica              
  
           CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount) // FUNCAO PARA TRATAMENTO DA QUEBRA //.F. TRATA A QUEBRA/REINICIO
        Else

            If m_pag > nPagFim
            
                If lNewPAGFIM
                
                    nPagFim := m_pag+nPagFim        
                    
                    If l1StQb                            // SE FOR A 1ª QUEBRA

                        m_pag := nReinicia
                        l1StQb := .F.                    // INDICA Q NÃO É MAIS A 1ª QUEBRA
                    Endif
                Else
        
                    m_pag := nReinicia
                Endif
            EndIf            
        EndIf
  
        CtCGCCabec(.F.,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
        
        @li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1;
        PSAY STR0023    //"A TRANSPORTAR : "
        ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
        li++
  EndIf        

  @li,aColunas[If(lAnalitico,COL_HISTORICO,COL_NUMERO)] PSAY STR0017 + Upper(Alltrim(cSayItem)) + " ==> " //"T o t a i s   I t e m  ==> " 
    
  @li, pcol()+1 PSAY "( "     
    
  If mv_par25 ==1 //Imprime cod. normal Item 

      EntidadeCTB(cItemAnt,li,pcol()+2,20,.F.,cMascara3,cSepara3)
  Else
     dbSelectArea("CTD")
     dbSetOrder(1)            
     SET FILTER TO CTD->CTD_XVISAO == "1"       
        
     dbSeek(xFilial()+cItemAnt)  
     cResItem := CTD->CTD_RES
     EntidadeCTB(cResItem,li,pcol()+2,20,.F.,cMascara3,cSepara3)        
  Endif                           
  @li, pcol()+1 PSAY " )"

  ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,;
            .F.,cPicture,"1", , , , , ,lPrintZero)

  ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,;
           .F.,cPicture,"2", , , , , ,lPrintZero)

  ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,;
           .T.,cPicture, , , , , , ,lPrintZero)

  li+=2
        
  If lAnalitico

     li++
     @li, 00 PSAY Replicate("=",nTamLinha)

     If lSaltLin

          li += 2  
     Else         
        li += 1         
     EndIf
  Endif
  dbSelectArea("cArqTmp")
EndDo                       

If li != 80

   roda(cbcont,cbtxt,Tamanho)
EndIf

If aReturn[5] = 1

   Set Printer To
   Commit
   Ourspool(wnrel)
End

//-----------------------------------------------------------------------
//Robert - 09/05/2011 - Remoção do Filtro para controle da visão contábil
//dbSelectArea("CTD")
//Set Filter To
//-----------------------------------------------------------------------

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()

If Select("cArqTmp") = 0
   FErase(cArqTmp+GetDBExtension())
   FErase(cArqTmp+OrdBagExt())
EndIf    

dbselectArea("CT2")

MS_FLUSH()

Return

/*/
------------------------------------------------------------------------------
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
------------------------------------------------------------------------------
/*/
Static Function CtbGerRaz( oMeter    ,;
                           oText     ,;
                           oDlg      ,;
                           lEnd      ,;
                           cArqTmp   ,;
                           cContaIni ,;
                           cContaFim ,;
                           cCustoIni ,;
                           cCustoFim ,;
                           cItemIni  ,;
                           cItemFim  ,;
                           cCLVLIni  ,;
                           cCLVLFim  ,;
                           cMoeda    ,;
                           dDataIni  ,;
                           dDataFim  ,;
                           aSetOfBook,;
                           lNoMov    ,;
                           cSaldo    ,;
                           lJunta    ,;
                           cTipo     ,;
                           lAnalit   ,;
                           c2Moeda   ,;
                           nTipo     ,;
                           cUFilter  ,;
                           lSldAnt   ,;
                           aSelFil )
                          
Local aTamConta     := TAMSX3("CT1_CONTA")
Local aTamCusto     := TAMSX3("CT3_CUSTO") 
Local aTamVal     := TAMSX3("CT2_VALOR")
Local aCtbMoeda     := {}
Local aSaveArea  := GetArea()                       
Local aCampos
Local cChave
Local nTamHist     := Len(CriaVar("CT2_HIST"))
Local nTamItem     := Len(CriaVar("CTD_ITEM"))
Local nTamCLVL     := Len(CriaVar("CTH_CLVL"))
Local nDecimais     := 0    
Local cMensagem  := STR0030// O plano gerencial nao esta disponivel nesse relatorio. 
Local lCriaInd   := .F.
Local nTamFilial := TamSx3( "CT2_FILIAL" )[1]

DEFAULT c2Moeda  := ""
DEFAULT nTipo     := 1
DEFAULT cUFilter := ""
DEFAULT lSldAnt     := .F.
DEFAULT aSelFil  := {}    

dbSelectArea("CTD")
CTD->( DBSETORDER(1) )
SET FILTER TO CTD->CTD_XVISAO == "1"

#IFDEF TOP
If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"        
   DEFAULT cUFilter    := ".T."        
Else
#ENDIF

DEFAULT cUFilter    := ""

#IFDEF TOP
Endif
#ENDIF

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
                
aCampos :={    { "CONTA"        , "C", aTamConta[1] , 0 },;          // Codigo da Conta
            { "XPARTIDA"       , "C", aTamConta[1] , 0 },;            // Contra Partida
            { "TIPO"           , "C", 01            , 0 },;            // Tipo do Registro (Debito/Credito/Continuacao)
            { "LANCDEB"        , "N", aTamVal[1]+2 , nDecimais },; // Debito
            { "LANCCRD"        , "N", aTamVal[1]+2    , nDecimais },; // Credito
            { "SALDOSCR"    , "N", aTamVal[1]+2 , nDecimais },;    // Saldo
            { "TPSLDANT"    , "C", 01, 0 },;                     // Sinal do Saldo Anterior => Consulta Razao
            { "TPSLDATU"    , "C", 01, 0 },;                     // Sinal do Saldo Atual => Consulta Razao            
            { "HISTORICO"    , "C", nTamHist       , 0 },;            // Historico
            { "CCUSTO"        , "C", aTamCusto[1] , 0 },;            // Centro de Custo
            { "ITEM"        , "C", nTamItem        , 0 },;            // Item Contabil
            { "CLVL"        , "C", nTamCLVL        , 0 },;            // Classe de Valor
            { "DATAL"        , "D", 10            , 0 },;            // Data do Lancamento
            { "LOTE"         , "C", 06            , 0 },;            // Lote
            { "SUBLOTE"     , "C", 03            , 0 },;            // Sub-Lote
            { "DOC"         , "C", 06            , 0 },;            // Documento
            { "LINHA"        , "C", 03            , 0 },;            // Linha
            { "SEQLAN"        , "C", 03            , 0 },;            // Sequencia do Lancamento
            { "SEQHIST"        , "C", 03            , 0 },;            // Seq do Historico
            { "EMPORI"        , "C", 02            , 0 },;            // Empresa Original
            { "FILORI"        , "C", nTamFilial    , 0 },;            // Filial Original
            { "NOMOV"        , "L", 01            , 0 },;            // Conta Sem Movimento
            { "FILIAL"        , "C", nTamFilial    , 0 }} // Filial do sistema

If cPaisLoc $ "CHI|ARG"
   Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf
If ! Empty(c2Moeda)
   Aadd(aCampos, { "LANCDEB_1"    , "N", aTamVal[1]+2, nDecimais }) // Debito
   Aadd(aCampos, { "LANCCRD_1"    , "N", aTamVal[1]+2, nDecimais }) // Credito
   Aadd(aCampos, { "TXDEBITO"    , "N", aTamVal[1]+2, 6 }) // Taxa Debito
   Aadd(aCampos, { "TXCREDITO"    , "N", aTamVal[1]+2, 6 }) // Taxa Credito
Endif
                                                                    
//Se o arquivo temporario de trabalho esta aberto
If ( Select ( "cArqTmp" ) > 0 )
   cArqTmp->(dbCloseArea())
EndIf

cArqTmp  := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
lCriaInd := .T.

DbSelectArea("cArqTmp")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"            // Razao por Conta
    If FunName() <> "CTBC400"
        cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
    Else
        cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
    EndIf
ElseIf cTipo == "2"        // Razao por Centro de Custo                   
    If lAnalit             // Se o relatorio for analitico
        If FunName() <> "CTBC440"
            cChave     := "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
        Else
            cChave     := "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"        
        EndIf
    Else                                                                  
        cChave     := "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
    Endif
ElseIf cTipo == "3"     //Razao por Item Contabil      
    If lAnalit             // Se o relatorio for analitico               
        If FunName() <> "CTBC480"
            cChave     := "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
        Else
            cChave     := "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"        
        Endif
    Else                                                                  
        cChave     := "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
    Endif
ElseIf cTipo == "4"        //Razao por Classe de Valor    
    If lAnalit             // Se o relatorio for analitico               
        If FunName() <> "CTBC490"    
            cChave     := "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
        Else
            cChave     := "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
        EndIf
    Else                                                                  
        cChave     := "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
    Endif    
EndIf

dbSelectArea("cArqTmp")

If lCriaInd
    IndRegua("cArqTmp",cArqTmp,cChave,,,STR0017)  //"Selecionando Registros..."
    dbSelectArea("cArqTmp")
    dbSetIndex(cArqTmp+OrdBagExt())
Endif    
dbSetOrder(1)
                                                                                        
If !Empty(aSetOfBook[5])
    MsgAlert(cMensagem)    
    Return
EndIf                   

//CT2->(dbGotop())
#IFDEF TOP
    If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"        
        CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
                cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
                aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil)    
    Else
#ENDIF      
    // Monta Arquivo para gerar o Razao
    CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
             cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
             aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil)
#IFDEF TOP
    EndIf
#ENDIF    

RestArea(aSaveArea)

Return cArqTmp

/*/
Função     ³ CtbRazao
Descrição  ³ Realiza a "filtragem" dos registros do Razao
Sintaxe    ³ CtbRazao( oMeter   ,oText    ,oDlg    ,lEnd      ,cContaIni,cContaFim,
                       cCustoIni,cCustoFim,cItemIni,cItemFim  ,cCLVLIni ,cCLVLFim ,
                       cMoeda   ,dDataIni ,dDataFim,aSetOfBook,lNoMov   ,cSaldo   ,lJunta,
                       cTipo )                                                     
Retorno    ³ Nenhum                                                     
Uso        ³ SIGACTB                                                    
Parametros ³ ExpO1 = Objeto oMeter                                      
           ³ ExpO2 = Objeto oText                                       
           ³ ExpO3 = Objeto oDlg                                        
           ³ ExpL1 = Acao do Codeblock                                  
           ³ ExpC2 = Conta Inicial                                      
           ³ ExpC3 = Conta Final                                        
           ³ ExpC4 = C.Custo Inicial                                    
           ³ ExpC5 = C.Custo Final                                      
           ³ ExpC6 = Item Inicial                                       
           ³ ExpC7 = Cl.Valor Inicial                                   
           ³ ExpC8 = Cl.Valor Final                                     
           ³ ExpC9 = Moeda                                              
           ³ ExpD1 = Data Inicial                                       
           ³ ExpD2 = Data Final                                         
           ³ ExpA1 = Matriz aSetOfBook                                  
           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         
           ³ ExpC10= Tipo de Saldo                                      
           ³ ExpL3 = Indica se junta CC ou nao.                         
           ³ ExpC11= Tipo do lancamento                                 
           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       
           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       
/*/
Static Function CtbRazao( oMeter    ,;
                          oText     ,;
                          oDlg      ,;
                          lEnd      ,;
                          cContaIni ,;
                          cContaFim ,;
                          cCustoIni ,;
                          cCustoFim ,;
                              cItemIni  ,;
                              cItemFim  ,;
                              cCLVLIni  ,;
                              cCLVLFim  ,;
                              cMoeda    ,;
                              dDataIni  ,;
                              dDataFim  ,;
                          aSetOfBook,;
                          lNoMov    ,;
                          cSaldo    ,;
                          lJunta    ,;
                          cTipo     ,;
                          c2Moeda   ,;
                          nTipo     ,;
                          cUFilter  ,;
                          lSldAnt   ,;
                          aSelFil )

Local cCpoChave    := ""
Local cTmpChave    := ""
Local cContaI    := ""
Local cContaF    := ""
Local cCustoI    := ""
Local cCustoF    := ""
Local cItemI    := ""
Local cItemF    := ""
Local cClVlI    := ""
Local cClVlF    := ""
Local cVldEnt    := ""
Local cAlias    := ""
Local lUFilter    := !Empty(cUFilter)
Local cFilMoeda    := ""                             
Local cAliasCT2    := "CT2"    
Local bCond        := {||.T.}
Local cQryFil    := ''

#IFDEF TOP
     Local cQuery    := ""
     Local cOrderBy    := ""
     Local nI        := 0
     Local aStru    := {}
#ENDIF

DEFAULT cUFilter := ".T."
DEFAULT lSldAnt     := .F.
DEFAULT aSelFil  := {}

DBSELECTAREA("CTD")
SET FILTER TO CTD->CTD_XVISAO == "1"                   

cQryFil := " CT2_FILIAL " + GetRngFil( aSelFil ,"CT2") 

cCustoI    := CCUSTOINI
cCustoF := CCUSTOFIM
cContaI    := CCONTAINI
cContaF := CCONTAFIM
cItemI    := CITEMINI      
cItemF     := CITEMFIM
cClvlI    := CCLVLINI
cClVlF     := CCLVLFIM

#IFDEF TOP
     If TcSrvType() != "AS/400"
        If !Empty(c2Moeda)             
            cFilMoeda    := " (CT2_MOEDLC = '" + cMoeda + "' OR "        
            cFilMoeda    += " CT2_MOEDLC = '" + c2Moeda + "') "             
        Else
            cFilMoeda    := " CT2_MOEDLC = '" + cMoeda + "' "                
        EndIf
     Else
#ENDIF 
     If !Empty(c2Moeda)             
        cFilMoeda    := " (CT2_MOEDLC = '" + cMoeda + "' .Or. "        
        cFilMoeda    += " CT2_MOEDLC = '" + c2Moeda + "') "             
     Else
        cFilMoeda    := " CT2_MOEDLC = '" + cMoeda + "' "                
     EndIf
#IFDEF TOP
     EndIf
#ENDIF 

oMeter:nTotal := CT1->(RecCount())

If cTipo <> "1"                 

   If cTipo = "2" .And. Empty(cCustoIni)
      CTT->(DbSeek(xFilial("CTT")))
      cCustoIni := CTT->CTT_CUSTO
   Endif
   
   If cTipo = "3" .And. Empty(cItemIni)
      CTD->(DbSeek(xFilial("CTD")))
      cItemIni  := CTD->CTD_ITEM      
   Endif
   
   If cTipo = "4" .And. Empty(cClVlIni)
      CTH->(DbSeek(xFilial("CTH")))
      cClVlIni  := CTH->CTH_CLVL
   Endif
Endif

#IFDEF TOP
    If TcSrvType() != "AS/400"

        If cTipo == "1"

            dbSelectArea("CT2")
            dbSetOrder(2)
            cValid    :=     "CT2_DEBITO>='" + cContaIni + "' AND " +;
                        "CT2_DEBITO<='" + cContaFim + "'"
            cVldEnt :=     "CT2_CCD>='" + cCustoIni + "' AND " +;
                        "CT2_CCD<='" + cCustoFim + "' AND " +;
                        "CT2_XVISCT>='" + cItemIni + "' AND " +;
                        "CT2_XVISCT<='" + cItemFim + "' AND " +;
                        "CT2_CLVLDB>='" + cClVlIni + "' AND " +;
                        "CT2_CLVLDB<='" + cClVlFim + "'"                        
            cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_DATA "

        ElseIf cTipo == "2"

            dbSelectArea("CT2")
            dbSetOrder(4)
            cValid    :=     "CT2_CCD >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCD <= '" + cCustoFim + "'"
            cVldEnt :=     "CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
                        "CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
                        "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'  AND  " +;
                        "CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLDB <= '" + cClVlFim + "'" 
            cOrderBy:= " CT2_FILIAL, CT2_CCD, CT2_DATA "                        

        ElseIf cTipo == "3"

            dbSelectArea("CT2")
            dbSetOrder(6)
            cValid     :=     "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'"
            cVldEnt    :=     "CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
                        "CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
                        "CT2_CCD >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCD <= '" + cCustoFim + "'  AND  " +;
                        "CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLDB <= '" + cClVlFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_XVISCT, CT2_DATA "                                                

        ElseIf cTipo == "4"

            dbSelectArea("CT2")
            dbSetOrder(8)
            cValid     :=     "CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLDB <= '" + cClVlFim + "'"
            cVldEnt    :=     "CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
                        "CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
                        "CT2_CCD >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCD <= '" + cCustoFim + "'  AND  " +;
                        "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_CLVLDB, CT2_DATA "                                                
        EndIf                                           

        cAliasCT2    := "cAliasCT2"
        
        cQuery    := " SELECT * "
        cQuery    += " FROM " + RetSqlName("CT2")  
        cQuery    += " WHERE " + cQryFil + " AND "
        cQuery    += cValid + " AND "
        cQuery    += " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
        cQuery    += " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
        cQuery    += cVldEnt+ " AND " 
        cQuery    += cFilMoeda + " AND " 
        cQuery    += " CT2_TPSALD = '"+ cSaldo + "'"
        cQuery    += " AND (CT2_DC = '1' OR CT2_DC = '3')"
        cQuery   += " AND CT2_VALOR <> 0 "
        cQuery    += " AND D_E_L_E_T_ = ' ' " 
        
        cQuery    += " AND CT2_XVISCT <> ''"        
        
        cQuery    += " ORDER BY "+ cOrderBy
        cQuery := ChangeQuery(cQuery)
        
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
        aStru := CT2->(dbStruct())
        
        For ni := 1 to Len(aStru)
            If aStru[ni,2] != 'C'
                TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
            Endif
        Next ni        

        If lUFilter                    //// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
            If !Empty(cVldEnt)
                cVldEnt  += " AND "            /// SE JÁ TIVER CONTEUDO, ADICIONA "AND"                
                cVldEnt  += cUFilter                /// ADICIONA O FILTRO DE USUÁRIO        
            EndIf        
        EndIf    
                                             
        If (!lUFilter) .or. Empty(cUFilter)
            cUFilter := ".T."
        EndIf            
        
        dbSelectArea(cAliasCT2)                
        While !Eof()
            If &cUFilter
                CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo)
                dbSelectArea(cAliasCT2)
            EndIf
            dbSkip()
        EndDo            
        If ( Select ( "cAliasCT2" ) <> 0 )
            dbSelectArea ( "cAliasCT2" )
            dbCloseArea ()
        Endif
        
    Else    
#ENDIF    
    If cTipo == "1"
        dbSelectArea("CT2")                              
        dbSetOrder(2)
        cValid    :=     "CT2_DEBITO>='" + cContaIni + "' .And. " +;
                    "CT2_DEBITO<='" + cContaFim + "'"
        cVldEnt :=     "CT2_CCD>='" + cCustoIni + "' .And. " +;
                    "CT2_CCD<='" + cCustoFim + "' .And. " +;
                    "CT2_XVISCT>='" + cItemIni + "' .And. " +;
                    "CT2_XVISCT<='" + cItemFim + "' .And. " +;
                    "CT2_CLVLDB>='" + cClVlIni + "' .And. " +;
                    "CT2_CLVLDB<='" + cClVlFim + "'"
        bCond     := { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
    ElseIf cTipo == "2"
        dbSelectArea("CT2")
        dbSetOrder(4)
        cValid    :=     "CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
                    "CT2_CCD <= '" + cCustoFim + "'"
        cVldEnt :=     "CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
                    "CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
                    "CT2_XVISCT >= '" + cItemIni + "'  .And.  " +;
                    "CT2_XVISCT <= '" + cItemFim + "'  .And.  " +;
                    "CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
                    "CT2_CLVLDB <= '" + cClVlFim + "'"
    ElseIf cTipo == "3"
        dbSelectArea("CT2")
        dbSetOrder(6)
        cValid     :=     "CT2_XVISCT >= '" + cItemIni + "'  .And.  " +;
                    "CT2_XVISCT <= '" + cItemFim + "'"
        cVldEnt    :=     "CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
                    "CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
                    "CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
                    "CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
                    "CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
                    "CT2_CLVLDB <= '" + cClVlFim + "'"
    ElseIf cTipo == "4"
        dbSelectArea("CT2")
        dbSetOrder(8)
        cValid     :=     "CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
                    "CT2_CLVLDB <= '" + cClVlFim + "'"
        cVldEnt    :=     "CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
                    "CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
                    "CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
                    "CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
                    "CT2_XVISCT >= '" + cItemIni + "'  .And.  " +;
                    "CT2_XVISCT <= '" + cItemFim + "'"
    EndIf
        
    If lUFilter                            /// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
        If !Empty(cVldEnt)
            cVldEnt  += " .and. "        /// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."        
        EndIf
    Endif
    
    cVldEnt  += cUFilter                /// ADICIONA O FILTRO DE USUÁRIO        
        
    If cTipo == "1"                        /// TRATAMENTO CONTAS A CREDITO

        dbSelectArea("CT2")
        dbSetOrder(2)
        
        dbSelectArea("CT1")
        dbSetOrder(3)
        cFilCT1 := xFilial("CT1")
        cFilCT2    := xFilial("CT2")
        cContaIni := If(Empty(cContaIni),"",cContaIni)        /// Se tiver espacos em branco usa "" p/ seek
        dbSeek(cFilCT1+"2"+cContaIni,.T.)                    /// Procura inicial analitica
        
        While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
            dbSelectArea("CT2")
            MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
            While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
                
                If CT2->CT2_VALOR = 0
                    dbSkip()
                    Loop                
                EndIf
        
                If Empty(c2Moeda)            
                    If CT2->CT2_MOEDLC <> cMoeda
                        dbSkip()
                        Loop
                    EndIF
                Else
                    If !(&(cFilMoeda))
                        dbSkip()
                        Loop
                    EndIf            
                EndIf
                
                If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
                    CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
                Endif
                dbSelectArea("CT2")
                dbSkip()
            EndDo
            CT1->(dbSkip())
        EndDo
    Else
        dbSelectArea("CTD")
        SET FILTER TO CTD_XVISAO == "1"

        dbSelectArea("CT2")
        SET FILTER TO CT2_XVISCT <> ""        

        cTabCad := "CTT"
        cEntIni    := cCustoIni
        bCond     := { || CT2->CT2_CCD == CTT->CTT_CUSTO}
        bCondCad:= { || .T.}
        dbSetOrder(4)

        If cTipo == "3"
            cTabCad := "CTD"
            cEntIni := cItemIni
            bCond     := { || CT2->CT2_XVISCT == CTD->CTD_ITEM}            
            dbSetOrder(6)
        ElseIf cTipo == "4"
            cTabCad := "CTH"
            cEntIni := cCLVLIni
            bCond     := { || CT2->CT2_CLVLDB == CTH->CTH_CLVL}                    
            dbSetOrder(8)
        EndIf
        
        dbSelectArea(cTabCad)
        dbSetOrder(2)
        cFilEnt := xFilial(cTabCad)
        cFilCT2    := xFilial("CT2")
        cEntIni := If(Empty(cEntIni),"",cEntIni)        /// Se tiver espacos em branco usa "" p/ seek
        dbSeek(cFilEnt+"2"+cEntIni,.T.)                    /// Procura inicial analitica
        
        If cTipo == "2"
            bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
        ElseIf cTipo == "3"
               bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
          ElseIf cTipo == "4"
            bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }          
          EndIf
        
        While (cTabCad)->(!Eof()) .and. Eval(bCondCad)            /// WHILE DO CADASTRO DE ENTIDADES
    
            dbSelectArea("CT2")                
            If cTipo == "2"
                MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
            ElseIf cTipo == "3"
                MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)            
            Else
                MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)                        
            EndIf

            dbSelectArea("CT2")                                    /// WHILE CT2 - DEBITOS
            While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
        
                If CT2->CT2_VALOR = 0
                    dbSkip()
                    Loop                
                EndIf

                If Empty(c2Moeda)            
                    If CT2->CT2_MOEDLC <> cMoeda
                        dbSkip()
                        Loop
                    EndIF
                Else
                    If !(&(cFilMoeda))
                        dbSkip()
                        Loop
                    EndIf            
                EndIf
                
                If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
                    CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
                Endif
                dbSelectArea("CT2")
                dbSkip()
            EndDo    
            (cTabCad)->(dbSkip())
        EndDo
    Endif
        
#IFDEF TOP
    EndIf
#ENDIF

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os creditos³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"
    dbSelectArea("CT2")
    dbSetOrder(3)
ElseIf cTipo == "2"
    dbSelectArea("CT2")
    dbSetOrder(5)
ElseIf cTipo == "3"
    dbSelectArea("CT2")
    dbSetOrder(7)
ElseIf cTipo == "4"        
    dbSelectArea("CT2")
    dbSetOrder(9)
EndIf

#IFDEF TOP
    If TcSrvType() != "AS/400"                          
        If cTipo == "1"
            cValid    :=     "CT2_CREDIT>='" + cContaIni + "' AND " +;
                        "CT2_CREDIT<='" + cContaFim + "'"
            cVldEnt :=    "CT2_CCC>='" + cCustoIni + "' AND " +;
                        "CT2_CCC<='" + cCustoFim + "' AND " +;
                        "CT2_XVISCT>='" + cItemIni + "' AND " +;
                        "CT2_XVISCT<='" + cItemFim + "' AND " +;
                        "CT2_CLVLCR>='" + cClVlIni + "' AND " +;
                        "CT2_CLVLCR<='" + cClVlFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_DATA "                                                                    
        ElseIf cTipo == "2"
            cValid     :=     "CT2_CCC >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCC <= '" + cCustoFim + "'"
            cVldEnt    :=     "CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
                        "CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
                        "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'  AND  " +;
                        "CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLCR <= '" + cClVlFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "                                                                    
        ElseIf cTipo == "3"
            cValid     :=     "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'"
            cVldEnt :=     "CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
                        "CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
                        "CT2_CCC >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCC <= '" + cCustoFim + "'  AND  " +;
                        "CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLCR <= '" + cClVlFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_XVISCT, CT2_DATA "                                                                    
        ElseIf cTipo == "4"        
            cValid     :=     "CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
                        "CT2_CLVLCR <= '" + cClVlFim + "'"
            cVldEnt :=     "CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
                        "CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
                        "CT2_CCC >= '" + cCustoIni + "'  AND  " +;
                        "CT2_CCC <= '" + cCustoFim + "'  AND  " +;
                        "CT2_XVISCT >= '" + cItemIni + "'  AND  " +;
                        "CT2_XVISCT <= '" + cItemFim + "'"
            cOrderBy:= " CT2_FILIAL, CT2_CLVLCR, CT2_DATA "                                                                                        
        EndIf                        
        
        cAliasCT2    := "cAliasCT2"        
        
        cQuery    := " SELECT * "
        cQuery    += " FROM " + RetSqlName("CT2")  
        cQuery    += " WHERE " + cQryFil + " AND "
        cQuery    += cValid + " AND "
        cQuery    += " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
        cQuery    += " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
        cQuery    += cVldEnt+ " AND " 
        cQuery    += cFilMoeda + " AND " 
        cQuery    += " CT2_TPSALD = '"+ cSaldo + "' AND "  
        cQuery    += " (CT2_DC = '2' OR CT2_DC = '3') AND "
        cQuery    += " CT2_VALOR <> 0 AND "
        cQuery    += " D_E_L_E_T_ = ' ' " 
        cQuery    += " ORDER BY "+ cOrderBy
        cQuery := ChangeQuery(cQuery)
            
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
        
        aStru := CT2->(dbStruct())
        
        For ni := 1 to Len(aStru)
            If aStru[ni,2] != 'C'
                TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
            Endif
        Next ni        
        

        If lUFilter                    //// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
            If !Empty(cVldEnt)
                cVldEnt  += " AND "            /// SE JÁ TIVER CONTEUDO, ADICIONA "AND"                
                cVldEnt  += cUFilter                /// ADICIONA O FILTRO DE USUÁRIO        
            EndIf        
        EndIf    
        
        If (!lUFilter) .or. Empty(cUFilter)
            cUFilter := ".T."
        EndIf            
        
        dbSelectArea(cAliasCT2)                
        While !Eof()
            If &cUFilter
                CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo)
                dbSelectArea(cAliasCT2)
            EndIf
            dbSkip()
        EndDo
        
        If ( Select ( "cAliasCT2" ) <> 0 )
            dbSelectArea ( "cAliasCT2" )
            dbCloseArea ()
        Endif

    Else
#ENDIF
    bCond    := {||.T.}

    If cTipo == "1"
        cValid    :=     "CT2_CREDIT>='" + cContaIni + "'.And." +;
                    "CT2_CREDIT<='" + cContaFim + "'"
        cVldEnt :=    "CT2_CCC>='" + cCustoIni + "'.And." +;
                    "CT2_CCC<='" + cCustoFim + "'.And." +;
                    "CT2_XVISCT>='" + cItemIni + "'.And." +;
                    "CT2_XVISCT<='" + cItemFim + "'.And." +;
                    "CT2_CLVLCR>='" + cClVlIni + "'.And." +;
                    "CT2_CLVLCR<='" + cClVlFim + "'"
        bCond     := { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
    ElseIf cTipo == "2"
        cValid     :=     "CT2_CCC >= '" + cCustoIni + "' .And. " +;
                    "CT2_CCC <= '" + cCustoFim + "'"
        cVldEnt    :=     "CT2_CREDIT >= '" + cContaIni + "' .And. " +;
                    "CT2_CREDIT <= '" + cContaFim + "' .And. " +;
                    "CT2_XVISCT >= '" + cItemIni + "' .And. " +;
                    "CT2_XVISCT <= '" + cItemFim + "' .And. " +;
                    "CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
                    "CT2_CLVLCR <= '" + cClVlFim + "'"
    ElseIf cTipo == "3"
        cValid     :=     "CT2_XVISCT >= '" + cItemIni + "' .And. " +;
                    "CT2_XVISCT <= '" + cItemFim + "'"
        cVldEnt :=     "CT2_CREDIT >= '" + cContaIni + "' .And. " +;
                    "CT2_CREDIT <= '" + cContaFim + "' .And. " +;
                    "CT2_CCC >= '" + cCustoIni + "' .And. " +;
                    "CT2_CCC <= '" + cCustoFim + "' .And. " +;
                    "CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
                    "CT2_CLVLCR <= '" + cClVlFim + "'"
    ElseIf cTipo == "4"        
        cValid     :=     "CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
                    "CT2_CLVLCR <= '" + cClVlFim + "'"
        cVldEnt :=     "CT2_CREDIT >= '" + cContaIni + "' .And. " +;
                    "CT2_CREDIT <= '" + cContaFim + "' .And. " +;
                    "CT2_CCC >= '" + cCustoIni + "' .And. " +;
                    "CT2_CCC <= '" + cCustoFim + "' .And. " +;
                    "CT2_XVISCT >= '" + cItemIni + "' .And. " +;
                    "CT2_XVISCT <= '" + cItemFim + "'"
    EndIf    
    
    If lUFilter                    //// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
        If !Empty(cVldEnt)
            cVldEnt  += " .and. "            /// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."        
        EndIf
    Endif
    
    cVldEnt  += cUFilter                /// ADICIONA O FILTRO DE USUÁRIO        
    
    If cTipo == "1"                        /// TRATAMENTO CONTAS A CREDITO
        dbSelectArea("CT2")
        dbSetOrder(3)
        
        dbSelectArea("CT1")
        dbSetOrder(3)
        cFilCT1 := xFilial("CT1")
        cFilCT2    := xFilial("CT2")
        cContaIni := If(Empty(cContaIni),"",cContaIni)        /// Se tiver espacos em branco usa "" p/ seek
        dbSeek(cFilCT1+"2"+cContaIni,.T.)                    /// Procura inicial analitica
        
        While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
            dbSelectArea("CT2")
            MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
            While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

                If CT2->CT2_VALOR = 0
                    dbSkip()
                    Loop                
                EndIf
    
                If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
                    If Empty(c2Moeda)            
                        If CT2->CT2_MOEDLC <> cMoeda
                            dbSkip()
                            Loop
                        EndIF
                    Else
                        If !(&(cFilMoeda))
                            dbSkip()
                            Loop
                        EndIf            
                    EndIf            
                    CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
                Endif
                dbSelectArea("CT2")
                dbSkip()
            EndDo            
            CT1->(dbSkip())
        EndDo
    Else
        dbSelectArea("CT2")

        cTabCad := "CTT"
        cEntIni    := cCustoIni
        bCond     := { || CT2->CT2_CCC == CTT->CTT_CUSTO}
        bCondCad:= { || .T.}
        dbSetOrder(5)

        If cTipo == "3"
            cTabCad := "CTD"
            cEntIni := cItemIni
            bCond     := { || CT2->CT2_XVISCT == CTD->CTD_ITEM}            
            dbSetOrder(7)
        ElseIf cTipo == "4"
            cTabCad := "CTH"
            cEntIni := cCLVLIni
            bCond     := { || CT2->CT2_CLVLCR == CTH->CTH_CLVL}                    
            dbSetOrder(9)
        EndIf
        
        dbSelectArea(cTabCad)
        dbSetOrder(2)
        cFilEnt := xFilial(cTabCad)
        cFilCT2    := xFilial("CT2")
        cEntIni := If(Empty(cEntIni),"",cEntIni)        /// Se tiver espacos em branco usa "" p/ seek
        dbSeek(cFilEnt+"2"+cEntIni,.T.)                    /// Procura inicial analitica
        
        If cTipo == "2"
            bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
        ElseIf cTipo == "3"
               bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
          ElseIf cTipo == "4"
            bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }          
          EndIf
        
        While (cTabCad)->(!Eof()) .and. Eval(bCondCad)            /// WHILE DO CADASTRO DE ENTIDADES
    
            dbSelectArea("CT2")        
            If cTipo == "2"
                MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
            ElseIf cTipo == "3"
                MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)            
            Else
                MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)                        
            EndIf

            dbSelectArea("CT2")                                    /// WHILE CT2 - CREDITO
            While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim

                If CT2->CT2_VALOR = 0
                    dbSkip()
                    Loop                
                EndIf
        
                If Empty(c2Moeda)            
                    If CT2->CT2_MOEDLC <> cMoeda
                        dbSkip()
                        Loop
                    EndIF
                Else
                    If !(&(cFilMoeda))
                        dbSkip()
                        Loop
                    EndIf            
                EndIf
                
                If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
                    CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
                Endif
                dbSelectArea("CT2")
                dbSkip()
            EndDo    
            (cTabCad)->(dbSkip())
        EndDo
    EndIf

#IFDEF TOP
    EndIf
#ENDIF

If lNoMov .or. lSldAnt
    If cTipo == "1"
        dbSelectArea("CT1")
        dbSetOrder(3)
        IndRegua(    Alias(),CriaTrab(nil,.f.),IndexKey(),,;
                        "CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
                        cContaF + "' .And. CT1_CLASSE = '2'",STR0017)
        cCpoChave := "CT1_CONTA"
        cTmpChave := "CONTA"
    ElseIf cTipo == "2"
        dbSelectArea("CTT")
        dbSetOrder(2)
        IndRegua(    Alias(),CriaTrab(nil,.f.),IndexKey(),,;
                        "CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
                        cCUSTOF + "' .And. CTT_CLASSE == '2'",STR0017)
        cCpoChave := "CTT_CUSTO"
        cTmpChave := "CCUSTO"
    ElseIf ctipo == "3"
        dbSelectArea("CTD")
        dbSetOrder(2)
        IndRegua(    Alias(),CriaTrab(nil,.f.),IndexKey(),,;
                        "CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
                        cITEMF + "' .And. CTD_CLASSE == '2'",STR0017)
        cCpoChave := "CTD_ITEM"
        cTmpChave := "ITEM"
    ElseIf ctipo == "4"
        dbSelectArea("CTH")
        dbSetOrder(2)
        IndRegua(    Alias(),CriaTrab(nil,.f.),IndexKey(),,;
                        "CTH_FILIAL == '" + xFilial("CTH") + "' .And. CTH_CLVL >= '"+cClVlI+"' .And. CTH_CLVL <= '" +;
                        cCLVLF + "' .And. CTH_CLASSE == '2'",STR0017)
        cCpoChave := "CTH_CLVL"
        cTmpChave := "CLVL"
    EndIf

    cAlias := Alias()

    While ! Eof()
        dbSelectArea("cArqTmp")
        cKey2Seek    := &(cAlias + "->" + cCpoChave)
        If !DbSeek(cKey2Seek)
            If lNoMov        
                CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
            ElseIf cTipo == "1"        /// SOMENTE PARA O RAZAO POR CONTA
                /// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."
                If SaldoCT7Fil(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
                    /// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
                    CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
                Endif
            EndIf
        Endif
        DbSelectArea(cAlias)
        DbSkip()
    EndDo

    DbSelectArea(cAlias)
    DbClearFil()
    RetIndex(cAlias)
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRaz(lJunta,cMoeda,cSaldo,cTipo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvRAZ(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)

Local cConta
Local cContra
Local cCusto
Local cItem
Local cCLVL
Local cChave          := ""
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
DEFAULT cAliasCT2  := "CT2"

If !Empty(c2Moeda)

    If cTipo == "1"
        cChave := (cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
    Else
        cChave := (cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
     EndIf
EndIf


If cTipo == "1"
    cConta     := (cAliasCT2)->CT2_DEBITO
    cContra    := (cAliasCT2)->CT2_CREDIT
    cCusto    := (cAliasCT2)->CT2_CCD
//    cItem    := (cAliasCT2)->CT2_ITEMD
    cItem    := (cAliasCT2)->CT2_XVISCT    
    cCLVL    := (cAliasCT2)->CT2_CLVLDB
EndIf    
If cTipo == "2"
    cConta     := (cAliasCT2)->CT2_CREDIT
    cContra := (cAliasCT2)->CT2_DEBITO
    cCusto    := (cAliasCT2)->CT2_CCC
//    cItem    := (cAliasCT2)->CT2_XVISCT
    cItem    := (cAliasCT2)->CT2_XVISCT
    cCLVL    := (cAliasCT2)->CT2_CLVLCR
EndIf                   

dbSelectArea("cArqTmp")
dbSetOrder(1)    
If ! Empty(c2Moeda) 
   If MsSeek(cChave,.F.)
         Reclock("cArqTmp",.F.)
   Else
         RecLock("cArqTmp",.T.)        
   EndIf
Else
   RecLock("cArqTmp",.T.)
EndIf

Replace DATAL        With (cAliasCT2)->CT2_DATA
Replace TIPO        With cTipo
Replace LOTE        With (cAliasCT2)->CT2_LOTE
Replace SUBLOTE        With (cAliasCT2)->CT2_SBLOTE
Replace DOC            With (cAliasCT2)->CT2_DOC
Replace LINHA        With (cAliasCT2)->CT2_LINHA
Replace CONTA        With cConta

If lImpCPartida
    Replace XPARTIDA    With cContra
EndIf

Replace CCUSTO        With cCusto
Replace ITEM        With cItem
Replace CLVL        With cCLVL
Replace HISTORICO    With (cAliasCT2)->CT2_HIST
Replace EMPORI        With (cAliasCT2)->CT2_EMPORI
Replace FILORI        With (cAliasCT2)->CT2_FILORI
Replace SEQHIST        With (cAliasCT2)->CT2_SEQHIST
Replace SEQLAN        With (cAliasCT2)->CT2_SEQLAN
Replace NOMOV        With .F.                            // Conta com movimento

If cPaisLoc $ "CHI|ARG"
    Replace SEGOFI With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
EndIf

If Empty(c2Moeda)    //Se nao for Razao em 2 Moedas
    If cTipo == "1"
        Replace LANCDEB    With LANCDEB + (cAliasCT2)->CT2_VALOR
    EndIf    
    If cTipo == "2"
        Replace LANCCRD    With LANCCRD + (cAliasCT2)->CT2_VALOR
    EndIf        
    If (cAliasCT2)->CT2_DC == "3"
        Replace TIPO    With cTipo
    Else
        Replace TIPO     With (cAliasCT2)->CT2_DC
    EndIf        
Else    //Se for Razao em 2 Moedas
    If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
        If cTipo == "1"
            Replace LANCDEB With (cAliasCT2)->CT2_VALOR    
        Else            
            Replace LANCCRD With (cAliasCT2)->CT2_VALOR    
        EndIf
    EndIf
    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda    //Se Imprime Moeda Corrente ou Ambas
        If cTipo == "1"
            Replace LANCDEB_1    With (cAliasCT2)->CT2_VALOR
        Else
            Replace LANCCRD_1    With (cAliasCT2)->CT2_VALOR
        Endif
    EndIf
    If LANCDEB_1 <> 0 .And. LANCDEB <> 0 
        Replace TXDEBITO      With LANCDEB_1 / LANCDEB        
    Endif                                               
    If LANCCRD_1 <> 0 .And. LANCCRD <> 0
        Replace TXCREDITO     With LANCCRD_1 / LANCCRD
    EndIf    
    If (cAliasCT2)->CT2_DC == "3"
        Replace TIPO    With cTipo
    Else
        Replace TIPO     With (cAliasCT2)->CT2_DC
    EndIf            
EndIf

If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
    DbDelete()
ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
    DbDelete()
Endif
If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
    DbDelete()
Endif
MsUnlock()

Return

/* ================================================================================== */
/* Função .....: SaldtotCT2
   Objetivo ...: Retornar os saldos do intervalo de conta, item e centro de custo
   Sintaxe ....: SaldtotCT2( cItemIni, cItemFim, cCusIni, cCusFim, cContaini, cContaFim, dData, cMoeda, cTpSald )
   Retorno ....: nSaldoAtu, nDebito, nCredito, nAtuDeb, nAtuCrd, nSaldoAnt, nAntDeb, nAntCrd 
   Parâmetros ExpC1 = Item Inicial                                                  
              ExpC1 = Item Final                                                    
              ExpC1 = Centro de Custo Inicial                                       
              ExpC2 = Centro de Custo Final                                         
              ExpC3 = Conta Final                                                   
              ExpC4 = Conta Final                                                   
              ExpD1 = Data                                                       
              ExpC3 = Moeda                                                         
              ExpC4 = Tipo de Saldo                                                
              ExpC5 = Filial Especifica                                            
*/
/* ================================================================================== */
Static Function SaldtotCT2( cItemIni ,;
                            cItemFim ,;
                            cCusIni  ,;
                            cCusFim  ,;
                            cContaIni,;
                            cContaFim,;
                              dData    ,;
                              cMoeda   ,;
                              cTpSald  ,;
                              aSelFil  ,;
                              lRecDesp0,;
                              cRecDesp ,;
                              dDtZeraRD,;
                              lImpAntLP,;
                              dDataLP  ,;
                              cArqCt2  ,;
                              lConsSaldo )

Local aSaveArea       := CT2->(GetArea())
Local aSaveAnt       := GetArea()
Local nDebito       := 0   // Valor Debito na Data
Local nCredito        := 0   // Valor Credito na Data
Local nAtuDeb         := 0   // Saldo Atual Devedor
Local nAtuCrd       := 0   // Saldo Atual Credor
Local nAntDeb       := 0   // Saldo Anterior Devedor
Local nAntCrd       := 0   // Saldo Anterior Credor
Local nSaldoAnt       := 0   // Saldo Anterior (com sinal)
Local nSaldoAtu       := 0   // Saldo Atual (com sinal)
Local cQryFil      := ""
Local cTipoSaldo   := ""
Local lDefTop        := IfDefTopCTB() //Verifica se a query pode ser executada (TOPCONN)

DEFAULT cTpSald    := Iif( Empty(cTpSald), "1", cTpSald )
DEFAULT lConsSaldo := .F.
DEFAULT lRecDesp0  := .F.
DEFAULT cRecDesp   := ""                
DEFAULT dDtZeraRD  := CTOD("  /  /  ")
DEFAULT lImpAntLp  := .F.
DEFAULT dDataLp    := CTOD("  /  /  ")
DEFAULT aSelFil    := {}
DEFAULT cArqCt2    := Nil

cTipoSaldo         := StrTran(StrTran(cTpSald,"','",""),";","")

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
   lRecDesp0 := .F.
EndIf

//Tratamento para o filtro de filiais
cQryFil := GetRngFil( aSelFil , "CT2" ) 

If lDefTop

   IF cArqCt2 == Nil

         cArqCt2 := RetSqlName("CT2")
   EndIf

   //Query Saldo Anterior                              
   /*
   cQuery := " SELECT SUM( DEBITO  ) TOTDEB, "
   cQuery += "        SUM( CREDITO ) TOTCRED "
   cQuery += "   FROM ( SELECT ( CASE ( SELECT 1 WHERE CT2_DEBITO <> '' ) "
   cQuery += "                        WHEN 1 "
   cQuery += "                        THEN CT2_VALOR  "
   cQuery += "                        ELSE 0 "
   cQuery += "                   END ) DEBITO, "
   cQuery += "                 ( CASE ( SELECT 1 WHERE CT2_CREDIT <> '' ) "
   cQuery += "                        WHEN 1 "
   cQuery += "                        THEN CT2_VALOR  "
   cQuery += "                        ELSE 0 "
   cQuery += "                   END )CREDITO "
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "      + cQryFil 
   cQuery += "    AND CT2_XVISCT >= '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT <= '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD IN ('" + cTpSald     + "') "
   cQuery += "    AND CT2_DATA    < '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_ <> '*' ) SALDOANT"
   */
     
   /*
   02/08/2011 - Esta query foi substituída para contemplar a nova solicitação 
                da contabilidade em referência a exibição do  valor  no saldo 
                anterior.
   cQuery := " SELECT ISNULL( ( CASE ( SELECT 1 WHERE DEBTOT < 0 ) WHEN 1 THEN DEBTOT END ), 0 ) DEBTOT , "       
   cQuery += "        ISNULL( ( CASE ( SELECT 1 WHERE DEBTOT > 0 ) WHEN 1 THEN DEBTOT END ), 0 ) CREDTOT  "
   cQuery += "   FROM ( "
   cQuery += " SELECT ( " 
   cQuery += "SELECT DEBTOT "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT DEBITOS.CONTA, ( DEBITOS.VALOR - CREDITOS.VALOR ) DEBTOT "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT 'D' TIPO, CT2_DEBITO CONTA, SUM( CT2_VALOR ) VALOR "  
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "    AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "   AND ( CT2_DEBITO >=  '"  + cContaIni   + "' AND CT2_DEBITO <= '" + cContaFim + "') "
   cQuery += "    AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <>  '*'
   cQuery += "GROUP BY CT2_DEBITO "
   cQuery += ") DEBITOS "
   cQuery += "LEFT JOIN "
   cQuery += "( "
   cQuery += "SELECT 'C' TIPO, CT2_CREDIT CONTA, SUM( CT2_VALOR ) VALOR "
   cQuery += "   FROM " + cArqCt2 
   cQuery += "  WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "    AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "   AND ( CT2_CREDIT >=  '"  + cContaIni   + "' AND CT2_CREDIT <= '" + cContaFim + "') "
   cQuery += "    AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <>  '*'
   cQuery += "GROUP BY CT2_CREDIT "
   cQuery += ") "
   cQuery += "CREDITOS "
   cQuery += "ON CREDITOS.CONTA = DEBITOS.CONTA "
   cQuery += ") SLDDEBITOS "
   cQuery += ") DEBTOT "
   cQuery += ", "
   cQuery += "( "
   cQuery += "SELECT CREDTOT "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT CONTA, VALOR CREDTOT "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT 'C' TIPO, CT2_CREDIT CONTA, SUM( CT2_VALOR ) VALOR "
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "    AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "   AND ( CT2_CREDIT >=  '"  + cContaIni   + "' AND CT2_CREDIT <= '" + cContaFim + "') "
   cQuery += "    AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <>  '*'  
   cQuery += "GROUP BY CT2_CREDIT "
   cQuery += ") CREDITOS "
   cQuery += "WHERE CONTA NOT IN " 
   cQuery += "( "
   cQuery += "SELECT CONTA "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT DEBITOS.CONTA, DEBITOS.VALOR "
   cQuery += "  FROM "
   cQuery += "( " 
   cQuery += "SELECT 'D' TIPO, CT2_DEBITO CONTA, SUM( CT2_VALOR ) VALOR "
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "    AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "   AND ( CT2_DEBITO >=  '"  + cContaIni   + "' AND CT2_DEBITO <= '" + cContaFim + "') "
   cQuery += "    AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <>  '*'
   cQuery += "GROUP BY CT2_DEBITO "
   cQuery += ") DEBITOS "
   cQuery += "LEFT JOIN " 
   cQuery += "( "
   cQuery += "SELECT 'C' TIPO, CT2_CREDIT CONTA, SUM( CT2_VALOR ) VALOR "
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "    AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "   AND ( CT2_CREDIT >=  '"  + cContaIni   + "' AND CT2_CREDIT <= '" + cContaFim + "') "
   cQuery += "    AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <>  '*'  
   cQuery += "GROUP BY CT2_CREDIT "
   cQuery += ") "
   cQuery += "CREDITOS "
   cQuery += "ON CREDITOS.CONTA = DEBITOS.CONTA "
   cQuery += ") SLDDEBITOS "
   cQuery += ") "
   cQuery += ") SLDCREDITOS "
   cQuery += ") CREDTOT ) SALDO "           
   */   
   
   cQuery := " SELECT ISNULL( ( CASE ( SELECT 1 WHERE DEBTOT < 0 ) WHEN 1 THEN ( DEBTOT * -1 ) END ), 0 ) DEBTOT ,
   cQuery += "        ISNULL( ( CASE ( SELECT 1 WHERE DEBTOT > 0 ) WHEN 1 THEN DEBTOT END ), 0 ) CREDTOT
   cQuery += "  FROM (   SELECT ( ISNULL( CREDITOS, 0 ) - ISNULL( DEBITOS, 0 ) ) DEBTOT
   cQuery += "             FROM ( SELECT ( SELECT SUM( CT2_VALOR ) VALOR
   cQuery += "                              FROM " + cArqCt2
   cQuery += "                             WHERE CT2_FILIAL "         + cQryFil 
   cQuery += "                               AND CT2_XVISCT   >=  '"  + cItemIni    + "' "
   cQuery += "                               AND CT2_XVISCT   <=  '"  + cItemFim    + "' "
   cQuery += "                               AND CT2_TPSALD   IN ('"  + cTpSald     + "')"
   cQuery += "                               AND ( CT2_DEBITO >=  '"  + cContaIni   + "' AND CT2_DEBITO <= '" + cContaFim + "') "
   cQuery += "                               AND CT2_DATA      <  '"  + DTOS(dData) + "' "
   cQuery += "                               AND D_E_L_E_T_   <>  '*'  
   cQuery += "                           ) DEBITOS,
   cQuery += "                           ( SELECT SUM( CT2_VALOR ) VALOR
   cQuery += "                              FROM " + cArqCt2
   cQuery += "                             WHERE CT2_FILIAL "        + cQryFil 
   cQuery += "                               AND CT2_XVISCT  >=  '"  + cItemIni    + "' "
   cQuery += "                               AND CT2_XVISCT  <=  '"  + cItemFim    + "' "
   cQuery += "                               AND CT2_TPSALD  IN ('"  + cTpSald     + "')"
   cQuery += "                               AND ( CT2_CREDIT >= '"  + cContaIni   + "' AND CT2_CREDIT <= '" + cContaFim + "') "
   cQuery += "                               AND CT2_DATA     <  '"  + DTOS(dData) + "' "
   cQuery += "                               AND D_E_L_E_T_  <>  '*'  
   cQuery += "                           ) CREDITOS ) SUBCREDEB ) SALDOS "       
      
   DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "SLDTOTCT2", .T., .F. )                
    
   DBSelectArea( "SLDTOTCT2" )
   DBGoTop()

   //nAntDeb := SLDTOTCT2->TOTDEB
   //nAntCrd := SLDTOTCT2->TOTCRED

   nAntDeb := SLDTOTCT2->DEBTOT
   nAntCrd := SLDTOTCT2->CREDTOT
       
   //SLDTOTCT2->(DBCloseArea())
    
   //Query Mov. no Dia
   /*
   cQuery := " SELECT SUM( DEBITO  ) DEBTOT, "
   cQuery += "        SUM( CREDITO ) CREDTOT "
   cQuery += "   FROM ( SELECT ( CASE ( SELECT 1 WHERE CT2_DEBITO <> '' ) "
   cQuery += "                        WHEN 1 "
   cQuery += "                        THEN CT2_VALOR  "
   cQuery += "                        ELSE 0 "
   cQuery += "                   END ) DEBITO, "
   cQuery += "                 ( CASE ( SELECT 1 WHERE CT2_CREDIT <> '' ) "
   cQuery += "                        WHEN 1 "
   cQuery += "                        THEN CT2_VALOR  "
   cQuery += "                        ELSE 0 "
   cQuery += "                   END )CREDITO "
   cQuery += "   FROM " + cArqCt2
   cQuery += "  WHERE CT2_FILIAL "       + cQryFil 
   cQuery += "    AND CT2_XVISCT  >= '"  + cItemIni    + "' "
   cQuery += "    AND CT2_XVISCT  <= '"  + cItemFim    + "' "
   cQuery += "    AND CT2_TPSALD IN ('"  + cTpSald     + "') "
   cQuery += "    AND CT2_DATA     < '"  + DTOS(dData) + "' "
   cQuery += "    AND D_E_L_E_T_  <> '*' ) SALDODIA"
   */
      
   //DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "SLDTOTCT2", .T., .F. )
        
   //DBSelectArea("SLDTOTCT2")
   //DBGoTop()
           
   //Movimentacao da data
   //nDebito   := SLDTOTCT2->DEBTOT
   //nCredito  := SLDTOTCT2->CREDTOT                                                               

   nDebito     := 0
   nCredito  := 0
     
   nAtuDeb   := nAntDeb + nDebito
   nAtuCrd   := nAntCrd + nCredito
        
   nSaldoAtu := nAtuCrd - nAtuDeb
   nSaldoAnt := nAntCrd - nAntDeb

   SLDTOTCT2->( DBCloseArea() )    
EndIf

CT2->(RestArea(aSaveArea))
RestArea(aSaveAnt)

// Retorno:                                             
// [1] Saldo Atual (com sinal)                          
// [2] Debito na Data                                   
// [3] Credito na Data                                  
// [4] Saldo Atual Devedor                              
// [5] Saldo Atual Credor                               
// [6] Saldo Anterior (com sinal)                       
// [7] Saldo Anterior Devedor                           
// [8] Saldo Anterior Credor                            
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}

/*/
//Sintaxe ValorCtb(nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,cTipo,cConta,lGraf,oPrint)
//Parametros ExpN1 = Valor                                                          
//           ExpN2 = Numero da Linha                                                
//           ExpN3 = Numero da Coluna                                               
//           ExpN4 = Tamanho                                                        
//           ExpN5 = Numero de Decimais                                             
//           ExpL1 = Se devera ser impresso com sinal ou nao.                       
//           ExpC1 = Picture                                                        
//           ExpC2 = Tipo                                                           
//           ExpC3 = Conta                                                          
//           ExpL2 = Se eh grafico ou nao                                           
//           ExpO1 = Objeto oPrint                                                  
//           ExpC4 = Tipo do sinal utilizado                                        
//           ExpC5 = Identificar [USADO em modo gerencial]                          
//           ExpL3 = Imprime zero                                                   
//           ExpL4 = Se .F., ao inves de imprimir retornara o valor como caracter
/*/
Static Function ValorCtb(nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,cTipo,cConta,lGraf,oPrint,cTipoSinal,cIdentifi,lPrintZero,lSay)

Local aSaveArea    := GetArea()
Local cImpSaldo := ""
Local lDifZero    := .T.
Local lInformada:= .T.                      
Local cCharSinal:= ""

//lPrintZero := Iif(lPrintZero==Nil,.T.,lPrintZero)
lPrintZero := .T.

//Nao imprime o valor 0,00
//If !lPrintZero 
//    If (Int(nSaldo*1000000)/1000000) == 0
//        lDifZero := .F.            // O saldo nao eh diferente de zero
//    EndIf
//EndIf        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo D -> Default (D/C)                                                  ³
//³ Tipo S -> Imprime saldo com sinal                                      ³
//³ Tipo P -> Imprime saldo entre parenteses (qdo. negativo)      ³
//³ Tipo C -> So imprime "C" (o "D" nao e impresso)              ³
//³ Tipo N -> Imprime saldo com sinal (-) se o saldo for credor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFAULT cTipoSinal := GetMV("MV_TPVALOR")       // Assume valor default

DEFAULT lSay := .T.

cTipo         := Iif(cTipo == Nil, Space(1), cTipo)
nDecimais    := Iif(nDecimais==Nil,GetMv("MV_CENT"),nDecimais)

dbSelectArea("CT1")
dbSetOrder(1)

If !Empty(cConta) .And. Empty(cTipo)
    If MsSeek(cFilial+cConta)
        cTipo := CT1->CT1_NORMAL
    Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a picture. Caso nao exista espaco, retira os pontos  ³
//³ separadores de dezenas, centenas e milhares                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cPicture)        
    If cTipoSinal $ "D/C"
        cPicture := TmContab(Abs(nSaldo),nTamanho,nDecimais)
    Else
        cPicture := TmContab(nSaldo,nTamanho,nDecimais)
    EndIf    
    lInformada  := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³* Alguns valores, apesar de  terem sinal devem ser impressos  ³
//³ sem sinal (lSinal). Ex: valores de colunas Debito e Credito  ³
//³* Se estiver com a opcao de lingua estrangeira (lEstrang) a   ³
//³ picture sera invertida para exibir valores: 999,999,999.99   ³
//³* O tipo de sinal "D" - default nao leva em consideracao a    ³
//³ a natureza da conta. Dessa forma valores negativos serao      ³
//³ impressos sem sinal, e ao seu lado "D" (Devedor) e valores   ³
//³ positivos terao um "C" (Credito) impresso ao seu lado.       ³
//³* O tipo de Sinal "P" - Parenteses, imprimira valores de saldo³
//³  invertidos da condicao normal da conta entre parenteses.      ³
//³* O tipo de Sinal "S" - Sinal, imprimira valores de saldo in- ³
//³  vertidos da condicao normal da conta com sinal -               ³
//³EXEMPLOS  -  EXEMPLOS  -  EXEMPLOS    -    EXEMPLOS  - EXEMPLOS   ³
//³Cond Normal     Saldo     Default      Sinal   Parenteses          ³
//³    D               -1000       1000 D          1000         1000                    ³
//³    D                 1000     1000 C        -1000     (1000)              ³
//³    C                -1000     1000 D        -1000     (1000)              ³
//³    C                 1000     1000 C         1000      1000               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// So imprime valor se for diferente de zero!
If lDifZero
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Neste caso (Default), nao importa a natureza da conta! Saldos³
    //³ devedores serao impressos com "D" e credores com "C".        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    // Neste caso, nao importa a natureza da conta!!
    If cTipoSinal == "D" .Or. cTipoSinal == "C" .Or. cTipoSinal == "N"            // D(Default) ou C(so Credito)
        If !lInformada
            cPicture := "@E " + cPicture
        Endif             
        If lSinal
            If nSaldo < 0
                If lGraf                                     
                    If cTipoSinal == "D"                
                        cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
                    EndIf
                Else     
                    // No Tipo C -> so sao impressos os "C´s"
                    If cTipoSinal == "D"
                        cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
                    EndIf    
                Endif
            ElseIf nSaldo > 0
                If lGraf                                                                
                    If cIdentifi # Nil .And. cIdentifi $ "34"                                                           
                        If cTipoSinal == "D"
                            cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
                        EndIf
                    Else
                        cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
                    Endif
                Else
                    cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
                Endif
            EndIf
            cCharSinal := " "+cCharSinal            
        EndIf
                                   
        //Se o parametro MV_TPVALOR == "N" => nao considera a condicao normal da conta. 
        //So imprime sinal (-) se o saldo for credor. 
        If cTipoSinal == "N"
            If lSinal 
                cImpSaldo := Transform(nSaldo*(-1),cPicture)
            Else
                cImpSaldo := Transform(ABS(nSaldo),cPicture)                                                             
            EndIf
        Else
            cImpSaldo := Transform(Abs(nSaldo),cPicture)+cCharSinal
        EndIf
        
        If lGraf                                                
            If cIdentifi # Nil .And. cIdentifi $ "34"
                If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                    oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                Else
                    oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                EndIf
            Else
                oPrint:Say(nLin,nCol,cImpSaldo,oFont08)                
            Endif
        ElseIf lSay
            @ nLin, nCol pSay cImpSaldo 
        Endif
        
    Else
        //Utiliza conceito de conta estourada e a conta eh redutora.
        If Select("cArqTmp") > 0 .And. cArqTmp->(FieldPos("ESTOUR")) <> 0 .And.  cArqTmp->ESTOUR == "1"
            If cTipo == "1"                                 // Conta Devedora
                If cTipoSinal == "S"                          // Sinal
                    If !lSinal
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E " + cPicture
                    EndIf 
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"                        
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else                        
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol PSAY nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                ElseIf (cTipoSinal) == "P"                  // Parenteses
                    If !lSinal 
                        nSaldo := Abs(nSaldo)
                    EndIf

                    If !lInformada                         
                        cPicture := "@E( " + cPicture
                    EndIf
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"                    
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol pSay nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                EndIf
            Else
                If (cTipoSinal) == "S"                      // Sinal
                    If lSinal 
                        nSaldo := nSaldo * (-1)
//                    If !lSinal .And. cTipo == "2"             // Conta Credora
                    Else
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E " + cPicture
                    EndIf 
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol PSAY nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                ElseIf (cTipoSinal) == "P"              // Parenteses
                    If lSinal                  
                        nSaldo := nSaldo * (-1)                    
//                    If !lSinal .And. cTipo == "2"             // Conta Credora
                    Else
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E( " + cPicture
                    EndIf    
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            // Debito
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif                    
                    ElseIf lSay
                        @ nLin, nCol pSay nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                EndIf        
            EndIf        
        Else    //Se nao utiliza conceito de conta estourada
            If cTipo == "1"                                 // Conta Devedora
                If cTipoSinal == "S"                          // Sinal
                    If lSinal
                        nSaldo := nSaldo * (-1)
                    Else
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E " + cPicture
                    EndIf 
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol PSAY nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)            
                    Endif
                ElseIf (cTipoSinal) == "P"                  // Parenteses
                    If lSinal 
                        nSaldo := nSaldo * (-1)                   // a Picture so exibe parenteses para numeros negativos
                    Else
                        nSaldo := Abs(nSaldo)
                    EndIf
            
                    If !lInformada                         
                        cPicture := "@E( " + cPicture
                    EndIf
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol pSay nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                EndIf
            Else
                If (cTipoSinal) == "S"                      // Sinal
                    If !lSinal .And. cTipo == "2"             // Conta Credora
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E " + cPicture
                    EndIf 
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture)            
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif
                    ElseIf lSay
                        @ nLin, nCol PSAY nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                ElseIf (cTipoSinal) == "P"              // Parenteses
                    If !lSinal .And. cTipo == "2"         // Conta Credora
                        nSaldo := Abs(nSaldo)
                    EndIf
                    If !lInformada
                        cPicture := "@E( " + cPicture
                    EndIf    
                    If lGraf
                        cImpSaldo := Transform(nSaldo,cPicture) // Debito
                        If cIdentifi # Nil .And. cIdentifi $ "34"
                            If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
                            Else
                                oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
                            EndIf
                        Else
                            oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
                        Endif                    
                    ElseIf lSay
                        @ nLin, nCol pSay nSaldo Picture cPicture
                    Else
                        cImpSaldo := Transform(nSaldo,cPicture)                
                    Endif
                EndIf
            EndIf
        EndIf
    EndIf
EndIf
RestArea(aSaveArea)
         
If lSay
    Return
Else
    If Empty( cImpSaldo )
        If lPrintZero
            cImpSaldo := Transform(nSaldo,cPicture)   
        EndIf
    EndIf
    Return cImpSaldo
EndIf
