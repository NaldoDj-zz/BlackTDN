/*
	Header : msobject.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _OBJECTS_CH
#define _OBJECTS_CH

#define _FuncType_

#xcommand DEFAULT <Desc> [, <DescN> ]      => ;
                  __DFT__( <Desc> ) [ ; __DFT__( <DescN> ) ]

#xtranslate __DFT__( <Var> := <Dft> ) => ;
            if( <Var> == nil, <Var> := <Dft>, )

#xtranslate __DFT__( <Var> = <Dft> )  => ;
            __DFT__( <Var> := <Dft> )

#xtranslate BYNAME <V> [, <VN> ]     => ::<V> := <V> [; ::<VN> := <VN> ]
#xtranslate BYNAME <V> DEFAULT <Val> => ::<V> := BYDEFAULT <V>, <Val>
#xtranslate BYNAME <V> IFNONIL       => ;
                            if <V> != NIL ;;
                                ::<V> := <V> ;;
                            end
#xtranslate BYDEFAULT <V>, <Val>     => if( <V> == NIL, <Val>, <V> )

#xcommand CLASS <ClsNam>   ;
		[ <from: INHERIT FROM, INHERIT, FROM, OF> <SupCls> ];
		=> ;
		_ObjNewClass( <ClsNam> , [<SupCls>] ) 

#xtranslate CREATE CLASS <*ClsHead*> =>  CLASS <ClsHead>

#xcommand _GEN_DATA_ <vt>, <Vrs,...> [ AS <Typ,...> ]   ;
         [ <scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
         [ <dft: DEFAULT, INIT> <uData> ]   ;
         [ USER DATA <uUserData> ] ;
         =>  ;
         _ObjAddMet( nClassH, __SCOPE__ [ <scp> ], [ \{ _AsUppLst_( <Typ> ) \} ] ,;
                    <vt>, [ <uData> ], _AsStrLst_( <Vrs> ) ) ;
         [ ; ObjSetUserData( nClassH, <uUserData>, _AsStrLst_( <Vrs> ) ) ]

#xcommand _GEN_DATA_ <vt>, <Vrs,...> [ AS <Typ,...> ]   ;
         [ <scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
         [ INSTANTIATE <uData,...> ]    ;
         [ USER DATA <uUserData> ] ;
         =>  ;
         _ObjAddMet( nClassH, __SCOPE__ [ <scp> ], [ \{ _AsUppLst_( <Typ> ) \} ] ,;
                    <vt>, [ _ObjInsDat( \{|Self| <uData> \} )], _AsStrLst_( <Vrs> ) ) ;
         [ ; ObjSetUserData( nClassH, <uUserData>, _AsStrLst_( <Vrs> ) ) ]

#xcommand VAR <uVar> [AS <Typ>] ;
				[ <Scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
				[ <Dft: DEFAULT, INIT> <uData> ] ;
				=> _ObjClassData( <uVar>, [<Typ>], [<Scp>], [<uData>] )
#xcommand INSTVAR <uVar> [AS <Typ>] ;
				[ <Scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
				[ <Dft: DEFAULT, INIT> <uData> ] ;
				=> _ObjClassData( <uVar>, [<Typ>], [<Scp>], [<uData>] )
#xcommand DATA <uVar> [AS <Typ>] ;
				[ <Scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
				[ <Dft: DEFAULT, INIT> <uData> ] ;
				=> _ObjClassData( <uVar>, [<Typ>], [<Scp>], [<uData>] )

#xcommand CLASSVAR <uVar> [AS <Typ>] ;
				[ <Scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
				[ <Dft: DEFAULT, INIT> <uData> ] ;
				=> _ObjClassData( <uVar>, [<Typ>], [<Scp>], [<uData>] )
				
#xcommand CLASSDATA <uVar> [AS <Typ>] ;
				[ <Scp: PUBLIC, EXPORT, READONLY, PROTECTED, LOCAL, HIDDEN> ] ;
				[ <Dft: DEFAULT, INIT> <uData> ] ;
				=> _ObjClassData( <uVar>, [<Typ>], [<Scp>], [<uData>] )

#xcommand __METHOD__ <Met> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ] [ <ctor: CONSTRUCTOR> ] => ;
		_ObjClassMethod(_AsName_( <Met> ),_AsParms_([<Met>]), [<scp>])

#xcommand _GEN_METHOD_ <Met> [,<MetN> ] [<*x*>] =>  ;
          __METHOD__  <Met> [,<MetN> ]  [<x>]

#xcommand _GEN_METHOD_ <Met> VIRTUAL [<*x*>] => __METHOD__ <Met>:_VIRTUAL_ [<x>]

#xcommand ERROR HANDLER <cFunc>  => ;
          _ObjAddMet( nClassH, , .f., 5, \{|| _AsName_( <cFunc> )() \} )

#xcommand ERROR HANDLER <cFunc> <code: EXTERN, CFUNC, CMETHOD> => ;
          EXTERNAL _AsName_( <cFunc> ) ;;
          _ObjAddMet( nClassH, , .f., 5, _AsStr_( <cFunc> ) )

#xcommand _GEN_METHOD_ <cFunc> ERROR HANDLER [ <x> ] => ;
          ERROR HANDLER <cFunc> [ <x> ]


#xcommand _GEN_METHOD_ <cMeth> OPERATOR <cOp> => ;
          _ObjAddMet( nClassH, , .f., 6, <(cOp)>, \{|| _AsName_( <cMeth> )() \} )

#xcommand _GEN_METHOD_ <cMeth> ALIAS OF <cMsg> => ;
          _ObjAddMet( nClassH, _AsStr_( <cMeth> ), _AsStr_( <cMsg> ), 7 )

#xcommand  __ST__  <st: METHOD, MESSAGE, VAR, INSTVAR, DATA, CLASSVAR, CLASSDATA > <*x*> ;
                  => <st> <x>
#xcommand EXPORT  <*x*> => __ST__ <x> PUBLIC
#xcommand HIDE    <*x*> => __ST__ <x> HIDDEN
#xcommand PROTECT <*x*> => __ST__ <x> PROTECTED
#xcommand EXPORT:     =>   _DftScope( 0 )
#xcommand PUBLIC:     =>   EXPORT:
#xcommand PROTECTED:  =>   _DftScope( 1 )
#xcommand READONLY:   =>   PROTECTED:
#xcommand LOCAL:      =>   _DftScope( 2 )
#xcommand HIDDEN:     =>   LOCAL:

#xtranslate _MetTrans_( <Met> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _MetTrans_( <Met> = <udf> ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <udf> )() \}

#xtranslate _MetTrans_( <Met>:_VIRTUAL_ ) => ;
            _AsStr_( <Met> ), "_VIRTUAL_"

#xtranslate _MetTrans_( <Met>:_SETGET_ ) => ;
            _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}, ;
            "_" + _AsStr_( <Met> ), \{|| _AsName_( <Met> )() \}

#xtranslate _BlkTrans_( <Met> INLINE <code,...> ) => ;
            #<Met>, \{ | Self | <code> \}

#xtranslate _BlkTrans_( <Met>( [<prm,...>] ) INLINE <code,...> ) => ;
            #<Met>, \{ | Self [, <prm> ] | <code> \}

#xtranslate _BlkTrans_( <Met> BLOCK <code,...> ) => ;
            _AsStr_( <Met> ), <code>

#xtranslate _AsParms_( <itm>( [<prm,...>] ) )    =>  [(<prm>)] 

#xtranslate _AsFunc_( <itm> )                   => <itm>()
#xtranslate _AsFunc_( <itm>( [<prm,...>] ) )    =>  <itm>( [<prm>] )

#xtranslate _AsName_( <itm> )                   => <itm>
#xtranslate _AsName_( <itm>( [<prm,...>] ) )    => <itm>


#xtranslate _AsStr_( <itm> )                    => <(itm)>
#xtranslate _AsStr_( <itm>( [<prm,...>] ) )     => #<itm>
#xtranslate _AsUpp_( <itm> )                    => upper( _AsStr_( <itm> ) )

#xtranslate _AsStrLst_( <Typ> [, <TypN> ] )     => ;
                                    _AsStr_( <Typ> ) [, _AsStr_( <TypN> ) ]
#xtranslate _AsUppLst_( <Typ> [, <TypN> ] )     => ;
                                    _AsUpp_( <Typ> ) [, _AsUpp_( <TypN> ) ]

#xtranslate __SCOPE__                                => NIL
#xtranslate __SCOPE__ <scp: PUBLIC, EXPORT>          => 0
#xtranslate __SCOPE__ <scp: READONLY, PROTECTED>     => 1
#xtranslate __SCOPE__ <scp: LOCAL, HIDDEN>           => 2

#xtranslate :VIRTUAL => :_VIRTUAL_
#xtranslate :SETGET  => :_SETGET_

#xcommand ENDCLASS  =>                                ;
		_ObjEndClass( )  

#xcommand END CLASS  => ENDCLASS

#xtranslate :Parent( <SupCls> ):<*M*> => :<SupCls>:<M>

#xtranslate :Parent:<*M*>             => :_sUPcLS_:<M>

#xtranslate Super:<*M*>               => Self:_sUPcLS_:<M>

#xtranslate :Super  => :Parent

#xtranslate ::      =>    Self:

#xcommand METHOD <Met> [ <scp: PUBLIC, EXPORT, LOCAL, HIDDEN> ][ <ctor: CONSTRUCTOR> ][ VIRTUAL ] => ;
		_ObjClassMethod(_AsName_( <Met> ),_AsParms_([<Met>]), [<scp>])

#xtranslate METHOD <Met> CLASS <clas> [ VIRTUAL ]=> ;
		Function ___<clas>_AsMet_(<Met>)
		
#xtranslate _AsMet_( <itm>( [<prm,...>] ) )  => ____<itm>( [<prm>] )

#endif

