@echo off
::**************************************************************************
:: File:           wxBuild_wxWidgets.bat
:: Version:        1.17
:: Name:           RJP Computing - modified for 64-bit VS compilation
:: Date:           09/03/2009
:: Description:    Build wxWidgets with the MinGW/Visual C++.
::
::                 v1.01 - Added Compiler setup for VC7.1 and VC8.0.
::                 v1.02 - Added INCLUDE variable to VC7.1 and VC8.0 setups.
::                 v1.03 - Added FLAGS. Use to set extra command line options.
::                 v1.04 - Added flags for specific wxWidgets build options.
::                 v1.05 - Added mono static library creation. (Only needed for
::                         building wxWidgets)
::                         Added a better clean method.
::                         Added an app name parameter.
::                 v1.06 - Fixed that the monolithic static libraries were not
::                         built using the static run-time library.
::                 v1.07 - Added MinGW Gcc 4.x.x compiler.
::                 v1.08 - Added a move command to help automate building with
::                         multiple compilers from the same family.
::                         (ie. vc and gcc).
::                 v1.09 - Removed 'CXXFLAGS=/Zc:wchar_t-' from VC8.0 setup.
::                 v1.10 - Added USE_GDIPLUS=1 to FLAGS for wxGraphicsContext.
::                 v1.11 - Added support for VC 9.0
::                 v1.12 - Added support for VC 10.0 and x64 builds
::                 v1.13 - Added support for VC 12.0 and wxWidgets 3.0 and MinGW4-w64
::                 v1.14 - Added support for VC 14.0 and external 3rd party libraries
::                 v1.15 - Added support for VC 14.1
::                 v1.16 - Added support for VC 14.2
::                 v1.17 - Added support to build utils and samples
::**************************************************************************
SETLOCAL
set WXBUILD_VERSION=1.17
set WXBUILD_APPNAME=wxBuild_wxWidgets
:: MinGW Gcc install location. This must match your systems configuration.
set GCCDIR=C:\MinGW
set GCCVER=3
:: MinGW4 Gcc install location. This must match your systems configuration.
set GCC4DIR=C:\MinGW4
set GCC4VER=48
:: MinGW-w64 Gcc install location. This must match your systems configuration.
set MINGW_W64_DIR=C:\Program Files (x86)\mingw-w64\i686-8.1.0-posix-dwarf-rt_v6-rev0\mingw32
set MINGW_W64_VER=81
:: MinGW-w64 x64 Gcc install location. This must match your systems configuration.
set MINGW_W64_64_DIR=C:\Program Files\mingw-w64\x86_64-8.1.0-posix-seh-rt_v6-rev0\mingw64
set MINGW_W64_64_VER=81

set CPU=X86
set CFG=

if (%1) == () goto ERROR
:: -- Check if user wants help --
if (%1) == (/?)  goto SHOW_USAGE
if (%1) == (-?)  goto SHOW_USAGE
if (%1) == HELP  goto SHOW_USAGE
if (%1) == help  goto SHOW_USAGE
if (%2) == ()    goto ERROR

:: -- Check which compiler was selected. --
if %1 == VCTK           goto SETUP_VC71_TOOLKIT_BUILD_ENVIRONMENT
if %1 == vctk           goto SETUP_VC71_TOOLKIT_BUILD_ENVIRONMENT
if %1 == VC71           goto SETUP_VC71_BUILD_ENVIRONMENT
if %1 == vc71           goto SETUP_VC71_BUILD_ENVIRONMENT
if %1 == VC80           goto SETUP_VC80_BUILD_ENVIRONMENT
if %1 == vc80           goto SETUP_VC80_BUILD_ENVIRONMENT
if %1 == VC80_64        goto SETUP_VC80_64_BUILD_ENVIRONMENT
if %1 == vc80_64        goto SETUP_VC80_64_BUILD_ENVIRONMENT
if %1 == VC90           goto SETUP_VC90_BUILD_ENVIRONMENT
if %1 == vc90           goto SETUP_VC90_BUILD_ENVIRONMENT
if %1 == VC90_64        goto SETUP_VC90_64_BUILD_ENVIRONMENT
if %1 == vc90_64        goto SETUP_VC90_64_BUILD_ENVIRONMENT
if %1 == VC100          goto SETUP_VC100_BUILD_ENVIRONMENT
if %1 == vc100          goto SETUP_VC100_BUILD_ENVIRONMENT
if %1 == VC100_64       goto SETUP_VC100_64_BUILD_ENVIRONMENT
if %1 == vc100_64       goto SETUP_VC100_64_BUILD_ENVIRONMENT
if %1 == VC110          goto SETUP_VC110_BUILD_ENVIRONMENT
if %1 == vc110          goto SETUP_VC110_BUILD_ENVIRONMENT
if %1 == VC110_64       goto SETUP_VC110_64_BUILD_ENVIRONMENT
if %1 == vc110_64       goto SETUP_VC110_64_BUILD_ENVIRONMENT
if %1 == VC120          goto SETUP_VC120_BUILD_ENVIRONMENT
if %1 == vc120          goto SETUP_VC120_BUILD_ENVIRONMENT
if %1 == VC120_64       goto SETUP_VC120_64_BUILD_ENVIRONMENT
if %1 == vc120_64       goto SETUP_VC120_64_BUILD_ENVIRONMENT
if %1 == VC140          goto SETUP_VC140_BUILD_ENVIRONMENT
if %1 == vc140          goto SETUP_VC140_BUILD_ENVIRONMENT
if %1 == VC140_64       goto SETUP_VC140_64_BUILD_ENVIRONMENT
if %1 == vc140_64       goto SETUP_VC140_64_BUILD_ENVIRONMENT
if %1 == VC141          goto SETUP_VC141_BUILD_ENVIRONMENT
if %1 == vc141          goto SETUP_VC141_BUILD_ENVIRONMENT
if %1 == VC141_64       goto SETUP_VC141_64_BUILD_ENVIRONMENT
if %1 == vc141_64       goto SETUP_VC141_64_BUILD_ENVIRONMENT
if %1 == VC142          goto SETUP_VC142_BUILD_ENVIRONMENT
if %1 == vc142          goto SETUP_VC142_BUILD_ENVIRONMENT
if %1 == VC142_64       goto SETUP_VC142_64_BUILD_ENVIRONMENT
if %1 == vc142_64       goto SETUP_VC142_64_BUILD_ENVIRONMENT
if %1 == MINGW          goto SETUP_GCC_BUILD_ENVIRONMENT
if %1 == mingw          goto SETUP_GCC_BUILD_ENVIRONMENT
if %1 == MINGW4         goto SETUP_GCC4_BUILD_ENVIRONMENT
if %1 == mingw4         goto SETUP_GCC4_BUILD_ENVIRONMENT
if %1 == MINGW_W64      goto SETUP_MINGW_W64_BUILD_ENVIRONMENT
if %1 == mingw_w64      goto SETUP_MINGW_W64_BUILD_ENVIRONMENT
if %1 == MINGW_W64_64   goto SETUP_MINGW_W64_64_BUILD_ENVIRONMENT
if %1 == mingw_w64_64   goto SETUP_MINGW_W64_64_BUILD_ENVIRONMENT
goto COMPILER_ERROR

:SETUP_VC71_TOOLKIT_BUILD_ENVIRONMENT
:: -- Add Visual C++ directories to the systems PATH --
echo Setting environment for Visual C++ 7.1 Toolkit...
set MSVC=C:\Program Files\Microsoft Visual C++ Toolkit 2003
set MSSDK=C:\Program Files\Microsoft Platform SDK
set DOTNETSDK=C:\Program Files\Microsoft Visual Studio .NET 2003\vc7

set PATH=%MSVC%\bin;%MSSDK%\bin;%MSSDK%\bin\win64;%DOTNETSDK%\bin;%PATH%
set INCLUDE=%MSVC%\include;%MSSDK%\include;%DOTNETSDK%\include;%INCLUDE%
set LIB=%MSVC%\lib;%MSSDK%\lib;%DOTNETSDK%\lib;%LIB%
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=71
set COMPILER_NAME=vs2003
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC71_BUILD_ENVIRONMENT
:: Add the full VC 2003 .net includes.
echo Setting environment for Visual C++ 7.1...
echo.
call "C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=71
set COMPILER_NAME=vs2003
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC80_BUILD_ENVIRONMENT
:: Add the full VC 2005 includes.
echo Setting environment for Visual C++ 8.0...
echo.
call "%VS80COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=80
set COMPILER_NAME=vs2005
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC80_64_BUILD_ENVIRONMENT
:: Add the VC 2005 64-bit includes.
echo Setting environment for Visual C++ 8.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS80COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
call %CMD64% amd64
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=80
set COMPILER_NAME=vs2005
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC90_BUILD_ENVIRONMENT
:: Add the VC 2008 includes.
echo Setting environment for Visual C++ 9.0...
echo.
call "%VS90COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=90
set COMPILER_NAME=vs2008
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC90_64_BUILD_ENVIRONMENT
:: Add the VC 2009 64-bit includes.
echo Setting environment for Visual C++ 9.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS90COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
call %CMD64% amd64
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=90
set COMPILER_NAME=vs2008
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC100_BUILD_ENVIRONMENT
:: Add the VC 2010 includes.
echo Setting environment for Visual C++ 10.0...
echo.
call "%VS100COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=100
set COMPILER_NAME=vs2010
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC100_64_BUILD_ENVIRONMENT
:: Add the VC 2010 64-bit includes.
echo Setting environment for Visual C++ 10.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS100COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
call %CMD64% amd64
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=100
set COMPILER_NAME=vs2010
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC110_BUILD_ENVIRONMENT
:: Add the VC 2012 includes.
echo Setting environment for Visual C++ 11.0...
echo.
call "%VS110COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=110
set COMPILER_NAME=vs2012
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC110_64_BUILD_ENVIRONMENT
:: Add the VC 2012 64-bit includes.
echo Setting environment for Visual C++ 11.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS110COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
call %CMD64% x86_amd64
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=110
set COMPILER_NAME=vs2012
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC120_BUILD_ENVIRONMENT
:: Add the VC 2013 includes.
echo Setting environment for Visual C++ 12.0...
echo.
call "%VS120COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=120
set COMPILER_NAME=vs2013
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC120_64_BUILD_ENVIRONMENT
:: Add the VC 2013 64-bit includes.
echo Setting environment for Visual C++ 12.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS120COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
call %CMD64% x86_amd64
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=120
set COMPILER_NAME=vs2013
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC140_BUILD_ENVIRONMENT
:: Add the VS 2015 includes.
echo Setting environment for Visual C++ 14.0...
echo.
call "%VS140COMNTOOLS%vsvars32.bat"
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=140
set COMPILER_NAME=vs2015
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC140_64_BUILD_ENVIRONMENT
:: Add the VS 2015 64-bit includes.
echo Setting environment for Visual C++ 14.0 64-bit...
echo.
set CPU=AMD64
set CMD32="%VS140COMNTOOLS%vcvarsall.bat"
set CMD64=%CMD32:\Common7\Tools\=\VC\%
:: If we are on native x64, build with that, else use cross-compiler.
:: Note: Until VS2015 Update 1 happens, you will need to do this for the cross-compiler to work:
:: https://connect.microsoft.com/VisualStudio/feedback/details/1651822/incorrect-mspdb140-dll-version-picked-in-x86-x64-cross-tools-environment
set CMD64_ARG=x86_amd64
echo Determining Processor Architecture for VC140 64-bit Build.
if %PROCESSOR_ARCHITECTURE% == AMD64 set CMD64_ARG=amd64
echo Determined %CMD64_ARG%
echo.
call %CMD64% %CMD64_ARG%
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=140
set COMPILER_NAME=vs2015
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC141_BUILD_ENVIRONMENT
:: Add the VS 2017 includes.
echo Setting environment for Visual C++ 14.1...
echo.
set BASEDIR=%ProgramFiles(x86)%
if %PROCESSOR_ARCHITECTURE% == x86 set BASEDIR=%ProgramFiles%
for /f "usebackq tokens=*" %%i in (`"%BASEDIR%\Microsoft Visual Studio\Installer\vswhere.exe" -version 15 -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set INSTALLDIR=%%i
)
if not exist "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" (
  echo ERROR OCCURED!
  echo Compiler not found.
  goto END
)
call "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" -no_logo -vcvars_ver=14.1 -arch=x86
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=141
set COMPILER_NAME=vs2017
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC141_64_BUILD_ENVIRONMENT
:: Add the VS 2017 64-bit includes.
echo Setting environment for Visual C++ 14.1 64-bit...
echo.
set CPU=AMD64
set HOSTARCH=x86
echo Determining Processor Architecture for VC141 64-bit Build.
if %PROCESSOR_ARCHITECTURE% == AMD64 set HOSTARCH=amd64
echo Determined %HOSTARCH%
echo.
set BASEDIR=%ProgramFiles(x86)%
if %PROCESSOR_ARCHITECTURE% == x86 set BASEDIR=%ProgramFiles%
for /f "usebackq tokens=*" %%i in (`"%BASEDIR%\Microsoft Visual Studio\Installer\vswhere.exe" -version 15 -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set INSTALLDIR=%%i
)
if not exist "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" (
  echo ERROR OCCURED!
  echo Compiler not found.
  goto END
)
call "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" -no_logo -vcvars_ver=14.1 -arch=amd64 -host_arch=%HOSTARCH%
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=141
set COMPILER_NAME=vs2017
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC142_BUILD_ENVIRONMENT
:: Add the VS 2019 includes.
echo Setting environment for Visual C++ 14.2...
echo.
set BASEDIR=%ProgramFiles(x86)%
if %PROCESSOR_ARCHITECTURE% == x86 set BASEDIR=%ProgramFiles%
for /f "usebackq tokens=*" %%i in (`"%BASEDIR%\Microsoft Visual Studio\Installer\vswhere.exe" -version 16 -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set INSTALLDIR=%%i
)
if not exist "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" (
  echo ERROR OCCURED!
  echo Compiler not found.
  goto END
)
call "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" -no_logo -vcvars_ver=14.2 -arch=x86
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=142
set COMPILER_NAME=vs2019
set COMPILER_ARCH=32
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_VC142_64_BUILD_ENVIRONMENT
:: Add the VS 2019 64-bit includes.
echo Setting environment for Visual C++ 14.2 64-bit...
echo.
set CPU=AMD64
set HOSTARCH=x86
echo Determining Processor Architecture for VC142 64-bit Build.
if %PROCESSOR_ARCHITECTURE% == AMD64 set HOSTARCH=amd64
echo Determined %HOSTARCH%
echo.
set BASEDIR=%ProgramFiles(x86)%
if %PROCESSOR_ARCHITECTURE% == x86 set BASEDIR=%ProgramFiles%
for /f "usebackq tokens=*" %%i in (`"%BASEDIR%\Microsoft Visual Studio\Installer\vswhere.exe" -version 16 -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set INSTALLDIR=%%i
)
if not exist "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" (
  echo ERROR OCCURED!
  echo Compiler not found.
  goto END
)
call "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" -no_logo -vcvars_ver=14.2 -arch=amd64 -host_arch=%HOSTARCH%
:: -- Setup the make executable and the actual makefile name --
set MAKE=nmake
set MAKEFILE=makefile.vc
set FLAGS=
set COMPILER_VERSION=142
set COMPILER_NAME=vs2019
set COMPILER_ARCH=64
set BAKE_FORMAT=msvc
set BAKE_OPTIONS_FILE=config.vc
goto START

:SETUP_GCC_BUILD_ENVIRONMENT
echo Assuming that GCC has been installed to:
echo   %GCCDIR%
echo.
:: -- Add MinGW directory to the systems PATH --
echo Setting environment for MinGW Gcc...
if "%OS%" == "Windows_NT" set PATH=%GCCDIR%\BIN;%PATH%
if "%OS%" == "" set PATH="%GCCDIR%\BIN";"%PATH%"
echo.
:: -- Setup the make executable and the actual makefile name --
set MAKE=mingw32-make.exe
set MAKEFILE=makefile.gcc
set FLAGS=-j %NUMBER_OF_PROCESSORS%
set COMPILER_VERSION=%GCCVER%
set COMPILER_NAME=mingw
set COMPILER_ARCH=32
set BAKE_FORMAT=mingw
set BAKE_OPTIONS_FILE=config.gcc
goto START

:SETUP_GCC4_BUILD_ENVIRONMENT
echo Assuming that GCC4 has been installed to:
echo   %GCC4DIR%
echo.
:: -- Add MinGW directory to the systems PATH --
echo Setting environment for MinGW Gcc...
if "%OS%" == "Windows_NT" set PATH=%GCC4DIR%\BIN;%PATH%
if "%OS%" == "" set PATH="%GCC4DIR%\BIN";"%PATH%"
echo.
:: -- Setup the make executable and the actual makefile name --
set MAKE=mingw32-make.exe
set MAKEFILE=makefile.gcc
set FLAGS=CXXFLAGS=-Wno-attributes -j %NUMBER_OF_PROCESSORS%
set COMPILER_VERSION=%GCC4VER%
set COMPILER_NAME=mingw
set COMPILER_ARCH=32
set BAKE_FORMAT=mingw
set BAKE_OPTIONS_FILE=config.gcc
goto START

:SETUP_MINGW_W64_BUILD_ENVIRONMENT
echo Assuming that MinGW-w64 has been installed to:
echo   %MINGW_W64_DIR%
echo.
:: -- Add MinGW directory to the systems PATH --
echo Setting environment for MinGW4-w64 Gcc...
if "%OS%" == "Windows_NT" set PATH=%MINGW_W64_DIR%\BIN;%PATH%
if "%OS%" == "" set PATH="%MINGW_W64_DIR%\BIN";"%PATH%"
echo.
:: -- Setup the make executable and the actual makefile name --
set MAKE=mingw32-make.exe
set MAKEFILE=makefile.gcc
set FLAGS=CXXFLAGS=-Wno-attributes -j %NUMBER_OF_PROCESSORS% CFLAGS=-m32 CPPFLAGS=-m32 LDFLAGS=-m32 CC="gcc -m32" WINDRES="windres --use-temp-file -F pe-i386"
set COMPILER_VERSION=%MINGW_W64_VER%
set COMPILER_NAME=mingw
set COMPILER_ARCH=32
set BAKE_FORMAT=mingw
set BAKE_OPTIONS_FILE=config.gcc
goto START

:SETUP_MINGW_W64_64_BUILD_ENVIRONMENT
echo Assuming that MinGW-w64 has been installed to:
echo   %MINGW_W64_64_DIR%
echo.
:: -- Add MinGW directory to the systems PATH --
echo Setting environment for MinGW4-w64 64-bit Gcc...
if "%OS%" == "Windows_NT" set PATH=%MINGW_W64_64_DIR%\BIN;%PATH%
if "%OS%" == "" set PATH="%MINGW_W64_64_DIR%\BIN";"%PATH%"
echo.
:: -- Setup the make executable and the actual makefile name --
set CFG=_x64
set MAKE=mingw32-make.exe
set MAKEFILE=makefile.gcc
set FLAGS=CXXFLAGS=-Wno-attributes -j %NUMBER_OF_PROCESSORS%
set COMPILER_VERSION=%MINGW_W64_64_VER%
set COMPILER_NAME=mingw
set COMPILER_ARCH=64
set BAKE_FORMAT=mingw
set BAKE_OPTIONS_FILE=config.gcc
goto START

:START
echo %WXBUILD_APPNAME% v%WXBUILD_VERSION%
echo.

if %2 == LIB   goto LIB_BUILD_UNICODE
if %2 == lib   goto LIB_BUILD_UNICODE
if %2 == DLL   goto DLL_BUILD_UNICODE
if %2 == dll   goto DLL_BUILD_UNICODE
if %2 == ALL   goto ALL_BUILD
if %2 == all   goto ALL_BUILD
if %2 == NULL  goto SECIFIC_BUILD
if %2 == null  goto SECIFIC_BUILD
goto WRONGPARAM

:SECIFIC_BUILD
echo Specific mode...
echo.
IF (%3) == () goto ERROR
goto %3

:ALL_BUILD
echo Compiling all versions.
echo.
goto LIB_BUILD_UNICODE

:LIB_BUILD_UNICODE
echo Building Unicode Lib's...
echo.
goto LIB_DEBUG_UNICODE

:LIB_DEBUG_UNICODE
echo Compiling lib debug Unicode...
call wxBuild_Bakefile.bat debug
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug UNICODE=1 OFFICIAL_BUILD=1 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto LIB_RELEASE_UNICODE

:LIB_RELEASE_UNICODE
echo Compiling lib release Unicode...
call wxBuild_Bakefile.bat release
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release UNICODE=1 OFFICIAL_BUILD=1 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto LIB_BUILD_MONO_UNICODE

:LIB_BUILD_MONO_UNICODE
echo Building Monolithic Unicode lib's...
echo.
goto LIB_DEBUG_MONO_UNICODE

:LIB_DEBUG_MONO_UNICODE
echo Compiling lib debug Unicode monolithic...
call wxBuild_Bakefile.bat debug
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=1 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto LIB_RELEASE_MONO_UNICODE

:LIB_RELEASE_MONO_UNICODE
echo Compiling lib release Unicode monolithic...
call wxBuild_Bakefile.bat release
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=1 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for build all
if %2 == all goto DLL_BUILD_UNICODE
if %2 == ALL goto DLL_BUILD_UNICODE
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto END

:DLL_BUILD_UNICODE
echo Building Unicode Dll's...
echo.
goto DLL_DEBUG_UNICODE

:DLL_DEBUG_UNICODE
echo Compiling dll debug Unicode...
call wxBuild_Bakefile.bat debug
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug SHARED=1 UNICODE=1 OFFICIAL_BUILD=1 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto DLL_RELEASE_UNICODE

:DLL_RELEASE_UNICODE
echo Compiling dll release Unicode...
call wxBuild_Bakefile.bat release
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release SHARED=1 UNICODE=1 OFFICIAL_BUILD=1 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto DLL_BUILD_MONO_UNICODE

:DLL_BUILD_MONO_UNICODE
echo Building Monolithic Unicode Dll's...
echo.
goto DLL_DEBUG_MONO_UNICODE

:DLL_DEBUG_MONO_UNICODE
echo Compiling dll debug Unicode monolithic...
call wxBuild_Bakefile.bat debug
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=1 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto DLL_RELEASE_MONO_UNICODE

:DLL_RELEASE_MONO_UNICODE
echo Compiling dll release Unicode monolithic...
call wxBuild_Bakefile.bat release
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=1 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%

echo.
:: Check for specific mode.
if %2 == null goto END
if %2 == NULL goto END
goto END

:UTILS_LIB_DEBUG_UNICODE
echo Compiling utils lib debug Unicode...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_LIB_RELEASE_UNICODE
echo Compiling utils lib release Unicode...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_LIB_DEBUG_MONO_UNICODE
echo Compiling utils lib debug Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_LIB_RELEASE_MONO_UNICODE
echo Compiling utils lib release Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_DLL_DEBUG_UNICODE
echo Compiling utils dll debug Unicode...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_DLL_RELEASE_UNICODE
echo Compiling utils dll release Unicode...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_DLL_DEBUG_MONO_UNICODE
echo Compiling utils dll debug Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:UTILS_DLL_RELEASE_MONO_UNICODE
echo Compiling utils dll release Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\utils
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_LIB_DEBUG_UNICODE
echo Compiling samples lib debug Unicode...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_LIB_RELEASE_UNICODE
echo Compiling samples lib release Unicode...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_LIB_DEBUG_MONO_UNICODE
echo Compiling samples lib debug Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_LIB_RELEASE_MONO_UNICODE
echo Compiling samples lib release Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=0 UNICODE=1 OFFICIAL_BUILD=0 RUNTIME_LIBS=static TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_DLL_DEBUG_UNICODE
echo Compiling samples dll debug Unicode...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_DLL_RELEASE_UNICODE
echo Compiling samples dll release Unicode...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_DLL_DEBUG_MONO_UNICODE
echo Compiling samples dll debug Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=debug MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:SAMPLES_DLL_RELEASE_MONO_UNICODE
echo Compiling samples dll release Unicode monolithic...
set OLDDIR=%CD%
cd ..\..\samples
:: Calling the compilers  make
%MAKE% -f %MAKEFILE%  BUILD=release MONOLITHIC=1 SHARED=1 UNICODE=1 OFFICIAL_BUILD=0 TARGET_CPU=%CPU% COMPILER_VERSION=%COMPILER_VERSION% %FLAGS%
cd /D "%OLDDIR%"

echo.
:: This can only be used in specific mode.
goto END

:ERROR
echo.
echo ERROR OCCURED!
echo Not enough command line parameters.
goto SHOW_USAGE

:WRONGPARAM
echo.
echo ERROR OCCURED!
echo The command line parameters was %1. This is not an available option.
goto SHOW_USAGE

:COMPILER_ERROR
echo.
echo ERROR OCCURED!
echo Unsupported compiler. %1 is not an available compiler option.
goto SHOW_USAGE

:SHOW_USAGE
echo.
echo %WXBUILD_APPNAME% v%WXBUILD_VERSION%
echo     Build wxWidgets with the MinGW/Visual C++ Tool chains.
echo.
echo Usage: "wxBuild_wxWidgets.bat <Compiler{MINGW*|VC*}> <BuildTarget{LIB|DLL|ALL|NULL}> [Specific Option]"
goto SHOW_OPTIONS

:SHOW_OPTIONS
echo.
echo      Compiler Options:
echo           MINGW         = MinGW Gcc v3.x.x compiler
echo           MINGW4        = MinGW Gcc v4.x.x compiler
echo           MINGW_W64     = MinGW-w64 Gcc compiler
echo           MINGW_W64_64  = MinGW-w64 Gcc compiler 64-bit
echo           VCTK          = Visual C++ 7.1 Toolkit
echo           VC71          = Visual C++ 7.1
echo           VC80          = Visual C++ 8.0
echo           VC80_64       = Visual C++ 8.0 64-bit
echo           VC90          = Visual C++ 9.0
echo           VC90_64       = Visual C++ 9.0 64-bit
echo           VC100         = Visual C++ 10.0
echo           VC100_64      = Visual C++ 10.0 64-bit
echo           VC110         = Visual C++ 11.0
echo           VC110_64      = Visual C++ 11.0 64-bit
echo           VC120         = Visual C++ 12.0
echo           VC120_64      = Visual C++ 12.0 64-bit
echo           VC140         = Visual C++ 14.0
echo           VC140_64      = Visual C++ 14.0 64-bit
echo           VC141         = Visual C++ 14.1
echo           VC141_64      = Visual C++ 14.1 64-bit
echo           VC142         = Visual C++ 14.2
echo           VC142_64      = Visual C++ 14.2 64-bit
echo.
echo      BuildTarget Options:
echo           LIB   = Builds all the static library targets.
echo           DLL   = Builds all the dynamic library targets.
echo           ALL   = Builds all the library targets (Recommended).
echo           NULL  = Used to build a specific target only (See below).
echo.
echo      Specific Options (Used with NULL):
echo           LIB_DEBUG_UNICODE, LIB_RELEASE_UNICODE,
echo           LIB_DEBUG_MONO_UNICODE, LIB_RELEASE_MONO_UNICODE,
echo.
echo           DLL_DEBUG_UNICODE, DLL_RELEASE_UNICODE,
echo           DLL_DEBUG_MONO_UNICODE, DLL_RELEASE_MONO_UNICODE
echo.
echo           UTILS_LIB_DEBUG_UNICODE, UTILS_LIB_RELEASE_UNICODE,
echo           UTILS_LIB_DEBUG_MONO_UNICODE, UTILS_LIB_RELEASE_MONO_UNICODE,
echo.
echo           UTILS_DLL_DEBUG_UNICODE, UTILS_DLL_RELEASE_UNICODE,
echo           UTILS_DLL_DEBUG_MONO_UNICODE, UTILS_DLL_RELEASE_MONO_UNICODE
echo.
echo           SAMPLES_LIB_DEBUG_UNICODE, SAMPLES_LIB_RELEASE_UNICODE,
echo           SAMPLES_LIB_DEBUG_MONO_UNICODE, SAMPLES_LIB_RELEASE_MONO_UNICODE,
echo.
echo           SAMPLES_DLL_DEBUG_UNICODE, SAMPLES_DLL_RELEASE_UNICODE,
echo           SAMPLES_DLL_DEBUG_MONO_UNICODE, SAMPLES_DLL_RELEASE_MONO_UNICODE
echo.
echo      Examples:
echo           wxBuild_default.bat MINGW ALL
echo                Builds all targets with MinGW Gcc Compiler.
echo.
echo           wxBuild_default.bat VCTK LIB
echo                Builds just the static libraries with Visual C++ 7.1 Toolkit.
echo.
echo           wxBuild_default.bat VCTK NULL LIB_RELEASE_UNICODE
echo                Builds only the release static library with Visual C++ 7.1 Toolkit
goto END

:END
set WXBUILD_VERSION=
set WXBUILD_APPNAME=
set GCCDIR=
set GCCVER=
set GCC4DIR=
set GCC4VER=
set MINGW_W64_DIR=
set MINGW_W64_VER=
set MINGW_W64_64_DIR=
set MINGW_W64_64_VER=
set CPU=
set CFG=
set HOSTARCH=
set CMD32=
set CMD64=
set BASEDIR=
set INSTALLDIR=
set MAKE=
set MAKEFILE=
set FLAGS=
set COMPILER_VERSION=
set COMPILER_NAME=
set COMPILER_ARCH=
set BAKE_FORMAT=
set BAKE_OPTIONS_FILE=
set OLDDIR=
ENDLOCAL
