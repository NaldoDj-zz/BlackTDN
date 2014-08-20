/*
	Header : scrollbox.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _SCROLLBOX_CH
#define _SCROLLBOX_CH

#xcommand @ <nTop>, <nLeft> SCROLLBOX [ <oScrollBox> ] ;
     [ SIZE <nHeight>, <nWidth> ] ;
     [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <lVertical: VERTICAL> ] ;
     [ <lHorizontal: HORIZONTAL> ] ;
     [ <lBorder: BORDER> ] ] ;
    => ;
  [ <oScrollBox> := ] TScrollBox():New( <oWnd>, <nTop>, <nLeft>, <nHeight>, <nWidth>,;
     <.lVertical.>, <.lHorizontal.>, <.lBorder.> )
#endif
