#INCLUDE "NDJ.CH"
/*/
ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ܍
�����������������������������������������������������������������������������
��ɍ͍͍͍͍͍͍͍͍͍͑ˍ͍͍͍э͍͍͍͍͍͍͍͍͍͍͍͍͋э͍͍͍͍͍͍���
���Programa  � NDJ0085  � Autor � Jose Carlos Noronha� Data �  05/10/10   ���
��͍͍͍͍͍͍͍͍͍̍͘ʍ͍͍͍ύ͍͍͍͍͍͍͍͍͍͍͍͍͊ύ͍͍͍͍͍͍���
���Descricao � Troca das Matriculas dos Funcionarios nas Tabelas da Folha ���
���          � Para Estagiarios e Autonomos. (Filiais 70 e 80)            ���
��͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍̍͘���
���Uso       �                                                            ���
��ȍ͍͍͍͍͏͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍���
�����������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߍ
/*/
User Function NDJ0085

Local ocbSR0
Local ocbSR1
Local ocbSR2
Local ocbSR3
Local ocbSR4
Local ocbSR7
Local ocbSR8
Local ocbSR9
//Local ocbSRA
Local ocbSRB
Local ocbSRC
Local ocbSRD
Local ocbSRE
Local ocbSRF
Local ocbSRG
Local ocbSRH
Local ocbSRI
Local ocbSRK
Local ocbSRL
Local ocbSRO
Local ocbSRP
Local ocbSRQ
Local ocbSRR
Local ocbSRS
Local ocbSRT
//Local ocbSRZ
Local oSay1
Local oSay2
Local oGroup1
Private cMV_PAR1 := "  /  " 
Private lcbSR0 := .F.
Private lcbSR1 := .F.
Private lcbSR2 := .F.
Private lcbSR3 := .F.
Private lcbSR4 := .F.
Private lcbSR7 := .F.
Private lcbSR8 := .F.
Private lcbSR9 := .F.
//Private lcbSRA := .F.
Private lcbSRB := .F.
Private lcbSRC := .F.
Private lcbSRD := .F.
Private lcbSRE := .F.
Private lcbSRF := .F.
Private lcbSRG := .F.
Private lcbSRH := .F.
Private lcbSRI := .F.
Private lcbSRK := .F.
Private lcbSRL := .F.
Private lcbSRO := .F.
Private lcbSRP := .F.
Private lcbSRQ := .F.
Private lcbSRR := .F.
Private lcbSRS := .F.
Private lcbSRT := .F.
//Private lcbSRZ := .F.

Private aDePara  := {}
Private oProcess := Nil
Private _oDlg
Private VISUAL   := .F.
Private INCLUI   := .F.
Private LALTERA  := .F.
Private DELETA   := .F.

Private _MV_PAR1 := "  /  "
Private _MV_PAR2 := "  /  "

DEFINE MSDIALOG _oDlg TITLE "Troca de Matriculas - Filiais 70 e 80" FROM C(178),C(181) TO C(535),C(866) PIXEL
@ C(006),C(011) Say "Selecione as Tabelas:" Size C(054),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(020),C(010) CheckBox ocbSR0 Var lcbSR0 Prompt "SR0 - Itens Vale-Transporte" Size C(095),C(008) PIXEL OF _oDlg
@ C(020),C(125) CheckBox ocbSR1 Var lcbSR1 Prompt "SR1 - Valores Extras" Size C(095),C(008) PIXEL OF _oDlg
@ C(020),C(240) CheckBox ocbSR2 Var lcbSR2 Prompt "SR2 - RAIS" Size C(095),C(008) PIXEL OF _oDlg
@ C(030),C(010) CheckBox ocbSR3 Var lcbSR3 Prompt "SR3 - Historico Valores Salariais" Size C(095),C(008) PIXEL OF _oDlg
@ C(030),C(125) CheckBox ocbSR4 Var lcbSR4 Prompt "SR4 - Itens DIRF/Informe Rendimento" Size C(095),C(008) PIXEL OF _oDlg
@ C(030),C(240) CheckBox ocbSR7 Var lcbSR7 Prompt "SR7 - Historico Alteracoes Salariais" Size C(095),C(008) PIXEL OF _oDlg
@ C(040),C(010) CheckBox ocbSR8 Var lcbSR8 Prompt "SR8 - Controle de Ausencias" Size C(095),C(008) PIXEL OF _oDlg
@ C(040),C(125) CheckBox ocbSR9 Var lcbSR9 Prompt "SR9 - Histrorico Dados Funcionarios" Size C(095),C(008) PIXEL OF _oDlg
//@ C(040),C(240) CheckBox ocbSRA Var lcbSRA Prompt "SRA - Funcionarios" Size C(095),C(008) PIXEL OF _oDlg
@ C(050),C(010) CheckBox ocbSRB Var lcbSRB Prompt "SRB - Dependentes" Size C(095),C(008) PIXEL OF _oDlg
@ C(050),C(125) CheckBox ocbSRC Var lcbSRC Prompt "SRC - Movimento do Periodo" Size C(095),C(008) PIXEL OF _oDlg
@ C(050),C(240) CheckBox ocbSRD Var lcbSRD Prompt "SRD - Historico de Movimentos" Size C(095),C(008) PIXEL OF _oDlg
@ C(060),C(010) CheckBox ocbSRE Var lcbSRE Prompt "SRE - Transferencias" Size C(095),C(008) PIXEL OF _oDlg
@ C(060),C(125) CheckBox ocbSRF Var lcbSRF Prompt "SRF - Programa碯 de Ferias" Size C(095),C(008) PIXEL OF _oDlg
@ C(060),C(240) CheckBox ocbSRG Var lcbSRG Prompt "SRG - Rescisoes" Size C(095),C(008) PIXEL OF _oDlg
@ C(070),C(010) CheckBox ocbSRH Var lcbSRH Prompt "SRH - Ferias" Size C(095),C(008) PIXEL OF _oDlg
@ C(070),C(125) CheckBox ocbSRI Var lcbSRI Prompt "SRI - Movimento 2o. Parcela 13" Size C(095),C(008) PIXEL OF _oDlg
@ C(070),C(240) CheckBox ocbSRK Var lcbSRK Prompt "SRK - Movimento de Valores Futuros" Size C(095),C(008) PIXEL OF _oDlg
@ C(080),C(010) CheckBox osbSRL Var lcbSRL Prompt "SRL - DIRF/Informe Rendimentos" Size C(095),C(008) PIXEL OF _oDlg
@ C(080),C(125) CheckBox ocbSRQ Var lcbSRQ Prompt "SRQ - Beneficiarios" Size C(095),C(008) PIXEL OF _oDlg
@ C(080),C(240) CheckBox ocbSRS Var lcbSRS Prompt "SRS - Saldos do FGTS" Size C(095),C(008) PIXEL OF _oDlg
@ C(090),C(010) CheckBox ocbSRR Var lcbSRR Prompt "SRR - Itens de Ferias e Rescisoes" Size C(095),C(008) PIXEL OF _oDlg
@ C(090),C(125) CheckBox ocbSRP Var lcbSRP Prompt "SRP - Demonstrativos de Medias" Size C(095),C(008) PIXEL OF _oDlg
@ C(090),C(240) CheckBox ocbSRO Var lcbSRO Prompt "SRO - Movimento de Tarefas" Size C(095),C(008) PIXEL OF _oDlg
//@ C(100),C(010) CheckBox ocbSRZ Var lcbSRZ Prompt "SRZ - Resumo da Folha" Size C(095),C(008) PIXEL OF _oDlg
@ C(100),C(010) CheckBox ocbSRT Var lcbSRT Prompt "SRT - Movimento de Provisoes" Size C(095),C(008) PIXEL OF _oDlg
@ C(136),C(300) Button "Processar" Size C(037),C(012) Action ProcDePara() PIXEL OF _oDlg
@ C(154),C(300) Button "Cancelar"  Size C(037),C(012) Action _oDlg:End()  PIXEL OF _oDlg

//@ 145, 010 SAY oSay1 PROMPT "De Mes/Ano" SIZE 032, 010 OF _oDlg COLORS 0, 16777215 PIXEL
//@ 145, 055 MSGET _MV_PAR1 VAR cMV_PAR1 Picture "99/99/99" SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL
//@ 160, 010 SAY oSay2 PROMPT "At頍es/Ano" SIZE 032, 010 OF _oDlg COLORS 0, 16777215 PIXEL
//@ 160, 055 MSGET _MV_PAR2 VAR cMV_PAR2  Picture "99/99/99" SIZE 030, 012 OF _oDlg COLORS 0, 16777215 PIXEL

@ 145, 003 GROUP oGroup1 TO 183, 173 PROMPT "  Per���o Para  Arquivos do Cᬣulo da Folha  " OF _oDlg COLOR 0, 16777215 PIXEL
@ 162, 012 SAY oSay1 PROMPT "Mes/Ano"  SIZE 037, 007 OF _oDlg COLORS 0, 16777215 PIXEL
@ 161, 055 MSGET _MV_PAR1 VAR cMV_PAR1  Picture "99/99" SIZE 020, 010 OF _oDlg COLORS 0, 16777215 PIXEL
//@ 181, 012 SAY oSay2 PROMPT "At頍es/Ano" SIZE 039, 007 OF _oDlg COLORS 0, 16777215 PIXEL
//@ 179, 055 MSGET _MV_PAR2 VAR cMV_PAR2  Picture "99/99" SIZE 020, 010 OF _oDlg COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG _oDlg CENTERED

Return

/*/
ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ܍
�����������������������������������������������������������������������������
��ɍ͍͍͍͍͍͍͍͍͍͍͑ˍ͍͍͍э͍͍͍͍͍͍͍͍͍͍͍͍͋э͍͍͍͍͍���
���Funcao    � ProcDePara � Autor � Jose Carlos Noronha� Data �  02/07/07 ���
��͍͍͍͍͍͍͍͍͍͍̍͘ʍ͍͍͍ύ͍͍͍͍͍͍͍͍͍͍͍͍͊ύ͍͍͍͍͍���
���Descricao � Prepara Carga das Tabelas Para De/Para                     ���
��͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍̍͘���
���Uso       �                                                            ���
��ȍ͍͍͍͍͏͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍���
�����������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߍ
/*/
Static Function ProcDePara()
// Arquivo .DBF De/Para matricula
// Este arquivo deve ser gravado na pasta protheus_data\system
cArqTrb := "DEPARAMAT.DBF"
DbUseArea( .T.,"DBFCDXADS",cArqTrb,"TMP",.F.)

// 01/11/2010 - Noronha
dbselectarea("TMP")
ZAP
dbselectarea("SRA")
dbgotop()
Do While ! EOF()
    _MatDe   := SRA->RA_XMATAN
    _FilDe   := SRA->RA_XFILAN
    _MatPara := SRA->RA_MAT
    _FilPara := SRA->RA_FILIAL 
    If (SRA->RA_XMATAN == SRA->RA_MAT) .And. (SRA->RA_XFILAN == SRA->RA_FILIAL)
       dbselectarea("SRA")
       dbskip()
       Loop
    Endif   
    dbselectarea("TMP")
    Reclock("TMP",.T.)
    TMP->RA_XMATAN := _MatDe
    TMP->RA_XFILAN := _FilDe
    TMP->RA_MAT    := _MatPara 
    TMP->RA_FILIAL := _FilPara 
    dbselectarea("SRA")
    dbskip()
Enddo    
dbselectarea("TMP")
dbgotop()

If lcbSR0
    aadd(aDepara,{"SR0", "R0_FILIAL" ,"R0_MAT","Itens Vale-Transporte",""})
Endif

If lcbSR1
    aadd(aDepara,{"SR1", "R1_FILIAL", "R1_MAT", "Valores Extras",""})
Endif

If lcbSR2
    aadd(aDepara,{"SR2", "R2_FILIAL" , "R2_MAT","RAIS",""})
Endif

If lcbSR3
    aadd(aDepara,{"SR3", "R3_FILIAL", "R3_MAT","Historico Valores Salariais",""})
Endif

If lcbSR4
    aadd(aDepara,{"SR4", "R4_FILIAL", "R4_MAT","Itens DIRF/Informe Rendimento",""})
Endif

If lcbSR7
    aadd(aDepara,{"SR7", "R7_FILIAL", "R7_MAT","Historico Alteracoes Salariais",""})
Endif

If lcbSR8
    aadd(aDepara,{"SR8", "R8_FILIAL", "R8_MAT","Controle de Ausencias",""})
Endif

If lcbSR9
    aadd(aDepara,{"SR9", "R9_FILIAL", "R9_MAT","Histrorico Dados Funcionarios",""})
Endif

//If lcbSRA
//    aadd(aDepara,{"SRA", "RA_FILIAL", "RA_MAT","Funcionarios",""})
//Endif

If lcbSRB
    aadd(aDepara,{"SRB", "RB_FILIAL", "RB_MAT","Dependentes",""})
Endif

If lcbSRC
    aadd(aDepara,{"SRC", "RC_FILIAL", "RC_MAT","Movimento do Periodo",""})
Endif

If lcbSRD
    aadd(aDepara,{"SRD", "RD_FILIAL", "RD_MAT","Historico de Movimentos",""})
Endif

If lcbSRE
    aadd(aDepara,{"SRE", "RE_FILIAL", "RE_MATD","Transferencias",""})
    aadd(aDepara,{"SRE", "RE_FILIAL", "RE_MATP","Transferencias",""})
Endif

If lcbSRF
    aadd(aDepara,{"SRF", "RF_FILIAL", "RF_MAT","Programa碯 de Ferias",""})
Endif

If lcbSRG
    aadd(aDepara,{"SRG", "RG_FILIAL", "RG_MAT","Rescisoes",""})
Endif

If lcbSRH
    aadd(aDepara,{"SRH", "RH_FILIAL", "RH_MAT","Ferias",""})
Endif

If lcbSRI
    aadd(aDepara,{"SRI", "RI_FILIAL", "RI_MAT","Movimento 2o. Parcela 13",""})
Endif

If lcbSRK
    aadd(aDepara,{"SRK", "RK_FILIAL", "RK_MAT","Movimento de Valores Futuros",""})
Endif

If lcbSRL
    aadd(aDepara,{"SRL", "RL_FILIAL", "RL_MAT","DIRF/Informe Rendimentos",""})
Endif

If lcbSRO
    aadd(aDepara,{"SRO", "RO_FILIAL", "RO_MAT","Movimento de Tarefas",""})
Endif

If lcbSRP
    aadd(aDepara,{"SRP", "RP_FILIAL", "RP_MAT","Demonstrativos de Medias",""})
Endif

If lcbSRQ
    aadd(aDepara,{"SRQ", "RQ_FILIAL", "RQ_MAT","Beneficiarios",""})
Endif

If lcbSRR
    aadd(aDepara,{"SRR", "RR_FILIAL", "RR_MAT","Itens de Ferias e Rescisoes",""})
Endif

If lcbSRS
    aadd(aDepara,{"SRS", "RS_FILIAL", "RS_MAT","Saldos do FGTS",""})
Endif

If lcbSRT
    aadd(aDepara,{"SRT", "RT_FILIAL", "RT_MAT","Movimento de Provisoes",""})
Endif

//If lcbSRZ
//    aadd(aDepara,{"SRZ", "RZ_FILIAL", "RZ_MAT","Resumo da Folha",""})
//Endif

oProcess := MsNewProcess():New({|lEnd| FazDePara(lEnd,oProcess)},"Processando","Lendo...",.T.)
oProcess:Activate()

dbselectarea("TMP")
dbclosearea()

ALERT("FIM")

Return Nil

/*/
ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ܍
�����������������������������������������������������������������������������
��ɍ͍͍͍͍͍͍͍͍͍͍͑ˍ͍͍͍э͍͍͍͍͍͍͍͍͍͍͍͍͋э͍͍͍͍͍���
���Funcao    � FazDePara  � Autor � Jose Carlos Noronha� Data �  02/07/07 ���
��͍͍͍͍͍͍͍͍͍͍̍͘ʍ͍͍͍ύ͍͍͍͍͍͍͍͍͍͍͍͍͊ύ͍͍͍͍͍���
���Descricao � Processar a Troca das Contas Contabeis                     ���
��͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍̍͘���
���Uso       �                                                            ���
��ȍ͍͍͍͍͏͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍͍���
�����������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߍ
/*/
Static Function FazDePara(lEnd,oObj)

Local I
Local nX

// Primeira Regua - Contas Contabeis
oObj:SetRegua1(Len(aDePara))
nSRE := 0
For nx:=1 To Len(aDePara)
    
    // Incrementa na Primeira Regua
    oObj:IncRegua1("Atualizando Tabela: "+aDePara[nx][1]+"-"+aDePara[nx][4])
    
    lInd := .F.
    dbselectarea(aDePara[nx][1])
    
    If lInd = .F.
        cFiltro := aDePara[nx][5]
        cChave  := aDePara[nx][2]+"+"+aDePara[nx][3]
        cInd    := CriaTrab(Nil,.F.)
        cArq    := aDePara[nx][1]
        lInd    := .T.
        If !Empty(cFiltro)
            IndRegua(cArq, cInd, cChave, ,cFiltro, "Selecionando Movimento...")
        Else
            IndRegua(cArq, cInd, cChave,,, "Selecionando Movimento...")
        Endif
    Endif
    
    // Segunda Regua - Tabelas
    dbselectarea("TMP")
    dbgotop()
    oObj:SetRegua2(Reccount())
    
    Do While ! EOF()
        
        _MatDe   := TMP->RA_XMATAN
        _FilDe   := TMP->RA_XFILAN
        _MatPara := TMP->RA_MAT
        _FilPara := TMP->RA_FILIAL
        
        // Incrementa na Segunda Regua
        oObj:IncRegua2("Matricula: "+_MatDe)
        
        _cCampo1 := aDePara[nx][2]
        _cCampo2 := aDePara[nx][3]
        
        If aDePara[nx][1] <> "SRE"
            
            dbselectarea(aDePara[nx][1])
            dbseek(_FilDe+_MatDe)
            
            Do While !EOF()
                dbseek(_FilDe+_MatDe)
                If Found()
                    Reclock(aDePara[nx][1],.F.)
                    Replace &_cCampo1 With     _FilPara
                    Replace &_cCampo2 With     _MatPara
                    MSunlock()
                Endif
            Enddo
            
        Else
            nSRE++
            If nSRE = 1
                
                dbselectarea(aDePara[nx][1])
                dbseek(_FilDe+_MatDe)
                
                Do While !EOF()
                    dbseek(_FilDe+_MatDe)
                    If Found()
                        Reclock(aDePara[nx][1],.F.)
                        Replace &_cCampo2 With     _MatPara
                        MSunlock()
                    Endif
                Enddo
            Else
                
                dbselectarea(aDePara[nx][1])
                dbseek(_FilDe+_MatPara)
                
                Do While !EOF()
                    dbseek(_FilDe+_MatPara)
                    If Found()
                        Reclock(aDePara[nx][1],.F.)
                        Replace &_cCampo1 With     _FilPara
                        MSunlock()
                    Endif
                Enddo
                
            Endif
        Endif
        dbselectarea("TMP")
        dbskip()
        
    Enddo
    
Next nx

If cMV_PAR1 <> "  /  " 
    // Incrementa na Primeira Regua
    cTabFol := "RC"+CEMPANT+Substr(cMV_PAR1,4,2)+Substr(cMV_PAR1,1,2)
    oObj:IncRegua1("Atualizando Tabela: "+cTabFol)
    cChave  := "RC_FILIAL+RC_MAT"
    If Select("TFOL")>0
       dbselectarea("TFOL")
       dbclosearea()
    Endif   
    dbUseArea(.T., "TOPCONN", cTabFol , "TFOL", .T., .F.)

    lInd := .F.
    dbselectarea("TFOL")
    
    If lInd = .F.
        cFiltro := ""
        cInd    := CriaTrab(Nil,.F.)
        cArq    := "TFOL"
        lInd    := .T.
        IndRegua(cArq, cInd, cChave,,, "Selecionando Movimento...")    
    Endif
    
    // Segunda Regua - Tabelas
    dbselectarea("TMP")
    dbgotop()
    oObj:SetRegua2(Reccount())
    
    Do While ! EOF()
        
        _MatDe   := TMP->RA_XMATAN
        _FilDe   := TMP->RA_XFILAN
        _MatPara := TMP->RA_MAT
        _FilPara := TMP->RA_FILIAL
        
        // Incrementa na Segunda Regua
        oObj:IncRegua2("Matricula: "+_MatDe)
        
        _cCampo1 := "RC_FILIAL"
        _cCampo2 := "RC_MAT"
        
        dbselectarea("TFOL")
        dbseek(_FilDe+_MatDe)
            
        Do While !EOF()
            dbseek(_FilDe+_MatDe)
            If Found()
                Reclock("TFOL",.F.)
                Replace &_cCampo1 With     _FilPara
                Replace &_cCampo2 With     _MatPara
                MSunlock()
            Endif
        Enddo
            
        dbselectarea("TMP")
        dbskip()
        
    Enddo

Endif

Return


/*ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ
��������������������������������������������������������������������������������
��ڄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĂĄĄĄĄĄĄĄĿ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
��ÄĄĄĄĄĄńĄĄĄĄDĄĄĄĄDĄĄĄĄĄĄĄĄĄĄĄāĄĄĄDĄĄĄĄĴ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
��ĄĄĄĄĄDĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄę��
��������������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟ*/
Static Function C(nTam)
Local nHRes    :=    oMainWnd:nClientWidth    // Resolucao horizontal do monitor
If nHRes == 640    // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
    nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)    // Resolucao 800x600
    nTam *= 1
Else    // Resolucao 1024x768 e acima
    nTam *= 1.28
EndIf

//ڄĄĄĄĄĄĄĄĄĄĄĄĄĄ�
//�Tratamento para tema "Flat"�
//ĄĄĄĄĄĄĄĄĄĄĄĄĄٍ
If "MP8" $ oApp:cVersion
    If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
        nTam *= 0.90
    EndIf
EndIf
Return Int(nTam)

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
