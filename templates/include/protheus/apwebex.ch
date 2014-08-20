
/*
	Header : apwebex.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _APWEBEX_CH_
#define _APWEBEX_CH_

#XCOMMAND OPEN QUERY <cQuery> ALIAS <cAlias> ;
                  [ <lNOChange: NOCHANGE> ] ;
            =>  APWExOpenQuery(<cQuery>,<cAlias>,<.lNOChange.>)

#XCOMMAND CLOSE QUERY <cAlias> => APWExCloseQuery(<cAlias>)
         
#XCOMMAND WEB EXTENDED INIT <cHtml> ;
                [ START <cFnStart> ] ;
            => If APWExInit( @<cHtml> , <cFnStart> )
            
#XCOMMAND WEB EXTENDED END ;
            => Endif

#endif


