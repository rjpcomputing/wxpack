@echo off
echo Copy the setup configuration into the source tree
copy setup.h /Y wxwidgets\include\wx\msw
copy setup.h /Y wxwidgets\include\wx

echo Copy build script to build directory
copy wxBuild_wxWidgets.bat /Y wxwidgets\build\msw

::echo Create directories for binary targets
::mkdir wxwidgets\lib\gcc_dll
::mkdir wxwidgets\lib\gcc_lib
::mkdir wxwidgets\lib\vc_dll
::mkdir wxwidgets\lib\vc_lib

echo Change into the build directory of the source tree
cd wxwidgets\build\msw

echo Run the build file for each compiler
call wxBuild_wxWidgets.bat VC80 ALL
call wxBuild_wxWidgets.bat MINGW4 ALL

echo Move the built binaries to save them from being overwritten
call wxBuild_wxWidgets.bat VC80 MOVE
call wxBuild_wxWidgets.bat MINGW4 MOVE

echo Change to installer directory
cd ..\..\..\install\wxCompiled 

:: Make installer for wxCompiled
echo Building installer...
:: "C:\Program Files\Inno Setup 5\Compil32.exe" /cc "wxWidgets Compiled.iss"

echo Change to additions build directory
cd ..\..\wxwidgets\additions\build
call build_wxadditions VC80
call build_wxadditions MINGW4

