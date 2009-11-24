@echo off

:SETUP_ENVIRONMENT
	:: ~dp0 expands %0 to a drive letter and path.
	:: google for "batch parameter modifiers"
	set WXWIN=%~dp0wxwidgets
	echo %WXWIN%
	goto BUILD_WXFORMBUILDER
goto CONFIGURE

:CONFIGURE
	echo Copy the setup configuration into the source tree
	copy setup.h /Y wxwidgets\include\wx\msw
	copy setup.h /Y wxwidgets\include\wx

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
goto BUILD_WXCOMPILED

:BUILD_WXCOMPILED
	echo -- WXCOMPILED ---------------------------------------------------------
	echo --
	echo Starting to build wxCompiled from %CD%
	echo Change into the build directory of the source tree
	cd wxwidgets\build\msw

	echo Run the build file for each compiler
	call wxBuild_wxWidgets.bat VC80 ALL
	if ERRORLEVEL 1 goto END
	call wxBuild_wxWidgets.bat MINGW4 ALL
	if ERRORLEVEL 1 goto END
	::call wxBuild_wxWidgets.bat MINGW4 NULL LIB_RELEASE_UNICODE
	::call wxBuild_wxWidgets.bat MINGW4 NULL DLL_RELEASE_UNICODE

	echo Change to installer directory
	cd ..\..\..\install\wxCompiled

	:: Make installer for wxCompiled
	echo Building wxCompiled installer...
	call "C:\Program Files\Inno Setup 5\iscc.exe" /F"wxWidgets_Compiled-setup" "wxWidgets_Compiled.iss"
	if ERRORLEVEL 1 goto END
	
	cd ..\..
	echo Done building wxCompiled. Current Directory: %CD%
goto BUILD_WXADDITIONS

:BUILD_WXADDITIONS
	echo -- WXADDITIONS --------------------------------------------------------
	echo --
	echo Starting to build wxAdditions from %CD%
	echo Change to additions build directory
	cd wxwidgets\additions\build
	
	call build_wxadditions.bat VC80
	if ERRORLEVEL 1 goto END
	call build_wxadditions.bat MINGW4
	if ERRORLEVEL 1 goto END
	
	echo Build the wxFormBuilder plugin
	call build_wxfb_plugin.bat

	echo Change to installer directory
	cd ..\..\..\install\wxAdditions

	:: Make installer for wxAdditions
	echo Building wxAdditions installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /F"wxAdditions-setup" "wxAdditions.iss"
	if ERRORLEVEL 1 goto END
	
	cd ..\..
	echo Done building wxAdditions. Current Directory: %CD%
goto BUILD_WXFORMBUILDER

:BUILD_WXFORMBUILDER
	echo -- WXFORMBUILDER ------------------------------------------------------
	echo --
	echo Starting to build wxFormBuilder from '%CD%'
	:: This is currently relying on the fact that MinGW was setup in the environment before running this build.
	:: It has been because we are building wxCompiled and wxAdditions before this.
	:: NOTE: This mayu be fragile, but it works.
	echo Change to wxFormBuilder build directory
	cd wxformbuilder
	
	echo Create the build files. Current Directory: %CD%
	call premake.exe --target gnu --unicode --with-wx-shared
	if ERRORLEVEL 1 goto END
	
	echo Building wxFormBuilder. Current Directory: %CD%
	call mingw32-make.exe CONFIG=Release -j %NUMBER_OF_PROCESSORS%
	if ERRORLEVEL 1 goto END
	
	echo Change to installer directory. Current Directory: %CD%
	cd install\windows
	
	echo Building wxFormBuilder installer. Current Directory: %CD%
	"C:\Program Files\Inno Setup 5\ISCC.exe" /F"wxFormBuilder-setup" "wxFormBuilder.iss"
	if ERRORLEVEL 1 goto END
	
	cd ..\..\..
	echo Done building wxFormBuilder. Current Directory: %CD%
goto BUILD_WXVC

:BUILD_WXVC
	echo -- WXVC ---------------------------------------------------------------
	echo --
	echo Starting to build wxVC from %CD%
	echo Change to wxVC installer directory
	cd install\wxVC
	
	echo Building wxVC installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /F"wxVC-setup" "wxVC.iss"
	if ERRORLEVEL 1 goto END
	
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
	"C:\Program Files\Inno Setup 5\iscc.exe" /cc "wxPack.iss"
	if ERRORLEVEL 1 goto END
	
	cd ..
	echo Done building wxVC. Current Directory: %CD%
goto END

:END
echo.
echo End (%ERRORLEVEL%)
exit %ERRORLEVEL%
