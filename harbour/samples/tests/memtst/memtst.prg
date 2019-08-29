/*
 * #Id: memtst.prg
 * baseado no original de: Harbour Project source code: #Id: memtst.prg 13932 2010-02-20 11:57:17Z vszakats $
 * a small memory manager test code
 */
#define N_LOOPS      (1000*1000)
#define N_MAXLOOP             10
#define WHITE_SPACE         1024
#define MAX_SIZE_ARRAY    100000

#ifndef HB_SYMBOL_UNUSED
     #define HB_SYMBOL_UNUSED( symbol ) ( symbol := ( symbol ) )
#endif

#ifdef __HARBOUR__
    #include "simpleio.ch"
    #include "hbmemory.ch"
#else
    #xcommand ?  [<list,...>] => ConOut( [ <list> ] )
    #xcommand ?? [<list,...>] => ConOut( [ <list> ] )
    #ifdef TOTVS
        #include "totvs.ch"
    #else
        #include "protheus.ch"
    #endif    
#endif
//-----------------------------------------------------------------------------------------------------------
#ifdef __HARBOUR__
procedure main()
    local cCRLF        := hb_OsNewLine()
    local cVersion     := VERSION()+build_mode()
    local cOS          := OS()
#else
Static __lWGTickCount  := ( !IsSrvUnix() .and. ( aSCan( __FunArr() , { |e| ( e[1] == "WGetTickCount" ) } ) > 0 ) )
user function memtst()
    local cCRLF        := CRLF
    local cVersion     := "TOTVS APPServer " + GetVersao(.T.,.F.) + " " + GetBuild() + " " + GetRPORelease()
    local cOS          := IF( IsSrvUnix() , "Unix/Linux", "Windows" )     
#endif
    local dDate
    local cTime
    local t
    local nCPUSec
    local nRealSec
    local nSizeArr     := 100
    local cWSpace      := ""
    local nfhandle

    SET DATE TO BRITISH
    SET CENTURY ON

    for t := 1 to N_MAXLOOP
    
         nRealSec    := seconds()
         nCPUSec     := hb_secondsCPU()
    
         nfhandle    := fCreate( "memtst" + StrZero(t,10) + ".log" )
         IF ( nfhandle < 0 )
             ? "Can not start a test: " + Str( t )
             loop
         EndIF
     
         dDate := date()
         cTime := Time()
     
         ? dDate, cTime, cVersion+", "+cOS
         fWrite( nfhandle , dtoc( dDate ) + ", " + cTime + ", " + cVersion+", "+cOS + cCRLF )
     
         #ifdef __HARBOUR__
             if MEMORY( HB_MEM_USEDMAX ) != 0
                 ?
                fWrite( nfhandle , cCRLF )
                ? "Warning !!! Memory statistic enabled."
                fWrite( nfhandle , "Warning !!! Memory statistic enabled." + cCRLF )
             endif
         #endif

         nSizeArr    := Min( nSizeArr * 10 , MAX_SIZE_ARRAY )
         cWSpace     := Space( t * WHITE_SPACE  )

          ?
         fWrite( nfhandle , cCRLF )
        
         fWrite( nfhandle , "Len( cWSpace ) :" + Transform( Len( cWSpace ) , "9999999999" ) + cCRLF )
        
         fWrite( nfhandle , cCRLF )

         memtst(@nfhandle,@cCRLF,@t,@nSizeArr,@cWSpace)

         dDate       := date()
         cTime       := Time()
         nCPUSec     := hb_secondsCPU() - nCPUSec
         nRealSec    := seconds() - nRealSec

         ?
         fWrite( nfhandle , cCRLF )          

         ? dDate, cTime, cVersion+", "+cOS
         fWrite( nfhandle , dtoc( dDate ) + ", " + cTime + ", " + cVersion+", "+cOS + cCRLF )

         ?
         fWrite( nfhandle , cCRLF )
      
         ? " CPU time (total):", nCPUSec, "sec."
         fWrite( nfhandle , " CPU time (total):" + Transform(  nCPUSec , "99999.9999999999" )  + " sec." + cCRLF )
         
         ? "real time (total):", nRealSec, "sec."
         fWrite( nfhandle , "real time (total):" + Transform( nRealSec , "99999.9999999999" ) + " sec." + cCRLF  )

         fClose( nfhandle )

    next t

    cWSpace := NIL

Return
//-----------------------------------------------------------------------------------------------------------
static procedure memtst(nfhandle,cCRLF,t,nSizeArr,cWSpace)

    local i
    local a
    local nCPUSec
    local nRealSec
    local nCRLF
    local lFree := .F.
    
    ?
    fWrite( nfhandle , cCRLF )
    ? "testing single large memory blocks allocation and freeing..."
    fWrite( nfhandle , "testing single large memory blocks allocation and freeing..."+ cCRLF )    
    
    ?
    fWrite( nfhandle , cCRLF )
    
    nRealSec    := seconds()
    nCPUSec     := hb_secondsCPU()

    for i := 1 to ( t * N_LOOPS )
        a := cWSpace
        HB_SYMBOL_UNUSED( a )
        a := ""
        HB_SYMBOL_UNUSED( a )
        a := NIL
    next i

    nCPUSec     := hb_secondsCPU() - nCPUSec
    nRealSec    := seconds() - nRealSec

    ? " CPU time:", nCPUSec, "sec."
    fWrite( nfhandle , " CPU time:" + Transform(  nCPUSec , "99999.9999999999" )  + " sec." + cCRLF )    
    
    ? "real time:", nRealSec, "sec."
    fWrite( nfhandle , "real time:" + Transform( nRealSec , "99999.9999999999" ) + " sec." + cCRLF )    
    
    ?
    fWrite( nfhandle , cCRLF )
   
    ? "testing many large memory blocks allocation and freeing..."     
    ?
   
    fWrite( nfhandle , cCRLF )
    fWrite( nfhandle , "testing many large memory blocks allocation and freeing..." + cCRLF )    
    
    ?
    fWrite( nfhandle , cCRLF )

    nRealSec    := seconds()
    nCPUSec     := hb_secondsCPU()
    a           := Array(nSizeArr)
    nCRLF       := 0
    for i := 1 to ( t * N_LOOPS )
        a[ i % 100 + 1 ] := cWSpace
        fWrite( nfhandle , Transform( i % 100 + 1  , "9999999999" ) )
        IF ( ( ++nCRLF % 10 ) == 0 )
            fWrite( nfhandle , cCRLF )    
        EndIF
        if i % 200 == 0
            fWrite( nfhandle , cCRLF )
            IF ( lFree )
                lFree := .F.
                afill(a,"")
                ? "Free  :",i
                fWrite( nfhandle , "Free  : " + Transform( i  , "9999999999" ) + cCRLF )
            Else
                lFree := .T.
                afill(a,cWSpace)
                ? "Alloc :",i
                fWrite( nfhandle , "Alloc : " + TransForm( i  , "9999999999" ) + cCRLF )
            EndIF
            fWrite( nfhandle , cCRLF )
        endif
    next i

    aSize( a , 0 )
    a           := NIL
    nCPUSec     := hb_secondsCPU() - nCPUSec
    nRealSec    := seconds() - nRealSec

    ? " CPU time:", nCPUSec, "sec."
    fWrite( nfhandle , " CPU time:" + Transform( nCPUSec  , "99999.9999999999" )  + " sec." + cCRLF )    
    
    ? "real time:", nRealSec, "sec."
    fWrite( nfhandle , "real time:" + Transform( nRealSec  , "99999.9999999999" ) + " sec." + cCRLF )
    
    ?
    fWrite( nfhandle , cCRLF )

    ? "testing large memory block reallocation with intermediate allocations..."

    fWrite( nfhandle , "testing large memory block reallocation with intermediate allocations..." + cCRLF )

    ? "Warning!!! some compilers may badly fail here"

    ?
    fWrite( nfhandle , cCRLF )
    
    fWrite( nfhandle , "Warning!!! some compilers may badly fail here" + cCRLF )

    ?
    fWrite( nfhandle , cCRLF )

    IdleSleep( 2 )
    
    nRealSec    := seconds()
    nCPUSec     := hb_secondsCPU()
    nCRLF       := 0
    a           := Array(0)
    for i := 1 to ( t * N_LOOPS )
        aadd( a, { cWSpace } )
        if i%1000 == 0
            ?? i
            fWrite( nfhandle , Transform( i  , "9999999999" ) )
            if ( ( ++nCRLF % 10 ) == 0 )
                fWrite( nfhandle , cCRLF )    
            endif
        endif
    next i

    fWrite( nfhandle , cCRLF )    
    aSize( a , 0 )
    a           := NIL
    nCPUSec     := hb_secondsCPU() - nCPUSec
    nRealSec    := seconds() - nRealSec

    ? " CPU time:", nCPUSec, "sec."
    fWrite( nfhandle , " CPU time:" + Transform( nCPUSec  , "99999.9999999999" )  + " sec." + cCRLF )
    
    ? "real time:", nRealSec, "sec."
    fWrite( nfhandle , "real time:" + Transform( nRealSec  , "99999.9999999999" ) + " sec." + cCRLF )
    
    IdleSleep( 2 )

return
//-----------------------------------------------------------------------------------------------------------
static procedure IdleSleep( n )
    #ifdef __HARBOUR__
        n += seconds()
        while seconds() < n
        enddo
    #else
        Sleep( n )
    #endif
return
//-----------------------------------------------------------------------------------------------------------
#ifndef PROTHEUS
    #ifndef TOTVS
        static function build_mode()
        #ifdef __CLIP__
           return " (MT)"
        #else
           #ifdef __XHARBOUR__
              return iif( HB_MULTITHREAD(), " (MT)", "" ) + ;
                     iif( MEMORY( HB_MEM_USEDMAX ) != 0, " (FMSTAT)", "" )
           #else
              #ifdef __HARBOUR__
                 return iif( HB_MTVM(), " (MT)", "" ) + ;
                        iif( MEMORY( HB_MEM_USEDMAX ) != 0, " (FMSTAT)", "" )
              #else
                 #ifdef __XPP__
                    return " (MT)"
                 #else
                    return ""
                 #endif
              #endif
           #endif
        #endif
    #else
        static Function hb_secondsCPU()
        IF ( __lWGTickCount )
            Return(WGetTickCount())
        Else
            Return(Seconds())
        EndIF    
    #endif
#else
    static Function hb_secondsCPU()
    IF ( __lWGTickCount )
        Return(WGetTickCount())
    Else
        Return(Seconds())
    EndIF    
#endif 
