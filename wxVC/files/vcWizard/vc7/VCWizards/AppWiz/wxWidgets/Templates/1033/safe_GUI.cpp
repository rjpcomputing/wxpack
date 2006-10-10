///////////////////////////////////////////////////////////////////////////
// C++ code generated with wxFormBuilder (version May 31 2006)
// http://wxformbuilder.sourceforge.net/
//
// PLEASE DO "NOT" EDIT THIS FILE!
///////////////////////////////////////////////////////////////////////////

#include "[!output SAFE_PROJECT_NAME]_GUI.h"


MainFrame::MainFrame( wxWindow* parent, int id, wxString title, wxPoint pos, wxSize size, int style ) : wxFrame( parent, id, title, pos, size, style )
{
[!if WX_STATUS_BAR]
	m_statusBar = this->CreateStatusBar( 1, wxST_SIZEGRIP, ID_DEFAULT );
[!endif]

[!if WX_MENU_BAR]
	m_menubar = new wxMenuBar( 0 );

	wxMenu* m_fileMenu;
	m_fileMenu = new wxMenu();
	wxMenuItem* fileExit = new wxMenuItem( m_fileMenu, ID_FILE_EXIT, wxString( wxT("E&xit") ) + wxT('\t') + wxT("Alt+F4"), wxT("Exit the application"), wxITEM_NORMAL );
	m_fileMenu->Append( fileExit );
	m_menubar->Append( m_fileMenu, wxT("&File") );
	
	wxMenu* m_helpMenu;
	m_helpMenu = new wxMenu();
	wxMenuItem* helpAbout = new wxMenuItem( m_helpMenu, ID_HELP_ABOUT, wxString( wxT("&About") ) + wxT('\t') + wxT("F1"), wxT("Show info about this application"), wxITEM_NORMAL );
	m_helpMenu->Append( helpAbout );
	m_menubar->Append( m_helpMenu, wxT("&Help") );
	
	this->SetMenuBar( m_menubar );
[!endif]
}

MainPanel::MainPanel( wxWindow* parent, int id, wxPoint pos, wxSize size, int style ) : wxPanel( parent, id,pos,size,style )
{
	wxBoxSizer* mainSizer;
	mainSizer = new wxBoxSizer( wxVERTICAL );
	mainSizer->Add( 0, 0, 1, 0, 0 );
	m_OK = new wxButton( this, ID_MAIN_OK, wxT("OK"), wxDefaultPosition, wxDefaultSize, 0 );
	mainSizer->Add( m_OK, 0, wxALL|wxALIGN_RIGHT|wxALIGN_BOTTOM, 5 );
	
	this->SetSizer( mainSizer );
	this->SetAutoLayout( true );
	this->Layout();
	
}

[!if WX_ABOUT_DIALOG]

AboutDlg::AboutDlg( wxWindow* parent, int id, wxString title, wxPoint pos, wxSize size, int style ) : wxDialog( parent, id, title, pos, size, style )
{
	wxBoxSizer* mainSizer;
	mainSizer = new wxBoxSizer( wxVERTICAL );
	wxStaticBoxSizer* infoSizer;
	infoSizer = new wxStaticBoxSizer( new wxStaticBox( this, -1, wxT("") ), wxVERTICAL );
	wxBoxSizer* bSizer10;
	bSizer10 = new wxBoxSizer( wxHORIZONTAL );
	m_icon = new wxStaticBitmap( this, ID_ABOUT_ICON, wxICON( amain ), wxDefaultPosition, wxDefaultSize, 0 );
	bSizer10->Add( m_icon, 0, wxALL|wxALIGN_CENTER_VERTICAL, 5 );
	
	wxBoxSizer* textSizer;
	textSizer = new wxBoxSizer( wxVERTICAL );
	m_staticAppName = new wxStaticText( this, ID_ABOUT_APPNAME, wxT("[!output PROJECT_NAME]"), wxDefaultPosition, wxDefaultSize, 0 );
	m_staticAppName->SetFont( wxFont( 10, 74, 90, 92, false, wxT("Arial") ) );
	
	textSizer->Add( m_staticAppName, 0, wxTOP|wxRIGHT|wxLEFT, 5 );
	
	[!if WX_USE_AUTOBUILDNUMBER]
	m_staticVersion = new wxStaticText( this, ID_ABOUT_VERSION, wxT("Version"), wxDefaultPosition, wxDefaultSize, 0 );
	[!else]
	m_staticVersion = new wxStaticText( this, ID_ABOUT_VERSION, wxT("Version 1.00.0"), wxDefaultPosition, wxDefaultSize, 0 );
	[!endif]
	textSizer->Add( m_staticVersion, 0, wxBOTTOM|wxRIGHT|wxLEFT, 5 );
	
	bSizer10->Add( textSizer, 0, wxALIGN_CENTER_VERTICAL, 5 );
	
	infoSizer->Add( bSizer10, 1, 0, 5 );
	
	m_staticline1 = new wxStaticLine( this, ID_DEFAULT, wxDefaultPosition, wxDefaultSize, wxLI_HORIZONTAL );
	infoSizer->Add( m_staticline1, 0, wxALL|wxEXPAND, 5 );
	
	m_staticCopyright = new wxStaticText( this, ID_ABOUT_COPYRIGHT, wxT("Copyright © 2006"), wxDefaultPosition, wxDefaultSize, wxALIGN_CENTRE );
	infoSizer->Add( m_staticCopyright, 0, wxALIGN_CENTER_HORIZONTAL|wxEXPAND|wxBOTTOM|wxRIGHT|wxLEFT, 5 );
	
	mainSizer->Add( infoSizer, 1, wxEXPAND|wxRIGHT|wxLEFT, 5 );
	
	m_aboutDialogButtonSizer = new wxStdDialogButtonSizer(); m_aboutDialogButtonSizer->AddButton( new wxButton( this, wxID_OK ) ); m_aboutDialogButtonSizer->Realize();
	mainSizer->Add( m_aboutDialogButtonSizer, 0, wxALL|wxALIGN_CENTER_HORIZONTAL, 5 );
	
	this->SetSizer( mainSizer );
	this->SetAutoLayout( true );
	this->Layout();
	
}
[!endif]
