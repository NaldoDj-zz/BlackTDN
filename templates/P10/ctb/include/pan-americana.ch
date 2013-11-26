 #IFNDEF _PAN_AMERICANA_CH

	#DEFINE _PAN_AMERICANA_CH

	/*/
		Arquivo:	PAN-AMERICANA.CH
		Autor:		Marinaldo de Jesus
		Descricao:	Arquivo de Cabecalho dos Programas Utilizados na PAN-AMERICANA
		Sintaxe:	#include "PAN-AMERICANA.CH"	
	/*/

	#INCLUDE "PROTHEUS.CH"
	#INCLUDE "RWMAKE.CH"
	#INCLUDE "TOPCONN.CH"
	#INCLUDE "TBICONN.CH"
	#INCLUDE "CTRL_VK.CH"
	#INCLUDE "DBTREE.CH"
	#INCLUDE "DBINFO.CH"
	#INCLUDE "DBSTRUCT.CH"
	#INCLUDE "SET.CH"
	#INCLUDE "FILEIO.CH"
	#INCLUDE "HEADERGD.CH"
	#INCLUDE "MSOLE.CH"
	#INCLUDE "SCOPECNT.CH"
	#INCLUDE "TBICONN.CH"
    #INCLUDE "TRYEXCEPTION.CH"

	/*/
		Autor:		Marinaldo de Jesus
		Descricao:	Constantes Utilizadas no Protheus para a PAN-AMERICANA

	/*/
	#DEFINE FILE_FIELDS_CT1_CTT 			( cEmpAnt+"_fields_ct1_vs_ctt.txt" )
	#DEFINE FILE_AMARRACAO_CT1_CTT_FILIAL	( cEmpAnt+"_amarracao_ct1_ctt_filial.txt" )
	#DEFINE FILE_EXCLUI_CT1					( cEmpAnt+"_"+cFilAnt+"_exclui_ct1.txt" )
	#DEFINE FILE_EXCLUI_CTT 				( cEmpAnt+"_"+cFilAnt+"_exclui_ctt.txt" )

	#DEFINE _SET_MAX_CODE					10000
	#DEFINE PATH_FINAL_FILE 				"\final\"
	#DEFINE FINAL_FILE						"final"
    #DEFINE FINAL_FILE_GROUP				FINAL_FILE + "g"
	#DEFINE DIR_MENU_FILES					"\menus\"
	#DEFINE DIR_MENU_FILES_REBUILD			"\menus\rebuild\"
	#DEFINE DIR_MENU_FILES_BACKUP			"\menus\backup\"
	#DEFINE ID_USER_ADMINISTRATOR			"000000"

#ENDIF
