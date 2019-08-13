#ifndef __PARAMTYPE_CH

    #define __PARAMTYPE_CH

    #xcommand PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text> [ MESSAGE <message> ] ;
        => ;
        if .NOT.(Empty(<message>)) ;;
            [ UserException(<message>) ] ;;
        elseif .NOT.(Empty(<param>)) ;;
            [ UserException("argument #"+<"param">+" error, expected "+<text>) ] ;;
        else ;;
            UserException("argument error in parameter "+<"varname">+", expected "+<text>) ;;
        endif ;;

    #xcommand CLASSPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text> [ MESSAGE <message> ] ;
        => ;
        if .NOT.(Empty(<message>)) ;;
            [ UserException(<message>) ] ;;
        elseif .NOT.(Empty(<param>)) ;;
            [ UserException("argument #"+<"param">+" error, class expected "+<text>) ] ;;
        else ;;
            UserException("argument error in parameter "+<"varname">+", class expected "+<text>) ;;
        endif ;;

    #xcommand BLOCKPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text> [ MESSAGE <message> ] ;
        => ;
        if .NOT.(Empty(<message>)) ;;
            [ UserException(<message>) ] ;;
        elseif .NOT.(Empty(<param>)) ;;
            [ UserException("argument #"+<"param">+" error , return expected "+<text>) ] ;;
        else ;;
            UserException("argument error in block "+<"varname">+", return expected "+<text>) ;;
        endif ;;

    #xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,LOGIC,OBJECT,POINTER,UNDEFINED> ;
        [ , <typeN: ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,LOGIC,OBJECT,POINTER,UNDEFINED> ] ;
        [ MESSAGE <message> ] ;
        [ <optional: OPTIONAL> ] ;
        [ DEFAULT <uVar> ] ;
        => ;
        if (<.optional.>);;
            <varname> := if(<varname> == NIL,<uVar>,<varname>);;
        endif;;
        if .NOT.(<.optional.> .and. ValType(<varname>) == "U") .and. .NOT.(ValType(<varname>) $ SubStr(<"type">,1,1) [ + SubStr(<"typeN">,1,1) ]) ;;
            if .NOT.("U" $ SubStr(<"type">,1,1) [ + SubStr(<"typeN">,1,1) ]) ;;
                PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT SubStr(<"type">,1,1) [ + "," + SubStr(<"typeN">,1,1) ]+"->"+ValType(<varname>) [ MESSAGE <message> ] ;;
            endif ;;
        endif ;;

    #xcommand PARAMTYPE [ <param> VAR ] <varname> AS BLOCK EXPECTED <expected: ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,LOGIC,OBJECT,POINTER,UNDEFINED> ;
        [ MESSAGE <message> ] ;
        [ <optional: OPTIONAL> ] ;
        => ;
        if ValType(<varname>) == "B" ;;
            __block := Eval(<varname>)  ;;
            if ValType(__block) <> SubStr(<"expected">,1,1)  ;;
                if .NOT.("U" $ SubStr(<"expected">,1,1)) ;;
                    BLOCKPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT SubStr(<"expected">,1,1) + "->"+ValType(__block) [ MESSAGE <message> ] ;;
                endif ;;
            endif ;;
        Elseif .NOT.(<.optional.> .and. ValType(<varname>) == "U") ;;
            PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT "B->"+ValType(<varname>) [ MESSAGE <message> ] ;;
        endif

    #xcommand PARAMTYPE [ <param> VAR ] <varname> AS OBJECT CLASS <classname> ;
        [ MESSAGE <message> ] ;
        [ <optional: OPTIONAL> ] ;
        [ DEFAULT <uVar> ] ;
        => ;
        if (<.optional.>);;
            <varname> := if(<varname> == NIL,<uVar>,<varname>);;
        endif;;
        if ValType(<varname>) == "O" ;;
            __erro := ErrorBlock({||"UNDEFINED"}) ;;
            BEGIN SEQUENCE ;;
            __classname := Upper(<varname>:ClassName()) ;;
            END SEQUENCE ;;
            ErrorBlock(__erro)  ;;
            if .NOT.(__classname $ Upper(<classname>)) ;;
                CLASSPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <classname> [ MESSAGE <message> ] ;;
            endif ;;
        Elseif .NOT.(<.optional.> .and. ValType(<varname>) == "U") ;;
            PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT "O->"+ValType(<varname>) [ MESSAGE <message> ] ;;
        endif ;;

    #xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,LOGIC,POINTER,UNDEFINED> ;
        [ , <typeN: ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,LOGIC,POINTER,UNDEFINED> ] ;
        OR OBJECT CLASS <classname> ;
        [ MESSAGE <message> ] ;
        [ <optional: OPTIONAL> ] ;
        [ DEFAULT <uVar> ] ;
        => ;
        if (<.optional.>);;
            <varname> := if(<varname> == NIL,<uVar>,<varname>);;
        endif;;
        if ValType(<varname>) == "O" ;;
            PARAMTYPE [ <param> VAR ] <varname> AS OBJECT CLASS <classname> [ MESSAGE <message> ] [ <optional> ] [ DEFAULT <uVar> ] ;;
        Else ;;
            PARAMTYPE [ <param> VAR ] <varname> AS <type> [, <typeN>] [ MESSAGE <message> ] [ <optional> ] [ DEFAULT <uVar> ] ;;
        endif

        // ============================================================================
        // Strongly Typed Variables     (c) 1996-1997, Bryan Duchesne
        // ============================================================================
        /*
         * Adapted for ADVPL by Marinaldo de Jesus [http://www.blacktdn.com.br] - 2012
        */

        // This command replaces the traditional := assignment
        #ifdef PTEX_ASSIGN_VAR
            #xtranslate ASSIGN <cVar> =  <uVal> => <cVar> := __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> := <uVal> => <cVar> := __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> += <uVal> => <cVar> += __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> -= <uVal> => <cVar> -= __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> *= <uVal> => <cVar> *= __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> /= <uVal> => <cVar> /= __IsTyped( <"cVar"> , <cVar> , <uVal> )
            #xtranslate ASSIGN <cVar> %= <uVal> => <cVar> %= __IsTyped( <"cVar"> , <cVar> , <uVal> )
        #ELSE
            #xtranslate ASSIGN <cVar> =  <uVal> => <cVar> := <uVal>
            #xtranslate ASSIGN <cVar> := <uVal> => <cVar> := <uVal>
            #xtranslate ASSIGN <cVar> += <uVal> => <cVar> += <uVal>
            #xtranslate ASSIGN <cVar> -= <uVal> => <cVar> -= <uVal>
            #xtranslate ASSIGN <cVar> *= <uVal> => <cVar> *= <uVal>
            #xtranslate ASSIGN <cVar> /= <uVal> => <cVar> /= <uVal>
            #xtranslate ASSIGN <cVar> %= <uVal> => <cVar> %= <uVal>
        #endif


        // declare your variables as strongly typed
        // ============================================================================

        #xcommand LOCAL <varname> AS <type:ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,OBJECT,POINTER,UNDEFINED>;
        [CLASS <classname>];
        [MESSAGE <message>];
        [VALUE <uVal>];
        => ;
        LOCAL <varname> := __SetType(<"varname">,<"type">,<uVal>,<classname>,<message>)

        #xcommand STATIC <varname> AS <type:ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,OBJECT,POINTER,UNDEFINED>;
        [CLASS <classname>];
        [MESSAGE <message>];
        [VALUE <uVal>];
        => ;
        STATIC <varname> := __SetType(<"varname">,<"type">,<uVal>,<classname>,<message>)

        #xcommand PUBLIC <varname> AS <type:ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,OBJECT,POINTER,UNDEFINED>;
        [CLASS <classname>];
        [MESSAGE <message>];
        [VALUE <uVal>];
        => ;
        PUBLIC <varname> := __SetType(<"varname">,<"type">,<uVal>,<classname>,<message>)

        #xcommand PRIVATE <varname> AS <type:ARRAY,BLOCK,CHARACTER,DATE,HASH,NUMERIC,NUMBER,LOGICAL,OBJECT,POINTER,UNDEFINED>;
        [CLASS <classname>];
        [MESSAGE <message>];
        [VALUE <uVal>];
        => ;
        PRIVATE <varname> := __SetType(<"varname">,<"type">,<uVal>,<classname>,<message>)

        /*
            Include : ParamType.ch
            Funcao  : __SetType
            Autor   : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
            Data    : 29/07/2012
            Uso     : Strongly Typed Variables
        */
        Static Function __SetType( cVarName , cTypeVar , uVal , cClassName , cMessage )

            Local cTypeVal    := ValType(uVal)
            Local xRetVal

            cTypeVar        := Upper(SubStr(cTypeVar,1,1))

            if .NOT.( cTypeVal == "U" )
                if ( .NOT.( cTypeVar == "U" ) .and. .NOT.( cTypeVar == cTypeVal ) )
                    UserException( "Variable ("+cVarName+") assignment: Data Type Mismatch. Expected ("+cTypeVar+") assigned ("+cTypeVal+")"  )
                endif
            endif

            if ( cTypeVar == "O" )
                if Empty(cClassName)
                    if Empty(cMessage)
                        cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                    endif
                    PARAMTYPE cVarName VAR xRetVal AS OBJECT DEFAULT uVal OPTIONAL MESSAGE (cMessage)
                Else
                    if Empty(cMessage)
                        cMessage := "argument error in object ("+cVarName+"), class expected ("+cClassName+")"
                    endif
                    PARAMTYPE cVarName VAR xRetVal AS OBJECT CLASS (cClassName) DEFAULT uVal OPTIONAL MESSAGE (cMessage)
                endif
            Elseif ( cTypeVar == "C" )
                uVal := if( uVal == NIL , "" , uVal )
                if Empty(cMessage)
                   cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS CHARACTER DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "N" )
                uVal := if( uVal == NIL , 0 , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS NUMERIC   DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "L" )
                uVal := if( uVal == NIL , .F. , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS LOGICAL   DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "D" )
                uVal := if( uVal == NIL , Ctod("") , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS DATE      DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "B" )
                uVal := if( uVal == NIL , {||NIL} , uVal )
                if Empty(cMessage)
                    cMessage    := "argument error in block ("+cVarName+"), return expected "
                endif
                PARAMTYPE cVarName VAR xRetVal AS BLOCK     DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "A" )
                uVal := if( uVal == NIL , Array(0) , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS ARRAY     DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "H" )
                uVal := if( uVal == NIL , Hash() , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS HASH DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            Elseif ( cTypeVar == "P" )
                uVal := if( uVal == NIL , 0 , uVal )
                if Empty(cMessage)
                    cMessage := "argument error in variable ("+cVarName+"), expected ("+cTypeVar+") assigned ("+cTypeVal+")"
                endif
                PARAMTYPE cVarName VAR xRetVal AS POINTER DEFAULT uVal OPTIONAL MESSAGE (cMessage)
            endif

        Return( xRetVal )

        #ifdef PTEX_ASSIGN_VAR
            /*
                Include : ParamType.ch
                Funcao  : __IsTyped
                Autor   : Marinaldo de Jesus [ http://www.blacktdn.com.br ]
                Data    : 29/07/2012
                Uso     : Strongly Typed Variables
            */
            Static Function __IsTyped( cVarName , uVar , uVal , cMessage )

                   Local bErrorBlock

                   Local cTypeVar    := ValType(uVar)
                   Local cTypeVal    := ValType(uVal)

                   Local cClassName

                   BEGIN SEQUENCE

                       if ( cTypeVar == "U" )
                           BREAK
                       endif

                       if .NOT.( cTypeVar == cTypeVal )
                           UserException( "Variable ("+cVarName+") assignment: Data Type Mismatch. Expected ("+cTypeVar+") assigned ("+cTypeVal+")"  )
                       endif

                    if ( cTypeVar == "O" )
                        bErrorBlock := ErrorBlock({||"UNDEFINED"})
                        BEGIN SEQUENCE
                            cClassName := Upper( uVar:ClassName() )
                        END SEQUENCE
                        ErrorBlock( bErrorBlock )
                    endif

                    __SetType( cVarName , cTypeVar , uVal , cClassName , cMessage )

                END SEQUENCE

            Return( uVal )

        #endif

        #ifdef __HARBOUR__
            #include "error.ch"
            Static Function UserException(cDescription)
                Local e         := ErrorNew()
                e:description   := cDescription
                e:gencode       := EG_ARG
                e:severity      := ES_ERROR
                e:cansubstitute := .T.
                e:subsystem     := ProcName(1)
                #ifdef HB_CLP_STRICT
                    HB_SYMBOL_UNUSED(cMethod )
                #else
                    e:operation := "ASSIGN"
                #endif
                e:subcode       := 0
                e:args          := hb_aParams(1)
            Return(Throw(e))
        #endif

#endif /*__PARAMTYPE_CH*/
