@echo off
title Build Languages
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
if not exist %pkgsource%\core-hdd0\%id_xmbmp% goto :error_source
call "%bindir%\global_messages.bat" "BUILDING"
for /f "tokens=1,2 delims=." %%X IN ('dir /b %languageinisdir%\*.ini') DO (
%external%\%packager% %pkgsource%\package-xmbmp.conf %pkgsource%\languagepacks\%%X\%id_xmbmp%
rename UP0001-%id_xmbmp%_00-0000000000000000.pkg XMBM+v%working_version%-LANGUAGEPACK-%%X.pkg
)
if not exist "%pkgoutput%" mkdir "%pkgoutput%"
move %bindir%\*.pkg "%pkgoutput%\"

:done
call "%bindir%\global_messages.bat" "BUILD-OK"
goto :end

:error_source
call "%bindir%\global_messages.bat" "ERROR-NO-SOURCE"
goto :end

:end
exit