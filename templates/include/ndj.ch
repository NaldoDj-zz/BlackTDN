#IFNDEF _NDJ_CH

    #DEFINE _NDJ_CH

*	#IFNDEF TOTVS_INCLUDE
*		#DEFINE TOTVS_INCLUDE
*	#ENDIF
	
     /*/
        Arquivo:    NDJ.CH
        Autor:      Marinaldo de Jesus
        Descricao:  Arquivo de Cabecalho dos Programas Utilizados na NDJ
        Sintaxe:    #INCLUDE "NDJ.ch"    
     /*/
	#IFDEF TOTVS_INCLUDE

	     #include "aabonos.ch"
	     #include "amarc.ch"
	     #include "ap5mail.ch"
	     #include "apvisio.ch"
	     #include "apwebex.ch"
	     #include "apwebsrv.ch"
	     #include "apwizard.ch"
	     #include "aresult.ch"
	     #include "atotais.ch"
	     #include "avprint.ch"
	     #include "axsdef.ch"
	     #include "calenbmp.ch"
	     #include "colors.ch"
	     #include "common.ch"
	     #include "constant.ch"
	     #include "dbinfo.ch"
	     #include "dbstruct.ch"
	     #include "dbtree.ch"
	     #include "dialog.ch"
	     #include "eicconst.ch"
	     #include "error.ch"
	     #include "fildflt.ch"
	     #include "fileio.ch"
	     #include "fivewin.ch"
	     #include "folder.ch"
	     #include "font.ch"
	     #include "headergd.ch"
	     #include "jpeg.ch"
	     #include "mproject.ch"
	     #include "msgraphi.ch"
	     #include "msmgadd.ch"
	     #include "msobject.ch"
	     #include "msole.ch"
	     #include "msserial.ch"
	     #include "olecont.ch"
	     #include "poncalen.ch"
	     #include "prbtvdef.ch"
	     #include "prconst.ch"
	     #include "prctrdef.ch"
	     #include "print.ch"
	     #include "protdef.ch"
	     #include "protheus.ch"
	     #include "prtopdef.ch"
	     #include "ptmenu.ch"
	     #include "rwmake.ch"
	     #include "scopecnt.ch"
	     #include "scrollbx.ch"
	     #include "set.ch"
	     #include "shell.ch"
	     #include "siga.ch"
	     #include "sigawin.ch"
	     #include "std.ch"
	     #include "stdwin.ch"
	     #include "tbicode.ch"
	     #include "tbiconn.ch"
	     #include "tcbrowse.ch"
	     #include "topconn.ch"
	     #include "vkey.ch"
	     #include "winapi.ch"
	     #include "xmlxfun.ch"

	#ENDIF

	#include "ctrl_vk.ch"
	#include "tryexception.ch"
	#include "thash.ch"
	#include "tfini.ch"
	#include "ndjipcdef.ch"

     /*/
        Autor:        Marinaldo de Jesus
        Descricao:    Constantes Utilizadas no Protheus para a NDJ
        Uso:          Empenho/Bloqueio de Valor na SC/PC/NFE

     /*/
    #IFNDEF NDJ_BLK_GET_SALDO
        #DEFINE NDJ_BLK_GET_SALDO         0
     #ENDIF
    #IFNDEF NDJ_BLK_GET_ORCAMENTO
        #DEFINE NDJ_BLK_GET_ORCAMENTO     1
     #ENDIF     
    #IFNDEF NDJ_BLK_GET_EMPENHADO
        #DEFINE NDJ_BLK_GET_EMPENHADO     2
     #ENDIF
    #IFNDEF NDJ_BLK_GET_LASTVAL
        #DEFINE NDJ_BLK_GET_LASTVAL       3
     #ENDIF     

     /*/
        Autor:        Marinaldo de Jesus
        Descricao:    Constantes Utilizadas no Protheus para a NDJ
        Uso:          Tipos de Aprovacao da SC

     /*/
    #IFNDEF NDJ_APROVACAO_PADRAO
        #DEFINE NDJ_APROVACAO_PADRAO     0
     #ENDIF
    #IFNDEF NDJ_PRE_ANALISE
        #DEFINE NDJ_PRE_ANALISE          1
     #ENDIF     
    #IFNDEF NDJ_SUSPENDER
        #DEFINE NDJ_SUSPENDER            2
     #ENDIF     
          
     /*/
        Autor:        Marinaldo de Jesus
        Descricao:    Constantes Utilizadas no Protheus para a NDJ
        Uso:          Indice dos Elementos do Array aPlanilha na Analise de Cotacao

     /*/
     #DEFINE PLAN_MARK                       1
     #DEFINE PLAN_FORNECEDOR                 2
     #DEFINE PLAN_LOJA_FORNECEDOR            3
     #DEFINE PLAN_NOME_FANTASIA              4
     #DEFINE PLAN_PROPOSTA                   5
     #DEFINE PLAN_TOTAL_ITEM                 6
     #DEFINE PLAN_DATA_NECESSIDADE           7
     #DEFINE PLAN_PRAZO_ENTREGA              8
     #DEFINE PLAN_DESVIO                     9
     #DEFINE PLAN_NOTA                      10
     #DEFINE PLAN_OBSERVACAO                11
     #DEFINE PLAN_BRANCO_1_VAL              12
     #DEFINE PLAN_ITEM_COTACAO              13
     #DEFINE PLAN_PRECO_UNITARIO            14
     #DEFINE PLAN_CONDICAO_DE_PAGAMENTO     15
     #DEFINE PLAN_DESCRICAO_COND_PAGTO      16
     #DEFINE PLAN_PRAZO_DE_ENTREGA          17
     #DEFINE PLAN_BRANCO_2_CHR              18
     #DEFINE PLAN_ITEM_GRADE                19

     /*/
        Autor:        Marinaldo de Jesus
        Descricao:    Constantes Utilizadas no Protheus para a NDJ
        Uso:          Indice dos Elementos do Array da Pilha de Chamadas

     /*/
     #DEFINE STACK_INDEX_PARAMETER     1
     #DEFINE STACK_INDEX_SCOPE         2
     #DEFINE STACK_INDEX_TYPE          3
     #DEFINE STACK_INDEX_VALUE         4

     #DEFINE STACK_INDEX_ELEMENTS      4 
     
     /*/
        Autor:        Marinaldo de Jesus
        Descricao:    Constantes Utilizadas no Protheus para a NDJ
        Uso:          Define o Numero de Codigos Maximos a Serem Reservados pela MayIUseCode
     /*/
    #DEFINE NDJ_MAX_CODE    100000

     /*/
        Autor:         Marinaldo de Jesus
        Descricao:     Constantes Utilizadas no Protheus para a NDJ
        Uso:           Define a Constante SEPARADORA do MailID
     /*/
    #DEFINE NDJ_TOKEN_MAILD    ";"
     
     /*/
        Autor:         Marinaldo de Jesus
        Descricao:     Constantes Utilizadas no Protheus para a NDJ
        Uso:           Define as Constantes NDJ_DIR_INI_FILE e NDJ_INI_FILE que aponta para o arquivo de configuracao NDJ
     /*/
    #DEFINE NDJ_DIR_INI_FILE    "\ndj_cfg\"
    #DEFINE NDJ_INI_FILE        NDJ_DIR_INI_FILE + "ndj_totvs.ini"

    /*/
        Autor:         Marinaldo de Jesus
        Descricao:     Traducao para os comandos utilizados no processo de Comunicacao de Dados Baseado no Harbour/MiniGui
        Uso:           Transferencia de Dados (SendData/GetData)
    /*/
	#xtranslate Set StationName To <st> 	=> _HMG_StationName := <st>
	#xtranslate Set CommPath To <cph>		=> _HMG_CommPath := <cph>
	#xtranslate _HMG_StationName := <st>	=> StaticCall( NDJLIB023 , StationName , <st> ,.T. )
	#xtranslate _HMG_CommPath := <cph> 		=> StaticCall( NDJLIB023 , CommPath , <cph> )
	#xtranslate _HMG_CommPath				=> StaticCall( NDJLIB023 , CommPath )
	#xtranslate _HMG_StationName			=> StaticCall( NDJLIB023 , StationName )
	#xtranslate _HMG_SendDataCount   		=> StaticCall( NDJLIB023 , SDataCount )
	#xtranslate _HMG_SendDataCount++   		=> StaticCall( NDJLIB023 , SDataCount , StaticCall( NDJLIB023 , SDataCount ) + 1 )
	#xtranslate _HMG_SendDataCount := <n>	=> StaticCall( NDJLIB023 , SDataCount , <n> )
	#xtranslate MsgMiniGuiError(<m>)   		=> MsgInfo(<m>)
	#xcommand 	Delete File <f>				=> fErase(<f>)

    /*/
        Autor:         Marinaldo de Jesus
        Descricao:     Traducao para o comandos User Procedure
        Uso:           Declaracao de User Procedure
    /*/
   #xcommand   USER PROCEDURE <p> => PROCEDURE U_<p>
   #xtranslate USER PROCEDURE <p> => PROCEDURE U_<p>

    /*/
        Autor:         Marinaldo de Jesus
        Descricao:     SYMBOL_UNUSED
        Uso:           Geral
    /*/
   #ifndef HB_SYMBOL_UNUSED
      #define HB_SYMBOL_UNUSED( symbol ) SYMBOL_UNUSED( symbol )
   #endif
   #ifndef SYMBOL_UNUSED
      #define SYMBOL_UNUSED( symbol )    ( symbol := ( symbol ) )
   #endif

    /*/
        Autor:         Marinaldo de Jesus
        Descricao:     Constante para CRLF
        Uso:           Geral
    /*/
   #ifndef __cCRLF__
		#define __cCRLF__
		Static __cCRLF := CRLF
   #endif		

#ENDIF