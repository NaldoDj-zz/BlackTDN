//=======  DEFINES DOS TIPOS DE ERP DISPONÍVEIS NO TOTVS TWS =======//

#DEFINE ERP_PROTHEUS '1'
#DEFINE ERP_RM '2'
#DEFINE ERP_LOGIX '3'
#DEFINE ERP_DATASUL '4'

//======================================================================//

//=======  DEFINES DOS TIPOS DE DATASET DISPONÍVEIS NO TOTVS TWS =======//

#DEFINE DATASET_TABLE '1'
#DEFINE DATASET_QUERY '2'
#DEFINE DATASET_PROCEDURE '3'

//=====================================================================//


//==  DEFINES DOS MOVIMENTOS DE IMPORTAÇÃO E EXPORTAÇÃO NO TOTVS TWS =//

#DEFINE UMOV_ARCH_IMPORT '1'
#DEFINE UMOV_ARCH_EXPORT '2'
#DEFINE UMOV_ARCH_LOG '3'

//=====================================================================//

//==  DEFINES DOS STATUS DE IMPORTAÇÃO E EXPORTAÇÃO NO TOTVS TWS =//

#DEFINE UMOV_PROCESS_OK '1'
#DEFINE UMOV_PROCESS_FAILED '2'
#DEFINE UMOV_FILE_SENT '3'
#DEFINE UMOV_FILE_RECEIPT '4'
#DEFINE UMOV_FILE_ERROR '5'
#DEFINE UMOV_FTP_ERROR '6'
#DEFINE UMOV_FILE_CREATED '7'


//=====================================================================//
//==  DEFINES DOS TIPOS DE DADOS DOS PARAMETROS DAS PROCEDURES=========//

#DEFINE PROC_DATA_CHAR '1'
#DEFINE PROC_DATA_NUM '2'
#DEFINE PROC_DATA_DATE '3'

//=====================================================================//



//=====================================================================//
//==  DEFINES DOS LOCAIS DE GRAVAÇÃO DOS ARQUIVOS DO TWS=========//
#define UMOV_BASE_DIR '\umov'
#define UMOV_EXPORT_DIR '\export'
#define UMOV_IMPORT_DIR '\import'
#define UMOV_LOG_DIR '\log'
#define UMOV_CONNECTOR_DIR '\connector'
//=====================================================================//

//=====================================================================//
//==  DEFINES DAS EXTESOES DOS ARQUIVOS DE EXPORTACAO===================//

#define END_OF_FILE "_v2"

//=====================================================================//


//=====================================================================//
//==  DEFINES DOS DIRETORIOS DE IMPORTACAO DO UMOVME===================//
#define U_MOV_FTP_EXPORT_DIR "/exportacao"
#define U_MOV_FTP_IMPORT_DIR "/importacao"
#define U_MOV_FTP_LOG_DIR "/logs"
//=====================================================================//

//=====================================================================//
//==  DEFINES DOS DIRETORIOS DO FTP DO TWS============================//
#define TWS_FTP_EXPORT_DIR "/export"
#define TWS_FTP_IMPORT_DIR "/import"
//=====================================================================//

