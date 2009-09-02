#ifndef [!output UPPERCASE_SAFE_PROJECT_NAME]FRAME_H
#define [!output UPPERCASE_SAFE_PROJECT_NAME]FRAME_H

[!if WX_USE_FORMBUILDER]
#include "[!output SAFE_PROJECT_NAME]_GUI.h"

class [!output SAFE_PROJECT_NAME]Frame : public MainFrame
{
public:
	[!output SAFE_PROJECT_NAME]Frame( wxWindow *parent = NULL, int id = -1 );
	~[!output SAFE_PROJECT_NAME]Frame();
[!if WX_MENU_BAR]
private:
	void OnExit( wxCommandEvent& event );
	void OnAbout( wxCommandEvent& event );
	DECLARE_EVENT_TABLE();
[!endif]
};
[!else]
#include "[!output PROJECT_NAME].h"

class [!output SAFE_PROJECT_NAME]Frame : public wxFrame
{
public:
	static const int ID_FILE_EXIT;
	static const int ID_HELP_ABOUT;

	[!output SAFE_PROJECT_NAME]Frame( wxFrame *frame, const wxString& title );
	~[!output SAFE_PROJECT_NAME]Frame();
private:
	void OnExit( wxCommandEvent& event );
	void OnAbout( wxCommandEvent& event );
	DECLARE_EVENT_TABLE();
};
[!endif]
#endif // [!output UPPERCASE_SAFE_PROJECT_NAME]FRAME_H
