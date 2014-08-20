#INCLUDE "PARMTYPE.CH"
#INCLUDE "FWMBROWSE.CH"

//------------------------------------------------------------
//Conjunto de especificacoes do ProtheusFunctionMVC
//------------------------------------------------------------
#DEFINE FORM_STRUCT_TABLE_MODEL       1
#DEFINE FORM_STRUCT_TABLE_TRIGGER     2
#DEFINE FORM_STRUCT_TABLE_VIEW        3
#DEFINE FORM_STRUCT_TABLE_FOLDER      4
#DEFINE FORM_STRUCT_TABLE_GROUP       5
#DEFINE FORM_STRUCT_TABLE_ALIAS       6
#DEFINE FORM_STRUCT_TABLE_INDEX       7
#DEFINE FORM_STRUCT_TABLE_BROWSE      8
#DEFINE FORM_STRUCT_TABLE_RULES       9

#DEFINE FORM_STRUCT_TABLE_ALIAS_ID          1
#DEFINE FORM_STRUCT_TABLE_ALIAS_PK          2
#DEFINE FORM_STRUCT_TABLE_ALIAS_DESCRIPTION 3

#DEFINE FORM_STRUCT_TABLE_INDEX_ORDEM       1
#DEFINE FORM_STRUCT_TABLE_INDEX_ID          2
#DEFINE FORM_STRUCT_TABLE_INDEX_KEY         3
#DEFINE FORM_STRUCT_TABLE_INDEX_DESCRIPTION 4
#DEFINE FORM_STRUCT_TABLE_INDEX_F3          5
#DEFINE FORM_STRUCT_TABLE_INDEX_NICKNAME    6
#DEFINE FORM_STRUCT_TABLE_INDEX_SHOWPESQ    7

#DEFINE FORM_STRUCT_TABLE_FOLDER_ID          1
#DEFINE FORM_STRUCT_TABLE_FOLDER_DESCRIPTION 2

#DEFINE FORM_STRUCT_TABLE_GROUP_ID           1
#DEFINE FORM_STRUCT_TABLE_GROUP_DESCRIPTION  2
#DEFINE FORM_STRUCT_TABLE_GROUP_FOLDER       3
#DEFINE FORM_STRUCT_TABLE_GROUP_TYPE         4

#DEFINE FORM_STRUCT_CARGO_MEMO       1
#DEFINE FORM_STRUCT_CARGO_MEMO_CODE  1
#DEFINE FORM_STRUCT_CARGO_MEMO_TEXT  2
#DEFINE FORM_STRUCT_CARGO_MEMO_TABLE 3

//------------------------------------------------------------
// Ordem do aRotina do MenuDef
//------------------------------------------------------------
#DEFINE MVC_BUTTON_TITLE 	  1
#DEFINE MVC_BUTTON_ACTION     2
#DEFINE MVC_BUTTON_UNUSED     3
#DEFINE MVC_BUTTON_OPERATION  4
#DEFINE MVC_BUTTON_ACCESS     5
#DEFINE MVC_BUTTON_DISABLE    6
#DEFINE MVC_BUTTON_ID         7
#DEFINE MVC_BUTTON_TOOLBAR    8

//------------------------------------------------------------
// Ordem do aToolBar do ToolBarDef
//------------------------------------------------------------
#DEFINE MVC_TOOLBAR_IMAGE 	      1
#DEFINE MVC_TOOLBAR_ACTION        2
#DEFINE MVC_TOOLBAR_TITLE         3
#DEFINE MVC_TOOLBAR_DESCRIPTION   4
#DEFINE MVC_TOOLBAR_SHORTCUT      5
#DEFINE MVC_TOOLBAR_TEXTSHORTCUT  6
#DEFINE MVC_TOOLBAR_ID            7
#DEFINE MVC_TOOLBAR_TOOLBAR       8

//------------------------------------------------------------
#DEFINE MODELO_PK_OPERATION 1
#DEFINE MODELO_PK_KEYS      2

#DEFINE MODELO_PK_VALUE     1
#DEFINE MODELO_PK_IDFIELD   2
//------------------------------------------------------------
#DEFINE MODEL_TRIGGER_IDFIELD       1
#DEFINE MODEL_TRIGGER_TARGETIDFIELD 2
#DEFINE MODEL_TRIGGER_PRE           3
#DEFINE MODEL_TRIGGER_SETVALUE      4
//------------------------------------------------------------
#DEFINE MODEL_FIELD_TITULO   1
#DEFINE MODEL_FIELD_TOOLTIP  2
#DEFINE MODEL_FIELD_IDFIELD  3
#DEFINE MODEL_FIELD_TIPO     4
#DEFINE MODEL_FIELD_TAMANHO  5
#DEFINE MODEL_FIELD_DECIMAL  6
#DEFINE MODEL_FIELD_VALID    7
#DEFINE MODEL_FIELD_WHEN     8
#DEFINE MODEL_FIELD_VALUES   9
#DEFINE MODEL_FIELD_OBRIGAT 10
#DEFINE MODEL_FIELD_INIT    11
#DEFINE MODEL_FIELD_KEY     12
#DEFINE MODEL_FIELD_NOUPD   13
#DEFINE MODEL_FIELD_VIRTUAL 14
#DEFINE MODEL_FIELD_CVALID  15

//------------------------------------------------------------
//Conjunto de especificacoes do FWFORMMODEL e derivacoes
//------------------------------------------------------------
#DEFINE MODEL_RELATION_RULES        1
#DEFINE MODEL_RELATION_KEY          2

#DEFINE MODEL_RELATION_RULES_ORIGEM 1
#DEFINE MODEL_RELATION_RULES_TARGET 2
//------------------------------------------------------------
#DEFINE MODEL_STRUCT_TYPE         1
#DEFINE MODEL_STRUCT_ID           2
#DEFINE MODEL_STRUCT_MODEL        3
#DEFINE MODEL_STRUCT_OWNER        4

//------------------------------------------------------------
// Tipo de criacao de codigos de bloco FWBUILDFEATURE
//------------------------------------------------------------
#DEFINE STRUCT_FEATURE_VALID      1
#DEFINE STRUCT_FEATURE_WHEN       2
#DEFINE STRUCT_FEATURE_INIPAD     3
#DEFINE STRUCT_FEATURE_PICTVAR    4

//------------------------------------------------------------
// Array de AddRules da Estrutura do Model
//------------------------------------------------------------
#DEFINE STRUCT_RULES_ID            1
#DEFINE STRUCT_RULES_IDFIELD       2
#DEFINE STRUCT_RULES_IDTARGET      3
#DEFINE STRUCT_RULES_IDFIELDTARGET 4
#DEFINE STRUCT_RULES_TYPE          5

//------------------------------------------------------------
#DEFINE MODEL_DATA_IDFIELD  1
#DEFINE MODEL_DATA_VALUE    2
#DEFINE MODEL_DATA_UPDATE   3
#DEFINE MODEL_DATA_COUNT    4
#DEFINE MODEL_DATA_SUM      5
//------------------------------------------------------------
// Controles do aDataModel
// FormGrid
//------------------------------------------------------------
#DEFINE MODEL_GRID_DATA      1
#DEFINE MODEL_GRID_VALID     2
#DEFINE MODEL_GRID_DELETE    3
#DEFINE MODEL_GRID_ID        4
#DEFINE MODEL_GRID_CHILDREN  5
#DEFINE MODEL_GRID_MODIFY 	 6
#DEFINE MODEL_GRID_INSERT    7
#DEFINE MODEL_GRID_UPDATE    8
#DEFINE MODEL_GRID_CHILDLOAD 9
//------------------------------------------------------------
#DEFINE MODEL_FIELD_DATA           1
#DEFINE MODEL_FIELD_CHILDREN       2
//------------------------------------------------------------
#DEFINE MODEL_GRID_CHILDREN_ID           1
#DEFINE MODEL_GRID_CHILDREN_DATA         2
#DEFINE MODEL_GRID_CHILDREN_COLS         3
#DEFINE MODEL_GRID_CHILDREN_CALC         4
#DEFINE MODEL_GRID_CHILDREN_LINE         5
#DEFINE MODEL_GRID_CHILDREN_LINESCHANGED 6

//------------------------------------------------------------
// Tipos do GetLinesChanged
//------------------------------------------------------------
#DEFINE MODEL_GRID_LINECHANGED_ALL		 0
#DEFINE MODEL_GRID_LINECHANGED_INSERTED	 1
#DEFINE MODEL_GRID_LINECHANGED_UPDATED	 2
#DEFINE MODEL_GRID_LINECHANGED_DELETED	 4

//------------------------------------------------------------
// Controles do aDataModel
// FormField
//------------------------------------------------------------
#DEFINE MODEL_FIELD_CHILDREN_ID      1
#DEFINE MODEL_FIELD_CHILDREN_DATA    2
#DEFINE MODEL_FIELD_CHILDREN_DATAID  3

//------------------------------------------------------------
#DEFINE MODEL_GRID_CALC_IDFIELD      1
#DEFINE MODEL_GRID_CALC_IDFORMCALC   2
#DEFINE MODEL_GRID_CALC_IDCALC       3
//------------------------------------------------------------
#DEFINE MODEL_GRIDLINE_VALUE    1
#DEFINE MODEL_GRIDLINE_UPDATE   2
//------------------------------------------------------------
#DEFINE MODEL_RULES_IDFIELD       1
#DEFINE MODEL_RULES_IDTARGET      2
#DEFINE MODEL_RULES_IDFIELDTARGET 3
#DEFINE MODEL_RULES_TYPE          4
//------------------------------------------------------------
#DEFINE MODEL_MSGERR_IDFORM     1
#DEFINE MODEL_MSGERR_IDFIELD    2
#DEFINE MODEL_MSGERR_IDFORMERR  3
#DEFINE MODEL_MSGERR_IDFIELDERR 4
#DEFINE MODEL_MSGERR_ID         5
#DEFINE MODEL_MSGERR_MESSAGE    6
#DEFINE MODEL_MSGERR_SOLUCTION  7
#DEFINE MODEL_MSGERR_VALUE      8
#DEFINE MODEL_MSGERR_OLDVALUE   9
//------------------------------------------------------------
#DEFINE MODEL_OPERATION_VIEW       1
#DEFINE MODEL_OPERATION_INSERT     3
#DEFINE MODEL_OPERATION_UPDATE     4
#DEFINE MODEL_OPERATION_DELETE     5
#DEFINE MODEL_OPERATION_ONLYUPDATE 6

//------------------------------------------------------------
// Operadores Relacionais e Logicos do filtro de carga do formulario
//------------------------------------------------------------
#DEFINE MVC_LOADFILTER_EQUAL 			  1 // Igual a
#DEFINE MVC_LOADFILTER_NOT_EQUAL  		  2 // Diferente de
#DEFINE MVC_LOADFILTER_LESS  			  3 // Menor que
#DEFINE MVC_LOADFILTER_LESS_EQUAL  		  4 // Menor que ou Igual a
#DEFINE MVC_LOADFILTER_GREATER  		  5 // Maior que
#DEFINE MVC_LOADFILTER_GREATER_EQUAL	  6 // Maior que ou Igual a
#DEFINE MVC_LOADFILTER_CONTAINS 		  7 // Contém
#DEFINE MVC_LOADFILTER_NOT_CONTAINS  	  8 // Não Contém
#DEFINE MVC_LOADFILTER_IS_CONTAINED       9 // Está Contido Em
#DEFINE MVC_LOADFILTER_IS_NOT_CONTAINED  10 // Não Está Contido Em

#DEFINE MVC_LOADFILTER_AND  		      1 // "e" AND
#DEFINE MVC_LOADFILTER_OR  				  2 // "ou" OR

//------------------------------------------------------------
// Controles do modelo
//------------------------------------------------------------
#DEFINE MODEL_CONTROL_ONDEMAND      1
#DEFINE MODEL_CONTROL_COPY          2
#DEFINE MODEL_CONTROL_FORCELOAD     3
#DEFINE MODEL_CONTROL_PROCESS       4

//------------------------------------------------------------
//Conjunto de especificacoes do FWFORMVIEW e derivacoes
//------------------------------------------------------------
#DEFINE VIEWS_VIEW_ID 		    1
#DEFINE VIEWS_VIEW_TYPE 	    2
#DEFINE VIEWS_VIEW_OBJ 	        3
#DEFINE VIEWS_VIEW_IDCONTAINER  4
#DEFINE VIEWS_VIEW_VALID 	    5
#DEFINE VIEWS_VIEW_LINKVIEW	    6
#DEFINE VIEWS_VIEW_TITLE		7
#DEFINE VIEWS_VIEW_TITLE_COLOR	8
#DEFINE VIEWS_VIEW_PROPERTY     9

#DEFINE MVC_VIEW_IDFIELD        1
#DEFINE MVC_VIEW_ORDEM          2
#DEFINE MVC_VIEW_TITULO         3
#DEFINE MVC_VIEW_DESCR          4
#DEFINE MVC_VIEW_HELP           5
#DEFINE MVC_VIEW_PICT           7
#DEFINE MVC_VIEW_PVAR           8
#DEFINE MVC_VIEW_LOOKUP         9
#DEFINE MVC_VIEW_CANCHANGE     10
#DEFINE MVC_VIEW_FOLDER_NUMBER 11
#DEFINE MVC_VIEW_GROUP_NUMBER  12
#DEFINE MVC_VIEW_COMBOBOX      13
#DEFINE MVC_VIEW_MAXTAMCMB     14
#DEFINE MVC_VIEW_INIBROW       15
#DEFINE MVC_VIEW_VIRTUAL       16
#DEFINE MVC_VIEW_PICTVAR       17
#DEFINE MVC_VIEW_INSERTLINE    18
#DEFINE MVC_VIEW_WIDTH         19

#DEFINE MVC_MODEL_TITULO   1
#DEFINE MVC_MODEL_TOOLTIP  2
#DEFINE MVC_MODEL_IDFIELD  3
#DEFINE MVC_MODEL_TIPO     4
#DEFINE MVC_MODEL_TAMANHO  5
#DEFINE MVC_MODEL_DECIMAL  6
#DEFINE MVC_MODEL_VALID    7
#DEFINE MVC_MODEL_WHEN     8
#DEFINE MVC_MODEL_VALUES   9
#DEFINE MVC_MODEL_OBRIGAT 10
#DEFINE MVC_MODEL_INIT    11

#DEFINE FORMSTRUFIELD      1
#DEFINE FORMSTRUTRIGGER    2

#DEFINE VIEWSTRUFIELD      3
#DEFINE VIEWSTRUFOLDER     4
#DEFINE VIEWSTRUDOCKWINDOW 5
#DEFINE VIEWSTRUGROUP      6

//------------------------------------------------------------
// Defines do ultimo estado dos botoes precionados
//------------------------------------------------------------
#DEFINE VIEW_BUTTON_ERROR  -1
#DEFINE VIEW_BUTTON_OK      0
#DEFINE VIEW_BUTTON_CANCEL  1

//------------------------------------------------------------
#DEFINE OP_PESQUISAR 	1
#DEFINE OP_VISUALIZAR	2
#DEFINE OP_INCLUIR		3
#DEFINE OP_ALTERAR		4
#DEFINE OP_EXCLUIR		5
#DEFINE OP_IMPRIMIR	 	8
#DEFINE OP_COPIA	 	9


#xcommand ADD FWTOOLBUTTON <aToolBar> ;
	RESOURCE        <cResource>		  ;
	ACTION	    	<bAction>		  ;
	TITLE		    <cTitle>		  ;
	DESCRIPTION	    <cDescription>    ;
	[ SHORTCUT	    <nShortCut>     ] ;
	[ TEXTSHORTCUT	<cTextShortCut> ] ;
	ID		        <cId>	          ;
	RELATION        <cRelation>       ;
	=>							      ;
	<aToolBar> := If(ValType(<aToolBar>) <> "A",{},<aToolBar>);;
	Aadd(<aToolBar>,{<cResource>,<bAction>,<cTitle>,<cDescription>,<nShortCut>,<cTextShortCut>,<cId>,<cRelation>})

#xcommand NEW MODEL ;
			TYPE <nType> ;
			DESCRIPTION <cDescription> ;
			BROWSE <oBrowse> ;
			SOURCE <cSource> ;
			[ MODELID <cModelID> ] ;
			[ LEGEND <aLegends,...>];
			[ FILTER <cFilter> ] ;
			[ <canactive:CANACTIVE, CAN ACTIVE> <bSetVldActive> ] ;
			[ <pk:PRIMARYKEY, PRIMARY KEY> <aPrimaryKey,...> ] ;
				[ MASTER <cMasterAlias> ] ;
				[ <header:HEADER> <aHeader,...> ] ;
				[ EXCEPT <aExcept> ] ;
				[ BEFORE <bBeforeModel> ] ;
				[ AFTER <bAfterModel> ] ;
				[ COMMIT <bCommit> ] ;
				[ CANCEL <bCancel> ] ;
				[ BEFOREFIELD <bBeforeField> ] ;
				[ AFTERFIELD <bAfterField> ] ;
				[ LOAD <bFieldLoad> ] ;
					[ DETAIL <cDetailAlias> ] ;
					[ EXCEPTDETAIL <aExcepDet> ] ;
					[ BEFORELINE <bBeforeLine> ] ;
					[ AFTERLINE <bAfterLine> ] ;
					[ BEFOREGRID <bBeforeGrid> ] ;
					[ AFTERGRID <bAfterGrid> ] ;
					[ LOADGRID <bGridLoad> ] ;
					[ RELATION <aRelation,...> ] ;
					[ <orderkey: ORDERKEY, ORDER KEY> <cOrder> ] ;
					[ <uniqueline: UNIQUELINE, UNIQUE LINE> <aUniqueLine,...> ];
					[ <autoincrement: AUTOINCREMENT, AUTO INCREMENT> <cFieldInc>];
					[ <lOptional: OPTIONAL> ];
	=>;
		If Valtype( <nType> ) <> "N" ;;
			CLASSEXCEPTION "TYPE" MESSAGE "type mismatch" ;;
		ElseIf <nType> # 1 .And. <nType> # 2 .And. <nType> # 3 ;;
			CLASSEXCEPTION "TYPE" MESSAGE "invalid option" ;;
		EndIf ;;
		;;
		If ( <nType> > 1 ) ;;
			If ( ValType( <aRelation> ) <> "A" ) ;;
				CLASSEXCEPTION "RELATION" MESSAGE "parameter required in model" ;;
			EndIf ;;
		EndIf ;;
		;;
		<oBrowse> := FWMBrowse():New() ;;
		<oBrowse>:SetAlias( <cMasterAlias> ) ;;
		<oBrowse>:SetMenuDef( <cSource> ) ;;
		If !Empty( <cFilter> ) ;;
			<oBrowse>:SetFilterDefault( <cFilter> ) ;;
		EndIf ;;
		If !Empty( <bSetVldActive> ) ;;
			<oBrowse>:SetVldActive( <{bSetVldActive}> ) ;;
		EndIf ;;
		If ( ValType( <aLegends> ) == "A" ) ;;
			aLegends := IIf( Empty( <aLegends> ), {}, <aLegends> ) ;;
			nAuxLeg := 1;;
			While !( nAuxLeg > Len(aLegends)) ;;
				<oBrowse>:AddLegend( &("aLegends["+Str(nAuxLeg)+",1]"), &("aLegends["+Str(nAuxLeg)+",2]"), &("aLegends["+Str(nAuxLeg)+",3]") );;
				nAuxLeg++ ;;
			End ;;
		EndIf ;;
		<oBrowse>:Activate() ;;
		;;
		Return ;;
		;;
		;;
		Static Function ModelDef() ;;
			;;
			Local nX, oModel, cGridId, bSX3Header, bSX3Detail, cHeader, cDetailAlias, cDetailDescription, cMasterDescription, aExcept, aExcepDet ;;
			;;
			cMasterDescription := "" ;;
			SX2->( dbSetOrder( 1 ) ) ;;
			If SX2->( dbSeek( <cMasterAlias> ) ) ;;
				cMasterDescription := X2Nome() ;;
			EndIf ;;
			;;
			cDetailAlias := "" ;;
			If ( <nType> == 2 ) ;;
				[cDetailAlias := <cMasterAlias>];;
			EndIf ;;
			If  ( <nType> == 3 ) ;;
				[cDetailAlias := <cDetailAlias>] ;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				cDetailDescription := "" ;;
				SX2->( dbSetOrder( 1 ) ) ;;
				If SX2->( dbSeek( cDetailAlias ) ) ;;
					cDetailDescription := X2Nome() ;;
				EndIf ;;
			EndIf ;;
			;;
			cHeader := "" ;;
			If ( <nType> == 2 ) ;;
				aHeader := IIf( Empty( <aHeader> ), {}, <aHeader> ) ;;
				If ( ValType( aHeader ) == "A" ) ;;
					For nX:=1 To Len( aHeader ) ;;
						cHeader += &( "aHeader[" + Str(nX) + "]") +"|" ;;
					Next nX ;;
				EndIf ;;
				If cHeader <> "" ;;
					bSX3Header := {|cCampo|  AllTrim( cCampo )+"|" $ cHeader} ;;
					bSX3Detail := {|cCampo| !AllTrim( cCampo )+"|" $ cHeader} ;;
				Else ;;
					bSX3Header := NIL ;;
					bSX3Detail := NIL ;;
				EndIf ;;
			Else ;;
				bSX3Header := NIL ;;
				bSX3Detail := NIL ;;
			EndIf ;;
			;;
			oMasterStruct := FWFormStruct( 1, <cMasterAlias>, bSX3Header ) ;;
			;;
			If ( ValType( <aExcept>) == "A" ) ;;
				aExcept := IIf( Empty( <aExcept> ), {}, <aExcept> );;
				For nX := 1 To Len( aExcept );;
					oMasterStruct:RemoveField( Eval( &("{|| aExcept["+Str(nX)+"] }") ) );;
				Next;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				oDetailStruct := FWFormStruct( 1, cDetailAlias, bSX3Detail ) ;;
				;;
				If ( ValType( <aExcepDet>) == "A" ) ;;
					aExcepDet := IIf( Empty( <aExcepDet> ), {}, <aExcepDet> );;
					For nX := 1 To Len( aExcepDet );;
						oDetailStruct:RemoveField( Eval( &("{|| aExcepDet["+Str(nX)+"] }") ) );;
					Next;;
				EndIf ;;
				;;
			EndIf ;;
			;;
			oModel := MPFormModel():New( If( ValType( <cModelID> )=="C", <cModelID>, <cSource> ), <{bBeforeModel}>, <{bAfterModel}>, <{bCommit}>, <{bCancel}> ) ;;
			oModel:SetDescription( <cDescription> ) ;;
			;;
			oModel:AddFields( <cSource>+"_"+<cMasterAlias>, NIL, oMasterStruct, <{bBeforeField}>, <{bAfterField}>, <{bFieldLoad}> ) ;;
			oModel:GetModel( <cSource>+"_"+<cMasterAlias> ):SetDescription( cMasterDescription ) ;;
			;;
			If ( <nType> > 1 ) ;;
				;;
			    cGridId := <cSource>+"_"+cDetailAlias ;;
				If ( <nType> == 2 ) ;;
					cGridId := <cSource>+"_GRID" ;;
				EndIf ;;
				;;
				oModel:AddGrid( cGridId, <cSource>+"_"+<cMasterAlias>, oDetailStruct, <{bBeforeLine}>, <{bAfterLine}>, <{bBeforeGrid}>, <{bAfterGrid}>, <{bGridLoad}> ) ;;
				oModel:GetModel( cGridId ):SetDescription( cDetailDescription ) ;;
				If ( ValType( [\{<aUniqueLine>\}] )=="A" ) ;;
					oModel:GetModel( cGridId ):SetUniqueLine( <aUniqueLine> ) ;;
				EndIf ;;
				oModel:GetModel( cGridId ):SetRelation( <aRelation>, If( Empty( <cOrder> ), ( <cMasterAlias> )->( IndexKey( 1 ) ), <cOrder> ) ) ;;
				oModel:GetModel( cGridId ):SetOptional( <.lOptional.> ) ;;
			EndIf ;;
			If ( ValType( [\{<aPrimaryKey>\}] )=="A" ) ;;
				oModel:SetPrimaryKey( <aPrimaryKey> ) ;;
			EndIf ;;
		Return oModel ;;
		;;
		;;
		;;
		;;
		Static Function ViewDef() ;;
			;;
			Local oModel, nX, cGridId, bSX3Header, bSX3Detail, cHeader, cDetailAlias, aExcept, aExcepDet;;
			;;
			oModel := FWLoadModel( <cSource> ) ;;
			;;
			cDetailAlias := "" ;;
			If ( <nType> == 2 ) ;;
				[cDetailAlias := <cMasterAlias>] ;;
			EndIf ;;
			If ( <nType> == 3 ) ;;
				[cDetailAlias := <cDetailAlias>] ;;
			EndIf ;;
			;;
			cHeader := "" ;;
			If ( <nType> > 1 ) ;;
				aHeader := IIf( Empty( <aHeader> ), {}, <aHeader> ) ;;
				If ( ValType( aHeader ) == "A" ) ;;
					For nX:=1 To Len( aHeader ) ;;
						cHeader += &( "aHeader[" + Str(nX) + "]") +"|" ;;
					Next nX ;;
				EndIf ;;
				If cHeader <> "" ;;
					bSX3Header := {|cCampo|  AllTrim( cCampo )+"|" $ cHeader} ;;
					bSX3Detail := {|cCampo| !AllTrim( cCampo )+"|" $ cHeader} ;;
				Else ;;
					bSX3Header := NIL ;;
					bSX3Detail := NIL ;;
				EndIf ;;
			Else ;;
				bSX3Header := NIL ;;
				bSX3Detail := NIL ;;
			EndIf ;;
			;;
			oMasterStruct := FWFormStruct( 2, <cMasterAlias>, bSX3Header ) ;;
			;;
			If ( ValType( <aExcept>) == "A" ) ;;
				aExcept := IIf( Empty( <aExcept> ), {}, <aExcept> );;
				For nX := 1 To Len( aExcept );;
					oMasterStruct:RemoveField( Eval( &("{|| aExcept["+Str(nX)+"] }") ) );;
				Next;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				oDetailStruct := FWFormStruct( 2, cDetailAlias, bSX3Detail ) ;;
				;;
				If ( ValType( <aExcepDet>) == "A" ) ;;
					aExcepDet := IIf( Empty( <aExcepDet> ), {}, <aExcepDet> );;
					For nX := 1 To Len( aExcepDet );;
						oDetailStruct:RemoveField( Eval( &("{|| aExcepDet["+Str(nX)+"] }") ) );;
					Next;;
				EndIf ;;
				;;
			EndIf ;;
			;;
			oView := FWFormView():New() ;;
			oView:SetModel( oModel ) ;;
			oView:AddField( <cSource>+"_"+<cMasterAlias> , oMasterStruct ) ;;
			;;
			If ( <nType> == 1 ) ;;
				oView:CreateHorizontalBox( "BOXFIELD", 100 ) ;;
				oView:SetOwnerView( <cSource>+"_"+<cMasterAlias>, "BOXFIELD" ) ;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				;;
			    cGridId := <cSource>+"_"+cDetailAlias ;;
				If ( <nType> == 2 ) ;;
					cGridId := <cSource>+"_GRID" ;;
				EndIf ;;
				;;
				oView:AddGrid( cGridId, oDetailStruct ) ;;
				If ValType( <cFieldInc> ) == "C" .And. !Empty( <cFieldInc> ) ;;
					oView:AddIncrementField( cGridId, <cFieldInc> ) ;;
				EndIf ;;
				oView:CreateHorizontalBox( "BOXFIELD", 20 ) ;;
				oView:SetOwnerView( <cSource>+"_"+<cMasterAlias>, "BOXFIELD" ) ;;
				oView:CreateHorizontalBox( "BOXGRID" , 80 ) ;;
				oView:SetOwnerView( cGridId, "BOXGRID" ) ;;
			EndIf ;;
			oView:EnableControlBar( .T. ) ;;
		Return oView ;;
		;;
		;;
		;;
		;;
		Static Function MenuDef() ;;
		Return FWMVCMENU( <cSource> )


#xcommand NEW MODEL ;
			TYPE <nType> ;
			DESCRIPTION <cDescription> ;
			BROWSE <oBrowse> ;
			SOURCE <cSource> ;
			MENUDEF <cMenuDef> ;
			[ MODELID <cModelID> ] ;
			[ LEGEND <aLegends,...>];
			[ FILTER <cFilter> ] ;
			[ <canactive:CANACTIVE, CAN ACTIVE> <bSetVldActive> ] ;
			[ <pk:PRIMARYKEY, PRIMARY KEY> <aPrimaryKey,...> ] ;
				[ MASTER <cMasterAlias> ] ;
				[ EXCEPT <aExcept> ] ;
				[ <header:HEADER> <aHeader,...> ] ;
				[ BEFORE <bBeforeModel> ] ;
				[ AFTER <bAfterModel> ] ;
				[ COMMIT <bCommit> ] ;
				[ CANCEL <bCancel> ] ;
				[ BEFOREFIELD <bBeforeField> ] ;
				[ AFTERFIELD <bAfterField> ] ;
				[ LOAD <bFieldLoad> ] ;
					[ DETAIL <cDetailAlias> ] ;
					[ EXCEPTDETAIL <aExcepDet> ] ;
					[ BEFORELINE <bBeforeLine> ] ;
					[ AFTERLINE <bAfterLine> ] ;
					[ BEFOREGRID <bBeforeGrid> ] ;
					[ AFTERGRID <bAfterGrid> ] ;
					[ LOADGRID <bGridLoad> ] ;
					[ RELATION <aRelation,...> ] ;
					[ <orderkey: ORDERKEY, ORDER KEY> <cOrder> ] ;
					[ <uniqueline: UNIQUELINE, UNIQUE LINE> <aUniqueLine,...> ];
					[ <autoincrement: AUTOINCREMENT, AUTO INCREMENT> <cFieldInc>];
					[ <lOptional: OPTIONAL> ];
	=>;
		If Valtype( <nType> ) <> "N" ;;
			CLASSEXCEPTION "TYPE" MESSAGE "type mismatch" ;;
		ElseIf <nType> # 1 .And. <nType> # 2 .And. <nType> # 3 ;;
			CLASSEXCEPTION "TYPE" MESSAGE "invalid option" ;;
		EndIf ;;
		 ;;
		If ( <nType> > 1 ) ;;
			If ( ValType( <aRelation> ) <> "A" ) ;;
				CLASSEXCEPTION "RELATION" MESSAGE "parameter required in model" ;;
			EndIf ;;
		EndIf ;;
		;;
		<oBrowse> := FWMBrowse():New() ;;
		<oBrowse>:SetAlias( <cMasterAlias> ) ;;
		<oBrowse>:SetMenuDef( <cMenuDef> ) ;;
		If !Empty( <cFilter> ) ;;
			<oBrowse>:SetFilterDefault( <cFilter> ) ;;
		EndIf ;;
		If !Empty( <bSetVldActive> ) ;;
			<oBrowse>:SetVldActive( <{bSetVldActive}> ) ;;
		EndIf ;;
		If ( ValType( <aLegends> ) == "A" ) ;;
			aLegends := IIf( Empty( <aLegends> ), {}, <aLegends> ) ;;
			nAuxLeg := 1;;
			While !( nAuxLeg > Len(aLegends)) ;;
				<oBrowse>:AddLegend( &("aLegends["+Str(nAuxLeg)+",1]"), &("aLegends["+Str(nAuxLeg)+",2]"), &("aLegends["+Str(nAuxLeg)+",3]") );;
				nAuxLeg++ ;;
			End ;;
		EndIf ;;
		<oBrowse>:Activate() ;;
		;;
		Return ;;
		;;
		;;
		Static Function ModelDef() ;;
			;;
			Local nX, oModel, cGridId, bSX3Header, bSX3Detail, cHeader, cDetailAlias, cDetailDescription, cMasterDescription, aExcept, aExcepDet ;;
			;;
			cMasterDescription := "" ;;
			SX2->( dbSetOrder( 1 ) ) ;;
			If SX2->( dbSeek( <cMasterAlias> ) ) ;;
				cMasterDescription := X2Nome() ;;
			EndIf ;;
			;;
			cDetailAlias := "" ;;
			If ( <nType> == 2 ) ;;
				[cDetailAlias := <cMasterAlias>];;
			EndIf ;;
			If  ( <nType> == 3 ) ;;
				[cDetailAlias := <cDetailAlias>] ;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				cDetailDescription := "" ;;
				SX2->( dbSetOrder( 1 ) ) ;;
				If SX2->( dbSeek( cDetailAlias ) ) ;;
					cDetailDescription := X2Nome() ;;
				EndIf ;;
			EndIf ;;
			;;
			cHeader := "" ;;
			If ( <nType> == 2 ) ;;
				aHeader := IIf( Empty( <aHeader> ), {}, <aHeader> ) ;;
				If ( ValType( aHeader ) == "A" ) ;;
					For nX:=1 To Len( aHeader ) ;;
						cHeader += &( "aHeader[" + Str(nX) + "]") +"|" ;;
					Next nX ;;
				EndIf ;;
				If cHeader <> "" ;;
					bSX3Header := {|cCampo|  AllTrim( cCampo )+"|" $ cHeader} ;;
					bSX3Detail := {|cCampo| !AllTrim( cCampo )+"|" $ cHeader} ;;
				Else ;;
					bSX3Header := NIL ;;
					bSX3Detail := NIL ;;
				EndIf ;;
			Else ;;
				bSX3Header := NIL ;;
				bSX3Detail := NIL ;;
			EndIf ;;
			;;
			oMasterStruct := FWFormStruct( 1, <cMasterAlias>, bSX3Header ) ;;
			;;
			If ( ValType( <aExcept>) == "A" ) ;;
				aExcept := IIf( Empty( <aExcept> ), {}, <aExcept> );;
				For nX := 1 To Len( aExcept );;
					oMasterStruct:RemoveField( Eval( &("{|| aExcept["+Str(nX)+"] }") ) );;
				Next;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				oDetailStruct := FWFormStruct( 1, cDetailAlias, bSX3Detail ) ;;
				;;
				If ( ValType( <aExcepDet>) == "A" ) ;;
					aExcepDet := IIf( Empty( <aExcepDet> ), {}, <aExcepDet> );;
					For nX := 1 To Len( aExcepDet );;
						oDetailStruct:RemoveField( Eval( &("{|| aExcepDet["+Str(nX)+"] }") ) );;
					Next;;
				EndIf ;;
				;;
			EndIf ;;
			;;
			oModel := MPFormModel():New( If( ValType( <cModelID> )=="C", <cModelID>, <cSource> ), <{bBeforeModel}>, <{bAfterModel}>, <{bCommit}>, <{bCancel}> ) ;;
			oModel:SetDescription( <cDescription> ) ;;
			;;
			oModel:AddFields( <cSource>+"_"+<cMasterAlias>, NIL, oMasterStruct, <{bBeforeField}>, <{bAfterField}>, <{bFieldLoad}> ) ;;
			oModel:GetModel( <cSource>+"_"+<cMasterAlias> ):SetDescription( cMasterDescription ) ;;
			;;
			If ( <nType> > 1 ) ;;
				;;
			    cGridId := <cSource>+"_"+cDetailAlias ;;
				If ( <nType> == 2 ) ;;
					cGridId := <cSource>+"_GRID" ;;
				EndIf ;;
				;;
				oModel:AddGrid( cGridId, <cSource>+"_"+<cMasterAlias>, oDetailStruct, <{bBeforeLine}>, <{bAfterLine}>, <{bBeforeGrid}>, <{bAfterGrid}>, <{bGridLoad}> ) ;;
				oModel:GetModel( cGridId ):SetDescription( cDetailDescription ) ;;
				If ( ValType( [\{<aUniqueLine>\}] )=="A" ) ;;
					oModel:GetModel( cGridId ):SetUniqueLine( <aUniqueLine> ) ;;
				EndIf ;;
				oModel:GetModel( cGridId ):SetRelation( <aRelation>, If( Empty( <cOrder> ), ( <cMasterAlias> )->( IndexKey( 1 ) ), <cOrder> ) ) ;;
				oModel:GetModel( cGridId ):SetOptional( <.lOptional.> ) ;;
			EndIf ;;
			If ( ValType( [\{<aPrimaryKey>\}] )=="A" ) ;;
				oModel:SetPrimaryKey( <aPrimaryKey> ) ;;
			EndIf ;;
		Return oModel ;;
		;;
		;;
		;;
		;;
		Static Function ViewDef() ;;
			;;
			Local oModel, nX, cGridId, bSX3Header, bSX3Detail, cHeader, cDetailAlias, aExcept, aExcepDet ;;
			;;
			oModel := FWLoadModel( <cSource> ) ;;
			;;
			cDetailAlias := "" ;;
			If ( <nType> == 2 ) ;;
				[cDetailAlias := <cMasterAlias>] ;;
			EndIf ;;
			If ( <nType> == 3 ) ;;
				[cDetailAlias := <cDetailAlias>] ;;
			EndIf ;;
			;;
			cHeader := "" ;;
			If ( <nType> > 1 ) ;;
				aHeader := IIf( Empty( <aHeader> ), {}, <aHeader> ) ;;
				If ( ValType( aHeader ) == "A" ) ;;
					For nX:=1 To Len( aHeader ) ;;
						cHeader += &( "aHeader[" + Str(nX) + "]") +"|" ;;
					Next nX ;;
				EndIf ;;
				If cHeader <> "" ;;
					bSX3Header := {|cCampo|  AllTrim( cCampo )+"|" $ cHeader} ;;
					bSX3Detail := {|cCampo| !AllTrim( cCampo )+"|" $ cHeader} ;;
				Else ;;
					bSX3Header := NIL ;;
					bSX3Detail := NIL ;;
				EndIf ;;
			Else ;;
				bSX3Header := NIL ;;
				bSX3Detail := NIL ;;
			EndIf ;;
			;;
			oMasterStruct := FWFormStruct( 2, <cMasterAlias>, bSX3Header ) ;;
			;;
			If ( ValType( <aExcept>) == "A" ) ;;
				aExcept := IIf( Empty( <aExcept> ), {}, <aExcept> );;
				For nX := 1 To Len( aExcept );;
					oMasterStruct:RemoveField( Eval( &("{|| aExcept["+Str(nX)+"] }") ) );;
				Next;;
			EndIf ;;
			;;			;;
			If ( <nType> > 1 ) ;;
				oDetailStruct := FWFormStruct( 2, cDetailAlias, bSX3Detail ) ;;
				;;
				If ( ValType( <aExcepDet>) == "A" ) ;;
					aExcepDet := IIf( Empty( <aExcepDet> ), {}, <aExcepDet> );;
					For nX := 1 To Len( aExcepDet );;
						oDetailStruct:RemoveField( Eval( &("{|| aExcepDet["+Str(nX)+"] }") ) );;
					Next;;
				EndIf ;;
				;;
			EndIf ;;
			;;
			oView := FWFormView():New() ;;
			oView:SetModel( oModel ) ;;
			oView:AddField( <cSource>+"_"+<cMasterAlias> , oMasterStruct ) ;;
			;;
			If ( <nType> == 1 ) ;;
				oView:CreateHorizontalBox( "BOXFIELD", 100 ) ;;
				oView:SetOwnerView( <cSource>+"_"+<cMasterAlias>, "BOXFIELD" ) ;;
			EndIf ;;
			;;
			If ( <nType> > 1 ) ;;
				;;
			    cGridId := <cSource>+"_"+cDetailAlias ;;
				If ( <nType> == 2 ) ;;
					cGridId := <cSource>+"_GRID" ;;
				EndIf ;;
				;;
				oView:AddGrid( cGridId, oDetailStruct ) ;;
				If ValType( <cFieldInc> ) == "C" .And. !Empty( <cFieldInc> ) ;;
					oView:AddIncrementField( cGridId, <cFieldInc> ) ;;
				EndIf ;;
				oView:CreateHorizontalBox( "BOXFIELD", 20 ) ;;
				oView:SetOwnerView( <cSource>+"_"+<cMasterAlias>, "BOXFIELD" ) ;;
				oView:CreateHorizontalBox( "BOXGRID" , 80 ) ;;
				oView:SetOwnerView( cGridId, "BOXGRID" ) ;;
			EndIf ;;
			oView:EnableControlBar( .T. ) ;;
		Return oView ;;

