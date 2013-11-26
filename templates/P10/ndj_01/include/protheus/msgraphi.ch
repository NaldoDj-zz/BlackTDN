/*
	Header : msgraphi.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _MSGRAPHI_CH_
#define _MSGRAPHI_CH_

// Constantes com os tipos de gráfico
#define GRP_LINE      1
#define GRP_AREA      2
#define GRP_POINT     3
#define GRP_BAR       4
#define GRP_PYRAMID   5
#define GRP_CILINDER  6
#define GRP_HBAR      7
#define GRP_HPYRAMID  8
#define GRP_HCILINDER 9
#define GRP_PIE       10
#define GRP_SHAPES    11
#define GRP_FASTLINE  12
#define GRP_ARROWS    13
#define GRP_GANTT     14
#define GRP_BUBBLE    15
#define GRP_CREATE_ERR -1

// Constantes com a direção de um gradiente
#define GDTOPBOTTOM 1
#define GDBOTTOMTOP 2
#define GDLEFTRIGHT 3
#define GDRIGHTLEFT 4

// Constantes para alinhamento
#define A_LEFTJUST 1
#define A_RIGHTJUS 2
#define A_CENTER   3

#define GRP_FOOT  .T.
#define GRP_TITLE .F.

#define GRP_SCRTOP    1
#define GRP_SCRLEFT   2
#define GRP_SCRBOTTOM 3
#define GRP_SCRRIGHT  4

#define GRP_AUTO   1
#define GRP_SERIES 2
#define GRP_VALUES 3
#define GRPLASTVAL 4

#xcommand @ <nRow>, <nCol> MSGRAPHIC [<oMSGraphic>] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ FONT <oFont> ] ;
	  [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
    => ;
  [ <oMSGraphic> := ] TMSGraphic():New( <nRow>, <nCol>, <oWnd> , <oFont>, <nClrFore>,;
  													 [<nClrBack>] ,<nWidth>, <nHeight> )
#endif