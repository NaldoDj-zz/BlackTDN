#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  25/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORCAMENTO                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PMSR002


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELATORIO DE TESTE"
Local cPict          := ""
Local titulo         := "RELATORIO DE ORCAMENTOS POR DIRETORIA"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "PMSR002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0

Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PMSR002" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "AF1"

dbSelectArea("AF1")
dbSetOrder(1)      

Cabec1 = "DIR.  UNID. SPONSOR                      GERENTE                       DESC.ORCAMENTO                          TIPO                   ORIGEM                                  TEMA                           VALOR"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
msgbox("Para obtenção de informações estratégicas se faz necessário a geração do relatório em excel", "ATENÇÃO","INFO")
Pergunte("AF1REL2")

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  25/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("AF4")
cchave := "AF4_FILIAL+AF4_ORCAME+AF4_XORIRE"
cindexAF4 := CriaTrab(nil,.F.)
IndRegua("AF4",cindexAF4,cchave,,,"Selecionando Registros")     

dbSelectArea("AF1")
cchave := "AF1_FILIAL+AF1_XCODDI+AF1_XUNIOR"
cindexAF1 := CriaTrab(nil,.F.)
IndRegua("AF1",cindexAF1,cchave,,,"Selecionando Registros") 
   
dbSelectArea("AF1")
//dbSetOrder(1)
//dbGoTop()
if MV_PAR01 = 1 
  While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
  
   @nLin,00 PSAY AF1->AF1_XCODDI
   WUNIDADE = space(10) 
   dbSelectArea("SZI") 
   IF SZI->(DBSEEK(XFILIAL("SZI")+AF1->AF1_XUNIOR))
      WUNIDADE = SZI->ZI_XCODUNI
   ENDIF  
   dbSelectArea("AF1")   
   @nLin,06  PSAY WUNIDADE   
   @nLin,12  PSAY AF1->AF1_XSPON 
   @nLin,42  PSAY AF1->AF1_XGER
   @nLin,72  PSAY AF1->AF1_DESCRI
   @nLin,112 PSAY AF1->AF1_XDESTA
   @nLin,135 PSAY AF1->AF1_XDORIG
   @nLin,175 PSAY AF1->AF1_XTEMA
   wtotalger = 0.00
   //nLin := nLin + 1 // Avanca a linha de impressao 
   //Rotina para somar os valores das tarefas referentes ao projeto
   dbSelectArea("AF4")
   IF AF4->(DBSEEK(XFILIAL("AF4")+AF1->AF1_ORCAME)) 
      While !EOF() .AND. AF4->AF4_ORCAME = AF1->AF1_ORCAME 
            wtotalger +=  AF4->AF4_VALOR
            dbSkip()
       EndDo
       @nLin,205 PSAY wtotalger  picture "@E 999,999,999.99"         
   Endif         
   // Fim da rotina    
   nLin := nLin + 1 // Avanca a linha de impressao
   dbSelectArea("AF1")
   AF1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  EndDo

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Finaliza a execucao do relatorio...                                 ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  SET DEVICE TO SCREEN

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Se impressao em disco, chama o gerenciador de impressao...          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif

  MS_FLUSH()
  
else
  nlin = 9
  wlinha = space(232)
  wlinha = "<table cellpadding='3' cellspacing='0' align='center' summary=''>"
  @nlin,00 psay wlinha
  nlin += 1  
  wlinha = space(232)   
  wlinha = "<tr><td colspan='8'><span><h2>RELATORIO DE PROPOSTAS DE ACAO (ORCAMENTO)</td></h2></span></tr>"
  @nlin,00 psay wlinha
  nlin += 1     
  wlinha = space(232)  
  wlinha =  "<tr bgcolor='##ff9966'><td>Nome da Acao</td><td>Item</td><td>Origem de Recurso</td><td>Diretoria</td><td>Unidade Organ.</td><td>Sponsor</td>"
  wlinha += "<td>Gerente</td><td>Tipo de Acao</td><td>Macroprocesso</td><td>Indicador 1</td><td>Indicador 2</td>"
  wlinha += "<td>Macroprocesso Interno</td><td>Tema Estategico</td><td>Objetivo Estrategico</td><td>Programa</td><td>Contratos de Prestação de Serviços</td><td>Pessoal PJ</td>"
  wlinha += "<td>Pessoal PF</td><td>Pessoal CLT</td><td>Operacionail Administrativos</td><td>Capital</td><td>Viagem</td><td>Total Orcado</td><td>Data Inicial</td>"
  wlinha += "<td>Data Final</td><td>Status</td><td>Fase</td><td>Descricao da Fase</td><td>Prioridade</td></tr>"


  @nlin,00 psay wlinha
  nlin += 1     
  wlinha = space(232)
  While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
/* 
   wlinha  = "<tr bgcolor="+wcor+">"
   wlinha += "<td>"+AF1->AF1_DESCRI+"</td>"
   wlinha += "<td>"+AF1->AF1_XDIR+"</td>" 
   wlinha += "<td>"+AF1->AF1_XUNIOR+"</td>"      
   wlinha += "<td>"+AF1->AF1_XSPON+"</td>"
   wlinha += "<td>"+AF1->AF1_XGER+"</td>"
   wlinha += "<td>"+AF1->AF1_XDORIG+"</td>"
   wlinha += "<td>"+AF1->AF1_XDESTA+"</td>" 
   wlinha += "<td>"+AF1->AF1_XMACRO+"</td>"   
   wlinha += "<td>"+AF1->AF1_XIND+"</td>"  
   wlinha += "<td>"+AF1->AF1_XINDS+"</td>" 
   wlinha += "<td>"+AF1->AF1_XPMORG+"</td>"       
   wlinha += "<td>"+AF1->AF1_XTEMA+"</td>"
   wlinha += "<td>"+AF1->AF1_XDESC+"</td>"    
   wlinha += "<td>"+AF1->AF1_XDPROG+"</td>"        
 */
   wtotalger = 0.00
   //nLin := nLin + 1 // Avanca a linha de impressao 
   //Rotina para somar os valores das tarefas referentes ao projeto
   dbSelectArea("AF4")
   IF AF4->(DBSEEK(XFILIAL("AF4")+AF1->AF1_ORCAME))
      witem = 1                     
      While AF4->(!EOF()) .AND. (AF4->AF4_ORCAME = AF1->AF1_ORCAME)
          if mod(nlin,2) = 0
              wcor = "'##D3D3D3'"
             else 
              wcor = "'##FFFFFF'"   
             endif
             wlinha  = "<tr bgcolor="+wcor+">"               
             wlinha += "<td>"+AF1->AF1_DESCRI+"</td>"
             wlinha += "<td>"+str(witem,3)+"</td>"             
          wlinha += "<td>"+AF4->AF4_XORIRE+"</td>"              
             wlinha += "<td>"+AF1->AF1_XDIR+"</td>" 
             wlinha += "<td>"+AF1->AF1_XUNIOR+"</td>"      
             wlinha += "<td>"+AF1->AF1_XSPON+"</td>"
             wlinha += "<td>"+AF1->AF1_XGER+"</td>"      
             wlinha += "<td>"+AF1->AF1_XDESTA+"</td>" 
            wlinha += "<td>"+AF1->AF1_XMACRO+"</td>"   
             wlinha += "<td>"+AF1->AF1_XIND+"</td>"  
             wlinha += "<td>"+AF1->AF1_XINDS+"</td>" 
             wlinha += "<td>"+AF1->AF1_XPMORG+"</td>"       
             wlinha += "<td>"+AF1->AF1_XTEMA+"</td>"
             wlinha += "<td>"+AF1->AF1_XDESC+"</td>"    
             wlinha += "<td>"+AF1->AF1_XDPROG+"</td>"            
          WORIRE   = AF4->AF4_XORIRE    
          wtotalger = 0.00                      
          WTIPOD   = AF4->AF4_TIPOD
          WPJ      = 0.00
          WPESSOAL = 0.00         
          WPF      = 0.00 
          WPPF     = 0.00          
          WVIAGEM  = 0.00
          WCUSTEIO = 0.00
          WCAPITAL = 0.00
          WVALTOT  = 0.00   
          While AF4->(!EOF()) .AND. (AF4->AF4_ORCAME = AF1->AF1_ORCAME) .AND. (WORIRE = AF4->AF4_XORIRE)              
              IF AF4_TIPOD = "MU" .OR. AF4_TIPOD = "HW" .OR. AF4_TIPOD = "MA" .OR. AF4_TIPOD = "SW" .OR. AF4_TIPOD = "BO"  
                 WCAPITAL +=  AF4->AF4_VALOR 
              ENDIF
              IF AF4_TIPOD = "SJ"
                 WPJ +=  AF4->AF4_VALOR 
              ENDIF 
              IF AF4_TIPOD = "MO"
                 WPJ +=  AF4->AF4_VALOR 
              ENDIF                 
              IF AF4_TIPOD = "SF"
                 WPF +=  AF4->AF4_VALOR 
              ENDIF 
              IF AF4_TIPOD = "PE"
                 WPESSOAL +=  AF4->AF4_VALOR 
              ENDIF 
              IF AF4_TIPOD = "VI" .OR. AF4_TIPOD = "VN" 
                 WVIAGEM +=  AF4->AF4_VALOR 
              ENDIF              
              IF AF4_TIPOD = "OA"  
                 WCUSTEIO +=  AF4->AF4_VALOR 
              ENDIF     
              wtotalger += AF4->AF4_VALOR                                             
              AF4->(dbSkip())
          EndDo           
            wlinha += "<td>"+strtran(str(wpj,12,2),".",",")+"</td>"
          wlinha += "<td>"+strtran(str(wpf,12,2),".",",")+"</td>"
          wlinha += "<td>"+strtran(str(wppf,12,2),".",",")+"</td>"          
          wlinha += "<td>"+strtran(str(wpessoal,12,2),".",",")+"</td>"
          wlinha += "<td>"+strtran(str(wcusteio,12,2),".",",")+"</td>"
          wlinha += "<td>"+strtran(str(wcapital,12,2),".",",")+"</td>"
          wlinha += "<td>"+strtran(str(wviagem,12,2),".",",")+"</td>"  
          wlinha += "<td>"+strtran(str(wtotalger,12,2),".",",")+"</td>"           
             wlinha += "<td>"+dtoc(AF1->AF1_XDATIN)+"</td>"
          wlinha += "<td>"+dtoc(AF1->AF1_XDATFI)+"</td>"
             IF AF1->AF1_XSTATU = "1"
                 wlinha += "<td>NOVO</td>"
             ELSE  
              wlinha += "<td>EM CURSO</td>"   
             ENDIF   
             wlinha += "<td>"+AF1->AF1_FASE+"</td>"
             dbSelectArea("AE9")
             IF AE9->(DBSEEK(XFILIAL("AE9")+AF1->AF1_FASE)) 
              wlinha += "<td>"+AE9->AE9_DESCRI+"</td>"
             ELSE 
              wlinha += "<td>FASE NAO ENCONTRADA</td>"   
             ENDIF         
          wlinha += "<td>"+AF1->AF1_XPRIO+"</td>"  
          wlinha += "<td>"+AF1->AF1_XDESTA+"</td>"                    
          wlinha += "</tr>"   
          @nlin,00 psay wlinha   
          nlin += 1
          wlinha = space(232)
          witem += 1                    
       EndDo        
   Endif         
/*   wlinha += "<td>"+dtoc(AF1->AF1_XDATIN)+"</td>"
   wlinha += "<td>"+dtoc(AF1->AF1_XDATFI)+"</td>"
   IF AF1->AF1_XSTATU = "1"
      wlinha += "<td>NOVO</td>"
   ELSE  
      wlinha += "<td>EM CURSO</td>"   
   ENDIF   
   wlinha += "<td>"+AF1->AF1_FASE+"</td>"
   dbSelectArea("AE9")
   IF AE9->(DBSEEK(XFILIAL("AE9")+AF1->AF1_FASE)) 
      wlinha += "<td>"+AE9->AE9_DESCRI+"</td>"
   ELSE 
      wlinha += "<td>FASE NAO ENCONTRADA</td>"   
   ENDIF 
   */
   cObs = ""
//   cObs =  AF1->AF1_OBS  
//   wlinha += "<td>"+cObs+"</td>"  
//   wlinha += "<td>"+AF1->AF1_XPRIO+"</td>"                    
//   wlinha += "</tr>"   
//   @nlin,00 psay wlinha  
//   wlinha = space(232)      
   // Fim da rotina    
//   nLin := nLin + 1 // Avanca a linha de impressao
   dbSelectArea("AF1")
   dbSkip() // Avanca o ponteiro do registro no arquivo
  EndDo
  nlin += 1                            
  wlinha ="</table>"
  If !ApOleClient("MsExcel")
     MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
    Return
  EndIf
  MS_FLUSH()       
  __CopyFile(__reldir+wnrel+".##R" , AllTrim(GetTempPath())+wnrel+".HTM")
    
  oExcelApp:= MsExcel():New()
  oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+wnrel+".HTM")
  oExcelApp:SetVisible(.T.)   
endif  

Return
  
Static Function __Dummy( lRecursa )
    Local oException
    TRYEXCEPTION
        lRecursa := .F.
        IF !( lRecursa )
            BREAK
        EndIF
        lRecursa    := __Dummy( .F. )
        __cCRLF        := NIL
    CATCHEXCEPTION USING oException
    ENDEXCEPTION
Return( lRecursa )
