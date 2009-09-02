///////////////////////////////////////////////////////////////////////////
// C++ code generated with wxFormBuilder (version Feb  3 2006)
// http://wxformbuilder.sourceforge.net/
//
// PLEASE DO "NOT" EDIT THIS FILE!
///////////////////////////////////////////////////////////////////////////
#ifndef __[!output SAFE_PROJECT_NAME]_GUI__
#define __[!output SAFE_PROJECT_NAME]_GUI__

#include "wx/wxprec.h"

#ifdef __BORLANDC__
#pragma hdrstop
#endif //__BORLANDC__

#ifndef WX_PRECOMP
#include <wx/wx.h>
#endif //WX_PRECOMP

#include <wx/button.h>
[!if WX_MENU_BAR]
#include <wx/menu.h>
[!endif]
#include <wx/statbmp.h>
#include <wx/statline.h>

#define ID_DEFAULT -1 // Default
[!if WX_MENU_BAR]
#define ID_FILE_EXIT 1000
#define ID_HELP_ABOUT 1001
[!endif]
#define ID_MAIN_OK 1002
#define ID_ABOUT_APPNAME 1003
#define ID_ABOUT_COPYRIGHT 1004
#define ID_ABOUT_ICON 1005
#define ID_ABOUT_VERSION 1006

/**
 * Class MainFrame
 */
class MainFrame : public wxFrame
{
	private:
	
	protected:
[!if WX_STATUS_BAR]
		wxStatusBar* m_statusBar;
[!endif]
[!if WX_MENU_BAR]
		wxMenuBar* m_menubar;
[!endif]
	
	public:
		MainFrame( wxWindow* parent, int id = -1, wxString title = wxT("[!output PROJECT_NAME]"), wxPoint pos = wxDefaultPosition, wxSize size = wxDefaultSize, int style = wxDEFAULT_FRAME_STYLE );
};

/**
 * Class MainPanel
 */
class MainPanel : public wxPanel
{
	private:
	
	protected:
		wxButton* m_OK;
	
	public:
		MainPanel( wxWindow* parent, int id = -1, wxPoint pos = wxDefaultPosition, wxSize size = wxSize( 500,300 ), int style = 0 );
};

[!if WX_ABOUT_DIALOG]
/**
 * Class AboutDlg
 */
class AboutDlg : public wxDialog
{
	private:
	
	protected:
		wxStaticBitmap* m_icon;
		wxStaticText* m_staticAppName;
		wxStaticText* m_staticVersion;
		wxStaticLine* m_staticline1;
		wxStaticText* m_staticCopyright;
		wxStdDialogButtonSizer* m_aboutDialogButtonSizer;
	
	public:
		AboutDlg( wxWindow* parent, int id = -1, wxString title = wxT("About [!output PROJECT_NAME]..."), wxPoint pos = wxDefaultPosition, wxSize size = wxDefaultSize, int style = wxDEFAULT_DIALOG_STYLE );
};
[!endif]

#endif //__[!output SAFE_PROJECT_NAME]_GUI__
