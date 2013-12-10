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
#define MyAppVer "3.0.00.00"
#define wxMajorVersion "3.0"
#define MyAppName "wxPack"
#define wxWidgetsGUID "C8088AE5-A62A-4C29-A3D5-E5E258B517DE"
#define AppMinVer "3.0.00.00"

; **** DON'T EDIT BELOW THIS LINE! ****
[Setup]
AppName={#MyAppName}
AppVerName={#MyAppName} v{#MyAppVer}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=true
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=false
AllowNoIcons=true
OutputBaseFilename={#MyAppName}_v{#MyAppVer}
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
Source: ..\wxformbuilder\install\windows\wxFormBuilder*.exe; DestDir: {app}\files; Flags: ignoreversion;
Source: wxCompiled\wxWidgets_Compiled*.exe; DestDir: {app}\files; Flags: ignoreversion;
Source: wxAdditions\wxAdditions*.exe; DestDir: {app}\files; Flags: ignoreversion;
Source: license.txt; DestDir: {app}; Flags: ignoreversion
Source: wxwin.bmp; Flags: dontcopy

[Dirs]
Name: {app}\files; Flags: uninsalwaysuninstall; attribs: hidden

[Icons]
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\files\wxFormBuilder-setup.exe; StatusMsg: Installing wxFormBuilder ...; WorkingDir: {app}\files; Parameters: "/SILENT ""{code:GetGroup|wxFormBuilder}"""; Flags: hidewizard; Components: wxfb
Filename: {app}\files\wxWidgets_Compiled-setup.exe; StatusMsg: Installing wxWidgets ...; WorkingDir: {app}\files; Parameters: "/SILENT /DIR=""{code:GetLocation}"" ""{code:GetGroup|wxWidgets Compiled}"" /COMPONENTS={code:GetSelectedComponents}"; Flags: hidewizard; Components: wx\vc\120\x86\vclib wx\vc\120\x86\vcdll wx\vc\120\x64\vclib wx\vc\120\x64\vcdll wx\vc\100\x86\vclib wx\vc\100\x86\vcdll wx\vc\100\x64\vclib wx\vc\100\x64\vcdll wx\gcc\48\x86\gcclib wx\gcc\48\x86\gccdll wx\gcc\48\x64\gcclib wx\gcc\48\x64\gccdll
Filename: {app}\files\wxAdditions-setup.exe; StatusMsg: Installing wxAdditions ...; WorkingDir: {app}\files; Parameters: "/SILENT ""{code:GetGroup|wxAdditions}"""; Flags: hidewizard; Components: add

[Components]
Name: wxfb; Description: wxFormBuilder; Flags: disablenouninstallwarning; Types: custom full vc gcc compact; ExtraDiskSpaceRequired: 69520600
Name: add; Description: wxWidgets Additions; Flags: disablenouninstallwarning; Types: custom full vc gcc compact; ExtraDiskSpaceRequired: 1067346000
Name: wx; Description: wxWidgets Compiled By:; Flags: fixed; Types: full custom compact
Name: wx\vc; Description: "Visual C++"; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc; 
Name: wx\vc\120; Description: Visual C++ 2013; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013
Name: wx\vc\120\x86; Description: 32-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013
Name: wx\vc\120\x86\vclib; Description: Lib's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013 compact; ExtraDiskSpaceRequired: 788110000
Name: wx\vc\120\x86\vcdll; Description: Dll's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013; ExtraDiskSpaceRequired: 260000000
Name: wx\vc\120\x64; Description: 64-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013
Name: wx\vc\120\x64\vclib; Description: Lib's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013 compact; ExtraDiskSpaceRequired: 1002860000
Name: wx\vc\120\x64\vcdll; Description: Dll's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2013; ExtraDiskSpaceRequired: 298005000
Name: wx\vc\100; Description: Visual C++ 2010; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010
Name: wx\vc\100\x86; Description: 32-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010
Name: wx\vc\100\x86\vclib; Description: Lib's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010 compact; ExtraDiskSpaceRequired: 766500000
Name: wx\vc\100\x86\vcdll; Description: Dll's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010; ExtraDiskSpaceRequired: 402339000
Name: wx\vc\100\x64; Description: 64-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010
Name: wx\vc\100\x64\vclib; Description: Lib's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010 compact; ExtraDiskSpaceRequired: 978531000
Name: wx\vc\100\x64\vcdll; Description: Dll's; Flags: dontinheritcheck disablenouninstallwarning; Types: full vc vc2010; ExtraDiskSpaceRequired: 441765000
Name: wx\gcc; Description: MinGW4-w64; Flags: dontinheritcheck disablenouninstallwarning; Types: full gcc
Name: wx\gcc\48; Description: 4.8; Flags: dontinheritcheck disablenouninstallwarning; Types: full gcc
Name: wx\gcc\48\x86; Description: 32-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full gcc
Name: wx\gcc\48\x86\gcclib; Description: Lib's; Flags: checkablealone disablenouninstallwarning; Types: full gcc; ExtraDiskSpaceRequired: 615200000
Name: wx\gcc\48\x86\gccdll; Description: Dll's; Flags: checkablealone disablenouninstallwarning; Types: full gcc; ExtraDiskSpaceRequired: 585001000
Name: wx\gcc\48\x64; Description: 64-bit; Flags: dontinheritcheck disablenouninstallwarning; Types: full gcc gcc64
Name: wx\gcc\48\x64\gcclib; Description: Lib's; Flags: checkablealone disablenouninstallwarning; Types: full gcc gcc64; ExtraDiskSpaceRequired: 741658000 
Name: wx\gcc\48\x64\gccdll; Description: Dll's; Flags: checkablealone disablenouninstallwarning; Types: full gcc gcc64; ExtraDiskSpaceRequired: 612893000

[Types]
Name: full; Description: Full Installation
Name: vc; Description: Visual C++
Name: vc2013; Description: Visual C++ 2013 Only   Runtime Version: 12.0
Name: vc2010; Description: Visual C++ 2010 Only   Runtime Version: 10.0
Name: gcc; Description: MinGW-w64 Gcc Only
Name: gcc64; Description: MinGW-w64 x64 Gcc Only
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
	compList := CheckComponent('wx\vc\120\x86\vclib') + CheckComponent('wx\vc\120\x86\vcdll') + CheckComponent('wx\vc\120\x64\vclib') + CheckComponent('wx\vc\120\x64\vcdll') + CheckComponent('wx\vc\100\x86\vclib') + CheckComponent('wx\vc\100\x86\vcdll') + CheckComponent('wx\vc\100\x64\vclib') + CheckComponent('wx\vc\100\x64\vcdll') + CheckComponent('wx\gcc\48\x86\gcclib') + CheckComponent('wx\gcc\48\x86\gccdll') + CheckComponent('wx\gcc\48\x64\gcclib') + CheckComponent('wx\gcc\48\x64\gccdll');
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
	wxLocationString := wxLocation.text;
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
		Caption := 'To continue, click Next. If you would like to select a different folder, click Browse.';
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
		Caption := 'Setup will create the wxWidgets Compiled library in the following location.';
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
			end else begin
				result := true;
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
	wxFormBuilderUninstEXE: String;
	wxCompiledUninstEXE: String;
	ResultCode: Integer;

begin
	if CurUninstallStep = usUninstall then
	begin
		// Get all the paths to the components uninstaller
		wxAdditionsUninstEXE := RemoveQuotes( GetPathUninstallString( 'wxAdditions' ) );
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
//    All used to check to see if VC is installed.
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

