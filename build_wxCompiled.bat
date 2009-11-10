@echo off

:SETUP_ENVIRONMENT
	:: ~dp0 expands %0 to a drive letter and path.
	:: google for "batch parameter modifiers"
	set WXWIN=%~dp0wxwidgets
	echo %WXWIN%
	::goto END
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
	echo Change into the build directory of the source tree
	cd wxwidgets\build\msw

	echo Run the build file for each compiler
	call wxBuild_wxWidgets.bat VC80 ALL
	call wxBuild_wxWidgets.bat MINGW4 ALL
	::call wxBuild_wxWidgets.bat MINGW4 NULL LIB_RELEASE_UNICODE
	::call wxBuild_wxWidgets.bat MINGW4 NULL DLL_RELEASE_UNICODE

	echo Change to installer directory
	cd ..\..\..\install\wxCompiled

	:: Make installer for wxCompiled
	echo Building wxCompiled installer...
	call "C:\Program Files\Inno Setup 5\iscc.exe" /F"wxWidgets_Compiled-setup" "wxWidgets_Compiled.iss"
	
	cd ..\..
goto BUILD_WXADDITIONS

:BUILD_WXADDITIONS
	echo Change to additions build directory
	cd wxwidgets\additions\build
	call build_wxadditions VC80
	call build_wxadditions MINGW4

	echo Change to installer directory
	cd ..\..\..\install\wxAdditions

	:: Make installer for wxAdditions
	echo Building wxAdditions installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /F"wxAdditions-setup" "wxAdditions.iss"
	
	cd ..\..
goto BUILD_WXFORMBUILDER

:BUILD_WXFORMBUILDER
	:: This is currently relying on the fact that MinGW was setup in the environment before running this build.
	:: It has been because we are building wxCompiled and wxAdditions before this.
	:: NOTE: This mayu be fragile, but it works.
	echo Change to wxFormBuilder build directory
	cd wxformbuilder
	
	echo Create the build files...
	call premake --target gnu --unicode --with-wx-shared
	
	echo Building wxFormBuilder
	call mingw32-make.exe CONFIG=Release -j
	
	echo Change to installer directory
	cd install\windows
	
	echo Building wxFormBuilder installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /F"wxFormBuilder-setup" "wxFormBuilder.iss"
	
	cd ..\..\..
goto BUILD_WXVC

:BUILD_WXVC
	echo Change to wxVC installer directory
	cd install\wxVC
	
	echo Building wxFormBuilder installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /F"wxVC-setup" "wxVC.iss"
	
	cd ..\..
goto BUILD_WXPACK

:BUILD_WXPACK
	echo Change to wxPack installer directory
	cd install
	
	echo Building wxFormBuilder installer...
	"C:\Program Files\Inno Setup 5\iscc.exe" /cc "wxPack.iss"
	
	cd ..
goto END

:END
