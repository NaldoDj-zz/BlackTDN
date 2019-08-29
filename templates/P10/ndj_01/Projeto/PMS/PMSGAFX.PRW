#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IUSUARIO Autor ³ LAPORTE               º Data ³  22/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ GRAVAÇÃO DA TABELA AFX010 COM OS USUARIOS QUE TERAM ACESSO º±±
±±º          ³ LIBERADO PARA UM DETERMINADO PROJETO                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AF1                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 

//User Function TSTUSER()
//     PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
//     U_IUSUARIO("0000000021","0000000021","000008") 
     
//Reset ENVIRONMENT

User Function PMSGAFX()

// alert("entrei neste ponto")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ESTA FUNÇÃO TEM O OBJETIVO DE INSERIR O USUARIO CONTROLER, GERENTE  ³
//³ E SPONSOR QUANDO DO FOR GERADO O PROJETO                            ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
AJF->(DBSETORDER(1)) 
IF AJF->(DBSEEK(XFILIAL("AJF")+AF8->AF8_ORCAME+Padr(AF8->AF8_ORCAME,TAMSX3("AJF_EDT")[1] )))
   WHILE .NOT. EOF() .AND. AJF->AJF_ORCAME = AF8->AF8_ORCAME
        WUSER = AJF->AJF_USER
        AFX->(DBSETORDER(1))
        IF AFX->(!DBSEEK(XFILIAL("AFX")+AF8->AF8_PROJET+space(TAMSX3("AFX_REVISA")[1])+Padr(AF8->AF8_PROJET,TAMSX3("AFX_EDT")[1] )+WUSER ))
            RecLock("AFX",.T.)
            AFX->AFX_FILIAL := xFilial("AFX")
            AFX->AFX_PROJET := AF8->AF8_PROJET
            AFX->AFX_EDT    := AF8->AF8_PROJET
            AFX->AFX_USER    := WUSER
            AFX->AFX_FASE    := "03"            
            AFX->AFX_ESTRUT := "3"
            AFX->AFX_DOCUME := "3"
            AFX->AFX_GERSC    := "4"  
            AFX->AFX_GERSA    := "4"
            AFX->AFX_GEROP    := "4"
            AFX->AFX_GERCP    := "4"
            AFX->AFX_GEREMP    := "4"
            AFX->AFX_CONFIR    := "4"
            AFX->AFX_NFE    := "4"
            AFX->AFX_REQUIS    := "4"
            AFX->AFX_DESP    := "4"
            AFX->AFX_RECEI    := "4"
            AFX->AFX_RECURS    := "4"
            AFX->AFX_NFS    := "4"
            AFX->AFX_MOVBAN    := "4"
            If AFX->(FieldPos("AFX_PREREC")) >0
                AFX->AFX_PREREC    := "4"
            EndIf
            If AFX->(FieldPos("AFX_APRPRE")) >0
                AFX->AFX_APRPRE    := "2"
            EndIf
            MsUnlock()
        endif
        dbselectarea("AJF")
        DbSkip()
   ENDDO
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
