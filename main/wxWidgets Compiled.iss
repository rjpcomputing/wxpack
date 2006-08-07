;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxWidgets Compiled_v26.iss
; Author:      Ryan Pusztai
; Date:        11/28/2005
; Copyright:   (c) 2006 Ryan Pusztai <rpusztai@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define MyAppVer "2.6.3.23"
#define MyAppName "wxWidgets"
#define wxMajorVersion "2.6"
#define MyAppVerName "wxWidgets Compiled 2.6.3"
#define MyAppPublisher "Julian Smart"
#define MyAppURL "http://www.wxwidgets.org/"

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
OutputBaseFilename={#MyAppName} Compiled_v{#MyAppVer}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir=.
ShowLanguageDialog=yes
AppVersion={#MyAppVer}
WizardImageFile=compiler:wizmodernimage-IS.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp
SetupIconFile=support\mondrian.ico
LicenseFile=files\license.txt
UsePreviousAppDir=true
DisableDirPage=false
AppendDefaultGroupName=false
ChangesEnvironment=true
AlwaysShowComponentsList=false
VersionInfoVersion={#MyAppVer}
VersionInfoDescription={#MyAppName}

[Files]
Source: files\*; DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: support\upx.exe; DestDir: {win}; Flags: ignoreversion
Source: files26\common\*; DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: files26\lib\gcc_dll\*; DestDir: {app}\lib\gcc_dll; Flags: ignoreversion recursesubdirs; Components: wx\gcc\gccdll
Source: files26\lib\gcc_lib\*; DestDir: {app}\lib\gcc_lib; Flags: ignoreversion recursesubdirs; Components: wx\gcc\gcclib
Source: files26\lib\vc_dll\*; DestDir: {app}\lib\vc_dll; Flags: ignoreversion recursesubdirs; Components: wx\vc\vcdll\vc71
Source: files26\lib\vc_lib\*; DestDir: {app}\lib\vc_lib; Flags: ignoreversion recursesubdirs; Components: wx\vc\vclib
Source: wxWidgets Compiled_v26.iss; DestDir: {app}; Flags: ignoreversion recursesubdirs dontcopy

[InstallDelete]
; Remove plot from distribution. It is added to wxAdditions.
Name: {app}\contrib\build\plot; Type: filesandordirs
Name: {app}\contrib\include\wx\plot; Type: filesandordirs
Name: {app}\contrib\samples\plot; Type: filesandordirs
Name: {app}\contrib\src\plot; Type: filesandordirs

[Components]
Name: wx; Description: wxWidgets Compiled By:; Flags: fixed; Types: full custom compact
Name: wx\vc; Description: Visual C++; Flags: dontinheritcheck; Types: full
Name: wx\vc\vclib; Description: Lib's; Types: full compact vc71
Name: wx\vc\vcdll; Description: Dll's
Name: wx\vc\vcdll\vc71; Description: Visual C++ 7.1 Compiled; Flags: exclusive; Types: full vc71
;Name: wx\vc\vcdll\vc80; Description: Visual C++ 8.0 Compiled; Flags: exclusive; Types: vc80
Name: wx\gcc; Description: MinGW Gcc; Flags: dontinheritcheck; Types: full gcc
Name: wx\gcc\gcclib; Description: Lib's; Flags: checkablealone; Types: full gcc
Name: wx\gcc\gccdll; Description: Dll's; Flags: checkablealone; Types: full gcc

[Types]
Name: full; Description: Full Installation
Name: vc71; Description: Visual C++ Only   Runtime Version: 7.1
;Name: vc80; Description: Visual C++ Only   Runtime Version: 8.0
Name: gcc; Description: MinGW Gcc Only
Name: compact; Description: Compact Installation (VC Libs Only)
Name: custom; Description: Custom Installation; Flags: iscustom

[Registry]
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: WXWIN; ValueData: {app}; Flags: uninsdeletevalue preservestringtype deletevalue; MinVersion: 0,4.0.1381; OnlyBelowVersion: 0,5.2; Components: 

[Icons]
Name: {group}\{#MyAppName} 2.6.3 Help; Filename: {app}\help\wx.chm
Name: {group}\{#MyAppName} Book; Filename: {app}\help\Cross Platform GUI Programming With wxWidget.pdf
Name: {group}\{cm:UninstallProgram,{#MyAppName} 2.6.3}; Filename: {uninstallexe}

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
	sVersion:= GetInstalledVersion('{C8088AE5-A62A-4C29-A3D5-E5E258B517DE}');
	sUninstallEXE:= RemoveQuotes(GetPathUninstallString('{C8088AE5-A62A-4C29-A3D5-E5E258B517DE}'));

	// Debug Stuff
	//MsgBox('Version ' + sVersion + ' was found' #13 'The length is ' + IntToStr(Length(sVersion)), mbInformation, MB_OK);
	//MsgBox('Uninstall is located at : ' + sUninstallEXE, mbInformation, MB_OK);
	//MsgBox('Results from a string compare ' + IntToStr(CompareStr('4.18', sVersion)), mbInformation, MB_OK);

	if Length(sVersion) = 0 then begin
		result:= true;
	end else begin
		if CompareStr('2.6.2.17', sVersion) >= 0 then begin
			if FileExists(sUninstallEXE) then begin
				//  #13 #13 'WARNING: This will delete all files in the wxWidgets Compiled install directory.'
				if MsgBox('An old version of {#MyAppVerName} was detected.' #13 'It is recommended that you uninstall the old version first before continuing.' + #13 + #13 + 'Would you like to uninstall it now?', mbInformation, MB_YESNO) = IDYES then begin
					Exec(sUninstallEXE,
							'/SILENT',
							GetPathInstalled('{C8088AE5-A62A-4C29-A3D5-E5E258B517DE}'),
							SW_SHOWNORMAL,
							ewWaitUntilTerminated,
							ResultCode);

					// Make sure that Setup is visible and the foreground window
					BringToFrontAndRestore;
					result := true;
				end else
					result := true;
			end;
		end else
			result := true;
	end;
end;
