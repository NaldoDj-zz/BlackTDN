#IFNDEF _TBigNumber_CH

    #DEFINE _TBigNumber_CH

    #DEFINE OPERATOR_ADD            { '+' , 'add' }
    #DEFINE OPERATOR_SUBTRACT       { '-' , 'sub' }
    #DEFINE OPERATOR_MULTIPLY       { '*' , 'x' , 'mult' }
    #DEFINE OPERATOR_DIVIDE         { '/' , ':' , 'div'  }
    #DEFINE OPERATOR_POW            { '^' , '**' , 'xx' , 'pow' }
    #DEFINE OPERATOR_MOD            { '%' , 'mod' }
    #DEFINE OPERATOR_EXP            { 'exp' }
    #DEFINE OPERATOR_SQRT           { 'sqrt' }
    #DEFINE OPERATOR_ROOT           { 'root' }

    #DEFINE OPERATORS               {;
                                        OPERATOR_ADD,      ;
                                        OPERATOR_SUBTRACT, ;
                                        OPERATOR_MULTIPLY, ;
                                        OPERATOR_DIVIDE,   ;    
                                        OPERATOR_POW,      ;
                                        OPERATOR_MOD,      ;
                                        OPERATOR_EXP,      ;
                                        OPERATOR_SQRT,     ;
                                        OPERATOR_ROOT,     ;
                                    }

    #IFDEF PROTHEUS
        #DEFINE __PROTHEUS__        
        #INCLUDE "pt_tBigNumber.ch"
    #ELSE
        #IFDEF __HARBOUR__
            #INCLUDE "hb_tBigNumber.ch"
        #ENDIF
    #ENDIF

    #INCLUDE "set.ch"
    #INCLUDE "fileio.ch"

    #DEFINE MAX_DECIMAL_PRECISION    999999999999999 //999.999.999.999.999

    /* by default create ST version */
    #IFNDEF __ST__
        #IFNDEF __MT__
          #DEFINE __ST__
       #ENDIF
    #ENDIF

    #IFNDEF SYMBOL_UNUSED
        #DEFINE SYMBOL_UNUSED( symbol ) ( symbol := ( symbol ) )
    #ENDIF

#ENDIF