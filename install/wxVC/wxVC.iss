;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxVC26.iss
; Author:      Ryan Pusztai
; Date:        12/08/2005
; Copyright:   (c) 2006 Ryan Pusztai <rpusztai@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define MyAppVer "2.8.12.02"
#define MyAppName "wxVC"
#define wxMajorVersion "2.8"
#define AppMinVer "2.8.12.00"

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
Source: files\h2\*; DestDir: {app}\h2; Excludes: .svn\; Flags: ignoreversion recursesubdirs
Source: files\vcWizard\vc7\*; DestDir: {code:GetVC7InstallDir}; Flags: ignoreversion recursesubdirs touch; Excludes: .svn\; Check: IsVC7Installed()
Source: files\vcWizard\vc8\*; DestDir: {code:GetVC8InstallDir}; Flags: ignoreversion recursesubdirs touch; Excludes: .svn\; Check: IsVC8Installed()
Source: files\vcWizard\vc8Express\*; DestDir: {code:GetVC8ExpressInstallDir}; Flags: ignoreversion recursesubdirs touch; Excludes: .svn\; Check: IsVC8ExpressInstalled()
Source: files\vcWizard\vc9\*; DestDir: {code:GetVC9InstallDir}; Flags: ignoreversion recursesubdirs touch; Excludes: .svn\; Check: IsVC9Installed()
Source: files\vcWizard\vc9Express\*; DestDir: {code:GetVC9ExpressInstallDir}; Flags: ignoreversion recursesubdirs touch; Excludes: .svn\; Check: IsVC9ExpressInstalled()
Source: files\license.txt; DestDir: {app}
Source: files\autobuildnumber.exe; DestDir: {win}
Source: wxVC.iss; DestDir: {app}; Flags: dontcopy

[Run]
Filename: {app}\h2\H2Reg.exe; Parameters: -r cmdfile={app}\h2\H2Reg_cmd.ini; StatusMsg: Registering wxWidgets Help With Visual C++ IDE's; Flags: runhidden; Check: IsVCInstalled()

[INI]
Filename: {code:GetVS7CommonDir}\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC7Installed()
Filename: {code:GetVS8CommonDir}\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC8Installed()
Filename: {code:GetVC8ExpressInstallDir}\Common7\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC8ExpressInstalled()
Filename: {code:GetVC9InstallDir}\Common7\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC9Installed()
Filename: {code:GetVC9ExpressInstallDir}\Common7\Packages\Debugger\autoexp.dat; Section: autoexpand; Key: wxString; String: <m_pchData,st>; Flags: uninsdeleteentry; Check: IsVC9ExpressInstalled()

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

function GetVC9InstallDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual Studio 9.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VisualStudio\9.0\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
end;

function GetVC9ExpressInstallDir(Param: String): String;
var
   sPath: String;
begin
	sPath := '';

	// Check to see if Visual C++ Express 9.0 is installed.
	if RegQueryStringValue( HKLM, 'Software\Microsoft\VCExpress\9.0\Setup\VC', 'ProductDir', sPath) then
	begin
		Result := sPath;
	end;

	Result := sPath;
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

function IsVC9Installed(): Boolean;
begin
	if CompareStr( GetVC9InstallDir(''), '' ) = 0 then
	begin
		Result := false;
	end else begin
		Result := true;
	end;
end;

function IsVC9ExpressInstalled(): Boolean;
begin
	if CompareStr( GetVC9ExpressInstallDir(''), '' ) = 0 then
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

	if IsVC9Installed() then
	begin
		IsInstalled := true;
	end;

	if IsVC9ExpressInstalled() then
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
	sVersion:= GetInstalledVersion('{#MyAppName}');
	sUninstallEXE:= RemoveQuotes(GetPathUninstallString('{#MyAppName}'));

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
