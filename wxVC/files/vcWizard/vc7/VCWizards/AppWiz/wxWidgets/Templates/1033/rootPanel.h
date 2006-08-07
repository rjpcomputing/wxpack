#ifndef [!output UPPERCASE_SAFE_PROJECT_NAME]PANEL_H
#define [!output UPPERCASE_SAFE_PROJECT_NAME]PANEL_H

#include "[!output SAFE_PROJECT_NAME]_GUI.h"

class [!output SAFE_PROJECT_NAME]Panel : public MainPanel
{
public:
	[!output SAFE_PROJECT_NAME]Panel( wxWindow* parent, int id = -1, wxPoint pos = wxDefaultPosition, wxSize size = wxSize(500,300), int style = 0 );
	~[!output SAFE_PROJECT_NAME]Panel();

private:
	void OnOK( wxCommandEvent& event );
	DECLARE_EVENT_TABLE();
};

#endif //[!output UPPERCASE_SAFE_PROJECT_NAME]PANEL_H