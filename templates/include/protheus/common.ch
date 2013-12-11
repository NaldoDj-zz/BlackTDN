/*
	Header : common.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _COMMON_CH_
#define _COMMON_CH_

#define MAX_STR 65519

#define TRUE  .T.
#define FALSE .F.
#define YES   .T.
#define NO    .F.

#xtranslate ISNIL( <v1> )         => ( <v1> == NIL )
#xtranslate ISARRAY( <v1> )       => ( valtype( <v1> ) == "A" )
#xtranslate ISBLOCK( <v1> )       => ( valtype( <v1> ) == "B" )
#xtranslate ISCHARACTER( <v1> )   => ( valtype( <v1> ) == "C" )
#xtranslate ISDATE( <v1> )        => ( valtype( <v1> ) == "D" )
#xtranslate ISLOGICAL( <v1> )     => ( valtype( <v1> ) == "L" )
#xtranslate ISMEMO( <v1> )        => ( valtype( <v1> ) == "M" )
#xtranslate ISNUMBER( <v1> )      => ( valtype( <v1> ) == "N" )
#xtranslate ISOBJECT( <v1> )      => ( valtype( <v1> ) == "O" )

#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ]                        ;
          =>                                                            ;
          IF <v1> == NIL ; <v1> := <x1> ; END                           ;
          [; IF <vn> == NIL ; <vn> := <xn> ; END ]

#xcommand UPDATE <v1> IF <exp> TO <v2> ;
         =>                           ;
         IF <exp> ; <v1> := <v2> ; END

#endif
