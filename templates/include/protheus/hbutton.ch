#ifndef _HBUTTON_CH
#define _HBUTTON_CH

// HButton
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> HBUTTON [ <ohBtn> PROMPT ] <cCaption> ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ ACTION <uAction> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ FONT <oFont> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <WhenFunc> ] ;
     [ VALID <uValid> ];
    => ;
  [ <ohBtn> := ] thButton():New( <nRow>, <nCol>, <cCaption>, <oWnd>, ;
    <{uAction}>, <nWidth>, <nHeight>, <oFont>, <cMsg>, <{WhenFunc}>, <{uValid}> )

// MultiButton                                                                        
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> MULTIBUTTON [ <ohBtn> TITLE ] <cCaption> ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ RESOURCE <cImageName> ] ;     
     [ FONT <oFont> ] ;
     [ WHEN <WhenFunc> ] ;
    => ;
  [ <ohBtn> := ] tMultiButton():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <cCaption>, <cImageName>, ;
    																 <oFont>, <oWnd>, <{WhenFunc}> )
#xcommand MULTIBUTTON ADD <ohBtn> TITLE <cCaption> ;
     [ SIZE <nWidth> ] ;
     [ ACTION <uAction> ] ;
     [ FONT <oFont> ] ;
     [ WHEN <WhenFunc> ] ;
    => ;
  <ohBtn>:Add( <cCaption>, <{uAction}>, <oFont>, <nWidth>, <{WhenFunc}> )


// ToolBox
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> TOOLBOX [ <oTbx> ];
		 [ SIZE <nWidth>, <nHeight> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ FONT <oFont> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <WhenFunc> ] ;
    => ;
  [ <oTbx> := ] tToolBox():New( <nRow>, <nCol>, <oWnd>, ;
    <nWidth>, <nHeight>, <oFont>, <cMsg>, <{WhenFunc}> )

#xcommand TOOLBOX ADDGROUP <oTbx> TITLE <cCaption> ;
     OBJECT <oObj> ;
     [ ICON <oIcon> ] ;
    => ;
  <oTbx>:addGroup( <oObj>, <cCaption>, <oIcon> )


// TSimpEdit
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> EDITOR [ <oEdit> ];
		 VARREF <cText>;
		 SIZE <nWidth>, <nHeight>;
		 [ TITLE <cTitle> ] ;
		 [ FORMAT <nFormat> ] ;
    => ;
  [ <oEdit> := ] tSimpEdit():New( <nRow>, <nCol>,;
    <nWidth>, <nHeight>, <cTitle>, <cText>, <nFormat> )


// TSlider
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> SLIDER [ <oSld> ];
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <WhenFunc> ] ;
     [ CHANGE <uChange> ];
    => ;
  [ <oSld> := ] tSlider():New( <nRow>, <nCol>, <oWnd>, ;
    <uChange>, <nWidth>, <nHeight>, <cMsg>, <{WhenFunc}> )


// TSpinBox
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> SPINBOX [ <oSpb> ];
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ MESSAGE <cMsg> ] ;
     [ WHEN <WhenFunc> ] ;
     [ CHANGE <uChange> ];
    => ;
  [ <oSpb> := ] tSpinBox():New( <nRow>, <nCol>, <oWnd>, ;
    <uChange>, <nWidth>, <nHeight>, <cMsg>, <{WhenFunc}> )


// TSplitter
//--------------------------------------------------------------------------------
#xcommand @ <nRow>, <nCol> SPLITTER [ <oSpt> ];
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ ORIENTATION <nOrient> ] ;
    => ;
  [ <oSpt> := ] tSplitter():New( <nRow>, <nCol>, <oWnd>, <nWidth>, <nHeight>, <nOrient> )

#endif

