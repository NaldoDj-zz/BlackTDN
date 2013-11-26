
/*
	Header : rwmake.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/


#ifndef _RWMAKE_CH
#define _RWMAKE_CH

#include 'stdwin.ch'

#XCOMMAND User Function <cNome> => Function U_<cNome>
#XCOMMAND HTML Function <cNome> => Function H_<cNome>
#XCOMMAND USERHTML Function <cNome> => Function L_<cNome>
#XCOMMAND Template Function <cNome> => Function T_<cNome>
							  
#Command @ <nTop>, <nLeft> TO <nBottom>,<nRight> DIALOG <oDlg> [TITLE <cTitle>] ;
	=> <oDlg> := MSDialog():New(<nTop>, <nLeft>, <nBottom>, <nRight>, OemToAnsi(<cTitle>),,,,,,,,,.t.,,,)
	
#Command ACTIVATE DIALOG <oDlg> [<center: CENTERED,CENTER>] [ ON INIT <bInit> ] [ VALID <bValid> ] ;
	=> <oDlg>:Activate(,,, <.center.>, [{|Self|<bValid>}], , [{|Self|<bInit>}])
	
#Command @ <nRow>, <nCol> BITMAP [<oBmp>] SIZE <nWidth>,<nHeight> FILE <cFile> ;
    => AllwaysTrue() // [ <oBmp> := ] TBitMap():New(<nRow>, <nCol>, <nWidth>, <nHeight>,, <cFile>, .t., , , , , , , , , , .t.)

#xcommand Debug <Flds,...> => MsgDbg(\{ <Flds> \}
#xcommand @ <nRow>, <nCol> PSAY <cText> [ PICTURE <cPict> ] => PrintOut(<nRow>,<nCol>,<cText>,<cPict>)

#Translate PROW( => _PROW(
#Translate PCOL( => _PCOL(
#TransLate DEVPOS( => _DEVPOS(

#Translate PLAYWAVE( => SndPlaySound(

#Translate CLOSE(<oObj>) => <oObj>:End()

#Translate MSGBOX( => IW_MsgBox(

#Command @ <nRow>, <nCol> BUTTON <cCaption> [SIZE <nWidth>,<nHeight>] ACTION <cAction> [ OBJECT <oBtn>] ;
    => [ <oBtn> := ] TButton():New( <nRow>, <nCol>, OemToAnsi(StrTran(<cCaption>, '_', '&')) , , [{|Self|<cAction>}], <nWidth>, <nHeight>,,,,.t.)

#Command @ <nRow>,<nCol> SAY <cSay> [PICTURE <cPicture>] [<color: COLOR,COLORS> <nCor> [,<nCorBack>] ] [SIZE <nWidth> [,<nHeight>] ] [OBJECT <oSay>] ;
    => [ <oSay> := ] IW_Say(<nRow>,<nCol>,<cSay>,[<cPicture>],[<nCor>],[<nCorBack>],[<nWidth>],[<nHeight>] ) // ,<{cSay}>) // removido code-block para combitibilizacao dos rdmakes antigos no Protheus

#Command @ <nRow>,<nCol> GET <cVar> [PICTURE <cPicture>] [VALID <bValid>] [WHEN <bWhen>] [F3 <cF3>] [SIZE <nW>,<nH>] [OBJECT <oGet>] [<lMemo: MEMO>] [<lPass: PASSWORD>];
	=> [ <oGet> := ] IW_Edit(<nRow>,<nCol>,<(cVar)>,[<cPicture>],<nW>,<nH>,[\{||<bValid>\}],[\{||<bWhen>\}],[<cF3>],[<.lMemo.>],[<.lPass.>],[{|x| iif(PCount()>0,<cVar> := x,<cVar>) }])

#Command @ <nRow>,<nCol> LISTBOX <nList> ITEMS <aList> SIZE <nWidth>,<nHeight> [<sort: SORTED>] [OBJECT <oLbx>] ;
    => [ <oLbx> := ] TListBox():New(<nRow>,<nCol>, [{|x| iif(PCount()>0,<nList> := x,<nList>) }] ,<aList>,<nWidth>,<nHeight>,,,,,,.t.,,,,,,,,,,[<.sort.>])

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> [TITLE <cTitle>] [OBJECT <oGrp>] ;
    => [ <oGrp> := ] TGroup():New(<nRow>,<nCol>,<nToRow>,<nToCol>,OemToAnsi(<cTitle>),, , ,.t.)

#Command @ <nRow>,<nCol> CHECKBOX <cCaption> VAR <lCheck> [OBJECT <oCbx>];
    => [ <oCbx> := ] IW_CheckBox(<nRow>,<nCol>,<cCaption>,<(lCheck)>)

#Command @ <nRow>,<nCol> RADIO <aRadio> VAR <nSelect> [OBJECT <oRdx>] ;
    => [ <oRdx> := ] IW_Radio(<nRow>,<nCol>,<(nSelect)>,<aRadio>)

#Command @ <nRow>,<nCol> COMBOBOX <cVar> ITEMS <aCombo> SIZE <nWidth>,<nHeight> [OBJECT <oCox>] ;
    => [ <oCox> := ] TComboBox():New(<nRow>,<nCol>,[{ |x| If(x<>nil,<cVar> := x,nil) , <cVar> }],<aCombo>,<nWidth>,<nHeight>,, , , , , ,.t.)

#Command @ <nRow>, <nCol> BMPBUTTON TYPE <nType> ACTION <cAction> [OBJECT <oBmt>] [<lEnable:ENABLE>] ;
    => [ <oBmt> := ] SButton():New(<nRow>, <nCol>, <nType>, [{|| <cAction>}],,<lEnable>)

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> BROWSE <cAlias> [MARK <cMark>] [ENABLE <cEnable>] [ OBJECT <oBrw> ] [ FIELDS <aFields> ];
	=> [ <oBrw> := ] IW_Browse(<nRow>,<nCol>,<nToRow>,<nToCol>,<cAlias>,<cMark>,<cEnable> [,<aFields>])

#Command @ <nRow>,<nCol> TO <nToRow>,<nToCol> MULTILINE [<lModi: MODIFY>] [<lDel: DELETE>] [VALID <bLineOk>] [FREEZE <nFreeze>] [OBJECT <oMtl>] ;
	=> [ <oMtl> := ] IW_MultiLine(<nRow>,<nCol>,<nToRow>,<nToCol>,<.lModi.>,<.lDel.>,[\{||<bLineOk>\}],<nFreeze>)
	
#xcommand DEFINE TIMER [ <oTimer> ] [ INTERVAL <nInterval> ] [ ACTION <uAction,...> ] ;
    => [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}],  )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

#xtranslate oSend( <o>,<m> ) => OSEND <o> METHOD <m> NOPARAM
#xtranslate OSEND <o> METHOD <m> NOPARAM => PT_oSend( <(o)>,<m>,<o> )
#xtranslate OSEND <o>() METHOD <m> NOPARAM => PT_oSend( <(o)>+"()",<m>, )

#xtranslate oSend( <o>,<m> ,<param,...> ) => OSEND <o> METHOD <m> PARAM \{<param>\}
#xtranslate OSEND <o> METHOD <m> PARAM <param> => PT_oSend( <(o)>,<m>,<o> ,<param> )
#xtranslate OSEND <o>() METHOD <m> PARAM <param> => PT_oSend( <(o)>+"()",<m>, ,<param> )

#endif
