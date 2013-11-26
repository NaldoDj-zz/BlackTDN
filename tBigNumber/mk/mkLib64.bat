@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=c:\hb32\
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\_tbigNumber.hbp	
SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%



