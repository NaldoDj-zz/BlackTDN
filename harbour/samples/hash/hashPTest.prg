#define COUNT 400000 

PROCEDURE main() 

   LOCAL aH 

   IF ( ( COUNT % 13 ) == 0 )
     ? "Invalid count number" 
     RETURN 
   ENDIF 

   aH := {=>} 

   dummy_insert(aH) 
   dummy_seek(aH) 
   dummy_delete(aH) 
   
   ? "KEEPORDER = .F." 

   aH := {=>} 

   hash_insert(aH) 
   hash_seek(aH) 
   hash_delete(aH) 

   ? "KEEPORDER = .T." 

   aH := {=>} 

   HB_HKeepOrder(aH, .T.) 

   hash_insert(aH) 
   hash_seek(aH) 
   hash_delete(aH) 

RETURN 

PROCEDURE dummy_insert(aH) 

   LOCAL nI, nT, nT1 

   nT := nT1 := hb_milliseconds() 

   FOR nI := 0 TO COUNT - 1 
     IF ( nI < 65536 )
       aH["dummy"] := nI
     ELSE 
       aH["dummy"] := nI
     ENDIF 
     IF ( ( (nI + 1) % 10000 ) == 0 )
       ? nI + 1, hb_milliseconds() - nT1, "ms" 
       nT1 := hb_milliseconds() 
     ENDIF 
   NEXT 

   ? "Hash insert", hb_milliseconds() - nT, "ms" , "length", LEN(aH) 

RETURN 

PROCEDURE dummy_delete(aH) 

   LOCAL nI, nJ, nT, nT1 

   nT := nT1 := hb_milliseconds() 

   FOR nI := 0 TO COUNT - 1 
     nJ := ( (nI * 13) % COUNT )  // randomize 
     IF nJ < 65536 
        HB_HDel(aH, "dummy") 
     ELSE 
        HB_HDel(aH, "dummy") 
     EndIF
     IF ( ( (nI + 1) % 10000 ) == 0 )
       ? nI + 1, hb_milliseconds() - nT1, "ms" 
       nT1 := hb_milliseconds() 
     ENDIF 
   NEXT 

   ? "Hash delete", hb_milliseconds() - nT, "ms", "length", LEN(aH) 

 RETURN 

PROCEDURE dummy_seek(aH) 

   LOCAL nI, nJ, nK, nT, nT1, xI

   nT := nT1 := hb_milliseconds() 

   FOR nK := 1 TO 100 
      FOR nI := 0 TO COUNT - 1 
        nJ := ( (nI * 13) % COUNT )  // randomize 
        IF ( nJ < 65536 )
          xI := aH["dummy"] 
        ELSE 
          xI := aH["dummy"] 
        ENDIF

      NEXT 
      IF ( ( (nK + 1) % 10 ) == 0 )
        ? nK + 1, hb_milliseconds() - nT1, "ms" 
        nT1 := hb_milliseconds() 
      ENDIF 
   NEXT 

   xI    := NIL 
   xLast := NIL

   ? "Hash seek", hb_milliseconds() - nT, "ms" , "length", LEN(aH) 

RETURN 

PROCEDURE hash_insert(aH) 

   LOCAL nI, nT, nT1, cIndex

   nT := nT1 := hb_milliseconds() 

   FOR nI := 0 TO COUNT - 1 
     IF ( nI < 65536 )
       cIndex := LEFT(L2BIN(nI), 2)
     ELSE 
       cIndex := LEFT(L2BIN(nI), 3)
     ENDIF 
     aH[cIndex] := nI
     IF ( ( (nI + 1) % 10000 ) == 0 )
       ? nI + 1, hb_milliseconds() - nT1, "ms" 
       nT1 := hb_milliseconds() 
     ENDIF 
   NEXT 

   ? "Hash insert", hb_milliseconds() - nT, "ms" , "length", LEN(aH) 

RETURN 

PROCEDURE hash_delete(aH) 

   LOCAL nI, nJ, nT, nT1,cIndex

   nT := nT1 := hb_milliseconds() 

   FOR nI := 0 TO COUNT - 1 
     nJ := ( (nI * 13) % COUNT )  // randomize 
     IF ( nJ < 65536 )
       cIndex := LEFT(L2BIN(nJ), 2)
     ELSE 
       cIndex := LEFT(L2BIN(nJ), 3)
     ENDIF 
     HB_HDel(aH,cIndex) 
     IF ( ( (nI + 1) % 10000 ) == 0 )
       ? nI + 1, hb_milliseconds() - nT1, "ms" 
       nT1 := hb_milliseconds() 
     ENDIF 
   NEXT 

   ? "Hash delete", hb_milliseconds() - nT, "ms", "length", LEN(aH) 

 RETURN 

PROCEDURE hash_seek(aH) 

   LOCAL nI, nJ, nK, nT, nT1, xI, cIndex

   nT := nT1 := hb_milliseconds() 

   FOR nK := 1 TO 100 
      FOR nI := 0 TO COUNT - 1 
        nJ := ( (nI * 13) % COUNT )  // randomize 
        IF ( nJ < 65536 )
          cIndex := LEFT(L2BIN(nJ), 2) 
        ELSE 
          cIndex := LEFT(L2BIN(nJ), 3)
        ENDIF 
        xI := aH[cIndex] 
      NEXT 
      IF ( ( (nK + 1) % 10 ) == 0 )
        ? nK + 1, hb_milliseconds() - nT1, "ms" 
        nT1 := hb_milliseconds() 
      ENDIF 
    NEXT 

   xI := NIL 

   ? "Hash seek", hb_milliseconds() - nT, "ms", "length", LEN(aH) 

RETURN
