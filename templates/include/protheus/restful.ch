/*/
	Header : RestFul.ch
	Copyright (c) 1997-2003, Microsiga Protheus - TOTVS SA
	All rights reserved.
/*/

#XTRANSLATE _WSParms_( [<prm,...>] )    =>  [(<prm>)] 	

#XCOMMAND WSRESTFUL <ClsNam> DESCRIPTION <ClsDoc> [ SECURITY <cResource> ] [ FORMAT <ClsFormat> ] ;
		=> ;
		_ObjNewClass( REST_<ClsNam> , WSRESTFUL )	;;
		_ObjClassData( DESCRIPTION__ , string, , <ClsDoc> ) ;;
		_ObjClassData( DESCRIPTION_FORMAT , string , , <ClsFormat>) ;;
		_ObjClassData( DESCRIPTION_SECURITY , string , , <cResource> ) ;;
		_ObjClassData( DESCRIPTION_SSL , string, , ".F." )

#XCOMMAND WSRESTFUL <ClsNam> DESCRIPTION <ClsDoc> [ SECURITY <cResource> ] [ FORMAT <ClsFormat> ] SSL ONLY ;
		=> ;
		_ObjNewClass( REST_<ClsNam> , WSRESTFUL )	;;
		_ObjClassData( DESCRIPTION__ , string, , <ClsDoc> ) ;;
		_ObjClassData( DESCRIPTION_FORMAT , string , , <ClsFormat>) ;;
		_ObjClassData( DESCRIPTION_SECURITY , string , , <cResource> ) ;;
		_ObjClassData( DESCRIPTION_SSL , string, , ".T." )

#XCOMMAND ENDWSRESTFUL	=>	;
		_ObjEndClass()  

#XCOMMAND END WSRESTFUL	=>	ENDWSRESTFUL ;


#XCOMMAND WSMETHOD GET DESCRIPTION <MthDoc> WSSYNTAX <MthWSSyntax>	;
        =>  ;
        _ObjClassMethod( GET, _WSParms_(), ) ;;
	_ObjClassData( DESCRIPTION_GET , string, , <MthDoc> ) ;;
	_ObjClassData( DESCRIPTION_SYNTAX_GET, string, , <MthWSSyntax> )

#XCOMMAND WSMETHOD PUT DESCRIPTION <MthDoc> WSSYNTAX <MthWSSyntax>	;
        =>  ;
        _ObjClassMethod( PUT, _WSParms_(), ) ;;
	_ObjClassData( DESCRIPTION_PUT , string, , <MthDoc> ) ;;
	_ObjClassData( DESCRIPTION_SYNTAX_PUT, string, , <MthWSSyntax> )

#XCOMMAND WSMETHOD POST DESCRIPTION <MthDoc> WSSYNTAX <MthWSSyntax>	;
        =>  ;
        _ObjClassMethod( POST, _WSParms_(), ) ;;
	_ObjClassData( DESCRIPTION_POST , string, , <MthDoc> ) ;;
	_ObjClassData( DESCRIPTION_SYNTAX_POST, string, , <MthWSSyntax> )
                                       
#XCOMMAND WSMETHOD DELETE DESCRIPTION <MthDoc> WSSYNTAX <MthWSSyntax>	;
        =>  ;
        _ObjClassMethod( DELETE, _WSParms_(), ) ;;
	_ObjClassData( DESCRIPTION_DELETE , string, , <MthDoc> ) ;;
	_ObjClassData( DESCRIPTION_SYNTAX_DELETE, string, , <MthWSSyntax> )

#XTRANSLATE WSMETHOD GET WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____GET()

#XTRANSLATE WSMETHOD GET WSRECEIVE <_p1_Par,...> WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____GET(<_p1_Par>, WSNOSEND)

#XTRANSLATE WSMETHOD PUT WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____PUT()

#XTRANSLATE WSMETHOD PUT WSRECEIVE <_p1_Par,...> WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____PUT(<_p1_Par>, WSNOSEND)

#XTRANSLATE WSMETHOD POST WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____POST()

#XTRANSLATE WSMETHOD POST WSRECEIVE <_p1_Par,...> WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____POST(<_p1_Par>, WSNOSEND)

#XTRANSLATE WSMETHOD DELETE WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____DELETE()

#XTRANSLATE WSMETHOD DELETE WSRECEIVE <_p1_Par,...> WSSERVICE <clas> ;
		=>	;
		Function ___REST_<clas>____DELETE(<_p1_Par>, WSNOSEND)


#XCOMMAND WSDATA <uVar> [AS <Typ>] ;
        => _ObjClassData( <uVar>, [<Typ>], , )
		
#XCOMMAND WSDATA <uVar> [AS <Typ> OPTIONAL] ;
        => _ObjClassData( <uVar>, [opt_<Typ>], , )

