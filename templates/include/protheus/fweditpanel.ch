// Layouts               
#DEFINE FF_LAYOUT_VERT_DESCR_TOP 			001 // Vertical com descrição acima do get
#DEFINE FF_LAYOUT_VERT_DESCR_LEFT			002 // Vertical com descrição a esquerda
#DEFINE FF_LAYOUT_HORZ_DESCR_TOP 			003 // Horizontal com descrição acima do get
#DEFINE FF_LAYOUT_HORZ_DESCR_LEFT			004 // Horizontal com descrição a esquerda

// Posicionamentos primários
#DEFINE FF_COLUMN_WIDTH_DESCR  		040 // Largura da coluna da descrição
#DEFINE FF_COLUMN_WIDTH_DEF_TOP		140 // Largura  Calculo em pixels de 20 caracteres para TGet (Horizontal)
#DEFINE FF_COLUMN_WIDTH_DEF_LEFT	260 // Calculo em pixels de 20 caracteres para TGet (Vertical)

// Medidas em pixels de posicionamento dos controles
#Define FF_CTRL_INIT_TOP  				006 // Pixel inicial ao topo
#Define FF_CTRL_INIT_LEFT 				010 // Pixel inicial a esquerda
#Define FF_CTRL_SEP_LINE 					014 // Distancia em pixels entre cada controle verticalmente
#Define FF_CTRL_SEP_LEFT 					020 // Distancia em pixels entre cada controle horizontalmente
#Define FF_CTRL_HEIGHT_DESCR_TOP	038 // Altura da linha quando descrição acima 
#Define FF_CTRL_HEIGHT_DESCR_LEFT	022 // Altura da linha quando descrição a esquerda 
#Define FF_DESCR_HEIGHT						018 // Altura da descrição
#Define FF_HEADER_HEIGHT 					011 // Altura do Header no FWEditPanel 
#Define FF_SCROLL_WIDTH						015 // Largura da Scroll lateral
#Define FF_BUTTON_WIDTH						022 // Largura do botão de consulta padrão
#Define FF_BUTTON_HEIGHT					011 // Altura do botão de Imagem/Memo (lX3Memo da MSMGet)
#Define FF_CHECK_WIDTH						022 // Largura do quandrado do CheckBox
#Define FF_CHECK_HEIGHT						014 // Altura padrão do campo Check
#Define FF_MSGET_HEIGHT						009 // Altura padrão do MSGET
#Define FF_COMBO_BUTTON_WIDTH			008 // Largura do botão da ComboBox
#Define FF_CTRL_WIDTH_MINIMAL			032 // Largura minima do controle

// Dimensao dos objetos largos                  
#Define FF_MEMO_WIDTH     		    300 // Largura do campo Memo em Pixels
#Define FF_MEMO_LINES			        003 // Altura do campo Memo em Linhas
#Define FF_IMAGE_WIDTH        	  226 // Largura do campo imagem
#Define FF_IMAGE_LINES	         	005 // Altura do campo Image em linhas (respeitando o Layout)
#Define FF_LIST_WIDTH     		    300 // Largura dos campos radio/listbox
#Define FF_LIST_LINES			        003 // Altura dos campos radio/listbox

// Tipo de lista à ser usado
#Define FF_LIST_COMBO			        001 // Combo
#Define FF_LIST_RADIO			        002 // Radio
#Define FF_LIST_LISTBOX		        003 // Listbox

// Estilos padrao
#Define FF_STYLE_BODY 			"QLabel{ border: 1px solid red;}"
#Define FF_STYLE_HEADER		 	"QLabel{ margin:2px;"+; 
		                				" margin-bottom:0px;"+;
    		            				" margin-right:0px;"+;
		  											" border-style:solid;"+; 
		  											" border-width:1px;"+;
	              						" border-color:#7988A3;"+; 
	              						" background-color:#99A2B4;"+; 
	              						" border-bottom:none;}"
#Define FF_STYLE_TITLE			"QLabel{ border:none; color: white}"

#Define FF_STYLE_SEPARATOR 	"QLabel{background-color: White; margin-top: 2px; color: #004A77; font: bold 14px; border: none; border-bottom: 2px solid #004A77;}" 
//#Define FF_STYLE_SEPARATOR 	"QLabel{backgroundo-color: White; margin-top: 2px; color: #8A93A5; font: bold 14px; border: none; border-bottom: 2px solid #8A93A5;}" 


// Disposicao dos campos
#Define FF_PARAM_ITEMS_COUNT			028
#Define FF_PARAM_ORDER					001
#Define FF_PARAM_CTRL_TYPE				002
#Define FF_PARAM_FIELD					003
#Define FF_PARAM_TITLE      			004
#Define FF_PARAM_TYPE       			005
#Define FF_PARAM_SIZE       			006
#Define FF_PARAM_DECIMAL    			007
#Define FF_PARAM_REQUIRED   			008
#Define FF_PARAM_WHEN       			009
#Define FF_PARAM_VALID      			010
#Define FF_PARAM_CANCHANGE  			011
#Define FF_PARAM_BSETGET     			012
#Define FF_PARAM_CREADVAR    			013
#Define FF_PARAM_FOLDER     			014
#Define FF_PARAM_GROUP      			015
#Define FF_PARAM_PICTURE    			016
#Define FF_PARAM_BPICTVAR   			017
#Define FF_PARAM_LOOKUP     			018
#Define FF_PARAM_ACOMBBOX   			019
#Define FF_PARAM_TAMCBOX    			020
#Define FF_PARAM_HELP       			021
#Define FF_PARAM_INSERTLINE 			022
#Define FF_PARAM_RIGHT					023
#Define FF_PARAM_CTRL					024
#Define FF_PARAM_TITLEFULL				025
#Define FF_PARAM_CPICTVAR				026
#Define FF_PARAM_LINESCTRL				027
#Define FF_PARAM_CTRLWIDTH				028

// *******************************************************************************************
// [OBSOLETO, separador de grupo sera uma linha]
// #Define FF_CTRL_SEP_GRP  					012 // Distancia em pixels que sera usada pelo separador de Grupos

//[todo:calcular a partir do nr de linhas] 
//#Define FF_IMAGE_BUTTON_HEIGHT 	  010 // Altura do campo imagem

// Tipos de Campos
//#Define FF_EDIT_CONTROL_GET				"G"
//#Define FF_EDIT_CONTROL_COMBO			"C"
//#Define FF_EDIT_CONTROL_MEMO			"M"
//#Define FF_EDIT_CONTROL_IMAGE			"I"

// #Define FW_CTRL_SEP_TOP_LABEL_TOP  022 // Distancia em pixels entre cada controle verticalmente[quando a label estiver no topo]  (OBSOLETO)
// #Define FW_CTRL_SEP_TOP_LABEL_LEFT 012 // Distancia em pixels entre cada controle verticalmente[quando a label estiver a esquerda]  (OBSOLETO)
// #Define FW_MEMO_HEIGHT             050 // Altura do campo Memo (OBSOLETO)
// #Define FW_IMAGE_HEIGHT            080 // Altura do campo imagem: 070 (OBSOLETO)
// *******************************************************************************************

