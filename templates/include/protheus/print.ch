/*
	Header : print.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _PRINT_CH
#define _PRINT_CH

#xcommand PRINT [ <oPrint> ] ;
             [ <name:TITLE,NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand PRINTER [ <oPrint> ] ;
             [ <name:NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] PrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand PAGE => PageBegin()

#xcommand ENDPAGE => PageEnd()

#xcommand ENDPRINT   => PrintEnd()
#xcommand ENDPRINTER => PrintEnd()

//----------------------------------------------------------------------------//

#endif
