
/*
	Header : xmlxfun.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _XMLXFUN_CH
#define _XMLXFUN_CH

#DEFINE XERROR_ONLYFIRSTNODE -1
#DEFINE XERROR_SUCCESS        0
#DEFINE XERROR_FILE_NOT_FOUND 1
#DEFINE XERROR_OPEN_ERROR     2
#DEFINE XERROR_INVALID_XML    3

#IFDEF SPANISH              
	#DEFINE STR001 "Éxito"
	#DEFINE STR002 "Error desconocido"
	#DEFINE STR003 "Archivo no encontrado: "
	#DEFINE STR004 "No fue posible abrir el archivo "
	#DEFINE STR005 "Archivo XML invalido: "
#ELSE
	#IFDEF ENGLISH
		#DEFINE STR001 "Success"
		#DEFINE STR002 "Unknown error"
		#DEFINE STR003 "File not found: "
		#DEFINE STR004 "It wasn´t possible to open the file "
		#DEFINE STR005 "Invalid XML file: "
	#ELSE             
		#DEFINE STR001 "Sucesso"
		#DEFINE STR002 "Erro desconhecido"		
		#DEFINE STR003 "Arquivo não encontrado: "	
		#DEFINE STR004 "Não foi possível abrir o arquivo "
		#DEFINE STR005 "Arquivo XML inválido: "		
	#ENDIF
#ENDIF

#xcommand CREATE <oXML> XMLSTRING <cString> [<lOnlyFirst:ONLYFIRSTNODE>] [ SETASARRAY <aArray,...> ] [OPTIONAL <aArray1,...> ];
            =>  ;
            <oXML>:=XMLStr( <cString> ,[ \{<"aArray">\} ] ,[ \{<"aArray1">\} ], [<.lOnlyFirst.>] ) ;

#xcommand CREATE <oXML> XMLFILE <cFile> [<lOnlyFirst:ONLYFIRSTNODE>] [ SETASARRAY <aArray,...> ] [OPTIONAL <aArray1,...> ];
            =>  ;
            <oXML>:=XMLFile( <cFile> ,[ \{<"aArray">\} ] ,[ \{<"aArray1">\} ], [<.lOnlyFirst.>] ) ;

#xcommand SAVE <oXML> XMLSTRING <cString> [<lNewLine:NEWLINE>] =>  ;
            <cString>:=XMLSaveStr( <oXML>, [<.lNewLine.>] ) ;

#xcommand SAVE <oXML> XMLFILE <cFile> [<lNewLine:NEWLINE>] =>  ;
            XMLSaveFil( <oXML>, <cFile>, [<.lNewLine.>] ) ;
            
#xcommand ADDITEM <oWhere> TAG <cTag> ON <oXML> [<lArray:ASARRAY>] [TEXT <cText>] =>  ;
            XMLAddItem( <oWhere>, <cTag>, <oXML>, [<.lArray.>],[<cText>] ) ;
            
#xcommand ADDNODE <oWhere> NODE <cNode> ON <oXML> [ SETASARRAY <aChild,...> ]  =>  ;
            XMLAddNode( <oWhere>, <cNode>, <oXML>, [ \{<"aChild">\} ] ) ;

#xcommand DELETENODE <cNode> ON <oXML> => ;
            XMLDltNode( <cNode>, @<oXML> )

#endif

