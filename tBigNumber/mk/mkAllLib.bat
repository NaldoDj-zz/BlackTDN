@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
SET _PATH=%PATH%
	call mkLib.bat
	call mkLib64.bat
	call mkLibARM.bat
SET PATH=%_PATH%