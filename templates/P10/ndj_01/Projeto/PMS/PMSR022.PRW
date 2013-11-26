#INCLUDE "NDJ.CH"

User Function PMSR022

Local cHTML          := ""
Local cQuery         := ""
Local cAlias         := GetNextAlias() 	
Local nLin
Local wCor                                                                                                             












Private cPerg        := 'R022'
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "PMSR022"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0

Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PMSR022"
Private cString      := ""

MSGBOX("Para obtenção de informações estratégicas se faz necessário a geração do relatório em excel.", "ATENÇÃO","INFO")

CriaAjuSX1()

Pergunte( cPerg, .T. )

If !ApOleClient("MsExcel")
   MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
   Return
EndIf

cQuery := MemoRead( "\SQL\prevreal.sql" )
cQuery += " "

If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02) .AND. !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
   cQuery += " WHERE "
   cQuery += " AF8_PROJET>='"+MV_PAR01+"' AND AF8_PROJET<='"+MV_PAR02+"'"
   cQuery += " AND "   
   cQuery += " AF8_XCODOR>='"+MV_PAR03+"' AND AF8_XCODOR<='"+MV_PAR04+"'"
Else
   If !Empty(MV_PAR01) .AND. !Empty(MV_PAR02) .AND. Empty(MV_PAR03) .AND. Empty(MV_PAR04)
      cQuery += " WHERE "
      cQuery += " AF8_PROJET>='"+MV_PAR01+"' AND AF8_PROJET<='"+MV_PAR02+"'"
   Else
      If Empty(MV_PAR01) .AND. Empty(MV_PAR02) .AND. !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
         cQuery += " WHERE "
         cQuery += " AF8_XCODOR>='"+MV_PAR03+"' AND AF8_XCODOR<='"+MV_PAR04+"'"
      EndIf   
   EndIf
EndIf   

cQuery += " "
cQuery += "ORDER BY AF8_PROJET, AF8_REVISA, AF8_XCODOR"

dbUseArea(.T.,"TOPCONN",TcGenQry(NIL,NIL,cQuery),cAlias)

cHTML	:= "<table cellpadding='3' cellspacing='0' align='center' summary=''>"
cHTML	+= "<tr><td colspan='6'><span><h2>RELATÓRIO DE PROPOSTAS DE AÇÃO (PREVISTO X REALIZADO)</h2></span></td></tr>"

cHTML	+= "<tr></tr>"
cHTML	+= "<tr><td>Legenda =></td>"
cHTML	+= "<td>PESSOA JURÍDICA:</td>"
cHTML	+= "<td>SJ-Serviços PJ</td></tr>"
cHTML	+= "<tr><td></td><td></td><td>MO-Mão de Obra<td></tr>"

cHTML	+= "<td></td><td>PESSOAL:</td>"
cHTML	+= "<td>PE-Pessoal (Celetistas e Estagiários)</td></tr>"

cHTML	+= "<td></td><td>PESSOA FÍSICA:</td>"    
cHTML	+= "<td>SF-Serviços</td></tr>"

cHTML	+= "<td></td><td>OPERACIONAIS ADMINISTRATIVOS:</td>"
cHTML	+= "<td>OA-Operacionais Administrativos</td></tr>"

cHTML	+= "<td></td><td>CAPITAL:</td>"
cHTML	+= "<td>MU-Movéis e Utensílios</td></tr>"
cHTML	+= "<tr><td></td><td></td><td>HW-Harware<td></tr>"
cHTML	+= "<tr><td></td><td></td><td>MA-Máquinas e Aparelhos<td></tr>"
cHTML	+= "<tr><td></td><td></td><td>SW-Software<td></tr>"
cHTML	+= "<tr><td></td><td></td><td>BO-Benfeitorias e Obras Próprias<td></tr>"

cHTML	+= "<td></td><td>VIAGENS:</td>"
cHTML	+= "<td>VI-Viagens Internacionais</td></tr>"
cHTML	+= "<tr><td></td><td></td><td>VN-Viagens Nacionais<td></tr>"
cHTML	+= "<tr></tr>"

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
                                  
cHTML	+= "<tr bgcolor='#000099'>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"     
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"     
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>" 
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"  
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"      
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"   
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"   	      	   

//cHTML	+= "<tr><td colspan='6'><span><h2>RELATÓRIO DE PROPOSTAS DE AÇÃO (PREVISTO X REALIZADO)</h2></span></td></tr>"

cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>PESSOA JURÍDICA</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>PESSOAL</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>PESSOA FÍSICA</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>OPERACIONAIS ADMINISTRATIVOS</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>CAPITAL</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>VIAGENS</center></font></b></span></td>"
cHTML	+= "<td colspan='2'><span><b><font color='#FFFFFF'><center>TOTAIS</center></font></b></span></td>"

cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'><font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'></font></b></td>"
cHTML	+= "</tr>"

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

cHTML	+= "<tr bgcolor='#000099'>"
cHTML	+= "<td><b><font color='#FFFFFF'>Id Projeto</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Revisão Projeto</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Nome da Ação</font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'>Id Orçamento</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Origem de Recurso</font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'>Desc. Origem</font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'>Item</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Diretoria</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Unidade Organ.</font></b></td>"     
cHTML	+= "<td><b><font color='#FFFFFF'>Sponsor</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Gerente</font></b></td>"     
cHTML	+= "<td><b><font color='#FFFFFF'>Tipo de Ação</font></b></td>" 
cHTML	+= "<td><b><font color='#FFFFFF'>Macroprocesso</font></b></td>"  
cHTML	+= "<td><b><font color='#FFFFFF'>Indicador 1</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Indicador 2</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Macroprocesso Interno</font></b></td>"      
cHTML	+= "<td><b><font color='#FFFFFF'>Tema Estatégico</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Objetivo Estratégico</font></b></td>"   
cHTML	+= "<td><b><font color='#FFFFFF'>Programa</font></b></td>"   	      	   

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO</font></b></td>"

/*
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - PESSOA JURÍDICA</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - PESSOA JURÍDICA</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - PESSOAL</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - PESSOAL</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - PESSOA FÍSICA</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - PESSOA FÍSICA</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - OPERACIONAIS ADMINISTRATIVOS</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - OPERACIONAIS ADMINISTRATIVOS</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - CAPITAL</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - CAPITAL</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>PREVISTO  - VIAGENS</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>REALIZADO - VIAGENS</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Total PREVISTO</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Total REALIZADO</font></b></td>"
*/

cHTML	+= "<td><b><font color='#FFFFFF'>Data Inicial</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Data Final</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Status</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Fase</font></b></td>"
cHTML	+= "<td><b><font color='#FFFFFF'>Descricao da Fase</font></b></td>"       
cHTML	+= "<td><b><font color='#FFFFFF'>Prioridade</font></b></td>"
cHTML	+= "</tr>"

nlin    := 0

While ( cAlias )->( !Eof() )

    If mod(nlin,2) = 0
       wcor = "'##D3D3D3'"
   	Else 
       wcor = "'##FFFFFF'"   
   	Endif
   	 
    cHTML += "<tr bgcolor="+wcor+">"  
    cHTML += "<td>"+"'"+( ( cAlias )->AF8_PROJET )+"</td>"
    cHTML += "<td>"+"'"+( ( cAlias )->AF8_REVISA )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_DESCRI )+"</td>"
    cHTML += "<td>"+"'"+( ( cAlias )->AF1_ORCAME )+"</td>"
    cHTML += "<td>"+"'"+( ( cAlias )->AF1_XCODOR )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDORIG )+"</td>"
    cHTML += "<td>"+"'"+( ( cAlias )->Item       )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDIR   )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XUNIOR )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XSPON  )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XGER   )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDESTA )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XMACRO )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XIND   )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XINDS  )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XPMORG )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XTEMA  )+"</td>"       
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDESC  )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDPROG )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->PREVPESJUR )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALPESJUR )+"</td>"                 

    cHTML += "<td>"+    ( ( cAlias )->PREVPESSOAL )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALPESSOAL )+"</td>"

    cHTML += "<td>"+    ( ( cAlias )->PREVPESFIS )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALPESFIS )+"</td>"       
    cHTML += "<td>"+    ( ( cAlias )->PREVOPERADM)+"</td>" 
    cHTML += "<td>"+    ( ( cAlias )->REALOPERADM)+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->PREVCAPITAL)+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALCAPITAL)+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->PREVVIAGEM )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALVIAGEM )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->PREVTOTORC )+"</td>"
    cHTML += "<td>"+    ( ( cAlias )->REALTOTORC )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDATIN )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XDATFI )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->DESCSTATUS )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_FASE   )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->DESCFASE   )+"</td>"
    cHTML += "<td>"+"" +( ( cAlias )->AF1_XPRIO  )+"</td>"        		          
    cHTML += "</tr>"    
 
	nlin := nlin + 1
		
	( cAlias )->( dbSkip() )
End While
( cAlias )->( dbCloseArea() )

cHTML   += "</table>"

MemoWrite( AllTrim(GetTempPath())+"prevreal1.htm", cHTML )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+"prevreal1.htm")
oExcelApp:SetVisible(.T.)  
oExcelApp:Destroy()

MSGBOX("Geração do relatório, em excel, concluída com sucesso.", "ATENÇÃO","INFO")

Return( NIL )

// --------------------------------------------------------------------------
// Cria e Atualiza SX1
// --------------------------------------------------------------------------
Static Function CriaAjuSX1()

Local aRegs
LOCAL aArea
LOCAL nFCount
LOCAL nARegs
LOCAL aSx1Stru
LOCAL nI
LOCAL nJ


LOCAL nTamPerg
LOCAL aNewSx1Stru
LOCAL cNmCampo
LOCAL uDdCampo

aRegs := {}
        
dbSelectArea("SX1")
SX1->(dbSetOrder(1)) 

If SX1->(dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+"07")) .And. SX1->X1_TAMANHO = 6
   While !SX1->(Eof()) .And. SX1->(dbSeek(cPerg)) 
       SX1->(RecLock("SX1",.F.))
	   SX1->(dbDelete())
	   SX1->(MsUnlock())   
	EndDo
EndIf

aadd(aRegs,{cPerg,"01","Projeto De"                   ,"","","mv_ch1","C",10,0,0,"G","","mv_par01",""            ,""    ,"","","",""               ,""     ,"","","",""              ,""     ,"","","",""       ,"","","","","","","","","AF8" ,"","","","",""})
aadd(aRegs,{cPerg,"02","Projeto Ate"                  ,"","","mv_ch2","C",10,0,0,"G","","mv_par02",""            ,""    ,"","","",""               ,""     ,"","","",""              ,""     ,"","","",""       ,"","","","","","","","","AF8" ,"","","","",""})
aadd(aRegs,{cPerg,"03","Orig.Rec. De"                 ,"","","mv_ch3","C", 3,0,0,"G","","mv_par03",""            ,""    ,"","","",""               ,""     ,"","","",""              ,""     ,"","","",""       ,"","","","","","","","","SZF" ,"","","","",""})
aadd(aRegs,{cPerg,"04","Orig.Rec. Ate"                ,"","","mv_ch4","C", 3,0,0,"G","","mv_par04",""            ,""    ,"","","",""               ,""     ,"","","",""              ,""     ,"","","",""       ,"","","","","","","","","SZF" ,"","","","",""})

aArea		:= GetArea()
nFCount	    := SX1->( Fcount() )
nARegs	    := Len( aRegs )
aSx1Stru    := SX1->( DbStruct() )
nTamPerg    := aSx1Stru[1,3]
aNewSx1Stru := aSx1Stru

ProcRegua(nARegs)
SX1->(dbSetOrder(1))   

FOR nI := 1 TO nARegs
    aRegs[nI][1] := aRegs[nI][1] + space(nTamPerg - len(aRegs[nI][1])) 
    
	IF !SX1->(MsSeek(aRegs[nI][1]+aRegs[nI][2]))
		RecLock('SX1',.T.)
		
  	    For nj:=1 To Len(aRegs[nI])      
  	        cNmCampo := aNewSx1Stru[nj][1]
  	        uDdCampo := aRegs[nI,nj]
		    If !Empty(FieldName(FieldPos(cNmCampo)))
		       FieldPut(FieldPos(cNmCampo),uDdCampo)
		    EndIf
	    Next nj
		
	    MsUnlock()
   	    IncProc("Atualizando Perguntas de Relatorios...") //"Atualizando Perguntas do Relatorio..."		
	ENDIF
NEXT nI

RestArea( aArea )
RETURN NIL

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF !( lRecursa )
			BREAK
		EndIF
		lRecursa	:= __Dummy( .F. )
		__cCRLF		:= NIL
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )