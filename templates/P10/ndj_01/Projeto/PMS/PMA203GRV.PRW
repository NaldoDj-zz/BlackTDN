#INCLUDE "NDJ.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IUSUARIO Autor ³ LAPORTE               º Data ³  22/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA GRAVAÇÃO DE REGISTROS NA TABELA CTT  º±±
±±º          ³ (CENTRO DE CUSTOS) APÓS A ALTERAÇÃO OU INCLUSÃO            º±±
±±º          ³ DE UMA NOVA TAREFA                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AFB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 


User Function PMA203GRV()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ESTA FUNÇÃO TEM O OBJETIVO DE INSERIR UM NOVO CENTRO DE CUSTOS NA   ³
//³ ALTERAÇÃO OU INCLUSÃO DE UMA TAREFA EM PROJETO                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
CTT->(DBSETORDER(1))
WCODCC = SPACE(13)
WCODCC = AFB->AFB_XCODOR+AFB->AFB_PROJET 
IF CTT->(!DBSEEK(XFILIAL("CTT")+WCODCC)) .and. AFB->AFB_PROJET <> space(10)
  RecLock("CTT",.T.)
   CTT->CTT_FILIAL := XFILIAL("CTT")
   CTT->CTT_CLASSE := "2"   
   CTT->CTT_CUSTO  := WCODCC
   CTT->CTT_DESC01 := AF8->AF8_DESCRI
   CTT->CTT_BLOQ   := "1"   
   CTT->CTT_DTEXIS := DATE()
   CTT->CTT_CCLP   := WCODCC
   CTT->CTT_ITOBRG := "2" 
   CTT->CTT_CLOBRG := "2"
   CTT->CTT_ACITEM := "1"              
   CTT->CTT_ACCLVL := "1" 
   MSUNLOCK() 
   StaticCall(PM110AFB, EMAILFIN)
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
