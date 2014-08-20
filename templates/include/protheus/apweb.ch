#COMMAND APWEB INIT <cHtml> USING <_P1> , <_P2> , <_P3> , <_P4> ;
         [ TABLES <aFiles,...>] ;
         [ TIMEOUT <tOut>] ;
         [ START <cInit>] ;
         [ CACHE <cId>] ;
         [ EXPIRES <cExpKey>] ;
         [ <lKill: NOTHREAD> ] => ;
         BEGIN SEQUENCE ;;
         If !HTMLInitEnv(@<_P1>,@<_P2>,@<_P3>,@<_P4>,@<cHtml>, [<cInit> ], [\{ <aFiles> \} ] , [<tOut> ] , [<cId> ] , [<cExpKey> ] , [<.lKill.>]) ;;
            Return <cHtml> ;;
         Endif 
         
#COMMAND APWEB END <cHtml> => ;
         END SEQUENCE;;
         HTMLEndEnv( @<cHtml> )
