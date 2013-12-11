/*
	Header : sigawin.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _SIGAWIN_CH
#define _SIGAWIN_CH

#xCommand Debug <Flds,...> => MsgDbg(\{ <Flds> \})

#xcommand @ <nRow>, <nCol> BTNAUTFMT [ <oBtnAutFmt> PROMPT ] <cCaption> ;
     [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
     [ ACTION <bAction> ] ;
     [ SIZE <nWidth>, <nHeight> ] ;
     [ <help:HELP, HELPID, HELP ID> <nHelpId> ] ;
     [ FONT <oFont> ] ;
     [ HINT <cToolTip> ];
     [ WHEN <bWhen> ] ;
     [ VALID <bValid> ] ;
     [ <lCancel: CANCEL> ] ;
     [ SRVFILE <cBmpSrvPath> ] ;
     [ REPOSIT <cBmpOnReposit> ] ;
    => ;
  [ <oBtnAutFmt> := ] tBtnAutFmt():New( <nRow>, <nCol>, <cCaption>, <oWnd>,;
    <{bAction}>, <nWidth>, <nHeight>, <nHelpId>, <oFont>, <cToolTip>,;
    <{bWhen}>, <{bValid}>, <.lCancel.>, <cBmpSrvPath>, <cBmpOnReposit> )

#XCOMMAND @ <nRow>, <nCol> PSAY <cText> [FONT <oFont> ][ PICTURE <cPict> ] => PrintOut(<nRow>,<nCol>,<cText>,<cPict>,<oFont>)

#XCOMMAND User Function <cNome> => Function U_<cNome>
#XCOMMAND Project Function <cNome> => Function P_<cNome>
#XCOMMAND Web Function <cNome> => Function W_<cNome>
#XCOMMAND HTML Function <cNome> => Function H_<cNome>
#XCOMMAND USERHTML Function <cNome> => Function L_<cNome>
#XCOMMAND Template Function <cNome> => Function T_<cNome>

#xcommand STACKVAR <uVar1> [, <uVarN> ] => ;
                  _STKVARDEF(<uVar1>) ;;
                [ _STKVARDEF(<uVarN>); ]

#Translate PROW( => _PROW(
#Translate PCOL( => _PCOL(
#TransLate DEVPOS( => _DEVPOS(


#xcommand @ <nRow>, <nCol> BUTTON [<oBtn>] RESOURCE [ <cResName1> [,<cResName2>] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ ACTION <uAction,...> ] ;
				 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ UPDATE <lUpdate> ] ;
				 [ <pixel: PIXEL> ] ;
		=> ;
			[ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				<cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
				[{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
				<lUpdate> )

#xcommand DEFINE MSDIALOG <oDlg> ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ TITLE <cTitle> ] ;
				 [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
				 [ <lib: LIBRARY, DLL> <hResources> ] ;
				 [ <vbx: VBX> ] ;
				 [ STYLE <nStyle> ] ;
				 [ <color: COLOR, COLORS> <nClrText> [,<nClrBack> ] ] ;
				 [ BRUSH <oBrush> ] ;
				 [ <of: WINDOW, DIALOG, OF> <oWnd> ] ;
				 [ <pixel: PIXEL> ] ;
				 [ ICON <oIco> ] ;
				 [ FONT <oFont> ] ;
				 [ <status: STATUS> ] ;
		 => ;
			 <oDlg> = MsDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
					  <cTitle>, <cResName>, <hResources>, <.vbx.>, <nStyle>,;
					  <nClrText>, <nClrBack>, <oBrush>, <oWnd>, <.pixel.>,;
					  <oIco>, <oFont> , <.status.> )

#xcommand ACTIVATE MSDIALOG <oDlg> ;
				 [ <center: CENTER, CENTERED> ] ;
				 [ <NonModal: NOWAIT, NOMODAL> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ ON [ LEFT ] CLICK <uClick> ] ;
				 [ ON INIT <uInit> ] ;
				 [ ON MOVE <uMoved> ] ;
				 [ ON PAINT <uPaint> ] ;
				 [ ON RIGHT CLICK <uRClicked> ] ;
		  => ;
			 <oDlg>:Activate( <oDlg>:bLClicked [ := <{uClick}> ], ;
									<oDlg>:bMoved	  [ := <{uMoved}> ], ;
									<oDlg>:bPainted  [ := <{uPaint}> ], ;
									[<.center.>], [{|Self|<uValid>}],;
									[ ! <.NonModal.> ], [{|Self|<uInit>}],;
									<oDlg>:bRClicked [ := <{uRClicked}> ],;
									[{|Self|<uWhen>}] )

#xcommand ACTIVATE MSDIALOG <oDlg> ;
				 [ <nocenter: NOCENTER, NOCENTERED> ] ;
				 [ <NonModal: NOWAIT, NOMODAL> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ ON [ LEFT ] CLICK <uClick> ] ;
				 [ ON INIT <uInit> ] ;
				 [ ON MOVE <uMoved> ] ;
				 [ ON PAINT <uPaint> ] ;
				 [ ON RIGHT CLICK <uRClicked> ] ;
		  => ;
			 <oDlg>:Activate( <oDlg>:bLClicked [ := <{uClick}> ], ;
									<oDlg>:bMoved	  [ := <{uMoved}> ], ;
									<oDlg>:bPainted  [ := <{uPaint}> ], ;
									[! <.nocenter.>], [{|Self|<uValid>}],;
									[ ! <.NonModal.> ], [{|Self|<uInit>}],;
									<oDlg>:bRClicked [ := <{uRClicked}> ],;
									[{|Self|<uWhen>}] )

//----------------------------------------------------------------------------//
#command @ <nRow>, <nCol> MSGETS [ <oGet> VAR ] <uVar> ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ PICTURE <cPict> ] ;
				[ VALID <ValidFunc> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ]	;
				[ FONT <oFont> ] ;
				[ <design: DESIGN> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ ON CHANGE <uChange> ] ;
				 [ <readonly: READONLY, NO MODIFY> ] ;
		 => ;
			 [ <oGet> := ] MsGets():New( <nRow>, <nCol>, bSETGET(<uVar>),;
				 [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
				 <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
				 <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.lCenter.>, <.lRight.>,;
				 [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.> ,<(uVar)>)

#command @ <nRow>, <nCol> MSGET [ <oGet> VAR ] <uVar> ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ PICTURE <cPict> ] ;
				[ VALID <ValidFunc> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ]	;
				[ FONT <oFont> ] ;
				[ <design: DESIGN> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ ON CHANGE <uChange> ] ;
				[ <readonly: READONLY, NO MODIFY> ] ;
				[ <pass: PASSWORD> ] ;
				[ F3 <cAlias> ];
				[ <lNoBorder: NO BORDER, NOBORDER> ] ;
				[ <help:HELPID, HELP ID> <nHelpId> ] ;
				[ <lHasButton: HASBUTTON> ] ;
		 => ;
			 [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
				 [<oWnd>], <nWidth>, <nHeight>, <cPict>, <{ValidFunc}>,;
				 <nClrFore>, <nClrBack>, <oFont>, <.design.>,;
				 <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.lCenter.>, <.lRight.>,;
				 [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
				 <.pass.> ,<cAlias>,<(uVar)>,,[<.lNoBorder.>], [<nHelpId>], [<.lHasButton.>] )

#xcommand REDEFINE MSGET [ <oGet> VAR ] <uVar> ;
				 [ ID <nId> ] ;
				 [ <dlg: OF, WINDOW, DIALOG> <oDlg> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ VALID   <ValidFunc> ]		 ;
				 [ PICTURE <cPict> ] ;
				 [ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				 [ FONT <oFont> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ <readonly: READONLY, NO MODIFY> ] ;
				 [ F3 <cF3> ] ;
		 => ;
			 [ <oGet> := ] TGet():ReDefine( <nId>, bSETGET(<uVar>), <oDlg>,;
				 <nHelpId>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>,;
				 <oFont>, <oCursor>, <cMsg>, <.update.>, <{uWhen}>,;
				 [ \{|nKey,nFlags,Self| <uChange> \}], <.readonly.> ,<cF3>,<(uVar)>)


#xcommand REDEFINE LISTBOX [ <oLbx> ] FIELDS [<Flds,...>] ;
				 [ ALIAS <cAlias> ] ;
				 [ ID <nId> ] ;
				 [ <dlg:OF,DIALOG> <oDlg> ] ;
				 [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
				 [ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
				 [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ ON [ LEFT ] CLICK <uLClick> ] ;
				 [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
				 [ ON RIGHT CLICK <uRClick> ] ;
				 [ FONT <oFont> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <hScroll: NOSCROLL> ];
		 => ;
				  [ <oLbx> := ] TWBrowse():ReDefine( <nId>, ;
				  [\{|| \{ <Flds> \} \}], <oDlg>,;
				  [ \{<aHeaders>\}], [\{<aColSizes>\}],;
				  <(cField)>, <uValue1>, <uValue2>,;
				  [<{uChange}>],;
				  [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
				  [<{uRClick}>], <oFont>,;
				  <oCursor>, <nClrFore>, <nClrBack>, <cMsg>, <.update.>,;
				  <cAlias>, <{uWhen}>, <{uValid}>, <{uLClick}>, !<.hScroll.> )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oBrw> ] FIELDS [<Flds,...>] ;
					[ ALIAS <cAlias> ] ;
					[ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
					[ <head:HEAD,HEADER,HEADERS,TITLE> <aHeaders,...> ] ;
					[ SIZE <nWidth>, <nHeigth> ] ;
					[ <dlg:OF,DIALOG> <oDlg> ] ;
					[ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
					[ ON CHANGE <uChange> ] ;
					[ ON [ LEFT ] CLICK <uLClick> ] ;
					[ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
					[ ON RIGHT CLICK <uRClick> ] ;
					[ FONT <oFont> ] ;
					[ CURSOR <oCursor> ] ;
					[ <color: COLOR, COLORS> <nClrFore> [,<nClrBack>] ] ;
					[ MESSAGE <cMsg> ] ;
					[ <update: UPDATE> ] ;
					[ <pixel: PIXEL> ] ;
					[ WHEN <uWhen> ] ;
					[ <design: DESIGN> ] ;
					[ VALID <uValid> ] ;
					[ <hScroll: NOSCROLL> ];
		=> ;
			 [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
									[\{|| \{<Flds> \} \}], ;
									[\{<aHeaders>\}], [\{<aColSizes>\}], ;
									<oDlg>, <(cField)>, <uValue1>, <uValue2>,;
									[<{uChange}>],;
									[\{|nRow,nCol,nFlags|<uLDblClick>\}],;
									[\{|nRow,nCol,nFlags|<uRClick>\}],;
									<oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
									<.update.>, <cAlias>, <.pixel.>, <{uWhen}>,;
									<.design.>, <{uValid}>, !<.hScroll.>,!<.hScroll.> )


#xcommand @ <nRow>, <nCol> REPOSITORY [ <oBmp> ] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <NoBorder:NOBORDER, NO BORDER> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <lClick: ON CLICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ <scroll: SCROLL> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <pixel: PIXEL>   ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <lDesign: DESIGN> ] ;
				 [ <filename: FROM FILE> <cFileName> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				 <cResName>, <.NoBorder.>, <oWnd>,;
				 [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
				 [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], <.scroll.>,;
				 <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.>, <cFileName> )

#xcommand REDEFINE REPOSITORY [ <oBmp> ] ;
				 [ ID <nId> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ <scroll: SCROLL> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():ReDefine( <nId>, <cResName>,;
				 <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
							[\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
				 <.scroll.>, <.adjust.>, <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <{uValid}> )

#xcommand DEFINE REPOSITORY [<oBmp>] ;
				 [ <resource: ENTRY, RESOURCE> <cResName> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
		 => ;
			 [ <oBmp> := ] TBmpRep():Define( <cResName>, <oWnd> )

#xcommand DEFINE TOOLBAR [ <oBar> ] ;
				 [ <size: SIZE, BUTTONSIZE, SIZEBUTTON > <nWidth>, <nHeight> ] ;
				 [ <_3d: 3D, 3DLOOK> ] ;
				 [ <mode: TOP, LEFT, RIGHT, BOTTOM, FLOAT> ] ;
				 [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
				 [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
		=> ;
			[ <oBar> := ] TToolBar():New( <oWnd>, <nWidth>, <nHeight>, <._3d.>,;
				 [ Upper(<(mode)>) ], <oCursor> , <cBmpFile>, <cBmpRes>)

#xcommand DEFINE IEBUTTON [ <oBtn> ] ;
				 [ <bar: OF, BUTTONBAR > <oBar> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName1> ;
					 [,<cResName2>[,<cResName3>] ] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> ;
					 [,<cBmpFile2>[,<cBmpFile3>] ] ] ;
				 [ <action:ACTION,EXEC> <uAction,...> ] ;
				 [ <group: GROUP > ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ <adjust: ADJUST > ] ;
				 [ WHEN <WhenFunc> ] ;
				 [ TOOLTIP <cToolTip> ] ;
				 [ <lPressed: PRESSED> ] ;
				 [ ON DROP <bDrop> ] ;
				 [ AT <nPos> ] ;
				 [ PROMPT <cPrompt> ] ;
				 [ FONT <oFont> ] ;
				 [ <lNoBorder: NOBORDER> ] ;
		=> ;
			[ <oBtn> := ] TIeButton():NewBar( <cResName1>, <cResName2>,;
				<cBmpFile1>, <cBmpFile2>, <cMsg>, [{|This|<uAction>}],;
				<.group.>, <oBar>, <.adjust.>, <{WhenFunc}>,;
				<cToolTip>, <.lPressed.>, [\{||<bDrop>\}], [\"<uAction>\"], <nPos>,;
				<cPrompt>, <oFont>, [<cResName3>], [<cBmpFile3>], [!<.lNoBorder.>] )
#xcommand @ <nRow>, <nCol> ANIMATION [ <oBmp> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
				 [ <NoBorder:NOBORDER, NO BORDER> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <lClick: ON CLICK,  ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RCLICK, ON RIGHT CLICK> <uRClick> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ <pixel: PIXEL>   ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ <lDesign: DESIGN> ] ;
				 [ FRAMES <nFrames>	];
				 [ INTERVAL <nInterval> ];
				 [ STOPFRAME <nStop> ];
				 [ <lup: UPDOWN> ];
		 => ;
			 [ <oBmp> := ] TAnimation():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				 <cResName>, <cBmpFile>, <.NoBorder.>, <oWnd>,;
				 [\{ |nRow,nCol,nKeyFlags| <uLClick> \} ],;
				 [\{ |nRow,nCol,nKeyFlags| <uRClick> \} ], ;
				 <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <.pixel.>, <{uValid}>, <.lDesign.>, <nFrames>, <nInterval>,<nStop>,<.lup.>)

#xcommand REDEFINE ANIMATION [ <oBmp> ] ;
				 [ ID <nId> ] ;
				 [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
				 [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
				 [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
				 [ CURSOR <oCursor> ] ;
				 [ MESSAGE <cMsg>   ] ;
				 [ <update: UPDATE> ] ;
				 [ WHEN <uWhen> ] ;
				 [ VALID <uValid> ] ;
				 [ FRAMES <nFrames>	];
				 [ INTERVAL <nInterval> ];
				 [ STOPFRAME <nStop> ];
				 [ <lup: UPDOWN> ];
		 => ;
			 [ <oBmp> := ] TAnimation():ReDefine( <nId>, <cResName>, <cBmpFile>,;
				 <oWnd>, [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
							[\{ |nRow,nCol,nKeyFlags| <uRClick> \}],;
				 <oCursor>, <cMsg>, <.update.>,;
				 <{uWhen}>, <{uValid}> , <nFrames>, <nInterval>, <nStop>, <.lup.> )

#xcommand @ <nRow>, <nCol> MSCOMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <pixel: PIXEL> ] ;
				 [ FONT <oFont> ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <design: DESIGN> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, bSETGET(<cVar>),;
				 <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
				 [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
				 <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
				 <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}], ,<(cVar)> )

#xcommand REDEFINE MSCOMBOBOX [ <oCbx> VAR ] <cVar> ;
				 [ <items: ITEMS, PROMPTS> <aItems> ] ;
				 [ ID <nId> ] ;
				 [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
				 [ <help:HELPID, HELP ID> <nHelpId> ] ;
				 [ ON CHANGE <uChange> ] ;
				 [ VALID   <uValid> ] ;
				 [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
				 [ <update: UPDATE> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ BITMAPS <acBitmaps> ] ;
				 [ ON DRAWITEM <uBmpSelect> ] ;
				 [ STYLE <nStyle> ] ;
				 [ PICTURE <cPicture> ];
				 [ ON EDIT CHANGE <uEChange> ] ;
		 => ;
			 [ <oCbx> := ] TComboBox():ReDefine( <nId>, bSETGET(<cVar>),;
				 <aItems>, <oWnd>, <nHelpId>, <{uValid}>, [{|Self|<uChange>}],;
				 <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
				 <acBitmaps>, [{|nItem|<uBmpSelect>}], <nStyle>, <cPicture>,;
				 [<{uEChange}>], ,<(cVar)> )


#xcommand @ <nRow>, <nCol> SHORTCUT [ <oShort> ] ;
			[ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
			[ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
			[ SIZE <nWidth>, <nHeight> ] ;
			[ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
			[ MESSAGE <cMsg>	 ] ;
			[ PROMPT <cPrompt> ];
			[ FONT <oFont> ];
			[ <pixel: PIXEL>	 ] ;
			[ <action:ACTION,EXEC> <uAction,...> ] ;
		 => ;
		[ <oShort> := ] TShortCut():New( <nRow>, <nCol>, <nWidth>, <nHeight>, <cResName>, <cBmpFile>, <oWnd>, <cMsg>, <cPrompt>, <oFont>, <.pixel.>, [{|This| <uAction>}] )

#xcommand DEFINE SHORTCUTLIST <oShortList> MENU <cMenu> <of: OF, WINDOW, DIALOG> <oWnd>;
		=>;
		<oShortList> := TShortList():New(<oWnd>,<cMenu>)


#xcommand @ <nRow>, <nCol> BUTTON [<oBtn>] RESOURCE [ <cResName1> [,<cResName2>] ] ;
				 [ <file: FILE, FILENAME, DISK> <cBmpFile1> [,<cBmpFile2>] ] ;
				 [ SIZE <nWidth>, <nHeight> ] ;
				 [ ACTION <uAction,...> ] ;
				 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
				 [ MESSAGE <cMsg> ] ;
				 [ WHEN <uWhen> ] ;
				 [ <adjust: ADJUST> ] ;
				 [ UPDATE <lUpdate> ] ;
				 [ <pixel: PIXEL> ] ;
		=> ;
			[ <oBtn> := ] TBtnBmp():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
				<cResName1>, <cResName2>, <cBmpFile1>, <cBmpFile2>,;
				[{|Self|<uAction>}], <oWnd>, <cMsg>, <{uWhen}>, <.adjust.>,;
				<lUpdate> )

#xcommand DEFINE SBUTTON [ <oBtn> ] ;
				 [ FROM <nTop>,<nLeft> ] ;
				 [ TYPE <nType> ] ;
				 [ <action:ACTION,EXEC> <uAction> ] ;
				 [ OF <oWnd> ] ;
				 [ <mode: ENABLE > ] ;
				 [ ONSTOP <cMsg> ] ;
				 [ WHEN	 <uWhen>] ;
		=> ;
			[ <oBtn> := ] SButton():New( <nTop>, <nLeft>,<nType>, <{ uAction }>,;
													  <oWnd>, <.mode.>, <cMsg>,<{ uWhen}>)

#xcommand REDEFINE SBUTTON [<oBtn>] ;
				 [ ID <nId> ] ;
				 [ TYPE <nType> ] ;
				 [ <action:ACTION,EXEC> <uAction> ] ;
				 [ OF <oWnd> ] ;
				 [ <mode: ENABLE > ] ;
				 [ ONSTOP <cMsg> ] ;
		=> ;
			[ <oBtn> := ] SButton():ReDefine( <nId>, <nType>, <cMsg>, <{uAction}>,;
													  <oWnd>, <.mode.> )

#ifndef SIGA

#define Comprimido	CHR(15)
#define Expandido 	CHR(18)
#define Topo			1
#define Rodape 		2
#define Corpo			3
#define A_Enter		8
#define A_Esc			9
#define A_Ajuda		10
#define A_Ferram		11
#define Yes 	  .T.
#define No		  .F.
#define MsBotao		Val(SubStr(MouseRet,1,1))
#define MsArea 		Val(SubStr(MouseRet,2,2))
#define MsTecla		Val(SubStr(MouseRet,4,3))
#define MsLinha		Val(SubStr(MouseRet,7,2))
#define MsColuna		Val(SubStr(MouseRet,9,2))
#define cFilial		IIF(AT(Alias()+"E",cArqTab)>0,cFilAnt,"  ")
#define cVer			"8.11  "
#define ADVWINDLL 	"ADVANCED.DLL"
#command  MouseOn  => IF Have_A_Mouse;MS_CURON();MS_CURSOR(1);MS_CURON();END
#command  MouseOff => IIF(Have_A_Mouse,MS_CUROFF(),"")

//SigaTTS
#xcommand  BEGIN TRANSACTION => Begin Sequence; BeginTran()
#xcommand  BEGIN TRANSACTION EXTENDED => Begin Sequence; BeginTran()
#Translate END TRANSACTION   => EndTran(); End Sequence
#Translate END TRANSACTION EXTENDED   => EndTran(); End Sequence

#Translate Enchoice => Zero();MsMGet():New
#Translate GetDados => MsGetDados():New
#Translate InKey( => _inKey(

#include "StdWin.ch"

#define SIGA

//getdados
#define GD_INSERT	1
#define GD_UPDATE	2
#define GD_DELETE	4

#endif
#endif