/*
	Header : dbtree.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _DBTREE_CH_
#define _DBTREE_CH_

#xcommand DEFINE DBTREE [<oTree>];
            [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
            [ <dlg:OF,DIALOG> <oWnd> ] ;
            [ ON CHANGE <uChange> ] ;
            [ ON RIGHT CLICK <uRClick> ] ;
            [ <lCargo: CARGO> ] ;
            [ <lDisable: DISABLE> ] ;
    => ;
        <oTree> := DbTree():New(<nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd>,<{uChange}>, <{uRClick}>, <.lCargo.>, <.lDisable.> )

#xcommand REDEFINE DBTREE [<oTree>];
            [ <dlg:OF,DIALOG> <oWnd> ] ;
            [ ID <nId> ] ;
            [ ON CHANGE <uChange> ] ;
            [ ON RIGHT CLICK <uRClick> ] ;
            [ <lCargo: CARGO>  ] ;
            [ <lDisable: DISABLE> ] ;
    => ;
        <oTree> := DbTree():Redefine(<oWnd>, <nId>, <{uChange}>, <{uRClick}>, <.lCargo.>, <.lDisable.> )

#xcommand DBADDTREE [<oTree> <cLab: PROMPT, LABEL>] <cLabel>;
            [ <lOpen: OPEN, OPENED> ] ;
            [ <cRes: RESOURCE, RES> <cResOpen> [, <cResClose> ] ] ;
            [ <cBmp: FILENAME, FILE, BITMAP> <cBmpOpen> [, <cBmpClose> ] ] ;
            [ <cCrg: CARGO> <cCargo> ] ;
    => ;
        <oTree>:AddTree( <cLabel>, <.lOpen.>, <cResOpen>, <cResClose>, <cBmpOpen>, <cBmpClose>, <cCargo> )

#xcommand DBADDITEM [<oTree> <cLab: PROMPT, LABEL>] <cLabel> ;
            [ <cRes: RESOURCE, RES> <cResOpen> ] ;
            [ <cBmp: FILENAME, FILE, BITMAP> <cBmpOpen> ] ;
            [ <cCrg: CARGO> <cCargo> ] ;
    => ;
        <oTree>:AddTreeItem( <cLabel>, <cResOpen>, <cBmpOpen>, <cCargo>)

#xcommand DBENDTREE [<oTree>];
    => ;
        <oTree>:EndTree()

#endif

