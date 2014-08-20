/*
 * Source     : DBFCDXAX.CH for CA-Clipper 5.3
 * Description: Header file for the Advantage CDX/IDX RDD (DBFCDXAX).
 *              Include this file in your application if:  1) You want to
 *              use both the Advantage CDX/IDX RDD (DBFCDXAX) and the
 *              CA-Clipper CDX RDD (DBFCDX) in the same application and/or
 *              2) You want to make use of the advanced functionality that
 *              is available with the Advantage CDX/IDX RDD, e.g. SET AXS
 *              LOCKING, BEGIN TRANSACTION, SET RIGHTS CHECKING, etc.  If
 *              you want to use both DBFCDXAX and DBFCDX in the same
 *              application you must "REQUEST DBFCDX" somewhere in your
 *              code.  If you include the ORD.CH header file in your
 *              application, include it before this header file.  To make
 *              DBFCDXAX the default RDD, link DBFCDXAX.OBJ into your
 *              application.
 *
 * Copyright 1996 - Extended Systems, Inc.
 */

#IFNDEF PROTHEUS
	REQUEST DBFCDXAX
#ENDIF


#command SET PASSWORD TO <(password)>                                      ;
      => AX_SetPass( <(password)> )

#command SET PASSWORD TO                                                   ;
      => AX_SetPass( "" )

#command BEGIN TRANSACTION                                                 ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 1 )

#command COMMIT TRANSACTION                                                ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 2 )

#command ROLLBACK TRANSACTION                                              ;
      => dbCommitAll()                                                     ;
       ; AX_Transaction( 3 )

#command SET RIGHTS CHECKING <x:ON,OFF>                                    ;
      => AX_RightsCheck( if( upper( <(x)> ) == "ON", .t., .f. ) )

#command SET EXPRESSION ENGINE <x:ON,OFF>                                  ;
      => AX_ExprEngine( if( upper( <(x)> ) == "ON", .t., .f. ) )

#command SET AXS LOCKING <x:ON,OFF>                                        ;
      => AX_AXSLocking( if( upper( <(x)> ) == "ON", .t., .f. )  )

#command SET TAGORDER TO <order>                                           ;
      => ordSetFocus( <order> )

#command SET TAGORDER TO                                                   ;
      => ordSetFocus( 0 )

#command SET ORDER TO TAG <(tag)>                                          ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => ordSetFocus( <(tag)> [, <(bag)>] )

#command SET TAG TO <(tag)>                                                ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => ordSetFocus( <(tag)> [, <(bag)>] )

#command SET TAG TO                                                        ;
      => ordSetFocus( 0 )

#command INDEX ON <key> TO <(file)>                                        ;
         [FOR       <for>]                                                 ;
         [<all:     ALL>]                                                  ;
         [WHILE     <while>]                                               ;
         [NEXT      <next>]                                                ;
         [RECORD    <rec>]                                                 ;
         [<rest:    REST>]                                                 ;
         [EVAL      <eval> [EVERY  <every>]]                               ;
         [OPTION    <eval> [STEP   <every>]]                               ;
         [<unique:  UNIQUE>]                                               ;
         [<ascend:  ASCENDING>]                                            ;
         [<descend: DESCENDING>]                                           ;
         [<cur:     USECURRENT>]                                           ;
         [<cur:     SUBINDEX>]                                             ;
         [<add:     ADDITIVE>]                                             ;
         [<custom:  CUSTOM>]                                               ;
         [<custom:  EMPTY>]                                                ;
         [<non:     NONCOMPACT>]                                           ;
         [<noopt:   NOOPTIMIZE>]                                           ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     [<.all.>],                                            ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     [<.rest.>], [<.descend.>],                            ;
                     NIL, <.add.>, <.cur.>, <.custom.>, <.noopt.>,         ;
                     .f., NIL, <"while">, <.non.> )                        ;
       ; dbCreateIndex( <(file)>, <"key">, <{key}>, [<.unique.>] )

#command INDEX ON <key> TAG <(tag)>                                        ;
         [OF <(bag)>]                                                      ;
         [TO <(bag)>]                                                      ;
         [FOR        <for>]                                                ;
         [<all:      ALL>]                                                 ;
         [WHILE      <while>]                                              ;
         [NEXT       <next>]                                               ;
         [RECORD     <rec>]                                                ;
         [<rest:     REST>]                                                ;
         [EVAL       <eval> [EVERY  <every>]]                              ;
         [OPTION     <eval> [STEP   <every>]]                              ;
         [<unique:   UNIQUE>]                                              ;
         [<ascend:   ASCENDING>]                                           ;
         [<descend:  DESCENDING>]                                          ;
         [<cur:      USECURRENT>]                                          ;
         [<cur:      SUBINDEX>]                                            ;
         [<add:      ADDITIVE>]                                            ;
         [<custom:   CUSTOM>]                                              ;
         [<custom:   EMPTY>]                                               ;
         [<noopt:    NOOPTIMIZE>]                                          ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     [<.all.>],                                            ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     [<.rest.>], [<.descend.>],                            ;
                     NIL, <.add.>, <.cur.>, <.custom.>, <.noopt.>,         ;
                     .t., <(bag)>, <"while">, .f. )                        ;
       ; ordCreate( <(bag)>, <(tag)>, <"key">, <{key}>, [<.unique.>] )


#command SUBINDEX ON <key> TO <(file)>                                     ;
         [FOR       <for>]                                                 ;
         [<all:     ALL>]                                                  ;
         [WHILE     <while>]                                               ;
         [NEXT      <next>]                                                ;
         [RECORD    <rec>]                                                 ;
         [<rest:    REST>]                                                 ;
         [EVAL      <eval> [EVERY  <every>]]                               ;
         [OPTION    <eval> [STEP   <every>]]                               ;
         [<unique:  UNIQUE>]                                               ;
         [<ascend:  ASCENDING>]                                            ;
         [<descend: DESCENDING>]                                           ;
         [<non:     NONCOMPACT>]                                           ;
         [<add:     ADDITIVE>]                                             ;
         [<custom:  CUSTOM>]                                               ;
         [<custom:  EMPTY>]                                                ;
         [<noopt:   NOOPTIMIZE>]                                           ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     [<.all.>],                                            ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     [<.rest.>], [<.descend.>],                            ;
                     NIL, <.add.>, .t., <.custom.>, <.noopt.>,             ;
                     .f., NIL, <"while">, <.non.> )                        ;
       ; dbCreateIndex( <(file)>, <"key">, <{key}>, [<.unique.>] )

#command SUBINDEX ON <key> TAG <(tag)>                                     ;
         [OF <(bag)>]                                                      ;
         [TO <(bag)>]                                                      ;
         [FOR        <for>]                                                ;
         [<all:      ALL>]                                                 ;
         [WHILE      <while>]                                              ;
         [NEXT       <next>]                                               ;
         [RECORD     <rec>]                                                ;
         [<rest:     REST>]                                                ;
         [EVAL       <eval> [EVERY  <every>]]                              ;
         [OPTION     <eval> [STEP   <every>]]                              ;
         [<ascend:   ASCENDING>]                                           ;
         [<descend:  DESCENDING>]                                          ;
         [<unique:   UNIQUE>]                                              ;
         [<add:      ADDITIVE>]                                            ;
         [<custom:   CUSTOM>]                                              ;
         [<custom:   EMPTY>]                                               ;
         [<noopt:    NOOPTIMIZE>]                                          ;
      => ordCondSet( <"for">, <{for}>,                                     ;
                     [<.all.>],                                            ;
                     <{while}>,                                            ;
                     <{eval}>, <every>,                                    ;
                     RECNO(), <next>, <rec>,                               ;
                     [<.rest.>], [<.descend.>],                            ;
                     NIL, <.add.>, .t., <.custom.>, <.noopt.>,             ;
                     .t., <(bag)>, <"while">, .f. )                        ;
       ; ordCreate( <(bag)>, <(tag)>, <"key">, <{key}>, [<.unique.>] )


#command REINDEX                                                           ;
         [EVAL    <eval> [EVERY  <every>]]                                 ;
         [OPTION  <eval> [STEP   <every>]]                                 ;
      => ordCondSet(,,,, <{eval}>, <every>,,,,,,,,,,,,,)                   ;
       ; ordListRebuild()

#command DELETE TAG <(tag1)> [OF <(bag1)>]                                 ;
         [, <(tagn)> [OF <(bagn)>]]                                        ;
      => ordDestroy( <(tag1)>, <(bag1)> )                                  ;
      [; ordDestroy( <(tagn)>, <(bagn)> )]

#command DELETE TAG <(tag1)> [IN <(bag1)>]                                 ;
         [, <(tagn)> [IN <(bagn)>]]                                        ;
      => ordDestroy( <(tag1)>, <(bag1)> )                                  ;
      [; ordDestroy( <(tagn)>, <(bagn)> )]

#command DELETE TAG ALL                                                    ;
         [OF <(bag)>]                                                      ;
         [IN <(bag)>]                                                      ;
      => AX_KillTag( .t., <(bag)> )

#command CLEAR SCOPE                                                       ;
      => ordScope( 0, NIL )                                                ;
       ; ordScope( 1, NIL )

#xcommand SET SCOPETOP TO <value>                                          ;
      => ordScope( 0, <value> )

#xcommand SET SCOPETOP TO                                                  ;
      => ordScope( 0, NIL )

#xcommand SET SCOPEBOTTOM TO <value>                                       ;
      => ordScope( 1, <value> )

#xcommand SET SCOPEBOTTOM TO                                               ;
      => ordScope( 1, NIL )

#command SET SCOPE TO                                                      ;
      => ordScope( 0, NIL )                                                ;
       ; ordScope( 1, NIL )

#command SET SCOPE TO <value>                                              ;
      => ordScope( 0, <value> )                                            ;
       ; ordScope( 1, <value> )

#command SET MEMOBLOCK TO <value>                                          ;
      => AX_SetMemoBlock( <value> )                                        ;
       ; dbInfo( 39, <value> )

#command SORT [TO <(file)>] [ON <fields,...>]                              ;
         [FOR    <for>]                                                    ;
         [WHILE  <while>]                                                  ;
         [NEXT   <next>]                                                   ;
         [RECORD <rec>]                                                    ;
         [<rest: REST>]                                                    ;
         [ALL]                                                             ;
         [<cur:  USECURRENT>]                                              ;
                                                                           ;
      => AX_SortOption(<.cur.>)                                            ;
       ; __dbSort( <(file)>, { <(fields)> },                               ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.> )

#command AUTOUSE <(db)> VIA <rdd> ALTERNATE <altrdd>                       ;
         [ALIAS <a>]                                                       ;
         [<new: NEW>]                                                      ;
         [<ex: EXCLUSIVE>]                                                 ;
         [<sh: SHARED>]                                                    ;
         [<ro: READONLY>]                                                  ;
         [INDEX <(index1)> [, <(indexn)>]]                                 ;
                                                                           ;
      => if AX_Loaded( AX_GetDrive( <(db)> ) )                             ;
       ;    dbUseArea(                                                     ;
                      <.new.>, <rdd>, <(db)>, <(a)>,                       ;
                      if (<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                     )                                                     ;
            [; dbSetIndex( <(index1)> )]                                   ;
            [; dbSetIndex( <(indexn)> )]                                   ;
       ; else                                                              ;
       ;    dbUseArea(                                                     ;
                      <.new.>, <altrdd>, <(db)>, <(a)>,                    ;
                      if (<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                     )                                                     ;
            [; dbSetIndex( <(index1)> )]                                   ;
            [; dbSetIndex( <(indexn)> )]                                   ;
       ; endif

/* Redefinition of USE for PASSWORDs */
#command USE <(db)>                                                        ;
             [VIA <rdd>]                                                   ;
             [ALIAS <a>]                                                   ;
             [<new: NEW>]                                                  ;
             [<ex: EXCLUSIVE>]                                             ;
             [<sh: SHARED>]                                                ;
             [<ro: READONLY>]                                              ;
             [INDEX <(index1)> [, <(indexn)>]]                             ;
             [PASSWORD <(password)>]                                       ;
                                                                           ;
      => dbUseArea(                                                        ;
                    <.new.>, <rdd>, <(db)>, <(a)>,                         ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>           ;
                  )                                                        ;
                                                                           ;
      [; AX_SetPass( <(password)> )]                                       ;
      [; dbSetIndex( <(index1)> )]                                         ;
      [; dbSetIndex( <(indexn)> )]

