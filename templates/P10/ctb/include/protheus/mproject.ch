/*
	Header : mproject.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _MPROJECT_CH_
#define _MPROJECT_CH_

#xtranslate ActiveProject:<Desc> => _GetPjApp():Projects():<Desc> 

//	PjWeekday

#define	PJSUNDAY 						'1'
#define PJMONDAY 						'2'
#define PJTUESDAY 						'3'
#define PJWEDNESDAY 					'4'
#define PJTHURSDAY 						'5'
#define PJFRIDAY 						'6'
#define PJSATURDAY 						'7'

//	PjTaskLinkType

#define PJFINISHTOFINISH 				0
#define PJFINISHTOSTART 				1
#define PJSTARTTOFINISH 				2
#define PJSTARTTOSTART 					3

//	PjAlignment 

#define PJLEFT 							'0'
#define PJCENTER 						'1'
#define PJRIGHT 						'2'

//	PjDateFormat 

#define PJDATEDEFAULT 					'255'
#define PJDATE_MM_DD_YY_HH_MMAM 		'0'
#define PJDATE_MM_DD_YY 				'0x1'
#define PJDATE_MMMM_DD_YYYY_HH_MMAM 	'0x2'
#define PJDATE_MMMM_DD_YYYY 			'0x3'
#define PJDATE_MMM_DD_HH_MMAM 			'0x4'
#define PJDATE_MMM_DD_YYY 				'0x5'
#define PJDATE_MMMM_DD 					'0x6'
#define PJDATE_MMM_DD 					'0x7'
#define PJDATE_DDD_MM_DD_YY_HH_MMAM 	'0x8'
#define PJDATE_DDD_MM_DD_YY 			'0x9'
#define PJDATE_DDD_MMM_DD_YYY 			'0xA'
#define PJDATE_DDD_HH_MMAM 				'0xB'
#define PJDATE_MM_DD 					'0xC'
#define PJDATE_DD 						'0xD'
#define PJDATE_HH_MMAM 					'0xE'
#define PJDATE_DDD_MMM_DD 				'0xF'
#define PJDATE_DDD_MM_DD 				'0x10'
#define PJDATE_DDD_DD 					'0x11'
#define PJDATE_WWW_DD 					'0x12'
#define PJDATE_WWW_DD_YY_HH_MMAM 		'0x13'
#define PJDATE_MM_DD_YYYY 				'0x14'


//-<$_BOF_MSPROJECT_$>----------------------------------------
#xtranslate :Visible => :GetVisible()
#xtranslate :Visible := <uVal> => :SetVisible( <uVal> )
#xtranslate :Visible =  <uVal> => :SetVisible( <uVal> )

#xtranslate :Caption => :GetCaption()
#xtranslate :Caption := <uVal> => :SetCaption( <uVal> )
#xtranslate :Caption =  <uVal> => :SetCaption( <uVal> )

#xtranslate :Left => :GetLeft()
#xtranslate :Left := <uVal> => :SetLeft( <uVal> )
#xtranslate :Left =  <uVal> => :SetLeft( <uVal> )

#xtranslate :Top => :GetTop()
#xtranslate :Top := <uVal> => :SetTop( <uVal> )
#xtranslate :Top =  <uVal> => :SetTop( <uVal> )

#xtranslate :Width => :GetWidth()
#xtranslate :Width := <uVal> => :SetWidth( <uVal> )
#xtranslate :Width =  <uVal> => :SetWidth( <uVal> )

#xtranslate :Height => :GetHeight()
#xtranslate :Height := <uVal> => :SetHeight( <uVal> )
#xtranslate :Height =  <uVal> => :SetHeight( <uVal> )

#xtranslate :BaseCalendarCreate( => :BCalendarCreate(
#xtranslate :BaseCalendarRename( => :BCalendarRename(
#xtranslate :BaseCalendarDelete( => :BCalendarDelete(
#xtranslate :BaseCalendarEditDays( => :BCalendarEditDays(
#xtranslate :ResourceCalendarEditDays( => :RCalendarEditDays(
//-<$_EOF_MSPROJECT_$>----------------------------------------
//-<$_BOF__PROJECTS_$>----------------------------------------
#xtranslate :Count => :GetCount()
//-<$_EOF__PROJECTS_$>----------------------------------------
//-<$_BOF__IPROJECTDOC_$>----------------------------------------
#xtranslate :Name => :GetName()
#xtranslate :Name := <uVal> => :SetName( <uVal> )
#xtranslate :Name =  <uVal> => :SetName( <uVal> )

#xtranslate :Saved => :GetSaved()
//-<$_EOF__IPROJECTDOC_$>----------------------------------------
//-<$_BOF__TASKS_$>----------------------------------------
#xtranslate :Count => :GetCount()
//-<$_EOF__TASKS_$>----------------------------------------
//-<$_BOF__TASK_$>----------------------------------------
#xtranslate :Name => :GetName()
#xtranslate :Name := <uVal> => :SetName( <uVal> )
#xtranslate :Name =  <uVal> => :SetName( <uVal> )

#xtranslate :Wbs => :GetWbs()
#xtranslate :Wbs := <uVal> => :SetWbs( <uVal> )
#xtranslate :Wbs =  <uVal> => :SetWbs( <uVal> )

#xtranslate :Id => :GetId()
#xtranslate :Duration => :GetDuration()
#xtranslate :Duration := <uVal> => :SetDuration( <uVal> )
#xtranslate :Duration =  <uVal> => :SetDuration( <uVal> )

#xtranslate :Start => :GetStart()
#xtranslate :Start := <uVal> => :SetStart( <uVal> )
#xtranslate :Start =  <uVal> => :SetStart( <uVal> )

#xtranslate :Finish => :GetFinish()
#xtranslate :Finish := <uVal> => :SetFinish( <uVal> )
#xtranslate :Finish =  <uVal> => :SetFinish( <uVal> )

#xtranslate :Text1 => :GetText1()
#xtranslate :Text1 := <uVal> => :SetText1( <uVal> )
#xtranslate :Text1 =  <uVal> => :SetText1( <uVal> )

#xtranslate :Start1 => :GetStart1()
#xtranslate :Start1 := <uVal> => :SetStart1( <uVal> )
#xtranslate :Start1 =  <uVal> => :SetStart1( <uVal> )

#xtranslate :Finish1 => :GetFinish1()
#xtranslate :Finish1 := <uVal> => :SetFinish1( <uVal> )
#xtranslate :Finish1 =  <uVal> => :SetFinish1( <uVal> )

#xtranslate :Text2 => :GetText2()
#xtranslate :Text2 := <uVal> => :SetText2( <uVal> )
#xtranslate :Text2 =  <uVal> => :SetText2( <uVal> )

#xtranslate :Start2 => :GetStart2()
#xtranslate :Start2 := <uVal> => :SetStart2( <uVal> )
#xtranslate :Start2 =  <uVal> => :SetStart2( <uVal> )

#xtranslate :Finish2 => :GetFinish2()
#xtranslate :Finish2 := <uVal> => :SetFinish2( <uVal> )
#xtranslate :Finish2 =  <uVal> => :SetFinish2( <uVal> )

#xtranslate :Text3 => :GetText3()
#xtranslate :Text3 := <uVal> => :SetText3( <uVal> )
#xtranslate :Text3 =  <uVal> => :SetText3( <uVal> )

#xtranslate :Text4 => :GetText4()
#xtranslate :Text4 := <uVal> => :SetText4( <uVal> )
#xtranslate :Text4 =  <uVal> => :SetText4( <uVal> )

#xtranslate :Text5 => :GetText5()
#xtranslate :Text5 := <uVal> => :SetText5( <uVal> )
#xtranslate :Text5 =  <uVal> => :SetText5( <uVal> )

#xtranslate :Text6 => :GetText6()
#xtranslate :Text6 := <uVal> => :SetText6( <uVal> )
#xtranslate :Text6 =  <uVal> => :SetText6( <uVal> )

#xtranslate :Text7 => :GetText7()
#xtranslate :Text7 := <uVal> => :SetText7( <uVal> )
#xtranslate :Text7 =  <uVal> => :SetText7( <uVal> )

#xtranslate :Text8 => :GetText8()
#xtranslate :Text8 := <uVal> => :SetText8( <uVal> )
#xtranslate :Text8 =  <uVal> => :SetText8( <uVal> )

#xtranslate :Text9 => :GetText9()
#xtranslate :Text9 := <uVal> => :SetText9( <uVal> )
#xtranslate :Text9 =  <uVal> => :SetText9( <uVal> )

#xtranslate :Text10 => :GetText10()
#xtranslate :Text10 := <uVal> => :SetText10( <uVal> )
#xtranslate :Text10 =  <uVal> => :SetText10( <uVal> )

#xtranslate :Text11 => :GetText11()
#xtranslate :Text11 := <uVal> => :SetText11( <uVal> )
#xtranslate :Text11 =  <uVal> => :SetText11( <uVal> )

#xtranslate :Text12 => :GetText12()
#xtranslate :Text12 := <uVal> => :SetText12( <uVal> )
#xtranslate :Text12 =  <uVal> => :SetText12( <uVal> )

#xtranslate :Text13 => :GetText13()
#xtranslate :Text13 := <uVal> => :SetText13( <uVal> )
#xtranslate :Text13 =  <uVal> => :SetText13( <uVal> )

#xtranslate :Text14 => :GetText14()
#xtranslate :Text14 := <uVal> => :SetText14( <uVal> )
#xtranslate :Text14 =  <uVal> => :SetText14( <uVal> )

#xtranslate :Text15 => :GetText15()
#xtranslate :Text15 := <uVal> => :SetText15( <uVal> )
#xtranslate :Text15 =  <uVal> => :SetText15( <uVal> )

#xtranslate :Text16 => :GetText16()
#xtranslate :Text16 := <uVal> => :SetText16( <uVal> )
#xtranslate :Text16 =  <uVal> => :SetText16( <uVal> )

#xtranslate :Text17 => :GetText17()
#xtranslate :Text17 := <uVal> => :SetText17( <uVal> )
#xtranslate :Text17 =  <uVal> => :SetText17( <uVal> )

#xtranslate :Text18 => :GetText18()
#xtranslate :Text18 := <uVal> => :SetText18( <uVal> )
#xtranslate :Text18 =  <uVal> => :SetText18( <uVal> )

#xtranslate :Text19 => :GetText19()
#xtranslate :Text19 := <uVal> => :SetText19( <uVal> )
#xtranslate :Text19 =  <uVal> => :SetText19( <uVal> )

#xtranslate :Text20 => :GetText20()
#xtranslate :Text20 := <uVal> => :SetText20( <uVal> )
#xtranslate :Text20 =  <uVal> => :SetText20( <uVal> )

#xtranslate :Text21 => :GetText21()
#xtranslate :Text21 := <uVal> => :SetText21( <uVal> )
#xtranslate :Text21 =  <uVal> => :SetText21( <uVal> )

#xtranslate :Text22 => :GetText22()
#xtranslate :Text22 := <uVal> => :SetText22( <uVal> )
#xtranslate :Text22 =  <uVal> => :SetText22( <uVal> )

#xtranslate :Text23 => :GetText23()
#xtranslate :Text23 := <uVal> => :SetText23( <uVal> )
#xtranslate :Text23 =  <uVal> => :SetText23( <uVal> )

#xtranslate :Text24 => :GetText24()
#xtranslate :Text24 := <uVal> => :SetText24( <uVal> )
#xtranslate :Text24 =  <uVal> => :SetText24( <uVal> )

#xtranslate :Text25 => :GetText25()
#xtranslate :Text25 := <uVal> => :SetText25( <uVal> )
#xtranslate :Text25 =  <uVal> => :SetText25( <uVal> )

#xtranslate :Text26 => :GetText26()
#xtranslate :Text26 := <uVal> => :SetText26( <uVal> )
#xtranslate :Text26 =  <uVal> => :SetText26( <uVal> )

#xtranslate :Text27 => :GetText27()
#xtranslate :Text27 := <uVal> => :SetText27( <uVal> )
#xtranslate :Text27 =  <uVal> => :SetText27( <uVal> )

#xtranslate :Text28 => :GetText28()
#xtranslate :Text28 := <uVal> => :SetText28( <uVal> )
#xtranslate :Text28 =  <uVal> => :SetText28( <uVal> )

#xtranslate :Text29 => :GetText29()
#xtranslate :Text29 := <uVal> => :SetText29( <uVal> )
#xtranslate :Text29 =  <uVal> => :SetText29( <uVal> )

#xtranslate :Text30 => :GetText30()
#xtranslate :Text30 := <uVal> => :SetText30( <uVal> )
#xtranslate :Text30 =  <uVal> => :SetText30( <uVal> )

#xtranslate :Predecessors => :GetPredecessors()
#xtranslate :Predecessors := <uVal> => :SetPredecessors( <uVal> )
#xtranslate :Predecessors =  <uVal> => :SetPredecessors( <uVal> )

#xtranslate :Successors => :GetSuccessors()
#xtranslate :Successors := <uVal> => :SetSuccessors( <uVal> )
#xtranslate :Successors =  <uVal> => :SetSuccessors( <uVal> )

#xtranslate :ResourceNames => :GetResourceNames()
#xtranslate :ResourceNames := <uVal> => :SetResourceNames( <uVal> )
#xtranslate :ResourceNames =  <uVal> => :SetResourceNames( <uVal> )

#xtranslate :Calendar => :GetCalendar()
#xtranslate :Calendar := <uVal> => :SetCalendar( <uVal> )
#xtranslate :Calendar =  <uVal> => :SetCalendar( <uVal> )

#xtranslate :WBSPredecessors => :GetWBSPredecessors()
#xtranslate :WBSSuccessors => :GetWBSSuccessors()
//-<$_EOF__TASK_$>----------------------------------------
//-<$_BOF__RESOURCES_$>----------------------------------------
#xtranslate :Count => :GetCount()
//-<$_EOF__RESOURCES_$>----------------------------------------
//-<$_BOF__RESOURCE_$>----------------------------------------
#xtranslate :Name => :GetName()
#xtranslate :Name := <uVal> => :SetName( <uVal> )
#xtranslate :Name =  <uVal> => :SetName( <uVal> )

#xtranslate :BaseCalendar => :GetBaseCalendar()
#xtranslate :BaseCalendar := <uVal> => :SetBaseCalendar( <uVal> )
#xtranslate :BaseCalendar =  <uVal> => :SetBaseCalendar( <uVal> )

#xtranslate :Text1 => :GetText1()
#xtranslate :Text1 := <uVal> => :SetText1( <uVal> )
#xtranslate :Text1 =  <uVal> => :SetText1( <uVal> )

#xtranslate :Text2 => :GetText2()
#xtranslate :Text2 := <uVal> => :SetText2( <uVal> )
#xtranslate :Text2 =  <uVal> => :SetText2( <uVal> )

#xtranslate :Text3 => :GetText3()
#xtranslate :Text3 := <uVal> => :SetText3( <uVal> )
#xtranslate :Text3 =  <uVal> => :SetText3( <uVal> )

#xtranslate :Text4 => :GetText4()
#xtranslate :Text4 := <uVal> => :SetText4( <uVal> )
#xtranslate :Text4 =  <uVal> => :SetText4( <uVal> )

#xtranslate :Text5 => :GetText5()
#xtranslate :Text5 := <uVal> => :SetText5( <uVal> )
#xtranslate :Text5 =  <uVal> => :SetText5( <uVal> )

//-<$_EOF__RESOURCE_$>----------------------------------------

//-<$_BOF__BASECALENDARS_$>----------------------------------------
#xtranslate :Count => :GetCount()
//-<$_EOF__BASECALENDARS_$>----------------------------------------
//-<$_BOF__CALENDAR_$>----------------------------------------
#xtranslate :Name => :GetName()
#xtranslate :Name := <uVal> => :SetName( <uVal> )
#xtranslate :Name =  <uVal> => :SetName( <uVal> )

#xtranslate :Index => :GetIndex()
//-<$_EOF__CALENDAR_$>----------------------------------------
//-<$_BOF_YEARS_$>----------------------------------------
//-<$_EOF_YEARS_$>----------------------------------------
//-<$_BOF_YEAR_$>----------------------------------------
//-<$_EOF_YEAR_$>----------------------------------------
//-<$_BOF_MONTHS_$>----------------------------------------
//-<$_EOF_MONTHS_$>----------------------------------------
//-<$_BOF_MONTH_$>----------------------------------------
//-<$_EOF_MONTH_$>----------------------------------------
//-<$_BOF_WEEKDAYS_$>----------------------------------------
//-<$_EOF_WEEKDAYS_$>----------------------------------------
//-<$_BOF_WEEKDAY_$>----------------------------------------
//-<$_EOF_WEEKDAY_$>----------------------------------------
//-<$_BOF_DAYS_$>----------------------------------------
//-<$_EOF_DAYS_$>----------------------------------------
//-<$_BOF_DAY_$>----------------------------------------
//-<$_EOF_DAY_$>----------------------------------------

#endif
