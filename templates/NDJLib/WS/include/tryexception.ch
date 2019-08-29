#IFNDEF _TRYEXCEPTION_CH

    #DEFINE _TRYEXCEPTION_CH

    /*/
        Autor:Marinaldo de Jesus
        Data:07/10/2009
        Descricao:Comandos para Simular TRY & CATCH EXCEPTION em ADVPL

    /*/
    #DEFINE TRY_ERROR_BLOCK     1
    #DEFINE TRY_SYSERROR_BLOCK  2
    #DEFINE TRY_INDEX           3
    #DEFINE TRY_OBJERROR        4
    #DEFINE TRY_ERROR_MESSAGE   5
    #DEFINE TRY_SET_BELL        6

    #DEFINE TRY_ELEMENTS        6
    
    #XTRANSLATE    TRY EXCEPTION    => TRYEXCEPTION
    #XTRANSLATE    CATCH EXCEPTION  => CATCHEXCEPTION
    #XTRANSLATE    END TRY          => ENDEXCEPTION
    #XTRANSLATE    ENDTRY           => ENDEXCEPTION
    #XTRANSLATE    END EXCEPTION    => ENDEXCEPTION

    #IFNDEF _SET_BELL
        #DEFINE _SET_BELL   26
    #ENDIF   

    #XCOMMAND TRYEXCEPTION  => ;
        if(!(Type("aTryException")=="A").or.!(Type("nTryException")=="N"),PutTryExceptionVars(),nil) ;;
        aAdd(&("aTryException"),Array(TRY_ELEMENTS)) ;;
        &("++nTryException") ;;
        &("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\]:=Set(_SET_BELL,"OFF") ;;
        &("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\]:=ErrorBlock(\{\|oError\|BREAK(@oError)\}) ;;
        &("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\]:=SysErrorBlock(\{\|oError\|BREAK(@oError)\}) ;;
        &("aTryException")\[&("nTryException")\]\[TRY_INDEX\]:=&("nTryException") ;;
        ErrorBlock(\{\|oError\|&("aTryException")\[&("nTryException")\]\[TRY_OBJERROR\]:=oError,BREAK(@oError)\}) ;;
        SysErrorBlock(\{\|oError\|&("aTryException")\[&("nTryException")\]\[TRY_OBJERROR\]:=oError,BREAK(@oError)\}) ;;
        BEGIN SEQUENCE ;;
    
    #XCOMMAND TRYEXCEPTION USING <bError> [PARAMETERS <aParameters>] => ;
        if(!(Type("aTryException")=="A").or.!(Type("nTryException")=="N"),PutTryExceptionVars(),nil) ;;
        aAdd(&("aTryException"),Array(TRY_ELEMENTS)) ;;
        &("++nTryException") ;;
        &("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\]:=Set(_SET_BELL,"OFF") ;;
        &("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\]:=ErrorBlock(\{\|oError\|BREAK(@oError)\}) ;;
        &("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\]:=SysErrorBlock(\{\|oError\|BREAK(@oError)\}) ;;
        &("aTryException")\[&("nTryException")\]\[TRY_INDEX\]:=&("nTryException") ;;
        ErrorBlock(\{\|oError\|&("aTryException")\[&("nTryException")\]\[TRY_OBJERROR\]:=oError,Eval(<bError>,@oError,[@<aParameters>])\}) ;;
        SysErrorBlock(\{\|oError\|&("aTryException")\[&("nTryException")\]\[TRY_OBJERROR\]:=oError,Eval(<bError>,@oError,[@<aParameters>])\}) ;;
        BEGIN SEQUENCE ;;

    #XCOMMAND CATCHEXCEPTION    =>  ;
            &("aTryException")\[&("nTryException")\]\[TRY_ERROR_MESSAGE\]:=CaptureError(.T.,&("nTryException"),&("nTryException"),1) ;; 
            RECOVER ;;
    
    #XCOMMAND CATCHEXCEPTION USING <oException> => ;
        RECOVER ;;
        &("aTryException")\[&("nTryException")\]\[TRY_ERROR_MESSAGE\]:=CaptureError(.T.,&("nTryException"),&("nTryException"),1) ;; 
        <oException>:=&("aTryException")\[&("nTryException")\]\[TRY_OBJERROR\] ;;
    
    #XCOMMAND ENDEXCEPTION        => ;
        END SEQUENCE ;;
        if ((Type("aTryException")=="A").and.(Type("nTryException")=="N")) ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\])=="B") ;;
                ErrorBlock(&("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\]) ;;
            endif ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\])=="B") ;;
                SysErrorBlock(&("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\]) ;;
            endif ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\])=="L") ;;
                if (&("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\]) ;;
                    Set(_SET_BELL,"ON") ;;
                endif ;;    
            endif ;;            
            aDel(&("aTryException"),&("nTryException")) ;;
            aSize(&("aTryException"),&("--nTryException")) ;;
        endif ;;

    #XCOMMAND ENDEXCEPTION NODELSTACKERROR  => ;
        END SEQUENCE ;;
        if ((Type("aTryException")=="A").and.(Type("nTryException")=="N")) ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\])=="B") ;;
                ErrorBlock(&("aTryException")\[&("nTryException")\]\[TRY_ERROR_BLOCK\]) ;;
            endif ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\])=="B") ;;
                SysErrorBlock(&("aTryException")\[&("nTryException")\]\[TRY_SYSERROR_BLOCK\]) ;;
            endif ;;
            if (ValType(&("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\])=="L") ;;
                if (&("aTryException")\[&("nTryException")\]\[TRY_SET_BELL\]) ;;
                    Set(_SET_BELL,"ON") ;;
                endif ;;    
            endif ;;
            &("--nTryException") ;;
        endif ;;
 
    static procedure PutTryExceptionVars() 
        local aStacks          as array
        local nStacks          as numeric 
        local lTryException    as logical
        lTryException:=((Type("aTryException")=="A").and.(Type("nTryException")=="N"))
        if (!lTryException)
            aStacks:=GetCStack(0)
            nStacks:=len(aStacks)
            _SetNamedPrvt("aTryException",array(0),aStacks[nStacks])
            _SetNamedPrvt("nTryException",0,aStacks[nStacks])
        endif
    return
    
    static function GetCStack(nStart as numeric) as array

        local aCallStack    as array
    
        local cCallStack    as character
    
        local nCallStack    as numeric
    
        DEFAULT nStart:=0
    
        nCallStack:=nStart
        aCallStack:=array(0)
        while (cCallStack:=ProcName(++nCallStack),.NOT.(Empty(cCallStack)))
            aAdd(aCallStack,cCallStack)
        end while
    
    return(aCallStack)
    
    static function CaptureError(lObjError as logical,nStart as numeric,nFinish as numeric,nStep as numeric) as character
        
        local cError        as character
        
        local lObj          as logical
        local lTryException as logical
        
        local nS            as numeric
        local nF            as numeric
        local nP            as numeric
        
        local nError        as numeric
        
        cError:=""
        lTryException:=((Type("aTryException")=="A").and.(Type("nTryException")=="N"))
        if (lTryException)
            lObj:=if((lObjError==nil),.F.,lObjError)
            nS:=max(if((nStart==nil),1,nStart),1)
            nF:=min(if((nFinish==nil),len(&("aTryException")),nFinish),len(&("aTryException")))
            nP:=if((nStep==nil),1,nStep)
            for nError:=nS to nF step nP
                if (lObjError)
                    if (ValType(&("aTryException")[nError][TRY_OBJERROR])=='O')
                        cError+=&("aTryException")[nError][TRY_OBJERROR]:Description
                        cError+=&("aTryException")[nError][TRY_OBJERROR]:ErrorStack
                        cError+=&("aTryException")[nError][TRY_OBJERROR]:ErrorEnv
                    endif
                else
                    if (ValType(&("aTryException")[nError][TRY_ERROR_MESSAGE])=='C')
                        cError+=&("aTryException")[nError][TRY_ERROR_MESSAGE]
                    endif
                endif    
            next nError
        endif
        return(cError)
    
    static function __tryDummy()
        if (.F.)
            __tryDummy()
            CaptureError()
            PutTryExceptionVars()
        endif
    return(.F.)

#ENDIF
