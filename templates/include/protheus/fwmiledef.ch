///////////////////////////////////////////////////////
//
// Include de uso da ferramenta MILE
//
///////////////////////////////////////////////////////
//-----------------------------------------------------
// Operacoes
//-----------------------------------------------------
#DEFINE MILE_IMPORT         '1'
#DEFINE MILE_EXPORT         '2'
//-----------------------------------------------------
// Tipos de Adapters
//-----------------------------------------------------
#DEFINE MILE_ADAPT_EXECAUTO '1'
#DEFINE MILE_ADAPT_MVC      '2'
#DEFINE MILE_ADAPT_FUNC     '3'
//-----------------------------------------------------
// Tipos de Leitura/Geracao
//-----------------------------------------------------
#DEFINE MILE_STRUCT_FIX     '1'
#DEFINE MILE_STRUCT_SEP     '2'
//-----------------------------------------------------
// Operacoes
//-----------------------------------------------------
#DEFINE MILE_DEACTIVE       '0'
#DEFINE MILE_ACTIVE         '1'
//-----------------------------------------------------
// Tamanho de alguns campos importantes
//-----------------------------------------------------
#DEFINE TAMMILELAYOUT         8
#DEFINE TAMMILECANAL         20
#DEFINE TAMMILEADAPTER       10
//-----------------------------------------------------
// Dados
//-----------------------------------------------------
#DEFINE XZ1DADOS              1
#DEFINE XZ2DADOS              2
//-----------------------------------------------------
// Dados Gerais Layout
//-----------------------------------------------------
#DEFINE XZ1LAYOUT      	   1, 1
#DEFINE XZ1TYPE        	   1, 2
#DEFINE XZ1ADAPT       	   1, 3
#DEFINE XZ1STRUCT      	   1, 4
#DEFINE XZ1SEPARA      	   1, 5
#DEFINE XZ1TYPEXA      	   1, 6
#DEFINE XZ1SEPINI      	   1, 7
#DEFINE XZ1SEPFIN      	   1, 8
#DEFINE XZ1TABLE       	   1, 9
#DEFINE XZ1ORDER       	   1,10
#DEFINE XZ1DESC        	   1,11
#DEFINE XZ1SOURCE      	   1,12
#DEFINE XZ1PRE         	   1,13
#DEFINE XZ1POS         	   1,14
#DEFINE XZ1TDATA       	   1,15
#DEFINE XZ1TIPDAT      	   1,16
#DEFINE XZ1EMULTC      	   1,17
#DEFINE XZ1DETOPC      	   1,18
#DEFINE XZ1IMPEXP      	   1,19
#DEFINE XZ1DECSEP      	   1,20
#DEFINE XZ1MVCOPT      	   1,21
#DEFINE XZ1MVCMET      	   1,22    
#DEFINE XZ1CANDO      	   1,23
#DEFINE XZ1SEPAS      	   1,24
#DEFINE XZ1NOCACHE     	   1,25
#DEFINE XZ1PERG     	   1,26
//-----------------------------------------------------
// Dados Canal Layout
//-----------------------------------------------------
#DEFINE XZ2CHANEL      	   1
#DEFINE XZ2SUPER       	   2
#DEFINE XZ2DESC        	   3
#DEFINE XZ2IDOUT       	   4
#DEFINE XZ2OCCURS      	   5
#DEFINE XZ2POS         	   6
//#DEFINE XZ2BREAK           7
#DEFINE XZ2XZ4         	   7
#DEFINE XZ2XZ5         	   8
//-----------------------------------------------------
// Dados Campos Layout
//-----------------------------------------------------
#DEFINE XZ4FIELD       	   1
#DEFINE XZ4TYPFLD      	   2
#DEFINE XZ4SIZFLD      	   3
#DEFINE XZ4DECFLD      	   4
#DEFINE XZ4SOURCE      	   5
#DEFINE XZ4EXEC        	   6
#DEFINE XZ4COND        	   7
#DEFINE XZ4VALUE       	   8
#DEFINE XZ4NOVAL       	   9
//-----------------------------------------------------
// Dados Variaveis Layout
//-----------------------------------------------------
#DEFINE XZ5FIELD           1
#DEFINE XZ5TYPFLD          2
#DEFINE XZ5SIZFLD          3
#DEFINE XZ5DECFLD          4
#DEFINE XZ5SOURCE          5
#DEFINE XZ5EXEC            6
#DEFINE XZ5COND            7
#DEFINE XZ5VALUE           8
//-----------------------------------------------------
// Vetor de Saida
//-----------------------------------------------------
#DEFINE OUTID              1
#DEFINE OUTBREAK           2
#DEFINE OUTITENS           4
#DEFINE OUTCHNIN           5
#DEFINE OUTIDSUPER         6
//-----------------------------------------------------
// Vetor de Informacoes passado as funcoes do layout
//-----------------------------------------------------
#DEFINE MILE_INFO_LINEFROM 1
#DEFINE MILE_INFO_LINETO   2
#DEFINE MILE_INFO_TXTFILE  3
//-----------------------------------------------------
// Posicao das opcoes do CFGA600 no menu
//-----------------------------------------------------
#DEFINE MILE_MENU_VIEW   1 //"&Visualizar"
#DEFINE MILE_MENU_INSERT 2 //"&Incluir"
#DEFINE MILE_MENU_UPDATE 3 //"&Alterar"
#DEFINE MILE_MENU_DELETE 4 //"&Excluir"
#DEFINE MILE_MENU_COPY   5 //"&Copiar"
#DEFINE MILE_MENU_LAYOUT 6 //"&Layouts"
#DEFINE MILE_MENU_DOC    7 //"&Documentação"
#DEFINE MILE_MENU_PROTXT 8 //"Proc. &TXT"
#DEFINE MILE_MENU_LOG    9 // LOG
