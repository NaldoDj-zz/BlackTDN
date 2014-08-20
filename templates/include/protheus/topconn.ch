/*
	Header : topconn.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _TOPCONN_CH
#define _TOPCONN_CH

#xcommand TCQUERY <sql_expr>                                           ;
                  [ALIAS <a>]                                           ;
                  [<new: NEW>]                                          ;
                  [SERVER <(server)>]                                   ;
                  [ENVIRONMENT <(environment)>]                         ;
                                                                        ;
      => dbUseArea(                                                     ;
                    <.new.>,                                            ;
                    "TOPCONN",                                          ;
                    TCGENQRY(<(server)>,<(environment)>,<sql_expr>),   ;
                    <(a)>, .F., .T.)                                    
					
#endif										

