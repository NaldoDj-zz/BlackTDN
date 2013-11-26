@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
SET _PATH=%PATH%
	call mk.bat
	call mk64.bat
	call mkarm.bat
SET PATH=%_PATH%