#INCLUDE "NDJ.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIUSUARIO Autor ณ LAPORTE               บ Data ณ  22/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ GRAVAวรO DA TABELA AJF010 COM O USUARIO QUE TERม ACESSO    บฑฑ
ฑฑบ          ณ LIBERADO PARA UM DETERMINADO PROJETO                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AF1                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                 

//User Function TSTUSER()
//     PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
//     U_IUSUARIO("0000000021","0000000021","000008") 
     
//Reset ENVIRONMENT

User Function PMA100SA()

Local aUsu := {}
WORCAME := AF1->AF1_ORCAME 
WEDT    := AF1->AF1_ORCAME  
//ALERT("ORCAMENTO - "+AF1->AF1_ORCAME)
WUSER   := {"000096","000004","000099"} 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ESTA FUNวรO TEM O OBJETIVO DE INSERIR O USUARIO CONTROLER           ณ
//ณ QUANDO DO CADASTRO DE NOVOS ORCAMENTOS                              ณ
//ณ                                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


aUsu := ALLUSERS()
widx = 1
while widx <= len(aUsu)
     if aUsu[widx][1][4] = AF1->AF1_XSPON 
        RECLOCK("AF1",.F.)
        AF1->AF1_XCODSP  := aUsu[widx][1][1]  
        MSUNLOCK()
        AJF->(DBSETORDER(1))
        IF AJF->(!DBSEEK(XFILIAL("AJF")+WORCAME+Padr(WEDT,TAMSX3("AJF_EDT")[1] )+aUsu[widx][1][1]))
   			RECLOCK("AJF",.T.)
   			AJF->AJF_FILIAL := XFILIAL("AJF")
   			AJF->AJF_ORCAME := WORCAME
   			AJF->AJF_EDT    := WEDT
   			AJF->AJF_USER   := aUsu[widx][1][1]
   			AJF_PROJET      := "2"
   			AJF_ESTRUT      := "3"
   			AJF_DOCUME      := "4"   
		    MSUNLOCK()
   		endif		                
     endif  
     if aUsu[widx][1][4] = AF1->AF1_XGER
        RECLOCK("AF1",.F.)
        AF1->AF1_XCODGE  := aUsu[widx][1][1] 
        MSUNLOCK() 
        AJF->(DBSETORDER(1))
        IF AJF->(!DBSEEK(XFILIAL("AJF")+WORCAME+Padr(WEDT,TAMSX3("AJF_EDT")[1] )+aUsu[widx][1][1]))
   			RECLOCK("AJF",.T.)
   			AJF->AJF_FILIAL := XFILIAL("AJF")
   			AJF->AJF_ORCAME := WORCAME
   			AJF->AJF_EDT    := WEDT
   			AJF->AJF_USER   := aUsu[widx][1][1]
   			AJF_PROJET      := "2"
   			AJF_ESTRUT      := "3"
   			AJF_DOCUME      := "4"   
		    MSUNLOCK()
   		endif		            
     endif  
     widx += 1
enddo   

widx = 1
AJF->(DBSETORDER(1))
do while widx <= LEN(WUSER)
   IF AJF->(!DBSEEK(XFILIAL("AJF")+WORCAME+Padr(WEDT,TAMSX3("AJF_EDT")[1] )+WUSER[widx]))
      RECLOCK("AJF",.T.)
      AJF->AJF_FILIAL := XFILIAL("AJF")
      AJF->AJF_ORCAME := WORCAME
      AJF->AJF_EDT    := WEDT
      AJF->AJF_USER   := WUSER[widx]
      AJF_PROJET      := "2"
      AJF_ESTRUT      := "3"
      AJF_DOCUME      := "4"   
      MSUNLOCK()
   endif
   widx += 1
enddo      
Return

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