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

User Function PMSR023


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELATORIO DE TESTE"
Local cPict          := ""
Local titulo         := "RELATORIO DE SOLICITAÇÃO DE COMPRAS"
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
Private nomeprog     := "PMSR023" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PMSR023" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC1"

dbSelectArea("SC1")
dbSetOrder(1)      

Cabec1 = "DIR.  UNID. SPONSOR                      GERENTE                       DESC.ORCAMENTO                          TIPO                   ORIGEM                                  TEMA                           VALOR"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
msgbox("Devido a quantidade de colunas, este relatório só poderá ser exportado para Excel", "ATENÇÃO","INFO")
//Pergunte("AF1REL2")
Pergunte("SC1REL1")
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


Local cTESTE    := GetNextAlias()

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
wdata1 = STRZERO(YEAR(MV_PAR01),4)+STRZERO(MONTH(MV_PAR01),2)+STRZERO(DAY(MV_PAR01),2)
wdata2 = STRZERO(YEAR(MV_PAR02),4)+STRZERO(MONTH(MV_PAR02),2)+STRZERO(DAY(MV_PAR02),2)
cQuery  = ""
cQuery +="select C1_NUM," 
cQuery +="C1_ITEM," 
cQuery +="C1_XNUMPRO," 
cQuery +="C1_SOLICIT,"
cQuery +="(SELECT AF8_DESCRI FROM AF8010 WHERE AF8_PROJET = C1_XPROJET and AF8_REVISA = C1_XREVISA AND D_E_L_E_T_ = '') AS DESCRICAO,"
cQuery +="(SELECT AF8_XGER   FROM AF8010 WHERE AF8_PROJET = C1_XPROJET and AF8_REVISA = C1_XREVISA AND D_E_L_E_T_ = '') AS GERENTE,"
cQuery +="(SELECT AF8_XSPON  FROM AF8010 WHERE AF8_PROJET = C1_XPROJET and AF8_REVISA = C1_XREVISA AND D_E_L_E_T_ = '') AS SPONSOR,"
cQuery +="C1_XPROJET,"
cQuery +="C1_XTAREFA,"
cQuery +="C1_XCODOR,"
cQuery +="(select ZF_XDESORI FROM SZF010 WHERE (CONVERT(INT, ZF_XCODORI))=(CONVERT(INT, C1_XCODOR))) AS [DESC_ORIGEM],"
cQuery +="C1_PRODUTO,"
cQuery +="C1_DESCRI,"
cQuery +="C1_QUANT,"
cQuery +="C1_XTOTAL,"  
cQuery +="CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C1_XEQUIPA)) AS INFORMA"     
cQuery +=" from SC1010 where SC1010.D_E_L_E_T_ <> '*' and C1_XPROJET >= '"+MV_PAR03+"' and C1_XPROJET <= '"+MV_PAR04+"' and "    
cQuery +=" C1_EMISSAO >= '"+wdata1+"' and C1_EMISSAO <= '"+wdata2+"' "    
cQuery +=" ORDER BY C1_NUM"
TcQuery ( cQuery ) ALIAS ( cTESTE ) NEW 

   
dbSelectArea(cTESTE)
//dbSetOrder(1)
//dbGoTop()    
wexcel = 2
if wexcel = 1 
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
  
   @nLin,00  PSAY (cTESTE)->C1_NUM 
   @nLin,06  PSAY (cTESTE)->C1_ITEM   
   @nLin,12  PSAY (cTESTE)->C1_XNUMPRO 
   @nLin,42  PSAY (cTESTE)->C1_SOLICIT
   @nLin,72  PSAY (cTESTE)->GERENTE
   @nLin,112 PSAY (cTESTE)->SPONSOR
   @nLin,135 PSAY (cTESTE)->C1_XPROJET
   @nLin,175 PSAY (cTESTE)->C1_XTAREFA  
   @nLin,175 PSAY (cTESTE)->C1_XCODOR
   @nLin,175 PSAY (cTESTE)->DESC_ORIGEM
   @nLin,175 PSAY (cTESTE)->C1_PRODUTO
   @nLin,175 PSAY (cTESTE)->C1_DESCRI
   @nLin,175 PSAY (cTESTE)->C1_QUANT
   @nLin,175 PSAY (cTESTE)->C1_XTOTAL           
   wtotalger = 0.00
   //nLin := nLin + 1 // Avanca a linha de impressao 
   //Rotina para somar os valores das tarefas referentes ao projeto
   (cTESTE)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
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
  wlinha = "<tr><td colspan='8'><span><h2>RELATORIO DE SOLICITAÇÕES DE COMPRAS POR PROJETO E TAREFA</td></h2></span></tr>"
  @nlin,00 psay wlinha
  nlin += 1     
  wlinha = space(232)  
  wlinha =  "<tr bgcolor='##ff9966' colspan='15'><td>Numero</td><td>Item</td><td>Processo</td><td>Situacao</td><td>solicitante</td><td>Gerente</td>"
  wlinha += "<td>Sponsor</td><td>Projeto</td><td>Descrição</td><td>Tarefa</td><td>Codigo da Origem</td><td>Descrição</td>"
  wlinha += "<td>Produto</td><td>Desc Produto</td><td>Quantidade</td><td>Valor</td><td>Informação</td></tr>"


  @nlin,00 psay wlinha
  nlin += 1     
  wlinha = space(232)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
   //nLin := nLin + 1 // Avanca a linha de impressao 
   //Rotina para somar os valores das tarefas referentes ao projeto
   dbSelectArea(cTESTE)
   While (cTESTE)->(!EOF()) 
      wsituacao = space(30)
      
      dbSelectArea("SC1")
      if SC1->(DBSEEK(XFILIAL("SC1")+(cTESTE)->C1_NUM+(cTESTE)->C1_ITEM))
        wsituacao = StaticCall( U_MT110COR , GetC1Status)
      endif                    
      if mod(nlin,2) = 0
         wcor = "'##D3D3D3'"
      else 
         wcor = "'##FFFFFF'"   
         endif
        wlinha  = "<tr bgcolor="+wcor+" colspan='15'>"               
        wlinha += "<td>'"+(cTESTE)->C1_NUM+"</td>"
        wlinha += "<td>'"+(cTESTE)->C1_ITEM+"</td>"             
     wlinha += "<td>"+(cTESTE)->C1_XNUMPRO+"</td>"  
     wlinha += "<td>"+WSITUACAO+"</td>"                 
        wlinha += "<td>"+(cTESTE)->C1_SOLICIT+"</td>" 
        wlinha += "<td>"+(cTESTE)->GERENTE+"</td>"      
        wlinha += "<td>"+(cTESTE)->SPONSOR+"</td>"
        wlinha += "<td>'"+(cTESTE)->C1_XPROJET+"</td>"     
        wlinha += "<td>"+(cTESTE)->DESCRICAO+"</td>"          
        wlinha += "<td>'"+(cTESTE)->C1_XTAREFA+"</td>" 
       wlinha += "<td>'"+(cTESTE)->C1_XCODOR+"</td>"   
        wlinha += "<td>"+(cTESTE)->DESC_ORIGEM+"</td>"  
        wlinha += "<td>"+(cTESTE)->C1_PRODUTO+"</td>" 
        wlinha += "<td>"+(cTESTE)->C1_DESCRI+"</td>"       
        wlinha += "<td>"+str((cTESTE)->C1_QUANT,4)+"</td>" 
        wlinha += "<td>"+strtran(str((cTESTE)->C1_XTOTAL,12,2),".",",")+"</td>" 
        wlinha += "<td>"+(cTESTE)->INFORMA+"</td></tr>"       
     @nlin,00 psay wlinha
     nlin += 1     
     wlinha = space(232)                        
     dbSelectArea(cTESTE)
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
(cTESTE)->( dbCloseArea() )
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
