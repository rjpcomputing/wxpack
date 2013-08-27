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
	mkdir wxwidgets\lib\gcc_dll\msw\wx
	mkdir wxwidgets\lib\gcc_dll\mswd\wx
	mkdir wxwidgets\lib\gcc_dll\mswu\wx
	mkdir wxwidgets\lib\gcc_dll\mswud\wx
	mkdir wxwidgets\lib\gcc_lib\msw\wx
	mkdir wxwidgets\lib\gcc_lib\mswd\wx
	mkdir wxwidgets\lib\gcc_lib\mswu\wx
	mkdir wxwidgets\lib\gcc_lib\mswud\wx

	echo Get wxFormBuilders source
	svn checkout https://svn.code.sf.net/p/wxformbuilder/code/3.x/trunk/ wxformbuilder

	echo Get wxAdditions source
	svn checkout https://svn.code.sf.net/p/wxformbuilder/code/plugins/additions/trunk/ wxwidgets/additions

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
	call wxBuild_wxWidgets.bat VC110 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat VC110_64 ALL
	if ERRORLEVEL 1 goto ERROR
	call wxBuild_wxWidgets.bat MINGW4 ALL
	if ERRORLEVEL 1 goto ERROR

	echo Change to installer directory
	cd ..\..\..\install\wxCompiled

	:: Make installer for wxCompiled
	echo Building wxCompiled installer...
	call "%ProgramFiles%\Inno Setup 5\iscc.exe" /Q /F"wxWidgets_Compiled-setup" "wxWidgets_Compiled.iss"
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

	call build_wxadditions.bat VC110
	if ERRORLEVEL 1 goto ERROR
	call build_wxadditions.bat VC110_64
	if ERRORLEVEL 1 goto ERROR
	call build_wxadditions.bat MINGW4
	if ERRORLEVEL 1 goto ERROR

	echo Move 64bit directory to lib64
	:: Move Visual C++ 10.0 64-bit directories.
	if not exist ..\lib64 mkdir ..\lib64
	if exist ..\lib\vc_amd64_lib move /Y ..\lib\vc_amd64_lib ..\lib64\vc_lib
	if exist ..\lib\vc_amd64_dll move /Y ..\lib\vc_amd64_dll ..\lib64\vc_dll

	echo Build the wxFormBuilder plugin
	call build_wxfb_plugin.bat

	echo Change to installer directory
	cd ..\..\..\install\wxAdditions

	:: Make installer for wxAdditions
	echo Building wxAdditions installer...
	"%ProgramFiles%\Inno Setup 5\iscc.exe" /Q /F"wxAdditions-setup" "wxAdditions.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..
	echo Done building wxAdditions. Current Directory: %CD%
goto BUILD_WXFORMBUILDER

:BUILD_WXFORMBUILDER
	echo -- WXFORMBUILDER ------------------------------------------------------
	echo --
	echo Starting to build wxFormBuilder from '%CD%'

	:: MinGW Gcc install location. This must match you systems configuration.
	set GCCDIR=C:\MinGW4
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
	copy %WXWIN%\lib\gcc_dll\wxmsw28u_gcc.dll /Y output\
	echo Copying over MinGW dlls
	copy %GCCDIR%\bin\mingwm10.dll /Y output\
	::copy %GCCDIR%\bin\libgcc_s_dw2-1.dll /Y output\
	copy %GCCDIR%\bin\libintl-8.dll /Y output\
	copy %GCCDIR%\bin\libiconv-2.dll /Y output\

	echo Create the build files.
	call create_build_files4.bat
	if ERRORLEVEL 1 goto ERROR

	echo Change to build directory.
	cd build\2.8\gmake
	
	echo Building wxFormBuilder.
	call mingw32-make.exe config=release
	if ERRORLEVEL 1 goto ERROR

	echo Change to installer directory.
	cd ..\..\..\install\windows

	echo Building wxFormBuilder installer. Current Directory: %CD%
	call "%ProgramFiles%\Inno Setup 5\ISCC.exe" /Q /F"wxFormBuilder-setup" "wxFormBuilder.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..\..
	echo Done building wxFormBuilder. Current Directory: %CD%
::goto BUILD_WXVC
goto BUILD_WXPACK

:BUILD_WXVC
	echo -- WXVC ---------------------------------------------------------------
	echo --
	echo Starting to build wxVC from %CD%
	echo Change to wxVC installer directory
	cd install\wxVC

	echo Building wxVC installer...
	call "%ProgramFiles%\Inno Setup 5\iscc.exe" /Q /F"wxVC-setup" "wxVC.iss"
	if ERRORLEVEL 1 goto ERROR

	cd ..\..
	echo Done building wxVC. Current Directory: %CD%
goto BUILD_WXPACK

:BUILD_WXPACK
	echo -- WXPACK -------------------------------------------------------------
	echo --
	echo Starting to build wxPack from %CD%
	echo Change to wxPack installer directory
	cd install

	echo Building wxPack installer...
	call "%ProgramFiles%\Inno Setup 5\iscc.exe" /Q "wxPack.iss"
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
