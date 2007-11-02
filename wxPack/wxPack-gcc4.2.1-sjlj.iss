;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; File:        wxPack.iss
; Author:      Ryan Pusztai & Ryan Mulder
; Date:        05/18/2006
; Copyright:   (c) 2006 Ryan Pusztai <rpusztai@gmail.com>
;              (c) 2006 Ryan Mulder <rjmyst3@gmail.com>
; License:     wxWindows license
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; -- Installer configurations

; Name:    ShowComponentsListAlways
; Options: 1 or 0
;
; If this is set to 1, the setup will always show the components list
; for customizable setups. If this is set to 0 the setup will only
; show the components list if the user selected a custom type from
; the type list.
#define ShowComponentsListAlways 1

; -- Included application defines.
;    Change these when any of the included apps change.
;    (i.e. When a new rev of an application comes out)
#define MyAppVer "2.8.6.02"
#define wxMajorVersion "2.8"
#define MyAppName "wxPack"
#define wxWidgetsGUID "C8088AE5-A62A-4C29-A3D5-E5E258B517DE"
#define FormBulder "wxFormBuilder_v3.0.50-RC3.exe"
#define Compiled "wxWidgets Compiled_v2.8.6.02-gcc_v4.2.1-sjlj.exe"
#define Additions "wxAdditions_v2.8.6.02-gcc_v4.2.1-sjlj.exe"
#define VC "wxVC_v2.8.6.01.exe"
#define AppMinVer "2.8.5.01"

; **** DON'T EDIT BELOW THIS LINE! ****
[Setup]
AppName={#MyAppName}
AppVerName={#MyAppName} v{#MyAppVer}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=true
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=false
AllowNoIcons=true
OutputBaseFilename={#MyAppName}_v{#MyAppVer}-gcc_v4.2.1-sjlj
Compression=none
SolidCompression=false
OutputDir=.
ShowLanguageDialog=yes
AppVersion={#MyAppVer}
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=compiler:WizModernSmallImage-IS.bmp
#if ShowComponentsListAlways == 0
AlwaysShowComponentsList=false
#else
AlwaysShowComponentsList=true
#endif
SetupIconFile=wxwin.ico
MergeDuplicateFiles=true
VersionInfoVersion={#MyAppVer}
VersionInfoDescription={#MyAppName}
LicenseFile=license.txt
ChangesEnvironment=true

[Files]
Source: files\{#FormBulder}; DestDir: {app}\files; DestName: wxFormBuilder_setup.exe
Source: files\{#Compiled}; DestDir: {app}\files; DestName: wxWidgets Compiled_setup.exe
Source: files\{#Additions}; DestDir: {app}\files; DestName: wxAdditions_setup.exe
Source: files\{#VC}; DestDir: {app}\files; DestName: wxVC_setup.exe; Check: IsVCInstalled
Source: license.txt; DestDir: {app}
Source: wxwin.bmp; Flags: dontcopy

[Dirs]
Name: {app}\files; Flags: uninsalwaysuninstall; attribs: hidden

[Icons]
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\files\wxFormBuilder_setup.exe; StatusMsg: Installing wxFormBuilder ...; WorkingDir: {app}\files; Parameters: "/SILENT ""{code:GetGroup|wxFormBuilder}"""; Flags: hidewizard; Components: wxfb
Filename: {app}\files\wxWidgets Compiled_setup.exe; StatusMsg: Installing wxWidgets ...; WorkingDir: {app}\files; Parameters: "/SILENT /DIR={code:GetLocation} ""{code:GetGroup|wxWidgets Compiled}"" /COMPONENTS={code:GetSelectedComponents}"; Flags: hidewizard; Components: wx\vc\vclib wx\vc\vcdll\vc71 wx\gcc\gcclib wx\gcc\gccdll
Filename: {app}\files\wxAdditions_setup.exe; StatusMsg: Installing wxAdditions ...; WorkingDir: {app}\files; Parameters: "/SILENT ""{code:GetGroup|wxAdditions}"""; Flags: hidewizard; Components: add
Filename: {app}\files\wxVC_setup.exe; StatusMsg: Installing wxVC ...; WorkingDir: {app}\files; Parameters: "/SILENT ""{code:GetGroup|wxVC}"""; Flags: hidewizard; Components: wxvc; Check: IsVCInstalled

[Components]
Name: wxfb; Description: wxFormBuilder; Flags: disablenouninstallwarning; Types: custom full vc71 gcc compact; ExtraDiskSpaceRequired: 17406362
Name: add; Description: wxWidgets Additions; Flags: disablenouninstallwarning; Types: custom full vc71 gcc compact; ExtraDiskSpaceRequired: 216111514
Name: wxvc; Description: wxVC; Flags: disablenouninstallwarning; Types: custom full vc71 compact; Check: IsVCInstalled; ExtraDiskSpaceRequired: 3565158
Name: wx; Description: wxWidgets Compiled By:; Flags: disablenouninstallwarning
Name: wx\vc; Description: Visual C++; Flags: disablenouninstallwarning
Name: wx\vc\vclib; Description: Lib's; Flags: disablenouninstallwarning; Types: custom full compact vc71; ExtraDiskSpaceRequired: 397410304
Name: wx\vc\vcdll; Description: Dll's; Flags: disablenouninstallwarning; ExtraDiskSpaceRequired: 298844160
Name: wx\vc\vcdll\vc71; Description: Visual C++ 7.1 Compiled; Flags: disablenouninstallwarning exclusive; Types: custom full vc71
;Name: wx\vc\vcdll\vc80; Description: Visual C++ 8.0 Compiled; Flags: disablenouninstallwarning exclusive; Types: vc80
Name: wx\gcc; Description: MinGW Gcc v4.2.1; Flags: disablenouninstallwarning
Name: wx\gcc\gcclib; Description: Lib's; Flags: disablenouninstallwarning; Types: custom full gcc; ExtraDiskSpaceRequired: 1887436800
Name: wx\gcc\gccdll; Description: Dll's; Flags: disablenouninstallwarning; Types: custom full gcc; ExtraDiskSpaceRequired: 350224384

[Types]
Name: full; Description: Full Installation
Name: vc71; Description: Visual C++ Only   Runtime Version: 7.1
;Name: vc80; Description: Visual C++ Only   Runtime Version: 8.0
Name: gcc; Description: MinGW Gcc Only
Name: compact; Description: Compact Installation (VC Libs Only)
Name: custom; Description: Custom Installation; Flags: iscustom

[CustomMessages]
PackCustomPagesCaption=Select Destination Location
PackCustomPagesDescription=Where should wxWidgets Compiled be installed?

[UninstallDelete]
Name: {app}\files; Type: filesandordirs

[Code]
// -- Custom Page Functions
//
var
	Label1: TLabel;
	wxLogo: TBitmapImage;
	Label2: TLabel;
	wxLocationFolderTreeView: TFolderTreeView;
	wxLocation: TEdit;
	BrowseButton: TButton;
	wxLocationString: String;

function CheckComponent( comp: String ): String;
begin
	if IsComponentSelected( comp ) then
	begin
		result := comp + ',';
	end else begin
		result := '';
	end;
end;

function GetSelectedComponents( Param: String ): String;
var
	compList: String;
begin
	compList := CheckComponent('wx\vc\vclib') + CheckComponent('wx\vc\vcdll\vc71') + CheckComponent('wx\gcc\gcclib') + CheckComponent('wx\gcc\gccdll');
	//MsgBox(compList, mbInformation, MB_OK);
	result := compList;
end;

procedure PackCustomPages_Activate(Page: TWizardPage);
begin
end;

function PackCustomPages_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
	if CompareStr( GetSelectedComponents(''), '' ) = 0 then
	begin
		Result := True;
	end else begin
		Result := False;
	end;
end;

function PackCustomPages_BackButtonClick(Page: TWizardPage): Boolean;
begin
	Result := True;
end;

function PackCustomPages_NextButtonClick(Page: TWizardPage): Boolean;
begin
	Result := True;
end;

procedure PackCustomPages_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
end;

procedure wxLocationOnChange(Sender: TObject);
begin
	// Update TreeView
	wxLocationFolderTreeView.Directory := wxLocation.text + '\ ';
	wxLocationString := wxLocation.text;
end;

function GetLocation( Param: String ): String;
begin
	result := wxLocationString;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
	SetPreviousData(PreviousDataKey, 'wxLocationString', wxLocationString);
end;

procedure OnWxBrowseClick(Sender: TObject);
var
	sFolder: String;
begin
	if BrowseForFolder( 'Choose the location for wxWidgets Compiled', sFolder, True ) then
	begin
		// User selected a directory
		// Update edit box
		wxLocation.text := sFolder + '\wxWidgets{#wxMajorVersion}';
	end;
end;

function PackCustomPages_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
	BitmapFileName: String;
begin
	Page := CreateCustomPage(
		PreviousPageId,
		ExpandConstant('{cm:PackCustomPagesCaption}'),
		ExpandConstant('{cm:PackCustomPagesDescription}')
	);

	{ Label1 }
	Label1 := TLabel.Create(Page);
	with Label1 do
	begin
		Parent := Page.Surface;
		Left := ScaleX(0);
		Top := ScaleY(40);
		Width := ScaleX(390);
		Height := ScaleY(13);
		Caption := 'To continue, click Next. If you would like to select a different'' folder, click Browse.';
	end;

	BitmapFileName := ExpandConstant('{tmp}\wxWin.bmp');
	ExtractTemporaryFile(ExtractFileName(BitmapFileName));

	{ wxLogo }
	wxLogo := TBitmapImage.Create(Page);
	with wxLogo do
	begin
		Parent := Page.Surface;
		Left := ScaleX(0);
		Top := ScaleY(0);
		Width := ScaleX(32);
		Height := ScaleY(32);
		Bitmap.LoadFromFile(ExpandConstant('{tmp}\wxWin.bmp'));
	end;

	{ Label2 }
	Label2 := TLabel.Create(Page);
	with Label2 do
	begin
		Parent := Page.Surface;
		Left := ScaleX(40);
		Top := ScaleY(10);
		Width := ScaleX(352);
		Height := ScaleY(13);
		Caption := 'Setup will create the wxWidgets Compiled library in the followin''g location.';
	end;

	{ wxLocationFolderTreeView }
	wxLocationFolderTreeView := TFolderTreeView.Create(Page);
	with wxLocationFolderTreeView do
	begin
		Parent := Page.Surface;
		Left := ScaleX(0);
		Top := ScaleY(88);
		Width := ScaleX(409);
		Height := ScaleY(145);
		Cursor := crArrow;
		Hint := 'Enter Path for the wxWidgets Compiled Library';
		Enabled := False;
		ShowHint := True;
		Directory := GetPreviousData('wxLocationString', 'C:\SourceCode\Libraries\wxWidgets{#wxMajorVersion}');
		TabOrder := 2;
	end;

	{ wxLocation }
	wxLocation := TEdit.Create(Page);
	with wxLocation do
	begin
		Parent := Page.Surface;
		Left := ScaleX(0);
		Top := ScaleY(62);
		Width := ScaleX(330);
		Height := ScaleY(21);
		TabOrder := 0;
		Text := GetPreviousData('wxLocationString', 'C:\SourceCode\Libraries\wxWidgets{#wxMajorVersion}');
		OnChange := @wxLocationOnChange;
	end;

	{ BrowseButton }
	BrowseButton := TButton.Create(Page);
	with BrowseButton do
	begin
		Parent := Page.Surface;
		Left := ScaleX(336);
		Top := ScaleY(60);
		Width := ScaleX(74);
		Height := ScaleY(24);
		Caption := 'Browse ...';
		TabOrder := 1;
		OnClick := @OnWxBrowseClick;
	end;

	with Page do
	begin
		OnActivate := @PackCustomPages_Activate;
		OnShouldSkipPage := @PackCustomPages_ShouldSkipPage;
		OnBackButtonClick := @PackCustomPages_BackButtonClick;
		OnNextButtonClick := @PackCustomPages_NextButtonClick;
		OnCancelButtonClick := @PackCustomPages_CancelButtonClick;
	end;

	Result := Page.ID;
end;

procedure InitializeWizard();
begin
	PackCustomPages_CreatePage(wpSelectProgramGroup);
end;

// -- Previous version and uninstalling functions
//
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
					Exec( sUninstallEXE, '/SILENT', GetPathInstalled('{#MyAppName}'),
							SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

					// Make sure that Setup is visible and the foreground window
					BringToFrontAndRestore;
					result := true;
				end else begin
					// Ask if they really want to uninstall because we are in the default installer.
					if SuppressibleMsgBox( 'Version ' + sVersion + ' of {#MyAppName} was detected.' #13 'It is recommended that you uninstall the old version first before continuing.' + #13 + #13 + 'Would you like to uninstall it now?', mbInformation, MB_YESNO, IDYES ) = IDYES then begin
						Exec( sUninstallEXE, '/SILENT', GetPathInstalled('{#MyAppName}'),
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
end;

// -- Helper Functions
//
function GetGroup( appname: String ): String;
begin
	if WizardNoIcons() then
	begin
		result := '/NOICONS';
	end else begin
		result := ExpandConstant('/GROUP={groupname}\') + appname
	end;
end;


// -- Uninstaller Functions
//
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
	wxAdditionsUninstEXE: String;
	wxVCUninstEXE: String;
	wxFormBuilderUninstEXE: String;
	wxCompiledUninstEXE: String;
	ResultCode: Integer;

begin
	if CurUninstallStep = usUninstall then
	begin
		// Get all the paths to the components uninstaller
		wxAdditionsUninstEXE := RemoveQuotes( GetPathUninstallString( 'wxAdditions' ) );
		wxVCUninstEXE := RemoveQuotes( GetPathUninstallString( 'wxVC' ) );
		wxFormBuilderUninstEXE := RemoveQuotes( GetPathUninstallString( 'wxFormBuilder' ) );
		wxCompiledUninstEXE := RemoveQuotes( GetPathUninstallString( '{{#wxWidgetsGUID}}' ) );

		// Check to make sure the return has a valid location.
		if CompareStr( wxAdditionsUninstEXE, '' ) > 0 then
		begin
			//MsgBox(wxAdditionsUninstEXE, mbInformation, MB_OK);
			if Exec( wxAdditionsUninstEXE, '/silent', '', SW_SHOW, ewWaitUntilTerminated, ResultCode ) then
			begin
				// handle success if necessary; ResultCode contains the exit code
			end
			else begin
				// handle failure if necessary; ResultCode contains the error code
				MsgBox(wxAdditionsUninstEXE + ' could not be executed', mbError, MB_OK);
			end;
		end;

		// Check to make sure the return has a valid location.
		if CompareStr( wxVCUninstEXE, '' ) > 0 then
		begin
			//MsgBox(wxVCUninstEXE, mbInformation, MB_OK);
			if Exec( wxVCUninstEXE, '/silent', '', SW_SHOW, ewWaitUntilTerminated, ResultCode ) then
			begin
				// handle success if necessary; ResultCode contains the exit code
			end
			else begin
				// handle failure if necessary; ResultCode contains the error code
				MsgBox(wxFormBuilderUninstEXE + ' could not be executed', mbError, MB_OK);
			end;
		end;

		// Check to make sure the return has a valid location.
		if CompareStr( wxFormBuilderUninstEXE, '' ) > 0 then
		begin
			//MsgBox(wxFormBuilderUninstEXE, mbInformation, MB_OK);
			if Exec( wxFormBuilderUninstEXE, '/silent', '', SW_SHOW, ewWaitUntilTerminated, ResultCode ) then
			begin
				// handle success if necessary; ResultCode contains the exit code
			end
			else begin
				// handle failure if necessary; ResultCode contains the error code
				MsgBox(wxFormBuilderUninstEXE + ' could not be executed', mbError, MB_OK);
			end;
		end;

		// Check to make sure the return has a valid location.
		if CompareStr( wxCompiledUninstEXE, '' ) > 0 then
		begin
			//MsgBox(wxCompiledUninstEXE, mbInformation, MB_OK);
			if Exec( wxCompiledUninstEXE, '/silent', '', SW_SHOW, ewWaitUntilTerminated, ResultCode ) then
			begin
				// handle success if necessary; ResultCode contains the exit code
			end
			else begin
				// handle failure if necessary; ResultCode contains the error code
				MsgBox(wxCompiledUninstEXE + ' could not be executed', mbError, MB_OK);
			end;
		end;
	end;
end;

// -- Visual C++ install functions.
//    All used to check to see if VC 7.1+ is installed.
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
