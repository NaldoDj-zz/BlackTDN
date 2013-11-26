/*
	Header : stdwin.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _SET_CH
   #include "Set.ch"
#endif

#ifndef _STDWIN_CH
#define _STDWIN_CH

#command DO WHILE <exp>         => while <exp>

#command END <x>                => end
#command END SEQUENCE           => end
#command ENDSEQUENCE            => end
#command ENDDO    <*x*>         => enddo
#command ENDIF    <*x*>         => endif
#command ENDCASE  <*x*>         => endcase
#command ENDFOR [ <*x*> ]       => next

#command NEXT <v> [TO <x>] [STEP <s>]                                   ;
      => next

#command DO <proc>.PRG [WITH <list,...>]                                ;
      => do <proc> [ WITH <list>]

#command CALL <proc>() [WITH <list,...>]                                ;
      => call <proc> [ WITH <list>]

#command STORE <value> TO <var1> [, <varN> ]                            ;
      => <var1> := [ <varN> := ] <value>

#command EJECT                  => __Eject()

#command SET ECHO <*x*>         =>
#command SET HEADING <*x*>      =>
#command SET MENU <*x*>         =>
#command SET STATUS <*x*>       =>
#command SET STEP <*x*>         =>
#command SET SAFETY <*x*>       =>
#command SET TALK <*x*>         =>
#command SET PROCEDURE TO       =>
#command SET PROCEDURE TO <f>   =>  _ProcReq_( <(f)> )

#command SET EXACT <x:ON,OFF,&>         => Set( _SET_EXACT, <(x)> )
#command SET EXACT (<x>)                => Set( _SET_EXACT, <x> )

#command SET FIXED <x:ON,OFF,&>         => Set( _SET_FIXED, <(x)> )
#command SET FIXED (<x>)                => Set( _SET_FIXED, <x> )

#command SET DECIMALS TO <x>            => Set( _SET_DECIMALS, <x> )
#command SET DECIMALS TO                => Set( _SET_DECIMALS, 0 )

#command SET PATH TO <*path*>           => Set( _SET_PATH, <(path)> )
#command SET PATH TO                    => Set( _SET_PATH, "" )

#command SET DEFAULT TO <(path)>        => Set( _SET_DEFAULT, <(path)> )
#command SET DEFAULT TO                 => Set( _SET_DEFAULT, "" )

#command SET CENTURY <x:ON,OFF,&>       => __SetCentury( <(x)> )
#command SET CENTURY (<x>)              => __SetCentury( <x> )
#command SET EPOCH TO <year>            => Set( _SET_EPOCH, <year> )
#command SET DATE FORMAT [TO] <c>       => Set( _SET_DATEFORMAT, <c> )

#define  _DFSET(x, y)  Set( _SET_DATEFORMAT, if(__SetCentury(), x, y) )

#command SET DATE [TO] AMERICAN         => _DFSET( "mm/dd/yyyy", "mm/dd/yy" )
#command SET DATE [TO] ANSI             => _DFSET( "yyyy.mm.dd", "yy.mm.dd" )
#command SET DATE [TO] BRITISH          => _DFSET( "dd/mm/yyyy", "dd/mm/yy" )
#command SET DATE [TO] FRENCH           => _DFSET( "dd/mm/yyyy", "dd/mm/yy" )
#command SET DATE [TO] GERMAN           => _DFSET( "dd.mm.yyyy", "dd.mm.yy" )
#command SET DATE [TO] ITALIAN          => _DFSET( "dd-mm-yyyy", "dd-mm-yy" )
#command SET DATE [TO] JAPANESE         => _DFSET( "yyyy/mm/dd", "yy/mm/dd" )
#command SET DATE [TO] USA              => _DFSET( "mm-dd-yyyy", "mm-dd-yy" )

#command SET ALTERNATE <x:ON,OFF,&>     => Set( _SET_ALTERNATE, <(x)> )
#command SET ALTERNATE (<x>)            => Set( _SET_ALTERNATE, <x> )

#command SET ALTERNATE TO               => Set( _SET_ALTFILE, "" )

#command SET ALTERNATE TO <(file)> [<add: ADDITIVE>]                    ;
      => Set( _SET_ALTFILE, <(file)>, <.add.> )

#command SET CONSOLE <x:ON,OFF,&>       => Set( _SET_CONSOLE, <(x)> )
#command SET CONSOLE (<x>)              => Set( _SET_CONSOLE, <x> )

#command SET MARGIN TO <x>              => Set( _SET_MARGIN, <x> )
#command SET MARGIN TO                  => Set( _SET_MARGIN, 0 )

#command SET PRINTER <x:ON,OFF,&>       => Set( _SET_PRINTER, <(x)> )
#command SET PRINTER (<x>)              => Set( _SET_PRINTER, <x> )

#command SET PRINTER TO                 => Set( _SET_PRINTFILE, "" )

#command SET PRINTER TO <(file)> [<add: ADDITIVE>]                      ;
      => Set( _SET_PRINTFILE, <(file)>, <.add.> )

#command SET DEVICE TO SCREEN           => Set( _SET_DEVICE, "SCREEN" )
#command SET DEVICE TO PRINTER          => Set( _SET_DEVICE, "PRINTER" )

#command SET COLOR TO [<*spec*>]        => SetColor( #<spec> )
#command SET COLOR TO ( <c> )           => SetColor( <c> )
#command SET COLOUR TO [<*spec*>]       => SET COLOR TO [<spec>]

#command SET CURSOR <x:ON,OFF,&>                                        ;
      => SetCursor( if(Upper(<(x)>) == "ON", 1, 0) )

#command SET CURSOR (<x>)                                               ;
      => SetCursor( if(<x>, 1, 0) )

#command SET EVENTMASK TO <x>            => Set( _SET_EVENTMASK, <x> )

#command SET VIDEOMODE TO <x>            => Set( _SET_VIDEOMODE, <x> )


#command SET SCOPETOP TO                => OrdScope( 0, nil )
#command SET SCOPETOP TO <x>            => OrdScope( 0, <x> )

#command SET SCOPEBOTTOM TO             => OrdScope( 1, nil )
#command SET SCOPEBOTTOM TO <x>         => OrdScope( 1, <x> )

#command SET SCOPE TO                   => OrdScope( 0, nil );
                                         ; OrdScope( 1, nil )
#command SET SCOPE TO <x>, <y>          => OrdScope( 0, <x> );
                                         ; OrdScope( 1, <y> )
#command SET SCOPE TO <x>               => OrdScope( 0, <x> );
                                         ; OrdScope( 1, <x> )
#command SET SCOPE TO ,<x>              => OrdScope( 1, <x> )

#command SET MBLOCKSIZE TO <x>          => Set( _SET_MBLOCKSIZE, <x> )
#command SET MEMOBLOCK TO <x>           => Set( _SET_MBLOCKSIZE, <x> )
#command SET MFILEEXT TO <x>            => Set( _SET_MFILEEXT, <x> )

#command SET STRICTREAD <x:ON,OFF,&>    => Set( _SET_STRICTREAD, <(x)> )
#command SET STRICTREAD (<x>)           => Set( _SET_STRICTREAD, <x> )

#command SET OPTIMIZE <x:ON,OFF,&>      => Set( _SET_OPTIMIZE, <(x)> )
#command SET OPTIMIZE (<x>)             => Set( _SET_OPTIMIZE, <x> )

#command SET AUTOPEN <x:ON,OFF,&>       => Set( _SET_AUTOPEN, <(x)> )
#command SET AUTOPEN (<x>)              => Set( _SET_AUTOPEN, <x> )

#command SET AUTORDER TO                => Set( _SET_AUTORDER,  0  )
#command SET AUTORDER TO <x>            => Set( _SET_AUTORDER, <x> )

#command SET AUTOSHARE TO               => Set( _SET_AUTOSHARE,  0  )
#command SET AUTOSHARE TO <x>           => Set( _SET_AUTOSHARE, <x> )

#command SET BELL <x:ON,OFF,&>          => Set( _SET_BELL, <(x)> )
#command SET BELL (<x>)                 => Set( _SET_BELL, <x> )

#command SET CONFIRM <x:ON,OFF,&>       => Set( _SET_CONFIRM, <(x)> )
#command SET CONFIRM (<x>)              => Set( _SET_CONFIRM, <x> )

#command SET ESCAPE <x:ON,OFF,&>        => Set( _SET_ESCAPE, <(x)> )
#command SET ESCAPE (<x>)               => Set( _SET_ESCAPE, <x> )

#command SET INTENSITY <x:ON,OFF,&>     => Set( _SET_INTENSITY, <(x)> )
#command SET INTENSITY (<x>)            => Set( _SET_INTENSITY, <x> )

#command SET SCOREBOARD <x:ON,OFF,&>    => Set( _SET_SCOREBOARD, <(x)> )
#command SET SCOREBOARD (<x>)           => Set( _SET_SCOREBOARD, <x> )

#command SET DELIMITERS <x:ON,OFF,&>    => Set( _SET_DELIMITERS, <(x)> )
#command SET DELIMITERS (<x>)           => Set( _SET_DELIMITERS, <x> )

#command SET DELIMITERS TO <c>          => Set( _SET_DELIMCHARS, <c> )
#command SET DELIMITERS TO DEFAULT      => Set( _SET_DELIMCHARS, "::" )
#command SET DELIMITERS TO              => Set( _SET_DELIMCHARS, "::" )

#command SET FORMAT TO <proc>                                           ;
                                                                        ;
      => _ProcReq_( <(proc)> + ".FMT" )                                 ;
       ; __SetFormat( {|| <proc>()} )

#command SET FORMAT TO <proc>.<ext>                                     ;
                                                                        ;
      => _ProcReq_( <(proc)> + "." + <(ext)> )                          ;
       ; __SetFormat( {|| <proc>()} )

#command SET FORMAT TO <x:&>                                            ;
                                                                        ;
      => if ( Empty(<(x)>) )                                            ;
       ;   SET FORMAT TO                                                ;
       ; else                                                           ;
       ;   __SetFormat( &("{||" + <(x)> + "()}") )                      ;
       ; end

#command SET FORMAT TO                                                  ;
      => __SetFormat()

#command SAVE SCREEN            => __XSaveScreen()
#command RESTORE SCREEN         => __XRestScreen()

#command SAVE SCREEN TO <var>                                           ;
      => <var> := SaveScreen( 0, 0, Maxrow(), Maxcol() )

#command RESTORE SCREEN FROM <c>                                        ;
      => RestScreen( 0, 0, Maxrow(), Maxcol(), <c> )

#command WAIT [<c>]             => __Wait( <c> )
#command WAIT [<c>] TO <var>    => <var> := __Wait( <c> )
#command ACCEPT [<c>] TO <var>  => <var> := __Accept( <c> )

#command INPUT [<c>] TO <var>                                           ;
                                                                        ;
      => if ( !Empty(__Accept(<c>)) )                                   ;
       ;    <var> := &( __AcceptStr() )                                 ;
       ; end

#command KEYBOARD <c>           => __Keyboard( <c> )

#command SET KEY <n> TO <proc>                                          ;
      => SetKey( <n>, {|p, l, v| <proc>(p, l, v)} )

#command SET KEY <n> TO <proc> ( [<list,...>] )                         ;
      => SET KEY <n> TO <proc>

#command SET KEY <n> TO <proc:&>                                        ;
                                                                        ;
      => if ( Empty(<(proc)>) )                                         ;
       ;   SetKey( <n>, NIL )                                           ;
       ; else                                                           ;
       ;   SetKey( <n>, {|p, l, v| <proc>(p, l, v)} )                   ;
       ; end

#command SET KEY <n> [TO]                                               ;
      => SetKey( <n>, NIL )

#command SET FUNCTION <n> [TO] [<c>]                                    ;
      => __SetFunction( <n>, <c> )

#command CLEAR MEMORY                   => __MClear()
#command RELEASE <vars,...>             => __MXRelease( <"vars"> )
#command RELEASE ALL                    => __MRelease("*", .t.)
#command RELEASE ALL LIKE <skel>        => __MRelease( #<skel>, .t. )
#command RELEASE ALL EXCEPT <skel>      => __MRelease( #<skel>, .f. )

#command RESTORE [FROM <(file)>] [<add: ADDITIVE>]                      ;
      => __MRestore( <(file)>, <.add.> )

#command SAVE ALL LIKE <skel> TO <(file)>                               ;
      => __MSave( <(file)>, <(skel)>, .t. )

#command SAVE TO <(file)> ALL LIKE <skel>                               ;
      => __MSave( <(file)>, <(skel)>, .t. )

#command SAVE ALL EXCEPT <skel> TO <(file)>                             ;
      => __MSave( <(file)>, <(skel)>, .f. )

#command SAVE TO <(file)> ALL EXCEPT <skel>                             ;
      => __MSave( <(file)>, <(skel)>, .f. )

#command SAVE [TO <(file)>] [ALL]                                       ;
      => __MSave( <(file)>, "*", .t. )

#command ERASE <(file)>                 => FErase( <(file)> )
#command DELETE FILE <(file)>           => FErase( <(file)> )
#command RENAME <(old)> TO <(new)>      => FRename( <(old)>, <(new)> )

#command COPY FILE <(src)> TO <(dest)>  => __CopyFile( <(src)>, <(dest)> )
#command DIR [<(spec)>]                 => __Dir( <(spec)> )

#command TYPE <(file)> [<print: TO PRINTER>] [TO FILE <(dest)>]         ;
                                                                        ;
      => __TypeFile( <(file)>, <.print.> )                              ;
      [; COPY FILE <(file)> TO <(dest)> ]

#command TYPE <(file)> [<print: TO PRINTER>]                            ;
                                                                        ;
      => __TypeFile( <(file)>, <.print.> )

#command REQUEST <vars,...>             => EXTERNAL <vars>

#command CANCEL                 => __Quit()
#command QUIT                   => __Quit()

#command RUN <*cmd*>            => __Run( #<cmd> )
#command RUN ( <c> )            => __Run( <c> )
#command ! <*cmd*>              => RUN <cmd>
#command RUN = <xpr>            => ( run := <xpr> )
#command RUN := <xpr>           => ( run := <xpr> )


/***
*  DB SETs
***/

#command SET EXCLUSIVE <x:ON,OFF,&>     =>  Set( _SET_EXCLUSIVE, <(x)> )
#command SET EXCLUSIVE (<x>)            =>  Set( _SET_EXCLUSIVE, <x> )

#command SET SOFTSEEK <x:ON,OFF,&>      =>  Set( _SET_SOFTSEEK, <(x)> )
#command SET SOFTSEEK (<x>)             =>  Set( _SET_SOFTSEEK, <x> )

#command SET UNIQUE <x:ON,OFF,&>        =>  Set( _SET_UNIQUE, <(x)> )
#command SET UNIQUE (<x>)               =>  Set( _SET_UNIQUE, <x> )

#command SET DELETED <x:ON,OFF,&>       =>  Set( _SET_DELETED, <(x)> )
#command SET DELETED (<x>)              =>  Set( _SET_DELETED, <x> )

#command SELECT <whatever>              => dbSelectArea( <(whatever)> )
#command SELECT <f>([<list,...>])       => dbSelectArea( <f>(<list>) )

#command USE                            => dbCloseArea()

#command USE <(db)>                                                     ;
             [VIA <rdd>]                                                ;
             [ALIAS <a>]                                                ;
             [<new: NEW>]                                               ;
             [<ex: EXCLUSIVE>]                                          ;
             [<sh: SHARED>]                                             ;
             [<ro: READONLY>]                                           ;
             [INDEX <(index1)> [, <(indexn)>]]                          ;
                                                                        ;
      => dbUseArea(                                                     ;
                    <.new.>, <rdd>, <(db)>, <(a)>,                      ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                  )                                                     ;
                                                                        ;
      [; dbSetIndex( <(index1)> )]                                      ;
      [; dbSetIndex( <(indexn)> )]

#command APPEND BLANK           => dbAppend()
#command PACK                   => __dbPack()
#command ZAP                    => __dbZap()
#command UNLOCK                 => dbUnlock()
#command UNLOCK ALL             => dbUnlockAll()
#command COMMIT                 => dbCommitAll()

#command GOTO <n>               => dbGoto(<n>)
#command GO <n>                 => dbGoto(<n>)
#command GOTO TOP               => dbGoTop()
#command GO TOP                 => dbGoTop()
#command GOTO BOTTOM            => dbGoBottom()
#command GO BOTTOM              => dbGoBottom()

#command SKIP                   => dbSkip(1)
#command SKIP <n>               => dbSkip( <n> )
#command SKIP ALIAS <a>         => <a> -> ( dbSkip(1) )
#command SKIP <n> ALIAS <a>     => <a> -> ( dbSkip(<n>) )

#command SEEK <xpr>                                                        ;
         [<soft: SOFTSEEK>]                                                ;
         [<last: LAST>]                                                    ;
      => dbSeek( <xpr>, if( <.soft.>, .T., NIL ), if( <.last.>, .T., NIL ) )

#command FIND <*text*>          => dbSeek( <(text)> )
#command FIND := <xpr>          => ( find := <xpr> )
#command FIND = <xpr>           => ( find := <xpr> )

#command CONTINUE               => __dbContinue()

#command LOCATE                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbLocate( <{for}>, <{while}>, <next>, <rec>, <.rest.> )

#command SET RELATION TO        => dbClearRel()

#command SET RELATION                                                   ;
         [<add:ADDITIVE>]                                               ;
         [TO <key1> INTO <(alias1)> [, [TO] <keyn> INTO <(aliasn)>]]    ;
                                                                        ;
      => if ( !<.add.> )                                                ;
       ;    dbClearRel()                                                ;
       ; end                                                            ;
                                                                        ;
       ; dbSetRelation( <(alias1)>, <{key1}>, <"key1"> )                ;
      [; dbSetRelation( <(aliasn)>, <{keyn}>, <"keyn"> )]

#command SET FILTER TO          => dbClearFilter()
#command SET FILTER TO <xpr>    => dbSetFilter( <{xpr}>, <"xpr"> )

#command SET FILTER TO <x:&>                                            ;
      => if ( Empty(<(x)>) )                                            ;
       ;    dbClearFilter()                                             ;
       ; else                                                           ;
       ;    dbSetFilter( <{x}>, <(x)> )                                 ;
       ; end

#command REPLACE [ <f1> WITH <x1> [, <fn> WITH <xn>] ]                  ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => DBEval(                                                        ;
                 {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]},    ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )

#command REPLACE <f1> WITH <v1> [, <fN> WITH <vN> ]                     ;
      => _FIELD-><f1> := <v1> [; _FIELD-><fN> := <vN>]

#command DELETE                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => DBEval(                                                        ;
                 {|| dbDelete()},                                       ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )

#command RECALL                                                         ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => DBEval(                                                        ;
                 {|| dbRecall()},                                       ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )

#command DELETE                 =>  dbDelete()
#command RECALL                 =>  dbRecall()

#command CREATE <(file1)>                                               ;
            [FROM <(file2)>]                                            ;
            [VIA <rdd>]                                                 ;
            [ALIAS <a>]                                                 ;
            [<new: NEW>]                                                ;
                                                                        ;
      => __dbCreate( <(file1)>, <(file2)>, <rdd>, <.new.>, <(a)> )

#command COPY [STRUCTURE] [EXTENDED] [TO <(file)>]                      ;
      => __dbCopyXStruct( <(file)> )

#command COPY [STRUCTURE] [TO <(file)>] [FIELDS <fields,...>]           ;
      => __dbCopyStruct( <(file)>, { <(fields)> } )

#command COPY [TO <(file)>] [DELIMITED [WITH <*delim*>]]                ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbDelim(                                                     ;
                        .T., <(file)>, <(delim)>, { <(fields)> },       ;
                        <{for}>, <{while}>, <next>, <rec>, <.rest.>     ;
                      )

#command COPY [TO <(file)>] [SDF]                                       ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbSDF(                                                       ;
                  .T., <(file)>, { <(fields)> },                        ;
                  <{for}>, <{while}>, <next>, <rec>, <.rest.>           ;
                )

#command COPY [TO <(file)>]                                             ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [VIA <rdd>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => __dbCopy(                                                      ;
                   <(file)>, { <(fields)> },                            ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>, <rdd>   ;
                 )

#command APPEND [FROM <(file)>] [DELIMITED [WITH <*delim*>]]            ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbDelim(                                                     ;
                       .F., <(file)>, <(delim)>, { <(fields)> },        ;
                       <{for}>, <{while}>, <next>, <rec>, <.rest.>      ;
                     )

#command APPEND [FROM <(file)>] [SDF]                                   ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbSDF(                                                       ;
                     .F., <(file)>, { <(fields)> },                     ;
                     <{for}>, <{while}>, <next>, <rec>, <.rest.>        ;
                   )

#command APPEND [FROM <(file)>]                                         ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [VIA <rdd>]                                                    ;
         [ALL]                                                          ;
                                                                        ;
      => __dbApp(                                                       ;
                  <(file)>, { <(fields)> },                             ;
                  <{for}>, <{while}>, <next>, <rec>, <.rest.>, <rdd>    ;
                )

#command SORT [TO <(file)>] [ON <fields,...>]                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbSort(                                                      ;
                   <(file)>, { <(fields)> },                            ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>          ;
                 )

#command TOTAL [TO <(file)>] [ON <key>]                                 ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbTotal(                                                     ;
                    <(file)>, <{key}>, { <(fields)> },                  ;
                    <{for}>, <{while}>, <next>, <rec>, <.rest.>         ;
                  )

#command UPDATE [FROM <(alias)>] [ON <key>]                             ;
         [REPLACE <f1> WITH <x1> [, <fn> WITH <xn>]]                    ;
         [<rand:RANDOM>]                                                ;
                                                                        ;
      => __dbUpdate(                                                    ;
                     <(alias)>, <{key}>, <.rand.>,                      ;
                     {|| _FIELD-><f1> := <x1> [, _FIELD-><fn> := <xn>]} ;
                   )

#command JOIN [WITH <(alias)>] [TO <file>]                              ;
         [FIELDS <fields,...>]                                          ;
         [FOR <for>]                                                    ;
                                                                        ;
      => __dbJoin( <(alias)>, <(file)>, { <(fields)> },                 ;
              IIF( EMPTY( #<for> ), { || .T. }, <{for}> ) )

#command COUNT [TO <var>]                                               ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => <var> := 0                                                     ;
       ; DBEval(                                                        ;
                 {|| <var> := <var> + 1},                               ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )

#command SUM [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                       ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => <v1> := [ <vn> := ] 0                                          ;
       ; DBEval(                                                        ;
                 {|| <v1> := <v1> + <x1> [, <vn> := <vn> + <xn> ]},     ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )

#command AVERAGE [ <x1> [, <xn>]  TO  <v1> [, <vn>] ]                   ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => M->__Avg := <v1> := [ <vn> := ] 0                              ;
                                                                        ;
       ; DBEval(                                                        ;
                 {|| M->__Avg := M->__Avg + 1,                          ;
                 <v1> := <v1> + <x1> [, <vn> := <vn> + <xn>] },         ;
                 <{for}>, <{while}>, <next>, <rec>, <.rest.>            ;
               )                                                        ;
                                                                        ;
       ; <v1> := <v1> / M->__Avg [; <vn> := <vn> / M->__Avg ]

#command LIST [<list,...>]                                              ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [ALL]                                                          ;
                                                                        ;
      => __dbList(                                                      ;
                   <.off.>, { <{list}> }, .t.,                          ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>,         ;
                   <.toPrint.>, <(toFile)>                              ;
                 )

#command DISPLAY [<list,...>]                                           ;
         [<off:OFF>]                                                    ;
         [<toPrint: TO PRINTER>]                                        ;
         [TO FILE <(toFile)>]                                           ;
         [FOR <for>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [<all:ALL>]                                                    ;
                                                                        ;
      => __DBList(                                                      ;
                   <.off.>, { <{list}> }, <.all.>,                      ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>,         ;
                   <.toPrint.>, <(toFile)>                              ;
                 )


#command CLOSE <alias>          => <alias>->( dbCloseArea() )

#command CLOSE                  => dbCloseArea()
#command CLOSE DATABASES        => dbCloseAll()
#command CLOSE ALTERNATE        => Set(_SET_ALTFILE, "")
#command CLOSE FORMAT           => __SetFormat(NIL)
#command CLOSE INDEXES          => dbClearIndex()
#command CLOSE PROCEDURE        =>

#command CLOSE ALL                                                      ;
                                                                        ;
      => CLOSE DATABASES                                                ;
       ; SELECT 1                                                       ;
       ; CLOSE FORMAT

#command CLEAR ALL                                                      ;
                                                                        ;
      => CLOSE DATABASES                                                ;
       ; CLOSE FORMAT                                                   ;
       ; CLEAR MEMORY                                                   ;
       ; CLEAR GETS                                                     ;
       ; SET ALTERNATE OFF                                              ;
       ; SET ALTERNATE TO

#command INDEX ON <key> [TAG <(cOrderName)> ] TO <(cOrderBagName)>      ;
         [FOR <for>]                                                    ;
         [<all:ALL>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [EVAL <eval>]                                                  ;
         [EVERY <every>]                                                ;
         [<unique: UNIQUE>]                                             ;
         [<ascend: ASCENDING>]                                          ;
         [<descend: DESCENDING>]                                        ;
      => ordCondSet( <"for">, <{for}>,                                  ;
                     [<.all.>],                                         ;
                     <{while}>,                                         ;
                     <{eval}>, <every>,                                 ;
                     RECNO(), <next>, <rec>,                            ;
                     [<.rest.>], [<.descend.>] )                        ;
      ;  ordCreate(<(cOrderBagName)>, <(cOrderName)>,                   ;
                   <"key">, <{key}>, [<.unique.>]    )

#command INDEX ON <key> TAG <(cOrderName)> [TO <(cOrderBagName)>]       ;
         [FOR <for>]                                                    ;
         [<all:ALL>]                                                    ;
         [WHILE <while>]                                                ;
         [NEXT <next>]                                                  ;
         [RECORD <rec>]                                                 ;
         [<rest:REST>]                                                  ;
         [EVAL <eval>]                                                  ;
         [EVERY <every>]                                                ;
         [<unique: UNIQUE>]                                             ;
         [<ascend: ASCENDING>]                                          ;
         [<descend: DESCENDING>]                                        ;
      => ordCondSet( <"for">, <{for}>,                                  ;
                     [<.all.>],                                         ;
                     <{while}>,                                         ;
                     <{eval}>, <every>,                                 ;
                     RECNO(), <next>, <rec>,                            ;
                     [<.rest.>], [<.descend.>] )                        ;
      ;  ordCreate(<(cOrderBagName)>, <(cOrderName)>,                   ;
                   <"key">, <{key}>, [<.unique.>]    )

#command INDEX ON <key> TO <(file)> [<u: UNIQUE>]                       ;
      => dbCreateIndex(                                                 ;
                        <(file)>, <"key">, <{key}>,                     ;
                        if( <.u.>, .t., NIL )                           ;
                      )

#command DELETE TAG <(cOrdName1)> [ IN <(cOrdBag1)> ]                   ;
                  [, <(cOrdNameN)> [ IN <(cOrdBagN)> ] ]                ;
      => ordDestroy( <(cOrdName1)>, <(cOrdBag1)> )                      ;
      [; ordDestroy( <(cOrdNameN)>, <(cOrdBagN)> ) ]

#command REINDEX                                                        ;
         [EVAL <eval>]                                                  ;
         [EVERY <every>]                                                ;
            [<lNoOpt: NOOPTIMIZE>]                                      ;
      => ordCondSet(,,,, <{eval}>, <every>,,,,,,,,,, <.lNoOpt.>)        ;
      ;  ordListRebuild()

#command REINDEX                => ordListRebuild()

#command SET INDEX TO [ <(index1)> [, <(indexn)>]] [<add: ADDITIVE>]    ;
                                                                        ;
      => if !<.add.> ; ordListClear() ; end                             ;
                                                                        ;
      [; ordListAdd( <(index1)> )]                                      ;
      [; ordListAdd( <(indexn)> )]

#command SET ORDER TO <xOrder>                                          ;
         [IN <(cOrdBag)>]                                               ;
                                                                        ;
      => ordSetFocus( <xOrder> [, <(cOrdBag)>] )

#command SET ORDER TO TAG <(cOrder)>                                                 ;
         [IN <(cOrdBag)>]                                               ;
                                                                        ;
      => ordSetFocus( <(cOrder)> [, <(cOrdBag)>] )

#command SET ORDER TO                   => ordSetFocus(0)

#command SET DESCENDING ON              => ordDescend( ,, .T. )
#command SET DESCENDING OFF             => ordDescend( ,, .F. )

#xcommand TEXTBLOCK <*cText*>   => // <cText>

#endif
