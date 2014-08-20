/*
	Header : jpeg.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _JPEG_CH_
#define _JPEG_CH_

#xcommand @ <nRow>, <nCol> JPEG [ <oJpeg> ] ;
     [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
     [ <file: FILE, FILENAME, DISK> <cJpegFile> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <border:BORDER> ] ;
     [ ON CLICK <uClick> ] ;
     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
     [ <update: UPDATE> ] ;
     [ WHEN <uWhen> ] ;
     [ COLOR <nClrFore> [,<nClrBack>] ] ;
     [ <pixel: PIXEL> ] ;     
     => ;
   [ <oJpeg> := ] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
     <cResName>,<cJpegFile>,.T.,<oWnd>,;
     <{uClick}>,,,,,,,;
     <{uWhen}>,<.pixel.>,,,,.T.)

#endif
