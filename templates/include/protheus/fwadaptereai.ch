//=======  DEFINES PARA STATUS DAS TRANSA합ES - INICIO =======//
#INCLUDE "FWEVENTVIEWCONSTS.CH"

#DEFINE TRANS_INQUEUE			"0"
#DEFINE TRANS_EXECUTING			"1"
#DEFINE TRANS_FINISHED			"2"
#DEFINE TRANS_FAILED			"3"
#DEFINE TRANS_BLOCKED			"4"

//=======  DEFINES PARA STATUS DAS TRANSA합ES - FIM ==========//


//=======  DEFINES PARA TIPO DE TRANSA플O - INICIO =======//

#DEFINE TRANS_RECEIVE			"0"
#DEFINE TRANS_SEND				"1"

//=======  DEFINES PARA TIPO DE TRANSA플O - FIM ==========//


//=======  DEFINES PARA TIPO DE PROCESSAMENTO - INICIO =======//

#DEFINE PROC_SYNC	    "1"
#DEFINE PROC_ASYNC	    "2"

//=======  DEFINES PARA TIPO DE PROCESSAMENTO - FIM ==========//


//=======  DEFINES PARA ARRAY DE RETORNO DO FWCOEAI - INICIO =======//

#DEFINE EAI_EMPFIL		01
#DEFINE EAI_ID			02
#DEFINE EAI_UUID		03
#DEFINE EAI_FUNCCODE	04
#DEFINE EAI_FUNCDESC	05
#DEFINE EAI_DOCDATE		06
#DEFINE EAI_DOCTIME		07
#DEFINE EAI_PROCDATE	08
#DEFINE EAI_PROCTIME	09
#DEFINE EAI_TRIALS		10
#DEFINE EAI_TRIALDATE	11
#DEFINE EAI_TRIALTIME	12
#DEFINE EAI_TRANS		13
#DEFINE EAI_PROCTYPE	14
#DEFINE EAI_TRANSTYPE	15
#DEFINE EAI_STATUS		16

//=======  DEFINES PARA ARRAY DE RETORNO DO FWCOEAI - FIM    =======//


//=======  DEFINES PARA TIPO DE MENSAGEM EAI - INICIO =======//

#DEFINE EAI_MESSAGE_PROTHEUS   "10"  // EAI Mensagem Protheus	
#DEFINE EAI_MESSAGE_MVC        "11"  // EAI Mensagem Protheus com MVC
#DEFINE EAI_MESSAGE_BUSINESS   "20"  // EAI Mensagem Unica Business Message
#DEFINE EAI_MESSAGE_RESPONSE   "21"  // EAI Mensagem Unica Response Message
#DEFINE EAI_MESSAGE_RECEIPT    "22"  // EAI Mensagem Unica Receipt Message
#DEFINE EAI_MESSAGE_WHOIS      "23"  // EAI Mensagem Unica WhoIs Message


//=======  DEFINES VERSOES DO XML MENSAGEM =======//
        
#DEFINE EAI_VER_MESS_PROTHEUS   "1.0"    // Versao Mensagem Protheus	
#DEFINE EAI_VER_MESS_MVC        "1.0"    // Versao Mensagem Protheus com MVC
#DEFINE EAI_VER_MESS_BUSINESS   "1.000"  // Versao Mensagem Unica Business Message
#DEFINE EAI_VER_MESS_RESPONSE   "1.000"  // Versao Mensagem Unica Response Message
#DEFINE EAI_VER_MESS_RECEIPT    "1.000"  // Versao Mensagem Unica Receipt Message
#DEFINE EAI_VER_MESS_WHOIS      "1.000"  // Versao Mensagem Unica WhoIs Message  
#DEFINE EAI_VER_SEND_STANDARD	"1.000"    // Versao da MESSAGEINFORMATION

//=======  DEFINES PARA TIPO DE MENSAGEM EAI - FIM    =======//


//=======  DEFINES PARA TIPO DE CANAIS DE ENVIO EAI - INICIO =======//

#DEFINE EAI_CHANNEL_ESB   "1"  // Canal de Envio para ESB
#DEFINE EAI_CHANNEL_EAI   "2"  // Canal de Envio para EAI

//=======  DEFINES PARA TIPO DE CANAIS DE ENVIO EAI - FIM    =======//


//=======  DEFINES PARA TIPO DE OPERACOES EAI - INICIO =======//

#DEFINE EAI_EVENT_UPSERT  "upsert"  // Operacao de Inclusao / Alteracao
#DEFINE EAI_EVENT_DELETE  "delete"  // Operacao de Exclusao
#DEFINE EAI_REQUEST		  "request" // Resquest nao tem Operacao

//=======  DEFINES PARA TIPO DE OPERACOES EAI - FIM    =======//

//=======  DEFINES PARA TIPO DE OPERACOES EAI - INICIO =======//

#DEFINE EAI_BUSINESS_EVENT   "1"  // BusinessMessage de Event
#DEFINE EAI_BUSINESS_REQUEST "2"  // BusinessMessage de Request

//=======  DEFINES PARA TIPO DE OPERACOES EAI - FIM    =======//
