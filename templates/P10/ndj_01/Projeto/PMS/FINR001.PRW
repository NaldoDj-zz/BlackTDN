#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//===================================================================== */
/* ==================================================================== */
User Function FINR001
/* ==================================================================== */
Local clblTpRel   := "Número da Conta:"
Local cQuery      := ""

//Local oFont	      := TFont():New("Arial",,14,,.T.)

Local oFont	      := NIL
Local oRadio	  := NIL	

Local oDlgSint	  := NIL
Local oGrupo  	  := NIL

Local nRecCount
Local nOpc        := 0                      
Local nLinha
Local nPosCombo
Local nIndex 

Local cIndex      := ""
Local cChave      := ""


Local _aSize      := {}

Local oPanel

Private nOpcRad	  := 1
Private nTipRel



Private aGrupos   := {"70000-2"}

Private aCampos   := {}
Private cGrupo    := ""
Private cMarca    := GetMark()

cNmArqGrid := Alltrim( CriaTrab(,.F.) )


_aSize     := MsAdvSize()
_aSize [1] := 1
_aSize [5] := 502 
widx = 1

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Relatório Financeiro Por Natureza") From 1, 1 TO 200, 502 OF oMainWnd PIXEL

@ 000,000 MSPANEL oPanel OF oDlg
oPanel:Align	:= CONTROL_ALIGN_ALLCLIENT

nLinha   := _aSize [1] + 4

@ nLinha,( _aSize [1] +  3  ) Say OemToAnsi(clblTpRel  )                   OF oPanel  SIZE 060,015 PIXEL FONT oFont COLOR CLR_HBLUE
@ nLinha,( _aSize [1] + 45  ) COMBOBOX oGrupo    Var cGrupo  ITEMS aGrupos OF oPanel  SIZE 060,015 PIXEL FONT oFont ON CHANGE ChgColBrow()
                                                                                                                          
@ ( _aSize [1] +  05 ),( _aSize [1] + 185 ) BUTTON OemToAnsi("Finalizar")             SIZE 060,015 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())OF oPanel PIXEL
@ ( _aSize [1] +  25 ),( _aSize [1] + 185 ) BUTTON OemToAnsi("Gerar Relatório PDF")   SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fExecRelat(2) }, "Aguarde", OemToAnsi("Gerando arquivo pdf..."     ), .F. ) OF oPanel PIXEL
@ ( _aSize [1] +  45 ),( _aSize [1] + 185 ) BUTTON OemToAnsi("Gerar Relatório EXCEL") SIZE 060,015 FONT oDlg:oFont ACTION MsAguarde( {|| fExecRelat(3) }, "Aguarde", OemToAnsi("Gerando arquivo xls..."     ), .F. ) OF oPanel PIXEL

                         	
ACTIVATE MSDIALOG oDlg


Return

Static Function fExecRelat(wtiporel)

Local bBloco 
Local cQuery := ""                  

cQuery := "select *, (case NIVEL when '1' then 'CREDITO' when '9' then 'CREDITO' else 'DEBITO' end) descnivel, ISNULL((SELECT ED_DESCRIC FROM SED010 WHERE ED_CODIGO = GRUPO),'SALDO INICIAL') AS DESCGRUPO  from ("
cQuery += "select ED_CODIGO,"
cQuery += "ED_DESCRIC,"
cQuery += "SUBSTRING(ED_CODIGO,1,1) AS NIVEL,"
cQuery += "SUBSTRING(ED_CODIGO,1,3) AS GRUPO,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='01' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') JAN,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='02' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') FEV,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='03' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') MAR,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='04' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') ABR,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='05' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') MAI,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='06' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') JUN,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='07' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') JUL,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='08' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') AGO,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='09' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') [SET],"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='10' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') [OUT],"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='11' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') NOV,"
cQuery += "(SELECT ISNULL(SUM(E5_VALOR),0) FROM SE5010 WHERE SUBSTRING(E5_DATA,5,2)='12' AND E5_SITUACA <> 'C' AND SUBSTRING(E5_DATA,1,4)='2011' AND E5_NATUREZ = ED_CODIGO AND E5_CONTA = '"+cGrupo+"' AND D_E_L_E_T_ <> '*') DEZ "
cQuery += "from SED010 WHERE ED_TIPO = '2' AND SED010.D_E_L_E_T_ <> '*' AND ED_CODIGO < '999999999' and ED_CODIGO <> '90101' and ED_CODIGO <> '90102') as tab1 "
cQuery += "ORDER BY GRUPO, ED_CODIGO"


/*                        
1) Exemplo de chamada a query que será gravada na pasta SQL dentro do RootPath do Protheus
com o nome de modelo.sql e cuja geração será de um arquivo PDF com o nome de modelo.pdf
fIReport( , cQuery, .T., 2, "modelo" )

2) Exemplo de chamada a query que será gravada na pasta SQL dentro do RootPath do Protheus
com o nome de modelo.sql e cuja geração será de um arquivo XLS com o nome de modelo.xls
fIReport( , cQuery, .T., 3, "modelo" )

3) Exemplo de chamada a query contida no arquivo modelo.sql gravada na pasta SQL dentro do 
RootPath do Protheus, onde a geração/exibição será de um arquivo PDF com o nome de modelo.pdf
fIReport( "modelo",,, 2, "modelo" )

4) Exemplo apresentando o uso da função com exibição de mensagem ao usuário de que o relatório
está sendo gerado.
bBloco := {|| fIReport( "modelo",,, 2, "modelo" ) }

MsAguarde( bBloco , "Aguarde", OemToAnsi("Gerando Relatório..."), .F. )   
*/

bBloco := {|| fIReport( , cQuery, .T., wtiporel, "relnatureza",  ) }

MsAguarde( bBloco , "Aguarde", OemToAnsi("Gerando Relatório..."), .F. )   

Return( Nil )

/* ---------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------- */
Static Function fIReport( cArqSql, cQuery, lGravaQuery, nTipoVisual, cNomeRelJasper, cPathJava )
/*
Lista de parâmetros:
cArqSql        -> Parâmetro para passagem de arquivo com a extensão SQL, que deve estar gravado 
                  no diretório SQL dentro do ROOTPATH do Protheus, e que contém a query  a  ser 
                  executada pela aplicação para a geração/exibição do relatório.
                  Obs.: Basta passar o nome do arquivo sem a há a necessidade de  definição  da 
                        extensão.                                                                            

cQuery         -> Parâmetro que permite a passagem de uma query criada dinamicamente.

<<< OBRIGATORIEDADE DE PREENCHIMENTO >>>
Obs.: Se faz necessário que um dos parâmetros acima estejam preenchidos.Quando do preenchimento
      de um deles o outro passa a não ser obrigatório. Em caso de não preenchimento de qualquer
      um dos dois, a função retornará mensagem indicando esta situação.

lGravaQuery    -> Controle boleano que permite gravar a query  que  está  sendo  passada,  como
                  arquivo no diretório SQL dentro do ROOTPATH do Protheus. Quando estiver  como 
                  .T. a  query  será  gravada com o mesmo nome  do  arquivo iReport ( parâmetro
                  cNomeRelJasper ).
                  Obs.: O preenchimento deste parâmetro não é obrigatório. Por padrão a  função 
                        assume que não há a necessidade de gravação da query como arquivo.

nTipoVisual    -> Define se o arquivo a ser gerado/exibido será do tipo 2 (PDF) ou 3(XLS). 
                  Obs.: O preenchimento deste parâmetro não é obrigatório. Por padrão o  tipo 2
                        (PDF) está pré-definido.                        

cNomeRelJasper -> Nome do arquivo ireport desenvolvido e que também será utilizado como nome do 
                  arquivo que será gerado/exibido não importando o tipo de arquivo (PDF ou XLS)
                  pré-definido no parâmetro nTipoVisual.
                  Obs.: CAMPO OBRIGATÓRIO. 

cPathJava      -> Local de instalação do java no servidor (JVM - Máquina Virtual do Java)
                  Obs.: O preenchimento deste parâmetro não é obrigatório. Por padrão  o  local 
                        de instalação do java no servidor já está setado nesta função. 
                        
Obs.: A função retornará .T. sempre que a geração/exibição do relatório ocorrer sem problemas e 
      .F. quando do contrário.                                                 
*/
/* ---------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------- */
Local cRootPath     := ""     
Local cNmArqSQL     := ""
Local cVisualiza    := ""
Local cString       := ""
Local cNmArq1       := ""
Local cNmArq2       := ""
Local cDateTime     := ""
Local cMensSemExcel := OemToAnsi( "Microsoft Excel não instalado." )
Local cMensErro     := OemToAnsi( "Não foi possível gerar/exibir o relatório." )
Local lExecutou     := .F.

Default cPathJava   := "C:\Program Files (x86)\Java\jre6\bin\"
Default nTipoVisual := 2
Default lGravaQuery := .F.
Default cQuery      := ""

If ( ( nTipoVisual == 2 ) .Or. ( nTipoVisual == 3 ) )

   If nTipoVisual == 3
   
      If !ApOleClient("MsExcel")
      
         MsgStop( cMensSemExcel )
         Return( lExecutou )
      EndIf
   EndIf              
   
   If ( ( cArqSql == "" ) .And. ( cQuery == "" ) )

      MsgStop("Pesquisa não detectada para geração/exibição do relatório.")
      Return( lExecutou )
   EndIf      

   If cQuery <> ""

      cNmArqSQL := cNomeRelJasper+".sql"
         
      If File( "\SQL\"+cNmArqSQL )
         
         cDateTime := DTOC( MsDate() ) + "_" + Time()
                                                      
         cDateTime := SUBSTR( cDateTime, 07, 4 ) + "_" + ;
                      SUBSTR( cDateTime, 04, 2 ) + "_" + ;
                      SUBSTR( cDateTime, 01, 2 ) + "_" + ;
                      SUBSTR( cDateTime, 12, 8 )
             
         //cDateTime := "12/05/2011_16:38:00"
                               
         While ( AT( ":", cDateTime ) <> 0 )
           cDateTime := STUFF( cDateTime, AT( ":", cDateTime ), 1, "_" )
         EndDo                                                                 
                  
         FRename( "\SQL\"+cNmArqSQL, "\SQL\"+StrTran(cNmArqSQL,".sql", "_" + cDateTime + ".sql" ) )
      EndIf

      MemoWrite( "\SQL\"+cNmArqSQL, cQuery )
      
   Else 
      cNmArqSQL := cArqSql+".sql"
   EndIf      
      
   cRootPath  := GetSrvProfString( "ROOTPATH", "" )
   cDirFile   := cRootPath + "\web\reports\ExecIReport\dist\ExecIReport.jar"
      
   While ( AT( "\", cRootPath ) <> 0 )
     cRootPath := STUFF( cRootPath, AT( "\", cRootPath ), 1, "." )
   EndDo                                               
      
   While ( AT( ".", cRootPath ) <> 0 )
     cRootPath := STUFF( cRootPath, AT( ".", cRootPath ), 1, "\\" )        
   EndDo                                                           

   cRootPath  := cRootPath + "\\web\\reports\\"
   cVisualiza := AllTrim(Str(nTipoVisual))
                  
   cString    := "'"
   cString    += cPathJava + "JAVA.EXE -jar "
   cString    += '"' + cDirFile       + '" '
   cString    += '"' + cNmArqSQL      + '" '
   cString    += '"' + cVisualiza     + '" '   
   cString    += '"' + cNomeRelJasper + '" '
   cString    += '"' + cRootPath      + "ExecIReport\\ireport.properties" + '" '
   cString    += '"' + "0"            + '"'
   cString    += "'"
                           
   lExecutou  := WAITRUNSRV( &cString, .T., cPathJava )
   
   If ! lExecutou
   
      MsgStop( cMensErro )
      Return( lExecutou )      
   Else
   
      If nTipoVisual == 2
      
         cNmArq1 := "\web\reports\PDFTEMP\"+cNomeRelJasper+".pdf"
         cNmArq2 := AllTrim(GetTempPath()) +cNomeRelJasper+".pdf"
      Else 
      
         cNmArq1 := "\web\reports\XLSTEMP\"+cNomeRelJasper+".xls"
         cNmArq2 := AllTrim(GetTempPath()) +cNomeRelJasper+".xls"
      EndIf                                                                   

      lExecutou  := __copyfile( cNmArq1, cNmArq2 )
      
      If ! lExecutou
   
         MsgStop( cMensErro )
         Return( lExecutou )      
      Else   
      
         If cQuery <> ""
         
            If ! lGravaQuery
                     
               FErase( "\SQL\"+cNmArqSQL )
            EndIf  
                        
         EndIf
            
         FErase( cNmArq1 )

         If lExecutou
            ShellExecute( "Open", cNmArq2, "", AllTrim(GetTempPath()), 1 )      
         EndIf         
         
      EndIf      
      
   EndIf      
   
EndIf

Return( lExecutou )

   
