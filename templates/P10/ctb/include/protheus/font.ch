/*
	Header : font.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _FONT_CH_
#define _FONT_CH_

#define LF_HEIGHT          1
#define LF_WIDTH           2
#define LF_ESCAPEMENT      3
#define LF_ORIENTATION     4
#define LF_WEIGHT          5
#define LF_ITALIC          6
#define LF_UNDERLINE       7
#define LF_STRIKEOUT       8
#define LF_CHARSET         9
#define LF_OUTPRECISION   10
#define LF_CLIPPRECISION  11
#define LF_QUALITY        12
#define LF_PITCHANDFAMILY 13
#define LF_FACENAME       14

//----------------------------------------------------------------------------//

#xcommand DEFINE FONT <oFont> ;
             [ NAME <cName> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <from:FROM USER> ] ;
             [ <bold: BOLD> ] ;
             [ <italic: ITALIC> ] ;
             [ <underline: UNDERLINE> ] ;
             [ WEIGHT <nWeight> ] ;
             [ OF <oDevice> ] ;
             [ NESCAPEMENT <nEscapement> ] ;
       => ;
          <oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, <.from.>,;
                     [<.bold.>],<nEscapement>,,<nWeight>, [<.italic.>],;
                     [<.underline.>],,,,,, [<oDevice>] )

#xcommand ACTIVATE   FONT <oFont> => <oFont>:Activate()

#xcommand DEACTIVATE FONT <oFont> => <oFont>:DeActivate()

#xcommand SET FONT ;
             [ OF <oWnd> ] ;
             [ TO <oFont> ] ;
       => ;
          <oWnd>:SetFont( <oFont> )

//----------------------------------------------------------------------------//

#endif
