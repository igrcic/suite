@echo off
echo.

REM Check for one argument, display usage and quit if not found

if "%1" == "" (
  echo Sorry, one argument is required.
  goto Usage
)


REM Start
if "%1" == "start" (
  net start "OpenGeoPostgresService"
  net start "OpenGeoGeoserverService"
  goto Done
)


REM Stop
if "%1" == "stop" (
  net stop "OpenGeoPostgresService"
  net stop "OpenGeoGeoserverService"
  goto Done
)

REM if %1 is unknown

:Usage
REM Display usage 
echo.
echo Usage:
echo    opengeo-suite ^[start^|stop^]
goto End

:Done

:End
echo.


