/*/
	Header : RestFul.ch
	Copyright (c) 1997-2003, Microsiga Protheus - TOTVS SA
	All rights reserved.
/*/

#DEFINE QSROWS "12"

#XTRANSLATE _WSParms_( [<prm,...>] )    =>  [(<prm>)] 	

#XCOMMAND QSSTRUCT <ClsNam> DESCRIPTION <ClsDoc> MODULE <ClsMod> ;
		=> ;
		Function _<ClsNam>() ; Return ;;
		_ObjNewClass( QS_<ClsNam> , FWQSSTRUCT )	;;
		_ObjClassData( DESCRIPTION__ , string, , <ClsDoc> ) ;; 
		_ObjClassData( DESCRIPTION_MODULE , string, , \"<ClsMod>\" ) ;; 
		_ObjClassMethod( INIT, _WSParms_(), ) ;;
		_ObjEndClass()

#XTRANSLATE QSMETHOD INIT QSSTRUCT <clas> ;
		=>	;
		Function ___QS_<clas>____INIT()

#XTRANSLATE QSTABLE <table1> [ ALIAS <cAlias1> ] [ [ <left: LEFT> ] [ <right: RIGHT> ] JOIN <table2> [ ALIAS <cAlias2> ] [ ON <join> ] ] ;
		=> ;
		self:AddTable(<table1>,[<table2>],[<join>],<.left.>,<.right.>,[<cAlias1>],[<cAlias2>])

#XTRANSLATE QSPARENTFIELD <field1,...> INDEX ORDER <order> [ LABEL <label> ] ;
		[ <fields2:SET RELATION TO> <field2,...> [ <fields3:WITH> <field3,...> ] ] ;
		=> ;
		self:AddParentField(\{<field1>\},<order>,[<label>],[\{<field2>\}],[\{<field3>\}])

#XTRANSLATE QSFIELD <field>;
		=> ;
		self:AddGridField(<field>,NIL, NIL, .F.) ;

#XTRANSLATE QSFIELD <field> LABEL <label>;
		=> ;
		self:AddGridField(<field>,<label>, NIL, .F.) ;

#XTRANSLATE QSFIELD <field1> [ LABEL <label1> ] , <fieldN> [ LABEL <labelN> ]  ;
		=> ;
		QSFIELD <field1> [ LABEL <label1> ] ;;
		QSFIELD <fieldN> [ LABEL <labelN> ]

#XTRANSLATE QSFIELD <field1> [ LABEL <label1> ] ORDER BY [, <fieldN> [ LABEL <labelN> ] ORDER BY ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, NIL, .T.) ;
		[; self:AddGridField(<fieldN>,<labelN>, NIL, .T.) ]

#XTRANSLATE QSFIELD SUM <field1> [ LABEL <label1> ] [, <fieldN> [ LABEL <labelN> ] ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "SUM", .F.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "SUM", .F.) ]

#XTRANSLATE QSFIELD SUM <field1> [ LABEL <label1> ] ORDER BY [, <fieldN> [ LABEL <labelN> ] ORDER BY ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "SUM", .T.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "SUM", .T.) ]

#XTRANSLATE QSFIELD COUNT <field1> [ LABEL <label1> ] [, <fieldN> [ LABEL <labelN> ] ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "COUNT", .F.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "COUNT", .F.) ]

#XTRANSLATE QSFIELD COUNT <field1> [ LABEL <label1> ] ORDER BY [, <fieldN> [ LABEL <labelN> ] ORDER BY ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "COUNT", .T.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "COUNT", .T.) ]

#XTRANSLATE QSFIELD AVG <field1> [ LABEL <label1> ] [, <fieldN> [ LABEL <labelN> ] ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "AVG", .F.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "AVG", .F.) ]

#XTRANSLATE QSFIELD AVG <field1> [ LABEL <label1> ] ORDER BY [, <fieldN> [ LABEL <labelN> ] ORDER BY ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "AVG", .T.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "AVG", .T.) ]

#XTRANSLATE QSFIELD MIN <field1> [ LABEL <label1> ] [, <fieldN> [ LABEL <labelN> ] ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "MIN", .F.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "MIN", .F.) ]

#XTRANSLATE QSFIELD MAX <field1> [ LABEL <label1> ] ORDER BY [, <fieldN> [ LABEL <labelN> ] ORDER BY ] ;
		=> ;
		self:AddGridField(<field1>,<label1>, "MAX", .T.) ;
		[; self:AddGridField(<fieldN>,<labelN>, "MAX", .T.) ]

#XTRANSLATE QSFIELD <field1> EXPRESSION <expr> LABEL <label1> FIELDS <fields,...> [ <groupBy: GROUP BY> ] TYPE <type> SIZE <size> [ DECIMAL <decimal>] [PICTURE <picture>] ;
		=> ;
		self:AddExpField(<field1>,<label1>, <expr>, \{<fields>\}, <.groupBy.>, [<type>], [<size>], [<decimal>], [<picture>])

#XTRANSLATE QSFIELD <field1> BLOCK <block> LABEL <label1> TYPE <type> SIZE <size> [ DECIMAL <decimal>] [PICTURE <picture>] ;
		=> ;
		self:AddBlockField(<field1>,<label1>, <block>, [<type>], [<size>], [<decimal>], [<picture>])
		
#XTRANSLATE QSACTION <action> LABEL <label> ;
		=> ;
		self:AddAction(<action>,<label>)

#XTRANSLATE QSACTION MENUDEF <action> OPERATION <operation> LABEL <label> ;
		=> ;
		self:AddAction(<action>,<label>,.T.,.F.,<operation>)

#XTRANSLATE QSACTION VIEWDEF <action> LABEL <label> ;
		=> ;
		self:AddAction(<action>,<label>,.F.,.T.)

#XTRANSLATE QSACTION URL <action> LABEL <label> ;
		=> ;
		self:AddAction(<action>,<label>,.F.,.F.,,.T.)
		
#XTRANSLATE QSFILTER <label> [ WHERE <filter> ] [ HAVING <having> ] ;
		=> ;
		self:AddFilter(<label>,[<filter>],[<having>])
