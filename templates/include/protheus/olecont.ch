/*
	Header : olecont.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _OLECONTAINER_CH
#define _OLECONTAINER_CH

#xcommand @ <nRow>, <nCol> OLECONTAINER [ <oOle> ];
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <dlg: OF,WINDOW,DIALOG > <oWnd> ] ;
     [ <lAutoActivate: AUTOACTIVATE > ] ;
     [ FILENAME <cFileName> ] ;
    => ;
   [ <oOle> := ] TOleContainer():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     [<oWnd>], [<.lAutoActivate.>], [<cFileName>] )

#endif
