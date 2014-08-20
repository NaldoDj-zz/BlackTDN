/*
	Header : folder.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _FOLDER_CH_
#define _FOLDER_CH_

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> FOLDER [<oFolder>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <dlg: DIALOG, DIALOGS, PAGE, PAGES> <cDlgName1> [,<cDlgNameN>] ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          [<oFolder> := ] TFolder():New( <nRow>, <nCol>,;
             [\{<cPrompt>\}], \{<cDlgName1> [,<cDlgNameN>]\},;
             <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             <.lDesign.>, <nWidth>, <nHeight>, <cMsg> )

//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> TABS [<oTabs>] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
             [ <act: ACTION, EXECUTE> <uAction> ] ;
             [ <lPixel: PIXEL> ] ;
             [ <lDesign: DESIGN> ] ;
             [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
             [ OPTION <nOption> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          [<oTabs> := ] TTabs():New( <nRow>, <nCol>,;
             [\{<cPrompt>\}], [{|nOption|<uAction>}],;
             <oWnd>, <nOption>, <nClrFore>, <nClrBack>, <.lPixel.>,;
             <.lDesign.>, <nWidth>, <nHeight>, <cMsg> )

#endif

