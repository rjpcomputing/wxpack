;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxVC26.iss
; Author:      Ryan Pusztai
; Date:        12/08/2005
; Copyright:   (c) 2006 Ryan Pusztai <rpusztai@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define MyAppVer "2.6.3.44"
#define MyAppName "wxVC"
#define wxMajorVersion "2.6"

[Setup]
AppName={#MyAppName}
AppVerName={#MyAppName} {#MyAppVer}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=false
OutputBaseFilename={#MyAppName}_v{#MyAppVer}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir=.
ShowLanguageDialog=yes
AppVersion={#MyAppVer}
WizardImageFile=compiler:wizmodernimage-IS.bmp
WizardSmallImageFile=compiler:wizmodernsmallimage-IS.bmp
DisableDirPage=true
AllowNoIcons=true
DisableReadyPage=true
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
VersionInfoVersion={#MyAppVer}
VersionInfoDescription={#MyAppName}
LicenseFile=files\license.txt

[Files]
Source: files\h2\*; DestDir: {app}\h2; Flags: ignoreversion recursesubdirs
Source: files\support\*; DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: files\vcWizard\vc7\*; DestDir: {code:GetVC7InstallDir}; Flags: ignoreversion recursesubdirs touch; Check: IsVC7Installed()
Source: files\vcWizard\vc8\*; DestDir: {code:GetVC8InstallDir}; Flags: ignoreversion recursesubdirs touch; Check: IsVC8Installed()
Source: files\vcWizard\vc8Express\*; DestDir: {code:GetVC8ExpressInstallDir}; Flags: ignoreversion recursesubdirs touch; Check: IsVC8ExpressInstalled()
Source: files\license.txt; DestDir: {app}
Source: wxVC.iss; DestDir: {app}; Flags: dontcopy

[Run]
Filename: {app}\h2\H2Reg.exe; Parameters: -r cmdfile={app}\h2\H2Reg_Cmd.ini; StatusMsg: Registering wxWidgets Help With Visual C++ IDE's; Flags: runhidden; Check: IsVCInstalled()

[INI]
Filename: {code:GetVS7CommonDir}\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC7Installed()
Filename: {code:GetVS8CommonDir}\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC8Installed()
Filename: {code:GetVS8ExpressCommonDir}\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC8ExpressInstalled()

[Icons]
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[UninstallRun]
Filename: {app}\h2\H2Reg.exe; Parameters: -u cmdfile={app}\h2\H2Reg_Cmd.ini; Flags: runhidden; Check: IsVCInstalled()

[Code]
function GetPathInstalled( AppID: String ): String;
var
   sPrevPath: String;
begin
  // Debug Stuff
  //MsgBox( AppID + ' was passed into GetPathInstalled', mbInformation, MB_OK);

  sPrevPath := '';
  if not RegQueryStringValue( HKLM,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1',
      'Inno Setup: App Path', sPrevpath) then
    RegQueryStringValue( HKCU, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\'+AppID+'_is1' ,
      'Inno Setup: App Path', sPrevpath);

  // Debug Stuff
  //MsgBox( 'Installed Path: ' + sPrevPath, mbInformation, MB_OK);

  Result := sPrevPath;
end;

function GetVC8InstallDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual Studio 8.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\8.0\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function GetVC8ExpressInstallDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual C++ Express 8.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VCExpress\8.0\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function GetVC7InstallDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual Studio 7.1 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\7.1\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	// Check to see if Visual Studio 7.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\7.0\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function IsVC7Installed(): Boolean;
begin
	if CompareStr( GetVC7InstallDir(''), '' ) = 0 then
	begin
		Result := false;
	end else begin
		Result := true;
	end;
end;

function IsVC8Installed(): Boolean;
begin
	if CompareStr( GetVC8InstallDir(''), '' ) = 0 then
	begin
		Result := false;
	end else begin
		Result := true;
	end;
end;


function IsVC8ExpressInstalled(): Boolean;
begin
	if CompareStr( GetVC8ExpressInstallDir(''), '' ) = 0 then
	begin
		Result := false;
	end else begin
		Result := true;
	end;
end;

function IsVCInstalled(): Boolean;
var
	IsInstalled: Boolean;
begin
	IsInstalled := false;

	if IsVC7Installed() then
	begin
		IsInstalled := true;
	end;

	if IsVC8Installed() then
	begin
		IsInstalled := true;
	end;

	if IsVC8ExpressInstalled() then
	begin
		IsInstalled := true;
	end;

	Result := IsInstalled;
end;

function GetVS8CommonDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual Studio 8.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\8.0\Setup\VS', 'VS7CommonDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function GetVS8ExpressCommonDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual C++ Express 8.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VCExpress\8.0\Setup\VS', 'VS7CommonDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function GetVS7CommonDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual Studio 7.1 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\7.1\Setup\VS', 'VS7CommonDir', sPath) then
	begin
		Result := sPath;
	end;

	// Check to see if Visual Studio 7.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\7.0\Setup\VS', 'VS7CommonDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;
