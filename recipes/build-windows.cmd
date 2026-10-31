@echo off
rem Build Vim from the pinned upstream tarball into %VIBE_OUT% with MinGW-w64
rem (gcc and mingw32-make on PATH, for example C:\opt\mingw64\bin).
rem vibe lays the tarball out as %VIBE_SOURCES%\vim\vim-<version>\ and installs
rem a non-empty %VIBE_OUT% as the payload; nothing here depends on the
rem staging path, so the payload may be moved.
setlocal
for /d %%D in ("%VIBE_SOURCES%\vim\vim-*") do set "SRC=%%~fD"
if not defined SRC exit /b 2
cd /d "%SRC%\src" || exit /b 2
mingw32-make -f Make_ming.mak ARCH=x86-64 CPU=x86-64 GUI=no OLE=no FEATURES=NORMAL || exit /b 1
mkdir "%VIBE_OUT%\vim92" || exit /b 1
copy /y vim.exe "%VIBE_OUT%\vim92\vim.exe" >nul || exit /b 1
copy /y xxd\xxd.exe "%VIBE_OUT%\vim92\xxd.exe" >nul
xcopy /e /i /q /y "%SRC%\runtime" "%VIBE_OUT%\vim92" >nul || exit /b 1
endlocal
