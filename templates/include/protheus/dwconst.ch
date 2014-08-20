// ######################################################################################
// Projeto: DATA WAREHOUSE
// Modulo : Ferramentas
// Fonte  : DWConst - Constantes de uso genérico
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 25.06.01 | 0548-Alan Candido |
// --------------------------------------------------------------------------------------

/*
-----------------------------------------------------------------------------------------
Constantes de uso para execução de consultas
-----------------------------------------------------------------------------------------
*/
#define PAGE_SIZE      29

/*
-----------------------------------------------------------------------------------------
Constantes de uso genérico
-----------------------------------------------------------------------------------------
*/
#ifndef _DWCONST_CH
#define _DWCONST_CH
#define TAB                       chr(9)
#define CR	                      chr(13)
#define LF	                      chr(10)
#define CRLF                      chr(13)+chr(10)
#define PV                        ';'
#define PORT_PROTHEUS			        1024
#define COL_SEP                   chr(9)
#define ASPAS_S                   "'"
#define ASPAS_D                   '"'
#define PASSWORD_SIZE             10
#define MAX_REG_POR_PAGINA        12
#define VAZIO        "{VAZIO}"
// Inclui o arquivo de tradução do próprio
#INCLUDE "DWTConst.ch"

/*
-----------------------------------------------------------------------------------------
Identificadores de tabelas     
O nome das tabelas seguem o formato
	DWFFSSV, onde
		DW - sufixo que indica tabela do SigaDW, fixo
		FF - familia das tabelas, varia de 01 até até ZZ
		SS - sequencia das tabelas na família, , varia de 00 até até ZZ, 
			  onde tabela 00 é a pai e as demais serão filhas (Master/Detail)
		V  - sequencia da visão ou alias de select específico, varia de 0 até Z,
			  onde 0 é a tabela fixa	  
-----------------------------------------------------------------------------------------
*/                     
#define TAB_BUILD       "DW00000"
#define TAB_DW          "DW00001" 
#define TAB_CONFIG      "DW00100"
#define TAB_CONEXAO     "DW00200"
#define TAB_CALEND      "DW01000"
#define VIE_CALEND      "DT01000"
#define TAB_EVENTS      "DW01100"
#define TAB_PERIODO     "DW01200"
#define TAB_LOG         "DW02000"
#define TAB_LOGALER     "DW02001"
#define TAB_MSG			    "DW02002"
#define TAB_MSG_USER	  "DW02102"
#define SEL_MSG_LER     "QW02102"
#define TAB_PROCESS     "DW02200"
#define TAB_ACTIONS     "DW02300"
#define TAB_CUBESLIST   "DW05000"
#define TAB_FACTS       "DW05100"
#define SEL_FACT_INFO   "QW05101"
#define TAB_FACTFIELDS  "DW05110"
#define TAB_FACTVIRTUAL "DW05120"
#define TAB_FACT_WHERE	"DW05140"
#define TAB_CONSULTAS   "DW05200"
#define SEL_CONS_DIM    "QW05200"
#define SEL_QRY_INFO    "QW05201"
#define TAB_CONSTYPE  	"DW05205"
#define TAB_CONS_PROP   "DW05210"
#define TAB_ALERT       "DW05220"
#define TAB_CALC        "DW05230"
#define TAB_EXPR        "DW05240"
#define TAB_CONSCRW     "DW05250"
#define TAB_CRWPARAMS   "DW05255"
#define TAB_CONS_IND    "DW05260"
#define TAB_CONS_DIM    "DW05270"
#define TAB_CONS_WHE    "DW05280"
#define TAB_CONS_USR    "DW05285"
#define TAB_CONS_ALM    "DW05290"
#define TAB_WHERE       "DW05300"
#define TAB_WHERE_COND  "DW05310"
#define TAB_DIMENSAO    "DW06000"
#define SEL_DIM_INFO    "QW06001"
#define TAB_DIM_FIELDS  "DW06100"
#define TAB_DIM_CUBES   "DW06200"
#define SEL_DIM_CUBES   "QW06200"
#define TAB_USER        "DW07000"
#define SEL_USER        "QW07000"
#define TAB_USER_DW     "DW07100"
#define TAB_USER_CONS   "DW07110"
#define TAB_USER_CUB    "DW07120"
#define TAB_USER_RES    "DW07130"
#define TAB_USER_LOG    "DW07200"
#define TAB_USER_DSKTOP "DW07210"
#define TAB_USER_PRIV	  "DW07400"
#define TAB_DSN         "DW09000"
#define SEL_DSN_EMPFIL  "QW09000"
#define SEL_DSN_ALIAS   "QW09001"
#define SEL_DSN_EMPCOMP "QW09002"

#define TAB_DSNCONF     "DW09100"
#define SEL_DSNCONF     "QW09100"
#define SEL_DSNCONF2    "QW09101"
#define TAB_EXPORT      "DW09200"
#define TAB_SXM         "DW0A000"
#define TAB_SX2         "DW0A100"
#define TAB_SX9         "DW0A200"
#define TAB_DD          "DW0B000"
#define TAB_ESTAT_SPC   "DW0C000"
#define TAB_ESTAT       "DW0C100"






#define PIVOT_SIZE                60
#define VERAO_R                   1 
#define OUTONO_R                  2
#define INVERNO_R                 3
#define PRIMAVERA_R               4

#define VERAO                     _TRAD0001/*//'Verão'*/
#define OUTONO                    _TRAD0002/*//'Outono'*/
#define INVERNO                   _TRAD0003/*//'Inverno'*/
#define PRIMAVERA                 _TRAD0004/*//'Primavera'*/

#define SIZE_BUFFER               512

#define DIR_SIGADW                '\sigadw_wk'

/*
-----------------------------------------------------------------------------------------
Identificadores de tipo de Jobs (usando no monitor de jobs)
-----------------------------------------------------------------------------------------
*/
#define JOB_EXPORTACAO "EXP"
#define JOB_IMPORTACAO "IMP"

/*
-----------------------------------------------------------------------------------------
Identificadores de Jobs usando no DWJobMonitor
-----------------------------------------------------------------------------------------
*/
#define JOB_INITCALEND    "JOB001"
#define JOB_IMPORTSIGA    "JOB002"
#define JOB_IMPORTDIRETO  "JOB003"
#define JOB_INITCUBE      "JOB005"
#define JOB_INITDIM       "JOB005A"
#define JOB_EXECCONS      "JOB008"
#define JOB_BASETOP       "JOB010"
#define JOB_BASESXS       "JOB011"
#define JOB_BASEDIR       "JOB012"
#define JOB_EXECSP        "JOB013"
#define JOB_SENDMAIL      "JOB014"

/*
-----------------------------------------------------------------------------------------
Tipos de GetInfo
-----------------------------------------------------------------------------------------
*/
#define GI_ASIZE  13   // Tamanho do array de propriedades + 4

#define GI_HTML   1    // Tipo 1, com informações para "get" em html
#define GI_GET    2    // Tipo 2, com informações para "get" em adv/pl
#define GI_USER   3    // Tipo 3, com informações para "get" definidas pelo usuário

/*
-----------------------------------------------------------------------------------------
Identificador os tipos de agregações disponiveis
-----------------------------------------------------------------------------------------
*/
#define AGG_NONE         -1
#define AGG_SUM           0
#define AGG_COUNT         1
#define AGG_AVG           2
#define AGG_MIN           3
#define AGG_MAX           4
#define AGG_PAR           5
#define AGG_VAR           6
#define AGG_DIST          7
#define AGG_FORMULA       8
#define AGG_PARTOT        9
#define AGG_PARGLOB      10
#define AGG_MEDINT       11
#define AGG_ACUM         12
#define AGG_ACUMHIST     13
#define AGG_ACUMPERC     14
#define AGG_ACUMHISTPERC 15

/*
-----------------------------------------------------------------------------------------
Identificador de tipo de load/save da Consulta
-----------------------------------------------------------------------------------------
*/
#define TYPE_TABLE   1
#define TYPE_GRAPH   2

#define TYPE_TABLE_S "1"
#define TYPE_GRAPH_S "2"

/*
-----------------------------------------------------------------------------------------
Identificador dos atributidos do DW
-----------------------------------------------------------------------------------------
*/
#define DW_INFOSIZE 6
#define DW_ID       1
#define DW_NAME     2
#define DW_DESC     3
#define DW_CRIADO   4
#define DW_DISP     5
#define DW_ICONE    6
#define STRUCT_DW_VAZIO { -1, "", "", ctod("  /  /  "), .f., "" }

/*
-----------------------------------------------------------------------------------------
Identificador dos tipos de gráficos a serem utilizados
-----------------------------------------------------------------------------------------
*/
#define CHART_BAR       0
#define CHART_BAR3D     1
#define CHART_COLUMN    2
#define CHART_COLUMN3D  3
#define CHART_LINE      4
#define CHART_LINE3D    5
#define CHART_PIE       6
#define CHART_RADAR     7
#define CHART_GAUGE     8

/*
-----------------------------------------------------------------------------------------
Identificador de atributos para dimensão temporal
-----------------------------------------------------------------------------------------
*/
#define DT_DT				   0
#define DT_ANO				   1
#define DT_PERIODO			2
#define DT_ESTACAO			3
#define DT_SEMESTRE			4
#define DT_QUADMESTRE		5
#define DT_TRIMESTRE	      6
#define DT_BIMESTRE			7
#define DT_MES	            8
#define DT_QUINZENA			9
#define DT_SEMANA		     10
#define DT_DIA			     11
#define DT_DOW				  12
#define DT_DOY			     13
#define DT_ANOMES        14

#define DT_FIELDS ({ "DT", "ANO", "PERIODO", "ESTACAO", "SEMESTRE", "QUADMESTRE", "TRIMESTRE", "BIMESTRE", "MES", "QUINZENA", "SEMANA", "DIA", "DOW", "DOY", "ANO+MES" })
#define DT_TITLES ({ "DT", _TRAD0005, _TRAD0006, _TRAD0007, _TRAD0008, _TRAD0009, _TRAD0010, _TRAD0011, _TRAD0012, _TRAD0013, _TRAD0014, _TRAD0015, _TRAD0016, _TRAD0017, "Ano/Mês" })/*//"Ano"###"Periodo"###"Estação"###"Semestre"###"Quadrimestre"###"Trimestre"###"Bimestre"###"Mês"###"Quinzena"###"Semana"###"Dia"###"Dia sem."###"Dia greg."*///####TRADUZIR

/*
-----------------------------------------------------------------------------------------
Identifica os tipos de processamento de drill
-----------------------------------------------------------------------------------------
*/
#define DRILLRESET   -1
#define DRILLDOWN 	1
#define DRILLUP   	2
#define DRILLACROSS  3

/*
-----------------------------------------------------------------------------------------
Tipos de arquivo para a importação
-----------------------------------------------------------------------------------------
*/
#define FT_ERROR     "process_error"
#define FT_TEXT      "text_file"
#define FT_XBASE 	 "xbase_file"
#define FT_ARRAY 	 "array_file"
#define FT_SQL   	 "sql_file"
#define FT_SX        "sx_file"

/*
-----------------------------------------------------------------------------------------
ID/titulos para estatistica
-----------------------------------------------------------------------------------------
*/
#define EST_LASTBUILD     1
#define EST_RECCOUNT      2
#define EST_TIMEFORBUILD  3
#define EST_TIMEFORSUM    4
#define EST_LASTACCESS    5
#define EST_TIMEDOWNLOAD  6
#define EST_COUNTACCESS   7
#define EST_AVGPAGESIZE   8
#define EST_VIRTUAL       9

#define EST_TITLES { _TRAD0018 + '<i>[@D]</i>' + _TRAD0019 + '<i>[XXXXXXXX]</i>' /*//'Dados extraídos em '###' às '*/, ;
							_TRAD0020 + '<i>[@E 999,999,999]</i>' + _TRAD0021 + '<i>[@E 999,999,999]</i>'/*//'Foram extraídos '###' registro(s) de um universo de '*/, ;
							_TRAD0022 + '<i>[@X]</i>'/*//'Tempo de construção '*/, ;
							_TRAD0023 + '<i>[@X]</i>'/*//'Tempo de sumarização '*/, ;
							_TRAD0024 + '<i>[@D]</i>' + _TRAD0019 + '<i>[XXXXXXXX]</i>'/*//'O último acesso foi em '###' às '*/, ;
							_TRAD0025 + '<i>download</i>' + _TRAD0026 + '<i>[@x]</i>'/*//'O tempo médio de '###' é '*/,;
							_TRAD0027 + '<i>[@E 99,999]</i>' + _TRAD0028/*//'Foi visualizada '###' vezes'*/, ;
							_TRAD0029 + '<i>[@E 99,999.99]</i> (kbytes)'/*//'O tamanho médio das páginas é de '*/,;
							_TRAD0030 + '<i>[@X]</i>'/*//'Campos virtuais/filtros '*/ }

/*
-----------------------------------------------------------------------------------------
ID para acesso ao array de definição de campos
-----------------------------------------------------------------------------------------
*/
#define FLD_ARRAY_SIZE 19
#define FLD_NAME        1 
#define FLD_TYPE        2 
#define FLD_LEN         3 
#define FLD_DEC         4 
#define FLD_DEFAULT     5 
#define FLD_GETINFO     6 
#define FLD_GET         7 
#define FLD_SET         8 
#define FLD_TITLE       9 
#define FLD_MASK       10 
#define FLD_REALNAME   11 
#define FLD_ID         12 
#define FLD_VISIBLE    13 
#define FLD_ROTEIRO    14 
#define FLD_BLANK      15 
#define FLD_COLSPAM    16 
#define FLD_ORIGNAME   17
#define FLD_READONLY   18
#define FLD_LONGNAME   19

/*
-----------------------------------------------------------------------------------------
ID para acesso ao array de espaço em uso (tam. fisico da tabelas)
-----------------------------------------------------------------------------------------
*/
#define SPC_ROWS            1
#define SPC_SIZE            2

/*
-----------------------------------------------------------------------------------------
Tipos de conexão para acessar arquivos/dados
-----------------------------------------------------------------------------------------
*/
#define TC_TOP_CONNECT "1"
#define TC_AP_SX       "2"
#define TC_AP_DIRETO   "3"
#define TC_BAAN        "4"

/*
-----------------------------------------------------------------------------------------
Identificadore de versão do TopConnect
-----------------------------------------------------------------------------------------
*/
#define TC_VER_32  32   // Identifica TopApi32
#define TC_VER_40  40   // Identifica TopApi40

/*
-----------------------------------------------------------------------------------------
Identificadores de databases
-----------------------------------------------------------------------------------------
*/
#define DB_DB2         "DB2"
#define DB_INFORMIX    "INFORMIX"
#define DB_ORACLE      "ORACLE"
#define DB_POSTGRES    "POSTGRES"
#define DB_MSSQL       "MSSQL"
#define DB_MSSQL6      "MSSQL6"
#define DB_MSSQL7      "MSSQL7"   
#define DB_DB2400	   "DB2/400"
#define DB_MSSQL_ALL   DB_MSSQL + "|" + DB_MSSQL6 + "|" + DB_MSSQL7

/*
-----------------------------------------------------------------------------------------
Identificadores de filetypes
-----------------------------------------------------------------------------------------
*/
#define FT_TXT           1
#define FT_SDF	         2
#define FT_HTM	         3
#define FT_EXCEL         4
#define FT_GRAPH_JPEG    5
#define FT_EXCEL_XML     6
#define FT_CSV           7
#define FT_DIRECT_EXCEL  8
#define FT_EXT	    1
#define FT_DESC     2
#define FT_EXP_CODE 3
#define FT_TYPES    {{".txt", "Texto"      , FT_TXT}       , {".txt", "Texto SDF" , FT_SDF}, ;
                     {".htm", "HyperText"  , FT_HTM}       , {".xls", "Excel"     , FT_EXCEL }, ;
                     {".jpg", "Imagem JPEG", FT_GRAPH_JPEG}, {".xml", "Excel(xml)", FT_EXCEL_XML}, ;
                     {".csv", "Texto(CSV)" , FT_CSV}        }

//-----------------------------------------------------------------------------------------

/*
-----------------------------------------------------------------------------------------
Identificadores de tipos de agendamento
-----------------------------------------------------------------------------------------
*/
#define AG_IMP		0	// Agendamento de Fonte de Dados (Importação)
#define AG_DSN		1	// Agendamento de Fonte de Dados (Importação)
#define AG_EXP		2	// Agendamento de Exportação

/*
-----------------------------------------------------------------------------------------
Identificadores de tipos de exportações
-----------------------------------------------------------------------------------------
*/
#define EX_CON		1	// Exportação de consulta
#define EX_DIM		2	// Exportação de dimensão
#define EX_CUBE	    3   // Exportação de cubos
#define EX_GRAF	    4	// Exportação de consulta - grafico

/*
-----------------------------------------------------------------------------------------
Comportamento a adotar quando existirem registros inválidos na importação do fato
-----------------------------------------------------------------------------------------
*/
#define PROCINV_ALL             "1" // Aceita registros invalidos
#define PROCINV_IGNORE_INVALID  "2" // Rejeita registros invalidos
#define PROCINV_IGNORE_ALL      "3" // Ignorar todos os registros

/*
-----------------------------------------------------------------------------------------
Comportamento a adotar quando importar dados para o cubo
-----------------------------------------------------------------------------------------
*/
#define UPDMET_DEFAULT          "1" // Método default
#define UPDMET_INSERT           "2" // Insere com chaves duplicadas
#define UPDMET_UPDATE           "3" // Atualiza o registro já existente

/*
-----------------------------------------------------------------------------------------
Comportamento a adotar na geração de listagem de inválidos
-----------------------------------------------------------------------------------------
*/
#define RPTINVAL_NONE           "1" // Não gerar
#define RPTINVAL_KEYSONLY       "2" // Somente chaves, max. 500
#define RPTINVAL_FULL           "3" // Completo, max. 500
#define RPTINVAL_KEYSONLY_SL    "4" // Somente chaves, sem limites
#define RPTINVAL_FULL_SL        "5" // Completo, sem limites

/*
-----------------------------------------------------------------------------------------
Identificador de tipos de informação (typeInfo) para a TAB_DD
-----------------------------------------------------------------------------------------
*/
#define DD_INDEX			"I"

/*
-----------------------------------------------------------------------------------------
Sub-tipos de query
-----------------------------------------------------------------------------------------
*/
#define ST_DEFAULT     0
#define ST_DIMENSION   1
#define ST_CUBE        2

/*
-----------------------------------------------------------------------------------------
Tipo de estatisticas
-----------------------------------------------------------------------------------------
*/
#define ST_DIMENSIONS_COUNT      "01000" // Numero de dimensões/registros por dimensão
#define ST_DIMENSIONS_ATT_COUNT  "01100" // Numero de atributos por dimensão
#define ST_DIMENSIONS_DS_COUNT   "01200" // Numero de fonte de dados por dimensão
#define ST_USERS_COUNT           "02000" // Numero de usuários
#define ST_GROUPS_COUNT          "03000" // Numero de grupos
#define ST_QUERYS_COUNT          "04000" // Numero de consultas
#define ST_CUBES_COUNT           "05000" // Numero de cubos
#define ST_CUBES_ATT_COUNT       "05100" // Numero de atributos por cubos
#define ST_CUBES_DS_COUNT        "05200" // Numero de fontes de dados por cubos
#define ST_CONNECTIONS_COUNT     "06000" // Numero de conexões
#define ST_CONNECTIONS_TOP_COUNT "06100" // Numero de conexões via TC
#define ST_CONNECTIONS_SX_COUNT  "06200" // Numero de conexões via SX
#define ST_CONNECTIONS_DIR_COUNT "06300" // Numero de conexões diretas
#define ST_USERS_LOGIN           "11100" // Data/hora de login
#define ST_LOGIN_TODAY           "11110" // Quant. de logins hoje
#define ST_USERS_LOGOUT          "11200" // Data/hora de logout
#define ST_USERS_TRYACCESS       "11300" // Acesso negado
#define ST_USERS_TIMEOUT         "11400" // Ocorreu queda por time-out

/*
-----------------------------------------------------------------------------------------
Opções para apresentação dos forms de filtros ou seleçao na visualização da cosulta
-----------------------------------------------------------------------------------------
*/
#define OPTION_SHOWNOTHING     "0"
#define OPTION_SHOWFILTER      "1"
#define OPTION_SHOWSELECTION   "2"

/*
-----------------------------------------------------------------------------------------
Opções para integração com Excel
-----------------------------------------------------------------------------------------
*/
#define EXCEL_NONE        "0"
#define EXCEL_SOME        "1"
#define EXCEL_ALL         "2"

/*
-----------------------------------------------------------------------------------------
Identificadores de tipo de filtro
-----------------------------------------------------------------------------------------
*/
#define FILTER_NORMAL    "0"
#define FILTER_SECURE    "1"
#define FILTER_SEGTO     "2"
                      
/*
-----------------------------------------------------------------------------------------
Identificadores de visualização
-----------------------------------------------------------------------------------------
*/
#define PAN_SIMPLES      "0"
#define PAN_DUPLO        "1"

/*
-----------------------------------------------------------------------------------------
Identificadores de bits para liberação de acesso
-----------------------------------------------------------------------------------------
*/

#define ACL_MANUTENCAO     1
#define ACL_CONSULTA       2
#define ACL_EXPORTA        3
#define ACL_G_MANUTENCAO   4
#define ACL_G_CONSULTA     5
#define ACL_G_EXPORTA      6
#define ACL_ADMIN          8

/*
-----------------------------------------------------------------------------------------
Identificadores de objetos das bases de dados
-----------------------------------------------------------------------------------------
*/
#define DBO_TABLE          "T"
#define DBO_VIEW           "V"
#define DBO_SP             "SP"

#define FT_STD "STD"
#define FT_CVS "CVS"
#define FT_MIX "MIX"

/*
-----------------------------------------------------------------------------------------
Lista de icones para DW
-----------------------------------------------------------------------------------------
*/
#define DW_ICONE_LIST {{ "Padrão", "dw_new.gif" } , ;
               { "Produção", "dw_fab.gif" } , ;
               { "Financeiro", "dw_fin.gif" } , ;
               { "R.H.", "dw_rh.gif" } , ;
               { "Comercial", "dw_ven.gif" } }
               
/*
-----------------------------------------------------------------------------------------
Lista de opções de processamento para registros inválidos
-----------------------------------------------------------------------------------------
*/
#define PROCINV_LIST    {{ "Aceita registros invalidos" , PROCINV_ALL            }, { "Rejeita registros invalidos", PROCINV_IGNORE_INVALID }, { "Ignorar todos os registros" , PROCINV_IGNORE_ALL     } }

/*
-----------------------------------------------------------------------------------------
Lista de opções de processamento para atualização
-----------------------------------------------------------------------------------------
*/
#define UPDMET_LIST     {{ "Padrão"     , UPDMET_DEFAULT }, { "Inserção"   , UPDMET_INSERT  }, { "Atualização", UPDMET_UPDATE  } }

/*
-----------------------------------------------------------------------------------------
Lista de opções de listagem de inválidos
-----------------------------------------------------------------------------------------
*/
#define RPTINVAL_LIST   { { "Não gerar"                 , RPTINVAL_NONE        }, { "Somente chaves, max. 500"  , RPTINVAL_KEYSONLY    }, { "Completo, max. 500"        , RPTINVAL_FULL        }, { "Somente chaves, sem limite", RPTINVAL_KEYSONLY_SL }, { "Completo, sem limite"      , RPTINVAL_FULL_SL     } }

/*
-----------------------------------------------------------------------------------------
Destinos para abertura de novas janelas no browse
-----------------------------------------------------------------------------------------
*/

#define TARGET_90_BLANK		1
#define TARGET_BLANK		0
#define TARGET_WINDOW      -1
#define TARGET_MODAL       -2
#define TARGET_HIDDEN      -3
#define TARGET_SAMEWINDOW  -4
#define TARGET_CUSTOM      0
#define TARGET_100_WINDOW  1.00
#define TARGET_98_WINDOW   0.98
#define TARGET_95_WINDOW   0.95
#define TARGET_90_WINDOW   0.90
#define TARGET_80_WINDOW   0.80
#define TARGET_75_WINDOW   0.75
#define TARGET_60_WINDOW   0.60
#define TARGET_50_WINDOW   0.50
#define TARGET_40_WINDOW   0.40
#define TARGET_30_WINDOW   0.30
#define TARGET_25_WINDOW   0.25
#define TARGET_20_WINDOW   0.20
#define TARGET_10_WINDOW   0.10

/*
-----------------------------------------------------------------------------------------
Valores de checkBox (tag html input, type=chechbox)
-----------------------------------------------------------------------------------------
*/
#define CHKBOX_OFF   "0"
#define CHKBOX_ON    "1"

/*
-----------------------------------------------------------------------------------------
Valores de descrição do tipo de objetos
-----------------------------------------------------------------------------------------
*/
#define OBJ_DIMENSION   "D"
#define OBJ_CUBE		    "C"
#define OBJ_QUERY		    "Q"
#define OBJ_FILTER	    "F"
#define OBJ_USER        "U"
#define OBJ_CONNECTION  "S"
#define OBJ_INDICADOR   "I"
#define OBJ_INDVIRT     "V"

/*
-----------------------------------------------------------------------------------------
Identificação do tipo de informação (grupo), passada via IPC
-----------------------------------------------------------------------------------------
*/
#define IPC_SIZE_ARRAY 7    
#define IPC_BUFFER     -1
#define IPC_ERRO       1
#define IPC_INFO       2
#define IPC_TEMPO      3
#define IPC_PROCESSO   4
#define IPC_ETAPA      5
#define IPC_AVISO      6
#define IPC_TERMINO    7

/*
-----------------------------------------------------------------------------------------
Identificação de tipos de consultas
-----------------------------------------------------------------------------------------
*/
#define QUERY_USER			"U"//suário
#define QUERY_PREDEF		"P"//re-definida
#define QUERY_USER_DESC		"de Usuário"
#define QUERY_PREDEF_DESC	"Pre-Definida"

/*
-----------------------------------------------------------------------------------------
Identificação das posições de informações sobre a tela do browse
-----------------------------------------------------------------------------------------
*/
#define SCREEN_SIZE    2
#define SCREEN_WIDTH   1
#define SCREEN_HEIGHT  2

#define AREA_RESERVA_DE_TELA 270

/*
-----------------------------------------------------------------------------------------
Opções de paginação em browser
-----------------------------------------------------------------------------------------
*/
#define ENABLE_PAGING_DEFAULT  "0"
#define ENABLE_PAGING_TRUE     "1"
#define ENABLE_PAGING_FALSE    "2"

/*
-----------------------------------------------------------------------------------------
Operações de paginação
-----------------------------------------------------------------------------------------
*/
#define FIRST_PAGE        "PI"  // PI = Página Inicial
#define PREVS_PAGE        "PA"  // PA = Página Anterior
#define PREVS_RECORD      "PR"  // PR = reg. anterior
#define SELCT_PAGE        "SP"  // SP = Seleção de Página	
#define NEXT_RECORD       "NR"  // NR = prox. reg.
#define NEXT_PAGE         "PP"  // PP = Próxima Página
#define LAST_PAGE         "UP"  // UP = Última Página

#define ORDER_PAGE        "OR"  // OR = Ordenar
#define PRINT_PAGE        "PR"  // PR = PRint page
#define QUERY_QBE         "QBE" // QBE = Pesquisa por QBE
#define QUERY_ALLRECORDS  "ALL" // ALL = browse ALL Records

#define FIELD_INICIALIZER	"INIT"     // Inicializa os campos para a tabela específica
#define FIELD_TYPE        "TYPE"     // Pesquisar o tipo um campo
#define FIELD_SIZE        "SIZE"     // Pesquisar o tamanho um campo
#define FIELD_DEC_SIZE 		"DECSIZE"  // Pesquisar o número de casas decimais de um campo
#define FIELD_CAPTION     "CAPTIONN" // Pesquisar o caption de um campo
#define FIELD_MEMO        "M"        // campo com tipo Memo

/*
-----------------------------------------------------------------------------------------
Identificadores utilizados no armazenamento de diversas consultas em cache. Utilizados
pelos métodos de cache da classe TConsulta e nos arquivos que modifiquem ou acessem
uma consulta em cahe.
-----------------------------------------------------------------------------------------
*/
#define MEMO_CONS_QTDE_ELEMS  32 // Quantidade de elementos do array
#define MEMO_CONS_AXIS_X       1 // definição do eixo X
#define MEMO_CONS_AXIS_Y       2 // definição do eixo Y
#define MEMO_CONS_AXIS_M       3 // definição do eixo m (indicadores
#define MEMO_CONS_ALERT        4 // definição dos alertas
#define MEMO_CONS_WHERE        5 // definição dos filtros
#define MEMO_CONS_DRILL        6 // definição do drill
#define MEMO_CONS_RANK         7 // definição do rank
#define MEMO_CONS_RECLIM       8 // definição da propriedade de limite de registros
#define MEMO_CONS_INDSOBR      9 // definição da propriedade ind. sobre possto
#define MEMO_CONS_EMPTYCELL   10 // definição da propriedade empty cell
#define MEMO_CONS_FILTERED    11 // definição da propriedade filtered
#define MEMO_CONS_TOTAL       12 // definição da propriedade total
#define MEMO_CONS_ALERTON     13 // definição da propriedade alert on
#define MEMO_CONS_HINTON      14 // definição da propriedade hint on
#define MEMO_CONS_IGNZERO     15 // definição da propriedade ignorar zeros
#define MEMO_CONS_USEEXCEL    16 // definição da propriedade excel
#define MEMO_CONS_RANKON      17 // definição da propriedade rank on
#define MEMO_CONS_RNKOTHER    18 // definição da propriedade rankear outros
#define MEMO_CONS_ZERACUM     19 // definição da propriedade zera acumulados
#define MEMO_CONS_ISVALID     20 // definição da propriedade se consulta é valida
#define MEMO_CONS_GRAPHCLASS  21 // definição da propriedade classe do gráfico
#define MEMO_CONS_GRAPHPROPS  22 // definição da propriedade do gráfico
#define MEMO_CONS_GRAPHPY     23 // definição da propriedade Y do gráfico
#define MEMO_CONS_GRAPHPY2    24 // definição da propriedade Y2 do gráfico
#define MEMO_CONS_KEY_VALUES  25 // chaves de valores para a páginação
#define MEMO_CONS_AUTO_FILTER 26 // chaves de valores para o auto filter/seleção
#define MEMO_CONS_CUBE_ID     27 // ID do cubo da consulta
#define MEMO_CONS_PROPS       28 // Outras propriedades
#define MEMO_CONS_HIDEATT     29 // atributos não visiveis
#define MEMO_CONS_PAGE_KEYS	  30 // chaves usadas na paginação
#define MEMO_CONS_DRILL_HIST	31 // chaves usadas na paginação
#define MEMO_CONS_CURVAABC    32 // parametros para classificação da curva ABC

/*
-----------------------------------------------------------------------------------------
Identificadores de cache
-----------------------------------------------------------------------------------------
*/
#define CACHE_QUERY       "cacheQuery"
#define CACHE_KEY_VALUES  "consKeyValues"

/*
-----------------------------------------------------------------------------------------
Identificadores de listas para combos
-----------------------------------------------------------------------------------------
*/

#define NUM_COMBO_LISTS        7
#define ADVPL_FIELD_TYPES      1
#define PERIODICIDADE_SCHD     2
#define TIPO_CONEXAO           3
#define TIPO_BANCO             4
#define ADVPL_EXT_FIELD_TYPES  5
#define AGG_LIST_FOR_APPLET    6
#define RNK_PROCESSOS          7
      
/*
-----------------------------------------------------------------------------------------
Identificadores dos métodos utilizados para sumarização no Oracle
-----------------------------------------------------------------------------------------
*/
#define ORA_INSERT_INTO   0
#define ORA_MERGE         1
#define ORA_CTAS          2

/*
-----------------------------------------------------------------------------------------
Identificadores dos métodos utilizados para importação
-----------------------------------------------------------------------------------------
*/
#define ORA_IMP_DEFAULT   0
#define ORA_IMP_MERGE     1
#define ORA_IMP_INDEX     2
      

/*
-----------------------------------------------------------------------------------------
Identificadores de dimensão e atributos reservados
-----------------------------------------------------------------------------------------
*/
#define DIM_EMPFIL              "EMPFIL"
#define ATT_M0_CODIGO_KEYSEQ    1
#define ATT_M0_CODIGO_NOME      "M0_CODIGO"
#define ATT_M0_CODIGO_DESCRICAO "Código da Empresa"
#define ATT_M0_CODIGO_VISIBLE   .F.
#define ATT_M0_CODIGO_TIPO      "C"
#define ATT_M0_CODIGO_TAM       2
#define ATT_M0_CODFIL_NOME      "M0_CODFIL"
#define ATT_XX_FILIAL_NOME      "FILIAL"

/*
-----------------------------------------------------------------------------------------
Identificadores de tipos de ranking
-----------------------------------------------------------------------------------------
*/

#define RNK_ZERA     "x" // zerar R_A_N_K_ (limpar)
#define RNK_PARETO   "P" // principio de pareto
#define RNK_MENORES  "-" // menores
#define RNK_MAIORES  "+" // maiores
#define RNK_CURVAABC "A" // maiores

/*
-----------------------------------------------------------------------------------------
Identificadores das posições das informações de classificação para a curva ABC
-----------------------------------------------------------------------------------------
*/
#define ABC_SIZE       5
#define ABC_CLASSIF    1  // classificação
#define ABC_PERC       2  // percentual
#define ABC_DESC       3  // descrição
#define ABC_COR        4  // cor de destaque
#define ABC_LIMITE     5  // limite inferior da classificação

#endif


