#include "[!output PROJECT_NAME]Frame.h"
[!if WX_USE_FORMBUILDER]
#include "[!output PROJECT_NAME]Panel.h"
[!if WX_ABOUT_DIALOG]
#include "[!output PROJECT_NAME]About.h"
[!else]
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
#include "fileversion.h"
[!else]
#include "version.h"
[!endif]
[!endif]
[!endif]

[!if WX_MENU_BAR]
BEGIN_EVENT_TABLE( [!output SAFE_PROJECT_NAME]Frame, MainFrame )
	EVT_MENU( ID_FILE_EXIT, [!output SAFE_PROJECT_NAME]Frame::OnExit )
	EVT_MENU( ID_HELP_ABOUT, [!output SAFE_PROJECT_NAME]Frame::OnAbout )
END_EVENT_TABLE()
[!endif]

[!output SAFE_PROJECT_NAME]Frame::[!output SAFE_PROJECT_NAME]Frame( wxWindow *parent, int id )
	: MainFrame( parent, id )
{
	wxBoxSizer* sizer = new wxBoxSizer( wxVERTICAL );
	wxPanel* panel = new [!output SAFE_PROJECT_NAME]Panel( this );
	sizer->Add( panel, 1, wxEXPAND );
	wxSize panelSize = panel->GetSize();
	this->SetSizerAndFit( sizer );
	this->SetClientSize( panelSize );	
}

[!if WX_MENU_BAR]
void [!output SAFE_PROJECT_NAME]Frame::OnExit( wxCommandEvent& event )
{
	Close();
}

void [!output SAFE_PROJECT_NAME]Frame::OnAbout( wxCommandEvent& event )
{
[!if WX_ABOUT_DIALOG]
	[!output SAFE_PROJECT_NAME]About* about = new [!output SAFE_PROJECT_NAME]About( this );
	about->Show();
[!else]
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
	wxFileVersion ver;
	
	// Open the current executable's version information.
	ver.Open();
	
	// Get the file version.
	wxString fileVersion = ver.GetFixedFileVersion( true );
	
	// Set the version label.
	wxMessageBox( wxT("[!output PROJECT_NAME] Version ") + fileVersion, wxT("About [!output PROJECT_NAME]...") );
[!else]
	wxMessageBox( wxT("[!output PROJECT_NAME] Version " APP_VERSION_NUMBER), wxT("About [!output PROJECT_NAME]...") );
[!endif]
[!else]
	wxMessageBox( wxT("[!output PROJECT_NAME] Version 1.00.0"), wxT("About [!output PROJECT_NAME]...") );
[!endif]
[!endif]
}
[!endif]
[!else]
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
#include "fileversion.h"
[!else]
#include "version.h"
[!endif]
[!endif]

const int [!output SAFE_PROJECT_NAME]Frame::ID_FILE_EXIT = ::wxNewId();
const int [!output SAFE_PROJECT_NAME]Frame::ID_HELP_ABOUT = ::wxNewId();

BEGIN_EVENT_TABLE( [!output SAFE_PROJECT_NAME]Frame, wxFrame )
	EVT_MENU( ID_FILE_EXIT, [!output SAFE_PROJECT_NAME]Frame::OnExit )
	EVT_MENU( ID_HELP_ABOUT, [!output SAFE_PROJECT_NAME]Frame::OnAbout )
END_EVENT_TABLE()

[!output SAFE_PROJECT_NAME]Frame::[!output SAFE_PROJECT_NAME]Frame( wxFrame *frame, const wxString& title )
	: wxFrame( frame, -1, title )
{
	wxMenuBar* mbar = new wxMenuBar();
	wxMenu* fileMenu = new wxMenu( wxT("") );
	fileMenu->Append( ID_FILE_EXIT, wxT("E&xit\tAlt+F4"), wxT("Exit the application") );
	mbar->Append( fileMenu, wxT("&File") );

	wxMenu* helpMenu = new wxMenu( wxT("") );
	helpMenu->Append( ID_HELP_ABOUT, wxT("&About\tF1"), wxT("Show info about this application") );
	mbar->Append( helpMenu, wxT("&Help") );
	
	SetMenuBar( mbar );
}

void [!output SAFE_PROJECT_NAME]Frame::OnExit( wxCommandEvent& event )
{
	Close();
}

void [!output SAFE_PROJECT_NAME]Frame::OnAbout( wxCommandEvent& event )
{
[!if WX_USE_AUTOBUILDNUMBER]
[!if WX_USE_VERSION_RC]
	wxFileVersion ver;
	
	// Open the current executable's version information.
	ver.Open();
	
	// Get the file version.
	wxString fileVersion = ver.GetFixedFileVersion( true );
	
	// Set the version label.
	wxMessageBox( wxT("[!output PROJECT_NAME] Version ") + fileVersion, wxT("About [!output PROJECT_NAME]...") );
[!else]
	wxMessageBox( wxT("[!output PROJECT_NAME] Version " APP_VERSION_NUMBER), wxT("About [!output PROJECT_NAME]...") );
[!endif]
[!else]
	wxMessageBox( wxT("[!output PROJECT_NAME] Version 1.00.0"), wxT("About [!output PROJECT_NAME]...") );
[!endif]
}
[!endif]

[!output SAFE_PROJECT_NAME]Frame::~[!output SAFE_PROJECT_NAME]Frame()
{
}