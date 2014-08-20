/*
	Header : mproject.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _MPROJECT_CH_
#define _MPROJECT_CH_
#define _TASK_RAWREAD				9001
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

#define PJCUSTOMTASKCOST1 '0xB40006A'
#define PJCUSTOMTASKCOST10 '0xB400108'
#define PJCUSTOMTASKCOST2 '0xB40006B'
#define PJCUSTOMTASKCOST3 '0xB40006C'
#define PJCUSTOMTASKCOST4 '0xB400102'
#define PJCUSTOMTASKCOST5 '0xB400103'
#define PJCUSTOMTASKCOST6 '0xB400104'
#define PJCUSTOMTASKCOST7 '0xB400105'
#define PJCUSTOMTASKCOST8 '0xB400106'
#define PJCUSTOMTASKCOST9 '0xB400107'
#define PJCUSTOMTASKDATE1 '0xB400109'
#define PJCUSTOMTASKDATE10 '0xB400112'
#define PJCUSTOMTASKDATE2 '0xB40010A'
#define PJCUSTOMTASKDATE3 '0xB40010B'
#define PJCUSTOMTASKDATE4 '0xB40010C'
#define PJCUSTOMTASKDATE5 '0xB40010D'
#define PJCUSTOMTASKDATE6 '0xB40010E'
#define PJCUSTOMTASKDATE7 '0xB40010F'
#define PJCUSTOMTASKDATE8 '0xB400110'
#define PJCUSTOMTASKDATE9 '0xB400111'
#define PJCUSTOMTASKDURATION1 '0xB400067'
#define PJCUSTOMTASKDURATION10 '0xB400119'
#define PJCUSTOMTASKDURATION2 '0xB400068'
#define PJCUSTOMTASKDURATION3 '0xB400069'
#define PJCUSTOMTASKDURATION4 '0xB400113'
#define PJCUSTOMTASKDURATION5 '0xB400114'
#define PJCUSTOMTASKDURATION6 '0xB400115'
#define PJCUSTOMTASKDURATION7 '0xB400116'
#define PJCUSTOMTASKDURATION8 '0xB400117'
#define PJCUSTOMTASKDURATION9 '0xB400118'
#define PJCUSTOMTASKFINISH1 '0xB400035'
#define PJCUSTOMTASKFINISH10 '0xB400123'
#define PJCUSTOMTASKFINISH2 '0xB400038'
#define PJCUSTOMTASKFINISH3 '0xB40003B'
#define PJCUSTOMTASKFINISH4 '0xB40003E'
#define PJCUSTOMTASKFINISH5 '0xB400041'
#define PJCUSTOMTASKFINISH6 '0xB40011B'
#define PJCUSTOMTASKFINISH7 '0xB40011D'
#define PJCUSTOMTASKFINISH8 '0xB40011F'
#define PJCUSTOMTASKFINISH9 '0xB400121'
#define PJCUSTOMTASKFLAG1 '0xB400048'
#define PJCUSTOMTASKFLAG10 '0xB400051'
#define PJCUSTOMTASKFLAG11 '0xB400124'
#define PJCUSTOMTASKFLAG12 '0xB400125'
#define PJCUSTOMTASKFLAG13 '0xB400126'
#define PJCUSTOMTASKFLAG14 '0xB400127'
#define PJCUSTOMTASKFLAG15 '0xB400128'
#define PJCUSTOMTASKFLAG16 '0xB400129'
#define PJCUSTOMTASKFLAG17 '0xB40012A'
#define PJCUSTOMTASKFLAG18 '0xB40012B'
#define PJCUSTOMTASKFLAG19 '0xB40012C'
#define PJCUSTOMTASKFLAG2 '0xB400049'
#define PJCUSTOMTASKFLAG20 '0xB40012D'
#define PJCUSTOMTASKFLAG3 '0xB40004A'
#define PJCUSTOMTASKFLAG4 '0xB40004B'
#define PJCUSTOMTASKFLAG5 '0xB40004C'
#define PJCUSTOMTASKFLAG6 '0xB40004D'
#define PJCUSTOMTASKFLAG7 '0xB40004E'
#define PJCUSTOMTASKFLAG8 '0xB40004F'
#define PJCUSTOMTASKFLAG9 '0xB400050'
#define PJCUSTOMTASKNUMBER1 '0xB400057'
#define PJCUSTOMTASKNUMBER10 '0xB400132'
#define PJCUSTOMTASKNUMBER11 '0xB400133'
#define PJCUSTOMTASKNUMBER12 '0xB400134'
#define PJCUSTOMTASKNUMBER13 '0xB400135'
#define PJCUSTOMTASKNUMBER14 '0xB400136'
#define PJCUSTOMTASKNUMBER15 '0xB400137'
#define PJCUSTOMTASKNUMBER16 '0xB400138'
#define PJCUSTOMTASKNUMBER17 '0xB400139'
#define PJCUSTOMTASKNUMBER18 '0xB40013A'
#define PJCUSTOMTASKNUMBER19 '0xB40013B'
#define PJCUSTOMTASKNUMBER2 '0xB400058'
#define PJCUSTOMTASKNUMBER20 '0xB40013C'
#define PJCUSTOMTASKNUMBER3 '0xB400059'
#define PJCUSTOMTASKNUMBER4 '0xB40005A'
#define PJCUSTOMTASKNUMBER5 '0xB40005B'
#define PJCUSTOMTASKNUMBER6 '0xB40012E'
#define PJCUSTOMTASKNUMBER7 '0xB40012F'
#define PJCUSTOMTASKNUMBER8 '0xB400130'
#define PJCUSTOMTASKNUMBER9 '0xB400131'
#define PJCUSTOMTASKOUTLINECODE1 '0xB4001A0'
#define PJCUSTOMTASKOUTLINECODE10 '0xB4001B2'
#define PJCUSTOMTASKOUTLINECODE2 '0xB4001A2'
#define PJCUSTOMTASKOUTLINECODE3 '0xB4001A4'
#define PJCUSTOMTASKOUTLINECODE4 '0xB4001A6'
#define PJCUSTOMTASKOUTLINECODE5 '0xB4001A8'
#define PJCUSTOMTASKOUTLINECODE6 '0xB4001AA'
#define PJCUSTOMTASKOUTLINECODE7 '0xB4001AC'
#define PJCUSTOMTASKOUTLINECODE8 '0xB4001AE'
#define PJCUSTOMTASKOUTLINECODE9 '0xB4001B0'
#define PJCUSTOMTASKSTART1 '0xB400034'
#define PJCUSTOMTASKSTART10 '0xB400122'
#define PJCUSTOMTASKSTART2 '0xB400037'
#define PJCUSTOMTASKSTART3 '0xB40003A'
#define PJCUSTOMTASKSTART4 '0xB40003D'
#define PJCUSTOMTASKSTART5 '0xB400040'
#define PJCUSTOMTASKSTART6 '0xB40011A'
#define PJCUSTOMTASKSTART7 '0xB40011C'
#define PJCUSTOMTASKSTART8 '0xB40011E'
#define PJCUSTOMTASKSTART9 '0xB400120'
#define PJCUSTOMTASKTEXT1 '0xB400033'
#define PJCUSTOMTASKTEXT10 '0xB400046'
#define PJCUSTOMTASKTEXT11 '0xB40013D'
#define PJCUSTOMTASKTEXT12 '0xB40013E'
#define PJCUSTOMTASKTEXT13 '0xB40013F'
#define PJCUSTOMTASKTEXT14 '0xB400140'
#define PJCUSTOMTASKTEXT15 '0xB400141'
#define PJCUSTOMTASKTEXT16 '0xB400142'
#define PJCUSTOMTASKTEXT17 '0xB400143'
#define PJCUSTOMTASKTEXT18 '0xB400144'
#define PJCUSTOMTASKTEXT19 '0xB400145'
#define PJCUSTOMTASKTEXT2 '0xB400036'
#define PJCUSTOMTASKTEXT20 '0xB400146'
#define PJCUSTOMTASKTEXT21 '0xB400147'
#define PJCUSTOMTASKTEXT22 '0xB400148'
#define PJCUSTOMTASKTEXT23 '0xB400149'
#define PJCUSTOMTASKTEXT24 '0xB40014A'
#define PJCUSTOMTASKTEXT25 '0xB40014B'
#define PJCUSTOMTASKTEXT26 '0xB40014C'
#define PJCUSTOMTASKTEXT27 '0xB40014D'
#define PJCUSTOMTASKTEXT28 '0xB40014E'
#define PJCUSTOMTASKTEXT29 '0xB40014F'
#define PJCUSTOMTASKTEXT3 '0xB400039'
#define PJCUSTOMTASKTEXT30 '0xB400150'
#define PJCUSTOMTASKTEXT4 '0xB40003C'
#define PJCUSTOMTASKTEXT5 '0xB40003F'
#define PJCUSTOMTASKTEXT6 '0xB400042'
#define PJCUSTOMTASKTEXT7 '0xB400043'
#define PJCUSTOMTASKTEXT8 '0xB400044'
#define PJCUSTOMTASKTEXT9 '0xB400045'
#define PJTASKACTUALCOST '0xB400007'
#define PJTASKACTUALDURATION '0xB40001C'
#define PJTASKACTUALFINISH '0xB40002A'
#define PJTASKACTUALOVERTIMECOST '0xB4000A9'
#define PJTASKACTUALOVERTIMEWORK '0xB4000A4'
#define PJTASKACTUALSTART '0xB400029'
#define PJTASKACTUALWORK '0xB400002'
#define PJTASKACWP '0xB400078'
#define PJTASKASSIGNMENTDELAY '0xB40016E'
#define PJTASKASSIGNMENTUNITS '0xB40016F'
#define PJTASKBASELINECOST '0xB400006'
#define PJTASKBASELINEDURATION '0xB40001B'
#define PJTASKBASELINEDURATIONESTIMATED '0xB40019D'
#define PJTASKBASELINEFINISH '0xB40002C'
#define PJTASKBASELINESTART '0xB40002B'
#define PJTASKBASELINEWORK '0xB400001'
#define PJTASKBCWP '0xB40000B'
#define PJTASKBCWS '0xB40000C'
#define PJTASKCALENDAR '0xB400192'
#define PJTASKCONFIRMED '0xB40006E'
#define PJTASKCONSTRAINTDATE '0xB400012'
#define PJTASKCONSTRAINTTYPE '0xB400011'
#define PJTASKCONTACT '0xB400070'
#define PJTASKCOST '0xB400005'
#define PJTASKCOST1 '0xB40006A'
#define PJTASKCOST10 '0xB400108'
#define PJTASKCOST2 '0xB40006B'
#define PJTASKCOST3 '0xB40006C'
#define PJTASKCOST4 '0xB400102'
#define PJTASKCOST5 '0xB400103'
#define PJTASKCOST6 '0xB400104'
#define PJTASKCOST7 '0xB400105'
#define PJTASKCOST8 '0xB400106'
#define PJTASKCOST9 '0xB400107'
#define PJTASKCOSTRATETABLE '0xB400170'
#define PJTASKCOSTVARIANCE '0xB400009'
#define PJTASKCREATED '0xB40005D'
#define PJTASKCRITICAL '0xB400013'
#define PJTASKCV '0xB400053'
#define PJTASKDATE1 '0xB400109'
#define PJTASKDATE10 '0xB400112'
#define PJTASKDATE2 '0xB40010A'
#define PJTASKDATE3 '0xB40010B'
#define PJTASKDATE4 '0xB40010C'
#define PJTASKDATE5 '0xB40010D'
#define PJTASKDATE6 '0xB40010E'
#define PJTASKDATE7 '0xB40010F'
#define PJTASKDATE8 '0xB400110'
#define PJTASKDATE9 '0xB400111'
#define PJTASKDEADLINE '0xB4001B5'
#define PJTASKDELAY '0xB400014'
#define PJTASKDURATION '0xB40001D'
#define PJTASKDURATION1 '0xB400067'
#define PJTASKDURATION10 '0xB400119'
#define PJTASKDURATION10ESTIMATED '0xB40019C'
#define PJTASKDURATION1ESTIMATED '0xB400193'
#define PJTASKDURATION2 '0xB400068'
#define PJTASKDURATION2ESTIMATED '0xB400194'
#define PJTASKDURATION3 '0xB400069'
#define PJTASKDURATION3ESTIMATED '0xB400195'
#define PJTASKDURATION4 '0xB400113'
#define PJTASKDURATION4ESTIMATED '0xB400196'
#define PJTASKDURATION5 '0xB400114'
#define PJTASKDURATION5ESTIMATED '0xB400197'
#define PJTASKDURATION6 '0xB400115'
#define PJTASKDURATION6ESTIMATED '0xB400198'
#define PJTASKDURATION7 '0xB400116'
#define PJTASKDURATION7ESTIMATED '0xB400199'
#define PJTASKDURATION8 '0xB400117'
#define PJTASKDURATION8ESTIMATED '0xB40019A'
#define PJTASKDURATION9 '0xB400118'
#define PJTASKDURATION9ESTIMATED '0xB40019B'
#define PJTASKDURATIONVARIANCE '0xB40001E'
#define PJTASKEARLYFINISH '0xB400026'
#define PJTASKEARLYSTART '0xB400025'
#define PJTASKEFFORTDRIVEN '0xB400084'
#define PJTASKESTIMATED '0xB40018C'
#define PJTASKEXTERNALTASK '0xB4000E8'
#define PJTASKFINISH '0xB400024'
#define PJTASKFINISH1 '0xB400035'
#define PJTASKFINISH10 '0xB400123'
#define PJTASKFINISH2 '0xB400038'
#define PJTASKFINISH3 '0xB40003B'
#define PJTASKFINISH4 '0xB40003E'
#define PJTASKFINISH5 '0xB400041'
#define PJTASKFINISH6 '0xB40011B'
#define PJTASKFINISH7 '0xB40011D'
#define PJTASKFINISH8 '0xB40011F'
#define PJTASKFINISH9 '0xB400121'
#define PJTASKFINISHSLACK '0xB4001B7'
#define PJTASKFINISHVARIANCE '0xB40002E'
#define PJTASKFIXEDCOST '0xB400008'
#define PJTASKFIXEDCOSTACCRUAL '0xB4000C8'
#define PJTASKFIXEDDURATION '0xB400022'
#define PJTASKFLAG1 '0xB400048'
#define PJTASKFLAG10 '0xB400051'
#define PJTASKFLAG11 '0xB400124'
#define PJTASKFLAG12 '0xB400125'
#define PJTASKFLAG13 '0xB400126'
#define PJTASKFLAG14 '0xB400127'
#define PJTASKFLAG15 '0xB400128'
#define PJTASKFLAG16 '0xB400129'
#define PJTASKFLAG17 '0xB40012A'
#define PJTASKFLAG18 '0xB40012B'
#define PJTASKFLAG19 '0xB40012C'
#define PJTASKFLAG2 '0xB400049'
#define PJTASKFLAG20 '0xB40012D'
#define PJTASKFLAG3 '0xB40004A'
#define PJTASKFLAG4 '0xB40004B'
#define PJTASKFLAG5 '0xB40004C'
#define PJTASKFLAG6 '0xB40004D'
#define PJTASKFLAG7 '0xB40004E'
#define PJTASKFLAG8 '0xB40004F'
#define PJTASKFLAG9 '0xB400050'
#define PJTASKFREESLACK '0xB400015'
#define PJTASKGROUPBYSUMMARY '0xB4001BE'
#define PJTASKHIDEBAR '0xB40006D'
#define PJTASKHYPERLINK '0xB4000D9'
#define PJTASKHYPERLINKADDRESS '0xB4000DA'
#define PJTASKHYPERLINKHREF '0xB4000DC'
#define PJTASKHYPERLINKSCREENTIP '0xB4001C4'
#define PJTASKHYPERLINKSUBADDRESS '0xB4000DB'
#define PJTASKID '0xB400017'
#define PJTASKIGNOREENDAR '0xB40018F'
#define PJTASKINDEX '0xB400168'
#define PJTASKINDICATORS '0xB4000CD'
#define PJTASKISASSIGNMENT '0xB4000E0'
#define PJTASKLATEFINISH '0xB400028'
#define PJTASKLATESTART '0xB400027'
#define PJTASKLEVELASSIGNMENTS '0xB4000FD'
#define PJTASKLEVELCANSPLIT '0xB4000FC'
#define PJTASKLEVELDELAY '0xB400014'
#define PJTASKLINKEDFIELDS '0xB400062'
#define PJTASKMARKED '0xB400047'
#define PJTASKMILESTONE '0xB400018'
#define PJTASKNAME '0xB40000E'
#define PJTASKNOTES '0xB40000F'
#define PJTASKNUMBER1 '0xB400057'
#define PJTASKNUMBER10 '0xB400132'
#define PJTASKNUMBER11 '0xB400133'
#define PJTASKNUMBER12 '0xB400134'
#define PJTASKNUMBER13 '0xB400135'
#define PJTASKNUMBER14 '0xB400136'
#define PJTASKNUMBER15 '0xB400137'
#define PJTASKNUMBER16 '0xB400138'
#define PJTASKNUMBER17 '0xB400139'
#define PJTASKNUMBER18 '0xB40013A'
#define PJTASKNUMBER19 '0xB40013B'
#define PJTASKNUMBER2 '0xB400058'
#define PJTASKNUMBER20 '0xB40013C'
#define PJTASKNUMBER3 '0xB400059'
#define PJTASKNUMBER4 '0xB40005A'
#define PJTASKNUMBER5 '0xB40005B'
#define PJTASKNUMBER6 '0xB40012E'
#define PJTASKNUMBER7 '0xB40012F'
#define PJTASKNUMBER8 '0xB400130'
#define PJTASKNUMBER9 '0xB400131'
#define PJTASKOBJECTS '0xB400061'
#define PJTASKOUTLINECODE1 '0xB4001A0'
#define PJTASKOUTLINECODE10 '0xB4001B2'
#define PJTASKOUTLINECODE2 '0xB4001A2'
#define PJTASKOUTLINECODE3 '0xB4001A4'
#define PJTASKOUTLINECODE4 '0xB4001A6'
#define PJTASKOUTLINECODE5 '0xB4001A8'
#define PJTASKOUTLINECODE6 '0xB4001AA'
#define PJTASKOUTLINECODE7 '0xB4001AC'
#define PJTASKOUTLINECODE8 '0xB4001AE'
#define PJTASKOUTLINECODE9 '0xB4001B0'
#define PJTASKOUTLINELEVEL '0xB400055'
#define PJTASKOUTLINENUMBER '0xB400066'
#define PJTASKOVERALLOCATED '0xB4000E1'
#define PJTASKOVERTIMECOST '0xB4000A8'
#define PJTASKOVERTIMEWORK '0xB4000A3'
#define PJTASKPARENTTASK '0xB400087'
#define PJTASKPERCENTCOMPLETE '0xB400020'
#define PJTASKPERCENTWORKCOMPLETE '0xB400021'
#define PJTASKPREDECESSORS '0xB40002F'
#define PJTASKPRELEVELEDFINISH '0xB400172'
#define PJTASKPRELEVELEDSTART '0xB400171'
#define PJTASKPRIORITY '0xB400019'
#define PJTASKPROJECT '0xB400054'
#define PJTASKRECURRING '0xB400081'
#define PJTASKREGULARWORK '0xB4000A6'
#define PJTASKREMAININGCOST '0xB40000A'
#define PJTASKREMAININGDURATION '0xB40001F'
#define PJTASKREMAININGOVERTIMECOST '0xB4000AA'
#define PJTASKREMAININGOVERTIMEWORK '0xB4000A5'
#define PJTASKREMAININGWORK '0xB400004'
#define PJTASKRESOURCEGROUP '0xB400071'
#define PJTASKRESOURCEINITIALS '0xB400032'
#define PJTASKRESOURCENAMES '0xB400031'
#define PJTASKRESOURCEPHONETICS '0xB40015D'
#define PJTASKRESOURCETYPE '0xB4001C3'
#define PJTASKRESPONSEPENDING '0xB4000FA'
#define PJTASKRESUME '0xB400063'
#define PJTASKRESUMENOEARLIERTHAN '0xB400065'
#define PJTASKROLLUP '0xB400052'
#define PJTASKSHEETNOTES '0xB40005E'
#define PJTASKSTART '0xB400023'
#define PJTASKSTART1 '0xB400034'
#define PJTASKSTART10 '0xB400122'
#define PJTASKSTART2 '0xB400037'
#define PJTASKSTART3 '0xB40003A'
#define PJTASKSTART4 '0xB40003D'
#define PJTASKSTART5 '0xB400040'
#define PJTASKSTART6 '0xB40011A'
#define PJTASKSTART7 '0xB40011C'
#define PJTASKSTART8 '0xB40011E'
#define PJTASKSTART9 '0xB400120'
#define PJTASKSTARTSLACK '0xB4001B6'
#define PJTASKSTARTVARIANCE '0xB40002D'
#define PJTASKSTOP '0xB400064'
#define PJTASKSUBPROJECT '0xB40001A'
#define PJTASKSUBPROJECTREADONLY '0xB4000F6'
#define PJTASKSUCCESSORS '0xB400030'
#define PJTASKSUMMARY '0xB40005C'
#define PJTASKSV '0xB40000D'
#define PJTASKTEAMSTATUSPENDING '0xB4000FB'
#define PJTASKTEXT1 '0xB400033'
#define PJTASKTEXT10 '0xB400046'
#define PJTASKTEXT11 '0xB40013D'
#define PJTASKTEXT12 '0xB40013E'
#define PJTASKTEXT13 '0xB40013F'
#define PJTASKTEXT14 '0xB400140'
#define PJTASKTEXT15 '0xB400141'
#define PJTASKTEXT16 '0xB400142'
#define PJTASKTEXT17 '0xB400143'
#define PJTASKTEXT18 '0xB400144'
#define PJTASKTEXT19 '0xB400145'
#define PJTASKTEXT2 '0xB400036'
#define PJTASKTEXT20 '0xB400146'
#define PJTASKTEXT21 '0xB400147'
#define PJTASKTEXT22 '0xB400148'
#define PJTASKTEXT23 '0xB400149'
#define PJTASKTEXT24 '0xB40014A'
#define PJTASKTEXT25 '0xB40014B'
#define PJTASKTEXT26 '0xB40014C'
#define PJTASKTEXT27 '0xB40014D'
#define PJTASKTEXT28 '0xB40014E'
#define PJTASKTEXT29 '0xB40014F'
#define PJTASKTEXT3 '0xB400039'
#define PJTASKTEXT30 '0xB400150'
#define PJTASKTEXT4 '0xB40003C'
#define PJTASKTEXT5 '0xB40003F'
#define PJTASKTEXT6 '0xB400042'
#define PJTASKTEXT7 '0xB400043'
#define PJTASKTEXT8 '0xB400044'
#define PJTASKTEXT9 '0xB400045'
#define PJTASKTOTALSLACK '0xB400016'
#define PJTASKTYPE '0xB400080'
#define PJTASKUNIQUEID '0xB400056'
#define PJTASKUNIQUEPREDECESSORS '0xB40005F'
#define PJTASKUNIQUESUCCESSORS '0xB400060'
#define PJTASKUPDATENEEDED '0xB40006F'
#define PJTASKVAC '0xB4001B9'
#define PJTASKWBS '0xB400010'
#define PJTASKWBSPREDECESSORS '0xB4001C1'
#define PJTASKWBSSUCCESSORS '0xB4001C2'
#define PJTASKWORK '0xB400000'
#define PJTASKWORKCONTOUR '0xB400100'
#define PJTASKWORKVARIANCE '0xB400003'



#endif

