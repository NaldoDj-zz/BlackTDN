// ######################################################################################
// Projeto: DATA WAREHOUSE
// Modulo : Ferramentas
// Fonte  : DWActions - lista de ações e outros elementos envolvidos
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 27.09.03 | 0548-Alan Candido | Versão 3
// --------------------------------------------------------------------------------------

#define URL_BASE ""

#define EDT_EDIT      	   "01"
#define EDT_COMBO     	   "02"
#define EDT_PASSWORD  	   "03"
#define EDT_HIDDEN    	   "04"
#define EDT_CHECKBOX  	   "05"
#define EDT_CHECKBOX2 	   "06"
#define EDT_SHOW      	   "07"
#define EDT_TITLE     	   "08"
#define EDT_SUBTITLE  	   "09"
#define EDT_TEXT           "10"
#define EDT_HCHECK     	   "11"
#define EDT_HCHILD_CHECK   "12"
#define EDT_BLANK          "13"
#define EDT_ATTENTION 	   "14"
#define EDT_RADIO          "15"
#define EDT_WARNING        "16"
#define EDT_DUALLIST  	   "17"
#define EDT_LISTBOX        "18"
#define EDT_TEXTAREA       "19"
#define EDT_PROGRESSBAR    "20"
#define EDT_CUSTOM         "21"
#define EDT_DATE           "22"
#define EDT_UPLOAD         "23"
#define EDT_H1             "24"
#define EDT_H2             "25"
#define EDT_TABBED_PANE	   "26"
#define EDT_TABBED_CHILD   "27"
#define EDT_MULTI_STATUS   "28"
#define EDT_TABBED_JSPANE  "29"
#define EDT_IFRAME         "30"
#define EDT_LEGEND         "31"
#define EDT_TABBED_GROUP   "32"
#define EDT_CUSTOM_CONT    "33"  
#define EDT_PICTURE			 "34"

#define FFLD_EDTTYPE  	 1
#define FFLD_NAME     	 2
#define FFLD_CAPTION  	 3
#define FFLD_HOTKEY   	 4
#define FFLD_REQUIRED 	 5
#define FFLD_TYPE     	 6
#define FFLD_LEN      	 7
#define FFLD_DEC      	 8
#define FFLD_OPERATION   FFLD_DEC
#define FFLD_VALUE    	 9
#define FFLD_ACTION      FFLD_VALUE
#define FFLD_OPTIONS 	  10
#define FFLD_KEY     	  11
#define FFLD_EVENTS  	  12
#define FFLD_EVENTNAME     1   // elemento de FFLD_EVENTS
#define FFLD_EVENTJS       2   // elemento de FFLD_EVENTS
#define FFLD_FIREONINIT    3   // elemento de FFLD_EVENTS
#define FFLD_DOTBUTTON  13
#define FFLD_CHOOSE  	  14
#define FFLD_DOTBTNACT	15
#define FFLD_DOTINPUT	  16

#define BTN_SIZE_ARRAY  4
#define BTN_TYPE     1
#define BTN_CAPTION  2
#define BTN_ACTION   3
#define BTN_SMALL    4
#define BTN_ACTPARMS 5

#define NAME_ACTION      1
#define BEFORE_ACTION    2
#define EXEC_ACTION      3
#define AFTER_ACTION     4

#define LIST_LINK    1
#define LIST_ICONE   2
#define LIST_NAME    3
#define LIST_DESC    4

#define CUSTOM_EVENT "@event@" // para EDT_CUSTOM
                           
#define AC_NONE            "#"
#define AC_ONLINE_NOTIFY   "onLineNotify"
#define AC_BROWSER         "browser"
#define AC_CHANGE_MENU     "changemenu"
#define AC_CHANGEDW        "changedw"
#define AC_COL_SORT        "colsort"
#define AC_FORGET_PW       "forgetpw"
#define AC_SEND_PW         "sendpw"
#define AC_LOGIN           "login"
#define AC_LOGOUT          "logout"
#define AC_NEW_DW          "newdw"
#define AC_DELETE_DW			 "deletedw"
#define AC_PROC_ABA        "procaba"
#define AC_REC_MANUT       "recmanut"
#define AC_REC_NEW         "recnew"
#define AC_ATT_REC_MANUT   "attrecmanut"
#define AC_KEY_REC_MANUT   "keyrecmanut"
#define AC_RESET           "reset"
#define AC_SELECT_ABA      "selectaba"
#define AC_SELECT_DW       "selectdw"
#define AC_SETUP_DW        "setupdw"
#define AC_START_DW        "startdw"
#define AC_DIM_ATT         "dimAtt"
#define AC_DIM_DS          "dimDS"
#define AC_DIM_KEY         "dimKey"
#define AC_CUB_IND         "cubInd"
#define AC_IND_REC_MANUT   "indrecmanut"
#define AC_DIM_CUB_RECMAN  "cubdimrecmanut"
#define AC_DSN_CUB_RECMAN  "cubdsrecmanut"
#define AC_CUB_DSN_RECMAN  "cubdsnmanut"
#define AC_IMPORT_STRUC    "importStruct"
#define AC_TOOLS_META	     "tools_meta"
#define AC_DOWNLOAD		     "download"
#define AC_EXEC_DOWNLOAD   "execDownload"
#define AC_EXEC_UPLOAD     "execUpload"
#define AC_UPLOAD_FILE     "uploadFile"
#define AC_TOOLS_IMPORT	   "tools_import"
#define AC_VERIFY_PROCESS  "verifyProcess" 
#define AC_VERIFY_PROCESS_LIST "verifyProcessList"
#define AC_TOOLS_CLEAN	   "tools_clean"
#define AC_VERIFY_MESSAGE  "main_msgs"
#define AC_DSN_DIM_MANUT   "dsnDimManut"
#define AC_DSN_DIM_PARAM   "dsnDimParam"
#define AC_DSN_DIM_EVENT   "dsnDimEvent"
#define AC_DSN_DIM_ROTEIRO "dsnDimRoteiro"
#define AC_DSN_CUBE_MANUT  "dsnCubeManut"
#define AC_DSN             "dsn"
#define AC_DSN_IMPORT      "dsnImport"
#define AC_DSN_SCHED       "dsnSched"
#define AC_EDT_SCHED       "edtSched"
#define AC_EDT_EXPRESSION  "edtExpression"
#define AC_QUERY_DEFCUBE   "queryDefCub"
#define AC_QUERY_TABLE	   "queryTable"
#define AC_QUERY_GRAPH	   "querygraph"
#define AC_QRY_CUB_FILTER  "queryAndCubFilter"
#define AC_QUERY_CFG_EXP   "queryConfigExport"
#define AC_REC_FILTER	     "recManuFilter"
#define AC_QUERY_DECLFLTR  "queryDeclarFltr"
#define AC_QRY_FLTR_VALUE  "queryFilterValues"
#define AC_SAVE_FLTR_DECL  "saveFilterDecl"
#define AC_CLEAN_FLTR_DEC  "cleanFilterDecl"
#define AC_RESTORE_ALL	   "restoreAllFilterDecl"
#define AC_QUERY_DATA      "queryData"
#define AC_SHOW_DATA	     "showDatabase"
#define AC_MARK_DATA	     "markData"
#define AC_FILTER_DATA	   "filterData"
#define AC_SELECT_DATA     "selectData"
#define AC_QRY_DECL_EXPR   "queryFilterExpr"
#define AC_QRY_DESC_FLTR   "descrFilter"
#define AC_QRY_DESC_FIELD  "descrFilterElement"
#define AC_REC_EXPR		     "recSaveExpression"
#define AC_QUERY_ALERT     "queryAlert"
#define AC_QUERY_DEF       "queryDef"
#define AC_QUERY_DEF_STR   "queryDefStr"
#define AC_QUERY_DEF_FIL   "queryDefFil"
#define AC_QUERY_DEF_ALM   "queryDefAlm"
#define AC_QUERY_DEF_RNK   "queryDefRnk"
#define AC_QUERY_DEF_OPT   "queryDefOpt"
#define AC_REC_ALERT	     "recManutAlert"
#define AC_QUERY_VIRTFLD   "queryVirtFlds"
#define AC_QUERY_EXEC      "queryExec"
#define AC_QRY_ONLINE_EXEC "queryOnlineExec"
#define AC_BUILD_QUERY     "buildTable"
#define AC_EXPORT_QUERY    "exportQuery"
#define AC_REC_VIRTFLD	   "recManutVirtFld"
#define AC_PROCESS_VIEW    "processView"
#define AC_VIEW_LOG        "viewLog"
#define AC_SAVE_DW		     "saveDW"
#define AC_USER_PRIVILEGE  "userPrivileges"
#define AC_SHOW_PRIVILEGE  "showPrivileges"
#define AC_SAVE_PRIVILEGE  "savePrivileges"
#define AC_RESET_PRIVILEGE "resetPrivileges"
#define AC_VERIFY_CONECT   "verifyConnection"
#define AC_HELP            "helpDW"
#define AC_ANALISAR_FRAG   "analFrag"
#define AC_EXPORT_DATA     "exportData"
#define AC_DOCUMENTATION   "documentation"
#define AC_SHOW_SCHEMA     "showSchema"
#define AC_QRY_CRW         "querycrw"
#define AC_USER_DESKTOP    "userDesktop"
#define AC_USER_IMPORT     "userImport"
#define AC_IMP_USR_SCHED   "impUsrSched"
#define AC_WS_REQUEST      "wsRequest"
#define    CMD_GETLISTDW   		"wsRequestDwList"
#define    CMD_GETXMLCUBOS   	"wsRequestXmlCubos"
#define    CMD_GETXMLCUBO      	"wsRequestXmlCubo"
#define    CMD_GETXMLCONSULTAS 	"wsRequestXmlConsultas"
#define    CMD_GETCONSTRUCT    	"wsRequestConStruct"
#define    CMD_INICTABLE       	"wsRequestInicTable"
#define AC_INTEGRATION_EXCEL 	"integrExcel"
#define AC_DW_USER 				"alterCadastro"
#define AC_ALTER_DUPLI_FIELD 	"alterDupField"   
#define AC_OPEN_URL		   		"openURL"
#define AC_SYNC_EMPFIL     "syncEmpFil"

#define OP_NONE            0 //""
#define OP_SUBMIT          1 //"s"//ubmit"
#define OP_STEP            2 //"st"//ep
#define OP_REC_EDIT        3 //"e"//dit"
#define OP_REC_DEL         4 //"d"//el"
#define OP_REC_NEW         5 //"n"//ew"
#define OP_REC_NO_STEPS	   6 //"ns"//NoStepEdit"
#define OP_REC_STEPS	   7 //"se"//StepEdit"
#define OP_REC_CONF		   8 //"rc"//RecordeConfirmation"
#define OP_DISPLAY		   9 //"v"//Visualize"
#define OP_EXEC_ONLINE	  10 //"x"eXecutar online
#define OP_RESET		  11 //"r"eset

#define OP_EXCEL_LOGIN		1
#define OP_EXCEL_CONS		2
#define OP_EXCEL_QUERY		3
#define OP_EXCEL_SELEC		4
#define OP_EXCEL_PREPEXEC	5
#define OP_EXCEL_EXEC		6

#define BT_SUBMIT          "s"//ubmit"
#define BT_RESET           "r"//eset"
#define BT_BUTTON          "b"//utton"
#define BT_CANCEL          "c"//ancel"
#define BT_NEXT            "n"//ext step"
#define BT_PREVIOUS        "p"//revious step"
#define BT_PROCESS         "pr"//ocess"
#define BT_JAVA_SCRIPT     "j"//avaScript"
#define BT_PRINT           "pri"//nt"
#define BT_CLOSE           "cl"//ose"
#define BT_DOWNLOAD        "d"//ownload"
#define BT_FINALIZE        "f"//inalize
#define BT_ADT_OPER        "o"//peratiom
#define BT_BREAKROW        "br" //break row
#define BT_CUSTOM          "#" //custom

#define ABA_ID       1
#define ABA_CAPTION  2
#define ABA_MENU     3
#define ABA_ABAS     4
#define ABA_ACTION   5

#define NAV_LABEL       1
#define NAV_ICONE       2
#define NAV_ACTION      3
#define NAV_ALIGN       4
#define NAV_WINDOW_SIZE 5

#define LIST_MINI    0
#define LIST_LIST    1

#define OPB_CAPTION   1
#define OPB_ICONE     2
#define OPB_ACTION    3
#define OPB_PARAMS    4
#define OPB_TARGETWIN 5
#define OPB_MENU      6
#define OPB_CONFIRM   7
#define OPB_AWS_VISIB 8

#define EDT_CMD_SAVE     "S"//ave
#define EDT_CMD_CANCEL   "C"//ancel
#define EDT_CMD_EXECUTE  "E"//xecute
#define EDT_CMD_REMOVE   "R"//emove
#define EDT_CMD_COPY     "O"//c?py
#define EDT_CMD_EDIT     "D"//e?it
#define EDT_CMD_VIEW     "V"//iew

#define MAP_SIZE         6
#define MAP_TYPE         1
#define MAP_COORDS       2
#define MAP_ALT          3
#define MAP_MOUSE_OVER   4
#define MAP_MOUSE_OUT    5
#define MAP_MOUSE_HREF   6

#define MAP_RECT         "rect"
                              
#define IFRAME_SIZE           5
#define IFRAME_ID             1
#define IFRAME_CAPTION        2
#define IFRAME_WIDTH          3
#define IFRAME_HEIGHT         4
#define IFRAME_PARAMS         5
