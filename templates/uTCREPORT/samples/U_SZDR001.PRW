#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "uTCREPORT.ch"
#INCLUDE "uTCREPORTDef.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSZDR001    บ Autor ณCarlos Andrade      บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Contas a Pagar x Cheques Emitidos                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALOMAO ZOPPI DIAGNOSTICOS                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SZDR001()

uTCREPORT Activate

Return(SZDR001())

Static Function SZDR001()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Contas a Pagar x Cheques Emitidos"
Local cPict        := ""
Local titulo       := "Contas a Pagar x Cheques Emitidos"
Local nLin         := 80
Local Cabec1       := "Emiss. Cheque    Cod. Fornec   Desc. Fornec.               Num. Titulo    Venc. Titulo    Num. Cheque    Valor Cheque    Cod.Banco    Desc. Banco        Dt. Compensacao. Cheque"
Local Cabec2       := ""
Local imprime      := .T.
Local cPerg        := "SZDR001"
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "U_SZDR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0   
Private m_pag        := 1
Private wnrel      := "U_SZDR001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SEF"

dbSelectArea("SEF")
dbSetOrder(1)

ValidPerg(cPerg)
    
If ! Pergunte(cPerg, .T.)
    Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.F.)
    
    If nLastKey == 27
        Return
    Endif
    
    SetDefault(aReturn,cString)
    
    If nLastKey == 27
       Return
    Endif
    
nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Carlos Andrade     บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

MontaQuery()
dbSelectArea( cAlias )
dbGoTop()

While ( cAlias ) -> ( !EOF() )

   //MsgRun("Gerando Relatorio, Aguarde...","Contas a Pagar x Cheques Emitidos",{|| Nil})
   
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif 
                
   @nLin,000 PSAY STOD( ( cAlias )-> EF_DATA )
   @nLin,023 PSAY ( cAlias )-> EF_FORNECE                                                                             
   @nLin,037 PSAY ( cAlias )-> A2_NOME
   @nLin,080 PSAY ( cAlias )-> EF_TITULO
   
   dVencReal := Posicione( "SE2",1,xFilial("SE2")+(cAlias)-> EF_TITULO, "E2_VENCREA" )
   
   @nLin,095 PSAY ( dVencReal )
   @nLin,111 PSAY ( cAlias )-> E5_NUMCHEQ
   @nLin,124 PSAY Transform(( cAlias )-> E5_VALOR, "@E 99,999.99" )
   @nLin,143 PSAY ( cAlias )-> EF_BANCO
   @nLin,156 PSAY ( cAlias )-> A6_NOME
   @nLin,184 PSAY STOD( ( cAlias )-> E5_DTDISPO )
   
   nLin +=1
  
   DbSelectArea( cAlias )
   ( cAlias )->( dbSkip() )
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQueryบAutor  ณCarlos Andrade      บ Data ณ  23/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar Tabela Temporaria para impressao dos registros       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALOMAO ZOPPI DIAGNOSTICOS                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MontaQuery()

Local cQuery 
Local cChequeDe        := MV_PAR01
Local cChequeAte    := MV_PAR02
Local dEmissaoDe    := MV_PAR03
Local dEmissaoAte    := MV_PAR04

Public cAlias         := GetNextAlias()

cQuery := "SELECT " + CRLF
cQuery += "        A2_COD, "  + CRLF
cQuery += "        A2_NOME, " + CRLF
cQuery += "        EF_FILIAL, " + CRLF
cQuery += "        EF_BANCO, " + CRLF
cQuery += "        EF_AGENCIA, " + CRLF
cQuery += "        EF_CONTA, " + CRLF
cQuery += "        A6_NOME, " + CRLF
cQuery += "        ISNULL(E5_NUMCHEQ,'') AS E5_NUMCHEQ, " + CRLF
cQuery += "        ISNULL(E5_VALOR,0) AS E5_VALOR, " + CRLF
cQuery += "        ISNULL(E5_DTDISPO,'') AS E5_DTDISPO, "+ CRLF
cQuery += "        EF_DATA, "  + CRLF
cQuery += "        EF_FORNECE, " + CRLF
cQuery += "        EF_TITULO " + CRLF
cQuery += " FROM " + CRLF 
cQuery += "      " + RetSqlName( "SEF") + " SEF" + CRLF
cQuery += " INNER JOIN " 
cQuery += "            " + RetSQLName ("SA6") + " SA6 " + CRLF
cQuery += " ON SA6.A6_FILIAL = '" + xFilial("SA6") + "' " + CRLF
cQuery += " AND SA6.A6_COD = SEF.EF_BANCO AND SA6.A6_AGENCIA = SEF.EF_AGENCIA " + CRLF
cQuery += " AND SA6.A6_NUMCON = SEF.EF_CONTA AND SA6.D_E_L_E_T_=' '" + CRLF              
cQuery += "    INNER JOIN "                                 
cQuery += "            " + RetSQLName ("SA2") + " SA2 " + CRLF
cQuery += " ON SA2.A2_FILIAL  = '" + xFilial("SA2")+ "' " + CRLF
cQuery += " AND SA2.A2_COD = SEF.EF_FORNECE AND SA2.A2_LOJA = SEF.EF_LOJA AND SA2.D_E_L_E_T_= ' '" + CRLF
cQuery += " LEFT OUTER JOIN " 
cQuery += "            " + RetSQLName ("SE5") + " SE5 " + CRLF
cQuery += " ON SE5.E5_FILIAL = '" + xFilial("SE5")+ "' " + CRLF
cQuery += " AND SEF.EF_FILIAL = SE5.E5_FILIAL AND SEF.EF_BANCO = SE5.E5_BANCO AND " + CRLF
cQuery += " SEF.EF_AGENCIA = SE5.E5_AGENCIA AND SEF.EF_CONTA = SE5.E5_CONTA  AND " + CRLF
cQuery += " SEF.EF_NUM = SE5.E5_NUMCHEQ AND SEF.EF_TIPO = SE5.E5_TIPODOC AND " + CRLF
cQuery += " SEF.EF_FORNECE=SE5.E5_CLIFOR" 
cQuery += " AND " + CRLF
cQuery += " SE5.E5_TIPODOC ='CH' AND SE5.E5_RECPAG='P' AND SE5.D_E_L_E_T_= ' ' " + CRLF
cQuery += " WHERE " 
cQuery += "     SEF.EF_TIPO = 'CH' " + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_NUM >= '" + cChequeDe + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_NUM <= '" + cChequeAte + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_DATA >= '" + DTOS(dEmissaoDe) + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "        SEF.EF_DATA <= '" + DTOS(dEmissaoAte) + "'" + CRLF
/*
cQuery := "SELECT " + CRLF
cQuery += "        EF_DATA, "  + CRLF
cQuery += "        EF_FORNECE, " + CRLF
cQuery += "        A2_NOME, " + CRLF
cQuery += "        EF_TITULO, " + CRLF
cQuery += "        EF_NUM, " + CRLF
cQuery += "        EF_VALOR, " + CRLF
cQuery += "        EF_BANCO, " + CRLF
cQuery += "        A6_NOME, " + CRLF
cQuery += "        E2_VENCREA, " + CRLF
cQuery += "        E5_DTDISPO "+ CRLF  
cQuery += " FROM " + CRLF 
cQuery += "      " + RetSqlName( "SEF") + " SEF" + CRLF
cQuery += " INNER JOIN " 
cQuery += "            " + RetSQLName ("SE2") + " SE2 " + CRLF
cQuery += " ON SEF.EF_FILIAL = '" + xFilial("SEF") + "' " + CRLF 
cQuery += "    INNER JOIN "
cQuery += "            " + RetSQLName ("SE5") + " SE5 " + CRLF
cQuery += " ON SE5.E5_FILIAL  = '" + xFilial("SE5")+ "' " + CRLF
cQuery += "    INNER JOIN " 
cQuery += "            " + RetSQLName ("SA2") + " SA2 " + CRLF
cQuery += " ON SA2.A2_FILIAL = '" + xFilial("SA2")+ "' " + CRLF
cQuery += " AND " + CRLF 
cQuery += "    SA2.A2_COD = SE5.E5_CLIFOR" + CRLF
cQuery += "    INNER JOIN " + CRLF 
cQuery += "            " + RetSQLName ("SA6") + " SA6 " + CRLF
cQuery += " ON SA6.A6_FILIAL = '" + xFilial("SA6")+ "' " + CRLF
cQuery += " WHERE " 
cQuery += "     SEF.EF_TITULO = SE2.E2_NUM " + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_TIPO = 'CH' " + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_NUM >= '" + cChequeDe + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_NUM <= '" + cChequeAte + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.EF_DATA >= '" + DTOS(dEmissaoDe) + "'" + CRLF
cQuery += " AND " + CRLF
cQuery += "        SEF.EF_DATA <= '" + DTOS(dEmissaoAte) + "'" + CRLF 
cQuery += " AND " + CRLF                
cQuery += "     SEF.EF_LOJA = SE2.E2_LOJA " + CRLF
cQuery += " AND " + CRLF
cQuery += "     SEF.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND " + CRLF 
cQuery += "    SE5.E5_CLIFOR = SE2.E2_FORNECE " + CRLF
cQuery += " AND " + CRLF
cQuery += "    SE5.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND " + CRLF
cQuery += "    SA2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND " + CRLF 
cQuery += "   SA6.A6_COD = SE5.E5_BANCO" + CRLF
cQuery += " AND " + CRLF
cQuery += "   SA6.D_E_L_E_T_ = ' ' " + CRLF
*/ 
     
cQuery := ChangeQuery( cQuery )

If Select(cAlias) > 0
   DbSelectArea(cAlias)
   DbCloseArea()
Endif   

TCQUERY ( cQuery ) ALIAS ( cAlias ) NEW

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณCarlos Andrade      บ Data ณ  23/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criar Grupo de Perguntas em tempo de execucao              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALOMAO ZOPPI DIAGNOSTICOS                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg(cPerSX1)


PutSx1(cPerSX1, '01', 'Cheque De   ?','','','mv_ch1','C',TamSX3('EF_NUM' )[1]        ,0,0,'G','','SEF'      ,'','','mv_par01','','','','','','','','','','','','',''  ,'')
PutSx1(cPerSX1, '02', 'Cheque Ate  ?','','','mv_ch2','C',TamSX3('EF_NUM' )[1]        ,0,0,'G','','SEF'      ,'','','mv_par02','','','','','','','','','','','','',''  ,'')
PutSx1(cPerSX1, '03', 'Emissao De  ?','','','mv_ch3','D',TamSX3('EF_DATA')[1]        ,0,0,'G','',''         ,'','','mv_par03','','','','','','','','','','','','',''  ,'')
PutSx1(cPerSX1, '04', 'Emissao Ate ?','','','mv_ch4','D',TamSX3('EF_DATA')[1]        ,0,0,'G','',''         ,'','','mv_par04','','','','','','','','','','','','',''  ,'')

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณCarlos Andrade      บ Data ณ  24/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do Parametro                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SALOMAO ZOPPI DIAGNOSTICOS                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ValField()

If Empty( MV_PAR02 )
    MsgInfo("Favor preencher o parametro. " )
EndIf

If Empty( MV_PAR04 )
    MsgInfo("Favor preencher o parametro. " )
EndIf

Return     
