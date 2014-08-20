/*
	Header : tcbrowse.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _TCBROWSE_CH
#define _TCBROWSE_CH

#xcommand @ <nRow>, <nCol> [ COLUMN ] BROWSE  <oBrw>  ;
               [ [ FIELDS ] <Flds,...>] ;
               [ ALIAS <cAlias> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ <dlg:OF,DIALOG> <oDlg> ] ;
               [ SELECT <cField> FOR <uValue1> [ TO <uValue2> ] ] ;
               [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
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
      => ;
          <oBrw> := TCBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeigth>,;
                           [\{|| \{<Flds> \} \}], ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           <oDlg>, <(cField)>, <uValue1>, <uValue2>,;
                           [<{uChange}>],;
                           [\{|nRow,nCol,nFlags|<uLDblClick>\}],;
                           [\{|nRow,nCol,nFlags|<uRClick>\}],;
                           <oFont>, <oCursor>, <nClrFore>, <nClrBack>, <cMsg>,;
                           <.update.>, <(cAlias)>, <.pixel.>, <{uWhen}>,;
                           <.design.>, <{uValid}> )

#command DEFINE COLUMN <oCol> ;
            [ <dat: DATA, SHOWBLOCK> <uData> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <align: LEFT, CENTERED, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ PICTURE <cPicture> ] ;
            [ <bit: BITMAP> ] ;
            [ <edit: EDITABLE> ] ;
            [ MESSAGE <cMsg> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            [ <idx: ORDER, INDEX, TAG> <cOrder> ] ;
            => ;
    <oCol> :=  TCColumn():New( ;
    If(<.oem.>, OemToAnsi(<cHead>), <cHead>), ;
    [ If( ValType(<uData>)=="B", <uData>, <{uData}> ) ], <cPicture>, ;
    [ If( ValType(<uClrFore>)=="B", <uClrFore>, <{uClrFore}> ) ], ;
    [ If( ValType(<uClrBack>)=="B", <uClrBack>, <{uClrBack}> ) ], ;
    If(!<.align.>,"LEFT", Upper(<(align)>)), <nWidth>, <.bit.>, ;
    <.edit.>, <cMsg>, <{uValid}>, <cErr>, <.lite.>, <(cOrder)> )

#command ADD [ COLUMN ] TO [ BROWSE ] <oBrw> ;
            [ <dat: DATA, SHOWBLOCK> <uData> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <align: LEFT, CENTERED, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ PICTURE <cPicture> ] ;
            [ <bit: BITMAP> ] ;
            [ <edit: EDITABLE> ] ;
            [ MESSAGE <cMsg> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            [ <idx: ORDER, INDEX, TAG> <cOrder> ] ;
            => ;
    <oBrw>:AddColumn( TCColumn():New( ;
    If(<.oem.>, OemToAnsi(<cHead>), <cHead>), ;
    [ If( ValType(<uData>)=="B", <uData>, <{uData}> ) ], <cPicture>, ;
    [ If( ValType(<uClrFore>)=="B", <uClrFore>, <{uClrFore}> ) ], ;
    [ If( ValType(<uClrBack>)=="B", <uClrBack>, <{uClrBack}> ) ], ;
    If(!<.align.>,"LEFT", Upper(<(align)>)), <nWidth>, <.bit.>, ;
    <.edit.>, <cMsg>, <{uValid}>, <cErr>, <.lite.>, <(cOrder)> ) )

#command ADD [ COLUMN ] TO [ BROWSE ] <oBrw> [ DATA ] ARRAY ;
            [ <el: ELM, ELEMENT> <elm> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <align: LEFT, CENTERED, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ PICTURE <cPicture> ] ;
            [ <bit: BITMAP> ] ;
            [ <edit: EDITABLE> ] ;
            [ MESSAGE <cMsg> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            => ;
    <oBrw>:AddColumn( TCColumn():New( ;
    If(<.oem.>, OemToAnsi(<cHead>), <cHead>), ;
    \{|x| If(Pcount()>0, <oBrw>:aArray\[<oBrw>:nAt, <elm>\] :=x,  ;
            <oBrw>:aArray\[<oBrw>:nAt, <elm>\])\}, <cPicture>,    ;
    [ If( ValType(<uClrFore>)=="B", <uClrFore>, <{uClrFore}> ) ], ;
    [ If( ValType(<uClrBack>)=="B", <uClrBack>, <{uClrBack}> ) ], ;
    If(!<.align.>,"LEFT", Upper(<(align)>)), <nWidth>, <.bit.>,   ;
    <.edit.>, <cMsg>, <{uValid}>, <cErr>, <.lite.> ) )

// TDataBase Class oBrw:oDbf:FieldName
// TMultiDBF Class oBrw:oDbf:AliasName:FieldName

#command ADD [ COLUMN ] TO [BROWSE] <oBrw> [DATA]  ;
            <fi: oDBF, FIELD> [FIELD] <field>  ;
            [ ALIAS <alias> ] ;
            [ <tit: TITLE, HEADER> <cHead> [ <oem: OEM, ANSI, CONVERT>] ];
            [ <clr: COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ ALIGN ] [ <align: LEFT, CENTERED, RIGHT> ] ;
            [ <wid: WIDTH, SIZE> <nWidth> [ PIXELS ] ] ;
            [ PICTURE <cPicture> ] ;
            [ <bit: BITMAP> ] ;
            [ <edit: EDITABLE> ] ;
            [ MESSAGE <cMsg> ] ;
            [ VALID <uValid> ] ;
            [ ERROR [MSG] [MESSAGE] <cErr> ] ;
            [ <lite: NOBAR, NOHILITE> ] ;
            [ <idx: ORDER, INDEX, TAG> <cOrder> ] ;
            => ;
    <oBrw>:AddColumn( TCColumn():New(              ;
    If(<.oem.>, OemToAnsi(<cHead>), <cHead>),      ;
    \{|x| If(Pcount()>0, <oBrw>:oDbf:[<alias>:]<field> :=x,  ;
            <oBrw>:oDbf:[<alias>:]<field>) \}, <cPicture>,   ;
    [ If( ValType(<uClrFore>)=="B", <uClrFore>, <{uClrFore}> ) ], ;
    [ If( ValType(<uClrBack>)=="B", <uClrBack>, <{uClrBack}> ) ], ;
    If(!<.align.>,"LEFT", Upper(<(align)>)), <nWidth>, <.bit.>,   ;
    <.edit.>, <cMsg>, <{uValid}>, <cErr>, <.lite.>, <(cOrder)> ) )


#translate VALID <if: IF, CONDITION> <cond> => ;
                   VALID \{|o, x| x := o:varGet(), <cond> \}

#define DT_LEFT              0
#define DT_CENTER            1
#define DT_RIGHT             2

#endif

