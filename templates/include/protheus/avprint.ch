/*
	Header : colors.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _AVPRINT_CH_
#define _AVPRINT_CH_

#xcommand AVPRINT [ <oPrint> ] ;
             [ <name:TITLE,NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
             [ <name:NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE => AvPageBegin()

#xcommand AVENDPAGE => AvPageEnd()

#xcommand AVNEWPAGE => AvPageEnd() ; AvPageBegin()

#xcommand AVENDPRINT   => AvPrintEnd() ; AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; AvSetPortrait()

#endif

//----------------------------------------------------------------------------//

