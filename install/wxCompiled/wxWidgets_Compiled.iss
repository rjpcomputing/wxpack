;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxWidgets_Compiled.iss
; Author:      Ryan Pusztai
; Date:        11/28/2005
; Copyright:   (c) 2007 Ryan Pusztai <rpusztai@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define wxMajorVersion "3.0"
#define wxMinorVersion "2"
#define MyAppVer "3.0.2.06"
#define MyAppName "wxWidgets"
#define MyAppVerName "wxWidgets Compiled 3.0.2"
#define MyAppPublisher "Julian Smart"
#define MyAppURL "http://www.wxwidgets.org/"
#define wxWidgetsGUID "C8088AE5-A62A-4C29-A3D5-E5E258B517DE"
#define AppMinVer "3.0.2.06

[Setup]
AppID={{C8088AE5-A62A-4C29-A3D5-E5E258B517DE}
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\SourceCode\Libraries\{#MyAppName}{#wxMajorVersion}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=false
AllowNoIcons=true
OutputBaseFilename={#MyAppName}_Compiled_v{#MyAppVer}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir=.
ShowLanguageDialog=yes
AppVersion={#MyAppVer}
WizardImageFile=compiler:wizmodernimage-IS.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp
SetupIconFile=support\mondrian.ico
LicenseFile=license.txt
UsePreviousAppDir=true
DisableDirPage=false
AppendDefaultGroupName=false
ChangesEnvironment=true
AlwaysShowComponentsList=false
VersionInfoVersion={#MyAppVer}
VersionInfoDescription={#MyAppName}

[Files]
Source: ..\..\wxwidgets\docs\licence.txt; DestDir: {app}; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\art\*; DestDir: {app}\art; Flags: ignoreversion recursesubdirs; Excludes: .svn\
;Source: ..\..\wxwidgets\contrib\*; DestDir: {app}\contrib; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\docs\*; DestDir: {app}\docs; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\locale\*; DestDir: {app}\locale; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\samples\*; DestDir: {app}\samples; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\utils\*; DestDir: {app}\utils; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\build\*; DestDir: {app}\build; Flags: ignoreversion recursesubdirs; Excludes: .svn\, *.ilk, *.exp, *.pch, *.o, *.d, *.obj
Source: ..\..\wxwidgets\include\*; DestDir: {app}\include; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\src\*; DestDir: {app}\src; Flags: ignoreversion recursesubdirs; Excludes: .svn\
Source: ..\..\wxwidgets\lib\gcc48_dll\*; DestDir: {app}\lib\gcc48_dll; Flags: ignoreversion recursesubdirs; Components: wx\gcc\48\x86\gccdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\gcc48_lib\*; DestDir: {app}\lib\gcc48_lib; Flags: ignoreversion recursesubdirs; Components: wx\gcc\48\x86\gcclib; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\gcc48_dll_x64\*; DestDir: {app}\lib64\gcc48_dll; Flags: ignoreversion recursesubdirs; Components: wx\gcc\48\x64\gccdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\gcc48_lib_x64\*; DestDir: {app}\lib64\gcc48_lib; Flags: ignoreversion recursesubdirs; Components: wx\gcc\48\x64\gcclib; Excludes: .svn\, *.ilk
;Source: ..\..\wxwidgets\lib\vc100_dll\*; DestDir: {app}\lib\vc100_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\100\x86\vcdll; Excludes: .svn\, *.ilk
;Source: ..\..\wxwidgets\lib\vc100_lib\*; DestDir: {app}\lib\vc100_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\100\x86\vclib; Excludes: .svn\, *.ilk
;Source: ..\..\wxwidgets\lib\vc100_x64_dll\*; DestDir: {app}\lib64\vc100_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\100\x64\vcdll; Excludes: .svn\, *.ilk
;Source: ..\..\wxwidgets\lib\vc100_x64_lib\*; DestDir: {app}\lib64\vc100_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\100\x64\vclib; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc120_dll\*; DestDir: {app}\lib\vc120_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\120\x86\vcdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc120_lib\*; DestDir: {app}\lib\vc120_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\120\x86\vclib; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc120_x64_dll\*; DestDir: {app}\lib64\vc120_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\120\x64\vcdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc120_x64_lib\*; DestDir: {app}\lib64\vc120_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\120\x64\vclib; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc140_dll\*; DestDir: {app}\lib\vc140_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\140\x86\vcdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc140_lib\*; DestDir: {app}\lib\vc140_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\140\x86\vclib; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc140_x64_dll\*; DestDir: {app}\lib64\vc140_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\140\x64\vcdll; Excludes: .svn\, *.ilk
Source: ..\..\wxwidgets\lib\vc140_x64_lib\*; DestDir: {app}\lib64\vc140_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\140\x64\vclib; Excludes: .svn\, *.ilk
;Source: support\upx.exe; DestDir: {win}; Flags: ignoreversion
Source: cmake\*.cmake; DestDir: {app}\cmake; Flags: ignoreversion
Source: support\gdiplus.dll; DestDir: {sys}; Flags: uninsneveruninstall onlyifdoesntexist; MinVersion: 0,5.0.2195; OnlyBelowVersion: 0,5.0.2195sp3
Source: wxWidgets_Compiled.iss; DestDir: {app}; Flags: dontcopy

[InstallDelete]
Name: {group}\{#MyAppName} {#wxMajorVersion}. Help; Type: filesandordirs

[Components]
Name: wx; Description: wxWidgets Compiled By:; Flags: fixed; Types: full custom compact

Name: wx\vc; Description: Visual C++; Flags: dontinheritcheck; Types: full vc
Name: wx\vc\140; Description: Visual C++ 2015; Flags: dontinheritcheck; Types: full vc vc2015
Name: wx\vc\140\x86; Description: 32-bit; Flags: dontinheritcheck; Types: full vc vc2015
Name: wx\vc\140\x86\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2015 compact
Name: wx\vc\140\x86\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2015
Name: wx\vc\140\x64; Description: 64-bit; Flags: dontinheritcheck; Types: full vc vc2015
Name: wx\vc\140\x64\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2015 compact
Name: wx\vc\140\x64\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2015

Name: wx\vc\120; Description: Visual C++ 2013; Flags: dontinheritcheck; Types: full vc vc2013
Name: wx\vc\120\x86; Description: 32-bit; Flags: dontinheritcheck; Types: full vc vc2013
Name: wx\vc\120\x86\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2013 compact
Name: wx\vc\120\x86\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2013
Name: wx\vc\120\x64; Description: 64-bit; Flags: dontinheritcheck; Types: full vc vc2013
Name: wx\vc\120\x64\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2013 compact
Name: wx\vc\120\x64\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2013

;Name: wx\vc\100; Description: Visual C++ 2010; Flags: dontinheritcheck; Types: full vc vc2010
;Name: wx\vc\100\x86; Description: 32-bit; Flags: dontinheritcheck; Types: full vc vc2010
;Name: wx\vc\100\x86\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2013 compact
;Name: wx\vc\100\x86\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2010
;Name: wx\vc\100\x64; Description: 64-bit; Flags: dontinheritcheck; Types: full vc vc2010
;Name: wx\vc\100\x64\vclib; Description: Lib's; Flags: dontinheritcheck; Types: full vc vc2010 compact
;Name: wx\vc\100\x64\vcdll; Description: Dll's; Flags: dontinheritcheck; Types: full vc vc2010

Name: wx\gcc; Description: MinGW4-w64; Flags: dontinheritcheck; Types: full gcc
Name: wx\gcc\48; Description: 4.8; Flags: dontinheritcheck; Types: full gcc
Name: wx\gcc\48\x86; Description: 32-bit; Flags: dontinheritcheck; Types: full gcc
Name: wx\gcc\48\x86\gcclib; Description: Lib's; Flags: checkablealone; Types: full gcc
Name: wx\gcc\48\x86\gccdll; Description: Dll's; Flags: checkablealone; Types: full gcc
Name: wx\gcc\48\x64; Description: 64-bit; Flags: dontinheritcheck; Types: full gcc gcc64
Name: wx\gcc\48\x64\gcclib; Description: Lib's; Flags: checkablealone; Types: full gcc gcc64
Name: wx\gcc\48\x64\gccdll; Description: Dll's; Flags: checkablealone; Types: full gcc gcc64

[Types]
Name: full; Description: Full Installation
Name: vc; Description: Visual C++
Name: vc2015; Description: Visual C++ 2015 Only   Runtime Version: 14.0
Name: vc2013; Description: Visual C++ 2013 Only   Runtime Version: 12.0
;Name: vc2010; Description: Visual C++ 2010 Only   Runtime Version: 10.0
Name: gcc; Description: MinGW-w64 Gcc Only
Name: gcc64; Description: MinGW-w64 x64 Gcc Only
Name: compact; Description: Compact Installation (VC Libs Only)
Name: custom; Description: Custom Installation; Flags: iscustom

[Registry]
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: WXWIN; ValueData: {app}; Flags: uninsdeletevalue preservestringtype deletevalue; MinVersion: 0,4.0.1381; OnlyBelowVersion: 0,0; Components: 

[Icons]
Name: {group}\{#MyAppName} Help; Filename: {app}\docs\htmlhelp\wx.chm
Name: {group}\{#MyAppName} Book; Filename: {app}\docs\Cross Platform GUI Programming With wxWidget.pdf
Name: {group}\{cm:UninstallProgram,{#MyAppVerName}}; Filename: {uninstallexe}

[Code]
function GetPathInstalled( AppID: String ): String;
var
   sPrevPath: String;
begin
  sPrevPath := '';
  if not RegQueryStringValue( HKLM,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1',
      'Inno Setup: App Path', sPrevpath) then
    RegQueryStringValue( HKCU, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1' ,
      'Inno Setup: App Path', sPrevpath);

  Result := sPrevPath;
end;

function GetPathUninstallString( AppID: String ): String;
var
   sPrevPath: String;
begin
  sPrevPath := '';
  if not RegQueryStringValue( HKLM,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1',
		'UninstallString', sPrevpath) then
    RegQueryStringValue( HKCU, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1' ,
		'UninstallString', sPrevpath);

  Result := sPrevPath;
end;

function GetInstalledVersion( AppID: String ): String;
var
   sPrevPath: String;

begin
  sPrevPath := '';
  if not RegQueryStringValue( HKLM,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1',
		'DisplayVersion', sPrevpath) then
    RegQueryStringValue( HKCU, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1' ,
		'DisplayVersion', sPrevpath);

  Result := sPrevPath;
end;

function InitializeSetup(): boolean;
var
	ResultCode: Integer;
	sVersion: String;
	sUninstallEXE: String;

begin
	sVersion:= GetInstalledVersion('{{#wxWidgetsGUID}}');
	sUninstallEXE:= RemoveQuotes(GetPathUninstallString('{{#wxWidgetsGUID}}'));

	// Check to make sure there is an exceptable version of wxAdditions installed.
	if Length(sVersion) = 0 then begin
		result:= true;
	end else begin
		if CompareText( sVersion, '{#AppMinVer}' ) <= 0 then begin
			if FileExists( sUninstallEXE ) then begin
				if WizardSilent() then begin
					// Just uninstall without asking because we are in silent mode.
					//Exec( sUninstallEXE, '/SILENT', GetPathInstalled('{#MyAppName}'), SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

					// Make sure that Setup is visible and the foreground window
					BringToFrontAndRestore;
					result := true;
				end else begin
					// Ask if they really want to uninstall because we are in the default installer.
					if SuppressibleMsgBox( 'Version ' + sVersion + ' of {#MyAppName} was detected.' #13 'It is recommended that you uninstall the old version first before continuing.' + #13 + #13 + 'Would you like to uninstall it now?', mbInformation, MB_YESNO, IDNO ) = IDYES then begin
						Exec( sUninstallEXE, '/SILENT', GetPathInstalled('{#MyAppName}'),
							SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

						// Make sure that Setup is visible and the foreground window
						BringToFrontAndRestore;
						result := true;
					end else begin
						result := true;
					end;
				end;
			end else begin
				result := true;
			end;
		end else begin
			result := true;
		end;
	end;
end;
