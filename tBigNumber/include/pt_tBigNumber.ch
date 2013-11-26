#IFNDEF _pt_TBigNumber_CH

    #DEFINE _pt_TBigNumber_CH

    #IFDEF __PROTHEUS__

        #INCLUDE "protheus.ch"

        #xtranslate THREAD Static => Static
        #xtranslate hb_ntos( <n> ) => LTrim( Str( <n> ) )
        #xtranslate USER PROCEDURE => USER FUNCTION

        #xcommand DEFAULT =>
        /* Default parameters management */
        #xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                    => ;
                    <uVar1> := iif( <uVar1> == NIL, <uVal1>, <uVar1> ) ;
                    [; <uVarN> := iif( <uVarN> == NIL, <uValN>, <uVarN> ) ]


        #IFNDEF CRLF
            #DEFINE CRLF CHR(13)+CHR(10)
        #ENDIF
    
    #ENDIF
    
#ENDIF