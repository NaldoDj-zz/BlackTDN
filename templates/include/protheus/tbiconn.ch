
/*
	Header : tbiconn.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _AP5MAIL_CH_
	#include 'Ap5Mail.ch'
#endif

#ifndef _TBICONN_CH
#define _TBICONN_CH

#xcommand CREATE RPCCONN <oSrv> ;
			ON SERVER <cRpcServer> ;
          	PORT <nRpcPort>  ;
          	ENVIRONMENT <cRpcEnv> ;
          	EMPRESA <cRpcEmp> ;
          	FILIAL <cRpcFil> ;
            [ MODULO <cRpcMod>	    ]  ;			
          	[ TABLES <aTables,...>  ]  ;
			[ FUNNAME <cEnvFunName> ]  ;
			[ <lClean: CLEAN> ]        ;
			=> ;
        	<oSrv> := RpcConnect( <cRpcServer>		, ;
        						  <nRpcPort>  		, ;
                              	  <cRpcEnv>   		, ;
                                  <cRpcEmp>   		, ;
                                  <cRpcFil>   		, ;
								  [\{ <aTables> \} ], ;
								  [<cEnvFunName>]	, ;
								  [ <.lClean.> ]    , ;
								  [ <cRpcMod>  ] )	
	
#xcommand CLOSE RPCCONN <oSrv>										;
			=>	;
			RpcDisconnect( <oSrv> )									;
			
#xcommand PREPARE ENVIRONMENT [ IN <lRemote: SERVER> <oEnvSrv> ] 	;
					EMPRESA <cEnvEmp>								;
					FILIAL <cEnvFil>								;
					[ USER <cEnvUser>        ]						;
					[ PASSWORD <cEnvPass>    ]						;
                    [ MODULO <cEnvMod>	     ]						;
					[ FUNNAME <cEnvFunName>  ]						;
					[ TABLES <aEnvTables,...>]						;					
			=>	;
				If ( <.lRemote.> )				   					;;
					[ <oEnvSrv>:]CallProc( 'RpcSetEnv', <cEnvEmp>, <cEnvFil>, <cEnvUser>, <cEnvPass>, <cEnvMod>, <cEnvFunName>, \{ <aEnvTables> \} )	;	;
				Else												;;
					RpcSetEnv( <cEnvEmp>, <cEnvFil>, <cEnvUser>, <cEnvPass>, <cEnvMod>, <cEnvFunName>, \{ <aEnvTables> \} )	;	;
				EndIf													;;

#xcommand RESET ENVIRONMENT [ IN <lRemote: SERVER> <oEnvSrv> ] 		;
			=>	;                                                   
				If ( <.lRemote.> )									;;
					[ <oEnvSrv>:]CallProc( 'RpcClearEnv' )			;;
				Else												;;
					RpcClearEnv( )									;;
				EndIf												;;
								  
#xcommand OPEN REMOTE TRANSACTION <cRpcIdTTS> IN <oSrv> BY NAME <cRpcProcess> PARAMETERS [ <aRpcParams,...> ] ;
			=> ;
			BEGIN SEQUENCE ; BeginTran() ;<cRpcIdTTS> := RpcBeginTran( <oSrv>, <cRpcIdTTS>, <cRpcProcess>, [\{ <aRpcParams> \}] );

#xcommand CLOSE REMOTE TRANSACTION <cRpcIdTTS> CHECKSUM <cCheckSum> IN <oSrv> ;
			=> ;
			<cCheckSum> := RpcEndTran( <oSrv>, <cRpcIdTTS> ) ;EndTran() ;END SEQUENCE ; IF RpcRemoteErr(); <oSrv>:CallProc( 'DisarmTransaction' ) ;  DisarmTransaction();Endif;
			
#xcommand CALLPROC IN <oServer> 											;
				FUNCTION <cFunction> 	 			   						;
				[ PARAMETERS <uParam1> ] [, <uParamN> ] 					;
				[RESULT <xResult> ] 										;
			=> 																;
				[ <xResult> := ] <oServer>:CallProc( <cFunction> [, <uParam1> ] [, <uParamN> ] )	;;
                If RpcRemoteErr()											;; 
					BREAK													;;
				EndIf														;;

#xcommand OPEN REMOTE TABLES <aRpcTables,...>								;
				[ IN <lRemote: SERVER> <oRpcSrv> ] 							;
			=>	;                                                           
				If ( <.lRemote.> )												;;
					[<oRpcSrv>:]CallProc( 'RpcOpenTables', \{ <aRpcTables> \} ) ;; 
				Else															;;
                    RpcOpenTables ( \{ <aRpcTables> \} )                        ;;                  
				EndIf															;;

#endif

