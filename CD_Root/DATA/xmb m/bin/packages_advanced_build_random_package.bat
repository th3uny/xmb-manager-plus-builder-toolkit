@echo off
title Build Random Package
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0\%id_xmbmp% goto :error_source
SETLOCAL ENABLEDELAYEDEXPANSION
cls
echo.
echo.
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0E}                 Select the Source{04}                 �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �{08} ������������������������������������������������ͻ {04}�{\n}
%external%\cecho {08}        �ͼ                                                ���{\n}
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgsource%\*.') DO (
set /a counter += 1
%external%\cecho {0F}           !counter!. %%Y {\n}
)
%external%\cecho {08}        �ͻ                                                ���{\n}
%external%\cecho {04}        � {08}������������������������������������������������ͼ {04}�{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {0F}{\n}
echo.
:ask_source
set /p sourcenum= Choose a source directory: 
set counter=0
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgsource%\*.') DO (
set /a counter += 1
if [!counter!]==[%sourcenum%] (
set sourcesrc=%%Y
goto :name
)
)
goto :ask_source

:name
cls
echo.
echo.
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0E}           Type the Name of your .pkg{04}              �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        � {0F}            example "reallycoolpackage"{04}            �{\n}
%external%\cecho {04}        �                                                    �{\n}
%external%\cecho {04}        ������������������������������������������������������{\n}
%external%\cecho {0F}{\n}
echo.
:ask_name
set /p pkgname= Choose the name: 
if ["%pkgname%"]==[""] goto :ask_name

:build
call "%bindir%\global_messages.bat" "BUILDING"
if [%sourcesrc%]==[flash] goto :build_flash
%external%\%packager% %pkgsource%\package-xmbmp.conf %pkgsource%\%sourcesrc%\%id_xmbmp%
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg %pkgname%.pkg
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move "%bindir%\*.pkg" "%pkgoutput%"
goto :done

:build_flash
%external%\%packager% %pkgsource%\package-flash.conf %pkgsource%\%sourcesrc%\%id_xmbmp_flash%
rename UP0001-%id_xmbmp_flash%_00-0000000000000000.pkg %pkgname%.pkg
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move "%bindir%\*.pkg" "%pkgoutput%"
goto :done

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit