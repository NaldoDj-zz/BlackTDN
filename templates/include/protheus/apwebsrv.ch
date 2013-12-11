/*
	Header : apwebsrv.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _APWEBSRV_CH_
#define _APWEBSRV_CH_

#DEFINE SOAPFAULT_VERSIONMISMATCH		1
#DEFINE SOAPFAULT_MUSTUNDERSTAND			2
#DEFINE SOAPFAULT_DTDNOTSUPPORTED		3
#DEFINE SOAPFAULT_DATAENCODINGUNKNOWN	4
#DEFINE SOAPFAULT_SENDER					5
#DEFINE SOAPFAULT_RECEIVER					6

#xtranslate BYREF <_p_Name> =>	<_p_Name>

#xcommand WSSTRUCT <ClsNam>	;
		=> ;
		_ObjNewClass( <ClsNam> , WSSTRUCT ) 
		
#xcommand ENDWSSTRUCT	=>	;
		_ObjEndClass()  

#xcommand END WSSTRUCT	=>	ENDWSSTRUCT ;

#xcommand WSSERVICE <ClsNam> ;
		=> ;
		_ObjNewClass( <ClsNam> , WSSERVICE )

#xcommand WSSERVICE <ClsNam> DESCRIPTION <ClsDoc> ;
		=> ;
		_ObjNewClass( <ClsNam> , WSSERVICE )	;;
		_ObjClassData( DESCRIPTION_<ClsNam> , string, , <ClsDoc> )

#xcommand WSSERVICE <ClsNam> DESCRIPTION <ClsDoc> NAMESPACE <ClsNameSpace>;
		=> ;
		_ObjNewClass( <ClsNam> , WSSERVICE )	;;
		_ObjClassData( DESCRIPTION_<ClsNam> , string, , <ClsDoc> ) ;; 
		_ObjClassData( DESCRIPTION__NAMESPACE_<ClsNam> , string, , <ClsNameSpace> )

#xcommand WSSERVICE <ClsNam> NAMESPACE <ClsNameSpace>;
		=> ;
		_ObjNewClass( <ClsNam> , WSSERVICE )	;;
		_ObjClassData( DESCRIPTION__NAMESPACE_<ClsNam> , string, , <ClsNameSpace> )

#xcommand ENDWSSERVICE	=>	;
		_ObjEndClass()  

#xcommand END WSSERVICE	=>	ENDWSSERVICE ;

#xcommand WSCLIENT <ClsNam>	;
		=> ;
		_ObjNewClass( <ClsNam> , WSCLIENT ) 
		
#xcommand ENDWSCLIENT	=>	;
		_ObjEndClass()  

#xcommand END WSCLIENT	=>	ENDWSCLIENT ;

#xcommand WSMETHOD <_p_Name> ;
        =>  ;
        _ObjClassMethod( <_p_Name>, _WSParms_(), ) 

#xcommand WSMETHOD <_p_Name> DESCRIPTION <MthDoc> 	;
        =>  ;
        _ObjClassMethod( <_p_Name>, _WSParms_(), ) ;;
		_ObjClassData( DESCRIPTION_<_p_Name> , string, , <MthDoc> )		

#xcommand WSMETHOD <_p_Name> WSVALID <_valid_name_> ;
        =>  ;
        _ObjClassMethod( <_p_Name>, _WSParms_(), <_valid_name_>___<_p_Name> ) 
        
#xtranslate WSMETHOD <_p_Name> [ WSRECEIVE <_p1_Par,...> ] [ WSSEND <_p2_Par> ] WSSERVICE <clas> ;
		=>	;
		Function ___<clas>____<_p_Name>([<_p1_Par>][,<_p2_Par>])
		
#xtranslate WSMETHOD <_p_Name> [ WSRECEIVE <_p1_Par,...> ] WSNOSEND WSSERVICE <clas> ;
		=>	;
		Function ___<clas>____<_p_Name>([<_p1_Par>],WSNOSEND )

#xtranslate WSVALID <_p_Name> WSMETHOD <_p_method> [ WSRECEIVE <_p1_Par,...> ] [ WSSEND <_p2_Par> ] WSSERVICE <clas> ;
		=>	;
        Function ___<clas>_____WSVALID__<_p_Name>___<_p_method>([<_p1_Par>][,<_p2_Par>])

#xtranslate WSMETHOD <_p_Name> WSSERVICE <clas> ;
		=>	;
		Function ___<clas>____<_p_Name>()


#xtranslate WSMETHOD <_p_Name> [ WSSEND <_p1_Par,...> ] [ WSRECEIVE <_p2_Par,...> ] WSCLIENT <clas> ;
		=>	;
		Function ___<clas>____<_p_Name>([<_p1_Par>][,<_p2_Par>])
		
#xtranslate WSMETHOD <_p_Name> WSCLIENT <clas> ;
		=>	;
		Function ___<clas>____<_p_Name>()

#xtranslate _WSParms_( [<prm,...>] )    =>  [(<prm>)] 		

		
#xcommand WSDATA <uVar> [AS <Typ>] ;
        => _ObjClassData( <uVar>, [<Typ>], , )
		
#xcommand WSDATA <uVar> [AS <Typ> OPTIONAL] ;
        => _ObjClassData( <uVar>, [opt_<Typ>], , )

#xcommand WSDATA <uVar> [AS ARRAY OF <Typ>] ;
        => _ObjClassData( <uVar>, [arrayof_<Typ>], , )

#xcommand WSDATA <uVar> [AS ARRAY OF <Typ> OPTIONAL] ;
        => _ObjClassData( <uVar>, [opt_arrayof_<Typ>], , )

#xtranslate BEGIN WSMETHOD => WsMethodBegin() ; BEGIN SEQUENCE

#xtranslate END WSMETHOD => RECOVER ; WsMethodEnd(.T.) ; Return .F. ; END SEQUENCE ; WsMethodEnd(.F.)

#endif
