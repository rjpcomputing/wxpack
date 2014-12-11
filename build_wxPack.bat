@echo off

:SETUP_ENVIRONMENT
	:: ~dp0 expands %0 to a drive letter and path.
	:: google for "batch parameter modifiers"
	set WXWIN=%~dp0wxwidgets
	echo %WXWIN%
goto CONFIGURE

:CONFIGURE
	echo Copy the setup configuration into the source tree
	copy setup.h /Y wxwidgets\include\wx\msw
	copy setup.h /Y wxwidgets\include\wx

	echo Copy the documentation into the install tree
	xcopy /Y /I /S support wxwidgets

	echo Copy build script to build directory
	copy wxBuild_wxWidgets.bat /Y wxwidgets\build\msw

	echo Create directories for binary targets in GCC because of a bug in the wx Makefiles.
	mkdir wxwidgets\lib\gcc48_dll\msw\wx
	mkdir wxwidgets\lib\gcc48_dll\mswd\wx
	mkdir wxwidgets\lib\gcc48_dll\mswu\wx
	mkdir wxwidgets\lib\gcc48_dll\mswud\wx
	mkdir wxwidgets\lib\gcc48_lib\msw\wx
	mkdir wxwidgets\lib\gcc48_lib\mswd\wx
	mkdir wxwidgets\lib\gcc48_lib\mswu\wx
	mkdir wxwidgets\lib\gcc48_lib\mswud\wx

	mkdir wxwidgets\lib\gcc48_dll_x64\msw\wx
	mkdir wxwidgets\lib\gcc48_dll_x64\mswd\wx
	mkdir wxwidgets\lib\gcc48_dll_x64\mswu\wx
	mkdir wxwidgets\lib\gcc48_dll_x64\mswud\wx
	mkdir wxwidgets\lib\gcc48_lib_x64\msw\wx
	mkdir wxwidgets\lib\gcc48_lib_x64\mswd\wx
	mkdir wxwidgets\lib\gcc48_lib_x64\mswu\wx
	mkdir wxwidgets\lib\gcc48_lib_x64\mswud\wx
	
	set INNOSETUPPATH=
	if exist "%ProgramFiles%\Inno Setup 5\iscc.exe" set INNOSETUPPATH="%ProgramFiles%\Inno Setup 5\iscc.exe"
	if exist "%ProgramFiles(x86)%\Inno Setup 5\iscc.exe" set INNOSETUPPATH="%ProgramFiles(x86)%\Inno Setup 5\iscc.exe"
	IF (%INNOSETUPPATH%) == () goto ERROR
	echo InnoSetup 5 detected at '%INNOSETUPPATH%'
	
	
	echo Get wxFormBuilders source
	svn checkout svn://svn.code.sf.net/p/wxformbuilder/code/3.x/trunk/ wxformbuilder
	if ERRORLEVEL 1 goto ERROR

	echo Get wxAdditions source
	svn checkout svn://svn.code.sf.net/p/wxformbuilder/code/plugins/additions/trunk/ wxwidgets/additions
	if ERRORLEVEL 1 goto ERROR

	echo Cleaning up the old wxPack installs...
	del /F /Q %~dp0install\wxPack_v*
goto BUILD_WXCOMPILED


:BUILD_WXCOMPILED
	echo -- WXCOMPILED ---------------------------------------------------------
	echo --
	echo Starting to build wxCompiled from %CD%
	echo Change into the build directory of the source tree
	cd wxwidgets\build\msw

	echo Run the build file for each compiler
	call wxBuild_wxWidgets.bat VC100 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat VC100_64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat VC120 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat VC120_64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat MINGW4_W64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat MINGW4_W64_64 ALL
	if ERRORLEVEL 1 goto ERROR

	echo Change to installer directory
	cd ..\..\..\install\wxCompiled

	:: Make installer for wxCompiled
	echo Building wxCompiled installer...
	call %INNOSETUPPATH% /Q /F"wxWidgets_Compiled-setup" "wxWidgets_Compiled.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..
	echo Done building wxCompiled. Current Directory: %CD%
goto BUILD_WXADDITIONS

:BUILD_WXADDITIONS
	echo -- WXADDITIONS --------------------------------------------------------
	echo --
	echo Starting to build wxAdditions from %CD%
	echo Change to additions build directory
	cd wxwidgets\additions\build

	call wxBuild_wxAdditions.bat VC100 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxAdditions.bat VC100_64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxAdditions.bat VC120 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxAdditions.bat VC120_64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxAdditions.bat MINGW4_W64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxAdditions.bat MINGW4_W64_64 ALL
	if ERRORLEVEL 1 goto ERROR

	echo Build the wxFormBuilder plugin
	echo Change to wxFormBuilder plugin directory
	cd ..\wxfbPlugin
	call wxBuild_wxFormBuilderPlugin.bat

	echo Change to installer directory
	cd ..\..\..\install\wxAdditions

	:: Make installer for wxAdditions
	echo Building wxAdditions installer...
	%INNOSETUPPATH% /Q /F"wxAdditions-setup" "wxAdditions.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..
	echo Done building wxAdditions. Current Directory: %CD%
goto BUILD_WXFORMBUILDER

:BUILD_WXFORMBUILDER
	echo -- WXFORMBUILDER ------------------------------------------------------
	echo --
	echo Starting to build wxFormBuilder from '%CD%'

	:: MinGW Gcc install location. This must match you systems configuration.
	set GCCDIR=C:\GCC\MinGW-w64\4.8.1
	set CC=gcc
	set CXX=g++

	echo Assuming that MinGW has been installed to:
	echo   %GCCDIR%
	echo.
	:: -- Add MinGW directory to the systems PATH --
	echo Setting environment for MinGW Gcc...
	if "%OS%" == "Windows_NT" set PATH=%GCCDIR%\BIN;%PATH%
	if "%OS%" == "" set PATH="%GCCDIR%\BIN";"%PATH%"
	echo.

	echo Change to wxFormBuilder build directory
	cd wxformbuilder

	echo Copying over wxWidgets dlls from %WXWIN%
	copy %WXWIN%\lib\gcc48_dll\wxmsw30u_gcc48.dll /Y output\
	echo Copying over MinGW dlls

	echo Create the build files.
	call create_build_files4.bat --wx-version=3.0 --compiler=mingw64 --compiler-version=48
	if ERRORLEVEL 1 goto ERROR

	echo Change to build directory.
	cd build\3.0\gmake
	
	echo Building wxFormBuilder.
	call mingw32-make.exe config=release
	if ERRORLEVEL 1 goto ERROR

	echo Change to installer directory.
	cd ..\..\..\install\windows

	echo Building wxFormBuilder installer. Current Directory: %CD%
	call %INNOSETUPPATH% /Q /F"wxFormBuilder-setup" "wxFormBuilder.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..\..
	echo Done building wxFormBuilder. Current Directory: %CD%
goto BUILD_WXPACK

:BUILD_WXPACK
	echo -- WXPACK -------------------------------------------------------------
	echo --
	echo Starting to build wxPack from %CD%
	echo Change to wxPack installer directory
	cd install

	echo Building wxPack installer...
	call %INNOSETUPPATH% /Q "wxPack.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..
	echo Done building wxPack. Current Directory: %CD%
goto END

:ERROR
	set ERR=%ERRORLEVEL%
	echo An error (%ERR%) occurred...
	echo.
	echo Cleaning up the old wxPack installs...
	del /F /Q %~dp0install\wxPack_v*
	exit %ERR%
goto END

:END
echo.
echo End (%ERRORLEVEL%)
exit %ERRORLEVEL%
