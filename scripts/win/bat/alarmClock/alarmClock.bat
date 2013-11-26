@Echo off&setlocal

    color f0
    title Batch Alarm Clock

    SET tDSong="C:/\temp/\Racionais_MCs_Negro_Drama.mp3"
    
    IF [%1] NEQ [] ( 
        set tSetA=%1:00,00
        IF [%2] NEQ [] ( 
            set tPSong=%2
        ) else ( 
            set tPSong=%tDSong%
        )
        goto :top
    )

    cls
    
    echo.
    echo.
    echo.
    echo Use the 24 hour clock: example 15:00 for 3:00PM
    echo.
    
    echo TIME: %time%
    
    echo.
    
    set /p tSetG=Set Alarm:
    
    set tSetA=%tSetG:~0,5%:00,00
    set tPSong=%tDSong%

    goto :top

:top
    goto calcTime
    :sleep
    if "%tTime:~0,5%" == "%tSetA:~0,5%" (
            cls
            echo Date             : %date%
            echo.
            echo Time             : %tTime%
            echo Alarm is set for : %tSetA%
            echo.
            call bigtext ALARM !!! 
            start mplay32 /play /close %tPSong%
            REM %tPSong%
            goto :end
    ) else (
            PING -n 2 127.0.0.1 > NUL
            REM TIMEOUT /T 1 /NOBREAK > NUL
    )
    goto :top

:end
endlocal
goto :EOF   

:calcTime

    cls

    set hour=%tSetA:~0,2%
    if "%hour:~1,1%" == ":" set hour=0%hour:~0,1%
    set min=%tSetA:~3,2%
    if "%min:~1,1%" == ":" set min=%tSetA:~2,2%
    set secs=%tSetA:~6,6% 
    if "%secs:~1,1%" == "," set secs=%tSetA:~5,6% 
    set tSetA=%hour%:%min%:%secs%
    
    set tMatch=%tSetA%

    set tTime=%time%
    
    set hour=%tTime:~0,2%
    if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
    set min=%tTime:~3,2%
    if "%min:~0,1%" == " " set min=0%min:~1,1%
    set secs=%tTime:~6,6% 
    if "%secs:~0,1%" == " " set secs=0%secs:~1,6%
    set tTime=%hour%:%min%:%secs%
    
    echo Date             : %date%
    
    echo.
    
    echo Time             : %tTime%

    echo Alarm is set for : %tSetA%
    
    set /A tMatch=(1%tMatch:~0,2%-100)*360000+(1%tMatch:~3,2%-100)*6000+(1%tMatch:~6,2%-100)*100+(1%tMatch:~9,2%-100)
    set /A tnTime=(1%tTime:~0,2%-100)*360000+(1%tTime:~3,2%-100)*6000+(1%tTime:~6,2%-100)*100+(1%tTime:~9,2%-100)

    set t24=24:00:00,00
    set /A tn24=(1%t24:~0,2%-100)*360000+(1%t24:~3,2%-100)*6000+(1%t24:~6,2%-100)*100+(1%t24~9,2%-100)

    if %tMatch% LSS %tnTime% (
        set /a tnTime=%tn24%-%tnTime%
        set /a tElapTime=%tn24%-%tnTime%+%tMatch%
    ) else (
        set /a tElapTime=%tMatch%-%tnTime%
    )

    set /A tElapTimeH=(%tElapTime%/360000)
    set /A tElapTimeM=((%tElapTime%-%tElapTimeH%*360000)/6000)
    set /A tElapTimeS=((%tElapTime%-%tElapTimeH%*360000-%tElapTimeM%*6000)/100)
    set /A tElapTimeHS=(%tElapTime%-%tElapTimeH%*360000-%tElapTimeM%*6000-%tElapTimeS%*100)

    if %tElapTimeH%  LSS 10 set tElapTimeH=0%tElapTimeH%
    if %tElapTimeM%  LSS 10 set tElapTimeM=0%tElapTimeM%
    if %tElapTimeS%  LSS 10 set tElapTimeS=0%tElapTimeS%
    if %tElapTimeHS% LSS 10 set tElapTimeHS=0%tElapTimeHS%

    echo.

    set swElapTile=%tElapTimeH%:%tElapTimeM%:%tElapTimeS%,%tElapTimeHS%

    echo ElapTime         : %swElapTile%

    echo.
    
    echo %tnTime%
    echo %tMatch%
    echo %tElapTime%
    
goto :sleep
