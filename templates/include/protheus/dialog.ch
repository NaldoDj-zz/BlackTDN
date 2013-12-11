/*
	Header : dialog.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/


#ifndef _DIALOG_CH_
#define _DIALOG_CH_

//----------------------------------------------------------------------------//
// Microsoft 3D Look

#xcommand SET <look_3d: 3DLOOK, LOOK3D, LOOK 3D, 3D LOOK> <on:ON,OFF,&> => ;
          Set3DLook( Upper(<(on)>) == "ON" )

//----------------------------------------------------------------------------//
// Resources

#xcommand SET RESOURCES TO <cName1> [,<cName2>] ;
       => ;
          [ SetResources( <cName2> ); ] SetResources( <cName1> )

#xcommand SET RESOURCES TO => FreeResources()

//----------------------------------------------------------------------------//

#xcommand SET HELPFILE TO <cFile>    => SetHelpFile( <cFile> )
#xcommand SET HELP TOPIC TO <cTopic> => HelpSetTopic( <cTopic> )

//----------------------------------------------------------------------------//
// Loading strings/or other Types from Resources

#xcommand REDEFINE <uVar> ;
             [ AS <type: CHARACTER, NUMERIC, LOGICAL, DATE> ] ;
             [ <resource: RESOURCE, RESNAME, NAME> <nIdRes> ] ;
       => ;
          <uVar> := LoadValue( <nIdRes>, [Upper(<(type)>)], <uVar> )

//----------------------------------------------------------------------------//

#xcommand DEFINE DIALOG <oDlg> ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> ] ;
             [ TITLE <cTitle> ] ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lib: LIBRARY, DLL> <hResources> ] ;
             [ <vbx: VBX> ] ;
             [ STYLE <nStyle> ] ;
             [ <color: COLOR, COLORS> <nClrText> [,<nClrBack> ] ] ;
             [ BRUSH <oBrush> ] ;
             [ <of: WINDOW, DIALOG, OF> <oWnd> ] ;
             [ <pixel: PIXEL> ] ;
             [ ICON <oIco> ] ;
             [ FONT <oFont> ] ;
             [ <help: HELP, HELPID> <nHelpId> ] ;
       => ;
          <oDlg> = TDialog():New( <nTop>, <nLeft>, <nBottom>, <nRight>,;
                 <cTitle>, <cResName>, <hResources>, <.vbx.>, <nStyle>,;
                 <nClrText>, <nClrBack>, <oBrush>, <oWnd>, <.pixel.>,;
                 <oIco>, <oFont>, <nHelpId>, <nWidth>, <nHeight> )

#xcommand ACTIVATE DIALOG <oDlg> ;
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
          <oDlg>:Activate( <oDlg>:bLClicked [ := {|nRow,nCol,nFlags|<uClick>}], ;
                           <oDlg>:bMoved    [ := <{uMoved}> ], ;
                           <oDlg>:bPainted  [ := {|hDC,cPS|<uPaint>}],;
                           [<.center.>], [{|Self|<uValid>}],;
                           [ ! <.NonModal.> ], [{|Self|<uInit>}],;
                           <oDlg>:bRClicked [ := {|nRow,nCol,nFlags|<uRClicked>}],;
                           [{|Self|<uWhen>}] )
						   
#xcommand ACTIVATE DIALOG <oDlg> ;
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
          <oDlg>:Activate( <oDlg>:bLClicked [ := {|nRow,nCol,nFlags|<uClick>}], ;
                           <oDlg>:bMoved    [ := <{uMoved}> ], ;
                           <oDlg>:bPainted  [ := {|hDC,cPS|<uPaint>}],;
                           [! <.nocenter.>], [{|Self|<uValid>}],;
                           [ ! <.NonModal.> ], [{|Self|<uInit>}],;
                           <oDlg>:bRClicked [ := {|nRow,nCol,nFlags|<uRClicked>}],;
                           [{|Self|<uWhen>}] )

//----------------------------------------------------------------------------//

#endif