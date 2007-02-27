;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxAdditions.iss
; Author:      Ryan Pusztai
; Date:        03/31/2006
; Copyright:   (c) 2006 Ryan Pusztai <rpusztai@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define MyAppVer "2.8.0.05"
#define MyAppName "wxAdditions"
#define wxFBAppID "wxFormBuilder"
#define wxWidgetsGUID "C8088AE5-A62A-4C29-A3D5-E5E258B517DE"
#define wxWidgetsMinVer "2.8.0.01"
#define wxAdditionsMinVer "2.8.0.00"

[Setup]
AppName={#MyAppName}
AppVerName={#MyAppName} {#MyAppVer}
; Set the app directory to the wxWidgets directory.
DefaultDirName={code:GetWxAdditionsAppPath|{{{#wxWidgetsGUID}%7d}\additions
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=false
AllowNoIcons=true
OutputBaseFilename={#MyAppName}_v{#MyAppVer}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir=.
ShowLanguageDialog=yes
AppVersion={#MyAppVer}
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=compiler:WizModernSmallImage-IS.bmp
VersionInfoVersion={#MyAppVer}
VersionInfoDescription={#MyAppName}
LicenseFile=files\license.txt
ChangesEnvironment=true
UsePreviousAppDir=false

[Files]
Source: files\*; DestDir: {app}; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: .svn\
Source: files\wxfbPlugin\wxAdditions\*; DestDir: {code:GetWxFormBuilderAppPath}\plugins\wxAdditions; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: .svn\; Check: IsWxFBInstalled

[Registry]
Root: HKLM; Subkey: SYSTEM\CurrentControlSet\Control\Session Manager\Environment; ValueType: string; ValueName: WXADDITIONS; ValueData: {app}; Flags: preservestringtype; MinVersion: 0,4.0.1381; OnlyBelowVersion: 0,0

[Icons]
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[InstallDelete]
Name: {app}\lib\gcc_libdll; Type: filesandordirs
Name: {app}\lib\vc_libdll; Type: filesandordirs
Name: {app}\lib\gcc_dll\*.a; Type: files
Name: {app}\lib\vc_dll\*.a; Type: files
Name: {app}\licence.txt; Type: files
; Removing wxAUI because it is now in wxWidgets 2.7.0.
Name: {app}\build\wxAUI; Type: filesandordirs
Name: {app}\include\wx\wxAUI; Type: filesandordirs
Name: {app}\src\wxAUI; Type: filesandordirs

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
//--------------------------------------------------------------------------------
{Unused function}
function IsInstalled( AppID: String ): Boolean;
var
	sInstallPath: String;
	bExists: Boolean;
begin
	bExists := false;
	sInstallPath := GetPathInstalled( AppID );

	// Check to see if it returned something
	if not ( Length( sInstallPath ) = 0 ) then
	begin
		bExists := true;
	end;

	Result := bExists;
end;
//--------------------------------------------------------------------------------
function GetPathInstalledOrDefault( AppID: String; defVal: String ): String;
var
   sPath: String;
begin
  // Call the regular GetPathInstalled function.
  sPath := GetPathInstalled( AppID );

  // Check to see if it returned something
  if Length( sPath ) = 0 then
  begin
	sPath := defVal;
  end;

  Result := sPath;
end;
//--------------------------------------------------------------------------------
function GetWxAdditionsAppPath( AppID: String ): String;
var
  sEnvVar, sDefaultLocation: String;
begin
  sDefaultLocation := '';

  // Check for the environment variable WXWIN
  sEnvVar := GetEnv('WXWIN');
  if Length(sEnvVar) > 0 then
  begin
    sDefaultLocation := sEnvVar;
  end;

  // Check for the environment variable WX
  if Length(sDefaultLocation) = 0 then
  begin
    sEnvVar := GetEnv('WX');
    if Length(sEnvVar) > 0 then
    begin
      sDefaultLocation := sEnvVar;
    end;
  end;

  if Length(sDefaultLocation) <= 0 then
  begin
    sDefaultLocation := ExpandConstant( '{sd}' );
  end;

  Result := GetPathInstalledOrDefault( AppID, sDefaultLocation );
end;
//--------------------------------------------------------------------------------
function GetWxFormBuilderAppPath( tmp : String ): String;
var
	sTmp, sDefaultLocation: String;
begin
	// Initialize variables.
	sDefaultLocation := '';
	sTmp := '';

	// Check for a previous install.
	sTmp := GetPathInstalled( '{#wxFBAppID}' );
	if not ( Length(sTmp) = 0 ) then
	begin
		sDefaultLocation := sTmp;
	end;

	// Check for a commandline parameter of wxfbpath.
	sTmp := ExpandConstant( '{param:wxfbpath}' );
	if not ( Length(sTmp) = 0 ) then
	begin
		sDefaultLocation := sTmp;
	end;

    // Debug Stuff
	//MsgBox( 'wxFB Path: ' + sDefaultLocation, mbInformation, MB_OK);

	Result := sDefaultLocation;
end;
//--------------------------------------------------------------------------------
function IsWxFBInstalled(): Boolean;
var
	sInstallPath: String;
	bExists: Boolean;
begin
	bExists := false;
	sInstallPath := GetWxFormBuilderAppPath( '' );

	// Check to see if it returned something
	if not ( Length( sInstallPath ) = 0 ) then
	begin
		bExists := true;
	end;

	Result := bExists;
end;
//--------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------
function InitializeSetup(): boolean;
var
	ResultCode: Integer;
	wxVersion: String;
	wxAdditionsVersion: String;
	sUninstallEXE: String;

begin
	wxVersion:= GetInstalledVersion('{{#wxWidgetsGUID}}');
	wxAdditionsVersion:= GetInstalledVersion('{#MyAppName}');
	sUninstallEXE:= RemoveQuotes(GetPathUninstallString('{#MyAppName}'));

	// Debug Stuff
	//MsgBox('wxAdditions Version ' + wxAdditionsVersion + ' was found' #13 'The length is ' + IntToStr(Length(wxAdditionsVersion)), mbInformation, MB_OK);
	//MsgBox('Version ' + wxVersion + ' was found' #13 'The length is ' + IntToStr(Length(wxVersion)), mbInformation, MB_OK);
	//MsgBox('Uninstall is located at : ' + sUninstallEXE, mbInformation, MB_OK);

	// Check to make sure there is an exceptable version of wxAdditions installed.
	if Length(wxAdditionsVersion) = 0 then begin
		result:= true;
	end else begin
		//MsgBox('wxAdditions minimum version: ' + '{#wxAdditionsMinVer}' #13 'wxAdditions current version: ' + wxAdditionsVersion, mbInformation, MB_OK);
		if CompareText( wxAdditionsVersion, '{#wxAdditionsMinVer}' ) <= 0 then begin
			if FileExists(sUninstallEXE) then begin
				if WizardSilent() then begin
					// Just uninstall without asking because we are in silent mode.
					Exec(sUninstallEXE,	'/SILENT', GetPathInstalled('{#MyAppName}'),
							SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

					// Make sure that Setup is visible and the foreground window
					BringToFrontAndRestore;
					result := true;
				end else begin
					// Ask if they really want to uninstall because we are in the default installer.
					if MsgBox('Version ' + wxAdditionsVersion + ' of {#MyAppName} was detected.' #13 'It is recommended that you uninstall the old version first before continuing.' + #13 + #13 + 'Would you like to uninstall it now?', mbInformation, MB_YESNO) = IDYES then begin
						Exec(sUninstallEXE,	'/SILENT', GetPathInstalled('{#MyAppName}'),
							SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

						// Make sure that Setup is visible and the foreground window
						BringToFrontAndRestore;
						result := true;
					end else begin
						result := true;
					end;
				end;
			end;
		end else begin
			result := true;
		end;
	end;

	if Length(wxVersion) = 0 then begin
		SuppressibleMsgBox('WARNING: wxWidgets not found.' + #13 + #13 + 'wxAdditions was compiled against wxWidget v2.7.0. Please install wxWidgets Compiled v{#wxWidgetsMinVer} or above.' + #13 + #13 + 'NOTE: The installer will continue after pressing "OK".', mbError, MB_OK, idOk )
		result:= true;
	end else begin
		if CompareStr('{#wxWidgetsMinVer}', wxVersion) > 0 then begin
			SuppressibleMsgBox('wxWidgets Compiled v' + wxVersion + ' was detected.' #13 + 'Please install wxWidgets Compiled v{#wxWidgetsMinVer} or above.', mbCriticalError, MB_OK, idOk )
			result := false;
		end else begin
			result := true;
		end;
	end;
end;
