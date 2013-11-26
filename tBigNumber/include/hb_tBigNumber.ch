#IFNDEF _hb_TBigNumber_CH

    #DEFINE _hb_TBigNumber_CH

    #IFDEF __HARBOUR__
        #INCLUDE "common.ch"
        #INCLUDE "hbclass.ch"
*        #INCLUDE "hbCompat.ch"
        #IFDEF TBN_DBFILE
            #IFNDEF TBN_MEMIO
                REQUEST DBFCDX , DBFFPT
            #ELSE
                #require "hbmemio"
                REQUEST HB_MEMIO
            #ENDIF
        #ENDIF

        #IFNDEF __XHARBOUR__
            #INCLUDE "xhb.ch" //add xHarbour emulation to Harbour
        #ENDIF
        
        #xtranslate tbNCurrentFolder() => (hb_CurDrive()+hb_osDriveSeparator()+hb_ps()+CurDir())

        #xcommand DEFAULT =>

        /* Default parameters management */
        #if defined( __ARCH64BIT__ ) .or. defined( __PLATFORM__WINCE )
          #xcommand DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        <uVar1> := iif( <uVar1> == NIL, <uVal1>, <uVar1> ) ;
                        [; <uVarN> := iif( <uVarN> == NIL, <uValN>, <uVarN> ) ]
        #else
            #xtranslate DEFAULT <uVar1> := <uVal1> [, <uVarN> := <uValN> ] ;
                        => ;
                        iif( <uVar1> == NIL , hb_Default(@<uVar1>,<uVal1>) , );
                        [; iif( <uVarN> == NIL , hb_Default(@<uVarN>,<uValN>) , ) ]
        #endif

        #IFNDEF CRLF
            #DEFINE CRLF hb_eol()
        #ENDIF
    
    #ENDIF
    
#ENDIF