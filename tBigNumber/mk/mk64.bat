@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=c:\hb32\

    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_assignv_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_mt.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_mt_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_mt_assignv_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_array_mt_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_assignv_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_dyn_obj_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_dyn_obj_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_assignv_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_mt.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_mt_assignv.hbp
    %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\tBigNtst_mt_dyn_obj.hbp

SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%