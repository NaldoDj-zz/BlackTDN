//Autor: Alexandre Laporte
#INCLUDE "NDJ.CH"
User Function NDJJOB()

AF8_ZZPRI := "1-ALTO"

SET DELETED ON 
// Chamada da staticcall para limpeza das tabelas szq e szr
StaticCall(NDJLIB001,MDJdbDelete,"SZQ")
StaticCall(NDJLIB001,MDJdbDelete,"SZR") 
fGravaSZQ()
return

****************************************************************************************************************************************************
&& Funcao para gravacao dos dados na tabela SZQ
****************************************************************************************************************************************************
Static Function fGravaSZQ()
       DBSELECTAREA("AFB")
       DO WHILE AFB->(!EOF())
          IF (AFB_TIPOD <> 'VN' .AND. AFB_TIPOD <> 'VI')
              AFB->(DBSKIP())
              LOOP
          ENDIF    
          
          IF AF8->(!DBSEEK(XFILIAL("AFB")+AFB->AFB_PROJET)) 
             ConOut("PROJETO NÏ ENCONTRADO NA AF8 - "+AFB->AFB_PROJET)
             AFB->(DBSKIP())
             LOOP
          ENDIF 
          
          IF CTT->(!DBSEEK(XFILIAL("CTT")+AFB->AFB_XCODOR+AFB->AFB_PROJET)) 
             ConOut("CENTRO DE CUSTO NÏ ENCONTRADO NA CTT - "+AFB->AFB_XCODOR+AFB->AFB_PROJET)
             AFB->(DBSKIP())
             LOOP
          ENDIF    

          IF AFB->AFB_REVISA <> AF8->AF8_REVISA 
             AFB->(DBSKIP())
             LOOP
          ENDIF       

          IF AF8->AF8_FASE <> "03" 
             AFB->(DBSKIP())
             LOOP
          ENDIF   
          
          IF AF9->(!DBSEEK(XFILIAL("AF9")+AFB->AFB_PROJET+AFB->AFB_REVISA+AFB->AFB_TAREFA)) 
             AFB->(DBSKIP())
             LOOP
          ENDIF  
                         
          dbSelectArea("SZQ")
          SZQ->(dbSetOrder(1))
          IF SZQ->(!DBSEEK(AFB->AFB_FILIAL+AFB->AFB_XCODOR+AFB->AFB_PROJET))             
              RECLOCK("SZQ",.T.) 
              SZQ->ZQ_FILIAL     := AFB->AFB_FILIAL
              SZQ->ZQ_CC         := AFB->AFB_XCODOR+AFB->AFB_PROJET          
              SZQ->ZQ_DESCCC     := CTT->CTT_DESC01
              SZQ->ZQ_ITEMC      := AF8->AF8_PROJET
              SZQ->ZQ_DESCITC    := AF8->AF8_DESCRI
              SZQ->ZQ_SPONCOR    := AF8->AF8_XSPON
              SZQ->ZQ_ESPONCO    := StaticCall( NDJLIB014 , UsrRetMail , AF8->AF8_XCODSP )
              SZQ->ZQ_GERPRJ     := AF8->AF8_XGER
              SZQ->ZQ_EMGEPRJ    := StaticCall( NDJLIB014 , UsrRetMail , AF8->AF8_XCODGE )
              SZQ->ZQ_UNIFUNC    := "XXX" //EQUIPE SPONSOR
              SZQ->ZQ_UNIFGER    := "YYY" //EQUIPE GERENTE
              SZQ->ZQ_ANO        := alltrim(str(YEAR(AF8->AF8_DATA)))
              SZQ->ZQ_STATUS     := "1"  
              MSUNLOCK()
           ENDIF
           RECLOCK("SZR",.T.) 
           SZR->ZR_FILIAL     := AFB->AFB_FILIAL
           SZR->ZR_CC         := AFB->AFB_XCODOR+AFB->AFB_PROJET          
           SZR->ZR_ITEMC      := AF8->AF8_PROJET
           SZR->ZR_TRFPRJ     := AFB->AFB_TAREFA
           SZR->ZR_DESCRI     := AF9->AF9_DESCRI
           SZR->ZR_ITEM       := AFB->AFB_ITEM
           SZR->ZR_ITDESP     := AFB->AFB_TIPOD
           SZR->ZR_DESCDES    := AFB->AFB_DESCRI
           SZR->ZR_VLRDESP    := AFB->AFB_VALOR
           SZR->ZR_STATUS     := "1"   
           MSUNLOCK()
           AFB->(DBSKIP())
       ENDDO

RETURN

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
