#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*ܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜܜ܍
�����������������������������������������������������������������������������
��ڄĄĄĄĄĂĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĂĄĄĄĄĄ���
���Programa  � A100TRA    � Autor � Glaucio Oliveira      � Data �26/11/2010���
��ÄĄĄĄĄąĄĄĄĄĄDĄĄĄńĄĄĄĂĄĄĄĄĄĄĄDĄĄāĄĄĄĄĄ���
���Locacao   � Fabr.Tradicional �Contato � eduardo.brust@microsiga.com.br ���
��ÄĄĄĄĄąĄĄĄĄĄĄĄĄĄDĄĄĄāĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄ���
���Descricao � Utilizado para contabilizacao da transferencia bancaria    ���
���             � por partida dobrada.                                          ���
���          �                                                                ���
��ÄĄĄĄĄąĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄ���
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
��ÄĄĄĄĄĄĄąĄĄĄĄńĄĄąĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄ���
���              �  /  /  �      �                                        ���
���              �  /  /  �      �                                        ���
��ĄĄĄĄĄĄāĄĄĄĄDĄĄāĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄĄٱ�
�����������������������������������������������������������������������������
ߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߟߪ/
/*
[1] lEstorno - .T. - Estorno de Transferencia / .F. - Transferꮣia
[2] cBcoOrig - Banco de Origem
[3] cBcoDest - Banco de Destino
[4] cAgenOrig - Agencia de Origem
[5] cAgenDest - Agencia de Destino
[6] cCtaOrig - Conta de Origem
[7] cCtaDest - Conta de Destino
[8] cNaturOri - Natureza de Origem
[9] cNaturDes - Natureza de Destino
[10]cDocTran - N�mero do Documento de Transferꮣia
[11]cHist100 - Hist�rico
*/
User Function A100TRA ()
//definicao de variaveis
Private aArea := GetArea()

StaticCall( NDJLIB004 , SetPublic , "cContOrig" , "" )
StaticCall( NDJLIB004 , SetPublic , "cContDest" , "" )

// PEGA A CONTA DE ORIGEM
DBSELECTAREA("SA6")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA6")+ParamIXB[2]+ParamIXB[4]+ParamIXB[6])
    cContOrig := SA6->A6_CONTA
        
ENDIF 

// PEGA A CONTA DE DESTINO
DBSELECTAREA("SA6")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA6")+ParamIXB[3]+ParamIXB[5]+ParamIXB[7])
    cContDest := SA6->A6_CONTA
        
ENDIF   

RecLock("SE5",.F.)  
    SE5->E5_CREDITO := cContOrig
    SE5->E5_DEBITO  := cContDest
MsUnlock()

//alert(cNumero)
RestArea(aARea)
Return 
