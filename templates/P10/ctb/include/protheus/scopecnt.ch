#IFNDEF _SCOPECNT_CH
	
	#DEFINE _SCOPECNT_CH

	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁBegin Constantes Manifestas para aScop em CountScope()		  Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
		#DEFINE ASCOPE_FOR_COND      1
		#DEFINE ASCOPE_WHILE_COND    2
		#DEFINE ASCOPE_NEXT_SCOPE    3
		#DEFINE ASCOPE_REC_SCOPE     4
		#DEFINE ASCOPE_REST_SCOPE    5
		
		#COMMAND CREATE SCOPE <aScope> [FOR <for>] ;
				[WHILE <while>] [NEXT <next>] [RECORD <rec>] ;
				[<rest:REST>] [ALL];
		        =>;
				<aScope> := { <{for}>, <{while}>, <next>, ;
				<rec>, <.rest.> }
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁEnd Constantes Manifestas para aScop em CountScope()		  Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

#ENDIF